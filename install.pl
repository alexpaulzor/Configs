#! /usr/bin/env perl

# install.pl
# script to create symlinks from the checkout of davesdots to the home directory

use strict;
use warnings;

use File::Path qw(mkpath rmtree);
use File::Glob ':glob';
use Cwd 'cwd';

my $scriptdir = cwd() . '/' . $0;
$scriptdir    =~ s{/ [^/]+ $}{}x;

my $home = bsd_glob('~', GLOB_TILDE);

if(grep /^(?:-h|--help|-\?)$/, @ARGV) {
	print <<EOH;
install.pl: installs symbolic links from dotfile repo into your home directory

Options:
	-f          force an overwrite existing files
	-h, -?      print this help

Destination directory is "$home".
Source files are in "$scriptdir".
EOH
	exit;
}

my $force = 0;
$force = 1 if grep /^(?:-f|--force)$/, @ARGV;

unless(eval {symlink('', ''); 1;}) {
	die "Your symbolic links are not very link-like.\n";
}

my %links = (
	'bin/gopro_rename.rb' => 'bin/gopro_rename.rb',
	'bin/findbig' => 'bin/findbig',
	'bin/findpac.py' => 'bin/findpac.py',
	'bin/junipernc' => 'bin/junipernc',
	'bin/git-info' => 'bin/git-info',
	'bin/ipmicmd' => 'bin/ipmicmd',
	'bin/nmgui' => 'bin/nmgui',
	'bin/stats.rb' => 'bin/stats.rb',
	'bin/svnup' => 'bin/svnup',
	'bin/reptyr' => 'bin/reptyr',
	'bin/autodisper' => 'bin/autodisper',
	'bin/inxi' => 'bin/inxi',
	'bin/gopro_rename.rb' => 'bin/gopro_rename.rb',
	'bash' => '.bash',
	'bash_profile' => '.bash_profile',
	'bashrc' => '.bashrc',
	'commonsh' => '.commonsh',
	'compiz.Default.ini' => '.config/compiz/compizconfig/Default.ini',
	'dir_colors' => '.dir_colors',
	'gitconfig' => '.gitconfig',
	'gitignore' => '.gitignore',
	'gpg-agent.conf' => '.gnupg/gpg-agent.conf',
	'inputrc' => '.inputrc',
	'irbrc' => '.irbrc',
	'lessfilter' => '.lessfilter',
	'mkshrc' => '.mkshrc',
	'screenrc' => '.screenrc',
	'shinit' => '.shinit',
	'sshconfig' => ".ssh/config",
	'terminator.config' => '.config/terminator/config',
	'vim' => '.vim',
	'vimrc' => '.vimrc',
	'Xdefaults' => '.Xdefaults',
	'xinitrc' => '.xinitrc',
	'xmobarrc' => '.xmobarrc',
	'xmonad.hs' => '.xmonad/xmonad.hs',
	'Xresources' => '.Xresources',
	'xbindkeysrc' => '.xbindkeysrc',
	'xmodmaprc' => '.xmodmaprc',
	'xscreensaver' => '.xscreensaver',
	'zsh' => '.zsh',
	'zshrc' => '.zshrc'
);

my $hostname = `hostname`;
chomp($hostname);
if ( -d "$scriptdir/machines/$hostname" ) {
	$links{"machines/$hostname"} = ".$hostname";
}

my $contained = (substr $scriptdir, 0, length($home)) eq $home;
my $prefix = undef;
if ($contained) {
	$prefix = substr $scriptdir, length($home);
	($prefix) = $prefix =~ m{^\/? (.+) [^/]+ $}x;
}

my $i = 0; # Keep track of how many links we added
for my $file (keys %links) {
	# See if this file resides in a directory, and create it if needed.
	my($path) = $links{$file} =~ m{^ (.+/)? [^/]+ $}x;
	mkpath("$home/$path") if $path;

	my $src  = "$scriptdir/$file";
	my $dest = "$home/$links{$file}";

	# If a link already exists, see if it points to this file. If so, skip it.
	# This prevents extra warnings caused by previous runs of install.pl.
	if(!$force && -e $dest && -l $dest) {
		next if readlink($dest) eq $src;
	}

	# Remove the destination if it exists and we were told to force an overwrite
	if($force && -d $dest) {
		rmtree($dest) || warn "Couldn't rmtree '$dest': $!\n";
	} elsif($force) {
		unlink($dest) || warn "Couldn't unlink '$dest': $!\n";
	}

	if ($contained) {
		chdir $home;
		$dest = "$links{$file}";
		$src = "$prefix$file";
		if ($path) {
			$src = "../$src";
		}
	}

	symlink($src => $dest) ? $i++ : warn "Couldn't link '$src' to '$dest': $!\n";
}

print "$i link";
print 's' if $i != 1;
print " created\n";



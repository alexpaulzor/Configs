#! /usr/bin/env perl

# install.pl
# script to create symlinks from the checkout of davesdots to the home directory

use strict;
use warnings;

use File::Path 'mkpath';
use File::Glob ':glob';
use Cwd 'cwd';

my $scriptdir = cwd() . '/' . $0;
$scriptdir    =~ s{/ [^/]+ $}{}x;

my $home = bsd_glob('~', GLOB_TILDE);

if(grep /^(?:-h|--help|-\?)$/, @ARGV) {
	print <<EOH;
install.pl: installs symbollic links from dotfile repo into your home directory

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
	die "Your symbollic links are not very link-like.\n";
}

my %links = (
	screenrc   => '.screenrc',
	toprc      => '.toprc',
	lessfilter => '.lessfilter',

	vimrc    => '.vimrc',
	vim      => '.vim',
	zshrc    => '.zshrc',
	zsh      => '.zsh',

	Xdefaults  => '.Xdefaults',
	Xresources => '.Xresources',

	'uncrustify.cfg' => '.uncrustify.cfg',
	'indent.pro'     => '.indent.pro',

	xmobarrc    => '.xmobarrc',
	'xmonad.hs' => '.xmonad/xmonad.hs',
);

for my $file (keys %links) {
	my($path) = $links{$file} =~ m{^ (.+/)? [^/]+ $}x;
	mkpath($path) if $path;

	my $src  = "$scriptdir/$file";
	my $dest = "$home/$links{$file}";

	# Remove the destination if it exists and we were told to force
	if($force && -e $dest) {
		unlink($dest) || warn "Couldn't unlink '$dest': $!\n";
	}

	symlink($src => $dest) || warn "Couldn't link '$src' to '$dest': $!\n";
}
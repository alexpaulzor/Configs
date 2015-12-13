#!/usr/bin/env ruby

# USAGE: $0 [--dry-run] [files.MP4]
# Renames gopro video files so that they naturally sort by name.

# Works in subdirs too
# find . -name *.MP4 | sed -e 's/^/"/' -e 's/$/"/' | xargs gopro_rename.rb

ch0_regex = /(?<path>.*\/)?GOPR(?<id>[0-9]{4})\.MP4$/
sequel_regex = /(?<path>.*\/)?GP(?<chapter>[0-9]{2})(?<id>[0-9]{4})\.MP4$/
old_regex = /(?<path>.*\/)?GOPR(?<id>[0-9]{4})(?<chapter>[0-9]{2})\.MP4$/

if ARGV.first == "-n" || ARGV.first == "--dry-run"
  dry_run = "echo "
  ARGV.shift
end

ARGV.each do |f|
    ch0_result = f.match(ch0_regex)
    sequel_result = f.match(sequel_regex)
    old_result = f.match(old_regex)
    if ch0_result
        new_filename = "#{ch0_result["path"] || ""}GOPR#{ch0_result["id"]}-00.MP4"
        puts %x[#{dry_run}mv -v "#{f}" "#{new_filename}"]
    elsif sequel_result
        new_filename = "#{sequel_result["path"] || ""}GOPR#{sequel_result["id"]}-#{sequel_result["chapter"]}.MP4"
        puts %x[#{dry_run}mv -v "#{f}" "#{new_filename}"]
    elsif old_result
        new_filename = "#{old_result["path"] || ""}GOPR#{old_result["id"]}-#{old_result["chapter"]}.MP4"
        puts %x[#{dry_run}mv -v "#{f}" "#{new_filename}"]
    end

end

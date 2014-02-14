#!/usr/bin/env ruby

# USAGE: $0 [files.MP4]

ch0_regex = /(?<path>.*\/)?GOPR(?<id>[0-9]{4})\.MP4$/
sequel_regex = /(?<path>.*\/)?GP(?<chapter>[0-9]{2})(?<id>[0-9]{4})\.MP4$/

ARGV.each do |f|
    ch0_result = f.match(ch0_regex)
    sequel_result = f.match(sequel_regex)
    if ch0_result
        new_filename = "#{ch0_result["path"] || ""}GOPR#{ch0_result["id"]}00.MP4"
        puts %x[mv -v "#{f}" "#{new_filename}"]
    elsif sequel_result
        new_filename = "#{sequel_result["path"] || ""}GOPR#{sequel_result["id"]}#{sequel_result["chapter"]}.MP4"
        puts %x[mv -v "#{f}" "#{new_filename}"]
    end
end
        




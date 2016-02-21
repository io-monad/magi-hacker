#!/usr/bin/env ruby

File.open("SUMMARY.md", "w") do |summary|
    summary.puts "# 目次", ""

    Dir.glob("chapter-*").sort.each do |chapter|
        chapter_title = File.read("#{chapter}/.title").strip
        summary.puts "* #{chapter_title}"

        Dir.glob("#{chapter}/*.md").sort.each do |section|
            section_title = File.open(section) { |f| f.gets.chomp.sub(/^#+\s*\d+\s*-\s*/, "") }
            summary.puts "    * [#{section_title}](#{section})"
        end
    end
end

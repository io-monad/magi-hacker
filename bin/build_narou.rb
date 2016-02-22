#!/usr/bin/env ruby

require "fileutils"

OUT_DIR = "out/narou"

def narou_markup(original)
  # 《《強調》》 → |強《・》|調《・》
  original.gsub(/《《([^\n》]+)》》/) do
    $1.split(//).map { |s| "|#{s}《・》" }.join
  end
end

FileUtils.mkdir_p(OUT_DIR) unless Dir.exist?(OUT_DIR)

Dir.glob("chapter-*") do |chapter|
  chapter_outdir = "#{OUT_DIR}/#{chapter}"
  Dir.mkdir(chapter_outdir) unless Dir.exist?(chapter_outdir)
  Dir.glob("#{chapter}/*.md") do |section|
    section_outfile = "#{OUT_DIR}/#{section}"
    original = IO.read(section)
    modified = narou_markup(original)
    IO.write(section_outfile, modified)
  end
end

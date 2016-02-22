#!/usr/bin/env ruby

require "fileutils"
require "pathname"

ROOT_DIR = Pathname.new(File.expand_path(__FILE__)).join("..", "..")
OUT_DIR  = Pathname.new(ROOT_DIR).join("out", "narou")

def narou_markup(original)
  # 《《強調》》 → |強《・》|調《・》
  original.gsub(/《《([^\n》]+)》》/) do
    $1.split(//).map { |s| "|#{s}《・》" }.join
  end
end

def convert_file(orig_path, out_path)
  out_path.parent.mkpath
  original = orig_path.read
  modified = narou_markup(original)
  out_path.write(modified)
end

if ARGV.empty?
  Dir.chdir(ROOT_DIR) do
    Dir.glob("chapter-*/**/*.txt") do |file|
      convert_file(ROOT_DIR + file, OUT_DIR + file)
    end
  end
else
  ARGV.each do |path|
    orig_path = Pathname.new(ROOT_DIR).join(path)
    rel_path = orig_path.relative_path_from(ROOT_DIR)
    out_path = OUT_DIR + rel_path
    convert_file(orig_path, out_path)
  end
end

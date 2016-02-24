#!/usr/bin/env ruby -E UTF-8

require "pathname"

ROOT_DIR = Pathname.new(File.expand_path(__FILE__)).join("..", "..")
OUT_DIR  = Pathname.new(ROOT_DIR).join("out", "narou")

def narou_markup(original)
  # 《《強調》》 → |強《・》|調《・》
  original.gsub(/《《([^\n》]+)》》/) do
    $1.split(//).map { |s| "|#{s}《・》" }.join
  end
end

def lint_novel(text)
  line_no = 1
  errors = []
  text.each_line do |line|
    line.scan(%r{(\A[^#/ 　「『【\n])|([　 ]\n?\z)|(。」)}) do |lead, trail, fs|
      errors << "Line #{line_no}: No leading space" if lead
      errors << "Line #{line_no}: Extra tailing space" if trail
      errors << "Line #{line_no}: Extra full-stop in quote" if fs
    end
    line_no += 1
  end
  errors
end

def convert_file(orig_path, out_path)
  out_path.parent.mkpath
  original = IO.read(orig_path)
  errors = lint_novel(original)
  if errors.empty?
    modified = narou_markup(original)
    IO.write(out_path, modified)
  else
    warn "ERROR: #{orig_path.relative_path_from(ROOT_DIR)}"
    errors.each { |e| warn " * #{e}" }
  end
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

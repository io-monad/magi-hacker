require "rake/clean"

CLEAN << "out"

task :default => [:build]

desc "Build files"
task :build, [:paths] do |t, args|
  ruby "bin/build_narou.rb", *args.paths
end

gulp = require "gulp"
countStat = require "gulp-count-stat"
anno = require "./lib/annotations"

gulp.task "stat", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.stripAnnotations()
  .pipe countStat(words: false, showFile: false)

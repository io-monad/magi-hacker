gulp = require "gulp"
textlint = require "gulp-textlint"
anno = require "./lib/annotations"

gulp.task "lint", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.warnLongRuby()
  .pipe anno.stripAnnotations()
  .pipe textlint()

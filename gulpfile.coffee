gulp = require "gulp"
$ = do require "gulp-load-plugins"
rimraf = require "rimraf"
anno = require "./tasks/lib/annotations"

gulp.task "clean", (cb) ->
  rimraf "./out", cb

gulp.task "lint", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.warnLongRuby()
  .pipe anno.stripAnnotations()
  .pipe $.textlint()

gulp.task "build:narou", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.filterSiteSpecific("narou")
  .pipe anno.converToNarouEmphasis()
  .pipe anno.warnRemainingMetaTag()
  .pipe $.rename(prefix: "narou-")
  .pipe gulp.dest("./out/narou")

gulp.task "build:kakuyomu", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.filterSiteSpecific("kakuyomu")
  .pipe anno.warnRemainingMetaTag()
  .pipe $.rename(prefix: "kakuyomu-")
  .pipe gulp.dest("./out/kakuyomu")

gulp.task "build", ["build:narou", "build:kakuyomu"]

gulp.task "stat", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.stripAnnotations()
  .pipe $.countStat(words: false, showFile: false)

gulp.task "default", ["build", "stat"]

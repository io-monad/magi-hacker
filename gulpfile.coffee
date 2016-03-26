gulp = require "gulp"
$ = do require "gulp-load-plugins"
rimraf = require "rimraf"
anno = require "./tasks/lib/annotations"
glossary = require "./tasks/lib/glossary"

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

gulp.task "build:markdown", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.filterSiteSpecific("kakuyomu")
  .pipe anno.markupAnnotations()
  .pipe anno.convertToMarkdown()
  .pipe anno.warnRemainingMetaTag()
  .pipe $.rename(prefix: "md-", extname: ".md")
  .pipe gulp.dest("./out/markdown")

gulp.task "build", ["build:narou", "build:kakuyomu", "build:markdown"]

gulp.task "glossary", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.markupAnnotations()
  .pipe glossary("glossary.yml", "GLOSSARY.md")
  .pipe gulp.dest(".")

gulp.task "glossary:watch", ->
  gulp.watch ["glossary.yml"], ["glossary"]

gulp.task "stat", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.stripAnnotations()
  .pipe $.countStat(words: false, showFile: false)

gulp.task "default", ["build", "glossary", "stat"]

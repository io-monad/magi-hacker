gulp = require "gulp"
rename = require "gulp-rename"
anno = require "./lib/annotations"
summary = require "./lib/summary"

gulp.task "build", [
  "build:narou",
  "build:kakuyomu",
  "build:markdown",
  "build:summary"
]

gulp.task "build:narou", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.filterSiteSpecific("narou")
  .pipe anno.converToNarouEmphasis()
  .pipe anno.warnRemainingMetaTag()
  .pipe rename(prefix: "narou-")
  .pipe gulp.dest("./out/narou")

gulp.task "build:kakuyomu", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.filterSiteSpecific("kakuyomu")
  .pipe anno.warnRemainingMetaTag()
  .pipe rename(prefix: "kakuyomu-")
  .pipe gulp.dest("./out/kakuyomu")

gulp.task "build:markdown", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.addAnchorsToParagraphs()
  .pipe anno.filterSiteSpecific("kakuyomu")
  .pipe anno.markupAnnotations()
  .pipe anno.convertToMarkdown()
  .pipe anno.warnRemainingMetaTag()
  .pipe rename(extname: ".md")
  .pipe gulp.dest("./out/markdown")

gulp.task "build:summary", ->
  gulp.src "./chapter-*/**/*.{txt,md}"
  .pipe summary("SUMMARY.md")
  .pipe gulp.dest(".")

gulp = require "gulp"
anno = require "./lib/annotations"
glossary = require "./lib/glossary"

gulp.task "glossary", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe anno.markupAnnotations()
  .pipe glossary("glossary.yml", "GLOSSARY.md")
  .pipe gulp.dest(".")

gulp.task "glossary:watch", ->
  gulp.watch ["glossary.yml"], ["glossary"]

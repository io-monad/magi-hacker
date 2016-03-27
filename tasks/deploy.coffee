_ = require "lodash"
gulp = require "gulp"
bowerFiles = require "main-bower-files"
pagify = require "./lib/pagify"

gulp.task "deploy", [
  "deploy:pages"
  "deploy:covers"
  "deploy:images"
  "deploy:assets"
  "deploy:bower"
]

gulp.task "deploy:pages", ["build:summary", "glossary"], ->
  gulp.src [
    "./chapter-*/*.txt"
    "./chapter-*/*.md"
    "./tasks/gh-pages/*.md"
    "./SUMMARY.md"
    "./GLOSSARY.md"
  ]
  .pipe pagify()
  .pipe gulp.dest("./out/gh-pages")

gulp.task "deploy:covers", ->
  gulp.src ["./chapter-*/cover.png"]
  .pipe gulp.dest("./out/gh-pages")

gulp.task "deploy:images", ->
  gulp.src ["./images/*.png"]
  .pipe gulp.dest("./out/gh-pages/images")

gulp.task "deploy:assets", ->
  gulp.src ["./tasks/gh-pages/assets/**/*"]
  .pipe gulp.dest("./out/gh-pages/assets")

gulp.task "deploy:bower", ->
  gulp.src bowerFiles()
  .pipe gulp.dest("./out/gh-pages/bower")

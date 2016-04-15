_ = require "lodash"
gulp = require "gulp"
sequence = require "gulp-sequence"
rimraf = require "rimraf"
bowerFiles = require "main-bower-files"
pagify = require "./lib/pagify"
emojify = require "./lib/emojify"

outDir = "./out/gh-pages/magi-hacker"

gulp.task "gh-pages", sequence(
  "gh-pages:clean", [
    "gh-pages:pages"
    "gh-pages:covers"
    "gh-pages:images"
    "gh-pages:assets"
    "gh-pages:bower"
    "gh-pages:emoji"
  ]
)

gulp.task "gh-pages:clean", (cb) ->
  rimraf outDir, cb

gulp.task "gh-pages:pages", ["build:summary", "glossary"], ->
  gulp.src [
    "./chapter-*/*.txt"
    "./chapter-*/*.md"
    "./tasks/gh-pages/*.md"
    "./SUMMARY.md"
    "./GLOSSARY.md"
  ]
  .pipe emojify()
  .pipe pagify()
  .pipe gulp.dest(outDir)

gulp.task "gh-pages:covers", ->
  gulp.src ["./chapter-*/cover.png"]
  .pipe gulp.dest(outDir)

gulp.task "gh-pages:images", ->
  gulp.src ["./images/*.png"]
  .pipe gulp.dest("#{outDir}/images")

gulp.task "gh-pages:assets", ->
  gulp.src ["./tasks/gh-pages/assets/**/*"]
  .pipe gulp.dest("#{outDir}/assets")

gulp.task "gh-pages:bower", ->
  gulp.src bowerFiles()
  .pipe gulp.dest("#{outDir}/bower")

gulp.task "gh-pages:emoji", ->
  gulp.src ["./node_modules/emoji-images/pngs/*.png"]
  .pipe gulp.dest("#{outDir}/emoji")

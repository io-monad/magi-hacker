_ = require "lodash"
gulp = require "gulp"
sequence = require "gulp-sequence"
ghPages = require "gulp-gh-pages"
rimraf = require "rimraf"
bowerFiles = require "main-bower-files"
pagify = require "./lib/pagify"
emojify = require "./lib/emojify"

outDir = "./out/gh-pages/magi-hacker"

gulp.task "deploy", sequence(
  "deploy:build",
  "deploy:publish"
)

gulp.task "deploy:publish", ->
  options = {}
  if process.env.GH_TOKEN
    options["remoteUrl"] = "https://#{process.env.GH_TOKEN}@github.com/io-monad/magi-hacker.git"

  gulp.src("#{outDir}/**/*")
  .pipe ghPages(options)

gulp.task "deploy:build", sequence(
  "deploy:clean", [
    "deploy:pages"
    "deploy:covers"
    "deploy:images"
    "deploy:assets"
    "deploy:bower"
    "deploy:emoji"
  ]
)

gulp.task "deploy:clean", (cb) ->
  rimraf outDir, cb

gulp.task "deploy:pages", ["build:summary", "glossary"], ->
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

gulp.task "deploy:covers", ->
  gulp.src ["./chapter-*/cover.png"]
  .pipe gulp.dest(outDir)

gulp.task "deploy:images", ->
  gulp.src ["./images/*.png"]
  .pipe gulp.dest("#{outDir}/images")

gulp.task "deploy:assets", ->
  gulp.src ["./tasks/gh-pages/assets/**/*"]
  .pipe gulp.dest("#{outDir}/assets")

gulp.task "deploy:bower", ->
  gulp.src bowerFiles()
  .pipe gulp.dest("#{outDir}/bower")

gulp.task "deploy:emoji", ->
  gulp.src ["./node_modules/emoji-images/pngs/*.png"]
  .pipe gulp.dest("#{outDir}/emoji")

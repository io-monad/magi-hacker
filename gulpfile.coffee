gulp = require "gulp"
$ = do require "gulp-load-plugins"
rimraf = require "rimraf"

kakuyomuToNarou = () ->
  $.replace /《《([^\n》]+)》》/g,
    (m, text) -> text.split("").map((s) -> "|#{s}《・》").join("")

gulp.task "clean", (cb) ->
  rimraf "./out", cb

gulp.task "lint", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe $.textlint()

gulp.task "build", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe kakuyomuToNarou()
  .pipe gulp.dest("./out/narou")

gulp.task "default", ["build"]

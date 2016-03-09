gulp = require "gulp"
$ = do require "gulp-load-plugins"
rimraf = require "rimraf"

kakuyomuToNarou = () ->
  $.replace /《《([^\n》]+)》》/g,
    (m, text) -> text.split("").map((s) -> "|#{s}《・》").join("")

warnLongRuby = () ->
  $.scan term: /[|｜]([^\n《|｜]+)《([^\n》]+)》/g, fn: (match) ->
    if not /^[|｜]([^\n《|｜]{1,10})《([^\n》]{1,20})》$/.test(match)
      throw "Too long ruby found: #{match}"

gulp.task "clean", (cb) ->
  rimraf "./out", cb

gulp.task "lint", ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe warnLongRuby()
  .pipe $.textlint()

gulp.task "build", ["lint"], ->
  gulp.src "./chapter-*/**/*.txt"
  .pipe kakuyomuToNarou()
  .pipe gulp.dest("./out/narou")

gulp.task "default", ["build"]

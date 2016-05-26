_ = require "lodash"
gulp = require "gulp"
gulpIf = require "gulp-if"
webserver = require "gulp-webserver"
through = require "through2"
yargs = require "yargs"
latest = require "./lib/latest"
novelous = require "./lib/novelous"

argv = yargs.argv

gulp.task "publish:html", ["build"], ->
  gulp.src "./out/{narou,kakuyomu}/**/*.txt"
  .pipe setSite()
  .pipe gulpIf(forSite("narou"), latest())
  .pipe gulpIf(forSite("kakuyomu"), latest())
  .pipe novelous.publish(
    outFile: "publish.html"
    extensionId: "mikejgecmcephkolbcfmlomnnlihhfch"
    sites:
      narou:
        novelId: "815110"
      kakuyomu:
        novelId: "4852201425154996024"
    time: nearestDateAtHour(18).toISOString() unless argv.now
  )
  .pipe gulp.dest "./out/publish"

gulp.task "publish", ["publish:html"], (done) ->
  server = gulp.src "./out/publish"
  .pipe webserver(
    open: "/publish.html"
    middleware: (req, res, next) ->
      res.on "finish", ->
        server.emit("kill")
        done()
        process.exit(0)
      next()
  )
  null

setSite = () ->
  through.obj (file, enc, done) ->
    file.site = file.relative.match(/^\w+/)[0]
    done(null, file)

forSite = (site) ->
  (file) -> file.site == site

nearestDateAtHour = (hour) ->
  date = new Date()
  date.setDate(date.getDate() + 1) if date.getHours() >= hour
  date.setHours(hour)
  date.setMinutes(0)
  date.setSeconds(0)
  date.setMilliseconds(0)
  date

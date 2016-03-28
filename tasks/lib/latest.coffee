through = require "through2"

module.exports = () ->
  latest = null

  eachFile = (file, enc, done) ->
    return done() if file.isNull() or file.isStream()

    if not latest or latest.relative < file.relative
      latest = file

    done()

  finalize = (done) ->
    this.push latest if latest
    done()

  through.obj eachFile, finalize

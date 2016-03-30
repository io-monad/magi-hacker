_ = require "lodash"
through = require "through2"
emoji = require "emoji-images"

module.exports = (options) ->
  options = _.extend({
    path: "/magi-hacker/emoji"
    size: null
  }, options)

  through.obj (file, enc, done) ->
    return done(null, file) if file.isNull() or file.isStream()

    content = file.contents.toString()
    file.contents = new Buffer(emoji(content, options.path, options.size))

    done(null, file)

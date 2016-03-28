_ = require "lodash"
fs = require "fs"
gutil = require "gulp-util"
through = require "through2"

PublishTemplateFile = "#{__dirname}/../templates/publish.tpl.html"

module.exports =

  publish: (options) ->
    options = _.defaults(options, {
      extensionId: null
      outFile: "publish.html"
      sites: {}
      time: null
    })

    unless options.extensionId
      return done(new gutil.PluginError("novelous", "Require extensionId"))

    publishTemplate = _.template fs.readFileSync(PublishTemplateFile).toString()
    pubs = []

    eachFile = (file, enc, done) ->
      return done() if file.isNull() or file.isStream()

      content = file.contents.toString()
      lines = content.split("\n")
      title = lines.shift().replace(/^#\s*|\s*$/g, "")
      body = _.trim(lines.join("\n"))

      pubs.push {
        title
        body
        sites: _.pick(options.sites, [file.site])
        time: options.time
      }

      done()

    finalize = (done) ->
      if pubs.length > 0
        message = {
          type: "PUBLISH_NOVEL"
          pubs: pubs
          close: true
        }

        page = publishTemplate({
          extensionId: options.extensionId
          message
        })
        this.push new gutil.File
          path: options.outFile,
          contents: new Buffer(page)

      done()

    through.obj eachFile, finalize

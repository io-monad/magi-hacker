_ = require "lodash"
fs = require "fs"
path = require "path"
gutil = require "gulp-util"
through = require "through2"

SummaryTemplateFile = "#{__dirname}/../templates/summary.tpl.md"
ChapterTemplateFile = "#{__dirname}/../templates/chapter.tpl.md"

module.exports = (outFile) ->
  outFile ||= "SUMMARY.md"
  summaryTemplate = _.template fs.readFileSync(SummaryTemplateFile).toString()
  chapterTemplate = _.template fs.readFileSync(ChapterTemplateFile).toString()
  pages = {}

  eachFile = (file, enc, done) ->
    return done() if file.isNull() or file.isStream()

    content = file.contents.toString()
    title   = content.split("\n", 2)[0].replace(/^#\s*|\s*$/g, "")

    if m = file.relative.match(/chapter-(\d+)\/README\.md$/)
      cover = if content.indexOf("cover.png") >= 0
        file.relative.replace("README.md", "cover.png")

      _.extend (pages[m[1]] ||= {}), {
        file:  file.relative
        title: title
        link:  "[#{title}](#{file.relative})"
        cover: if cover then "![](#{cover})" else null
      }

      _.set pages, [m[1], "file"], file.relative
      _.set pages, [m[1], "link"], "[#{title}](#{file.relative})"
    else if m = file.relative.match(/chapter-(\d+)\/(\d+|cb\d+)\.txt$/)
      _.set pages, [m[1], "pages", m[2], "file"], file.relative
      _.set pages, [m[1], "pages", m[2], "link"], "[#{title}](#{file.relative})"
    else
      return done(new gutil.PluginError("summary", "Unknown file: #{file.relative}"))

    done()

  finalize = (done) ->
    _.each(pages, (o) -> o.pages = _.sortBy(o.pages, "file"))
    pages = _.sortBy(pages, "file")

    summary = summaryTemplate(pages: pages)
    this.push new gutil.File
      path: outFile,
      contents: new Buffer(summary)

    _.each pages, (chapter) =>
      readme = chapterTemplate(chapter: chapter)
      this.push new gutil.File
        path: chapter.file
        contents: new Buffer(readme)

    done()

  through.obj eachFile, finalize

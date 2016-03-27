_ = require "lodash"
through = require "through2"
combine = require "stream-combiner"
markdown = require "gulp-markdown"
layout = require "gulp-layout"
gulpIf = require "gulp-if"
anno = require "./annotations"
renderer = require "./renderer"
h = require "./helpers"

module.exports = () ->
  combine [
    gulpIf(isNovelFile, pagifyNovel()),
    markdown(renderer: renderer),
    layout (file) ->
      pageClass: getClassNames(file)
      pageTitle: extractTitle(file)
      navigation: file.navigation
      layout: "./tasks/gh-pages/layout.jade"
  ]

pagifyNovel = () ->
  combine [
    anno.markupAnnotations(),
    decorateMarkdown(),
    setNavigationData(),
    anno.filterSiteSpecific("markdown")
    anno.warnRemainingMetaTag(),
  ]

decorateMarkdown = () ->
  through.obj (file, enc, done) ->
    return done(null, file) if file.isNull() or file.isStream()

    content = file.contents.toString()
    lines   = content.split("\n")
    title   = lines[0].replace(/^#\s*/, "")

    lines = lines.map (line, i) ->
      if h.isParagraph(line)
        isSticky = i + 1 < lines.length and not h.isBlankLine(lines[i + 1])
        stickyClass = if isSticky then " sticky" else ""
        lineAnchor = h.anchorTag("L#{i+1}")
        """<span class="paragraph#{stickyClass}">#{lineAnchor}#{line}</span>"""
      else if h.isRuleLine(line)
        "----"
      else
        line

    file.contents = new Buffer(lines.join("\n"))
    file.title = title
    done(null, file)

setNavigationData = () ->
  files = {}

  eachFile = (file, enc, done) ->
    files[file.relative] = file
    done()

  finalize = (done) ->
    keys = _.keys(files).sort()
    keys.forEach (key, i) =>
      files[key].navigation = {
        prev: getNav(files[keys[i - 1]]) if i >= 1
        next: getNav(files[keys[i + 1]]) if i < keys.length - 1
      }
      this.push(files[key])
    done()

  getNav = (file) ->
    { title: file.title, url: file.relative.replace(/\.txt|\.md/, ".html") }

  through.obj eachFile, finalize


isNovelFile = (file) ->
  /\.txt$/.test(file.path)

getClassNames = (file) ->
  classes = ["page-#{_.kebabCase(file.relative.replace(/\.[^\/]+$/, ""))}"]
  classes.push("page-novel") if /chapter-\d+\/(\d+|cb\d+)/.test(file.relative)
  classes.join(" ")

extractTitle = (file) ->
  content = file.contents.toString()
  if match = content.match(/<h1[^>]*>\s*(?:<[^>]+>\s*)*((?:.|\n)+?)\s*<\/h1>/)
    _.trim(match[1])
  else
    throw "No title in #{file.relative}"

_ = require "lodash"
marked = require "marked"
h = require "./helpers"

module.exports = renderer = new marked.Renderer()

HeaderTemplate = _.template("""
  <h<%- level %>>
    <%= h.anchorTag(anchor) %>
    <%= text %>
  </h<%- level %>>
""")

renderer.heading = (text, level) ->
  anchor = _.escape(_.kebabCase(text.replace(/<.*?>/g, "")))
  HeaderTemplate({text, level, anchor, h})

originalLink = renderer.link
renderer.link = (href, title, text) ->
  href = href.replace(/\.txt|\.md/, ".html")
  originalLink.call(this, href, title, text)

renderer.paragraph = (text) ->
  if /^<a name[^>]+><\/a>$/.test(text)
    "#{text}\n"
  else
    "<p>#{text}</p>\n"

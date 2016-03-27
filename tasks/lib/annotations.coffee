replace = require "gulp-replace"
scan = require "gulp-scan"
combine = require "stream-combiner"
through = require "through2"
h = require "./helpers"

module.exports =

  # Convert annotations to HTML
  markupAnnotations: () ->
    replace /// #{h.Emphasis} | #{h.RubyLoose} ///g, (m, em, rb, rt) ->
      if em
        em.split("").map((s) -> h.rubyTag(s, "・")).join("")
      else
        h.rubyTag(rb, rt)

  # Convert Kakuyomu-style emphasis to Narou-style using ruby
  # e.g. 《《あいう》》 -> |あ《・》|い《・》|う《・》
  converToNarouEmphasis: () ->
    replace /// #{h.Emphasis} ///g, (m, text) ->
      text.split("").map((s) -> "|#{s}《・》").join("")

  # Filter site specific text using meta tags (//#)
  # e.g. //# kakuyomu { ... //#} only remains for Kakuyomu
  filterSiteSpecific: (targetSite) ->
    replace h.SiteSpecificScope, (m, site, text) ->
      if site == targetSite then text else ""

  # Warn too long ruby not shown on Narou properly
  warnLongRuby: () ->
    scan term: h.RubyLoose, fn: (match, file) ->
      if not /// ^ #{h.RubyStrict} $ ///.test(match)
        throw "Too long ruby found in #{file.relative}: #{match}"

  # Warn if any meta tags remaining
  warnRemainingMetaTag: () ->
    scan term: /// #{h.MetaTagLine} ///mg, fn: (match, file) ->
      throw "Meta tag remaining in #{file.relative}: #{match}"

  # Strip any annotations such as emphasis, ruby and meta tags
  stripAnnotations: () ->
    replace /// #{h.Emphasis} | #{h.RubyLoose} | #{h.MetaTagLine} ///mg,
      (m, text1, text2) -> text1 or text2

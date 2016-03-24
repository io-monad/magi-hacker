replace = require "gulp-replace"
scan = require "gulp-scan"

Space         = "[ \\t]*"
MultilineText = "(?:.|\\n)*?"
MetaTagPrefix = "^//#" + Space

Emphasis      = "《《([^\\n》]+)》》"                            # 《《あいう》》
RubyLoose     = "[|｜]([^\\n《|｜]+)《([^\\n》]+)》"             #  |ルビ対象《ルビ本文》
RubyStrict    = "[|｜]([^\\n《|｜]{1,10})《([^\\n》]{1,20})》"   #  ルビ (文字数制限あり)
MetaTagLine   = "#{MetaTagPrefix}.*"                             #  //# ... (メタタグ)

# Site-specific text ($1 = Site name, $2 = Scoped text)
SiteSpecificScope = ///
  #{MetaTagPrefix} (\w+) #{Space} \{ #{Space} \n   # //# kakuyomu {
  (  #{MultilineText}  )                           #   ... Multi-line text ...
  #{MetaTagPrefix} \} #{Space} \n                  # //# }
///mg

module.exports =

  # Convert Kakuyomu-style emphasis to Narou-style using ruby
  # e.g. 《《あいう》》 -> |あ《・》|い《・》|う《・》
  converToNarouEmphasis: () ->
    replace ///#{Emphasis}///g,
      (m, text) -> text.split("").map((s) -> "|#{s}《・》").join("")

  # Filter site specific text using meta tags (//#)
  # e.g. //# kakuyomu { ... //#} only remains for Kakuyomu
  filterSiteSpecific: (targetSite) ->
    replace SiteSpecificScope,
      (m, site, text) -> if site == targetSite then text else ""

  # Warn too long ruby not shown on Narou properly
  warnLongRuby: () ->
    scan term: RubyLoose, fn: (match, file) ->
      if not ///^#{RubyStrict}$///.test(match)
        throw "Too long ruby found in #{file.relative}: #{match}"

  # Warn if any meta tags remaining
  warnRemainingMetaTag: () ->
    scan term: ///#{MetaTagLine}///mg, fn: (match, file) ->
      throw "Meta tag remaining in #{file.relative}: #{match}"

  # Strip any annotations such as emphasis, ruby and meta tags
  stripAnnotations: () ->
    replace /// #{Emphasis} | #{RubyLoose} | #{MetaTagLine} ///mg,
      (m, text1, text2) -> text1 or text2

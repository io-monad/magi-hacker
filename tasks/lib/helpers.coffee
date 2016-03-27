Space         = "[ \\t]*"
MultilineText = "(?:.|\\n)*?"
MetaTagPrefix = "^//#" + Space

Emphasis      = "《《([^\\n》]+)》》"                            # 《《あいう》》
RubyLoose     = "[|｜]([^\\n《|｜]+)《([^\\n》]+)》"             #  |ルビ対象《ルビ本文》
RubyStrict    = "[|｜]([^\\n《|｜]{1,10})《([^\\n》]{1,20})》"   #  ルビ (文字数制限あり)
MetaTagLine   = "#{MetaTagPrefix}.*"                             #  //# ... (メタタグ)
RuleLine      = "^//----#{Space}(?:<br>)?$"                      #  //---- (区切り)
Paragraph     = "^(?!#{Space}[!-/:-@≠\[-`{-~]| {4}|#{Space}$)"   #  段落

# Site-specific text ($1 = Site name, $2 = Scoped text)
SiteSpecificScope = ///
  #{MetaTagPrefix} (\w+) #{Space} \{ #{Space} \n   # //# kakuyomu {
  (  #{MultilineText}  )                           #   ... Multi-line text ...
  #{MetaTagPrefix} \} #{Space} \n                  # //# }
///mg

module.exports = {

  # Export Regexps
  Space, MultilineText, MetaTagPrefix,
  Emphasis, RubyLoose, RubyStrict, MetaTagLine,
  RuleLine, Paragraph, SiteSpecificScope,

  # Check if str is a paragraph
  isParagraph: (str) ->
    ///#{Paragraph}///.test(str)

  # Check is str is a rule line
  isRuleLine: (str) ->
    ///#{RuleLine}///.test(str)

  # Check is str is a blank line
  isBlankLine: (str) ->
    ///^#{Space}$///.test(str)

  # Ruby tag
  rubyTag: (rb, rt) ->
    "<ruby>#{rb}<rp> (</rp><rt>#{rt}</rt><rp>)</rp></ruby>"

  # Anchor tag
  anchorTag: (name) ->
    """<a name="#{name}" id="#{name}" class="anchor"></a>"""

}

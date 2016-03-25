_ = require "lodash"
fs = require "fs"
gulp = require "gulp"
gutil = require "gulp-util"
through = require "through2"
yaml = require "yamljs"
RegexTrie = require "regex-trie"
lineColumn = require "line-column"
matchAll = require("match-index").matchAll

Categories = {
  "あ行": /^[ぁ-おァ-オ]/,
  "か行": /^[か-ごカ-ゴヵヶ]/,
  "さ行": /^[さ-ぞサ-ゾ]/,
  "た行": /^[た-どタ-ド]/,
  "な行": /^[な-のナ-ノ]/,
  "は行": /^[は-ぽハ-ポヴ]/,
  "ま行": /^[ま-もマ-モ]/,
  "や行": /^[ゃ-よャ-ヨ]/,
  "ら行": /^[ら-ろラ-ロ]/,
  "わ行": /^[ゎ-んヮ-ン]/
}

TemplateFile = "#{__dirname}/../templates/glossary.tpl.md"

module.exports = (inputFile, outFile) ->
  glossary   = yaml.load(inputFile)
  template   = _.template fs.readFileSync(TemplateFile).toString()
  outFile  ||= "glossary.md"

  words      = _.map glossary, (content, title) -> splitYomi(title)[0]
  wordRegexp = new RegExp (new RegexTrie).add(words).toString(), "g"
  wordLink   = wordLinker(wordRegexp)

  collected  = {}

  eachFile = (file, enc, done) ->
    return done() if file.isNull() or file.isStream()

    content = file.contents.toString()
    lines   = content.split("\n")
    title   = lines[0].replace(/^#\s*/, "")

    matches = matchAll(content, wordRegexp)
    linecol = lineColumn(content)

    matches.forEach (match) ->
      {line, col} = linecol.fromIndex(match.index)
      (collected[match.all] ||= []).push
        file:  file.relative,
        index: match.index,
        text:  lines[line - 1].replace(/^[\s　]+|[\s　]+$/g, "")
        link:  "[#{title}](#{file.relative}#L#{line})"

    done()

  finalize = (done) ->
    firsts =
      _.mapValues collected, (places, word) ->
        _.first(_.sortBy(places, ["file", "index"]))

    definitions = {}
    _.each glossary, (content, title) ->
      [word, yomi] = splitYomi(title)
      category = yomiToCategory(yomi)
      (definitions[category] ||= []).push
        word: word,
        yomi: yomi,
        header: if word == yomi then word else ruby(word, yomi),
        anchor: if word == yomi then ""   else anchor(word),
        content: content.replace(/^\s+|\s+$/g, ""),
        first: firsts[word],
        link: "[#{word}](##{word})"

    toc = _.keys(definitions).sort().map (category) ->
      defs = _.sortBy(definitions[category], ["yomi", "word"])
      { category: category, definitions: defs }

    glossary = template
      toc: toc,
      wordLink: wordLink

    file = new gutil.File
      path: outFile,
      contents: new Buffer(glossary)

    this.push file
    done()

  through.obj eachFile, finalize

yomiToCategory = (yomi) ->
  category = _.findKey Categories, (re) -> re.test(yomi)
  throw "No category for #{yomi}" unless category
  category

splitYomi = (word) ->
  if matched = word.match(/^(.+?)\s*\((.+)\)/)
    [matched[1], matched[2]]
  else
    [word, word]

wordLinker = (regexp) ->
  (content) ->
    content.replace regexp, (word) -> "[#{word}](##{word})"

ruby = (body, text) ->
  "<ruby>#{body}<rp> (</rp><rt>#{text}</rt><rp>)</rp></ruby>"

anchor = (name) ->
  """<a name="#{name}"></a>"""

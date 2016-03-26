# マギハッカーの異世界ベンチャー起業術 [![Build Status](https://travis-ci.org/io-monad/magi-hacker.svg?branch=master)](https://travis-ci.org/io-monad/magi-hacker)

[![](./images/magi-hacker-cover.png)](https://kakuyomu.jp/works/4852201425154996024)

ハッカーと呼ばれる存在に憧れてプログラマとなり、天才ハッカーとまで呼ばれるようになった白石番兵は、過酷なデスマーチ中に力尽きる。次に目を覚ますとそこは、プログラミング言語で作られた魔法のような「マギサービス」が人々の生活を支えている異世界だった。

スマートフォンのようなマギデバイス、プログラミング言語のようなマギランゲージ。知れば知るほど魔法の仕組みに魅了されていく番兵は、次々と非常識な魔法を生み出し周囲を驚かせ、世界の謎を解き明かしていく。

マギサービスのベンチャー企業立ち上げを目論む女社長に巻き込まれ、最高技術責任者（CTO）として会社を経営に関わりながら、魔法の達人「マギハッカー」を目指して今日も魔法のコードを書きまくる！

## リンク
- [用語集](GLOSSARY.md)
- [小説家になろう内の小説ページ](http://ncode.syosetu.com/n5191dd/)
- [カクヨム内の小説ページ](https://kakuyomu.jp/works/4852201425154996024)
- [GitHub](https://github.com/io-monad/magi-hacker)

## 作者
入出もなど / IRIDE Monad

- ブログ: [もなでぃっく](http://io-monad.hatenablog.com/)
- メール: iride.monad@gmail.com
- Twitter: [@io_monad](https://twitter.com/io_monad)

## ビルド方法

このリポジトリ内の小説テキストは、「小説家になろう」「カクヨム」へ同時投稿のため、一つのファイルから複数のサイト向けに変換を行なっています。

また、文法等をチェックするために [textlint](http://textlint.github.io/) を利用しています。

### インストール

Node.js + npm がインストールされている必要があります。

下記をプロジェクトのルートディレクトリで実行すると、全ての依存モジュールおよびコマンド類がインストールされます。

```
npm install
```

### gulp タスク

ビルド作業は gulp により自動化されています。

| タスク | 説明 |
| ------ | ---- |
| `gulp` (引数なし) | 文法検証、ビルド、用語集更新、文字数表示を行います。 |
| `gulp build` | ビルド（複数サイト向けの変換）を行います。<br>変換後は `out/{サイト名}/` 内に保存されます。 |
| `gulp lint` | 文法の検証を行います。 |
| `gulp glossary` | [用語集](GLOSSARY.md)を [glossary.yml](glossary.yml) から更新します。 |
| `gulp stat` | 文字数の統計情報を表示します。 |

## 免責・謝辞

本リポジトリで公開されているテキストの文責は作者「入出もなど」にあります。

この物語はフィクションであり、実在の人物・集団とは一切の関係がありません。

特定の人物や集団を毀損する意図は一切含めておりませんが、内容に問題がある場合は作者までご連絡ください。可及的速やかに対応させて頂きます。

## 著作権について

本リポジトリで公開されているテキスト及び画像類の著作権は作者「入出もなど」に帰属します。

申し訳ございませんが小説という媒体の性質上、作者の無断での再配布・改変等はお断りさせて頂きます。

利用の必要がある場合は、作者までご連絡頂けるようお願いいたします。

## プルリクエスト等について

公開されているテキストその他への [Issue](https://github.com/io-monad/magi-hacker/issues) および [Pull Request](https://github.com/io-monad/magi-hacker/pulls) による誤字脱字の指摘、加筆、修正等を受け付けております。頂いた場合はなるべく受け入れてまいりますが、誤字などの明らかな不具合を除き、必ずしもご期待にそえるとは限らない事をあらかじめご了承ください。

また頂いた内容については、作者である「入出もなど」及びその委託者が、小説の公開先である「小説家になろう」「カクヨム」及びその他の媒体にて無期限・無制限にて利用する事を認めて頂く必要がございます。

頂いた内容につきまして新たな利用をする際にはなるべく通知いたしますが、作者がその責務を負うわけではないことを、あらかじめご了承ください。

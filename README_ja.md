# Leaves - Productivity tool for frontend engineers

Leavesは静的なサイトやシングルページアプリケーションを作るための開発ツールです。
NodeJS上で動いており、他との依存関係はありません。
[yeoman](http://yeoman.io/)と[Grunt](http://gruntjs.com/)を使って作られています。

## 機能一覧

* [Jade](http://jade-lang.com/)や[EJS](https://github.com/RandomEtc/ejs-locals)を用いたHTMLテンプレート
* [Stylus](http://learnboost.github.io/stylus/)や[less](http://lesscss.org/)を用いたCSSテンプレート
* [CoffeeScript](http://coffeescript.org/)のコンパイル
* プロジェクトの変更監視とブラウザの自動更新
* スクリプトとスタイルシートの自動インクルード
* ブラウザ画面上でのコンパイルエラー表示
* 1つのコマンドでHerokuとGitHubページにデプロイ
* その他: lorem-ipsumジェネレーター, シェル補完, 簡単アップグレード

## インストール

Leavesのインストールは、以下のコマンドで行えます。

```sh
$ npm install -g leaves
```

パーミッション関連のエラーが発生した場合は、`sudo`をコマンドの先頭に付加した上で実行して下さい。

## コマンド

### Setup

シェルの補完を有効にしたい場合は次のコマンドを実行してください。

```sh
$ leaves setup
```

現在はzshにのみ対応しておりますが、PRは大歓迎です。

### New

新規プロジェクトを作成する場合は次のコマンドを実行してください。

```sh
$ leaves new PROJECT_NAME [--html=ejs] [--css=less]
```

その後`PROJECT_NAME`に`cd`し、開発を始めましょう。

#### CSSエンジン

デフォルトのエンジンは[Stylus](http://learnboost.github.io/stylus/)です。
[less css](http://lesscss.org/)を使う場合は`leaves new`に`--css=less`を追加してください。

#### HTMLテンプレートエンジン

デフォルトのエンジンは[Jade](http://jade-lang.com/)です。
[EJS templates (with layouts)](https://github.com/RandomEtc/ejs-locals)を使う場合は`leaves new`コマンドを実行する際に、`--html=ejs`を追加してください。

### Build

各ファイルを一括でコンパイルする場合は、プロジェクトのディレクトリから次のコマンドを実行してください。

```sh
$ leaves build [--development]
```

コマンドの末尾に`--development`を追加すると開発モードになります。
この場合は、通常ビルド時に行われるファイルの軽量化と結合を行いません。

### Watch

プロジェクトを監視し、各ファイルの変更をブラウザ画面に自動で反映させたい場合はプロジェクトのディレクトリから次のコマンドを実行してください。

```sh
$ leaves [watch]
```

### Upgrade

Leavesをアップグレードする場合は次のコマンドを実行してください。

```sh
$ leaves upgrade
```

プロジェクトのディレクトリから、

```sh
$ leaves upgrade -o
```

を実行すると、`package.json`も一緒に更新されます。

### Publish

作ったサイトを[Heroku][heroku]か[GitHub Pages][github-pages]に公開することができます。

Herokuに公開する場合はHerokuのアカウントが必要です。
また、Githubで公開する場合は、Github上にリモートリポジトリを作成する必要があります。

```sh
$ leaves publish [--skip-build] [--skip-commit] [--skip-install] [--use-dev] [-p PROVIDER]
```

`PROVIDER`として`github`か`heroku`を指定することができます。デフォルトは`heroku`です。
ビルド時のファイル軽量化と結合を行わずに公開する場合は、`--use-dev`をつけてください。

Herokuの場合、http://APP_NAME.herokuapp.com というURLで公開されます。
Github Pagesの場合、http://USERNAME.github.io/REPO_NAME というURLで公開されます。

### Install

Leavesを使用して[bower][bower]や[npm][npm]を使用したライブラリのインストールが行えます。

```sh
$ leaves install [PACKAGES [-p PROVIDER] [--no-save]]
```

パッケージが指定されていない時は`npm install`と`bower install`が実行されます。

パッケージが指定されている場合は、`PROVIDER`を`bower`か`npm`にできます。デフォルトは`bower`です。

新しいパッケージはbowerとnpmの`--save`オプションを使って入れることができます。
`bower.json`に依存関係を書き込まないようにしたい場合は、`--no-save`をコマンドに付けてください。

### Get

プロジェクトのダウンロードと準備が行えます。

```sh
$ leaves get GIT_REPOSITORY [-p PROTOCOL]
```

`GIT_REPOSITORY`は`git clone`で使えるものは何でも指定できます。
また、Githubレポジトリの場合、`ユーザ名/レポジトリ名`のような文法も使えます。
その際は`PROTOCOL`として、`https`(デフォルト)か`ssh`を指定できます。

## その他の機能

### lorem ipsumジェネレーター

すべてのテンプレートで`lorem`関数が使えます。

```jade
= lorem(10)
```

でlorem ipsumのランダムな10単語が生成されます。
オプションについては[パッケージのドキュメンテーション][node-lorem-ipsum]をご覧ください。

### スクリプトとスタイルシートの自動インクルード

レイアウトで大量のスクリプトを読み込ませる手間を省くため、次のように書くことができます。

```jade
html
  head
    script(src="js/**/*.js" glob)
    link(rel="stylesheet" src="css/**/*.css" glob)
```

開発ビルドの場合は、上記のコードで次のようなHTMLが生成されます。

```html
<html>
<head>
  <script src="js/app.js">
  <script src="js/other.js">
  <script src="css/main.css">
  <script src="css/other.css">
</head>
<body>
</body>
</html>
```

プロダクションビルドで次のように生成されます。

```html
<html>
<head>
  <script src="js/application.min.js">
  <script src="css/application.min.css">
</head>
<body>
</body>
</html>
```

`application.min.js`と`application.min.css`は結合と圧縮がなされたファイルです。

ファイルは辞書順で結合されますが、別の順番で機能を使いたい場合は
以下の例を参考に、タグに`glob`をつけてHTML上で指定してください。


```jade
html
  head
    script(src="js/this-one-is-first.js" glob)
    script(src="js/**/*.js" glob)
    link(rel="stylesheet" href="css/**/*.css" glob)
```

この場合ではHTML上での順番が優先されます。
また、同じファイルは一度しかインクルードされません。
より詳しい使い方については、[ドキュメンテーション][node-glob-html]をご覧ください。


[generator-static-website]: https://github.com/claudetech/generator-static-website
[github-pages]: https://pages.github.com/
[heroku]: https://www.heroku.com/
[bower]: http://bower.io/
[npm]: https://www.npmjs.org/
[node-lorem-ipsum]: https://github.com/knicklabs/lorem-ipsum.js
[node-glob-html]: https://github.com/claudetech/node-glob-html

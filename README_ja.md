# leaves - Productivity tool for frontend engineers

leavesは静的サイトやシングルページアプリケーションを
作るための開発ツールです。NodeJSの上で動いており、
他の依存関係が一切ありません。
[yeoman](http://yeoman.io/)と[Grunt](http://gruntjs.com/)を使って
作られています。

## 機能一覧

* [Jade](http://jade-lang.com/)(デフォルト)か[EJS](https://github.com/RandomEtc/ejs-locals)を用いたHTMLテンプレート
* [Stylus](http://learnboost.github.io/stylus/)(デフォルト)か[less](http://lesscss.org/)を用いたCSSテンプレート
* [CoffeeScript](http://coffeescript.org/)のコンパイル
* プロジェクトの監視と自動更新
* スクリプトとスタイルシートの自動インクルード
* ブラウザでコンパイルエラー表示
* 1つのコマンドでHerokuとGitHubページにデプロイ
* その他: lorem-ipsumジェネレーター, シェル補完, 簡単アップグレード

## インストール

Leavesをインストールするために、次のコマンドを実行してください。
To install leaves, run

許可のエラーが発生したら、`sudo`で試して下さい。

## コマンド

### Setup

シェルの補完を有効にするために、次のコマンドを実行してください。

```sh
$ leaves setup
```

現在、zshのみ対応しているが、PRを歓迎しています。

### New

新規プロジェクトを作成するために、次のコマンドを実行してください。

```sh
$ leaves new PROJECT_NAME [--html=ejs] [--css=less]
```

その後`PROJECT_NAME`に`cd`してください。

#### CSSエンジン

デフォルトのエンジンは[Stylus](http://learnboost.github.io/stylus/)です。
[less css](http://lesscss.org/)を使う場合は`leaves new`に`--css=less`を追加してください。

#### HTMLテンプレートエンジン

デフォルトのエンジンは[Jade](http://jade-lang.com/)です。
[EJS templates (with layouts)](https://github.com/RandomEtc/ejs-locals)を使う場合は`leaves new`に``--html=ejs`を追加してください。

### Build

ビルドするために、プロジェクトのディレクトリから次のコマンドを実行してください。

```sh
$ leaves build [--development]
```

開発モードでビルドするために、`--development`を追加してください。

### Watch

プロジェクトを監視するために、プロジェクトのディレクトリから次のコマンドを実行してください。

```sh
$ leaves [watch]
```

### Upgrade

leavesをアップグレードするために、次のコマンドを実行してください。

```sh
$ leaves upgrade
```

プロジェクトのディレクトリから、

```sh
$ leaves upgrade -o
```

を実行すると、`package.json`も更新されます。

### Publish

[Heroku][heroku]か[GitHub Pages][github-pages]にウェブサイトが公開できます。

Herokuに公開するために、Herokuのアカウントが必要です。
Githubに公開するために、github.comを指しているgitのリモートが必要です。

```sh
$ leaves publish [--skip-build] [--skip-commit] [--skip-install] [--use-dev] [-p PROVIDER]
```

`PROVIDER`を`github`か`heroku`が使えます。デフォルトは`heroku`です。
開発モード（結合と圧縮なし）を公開するために、`--use-dev`をつけてください。

Herofuの場合、http://APP_NAME.herokuapp.com で公開されます。
Github Pagesの場合、http://USERNAME.github.io/REPO_NAME に公開されます。

### Install

Leavesを使って[bower][bower]と[npm][npm]でライブラリをインストールできます。

```sh
$ leaves install [PACKAGES [-p PROVIDER] [--no-save]]
```

パッケージが指定されていないない時は`npm install`と`bower install`が実行されます。

パッケージがある時は、`PROVIDER`を`bower`か`npm`にできます。デフォルトは`bower`です。

新しいパッケージはbowerとnpmの`--save`オプションを使って入ります。
その挙動を避けるために、`--no-save`を付けてください。

### Get

プロジェクトのダウンロードと準備が行えます。

```sh
$ leaves get GIT_REPOSITORY [-p PROTOCOL]
```

`GIT_REPOSITORY`は`git clone`で使えるものは何でも指定できます。
また、Githubレポジトリの場合、`ユーザ名/レポジトリ名`のような文法も使えます。
この文法を使う時、`PROTOCOL`として`https`(デフォルト)か`ssh`を指定できます。

## その他の機能

### lorem ipsumジェネレーター

すべてのテンプレートで`lorem`関数が使えます。

```jade
= lorem(10)
```

でlorem ipsumのランダムな10単語が生成されます。
オプションについては[パケージのドキュメンテーション][node-lorem-ipsum]をご覧くさい。

### スクリプトとスタイルシートの自動インクルード

レイアウトですべてのスクリプトを入れないように、次の文法を使うことができます。

```jade
html
  head
    script(src="js/**/*.js" glob)
    link(rel="stylesheet" src="css/**/*.css" glob)
```

以上の入力から、開発ビルドの場合は次の出力が生成されます。

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

プロダクションビルドで次の出力が生成されます。

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

`application.min.js`と`application.min.css`は結合と圧縮されたファイルです。

ファイルは辞書順で結合されますが、別の順番が使いたい場合は`glob`をつけて
HTMLで追加すれば良いです。


```jade
html
  head
    script(src="js/this-one-is-first.js" glob)
    script(src="js/**/*.js" glob)
    link(rel="stylesheet" href="css/**/*.css" glob)
```

以上のような場合では、HTMLでの順番が優先されます。
また、同じファイルは一度しかインクルードされません。
より詳しい使い方については、[ドキュメンテーション][node-glob-html]をご覧ください。


[generator-static-website]: https://github.com/claudetech/generator-static-website
[github-pages]: https://pages.github.com/
[heroku]: https://www.heroku.com/
[bower]: http://bower.io/
[npm]: https://www.npmjs.org/
[node-lorem-ipsum]: https://github.com/knicklabs/lorem-ipsum.js
[node-glob-html]: https://github.com/claudetech/node-glob-html

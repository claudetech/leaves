# Leaves - デザイナーの開発ツール

ドキュメンテーションは日本語・英語・フランス語でご覧になれます。

[http://oss.claudetech.com/leaves](http://oss.claudetech.com/leaves)

Leavesはフロントエンド開発を効率よくするためのツールです。
使い方が非常に簡単で、NodeJSのみに依存しています。
以下の機能が入っています。

* [Jade](http://jade-lang.com/)や[EJS](https://github.com/RandomEtc/ejs-locals)を用いたHTMLテンプレート
* [Stylus](http://learnboost.github.io/stylus/)や[Less](http://lesscss.org/)を用いたCSSテンプレート
* [CoffeeScript](http://coffeescript.org/)のコンパイル
* プロジェクトの変更監視とブラウザの自動更新
* スクリプトとスタイルシートの自動インクルード
* ブラウザ画面上でのコンパイルエラー表示
* 1つのコマンドでHeroku、GitHubページ、FTPにデプロイ
* 多言語化対応
* その他: lorem-ipsumジェネレーター, CDNの自動使用, シェル補完,簡単アップグレード, 開発者モード

## はじめに

### インストール

```sh
$ npm install -g leaves
$ leaves setup
```

### 開発を始める


```sh
$ leaves new project
$ cd project
$ leaves
```

他のフィーチャは、[ドキュメンテーション](http://oss.claudetech.com/leaves)をご覧ください。

## 修正や機能追加

バグ直しの場合は

* フォーク
* ブランチを作成
* バグ直し
* PRを送る

という流れでお願いします。

機能の追加については一度チケットを開くようにお願いします。

## ライセンス

プロジェクトはMITライセンスで提供されています。
より詳しくは[LICENSE](./LICENSE)をご覧ください。

# leaves - Productivity tool for frontend engineers

[Full documentation](http://claudetech.github.io/leaves)

There are a lot of tools around to create
static websites and single page applications.
leaves is meant to be as simple
as possible, and to use *only* NodeJS tools, with
no other external dependencies. It is built using
[yeoman](http://yeoman.io/) and [Grunt](http://gruntjs.com/).

## Main functionalities

* HTML templating via [Jade](http://jade-lang.com/) (default) or [EJS](https://github.com/RandomEtc/ejs-locals)
* CSS templating via [Stylus](http://learnboost.github.io/stylus/) (default) or [less](http://lesscss.org/)
* [CoffeeScript](http://coffeescript.org/) compilation
* Project watch and livereload
* Scripts and stylesheets globbing with `**/*.js` like syntax
* Compile error displayed in browser
* Single command deploy to Heroku and GitHub pages
* Misc: lorem-ipsum generator, `leaves` shell completion, project single command upgrade

## Installation

To install leaves, run

```sh
$ npm install -g leaves
```

If `npm install` fails, try to use `sudo`.

## Commands

### Setup

You can run the initial setup to have shell completion by running:

```sh
$ leaves setup
```

Only zsh is supported for now, but PR are welcome.

### New

To create a new project, just run:

```sh
$ leaves new PROJECT_NAME [--html=ejs] [--css=less]
```

you can then `cd` in `PROJECT_NAME`.

#### CSS engines

The default engine is [Stylus](http://learnboost.github.io/stylus/).
Add `--css=less` to use [less css](http://lesscss.org/)

#### HTML template engines

The default engine is [Jade](http://jade-lang.com/).
Add `--html=ejs` to use [EJS templates (with layouts)](https://github.com/RandomEtc/ejs-locals)

### Build

Just run

```sh
$ leaves build [--development]
```

in your project directory.
If you want a development build, without
concatenation and minification, pass the `development` flag.

### Watch

To build and watch your files, run

```sh
$ leaves [watch]
```

(which will run `leaves watch`) in your project directory.

### Upgrade

You can upgrade your leaves installation by running

```sh
$ leaves upgrade
```

This will run `npm update -g leaves` for you and use `sudo` only if needed.

In your working project, you can also run

```sh
$ leaves upgrade -o
```

to get the latest `Gruntfile.coffee` and update your `package.json`
dependencies. Your `Gruntfile.coffee` will be overwritten so be
careful when you use it if you have some changes.
This will also run `npm install` for you to install the latest
dependencies.

### Publish

You can publish your website to [Heroku][heroku] or to [GitHub Pages][github-pages].

To publish to Heroku, you only need to have a valid account.
To publish to Github, you need to have a remote pointing to github.com in your project.

```sh
$ leaves publish [--skip-build] [--skip-commit] [--skip-install] [--use-dev] [-p PROVIDER]
```

`PROVIDER` parameter can be `github` or `heroku`. The default is `heroku`.
If you want to use the development build to deploy, pass `--use-dev`.

Your website will then be accessible at http://APP_NAME.herokuapp.com when publishing with Heroku and http://USERNAME.github.io/REPO_NAME. with GitHub Pages.
For heroku, `APP_NAME` will default to the appName in `.leavesrc`.

### Install

Leaves can be used as a wrapper around [bower][bower] and [npm][npm].

```sh
$ leaves install [PACKAGES [-p PROVIDER] [--no-save]]
```

If no package is given, leaves will run `npm install` and `bower install`.

If packages are given, `PROVIDER` can be either `bower` or `npm`. If provider is not given, it will default to `bower`.

New packages are installed using `--save` by default. You can disable this
behavior by passing `--no-save`.

### Get

Fetch and prepare project for development.

```sh
$ leaves get GIT_REPOSITORY [-p PROTOCOL]
```

`GIT_REPOSITORY` can be anyting that would work with `git clone`,
or for GitHub repositories, the short syntax `user/repo` can be used.
`PROTOCOL` is only relevant when using the short syntax, and can be
`https` (default) or `ssh`.

## Other functionalities

### Easy lorem ipsum generation

The function `lorem` is available in all templates.
Just call

```jade
= lorem(10)
```

and you will get 10 words of lorem ipsum.
For other options, see the action [package documentation][node-lorem-ipsum]

### `script` and `link` globbing

To avoid having to insert all scripts in your layout,
you can use glob syntax.

```jade
html
  head
    script(glob="js/**/*.js")
    link(rel="stylesheet" glob="css/**/*.css")
```

will become

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

for development build and

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

for production build, where `js/application.min.js` and
`css/application.min.css` will be concatenated and
minified versions of the globbed files.

If alphabetical order does not fit your need, you can
use

```jade
html
  head
    script(src="js/this-one-is-first.js" group="application")
    script(glob="js/**/*.js")
    link(rel="stylesheet" glob="css/**/*.css")
```

The files will always be concatenated in order of appearance.
The default group is called `application`, but you can use any. All files
in the same group will be concatenated together and ignored from
globbing if already included.
Check out [the documentation][node-glob-html] for more details.

[generator-static-website]: https://github.com/claudetech/generator-static-website
[github-pages]: https://pages.github.com/
[heroku]: https://www.heroku.com/
[bower]: http://bower.io/
[npm]: https://www.npmjs.org/
[node-lorem-ipsum]: https://github.com/knicklabs/lorem-ipsum.js
[node-glob-html]: https://github.com/claudetech/node-glob-html

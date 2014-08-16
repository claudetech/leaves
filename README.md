# leaves - Simple tool for creating static websites

[Full documentation](http://claudetech.github.io/leaves)

There are a lot of tools around to generate, build
static websites. leaves is meant to be as simple
as possible, and to use *only* NodeJS tools, with
no external dependencies. It is built using
[yeoman](http://yeoman.io/) and [Grunt](http://gruntjs.com/).

Check out [the Yeoman generator][generator-static-website] documentation
for more information of what you can do in the created project.

## Main functionalities

* HTML templating via [Jade](http://jade-lang.com/) (default) or [EJS](https://github.com/RandomEtc/ejs-locals)
* CSS templating via [Stylus](http://learnboost.github.io/stylus/) (default) or [less](http://lesscss.org/)
* CoffeeScript compilation
* Project watch and livereload
* Compile error displayed in browser
* Single command deploy to GitHub pages
* Misc: `leaves` shell completion, project single command upgrade

## Installation

To install leaves, run

```
npm install -g leaves
```

If `npm install` fails, try to use `sudo`.

## Usage

### Setup

You can run the initial setup to have shell completion by running:

```
leaves setup
```

Only zsh is supported for now, but PR are welcome.

### New project

To create a new project, just run:

```
leaves new PROJECT_NAME [--html=ejs] [--css=less]
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

```
leaves build
```

in your project directory.

### Watch

To build and watch your files, run

```
leaves [watch]
```

(which will run `leaves watch`) in your project directory.

### Upgrade

You can upgrade your leaves installation by running

```
leaves upgrade 
```

This will run `npm update -g leaves` for you and use `sudo` only if needed.

In your working project, you can also run

```
leaves upgrade -o
```

to get the latest `Gruntfile.coffee` and update your `package.json`
dependencies. Your `Gruntfile.coffee` will be overwritten so be
careful when you use it if you have some changes.
This will also run `npm install` for you to install the latest
dependencies.

### Publish

You can publish your website to [GitHub Pages][github-pages].
You only need to have a remote pointing to github.com in your project.

```
leaves publish [--skip-build] [--skip-commit] [--skip-install]
```

Your website will then be accessible at http://USERNAME.github.io/REPO_NAME.


[generator-static-website]: https://github.com/claudetech/generator-static-website
[github-pages]: https://pages.github.com/

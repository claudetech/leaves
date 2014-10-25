[![Stories in Ready](https://badge.waffle.io/claudetech/leaves.png?label=ready&title=Ready)](https://waffle.io/claudetech/leaves)
# Leaves - Productivity tool for frontend engineers

The full documentation is available in English, French and Japanese at:

[http://oss.claudetech.com/leaves](http://oss.claudetech.com/leaves)

Leaves is a tool running on NodeJS to increase frontend development productivity.
It is extremely simple to use, requires *only* NodeJS, and contains all the
features commonly needed for frontend development.

* HTML templating via [Jade](http://jade-lang.com/) (default) or [EJS](https://github.com/RandomEtc/ejs-locals)
* CSS templating via [Stylus](http://learnboost.github.io/stylus/) (default) or [less](http://lesscss.org/)
* [CoffeeScript](http://coffeescript.org/) compilation
* Project watch and livereload
* Scripts and stylesheets globbing with `**/*.js` like syntax
* Compile error displayed in browser
* Internationalization
* Single command deploy to Heroku, GitHub pages and FTP servers
* Misc: lorem-ipsum generator, easy CDN usage, `leaves` shell completion, project single command upgrade, dev mode

## Getting started

### Installation

To install Leaves, just run

```sh
$ npm install -g leaves
$ leaves setup
```

### Start a new project

To create a new project with the default `jade`/`stylus` stack, run the following.

```sh
$ leaves new project
$ cd project
$ leaves
```


For more features, [read the docs](http://oss.claudetech.com/leaves).

## Contributing

Contributions are very welcome.

For bug fixes

* Fork
* Create your branch
* Fix the bug
* Send a pull request

For new features, or important changes, please open an issue first.

## License

Leaves is released under MIT license.
See [LICENSE](./LICENSE) for more info.

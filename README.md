# leaves - Easy project generation for designers

There are a lot of tools around to generate, build
static websites. leaves is meant to be as simple
as possible, and to use *only* NodeJS tools, with
no external dependencies. It is built using
[yeoman](http://yeoman.io/) and [Grunt](http://gruntjs.com/).

Check out [the Yeoman generator][generator-static-website] documentation
for more information of what you can do in the created project.

## Installation

To install leaves, run

```
npm install -g leaves
```

If `npm install` fails, try to use `sudo`.

## Usage

### New project

To create a new project, just run:

```
leaves new PROJECT_NAME
```

you can then `cd` in `PROJECT_NAME`.

### Build

Just run

```
leaves build
```

in your project directory.

### Develop

To build and watch your files, run

```
leaves
```

(which will run `leaves run`) in your project directory.

## Upgrade

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


[generator-static-website]: https://github.com/claudetech/generator-static-website

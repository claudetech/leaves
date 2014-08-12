# leaves - Easy project generation for designers

There are a lot of tools around to generate, build
static websites. leaves is meant to be as simple
as possible, and to use *only* NodeJS tools, with
no external dependencies. It is built using
[yeoman](http://yeoman.io/) and [Grunt](http://gruntjs.com/).

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

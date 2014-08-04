module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    watch:
      scripts:
        files: 'src/**/*.coffee'
        tasks: ['newer:coffee']

    coffee:
      lib:
        files: [
          expand: true
          cwd: 'src'
          src: ['**/*.coffee']
          dest: 'lib'
          ext: '.js'
        ]

  grunt.registerTask 'default', ['coffee', 'watch']

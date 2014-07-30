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
          cwd: 'src/app'
          src: ['**/*.coffee']
          dest: 'lib'
          ext: '.js'
        ]
      bin:
        files:
          'bin/leaves': 'src/bin/leaves.coffee'

  grunt.registerTask 'default', ['coffee', 'watch']

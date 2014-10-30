path = require("path")
module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      compile:
        expand: true
        cwd: "assets"
        src: [
          "routes/*.coffee"
          "javascripts/*.coffee"
        ]
        dest: "public/"
        ext: ".js"

    stylus:
      compile:
        options:
          paths: ["assets/stylesheets/"]
          compress: false
        files: [
          expand: true
          cwd: "assets/stylesheets"
          src: ["**/*.styl"]
          dest: "public/stylesheets"
          ext: ".css"
        ]
    
    watch:
      views:
        files: ['public/views/**/*.jade']
      coffee:
        files: [
          'assets/routes/**/*.coffee',
          'assets/javascripts/**/*.coffee'
        ]
        tasks: ['coffee']
      stylus:
        files: ['assets/stylesheets/**/*.styl'],
        tasks: ['stylus']
      options:
        livereload: true
        serverreload: true

    express:
      server:
        options:
          port: 3000
          hostname: "localhost"
          livereload: true
          bases: path.resolve("public")
          server: path.resolve("app.coffee")
          debug: true

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-express"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.registerTask "default", "Watches the project for changes, automatically builds them and runs a server.", [
    "express"
    "coffee"
    "stylus"
    "watch"
  ]
  return
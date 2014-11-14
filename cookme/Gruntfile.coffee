path = require("path")
module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      src:
        expand: true
        cwd: "app"
        src: [
          "routes/**/*.coffee"
          "controller/**/*.coffee"
          "config/*.coffee"
          "models/*.coffee"
        ]
        dest: "src/"
        ext: ".js"
      assets:
        expand: true
        cwd: "app/assets"
        src: [
          "javascripts/*.coffee"
        ]
        dest: "public/"
        ext: ".js"


    stylus:
      compile:
        options:
          paths: ["app/assets/stylesheets/"]
          compress: false
        files: [
          expand: true
          cwd: "app/assets/stylesheets"
          src: ["**/*.styl"]
          dest: "public/stylesheets"
          ext: ".css"
        ]
    
    watch:
      views:
        files: ['app/views/**/*.jade']
      coffee:
        files: [
          'app/routes/**/*.coffee',
          'app/assets/javascripts/**/*.coffee'
        ]
        tasks: ['coffee']
      stylus:
        files: ['app/assets/stylesheets/**/*.styl'],
        tasks: ['stylus']
      options:
        livereload: true
        serverreload: true

    clean: [
      'src/*'
      'public/stylesheets/*'
      'public/javascripts/*'
    ]

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
  grunt.loadNpmTasks "grunt-contrib-clean"

  grunt.registerTask "default",
  "Watches the project for changes, automatically builds them and runs a server.", [
    "clean"
    "coffee"
    "stylus"
    "express"
    "watch"
  ]
  return

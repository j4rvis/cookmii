path = require("path")
module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      assets:
        expand: true
        cwd: "app/assets"
        src: [
          "javascripts/**/*.coffee"
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
          src: ["styles.styl"]
          dest: "public/stylesheets"
          ext: ".css"
        ]

    watch:
      views:
        files: ['app/views/**/*.jade']
      coffee:
        files: ['app/**/*.coffee']
      coffee_assets:
        files: ['app/assets/javascripts/**/*.coffee']
        tasks: ['coffee']
      stylus:
        files: ['app/assets/stylesheets/**/*.styl']
        tasks: ['stylus']
      express:
        files: ['*']
        tasks: ['express:dev']
        options:
          spawn: false
      options:
        livereload: true
        serverreload: true

    clean: [
      'public/stylesheets/*'
      'public/javascripts/*'
    ]

    express:
      dev:
        options:
          script: "./bin/www"
          opts:  ["node_modules/coffee-script/bin/coffee"]

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-express-server"
  grunt.loadNpmTasks('grunt-contrib-copy')

  grunt.registerTask "default",
  "Watches the project for changes, automatically builds them and runs a server.", [
    "clean"
    "stylus"
    "coffee:assets"
    "express:dev"
    "watch"
  ]
  return

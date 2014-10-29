path = require("path")
module.exports = (grunt) ->

  # configure the tasks
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

    watch:
      files: [path.resolve(__dirname, "") + "/{,*/}*.*"]
      options:
        livereload: true

    express:
      server:
        options:
          port: 3000
          hostname: "localhost"
          livereload: true
          bases: "public"
          server: path.resolve("app.coffee")


  # load the tasks
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-express"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-stylus"

  # define the tasks
  grunt.registerTask "default", "Watches the project for changes, automatically builds them and runs a server.", [
    "coffee"
    "express"
    "watch"
  ]
  return
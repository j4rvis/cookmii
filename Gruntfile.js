var path = require("path");

module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON("package.json"),
    coffee: {
      compile: {
        expand: true,
        cwd: "assets",
        src: ["routes/*.coffee", "javascripts/*.coffee"],
        dest: "public/",
        ext: ".js"
      }
    },
    stylus: {
      compile: {
        options: {
          paths: ["assets"],
          compress: false
        },
        sources:{
          files: [{
            expand: true,
            cwd: "/assets",
            scr: ["/stylesheets/**/*.styl"],
            dest: "/assets",
            ext: ".css"
          }]
        }
      }
    },
    jade: {
      compile: {
        sources: {
          files: {
            cwd: "assets/",
            scr: ["views/**/*.jade"],
            dest: "public/",
            ext: ".html"
          }
        }
      }
    },
    watch: {
      files: [path.resolve(__dirname, "") + "/{,*/}*.*"],
      options: {
        livereload: true
      }
    },
    express: {
      server: {
        options: {
          port: 3000,
          hostname: "localhost",
          livereload: true,
          bases: path.resolve("public"),
          server: path.resolve("app.coffee"),
          debug: true
        }
      }
    }
  });
  grunt.loadNpmTasks("grunt-contrib-coffee");
  grunt.loadNpmTasks("grunt-contrib-watch");
  grunt.loadNpmTasks("grunt-express");
  grunt.loadNpmTasks("grunt-contrib-jade");
  grunt.loadNpmTasks("grunt-contrib-stylus");
  grunt.registerTask("default", "Watches the project for changes, automatically builds them and runs a server.",
    ["coffee", "express", "watch"]);
};


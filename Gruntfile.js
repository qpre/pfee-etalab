var LIVERELOAD_PORT = 35729;
var lrSnippet = require('connect-livereload')({port: LIVERELOAD_PORT});
var mountFolder = function (connect, dir) {
    return connect.static(require('path').resolve(dir));
};

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      plugin: {
        files: [{
          expand: true,
          cwd: 'plugin',
          src: ['**/*.coffee'],
          dest: 'plugin/build',
          rename: function(dest, src) {
            return dest + '/' + src.replace(/\.coffee$/, '.js');
          }
        }]
      },
      
      panel: {
        files: [{
          expand: true,
          cwd: 'panel',
          src: ['**/*.coffee'],
          dest: 'panel',
          rename: function(dest, src) {
            return dest + '/' + src.replace(/\.coffee$/, '.js');
          }
        }]
      }
    },
    
    copy: {
      plugin: {
        files: [
          // includes lib
          {expand: true, flatten: true, src: ['plugin/assets/style/*'], dest: 'plugin/build/assets/style/', filter: 'isFile'},
          {expand: true, flatten: true, src: ['plugin/assets/img/*'], dest: 'plugin/build/assets/img/', filter: 'isFile'},
          { expand: true, cwd: 'plugin/bower_components/', src: '**/*', dest: 'plugin/build/bower_components/', filter: 'isFile'},
          {expand: true, flatten: true, src: ['plugin/*.html'], dest: 'plugin/build/'},
        ]
      }
    },
    
    clean:{
      plugin: {
        src: ['plugin/build']
      },
      panel: {
        src: ['panel/src/panel.js']
      },
    },
    
    // this, is orgasmically neat
    watch: {
        bower:{
            files: ['plugin/bower_components/*'],
        },
        coffee: {
            files: ['plugin/scripts/**/*.coffee'],
            tasks: ['coffee:plugin']
        },
        css: {
            files: ['plugin/assets/style/**/*.css'],
        },
        img: {
            files: ['plugin/assets/img/**/*.{png,jpg,jpeg,gif}'],
        },
        livereload: {
            options: {
                livereload: LIVERELOAD_PORT
            },
            files: [
                'plugin/build/scripts/**/*'
            ]
        }
    },
    connect: {
        options: {
            port: 9000,
            hostname: 'localhost'
        },
        livereload: {
            options: {
                middleware: function (connect) {
                    return [
                        lrSnippet,
                        mountFolder(connect, 'plugin/build'),
                    ];
                }
            }
        }
    },
    open: {
        server: {
            path: 'http://localhost:<%= connect.options.port %>'
        }
    },
    
    
  });

  // Load plugins
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-open');
  grunt.loadNpmTasks('grunt-contrib-connect');

  // Tasks
  grunt.registerTask('plugin', ['clean:plugin','coffee:plugin', 'copy:plugin']);
  grunt.registerTask('panel', ['clean:panel','coffee:panel']);
  grunt.registerTask('server', function (target) {
      if (target === 'plugin') {
          return grunt.task.run(['plugin', 'open', 'connect:dist:keepalive']);
      }

      grunt.task.run([
        'plugin',
        'connect:livereload',
        'open',
        'watch'
      ]);
  });
  
  grunt.registerTask('default', ['plugin', 'panel']);
};
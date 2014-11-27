

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig(
    pkg: grunt.file.readJSON("package.json")
    cfg: grunt.file.readJSON("build_config.json")


    #
    # File Operations
    #

    clean:
      tmp: '<%= cfg.tmp_dir %>/'
      build: '<%= cfg.build_dir %>/'
      compile: '<%= cfg.compile_dir %>/'

    copy:
      js_src:
        files: [
          cwd: "src/app"
          src: "**/*.js"
          dest: '<%= cfg.tmp_dir %>'
          expand: true
        ]
      js_tmp:
        files: [
          cwd: "tmp"
          src: "**/*.js"
          dest: '<%= cfg.build_dir %>'
          expand: true
        ]
      assets:
        files: [
          cwd: "src"
          src: ['assets/**']
          dest: '<%= cfg.build_dir %>'
          expand: true
        ]
      vendor:
        files: [
          src: [
            '<%= cfg.vendor_js %>'
            '<%= cfg.vendor_css %>'
            '<%= cfg.vendor_other %>'
          ]
          dest: '<%= cfg.build_dir %>'
          expand: true
        ]
      assets_compile:
        files: [
          cwd: "src"
          src: ['assets/**']
          dest: '<%= cfg.compile_dir %>'
          expand: true
        ]
      deploy:
        files: [
          cwd: '<%= cfg.compile_dir %>'
          src: ['**']
          dest: '<%= cfg.deploy_dir %>'
          expand: true
        ]
    

    #
    #  HTML Processing
    #

    jade:
      options:
        client: false
        pretty: true
      templates:
        files: [{
          cwd: "src/app"
          src: ["**/*.jade", "!index.jade"]
          dest: '<%= cfg.tmp_dir %>'
          expand: true,
          ext: ".tpl.html"
        }]

      index_build:
        options:
          data: () ->
            css:        grunt.file.expand({cwd:'build'}, ['**/*.css'])
            js:         grunt.file.expand({cwd:'build'}, ['**/*.js'])
            vendor_css: grunt.config.get('cfg.vendor_css')
            vendor_js:  grunt.config.get('cfg.vendor_js')
            build:      true
        files: [{
          src: "src/app/index.jade"
          dest: '<%= cfg.build_dir %>/index.html'
        }]

      index_compile:
        options:
          data: () ->
            css:        ["assets/#{grunt.config.get('pkg.name')}.css"]
            js:         ["assets/#{grunt.config.get('pkg.name')}.js"]
            vendor_css: []
            vendor_js:  []
            build:      false
        files: [{
          src: "src/app/index.jade"
          dest: '<%= cfg.compile_dir %>/index.html'
        }]

    html2js:
      all:
        options:
          base:   'tmp'
          module: 'templates'
        src: 'tmp/**/*.tpl.html',
        dest: '<%= cfg.build_dir %>/templates.js'


    #
    #  JS Processing
    #

    jshint:
      src: ['src/app/**/*.js']
      test: ['src/app/**/*.spec.js']
      options:
        curly: true
        immed: true
        newcap: true
        noarg: true
        sub: true
        boss: true
        eqnull: true

    coffeelint:
      options:
        max_line_length:
          value: 90
      src: ['src/app/**/*.coffee']
      test: ['src/app/**/*.spec.coffee']
      gruntfile: ['gruntfile.coffee']

    coffee:
      options:
        bare: true
      app:
        cwd: "src/app"
        src: ['**/*.coffee', '!**/*.spec.coffee']
        dest: '<%= cfg.tmp_dir %>'
        expand: true
        ext: '.js'


    #
    #  CSS Processing
    #

    less:
      build:
        files:
          '<%= cfg.build_dir %>/assets/<%= pkg.name %>.css': 'src/**/*.less'
      compile:
        files:
          '<%= cfg.compile_dir %>/assets/<%= pkg.name %>.css': 'src/**/*.less'
        options:
          cleancss: true,
          compress: true


    #
    #  Testing
    #

    karma:
      options:
        configFile: 'karma.conf.js'
        files: [
          '<%= cfg.vendor_js %>'
          '<%= cfg.vendor_test %>'
          '<%= cfg.build_dir %>/**/*.js'
          'src/**/*.spec.js'
          'src/**/*.spec.coffee'
        ]
      build:
        options:
          singleRun: true
      monitor:
        options:
          background: true
          singleRun: false
      compile:
        options:
          singleRun: true
          files: [
            '<%= cfg.compile_dir%>/**/*.js'
            '<%= cfg.vendor_test %>'
            'src/**/*.spec.js'
            'src/**/*.spec.coffee'
          ]

    protractor:
      all:
        configFile: "e2e/e2e.conf.coffee"
        keepAlive: true
        noColor: false


    #
    #  Compiling
    #

    ngAnnotate:
      compile:
        files:
          '<%= cfg.compile_dir %>/assets/<%= pkg.name %>.js':
            ['<%= cfg.compile_dir %>/assets/<%= pkg.name %>.js']

    concat:
      css:
        src: [
          '<%= cfg.vendor_css %>'
          '<%= cfg.build_dir %>/assets/<%= pkg.name %>.css'
        ]
        dest: '<%= cfg.compile_dir %>/assets/<%= pkg.name %>.css'
      js:
        src: [
          '<%= cfg.vendor_js %>'
          '<%= cfg.build_dir %>/**/*.js'
          '!**/<%= cfg.build_dir %>/vendor/**/*.js'
        ]
        dest: '<%= cfg.compile_dir %>/assets/<%= pkg.name %>.js'

    uglify:
      compile:
        files:
          '<%= cfg.compile_dir %>/assets/<%= pkg.name %>.js':
            '<%= cfg.compile_dir %>/assets/<%= pkg.name %>.js'


    #
    # Monitor for changes
    #

    monitor: # Renamed from watch
      options:
        livereload: true

      jade_src:
        files: ['src/**/*.jade']
        tasks: ['build_html']

      coffee_src:
        files: ['src/**/*.coffee', '!src/**/*.spec.coffee']
        tasks: ['coffeelint', 'build_js', 'jade:index_build', 'karma:monitor:run']

      js_src:
        files: ['src/**/*.js', '!src/**/*.spec.js']
        tasks: ['jshint', 'build_js', 'jade:index_build', 'karma:monitor:run']

      assets:
        files: ['src/assets/**/*'],
        tasks: ['copy:assets']

      less:
        files: ['src/**/*.less'],
        tasks: ['build_css', 'jade:index_build']

      coffee_test:
        files: ['src/**/*.spec.coffee']
        tasks: ['karma:monitor:run'],
        options:
          livereload: false

      js_test:
        files: ['src/**/*.spec.js']
        tasks: ['karma:monitor:run'],
        options:
          livereload: false

  )

  grunt.registerTask('default', ['karma:continuous'])


  grunt.renameTask('watch', 'monitor')
  grunt.registerTask('watch', ['build', 'karma:monitor:start', 'monitor'])


  grunt.registerTask('lint',       ['jshint', 'coffeelint'])

  grunt.registerTask('build_js',   ['copy:js_src', 'coffee', 'copy:js_tmp'])
  grunt.registerTask('build_css',  ['less:build'])
  grunt.registerTask('build_html', ['jade:templates', 'html2js', 'jade:index_build'])

  grunt.registerTask('compile_js',   ['concat:js', 'ngAnnotate', 'uglify'])
  grunt.registerTask('compile_css',  ['less:compile', 'concat:css'])
  grunt.registerTask('compile_html', ['jade:index_compile'])


  grunt.registerTask('pure_build', [
    'lint', 'clean',
    'build_js', 'build_css', 'build_html',
    'copy:vendor', 'copy:assets'
  ])
  grunt.registerTask('build', ['pure_build', 'karma:build'])


  grunt.registerTask('pure_compile', [
    'compile_js', 'compile_css', 'compile_html',
    'copy:assets_compile'
  ])
  grunt.registerTask('compile', ['pure_compile', 'karma:compile'])

  grunt.registerTask('e2e', ['protractor'])

  grunt.registerTask('deploy', ['copy:deploy'])

  grunt.registerTask('publish', [
    'pure_build', 'karma:build',
    'pure_compile', 'karma:compile',
    'deploy'
  ])


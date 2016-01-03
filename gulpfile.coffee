gulp = require 'gulp'
gutil = require 'gulp-util'

sass = require 'gulp-sass'
browserSync = require 'browser-sync'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
clean = require 'gulp-clean'
filter = require 'gulp-filter'
rev = require 'gulp-rev'
minifyCss = require 'gulp-minify-css'
sequence = require 'run-sequence'
bower = require 'main-bower-files'
ngAnnotate = require 'gulp-ng-annotate'

sources =
  coffee: ['src/client.coffee', 'src/**/*.coffee']
  examples:
    public: 'example/public/*'
    coffee: 'example/**/*.coffee'
    html:   'example/**/*.jade'
    sass:   'example/**/*.scss'
    vendor: [
      'bower_components/jquery/dist/jquery.min.js'
      'bower_components/angular/angular.min.js'
      'bower_components/angular-animate/angular-animate.min.js'
      'bower_components/angular-messages/angular-messages.min.js'
      'bower_components/ngstorage/ngStorage.min.js'
      'bower_components/angular-aria/angular-aria.min.js'
      'bower_components/angular-material/angular-material.min.js'
      'bower_components/three.js/build/three.min.js'
      'bower_components/threex.keyboardstate/threex.keyboardstate.js'
    ]

destinations =
  dist: 'dist'
  css: 'dist/css'
  html: 'dist'
  js: 'dist/js'

isProd = gutil.env.env

# Compile app code
gulp.task 'src', ->
  gulp.src(sources.coffee)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(concat('client.js'))
    .pipe(if isProd then uglify() else gutil.noop())
    .pipe(gulp.dest(destinations.js))

# Lint app code
gulp.task 'lint', ->
  gulp.src(sources.coffee)
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())

# Public resources
gulp.task 'examples-public', ->
  gulp.src(sources.examples.public)
    .pipe(gulp.dest(destinations.dist))

# Examples
gulp.task 'examples-src', ->
  gulp.src(sources.examples.coffee)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(concat('app.js'))
    .pipe(ngAnnotate())
    .pipe(gulp.dest(destinations.js))

gulp.task 'examples-lint', ->
  gulp.src(sources.examples.coffee)
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())

gulp.task 'examples-style', ->
  gulp.src(sources.examples.sass) # we defined that at the top of the file
    .pipe(sass({outputStyle: 'compressed', errLogToConsole: true}))
    .pipe(gulp.dest(destinations.css))

gulp.task 'examples-rev', ->
  gulp.src([destinations.css + '/*.css', destinations.js + '/*.js'], {base: destinations.dist})
    .pipe(rev())
    .pipe(gulp.dest(destinations.dist))
    .pipe(rev.manifest())
    .pipe(gulp.dest(destinations.dist))

gulp.task 'examples-html', ->
  revs = try
    require("./#{destinations.dist}/rev-manifest.json")
  catch
    undefined

  gulp.src(sources.examples.html)
    .pipe(jade({
      locals: {revs: (rev) -> if revs then revs[rev] else rev},
      pretty: true
    }))
    .pipe(gulp.dest(destinations.html))

# Vendor
gulp.task 'examples-src-vendor', ->
  gulp.src(sources.examples.vendor)
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest(destinations.js))

gulp.task 'examples-style-vendor', ->
  gulp.src(bower({includeDev: true}))
    .pipe(filter('*.css'))
    .pipe(concat('vendor.css'))
    .pipe(minifyCss())
    .pipe(gulp.dest(destinations.css))

# Server
gulp.task 'browser-sync', ->
  browserSync.init null,
  open: false
  server:
    baseDir: "./#{destinations.dist}"
  watchOptions:
    debounceDelay: 1000

# Watch files
gulp.task 'watch', ->
  gulp.watch sources.coffee, ['lint', 'src', 'examples-html']
  gulp.watch sources.examples.coffee, ['examples-lint', 'examples-src']
  gulp.watch sources.examples.sass, ['examples-style']
  gulp.watch sources.examples.html, ['examples-html']

  # And we reload our page if something changed in the output folder
  gulp.watch 'dist/**/**', (file) ->
    browserSync.reload(file.path) if file.type is 'changed'

# Clean
gulp.task 'clean', ->
  gulp.src(['dist/'], {read: false}).pipe(clean())

gulp.task 'assets', (callback) ->
  sequence 'lint', 'examples-lint', [
    'src',
    'examples-public',
    'examples-src-vendor', 'examples-src',
    'examples-style-vendor', 'examples-style'
  ], callback

gulp.task 'build', (callback) ->
  sequence 'clean', ['assets', 'examples-html'], callback

gulp.task 'dist', (callback) ->
  sequence 'clean', 'assets', 'examples-rev', 'examples-html', callback

gulp.task 'default', (callback) ->
  sequence 'build', ['browser-sync', 'watch'], callback

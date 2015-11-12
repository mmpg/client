gulp = require 'gulp'
gutil = require 'gulp-util'

sass = require 'gulp-sass'
browserSync = require 'browser-sync'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
clean = require 'gulp-clean'
filter = require 'gulp-filter'
sequence = require 'run-sequence'
bower = require 'main-bower-files'

sources =
  coffee: 'src/**/*.coffee'
  examples:
    coffee: 'examples/**/*.coffee'
    html:   'examples/**/*.html'
    sass:   'examples/**/*.scss'

destinations =
  css: 'dist/css'
  html: 'dist/'
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

# Examples
gulp.task 'examples-src', ->
  gulp.src(sources.examples.coffee)
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .pipe(gulp.dest(destinations.js))

gulp.task 'examples-lint', ->
  gulp.src(sources.examples.coffee)
  .pipe(coffeelint())
  .pipe(coffeelint.reporter())

gulp.task 'examples-style', ->
  gulp.src(sources.examples.sass) # we defined that at the top of the file
  .pipe(sass({outputStyle: 'compressed', errLogToConsole: true}))
  .pipe(gulp.dest(destinations.css))

gulp.task 'examples-html', ->
  gulp.src(sources.examples.html)
  .pipe(gulp.dest(destinations.html))

# Vendor
gulp.task 'vendor', ->
  gulp.src(bower({ includeDev: true }))
  .pipe(filter('*.js'))
  .pipe(concat('vendor.js'))
  .pipe(gulp.dest(destinations.js))

# Server
gulp.task 'browser-sync', ->
  browserSync.init null,
  open: false
  server:
    baseDir: "./dist"
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

gulp.task 'build', ->
  sequence 'clean', ['vendor', 'lint', 'src', 'examples-src', 'examples-style', 'examples-html']

gulp.task 'default', ['build', 'browser-sync','watch']

gulp = require 'gulp'

fs = require 'fs'
path = require 'path'
del = require 'del'
open = require 'opn'
gh = require 'gh-pages'

$ = require('gulp-load-plugins') rename:
    'gulp-ng-classify':'ng'

gulp.task 'ng', ['del:tmp'], () ->
  gulp.src 'app/js/**/*.coffee'
    .pipe $.concat 'app.coffee'
    .pipe $.ng()
    .pipe gulp.dest 'tmp'

gulp.task 'js', ['ng'], (done) ->
  gulp.src 'tmp/app.coffee', read: false
    .pipe $.browserify
      transform: ['coffeeify']
      extensions: ['.coffee']
    .pipe $.uglify()
    .pipe $.rename 'app.js'
    .pipe gulp.dest 'dist/js'
    .pipe $.connect.reload()

gulp.task 'css', () ->
  gulp.src 'app/css/app.styl'
    .pipe $.stylus compress: true
    .pipe gulp.dest 'dist/css'
    .pipe $.connect.reload()

  fs.exists 'dist/css/angular-material.min.css', (there) ->
    if not there
      gulp.src 'node_modules/angular-material/angular-material.min.css'
        .pipe gulp.dest 'dist/css'
  return

gulp.task 'jade', () ->
  gulp.src 'app/index.jade'
    .pipe $.jade()
    .pipe gulp.dest 'dist'
    .pipe $.connect.reload()

gulp.task 'res', () ->
  gulp.src 'app/res/**/*'
    .pipe gulp.dest 'dist/res'

gulp.task 'jade:views', () ->
  fs.readdir 'app/views', (err, views) ->
    if err then console.log err else compile view for view in views; return

  compile = (view) ->
    gulp.src "app/views/#{view}/index.jade"
      .pipe $.jade()
      .pipe gulp.dest "dist/views/#{view}"
      .pipe $.connect.reload()
  return

gulp.task 'del:tmp', (done) ->
  del ['tmp'], done; return

gulp.task 'watch', () ->
  gulp.watch ['app/index.jade', 'app/includes/**/*.jade'], ['jade']
  gulp.watch 'app/css/**/*.styl', ['css']
  gulp.watch 'app/js/**/*.coffee', ['js']
  gulp.watch 'app/views/**/*.jade', ['jade:views']; return

gulp.task 'connect', ['build'], (done) ->
  $.connect.server
    root: 'dist'
    livereload: true

  open 'http://localhost:8080', done; return

gulp.task 'deploy', ['build'], (done) ->
  gh.publish path.join(__dirname, 'dist'), logger: $.util.log, done; return

gulp.task 'build', ['js', 'jade', 'jade:views', 'css', 'res']
gulp.task 'serve', ['connect', 'watch']
gulp.task 'default', ['build']

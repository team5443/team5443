gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
uglify = require 'gulp-uglify'
ghpages = require 'gh-pages'
connect = require 'gulp-connect'
opn = require 'opn'
fs = require 'fs'
path = require 'path'

gulp.task 'js', () ->
  gulp.src 'app/js/**/*.js'
		.pipe concat 'app.js'
		.pipe uglify()
		.pipe gulp.dest('dist/js')

gulp.task 'stylus', () ->
  gulp.src 'app/css/app.styl'
    .pipe stylus compress: true
    .pipe gulp.dest 'dist/css'

gulp.task 'jade', () ->
  gulp.src 'app/index.jade'
    .pipe jade()
    .pipe gulp.dest 'dist'

gulp.task 'jade:views', () ->
  fs.readdir 'app/views', (err, views) ->
    if err
      console.log err
    else
      compile view for view in views
      return

  compile = (view) ->
    gulp.src "app/views/#{view}/index.jade"
      .pipe jade()
      .pipe gulp.dest "dist/views/#{view}"

  return

gulp.task 'copy', () ->
  fs.readdir 'app/vendor', (err, dep) ->
    if err
      console.log err
    else
      copy dir for dir in dep
      return

  gulp.src 'app/vendor/angular-ui-router/release/angular-ui-router.min.js'
    .pipe gulp.dest 'dist/vendor'

  copy = (dir) ->
    fs.readdir "app/vendor/#{dir}", (err, files) ->
      if err
        console.log err
      else
        for file in file
          if file.indexOf '.min' > -1
            switch file.split('.').pop()
              when 'js', 'css', 'map'
                gulp.src "app/vendor/#{dir}/#{file}"
                  .pipe gulp.dest 'dist/vendor'
                return
    return
  return

gulp.task 'watch', () ->
  gulp.watch ['app/index.jade', 'app/includes/**/*.jade'], ['jade']
  gulp.watch 'app/css/**/*.styl', ['stylus']
  gulp.watch 'app/js/**/*.js', ['js']
  gulp.watch 'app/views/**/*.jade', ['jade:views']
  return

gulp.task 'connect', ['build'], (done) ->
  connect.server
    root: 'dist'
    livereload: true

  opn 'https://localhost:8080', done
  return

gulp.task 'deploy', ['build'], (done) ->
  ghpages.publish path.join(__dirname, 'dist'), logger: gutil.log, done
  return

gulp.task 'build', ['js', 'jade', 'jade:views', 'stylus', 'copy']
gulp.task 'serve', ['connect', 'watch']
gulp.task 'default', ['build']

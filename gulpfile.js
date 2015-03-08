var gulp = require("gulp"),
	gutil = require("gulp-util"),
	concat = require("gulp-concat"),
	jade = require("gulp-jade"),
	stylus = require("gulp-stylus"),
	uglify = require("gulp-uglify"),
	ghpages = require("gh-pages"),
	connect = require("gulp-connect"),
	opn = require("opn"),
	fs = require("fs"),
	path = require("path");

gulp.task("js", function(){
	return gulp.src("app/js/**/*.js")
		.pipe(concat("app.js"))
		.pipe(uglify())
		.pipe(gulp.dest("dist/js"));
});

gulp.task("stylus", function(){
	return gulp.src("app/css/app.styl")
		.pipe(stylus({compress:true}))
		.pipe(gulp.dest("dist/css"))
});

gulp.task("jade", function(){
	return gulp.src("app/index.jade")
		.pipe(jade())
		.pipe(gulp.dest("dist"));
});

gulp.task('jade:views', function(){
	fs.readdir('app/views', function(err, views){
		if(err){
			console.log(err);
		}else {
			for(i in views){
				var view = views[i];
				compileView(view)
			}
		}	
	});
});

function compileView(view){
	return gulp.src('app/views/' + view + '/index.jade')
				.pipe(jade())
				.pipe(gulp.dest('dist/views/' + view));
}

gulp.task("copy", function(){
	var files = [
		"app/vendor/angular/angular.min.js",
		"app/vendor/angular-animate/angular-animate.min.js",
		"app/vendor/angular-aria/angular-aria.min.js",
		"app/vendor/angular-material/angular-material.min.js",
		"app/vendor/angular-material/angular-material.min.css",
		"app/vendor/angular-route/angular-route.min.js",
		"app/vendor/angular/angular.min.js.map",
		"app/vendor/angular-aria/angular-aria.min.js.map",
		"app/vendor/angular-route/angular-route.min.js.map",
		"app/vendor/angular-animate/angular-animate.min.js.map",
		"app/vendor/angular/angular.min.js.map"
	]

	return gulp.src(files)
		.pipe(gulp.dest("dist/vendor"));
});

gulp.task('watch', function() {
 	gulp.watch(['app/index.jade', 'app/includes/**/*.jade'], ['jade']);
 	gulp.watch('app/css/**/*.styl', ['stylus']);
 	gulp.watch('app/js/**/*.js', ['js']);

 	fs.readdir("app/views", function(err, views){
		if(err){
			console.log(err);
		} else {
			for(i in views){
				var view = views[i];
				gulp.watch("app/views/" + view + "/index.jade", compileView(view));
			}
		}
	})
});

gulp.task('connect', ['build'], function(done) {
 	connect.server({
   		root: 'dist',
    	livereload: true
  	});

  	opn('http://localhost:8080', done);
});

gulp.task('deploy', ['build'], function(done) {
  	ghpages.publish(path.join(__dirname, 'dist'), { logger: gutil.log }, done);
});

gulp.task('build', ['js', 'jade', 'jade:views', 'stylus', 'copy']);
gulp.task('serve', ['connect', 'watch']);
gulp.task('default', ['build']);
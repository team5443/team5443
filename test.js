var fs = require("fs");

gulp.task('jade:test', function(){
	return fs.readdir('app/view', function(err, views){
		for(i in views){
			var view = views[i];

			gulp.src('app/views/' + view + '/index.jade')
				.pipe(jade())
				.pipe(gulp.dest('app/views/' + view));
		}
	});
});
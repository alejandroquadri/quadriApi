var gulp = require('gulp');
var print = require('gulp-print');
var babel = require('gulp-babel');
var nodemon = require('gulp-nodemon');
var notify = require('gulp-notify');
var livereload = require('gulp-livereload');
var Cache = require('gulp-file-cache');

var cache = new Cache();

gulp.task('compile', function () {
  var stream = gulp.src('./src/**/*.js') // your ES2015 code
	  .pipe(cache.filter()) // remember files
	  .pipe(print()) 
	  .pipe(babel({ presets: ['es2015'] })) // compile new ones
	  .pipe(cache.cache()) // cache them
	  .pipe(gulp.dest('./build')); // write them
  return stream; // important for gulp-nodemon to wait for completion
});

gulp.task('sqlCopy', function () {
  var stram = gulp.src('./src/**/*.sql')
    .pipe(gulp.dest('./build'));
});

gulp.task('watch', ['compile', 'sqlCopy'], function () {
  var stream = nodemon({
    script: './build/app.js', // run ES5 code
    watch: 'src', // watch ES2015 code
    tasks: ['compile'] // compile synchronously onChange
  });

  return stream;
});

gulp.task('default', ['watch']);


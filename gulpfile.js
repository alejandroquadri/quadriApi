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
  var stream = gulp.src('./src/**/*.sql')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('jsonCopy', function () {
  var stream = gulp.src('./src/**/*.json')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('htmlCopy', function () {
  var stream = gulp.src('./src/**/*.html')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('cssCopy', function () {
  var stream = gulp.src('./src/**/*.css')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('imageCopy', function () {
  var stream = gulp.src('./src/**/*.jpg')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('watch', ['compile', 'sqlCopy', 'jsonCopy', 'htmlCopy', 'cssCopy', 'imageCopy'], function () {
  var stream = nodemon({
    script: './build/app.js', // run ES5 code
    watch: 'src', // watch ES2015 code
    ext: 'js sql html css',
    tasks: ['compile', 'sqlCopy', 'jsonCopy', 'htmlCopy', 'cssCopy', 'imageCopy'] // compile synchronously onChange
  });

  return stream;
});

gulp.task('default', ['watch']);



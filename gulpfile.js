var gulp = require('gulp');
var babel = require('gulp-babel');
var nodemon = require('gulp-nodemon');

gulp.task('compile', () => { 
  var stream = gulp.src('./src/**/*.js')    
  .pipe(babel({       
    "presets": ["env"]
  }))  
  .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('sqlCopy', () => {
  var stream = gulp.src('./src/**/*.sql')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('jsonCopy', () => {
  var stream = gulp.src('./src/**/*.json')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('htmlCopy', () => {
  var stream = gulp.src('./src/**/*.html')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('cssCopy', () => {
  var stream = gulp.src('./src/**/*.css')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('imageCopy', () => {
  var stream = gulp.src('./src/**/*.jpg')
    .pipe(gulp.dest('./build'));
  return stream;
});

gulp.task('watch', gulp.series(['compile', 'sqlCopy', 'jsonCopy', 'htmlCopy', 'cssCopy', 'imageCopy'],  () => {
  var stream = nodemon({
    script: './build/app.js', // run ES5 code
    watch: 'src', // watch ES2015 code
    ext: 'js sql html css',
    tasks: ['compile', 'sqlCopy', 'jsonCopy', 'htmlCopy', 'cssCopy', 'imageCopy'] // compile synchronously onChange
  });
  return stream;
}));

gulp.task('default', gulp.series(['compile', 'sqlCopy', 'jsonCopy', 'htmlCopy', 'cssCopy', 'imageCopy']));



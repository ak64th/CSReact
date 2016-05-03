var gulp = require('gulp');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var maps = require('gulp-sourcemaps');
var browserify = require('gulp-browserify');
var browserSync = require('browser-sync').create();
var gzip = require('gulp-gzip');
var gzipStatic  = require('connect-gzip-static');
var del = require('del');

var handleError = function (err) {
  gutil.log(err.toString());
  this.emit('end');
}

var environment = 'development';

gulp.task('set-production', function() {
  process.env.NODE_ENV = environment = 'production';
});

gulp.task('clean', function(){
  return del(['./public/**']);
});

gulp.task('html', function() {
  return gulp.src('./app/index.html')
    .pipe(gulp.dest('./public'));
});

gulp.task('css', function() {
  return gulp.src('./app/styles/app.css')
    .pipe(gulp.dest('./public/css'))
    .pipe(browserSync.stream());
});

gulp.task('browserify', function() {
  stream = gulp.src('./app/scripts/app.coffee', { read: false })
    .pipe(maps.init())
    .pipe(browserify({
      debug: true,
      transform: ['coffeeify'],
      extensions: ['.coffee']
    })).on('error', handleError)
    .pipe(concat('app.js'))
    .pipe(maps.write('./'));
  if (environment == 'production') {
    stream.pipe(uglify());
  }
  return stream.pipe(gzip()).pipe(gulp.dest('./public/js'));
});

gulp.task('reload-html', ['html'], function() {
    browserSync.reload();
});
gulp.task('reload-js', ['browserify'],  function() {
    browserSync.reload();
});

gulp.task('watch', ['html', 'css', 'browserify'], function() {
  gulp.watch('./app/*.html', ['reload-html']);
  gulp.watch('./app/styles/**/*.css', ['css']);
  gulp.watch('./app/scripts/**/*.coffee', ['reload-js']);
});

gulp.task('server', ['watch'], function() {
  browserSync.init({
    server: {
      baseDir: "./public/",
      middleware: [gzipStatic('./public')]
    }
  });
});

gulp.task('server-production', ['set-production', 'watch', 'server']);
gulp.task('default', ['html', 'browserify', 'css']);
gulp.task('production', ['set-production', 'default']);

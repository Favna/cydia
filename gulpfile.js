const gulp = require('gulp');
const replace = require('gulp-replace');

gulp.task('default', () =>
  gulp
    .src(['Packages'])
    .pipe(replace('support@favna.xyz', 'support@favware.tech'))
    .pipe(replace('Themes (Addons)', 'Themes'))
    .pipe(gulp.dest('./'))
);

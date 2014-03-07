# [gulp](http://gulpjs.com)-livingstyleguide [![Build Status](https://secure.travis-ci.org/medialwerk/gulp-livingstyleguide.png?branch=master)](http://travis-ci.org/medialwerk/gulp-livingstyleguide)

> Lorem ipsum


## Install

```
npm install --save-dev gulp-livingstyleguide
```


## Example

```js
var gulp = require('gulp');
var livingstyleguide = require('gulp-livingstyleguide');

gulp.task('default', function () {
	gulp.src('src/app.ext')
		.pipe(livingstyleguide())
		.pipe(gulp.dest('dist'));
});
```


## API

### livingstyleguide(options)

#### options

##### foo

Type: `Boolean`  
Default: `false`

Lorem ipsum.


## License

MIT © [Ferdinand Full](https://github.com/medialwerk)

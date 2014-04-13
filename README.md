# [gulp](http://gulpjs.com)-livingstyleguide

> Easily create living style guides with Markdown, Sass/SCSS and Compass using the [livingstyleguide gem](https://github.com/hagenburger/livingstyleguide)


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

#### options.template

Type: `String`
Default: `__dirname + "styleguide.jade"`

Where to put the generated jade template.


## License

MIT

Copyright (c) 2014 [efa GmbH](http://efa-gmbh.com/), [Ferdinand Full](https://github.com/medialwerk)

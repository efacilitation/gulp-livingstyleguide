# [gulp](http://gulpjs.com)-livingstyleguide

> Easily create living styleguides with Markdownn and Sass/Scss using the  [livingstyleguide gem](https://github.com/hagenburger/livingstyleguide)


## Install

First you have to install the [livingstyleguide gem](https://github.com/hagenburger/livingstyleguide). We recommend version >= 1.4.0

```
gem install livingstyleguide
```

Then install the gulp-livingstyleguide npm package:

```
npm install gulp-livingstyleguide --save-dev
```


## Example

```js
var gulp = require('gulp');
var livingstyleguide = require('gulp-livingstyleguide');

gulp.task('default', function () {
	gulp.src('styleguide.html.lsg')
		.pipe(livingstyleguide())
		.pipe(gulp.dest('dist'));
});
```

## What is the Plugin doing?

- It compiles the livingstyleguide

## License

MIT

Copyright (c) 2014 [efa GmbH](http://efa-gmbh.com/), [Ferdinand Full](https://github.com/medialwerk)

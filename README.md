# [gulp](http://gulpjs.com)-livingstyleguide

> Easily create living style guides with Markdown, Sass/SCSS and Compass using the [livingstyleguide gem](https://github.com/hagenburger/livingstyleguide)


## Install

First you have to install the livingstyleguide gem:
I recommend version > 1.0.4

```
gem install livingstyleguide
```

Then install the gulp-livingstyleguide npm package:

```
npm install --save-dev gulp-livingstyleguide
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
- Extracts the styles-tag from the livingstyleguide output to a sperate Vynl-File and hand it over to the gulp pipe.
- PrettyPrint the HTML

## API

### livingstyleguide(options)

#### options.template

**Type**: `String`  
**Description**: Path to the template Jade.  
It needs `!= content` where the generated code will be injected and the link-tag to the styleguide.css. `link(rel='stylesheet', type='text/css', href='styleguide.css')`  
**Default Template**:
```jade
doctype html
html
	head
		meta(charset='utf-8')
		meta(content='IE=edge,chrome=1', http-equiv='X-UA-Compatible')
		meta(content='The LivingStyleGuide Gem – http://livingstyleguide.org', name='generator')
		meta(name='description', content=title)
		title= title
		link(rel='stylesheet', type='text/css', href='styleguide.css')

	body.livingstyleguide

		header.livingstyleguide--header
			h1.livingstyleguide--page-title= title

		.livingstyleguide--container
			!= content

		footer.livingstyleguide--footer
```



## License

MIT

Copyright (c) 2014 [efa GmbH](http://efa-gmbh.com/), [Ferdinand Full](https://github.com/medialwerk)

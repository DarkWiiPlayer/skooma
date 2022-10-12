package.path = "?.lua;?/init.lua;" .. package.path

skooma = require 'skooma'
gen = skooma.env!
NAME = skooma.dom.name

describe 'skooma', ->
	describe 'environment', ->
		pending 'proxy', ->
		it 'returns DOM nodes', ->
			assert.is.equal "h1", gen.h1![NAME]
		pending 'handles nested table arguments'
	
	describe 'serialiser', ->
		it 'returns a table', ->
		it 'treats empty XML tags correctly', ->
			assert.is.equal '<div><span/></div>',
				skooma.serialise.xml(gen.div(gen.span))\concat!
		it 'concatenates attribute sequences', ->
			assert.is.equal '<span class="foo bar baz"/>',
				skooma.serialise.xml(gen.span(class: {"foo", "bar", "baz"}))\concat!
		describe 'method', ->
			it 'renders the content', ->
				assert.is.equal '<span class="foo bar baz"/>',
					gen.span(class: {"foo", "bar", "baz"})\render('xml')\concat!
				assert.is.equal '<span class="foo bar baz"></span>',
					gen.span(class: {"foo", "bar", "baz"})\render('html')\concat!
			it 'defaults to xml', -> -- TODO: Find a nice way of switching defaults
				assert.is.equal '<span class="foo bar baz"/>',
					gen.span(class: {"foo", "bar", "baz"})\render!\concat!
			it 'is available as a __call metamethod', ->
				assert.is.equal '<span class="foo bar baz"/>',
					gen.span(class: {"foo", "bar", "baz"})!\concat!


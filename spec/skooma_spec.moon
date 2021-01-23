package.path = "?.lua;?/init.lua;" .. package.path

skooma = require 'skooma'
_ = skooma.env
NAME = skooma.ast.name

describe 'skooma', ->
	describe 'environment', ->
		pending 'proxy', ->
		it 'returns AST nodes', ->
			assert.is.equal "h1", _.h1![NAME]
		pending 'handles nested table arguments'
	
	describe 'serializer', ->
		it 'returns a table', ->
		it 'treats empty XML tags correctly', ->
			assert.is.equal '<div><span/></div>',
				skooma.serialize.xml(_.div(_.span))\concat!
		it 'concatenates attribute sequences', ->
			assert.is.equal '<span class="foo bar baz"/>',
				skooma.serialize.xml(_.span(class: {"foo", "bar", "baz"}))\concat!

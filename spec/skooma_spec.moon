skooma = require 'skooma'
xml = skooma.env!
html = skooma.env 'html'
NAME = skooma.dom.name

describe 'skooma', ->
	describe 'environment', ->
		it 'returns DOM nodes', ->
			assert.is.equal "h1", xml.h1![NAME]
		it 'has a raw function', ->
			assert.is.function xml.raw
			assert.same { [NAME]: skooma.dom.raw, 'foo' }, xml.raw 'foo'
		pending 'handles nested table arguments', ->
	
	describe 'serialiser', ->
		it 'treats empty XML tags correctly', ->
			assert.is.equal '<div><span/></div>',
				tostring xml.div xml.span!
		it 'treats empty HTML tags correctly', ->
			assert.is.equal '<div></div>',
				tostring html.div!
			assert.is.equal '<br>',
				tostring html.br!
		it 'correctly transforms custom property names for convenience', ->
			assert.is.equal '<custom-element></custom-element>',
				tostring html.customElement!
		it 'concatenates attribute sequences', ->
			assert.is.equal '<span class="foo bar baz"/>',
				tostring xml.span class: {"foo", "bar", "baz"}
		describe 'method', ->
			it 'renders the content', ->
				assert.is.equal '<span class="foo bar baz"/>',
					xml.span(class: {"foo", "bar", "baz"})\render('xml')\concat!
				assert.is.equal '<span class="foo bar baz"></span>',
					xml.span(class: {"foo", "bar", "baz"})\render('html')\concat!

			it 'escapes strings by default', ->
				for lang in *{'xml', 'html'}
					assert.is.equal '<span>&lt;div&gt;</span>',
						xml.span('<div>')\render(lang)\concat!

			it 'does not escape raw strings', ->
				assert.is.equal '<span><div></span>',
					xml.span(xml.raw("<div>"))\render('html')\concat!

			it 'defaults to xml', -> -- TODO: Find a nice way of switching defaults
				assert.is.equal '<span class="foo bar baz"/>',
					xml.span(class: {"foo", "bar", "baz"})\render!\concat!

			it 'is available as a __call metamethod', ->
				assert.is.equal '<span class="foo bar baz"/>',
					xml.span(class: {"foo", "bar", "baz"})!\concat!

	it 'accepts custom serialiser functions', ->
		custom = skooma.env (node) -> node[NAME]
		doc = custom.node_name!
		assert.equal "node_name", tostring(doc)

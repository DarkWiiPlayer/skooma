import slotty, env from require 'skooma'

html = env 'html'

describe "slotty", ->
	before_each ->
		export slots = slotty!
	it "returns slots consistently", ->
		assert.equal slots.foo, slots.foo
		assert.not.equal slots.foo, slots.bar
	it "skips flattening until serialisation", ->
		div = html.div slots.foo
		assert.equal "<div></div>", tostring(div)
		slots.foo "foo"
		assert.equal "<div>foo</div>", tostring(div)

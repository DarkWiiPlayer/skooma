Skooma
================================================================================

A functional library for HTML and XML generation in Lua.

Why?
----------------------------------------

Because HTML sucks and most existing templating systems end up being glorified
string interpolation. This means you're still writing HTML at the end of the
day.

Additionally, HTML and XML are not trivial to parse, so transforming it is a
lot easier with a simplified DOM-like tree structure than in text form.

How?
----------------------------------------

Skooma is dead simple: every function returns a tree. No side effects.

After you're done applying whatever transformations to the ast, another function
serializes it into HTML, which you can then use however you want.

When should I use this?
----------------------------------------

Whenever you:

- Want to avoid writing actual HTML at all costs
- Want to further transform your HTML structure before sending it to a user
- Want to build small re-usable components close to where they're used

When should I *not* use this?
----------------------------------------

If you want

- Logic-less templating that you can trust your users with
- A simple and close-to-html templating language that you can learn easily
- Pain

Then you'd probably be better off with a more traditional templating solution.
A few recommendations in this case would be [Lustache][lustache], [Cosmo][cosmo]
and [etLua][etlua]

Examples
----------------------------------------

A simple example in [Yuescript][yuescript]

	skooma = require 'skooma'
	html = skooma.env 'html'

	link = => html.a @, href: "/#{@lower!}"
	list = => html.ul [html.li link item for item in *@]
	tree = html.html list
		* "Foo"
		* "Bar"
		* "Baz"

	print tree

A similar snippet in Lua:

	local skooma = require 'skooma'
	local html = skooma.env 'html'

	local function map(fn, tab)
		local new = {}
		for i, value in ipairs(tab) do
			new[i]=fn(value)
		end
		return new
	end

	local tree do
		local function link(text)
			return html.a(text, {href="/"..string.lower(text)})
		end

		local function list(items)
			return html.ul(
				map(html.li, map(link, items))
			)
		end

		tree = html.html(list{"Foo", "Bar", "Baz"})
	end

	print(tree)

The resulting HTML, formatted a bit, should look something like this:

	<html>
		<ul>
			<li>
				<a href="/foo">Foo</a>
			</li>
			<li>
				<a href="/bar">Bar</a>
			</li>
			<li>
				<a href="/baz">Baz</a>
			</li>
		</ul>
	</html>

I want to output a different format
----------------------------------------

Instead of a named format like `"xml"` or `"html"` you can also pass in a custom
serialise function during environment creation or while rendering an element.

	local alwaysfoo = skooma.env(function(root) return "foo" end)
	local root = alwaysfoo.h1(alwaysfoo.b("Bold title"))
	print(root) -- Just prints "foo"

Custom serialisers should return a sequence of strings. This is to avoid
needless concatenations when streaming content. Any return value that isn't
a table will be wrapped in one after being `tostring`d.

[cosmo]: https://github.com/LuaDist/cosmo
[etlua]: https://github.com/leafo/etlua
[yuescript]: http://yuescript.org
[moonxml]: http://github.com/darkwiiplayer/moonxml
[lustache]: https://github.com/Olivine-Labs/lustache

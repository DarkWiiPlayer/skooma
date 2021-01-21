Skooma
================================================================================

A library to generate HTML pages in Lua using functional tools. This project is
meant to be complementary to [MoonXML][moonxml] with a stronger focus on
performance and hackability and less on easy and quick template writing.

Why?
----------------------------------------

Because HTML sucks and most existing templating systems end up being glorified
string interpolation.

Additionally, templates usually produce text output, which is very uncomfortable
to modify, as that requires either parsing it back into a data structure or
doing string replacement, which can easily break if the generated HTML changes
or is simply dynamic in general.

How?
----------------------------------------

Skooma is dead simple: every function returns a tree. No side effects.

After you're done applying whatever transformations to the ast, another function
serializes it into HTML, which you can then use however you want.

When should I use this?
----------------------------------------

When you feel like your project has outgrown a simplistic approach on
templating, for either performance-related or architectural reasons. The benefit
when compared to a more traditional templating solution is the separation into
two steps:

1. Building an AST
2. Serializing into HTML

In between those two steps, one can easily apply additional transformations to
the structure (think middleware) without having to resort to string-manipulation
and HTML parsing.

Turning "templates" into (pure) Lua functions allows building re-usable
components that hide HTML semantics behind higher-level concepts. Imagine, for a
very basic example, a function `list(items, ordered)` that takes a sequence of
items and outputs either an `<ul>` or `<ol>` node with all items wrapped in an
`<li>`. More complex examples could be `post(title, text)`, `menu(sitemap)`,
etc.

When should I *not* use this?
----------------------------------------

If you want

-	A simple templating format, either with just interpolation or a dedicated
	syntax like with HAML, MoonXML, etc.
-	Template files that closely resemble the resulting HTML in their structure.
-	A way to very quickly write templates without thinking much about refactoring
	or extracting common logic into functions/components.

Then you'd probably be better off with a more traditional templating solution.
A few recommendations in this case would be [MoonXML][moonxml], [Cosmo][cosmo]
and [etLua][etlua]

Examples
----------------------------------------

A simple example in [Moonscript][moonscript]

	env = require "skooma.env"
	serialize = require "skooma.serialize"

	map = (fn, tab) ->
		[fn value for value in *tab]

	tree ==>
		-- Set up environment
		_ENV = env\proxy(_G)
		setfenv(1, _ENV) if _VERSION=="Lua 5.1"
		-- Define some helpers
		link = (text) -> a text, href: "/" .. string.lower text
		list = (items) -> ul map li, map link, items
		-- Define our actual function
		html list {"Foo", "Bar", "Baz"}

	print serialize(tree!)\concat!

A similar snippet in Lua:

	local env = require "skooma.env"
	local serialize = require "skooma.serialize"

	local function map(fn, tab)
		local new = {}
		for i, value in ipairs(tab) do
			new[i]=fn(value)
		end
		return new
	end

	local tree do
		local _ENV = env:proxy(_G)

		local function link(text)
			return a(text, {href="/"..string.lower(text)})
		end

		local function list(items)
			return ul(map(li, map(link, items)))
		end

		tree = html(list{"Foo", "Bar", "Baz"})
	end

	print(serialize(tree):concat())

[cosmo]: https://github.com/LuaDist/cosmo
[etlua]: https://github.com/leafo/etlua
[moonscript]: http://moonscript.org
[moonxml]: http://github.com/darkwiiplayer/moonxml

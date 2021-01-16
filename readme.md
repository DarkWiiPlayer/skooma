HTMΛ (name subject to change)
================================================================================

A library to generate HTML pages in Lua using functional tools. This project is
meant to be complementary to [MoonXML][moonxml] with a stronger focus on
performance and hackability and less on easy and quick template writing.


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

- A simple templating format, either with just interpolation or a dedicated
  syntax like with HAML, MoonXML, etc.
- Template files that closely resemble the resulting HTML in their structure.
- A way to very quickly write templates without thinking much about refactoring
  or extracting common logic into functions/components.

Then you'd probably be better off with a more traditional templating solution.
A few recommendations in this case would be [MoonXML][moonxml], [Cosmo][cosmo]
and [etLua][etlua]

[moonxml]: http://github.com/darkwiiplayer/moonxml

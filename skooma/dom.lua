--- Simple DOM generation library
-- @module skooma.dom

local dom = {}

dom.name = {token="Unique token to store a tag name"}
local NAME = dom.name

dom.format = {token="Unique token to stora a tags format"}
local FORMAT = dom.format

--- Table representing a DOM node.
-- Integer keys are child elements.
-- String keys are properties.
-- The special tokens `dom.name` and `dom.format` serve as keys
-- for the nodes name and its format (html, xml, etc.) respectively.
-- @table node

--- Renders a dom node
-- @tparam node node
function dom.render(node, format)
	local serialise = require 'skooma.serialise'
	format = format or node[FORMAT] or 'xml'
	return serialise[format](node)
end

dom.meta = {
	__index = dom,
	__call=dom.render,
	__tostring=function(self)
		return table.concat(dom.render(self))
	end
}

--- Like `next`, but for `node` attributes (string keys).
function dom.next_attribute(node, previous)
	local key, value = next(node, previous)
	if key then
		if type(key)=="string" then
			return key, value
		else
			return dom.next_attribute(node, key)
		end
	end
end

--- like `pairs` but for `node` attributes (string keys).
function dom.attributes(node)
	return dom.next_attribute, node, nil
end

--- Inserts a subtree into a node.
-- Non-table values and `node`s are inserted as-is.
-- Tables are iterated and their integer keys are inserted into the
-- given node in order while string keys are set as attributes.
function dom.insert(node, subtree)
	if type(subtree)~="table" or subtree[NAME] or subtree[NAME]==false then
		table.insert(node, subtree)
	else
		for _, element in ipairs(subtree) do
			dom.insert(node, element)
		end
		for key, value in dom.attributes(subtree) do
			node[key]=value
		end
	end
end

--- Creates a new DOM node.
-- @tparam string name Tag name of the new node
-- @tparam string format Serialisation format of the new node (html, xml, etc.).
-- Defaults to whatever is set in the environment, or 'xml' if nothing is set.
function dom.node(name, format)
	return function(...)
		local node = setmetatable({[NAME]=name, [FORMAT]=format}, dom.meta)
		for i=1,select('#', ...) do
			dom.insert(node, select(i, ...))
		end
		return node
	end
end

return dom

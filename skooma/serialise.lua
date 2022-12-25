--- Module for DOM serialisation.
-- This module should rarely be used directly, as DOM nodes know how to serialise themselves.
-- @module skooma.serialise

local dom = require 'skooma.dom'
local NAME = dom.name

local serialise = {}

local html_void = {
	area = true, base = true, br = true, col = true,
	command = true, embed = true, hr = true, img = true,
	input = true, keygen = true, link = true, meta = true,
	param = true, source = true, track = true, wbr = true
}

--- Turns a Lua object into something usable as an attribute.
-- Tables get concatenated as sequences, functions get called and their result fed back into `toattribute` and
-- everything else is fed through `tostring`.
local function toattribute(element)
	if type(element) == "table" then
		return table.concat(element, " ")
	elseif type(element) == "function" then
		return toattribute(element())
	else
		return tostring(element)
	end
end

--- Returns all attributes of a DOM node as a string.
-- @todo Benchmark table.insert
local function attribute_list(dom_node)
	local buffer = {}
	for attribute, value in dom.attributes(dom_node) do
		table.insert(buffer, ' '..attribute..'="'..toattribute(value)..'"')
	end
	return table.concat(buffer)
end

--- Recursively serialises a DOM tree.
-- @todo Benchmark table.insert
local function serialise_tree(serialise_tag, dom_node, buffer, ...)
	local t = type(dom_node)
	if t=="table" and dom_node[NAME] then
		serialise_tag(dom_node, buffer, ...)
	elseif t=="table" then
		for _, child in ipairs(dom_node) do
			serialise_tree(serialise_tag, child, buffer, ...)
		end
	elseif t=="function" then
		return serialise_tree(serialise_tag, dom_node(), buffer, ...)
	else
		table.insert(buffer, tostring(dom_node))
	end
	return buffer
end

--- Serialises an HTML tag
local function html_tag(dom_node, buffer, ...)
	local name = dom_node[NAME]:gsub("%u", "-%1", 2)
	if html_void[name] then
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node)..">")
		-- TODO: Maybe error or warn when node not empty? 🤔
	else
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node)..">")
		for _, child in ipairs(dom_node) do
			serialise_tree(html_tag, child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">") end
end

--- Serialises an XML tag
local function xml_tag(dom_node, buffer, ...)
	local name = dom_node[NAME]
	if 0 == #dom_node then
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node).."/>")
	else
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node)..">")
		for _, child in ipairs(dom_node) do
			serialise_tree(xml_tag, child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">")
	end
end

local meta = { __index = { concat = table.concat; } }

--- Serialises an HTML btree
function serialise.html(dom_node, ...)
	return serialise_tree(html_tag, dom_node, setmetatable({}, meta), ...)
end

--- Serialises an XML tree
function serialise.xml(dom_node, ...)
	return serialise_tree(xml_tag, dom_node, setmetatable({}, meta), ...)
end

return serialise

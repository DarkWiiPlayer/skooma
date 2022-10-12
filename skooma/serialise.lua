local dom = require 'skooma.dom'
local NAME = dom.name

local serialize = {}

local html_void = {
	area = true, base = true, br = true, col = true,
	command = true, embed = true, hr = true, img = true,
	input = true, keygen = true, link = true, meta = true,
	param = true, source = true, track = true, wbr = true
}

local function toattribute(element)
	if type(element) == "table" then
		return table.concat(element, " ")
	elseif type(element) == "function" then
		return toattribute(element())
	else
		return tostring(element)
	end
end


-- TODO: Benchmark table.insert
local function attribute_list(dom_node)
	local buffer = {}
	for attribute, value in dom.attributes(dom_node) do
		table.insert(buffer, ' '..attribute..'="'..toattribute(value)..'"')
	end
	return table.concat(buffer)
end

-- TODO: Benchmark table.insert
local function serialize_tree(serialize_tag, dom_node, buffer, ...)
	local t = type(dom_node)
	if t=="table" and dom_node[NAME] then
		serialize_tag(dom_node, buffer, ...)
	elseif t=="table" then
		for _, child in ipairs(dom_node) do
			serialize_tree(serialize_tag, child, buffer, ...)
		end
	elseif t=="function" then
		return serialize_tree(serialize_tag, dom_node(), buffer, ...)
	else
		table.insert(buffer, tostring(dom_node))
	end
	return buffer
end

local function html_tag(dom_node, buffer, ...)
	local name = dom_node[NAME]:gsub("%u", "-%1", 2)
	if html_void[name] then
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node)..">")
		-- TODO: Maybe error or warn when node not empty? 🤔
	else
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node)..">")
		for _, child in ipairs(dom_node) do
			serialize_tree(html_tag, child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">") end
end

local function xml_tag(dom_node, buffer, ...)
	local name = dom_node[NAME]
	if 0 == #dom_node then
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node).."/>")
	else
		table.insert(buffer, "<"..tostring(name)..attribute_list(dom_node)..">")
		for _, child in ipairs(dom_node) do
			serialize_tree(xml_tag, child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">")
	end
end

local meta = { __index = { concat = table.concat; } }

function serialize.html(dom_node, ...)
	return serialize_tree(html_tag, dom_node, setmetatable({}, meta), ...)
end

function serialize.xml(dom_node, ...)
	return serialize_tree(xml_tag, dom_node, setmetatable({}, meta), ...)
end

return serialize

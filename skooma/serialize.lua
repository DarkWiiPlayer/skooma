local ast = require 'skooma.ast'
local NAME = ast.name

local serialize = {}

local warn = function(...)
	if warn then
		warn(...)
	end
end

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
local function attribute_list(ast_node)
	local buffer = {}
	for attribute, value in ast.attributes(ast_node) do
		table.insert(buffer, ' '..attribute..'="'..toattribute(value)..'"')
	end
	return table.concat(buffer)
end

-- TODO: Benchmark table.insert
local function serialize_tree(serialize_tag, ast_node, buffer, ...)
	local t = type(ast_node)
	if t=="table" and ast_node[NAME] then
		serialize_tag(ast_node, buffer, ...)
	elseif t=="table" then
		for i, child in ipairs(ast_node) do
			serialize_tree(serialize_tag, child, buffer, ...)
		end
	elseif t=="function" then
		return serialize_tree(serialize_tag, ast_node(), buffer, ...)
	else
		table.insert(buffer, tostring(ast_node))
	end
	return buffer
end

local function html_tag(ast_node, buffer, ...)
	local name = ast_node[NAME]:gsub("%u", "-%1", 2)
	if html_void[name] then
		table.insert(buffer, "<"..tostring(name)..attribute_list(ast_node)..">")
		-- TODO: Maybe error or warn when node not empty? 🤔
	else
		table.insert(buffer, "<"..tostring(name)..attribute_list(ast_node)..">")
		for i, child in ipairs(ast_node) do
			serialize_tree(html_tag, child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">") end
end

local function xml_tag(ast_node, buffer, ...)
	local name = ast_node[NAME]
	if 0 == #ast_node then
		table.insert(buffer, "<"..tostring(name)..attribute_list(ast_node).."/>")
	else
		table.insert(buffer, "<"..tostring(name)..attribute_list(ast_node)..">")
		for i, child in ipairs(ast_node) do
			serialize_tree(xml_tag, child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">")
	end
end

local meta = { __index = { concat = table.concat; } }

function serialize.html(ast_node, ...)
	return serialize_tree(html_tag, ast_node, setmetatable({}, meta), ...)
end

function serialize.xml(ast_node, ...)
	return serialize_tree(xml_tag, ast_node, setmetatable({}, meta), ...)
end

return serialize

----------------------------------------
-- Concept
-- ‣ Functions to generate AST branches
-- ‣ Completely functional
----------------------------------------
-- Performance Considerations
-- ‣ Function closing should be memoized
--   Repeatedly calling templates should *not*
--   break out of JIT by using NYI features.

local function env(node)
	local meta = {}
	function meta:__index(key)
		self[key] = assert(node(key))
		return rawget(self, key)
	end
	return setmetatable({}, meta)
end

local NAME = {token="Unique token to store a tag name"}

local function ast_next_attribute(ast_node, previous)
	local key, value = next(ast_node, previous)
	if key then
		if type(key)=="string" then
			return key, value
		else
			return ast_next_attribute(ast_node, key)
		end
	end
end

local function ast_attributes(ast_node)
	return ast_next_attribute, ast_node, nil
end

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
local function ast_attribute_list(ast_node)
	local buffer = {}
	for attribute, value in ast_attributes(ast_node) do
		table.insert(buffer, ' '..attribute..'="'..toattribute(value)..'"')
	end
	return table.concat(buffer)
end

local function ast_insert(ast_node, subtree)
	if type(subtree)~="table" or subtree[NAME] then
		table.insert(ast_node, subtree)
	else
		for index, element in ipairs(subtree) do
			ast_insert(ast_node, element)
		end
		for key, value in ast_attributes(subtree) do
			ast_node[key]=value
		end
	end
end

-- TODO: Benchmark whether table.insert is too slow
local function ast_serialize(ast_node, buffer, ...)
	local buffer = buffer or {concat = table.concat}
	local t = type(ast_node)
	if t=="table" and ast_node[NAME] then
		local name = ast_node[NAME]
		table.insert(buffer, "<"..tostring(name)..ast_attribute_list(ast_node)..">")
		for i, child in ipairs(ast_node) do
			ast_serialize(child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">")
	elseif t=="table" then
		for i, child in ipairs(ast_node) do
			ast_serialize(child, buffer, ...)
		end
	elseif t=="function" then
		return ast_serialize(ast_node(), buffer, ...)
	else
		table.insert(buffer, tostring(ast_node))
	end
	return buffer
end

local function ast_print(ast_node, indent)
	indent = indent or 0
	local prefix = string.rep("\t", indent)

	if ast_node[NAME] then
		print(string.format("%s<%s>", prefix, tostring(ast_node[NAME])))
		for index, ast_child in ipairs(ast_node) do
			ast_print(ast_child, indent+1)
		end
	else
		print(string.format("%s '%s'", prefix, tostring(ast_node)))
	end
end

local function node(name)
	return function(...)
		local ast_node = {[NAME]=name}
		for i=1,select('#', ...) do
			ast_insert(ast_node, select(i, ...))
		end
		return ast_node
	end
end

local H = env(node)

local function map(fn, tab)
	local new = {}
	for i, value in ipairs(tab) do
		new[i]=fn(value)
	end
	return new
end

local string = string
local tree do
	local function link(text)
		return H.a(text:gsub("^.", string.upper), {href="/"..text})
	end
	tree = H.html(
		H.ul(
			{class={"foo", "bar"}},
			map(H.li,
				map(link, {"foo", "bar", "baz"})),
			H.li{"a", {"b", "c"}}))
end

print(ast_serialize(tree):concat())

local dom = {}

dom.name = {token="Unique token to store a tag name"}
local NAME = dom.name
dom.format = {token="Unique token to stora a tags format"}
local FORMAT = dom.format

function dom.render(dom_node, format)
	local serialise = require 'skooma.serialise'
	format = format or dom_node[FORMAT] or 'xml'
	return serialise[format](dom_node)
end

dom.meta = {
	__index = dom,
	__call=dom.render,
	__tostring=function(self)
		return table.concat(dom.render(self))
	end
}

function dom.next_attribute(dom_node, previous)
	local key, value = next(dom_node, previous)
	if key then
		if type(key)=="string" then
			return key, value
		else
			return dom.next_attribute(dom_node, key)
		end
	end
end

function dom.attributes(dom_node)
	return dom.next_attribute, dom_node, nil
end

function dom.insert(dom_node, subtree)
	if type(subtree)~="table" or subtree[NAME] then
		table.insert(dom_node, subtree)
	else
		for _, element in ipairs(subtree) do
			dom.insert(dom_node, element)
		end
		for key, value in dom.attributes(subtree) do
			dom_node[key]=value
		end
	end
end

function dom.node(name, format)
	return function(...)
		local dom_node = setmetatable({[NAME]=name, [FORMAT]=format}, dom.meta)
		for i=1,select('#', ...) do
			dom.insert(dom_node, select(i, ...))
		end
		return dom_node
	end
end

return dom

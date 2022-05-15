local dom = require 'skooma.dom'

local NAME = dom.name

local function env(node)
	local meta = {}
	function meta:__index(key)
		self[key] = assert(node(key))
		return rawget(self, key)
	end
	return setmetatable({require=require}, meta)
end

local function node(name)
	return function(...)
		local dom_node = {[NAME]=name}
		for i=1,select('#', ...) do
			dom.insert(dom_node, select(i, ...))
		end
		return dom_node
	end
end

return env(node)

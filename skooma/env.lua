local ast = require 'skooma.ast'

local NAME = ast.name

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
		local ast_node = {[NAME]=name}
		for i=1,select('#', ...) do
			ast.insert(ast_node, select(i, ...))
		end
		return ast_node
	end
end

return env(node)

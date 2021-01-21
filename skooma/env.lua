local ast = require 'skooma.ast'

local NAME = ast.name

local function new_env(node)
	local meta = {}
	function meta:__index(key)
		self[key] = assert(node(key))
		return rawget(self, key)
	end
	return setmetatable({}, meta)
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

local env = new_env(node)

function env:proxy(target)
	return setmetatable({}, {
		__index = function(proxy, key)
			return target[key] or self[key]
		end
	})
end

return env

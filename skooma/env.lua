local dom = require 'skooma.dom'

local function env(format)
	local meta = {}
	function meta:__index(key)
		self[key] = assert(dom.node(key, format))
		return rawget(self, key)
	end
	return setmetatable({}, meta)
end

return env

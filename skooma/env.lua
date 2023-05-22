--- Mini-DSL for DOM generation.
-- @module skooma.env
-- @usage
-- 	local env = require 'skooma.env'
-- 	local html = env 'html'
-- 	local node = html.h1 {
-- 		"Example Title";
-- 		html.a {
-- 			href = "https://example.org/",
-- 			"Example Link"
-- 		}
-- 	}
-- 	print(node)

local dom = require 'skooma.dom'

--- Creates a new environment of the given format
local function env(format)
	local meta = {}
	function meta:__index(key)
		self[key] = assert(dom.node(key, format))
		return rawget(self, key)
	end
	return setmetatable({
		raw = dom.raw
	}, meta)
end

return env

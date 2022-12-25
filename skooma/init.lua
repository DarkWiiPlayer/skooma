--- Helper module that loads skooma's submodules
-- @module skooma
-- @usage
-- 	local skooma = require 'skooma'
-- 	assert(skooma.env == require 'skooma.env')

return setmetatable({}, {__index = function(_, key)
	return require("skooma."..tostring(key))
end})

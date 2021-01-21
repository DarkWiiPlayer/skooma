return setmetatable({}, {__index = function(self, key)
	return require("skooma."..tostring(key))
end})

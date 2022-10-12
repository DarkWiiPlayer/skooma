return setmetatable({}, {__index = function(_, key)
	return require("skooma."..tostring(key))
end})

return function(env, paths, name)
	local message
	for path in paths:gmatch("[^;]+") do
		path = path:gsub("?", name:gsub("%.", "/"), 1)
		local file = io.open(path)
		if file then
			local str = file:read("*a")
			return load(str, path, 'tb', env)
		else
			message = message or {""}
			table.insert(message, "Not found: "..path)
		end
	end
	if message then
		return table.concat(message, "\n")
	end
end

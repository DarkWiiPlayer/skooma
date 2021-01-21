local ast = require 'skooma.ast'
local NAME = ast.name

-- TODO: Benchmark whether table.insert is too slow
local function ast_serialize(ast_node, buffer, ...)
	local buffer = buffer or {concat = table.concat}
	local t = type(ast_node)
	if t=="table" and ast_node[NAME] then
		local name = ast_node[NAME]
		table.insert(buffer, "<"..tostring(name)..ast.attribute_list(ast_node)..">")
		for i, child in ipairs(ast_node) do
			ast_serialize(child, buffer, ...)
		end
		table.insert(buffer, "</"..tostring(name)..">")
	elseif t=="table" then
		for i, child in ipairs(ast_node) do
			ast_serialize(child, buffer, ...)
		end
	elseif t=="function" then
		return ast_serialize(ast_node(), buffer, ...)
	else
		table.insert(buffer, tostring(ast_node))
	end
	return buffer
end

return ast_serialize

local ast = {}

ast.name = {token="Unique token to store a tag name"}
local NAME = ast.name

function ast.next_attribute(ast_node, previous)
	local key, value = next(ast_node, previous)
	if key then
		if type(key)=="string" then
			return key, value
		else
			return ast.next_attribute(ast_node, key)
		end
	end
end

function ast.attributes(ast_node)
	return ast.next_attribute, ast_node, nil
end

function ast.insert(ast_node, subtree)
	if type(subtree)~="table" or subtree[NAME] then
		table.insert(ast_node, subtree)
	else
		for index, element in ipairs(subtree) do
			ast.insert(ast_node, element)
		end
		for key, value in ast.attributes(subtree) do
			ast_node[key]=value
		end
	end
end

return ast

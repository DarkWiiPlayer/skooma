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

function toattribute(element)
	if type(element) == "table" then
		return table.concat(element, " ")
	elseif type(element) == "function" then
		return toattribute(element())
	else
		return tostring(element)
	end
end

-- TODO: Benchmark table.insert
function ast.attribute_list(ast_node)
	local buffer = {}
	for attribute, value in ast.attributes(ast_node) do
		table.insert(buffer, ' '..attribute..'="'..toattribute(value)..'"')
	end
	return table.concat(buffer)
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

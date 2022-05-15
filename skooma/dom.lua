local dom = {}

dom.name = {token="Unique token to store a tag name"}
local NAME = dom.name

function dom.next_attribute(dom_node, previous)
	local key, value = next(dom_node, previous)
	if key then
		if type(key)=="string" then
			return key, value
		else
			return dom.next_attribute(dom_node, key)
		end
	end
end

function dom.attributes(dom_node)
	return dom.next_attribute, dom_node, nil
end

function dom.insert(dom_node, subtree)
	if type(subtree)~="table" or subtree[NAME] then
		table.insert(dom_node, subtree)
	else
		for index, element in ipairs(subtree) do
			dom.insert(dom_node, element)
		end
		for key, value in dom.attributes(subtree) do
			dom_node[key]=value
		end
	end
end

return dom

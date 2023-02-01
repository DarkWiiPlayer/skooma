--- Slot helper for skooma templates.
-- Skooma templates are intended to be free of invisible side effects.
-- This helper library offers a way to pass content around different templates.
-- @classmod skooma.slotty
-- @usage
-- 	local html = require 'skooma.env' 'html'
-- 	local slots = require 'skooma.slotty' ()
-- 	-- Use slots
-- 	local document = html.html(html.ul{
-- 		html.li("Home");
-- 		html.li("About");
-- 		slots.nav(); -- Returns an empty table for now
-- 	})
-- 	-- Fill slots
-- 	slots.navbar(html.li("Contact"))
-- 	-- Renders the whole thing
-- 	print(tostring(documnet))

local slot = {}
local NAME = require('skooma').dom.name

local __slot = {__index=slot}

function __slot:__call(item, ...)
	if item ~= nil then
		table.insert(self, item)
	end
	if select("#", ...) > 0 then
		return self(...)
	end
end

local __slotty = {}

function __slotty:__index(key)
	self[key] = setmetatable({[NAME]=false}, __slot)
	return self[key]
end

local function slotty()
	return setmetatable({}, __slotty)
end

return slotty

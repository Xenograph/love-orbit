-- Imports
local util = require 'util'
local vector = require 'vector'

local system = {}
system.__index = system

local function new()
	return setmetatable({}, system)
end

function system:acceleration()
	local accVec = vector()
	for _, b in ipairs(self) do
		local bAcc = vector(0, 0)
		for _, other in ipairs(self) do
			if b ~= other then
				bAcc = bAcc + other:getField(b.pos)
			end
		end
		table.insert(accVec, bAcc)
	end
	return accVec
end

function system:velocity()
	local velVec = vector()
	for _, b in ipairs(self) do
		table.insert(velVec, b.vel)
	end
	return velVec
end

function system:derivative()
	return vector(self:velocity(), self:acceleration())
end

function system:evolve(delta)
	for i, b in ipairs(self) do
		if not b.static then
			b.pos = b.pos + delta[1][i]
			b.vel = b.vel + delta[2][i]
		end
	end
end

function system:clone()
	return util.deepcopy(self)
end

return setmetatable({}, {__call = function(_, ...) return new(...) end})
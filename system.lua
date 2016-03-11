-- Imports
local util = require 'util'
local vector = require 'vector'

local system = {}
system.__index = system

local function new()
	return setmetatable({bodies = {}, ctr = 1}, system)
end

function system:addBody(b)
	self.bodies[self.ctr] = b
	self.ctr = self.ctr + 1
end

function system:acceleration()
	local accVec = vector()
	for _, b in pairs(self.bodies) do
		local bAcc = vector(0, 0)
		for _, other in pairs(self.bodies) do
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
	for _, b in pairs(self.bodies) do
		table.insert(velVec, b.vel)
	end
	return velVec
end

function system:derivative()
	return vector(self:velocity(), self:acceleration())
end

function system:evolve(delta)
	for i, b in pairs(self.bodies) do
		if not b.static then
			b.pos = b.pos + delta[1][i]
			b.vel = b.vel + delta[2][i]
		end
	end
	return self
end

function system:clone()
	return util.deepCopy(self)
end

return setmetatable({}, {__call = function(_, ...) return new(...) end})
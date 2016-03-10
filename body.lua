local body = {}
body.__index = body

local function new(pos, vel, m, r, static)
	return setmetatable({pos = pos, vel = vel, m = m or 0, r = r or 0, static = static or false}, body)
end

function body:getField(pos)
	return self.m*(self.pos - pos)/(self.pos - pos):sqNorm()^1.5
end

return setmetatable({}, {__call = function(_, ...) return new(...) end})
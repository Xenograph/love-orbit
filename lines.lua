local lines = {}
local history = {}

function lines.update(system)
	for i, b in ipairs(system.bodies) do
		if history[i] == nil then
			history[i] = {b.pos}
		else
			table.insert(history[i], b.pos)
		end
	end
end

function lines.draw()
	for _, b in ipairs(history) do
		local lastPt = b[1]
		for i = 2, #b do
			love.graphics.line(lastPt[1], lastPt[2], b[i][1], b[i][2])
			lastPt = b[i]
		end
	end
end

function lines.clear()
	history = {}
end

return lines
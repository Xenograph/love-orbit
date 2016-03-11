-- Imports
local vector = require 'vector'
local body = require 'body'
local util = require 'util'
local system = require 'system'
local lines = require 'lines'
local bodies = require 'bodies'

-- Constants
local timeStep = 1/60

-- Globals
local universe = system()
local timeAcc = 0
local totalTime = 0
local paused = false
local drawLines = true

function love.load()
	for _, b in ipairs(bodies) do
		universe:addBody(b)
	end
end

function love.draw()
	-- Print FPS counter
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	-- Print time
	love.graphics.print("Time: "..string.format("%.2f", totalTime).."s", 10, 25)
	-- Draw bodies
	for i, b in ipairs(universe.bodies) do
		love.graphics.circle("fill", b.pos[1], b.pos[2], b.r, 100)
	end
	-- Draw lines
	if drawLines then lines.draw() end
end

function love.update(dt)
	if not paused then
		timeAcc = timeAcc + dt
		totalTime = totalTime + dt
		while timeAcc >= timeStep do
			stepUniverse(timeStep)
			lines.update(universe)
			timeAcc = timeAcc - timeStep
		end
	end
end

function love.keypressed(key)
	if key == "p" then paused = not paused end
	if key == "l" then drawLines = not drawLines end
	if key == "c" then lines.clear() end
end

function stepUniverse(dt)
	local a = universe:derivative()
	local b = universe:clone():evolve((dt/2)*a):derivative()
	local c = universe:clone():evolve((dt/2)*b):derivative()
	local d = universe:clone():evolve(dt*c):derivative()
	local k = (a + 2*b + 2*c + d)
	universe:evolve((dt/6)*k)
end
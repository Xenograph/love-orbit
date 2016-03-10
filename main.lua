-- Imports
local vector = require 'vector'
local body = require 'body'
local util = require 'util'
local system = require 'system'

-- Constants
local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
local timeStep = 1/60

-- Globals
local universe = system()
local timeAcc = 0
local totalTime = 0

function love.load()
	table.insert(universe, body(vector(centerX, centerY), vector(0, 0), 1000000, 50, true))
	table.insert(universe, body(vector(centerX+100,centerY),vector(0,-math.sqrt(1000000/100)), 10000, 10))
	table.insert(universe, body(vector(centerX+100/2,centerY+100*math.sqrt(3)/2),vector(math.sqrt(1000000/100)*math.sqrt(3)/2,-math.sqrt(1000000/100)/2), 100, 4))
	table.insert(universe, body(vector(centerX+100/2,centerY-100*math.sqrt(3)/2),vector(-math.sqrt(1000000/100)*math.sqrt(3)/2,-math.sqrt(1000000/100)/2), 100, 4))
	table.insert(universe, body(vector(centerX+250,centerY+20),vector(-math.sqrt(10000/20),-math.sqrt(1000000/250)), 1, 2))
end

function love.draw()
	-- Print FPS counter
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	-- Print time
	love.graphics.print("Time: "..string.format("%.2f", totalTime).."s", love.graphics.getWidth()-80, 10)
	-- Draw bodies
	for i, b in ipairs(universe) do
		love.graphics.circle("fill", b.pos[1], b.pos[2], b.r, 100)
	end
end

function love.update(dt)
	timeAcc = timeAcc + dt
	totalTime = totalTime + dt
	while timeAcc >= timeStep do
		stepUniverse(timeStep)
		timeAcc = timeAcc - timeStep
	end
end

function stepUniverse(dt)
	local a = universe:derivative()
	local b = universe:derivative(universe:clone():evolve((dt/2)*a))
	local c = universe:derivative(universe:clone():evolve((dt/2)*b))
	local d = universe:derivative(universe:clone():evolve(dt*c))
	local k = (a + 2*b + 2*c + d)
	universe:evolve((dt/6)*k)
end
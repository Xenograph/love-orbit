-- Imports
local vector = require 'vector'
local body = require 'body'
local util = require 'util'
local system = require 'system'
local lines = require 'lines'

-- Constants
local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
local timeStep = 1/60

-- Globals
local universe = system()
local timeAcc = 0
local totalTime = 0
local paused = false
local drawLines = true

function love.load()
	universe:addBody(body(vector(centerX, centerY), vector(0, 0), 1000000, 10, true))
	universe:addBody(body(vector(centerX+20,centerY),vector(0,-math.sqrt(1000000/20)), 10000, 10))
	universe:addBody(body(vector(centerX+100/2,centerY+100*math.sqrt(3)/2),vector(math.sqrt(1000000/100)*math.sqrt(3)/2,-math.sqrt(1000000/100)/2), 100, 4))
	universe:addBody(body(vector(centerX+100/2,centerY-100*math.sqrt(3)/2),vector(-math.sqrt(1000000/100)*math.sqrt(3)/2,-math.sqrt(1000000/100)/2), 100, 4))
	universe:addBody(body(vector(centerX+250,centerY+20),vector(-math.sqrt(10000/20),-math.sqrt(1000000/250)), 1, 2))
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
end

function stepUniverse(dt)
	local a = universe:derivative()
	local b = universe:clone():evolve((dt/2)*a):derivative()
	local c = universe:clone():evolve((dt/2)*b):derivative()
	local d = universe:clone():evolve(dt*c):derivative()
	local k = (a + 2*b + 2*c + d)
	universe:evolve((dt/6)*k)
end
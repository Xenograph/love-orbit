-- Imports
local vector = require 'vector'
local body = require 'body'

-- Constants
local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2

local bodies = {
	body(vector(centerX, centerY), vector(0, 0), 1000000, 10, true),
	body(vector(centerX+20,centerY),vector(0,-math.sqrt(1000000/20)), 10000, 10),
	body(vector(centerX+100/2,centerY+100*math.sqrt(3)/2),vector(math.sqrt(1000000/100)*math.sqrt(3)/2,-math.sqrt(1000000/100)/2), 100, 4),
	body(vector(centerX+100/2,centerY-100*math.sqrt(3)/2),vector(-math.sqrt(1000000/100)*math.sqrt(3)/2,-math.sqrt(1000000/100)/2), 100, 4),
	body(vector(centerX+250,centerY+20),vector(0,-math.sqrt(1000000/250)), 1, 2)
}

return bodies
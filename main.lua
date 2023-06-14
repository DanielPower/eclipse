local util = require("util")

local time
local files
local toyIndex = 1
local toy
local errorMessage

local function loadToy()
	local status, result = pcall(function()
		toy = util.newToy("shaders/" .. files[toyIndex], love.graphics.getWidth(), love.graphics.getHeight(), time)
	end)
	if status then
		errorMessage = nil
	elseif not errorMessage then
		print(result)
		errorMessage = result
	end
end

function love.load()
	time = 0
	files = love.filesystem.getDirectoryItems("shaders")
	loadToy()
end

function love.update(dt)
	time = time + dt
	toy.update(time)
	local modified = love.filesystem.getInfo("shaders/" .. files[toyIndex]).modtime
	if modified ~= toy.modified then
		loadToy()
	end
end

function love.draw()
	toy.draw()
	if errorMessage then
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setNewFont(16)
		love.graphics.printf(errorMessage, 10, 10, love.graphics.getWidth() - 20)
	end
end

function love.resize(w, h)
	toy.resize(w, h)
end

function love.keypressed(key)
	if key == "j" then
		toyIndex = (toyIndex % #files) + 1
		loadToy()
	end
	if key == "k" then
		toyIndex = (toyIndex - 2) % #files + 1
		loadToy()
	end
	if key == "r" then
		time = 0
		loadToy()
	end
end

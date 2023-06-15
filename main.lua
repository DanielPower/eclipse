local util = require("util")

local toyState
local errorMessage
local files
local toyIndex = 4

local function loadToy()
	local filePath = "shaders/" .. files[toyIndex]
	local status, result = pcall(function()
		return util.newShader(filePath)
	end)
	if status then
		errorMessage = nil
		toyState.shader = result
		toyState.modified = love.filesystem.getInfo(filePath).modtime
	elseif not errorMessage then
		print(result)
		errorMessage = result
	end
end

function love.load()
	toyState = {
		time = 0,
		frame = 0,
		shader = nil,
		mouse = { 0, 0 },
		size = { love.graphics.getWidth(), love.graphics.getHeight() },
		modified = 0,
	}
	files = love.filesystem.getDirectoryItems("shaders")
	loadToy()
end

function love.update(dt)
	if toyState.shader then
		toyState.time = toyState.time + dt
		toyState.frame = toyState.frame + 1
		local modified = love.filesystem.getInfo("shaders/" .. files[toyIndex]).modtime
		if modified ~= toyState.modified then
			loadToy()
		end
	end
end

function love.draw()
	util.renderShader(toyState)
	if errorMessage then
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setNewFont(16)
		love.graphics.printf(errorMessage, 10, 10, love.graphics.getWidth() - 20)
	end
end

function love.resize(w, h)
	toyState.size = { w, h }
end

function love.keypressed(key)
	if key == "j" then
		toyIndex = (toyIndex % #files) + 1
		toyState.time = 0
		toyState.frame = 0
		loadToy()
	end
	if key == "k" then
		toyIndex = (toyIndex - 2) % #files + 1
		toyState.time = 0
		toyState.frame = 0
		loadToy()
	end
	if key == "r" then
		toyState.time = 0
		toyState.frame = 0
		loadToy()
	end
end

function love.mousemoved(x, y)
	if love.mouse.isDown(1) then
		toyState.mouse = { x, y }
	end
end

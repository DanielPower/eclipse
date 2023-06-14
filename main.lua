local util = require("util")

local time
local shader
local files

function love.load()
	time = 0
	shader = util.parseShader("introduction")
end

function love.update(dt)
	time = time + dt
	shader:send("iTime", time)
end

function love.draw()
	love.graphics.setShader(shader)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function love.resize(w, h)
	shader:send("iResolution", { love.graphics.getWidth(), love.graphics.getHeight() })
end

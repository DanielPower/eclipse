local fun = require("lib.fun")
local util = {}

function util.newShader(file)
	local environment = {}
	-- Put a loop here to pcall newShader, parsing the error and adding uniform values
	-- until it succeeds. Return the uniform value names as environment so they can be
	-- included in state and appropriate `send` calls can be made
	return love.graphics.newShader([[
#pragma language glsl3
uniform float iTime;
uniform vec2 iResolution;
uniform int iFrame;
uniform vec2 iMouse;
]] .. love.filesystem.read(file) .. [[
vec4 effect(vec4 fragColor, Image tex, vec2 textureCoords, vec2 screenCoords) {
  mainImage(fragColor, screenCoords);
  return fragColor;
}
]])
end

function util.renderShader(state)
	fun.each(function(key, value)
		pcall(function()
			state.shader:send(key, value)
		end)
	end, {
		iTime = state.time,
		iResolution = state.size,
		iFrame = state.frame,
		iMouse = state.mouse,
	})
	if state.shader then
		love.graphics.setShader(state.shader)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setShader()
	end
end

function util.renderMenu(files, currentIndex, x, y, width, height)
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", x, y, width, height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setNewFont(14)
	for i, file in ipairs(files) do
		if i == currentIndex then
			love.graphics.setColor(0.3, 0.3, 0.3, 1)
			love.graphics.rectangle("fill", 0, (i - 1) * 20, width, 20)
			love.graphics.setColor(1, 1, 1, 1)
		end
		love.graphics.print(file, 5, y + 3 + (i - 1) * 20)
	end
end

return util

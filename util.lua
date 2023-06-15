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
]] .. love.filesystem.read(file) .. [[
vec4 effect(vec4 fragColor, Image tex, vec2 textureCoords, vec2 screenCoords) {
  mainImage(fragColor, screenCoords);
  return fragColor;
}
]])
end

function util.renderShader(state)
	state.shader:send("iTime", state.time)
	state.shader:send("iResolution", state.size)
	if state.shader then
		love.graphics.setShader(state.shader)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setShader()
	end
end

return util

local util = {}

function util.parseShader(name)
	local shaderString = [[
#pragma language glsl3
uniform float iTime;
uniform vec2 iResolution;
]] .. love.filesystem.read("shaders/" .. name .. ".glsl") .. [[
vec4 effect(vec4 fragColor, Image tex, vec2 textureCoords, vec2 screenCoords) {
  mainImage(fragColor, screenCoords);
  return fragColor;
}
]]
	local shader = love.graphics.newShader(shaderString)
	shader:send("iTime", 0)
	shader:send("iResolution", { love.graphics.getWidth(), love.graphics.getHeight() })
	return shader
end

return util

local util = {}

function util.newToy(file, initialWidth, initialHeight, initialTime)
	local shader = love.graphics.newShader([[
#pragma language glsl3
uniform float iTime;
uniform vec2 iResolution;
]] .. love.filesystem.read(file) .. [[
vec4 effect(vec4 fragColor, Image tex, vec2 textureCoords, vec2 screenCoords) {
  mainImage(fragColor, screenCoords);
  return fragColor;
}
]])
	local toy = {}
	toy.modified = love.filesystem.getInfo(file).modtime
	local time = initialTime
	local width = initialWidth
	local height = initialHeight
	shader:send("iTime", time)
	shader:send("iResolution", { width, height })

	function toy.update(newTime)
		time = newTime
		shader:send("iTime", time)
	end

	function toy.resize(w, h)
		width = w
		height = h
		shader:send("iResolution", { width, height })
	end

	function toy.draw()
		love.graphics.setShader(shader)
		love.graphics.rectangle("fill", 0, 0, width, height)
		love.graphics.setShader()
	end

	return toy
end

return util

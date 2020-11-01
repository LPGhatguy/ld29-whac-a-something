local L = (...)

local background

background = {
	new = function(self, whack)
		self.background_image = love.graphics.newImage("asset/image/background-3.png")

		return self
	end,

	draw = function(self)
		local rw, rh = 1920, 1080
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / rw, sh / rh)

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.background_image, (sw - rw * ratio) / 2, 0, 0, ratio)
	end
}

return background
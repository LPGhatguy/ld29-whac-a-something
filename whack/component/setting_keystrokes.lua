local L = (...)

return {
	new = function(self, whack)
		self.whack = whack
		return self
	end,

	keypressed = function(self, key)
		if (key == "f11") then
			love.window.setFullscreen(not love.window.getFullscreen())
		elseif (key == "f2") then
			love.graphics.newScreenshot(true):encode(os.time() .. ".png")
		end
	end
}
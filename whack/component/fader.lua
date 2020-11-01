local L = (...)

local fader = {
	state = 0,
	alpha = 0,
	time = 0,
	rate = 500,
	target = "",

	new = function(self, whack)
		self.whack = whack

		return self
	end,

	update = function(self, delta)
		self.time = self.time + delta

		if (self.state == 1) then
			self.alpha = self.alpha + self.rate * delta

			if (self.alpha >= 255) then
				self.alpha = 255
				self.state = 2
				self.whack:set_real_state(self.target)
			end
		elseif (self.state == 2) then
			self.alpha = self.alpha - self.rate * delta

			if (self.alpha <= 0) then
				self.alpha = 0
				self.state = 0
			end
		end
	end,

	draw = function(self)
		if (self.state > 0) then
			love.graphics.setColor(0, 0, 0, self.alpha)
			love.graphics.rectangle("fill", 0, 0, love.window:getDimensions())
		end
	end
}

return fader
local L = (...)
local oop = L:get("lcore.utility.oop")
local font = L:get("lcore.graphics.font")

local debug_ui

local debug_text = [[
DEBUG
FPS: %s
GAME PAUSED: %s
GAME STATES: %s
]]

debug_ui = oop:class()({
	enabled = false,

	_new = function(self, new, whack)
		new.whack = whack

		return new
	end,

	draw = function(self)
		if (self.enabled) then
			love.graphics.setColor(255, 255, 255)
			love.graphics.setFont(font:get(12))
			love.graphics.print(debug_text:format(
				love.timer.getFPS(),
				self.whack.paused and "YES" or "NO",
				table.concat(self.whack.state, ", ")
			), 0, 0)
		end
	end,

	update = function(self, delta)
	end,

	keypressed = function(self, key)
		if (key == "`") then
			self.enabled = not self.enabled
			self.whack.states.logic.debug_draw = self.enabled
		end
	end
})

return debug_ui
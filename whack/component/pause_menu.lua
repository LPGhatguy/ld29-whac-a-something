local L = (...)
local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local font = L:get("lcore.graphics.font")
local textbutton = oop:mix(
	"lcore.graphics.ui.textlabel",
	"lcore.graphics.ui.button"
)

local pause_menu

pause_menu = oop:class(event)({
	game_mode = "",

	_new = function(self, new, whack)
		new.whack = whack

		new:resize()

		return new
	end,

	resize = function(self)
		self:destroy()

		local sw, sh = love.window.getDimensions()

		self.resume_button = textbutton:new(self, "Resume", sw * 0.25, 200, sw * 0.5, 50)
		self.resume_button.click = function()
			self.whack:set_state(self.game_mode, true)
		end

		self.quit_button = textbutton:new(self, "Quit", sw * 0.25, 270, sw * 0.5, 50)
		self.quit_button.click = function()
			self.whack.states.logic:quit()
		end
	end,

	state_changing = function(self, to)
		if (not to.pause_menu) then
			self.whack.paused = false
		end
	end,

	state_changed = function(self, from)
		self.whack.paused = true

		love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
	end,

	draw = function(self)
		love.graphics.setColor(0, 0, 0, 192)
		love.graphics.rectangle("fill", 0, 0, love.window.getDimensions())

		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font:get(100))
		love.graphics.printf("PAUSED", 0, 50, love.window.getWidth(), "center")

		self:fire("draw")
	end
})

return pause_menu
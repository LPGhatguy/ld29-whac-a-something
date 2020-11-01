local L = (...)
local score = L:get("whack.scorekeeper")
local font = L:get("lcore.graphics.font")

local minute

minute = {
	finished = false,
	time_left = 60,
	next_spawn = 0,
	spawn_rate = 0,
	spawns = 0,

	new = function(self, whack)
		self.whack = whack

		return self
	end,

	init = function(self)
		self.time_left = 60
		self.finished = false

		self.spawn_rate = 2
		self.next_spawn = self.time_left - self.spawn_rate
		self.spawns = 0
		self.whack.states.logic.max_spawns = 1

		self:update_diff()
	end,

	finish = function(self)
		self.finished = true
		self.whack.states.logic:finish()
		self.whack:set_state("results_minute")

		if (self.time_left <= 0) then
			local logic = self.whack.states.logic

			if (logic.kills > score.minute_most_kills) then
				score.minute_most_kills = logic.kills
			end

			local accuracy = math.floor(100 * logic.kills / (logic.swings + logic.got_away))
			if (accuracy ~= accuracy) then
				accuracy = 0
			end

			if (accuracy > score.minute_most_accuracy) then
				score.minute_most_accuracy = accuracy
			end

			score:save()
		end
	end,

	update_diff = function(self)
		local x = 60 - self.time_left

		self.spawn_rate = math.max(0, 2 - 0.22 * (x^0.5))
		self.whack.states.logic.spawn_lifetime = self.spawn_rate * 2
		self.whack.states.logic.max_spawns = math.ceil((x + 1) / 15)
	end,

	state_changed = function(self, from)
		if (not from.logic) then
			self:init()
		end
	end,

	update = function(self, delta)
		self:update_diff()
		local logic = self.whack.states.logic

		if (not self.finished) then
			self.time_left = self.time_left - delta

			if (self.time_left <= 0) then
				self:finish()
			else
				if (self.time_left < self.next_spawn) then
					self.next_spawn = self.time_left - self.spawn_rate
					logic:spawn_whackable()
				end
			end
		end
	end,

	draw = function(self)
		local rw, rh = 1920, 1080
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / rw, sh / rh)

		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font:get(80 * ratio))
		love.graphics.printf(([[
			MINUTE MODE
			%s SECONDS LEFT
		]]):format(
			math.ceil(self.time_left)
		), 0, 40, love.window.getWidth(), "center")
	end
}

return minute
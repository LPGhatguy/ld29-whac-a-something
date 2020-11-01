local L = (...)
local font = L:get("lcore.graphics.font")
local score = L:get("whack.scorekeeper")

local endless

local function pad(n)
	if (n < 10) then
		return "0" .. n
	else
		return n
	end
end

endless = {
	time = 0,
	finished = false,
	lives = 5,
	next_spawn = 0,
	spawn_rate = 2,
	spawns = 0,

	new = function(self, whack)
		self.whack = whack

		return self
	end,

	finish = function(self)
		self.finished = true
		self.whack.states.logic:finish()
		self.whack:set_state("results_endless")

		local logic = self.whack.states.logic

		if (logic.kills > score.endless_most_kills) then
			score.endless_most_kills = logic.kills
		end

		if (self.time > score.endless_most_time) then
			score.endless_most_time = self.time
		end

		score:save()
	end,

	state_changed = function(self, from)
		if (not from.logic) then
			self:init()
		end
	end,

	init = function(self)
		self.finished = false
		self.time = 0
		self.lives = 5
		self.spawn_rate = 2
		self.next_spawn = self.time + self.spawn_rate
		self.spawns = 0
		self.whack.states.logic.max_spawns = 3
	end,

	update_diff = function(self)
		local x = self.time

		self.spawn_rate = math.max(0, 2 - (1 / 80) * x)
		self.whack.states.logic.spawn_lifetime = math.max(0.3, self.spawn_rate * 1.5)
		self.whack.states.logic.max_spawns = 3
	end,

	update = function(self, delta)
		self:update_diff()
		local logic = self.whack.states.logic

		if (not self.finished) then
			self.time = self.time + delta

			local lives_left = self.lives - logic.got_away
			self.lives_left = lives_left

			if (lives_left <= 0) then
				self:finish()
			elseif (self.time >= self.next_spawn) then
				self.next_spawn = self.time + self.spawn_rate
				logic:spawn_whackable()
			end
		end
	end,

	draw = function(self)
		local rw, rh = 1920, 1080
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / rw, sh / rh)

		love.graphics.setFont(font:get(80 * ratio))
		love.graphics.printf(([[
			ENDLESS MODE
			%d LIVES LEFT
			%s:%s
		]]):format(
			self.lives_left or self.lives,
			pad(math.floor(self.time / 60)),
			pad(math.floor(self.time % 60))
		), 0, 0, love.window.getWidth(), "center")
	end
}

return endless
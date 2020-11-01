local L = (...)
local utable = L:get("lcore.utility.table")
local event = L:get("lcore.service.event")
local oop = L:get("lcore.utility.oop")

local whack

local function fire_from(self, source, event_name, ...)
	for key, name in ipairs(source) do
		local entry = self.states[name]
		if (entry) then
			if (entry[event_name]) then
				entry[event_name](entry, ...)
			elseif (entry.fire) then
				entry:fire(event_name, ...)
			end
		end
	end
end

whack = oop:class()({
	sound = L:get("whack.sound"),
	paused = false,

	state_names = {
		title = "whack.component.title",
		main_menu = "whack.component.main_menu",
		pause_menu = "whack.component.pause_menu",
		debug_ui = "whack.component.debug_ui",
		logic = "whack.component.logic",
		accomplishments = "whack.component.accomplishments",
		mode_endless = "whack.component.mode_endless",
		mode_minute = "whack.component.mode_minute",
		menu_music = "whack.component.menu_music",
		sound = "whack.sound",
		setting_keystrokes = "whack.component.setting_keystrokes",
		results_minute = "whack.component.results_minute",
		results_endless = "whack.component.results_endless",
		game_background = "whack.component.game_background",
		game_music = "whack.component.game_music",
		fader = "whack.component.fader"
	},
	state_sets = {
		title = {
			"title",
			"menu_music"
		},

		main_menu = {
			"main_menu",
			"menu_music"
		},

		accomplishments = {
			"accomplishments",
			"menu_music"
		},

		game_endless = {
			"game_music",
			"game_background",
			"mode_endless",
			"logic"
		},

		game_minute = {
			"game_music",
			"game_background",
			"mode_minute",
			"logic"
		},

		results_minute = {
			"results_minute"
		},

		results_endless = {
			"results_endless"
		},

		game_paused = {
			"game_music",
			"game_background",
			"logic",
			"pause_menu"
		}
	},
	global = {
		"fader",
		"debug_ui",
		"sound",
		"setting_keystrokes"
	},
	states = {},
	state = nil,

	_new = function(self, new)
		for key, value in pairs(new.state_names) do
			new.states[key] = L:get(value):new(new)
		end

		for key, value in pairs(new.state_sets) do
			utable:invert(value, value)
		end

		utable:invert(new.global)

		return new
	end,

	set_state = function(self, state_name, no_fade)
		if (no_fade) then
			self:set_real_state(state_name)
		else
			self.states.fader.target = state_name
			self.states.fader.state = 1
		end
	end,

	set_real_state = function(self, state_name)
		if (self.state_sets[state_name]) then
			self:set_state_set(self.state_sets[state_name])
		else
			L:warn("Could not find state set '" .. tostring(state_name) .. "'")
		end
	end,

	set_state_set = function(self, state)
		local old_state = self.state or {}

		self:fire("state_changing", state)

		self.state = state

		self:fire("state_changed", old_state)
	end,

	resize = function(self)
		print("Resizing window...")
		--self:_new(self, self)
		for key, value in pairs(self.states) do
			if (value.resize) then
				value:resize()
			end
		end
	end,

	fire = function(self, event_name, ...)
		if (self.state) then
			fire_from(self, self.state, event_name, ...)
		end

		fire_from(self, self.global, event_name, ...)
	end
})

return whack
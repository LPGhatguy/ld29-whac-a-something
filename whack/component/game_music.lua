local L = (...)
local oop = L:get("lcore.utility.oop")
local sound = L:get("whack.sound")

local game_music

game_music = oop:class()({
	state_changing = function(self, to)
		if (not to.game_music) then
			sound:fade("music-game")
		end
	end,

	state_changed = function(self, from)
		if (not from.game_music) then
			sound:play("music-game")
		end
	end
})

return game_music
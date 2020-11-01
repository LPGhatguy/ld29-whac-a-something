local L = (...)
local oop = L:get("lcore.utility.oop")
local sound = L:get("whack.sound")

local menu_music

menu_music = oop:class()({
	state_changing = function(self, to)
		if (not to.menu_music) then
			sound:fade("music-title")
		end
	end,

	state_changed = function(self, from)
		if (not from.menu_music) then
			sound:play("music-title")
		end
	end
})

return menu_music
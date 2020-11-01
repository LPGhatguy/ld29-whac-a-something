local L = (...)
local sound = L:get("whack.sound")

sound:load_music("music-title", true)
sound:load_music("music-game", true)
sound:load_music("music-results", true)

sound:load_effect("hammer-hit")
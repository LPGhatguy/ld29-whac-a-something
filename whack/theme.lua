local L = (...)
local font = L:get("lcore.graphics.font")

font.default_face = "asset/font/distro.ttf"

local rectangle = L:get("lcore.graphics.ui.rectangle")
rectangle.background_color = {50, 50, 50, 200}
rectangle.border_color = {128, 128, 128}
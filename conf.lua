function love.conf(t)
    t.identity = "ld29-whackastuff"
    t.appendidentity = true
    t.console = true

    t.window.title = "WHAC-A-SOMETHING"
    t.window.icon = nil

    t.window.width = 1280
    t.window.height = 720
    t.window.minwidth = 800
    t.window.minheight = 600

    t.window.borderless = false
    t.window.resizable = true
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.display = 1

    t.window.vsync = true
    t.window.fsaa = 0

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.window = true
end

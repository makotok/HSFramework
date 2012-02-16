-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- sprite1
local sprite1 = Sprite:new("samples/images/cathead.png", {width = 60, height = 60, parent = scene})
local sprite2 = Sprite:new("samples/images/cathead.png", {width = 60, height = 60, y = 70, parent = scene})

-- animate
local animation = Animation:new({sprite1, sprite2}, 1):move(60, 0):fadeOut():fadeIn():rotate(360):play()

scene:openScene()


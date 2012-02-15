-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- sprite1
local sprite1 = Sprite:new("samples/images/cathead.png", {parent = scene})

-- animate
local animation = Animation:new(sprite1, 1):move(50, 50):fadeOut():fadeIn():rotate(360):play()

scene:openScene()


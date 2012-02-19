-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- sprite1
local sprite1 = Sprite:new("samples/images/cathead.png", {x = 10, y = 10, parent = scene})

-- spritesheet
local sprite2 = SpriteSheet:new("samples/images/actor.png", 3, 4, {x = 20 + sprite1.width, y = 10, parent = scene})
sprite2:moveFrames({1, 2, 3, 2, 1}, 0.25)

-- fps monitor
FPSMonitor:new(5):play()

scene:openScene()

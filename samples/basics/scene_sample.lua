-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

local group = Group:new({layout = VBoxLayout:new(), parent = scene})

-- sprite1
local sprite1 = Sprite:new("samples/images/back_1.png", {parent = group})
local sprite2 = Sprite:new("samples/images/cathead.png", {x = 10, y = 10, parent = group})

--[[
Animation:new(scene, 1):fadeOut():fadeIn():move(240, 0):parallel(
    Animation:new(scene.topLayer.camera, 1):rotate(360)
):play()
--]]
Animation:new(scene, 1):copy({x = -25, y = 0}):parallel(
    Animation:new(scene, 1):move(25, 0),
    Animation:new(scene, 1):fadeIn()
):play()

scene:openScene()
-- scene
anime_group_sample = Scene:new()
local scene = anime_group_sample

-- open event
function scene:onOpen(event)
    local sprite1 = Sprite:new("samples/resources/cathead.png", {width = 60, height = 60, parent = scene})
    local sprite2 = Sprite:new("samples/resources/cathead.png", {width = 60, height = 60, y = 70, parent = scene})
    
    local animation = Animation:new({sprite1, sprite2}, 1):move(60, 0):fadeOut():fadeIn():rotate(360):play()
end

-- close event
function scene:onClose(event)
end

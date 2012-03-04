-- scene
anime_fade_sample = Scene:new()
local scene = anime_fade_sample

-- open event
function scene:onOpen()
    local sprite1 = Sprite:new("samples/resources/cathead.png", {parent = scene})
    local animation = Animation:new(sprite1, 1):move(50, 50):fadeOut():fadeIn():rotate(360):play()    
end

-- close event
function scene:onClose(event)
end

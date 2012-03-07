module(..., package.seeall)

function onCreate()
    sprite1 = Sprite:new("samples/resources/cathead.png", {width = 60, height = 60, parent = scene})
    sprite2 = Sprite:new("samples/resources/cathead.png", {width = 60, height = 60, y = 70, parent = scene})
    
    animation = Animation:new({sprite1, sprite2}, 1):move(60, 0):fadeOut():fadeIn():rotate(360):play()
end

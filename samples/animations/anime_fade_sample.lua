module(..., package.seeall)

function onCreate()
    sprite1 = Sprite:new("samples/resources/cathead.png", {parent = scene})
    animation = Animation:new(sprite1, 1):move(50, 50):fadeOut():fadeIn():rotate(360):play()    
end

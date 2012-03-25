local display = require("hs/core/display")

module(..., package.seeall)

function onCreate()
    sprite1 = display:newSprite("samples/resources/cathead.png")
end

function onStart()
    animation = display:newAnimation(sprite1, 1):move(50, 50):fadeOut():fadeIn():rotate(360):play()    
end
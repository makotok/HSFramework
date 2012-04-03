local display = require("hs/core/display")

module(..., package.seeall)

function onCreate()
    sprite1 = display:newSprite("samples/resources/cathead.png")
end

function onStart()
    animation = display:newAnimation(sprite1, 1):moveLocation(50, 50):fadeOut():fadeIn():moveRotation(0, 0, 360):play()    
end
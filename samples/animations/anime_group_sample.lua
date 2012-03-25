local display = require("hs/core/display")

module(..., package.seeall)

function onCreate()
    sprite1 = display:newSprite("samples/resources/cathead.png", {width = 60, height = 60})
    sprite2 = display:newSprite("samples/resources/cathead.png", {width = 60, height = 60, y = 70})
end

function onStart()
    animation = display:newAnimation({sprite1, sprite2}, 1):move(60, 0):fadeOut():fadeIn():rotate(360):play()
end
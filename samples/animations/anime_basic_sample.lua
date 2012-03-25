local display = require("hs/core/display")
local Logger = require("hs/core/Logger")

module(..., package.seeall)

function onCreate()
    sprite1 = display:newSprite("samples/resources/cathead.png")

    animation = display:newAnimation(sprite1, 1)
        :copy({x = 0, y = 0, rotation = 0, scaleX = 1, scaleY = 1})
        :move(sprite1.width / 2, sprite1.height / 2)
        :wait(3)
        :parallel(
            display:newAnimation(sprite1, 1):rotate(90),
            display:newAnimation(sprite1, 1):scale(1, 1)
        )
end

function onStart()
    animate()
end

function onTouchDown(event)
    animate()
end

function animate()
    if animation.running then
        animation:stop()
    else
        animation:play({onComplete = function(e) Logger.info("animation complete!") end})
    end
end

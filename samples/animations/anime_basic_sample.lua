module(..., package.seeall)

function onCreate()
    sprite1 = Sprite:new("samples/resources/cathead.png", {parent = scene})

    animation = Animation:new(sprite1, 1)
        :copy({x = 0, y = 0, rotation = 0, scaleX = 1, scaleY = 1})
        :move(sprite1.width / 2, sprite1.height / 2)
        :wait(3)
        :parallel(
            Animation:new(sprite1, 1):rotate(90),
            Animation:new(sprite1, 1):scale(1, 1)
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

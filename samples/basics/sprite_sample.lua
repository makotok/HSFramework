module(..., package.seeall)

function onCreate()
    -- sprite
    sprite1 = Sprite:new("samples/resources/cathead.png", {x = 10, y = 10, parent = scene})
    
    -- spritesheet
    sprite2 = SpriteSheet:new("samples/resources/actor.png", 3, 4, {x = 20 + sprite1.width, y = 10, parent = scene})
    
    -- graphics
    g = Graphics:new({x = 10, y = 20, width = 50, height = 50, parent = scene})
    g:setPenColor(0, 1, 0, 1):fillRect(0, 0, 50, 50)
    g:setPenColor(1, 0, 0, 1):setPenWidth(1):drawRect(0, 0, 50, 50)
    
end

function onStart()
    -- sprite1 animation
    sprite1:move(50, 50, 1, nil,
        function(target)
            target:fadeOut(1, nil, function(target) target:fadeIn(1) end)
        end
    )

    -- sprite2 animation
    sprite2:moveFrames({1, 2, 3, 2, 1}, 0.25)
end

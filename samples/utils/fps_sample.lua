module(..., package.seeall)

function onCreate()
    sprite1 = Sprite:new("samples/resources/cathead.png", {x = 10, y = 10, parent = scene})
    sprite2 = SpriteSheet:new("samples/resources/actor.png", 3, 4, {x = 20 + sprite1.width, y = 10, parent = scene})
end

function onStart()
    -- sprite2 animation
    sprite2:moveFrames({1, 2, 3, 2, 1}, 0.25)
    
    -- fps monitor
    Log.level = Log.LEVEL_DEBUG
    FPSMonitor:new(5):play()
end
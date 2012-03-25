local display = require "hs/core/display"
local FPSMonitor = require "hs/util/FPSMonitor"
local Logger = require "hs/core/Logger"

module(..., package.seeall)

function onCreate()
    sprite1 = display:newSprite("samples/resources/cathead.png", {x = 10, y = 10})
    sprite2 = display:newSpriteSheet("samples/resources/actor.png", 3, 4, {x = 20 + sprite1.width, y = 10})
end

function onStart()
    -- sprite2 animation
    sprite2:moveFrames({1, 2, 3, 2, 1}, 0.25)
    
    -- fps monitor
    Logger.level = Logger.LEVEL_DEBUG
    FPSMonitor:new(5):play()
end
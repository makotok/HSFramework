local display = require("hs/core/display")

module(..., package.seeall)

function onCreate()
    -- group
    group = display:newGroup({layout = display:newVBoxLayout()})
    
    -- sprite
    sprite1 = display:newSprite("samples/resources/cathead.png", {width = 64, height = 64, parent = group})
    sprite2 = display:newSprite("samples/resources/cathead.png", {width = 64, height = 64, parent = group, flipX = true})
    sprite3 = display:newSprite("samples/resources/cathead.png", {width = 64, height = 64, parent = group, flipY = true})
    sprite4 = display:newSprite("samples/resources/cathead.png", {width = 64, height = 64, parent = group, flipX = true, flipY = true})
end

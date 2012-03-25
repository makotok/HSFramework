local display = require("hs/core/display")

module(..., package.seeall)

function onCreate(params)
    -- The child who can add to Scene is only Layer.
    -- When Group is specified as Scene, a child is added to TopLayer. 
    
    -- layer1
    layer1 = display:newLayer()
    layer1:addChild(display:newSprite("samples/resources/cathead.png", {x = 0, y = 0}))
    display:newSprite("samples/resources/cathead.png", {x = 64, y = 64, parent = layer1})
    
    -- layer2
    layer2 = display:newLayer()
    layer2:addChild(display:newSprite("samples/resources/cathead.png", {x = 32, y = 32}))
    layer2:addChild(display:newSprite("samples/resources/cathead.png", {x = 96, y = 96}))
    
end

function onStart()
    layer2.camera:move(100, 100, 3)
end

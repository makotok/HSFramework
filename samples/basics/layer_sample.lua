-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- The child who can add to Scene is only Layer.
-- When Group is specified as Scene, a child is added to TopLayer. 

-- layer1
local layer1 = Layer:new()
layer1.parent = scene
layer1:addChild(Sprite:new("samples/basics/cathead.png", {x = 0, y = 0}))
layer1:addChild(Sprite:new("samples/basics/cathead.png", {x = 64, y = 64}))

-- layer2
local layer2 = Layer:new()
layer2.parent = scene
layer2:addChild(Sprite:new("samples/basics/cathead.png", {x = 32, y = 32}))
layer2:addChild(Sprite:new("samples/basics/cathead.png", {x = 96, y = 96}))

-- camera
layer2.camera:moveLocation(100, 100, 3)

-- bad pattern!
-- screen location move.
--layer2:moveLocation(100, 100, 3)


-- show scene
scene:openScene()

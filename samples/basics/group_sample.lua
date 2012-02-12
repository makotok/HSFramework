-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- group1
local group1 = Group:new()
group1.layout = BoxLayout:new()
group1.parent = scene

-- group2
local group2 = Group:new()
group2.layout = VBoxLayout:new()
group2.parent = group1
table.copy({pTop = 0, pLeft = 0, pBottom = 0, pRight = 0}, group2)

-- group3
local group3 = Group:new()
group3.layout = HBoxLayout:new()
group3.parent = group1
table.copy({pTop = 0, pLeft = 0, pBottom = 0, pRight = 0}, group3)

-- sprite1
for i = 1, 3 do
    local sprite = Sprite:new("samples/images/cathead.png")
    sprite.width = 64
    sprite.height = 64
    sprite.parent = group2
end

-- sprite2
for i = 1, 3 do
    local sprite = Sprite:new("samples/images/cathead.png")
    sprite.width = 64
    sprite.height = 64
    sprite.parent = group3
end

-- update layout
group2:updateLayout()
group3:updateLayout()
group1:updateLayout()

scene:openScene()

-- debug print
Log.debug("group1:" .. group1.x .. "," .. group1.y .. "," .. group1.width .. "," .. group1.height)
Log.debug("group2:" .. group2.x .. "," .. group2.y .. "," .. group2.width .. "," .. group2.height)
Log.debug("group3:" .. group3.x .. "," .. group3.y .. "," .. group3.width .. "," .. group3.height)

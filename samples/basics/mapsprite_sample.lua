-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- mapsprite
local mapSprite = MapSprite:new("samples/images/numbers.png",
    {gridWidth = 8, gridHeight = 8, tileWidth = 8, tileHeight = 8, parent = scene})

--[[
for i = 1, 8 do
    local start = (i - 1) * 8 
    mapSprite:setRow(i, start + 1, start + 2, start + 3, start + 4, start + 5, start + 6, start + 7, start + 8)
end
--]]
local mapData = {}
for i = 1, 8 do
    local row = {}
    for j = 1, 8 do
        table.insert(row, (i - 1) * 8 + j)
    end
    table.insert(mapData, row)
end
mapSprite:setMapData(mapData)
mapSprite:setTile(2, 2, 0)

scene:openScene()


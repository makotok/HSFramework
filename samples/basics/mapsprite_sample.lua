module(..., package.seeall)

function onCreate()
    -- mapsprite
    local mapSprite = MapSprite:new("samples/resources/numbers.png", 8, 8, 8, 8)
    mapSprite.parent = scene
    
    for i = 1, 8 do
        local start = (i - 1) * 8 
        mapSprite:setRowData(i, start + 1, start + 2, start + 3, start + 4, start + 5, start + 6, start + 7, start + 8)
    end
    mapSprite:setTile(2, 2, 0)
end

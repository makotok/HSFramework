-- scene
tmxmap1_sample = Scene:new()
local scene = tmxmap1_sample

function scene:onOpen(event)
    local map = TMXMapLoader:new():load("samples/resources/demomap.tmx")
    map.resourceDirectory = "samples/resources/"
    map:drawMap(scene)
end

-- close event
function scene:onClose(event)
end

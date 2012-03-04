-- scene
tmxmap2_sample = Scene:new()
local scene = tmxmap2_sample
local preX, preY = 0, 0

function scene:onOpen(event)
    local map = TMXMapLoader:new():load("samples/resources/platformmap.tmx")
    map.resourceDirectory = "samples/resources/"
    map:drawMap(scene)
end

-- close event
function scene:onClose(event)
end

function scene:onTouchDown(event)
    preX = event.worldX
    preY = event.worldY
end

function scene:onTouchMove(event)
    local moveX, moveY = event.worldX - preX, event.worldY - preY
    local camera = scene.topLayer.camera
    camera.x = camera.x - moveX
    camera.y = camera.y - moveY
end

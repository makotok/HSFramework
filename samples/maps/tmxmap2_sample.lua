module(..., package.seeall)

function onCreate()
    local scrollView = ScrollView:new({parent = scene})
    local map = TMXMapLoader:new():load("samples/resources/platformmap.tmx")
    map.resourceDirectory = "samples/resources/"
    map:drawMap(scrollView)
end

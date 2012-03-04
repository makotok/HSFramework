TestTMXMapLoader = {}

------------------------------------------------------------
function TestTMXMapLoader:setUp()
end

function TestClass:test1_load()
    local mapLoader = TMXMapLoader:new()
    local tmxMap = mapLoader:load("test/resources/tmx_1.tmx")
    
    tmxMap:printDebugInfo()
end
------------------------------------------------------------

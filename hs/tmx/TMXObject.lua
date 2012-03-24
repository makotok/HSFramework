local table = require("hs/lang/table")
local Class = require("hs/lang/Class")

--------------------------------------------------------------------------------
-- TMXMapのObjectGroupです.
--
-- @class table
-- @name TMXObject
--------------------------------------------------------------------------------

local TMXObject = Class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXObject:init()
    
    self.name = ""
    self.type = ""
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.gid = nil
    self.properties = {}
end

---------------------------------------
-- DisplayObjectを生成します.
---------------------------------------
function TMXObject:createDisplayObject()
end

---------------------------------------
-- Box2DBodyを生成します.
---------------------------------------
function TMXObject:createBox2DBody()
end

return TMXObject

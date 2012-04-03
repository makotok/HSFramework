local Transform = require("hs/core/Transform")

--------------------------------------------------------------------------------
-- LayerのCameraクラスです.
-- @class table
-- @name Camera
--------------------------------------------------------------------------------
local Camera = Transform()

---------------------------------------
--- コンストラクタです
---------------------------------------
function Camera:init()
    Camera:super(self)
end

---------------------------------------
--- MOAICamera2Dを生成して返します.
---------------------------------------
function Camera:newTransformObj()
    return MOAICamera2D.new()
end

function Camera:getTransformObj()
    return self._transformObj
end

return Camera
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
    self:setUpMode2D()
end

---------------------------------------
--- MOAICameraを生成して返します.
---------------------------------------
function Camera:newTransformObj()
    return MOAICamera.new()
end

function Camera:setUpMode2D()
    self.transformObj:setOrtho(true)
    self.transformObj:setNearPlane(1)
    self.transformObj:setFarPlane(-1)
end

return Camera
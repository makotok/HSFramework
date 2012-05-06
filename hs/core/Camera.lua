local Transform = require("hs/core/Transform")

--------------------------------------------------------------------------------
-- LayerのCameraクラスです.
-- @class table
-- @name Camera
--------------------------------------------------------------------------------
local M = Transform()

---------------------------------------
--- コンストラクタです
---------------------------------------
function M:init()
    M:super(self)
    self:setUpMode2D()
end

---------------------------------------
--- MOAICameraを生成して返します.
---------------------------------------
function M:newTransformObj()
    return MOAICamera.new()
end

function M:setUpMode2D()
    self.transformObj:setOrtho(true)
    self.transformObj:setNearPlane(1)
    self.transformObj:setFarPlane(-1)
end

return M
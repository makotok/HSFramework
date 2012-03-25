local Transform = require("hs/core/Transform")

--------------------------------------------------------------------------------
-- 表示オブジェクトの移動や回転、拡大を行うためのクラスです
-- @class table
-- @name Transform
--------------------------------------------------------------------------------
local Camera = Transform()

---------------------------------------
--- コンストラクタです
---------------------------------------
function Camera:init()
    Camera:super(self)
end

---------------------------------------
--- MOAITransformを生成して返します.
---------------------------------------
function Camera:newTransformObj()
    return MOAICamera2D.new()
end

function Camera:getTransformObj()
    return self._transformObj
end

return Camera
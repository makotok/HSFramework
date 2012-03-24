local table = require("hs/lang/table")
local BoxLayout = require("hs/core/BoxLayout")

----------------------------------------------------------------
-- デフォルトで水平方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name HBoxLayout
----------------------------------------------------------------
local HBoxLayout = BoxLayout()

---------------------------------------
-- コンストラクタです
---------------------------------------
function HBoxLayout:init(params)
    HBoxLayout:super(self, params)
    self.direction = BoxLayout.DIRECTION_H
end

return HBoxLayout
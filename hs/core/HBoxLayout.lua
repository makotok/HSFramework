local table = require("hs/lang/table")
local BoxLayout = require("hs/core/BoxLayout")

----------------------------------------------------------------
-- デフォルトで水平方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name HBoxLayout
----------------------------------------------------------------
local M = BoxLayout()

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    M:super(self, params)
    self.direction = BoxLayout.DIRECTION_H
end

return M
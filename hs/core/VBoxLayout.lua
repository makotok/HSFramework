local BoxLayout = require("hs/core/BoxLayout")

----------------------------------------------------------------
-- デフォルトで垂直方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name VBoxLayout
----------------------------------------------------------------
local M = BoxLayout()

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    M:super(self, params)
    self.direction = BoxLayout.DIRECTION_V
end

return M
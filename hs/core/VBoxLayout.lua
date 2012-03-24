local BoxLayout = require("hs/core/BoxLayout")

----------------------------------------------------------------
-- デフォルトで垂直方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name VBoxLayout
----------------------------------------------------------------
local VBoxLayout = BoxLayout()

---------------------------------------
-- コンストラクタです
---------------------------------------
function VBoxLayout:init(params)
    VBoxLayout:super(self, params)
    self.direction = BoxLayout.DIRECTION_V
end

return VBoxLayout
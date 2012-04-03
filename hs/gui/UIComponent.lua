local table = require("hs/lang/table")
local Group = require("hs/core/Group")

--------------------------------------------------------------------------------
-- UIコンポーネントの基本クラスです。
--
--------------------------------------------------------------------------------

local UIComponent = Group()

---------------------------------------
-- コンストラクタです
-- @name UIComponent:new
---------------------------------------
function UIComponent:init(params)
    UIComponent:super(self, params)
end

function UIComponent:onInitial()
    Group.onInitial(self)
    
    self._createdChildren = false
    
    self:invalidateDisplay()
end

---------------------------------------
-- 子オブジェクト作成処理です.
-- フレームの最初に一回だけ呼ばれます.
-- デフォルトでは何もしません.
---------------------------------------
function UIComponent:createChildren()
end

---------------------------------------
-- フレーム毎の処理を行います。
-- invalidateDisplayList関数が呼ばれていた場合、
-- updateDisplayList関数を実行します。
---------------------------------------
function UIComponent:updateDisplay()
    -- 初期化処理
    if not self._createdChildren then
        self:createChildren()
        self._createdChildren = true
    end
    
    -- グループ共通処理
    Group.updateDisplay(self)
end

return UIComponent
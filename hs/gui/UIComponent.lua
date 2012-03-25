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
    self._invalidatedProperties = false
end

---------------------------------------
-- 子オブジェクト作成処理です.
-- フレームの最初に一回だけ呼ばれます.
-- デフォルトでは何もしません.
---------------------------------------
function UIComponent:onCreateChildren()
end

---------------------------------------
-- プロパティが変更された事をマークする関数です。
-- この関数を実行すると、onCommitProperties()
-- が後で呼び出されます。
---------------------------------------
function UIComponent:invalidateProperties()
    self._invalidatedProperties = true
end

---------------------------------------
-- プロパティが変更された場合に
-- フレームの最初に一回だけ呼ばれます。
-- デフォルトでは何もしません。
---------------------------------------
function UIComponent:onCommitProperties()
end

---------------------------------------
-- フレーム毎の処理を行います。
-- invalidateDisplayList関数が呼ばれていた場合、
-- updateDisplayList関数を実行します。
---------------------------------------
function UIComponent:onEnterFrame(event)
    -- 初期化処理
    if not self._createdChildren then
        self:onCreateChildren()
        self._createdChildren = true
    end
    
    -- グループ共通処理
    Group.onEnterFrame(self, event)

    -- プロパティ変更時の処理
    if self._invalidatedProperties then
        self:onCommitProperties()
        self._invalidatedProperties = false
    end
end

return UIComponent
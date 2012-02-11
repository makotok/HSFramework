
FocusManager = {}
setmetatable(FocusManager, {__index = EventDispatcher})

---------------------------------------
-- InputManagerの初期化処理です
-- フレームワークで初期化する必要があります。
---------------------------------------
function FocusManager:new()
    -- オブジェクト定義
    local proxy, object = EventDispatcher.new(self)
    object.focusObject = nil

    return proxy, object
end

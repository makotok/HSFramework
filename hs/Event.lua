-- モジュール参照
require "hs/Class"

Event = Class()

-- 定数
-- 典型的なイベントを定義
Event.OPEN = "open"
Event.CLOSE = "close"
Event.ACTIVATE = "activate"
Event.DEACTIVATE = "deactivate"
Event.DOWN = "down"
Event.UP = "up"
Event.MOVE = "move"
Event.CLICK = "click"
Event.CANCEL = "cancel"
Event.KEYBORD = "keybord"

Event.TOUCH = "touch"
Event.TOUCH_DOWN = "touchDown"
Event.TOUCH_UP = "touchUp"
Event.TOUCH_MOVE = "touchMove"
Event.TOUCH_CANCEL = "touchCancel"

---------------------------------------
--- コンストラクタです
---------------------------------------
function Event:init(eventType, target)
    self.type = eventType
    self.target = target
    self.stoped = false
end

function Event:stopPropagation()
    self.stoped = true
end

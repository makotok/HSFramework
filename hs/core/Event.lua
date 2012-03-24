local Class = require("hs/lang/Class")

--------------------------------------------------------------------------------
-- Eventの基本クラスです.
-- Eventのタイプ、送信元などの情報を保持します.
-- @class table
-- @name Event
--------------------------------------------------------------------------------

local Event = Class()

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
Event.KEYBOARD = "keyboard"
Event.COMPLETE = "complete"
Event.FRAME_LOOP = "frameLoop"
Event.FRAME_STOP = "frameStop"

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

function Event:setListener(callback, source)
    self.callback = callback
    self.source = source
end

function Event:stop()
    self.stoped = true
end

return Event
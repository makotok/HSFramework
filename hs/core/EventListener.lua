--------------------------------------------------------------------------------
-- イベントリスナーです.
-- ライブラリ内部で使用されます.
-- @class table
-- @name EventListener
--------------------------------------------------------------------------------
EventListener = Class()

-- 定数
EventListener.PRIORITY_MIN = 0
EventListener.PRIORITY_MAX = 999999

function EventListener:init(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority and priority or 0
end

function EventListener:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end


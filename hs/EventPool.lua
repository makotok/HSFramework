--------------------------------------------------------------------------------
-- イベントプールです。
--------------------------------------------------------------------------------

---------------------------------------
-- ファクトリー関数です。
---------------------------------------
local function factory(eventType, target)
    return Event:new(eventType, target)
end

---------------------------------------
-- 初期化関数です。
---------------------------------------
local function initial(object, eventType, target)
    object.type = eventType
    object.target = target
    object.stoped = false
end

EventPool = ObjectPool:new(factory, initial)

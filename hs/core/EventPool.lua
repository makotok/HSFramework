--------------------------------------------------------------------------------
-- イベントプールです.
-- @class table
-- @name EventPool
--------------------------------------------------------------------------------
EventPool = ObjectPool:new()

---------------------------------------
-- ファクトリー関数です.
---------------------------------------
function EventPool:createObject(eventType, target)
    return Event:new(eventType, target)
end

---------------------------------------
-- 初期化関数です.
---------------------------------------
function EventPool:initObject(object, eventType, target)
    object.type = eventType
    object.target = target
    object.stoped = false
end


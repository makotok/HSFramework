-- import
local ObjectPool = require("hs/core/ObjectPool")
local Event = require("hs/core/Event")

--------------------------------------------------------------------------------
-- イベントプールです.
-- @class table
-- @name EventPool
--------------------------------------------------------------------------------
local EventPool = ObjectPool:new()

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

return EventPool

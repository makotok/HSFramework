local PropertySupport = require("hs/lang/PropertySupport")
local EventListener = require("hs/core/EventListener")

----------------------------------------------------------------
-- イベント処理を行うための基本クラスです.
-- イベントの発出した結果を、登録したイベントリスナがキャッチして
-- イベント処理を行います.
-- @class table
-- @name EventDispatcher
----------------------------------------------------------------
local M = PropertySupport()

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init()
    M:super(self)
    self.listeners = {}
end

---------------------------------------
-- イベントリスナを登録します.
-- callbackは、呼び出されるコールバック関数です.
-- sourceは、オブジェクトの関数だった場合に指定します.
-- nilの場合は、callback(event)となり、
-- 指定ありの場合、callback(self, event)で呼ばれます.
-- priorityは、優先度です.
-- 優先度が小さい値程、最初に関数が呼ばれます.
---------------------------------------
function M:addListener(eventType, callback, source, priority)
    if self:hasListener(eventType, callback, source) then
        return false
    end

    local listener = EventListener:new(eventType, callback, source, priority)

    for i, v in ipairs(self.listeners) do
        if listener.priority < v.priority then
            table.insert(self.listeners, i, listener)
            return true
        end
    end

    table.insert(self.listeners, listener)
    return true
end

---------------------------------------
--- イベントリスナを削除します.
---------------------------------------
function M:removeListener(eventType, callback, source)
    for key, obj in ipairs(self.listeners) do
        if obj.type == eventType and obj.callback == callback and obj.source == source then
            table.remove(self.listeners, key)
            return true
        end
    end
    return false
end

---------------------------------------
--- イベントリスナを登録済か返します.
---------------------------------------
function M:hasListener(eventType, callback, source)
    for key, obj in ipairs(self.listeners) do
        if obj.type == eventType and obj.callback == callback and obj.source == source then
            return true
        end
    end
    return false
end

---------------------------------------
-- イベントをディスパッチします
---------------------------------------
function M:dispatchEvent(event)
    event.stoped = false
    event.target = event.target and event.target or self
    for key, obj in ipairs(self.listeners) do
        if obj.type == event.type then
            event:setListener(obj.callback, obj.source)
            obj:call(event)
            if event.stoped == true then
                break
            end
        end
    end
end

---------------------------------------
-- イベントリスナをすべて削除します.
---------------------------------------
function M:clearListeners()
    self.listeners = {}
end

return M
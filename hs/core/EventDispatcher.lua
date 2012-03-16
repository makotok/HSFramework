----------------------------------------------------------------
-- イベント処理を行うための基本クラスです。
-- イベントの発出した結果を、登録したイベントリスナがキャッチして
-- イベント処理を行います。
----------------------------------------------------------------

EventDispatcher = PropertySupport()

---------------------------------------
-- コンストラクタです
---------------------------------------
function EventDispatcher:init()
    PropertySupport.init(self)
    self.listeners = {}
end

---------------------------------------
-- イベントリスナを登録します。
-- callbackは、呼び出されるコールバック関数です。
-- sourceは、オブジェクトの関数だった場合に指定します。
-- nilの場合は、callback(event)となり、
-- 指定ありの場合、callback(self, event)で呼ばれます。
-- priorityは、優先度です。
-- 優先度が小さい値程、最初に関数が呼ばれます。
---------------------------------------
function EventDispatcher:addListener(eventType, callback, source, priority)
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
--- イベントリスナを削除します。
---------------------------------------
function EventDispatcher:removeListener(eventType, callback, source)
    for key, obj in ipairs(self.listeners) do
        if obj.type == eventType and obj.callback == callback and obj.source == source then
            table.remove(self.listeners, key)
            return true
        end
    end
    return false
end

---------------------------------------
--- イベントリスナを登録済か返します。
---------------------------------------
function EventDispatcher:hasListener(eventType, callback, source)
    for key, obj in ipairs(self.listeners) do
        if obj.type == eventType and obj.callback == callback and obj.source == source then
            return true
        end
    end
    return false
end

---------------------------------------
-- イベントをディスパッチします
-- eventオブジェクトは回収されるため、
-- 再利用する場合は、EventPoolから再取得してください。
---------------------------------------
function EventDispatcher:dispatchEvent(event)
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
    EventPool:releaseObject(event)
end

---------------------------------------
-- イベントリスナをすべて削除します。
---------------------------------------
function EventDispatcher:clearListeners()
    self.listeners = {}
end
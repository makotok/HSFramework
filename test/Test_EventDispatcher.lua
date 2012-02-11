
require "hs/Event"
require "hs/EventDispatcher"

local obj = EventDispatcher:new()
local count = 0

----------------------------------------
-- function listener
----------------------------------------
function onOpen(event)
    print("onOpen")
    count = count + 1
end

obj:addListener("open", onOpen)

----------------------------------------
-- object listener
----------------------------------------
local listener = {}
function listener:onOpen(event)
    print("listener:onOpen")
    count = count + 1
end

obj:addListener("open", listener.onOpen, listener)

----------------------------------------
-- dispatch
----------------------------------------

obj:dispatchEvent(Event:new("open"))



local table = require("hs/lang/table")
local Event = require("hs/core/Event")
local EventDispatcher = require("hs/core/EventDispatcher")

----------------------------------------------------------------
-- 画面の操作をキャッチして、イベントを発出するクラスです.
-- タッチ、キーボードの操作が該当します
-- @class table
-- @name InputManager
----------------------------------------------------------------

local M = EventDispatcher:new()
M.pointer = {x = 0, y = 0, down = false}
M.keyboard = {key = 0, down = false}

---------------------------------------
-- InputManagerの初期化処理です
-- フレームワークで初期化する必要があります.
---------------------------------------
function M:initialize()
    -- コールバック関数の登録
    if MOAIInputMgr.device.pointer then
        -- mouse input
        MOAIInputMgr.device.pointer:setCallback (M.onPointer)
        MOAIInputMgr.device.mouseLeft:setCallback (M.onClick)
    else
        -- touch input
        MOAIInputMgr.device.touch:setCallback (M.onTouch)
    end

    -- keyboard input
    if MOAIInputMgr.device.keyboard then
        MOAIInputMgr.device.keyboard:setCallback(M.onKeyboard)
    end
end

---------------------------------------
-- マウスを動かした時のイベント処理です
---------------------------------------
function M.onPointer(x, y)
    M.pointer.x = x
    M.pointer.y = y

    if M.pointer.down then
        M.onTouch(MOAITouchSensor.TOUCH_MOVE, 1, x, y)
    end
end

---------------------------------------
-- マウスを押下した時のイベント処理です
---------------------------------------
function M.onClick(down)
    M.pointer.down = down

    local eventType = nil
    if down then
        eventType = MOAITouchSensor.TOUCH_DOWN
    else
        eventType = MOAITouchSensor.TOUCH_UP
    end
    
    M.onTouch(eventType, 1, M.pointer.x, M.pointer.y)
end

---------------------------------------
-- 画面をタッチした時のイベント処理です
---------------------------------------
function M.onTouch(eventType, idx, x, y, tapCount)
    -- event
    local event = Event:new(Event.TOUCH, M)
    if eventType == MOAITouchSensor.TOUCH_DOWN then
        event.type = Event.TOUCH_DOWN
    elseif eventType == MOAITouchSensor.TOUCH_UP then
        event.type = Event.TOUCH_UP
    elseif eventType == MOAITouchSensor.TOUCH_MOVE then
        event.type = Event.TOUCH_MOVE
    elseif eventType == MOAITouchSensor.TOUCH_CANCEL then
        event.type = Event.TOUCH_CANCEL
    end
    event.idx = idx
    event.x = x
    event.y = y
    event.tapCount = tapCount

    M:dispatchEvent(event)
end

---------------------------------------
-- キーボード入力時のイベント処理です.
---------------------------------------
function M.onKeyboard( key, down )
    M.keyboard.key = key
    M.keyboard.down = down

    local event = Event:new(Event.KEYBOARD)
    event.key = key
    event.down = down

    M:dispatchEvent(event)
end

return M

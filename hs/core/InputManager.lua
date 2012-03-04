----------------------------------------------------------------
-- 画面の操作をキャッチして、イベントを発出するクラスです。
-- タッチ、キーボードの操作が該当します
----------------------------------------------------------------

InputManager = EventDispatcher:new()
InputManager.pointer = {x = 0, y = 0, down = false}
InputManager.keybord = {key = 0, down = false}

---------------------------------------
-- InputManagerの初期化処理です
-- フレームワークで初期化する必要があります。
---------------------------------------
function InputManager:initialize()
    -- コールバック関数の登録
    if MOAIInputMgr.device.pointer then
        -- mouse input
        MOAIInputMgr.device.pointer:setCallback (InputManager.onPointer)
        MOAIInputMgr.device.mouseLeft:setCallback (InputManager.onClick)
    else
        -- touch input
        MOAIInputMgr.device.touch:setCallback (InputManager.onTouch)
    end

    -- keybord input
    if MOAIInputMgr.device.keyboard then
        MOAIInputMgr.device.keyboard:setCallback(InputManager.onKeyboard)
    end
end

---------------------------------------
-- マウスを動かした時のイベント処理です
---------------------------------------
function InputManager.onPointer(x, y)
    InputManager.pointer.x = x
    InputManager.pointer.y = y

    if InputManager.pointer.down then
        InputManager.onTouch(MOAITouchSensor.TOUCH_MOVE, 1, x, y)
    end
end

---------------------------------------
-- マウスを押下した時のイベント処理です
---------------------------------------
function InputManager.onClick(down)
    InputManager.pointer.down = down

    local eventType = nil
    if down then
        eventType = MOAITouchSensor.TOUCH_DOWN
    else
        eventType = MOAITouchSensor.TOUCH_UP
    end
    
    InputManager.onTouch(eventType, 1, InputManager.pointer.x, InputManager.pointer.y)
end

---------------------------------------
-- 画面をタッチした時のイベント処理です
---------------------------------------
function InputManager.onTouch(eventType, idx, x, y, tapCount)
    -- event
    local event = Event:new(Event.TOUCH, InputManager)
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

    InputManager:dispatchEvent(event)
end

---------------------------------------
-- キーボード入力時のイベント処理です。
---------------------------------------
function InputManager.onKeyboard( key, down )
    InputManager.keybord.key = key
    InputManager.keybord.down = down

    local event = Event:new(Event.KEYBORD, InputManager)
    event.key = key
    event.down = down

    InputManager:dispatchEvent(event)
end


----------------------------------------------------------------
-- AnimationはDisplayObjectをアニメーションする為のクラスです。
-- 移動、回転、拡大や、フレームアニメーションに対応します。
--
----------------------------------------------------------------
Animation = EventDispatcher()

-- properties
Animation:setPropertyName("target")
Animation:setPropertyName("running", "setRunning", "isRunning")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Animation:init(target, sec, easeType)
    Scene:super(self)
    
    self._target = target
    self._commands = {}

    self._second = sec and sec or 1
    self._easeType = easeType
    
    self._currentCommand = nil
    self._currentIndex = 0
    self._currentSecond = sec
    self._currentEaseType = easeType
    self._running = false
    self._stoped = false
end

---------------------------------------
-- アニメーション中かどうか返します。
---------------------------------------
function Animation:isRunning()
    return self._running
end

---------------------------------------
-- 対象オブジェクトを返します。
---------------------------------------
function Animation:getTarget()
    return self._target
end

---------------------------------------
-- 対象オブジェクトを設定します。
---------------------------------------
function Animation:setTarget(target)
    self._target = target
end

---------------------------------------
-- アニメーションのプロパティを設定します。
---------------------------------------
function Animation:setting(src)
    local command = self:newCommand(
        function(obj, callback)
            table.copy(src, self)
            callback(obj)
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトのプロパティを設定します。
---------------------------------------
function Animation:copy(src)
    local command = self:newCommand(
        function(obj, callback)
            table.copy(src, self.target)
            callback(obj)
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます。
---------------------------------------
function Animation:move(moveX, moveY, sec, mode)
    local action = nil
    local command = self:newCommand(
        function(obj, callback)
            local tSec = self:_getCommandSecond(sec)
            local tMode = self:_getCommandEaseType(mode)
            action = self.target:move(moveX, moveY, tSec, tMode, function() callback(obj) end)
        end,
        function(obj)
            if action then
                action:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを回転させます。
---------------------------------------
function Animation:rotate(rotation, sec, mode)
    local action = nil
    local command = self:newCommand(
        function(obj, callback)
            local tSec = self:_getCommandSecond(sec)
            local tMode = self:_getCommandEaseType(mode)
            action = self.target:rotate(rotation, tSec, tMode,  function() callback(obj) end)
        end,
        function(obj)
            if action then
                action:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを拡大します。
---------------------------------------
function Animation:scale(scaleX, scaleY, sec, mode)
    local action = nil
    local command = self:newCommand(
        function(obj, callback)
            local tSec = self:_getCommandSecond(sec)
            local tMode = self:_getCommandEaseType(mode)
            action = self.target:scale(scaleX, scaleY, tSec, tMode, function() callback(obj) end)
        end,
        function(obj)
            if action then
                action:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトをフェードインします。
---------------------------------------
function Animation:fadeIn(sec, mode)
    local action = nil
    local command = self:newCommand(
        function(obj, callback)
            local tSec = self:_getCommandSecond(sec)
            local tMode = self:_getCommandEaseType(mode)
            action = self.target:fadeIn(tSec, tMode, function() callback(obj) end)
        end,
        function(obj)
            if action then
                action:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトをフェードアウトします。
---------------------------------------
function Animation:fadeOut(sec, mode)
    local action = nil
    local command = self:newCommand(
        function(obj, callback)
            local tSec = self:_getCommandSecond(sec)
            local tMode = self:_getCommandEaseType(mode)
            action = self.target:fadeOut(tSec, tMode, function() callback(obj) end)
        end,
        function(obj)
            if action then
                action:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトをフェードアウトします。
---------------------------------------
function Animation:color(red, green, blue, alpha, sec, mode)
    local action = nil
    local command = self:newCommand(
        function(obj, callback)
            local tSec = self:_getCommandSecond(sec)
            local tMode = self:_getCommandEaseType(mode)
            action = self.target:moveColor(red, green, blue, alpha, tSec, tMode, function() callback(obj) end)
        end,
        function(obj)
            if action then
                action:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 指定されたアニメーションを並列実行します。
---------------------------------------
function Animation:parallel(...)
    local animations = {...}
    local command = self:newCommand(
        -- start
        function(obj, callback)
            local count = 0
            local max = #animations
            local completeHandler = function(e)
                count = count + 1
                if count >= max then
                    callback(obj)
                end
            end
            for i, a in ipairs(animations) do
                a:play({onComplete = completeHandler})
            end
        end,
        -- stop
        function(obj)
            for i, a in ipairs(animations) do
                a:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 指定されたアニメーションを順次実行します。
---------------------------------------
function Animation:sequence(...)
    local animations = {...}
    local currentAnimation = nil
    local command = self:newCommand(
        -- start
        function(obj, callback)
            local count = 0
            local max = #animations
            local completeHandler = function(e)
                count = count + 1
                if count >= max then
                    currentAnimation = nil
                    callback(obj)
                else
                    currentAnimation = animations[count]
                    currentAnimation:reset()
                    currentAnimation:play({onComplete = completeHandler})
                end
            end
            completeHandler()
        end,
        -- stop
        function(obj)
            if currentAnimation then
                currentAnimation:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 指定されたアニメーションを指定回数だけ実行します。
-- 0の場合は、無限にアニメーションし続けます。
-- onLoop関数がtrueを返すと、ループは終了します。
-- 
-- @param count ループ回数
-- @param onLoop ループの判定関数
-- @param ... アニメーション
---------------------------------------
function Animation:loop(count, onLoop, ...)
    -- 未実装
end

---------------------------------------
-- 一定時間待機します。
-- @param sec 待機時間
---------------------------------------
function Animation:wait(sec)
    local timer = MOAITimer.new()
    timer:setTime(sec)
    
    local command = self:newCommand(
        function(obj, callback)
            timer:setListener(MOAIAction.EVENT_STOP, function() callback(obj) end)
            timer:start()
        end,
        function(obj)
            timer:stop()
        end
    )
    
    self:addCommand(command)
    return self
end

---------------------------------------
-- アニメーションを開始します。
-- 一時停止していた場合は最初から再開します。
-- 
-- 引数のparamsでいくつかの動作を制御できます。
-- params.onComplete(e)に関数を指定すると
-- 完了時に関数がコールされます。
---------------------------------------
function Animation:play(params)
    if self.running then
        return self
    end
    if #self._commands == 0 then
        return self
    end
    if params then
        self._onComplete = params.onComplete
    end
    Log.debug("Animation:play")
    self._currentSecond = self._second
    self._currentEaseType = self._easeType
    self._running = true
    self._stoped = false
    
    -- execute command
    self:_executeCommand(1)
    
    return self
end

---------------------------------------
-- コマンドを実行します。
---------------------------------------
function Animation:_executeCommand(index)
    if index <= #self._commands then
        self._currentIndex = index
        self._currentCommand = self._commands[self._currentIndex]
        self._currentCommand.play(self, self._onCommandComplete)
    end
end

---------------------------------------
-- コマンド完了時のハンドラです。
---------------------------------------
function Animation:_onCommandComplete()
    if self._stoped then
        return
    end
    -- next command
    if self._currentIndex < #self._commands then
        self:_executeCommand(self._currentIndex + 1)
    -- complete!
    else
        local event = Event:new(Event.COMPLETE, self)
        if self._onComplete then self._onComplete(event) end
        self:onComplete(event)
        self:dispatchEvent(event)
    end
end

---------------------------------------
-- アニメーションを開始します。
---------------------------------------
function Animation:stop()
    if not self.running then
        return self
    end
    
    Log.debug("Animation:stop")
    self._running = false
    self._stoped = true
    self._currentCommand.stop(self)    
    return self
end

---------------------------------------
-- アニメーション完了時のイベント処理を行います。
-- 継承して使用する事を想定します。
-- @param event
---------------------------------------
function Animation:onComplete(event)

end

---------------------------------------
-- アニメーション実行コマンドを追加します。
-- 通常は使用する必要がありませんが、
-- カスタムコマンドを追加する事もできます。
-- @param command play,stop,restart関数
---------------------------------------
function Animation:addCommand(command)
    table.insert(self._commands, command)
    return self
end

---------------------------------------
-- アニメーション実行コマンドを生成します。
-- 実行コマンドは単純なテーブルです。
-- 指定しなかった関数は空関数がセットされます。
-- @param playFunc 開始 playFunc(callback)
-- @param stopFunc 停止 stopFunc()
-- @return command コマンドテーブル
---------------------------------------
function Animation:newCommand(playFunc, stopFunc)
    local emptyFunc = function(obj, callback) end
    playFunc = playFunc
    stopFunc = stopFunc and stopFunc or emptyFunc
    
    local command = {play = playFunc, stop = stopFunc}
    return command
end

function Animation:_getCommandSecond(sec)
    return sec and sec or self._currentSecond
end

function Animation:_getCommandEaseType(easeType)
    return easeType and easeType or self._currentEaseType
end


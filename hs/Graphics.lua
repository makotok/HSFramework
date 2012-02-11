Graphics = DisplayObject()

function Graphics:init(width, height)
    DisplayObject.init(self)
    
    -- 描画コマンド
    self._commands = {}
    
    -- サイズ設定
    if width and height then
        self:setSize(width, height)
    end
    
end

---------------------------------------
-- MOAIDeckを生成します。
---------------------------------------
function Graphics:newDeck()
    local deck = MOAIScriptDeck.new()
    deck:setDrawCallback(
        function(index, xOff, yOff, xFlip, yFlip)
            self:onDraw(index, xOff, yOff, xFlip, yFlip)
        end
    )
    return deck
end

---------------------------------------
-- 描画処理を行います。
---------------------------------------
function Graphics:onDraw(index, xOff, yOff, xFlip, yFlip)
    MOAIGfxDevice.setPenColor(self.red, self.green, self.blue, self.alpha)
    for i, gfx in ipairs(self._commands) do
        gfx(self)
    end
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します。
---------------------------------------
function Graphics:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.deck:setRect(0, 0, width, height)
end

---------------------------------------
-- 円を描画します。
---------------------------------------
function Graphics:drawCircle(x, y, r, steps)
    local command = function(self)
        MOAIDraw.drawCircle(x, y, r, steps)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 楕円を描画します。
---------------------------------------
function Graphics:drawEllipse(x, y, xRad, yRad, steps)
    local command = function(self)
        MOAIDraw.drawEllipse(x, y, xRad, yRad, steps)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 線を描画します。
---------------------------------------
function Graphics:drawLine(...)
    local args = ...
    local command = function(self)
        MOAIDraw.drawLine(unpack(args))
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 点を描画します。
---------------------------------------
function Graphics:drawPoints(...)
    local args = ...
    local command = function(self)
        MOAIDraw.drawPoints(unpack(args))
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 円を描画します。
---------------------------------------
function Graphics:drawRay(x, y, dx, dy)
    local command = function(self)
        MOAIDraw.drawRay(x, y, dx, dy)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 四角形を描画します。
---------------------------------------
function Graphics:drawRect(x0, y0, x1, y1)
    local command = function(self)
        MOAIDraw.drawRect(x0, y0, x1, y1)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 円を塗りつぶします。
---------------------------------------
function Graphics:fillCircle(x, y, r, steps)
    local command = function(self)
        MOAIDraw.fillCircle(x, y, r, steps)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 円を塗りつぶします。
---------------------------------------
function Graphics:fillEllipse(x, y, xRad, yRad, steps)
    local command = function(self)
        MOAIDraw.fillEllipse(x, y, xRad, yRad, steps)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 円を塗りつぶします。
---------------------------------------
function Graphics:fillFan(...)
    local args = ...
    local command = function(self)
        MOAIDraw.fillFan(unpack(args))
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 四角形を塗りつぶします。
---------------------------------------
function Graphics:fillRect(x0, y0, x1, y1)
    local command = function(self)
        MOAIDraw.fillRect(x0, y0, x1, y1)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 指定した色に設定します。
-- 設定後に描画したコマンドに反映されます。
---------------------------------------
function Graphics:setPenColor(r, g, b, a)
    local command = function(self)
        MOAIGfxDevice.setPenColor(r, g, b, a)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 指定したペンのサイズに設定します。
-- 設定後に描画したコマンドに反映されます。
---------------------------------------
function Graphics:setPenWidth(width)
    local command = function(self)
        MOAIGfxDevice.setPenWidth(width)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 指定したポイントのサイズに設定します。
-- 設定後に描画したコマンドに反映されます。
---------------------------------------
function Graphics:setPointSize(size)
    local command = function(self)
        MOAIGfxDevice.setPointSize(size)
    end
    table.insert(self._commands, command)
end

---------------------------------------
-- 描画処理をクリアします。
---------------------------------------
function Graphics:clear()
    self._commands = {}
end
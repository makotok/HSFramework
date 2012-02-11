----------------------------------------------------------------
--- RectangleSprite クラスの定義
----------------------------------------------------------------
RectangleSprite = {}

function RectangleSprite.new()
    local scriptDeck = MOAIScriptDeck.new ()
    local obj = MOAIProp2D.new ()
    obj:setDeck ( scriptDeck )
    obj.border = {
        red = 1, green = 1, blue = 1, alpha = 1, width = 1, visible = true
    }
    obj.back= {
        red = 1, green = 1, blue = 1, alpha = 1, visible = true
    }

    function obj:setSize(width, height)
        scriptDeck:setRect(0, 0, width, height)
    end

    function obj:getSize()
        local xMin, yMin, xMax, yMax = self:getRect()
        local propWidth = xMax - xMin
        local propHeight = yMax - yMin

        return propWidth, propHeight
    end

    function obj.onDraw(index, xOff, yOff, xFlip, yFlip)
        local width, height = obj:getSize()

        -- 塗りつぶし
        local back = obj.back
        if back.visible then
            MOAIGfxDevice.setPenColor (back.red, back.green, back.blue, back.alpha)

            MOAIDraw.fillFan (
                0, height,
                0, 0,
                width, height
            )
            MOAIDraw.fillFan (
                0, 0,
                width, 0,
                width, height
            )
        end

        -- 枠線
        local border = obj.border
        if border.visible then
            MOAIGfxDevice.setPenWidth ( border.width )
            MOAIGfxDevice.setPenColor (border.red, border.green, border.blue, border.alpha)

            MOAIDraw.drawLine (
                0, 0,
                width, 0,
                width, height,
                0, height,
                0, 0
            )
        end
    end

    function obj:setBorderColor(r, g, b, a)
        self.border.red = r
        self.border.green = g
        self.border.blue = b
        if a ~= nil then
            self.border.alpha = a
        end
    end

    function obj:setBackColor(r, g, b, a)
        self.back.red = r
        self.back.green = g
        self.back.blue = b
        if a ~= nil then
            self.back.alpha = a
        end
    end

    scriptDeck:setDrawCallback ( obj.onDraw )
    return obj
end


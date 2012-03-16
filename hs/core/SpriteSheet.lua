--------------------------------------------------------------------------------
-- テクスチャをタイル毎に分割して、タイル毎に描画するクラスです。
--------------------------------------------------------------------------------

SpriteSheet = DisplayObject()

-- プロパティ定義
SpriteSheet:setPropertyName("frame")
SpriteSheet:setPropertyName("frameWidth")
SpriteSheet:setPropertyName("frameHeight")
SpriteSheet:setPropertyName("texture")

---------------------------------------
-- コンストラクタです
---------------------------------------
function SpriteSheet:init(texture, frameWidth, frameHeight, params)
    SpriteSheet:super(self)

    -- オブジェクト定義
    self._frame = 1
    self._frames = {}
    self._frameCurve = MOAIAnimCurve.new()
    self._frameAnim = MOAIAnim:new()
    self._frameWidth = 1
    self._frameHeight = 1
    
    -- イベントリスナの設定
    self._frameAnim:setListener(MOAITimer.EVENT_TIMER_LOOP, 
        function(prop)
            local e = EventPool:getObject(Event.FRAME_LOOP)
            self:onFrameLoop(e)
            self:dispatchEvent(e)
        end
    )
    self._frameAnim:setListener(MOAIAction.EVENT_STOP,
        function(prop)
            local e = EventPool:getObject(Event.FRAME_STOP)
            self:onFrameStop(e)
            self:dispatchEvent(e)
        end
    )

    -- テクスチャの設定
    if texture then
        self:setTexture(texture)
    end

    --  フレーム数の設定
    if frameWidth and frameHeight then
        self:setFrameSize(frameWidth, frameHeight)
    end

    --  その他パラメータの設定
    if params then
        table.copy(params, self)
    end

end

---------------------------------------
-- MOAIDeckを生成します。
---------------------------------------
function SpriteSheet:newDeck()
    return MOAITileDeck2D.new()
end

---------------------------------------
-- テキスチャを設定します。
-- サイズも自動で設定されます。
---------------------------------------
function SpriteSheet:setTexture(texture)
    if type(texture) == "string" then
        texture = TextureCache:get(texture)
    end

    local width, height = texture:getSize()
    self.deck:setTexture(texture)
    self._texture = texture

    self:setSize(width / self.frameWidth, height / self.frameHeight)
end

function SpriteSheet:getTexture()
    return self._texture
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します。
---------------------------------------
function SpriteSheet:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.deck:setRect(0, self.height, self.width, 0)
end

---------------------------------------
-- タイルのフレーム数を設定します。
---------------------------------------
function SpriteSheet:setFrameSize(width, height)
    self._frameWidth = width
    self._frameHeight = height
    self.deck:setSize(width, height)
    if self.texture then
        self.texture = self.texture
    end
end

---------------------------------------
-- タイルのフレーム数を設定します。
---------------------------------------
function SpriteSheet:setFrameWidth(width)
    self:setFrameSize(width, self._frameHeight)
end

function SpriteSheet:getFrameWidth()
    return self._frameWidth
end

---------------------------------------
-- タイルのフレーム数を設定します。
---------------------------------------
function SpriteSheet:setFrameHeight(height)
    self:setFrameSize(self._frameWidth, height)
end

function SpriteSheet:getFrameHeight()
    return self._frameHeight
end

---------------------------------------
-- タイルのフレーム番号を設定します。
---------------------------------------
function SpriteSheet:setFrame(value)
    self._frame = value
    self.deck:setIndex(value)
end

---------------------------------------
-- タイルのフレーム番号を返します。
---------------------------------------
function SpriteSheet:getFrame()
    return self._frame
end

---------------------------------------
-- フレームアニメーションを行います。
-- modeには、
---------------------------------------
function SpriteSheet:moveFrames(frames, sec, mode)
    mode = mode and mode or MOAITimer.LOOP

    local curve = self._frameCurve
    curve:reserveKeys(#frames)
    for i = 1, #frames do
        curve:setKey ( i, sec * (i - 1), frames[i], MOAIEaseType.FLAT )
    end

    local anim = self._frameAnim
    anim:reserveLinks(1)
    anim:setMode(mode)
    anim:setLink(1, curve, self.prop, MOAIProp2D.ATTR_INDEX )
    anim:setCurve(curve)
    
    if anim:isBusy() then
        anim:stop()
    end
    
    anim:start()
    return anim
end

function SpriteSheet:playFrames()

end

---------------------------------------
-- フレームアニメーションを停止します。
---------------------------------------
function SpriteSheet:stopFrames()
    self._frameAnim:stop()
end

---------------------------------------
-- フレームアニメーションのループ時の処理を行います。
---------------------------------------
function SpriteSheet:onFrameLoop(event)

end

---------------------------------------
-- フレームアニメーション停止時の処理を行います。
---------------------------------------
function SpriteSheet:onFrameStop(event)

end
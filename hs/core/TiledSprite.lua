local table = require("hs/lang/table")
local TextureCache = require("hs/core/TextureCache")
local DisplayObject = require("hs/core/DisplayObject")
local Event = require("hs/core/Event")

--------------------------------------------------------------------------------
-- テクスチャをタイル毎に分割して、タイル毎に描画するクラスです.<br>
-- TODO:クラス名がTiledSpriteに変更される予定.TiledSpriteは任意のフレームに変更される.<br>
-- @class table
-- @name TiledSprite
--------------------------------------------------------------------------------
local TiledSprite = DisplayObject()

-- プロパティ定義
TiledSprite:setPropertyName("frame")
TiledSprite:setPropertyName("frameWidth")
TiledSprite:setPropertyName("frameHeight")
TiledSprite:setPropertyName("texture")

---------------------------------------
-- コンストラクタです
-- @name TiledSprite:new
---------------------------------------
function TiledSprite:init(texture, frameWidth, frameHeight, params)
    TiledSprite:super(self)

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
            local e = Event:new(Event.FRAME_LOOP)
            self:onFrameLoop(e)
            self:dispatchEvent(e)
        end
    )
    self._frameAnim:setListener(MOAIAction.EVENT_STOP,
        function(prop)
            local e = Event:new(Event.FRAME_STOP)
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
-- MOAIDeckを生成します.
---------------------------------------
function TiledSprite:newDeck()
    return MOAITileDeck2D.new()
end

---------------------------------------
-- テキスチャを設定します.
-- サイズも自動で設定されます.
---------------------------------------
function TiledSprite:setTexture(texture)
    if type(texture) == "string" then
        texture = TextureCache:get(texture)
    end

    local width, height = texture:getSize()
    self.deck:setTexture(texture)
    self._texture = texture

    self:setSize(width / self.frameWidth, height / self.frameHeight)
end

---------------------------------------
-- テキスチャを返します.
-- @return texture
---------------------------------------
function TiledSprite:getTexture()
    return self._texture
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します.
---------------------------------------
function TiledSprite:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.deck:setRect(0, self.height, self.width, 0)
end

---------------------------------------
-- タイルのフレーム数を設定します.
---------------------------------------
function TiledSprite:setFrameSize(width, height)
    self._frameWidth = width
    self._frameHeight = height
    self.deck:setSize(width, height)
    if self.texture then
        self.texture = self.texture
    end
end

---------------------------------------
-- タイルのフレーム数を設定します.
---------------------------------------
function TiledSprite:setFrameWidth(width)
    self:setFrameSize(width, self._frameHeight)
end

---------------------------------------
-- タイルのフレーム数を返します.
-- @return frameWidth
---------------------------------------
function TiledSprite:getFrameWidth()
    return self._frameWidth
end

---------------------------------------
-- タイルのフレーム数を設定します.
---------------------------------------
function TiledSprite:setFrameHeight(height)
    self:setFrameSize(self._frameWidth, height)
end

---------------------------------------
-- タイルのフレーム数を返します.
-- @return frameHeight
---------------------------------------
function TiledSprite:getFrameHeight()
    return self._frameHeight
end

---------------------------------------
-- タイルのフレーム番号を設定します.
---------------------------------------
function TiledSprite:setFrame(value)
    self._frame = value
    self.deck:setIndex(value)
end

---------------------------------------
-- タイルのフレーム番号を返します.
---------------------------------------
function TiledSprite:getFrame()
    return self._frame
end

---------------------------------------
-- フレームアニメーションを行います.
-- TODO:改善されたアニメーションに置き換わる
---------------------------------------
function TiledSprite:moveFrames(frames, sec, mode)
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

---------------------------------------
-- フレームアニメーションを停止します.
---------------------------------------
function TiledSprite:stopFrames()
    self._frameAnim:stop()
end

---------------------------------------
-- フレームアニメーションのループ時の処理を行います.
---------------------------------------
function TiledSprite:onFrameLoop(event)

end

---------------------------------------
-- フレームアニメーション停止時の処理を行います.
---------------------------------------
function TiledSprite:onFrameStop(event)

end

return TiledSprite
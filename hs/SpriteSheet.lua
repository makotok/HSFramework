--------------------------------------------------------------------------------
-- テクスチャを任意のフレーム数で分割して、
-- All Rights Reserved.
--------------------------------------------------------------------------------

SpriteSheet = DisplayObject()

-- プロパティ定義
DisplayObject:setPropertyDef("frame", "setFrame", "getFrame")
DisplayObject:setPropertyDef("frameWidth", "setFrameWidth", "getFrameWidth")
DisplayObject:setPropertyDef("frameHeight", "setFrameHeight", "getFrameHeight")
DisplayObject:setPropertyDef("texture", "setTexture", "getTexture")

---------------------------------------
-- コンストラクタです
---------------------------------------
function SpriteSheet:init(texture, frameWidth, frameHeight, params)
    DisplayObject.init(self)

    -- オブジェクト定義
    self._frame = 1
    self._frameWidth = 1
    self._frameHeight = 1

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
        texture = Texture:get(texture)
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

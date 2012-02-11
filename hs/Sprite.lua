--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです。
--
--------------------------------------------------------------------------------

Sprite = DisplayObject()

-- プロパティ定義
Sprite:setPropertyName("texture")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Sprite:init(texture, params)
    DisplayObject.init(self)

    -- 初期化
    if texture then
        self:setTexture(texture)
    end
    if params then
        table.copy(params, self)
    end
    
end

---------------------------------------
-- MOAIDeckを生成します。
---------------------------------------
function Sprite:newDeck()
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    return deck
end

---------------------------------------
-- テキスチャを設定します。
-- サイズも自動で設定されます。
---------------------------------------
function Sprite:setTexture(texture)
    if type(texture) == "string" then
        texture = Texture:get(texture)
    end

    local width, height = texture:getSize()
    self.deck:setTexture(texture)
    self._texture = texture

    self:setSize(width, height)
end

function Sprite:getTexture()
    return self._texture
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します。
---------------------------------------
function Sprite:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.deck:setRect(0, 0, self.width, self.height)
end

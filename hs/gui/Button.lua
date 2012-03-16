--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです。
--
--------------------------------------------------------------------------------

Button = UIComponent()

Button:setPropertyName("text")

---------------------------------------
-- 子オブジェクトを生成します。
---------------------------------------
function Button:onCreateChildren()
    -- skin情報
    self._upSkin = Skins.Button.upSkin
    self._downSkin = Skins.Button.downSkin
    self._upEffect = Skins.Button.upEffect
    self._downEffect = Skins.Button.downEffect
    
    -- 描画スプライト
    self._buttonGround = Skins.Button.skinClass:new(self._upSkin, {parent = self, width = self.width, height = self.height})
    self._buttonLabel = TextLabel:new({text = self.text, width = self.width, height = self.height, parent = self})    

    -- イベント処理
    function self._buttonGround.onTouchDown(background, e)
        self:onTouchDown_Background(event)
    end
    function self._buttonGround.onTouchUp(background, e)
        self:onTouchUp_Background(event)
    end
end

---------------------------------------
-- ボタンを押下した時の処理を行います。
---------------------------------------
function Button:onTouchDown_Background(event)
    self._buttonGround.texture = self._downSkin
    if self._downEffect then
        self._downEffect(self)
    end
    self:onTouchDown(event)
end

---------------------------------------
-- ボタンを離した時の処理を行います。
---------------------------------------
function Button:onTouchUp_Background(event)
    self._buttonGround.texture = self._upSkin
    if self._upEffect then
        self._upEffect(self)
    end
    self:onTouchUp(event)
end

---------------------------------------
-- text
---------------------------------------

function Button:setText(text)
    self._text = text
    if self._buttonLabel then
        self._buttonLabel.text = text
    end
end

function Button:getText()
    return self._text
end

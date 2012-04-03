local table = require("hs/lang/table")
local TextLabel = require("hs/core/TextLabel")
local UIComponent = require("hs/gui/UIComponent")
local Skins = require("hs/gui/Skins")

--------------------------------------------------------------------------------
-- Buttonクラスです.
-- 
--------------------------------------------------------------------------------
local Button = UIComponent()

-- properties
Button:setPropertyName("text")

---------------------------------------
-- コンストラクタです.
-- @name Button:new
-- @param  params パラメータ
---------------------------------------
function Button:init(params)
    Button:super(self, params)
end

function Button:onInitial()
    UIComponent.onInitial(self)

    -- public var
    self.upSkin = nil
    self.downSkin = nil
    self.upEffect = nil
    self.downEffect = nil
    
    -- private var
    self._pressed = false
    self._buttonGround = nil
    self._buttonLabel = nil
    self._buttonStyle = nil
end

---------------------------------------
-- 子オブジェクトを生成します。
---------------------------------------
function Button:createChildren()
    -- skin情報
    self.upSkin = Skins.Button.upSkin
    self.downSkin = Skins.Button.downSkin
    self.upEffect = Skins.Button.upEffect
    self.downEffect = Skins.Button.downEffect
    
    -- 描画スプライト
    self._buttonGround = Skins.Button.skinClass:new(self.upSkin, {parent = self, width = self.width, height = self.height})
    self._buttonLabel = TextLabel:new({text = self.text, width = self.width, height = self.height, parent = self})    

    -- イベント処理
    
    function self._buttonGround.onTouchDown(background, e)
        self:onTouchDown_background(event)
    end
    function self._buttonGround.onTouchUp(background, e)
        self:onTouchUp_background(event)
    end
end

---------------------------------------
-- ボタンを押下しているか返します.
-- @return pressed
---------------------------------------
function Button:isPressed()
    return self._pressed
end

function Button:setButtonStyle(style)
    self._buttonStyle = style
end

function Button:getButtonStyle()
    return self._buttonStyle
end

---------------------------------------
-- ボタンのスキンを設定します.
---------------------------------------
function Button:updateSkins()
    if self.isPressed() then
        
    end
end

---------------------------------------
-- ボタンを押下した時の処理を行います。
---------------------------------------
function Button:onTouchDown_background(event)
    self._pressed = true

    self._buttonGround.texture = self.downSkin
    if self.downEffect then
        self.downEffect(self)
    end
    self:onTouchDown(event)
end

---------------------------------------
-- ボタンを離した時の処理を行います。
---------------------------------------
function Button:onTouchUp_background(event)
    self._pressed = false

    self._buttonGround.texture = self.upSkin
    if self.upEffect then
        self.upEffect(self)
    end
    self:onTouchUp(event)
end

---------------------------------------
-- textを設定します.
---------------------------------------
function Button:setText(text)
    self._text = text
    if self._buttonLabel then
        self._buttonLabel.text = text
    end
end

---------------------------------------
-- textを返します.
-- @return テキスト
---------------------------------------
function Button:getText()
    return self._text
end

return Button

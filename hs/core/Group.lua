local table = require("hs/lang/table")
local DisplayObject = require("hs/core/DisplayObject")
local Graphics = require("hs/core/Graphics")

--------------------------------------------------------------------------------
-- 表示オブジェクトを含める事ができるグルーピングクラスです
--
-- @class table
-- @name Group
--------------------------------------------------------------------------------
local M = DisplayObject()

-- プロパティ定義
M:setPropertyName("layout")
M:setPropertyName("background")
M:setPropertyName("children")
M:setPropertyName("autoLayout")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    M:super(self, params)
end

function M:onInitial()
    DisplayObject.onInitial(self)
    -- オブジェクト定義
    self._children = {}
    self._background = self:newBackground()
    self._autoLayout = true
    self._layoutChanged = false
    if self._background then
        self._background._displayObject = self
    end
end

---------------------------------------
-- 背景を生成して返します.
---------------------------------------
function M:newBackground()
    return Graphics:new()
end

---------------------------------------
-- ダミーなので生成しません.
---------------------------------------
function M:newDeck()
    return nil
end

---------------------------------------
-- ダミーなので生成しません.
---------------------------------------
function M:newProp(deck)
    return nil
end

---------------------------------------
-- 子オブジェクトを追加します.
---------------------------------------
function M:addChild(child)
    if child.prop == nil then
        return
    end
    if table.indexOf(self.children, child) > 0 then
        return
    end
    
    table.insert(self.children, child)
    child.layer = self.layer
    child.parent = self
    child.nestLevel = self.nestLevel + 1
    self:setAttrLinkForChild(child)
    
    self._layoutChanged = true
    self:invalidateDisplay()
end

---------------------------------------
-- 子オブジェクトを削除します.
---------------------------------------
function M:removeChild(child)
    local i = table.indexOf(self.children, child)
    if i > 0 then
        table.remove(self.children, i)
        child.layer = nil
        child.parent = nil
        self:setAttrLinkForChild(child)
        
        self._layoutChanged = true
        self:invalidateDisplay()
    end
end

---------------------------------------
-- 子オブジェクトの属性連携を設定します.
---------------------------------------
function M:setAttrLinkForChild(child)
    child.prop:clearAttrLink(MOAIColor.INHERIT_COLOR)
    child.prop:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
    if child.parent then
        child.prop:setAttrLink(MOAIColor.INHERIT_COLOR, child.parent.prop, MOAIColor.COLOR_TRAIT)
        child.prop:setAttrLink(MOAITransform.INHERIT_TRANSFORM, child.parent.prop, MOAITransform.TRANSFORM_TRAIT)
    end
end

---------------------------------------
-- 子オブジェクトリストを返します.
---------------------------------------
function M:getChildren()
    return self._children
end

---------------------------------------
-- 子オブジェクトを返します.
---------------------------------------
function M:getChildAt(i)
    return self._children[i]
end

---------------------------------------
-- 一致する名前の子オブジェクトを返します.
---------------------------------------
function M:findChildByName(name)
    for i, child in ipairs(self.children) do
        if child.name == name then
            return child
        end
    end
    return nil
end

---------------------------------------
-- レイヤーをセットします.
-- 描画オブジェクトをMOAILayerに追加します.
---------------------------------------
function M:setLayer(layer)
    self._layer = layer
    self.background.layer = layer
    for i, child in ipairs(self.children) do
        child.layer = layer
    end
end

---------------------------------------
-- サイズを設定します.
---------------------------------------
function M:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.background:setSize(width, height)
    
    self._layoutChanged = true
    self:invalidateDisplay()
end

---------------------------------------
-- 表示するか反映します.
---------------------------------------
--[[
function M:updateVisible()
    DisplayObject.updateVisible(self, visible)
    self.background:updateVisible()
    for i, child in ipairs(self.children) do
        child:updateVisible()
    end
end
--]]
---------------------------------------
-- 表示するか設定します.
---------------------------------------
function M:setVisible(visible)
    DisplayObject.setVisible(self, visible)
    self.background.visible = visible
    for i, child in ipairs(self.children) do
        child.visible = visible
    end
end

---------------------------------------
-- 背景オブジェクトを設定します.
-- TODO:変更時の子の反映
---------------------------------------
function M:setBackground(background)
    self._background = background
end

---------------------------------------
-- 背景オブジェクトを返します.
---------------------------------------
function M:getBackground()
    return self._background
end

---------------------------------------
-- @Deprecated
-- このメソッドは非推奨です.
-- 設定してもbackgroundのdeckが使用されます.
---------------------------------------
function M:setDeck(deck)
end

---------------------------------------
-- MOAIDeckを返します.
---------------------------------------
function M:getDeck()
    if self.background then
        return self.background.deck
    else
        return nil
    end
end

---------------------------------------
-- @Deprecated
-- このメソッドは非推奨です.
-- 設定してもbackgroundのpropが使用されます.
---------------------------------------
function M:setProp(prop)
end

---------------------------------------
-- MOAIPropを返します.
---------------------------------------
function M:getProp()
    if self.background then
        return self.background.prop
    else
        return nil
    end
end

---------------------------------------
-- 親オブジェクトを設定します.
-- 親オブジェクトはGroupである必要があります.
-- nilを設定した場合、親オブジェクトはクリアされます.
-- TODO:要リファクタリング
---------------------------------------
function M:setParent(parent)
    DisplayObject.setParent(self, parent)
    for i, child in ipairs(self.children) do
        child.parent = self
    end
end

---------------------------------------
-- グループのレイアウトを設定します.
-- レイアウトクラスを設定すると、子オブジェクトの
-- 座標やサイズを自動的に設定する事が可能になります.
---------------------------------------
function M:setLayout(layout)
    self._layout = layout
    
    self._layoutChanged = true
    self:invalidateDisplay()
end

---------------------------------------
-- グループのレイアウトを返します.
---------------------------------------
function M:getLayout()
    return self._layout
end

---------------------------------------
-- 自動的にレイアウトを調整するか設定します.
---------------------------------------
function M:setAutoLayout(value)
    self._autoLayout = value
    if value then
        self._layoutChanged = true
        self:invalidateDisplay()
    end
end

---------------------------------------
-- 自動的にレイアウトを調整するか返します.
---------------------------------------
function M:getAutoLayout()
    return self._autoLayout
end

---------------------------------------
-- 子オブジェクトのレイアウトを更新します.
---------------------------------------
function M:updateLayout()
    -- レイアウトを変更した場合
    for i, child in ipairs(self.children) do
        if child.updateLayout then
            child:updateLayout()
        end
    end
    if self.layout and self.autoLayout then
        self.layout:update(self)
    end
    
    self._layoutChanged = false
end
---------------------------------------
-- 子オブジェクトのレイアウトを更新します.
---------------------------------------
function M:updateDisplay()
    -- レイアウトを変更した場合
    if self._layoutChanged then
        self:updateLayout()
    end
end

---------------------------------------
-- 子オブジェクトの表示順を更新します.
---------------------------------------
function M:updatePriority()
    if not self.layer then
        return
    end
    
    local layer = self.layer
    self.priority = layer.nextPriority()
    
    for i, child in ipairs(self.children) do
        child:updatePriority()
    end
end

---------------------------------------
-- リソースを削除します.
---------------------------------------
function M:dispose()
    self.parent = nil
end

return M

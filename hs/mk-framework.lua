--------------------------------------------------------------------------------
-- Copyright (c) 2010-2011 makoto kinoshita
-- All Rights Reserved.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- グローバル関数群
--------------------------------------------------------------------------------

---------------------------------------
--- コンソールにデバッグ文字列を表示します。
---------------------------------------
function printf ( ... )
    return io.stdout:write ( string.format ( ... ))
end

---------------------------------------
--- 配列から一致する値を検索して、見つかった位置を返します。
---------------------------------------
function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

---------------------------------------
--- テクスチャをロードして返します。
--- テクスチャはキャッシュされます。
---------------------------------------
local textureCache = {}
function getTexture(path)
    if textureCache[path] == nil then
        local texture = MOAITexture.new ()
        texture:setFilter ( MOAITexture.GL_LINEAR)
        texture:load (path)
        textureCache[path] = texture
    end
    return textureCache[path]
end

--------------------------------------------------------------------------------
-- クラス定義群
--------------------------------------------------------------------------------

----------------------------------------------------------------
-- GameFrameworkクラス定義
----------------------------------------------------------------
GameFramework = {}

---------------------------------------
--- フレームワークの初期化処理です
--- この関数は、フレームワークを使用する側で、
--- 必ず一度だけコールしなければなりません。
--- フレームワークの初期化処理を変更する場合、
--- この関数の動作を変更する事で可能です。
---------------------------------------
function GameFramework:initialize()
    InputManager.initialize()
end

----------------------------------------------------------------
--- MOAIUtilsクラス定義
----------------------------------------------------------------
MOAIUtils = {}

---------------------------------------
--- MOAIProp2Dのサイズを返します。
--- サイズ計算は、getRect関数の位置より求められます。
--- @param prop
--- @return width, height
---------------------------------------
function MOAIUtils.getPropSize(prop)
    local xMin, yMin, xMax, yMax = prop:getRect()
    local propWidth = math.abs(xMax - xMin)
    local propHeight = math.abs(yMax - yMin)

    return propWidth, propHeight
end

----------------------------------------------------------------
--- Logクラス定義
----------------------------------------------------------------
Log = {}

-- 定数
Log.LEVEL_NONE = 0
Log.LEVEL_INFO = 1
Log.LEVEL_ERROR = 2
Log.LEVEL_DEBUG = 3

-- 変数
Log.level = Log.LEVEL_DEBUG

function Log.info(msg)
    if Log.level >= Log.LEVEL_INFO then
        print("[info]", msg)
    end
end

function Log.error(msg)
    if Log.level >= Log.LEVEL_ERROR then
        print("[error]", msg)
    end
end

function Log.debug(msg)
    if Log.level >= Log.LEVEL_DEBUG then
        print("[debug]", msg)
    end
end

----------------------------------------------------------------
--- Eventクラス定義
----------------------------------------------------------------
Event = {}

Event.OPEN = "open"
Event.CLOSE = "close"
Event.ACTIVATE = "activate"
Event.DEACTIVATE = "deactivate"
Event.CLICK = "click"
Event.POINTER = "pointer"
Event.KEYBORD = "keybord"

---------------------------------------
--- コンストラクタです
---------------------------------------
function Event.new(id, target)
    local obj = {}
    obj.eventID = id
    obj.target = target
    return obj
end

----------------------------------------------------------------
--- EventDispatcherクラス定義
----------------------------------------------------------------
EventDispatcher = {}

---------------------------------------
--- コンストラクタです
---------------------------------------
function EventDispatcher.new()
    local obj = {}
    obj.eventTable = {}
    setmetatable(obj, {__index = EventDispatcher})
    return obj
end

---------------------------------------
--- イベントリスナを登録します。
--- @param eventID
--- @param callback
---------------------------------------
function EventDispatcher:addListener(eventID, callback)
    if self:hasListener(eventID, callback) then
        return false
    end
    local eventObject = {}
    eventObject.eventID = eventID
    eventObject.callback = callback
    table.insert(self.eventTable, eventObject)
    return true
end

---------------------------------------
--- イベントリスナを削除します。
---------------------------------------
function EventDispatcher:removeListener(eventID, callback)
    for key, obj in ipairs(self.eventTable) do
        if obj.eventID == eventID and obj.callback == callback then
            table.remove(self.eventTable, key)
            return true
        end
    end
    return false
end

---------------------------------------
--- イベントリスナを登録済か返します。
---------------------------------------
function EventDispatcher:hasListener(eventID, callback)
    for key, obj in ipairs(self.eventTable) do
        if obj.eventID == eventID and obj.callback == callback then
            return true
        end
    end
    return false
end

---------------------------------------
--- イベントをディスパッチします
---------------------------------------
function EventDispatcher:dispatchEvent(event)
    for key, obj in ipairs(self.eventTable) do
        if obj.eventID == event.eventID then
            obj.callback(event)
        end
    end
end

----------------------------------------------------------------
--- Windowクラス定義
----------------------------------------------------------------
Window = {}
Window.title = ""
Window.width = 0
Window.height = 0

function Window.openWindow(title, width, height)
    MOAISim.openWindow(title, width, height)

    -- Windowプロパティ
    Window.title = title
    Window.width = width
    Window.height = height

    -- レイヤー
    Window.topLayer = Layer.new(width, height)
    Window.hudLayer = Layer.new(width, height)

    -- topLayerはプライオリティによりソート可能にする
    -- macだと動かない
    --Window.topLayer:setSortMode(MOAILayer2D.SORT_PRIORITY_DESCENDING)

    --レンダラーパスに追加
    MOAISim.pushRenderPass(Window.topLayer)
    MOAISim.pushRenderPass(Window.hudLayer)

end

----------------------------------------------------------------
-- Sceneクラス定義
----------------------------------------------------------------
Scene = {}
Scene.priority = 0

---------------------------------------
-- コンストラクタです
---------------------------------------
function Scene.new(name)
    --
    local obj = {}
    obj.name = name
    obj.active = false
    obj.eventDispatcher = EventDispatcher.new()
    obj.layer = Layer.new(Window.width, Window.height)
    --obj.layer:setPriority(0)

    ---------------------------------------
    -- シーンを開きます
    ---------------------------------------
    function obj:openScene()
        -- 開いた時の処理
        local event = Event.new(Event.OPEN, self)
        self:onOpen(event)
        self:dispatchEvent(event)

        -- ログ
        Log.debug(self.name .. ":onOpen(event)")

        -- マネージャにスタック
        SceneManager:addScene(self)
    end

    ---------------------------------------
    -- シーンを閉じます
    ---------------------------------------
    function obj:closeScene()
        -- 閉じた時の処理
        local event = Event.new(Event.CLOSE, self)
        self:onClose(event)
        self:dispatchEvent(event)

        -- ログ
        Log.debug(self.name .. ":onClose(event)")

        -- マネージャから削除
        SceneManager:removeScene(self)
    end

    function obj:orderToFront()
        SceneManager:orderToFront(self)
    end

    function obj:orderToBack()
        SceneManager:orderToBack(self)
    end

    ---------------------------------------
    -- シーンの有効化状態を設定します。
    -- 変更された場合で、trueの場合はonActivate()、
    -- falseの場合はonDeactivate()が呼ばれます
    ---------------------------------------
    function obj:setActive(value)
        if self.active ~= value then
            if value == true then
                local event = Event.new(Event.ACTIVATE, self)
                self.active = true
                self:onActivate(event)
                self:dispatchEvent(event)
                Log.debug(self.name .. ":onActivate(event)")
            elseif value == false then
                local event = Event.new(Event.DEACTIVATE, self)
                self.active = false
                self:onDeactivate(event)
                self:dispatchEvent(event)
                Log.debug(self.name .. ":onDeactivate(event)")
            end
        end
    end

    ---------------------------------------
    --- コールバック関数を登録します。
    --- @param eventID
    --- @param callback
    --- @return 登録した場合はtrue
    ---------------------------------------
    function obj:addListener(eventID, callback)
        return self.eventDispatcher:addListener(eventID, callback)
    end

    ---------------------------------------
    --- コールバック関数を削除します。
    --- @param eventID
    --- @param callback
    --- @return 削除した場合はtrue
    ---------------------------------------
    function obj:removeListener(eventID, callback)
        return self.eventDispatcher:removeListener(eventID, callback)
    end

    ---------------------------------------
    -- コールバック関数が登録済か返します。
    ---------------------------------------
    function obj:hasListener(eventID, callback)
        return self.eventDispatcher:hasListener(eventID, callback)
    end

    ---------------------------------------
    -- イベントをディスパッチします。
    ---------------------------------------
    function obj:dispatchEvent(event)
        self.eventDispatcher:dispatchEvent(event)
    end

    ---------------------------------------
    -- シーンを開いた時のイベントハンドラ関数です
    -- 子クラスで継承してください
    ---------------------------------------
    function obj:onOpen(event)
    end

    ---------------------------------------
    -- シーンを閉じた時のイベントハンドラ関数です
    -- 子クラスで継承してください
    ---------------------------------------
    function obj:onClose(event)
    end

    ---------------------------------------
    -- シーンを閉じた時のイベントハンドラ関数です
    -- 子クラスで継承してください
    ---------------------------------------
    function obj:onActivate(event)
    end

    ---------------------------------------
    -- シーンを閉じた時のイベントハンドラ関数です
    -- 子クラスで継承してください
    ---------------------------------------
    function obj:onDeactivate(event)
    end

    ---------------------------------------
    -- マウスをクリックした時のイベントハンドラ関数です
    -- 子クラスで継承してください
    ---------------------------------------
    function obj:onClick(event)
    end

    ---------------------------------------
    -- マウスのポインターを動かした時の
    -- イベントハンドラ関数です
    -- 子クラスで継承してください
    ---------------------------------------
    function obj:onPointer(x, y)
    end

    ---------------------------------------
    -- キーボードを押下した時のイベントハンドラ関数です
    -- 子クラスで継承してください
    ---------------------------------------
    function obj:onKeybord(key, down)
    end

    return obj
end

----------------------------------------------------------------
-- SceneManagerクラス定義
----------------------------------------------------------------
SceneManager = {}
SceneManager.scenes = {}
SceneManager.currentScene = nil

function SceneManager:addScene(scene)
    if table.indexOf(self.scenes, scene) then
        table.insert(self.scenes, scene)
        if self.currentScene ~= nil then
            self.currentScene:setActive(false)
        end
        self.currentScene = scene
        self.currentScene:setActive(true)

        -- TopLayerにSceneLayerを追加
        Window.topLayer:insertProp(scene.layer)
    end
end

function SceneManager:removeScene(scene)
    local i = table.indexOf(self.scenes, scene)
    if i > 0 then
        -- 現在のシーンを無効
        if self.currentScene == scene then
            self.currentScene:setActive(false)
        end

        table.remove(self.scenes, i)

        local maxn = table.maxn(self.scenes)
        if maxn > 0 then
            self.currentScene = self.scenes[maxn]
            self.currentScene:setActive(true)
        else
            self.currentScene = nil
        end

        -- TopLayerからSceneLayerを削除
        Window.topLayer:removeProp(scene.layer)
    end
end

function SceneManager:orderToFront(scene)
    if SceneManager.currentScene ~= scene then
        removeScene(scene)
        addScene(scene)
    end
end

function SceneManager:orderToBack(scene)

end

----------------------------------------------------------------
-- InputManagerクラス定義
----------------------------------------------------------------
InputManager = {}
InputManager.pointer = {x = 0, y = 0, down = false}
InputManager.keybord = {key = 0, down = false}
InputManager.dispatcher = EventDispatcher.new()

---------------------------------------
-- InputManagerの初期化処理です
---------------------------------------
function InputManager.initialize()
    -- コールバック関数の登録
    if MOAIInputMgr.device.pointer then
        -- mouse input
        MOAIInputMgr.device.pointer:setCallback (InputManager.onPointer)
        MOAIInputMgr.device.mouseLeft:setCallback (InputManager.onClick)
    else
        -- touch input
        MOAIInputMgr.device.touch:setCallback (InputManager.onTouch)
    end

    -- keybord input
    if MOAIInputMgr.device.keyboard then
        MOAIInputMgr.device.keyboard:setCallback(InputManager.onKeyboard)
    end
end

---------------------------------------
--- コールバック関数を登録します。
--- @param eventID
--- @param callback
--- @return 登録した場合はtrue
---------------------------------------
function InputManager.addListener(eventID, callback)
    return InputManager.dispatcher:addListener(eventID, callback)
end

---------------------------------------
--- コールバック関数を削除します。
--- @param eventID
--- @param callback
--- @return 削除した場合はtrue
---------------------------------------
function InputManager.removeListener(eventID, callback)
    return InputManager.dispatcher:removeListener(eventID, callback)
end

---------------------------------------
-- コールバック関数が登録済か返します。
---------------------------------------
function InputManager.hasListener(eventID, callback)
    return InputManager.dispatcher:hasListener(eventID, callback)
end

---------------------------------------
-- イベントをディスパッチします。
---------------------------------------
function InputManager.dispatchEvent(event)
    InputManager.dispatcher:dispatchEvent(event)
end

---------------------------------------
-- マウスを動かした時のイベント処理です
---------------------------------------
function InputManager.onPointer(x, y)
    InputManager.pointer.x = x
    InputManager.pointer.y = y
    local scene = SceneManager.currentScene
    if scene ~= nil then
        local event = Event.new(Event.POINTER, scene)
        event.x = x
        event.y = y
        scene:onPointer(event)
        scene:dispatchEvent(event)
        InputManager.dispatchEvent(event)
    end
end

---------------------------------------
-- マウスを押下した時のイベント処理です
---------------------------------------
function InputManager.onClick(down)
    InputManager.pointer.down = down
    local scene = SceneManager.currentScene
    if scene ~= nil then
        local event = Event.new(Event.CLICK, scene)
        event.down = down
        event.x = InputManager.pointer.x
        event.y = InputManager.pointer.y
        scene:onClick(event)
        scene:dispatchEvent(event)
        InputManager.dispatchEvent(event)
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です
---------------------------------------
function InputManager.onTouch(eventType, idx, x, y, tapCount)
    InputManager.onPointer( x, y )
    if eventType == MOAITouchSensor.TOUCH_DOWN then
        InputManager.onClick( true )
    elseif eventType == MOAITouchSensor.TOUCH_UP then
        InputManager.onClick( false )
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です
---------------------------------------
function InputManager.onKeyboard( key, down )
    InputManager.keybord.key = key
    InputManager.keybord.down = down
    local scene = SceneManager.currentScene
    if scene ~= nil then
        local event = Event.new(Event.KEYBORD, scene)
        event.key = key
        event.down = down
        scene:onKeybord(event)
        scene:dispatchEvent(event)
        InputManager.dispatchEvent(event)
    end
end

----------------------------------------------------------------
-- Layer クラスの定義
----------------------------------------------------------------
Layer = {}

function Layer.new(width, height)
    -- ビューポート
    local viewport = MOAIViewport.new ()
    if width ~= nil and height ~= nil then
        viewport:setSize ( width, height )
        viewport:setScale ( width, -height )
    end
    viewport:setOffset(-1, 1)

    -- レイヤー
    local layer = MOAILayer2D.new ()
    layer:setViewport(viewport)

    -- パーティーション
    local partition = MOAIPartition.new ()
    layer:setPartition(partition)

    -- private変数
    local props = {}

    -- superオブジェクト
    local super = {}

    ------------------------------------
    -- Orverride
    ------------------------------------
    super.insertProp = layer.insertProp
    function layer:insertProp(prop)
        if self:indexOfProp(prop) > 0 then
            return
        end
        table.insert(props, prop)
        super.insertProp(self, prop)
    end

    super.removeProp = layer.removeProp
    function layer:removeProp(prop)
        local i = self:indexOfProp(prop)
        if i > 0 then
            table.remove(props, i)
            super.removeProp(self, prop)
        end
    end

    function layer:indexOfProp(prop)
        for i, k in ipairs(props) do
            if k == prop then
                return i
            end
        end
        return 0
    end

    function layer:setSize(width, height)
        viewport:setSize(width, height)
        viewport:setScale (width, -height)
    end

    function layer:updateLayout()
        if self.layout then
            self.layout:update(layer, props)
        end
    end

    return layer

end

----------------------------------------------------------------
-- BoxLayout クラスの定義
----------------------------------------------------------------
BoxLayout = {}

-- 定数
-- hAlign
BoxLayout.H_LEFT = "left"
BoxLayout.H_MIDDLE = "middle"
BoxLayout.H_RIGHT = "right"

BoxLayout.V_TOP = "top"
BoxLayout.V_MIDDLE = "middle"
BoxLayout.V_BOTTOM = "bottom"

BoxLayout.DIRECTION_V = "vertical"
BoxLayout.DIRECTION_H = "horizotal"

-- 変数
BoxLayout.hAlign = BoxLayout.H_MIDDLE
BoxLayout.hGap = 5
BoxLayout.vAlign = BoxLayout.V_MIDDLE
BoxLayout.vGap = 5
BoxLayout.pTop = 5
BoxLayout.pBottom = 5
BoxLayout.pLeft = 5
BoxLayout.pRight = 5
BoxLayout.direction = BoxLayout.DIRECTION_V

function BoxLayout.new()
    local obj = {}
    setmetatable(obj, {__index = BoxLayout})
    return obj
end

function BoxLayout:update(layer, props)
    local layerWidth, layerHeight = MOAIUtils.getPropSize(layer)
    if self.direction == BoxLayout.DIRECTION_V then
        self:updateVertical(0, 0, layerWidth, layerHeight, props)
    elseif self.direction == BoxLayout.DIRECTION_H then
        self:updateHorizotal(0, 0, layerWidth, layerHeight, props)
    end
end

function BoxLayout:updateVertical(parentX, parentY, parentWidth, parentHeight, props)
    local propsWidth, propsHeight = self:getVerticalLayoutSize(props)
    local propY = self:getPropY(parentHeight, propsHeight) + parentY

    for i, prop in ipairs(props) do
        local propWidth, propHeight = MOAIUtils.getPropSize(prop)
        local propX = self:getPropX(parentWidth, propWidth) + parentX
        prop:setLoc(propX, propY)
        propY = propY + propHeight + self.vGap
    end
end

function BoxLayout:updateHorizotal(parentX, parentY, parentWidth, parentHeight, props)
    local propsWidth, propsHeight = self:getHorizotalLayoutSize(props)
    local propX = self:getPropX(parentWidth, propsWidth) + parentX

    for i, prop in ipairs(props) do
        local propWidth, propHeight = MOAIUtils.getPropSize(prop)
        local propY = self:getPropY(parentHeight, propHeight) + parentY
        prop:setLoc(propX, propY)
        propX = propX + propWidth + self.hGap
    end
end

function BoxLayout:getPropX(layerWidth, propWidth)
    -- サイズの計算
    local diffWidth = layerWidth - propWidth

    -- Horizotal
    local x
    if self.hAlign == BoxLayout.H_LEFT then
        x = self.pLeft
    elseif self.hAlign == BoxLayout.H_MIDDLE then
        x = math.floor((diffWidth + self.pLeft - self.pRight) / 2)
    elseif self.hAlign == BoxLayout.H_RIGHT then
        x = diffWidth - self.pRight
    end

    return x
end

function BoxLayout:getPropY(layerHeight, propHeight)
    -- サイズの計算
    local diffHeight = layerHeight - propHeight

    -- Vertical
    local y
    if self.vAlign == BoxLayout.V_TOP then
        y = self.pTop
    elseif self.vAlign == BoxLayout.V_MIDDLE then
        y = math.floor((diffHeight + self.pTop - self.pBottom) / 2)
    elseif self.vAlign == BoxLayout.V_BOTTOM then
        y = diffWidth - self.pBottom
    end

    return y
end

function BoxLayout:getPropsMaxSize(props)

end

function BoxLayout:getVerticalLayoutSize(props)
    local width = 0
    local height = 0
    for i, prop in ipairs(props) do
        local pWidth, pHeight = MOAIUtils.getPropSize(prop)
        height = height + pHeight + self.vGap
        width = math.max(width, pWidth)
    end
    if table.maxn(props) > 1 then
        height = height - self.vGap
    end
    return width, height
end

function BoxLayout:getHorizotalLayoutSize(props)
    local width = 0
    local height = 0
    for i, prop in ipairs(props) do
        local pWidth, pHeight = MOAIUtils.getPropSize(prop)
        width = width + pWidth + self.hGap
        height = math.max(height, pHeight)
    end
    if table.maxn(props) > 1 then
        width = width - self.hGap
    end
    return width, height
end


----------------------------------------------------------------
-- VBoxLayout クラスの定義
----------------------------------------------------------------
VBoxLayout = {}
setmetatable(VBoxLayout, {__index = BoxLayout})

function VBoxLayout.new()
    local obj = {}
    setmetatable(obj, {__index = VBoxLayout})
    return obj
end

function VBoxLayout:update(layer, props)
    local layerWidth, layerHeight = MOAIUtils.getPropSize(layer)
    self:updateVertical(0, 0, layerWidth, layerHeight, props)
end

----------------------------------------------------------------
-- HBoxLayout クラスの定義
----------------------------------------------------------------
HBoxLayout = {}
setmetatable(HBoxLayout, {__index = BoxLayout})

function HBoxLayout.new()
    local obj = {}
    setmetatable(obj, {__index = HBoxLayout})
    return obj
end

function HBoxLayout:update(layer, props)
    local layerWidth, layerHeight = MOAIUtils.getPropSize(layer)
    self:updateHorizotal(0, 0, layerWidth, layerHeight, props)
end

----------------------------------------------------------------
-- TableLayout クラスの定義
----------------------------------------------------------------
TableLayout = {}
setmetatable(TableLayout, {__index = BoxLayout})

function TableLayout.new()
    local obj = {}
    setmetatable(obj, {__index = TableLayout})
    return obj
end

function TableLayout:update(layer, props)
    local layerWidth, layerHeight = MOAIUtils.getPropSize(layer)
    if self.direction == BoxLayout.DIRECTION_V then
        local childProps = {}
        local childCount = 0
        for i, v in ipairs(props) do

            self:updateVertical(0, 0, layerWidth, layerHeight, props)
        end
    elseif self.direction == BoxLayout.DIRECTION_H then
        self:updateHorizotal(0, 0, layerWidth, layerHeight, props)
    end
end


----------------------------------------------------------------
-- Button クラスの定義
----------------------------------------------------------------
Button = {}

function Button.new()
    local obj = {}
end

----------------------------------------------------------------
-- ListBox クラスの定義
----------------------------------------------------------------
ListBox = {}
ListBox.style = {}
ListBox.style.itemRendererFactory = {}
ListBox.style.itemHeight = 20

function ListBox.new(width, height)
    local obj = Layer.new(width, height)
    obj.dataProvider = {}

    function obj:addItem(item)
        table.insert(obj.dataProvider, item)
    end

    function obj:removeItem(item)
        local i = table.indexOf(obj.dataProvider)
        self:removeItemAt(i)
    end

    function obj:removeItemAt(index)
        table.remove(obj.dataProvider, index)
    end

    function obj:getItemAt(index)
        return self.dataProvider[index]
    end

end

----------------------------------------------------------------
-- ItemRendererFactory クラスの定義
----------------------------------------------------------------
TextBoxRendererFactory = {}

function TextBoxRendererFactory.new()
    local obj = {}
    setmetatable(obj, {__index = TextBoxRendererFactory})
    return obj
end

function TextBoxRendererFactory:newRenderer(value, width, height)
    local textBox = TextBox.new()
end

----------------------------------------------------------------
-- TileList クラスの定義
----------------------------------------------------------------
TileList = {}

function TileList.new()

end

----------------------------------------------------------------
--- Fontクラスの定義
----------------------------------------------------------------
Font = {}
Font.charcodes =
[[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-
、。，．・：；？！｀＾　
＿ヽヾゝゞ〃仝々〆〇ー―‐／＼
～∥｜…‥‘’“”（）〔〕［］｛
｝〈〉《》「」『』【】＋－±×
÷＝≠＜＞≦≧∞∴♂♀°′″℃￥
０１２３４５６７８９
ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰ
ＱＲＳＴＵＶＷＸＹＺ
ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏ
ｐｑｒｓｔｕｖｗｘｙｚ
ぁあぃいぅうぇえぉおかがきぎくぐけ
げこごさざしじすずせぜそぞただち
ぢっつづてでとどなにぬねのはばぱ
ひびぴふぶぷへべぺほぼぽまみむめ
もゃやゅゆょよらりるれろゎわゐゑ
をん
ァアィイゥウェエォオカガキギクグ
ケゲコゴサザシジスズセゼソゾタダ
チヂッツヅテデトドナニヌネノハバ
パヒビピフブプヘベペホボポマミ
ムメモャヤュユョヨラリルレロヮワ
ヰヱヲンヴヵヶ]]

function Font.new(ttfPath)
    local font = MOAIFont.new()
    font:loadFromTTF (ttfPath, Font.charcodes, 9, 163)
    return font
end

----------------------------------------------------------------
--- TextBox クラスの定義
----------------------------------------------------------------
TextBox = {}
TextBox.style = {}
TextBox.style.fontTTF = "font.ttf"
TextBox.font = nil

function TextBox.new()
    if TextBox.font == nil then
        TextBox.font = Font.new(TextBox.style.fontTTF)
    end

    local textbox = MOAITextBox.new ()
    local font = TextBox.font
    textbox:setFont ( font )
    textbox:setTextSize ( font:getScale ())
    --textbox:setYFlip ( true )

    function textbox:setSize(width, height)
        textbox:setRect ( 0, 0, width, height )
    end

    function textbox:setData(data)
        textbox.data = data
        textbox.setString(data)
    end

    return textbox
end

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


----------------------------------------------------------------
--- Sprite クラスの定義
----------------------------------------------------------------
Sprite = {}

---------------------------------------
-- コンストラクタです
---------------------------------------
function Sprite.new(texture)
    local gfxQuad = MOAIGfxQuad2D.new()
    gfxQuad:setUVRect(0, 0, 1, 1)

    local prop = MOAIProp2D.new ()
    prop:setDeck ( gfxQuad )

    ---------------------------------------
    --- サイズを設定します。
    ---------------------------------------
    function prop:setSize(w, h)
        gfxQuad:setRect(0, 0, w, h)
    end

    ---------------------------------------
    --- テキスチャを設定します。
    --- サイズも自動で設定されます。
    ---------------------------------------
    function prop:setTexture(texture)
        if type(texture) == "string" then
            texture = getTexture(texture)
        end

        local width, height = texture:getSize()
        gfxQuad:setTexture(texture)
        gfxQuad:setRect(0, 0, width, height )
    end

    -- 初期化
    if texture ~= nil then
        prop:setTexture(texture)
    end

    return prop
end

----------------------------------------------------------------
-- SpriteSheet クラスの定義
----------------------------------------------------------------
SpriteSheet = {}

---------------------------------------
-- コンストラクタです
---------------------------------------
function SpriteSheet.new(texturePath, width, height, tileWidth, tileHeight)
    local tileDeck = MOAITileDeck2D.new()
    tileDeck:setTexture(getTexture(texturePath))
    tileDeck:setSize (width, height)
    tileDeck:setRect (0, tileHeight, tileWidth, 0)

    local prop = MOAIProp2D.new ()
    prop:setDeck (tileDeck)

    return prop
end

----------------------------------------------------------------
-- Actor クラスの定義
----------------------------------------------------------------
Actor = {}

---------------------------------------
-- Actorオブジェクトを作成して返します
-- 実体は、MOAIProp2Dです
---------------------------------------
function Actor.new(actorNo)
    -- MOAIProp2Dを継承
    local obj = MOAIProp2D.new ()

    -----------------------------------
    -- Initialize
    -----------------------------------
    -- タイル
    obj.tileDecks = {}
    for i = 0, 3 do
        local texturePath = "image/Actor" .. actorNo .. "_" .. i .. ".png"
        local tileDeck = MOAITileDeck2D.new()
        tileDeck:setTexture(getTexture(texturePath))
        tileDeck:setSize (3, 4)
        tileDeck:setRect (0, 32, 32, 0)
        obj.tileDecks[i + 1] = tileDeck
    end

    obj:setDeck (obj.tileDecks[1])

    -- アニメーションの定義
    obj.curves = {}
    obj.animes = {}
    obj.currentAnim = nil

    -- Actor0
    for i = 1, 4 do
        local curve = MOAIAnimCurve.new ()
        local startNo = (i - 1) * 3
        curve:reserveKeys ( 5 )
        curve:setKey ( 1, 0.00, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.75, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 5, 1.00, startNo + 2, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[i] = curve
        obj.animes[i] = anim
    end

    -- Actor1
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 0
        curve:reserveKeys ( 5 )
        curve:setKey ( 1, 0.00, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.75, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 5, 1.00, startNo + 2, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[5] = curve
        obj.animes[5] = anim
    end
    do
        local curve = MOAIAnimCurve.new()
        local startNo = 1 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 1.00, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP)
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX)
        anim:setCurve(curve)
        obj.curves[6] = curve
        obj.animes[6] = anim
    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 2 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.75, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[7] = curve
        obj.animes[7] = anim
    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 3 * 3
        curve:reserveKeys ( 5 )
        curve:setKey ( 1, 0.00, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.75, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 5, 1.00, startNo + 2, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[8] = curve
        obj.animes[8] = anim
    end

    -- Actor2
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 0 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 1.00, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[9] = curve
        obj.animes[9] = anim
    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 1 * 3
        curve:reserveKeys (6)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.125, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.250, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.375, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 5, 0.500, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 6, 1.000, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[10] = curve
        obj.animes[10] = anim
    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 2 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.75, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[11] = curve
        obj.animes[11] = anim
    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 3 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.75, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[12] = curve
        obj.animes[12] = anim
    end

    -- Actor3
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 0 * 3
        curve:reserveKeys (6)
        curve:setKey ( 1, 0.000, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.125, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.250, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.375, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 5, 0.500, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 6, 1.000, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[13] = curve
        obj.animes[13] = anim

    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 1 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.250, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.500, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 1.000, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[14] = curve
        obj.animes[14] = anim

    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 2 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 1.00, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[15] = curve
        obj.animes[15] = anim
    end
    do
        local curve = MOAIAnimCurve.new ()
        local startNo = 3 * 3
        curve:reserveKeys (4)
        curve:setKey ( 1, 0.00, startNo + 1, MOAIEaseType.FLAT )
        curve:setKey ( 2, 0.25, startNo + 2, MOAIEaseType.FLAT )
        curve:setKey ( 3, 0.50, startNo + 3, MOAIEaseType.FLAT )
        curve:setKey ( 4, 0.75, startNo + 3, MOAIEaseType.FLAT )

        local anim = MOAIAnim:new()
        anim:reserveLinks(1)
        anim:setMode(MOAITimer.LOOP )
        anim:setLink(1, curve, obj, MOAIProp2D.ATTR_INDEX )
        anim:setCurve(curve)
        obj.curves[16] = curve
        obj.animes[16] = anim
    end

    -- 関数の設定
    obj.setAnimNo = Actor.setAnimNo
    obj.startAnim = Actor.startAnim
    obj.stopAnim = Actor.stopAnim

    obj:setAnimNo(1)

    return obj
end

-----------------------------------
-- アニメーションを設定します
-----------------------------------
function Actor:setAnimNo(index)
    local tileNo = math.floor((index - 1) / 4) + 1
    self:setDeck(self.tileDecks[tileNo])
    if self.currentAnim ~= nil then
        self.currentAnim:stop()
    end
    self.currentAnim = self.animes[index]
    self.currentAnim:start()
    return self.currentAnim
end

-----------------------------------
-- アニメーションを開始します
-----------------------------------
function Actor:startAnim()
    self.currentAnim:start()
end

-----------------------------------
-- アニメーションを停止します
-----------------------------------
function Actor:stopAnim()
    self.currentAnim:stop()
end

----------------------------------------------------------------
-- IconSet クラスの定義
----------------------------------------------------------------

Icon = {}
function Icon.new(texturePath)
	local obj = MOAIProp2D.new ()

	-- タイル
    local tileDeck = MOAITileDeck2D.new()
    tileDeck:setTexture (getTexture(texturePath))
    tileDeck:setSize (16, 16)
    tileDeck:setRect (0, 24, 24, 0)

	obj:setDeck (tileDeck)

	return obj
end

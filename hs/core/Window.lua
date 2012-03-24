local Class = require("hs/lang/Class")
local logger = require("hs/core/Logger")
local Application = require("hs/core/Application")

----------------------------------------------------------------
-- 単一のウィンドウを管理するクラスです.
-- ウィンドウのタイトル、描画領域（Screen）を保持します.
-- @class table
-- @name Window
----------------------------------------------------------------
local Window = Class()

-- 定数
Window.MODE_STRETCH = 1
Window.MODE_EXPAND = 2
Window.MODE_FIXED_RATIO = 3
Window.MODE_EXACT = 4

function Window:init()    
    self.opened = false
    self.title = ""
    self.screenWidth = 0
    self.screenHeight = 0
    self.stageWidth = 0
    self.stageHeight = 0
    self.width = 0
    self.height = 0
    self.viewport = MOAIViewport.new()
    self.screenMode = 0
end

---------------------------------------
-- Windowを起動します.
-- titleは、ウィンドウのタイトルで使用されます.
-- width,heightは、ウィンドウのサイズになります.
--
-- ただし、モバイルアプリケーションの場合、
-- サイズが一致するわけではなく、サイズが固定の為、
-- StageにstageModeを指定する事で、描画領域の
-- 任意のロジックで引き伸ばしを行う事ができます.
---------------------------------------
function Window:open(title, width, height, stageMode)
    if self.opened == false then
        self.title = title        
        self.stageMode = stageMode
        self:initScreenSize(width, height)

        MOAISim.openWindow(self.title, self.screenWidth, self.screenHeight)
        self.opened = true
    end
end

function Window:initScreenSize(width, height)

    -- モバイルの場合、指定されたモードにより、
    -- Viewportのサイズを変更する.
    local scaleWidth = width
    local scaleHeight = height
    local stageWidth = width
    local stageHeight = height
    
    -- デスクトップアプリケーションの場合、
    -- モードをMODE_EXACTに強制する
    local deviceWidth, deviceHeight
    if Application:isMobile() == false then
        self.stageMode = Window.MODE_EXACT
        deviceWidth = width
        deviceHeight = height
    else
        --TODO:モバイルの場合の実装
    end

    -- 伸張
    if self.stageMode == Window.MODE_STRETCH then
        stageWidth = deviceWidth
        stageHeight = deviceHeight

    -- 拡大
    elseif self.stageMode == Window.MODE_EXPAND then
         -- 比率を求める
         -- TODO:実装を考える
         --[[
        local scaleX = deviceWidth / width
        local scaleY = deviceHeight / height
        if scaleX < scaleY then scaleY = scaleX end
        if scaleX > scaleY then scaleX = scaleY end

        scaleWidth = deviceWidth
        scaleHeight = deviceHeight
        stageWidth = width * scaleX
        stageHeight = height * scaleY
        --]]

    -- 比率は同一
    elseif self.stageMode == Window.MODE_FIXED_RATIO then
        -- 比率を求める
        local scaleX = deviceWidth / width
        local scaleY = deviceHeight / height
        if scaleX < scaleY then scaleY = scaleX end
        if scaleX > scaleY then scaleX = scaleY end

        stageWidth = math.floor(width * scalaX)
        stageWidth = math.floor(height * scalaY)

    -- そのまま
    elseif self.stageMode == Window.MODE_EXACT then
    end

    -- サイズを設定
    self.width = scaleWidth
    self.height = scaleHeight
    self.screenWidth = deviceWidth
    self.screenHeight = deviceHeight
    self.stageWidth = stageWidth
    self.stageHeight = stageHeight
    
    -- ビューポートを設定
    self.viewport:setOffset(-1, 1)
    self.viewport:setScale(self.width, -self.height)
    self.viewport:setSize(self.stageWidth, self.stageHeight)
    
    -- debug log
    logger.debug("Window Open! ----------")
    logger.debug("size:" .. self.width .. "," .. self.height)
    logger.debug("screenSize:" .. self.screenWidth .. "," .. self.screenHeight)
    logger.debug("stageSize:" .. self.stageWidth .. "," .. self.stageHeight)
    logger.debug("------------------------")
    
end

return Window
local table = require("hs/lang/table")
local Event = require("hs/core/Event")
local EventDispatcher = require("hs/core/EventDispatcher")

----------------------------------------------------------------
-- 単一のウィンドウを管理するクラスです.
-- ウィンドウのタイトル、描画領域（Screen）を保持します.
--
-- シングルトンなクラスとして扱います.
-- @class table
-- @name Application
----------------------------------------------------------------

local M = EventDispatcher():new()

-- プロパティ定義
M:setPropertyName("window")
M:setPropertyName("screenWidth")
M:setPropertyName("screenHeight")
M:setPropertyName("stageWidth")
M:setPropertyName("stageHeight")

---------------------------------------
-- 初期化処理を行います.
---------------------------------------
function M:initialize()
    local Window = require("hs/core/Window")
    self._window = Window:new()

    if MOAIThread then
        self._thread = MOAIThread.new()
    else
        self._thread = MOAICoroutine.new()
    end
    self._thread:run(function() self:enterFrame() end)
end

---------------------------------------
-- フレーム毎の処理を行います.
---------------------------------------
function M:enterFrame()
    local event = Event:new(Event.ENTER_FRAME)
    while true do
        self:dispatchEvent(event)
        coroutine.yield()
    end
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
function M:openWindow(title, width, height, screenMode)
    self.window:open(title, width, height, screenMode)
end

---------------------------------------
--- ウインドウを返します..
---------------------------------------
function M:getWindow()
    return self._window
end

---------------------------------------
--- 実行環境がモバイルかどうか返します.
---------------------------------------
function M:isMobile()
    local bland = MOAIEnvironment.osBrand
    return bland == MOAIEnvironment.OS_BRAND_ANDROID or bland == MOAIEnvironment.OS_BRAND_IOS
end

---------------------------------------
--- 実行環境がデスクトップかどうか返します.
---------------------------------------
function M:isDesktop()
    return not self:isMobile()
end

---------------------------------------
-- 画面の幅を返します.
-- モバイル環境の場合、シーンのサイズとは一致しません.
---------------------------------------
function M:getScreenWidth()
    return self.window.screenWidth
end

---------------------------------------
-- 画面の高さを返します.
-- モバイル環境の場合、シーンのサイズとは一致しません.
---------------------------------------
function M:getScreenHeight()
    return self.window.screenHeight
end

---------------------------------------
-- ステージの幅を返します.
-- シーンのサイズと一致します.
---------------------------------------
function M:getStageWidth()
    return self.window.stageWidth
end

---------------------------------------
-- ステージの高さを返します.
-- シーンのサイズと一致します.
---------------------------------------
function M:getStageHeight()
    return self.window.stageHeight
end

return M

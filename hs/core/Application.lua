----------------------------------------------------------------
-- 単一のウィンドウを管理するクラスです。
-- ウィンドウのタイトル、描画領域（Screen）を保持します。
--
-- シングルトンなクラスとして扱います。
----------------------------------------------------------------

Application = EventDispatcher():new()

-- プロパティ定義
Application:setPropertyName("window")
Application:setPropertyName("screenWidth")
Application:setPropertyName("screenHeight")
Application:setPropertyName("stageWidth")
Application:setPropertyName("stageHeight")

---------------------------------------
-- 初期化処理を行います。
---------------------------------------
function Application:initialize()
    self._window = Window:new()

    if MOAIThread then
        self._thread = MOAIThread.new()
    else
        self._thread = MOAICoroutine.new()
    end
    self._thread:run(function() self:enterFrame() end)
end

---------------------------------------
-- フレーム毎の処理を行います。
-- TODO:毎フレーム行うと遅いのかも・・・
---------------------------------------
function Application:enterFrame()
    local event = Event:new(Event.ENTER_FRAME, self)
    while true do
        self:dispatchEvent(event)
        coroutine.yield()
    end
end

---------------------------------------
-- Windowを起動します。
-- titleは、ウィンドウのタイトルで使用されます。
-- width,heightは、ウィンドウのサイズになります。
--
-- ただし、モバイルアプリケーションの場合、
-- サイズが一致するわけではなく、サイズが固定の為、
-- StageにstageModeを指定する事で、描画領域の
-- 任意のロジックで引き伸ばしを行う事ができます。
---------------------------------------
function Application:openWindow(title, width, height, screenMode)
    self.window:open(title, width, height, screenMode)
end

---------------------------------------
--- ウインドウを返します。。
---------------------------------------
function Application:getWindow()
    return self._window
end

---------------------------------------
--- 実行環境がモバイルかどうか返します。
---------------------------------------
function Application:isMobile()
    local bland = MOAIEnvironment.getOSBrand()
    return bland == MOAIEnvironment.OS_BRAND_ANDROID or bland == MOAIEnvironment.OS_BRAND_IOS
end

---------------------------------------
--- 実行環境がデスクトップかどうか返します。
---------------------------------------
function Application:isDesktop()
    return not self:isMobile()
end

---------------------------------------
-- 画面の幅を返します。
-- モバイル環境の場合、シーンのサイズとは一致しません。
---------------------------------------
function Application:getScreenWidth()
    return self.window.screenWidth
end

---------------------------------------
-- 画面の高さを返します。
-- モバイル環境の場合、シーンのサイズとは一致しません。
---------------------------------------
function Application:getScreenHeight()
    return self.window.screenHeight
end

---------------------------------------
-- ステージの幅を返します。
-- シーンのサイズと一致します。
---------------------------------------
function Application:getStageWidth()
    return self.window.stageWidth
end

---------------------------------------
-- ステージの高さを返します。
-- シーンのサイズと一致します。
---------------------------------------
function Application:getStageHeight()
    return self.window.stageHeight
end

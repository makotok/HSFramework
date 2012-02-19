----------------------------------------------------------------
-- 単一のウィンドウを管理するクラスです。
-- ウィンドウのタイトル、描画領域（Screen）を保持します。
--
-- シングルトンなクラスとして扱います。
----------------------------------------------------------------

Application = EventDispatcher:new()

-- プロパティ定義
Application:setPropertyName("window")
Application:setPropertyName("sceneManager")
Application:setPropertyName("screenWidth")
Application:setPropertyName("screenHeight")
Application:setPropertyName("stageWidth")
Application:setPropertyName("stageHeight")

---------------------------------------
-- 初期化処理を行います。
---------------------------------------
function Application:initialize()
    self._window = Window:new()
    self._sceneManager = SceneManager:new()
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

function Application:addScene(scene)
    self.sceneManager:addScene(scene)
end

function Application:removeScene(scene)
    self.sceneManager:removeScene(scene)
end

---------------------------------------
--- ウインドウを返します。。
---------------------------------------
function Application:getWindow()
    return self._window
end

---------------------------------------
--- シーンマネージャを返します。
---------------------------------------
function Application:getSceneManager()
    return self._sceneManager
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

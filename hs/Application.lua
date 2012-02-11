----------------------------------------------------------------
-- 単一のウィンドウを管理するクラスです。
-- ウィンドウのタイトル、描画領域（Screen）を保持します。
--
-- シングルトンなクラスとして扱います。
----------------------------------------------------------------

Application = EventDispatcher:new()

---------------------------------------
-- 初期化処理を行います。
---------------------------------------
function Application:initialize()
    self.window = Window:new()
    self.sceneManager = SceneManager:new()
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


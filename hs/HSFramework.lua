
----------------------------------------------------------------
-- モジュール参照
----------------------------------------------------------------
-- 依存関係の順に参照

-- 共通
require "hs/Class"
require "hs/Log"
require "hs/Runtime"
require "hs/Globals"

-- Event系クラス
require "hs/Event"
require "hs/EventListener"
require "hs/EventDispatcher"

-- InputManager
require "hs/InputManager"

-- 描画系クラス
require "hs/Transform"
require "hs/Texture"
require "hs/DisplayObject"
require "hs/Group"
require "hs/Layer"
require "hs/Graphics"
require "hs/Sprite"
require "hs/SpriteSheet"
require "hs/Scene"
require "hs/SceneManager"
require "hs/Window"
require "hs/Application"
require "hs/BoxLayout"
require "hs/VBoxLayout"
require "hs/HBoxLayout"

----------------------------------------------------------------
-- HSFrameworkクラス定義
----------------------------------------------------------------
HSFramework = {}

---------------------------------------
--- フレームワークの初期化処理です
--- この関数は、フレームワークを使用する側で、
--- 必ず一度だけコールしなければなりません。
--- フレームワークの初期化処理を変更する場合、
--- この関数の動作を変更する事で可能です。
---------------------------------------
function HSFramework:initialize()
    InputManager:initialize()
    Application:initialize()
end

HSFramework:initialize()

----------------------------------------------------------------
-- モジュール参照
----------------------------------------------------------------
-- 依存関係の順に参照

-- base liblary
require "hs/Class"
require "hs/Log"
require "hs/Runtime"
require "hs/Globals"
require "hs/UString"
require "hs/Event"
require "hs/EventListener"
require "hs/EventDispatcher"
require "hs/InputManager"

-- display classes
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
-- HSFramework
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
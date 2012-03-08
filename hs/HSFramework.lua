----------------------------------------------------------------
-- HSFrameworkのモジュールをロードするためのクラスです。
-- モジュールの参照、初期化を担います。
----------------------------------------------------------------

-- lang liblary
require "hs/lang/Globals"
require "hs/lang/Class"
require "hs/lang/PropertySupport"
require "hs/lang/UString"

-- util library
require "hs/util/FunctionUtil"

-- core library
require "hs/core/Log"
require "hs/core/ObjectPool"
require "hs/core/EventPool"
require "hs/core/Event"
require "hs/core/EventListener"
require "hs/core/EventDispatcher"
require "hs/core/InputManager"
require "hs/core/Transform"
require "hs/core/Texture"
require "hs/core/TextureCache"
require "hs/core/DisplayObject"
require "hs/core/Group"
require "hs/core/Layer"
require "hs/core/Graphics"
require "hs/core/Sprite"
require "hs/core/SpriteSheet"
require "hs/core/MapSprite"
require "hs/core/TextLabel"
require "hs/core/Font"
require "hs/core/FontCache"
require "hs/core/Scene"
require "hs/core/SceneAnimation"
require "hs/core/SceneFactory"
require "hs/core/SceneManager"
require "hs/core/Window"
require "hs/core/Application"
require "hs/core/BoxLayout"
require "hs/core/VBoxLayout"
require "hs/core/HBoxLayout"
require "hs/core/EaseType"
require "hs/core/Animation"
require "hs/core/FPSMonitor"

-- tmx library
require "hs/tmx/TMXMap"
require "hs/tmx/TMXMapLoader"
require "hs/tmx/TMXLayer"
require "hs/tmx/TMXObject"
require "hs/tmx/TMXObjectGroup"
require "hs/tmx/TMXTileset"

-- box2d library

----------------------------------------------------------------
-- HSFramework
----------------------------------------------------------------
HSFramework = {}
HSFramework.VERSION = "0.4"

---------------------------------------
--- フレームワークの初期化処理です
---------------------------------------
function HSFramework:initialize()
    Log.info("Hana Saurus Framework loading...", "Version:" .. HSFramework.VERSION)

    InputManager:initialize()
    SceneManager:initialize()
    Application:initialize()
end

HSFramework:initialize()
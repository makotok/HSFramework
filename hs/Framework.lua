-- lang liblary
require "hs/lang/Globals"
require "hs/lang/Class"
require "hs/lang/PropertySupport"
require "hs/lang/UString"

-- util library
require "hs/util/FunctionUtil"

-- core library
require "hs/core/Logger"
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
require "hs/core/NinePatch"
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
require "hs/box2d/Box2DWorld"
require "hs/box2d/Box2DBody"
require "hs/box2d/Box2DFixture"
require "hs/box2d/Box2DConfig"

-- gui library
require "hs/gui/UIComponent"
require "hs/gui/Button"
require "hs/gui/Skins" -- TODO:別の方法を考える
require "hs/gui/View"
require "hs/gui/ScrollView"

local logger = require("hs/core/Logger")
local InputManager = require("hs/core/InputManager")
local SceneManager = require("hs/core/SceneManager")
local Application = require("hs/core/Application")

----------------------------------------------------------------
-- HSFrameworkのモジュールをロードするためのクラスです.
-- モジュールの参照、初期化を担います.
----------------------------------------------------------------
local Framework = {initialObjects = {}}
Framework.VERSION = "0.4.2"

---------------------------------------
-- フレームワークの初期化処理です.
-- このフレームワークを使う場合に最初に実行してください.
---------------------------------------
function Framework:initialize()
    logger.info("Hana Saurus Framework loading...", "Version:" .. self.VERSION)

    for i, v in ipairs(self.initialObjects) do
        v:initialize()
    end
end

function Framework:addInitialObject(object)
    table.insert(self.initialObjects, object)
end

Framework:addInitialObject(InputManager)
Framework:addInitialObject(SceneManager)
Framework:addInitialObject(Application)

return Framework

-- lang liblary
require "hs/lang/Globals"
require "hs/lang/Class"
require "hs/lang/PropertySupport"
require "hs/lang/UString"

-- util library
require "hs/util/FunctionUtil"
require "hs/util/FPSMonitor"

-- core library
require "hs/core/Logger"
require "hs/core/Event"
require "hs/core/EventListener"
require "hs/core/EventDispatcher"
require "hs/core/InputManager"
require "hs/core/Transform"
require "hs/core/TextureManager"
require "hs/core/DisplayObject"
require "hs/core/Group"
require "hs/core/Layer"
require "hs/core/Graphics"
require "hs/core/Sprite"
require "hs/core/SpriteSheet"
require "hs/core/MapSprite"
require "hs/core/NinePatch"
require "hs/core/TextLabel"
require "hs/core/FontManager"
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
Framework.VERSION = "0.5.2"

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

---------------------------------------
-- フレームワークの初期化処理です.
-- このフレームワークを使う場合に最初に実行してください.
---------------------------------------
function Framework:importClasses(t)
    t["DisplayObject"] = require("hs/core/DisplayObject")
    t["Group"] = require("hs/core/Group")
    t["Layer"] = require("hs/core/Layer")
    t["Graphics"] = require("hs/core/Graphics")
    t["Sprite"] = require("hs/core/Sprite")
    t["SpriteSheet"] = require("hs/core/SpriteSheet")
    t["MapSprite"] = require("hs/core/MapSprite")
    t["NinePatch"] = require("hs/core/NinePatch")
    t["TextLabel"] = require("hs/core/TextLabel")
    t["Scene"] = require("hs/core/Scene")
    t["SceneAnimation"] = require("hs/core/SceneAnimation")
    t["SceneManager"] = require("hs/core/SceneManager")
    t["Application"] = require("hs/core/Application")
    t["BoxLayout"] = require("hs/core/BoxLayout")
    t["VBoxLayout"] = require("hs/core/VBoxLayout")
    t["HBoxLayout"] = require("hs/core/HBoxLayout")
    t["EaseType"] = require("hs/core/EaseType")
    t["Animation"] = require("hs/core/Animation")
    t["FPSMonitor"] = require("hs/util/FPSMonitor")

    t["TMXMap"] = require("hs/tmx/TMXMap")
    t["TMXMapLoader"] = require("hs/tmx/TMXMapLoader")
    t["TMXLayer"] = require("hs/tmx/TMXLayer")
    t["TMXObject"] = require("hs/tmx/TMXObject")
    t["TMXObjectGroup"] = require("hs/tmx/TMXObjectGroup")
    t["TMXTileset"] = require("hs/tmx/TMXTileset")
    
    t["Box2DWorld"] = require("hs/box2d/Box2DWorld")
    t["Box2DBody"] = require("hs/box2d/Box2DBody")
    t["Box2DFixture"] = require("hs/box2d/Box2DFixture")
    t["Box2DConfig"] = require("hs/box2d/Box2DConfig")
    
    t["Button"] = require("hs/gui/Button")
    t["View"] = require("hs/gui/View")
    t["ScrollView"] = require("hs/gui/ScrollView")

end

Framework:addInitialObject(InputManager)
Framework:addInitialObject(SceneManager)
Framework:addInitialObject(Application)

return Framework

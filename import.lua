--------------------------------------------------------------------------------
-- importを行うためだけのモジュールです.
-- global変数にimportを行いたくない場合はこのモジュールを使用しないで、
-- ファイル毎にimportを行ってください.
--------------------------------------------------------------------------------

-- core library
Logger = require("hs/core/Logger")
ObjectPool = require("hs/core/ObjectPool")
EventPool = require("hs/core/EventPool")
Event = require("hs/core/Event")
EventListener = require("hs/core/EventListener")
EventDispatcher = require("hs/core/EventDispatcher")
InputManager = require("hs/core/InputManager")
Transform = require("hs/core/Transform")
Texture = require("hs/core/Texture")
TextureCache = require("hs/core/TextureCache")
DisplayObject = require("hs/core/DisplayObject")
Group = require("hs/core/Group")
Layer = require("hs/core/Layer")
Graphics = require("hs/core/Graphics")
Sprite = require("hs/core/Sprite")
SpriteSheet = require("hs/core/SpriteSheet")
MapSprite = require("hs/core/MapSprite")
NinePatch = require("hs/core/NinePatch")
TextLabel = require("hs/core/TextLabel")
Scene = require("hs/core/Scene")
SceneAnimation = require("hs/core/SceneAnimation")
SceneManager = require("hs/core/SceneManager")
Application = require("hs/core/Application")
BoxLayout = require("hs/core/BoxLayout")
VBoxLayout = require("hs/core/VBoxLayout")
HBoxLayout = require("hs/core/HBoxLayout")
EaseType = require("hs/core/EaseType")
Animation = require("hs/core/Animation")
FPSMonitor = require("hs/core/FPSMonitor")

-- tmx library
TMXMap = require("hs/tmx/TMXMap")
TMXMapLoader = require("hs/tmx/TMXMapLoader")
TMXLayer = require("hs/tmx/TMXLayer")
TMXObject = require("hs/tmx/TMXObject")
TMXObjectGroup = require("hs/tmx/TMXObjectGroup")
TMXTileset = require("hs/tmx/TMXTileset")

-- box2d library
Box2DWorld = require("hs/box2d/Box2DWorld")
Box2DBody = require("hs/box2d/Box2DBody")
Box2DFixture = require("hs/box2d/Box2DFixture")
Box2DConfig = require("hs/box2d/Box2DConfig")

-- gui library
UIComponent = require("hs/gui/UIComponent")
Button = require("hs/gui/Button")
View = require("hs/gui/View")
ScrollView = require("hs/gui/ScrollView")

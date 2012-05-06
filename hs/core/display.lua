-- 使用するコンポーネント一覧
local Group
local Layer
local Graphics
local Sprite
local SpriteSheet
local MapSprite
local NinePatch
local TextLabel
local Scene
local SceneManager
local BoxLayout
local VBoxLayout
local HBoxLayout
local Animation

----------------------------------------------------------------
-- DisplayObject系のインスタンスを生成する為のクラスです.<br>
-- このクラスを使用しないで直接生成してもいいですが、
-- このクラスを使用するこで、requireが一回で済みます.
-- @class table
-- @name display
----------------------------------------------------------------
local M = {}

----------------------------------------------------------------
-- Spriteインスタンスを生成して返します.
----------------------------------------------------------------
function M:newSprite(...)
    Sprite = Sprite or require("hs/core/Sprite")
    return Sprite:new(...)
end

----------------------------------------------------------------
-- SpriteSheetインスタンスを生成して返します.
----------------------------------------------------------------
function M:newSpriteSheet(...)
    SpriteSheet = SpriteSheet or require("hs/core/SpriteSheet")
    return SpriteSheet:new(...)
end

----------------------------------------------------------------
-- MapSpriteインスタンスを生成して返します.
----------------------------------------------------------------
function M:newMapSprite(...)
    MapSprite = MapSprite or require("hs/core/MapSprite")
    return MapSprite:new(...)
end

----------------------------------------------------------------
-- TextLabelインスタンスを生成して返します.
----------------------------------------------------------------
function M:newText(...)
    TextLabel = TextLabel or require("hs/core/TextLabel")
    return TextLabel:new(...)
end

----------------------------------------------------------------
-- Graphicsインスタンスを生成して返します.
----------------------------------------------------------------
function M:newGraphics(...)
    Graphics = Graphics or require("hs/core/Graphics")
    return Graphics:new(...)
end

----------------------------------------------------------------
-- Groupインスタンスを生成して返します.
----------------------------------------------------------------
function M:newGroup(...)
    Group = Group or require("hs/core/Group")
    return Group:new(...)
end

----------------------------------------------------------------
-- Layerインスタンスを生成して返します.
----------------------------------------------------------------
function M:newLayer(...)
    Layer = Layer or require("hs/core/Layer")
    return Layer:new(...)
end

----------------------------------------------------------------
-- BoxLayoutインスタンスを生成して返します.
----------------------------------------------------------------
function M:newBoxLayout(...)
    BoxLayout = BoxLayout or require("hs/core/BoxLayout")
    return BoxLayout:new(...)
end

----------------------------------------------------------------
-- VBoxLayoutインスタンスを生成して返します.
----------------------------------------------------------------
function M:newVBoxLayout(...)
    VBoxLayout = VBoxLayout or require("hs/core/VBoxLayout")
    return VBoxLayout:new(...)
end

----------------------------------------------------------------
-- HBoxLayoutインスタンスを生成して返します.
----------------------------------------------------------------
function M:newHBoxLayout(...)
    HBoxLayout = HBoxLayout or require("hs/core/HBoxLayout")
    return HBoxLayout:new(...)
end

----------------------------------------------------------------
-- Animationインスタンスを生成して返します.
----------------------------------------------------------------
function M:newAnimation(...)
    Animation = Animation or require("hs/core/Animation")
    return Animation:new(...)
end

----------------------------------------------------------------
-- Sceneインスタンスを生成して返します.
----------------------------------------------------------------
function M:newScene(...)
    Scene = Scene or require("hs/core/Scene")
    return Scene:new(...)
end

----------------------------------------------------------------
-- SceneManager:openScene関数に処理を委譲します.
----------------------------------------------------------------
function M:openScene(...)
    SceneManager = SceneManager or require("hs/core/SceneManager")
    return SceneManager:openScene(...)
end

----------------------------------------------------------------
-- SceneManager:openNextScene関数に処理を委譲します.
----------------------------------------------------------------
function M:openNextScene(...)
    SceneManager = SceneManager or require("hs/core/SceneManager")
    return SceneManager:openNextScene(...)
end

----------------------------------------------------------------
-- SceneManager:closeScene関数に処理を委譲します.
----------------------------------------------------------------
function M:closeScene(...)
    SceneManager = SceneManager or require("hs/core/SceneManager")
    return SceneManager:closeScene(...)
end

return M
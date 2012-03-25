local Group = require("hs/core/Group")
local Layer = require("hs/core/Layer")
local Graphics = require("hs/core/Graphics")
local Sprite = require("hs/core/Sprite")
local SpriteSheet = require("hs/core/SpriteSheet")
local MapSprite = require("hs/core/MapSprite")
local NinePatch = require("hs/core/NinePatch")
local TextLabel = require("hs/core/TextLabel")
local Scene = require("hs/core/Scene")
local SceneManager = require("hs/core/SceneManager")
local BoxLayout = require("hs/core/BoxLayout")
local VBoxLayout = require("hs/core/VBoxLayout")
local HBoxLayout = require("hs/core/HBoxLayout")
local Animation = require("hs/core/Animation")

----------------------------------------------------------------
-- DisplayObject系のインスタンスを生成する為のクラスです.<br>
-- このクラスを使用しないで直接生成してもいいですが、
-- このクラスを使用するこで、requireが一回で済みます.
-- @class table
-- @name display
----------------------------------------------------------------
local display = {}

----------------------------------------------------------------
-- Spriteインスタンスを生成して返します.
----------------------------------------------------------------
function display:newSprite(...)
    return Sprite:new(...)
end

----------------------------------------------------------------
-- SpriteSheetインスタンスを生成して返します.
----------------------------------------------------------------
function display:newSpriteSheet(...)
    return SpriteSheet:new(...)
end

----------------------------------------------------------------
-- MapSpriteインスタンスを生成して返します.
----------------------------------------------------------------
function display:newMapSprite(...)
    return MapSprite:new(...)
end

----------------------------------------------------------------
-- TextLabelインスタンスを生成して返します.
----------------------------------------------------------------
function display:newText(...)
    return TextLabel:new(...)
end

----------------------------------------------------------------
-- Graphicsインスタンスを生成して返します.
----------------------------------------------------------------
function display:newGraphics(...)
    return Graphics:new(...)
end

----------------------------------------------------------------
-- Groupインスタンスを生成して返します.
----------------------------------------------------------------
function display:newGroup(...)
    return Group:new(...)
end

----------------------------------------------------------------
-- Layerインスタンスを生成して返します.
----------------------------------------------------------------
function display:newLayer(...)
    return Layer:new(...)
end

----------------------------------------------------------------
-- BoxLayoutインスタンスを生成して返します.
----------------------------------------------------------------
function display:newBoxLayout(...)
    return BoxLayout:new(...)
end

----------------------------------------------------------------
-- VBoxLayoutインスタンスを生成して返します.
----------------------------------------------------------------
function display:newVBoxLayout(...)
    return VBoxLayout:new(...)
end

----------------------------------------------------------------
-- HBoxLayoutインスタンスを生成して返します.
----------------------------------------------------------------
function display:newHBoxLayout(...)
    return HBoxLayout:new(...)
end

----------------------------------------------------------------
-- Animationインスタンスを生成して返します.
----------------------------------------------------------------
function display:newAnimation(...)
    return Animation:new(...)
end

----------------------------------------------------------------
-- SceneManager:openScene関数に処理を委譲します.
----------------------------------------------------------------
function display:openScene(...)
    return SceneManager:openScene(...)
end

----------------------------------------------------------------
-- SceneManager:openNextScene関数に処理を委譲します.
----------------------------------------------------------------
function display:openNextScene(...)
    return SceneManager:openNextScene(...)
end

----------------------------------------------------------------
-- SceneManager:closeScene関数に処理を委譲します.
----------------------------------------------------------------
function display:closeScene(...)
    return SceneManager:closeScene(...)
end

return display
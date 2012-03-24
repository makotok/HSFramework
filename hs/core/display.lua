local Transform = require("hs/core/Transform")
local Group = require("hs/core/Group")
local Layer = require("hs/core/Layer")
local Graphics = require("hs/core/Graphics")
local Sprite = require("hs/core/Sprite")
local SpriteSheet = require("hs/core/SpriteSheet")
local MapSprite = require("hs/core/MapSprite")
local NinePatch = require("hs/core/NinePatch")
local TextLabel = require("hs/core/TextLabel")
local Scene = require("hs/core/Scene")
local BoxLayout = require("hs/core/BoxLayout")
local VBoxLayout = require("hs/core/VBoxLayout")
local HBoxLayout = require("hs/core/HBoxLayout")
local Animation = require("hs/core/Animation")

----------------------------------------------------------------
-- DisplayObject系のインスタンスを生成する為のクラスです.
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

return display
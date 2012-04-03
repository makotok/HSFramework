local display = require("hs/core/display")
local Logger = require("hs/core/Logger")

module(..., package.seeall)

local animIndex = 1

function onCreate()
    -- spritesheet1
    sprite1 = display:newSpriteSheet({texture = "samples/resources/actor.png"})
    sprite1:loadSheetsFromTile(3, 4)
    sprite1:setSheetsAnimation(1, {2, 1, 2, 3, 2}, 0.25)
    sprite1:setSheetsAnimation(2, {5, 4, 5, 6, 5}, 0.25)
    sprite1:setSheetsAnimation(3, {8, 7, 8, 9, 8}, 0.25)
    sprite1:setSheetsAnimation(4, {11, 10, 11, 12, 11}, 0.25)
    sprite1.sheetIndex = 2
    sprite1:addListener("frameLoop", spriteSheetFrameLoopHandler)
    
    -- spritesheet2
    sprite2 = display:newSpriteSheet({texture = "samples/resources/actor.png", x = 32})
    sprite2.sheets = {
        {x = 0, y = 0, width = 32, height = 32},
        {x = 32, y = 0, width = 32, height = 32},
        {x = 64, y = 0, width = 32, height = 32}
    }
    sprite2.sheetsAnimations = {
        walk = {indexes = {2, 1, 2, 3, 2}, sec = 0.25}
    }
    sprite2.sheetIndex = 2
end

function onResume()
    sprite1:play(animIndex)
    sprite2:play("walk")
end

function spriteSheetFrameLoopHandler(e)
    animIndex = animIndex + 1
    animIndex = animIndex > 4 and 1 or animIndex
    sprite1:play(animIndex)
end
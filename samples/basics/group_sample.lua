local display = require("hs/core/display")

module(..., package.seeall)

function onCreate()
    -- groups
    group1 = display:newGroup({layout = display:newBoxLayout()})
    group2 = display:newGroup({layout = display:newHBoxLayout(), parent = group1})
    group3 = display:newGroup({layout = display:newVBoxLayout({pLeft = 0, pRight = 0}), parent = group2})
    group4 = display:newGroup({layout = display:newVBoxLayout({pLeft = 0, pRight = 0}), parent = group2})
    group5 = display:newGroup({layout = display:newVBoxLayout({pLeft = 0, pRight = 0}), parent = group2})
    group6 = display:newGroup({layout = display:newHBoxLayout(), parent = group1})
    
    group1.background:setPenColor(1, 1, 1):fillRect():setPenColor(0.5, 0.5, 0.5):setPenWidth(2):drawRect()
    group2.background:setPenColor(0, 1, 0):fillRect():setPenColor(0, 0.5, 0):setPenWidth(2):drawRect()
    group3.background:setPenColor(0, 0, 1):fillRect():setPenColor(0, 0, 0.5):setPenWidth(2):drawRect()
    group4.background:setPenColor(0, 0, 1):fillRect():setPenColor(0, 0, 0.5):setPenWidth(2):drawRect()
    group5.background:setPenColor(0, 0, 1):fillRect():setPenColor(0, 0, 0.5):setPenWidth(2):drawRect()
    group6.background:setPenColor(0, 1, 0):fillRect():setPenColor(0, 0.5, 0):setPenWidth(2):drawRect()
    
    -- sprites
    for i = 1, 3 do
        display:newSprite("samples/resources/cathead.png", {width = 64, height = 64, parent = group3})
        display:newSprite("samples/resources/cathead.png", {width = 64, height = 64, parent = group4})
        display:newSprite("samples/resources/cathead.png", {width = 64, height = 64, parent = group5})
        display:newGraphics({width = 64, height = 64, parent = group6})
            :fillRect():setPenColor(0, 0, 0):drawLine(0, 0, 64, 64, 0, 64, 64, 0, 0, 0)
    end
end

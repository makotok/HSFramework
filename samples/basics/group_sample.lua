module(..., package.seeall)

function onCreate()
    -- groups
    group1 = Group:new({layout = BoxLayout:new(), parent = scene})
    group2 = Group:new({layout = HBoxLayout:new(), parent = group1})
    group3 = Group:new({layout = VBoxLayout:new({pLeft = 0, pRight = 0}), parent = group2})
    group4 = Group:new({layout = VBoxLayout:new({pLeft = 0, pRight = 0}), parent = group2})
    group5 = Group:new({layout = VBoxLayout:new({pLeft = 0, pRight = 0}), parent = group2})
    group6 = Group:new({layout = HBoxLayout:new(), parent = group1})
    
    group1.background:setPenColor(1, 1, 1):fillRect():setPenColor(0.5, 0.5, 0.5):setPenWidth(2):drawRect()
    group2.background:setPenColor(0, 1, 0):fillRect():setPenColor(0, 0.5, 0):setPenWidth(2):drawRect()
    group3.background:setPenColor(0, 0, 1):fillRect():setPenColor(0, 0, 0.5):setPenWidth(2):drawRect()
    group4.background:setPenColor(0, 0, 1):fillRect():setPenColor(0, 0, 0.5):setPenWidth(2):drawRect()
    group5.background:setPenColor(0, 0, 1):fillRect():setPenColor(0, 0, 0.5):setPenWidth(2):drawRect()
    group6.background:setPenColor(0, 1, 0):fillRect():setPenColor(0, 0.5, 0):setPenWidth(2):drawRect()
    
    -- sprites
    for i = 1, 3 do
        Sprite:new("samples/resources/cathead.png", {width = 64, height = 64, parent = group3})
        Sprite:new("samples/resources/cathead.png", {width = 64, height = 64, parent = group4})
        Sprite:new("samples/resources/cathead.png", {width = 64, height = 64, parent = group5})
        Graphics:new({width = 64, height = 64, parent = group6})
            :fillRect():setPenColor(0, 0, 0):drawLine(0, 0, 64, 64, 0, 64, 64, 0, 0, 0)
    end
end

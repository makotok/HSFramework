UIComponent = require("hs/gui/UIComponent")
Button = require("hs/gui/Button")
View = require("hs/gui/View")
ScrollView = require("hs/gui/ScrollView")

----------------------------------------------------------------
-- GUIインスタンスを生成する為のクラスです.<br>
-- このクラスを使用しないで直接生成してもいいですが、
-- このクラスを使用するこで、requireが一回で済みます.
-- @class table
-- @name widget
----------------------------------------------------------------
local widget = {}

----------------------------------------------------------------
-- UIComponentインスタンスを生成して返します.
----------------------------------------------------------------
function widget:newUIComponent(...)
    return UIComponent:new(...)
end

----------------------------------------------------------------
-- Buttonインスタンスを生成して返します.
----------------------------------------------------------------
function widget:newButton(...)
    return Button:new(...)
end

----------------------------------------------------------------
-- Viewインスタンスを生成して返します.
----------------------------------------------------------------
function widget:newView(...)
    return View:new(...)
end

----------------------------------------------------------------
-- ScrollViewインスタンスを生成して返します.
----------------------------------------------------------------
function widget:newScrollView(...)
    return ScrollView:new(...)
end

return widget
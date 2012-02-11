HBoxLayout = BoxLayout()

---------------------------------------
-- コンストラクタです
---------------------------------------
function HBoxLayout:init()
    BoxLayout.init(self)
    self.direction = BoxLayout.DIRECTION_H
end

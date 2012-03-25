local display = require("hs/core/display")

module(..., package.seeall)

function onCreate()
    g = display:newGraphics({width = 50, height = 50})
    g:setPenColor(0, 1, 0, 1):fillRect(0, 0, 50, 50)
    g:setPenColor(1, 0, 0, 1):setPenWidth(1):drawRect(0, 0, 50, 50)
    g.x = 10
    g.y = 10
end

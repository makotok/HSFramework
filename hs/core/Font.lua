----------------------------------------------------------------
-- MOAIFontのラッパーです.
-- フレームワーク内部で使用します.
-- @class table
-- @name Font
----------------------------------------------------------------

local Font = {}
local defaultCharcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-_'

function Font:new(ttf, charcodes, points, dpi)
    local font = MOAIFont.new()
    font:loadFromTTF(ttf, charcodes, points, dpi)
    return font
end

return Font
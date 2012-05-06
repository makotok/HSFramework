----------------------------------------------------------------
-- Fontのキャッシュです.
-- フレームワーク内部で使用します.
-- @class table
-- @name FontManager
----------------------------------------------------------------

local M = {
    cache = {}
}

function M:getFont(path)

    if self.cache[path] == nil then
        local font = MOAIFont.new()
        font:load(path)
        font.path = path
        self.cache[path] = font
    end

    return self.cache[path]
end

return M

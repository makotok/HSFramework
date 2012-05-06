----------------------------------------------------------------
-- MOAITextureのCacheです.
-- フレームワーク内部で使用します.
-- @class table
-- @name TextureManager
----------------------------------------------------------------
local M = {
    cache = {}
}

setmetatable(M.cache, {__mode = "v"})

---------------------------------------
--- テクスチャをロードして返します.
--- テクスチャはキャッシュされます.
---------------------------------------
function M:get(path)
    if self.cache[path] == nil then
        local texture = MOAITexture.new ()
        texture:load (path)
        self.cache[path] = texture
    end
    return self.cache[path]
end

return M
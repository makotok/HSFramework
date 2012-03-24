local Texture = require("hs/core/Texture")

----------------------------------------------------------------
-- MOAITextureのCacheです.
-- フレームワーク内部で使用します.
-- @class table
-- @name TextureCache
----------------------------------------------------------------
local TextureCache = {
    cache = {}
}

---------------------------------------
--- テクスチャをロードして返します.
--- テクスチャはキャッシュされます.
---------------------------------------
function TextureCache:get(path)
    if self.cache[path] == nil then
        self.cache[path] = Texture:new(path)
    end
    return self.cache[path]
end

return TextureCache
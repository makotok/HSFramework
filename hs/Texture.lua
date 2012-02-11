
Texture = {
    cache = {}
}

---------------------------------------
--- テクスチャをロードして返します。
--- テクスチャはキャッシュされます。
---------------------------------------
function Texture:get(path)
    if self.cache[path] == nil then
        self.cache[path] = self:new(path)
    end
    return self.cache[path]
end

---------------------------------------
--- 新規テクスチャをロードして返します。
---------------------------------------
function Texture:new(path)
    local texture = MOAITexture.new ()
    texture:load (path)
    return texture
end

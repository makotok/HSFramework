
TextureCache = {
    cache = {}
}

---------------------------------------
--- テクスチャをロードして返します。
--- テクスチャはキャッシュされます。
---------------------------------------
function TextureCache:get(path)
    if self.cache[path] == nil then
        self.cache[path] = Texture:new(path)
    end
    return self.cache[path]
end

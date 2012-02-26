
Texture = {}

---------------------------------------
--- 新規テクスチャをロードして返します。
---------------------------------------
function Texture:new(path)
    local texture = MOAITexture.new ()
    texture:load (path)
    return texture
end


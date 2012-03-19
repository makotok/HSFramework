--------------------------------------------------------------------------------
-- TMXMapのレイヤークラスです.
-- @class table
-- @name TMXLayer
--------------------------------------------------------------------------------
TMXLayer = Class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXLayer:init(tmxMap)
    TMXLayer:super(self)

    self.tmxMap = tmxMap
    self.name = ""
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.opacity = 0
    self.visible = true
    self.properties = {}
    self.tiles = {}
    self.displayGroup = nil
end

---------------------------------------
-- レイヤーの描画を行います.
-- タイルセットのテクスチャが存在するのを対象とします.
-- TODO:割り切れない時の動作を厳密にしたい
---------------------------------------
function TMXLayer:drawLayer(parent)
    if not self.visible then
        return
    end

    local tmxMap = self.tmxMap
    local mapWidth, mapHeight = tmxMap.width, tmxMap.height
    local group = Group:new({parent = parent})
    local tilesets = self:createDisplayTilesets()
    self.displayGroup = group
    self.tilesets = tilesets
    
    for key, tileset in pairs(tilesets) do
        local texture = tileset.texture
        if texture then
            local tw, th = texture:getSize()
            local tileCol = math.floor(tw / tileset.tilewidth)
            local tileRow = math.floor(th / tileset.tileheight)
            local mapSprite = MapSprite:new(texture, mapWidth, mapHeight, tileCol, tileRow, tileset.tilewidth, tileset.tileheight)
            group:addChild(mapSprite)
            
            for y = 1, self.height do
                local rowData = {}
                for x = 1, self.width do
                    local gid = self.tiles[(y - 1) * self.width + x]
                    local tileNo = gid == 0 and gid or gid - tileset.firstgid + 1
                    table.insert(rowData, tileNo)                        
                end
                mapSprite:setRowData(y, unpack(rowData))
            end
        end
    end
end

---------------------------------------
-- レイヤーのタイルリストのgidから、
-- 描画すべきタイルセットのリストを生成します.
-- タイルセットのテクスチャはロードされた状態となります.
---------------------------------------
function TMXLayer:createDisplayTilesets()
    local tmxMap = self.tmxMap
    local tilesets = {}
    for i, gid in ipairs(self.tiles) do
        local tileset = tmxMap:findTilesetByGid(gid)
        if tileset then
            tileset:loadTexture()
            tilesets[tileset.name] = tileset
        end
    end
    return tilesets
end

---------------------------------------
-- プロパティを返します.
---------------------------------------
function TMXLayer:getProperty(key)
    return self.properties[key]
end

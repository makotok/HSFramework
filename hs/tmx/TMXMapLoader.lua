----------------------------------------------------------------
-- TMXMapLoaderはtmxファイルを読み込んで、TMXMapを生成するクラスです。
-- 
----------------------------------------------------------------

TMXMapLoader = Class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXMapLoader:init()
    -- パーサー
    self.nodeParserNames = {
        map = "parseNodeMap",
        tileset = "parseNodeTileset",
        layer = "parseNodeLayer",
        objectgroup = "parseNodeObjectGroup"
    }

end

---------------------------------------
-- TMX形式のファイルを読み込みます。
-- 読み込んだ結果をTMXMapで返します。
---------------------------------------
function TMXMapLoader:load(filename)
    local xml = MOAIXmlParser.parseFile(filename)
    self:parseNode(xml)
    return self.map
end

---------------------------------------
-- ノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNode(node)
    --Log.debug("[TMXMapLoader:parseNode]", node.type)

    local parser = self.nodeParserNames[node.type]
    if parser then
        self[parser](self, node)
    else
        return
    end
    
    if not node.children then
        return
    end
    
    for key, value in pairs(node.children) do
        for key, value in ipairs(value) do
            if type(value) == "table" then
                self:parseNode(value)
            end
        end
    end
end

---------------------------------------
-- Mapのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeMap(node)
    --Log.debug("[TMXMapLoader:parseNodeMap]")

    local map = TMXMap:new()
    self.map = map

    self:parseNodeAttributes(node, map)
    self:parseNodeProperties(node, map.properties)

end

---------------------------------------
-- ノードの属性を読み込みます。
-- 読み込んだ結果は、destに設定します。
---------------------------------------
function TMXMapLoader:parseNodeAttributes(node, dest)
    --Log.debug("[TMXMapLoader:parseNodeAttributes]", node.type)

    for key, value in pairs(node.attributes) do
        if tonumber(value) ~= nil then
            dest[key] = tonumber(value)
        else
            dest[key] = value
        end
    end
end

---------------------------------------
-- tilesetのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeTileset(node)
    --Log.debug("[TMXMapLoader:parseNodeTileset]")
    
    local tileset = TMXTileset:new(self.map)
    self.map:addTileset(tileset)

    self:parseNodeAttributes(node, tileset)
    self:parseNodeImage(node, tileset)
    self:parseNodeTile(node, tileset)
    self:parseNodeProperties(node, tileset.properties)
end

---------------------------------------
-- imageのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeImage(node, tileset)
    --Log.debug("[TMXMapLoader:parseNodeImage]")
    
    if not node.children.image then
        return
    end
    for key, value in pairs(node.children.image) do
        for key, value in pairs(value.attributes) do
            tileset.image[key] = value
        end
    end
end

---------------------------------------
-- tileのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeTile(node, tileset)
    --Log.debug("[TMXMapLoader:parseNodeTile]")

    if node.children.node == nil then
        return
    end
    for key, value in pairs(node.children.tile) do
        local gid = tonumber(value.attributes.id)
        if tileset.tiles[gid] == nil then
            tileset.tiles[gid] = {properties = {}}
        end
        self:parseNodeProperties(value, self.tiles[gid].properties)
    end
end

---------------------------------------
-- Layerのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeLayer(node)
    --Log.debug("[TMXMapLoader:parseNodeLayer]")

    local layer = TMXLayer:new(self.map)
    self.map:addLayer(layer)

    self:parseNodeAttributes(node, layer)
    self:parseNodeData(node, layer)
    self:parseNodeProperties(node, layer.properties)
end

---------------------------------------
-- dataのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeData(node, layer)
    --Log.debug("[TMXMapLoader:parseNodeData]")

    if node.children.data == nil then
        return
    end
    
    for i, data in ipairs(node.children.data) do
        for j, tile in ipairs(data.children.tile) do
            layer.tiles[j] = tonumber(tile.attributes.gid)
        end
    end
    
end

---------------------------------------
-- ObjectGroupのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeObjectGroup(node)
    --Log.debug("[TMXMapLoader:parseNodeObjectGroup]")

    local group = TMXObjectGroup:new(self.map)
    self.map:addObjectGroup(group)

    self:parseNodeAttributes(node, group)
    self:parseNodeObject(node, group)
    self:parseNodeProperties(node, group.properties)
end

---------------------------------------
-- ObjectGroup.objectのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeObject(node, group)
    --Log.debug("[TMXMapLoader:parseNodeObject]")

    if node.children.object == nil then
        return
    end
    
    for i, value in ipairs(node.children.object) do
        local object = TMXObject:new(group)
        self:parseNodeAttributes(value, object)
        group:addObject(object)
    end

    self:parseNodeAttributes(node, group)
    self:parseNodeProperties(node, group.properties)
end

---------------------------------------
-- TMXファイルのノードを読み込みます。
---------------------------------------
function TMXMapLoader:parseNodeProperties(node, dest)
    --Log.debug("[TMXMapLoader:parseNodeProperties]")

    if not node.children.properties then
        return
    end

    for key, value in ipairs(node.children.properties) do
        for key, value in ipairs(value.children.property) do
            dest[value.attributes.name] = value.attributes.value
        end
    end
end

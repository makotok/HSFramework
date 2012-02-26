TMXMapLoader = Class()

function TMXMapLoader:init()
    self.nodeParser = {
        map = parseNodeForMap,
        tileset = parseNodeForTileset,
        layer = parseNodeForLayer,
        objectgroup = parseNodeForObjectgroup
    }
end

function TMXMapLoader:load(map, filename)
    local xml = MOAIXmlParser.parseFile(filename)
    parseNode(xml)
    return self.map
end

function TMXMapLoader:parseNode(node)
    local parser = self.nodeParser[node.type]
    if parser then
        parser(node, map)
    end
end


function TMXMapLoader:parseNodeForMap(node)
    self.map = TMXMap:new()

    self:loadTMXNodeAttributes(node)
end

function TMXMapLoader:parseNodeForTileset()

end
function TMXMapLoader:parseNodeForLayer()

end
function TMXMapLoader:parseNodeForObjectgroup()

end

---------------------------------------
-- TMXファイルのノードを読み込みます。
---------------------------------------
function TMXTileset:parseNodeTileset(node)
    local tileset = TMXTileset:new()
    map:addTileset(tileset)

    self:loadTMXNodeAttributes(node)
    self:loadTMXNodeImage(node)
    self:loadTMXNodeTile(node)
    self:loadTMXNodeProperties(self, node)
end

---------------------------------------
-- TMXファイルのノードを読み込みます。
---------------------------------------
function TMXTileset:parseNodeAttributes(parent, node)
    for key, value in pairs(node.attributes) do
        if tonumber(value) ~= nil then
            parent[key] = tonumber(value)
        else
            parent[key] = value
        end
    end
end

---------------------------------------
-- TMXファイルのノードを読み込みます。
---------------------------------------
function TMXTileset:parseNodeImage(node)
    if not node.children.image then
        return
    end
    for key, value in pairs(node.children.image) do
        for key, value in pairs(value.attributes) do
            self.image[key] = value
        end
    end
end

---------------------------------------
-- TMXファイルのノードを読み込みます。
---------------------------------------
function TMXTileset:parseNodeTile(node)
    if node.children.node == nil then
        return
    end
    for key, value in pairs(node.children.tile) do
        local gid = value.attributes.id
        if self.tiles[gid] == nil then
            self.tiles[gid] = {properties = {}}
        end
        self:loadTMXNodeProperties(self.tiles[gid].properties, value)
    end
end

---------------------------------------
-- TMXファイルのノードを読み込みます。
---------------------------------------
function TMXTileset:loadNodeProperties(dest, node)
    if not node.children.properties then
        return
    end

    for key, value in ipairs(node.children.properties) do
        for key, value in ipairs(value.children.property) do
            dest[value.attributes.name] = value.attributes.value
        end
    end
end

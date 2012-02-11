FontCache = {
    cache = {}
}

function FontCache:getFont(ttf, charcodes, points, dpi)

    for i, v in ipairs(self.cache) do
        if v.ttf == ttf and v.charcodes == charcodes and v.points == points and v.dpi == dpi then
            return v.font
        end
    end

    local obj = { ttf = ttf, charcodes = charcodes, points = points, dpi = dpi }
    obj.font = Font:new(ttf, charcodes, points, dpi)
    table.insert(self.cache, obj)

    return obj.font
end

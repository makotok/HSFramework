Font = {
    ttf = "",
    charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-',
    points = 9,
    dpi = 163
}

function Font:new(ttf, charcodes, points, dpi)
    if ttf == nil then ttf = Font.ttf end
    if charcodes == nil then charcodes = Font.charcodes end
    if points == nil then points = Font.points end
    if dpi == nil then dpi = Font.dpi end

    local font = MOAIFont.new()
    font:loadFromTTF (ttf, charcodes, points, dpi)
    return font
end

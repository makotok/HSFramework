
TextBox = {}
TextBox.style = {}
TextBox.style.fontTTF = "font.ttf"
TextBox.font = nil

function TextBox.new()
    if TextBox.font == nil then
        TextBox.font = Font.new(TextBox.style.fontTTF)
    end

    local textbox = MOAITextBox.new ()
    local font = TextBox.font
    textbox:setFont ( font )
    textbox:setTextSize ( font:getScale ())
    --textbox:setYFlip ( true )

    function textbox:setSize(width, height)
        textbox:setRect ( 0, 0, width, height )
    end

    function textbox:setData(data)
        textbox.data = data
        textbox.setString(data)
    end

    return textbox
end

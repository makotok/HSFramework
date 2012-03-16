--------------------------------------------------------------------------------
-- デフォルトのスキン設定です。
--
--------------------------------------------------------------------------------

Skins = {
    TextLabel = {
        
    },
    Button = {
        skinClass = Sprite,
        upSkin = "hs/resources/skin_button_up.png",
        downSkin = "hs/resources/skin_button_up.png", -- TODO:とりあえず同じスキン
        font = "hs/resources/ipag.ttf", -- TODO:もっとかっこいいのにしたいな
        upEffect = function(button)
            if button._seekColorAction then
                button._seekColorAction:stop()
            end
            button._seekColorAction = button:seekColor(1, 1, 1, 1, 0.5)
            --button:setColor(1, 1, 1, 1)
        end,
        downEffect = function(button)
            if button._seekColorAction then
                button._seekColorAction:stop()
                button._seekColorAction = nil
            end
            button:setColor(1, 1, 0.5, 1)
        end
    },
    ListBox = {

    },
    MessageBox = {
    
    
    }
}

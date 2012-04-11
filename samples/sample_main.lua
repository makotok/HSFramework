local display = require "hs/core/display"
local widget = require "hs/gui/widget"

module(..., package.seeall)

-- create event
function onCreate()
    scene.topLayer.touchEnabled = false
    
    -- scrollView
    scrollView = widget:newScrollView({layout = display:newVBoxLayout(), hScrollEnabled = false, vScrollEnabled = true})
    
    -- sample list
    for i, item in ipairs(sceneItems) do
        local button = widget:newButton(
            {text = item.text, width = 200, height = 30, parent = scrollView,
            onTouchDown = onTouchDown_button, sceneName = item.scene})
    end
    
    scrollView:updateDisplay()
end

-- scene names
sceneItems ={
    {text = "sprite_sample", scene = "samples/basics/sprite_sample"},
    {text = "spritesheet_sample", scene = "samples/basics/spritesheet_sample"},
    {text = "mapsprite_sample", scene = "samples/basics/mapsprite_sample"},
    {text = "graphics_sample", scene = "samples/basics/graphics_sample"},
    {text = "group_sample", scene = "samples/basics/group_sample"},
    {text = "layer_sample", scene = "samples/basics/layer_sample"},
    {text = "scene_sample", scene = "samples/basics/scene1_sample"},
    {text = "textlabel_sample", scene = "samples/basics/textlabel_sample"},
    {text = "anime_basic_sample", scene = "samples/animations/anime_basic_sample"},
    {text = "anime_fade_sample", scene = "samples/animations/anime_fade_sample"},
    {text = "anime_group_sample", scene = "samples/animations/anime_group_sample"},
    {text = "tmxmap1_sample", scene = "samples/maps/tmxmap1_sample"},
    {text = "tmxmap2_sample", scene = "samples/maps/tmxmap2_sample"},
    {text = "box2d_body_sample", scene = "samples/box2d/box2d_body_sample"},
    {text = "button_sample", scene = "samples/gui/button_sample"},
    --{text = "fps_sample", scene = "samples/utils/fps_sample"}
}

-- touch event
function onTouchDown_button(self, event)
    display:openNextScene(self.sceneName)
end


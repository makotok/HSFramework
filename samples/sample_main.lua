module(..., package.seeall)

-- create event
function onCreate()
    scene.sceneOpenAnimation = SceneAnimation.now
    scene.sceneCloseAnimation = SceneAnimation.now
    
    -- group
    group = Group:new({parent = scene, layout = VBoxLayout:new({vGap = 0})})
    group.layout:setPadding(0, 0, 0, 0)

    -- sample list
    for i, item in ipairs(sceneItems) do
        local labelGroup = Group:new({width = Application.stageWidth + 1, height = 25, parent = group})
        labelGroup.background:drawRect()
        
        local label = TextLabel:new(
            {text = item.text, width = labelGroup.width, height = 25,
            parent = labelGroup, onTouchDown = onTouchDownLabel, sceneName = item.scene})
    end
end

-- scene names
sceneItems ={
    {text = "sprite_sample", scene = "samples/basics/sprite_sample"},
    {text = "mapsprite_sample", scene = "samples/basics/mapsprite_sample"},
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
    {text = "fps_sample", scene = "samples/utils/fps_sample"}
}

-- touch event
function onTouchDownLabel(self, event)
    Log.info("label touch!" .. self.sceneName)
    SceneManager:openNextScene(self.sceneName)
end


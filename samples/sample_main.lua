-- window
Application:openWindow("samples", 480, 320)

-- basic samples
require "samples/basics/sprite_sample"
require "samples/basics/mapsprite_sample"
require "samples/basics/group_sample"
require "samples/basics/layer_sample"
require "samples/basics/scene_sample"
require "samples/basics/textlabel_sample"


-- animation samples
require "samples/animations/anime_basic_sample"
require "samples/animations/anime_fade_sample"
require "samples/animations/anime_group_sample"

-- map samples
require "samples/maps/tmxmap1_sample"

-- utils samples
require "samples/utils/fps_sample"

-- scene
sample_scene = Scene:new()

-- group
local group = Group:new({parent = sample_scene, layout = VBoxLayout:new({vGap = 0})})
group.layout:setPadding(0, 0, 0, 0)

local function onTouchDown(self, event)
    local scene = _G[self.text]
    if scene then
        sample_scene:closeScene()
        scene:openScene()
    end
end

local sceneNames ={
    "sprite_sample",
    "mapsprite_sample",
    "group_sample",
    "layer_sample",
    "scene_sample",
    "textlabel_sample",
    "anime_basic_sample",
    "anime_fade_sample",
    "anime_group_sample",
    "tmxmap1_sample",
    "fps_sample"
}

for i, name in ipairs(sceneNames) do
    local labelGroup = Group:new({width = Application.stageWidth + 1, height = 25, parent = group})
    labelGroup.background:drawRect()
    local label = TextLabel:new({text = name, width = labelGroup.width, height = 25, parent = labelGroup, onTouchDown = onTouchDown})
end

-- scene open
sample_scene:openScene()


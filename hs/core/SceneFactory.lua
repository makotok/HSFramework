local Class = require("hs/lang/Class")
local Scene = require("hs/core/Scene")

----------------------------------------------------------------
-- Sceneを生成するファクトリークラスです.
-- SceneManagerにより使用されます.
-- @class table
-- @name SceneFactory
----------------------------------------------------------------
local M = Class()

---------------------------------------
-- シーンを生成します.
-- この関数の動作を変更する事で、
-- 任意のロジックでシーンを生成する事が可能です.
-- @param name シーン名です.
--     シーン名をもとに、モジュールを参照して、
--     sceneHandlerを生成します.
--     ただし、params.handlerが指定された場合、
--     そのhandlerを使用します.
-- @param params パラメータです.
--     sceneClassがある場合、同クラスを生成します.
--     handlerがある場合、sceneHandlerに設定されます.
---------------------------------------
function M:createScene(name, params)
    local sceneClass = params.sceneClass and params.sceneClass or Scene
    local scene = sceneClass:new()
    scene.sceneHandler = params.handler and params.handler or require(name)
    scene.name = name
    scene.sceneHandler.scene = scene

    return scene
end

return M
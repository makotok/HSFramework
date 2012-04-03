-- TODO:Version1.0 互換性の問題の対応
-- すぐに削除したい
require("hs/moai")

-- requires
local Framework = require("hs/Framework")
local Application = require("hs/core/Application")
local SceneManager = require("hs/core/SceneManager")

-- Use global imports
-- Please select by your coding style.
--require("hs/import")

-- framework initialize
Framework:initialize()

-- application start
Application:openWindow("samples", 480, 320)

-- main scene open
SceneManager:openScene("samples/sample_main")


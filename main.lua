-- requires
local Framework = require("hs/Framework")
local Application = require("hs/core/Application")
local SceneManager = require("hs/core/SceneManager")
local Logger = require("hs/core/Logger")

-- Use global imports
-- Please select by your coding style.
--require("hs/import")

Logger.level = Logger.LEVEL_DEBUG

-- framework initialize
Framework:initialize()

-- application start
Application:openWindow("samples", 480, 320)

-- main scene open
SceneManager:openScene("samples/sample_main")


-- requires
local Framework = require("hs/Framework")
local Application = require("hs/core/Application")
local SceneManager = require("hs/core/SceneManager")

-- use global imports
require("import")

-- framework initialize
Framework:initialize()

-- application start
Application:openWindow("samples", 480, 320)

-- main scene open
SceneManager:openScene("samples/sample_main")


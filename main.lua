-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.DefaultStatusBar )

local widget = require "widget"
local composer = require "composer"

local function onStart( event )
	composer.gotoScene( "start" )
end
onStart()

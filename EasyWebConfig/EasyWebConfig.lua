--------------------------------------------------------------------------------
-- EasyWebConfig module for NODEMCU
-- LICENCE: http://opensource.org/licenses/MIT
-- yangbo<gyangbo@gmail.com>
--------------------------------------------------------------------------------

--[[
here is the demo.lua:
require("EasyWebConfig")
--EasyWebConfig.addVar("gateWay")
--EasyWebConfig.addVar("userKey")
EasyWebConfig.doMyFile("demo.lua")
--]]
local moduleName = ...
local M = {}
_G[moduleName] = M
_G["wifiStatue"] = "..."

_G["config"]  = {}

local userScriptFile = ""


function M.doMyFile(fName)
     userScriptFile = fName
end

function M.addVar(vName)
     if(_G["config"].vName == nil) then
          table.insert(_G["config"],{name=vName,value=""})
     end
end

--M.addVar("ssid")
--M.addVar("password")

--try to open user configuration file
if( file.open("network_user_cfg.lua") ~= nil) then
     ssid=""
     password=""
     dofile("network_user_cfg.lua")
     if(gateWay ~= nil and userKey~=nil)then
     dofile("run.lua") 
     end
else
     dofile("network_default_cfg.lua")
     print ("LoadDefault")
end

--------------------------------------------------------------------------------
-- EasyWebConfig module for NODEMCU
-- LICENCE: http://opensource.org/licenses/MIT
-- yangbo<gyangbo@gmail.com>
--------------------------------------------------------------------------------
--[[
刷入此代码，会自动建立ESP8266+id的无线网，密码是12345678。
连上后通过192.168.4.1的网页来配置，里面的内容是需要连接的无线网的ssid和密码，其它需要配置的，可以模仿示例自行添加
如果配置成功，此无线网会自动取消，如果配置失败，可以重新配置。
如果无线网配置成功但其他配置错误，可以通过关掉上级路由器后，重启ESP8266来重新配置（模拟无线网失效）
建议刷入代码后，用node.compile("EasyWebConfig.lua")来编译成lc文件，减小内存使用
]]--
--[[
here is the demo.lua:
require("EasyWebConfig")
--这里通过web配置的gateWay和userKey可以在你的代码里通过_G["gateWay"],_G["userKey"]来直接使用
--EasyWebConfig.addVar("gateWay")
--EasyWebConfig.addVar("userKey")
--这里的demo.lua是需要运行的自己的代码文件
EasyWebConfig.doMyFile("demo.lua")
--]]
local moduleName = ...
local M = {}
_G[moduleName] = M
_G["wifiStatue"] = nil

_G["config"]  = {}

local userScriptFile = ""


function M.doMyFile(fName)
     userScriptFile = fName
end

function M.addVar(vName)
     table.insert(_G["config"],{name=vName,value=""})
end

M.addVar("ssid")
M.addVar("password")

--try to open user configuration file
if( file.open("network_user_cfg.lua") ~= nil) then
     require("network_user_cfg")
     if true then  --change to if true
          --print("set up wifi mode")
          wifi.setmode(wifi.STATION)
          --please config ssid and password according to settings of your wireless router.
          wifi.sta.config(ssid,password)
          wifi.sta.connect()
          cnt = 0
          tmr.alarm(1, 1000, 1, function()
               if (wifi.sta.getip() == nil) and (cnt < 10) then
                    --print(".")
                    cnt = cnt + 1
               else
                    tmr.stop(1)
                    if (cnt < 10) then print("IP:"..wifi.sta.getip())
                         --_G["wifiStatue"] = "OK"
                         --node.led(0,0)
                         if(userScriptFile ~="") then 
                              --print(node.heap())
                              --for n in pairs(_G) do print(n) end
                              ssid= nil
                              password = nil
                              _G["config"] = nil
                              --M = nil
                              --print("---")
                              --for n in pairs(_G) do print(n) end
                              --print(node.heap())
                              dofile(userScriptFile) 
                         end
                    else print("FailToConnect,LoadDefault")
                         _G["wifiStatue"] = "Failed"
                         --node.led(800,50)
                         _G["wifissid"] = ssid
                         require("network_default_cfg")
                         print ("LoadDefault")
                    end
               end
          end)
     end
else--not exist user config file,use default one
     require("network_default_cfg")
     print ("LoadDefault")
     --node.led(800,800)
end

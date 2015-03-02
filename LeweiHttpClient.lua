--------------------------------------------------------------------------------
-- LeweiHttpClient module for NODEMCU
-- LICENCE: http://opensource.org/licenses/MIT
-- yangbo<gyangbo@gmail.com>
--------------------------------------------------------------------------------

--[[
here is the demo.lua:

require("LeweiHttpClient")
LeweiHttpClient.init("01","your_api_key")
tmr.alarm(0, 60000, 1, function()
--添加数据，等待上传
LeweiHttpClient.appendSensorValue("sensor1","1")
--实际发送数据
LeweiHttpClient.sendSensorValue("sensor2","3")
end)
--]]

local moduleName = ...
local M = {}
_G[moduleName] = M

local ServerIP

local gateWay
local userKey
local sn
local sensorValueTable
local apiUrl = ""

function M.init(gw,ukey)
     if(_G["gateWay"] ~= nil) then gateWay = _G["gateWay"]
     else gateWay = gw
     end
     if(_G["userKey"] ~= nil) then userKey = _G["userKey"]
     else userKey = userkey
     end
     	apiUrl = "UpdateSensors/"..gateWay
     if(_G["sn"] ~= nil) then sn = _G["sn"]
     	apiUrl = "UpdateSensorsBySN/"..sn
     end
     sensorValueTable = {}
end

function M.appendSensorValue(sname,svalue)
     print ("appending")
     sensorValueTable[""..sname]=""..svalue
end

function M.sendSensorValue(sname,svalue)
     --定义数据变量格式
     PostData = "["
     for i,v in pairs(sensorValueTable) do 
          PostData = PostData .. "{\"Name\":\""..i.."\",\"Value\":\"" .. v .. "\"},"
          --print(i)
          --print(v) 
     end
     PostData = PostData .."{\"Name\":\""..sname.."\",\"Value\":\"" .. svalue .. "\"}"
     PostData = PostData .. "]"
     print(PostData)
     --创建一个TCP连接
     socket=net.createConnection(net.TCP, 0)
     
     --域名解析IP地址并赋值
     socket:dns("www.lewei50.com", function(conn, ip)
          ServerIP = ip
          print("Connection IP:" .. ServerIP)
          end)
     
     --开始连接服务器
     socket:connect(80, ServerIP)
     --print(apiUrl)
     socket:on("connection", function(sck) end)
     --HTTP请求头定义
     socket:send("POST /api/V1/gateway/"..apiUrl.." HTTP/1.1\r\n" ..
                    "Host: www.lewei50.com\r\n" ..
                    "Content-Length: " .. string.len(PostData) .. "\r\n" ..
                    "userkey: "..userKey.."\r\n\r\n" ..
                    PostData .. "\r\n")
     --HTTP响应内容
     socket:on("receive", function(sck, response)
          print(response)
          end)
     sensorValueTable  = {}
end

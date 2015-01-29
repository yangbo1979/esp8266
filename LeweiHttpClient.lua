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
LeweiHttpClient.appendSensorValue("sensor1","1")
LeweiHttpClient.sendSensorValue("sensor2","3")
end)
--]]

local moduleName = ...
local M = {}
_G[moduleName] = M

local ServerIP

local gatewayNo
local userKey
local sensorValueTable

function M.init(gw,ukey)
     gatewayNo =gw
     userKey =ukey
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
     socket:on("connection", function(sck) end)
     --HTTP请求头定义
     socket:send("POST /api/V1/gateway/UpdateSensors/"..gatewayNo.." HTTP/1.1\r\n" ..
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

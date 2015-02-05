ssid="ESP8266_".. node.chipid()
password="12345678"

wifi.setmode(wifi.SOFTAP)
--set ap ssid and pwd
cfg={}
cfg.ssid=ssid
cfg.pwd=password
wifi.ap.config(cfg)
print(wifi.ap.getip())

--  http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
     conn:on("receive",function(conn,payload)
          --print(payload)
          print("received")
          --conn:send("<h1> Hello, NodeMcu.</h1>")
          if(_G["wifiStatue"] == nil) then _G["wifiStatue"]="..." end
          k = string.find(payload,"ssid")
          if k then
               str=string.sub(payload,k)
               --print(str)
               m=string.find(str,"&")
               --print(m)
               strssid='ssid='..'"'..string.sub(str,6,(m-1))..'"'
               print(strssid)
               strpass='password="'..string.sub(str,(m+10))..'"'
               print(strpass)

               file.open("network_user_cfg.lua","w+")
               file.writeline(strssid)
               file.writeline(strpass)
               file.close()

               _G["wifiStatue"]="Saved"
               print("store ok")
          end
          -- html-output
          conn:send("HTTP/1.0 200 OK\r\nContent-type: text/html\r\nServer: ESP8266\r\n\n")
          conn:send("<html><head>")
          if(_G["wifiStatue"]=="Saved") then
          conn:send("<meta http-equiv=\"refresh\" content=\"30\">")
          end
          conn:send("</head><body>")
          conn:send("<div><h2><b>Configurate ESP8266</b></h2>")
          conn:send("<font color=\"red\">[<i>".._G["wifiStatue"].."</i>]</color>")
          if(_G["wifiStatue"]=="Saved") then
          conn:send("<br>wait 30 sec<br>Server lost mean NO ERROR MET.")
          end
          conn:send("<FORM action=\"\" method=\"POST\">")
          conn:send("<table><tr><td>")
          conn:send("SSID:</td><td><input type=\"text\" name=\"ssid\" value=\"")
          if(_G["wifissid"] ~= nil) then conn:send(_G["wifissid"]) end
          conn:send("\"></td></tr>")
          conn:send("<tr><td>")
          conn:send("Password</td><td><input type=\"password\" name=\"password\"></td></tr>")
          conn:send("<tr><td><input type=\"submit\" value=\"SAVE\"></td></tr>")
          conn:send("</table>")
          conn:send("</form></div>")
          conn:send("</body>")
          conn:send("</html>")
          conn:close()

          if(_G["wifiStatue"]=="Saved") then
               print("try to reboot")
               tmr.alarm(0,5000,0,function()node.restart() end )
          elseif(_G["wifiStatue"]=="..." or _G["wifiStatue"]=="Failed") then 
               --keep server open for 10 min to configure
               tmr.alarm(0,600000,0,function()node.restart() end )
          end
     end)
end)

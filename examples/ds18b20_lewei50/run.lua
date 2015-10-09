require("LeweiHttpClient")

LeweiHttpClient.init("01","your_api_key_here")
tmr.alarm(0, 60000, 1, function()
          t=require("ds18b20")
					t.setup(5)
					addrs=t.addrs()
					-- Total DS18B20 numbers, assume it is 2
					--print(table.getn(addrs))
					-- The first DS18B20
					--print(t.read(addrs[1],t.C))
					--print(t.read(addrs[1],t.F))
					--print(t.read(addrs[1],t.K))
					-- The second DS18B20
					--print(t.read(addrs[2],t.C))
					--print(t.read(addrs[2],t.F))
					--print(t.read(addrs[2],t.K))
					-- Just read
					--print(t.read())
					-- Just read as centigrade
					T1 = t.read(nil,t.C)
					print(T1)
          vcc = adc.read(0)
					vcc =vcc*557/100
					if(T1 ~= nil) then
					     LeweiHttpClient.sendSensorValue("T1",T1)   
					     LeweiHttpClient.appendSensorValue("Vol",vcc)
                         end
					-- Don't forget to release it after use
					t = nil
					ds18b20 = nil
					package.loaded["ds18b20"]=nil
end)





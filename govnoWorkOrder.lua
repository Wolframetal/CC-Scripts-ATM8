mon = peripheral.find("monitor")
col = peripheral.find("colonyIntegrator")
mon.setTextScale(1)
while(true) do
    wos = col.getWorkOrders()
    local woids = {}
    for i=1, #wos, 1 do
        table.insert(woids, {wos[i]["id"], wos[i]["type"]}) 
    end
    
    
    for i=1, #woids, 1 do
    for j=1 , 10 , 1 do
        wor = col.getWorkOrderResources(woids[i][1])
        mon.clear()
        mon.setTextColor(colors.white) 
        mon.setCursorPos(2, 1)
        mon.write("Job Type: " .. woids[i][2]) 
        mon.setCursorPos(40,1)
        mon.write ("Available")
        mon.setCursorPos(60,1)
        mon.write("Delivering") 
        row = 3
        if (wor) then
        for k,v in pairs(wor) do
            mon.setCursorPos(2, row)
            mon.setTextColor(colors.white)
            mon.write(v["displayName"]) 
            mon.setCursorPos(40, row)
            if (v["available"] >= v["needed"]) then
                mon.setTextColor(colors.green)
            else
                mon.setTextColor(colors.red )
            end
            mon.write(v["available"] .. "/" .. v["needed"] )
            mon.setCursorPos(60,row)
            mon.write(v["delivering"])
            row = row + 1
        end
        sleep(1) 
        end
    end
    end
end
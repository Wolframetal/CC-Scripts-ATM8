---
--- Made for the Advanced Peripherals documentation
--- Created by Srendi - Created by Srendi - https://github.com/SirEndii
--- DateTime: 25.04.2021 20:44
--- Link: https://docs.srendi.de/peripherals/colony_integrator/
---

--[[
    TODO:
    1
--]]

colony = peripheral.find("colonyIntegrator")
mon = peripheral.find("monitor")
 
function centerText(text, line, txtback, txtcolor, pos)
    monX, monY = mon.getSize()
    mon.setBackgroundColor(txtback)
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX-length)
    x = math.floor(dif/2)
    
    if pos == "head" then
        mon.setCursorPos(x+1, line)
        mon.write(text)
    elseif pos == "left" then
        mon.setCursorPos(2, line)
        mon.write(text) 
    elseif pos == "right" then
        mon.setCursorPos(monX-length, line)
        mon.write(text)
    end
end
 
function prepareMonitor() 
    mon.clear()
    mon.setTextScale(1)
    centerText("Requests", 1, colors.black, colors.white, "head")
end
 
function printRequests()
    row = 3
    useLeft = true
    for k, v in ipairs(colony.getRequests()) do
        if row > 40 then
            useLeft = false
            row = 3
        end
        
        if useLeft then
            centerText(v.name.. v.desc .. " - ".. v.state, row, colors.black, colors.white, "left")        
        else
            centerText(v.name.. v.desc .. " - ".. v.state, row, colors.black, colors.white, "right")
        end
        row = row+1
    end
end
 
prepareMonitor()
 
while true do
    printRequests()
    sleep(10)
end

--[[
    Request Properties
request	Description
id: string	The request's id
name: string	The name of the request
desc: string	A description about the request
state: string	The state of the request
count: number	The number of the request
minCount: number	The minimum of the request needed
target: string	The request's target
items: table	A list of items attached to the request
--]]

--[[
    Item Properties
item	Description
name: string	The registry name of the item
count: number	The amount of the item
maxStackSize: number	Maximum stack size for the item type
displayName: string	The item's display name
tags: table	A list of item tags
nbt: table	The item's nbt data
--]]
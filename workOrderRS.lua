mon = peripheral.find("monitor")
colony = peripheral.find("colonyIntegrator")
bridge = peripheral.find("rsBridge")

if mon == nil then 
    error("monitor not in range") 
end

if colony == nil then 
    error("colonyIntegrator not in range") 
end

if bridge == nil then 
    error("rsBridge not in range")
end


--[[
    Properties
workOrder	Description
id: string	The work order's id
priority: number	The priority of the work order
workOrderType: string	The type of work order
changed: boolean	If the work order changed
isClaimed: boolean	Whether the work order has been claimed
builder: table	The position of the builder (has x, y, z)
buildingName: string	The name of the building
type: string	The type of the building
targetLevel: number	The building's target level
]]

--[[
    Properties
resource	Description
item: string	The registry name for the item
displayName: string	The display name for the item
status: string	The status of this resource
needed: number	How much of the resource is needed for the job
available: boolean	If the resource is currently available
delivering: boolean	If the resource is currently being delivered
]]

function prepareMonitor() 
    mon.clear()
    mon.setTextScale(1)
    centerText("Work Orders", 1, colors.black, colors.white, "head")
end

function centerText(text, line, backcolor, txtcolor, pos)
    monX, monY = mon.getSize()
    mon.setBackgroundColor(backcolor)
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX-length)
    x = math.floor(dif/2)
    half = math.floor(monX/2)
    
    if pos == "head" then
        mon.setCursorPos(x+1, line)
        mon.write(text)
    elseif pos == "left" then
        mon.setCursorPos(2, line)
        mon.write(text) 
    elseif pos == "right" then
        mon.setCursorPos(monX-length, line)
        mon.write(text)
    elseif pos == "center" then
        mon.setCursorPos(half, line)
        mon.write(text)
    end
end

function printWorkOrders()
    for k, v in pairs(workOrders) do
        if v.isClaimed then
            prepareMonitor()
            centerText(k .. " " .. v.buildingName .. " id: " .. v.id, 2, colors.black, colors.white, "head")
            workOrder = colony.getWorkOrderResources(v.id)
            if workOrder ~= nil then
                for k, v in pairs(workOrder) do
                    txtcolor = colors.white
                    if v.available >= v.needed then txtcolor = colors.green else txtcolor = colors.red end
                    centerText(v.item, 2+k, colors.black, txtcolor, "left")
                    centerText(v.displayName, 2+k, colors.black, txtcolor, "center")
                    centerText(v.available .. "/" .. v.needed, 2+k, colors.black, txtcolor, "right")
                    print (v.item .. " " .. v.available .. "/" .. v.needed)
                end
                sleep(10)
            end
        end
    end
    sleep(5)
end

function exportCraftLink(k, v)
    shortage = v.available - v.needed
    if not bridge.exportItem({name = v.item, amount = shortage}, direction) then
        if not bridge.craftItem({name = v.item, count = shortage}) then 
            table.insert(workOrderRSBad, table)
            print("can't craft in RS: " .. v.item .. " " .. shortage) 
            txtcolor = colors.red
            displayStatusOfItem("can't craft in RS", k, v)
        else
            table.insert(workOrderRSGood, v)
            print("starting craft in RS: " .. v.item .. " " .. shortage) 
            txtcolor = colors.yellow
            displayStatusOfItem("crafting...", k, v)
        end
    else
        table.insert(workOrderRSFinished, v)
            print("successfully extracted from RS: " .. v.item .. " " .. shortage) 
            txtcolor = colors.green
            displayStatusOfItem("successfully extracted from RS", k, v)
    end
end

function displayStatusOfItem(status, k, v)
    centerText(v.displayName, 2+k, colors.black, txtcolor, "left")
    centerText(v.item, 2+k, colors.black, txtcolor, "center")
    centerText(v.available .. "/" .. v.needed, 2+k, colors.black, txtcolor, "right")
end

function firstExtractWorkOrderResourcesFromRS()
    for k, v in pairs(workOrders) do
        if v.isClaimed then
            prepareMonitor()
            workOrder = colony.getWorkOrderResources(v.id)
            if workOrder ~= nil then
                for k, v in pairs(workOrder) do
                    txtcolor = colors.white
                    if v.item:match("domum_ornamentum") then --domum ornamentum for self making
                        table.insert(workOrderRSBad, v)
                        txtcolor = colors.yellow
                        displayStatusOfItem("Only self-Made", k, v)
                    else
                        if (v.available < v.needed) then -- crafting end export from RS
                            txtcolor = colors.red
                            exportCraftLink(k, v)
                        else                            -- all ok
                            txtcolor = colors.green 
                            displayStatusOfItem("Success", k, v)
                        end
                    end
                end
            end
        end
        sleep (10)
    end
end

function functionName()
    prepareMonitor()
    --[[
    for k, v in pairs(workOrderRSBad)
    for k, v in pairs(workOrderRSGood)
    for k, v in pairs(workOrderRSFinished)
    workOrderRSGood = {}
    workOrderRSFinished = {}
    --]]

    for k, v in pairs(workOrders) do
        if v.isClaimed then
            prepareMonitor()
            workOrder = colony.getWorkOrderResources(v.id)
            if workOrder ~= nil then
                for k, v in pairs(workOrder) do
                    txtcolor = colors.white
                    if v.item:match("domum_ornamentum") then --domum ornamentum for self making
                        table.insert(workOrderRSBad, v)
                        txtcolor = colors.yellow
                        displayStatusOfItem("Only self-Made", k, v)
                    else
                        if (v.available < v.needed) then -- crafting end export from RS
                            txtcolor = colors.red
                            displayStatusOfItem("Processing in RS...", k, v)
                        else                            -- all ok
                            txtcolor = colors.green 
                            displayStatusOfItem("Success", k, v)
                        end
                    end
                end
            end
        end
        sleep (10)
    end
end

function extractWorkOrderResourcesFromRS()
    if C then
        firstExtractWorkOrderResourcesFromRS()
    else
        functionName()
    end
end

function chooseDirection()
    repeat
        print("Where is inventory of bridge? (north, west, east, south, up, down)")
        d = io.read()
    until direction == "north" or "west" or "east" or "south" or "up" or "down"
    return d
end

function chooseMod()
    repeat
        print("rsMod? (y/n)")
        mod = io.read()
    until mod == "y" or "n"
    return mod
end

direction = "east" -- do chooseDirection() function here if you want
C = true
rsMod = chooseMod()
while true do
    workOrders = colony.getWorkOrders()
    workOrder = {}
    workOrderRSBad = {}
    workOrderRSGood = {}
    workOrderRSFinished = {}
    listRS = bridge.listItems()
    txtcolor = colors.white
    if rsMod == "y" then
        extractWorkOrderResourcesFromRS()
    else
        printWorkOrders()
    end
    C = false
    sleep(10)
end


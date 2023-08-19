mon = peripheral.find("monitor")
colony = peripheral.find("colonyIntegrator")

if mon == nil then 
    error("monitor not in range") 
end

if colony == nil then 
    error("colonyIntegrator not in range") 
end

--colony.getWorkOrders()

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


--colony.getWorkOrderResources()

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

workOrders = {}
workOrder = {}

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

--table.insert(workOrder, colony.getWorkOrderResources(k))

function printWorkOrders()
    workOrders = colony.getWorkOrders()
    workOrder = {}
    for k, v in pairs(workOrders) do
        if v.isClaimed then
            local claim
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
                sleep(5)
            end
        end
    end
    sleep(5)
end

while true do
    printWorkOrders()
end
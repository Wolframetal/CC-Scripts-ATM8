---
--- Made for the Advanced Peripherals documentation
--- Created by Srendi - Created by Srendi - https://github.com/SirEndii
--- DateTime: 25.04.2021 20:44
--- Link: https://docs.srendi.de/peripherals/colony_integrator/
---


colony = peripheral.find("colonyIntegrator")
mon = peripheral.find("monitor")
 
function printRequests()
    for k, v in ipairs(colony.getRequests()) do
         print(v.name.. " - ".. v.state)
         for k, v in ipairs(v.items) do
             print(v.name, v.count)
        end   
    end
end

printRequests()

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
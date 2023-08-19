local bridge = peripheral.find("meBridge")

if bridge == nil then 
    error("meBridge not in range")
end 

function confirm(warning, bool) -- warning is string. bool true - error
    print(warning .. "\nContinue? (y/n)")
    local answer
    repeat answer=io.read() until answer=="y" or answer=="n"
    if answer=="n" and bool then 
          error("Stopped by confirm()") 
    end
    return answer
end

function chooseDirection()
    repeat
        print("Where is inventory of bridge? (north, west, east, south, up, down)")
        d = io.read()
    until direction = "north" or "west" or "east" or "south" or "up" or "down"
return d

function exportApotheosisItems(items) -- voids data after completion
    for _, item in pairs(items) do
        if item.nbt ~= nil then
            if item.nbt.rarity ~= nil then
                print(item.nbt.rarity, item.displayName, item.amount)
                for i = 1,item.amount do
                    bridge.exportItem({name = item.name, amount = "1", nbt = item.nbt}, direction)
                end
                print("extracted")
            elseif item.nbt.affix_data ~= nil then
                print(item.nbt.affix_data.rarity, item.displayName, item.amount)
                for i = 1, item.amount do
                    bridge.exportItem({name = item.name, amount = "1", nbt = item.nbt}, direction)
                end
                print("extracted")
            end
        end
        item = nil
    end
    items = nil
return 

confirm("This program will extract all apotheosis items in your ME system", true)

local direction = chooseDirection()
print("started listing")
items = bridge.listItems()
print("done listing")
exportApotheosisItems(items)
print("Done!")

--[[ getItems() returns table
item	Description
name: string	The registry name of the item
count: number	The amount of the item
maxStackSize: number	Maximum stack size for the item type
displayName: string	The item's display name
slot: number	The slot that the item stack is in
tags: table	A list of item tags
nbt: table	The item's nbt data 
--]]
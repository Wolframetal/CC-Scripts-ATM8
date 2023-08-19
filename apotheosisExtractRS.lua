local bridge = peripheral.find("rsBridge")

if bridge == nil then 
    error("rsBridge not in range")
end 

function confirm(warning, bool) -- warning is string. bool true - error
    print(warning .. "\nContinue? (y/n)")
    local answer
    repeat answer=io.read() until answer=="y" or "n"
    if answer~="y" and bool then 
          error("Stopped by confirm()") 
    end
    return answer
end

function chooseDirection()
    repeat
        print("Where is inventory of bridge? (north, west, east, south, up, down)")
        d = io.read()
    until direction == "north" or "west" or "east" or "south" or "up" or "down"
    return d
end

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
end

function whatToExtract()
    local answer
    repeat
        answer = nil
        print("What to extract: \n1. Gems \n2. Items with affixes \n3. Both options")
        answer = io.read()
    until answer == "1" or "2" or "3"
    if answer == nil then error("how did you do that?") end
    return answer
end

function whatRarityToExtract()
    local answer
    repeat
        answer = nil
        print("Select which rarity to extract:\n1. All\n2. Uncommon and above\n3. Rare and above\n4. Epic and above\n5. Mythic and above")
        answer = io.read()
    until answer == "1" or "2" or "3" or "4" or "5"
    if answer == "1" then answer = {"common", "uncommon", "rare", "epic", "mythic", "ancient"}
    elseif answer == "2" then answer = {"uncommon", "rare", "epic", "mythic", "ancient"}
    elseif answer == "3" then answer = {"rare", "epic", "mythic", "ancient"}
    elseif answer == "4" then answer = {"epic", "mythic", "ancient"}
    elseif answer == "5" then answer = {"mythic", "ancient"}
    else error("how did you do that?") end
    return answer
end

function exportApotheosisItemsFiltered(items, r, t) -- voids data after completion, t for type, r for rarity
    for _, item in pairs(items) do
        if item.nbt ~= nil then
            if (item.nbt.rarity ~= nil) and (t ~= "2") then -- check for gem
                for k, v in pairs(r) do -- cycle through rarity table
                    if item.nbt.rarity == v then
                        print(item.nbt.rarity, item.displayName, item.amount) -- print item
                        for i = 1,item.amount do -- extract each gem/item by one
                            bridge.exportItem({name = item.name, amount = "1", nbt = item.nbt}, direction) -- BUGGED
                            print("cycled")
                        end
                        print("extracted")
                        break
                    end
                end
            elseif (item.nbt.affix_data ~= nil) and (t ~= "1") then -- check for armor
                for k, v in pairs(r) do -- cycle through rarity table
                    if item.nbt.affix_data.rarity == v then 
                        print(item.nbt.affix_data.rarity, item.displayName, item.amount)
                        for i = 1, item.amount do
                            bridge.exportItem({name = item.name, amount = "1", nbt = item.nbt}, direction) -- BUGGED
                            print("cycled")
                        end
                        print("extracted")
                        break
                    end
                end
            end
        end
        item = nil
    end
    items = nil
end

--[[
bridge.exportItem(item, direction)
item.fingerprint = 32bit item.name * item.nbt * item.displayName
1 ЧТО РЕШИТЬ
ХОЧУ ЭТО
ЗНАЧИТ:

 1. item.fingerprint ТОГО ЧТО ХОЧУЪ
 
 2. item.fingerprint ТОГО ЧТО СЕЙЧАС ПЕРЕБИРАЮ В МЭ 1 СУММА (5 4 3 2 1)  СУММА 1000!
 
 3. Я СРАВНИВАЮ item.fingerprint ЕСЛИ СОВПАЛО ТО ИЗВЛЕЧЬ ИНАЧЕ ПОВТОРИТЬ

ЛИБО 2 ЧТО РЕШИТЬ
 item.nbt ТАБЛИЦА
 РАРИТИ МИФИК
 ФАСЕТС
 УУИДС
 ]]--


confirm("This program will extract all apotheosis items in your RS system", true)

direction = chooseDirection()
print("started listing")
items = bridge.listItems()
print("done listing")
exportApotheosisItemsFiltered(items, whatRarityToExtract(), whatToExtract())

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
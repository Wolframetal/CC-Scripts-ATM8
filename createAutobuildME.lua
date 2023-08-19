local manager = peripheral.find("inventoryManager")
local bridge = peripheral.find("meBridge")

if manager == nil then 
   error("inventoryManager not in range") 
end 

if bridge == nil then 
   error("meBridge not in range")
end 

term.clear()

function confirm(warning, bool) -- warning is string. bool true - error
   print(warning .. "\nContinue? (y/n)")
   local answer
   repeat answer=io.read() until answer=="y" or answer=="n"
   if answer=="n" and bool then 
         error("Stopped by confirm()") 
   end
   return answer
end

function findCheckList() --return content of inventory slot where Checklist is
   confirm("You're trying to getItems() from your inventory. It's bugged in this version. " ..
   "All items in the inventory will receive nbt tags.", true)
   local inv = manager.getItems() -- bugged in AdvancedPeripherals-0.7.27r version, makes nbt tags for items
   for _ in pairs(inv) do
      if inv[_].nbt ~=nil then
         if inv[_].nbt.pages ~= nil and inv[_].nbt.author == "Schematicannon" then
            return inv[_]
         end
      end
   end
   inv = manager.getItemInOffHand()
   if inv.nbt ~= nil then
      if inv.nbt.pages ~= nil and inv.nbt.author == "Schematicannon" then
         return inv
      end
   end
   return error("Can't find Checklist in the inventory")
end

function parseBook(pages) -- for minecraft books only, pattern was made for create:material_checklist
   cL = {id = {}, n = {}} -- returns tables in table
   for p in pairs(pages) do
      for word in string.gmatch(tostring(pages[p]), '%pid%p+(.-%p.-)%p') do 
         table.insert(cL.id, tostring(word))
      end
      for number in string.gmatch(tostring(pages[p]), 'n%sx(%d+)') do 
         table.insert(cL.n, tonumber(number))
      end
   end
   return cL
end

function chooseDirection()
   repeat
       print("Where is inventory of bridge? (north, west, east, south, up, down)")
       d = io.read()
   until direction = "north" or "west" or "east" or "south" or "up" or "down"
   return d
end

inventory = manager.getItems()
checkList = parseBook(findCheckList().nbt.pages)
tableShortageMaterials = {name = {}, count = {}}
countAll = 0
direction = chooseDirection()

for _, item in pairs(checkList.id) do -- compares items in checklist with RS
   repeat
      local answer = "n"
      itemME = bridge.getItem({name = item})
      if itemME.amount < checkList.n[_] then
         print("Out of [" .. item .. "], check your supplies! Need for construction: x" 
         .. checkList.n[_] - itemME.amount .. "\n")   
         answer = confirm("repeating request...", false)
      end
   until answer=="n"
   if itemME.amount < checkList.n[_] then
      print("Not transferred: " .. item .. "\n")
      table.insert(tableShortageMaterials.name, tostring(item))
      table.insert(tableShortageMaterials.count, tonumber(checkList.n[_] - itemME.amount))
      sleep(1)
   else
      bridge.exportItem({name=item, count=checkList.n[_]}, direction)
      countAll = countAll + checkList.n[_]
      print("Transferred: " .. item .. " x" .. checkList.n[_] .. "\n")
   end
end

itemME = bridge.getItem({name = "minecraft:gunpowder"})
countAll = math.ceil(countAll / 400)
if itemME.count < countAll / 400 then
   bridge.exportItem({name="minecraft:gunpowder", count= countAll}, direction)
   print("Transferred: " .. "minecraft:gunpowder" .. " x" .. countAll .. "\n")
end

sleep(1)
print("Successfully done! ^ ^")
sleep(1)

if tableShortageMaterials.name[1] ~= nil then
   term.clear()
   print("Please make sure to add this to Schematicannon inventory:\n")
   for _, item in pairs(tableShortageMaterials.name) do
      print( item .. " x" .. tableShortageMaterials.count[_])
   end
end


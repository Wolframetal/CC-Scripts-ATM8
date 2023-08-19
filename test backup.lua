--[[TODO: расчет сопротивления игрока без баффов
1. занесение брони игрока в таблицу
2. полученик чисел сопротивления для разных условий
3. интеграция с apotheosis и с curious
4. вывод данных с выделением слабых мест
]]--





local manager = peripheral.find("inventoryManager")
local bridge = peripheral.find("rsBridge")

function findCheckList(inv) --return number of slot where Checklist is
   for _ in pairs(inv) do
      if inv[_].nbt.pages ~= nil then
         return _
      end
   end
end

function parseBook(pages) -- for minecraft books only, pattern was made for create:material_checklist
   cL = {id = {}, n = {}}
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

local inventory = manager.getItems()
local checkList = parseBook(inventory[findCheckList(inventory)].nbt.pages)

for _, item in pairs(checkList.id) do
   print("trying export: " .. item .. " x" .. checkList.n[_])
   --tableRS = bridge.getItem({name=item, amount=tonumber(checkList.n[_])})
   if bridge.getItem({name=item, amount=tonumber(checkList.n[_])}) == nil then
      print("error " .. item)
      --print("Out of [" .. item .. "], check your supplies! Need for construction: x" .. 
      --tonumber(checkList.n[_]))
   end

   --print(bridge.getItem({name=item, count=tonumber(checkList.n[_])}))
   bridge.exportItem({name=item, count=tonumber(checkList.n[_])}, "up")
   
   sleep(0)
end
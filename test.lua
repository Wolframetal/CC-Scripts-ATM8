local manager = peripheral.find("inventoryManager")
local bridge = peripheral.find("rsBridge")

if manager == nil then 
   error("inventoryManager not in range") 
end 

if bridge == nil then 
   error("rsBridge not in range")
end 

term.clear()

local inv = manager.getItems()
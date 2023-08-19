--[[TODO: 
list of players in range [x]

]]--

local chatBox = peripheral.find("chatBox")
local detector = peripheral.find("playerDetector")
local speaker = peripheral.find("speaker")
local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()
--Вся База
local p1 = { x = 464, y = 61, z = 544 } 
local p2 = { x = 591, y = 100, z = 671 }
-- Возле Компьютера
local p3 = { x = 496, y = 64, z = 595}
local p4 = { x = 501, y = 68, z = 601}

local p5 = { x = -11, y = 70, z = -23}
local p6 = { x = -2, y = 78, z = -15}

if detector == nil then 
    error("playerDetector not in range") 
end 

--[[
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end --]]

 function dump(o)
    if type(o) == 'table' then
        local s
       for k,v in pairs(o) do
          s = ''..k..' ' .. dump(v) .. '\n'
       end
       return s
    else
       return tostring(o)
    end
 end

function AudioChoose()
    print("Choose your song.\n")
end  

function PlayerWhoCheck(posOne, posTwo) 
    return detector.getPlayersInCoords(posOne, posTwo)
end 

function PlayerCheck(posOne, posTwo) 
    return detector.isPlayersInCoords(posOne, posTwo)
end 

--[[
while true do 
    -- if PlayerCheck(p1, p2) == true then Условие  
    if PlayerCheck(p3, p4) == true then 
        --chatBox.sendMessage("Welcome to Leindell!", "WolfDiamond", "<>", "", 30)
        for chunk in io.lines("among_us_sus.dfpwm", 16 * 1024) do
            local buffer = decoder(chunk)
            while not speaker.playAudio(buffer) do
                os.pullEvent("speaker_audio_empty")
            end
        end
    end 
sleep(1) 
end
--]]


while true do 
    -- if PlayerCheck(p1, p2) == true then
    if PlayerCheck(p1, p2) == true then
        chatBox.sendMessage("Curent players in Leindell"..dump(PlayerWhoCheck(p1, p2)), "WolfDiamond", "<>", "", 30)
        print("Players:\n", dump(PlayerWhoCheck(p5, p6)))
        --[[ Music box
        for chunk in io.lines("among_us_sus.dfpwm", 16 * 1024) do
            local buffer = decoder(chunk)
            while not speaker.playAudio(buffer) do
                os.pullEvent("speaker_audio_empty")
            end
        end
        --]]
        return(false)
    end
sleep(1) 
end
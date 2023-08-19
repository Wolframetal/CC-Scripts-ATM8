local chatBox = peripheral.find("chatBox")
local detector = peripheral.find("playerDetector")
local speaker = peripheral.find("speaker")
local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

local p1 = { x = 464, y = 61, z = 544 } 
local p2 = { x = 591, y = 100, z = 671 }

local p3 = { x = 496, y = 64, z = 595}
local p4 = { x = 501, y = 68, z = 601}

if detector == nil then 
    error("playerDetector not in range") 
end 
function AudioChoose()
    print("Choose your song.\n")
end    
function PlayerCheck(posOne, posTwo) 
    return detector.isPlayersInCoords(posOne, posTwo) 
end 
while true do 
    if PlayerCheck(p1, p2)
    chatBox.sendMessage("Hello world!")
    os.sleep(1)
    chatBox.sendMessage("Добро пожаловать в Лейделл!", "WolfDiamond", "<>", "", 30)
    end    
    if PlayerCheck(p3, p4) == true then 
        for chunk in io.lines("among_us_sus.dfpwm", 16 * 1024) do
            local buffer = decoder(chunk)

            while not speaker.playAudio(buffer) do
                os.pullEvent("speaker_audio_empty")
            end
        end
    else 
        print("Nope.\n") 
    end 
sleep(0) 
end
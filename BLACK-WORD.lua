-- [[ BLACK-WORD V2 - AUTO RESPONSE EDITION ]] --
-- [[ EXCLUSIVE FOR ACEL👑 | FULL STEALTH AUTO-PLAY ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- [[ SETTINGS ]] --
_G.AutoPlay = false
_G.MinDelay = 2 -- Jeda minimal (detik)
_G.MaxDelay = 4 -- Jeda maksimal (biar gak kena ban)
local Words = {}

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK-WORD V2 | AUTO-KILL",
   LoadingTitle = "SYNCHRONIZING KBBI ENGINE...",
   LoadingSubtitle = "BY BLACK-AI FOR ACEL",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Auto Game 😈")

-- [[ LOAD KBBI DATABASE ]] --
task.spawn(function()
    local Success, Result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/hizbe/kbbi-data/master/bin/word.txt")
    end)
    if Success then
        for word in Result:gmatch("%S+") do
            table.insert(Words, word:lower())
        end
        Rayfield:Notify({Title = "READY!", Content = "Database KBBI AKTIF. Bantai mereka!", Duration = 5})
    end
end)

-- [[ CHAT FUNCTION ]] --
local function SendToChat(msg)
    -- Logic kirim pesan ke chat Roblox (Legacy & New System)
    local Event = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    if Event then
        Event:FireServer(msg, "All")
    else
        -- Fallback buat game modern (TextChatService)
        local TextChannel = game:GetService("TextChatService"):FindFirstChild("TextChannels") and game.TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if TextChannel then
            TextChannel:SendAsync(msg)
        end
    end
end

-- [[ AUTO LOGIC ]] --
local function GetReply(lastWord)
    local lastChar = lastWord:sub(-1):lower()
    for _, word in pairs(Words) do
        if word:sub(1,1) == lastChar and word ~= lastWord:lower() then
            return word
        end
    end
    return nil
end

-- Monitor Chat
for _, player in pairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        if _G.AutoPlay and player ~= LocalPlayer then
            local reply = GetReply(msg)
            if reply then
                task.wait(math.random(_G.MinDelay, _G.MaxDelay)) -- Jeda "Mikir"
                if _G.AutoPlay then -- Cek lagi bisi udah di-off
                    SendToChat(reply)
                end
            end
        end
    end)
end

-- [[ UI CONTROLS ]] --
Tab:CreateToggle({
   Name = "ACTIVATE AUTO-PLAY 🤖",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoPlay = Value
      Rayfield:Notify({
          Title = "SYSTEM STATUS", 
          Content = Value and "BOT AKTIF! Tinggal liatin aja musuh mampus. 😈" or "BOT MATI.", 
          Duration = 3
      })
   end,
})

Tab:CreateSlider({
   Name = "Delay Mikir (Detik)",
   Range = {1, 10},
   Increment = 1,
   CurrentValue = 3,
   Callback = function(Value)
      _G.MinDelay = Value
      _G.MaxDelay = Value + 2
   end,
})

Tab:CreateSection("Manual Backup")
Tab:CreateInput({
   Name = "Manual Guess",
   PlaceholderText = "Ketik kata musuh...",
   Callback = function(Text)
       local res = GetReply(Text)
       if res then Rayfield:Notify({Title = "SARAN", Content = "Balas: "..res:upper()}) end
   end,
})

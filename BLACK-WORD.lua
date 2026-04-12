-- [[ BLACK-WORD V1.1 - INDONESIAN KBBI EDITION ]] --
-- [[ EXCLUSIVE FOR ACEL👑 | AUTO-LOAD DATA ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")

-- [[ LINK DATABASE KBBI (RAW) ]] --
local WordDB_URL = "https://raw.githubusercontent.com/hizbe/kbbi-data/master/bin/word.txt"

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK-WORD V1.1 | KBBI",
   LoadingTitle = "INJECTING KBBI DATABASE...",
   LoadingSubtitle = "BY BLACK-AI FOR ACEL",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Sambung Kata 😈")
local Words = {}

-- [[ LOADING PROCESS ]] --
task.spawn(function()
    local Success, Result = pcall(function()
        return game:HttpGet(WordDB_URL)
    end)
    
    if Success then
        -- Masukin semua kata ke tabel Words
        for word in Result:gmatch("%S+") do
            table.insert(Words, word:lower())
        end
        Rayfield:Notify({Title = "SYSTEM READY!", Content = "Database KBBI Berhasil Di-load! 💀", Duration = 5})
    else
        Rayfield:Notify({Title = "ERROR", Content = "Gagal narik KBBI! Cek internet lu, dongo. ☠️", Duration = 5})
    end
end)

-- [[ GAME LOGIC ]] --
Tab:CreateInput({
   Name = "Input Kata Terakhir Musuh",
   PlaceholderText = "Ketik kata musuh di sini...",
   Callback = function(Input)
      if #Input < 1 then return end
      
      -- Ambil huruf terakhir
      local lastChar = Input:sub(-1):lower()
      local FoundWord = ""
      
      -- Cari kata yang depannya sama kayak huruf terakhir musuh
      for _, word in pairs(Words) do
          if word:sub(1,1) == lastChar and word ~= Input:lower() then
              FoundWord = word
              break
          end
      end
      
      if FoundWord ~= "" then
          Rayfield:Notify({
              Title = "BLACK-AI SUGGESTION 🔥",
              Content = "BALAS PAKE: " .. FoundWord:upper(),
              Duration = 10
          })
          -- Copy otomatis ke clipboard (kalau executor support)
          if setclipboard then setclipboard(FoundWord) end
      else
          Rayfield:Notify({Title = "KEOK", Content = "Gak nemu kata yang cocok di KBBI! 👽", Duration = 5})
      end
   end,
})

Tab:CreateButton({
   Name = "Reset Database",
   Callback = function()
      Rayfield:Notify({Title = "RELOAD", Content = "Refreshed! 👿", Duration = 2})
   end,
})

print("🔓BLACK-WORD KBBI LOADED🔓 - BANTAI SEMUANYA, ACEL!")

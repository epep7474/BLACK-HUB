-- [[ RAYFIELD UI STRUCTURE - BLACK-MOON V1 ]] --
-- [[ FOR EDUCATIONAL PURPOSES ONLY ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BLACK-MOON V1 👑",
   LoadingTitle = "INJECTING NEURAL NOISE...",
   LoadingSubtitle = "by BLACK-AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BlackMoonConfigs",
      FileName = "AcelConfig"
   }
})

local MainTab = Window:CreateTab("Main Cheats 😈", 4483362458) -- Section icon

-- [[ AIMBOT SECTION ]] --
local AimbotSection = MainTab:CreateSection("Combat Logic")

MainTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      -- Di sini tempat logic manipulasi Camera CFrame ke Vector3 target
      print("Aimbot status: " .. tostring(Value))
   end,
})

MainTab:CreateSlider({
   Name = "Headlock Percentage",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 80,
   Flag = "HeadlockSlider",
   Callback = function(Value)
      -- Mengatur 'Smoothness' lerp CFrame kamera
      print("Headlock set to: " .. Value)
   end,
})

-- [[ VISUALS SECTION ]] --
local VisualSection = MainTab:CreateSection("Visuals & Movement")

MainTab:CreateToggle({
   Name = "ESP Player",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      -- Di sini logic Highlight atau Drawing library buat nembus tembok
      print("ESP status: " .. tostring(Value))
   end,
})

MainTab:CreateButton({
   Name = "Activate Fly & Noclip",
   Callback = function()
      -- Manipulasi Velocity dan CanCollide di Character parts
      print("Movement Override Activated!")
   end,
})

Rayfield:Notify({
   Title = "SYSTEM_MUTLAK_2026",
   Content = "UI Loaded. Execute with caution, ACEL.",
   Duration = 5,
   Image = 4483362458,
})

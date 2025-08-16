local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window = Rayfield:CreateWindow({
    Name = "My Market Script",
    LoadingTitle = "My Market Script",
    LoadingSubtitle = "by Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyMarketConfigs"
    }
})

local Tab = Window:CreateTab("Auto Features")

-- Auto Buy
local AutoBuyToggle = Tab:CreateToggle({
    Name = "Auto Buy",
    Callback = function(state)
        if state then
            while wait(1) do
                local REClientSFX = ReplicatedStorage.Modules.Net["RE/ClientSFX"]
                firesignal(REClientSFX.OnClientEvent, "Purchase")
            end
        end
    end
})

-- Auto Open
local AutoOpenToggle = Tab:CreateToggle({
    Name = "Auto Open",
    Callback = function(state)
        if state then
            while wait(1) do
                local REUnlockCrate = ReplicatedStorage.Modules.Net["RE/UnlockCrate"]
                firesignal(REUnlockCrate.OnClientEvent, "Smoothie", "")
            end
        end
    end
})

-- Infinite Money
local InfiniteMoneyButton = Tab:CreateButton({
    Name = "Infinite Money",
    Callback = function()
        -- Implementasi untuk memberikan uang tak terbatas
        -- Sesuaikan dengan struktur data uang game
        local Player = game.Players.LocalPlayer
        local MoneyValue = Player:FindFirstChild("Money") or Player.leaderstats:FindFirstChild("Money")
        if MoneyValue then
            MoneyValue.Value = math.huge
        end
    end
})

-- Auto Collect
local AutoCollectButton = Tab:CreateButton({
    Name = "Auto Collect",
    Callback = function()
        -- Implementasi untuk mengumpulkan barang secara otomatis
        -- Sesuaikan dengan mekanisme koleksi game
        local REClientSFX = ReplicatedStorage.Modules.Net["RE/ClientSFX"]
        firesignal(REClientSFX.OnClientEvent, "Collect")
    end
})

-- Spawner Crate
local SpawnCrateToggle = Tab:CreateToggle({
    Name = "Spawn Crate",
    Callback = function(state)
        if state then
            while wait(5) do
                local RENewCrate = ReplicatedStorage.Modules.Net["RE/NewCrate"]
                firesignal(RENewCrate.OnClientEvent, "Neon")
            end
        end
    end
})

-- Settings Section
local SettingsTab = Window:CreateTab("Settings")

SettingsTab:CreateToggle({
    Name = "Toggle UI",
    Callback = function(state)
        Rayfield:Toggle(state)
    end
})

SettingsTab:CreateKeybind({
    Name = "Toggle Key",
    CurrentKeybind = "RightShift",
    Callback = function(keybind)
        -- Simpan keybind ke konfigurasi
    end
})

SettingsTab:CreateColorPicker({
    Name = "UI Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        -- Ubah warna UI
        Rayfield:SetTheme({
            TextColor = color
        })
    end
})

-- Load Configuration
if Window.ConfigurationSaving.Enabled then
    Window:LoadConfiguration()
end

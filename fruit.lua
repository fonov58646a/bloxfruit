--[[ My-Market 4-in-1 | Rayfield Edition ]]--
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RS = game:GetService("ReplicatedStorage")
local plr = game:GetService("Players").LocalPlayer

-- remotes (from your Sigma-Spy logs)
local buy    = RS.Modules.Net["RE/BuyCrate"]
local spawn  = RS.Modules.Net["RE/NewCrate"]
local unlock = RS.Modules.Net["RE/UnlockCrate"]
local notify = RS.Modules.Net["RE/NotificationManager"]

-- fire helper
local function fire(remote, ...)
    if remote and remote:IsA("RemoteEvent") then
        firesignal(remote.OnClientEvent, ...)
    end
end

-- ------------------------------------------------------------------------------
-- Rayfield window
local Window = Rayfield:CreateWindow({
    Name        = "My-Market Helper",
    LoadingTitle = "Setting up...",
    LoadingSubtitle = "by @you",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458) -- icon id

-- crate list
local CRATES = {"Basic","Rare","Epic","Legendary","Golden","Neon","Galaxy","Rainbow Crystal"}
local selected = "Golden"
local running  = false

-- dropdown
Tab:CreateDropdown({
    Name = "Pick Crate",
    Options = CRATES,
    CurrentOption = {selected},
    MultipleOptions = false,
    Callback = function(opt) selected = opt[1] end
})

-- toggles
local autoToggle = Tab:CreateToggle({
    Name = "Auto Buy + Open",
    CurrentValue = false,
    Callback = function(v)
        running = v
        if v then
            while running do
                fire(buy, selected)
                fire(spawn, selected)
                task.wait(.1)
                fire(unlock, selected, "")
                task.wait(.4) -- small delay to avoid spam-kick
            end
        end
    end
})

-- money button
Tab:CreateButton({
    Name = "Give 9 999 999 Cash (visual)",
    Callback = function()
        local ls = plr:FindFirstChild("leaderstats")
        if ls then
            local cash = ls:FindFirstChild("Cash")
            if cash then cash.Value = 9_999_999 end
        end
        fire(notify, "Cash set to 9 999 999", "", Color3.fromRGB(0,255,0))
    end
})

Rayfield:Notify({
    Title = "Ready",
    Content = "UI loaded. Pick a crate and toggle the loop!",
    Duration = 3
})

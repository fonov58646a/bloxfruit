-- My-Market 4-in-1 helper
-- (auto-buy, auto-open, spawner, infinite money)

local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

-- Remotes
local buy     = RS.Modules.Net["RE/BuyCrate"]        -- real purchase
local spawn   = RS.Modules.Net["RE/NewCrate"]        -- visual spawn
local unlock  = RS.Modules.Net["RE/UnlockCrate"]     -- instant open
local notify  = RS.Modules.Net["RE/NotificationManager"]

-- Crate tiers you can choose
local CRATES = {
    "Basic", "Rare", "Epic", "Legendary",
    "Golden", "Neon", "Galaxy", "Rainbow Crystal"
}

-- ----------------------------------------------
-- Helper – fire a remote safely
local function fire(remote, ...)
    if remote and remote:IsA("RemoteEvent") then
        firesignal(remote.OnClientEvent, ...)
    end
end

-- ----------------------------------------------
-- 1. Infinite money (client-side only)
local function setMoney(amount)
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        local cash = ls:FindFirstChild("Cash")
        if cash then cash.Value = amount end
    end
end
setMoney(9_999_999)

-- ----------------------------------------------
-- 2. Main loop
local running = false
local selectedCrate = "Golden"

local function toggle()
    running = not running
    if running then
        notify.Text = "Started"
        while running do
            -- Buy (server remote – actually costs money)
            fire(buy, selectedCrate)

            -- Visual spawn + instant open
            fire(spawn, selectedCrate)
            wait(.1)
            fire(unlock, selectedCrate, "")

            wait(.3) -- small delay to avoid spam-kick
        end
    else
        notify.Text = "Stopped"
    end
end

-- ----------------------------------------------
-- 3. Tiny UI
local Screen = Instance.new("ScreenGui")
Screen.Name = "MyMarketHelper"
Screen.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 130)
Frame.Position = UDim2.new(0, 20, 0.5, -65)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = Screen

-- Dropdown for crate choice
local Drop = Instance.new("TextButton")
Drop.Size = UDim2.new(0, 160, 0, 25)
Drop.Position = UDim2.new(0, 10, 0, 10)
Drop.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Drop.TextColor3 = Color3.white
Drop.Font = Enum.Font.SourceSans
Drop.TextSize = 14
Drop.Text = selectedCrate
Drop.Parent = Frame

local function buildDrop()
    local list = {}
    for _,t in ipairs(CRATES) do table.insert(list, t) end
    return list
end

Drop.MouseButton1Click:Connect(function()
    -- simple cycle
    local idx = table.find(CRATES, selectedCrate) or 1
    idx = (idx % #CRATES) + 1
    selectedCrate = CRATES[idx]
    Drop.Text = selectedCrate
end)

-- Start / Stop button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 160, 0, 25)
ToggleBtn.Position = UDim2.new(0, 10, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.TextColor3 = Color3.white
ToggleBtn.Font = Enum.Font.SourceSans
ToggleBtn.TextSize = 14
ToggleBtn.Text = "Start"
ToggleBtn.Parent = Frame

ToggleBtn.MouseButton1Click:Connect(function()
    toggle()
    ToggleBtn.Text = running and "Stop" or "Start"
    ToggleBtn.BackgroundColor3 = running and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
end)

-- Money button
local MoneyBtn = Instance.new("TextButton")
MoneyBtn.Size = UDim2.new(0, 160, 0, 25)
MoneyBtn.Position = UDim2.new(0, 10, 0, 80)
MoneyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 170)
MoneyBtn.TextColor3 = Color3.white
MoneyBtn.Font = Enum.Font.SourceSans
MoneyBtn.TextSize = 14
MoneyBtn.Text = "9 999 999 Cash"
MoneyBtn.Parent = Frame

MoneyBtn.MouseButton1Click:Connect(function()
    setMoney(9_999_999)
    fire(notify, "Cash set to 9 999 999", "", Color3.fromRGB(0, 255, 0))
end)

-- ----------------------------------------------
-- Hot-keys
UIS.InputBegan:Connect(function(io, gp)
    if gp then return end
    if io.KeyCode == Enum.KeyCode.X and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggle()
        ToggleBtn.Text = running and "Stop" or "Start"
        ToggleBtn.BackgroundColor3 = running and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
    elseif io.KeyCode == Enum.KeyCode.Z and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        setMoney(9_999_999)
        fire(notify, "Cash set to 9 999 999", "", Color3.fromRGB(0, 255, 0))
    end
end)

warn("My-Market helper loaded!  Ctrl + X to toggle loop, Ctrl + Z for money.")

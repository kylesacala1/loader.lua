--[[
    Game: Tap Simulator Reborn
    Script: Ultra-Fast Remote Tap & Auto-Clicker
    Executor: Delta Compatible
]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Safety check to ensure we are in the game
if not LocalPlayer then return end

-- Attempt to locate the primary tap remote dynamically
local function findTapRemote()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:find("tap") or name:find("click") or name:find("train") then
                return obj
            end
        end
    end
    return nil
end

local tapRemote = findTapRemote()

-- Settings
getgenv().AutoTap = getgenv().AutoTap or false
getgenv().AutoRebirth = getgenv().AutoRebirth or false
getgenv().TapSpeed = 0 -- 0 means maximum speed per frame/heartbeat

-- UI Library (Lightweight Custom Implementation for Delta)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local ToggleTapBtn = Instance.new("TextButton")
local UICornerBtn1 = Instance.new("UICorner")
local ToggleRebirthBtn = Instance.new("TextButton")
local UICornerBtn2 = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "TapSimulatorUltraGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true -- Allows moving around easily on Delta mobile

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Ultra Tap Reborn"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

ToggleTapBtn.Name = "ToggleTapBtn"
ToggleTapBtn.Parent = MainFrame
ToggleTapBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleTapBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleTapBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleTapBtn.Font = Enum.Font.GothamBold
ToggleTapBtn.Text = "Auto Tap: OFF"
ToggleTapBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleTapBtn.TextSize = 14

UICornerBtn1.CornerRadius = UDim.new(0, 8)
UICornerBtn1.Parent = ToggleTapBtn

ToggleRebirthBtn.Name = "ToggleRebirthBtn"
ToggleRebirthBtn.Parent = MainFrame
ToggleRebirthBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleRebirthBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
ToggleRebirthBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleRebirthBtn.Font = Enum.Font.GothamBold
ToggleRebirthBtn.Text = "Auto Rebirth: OFF"
ToggleRebirthBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleRebirthBtn.TextSize = 14

UICornerBtn2.CornerRadius = UDim.new(0, 8)
UICornerBtn2.Parent = ToggleRebirthBtn

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.86, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = tapRemote and "Status: Remote Found ✅" : "Status: Remote Missing ❌"
StatusLabel.TextColor3 = tapRemote and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 10

-- Core Ultra-Fast Auto Tap Loop
task.spawn(function()
    while true do
        if getgenv().AutoTap and tapRemote then
            pcall(function()
                -- Fires the remote multiple times per cycle for extreme speed without lagging the client UI thread
                for i = 1, 5 do
                    tapRemote:FireServer()
                end
            end)
        end
        task.wait(getgenv().TapSpeed)
    end
end)

-- Core Auto Rebirth Loop (Optional convenience)
task.spawn(function()
    while true do
        if getgenv().AutoRebirth then
            pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("rebirth")) then
                        obj:FireServer()
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- Button Functionality
ToggleTapBtn.MouseButton1Click:Connect(function()
    getgenv().AutoTap = not getgenv().AutoTap
    if getgenv().AutoTap then
        ToggleTapBtn.Text = "Auto Tap: ON"
        ToggleTapBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleTapBtn.Text = "Auto Tap: OFF"
        ToggleTapBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

ToggleRebirthBtn.MouseButton1Click:Connect(function()
    getgenv().AutoRebirth = not getgenv().AutoRebirth
    if getgenv().AutoRebirth then
        ToggleRebirthBtn.Text = "Auto Rebirth: ON"
        ToggleRebirthBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleRebirthBtn.Text = "Auto Rebirth: OFF"
        ToggleRebirthBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

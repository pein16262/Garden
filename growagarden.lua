-- Grow a Garden Script with GUI and Barrier Bypass
-- Author: You

-- CONFIG
local stealthMode = true
local bypassProtectedBarriers = true

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- FUNCTIONS
local function findAllSeedTools()
    local tools = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("Tool") then
            table.insert(tools, v.Name)
        end
    end
    return tools
end

local function cloneSeed(seedName)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("Tool") and v.Name == seedName then
            return v:Clone()
        end
    end
end

local function bypassDetection()
    for _, con in pairs(getconnections(LocalPlayer.Character.DescendantAdded)) do
        con:Disable()
    end
end

local function enterRestrictedZones()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide and v.Name:lower():match("barrier") then
            v.CanCollide = false
            v.Transparency = 0.7
        end
    end
end

local function spawnSeed(seedName)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local seed = cloneSeed(seedName)

    if not seed then
        warn("Seed not found:", seedName)
        return
    end

    if stealthMode then
        bypassDetection()
    end

    seed.Parent = backpack
    task.wait(0.5)
    LocalPlayer.Character.Humanoid:EquipTool(seed)
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SeedSpawnerUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0, 10, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

local DropDown = Instance.new("TextButton", Frame)
DropDown.Size = UDim2.new(1, 0, 0, 30)
DropDown.Text = "Choose a Seed"
DropDown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DropDown.TextColor3 = Color3.fromRGB(255, 255, 255)

local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(1, 0, 1, -30)
Scroll.Position = UDim2.new(0, 0, 0, 30)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Dynamic buttons for seeds
local yOffset = 0
for _, seedName in pairs(findAllSeedTools()) do
    local button = Instance.new("TextButton", Scroll)
    button.Size = UDim2.new(1, -6, 0, 25)
    button.Position = UDim2.new(0, 3, 0, yOffset)
    button.Text = seedName
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.MouseButton1Click:Connect(function()
        spawnSeed(seedName)
    end)
    yOffset = yOffset + 28
end
Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)

-- Barrier bypass (optional)
if bypassProtectedBarriers then
    enterRestrictedZones()
end

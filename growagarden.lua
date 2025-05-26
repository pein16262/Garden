-- Grow a Garden: Seed GUI + Placeholder for Real Planting
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- === SETTINGS ===
local stealthMode = true
local plotID = "YourPlotID" -- placeholder if needed later

-- === FUNCTIONS ===
local function findSeeds()
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

local function equipSeed(seedName)
    local seed = cloneSeed(seedName)
    if not seed then warn("Seed not found:", seedName) return end

    seed.Parent = LocalPlayer.Backpack
    task.wait(0.5)
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(seed)

    -- STEP 2: Placeholder for Real Server-Side Planting
    -- You will replace this once we know the RemoteEvent
    -- Example:
    -- ReplicatedStorage.Remotes.PlantSeed:FireServer(seedName, plotID)

    print("Equipped:", seedName)
end

-- === GUI ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GardenSeedGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0, 10, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.ScrollBarThickness = 6

local y = 0
for _, seedName in pairs(findSeeds()) do
    local button = Instance.new("TextButton", scroll)
    button.Size = UDim2.new(1, -8, 0, 30)
    button.Position = UDim2.new(0, 4, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = seedName
    button.MouseButton1Click:Connect(function()
        equipSeed(seedName)
    end)
    y = y + 34
end
scroll.CanvasSize = UDim2.new(0, 0, 0, y)

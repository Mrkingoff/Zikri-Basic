-- ZIKRI MENU by DeepSeek Chat
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create the main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZikriMenu"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 40) -- Start folded (only title visible)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -20)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "👾 ZIKRI MENU 👾"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SciFi
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.PaddingLeft = UDim.new(0, 10)
Title.Parent = MainFrame

local FoldButton = Instance.new("TextButton")
FoldButton.Name = "FoldButton"
FoldButton.Size = UDim2.new(0.2, 0, 1, 0)
FoldButton.Position = UDim2.new(0.8, 0, 0, 0)
FoldButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FoldButton.Text = "+"
FoldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FoldButton.Font = Enum.Font.SciFi
FoldButton.TextSize = 20
FoldButton.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, -10, 0, 360)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.Visible = false -- Start hidden
ScrollingFrame.Parent = MainFrame

-- Fold/unfold function
local isUnfolded = false
local function ToggleFold()
    isUnfolded = not isUnfolded
    
    if isUnfolded then
        MainFrame.Size = UDim2.new(0, 300, 0, 400)
        ScrollingFrame.Visible = true
        FoldButton.Text = "-"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 40)
        ScrollingFrame.Visible = false
        FoldButton.Text = "+"
    end
end

FoldButton.MouseButton1Click:Connect(ToggleFold)

-- Button template
local function CreateButton(text, yPosition)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, yPosition)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SciFi
    Button.TextSize = 14
    Button.Parent = ScrollingFrame
    
    return Button
end

-- Create buttons
local AntiKillButton = CreateButton("ANTI KILL PART 😂 ON/OFF", 10)
local RespawnButton = CreateButton("RESPAWN ☄️", 60)
local PermadeathButton = CreateButton("PERMADEATH 👻", 110)
local FloatButton = CreateButton("FLOAT 👾 ON/OFF", 160)
local AntiRagdollButton = CreateButton("ANTIRAGDOLL ON/OFF", 210)
local NoclipButton = CreateButton("NOCLIP ON/OFF", 260)
local SpawnBlockButton = CreateButton("SPAWN BLOCK UNCHORD", 310)

-- Variables for toggle states
local AntiKillEnabled = false
local FloatEnabled = false
local AntiRagdollEnabled = false
local NoclipEnabled = false
local PermadeathEnabled = false

-- Anti Kill Part
local function ToggleAntiKill()
    AntiKillEnabled = not AntiKillEnabled
    AntiKillButton.Text = AntiKillEnabled and "ANTI KILL PART 😂 ON" or "ANTI KILL PART 😂 OFF"
    
    if AntiKillEnabled then
        -- Prevent death from kill parts
        local function onTouched(part)
            if part:IsA("BasePart") and (part.Name:lower():find("kill") or part.Name:lower():find("death")) then
                return
            end
        end
        
        Character:WaitForChild("Humanoid").Touched:Connect(onTouched)
    end
end

AntiKillButton.MouseButton1Click:Connect(ToggleAntiKill)

-- Respawn Button
RespawnButton.MouseButton1Click:Connect(function()
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
    Player:LoadCharacter()
end)

-- Permadeath
local function TogglePermadeath()
    PermadeathEnabled = not PermadeathEnabled
    PermadeathButton.Text = PermadeathEnabled and "PERMADEATH 👻 ON" or "PERMADEATH 👻 OFF"
    
    if PermadeathEnabled then
        -- Force character to keep moving after death
        local humanoid = Character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            for _, v in ipairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Anchored = false
                    v.CanCollide = false
                end
            end
        end)
    end
end

PermadeathButton.MouseButton1Click:Connect(TogglePermadeath)

-- Float
local function ToggleFloat()
    FloatEnabled = not FloatEnabled
    FloatButton.Text = FloatEnabled and "FLOAT 👾 ON" or "FLOAT 👾 OFF"
    
    if FloatEnabled then
        -- Make character walk in air
        local humanoid = Character:WaitForChild("Humanoid")
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        local humanoid = Character:WaitForChild("Humanoid")
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

FloatButton.MouseButton1Click:Connect(ToggleFloat)

-- Anti Ragdoll
local function ToggleAntiRagdoll()
    AntiRagdollEnabled = not AntiRagdollEnabled
    AntiRagdollButton.Text = AntiRagdollEnabled and "ANTIRAGDOLL ON" or "ANTIRAGDOLL OFF"
    
    if AntiRagdollEnabled then
        -- Prevent ragdoll
        local humanoid = Character:WaitForChild("Humanoid")
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    else
        local humanoid = Character:WaitForChild("Humanoid")
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end
end

AntiRagdollButton.MouseButton1Click:Connect(ToggleAntiRagdoll)

-- Noclip
local noclipConnection
local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    NoclipButton.Text = NoclipEnabled and "NOCLIP ON" or "NOCLIP OFF"
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if NoclipEnabled then
        -- Noclip functionality
        noclipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Disable noclip
        if Character then
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

NoclipButton.MouseButton1Click:Connect(ToggleNoclip)

-- Spawn Block
SpawnBlockButton.MouseButton1Click:Connect(function()
    -- Spawn unanchored blocks around the map
    for i = 1, 5 do
        local block = Instance.new("Part")
        block.Size = Vector3.new(4, 1, 4)
        block.Position = Character:WaitForChild("HumanoidRootPart").Position + 
                         Vector3.new(math.random(-10, 10), -3, math.random(-10, 10))
        block.Anchored = false
        block.CanCollide = true
        block.BrickColor = BrickColor.random()
        block.Parent = workspace
    end
end)

-- Character handling
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    -- Reapply any enabled features to new character
    if FloatEnabled then
        local humanoid = Character:WaitForChild("Humanoid")
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    end
    if NoclipEnabled then
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        noclipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

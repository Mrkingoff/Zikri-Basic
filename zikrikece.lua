-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZikriMenu"
ScreenGui.Parent = player.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Logo/Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "☄️😎 ZIKRI MENU 😎☄️"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Scrolling Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
ScrollFrame.Parent = MainFrame

-- UIListLayout for buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Make the GUI draggable
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    
    -- Keep the GUI within screen bounds
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize
    local position = MainFrame.AbsolutePosition
    
    if position.X < 0 then
        MainFrame.Position = UDim2.new(0, 0, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    elseif position.X + frameSize.X > viewportSize.X then
        MainFrame.Position = UDim2.new(0, viewportSize.X - frameSize.X, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    end
    
    if position.Y < 0 then
        MainFrame.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0, 0)
    elseif position.Y + frameSize.Y > viewportSize.Y then
        MainFrame.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0, viewportSize.Y - frameSize.Y)
    end
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Button creation function
local function CreateButton(text)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.AutoButtonColor = true
    button.Parent = ScrollFrame
    
    return button
end

-- Variables for features
local antiKillEnabled = false
local floatEnabled = false
local noClipEnabled = false
local antiRagdollEnabled = false
local permadeathEnabled = false

-- Anti-Kill Part Button
local antiKillButton = CreateButton("ANTI KILL PART 😂 OFF")
antiKillButton.MouseButton1Click:Connect(function()
    antiKillEnabled = not antiKillEnabled
    
    if antiKillEnabled then
        antiKillButton.Text = "ANTI KILL PART 😂 ON"
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").Touched:Connect(function(part)
                if part:IsA("BasePart") and part.Name:lower():find("kill") then
                    char:MoveTo(char:GetPivot().Position + Vector3.new(0, 5, 0))
                end
            end)
        end)
    else
        antiKillButton.Text = "ANTI KILL PART 😂 OFF"
    end
end)

-- Respawn Button
local respawnButton = CreateButton("RESPAWN ☄️")
respawnButton.MouseButton1Click:Connect(function()
    local currentPosition = character:GetPivot().Position
    player:LoadCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    character:WaitForChild("Humanoid").RootPart.CFrame = CFrame.new(currentPosition)
end)

-- Permadeath Button
local permadeathButton = CreateButton("PERMADEATH 👻 OFF")
permadeathButton.MouseButton1Click:Connect(function()
    permadeathEnabled = not permadeathEnabled
    
    if permadeathEnabled then
        permadeathButton.Text = "PERMADEATH 👻 ON"
        player.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                -- Simulate walking by moving limbs
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Velocity = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
                        bodyVelocity.MaxForce = Vector3.new(1000, 1000, 1000)
                        bodyVelocity.Parent = part
                    end
                end
            end)
        end)
    else
        permadeathButton.Text = "PERMADEATH 👻 OFF"
    end
end)

-- Float Button
local floatButton = CreateButton("FLOAT 👾 OFF")
floatButton.MouseButton1Click:Connect(function()
    floatEnabled = not floatEnabled
    
    if floatEnabled then
        floatButton.Text = "FLOAT 👾 ON"
        
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 10000, 0)
        bodyVelocity.Parent = rootPart
        
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        RunService.Stepped:Connect(function()
            if not floatEnabled then return end
            local ray = Ray.new(rootPart.Position, Vector3.new(0, -5, 0))
            local part = workspace:FindPartOnRay(ray, character)
            
            if not part then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            else
                bodyVelocity.Velocity = Vector3.new(0, 5, 0)
            end
        end)
    else
        floatButton.Text = "FLOAT 👾 OFF"
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local bodyVelocity = rootPart:FindFirstChildWhichIsA("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
end)

-- Anti-Ragdoll Button
local antiRagdollButton = CreateButton("ANTIRAGDOLL OFF")
antiRagdollButton.MouseButton1Click:Connect(function()
    antiRagdollEnabled = not antiRagdollEnabled
    
    if antiRagdollEnabled then
        antiRagdollButton.Text = "ANTIRAGDOLL ON"
        player.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
    else
        antiRagdollButton.Text = "ANTIRAGDOLL OFF"
        player.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end)
    end
end)

-- NoClip Button
local noClipButton = CreateButton("NOCLIP OFF")
noClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    
    if noClipEnabled then
        noClipButton.Text = "NOCLIP ON"
        
        local function noclip()
            if noClipEnabled and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
        
        RunService.Stepped:Connect(noclip)
    else
        noClipButton.Text = "NOCLIP OFF"
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Spawn Unanchored Blocks Button
local spawnBlocksButton = CreateButton("SPAWN BLOCK UNCHORD")
spawnBlocksButton.MouseButton1Click:Connect(function()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local position = rootPart.Position + rootPart.CFrame.LookVector * 5
    
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 1, 4)
    block.Position = position
    block.Anchored = false
    block.CanCollide = true
    block.BrickColor = BrickColor.new("Bright blue")
    block.Parent = workspace
    
    -- Make sure it doesn't stick to other parts
    block.Touched:Connect(function(otherPart)
        if otherPart ~= rootPart and not otherPart:IsDescendantOf(character) then
            block:Destroy()
        end
    end)
end)

-- Handle character respawns
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    
    -- Re-enable features if they were on
    if floatEnabled then
        floatButton.Text = "FLOAT 👾 ON"
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 10000, 0)
        bodyVelocity.Parent = rootPart
    end
    
    if noClipEnabled then
        noClipButton.Text = "NOCLIP ON"
        RunService.Stepped:Connect(function()
            if noClipEnabled and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
    
    if antiRagdollEnabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end
end)
-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZikriMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Logo Button (Initial small logo)
local LogoButton = Instance.new("ImageButton")
LogoButton.Name = "LogoButton"
LogoButton.Size = UDim2.new(0, 100, 0, 100)
LogoButton.Position = UDim2.new(0.5, -50, 0.5, -50)
LogoButton.AnchorPoint = Vector2.new(0.5, 0.5)
LogoButton.BackgroundTransparency = 1
LogoButton.Image = "rbxassetid://123456789" -- Replace with your logo image ID
LogoButton.Parent = ScreenGui

-- Main Frame (Hidden initially)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 40)
MainFrame.Position = UDim2.new(0.5, -150, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "ZIKRI MENU ☄️😎"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- UIListLayout for buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ContentFrame

-- Make the Logo draggable
local logoDragging
local logoDragInput
local logoDragStart
local logoStartPos

local function updateLogoPosition(input)
    local delta = input.Position - logoDragStart
    LogoButton.Position = UDim2.new(logoStartPos.X.Scale, logoStartPos.X.Offset + delta.X, logoStartPos.Y.Scale, logoStartPos.Y.Offset + delta.Y)
    
    -- Keep the logo within screen bounds
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local logoSize = LogoButton.AbsoluteSize
    local position = LogoButton.AbsolutePosition
    
    if position.X < 0 then
        LogoButton.Position = UDim2.new(0, 0, LogoButton.Position.Y.Scale, LogoButton.Position.Y.Offset)
    elseif position.X + logoSize.X > viewportSize.X then
        LogoButton.Position = UDim2.new(0, viewportSize.X - logoSize.X, LogoButton.Position.Y.Scale, LogoButton.Position.Y.Offset)
    end
    
    if position.Y < 0 then
        LogoButton.Position = UDim2.new(LogoButton.Position.X.Scale, LogoButton.Position.X.Offset, 0, 0)
    elseif position.Y + logoSize.Y > viewportSize.Y then
        LogoButton.Position = UDim2.new(LogoButton.Position.X.Scale, LogoButton.Position.X.Offset, 0, viewportSize.Y - logoSize.Y)
    end
end

LogoButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        logoDragging = true
        logoDragStart = input.Position
        logoStartPos = LogoButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                logoDragging = false
            end
        end)
    end
end)

LogoButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        logoDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == logoDragInput and logoDragging then
        updateLogoPosition(input)
    end
end)

-- Logo click to show/hide menu
LogoButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Menu toggle functionality
local isExpanded = false
local targetHeight = 0

RunService.Heartbeat:Connect(function()
    local currentHeight = ContentFrame.Size.Y.Offset
    local newHeight = currentHeight + (targetHeight - currentHeight) * 0.2
    ContentFrame.Size = UDim2.new(1, 0, 0, newHeight)
    
    if math.abs(newHeight - targetHeight) < 1 then
        ContentFrame.Size = UDim2.new(1, 0, 0, targetHeight)
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Feature variables
local antiKillEnabled = false
local floatEnabled = false
local noClipEnabled = false
local antiRagdollEnabled = false
local permadeathEnabled = false

-- Create buttons for each feature
local function CreateButton(text)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.SourceSans
    button.Parent = ContentFrame
    
    return button
end

-- Anti-Kill Part Button
local antiKillButton = CreateButton("ANTI KILL PART 😂 OFF")
antiKillButton.MouseButton1Click:Connect(function()
    antiKillEnabled = not antiKillEnabled
    antiKillButton.Text = "ANTI KILL PART 😂 " .. (antiKillEnabled and "ON" or "OFF")
    
    if antiKillEnabled then
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").Touched:Connect(function(part)
                if part:IsA("BasePart") and part.Name:lower():find("kill") then
                    char:MoveTo(char:GetPivot().Position + Vector3.new(0, 5, 0))
                end
            end)
        end)
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
    permadeathButton.Text = "PERMADEATH 👻 " .. (permadeathEnabled and "ON" or "OFF")
    
    if permadeathEnabled then
        player.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
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
    end
end)

-- Float Button
local floatButton = CreateButton("FLOAT 👾 OFF")
floatButton.MouseButton1Click:Connect(function()
    floatEnabled = not floatEnabled
    floatButton.Text = "FLOAT 👾 " .. (floatEnabled and "ON" or "OFF")
    
    if floatEnabled then
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
    antiRagdollButton.Text = "ANTIRAGDOLL " .. (antiRagdollEnabled and "ON" or "OFF")
    
    if antiRagdollEnabled then
        player.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
    else
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
    noClipButton.Text = "NOCLIP " .. (noClipEnabled and "ON" or "OFF")
    
    if noClipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
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
    
    block.Touched:Connect(function(otherPart)
        if otherPart ~= rootPart and not otherPart:IsDescendantOf(character) then
            block:Destroy()
        end
    end)
end)

-- Continuous Noclip update
RunService.Stepped:Connect(function()
    if noClipEnabled and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Update content frame height when buttons are added
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    targetHeight = math.min(UIListLayout.AbsoluteContentSize.Y, 300)
end)

-- Make sure menu persists after death
player.CharacterAdded:Connect(function()
    if not ScreenGui.Parent then
        ScreenGui.Parent = player:WaitForChild("PlayerGui")
    end
end)

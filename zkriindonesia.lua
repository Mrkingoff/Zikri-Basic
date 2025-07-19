local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkullMenuGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Buat main frame untuk logo
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 50, 0, 50)
MainFrame.Position = UDim2.new(0.5, -25, 0.1, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Buat TextButton untuk logo ☠️
local LogoButton = Instance.new("TextButton")
LogoButton.Name = "LogoButton"
LogoButton.Size = UDim2.new(1, 0, 1, 0)
LogoButton.Text = "☠️"
LogoButton.TextSize = 40
LogoButton.BackgroundTransparency = 1
LogoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoButton.AutoButtonColor = false
LogoButton.Parent = MainFrame

-- Buat Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 200, 0, 500)
MenuFrame.Position = UDim2.new(0, 50, 0, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false
MenuFrame.Parent = MainFrame

-- Buat judul menu
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SAFE MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MenuFrame

-- Variabel untuk status fitur
local AntiKillEnabled = false
local NoClipEnabled = false
local SpeedWalkEnabled = false
local SpawnPointEnabled = false
local SpawnOrbitEnabled = false
local AntiNpcDamageEnabled = false
local AntiIceEnabled = false
local WalkFlingEnabled = false
local AntiSitEnabled = false
local SpawnLocation = nil
local Noclipping = false
local OriginalWalkSpeed = 16
local OrbitParts = {}
local OrbitConnection = nil
local NpcDamageConnections = {}
local IceConnections = {}
local FlingPart = nil

-- Fungsi untuk membuat tombol
local function CreateButton(name, text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = position
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    return button
end

-- Buat tombol-tombol utama
local AntiKillButton = CreateButton("AntiKill", "Anti Kill Part: OFF", UDim2.new(0.05, 0, 0.05, 0), MenuFrame)
local NoClipButton = CreateButton("NoClip", "NoClip: OFF", UDim2.new(0.05, 0, 0.12, 0), MenuFrame)
local SpeedWalkButton = CreateButton("SpeedWalk", "Speed Walk: OFF", UDim2.new(0.05, 0, 0.19, 0), MenuFrame)
local SpawnPointButton = CreateButton("SpawnPoint", "Spawn Point: OFF", UDim2.new(0.05, 0, 0.26, 0), MenuFrame)
local GetToolsButton = CreateButton("GetTools", "Get Tools", UDim2.new(0.05, 0, 0.33, 0), MenuFrame)
local AntiIceButton = CreateButton("AntiIce", "Anti Ice: OFF", UDim2.new(0.05, 0, 0.40, 0), MenuFrame)
local WalkFlingButton = CreateButton("WalkFling", "Walk Fling: OFF", UDim2.new(0.05, 0, 0.47, 0), MenuFrame)
local AntiSitButton = CreateButton("AntiSit", "Anti Sit: OFF", UDim2.new(0.05, 0, 0.54, 0), MenuFrame)
local OrbitButton = CreateButton("Orbit", "Orbit Parts: OFF", UDim2.new(0.05, 0, 0.61, 0), MenuFrame)
local AntiNpcDamageButton = CreateButton("AntiNpcDamage", "Anti NPC Damage: OFF", UDim2.new(0.05, 0, 0.68, 0), MenuFrame)

-- ==============================================
-- FITUR ANTI KILL PART
-- ==============================================
local function ToggleAntiKill()
    AntiKillEnabled = not AntiKillEnabled
    AntiKillButton.Text = "Anti Kill Part: " .. (AntiKillEnabled and "ON" or "OFF")
    
    local character = Player.Character or Player.CharacterAdded:Wait()
    
    if AntiKillEnabled then
        local forceField = Instance.new("ForceField")
        forceField.Name = "AntiKillFF"
        forceField.Parent = character
        
        character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if character.Humanoid.Health < character.Humanoid.MaxHealth then
                character.Humanoid.Health = character.Humanoid.MaxHealth
            end
        end)
    else
        local forceField = character:FindFirstChild("AntiKillFF")
        if forceField then
            forceField:Destroy()
        end
    end
end

-- ==============================================
-- FITUR NOCLIP
-- ==============================================
local function NoclipLoop()
    if Noclipping and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

local function ToggleNoClip()
    NoClipEnabled = not NoClipEnabled
    Noclipping = NoClipEnabled
    NoClipButton.Text = "NoClip: " .. (NoClipEnabled and "ON" or "OFF")
end

-- ==============================================
-- FITUR SPEED WALK
-- ==============================================
local function ToggleSpeedWalk()
    SpeedWalkEnabled = not SpeedWalkEnabled
    SpeedWalkButton.Text = "Speed Walk: " .. (SpeedWalkEnabled and "ON" or "OFF")
    
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = SpeedWalkEnabled and 50 or OriginalWalkSpeed
        end
    end
end

-- ==============================================
-- FITUR SPAWN POINT
-- ==============================================
local function ToggleSpawnPoint()
    SpawnPointEnabled = not SpawnPointEnabled
    SpawnPointButton.Text = "Spawn Point: " .. (SpawnPointEnabled and "ON" or "OFF")
    
    if SpawnPointEnabled then
        local character = Player.Character
        if character then
            SpawnLocation = character:WaitForChild("HumanoidRootPart").CFrame
        end
    else
        SpawnLocation = nil
    end
end

-- ==============================================
-- FITUR GET TOOLS
-- ==============================================
local function GetTools()
    local backpack = Player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(game:GetService("Workspace"):GetChildren()) do
            if tool:IsA("Tool") then
                tool:Clone().Parent = backpack
            end
        end
    end
end

-- ==============================================
-- FITUR ANTI ICE
-- ==============================================
local function ToggleAntiIce()
    AntiIceEnabled = not AntiIceEnabled
    AntiIceButton.Text = "Anti Ice: " .. (AntiIceEnabled and "ON" or "OFF")
    
    local character = Player.Character
    if not character then return end
    
    if AntiIceEnabled then
        -- Cegah efek ice
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part:FindFirstChild("Ice") then
                part.Ice:Destroy()
            end
        end
        
        -- Monitor untuk ice baru
        local iceConnection
        iceConnection = character.DescendantAdded:Connect(function(descendant)
            if AntiIceEnabled and descendant.Name == "Ice" then
                descendant:Destroy()
            end
        end)
        table.insert(IceConnections, iceConnection)
    else
        -- Hapus koneksi anti ice
        for _, connection in ipairs(IceConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        IceConnections = {}
    end
end

-- ==============================================
-- FITUR WALK FLING
-- ==============================================
local function ToggleWalkFling()
    WalkFlingEnabled = not WalkFlingEnabled
    WalkFlingButton.Text = "Walk Fling: " .. (WalkFlingEnabled and "ON" or "OFF")
    
    if WalkFlingEnabled then
        -- Buat part untuk deteksi tabrakan
        FlingPart = Instance.new("Part")
        FlingPart.Name = "FlingPart"
        FlingPart.Size = Vector3.new(5, 5, 5)
        FlingPart.Transparency = 1
        FlingPart.CanCollide = false
        FlingPart.Anchored = false
        FlingPart.Parent = workspace
        
        -- Buat weld ke karakter
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = Player.Character.HumanoidRootPart
        weld.Part1 = FlingPart
        weld.Parent = FlingPart
        
        -- Deteksi tabrakan
        FlingPart.Touched:Connect(function(hit)
            if WalkFlingEnabled and hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= Player.Character then
                local humanoid = hit.Parent.Humanoid
                local root = hit.Parent:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Lempar pemain yang tersentuh
                    root.Velocity = Vector3.new(math.random(-500,500), 500, math.random(-500,500))
                end
            end
        end)
    else
        -- Hapus part fling jika ada
        if FlingPart then
            FlingPart:Destroy()
            FlingPart = nil
        end
    end
end

-- ==============================================
-- FITUR ANTI SIT
-- ==============================================
local function ToggleAntiSit()
    AntiSitEnabled = not AntiSitEnabled
    AntiSitButton.Text = "Anti Sit: " .. (AntiSitEnabled and "ON" or "OFF")
    
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if AntiSitEnabled then
        -- Nonaktifkan kemampuan untuk duduk
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid.Sit = false
        
        -- Jika sedang duduk, bangunkan
        if humanoid.Sit then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    else
        -- Aktifkan kembali kemampuan untuk duduk
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    end
end

-- ==============================================
-- FITUR ORBIT PARTS
-- ==============================================
local function ToggleOrbitParts()
    SpawnOrbitEnabled = not SpawnOrbitEnabled
    OrbitButton.Text = "Orbit Parts: " .. (SpawnOrbitEnabled and "ON" or "OFF")
    
    local character = Player.Character
    if not character then return end
    
    if SpawnOrbitEnabled then
        for _, part in ipairs(OrbitParts) do
            if part then part:Destroy() end
        end
        OrbitParts = {}
        
        for i = 1, 8 do
            local part = Instance.new("Part")
            part.Name = "OrbitPart_"..i
            part.Size = Vector3.new(2, 2, 2)
            part.Shape = Enum.PartType.Ball
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromHSV(i/8, 1, 1)
            part.Anchored = false
            part.CanCollide = false
            part.Massless = true
            
            local angle = math.rad(i * 45)
            local radius = 5
            part.Position = character.HumanoidRootPart.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            
            part.Parent = workspace
            table.insert(OrbitParts, part)
        end
        
        if OrbitConnection then OrbitConnection:Disconnect() end
        local angle = 0
        OrbitConnection = RunService.Heartbeat:Connect(function(dt)
            if not SpawnOrbitEnabled or not character or not character:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            angle = angle + dt * 2
            if angle > 360 then angle = 0 end
            
            local rootPos = character.HumanoidRootPart.Position
            local radius = 5
            
            for i, part in ipairs(OrbitParts) do
                if part then
                    local partAngle = angle + math.rad(i * 45)
                    part.Position = rootPos + Vector3.new(math.cos(partAngle) * radius, 0, math.sin(partAngle) * radius)
                end
            end
        end)
    else
        if OrbitConnection then
            OrbitConnection:Disconnect()
            OrbitConnection = nil
        end
        
        for _, part in ipairs(OrbitParts) do
            if part then
                part.Anchored = true
            end
        end
    end
end

-- ==============================================
-- FITUR ANTI NPC DAMAGE
-- ==============================================
local function ToggleAntiNpcDamage()
    AntiNpcDamageEnabled = not AntiNpcDamageEnabled
    AntiNpcDamageButton.Text = "Anti NPC Damage: " .. (AntiNpcDamageEnabled and "ON" or "OFF")
    
    local character = Player.Character
    if not character then return end
    
    if AntiNpcDamageEnabled then
        for _, npc in ipairs(workspace:GetDescendants()) do
            if npc:FindFirstChild("Humanoid") and npc ~= character then
                local connection
                connection = npc.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if character.Humanoid.Health < character.Humanoid.MaxHealth then
                        character.Humanoid.Health = character.Humanoid.MaxHealth
                    end
                end)
                table.insert(NpcDamageConnections, connection)
            end
        end
        
        local npcAddedConnection
        npcAddedConnection = workspace.DescendantAdded:Connect(function(npc)
            if AntiNpcDamageEnabled and npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc ~= character then
                local connection
                connection = npc.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if character.Humanoid.Health < character.Humanoid.MaxHealth then
                        character.Humanoid.Health = character.Humanoid.MaxHealth
                    end
                end)
                table.insert(NpcDamageConnections, connection)
            end
        end)
        table.insert(NpcDamageConnections, npcAddedConnection)
    else
        for _, connection in ipairs(NpcDamageConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        NpcDamageConnections = {}
    end
end

-- ==============================================
-- EVENT HANDLERS
-- ==============================================
Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")
    
    if SpawnPointEnabled and SpawnLocation then
        wait(0.5)
        character.HumanoidRootPart.CFrame = SpawnLocation
    end
    
    if AntiKillEnabled then
        local forceField = Instance.new("ForceField")
        forceField.Name = "AntiKillFF"
        forceField.Parent = character
        
        character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if character.Humanoid.Health < character.Humanoid.MaxHealth then
                character.Humanoid.Health = character.Humanoid.MaxHealth
            end
        end)
    end
    
    if NoClipEnabled then
        Noclipping = true
        RunService.Stepped:Connect(NoclipLoop)
    end
    
    if SpeedWalkEnabled then
        character.Humanoid.WalkSpeed = 50
    end
    
    if SpawnOrbitEnabled then
        ToggleOrbitParts()
        ToggleOrbitParts()
    end
    
    if AntiNpcDamageEnabled then
        ToggleAntiNpcDamage()
        ToggleAntiNpcDamage()
    end
    
    if AntiIceEnabled then
        ToggleAntiIce()
        ToggleAntiIce()
    end
    
    if WalkFlingEnabled then
        ToggleWalkFling()
        ToggleWalkFling()
    end
    
    if AntiSitEnabled then
        ToggleAntiSit()
        ToggleAntiSit()
    end
end)

-- Hubungkan tombol-tombol
AntiKillButton.MouseButton1Click:Connect(ToggleAntiKill)
NoClipButton.MouseButton1Click:Connect(ToggleNoClip)
SpeedWalkButton.MouseButton1Click:Connect(ToggleSpeedWalk)
SpawnPointButton.MouseButton1Click:Connect(ToggleSpawnPoint)
GetToolsButton.MouseButton1Click:Connect(GetTools)
AntiIceButton.MouseButton1Click:Connect(ToggleAntiIce)
WalkFlingButton.MouseButton1Click:Connect(ToggleWalkFling)
AntiSitButton.MouseButton1Click:Connect(ToggleAntiSit)
OrbitButton.MouseButton1Click:Connect(ToggleOrbitParts)
AntiNpcDamageButton.MouseButton1Click:Connect(ToggleAntiNpcDamage)

-- Aktifkan loop noclip jika diperlukan
RunService.Stepped:Connect(function()
    if NoClipEnabled and Player.Character then
        NoclipLoop()
    end
end)

-- Toggle menu saat logo diklik
LogoButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
end)

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
MenuFrame.Size = UDim2.new(0, 200, 0, 450)
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
local NpcControlEnabled = false
local SpawnLocation = nil
local Noclipping = false
local OriginalWalkSpeed = 16
local OrbitParts = {}
local OrbitConnection = nil
local NpcDamageConnections = {}
local ControlledNpc = nil
local OriginalCameraSubject = nil

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
local AntiKillButton = CreateButton("AntiKill", "Anti Kill Part: OFF", UDim2.new(0.05, 0, 0.08, 0), MenuFrame)
local NoClipButton = CreateButton("NoClip", "NoClip: OFF", UDim2.new(0.05, 0, 0.16, 0), MenuFrame)
local SpeedWalkButton = CreateButton("SpeedWalk", "Speed Walk: OFF", UDim2.new(0.05, 0, 0.24, 0), MenuFrame)
local SpawnPointButton = CreateButton("SpawnPoint", "Spawn Point: OFF", UDim2.new(0.05, 0, 0.32, 0), MenuFrame)
local GetToolsButton = CreateButton("GetTools", "Get Tools", UDim2.new(0.05, 0, 0.40, 0), MenuFrame)
local NpcControlButton = CreateButton("NpcControl", "NPC Control: OFF", UDim2.new(0.05, 0, 0.48, 0), MenuFrame)
local OrbitButton = CreateButton("Orbit", "Orbit Parts: OFF", UDim2.new(0.05, 0, 0.56, 0), MenuFrame)
local AntiNpcDamageButton = CreateButton("AntiNpcDamage", "Anti NPC Damage: OFF", UDim2.new(0.05, 0, 0.64, 0), MenuFrame)

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
-- FITUR NPC CONTROL
-- ==============================================
local function ToggleNpcControl()
    NpcControlEnabled = not NpcControlEnabled
    NpcControlButton.Text = "NPC Control: " .. (NpcControlEnabled and "ON" or "OFF")
    
    if NpcControlEnabled then
        -- Mode aktif - siap menerima klik NPC
        Mouse.Button1Down:Connect(function()
            local target = Mouse.Target
            if target and target.Parent:FindFirstChild("Humanoid") and target.Parent ~= Player.Character then
                -- Kontrol NPC yang diklik
                ControlledNpc = target.Parent
                OriginalCameraSubject = workspace.CurrentCamera.CameraSubject
                
                -- Jadikan NPC sebagai karakter yang dikontrol
                workspace.CurrentCamera.CameraSubject = ControlledNpc.Humanoid
                
                -- Beri notifikasi
                game.StarterGui:SetCore("SendNotification", {
                    Title = "NPC Controlled",
                    Text = "Now controlling: "..ControlledNpc.Name,
                    Duration = 3,
                })
            end
        end)
    else
        -- Kembali ke karakter utama
        if ControlledNpc then
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
            end
            ControlledNpc = nil
            
            game.StarterGui:SetCore("SendNotification", {
                Title = "NPC Control",
                Text = "Returned to player control",
                Duration = 3,
            })
        end
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
-- FITUR ANTI DAMAGE NPC
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
    
    if NpcControlEnabled and ControlledNpc then
        workspace.CurrentCamera.CameraSubject = character.Humanoid
        ControlledNpc = nil
    end
end)

-- Hubungkan tombol-tombol
AntiKillButton.MouseButton1Click:Connect(ToggleAntiKill)
NoClipButton.MouseButton1Click:Connect(ToggleNoClip)
SpeedWalkButton.MouseButton1Click:Connect(ToggleSpeedWalk)
SpawnPointButton.MouseButton1Click:Connect(ToggleSpawnPoint)
GetToolsButton.MouseButton1Click:Connect(GetTools)
NpcControlButton.MouseButton1Click:Connect(ToggleNpcControl)
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
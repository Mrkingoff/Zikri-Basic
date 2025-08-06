
-- Variabel global
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local Mouse = LocalPlayer:GetMouse()

-- Variabel untuk menyimpan status toggle
local AntiKillEnabled = false
local NoClipEnabled = false
local SpeedWalkEnabled = false
local SpawnPointEnabled = false
local SpawnOrbitEnabled = false
local AntiNpcDamageEnabled = false
local WalkFlingEnabled = false
local AntiSitEnabled = false
local PermaDeathEnabled = false
local MenuOpen = false
local SpawnLocation = nil
local Noclipping = false
local OriginalWalkSpeed = 16
local OrbitParts = {}
local OrbitConnection = nil
local NpcDamageConnections = {}
local FlingPart = nil

-- Fungsi untuk membuat GUI
local function CreateGUI()
    -- Hapus GUI lama jika ada
    if PlayerGui:FindFirstChild("SkullMenuGUI") then
        PlayerGui.SkullMenuGUI:Destroy()
        print("Old SkullMenuGUI destroyed")
    end

    -- Membuat ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SkullMenuGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    print("ScreenGui created and parented to PlayerGui")

    -- Membuat frame utama untuk logo
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 50, 0, 50)
    MainFrame.Position = UDim2.new(0.5, -25, 0.1, 0)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Active = true
    MainFrame.Selectable = true
    MainFrame.ZIndex = 10
    MainFrame.Parent = ScreenGui
    print("MainFrame created")

    -- Membuat tombol logo
    local LogoButton = Instance.new("TextButton")
    LogoButton.Name = "LogoButton"
    LogoButton.Size = UDim2.new(1, 0, 1, 0)
    LogoButton.Text = "☠️"
    LogoButton.TextSize = 40
    LogoButton.BackgroundTransparency = 1
    LogoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoButton.AutoButtonColor = false
    LogoButton.ZIndex = 10
    LogoButton.Parent = MainFrame
    print("LogoButton created")

    -- Membuat frame menu
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Name = "MenuFrame"
    MenuFrame.Size = UDim2.new(0, 200, 0, 400)
    MenuFrame.Position = UDim2.new(1, 10, 0, 0)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MenuFrame.BorderSizePixel = 0
    MenuFrame.Visible = false
    MenuFrame.ZIndex = 5
    MenuFrame.Parent = MainFrame
    print("MenuFrame created")

    -- Membuat judul menu
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "ZIKRI MENU"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.ZIndex = 6
    Title.Parent = MenuFrame

    -- Membuat ScrollingFrame untuk tombol
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 5
    ScrollFrame.ZIndex = 6
    ScrollFrame.Parent = MenuFrame

    -- Membuat UIListLayout untuk ScrollingFrame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ScrollFrame

    -- Fungsi untuk membuat tombol
    local function CreateButton(name, text, callback)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0.9, 0, 0, 35)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.ZIndex = 7
        button.Parent = ScrollFrame
        button.MouseButton1Click:Connect(function()
            print("Button clicked: " .. name)
            callback()
        end)
        button.Activated:Connect(function()
            print("Button activated: " .. name)
            callback()
        end)
        return button
    end

    -- Fungsi untuk membuat tombol toggle
    local function CreateToggleButton(name, toggleVar, text, callback)
        local button = CreateButton(name, text .. (toggleVar and " ON" or " OFF"), function()
            toggleVar = not toggleVar
            button.Text = text .. (toggleVar and " ON" or " OFF")
            print("Toggle " .. name .. ": " .. tostring(toggleVar))
            callback(toggleVar)
        end)
        return button
    end

    -- Tombol Respawn
    CreateButton("Respawn", "Respawn", function()
        local Character = LocalPlayer.Character
        if Character then
            Character:BreakJoints()
            wait()
            LocalPlayer:LoadCharacter()
            print("Respawn triggered")
        end
    end)

    -- Tombol Anti Kill Part
    CreateToggleButton("AntiKill", AntiKillEnabled, "Anti Kill Part", function(state)
        AntiKillEnabled = state
        local character = LocalPlayer.Character
        if not character then return end
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
    end)

    -- Tombol NoClip
    CreateToggleButton("NoClip", NoClipEnabled, "NoClip", function(state)
        NoClipEnabled = state
        Noclipping = NoClipEnabled
        print("NoClip set to: " .. tostring(state))
    end)

    -- Tombol Speed Walk
    CreateToggleButton("SpeedWalk", SpeedWalkEnabled, "Speed Walk", function(state)
        SpeedWalkEnabled = state
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = SpeedWalkEnabled and 50 or OriginalWalkSpeed
                print("SpeedWalk set to: " .. tostring(state))
            end
        end
    end)

    -- Tombol Spawn Point
    CreateToggleButton("SpawnPoint", SpawnPointEnabled, "Spawn Point", function(state)
        SpawnPointEnabled = state
        if SpawnPointEnabled then
            local character = LocalPlayer.Character
            if character then
                SpawnLocation = character:WaitForChild("HumanoidRootPart").CFrame
                print("Spawn point set")
            end
        else
            SpawnLocation = nil
            print("Spawn point disabled")
        end
    end)

    -- Tombol Get Tools
    CreateButton("GetTools", "Get Tools", function()
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, tool in ipairs(game:GetService("Workspace"):GetChildren()) do
                if tool:IsA("Tool") then
                    tool:Clone().Parent = backpack
                    print("Tool cloned: " .. tool.Name)
                end
            end
        end
    end)

    -- Tombol Walk Fling
    CreateToggleButton("WalkFling", WalkFlingEnabled, "Walk Fling", function(state)
        WalkFlingEnabled = state
        if WalkFlingEnabled then
            if FlingPart then FlingPart:Destroy() end
            FlingPart = Instance.new("Part")
            FlingPart.Name = "FlingPart"
            FlingPart.Size = Vector3.new(5, 5, 5)
            FlingPart.Transparency = 1
            FlingPart.CanCollide = false
            FlingPart.Anchored = false
            FlingPart.Parent = workspace
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            weld.Part1 = FlingPart
            weld.Parent = FlingPart
            FlingPart.Touched:Connect(function(hit)
                if WalkFlingEnabled and hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= LocalPlayer.Character then
                    local root = hit.Parent:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Velocity = Vector3.new(math.random(-1000, 1000), 1000, math.random(-1000, 1000))
                        print("Fling triggered on: " .. hit.Parent.Name)
                    end
                end
            end)
        elseif FlingPart then
            FlingPart:Destroy()
            FlingPart = nil
        end
    end)

    -- Tombol Anti Sit
    CreateToggleButton("AntiSit", AntiSitEnabled, "Anti Sit", function(state)
        AntiSitEnabled = state
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if AntiSitEnabled then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            humanoid.Sit = false
            print("AntiSit enabled")
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            print("AntiSit disabled")
        end
    end)

    -- Tombol Orbit Parts
    CreateToggleButton("Orbit", SpawnOrbitEnabled, "Orbit Parts", function(state)
        SpawnOrbitEnabled = state
        local character = LocalPlayer.Character
        if not character then return end
        if SpawnOrbitEnabled then
            for _, part in ipairs(OrbitParts) do
                if part then part:Destroy() end
            end
            OrbitParts = {}
            for i = 1, 8 do
                local part = Instance.new("Part")
                part.Name = "OrbitPart_" .. i
                part.Size = Vector3.new(2, 2, 2)
                part.Shape = Enum.PartType.Ball
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromHSV(i / 8, 1, 1)
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
                local rootPos = character.HumanoidRootPart.Position
                for i, part in ipairs(OrbitParts) do
                    if part then
                        local partAngle = angle + math.rad(i * 45)
                        part.Position = rootPos + Vector3.new(math.cos(partAngle) * 5, 0, math.sin(partAngle) * 5)
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
    end)

    -- Tombol Anti NPC Damage
    CreateToggleButton("AntiNpcDamage", AntiNpcDamageEnabled, "Anti NPC Damage", function(state)
        AntiNpcDamageEnabled = state
        local character = LocalPlayer.Character
        if not character then return end
        if AntiNpcDamageEnabled then
            for _, npc in ipairs(workspace:GetDescendants()) do
                if npc:FindFirstChild("Humanoid") and npc ~= character then
                    local connection = npc.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                        if character.Humanoid.Health < character.Humanoid.MaxHealth then
                            character.Humanoid.Health = character.Humanoid.MaxHealth
                        end
                    end)
                    table.insert(NpcDamageConnections, connection)
                end
            end
        else
            for _, connection in ipairs(NpcDamageConnections) do
                connection:Disconnect()
            end
            NpcDamageConnections = {}
        end
    end)

    -- Tombol PermaDeath
    CreateToggleButton("PermaDeath", PermaDeathEnabled, "PermaDeath", function(state)
        PermaDeathEnabled = state
        print("PermaDeath set to: " .. tostring(state))
    end)

    -- Logika tombol logo untuk membuka/tutup menu
    LogoButton.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        MenuFrame.Visible = MenuOpen
        print("Menu toggled via button click: " .. tostring(MenuOpen))
    end)
    LogoButton.Activated:Connect(function()
        MenuOpen = not MenuOpen
        MenuFrame.Visible = MenuOpen
        print("Menu toggled via button activation: " .. tostring(MenuOpen))
    end)

    -- Input keyboard untuk membuka/tutup menu
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
            MenuOpen = not MenuOpen
            MenuFrame.Visible = MenuOpen
            print("Menu toggled via keyboard: " .. tostring(MenuOpen))
        end
    end)

    -- Logika drag untuk MainFrame
    local dragging = false
    local dragStart = nil
    local startPos = nil

    LogoButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    -- Logika NoClip
    local function NoclipLoop()
        if Noclipping and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
    if NoClipEnabled then
        RunService.Stepped:Connect(NoclipLoop)
    end

    -- Logika AntiKill, AntiSit, PermaDeath, dll.
    RunService.Stepped:Connect(function()
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if Humanoid and HumanoidRootPart then
                if PermaDeathEnabled and Humanoid.Health <= 0 then
                    Humanoid.WalkSpeed = 16
                    Humanoid.JumpPower = 50
                end
            end
        end
    end)

    -- Menyesuaikan ukuran ScrollingFrame
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- Inisialisasi GUI
if PlayerGui then
    CreateGUI()
    print("Script started and GUI initialized")
else
    warn("PlayerGui not found, GUI initialization failed")
end

-- Handler untuk respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")
    if SpawnPointEnabled and SpawnLocation then
        wait(0.5)
        character.HumanoidRootPart.CFrame = SpawnLocation
        print("Respawned at saved spawn point")
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
    end
    if SpeedWalkEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
        end
    end
    if AntiSitEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            humanoid.Sit = false
        end
    end
    if SpawnOrbitEnabled then
        for _, part in ipairs(OrbitParts) do
            if part then part:Destroy() end
        end
        OrbitParts = {}
        for i = 1, 8 do
            local part = Instance.new("Part")
            part.Name = "OrbitPart_" .. i
            part.Size = Vector3.new(2, 2, 2)
            part.Shape = Enum.PartType.Ball
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromHSV(i / 8, 1, 1)
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
            local rootPos = character.HumanoidRootPart.Position
            for i, part in ipairs(OrbitParts) do
                if part then
                    local partAngle = angle + math.rad(i * 45)
                    part.Position = rootPos + Vector3.new(math.cos(partAngle) * 5, 0, math.sin(partAngle) * 5)
                end
            end
        end)
    end
    if AntiNpcDamageEnabled then
        for _, npc in ipairs(workspace:GetDescendants()) do
            if npc:FindFirstChild("Humanoid") and npc ~= character then
                local connection = npc.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if character.Humanoid.Health < character.Humanoid.MaxHealth then
                        character.Humanoid.Health = character.Humanoid.MaxHealth
                    end
                end)
                table.insert(NpcDamageConnections, connection)
            end
        end
    end
    if WalkFlingEnabled then
        if FlingPart then FlingPart:Destroy() end
        FlingPart = Instance.new("Part")
        FlingPart.Name = "FlingPart"
        FlingPart.Size = Vector3.new(5, 5, 5)
        FlingPart.Transparency = 1
        FlingPart.CanCollide = false
        FlingPart.Anchored = false
        FlingPart.Parent = workspace
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = character:FindFirstChild("HumanoidRootPart")
        weld.Part1 = FlingPart
        weld.Parent = FlingPart
        FlingPart.Touched:Connect(function(hit)
            if WalkFlingEnabled and hit.Parent:FindFirstChild("Humanoid") and hit.Parent != character then
                local root = hit.Parent:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(math.random(-1000, 1000), 1000, math.random(-1000, 1000))
                end
            end
        end)
    end
    CreateGUI()
    print("GUI recreated after respawn")
end)
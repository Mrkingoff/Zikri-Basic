-- Script ini ditempatkan di ServerScriptService atau tempat yang sesuai
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Fungsi untuk menyimpan data menu
local function saveMenuData(player, enabledButtons, position)
    local data = {
        enabledButtons = enabledButtons,
        position = position
    }
    player:SetAttribute("MenuData", data)
end

-- Fungsi untuk memuat data menu
local function loadMenuData(player)
    return player:GetAttribute("MenuData") or {
        enabledButtons = {},
        position = UDim2.new(0.5, -150, 0.5, -200)
    }
end

-- Fungsi untuk membuat GUI
local function createGUI(player)
    -- Load data yang tersimpan
    local menuData = loadMenuData(player)
    
    -- Buat ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "PlayerMenu"
    gui.ResetOnSpawn = false -- Agar GUI tetap ada saat respawn
    gui.Parent = player:WaitForChild("PlayerGui")
    
    -- Buat main frame (menu utama)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = menuData.position
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    
    -- Buat title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌀 Player Menu"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.Parent = titleBar
    
    -- Buat container untuk tombol-tombol
    local buttonContainer = Instance.new("ScrollingFrame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -10, 1, -40)
    buttonContainer.Position = UDim2.new(0, 5, 0, 35)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.ScrollBarThickness = 5
    buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 600)
    buttonContainer.Parent = mainFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = buttonContainer
    
    -- Fungsi untuk membuat tombol toggle
    local function createToggleButton(name, defaultState)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = name .. "Frame"
        buttonFrame.Size = UDim2.new(1, 0, 0, 40)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        buttonFrame.BorderSizePixel = 0
        buttonFrame.Parent = buttonContainer
        
        local button = Instance.new("TextButton")
        button.Name = name .. "Button"
        button.Size = UDim2.new(1, -50, 1, 0)
        button.Position = UDim2.new(0, 0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        button.BorderSizePixel = 0
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Parent = buttonFrame
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Name = "ToggleIndicator"
        toggleIndicator.Size = UDim2.new(0, 40, 1, -10)
        toggleIndicator.Position = UDim2.new(1, -45, 0, 5)
        toggleIndicator.BackgroundColor3 = defaultState and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = buttonFrame
        
        local toggleText = Instance.new("TextLabel")
        toggleText.Name = "ToggleText"
        toggleText.Size = UDim2.new(1, 0, 1, 0)
        toggleText.BackgroundTransparency = 1
        toggleText.Text = defaultState and "ON" or "OFF"
        toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleText.Font = Enum.Font.GothamBold
        toggleText.TextSize = 12
        toggleText.Parent = toggleIndicator
        
        return button, toggleIndicator, toggleText
    end
    
    -- Buat tombol-tombol
    -- Anti Kill Part
    local antiKillButton, antiKillIndicator, antiKillText = createToggleButton("Anti Kill Part", menuData.enabledButtons.AntiKill or false)
    
    -- Noclip
    local noclipButton, noclipIndicator, noclipText = createToggleButton("Noclip", menuData.enabledButtons.Noclip or false)
    
    -- Speed Walk
    local speedButton, speedIndicator, speedText = createToggleButton("Speed Walk", menuData.enabledButtons.SpeedWalk or false)
    
    -- Spawn Point
    local spawnButton, spawnIndicator, spawnText = createToggleButton("Spawn Point", menuData.enabledButtons.SpawnPoint or false)
    
    -- Get Tools
    local toolsButton = Instance.new("TextButton")
    toolsButton.Name = "ToolsButton"
    toolsButton.Size = UDim2.new(1, 0, 0, 40)
    toolsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toolsButton.BorderSizePixel = 0
    toolsButton.Text = "Get Tools"
    toolsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toolsButton.Font = Enum.Font.Gotham
    toolsButton.TextSize = 14
    toolsButton.Parent = buttonContainer
    
    -- Fly
    local flyButton, flyIndicator, flyText = createToggleButton("Fly", menuData.enabledButtons.Fly or false)
    
    -- Buat frame untuk pengaturan fly (akan muncul saat fly diaktifkan)
    local flySettingsFrame = Instance.new("Frame")
    flySettingsFrame.Name = "FlySettingsFrame"
    flySettingsFrame.Size = UDim2.new(1, -20, 0, 80)
    flySettingsFrame.Position = UDim2.new(0, 10, 0, 0)
    flySettingsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    flySettingsFrame.BorderSizePixel = 0
    flySettingsFrame.Visible = false
    flySettingsFrame.Parent = mainFrame
    
    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Name = "FlySpeedLabel"
    flySpeedLabel.Size = UDim2.new(0.5, 0, 0, 30)
    flySpeedLabel.Position = UDim2.new(0, 10, 0, 10)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "Fly Speed:"
    flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedLabel.Font = Enum.Font.Gotham
    flySpeedLabel.TextSize = 14
    flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    flySpeedLabel.Parent = flySettingsFrame
    
    local flySpeedSlider = Instance.new("TextBox")
    flySpeedSlider.Name = "FlySpeedSlider"
    flySpeedSlider.Size = UDim2.new(0.4, 0, 0, 30)
    flySpeedSlider.Position = UDim2.new(0.5, 10, 0, 10)
    flySpeedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    flySpeedSlider.BorderSizePixel = 0
    flySpeedSlider.Text = "50"
    flySpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedSlider.Font = Enum.Font.Gotham
    flySpeedSlider.TextSize = 14
    flySpeedSlider.Parent = flySettingsFrame
    
    local flyStyleLabel = Instance.new("TextLabel")
    flyStyleLabel.Name = "FlyStyleLabel"
    flyStyleLabel.Size = UDim2.new(0.5, 0, 0, 30)
    flyStyleLabel.Position = UDim2.new(0, 10, 0, 45)
    flyStyleLabel.BackgroundTransparency = 1
    flyStyleLabel.Text = "Fly Style:"
    flyStyleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyStyleLabel.Font = Enum.Font.Gotham
    flyStyleLabel.TextSize = 14
    flyStyleLabel.TextXAlignment = Enum.TextXAlignment.Left
    flyStyleLabel.Parent = flySettingsFrame
    
    local flyStyleDropdown = Instance.new("TextButton")
    flyStyleDropdown.Name = "FlyStyleDropdown"
    flyStyleDropdown.Size = UDim2.new(0.4, 0, 0, 30)
    flyStyleDropdown.Position = UDim2.new(0.5, 10, 0, 45)
    flyStyleDropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    flyStyleDropdown.BorderSizePixel = 0
    flyStyleDropdown.Text = "Normal"
    flyStyleDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyStyleDropdown.Font = Enum.Font.Gotham
    flyStyleDropdown.TextSize = 14
    flyStyleDropdown.Parent = flySettingsFrame
    
    -- Buat logo/tombol untuk membuka menu
    local menuLogo = Instance.new("TextButton")
    menuLogo.Name = "MenuLogo"
    menuLogo.Size = UDim2.new(0, 50, 0, 50)
    menuLogo.Position = UDim2.new(0, 20, 0, 20)
    menuLogo.AnchorPoint = Vector2.new(0, 0)
    menuLogo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    menuLogo.BorderSizePixel = 0
    menuLogo.Text = "🌀"
    menuLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
    menuLogo.TextScaled = true
    menuLogo.Parent = gui
    menuLogo.Active = true
    menuLogo.Draggable = true
    
    -- Simpan referensi ke elemen GUI
    local guiElements = {
        gui = gui,
        mainFrame = mainFrame,
        menuLogo = menuLogo,
        flySettingsFrame = flySettingsFrame,
        flySpeedSlider = flySpeedSlider,
        flyStyleDropdown = flyStyleDropdown
    }
    
    -- Fungsi untuk toggle button
    local function toggleButton(button, indicator, text, state)
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        text.Text = state and "ON" or "OFF"
        return state
    end
    
    -- Variabel untuk menyimpan state
    local playerStates = {
        AntiKill = menuData.enabledButtons.AntiKill or false,
        Noclip = menuData.enabledButtons.Noclip or false,
        SpeedWalk = menuData.enabledButtons.SpeedWalk or false,
        SpawnPoint = menuData.enabledButtons.SpawnPoint or false,
        Fly = menuData.enabledButtons.Fly or false,
        FlySpeed = 50,
        FlyStyle = "Normal",
        SpawnLocation = nil
    }
    
    -- Fungsi untuk menyimpan state
    local function saveStates()
        local enabledButtons = {
            AntiKill = playerStates.AntiKill,
            Noclip = playerStates.Noclip,
            SpeedWalk = playerStates.SpeedWalk,
            SpawnPoint = playerStates.SpawnPoint,
            Fly = playerStates.Fly
        }
        saveMenuData(player, enabledButtons, mainFrame.Position)
    end
    
    -- Fungsi untuk noclip
    local noclipConnection
    local function setupNoclip()
        if noclipConnection then noclipConnection:Disconnect() end
        
        if playerStates.Noclip then
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            
            noclipConnection = RunService.Stepped:Connect(function()
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
    
    -- Fungsi untuk speed walk
    local function setupSpeedWalk()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        if playerStates.SpeedWalk then
            humanoid.WalkSpeed = 50
        else
            humanoid.WalkSpeed = 16
        end
    end
    
    -- Fungsi untuk spawn point
    local function setupSpawnPoint()
        if playerStates.SpawnPoint then
            if not playerStates.SpawnLocation then
                local character = player.Character or player.CharacterAdded:Wait()
                playerStates.SpawnLocation = character:GetPivot()
            end
        end
    end
    
    -- Fungsi untuk fly
    local flyConnection
    local function setupFly()
        if flyConnection then flyConnection:Disconnect() end
        
        if playerStates.Fly then
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            
            -- Hentikan fly bawaan Roblox jika ada
            if humanoid:FindFirstChild("PlatformStand") then
                humanoid.PlatformStand = false
            end
            
            -- Tambahkan body velocity untuk fly
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 10000
            bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
            bodyGyro.CFrame = character:GetPivot()
            bodyGyro.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("UpperTorso")
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("UpperTorso")
            
            -- Atur gaya terbang
            if playerStates.FlyStyle == "Superhero" then
                -- Pose superhero untuk R15
                if humanoid.RigType == Enum.HumanoidRigType.R15 then
                    local animateScript = character:FindFirstChild("Animate")
                    if animateScript then
                        animateScript:Destroy()
                    end
                    
                    -- Pose superhero
                    humanoid:LoadAnimation(Instance.new("Animation", {AnimationId = "rbxassetid://35154961"})):Play()
                end
            end
            
            -- Koneksi input untuk fly
            flyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                local rootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("UpperTorso")
                if not rootPart then return end
                
                local flySpeed = playerStates.FlySpeed or 50
                
                if input.KeyCode == Enum.KeyCode.Space then
                    bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, flySpeed, bodyVelocity.Velocity.Z)
                elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
                    bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, -flySpeed, bodyVelocity.Velocity.Z)
                elseif input.KeyCode == Enum.KeyCode.W then
                    bodyVelocity.Velocity = rootPart.CFrame.LookVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.S then
                    bodyVelocity.Velocity = -rootPart.CFrame.LookVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.A then
                    bodyVelocity.Velocity = -rootPart.CFrame.RightVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.D then
                    bodyVelocity.Velocity = rootPart.CFrame.RightVector * flySpeed
                end
            end)
            
            -- Simpan referensi
            playerStates.FlyObjects = {
                BodyGyro = bodyGyro,
                BodyVelocity = bodyVelocity
            }
        else
            -- Hentikan fly
            if playerStates.FlyObjects then
                for _, obj in pairs(playerStates.FlyObjects) do
                    obj:Destroy()
                end
                playerStates.FlyObjects = nil
            end
        end
    end
    
    -- Fungsi untuk anti kill part
    local function setupAntiKill()
        if playerStates.AntiKill then
            player.CharacterAdded:Connect(function(character)
                local humanoid = character:WaitForChild("Humanoid")
                humanoid.Died:Connect(function()
                    -- Cegah kematian jika AntiKill aktif
                    if playerStates.AntiKill then
                        task.wait(1) -- Tunggu sebentar untuk memastikan
                        character:BreakJoints()
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)
            end)
        end
    end
    
    -- Fungsi untuk get tools
    local function getTools()
        -- Cari semua tools di workspace dan clone ke backpack
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then return end
        
        for _, tool in ipairs(game:GetService("Workspace"):GetDescendants()) do
            if tool:IsA("Tool") then
                local clone = tool:Clone()
                clone.Parent = backpack
            end
        end
    end
    
    -- Event handlers
    menuLogo.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        saveStates()
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        saveStates()
    end)
    
    antiKillButton.MouseButton1Click:Connect(function()
        playerStates.AntiKill = toggleButton(antiKillButton, antiKillIndicator, antiKillText, playerStates.AntiKill)
        setupAntiKill()
        saveStates()
    end)
    
    noclipButton.MouseButton1Click:Connect(function()
        playerStates.Noclip = toggleButton(noclipButton, noclipIndicator, noclipText, playerStates.Noclip)
        setupNoclip()
        saveStates()
    end)
    
    speedButton.MouseButton1Click:Connect(function()
        playerStates.SpeedWalk = toggleButton(speedButton, speedIndicator, speedText, playerStates.SpeedWalk)
        setupSpeedWalk()
        saveStates()
    end)
    
    spawnButton.MouseButton1Click:Connect(function()
        playerStates.SpawnPoint = toggleButton(spawnButton, spawnIndicator, spawnText, playerStates.SpawnPoint)
        if playerStates.SpawnPoint then
            local character = player.Character
            if character then
                playerStates.SpawnLocation = character:GetPivot()
            end
        end
        saveStates()
    end)
    
    toolsButton.MouseButton1Click:Connect(function()
        getTools()
    end)
    
    flyButton.MouseButton1Click:Connect(function()
        playerStates.Fly = toggleButton(flyButton, flyIndicator, flyText, playerStates.Fly)
        guiElements.flySettingsFrame.Visible = playerStates.Fly
        setupFly()
        saveStates()
    end)
    
    flySpeedSlider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local speed = tonumber(flySpeedSlider.Text)
            if speed and speed > 0 then
                playerStates.FlySpeed = speed
                setupFly() -- Update fly speed
                saveStates()
            else
                flySpeedSlider.Text = tostring(playerStates.FlySpeed or 50)
            end
        end
    end)
    
    flyStyleDropdown.MouseButton1Click:Connect(function()
        playerStates.FlyStyle = playerStates.FlyStyle == "Normal" and "Superhero" or "Normal"
        flyStyleDropdown.Text = playerStates.FlyStyle
        setupFly() -- Update fly style
        saveStates()
    end)
    
    -- Handle karakter yang dimuat ulang
    player.CharacterAdded:Connect(function(character)
        -- Setel ulang semua fitur saat karakter dimuat ulang
        if playerStates.Noclip then setupNoclip() end
        if playerStates.SpeedWalk then setupSpeedWalk() end
        if playerStates.Fly then setupFly() end
        if playerStates.SpawnPoint then
            -- Teleport ke spawn point jika aktif
            task.wait(0.1) -- Tunggu sedikit untuk memastikan karakter siap
            if playerStates.SpawnLocation then
                character:PivotTo(playerStates.SpawnLocation)
            end
        end
    end)
    
    -- Inisialisasi fitur yang aktif
    if playerStates.AntiKill then setupAntiKill() end
    if playerStates.Noclip then setupNoclip() end
    if playerStates.SpeedWalk then setupSpeedWalk() end
    if playerStates.SpawnPoint then setupSpawnPoint() end
    if playerStates.Fly then 
        setupFly() 
        guiElements.flySettingsFrame.Visible = true
    end
    
    -- Sembunyikan menu utama awalnya
    mainFrame.Visible = false
end

-- Buat GUI untuk setiap pemain yang bergabung
Players.PlayerAdded:Connect(function(player)
    createGUI(player)
    
    -- Simpan GUI saat pemain keluar
    player.AttributeChanged:Connect(function(attribute)
        if attribute == "MenuData" then
            -- Data berubah, mungkin perlu dihandle
        end
    end)
end)

-- Buat GUI untuk pemain yang sudah ada (saat script dimuat ulang)
for _, player in ipairs(Players:GetPlayers()) do
    createGUI(player)
end
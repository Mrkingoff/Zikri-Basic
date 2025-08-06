-- ZIKRI MENU KECE ☄️ FULL FINAL
-- by Cees 😎☄️

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZikriMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Logo
local logo = Instance.new("TextButton")
logo.Text = "😎"
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
logo.TextScaled = true
logo.Parent = screenGui
logo.Active = true
logo.Draggable = true

-- Frame Menu
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 700)
menuFrame.Position = UDim2.new(0, 70, 0, 10)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Parent = screenGui

-- Title Menu
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ZIKRI MENU KECE ☄️"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextScaled = true
title.Parent = menuFrame

-- Rainbow efek untuk title
task.spawn(function()
	while task.wait(0.03) do
		for i = 0, 255 do
			title.TextColor3 = Color3.fromHSV(i / 255, 1, 1)
			task.wait(0.03)
		end
	end
end)

-- Tombol close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 0)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Parent = menuFrame

-- Scroll frame untuk tombol
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.Parent = menuFrame

-- Fungsi bikin toggle
local function createToggle(name, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, yPos)
	btn.Text = name .. ": OFF"
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Parent = scrollFrame

	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		btn.Text = name .. ": " .. (active and "ON" or "OFF")
		callback(active)
	end)
end

-- Fungsi bikin button sekali klik
local function createButton(name, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, yPos)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Parent = scrollFrame

	btn.MouseButton1Click:Connect(function()
		callback()
	end)
end

-- Event buka-tutup menu
logo.MouseButton1Click:Connect(function()
	menuFrame.Visible = true
	logo.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
	logo.Visible = true
end)
-- Invisible Ghost Mode
createToggle("Invisible Ghost Mode", 0, function(state)
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Simpan posisi asli
            local savePos = hrp.CFrame
            -- Buat dummy ghost
            local ghost = char:Clone()
            ghost.Parent = workspace
            ghost.Name = "Ghost_"..LocalPlayer.Name
            for _, v in pairs(ghost:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = 0.5
                    v.CanCollide = false
                end
            end
            -- Pindahkan player asli jauh di atas
            hrp.CFrame = CFrame.new(0, 10000, 0)
            char.Animate.Disabled = true
            -- Simpan data untuk nonaktif
            char:SetAttribute("GhostSave", savePos)
            char:SetAttribute("GhostModel", ghost)
        end
    else
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local savePos = char:GetAttribute("GhostSave")
        local ghost = char:GetAttribute("GhostModel")
        if hrp and savePos then
            hrp.CFrame = savePos
        end
        if ghost and ghost.Parent then
            ghost:Destroy()
        end
        char.Animate.Disabled = false
    end
end)

-- Telekinesis Tool
createButton("Get Telekinesis Tool", 60, function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Telekinesis"
    tool.Parent = LocalPlayer.Backpack

    local selectedPart
    local moveConn, clickConn, throwConn

    tool.Equipped:Connect(function(mouse)
        clickConn = mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target and target:IsA("BasePart") and not target.Anchored then
                selectedPart = target
                selectedPart:SetNetworkOwner(LocalPlayer)
            end
        end)

        moveConn = RunService.RenderStepped:Connect(function()
            if selectedPart then
                selectedPart.CFrame = CFrame.new(mouse.Hit.Position)
            end
        end)

        throwConn = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Q and selectedPart then
                selectedPart.AssemblyLinearVelocity = (mouse.Hit.Position - selectedPart.Position).Unit * 150
                selectedPart = nil
            end
        end)
    end)

    tool.Unequipped:Connect(function()
        if moveConn then moveConn:Disconnect() end
        if clickConn then clickConn:Disconnect() end
        if throwConn then throwConn:Disconnect() end
        selectedPart = nil
    end)
end)

-- Fly ikut kamera
createToggle("Fly", 120, function(state)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    if state then
        local bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.P = 1e5
        local bodyVel = Instance.new("BodyVelocity", hrp)
        bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVel.Velocity = Vector3.zero
        hum.PlatformStand = true

        local cam = workspace.CurrentCamera
        local flySpeed = 50
        local ascend = false
        local descend = false

        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.Space then ascend = true end
            if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.LeftControl then descend = true end
        end)

        UserInputService.InputEnded:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.Space then ascend = false end
            if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.LeftControl then descend = false end
        end)

        RunService.RenderStepped:Connect(function()
            if not state then return end
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + (cam.CFrame.LookVector * Vector3.new(1,0,1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - (cam.CFrame.LookVector * Vector3.new(1,0,1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - (cam.CFrame.RightVector * Vector3.new(1,0,1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + (cam.CFrame.RightVector * Vector3.new(1,0,1)).Unit
            end

            local yVel = 0
            if ascend then yVel = flySpeed / 2 end
            if descend then yVel = -flySpeed / 2 end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end

            bodyVel.Velocity = (moveDir * flySpeed) + Vector3.new(0, yVel, 0)
            bodyGyro.CFrame = cam.CFrame
        end)
    else
        hum.PlatformStand = false
        for _, v in ipairs(hrp:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end)
-- Anti Kill Part
createToggle("Anti Kill Part", 180, function(state)
    if state then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("kill") then
                v.CanTouch = false
            end
        end
        workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("BasePart") and obj.Name:lower():find("kill") then
                obj.CanTouch = false
            end
        end)
    else
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("kill") then
                v.CanTouch = true
            end
        end
    end
end)

-- Anti Kill NPC
createToggle("Anti Kill NPC", 240, function(state)
    local char = LocalPlayer.Character
    if state then
        RunService.Stepped:Connect(function()
            for _, npc in ipairs(workspace:GetDescendants()) do
                if npc:IsA("Humanoid") and npc.Parent ~= char then
                    npc:ChangeState(Enum.HumanoidStateType.Seated)
                end
            end
        end)
    end
end)

-- God Mode
createToggle("God Mode", 300, function(state)
    if state then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Name = "1" end
        local newHum = hum:Clone()
        newHum.Parent = LocalPlayer.Character
        newHum.Name = "Humanoid"
        task.wait()
        hum:Destroy()
        workspace.CurrentCamera.CameraSubject = newHum
    end
end)

-- Noclip
createToggle("Noclip", 360, function(state)
    if state then
        RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

-- Walkfling fix
createToggle("Walkfling", 420, function(state)
    local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    if state then
        RunService.Heartbeat:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and (plr.Character:FindFirstChild("HumanoidRootPart")) then
                    local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < 5 then
                        plr.Character.HumanoidRootPart.Velocity = (plr.Character.HumanoidRootPart.Position - hrp.Position).Unit * 100
                    end
                end
            end
        end)
    end
end)

-- Save Spawn Point
local savedSpawn
createToggle("Save Spawn", 480, function(state)
    if state then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then savedSpawn = hrp.CFrame end
    else
        savedSpawn = nil
    end
end)

-- Respawn
createButton("Respawn", 540, function()
    LocalPlayer.Character:BreakJoints()
end)

-- Get All Tools
createButton("Get All Tools", 570, function()
    for _, tool in ipairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") then
            tool.Parent = LocalPlayer.Backpack
        end
    end
end)

-- Permadeath (R6)
createToggle("Permadeath (R6)", 600, function(state)
    if state then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        end
    end
end)

-- Delete Tools All Player
createButton("Delete Tools All", 660, function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack then
            for _, tool in ipairs(plr.Backpack:GetChildren()) do
                tool:Destroy()
            end
        end
        if plr.Character then
            for _, tool in ipairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool:Destroy()
                end
            end
        end
    end
end)

-- Spawn Unanchored
createButton("Spawn Unanchored", 720, function()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored then
            part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

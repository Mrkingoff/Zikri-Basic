-- ZIKRI MENU KECE ☄️ FULL UPDATE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZikriMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local logo = Instance.new("TextButton")
logo.Text = "😎"
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
logo.TextScaled = true
logo.Parent = screenGui

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 650)
menuFrame.Position = UDim2.new(0, 70, 0, 10)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ZIKRI MENU KECE ☄️"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextScaled = true
title.Parent = menuFrame

task.spawn(function()
	while true do
		for i = 0, 255 do
			title.TextColor3 = Color3.fromHSV(i / 255, 1, 1)
			task.wait(0.03)
		end
	end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 0)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Parent = menuFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1250)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.Parent = menuFrame

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

-- === FITUR ===
createToggle("Anti Kill Part", 10, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") and part.CanTouch then
					if string.find(string.lower(part.Name), "kill") or string.find(string.lower(part.Name), "lava") then
						part.CanTouch = false
					end
				end
			end
		end)
	end
end)

createToggle("Anti Kill NPC", 60, function(state)
	if state then
		local hum = LocalPlayer.Character:WaitForChild("Humanoid")
		hum.HealthChanged:Connect(function(h)
			if h < hum.MaxHealth then hum.Health = hum.MaxHealth end
		end)
	end
end)

createToggle("God Mode", 110, function(state)
	if state then
		RunService.Stepped:Connect(function()
			local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end)
	end
end)

createToggle("Noclip", 160, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end)
	end
end)

createToggle("Walkfling", 210, function(state)
	if state then
		RunService.Heartbeat:Connect(function()
			if not state then return end
			local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local otherHRP = plr.Character.HumanoidRootPart
					if (hrp.Position - otherHRP.Position).Magnitude < 6 then
						otherHRP.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)
					end
				end
			end
		end)
	end
end)

local savedSpawn
createButton("Save Spawn Point", 260, function()
	local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	savedSpawn = hrp.Position
end)

createButton("Respawn", 310, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.Health = 0 end
	if savedSpawn then
		LocalPlayer.CharacterAdded:Wait()
		task.wait(1)
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(savedSpawn)
	end
end)

createButton("Get All Tools", 360, function()
	for _, tool in pairs(workspace:GetDescendants()) do
		if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
	end
	for _, tool in pairs(ReplicatedStorage:GetDescendants()) do
		if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
	end
end)

createToggle("Swim Mode", 410, function(state)
	local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if state then
			hum:ChangeState(Enum.HumanoidStateType.Swimming)
		else
			hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		end
	end
end)

createToggle("Deadboy", 460, function(state)
	local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum and state then
		hum.Health = 0
		task.wait(0.1)
		LocalPlayer.Character.HumanoidRootPart.Anchored = false
	end
end)

createToggle("Invisible", 510, function(state)
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		if state then
			char:MoveTo(Vector3.new(9999, 9999, 9999))
		else
			char:MoveTo(workspace.SpawnLocation and workspace.SpawnLocation.Position or Vector3.new(0, 10, 0))
		end
	end
end)

createToggle("Fly", 560, function(state)
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
		bodyVel.Velocity = Vector3.new(0, 0, 0)
		hum.PlatformStand = true

		RunService.RenderStepped:Connect(function()
			if not state then return end
			local moveDir = hum.MoveDirection
			bodyVel.Velocity = Vector3.new(moveDir.X * 50, 0, moveDir.Z * 50) + Vector3.new(0, 25, 0)
		end)
	else
		hum.PlatformStand = false
		for _, v in ipairs(hrp:GetChildren()) do
			if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
		end
	end
end)

createButton("Delete Tools All Player", 610, function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr.Backpack then
			for _, tool in pairs(plr.Backpack:GetChildren()) do
				if tool:IsA("Tool") then tool:Destroy() end
			end
		end
		if plr.Character then
			for _, tool in pairs(plr.Character:GetChildren()) do
				if tool:IsA("Tool") then tool:Destroy() end
			end
		end
	end
end)

logo.MouseButton1Click:Connect(function()
	menuFrame.Visible = true
	logo.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
	logo.Visible = true
end)

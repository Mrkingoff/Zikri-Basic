-- ZIKRI MENU KECE ☄️ FULL UPDATE + MODEGHOST
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Simpan posisi logo
local logoPos = UDim2.new(0, 10, 0, 10)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZikriMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- === LOGO DRAGGABLE ===
local logo = Instance.new("TextButton")
logo.Text = "😎"
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = logoPos
logo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
logo.TextScaled = true
logo.Parent = screenGui
logo.Active = true
logo.Draggable = true

-- Simpan posisi logo saat dilepas
logo.Changed:Connect(function(prop)
	if prop == "Position" then
		logoPos = logo.Position
	end
end)

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 720)
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
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1600)
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

createToggle("Permadeath (R6)", 410, function(state)
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	if state then
		hum.BreakJointsOnDeath = false
		hum.RequiresNeck = false
		hum.Health = 0
		task.wait(0.1)
		hum:ChangeState(Enum.HumanoidStateType.Physics)
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = false
				part.CanCollide = true
			end
		end
	else
		hum.Health = 100
	end
end)

createToggle("Invisible", 460, function(state)
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		if state then
			char:MoveTo(Vector3.new(9999, 9999, 9999))
		else
			char:MoveTo(workspace.SpawnLocation and workspace.SpawnLocation.Position or Vector3.new(0, 10, 0))
		end
	end
end)

-- === MODEGHOST ===
createToggle("ModeGhost", 510, function(state)
	local char = LocalPlayer.Character
	if not char then return end

	if state then
		_G.GhostPos = char:FindFirstChild("HumanoidRootPart").CFrame
		_G.Dummy = char:Clone()
		_G.Dummy.Parent = workspace
		for _, v in pairs(_G.Dummy:GetDescendants()) do
			if v:IsA("Script") or v:IsA("LocalScript") then
				v:Destroy()
			end
		end
		char:MoveTo(Vector3.new(99999, 99999, 99999))
	else
		if _G.GhostPos then
			char:MoveTo(_G.GhostPos.Position)
		end
		if _G.Dummy then
			_G.Dummy:Destroy()
			_G.Dummy = nil
		end
	end
end)

createButton("Delete Tools All Player", 560, function()
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

createButton("Spawn Unanchored", 610, function()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	for _, part in pairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and not part.Anchored and part.CanCollide then
			part.CFrame = hrp.CFrame * CFrame.new(0, 5, -5)
		end
	end
end)

-- Tombol buka/tutup menu
logo.MouseButton1Click:Connect(function()
	menuFrame.Visible = true
	logo.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
	logo.Visible = true
end)

--[[
	ZIKRI MENU KECE ☄️ FINAL BRUTAL EDITION
	By: bro anakhebat 😎🔥
	Executor: KRNL
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

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

-- Simpan posisi logo saat digeser
logo.Changed:Connect(function(prop)
	if prop == "Position" then
		logoPos = logo.Position
	end
end)

-- === MENU ===
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 760)
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

-- Rainbow title
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
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1800)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.Parent = menuFrame

-- Utility buat tombol
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
-- Anti Kill Part Brutal
createToggle("Anti Kill Part (Brutal)", 10, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") then
					local nameLower = string.lower(part.Name)
					if nameLower:find("kill") or nameLower:find("lava") or nameLower:find("touch") or nameLower:find("dead") then
						part.CanTouch = false
						part.CanCollide = false
						part.Transparency = 1
					end
				end
			end
		end)
	end
end)

-- Attach Kill Part Brutal
createButton("Attach Kill Part Brutal", 60, function()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for _, part in pairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") then
			local nameLower = string.lower(part.Name)
			if nameLower:find("kill") or nameLower:find("lava") or nameLower:find("touch") or nameLower:find("dead") then
				local clone = part:Clone()
				clone.Anchored = false
				clone.CanCollide = false
				clone.Transparency = 1
				clone.Parent = char
				local weld = Instance.new("WeldConstraint", clone)
				weld.Part0 = clone
				weld.Part1 = hrp
				clone.CanTouch = true
				local success = pcall(function()
					clone:SetNetworkOwner(LocalPlayer)
				end)
			end
		end
	end
end)

-- Anti Kill NPC
createToggle("Anti Kill NPC", 110, function(state)
	if state then
		local hum = LocalPlayer.Character:WaitForChild("Humanoid")
		hum.HealthChanged:Connect(function(h)
			if h < hum.MaxHealth then hum.Health = hum.MaxHealth end
		end)
	end
end)

-- God Mode
createToggle("God Mode", 160, function(state)
	if state then
		RunService.Stepped:Connect(function()
			local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end)
	end
end)

-- Noclip
createToggle("Noclip", 210, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end)
	end
end)

-- Walkfling
createToggle("Walkfling", 260, function(state)
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

-- Save Spawn
createButton("Save Spawn Point", 310, function()
	local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	_G.SavedSpawn = hrp.Position
end)

-- Respawn
createButton("Respawn", 360, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.Health = 0 end
	if _G.SavedSpawn then
		LocalPlayer.CharacterAdded:Wait()
		task.wait(1)
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(_G.SavedSpawn)
	end
end)

-- Get All Tools
createButton("Get All Tools", 410, function()
	for _, tool in pairs(workspace:GetDescendants()) do
		if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
	end
	for _, tool in pairs(ReplicatedStorage:GetDescendants()) do
		if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
	end
end)

-- ModeGhost Realistis
createToggle("ModeGhost (Realistic)", 460, function(state)
	if state then
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		_G.GhostDummy = char:Clone()
		for _, v in pairs(_G.GhostDummy:GetDescendants()) do
			if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end
		end
		_G.GhostDummy.Parent = workspace
		LocalPlayer.Character = _G.GhostDummy
		char:MoveTo(Vector3.new(99999, 99999, 99999))
	else
		if _G.GhostDummy then
			local pos = _G.GhostDummy:FindFirstChild("HumanoidRootPart") and _G.GhostDummy.HumanoidRootPart.Position
			_G.GhostDummy:Destroy()
			LocalPlayer.Character = LocalPlayer.CharacterAdded:Wait()
			task.wait(0.2)
			if pos then
				LocalPlayer.Character:MoveTo(pos)
			end
		end
	end
end)

-- Delete Tools All Player
createButton("Delete Tools All Player", 510, function()
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

-- Spawn Unanchored
createButton("Spawn Unanchored", 560, function()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	for _, part in pairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and not part.Anchored and part.CanCollide then
			part.CFrame = hrp.CFrame * CFrame.new(0, 5, -5)
		end
	end
end)

-- Menu open/close
logo.MouseButton1Click:Connect(function()
	menuFrame.Visible = true
	logo.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
	logo.Visible = true
end)

--[[
👾 ZIKRI MENU SIMPLE POWERFUL
By: anakhebat 😎🔥
Executor: KRNL
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Variabel global
local menuVisible = false
local savedSpawn = nil
local noclipConn
local ghostDummy
local mouse = LocalPlayer:GetMouse()

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZikriMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- === LOGO ===
local logo = Instance.new("TextButton")
logo.Text = "👾"
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
logo.TextScaled = true
logo.Parent = screenGui
logo.Active = true
logo.Draggable = true

-- === MENU FRAME ===
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 500)
menuFrame.Position = UDim2.new(0, 70, 0, 10)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Parent = screenGui

-- Scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = menuFrame

-- Utility: Toggle Button
local function createToggle(name, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, y)
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

-- Utility: Normal Button
local function createButton(name, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, y)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Parent = scrollFrame

	btn.MouseButton1Click:Connect(callback)
end

-- === FITUR ===

-- Anti Kill Part
createToggle("Anti Kill Part", 10, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") then
					local n = string.lower(part.Name)
					if n:find("kill") or n:find("lava") or n:find("touch") or n:find("dead") then
						part.CanTouch = false
					end
				end
			end
		end)
	end
end)

-- Anti Kill NPC
createToggle("Anti Kill NPC", 60, function(state)
	if state then
		local hum = LocalPlayer.Character:WaitForChild("Humanoid")
		hum.HealthChanged:Connect(function(hp)
			if hp < hum.MaxHealth then hum.Health = hum.MaxHealth end
		end)
	end
end)

-- God Mode
createToggle("God Mode", 110, function(state)
	if state then
		RunService.Stepped:Connect(function()
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end)
	end
end)

-- Noclip
createToggle("Noclip", 160, function(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
	end
end)

-- Invisible Ghost
createToggle("Invisible Ghost", 210, function(state)
	if state then
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		ghostDummy = char:Clone()
		for _, v in pairs(ghostDummy:GetDescendants()) do
			if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end
		end
		ghostDummy.Parent = workspace
		LocalPlayer.Character = ghostDummy
		char:MoveTo(Vector3.new(0, 1000, 0)) -- Sembunyikan asli
	else
		if ghostDummy then
			local pos = ghostDummy:FindFirstChild("HumanoidRootPart") and ghostDummy.HumanoidRootPart.Position
			ghostDummy:Destroy()
			LocalPlayer.Character = LocalPlayer.CharacterAdded:Wait()
			task.wait(0.2)
			if pos then
				LocalPlayer.Character:MoveTo(pos)
			end
		end
	end
end)

-- Reset Karakter
createButton("Reset Karakter", 260, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.Health = 0 end
end)

-- Get All Tools
createButton("Get All Tools", 310, function()
	for _, tool in pairs(workspace:GetDescendants()) do
		if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
	end
	for _, tool in pairs(ReplicatedStorage:GetDescendants()) do
		if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
	end
end)

-- TP Tool
createButton("TP Tool", 360, function()
	mouse.Button1Down:Connect(function()
		if LocalPlayer.Backpack then
			for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
				if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
					tool.Handle.CFrame = CFrame.new(mouse.Hit.p)
				end
			end
		end
	end)
end)

-- Anti Sit
createButton("Anti Sit", 410, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then
		hum.Seated:Connect(function(active)
			if active then hum.Sit = false end
		end)
	end
end)

-- === LOGO TOGGLE MENU ===
logo.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	menuFrame.Visible = menuVisible
end)

-- Respawn support
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	menuFrame.Parent = screenGui
	logo.Parent = screenGui
end)

-- ZIKRI MENU KECE ☄️ FULL FINAL
-- By Cees 😎☄️🔥

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

-- Rainbow efek title
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

-- Scroll frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.Parent = menuFrame

-- Fungsi tombol toggle
local function createToggle(name, order, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, order * 50)
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

-- Fungsi tombol klik sekali
local function createButton(name, order, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, order * 50)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Parent = scrollFrame
	btn.MouseButton1Click:Connect(function()
		callback()
	end)
end

-- Event buka/tutup menu
logo.MouseButton1Click:Connect(function()
	menuFrame.Visible = true
	logo.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
	logo.Visible = true
end)

-- ====== TITLE 1: BUTTON ON/OFF ======
local titleOnOff = Instance.new("TextLabel")
titleOnOff.Size = UDim2.new(1, 0, 0, 40)
titleOnOff.Position = UDim2.new(0, 0, 0, 0)
titleOnOff.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleOnOff.Text = "=== BUTTON ON / OFF ==="
titleOnOff.TextScaled = true
titleOnOff.TextColor3 = Color3.fromRGB(255, 255, 255)
titleOnOff.Parent = scrollFrame

-- ====== TITLE 2: BUTTON 1X CLICK ======
local titleClick = Instance.new("TextLabel")
titleClick.Size = UDim2.new(1, 0, 0, 40)
titleClick.Position = UDim2.new(0, 0, 0, 900)
titleClick.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleClick.Text = "=== BUTTON 1X CLICK ==="
titleClick.TextScaled = true
titleClick.TextColor3 = Color3.fromRGB(255, 255, 255)
titleClick.Parent = scrollFrame
-- === FITUR ON/OFF ===

-- Anti Kill Part
createToggle("Anti Kill Part", 1, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") and part.Name:lower():find("kill") then
					part.CanTouch = false
				end
			end
		end)
	else
		for _, part in pairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") and part.Name:lower():find("kill") then
				part.CanTouch = true
			end
		end
	end
end)

-- Anti Kill NPC
createToggle("Anti Kill NPC", 2, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, npc in pairs(workspace:GetDescendants()) do
				if npc:IsA("Humanoid") and npc ~= LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					npc.Health = 0
				end
			end
		end)
	end
end)

-- God Mode
createToggle("God Mode", 3, function(state)
	if state then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.MaxHealth = math.huge
			hum.Health = math.huge
		end
	else
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.MaxHealth = 100
			hum.Health = 100
		end
	end
end)

-- Noclip
createToggle("Noclip", 4, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	else
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end)

-- Walkfling (versi fix)
createToggle("Walkfling", 5, function(state)
	local char = LocalPlayer.Character
	if state and char then
		local hrp = char:WaitForChild("HumanoidRootPart")
		local fling = Instance.new("BodyAngularVelocity", hrp)
		fling.AngularVelocity = Vector3.new(0, 999999, 0)
		fling.MaxTorque = Vector3.new(0, math.huge, 0)
	else
		for _, v in pairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
			if v:IsA("BodyAngularVelocity") then v:Destroy() end
		end
	end
end)

-- Save Spawn
local savedPos = nil
createToggle("Save Spawn", 6, function(state)
	if state then
		savedPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
		LocalPlayer.CharacterAdded:Connect(function(char)
			task.wait(0.5)
			if savedPos then
				char:WaitForChild("HumanoidRootPart").CFrame = savedPos
			end
		end)
	else
		savedPos = nil
	end
end)

-- Fly Mobile Simple
createToggle("Fly (Mobile)", 7, function(state)
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

		RunService.RenderStepped:Connect(function()
			if not state then return end
			local moveDir = hum.MoveDirection
			if moveDir.Magnitude > 0 then
				local dir = cam.CFrame:VectorToWorldSpace(moveDir)
				bodyVel.Velocity = dir.Unit * flySpeed
			else
				bodyVel.Velocity = Vector3.zero
			end
			bodyGyro.CFrame = cam.CFrame
		end)
	else
		hum.PlatformStand = false
		for _, v in ipairs(hrp:GetChildren()) do
			if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
		end
	end
end)

-- Invisible Ghost Mode
createToggle("Invisible Ghost", 8, function(state)
	if state then
		local char = LocalPlayer.Character
		if not char then return end
		local clone = char:Clone()
		for _, v in pairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 1
				v.Anchored = false
			end
		end
		clone.Parent = workspace
		char:MoveTo(Vector3.new(0, 9999, 0))
	else
		LocalPlayer.Character:MoveTo(workspace:FindFirstChildWhichIsA("SpawnLocation").Position)
	end
end)

-- Permadeath (R6)
createToggle("Permadeath (R6)", 9, function(state)
	if state then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Health = 0
		end
	end
end)
-- === FITUR ON/OFF ===

-- Anti Kill Part
createToggle("Anti Kill Part", 1, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") and part.Name:lower():find("kill") then
					part.CanTouch = false
				end
			end
		end)
	else
		for _, part in pairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") and part.Name:lower():find("kill") then
				part.CanTouch = true
			end
		end
	end
end)

-- Anti Kill NPC
createToggle("Anti Kill NPC", 2, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, npc in pairs(workspace:GetDescendants()) do
				if npc:IsA("Humanoid") and npc ~= LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					npc.Health = 0
				end
			end
		end)
	end
end)

-- God Mode
createToggle("God Mode", 3, function(state)
	if state then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.MaxHealth = math.huge
			hum.Health = math.huge
		end
	else
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.MaxHealth = 100
			hum.Health = 100
		end
	end
end)

-- Noclip
createToggle("Noclip", 4, function(state)
	if state then
		RunService.Stepped:Connect(function()
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	else
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end)

-- Walkfling (versi fix)
createToggle("Walkfling", 5, function(state)
	local char = LocalPlayer.Character
	if state and char then
		local hrp = char:WaitForChild("HumanoidRootPart")
		local fling = Instance.new("BodyAngularVelocity", hrp)
		fling.AngularVelocity = Vector3.new(0, 999999, 0)
		fling.MaxTorque = Vector3.new(0, math.huge, 0)
	else
		for _, v in pairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
			if v:IsA("BodyAngularVelocity") then v:Destroy() end
		end
	end
end)

-- Save Spawn
local savedPos = nil
createToggle("Save Spawn", 6, function(state)
	if state then
		savedPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
		LocalPlayer.CharacterAdded:Connect(function(char)
			task.wait(0.5)
			if savedPos then
				char:WaitForChild("HumanoidRootPart").CFrame = savedPos
			end
		end)
	else
		savedPos = nil
	end
end)

-- Fly Mobile Simple
createToggle("Fly (Mobile)", 7, function(state)
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

		RunService.RenderStepped:Connect(function()
			if not state then return end
			local moveDir = hum.MoveDirection
			if moveDir.Magnitude > 0 then
				local dir = cam.CFrame:VectorToWorldSpace(moveDir)
				bodyVel.Velocity = dir.Unit * flySpeed
			else
				bodyVel.Velocity = Vector3.zero
			end
			bodyGyro.CFrame = cam.CFrame
		end)
	else
		hum.PlatformStand = false
		for _, v in ipairs(hrp:GetChildren()) do
			if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
		end
	end
end)

-- Invisible Ghost Mode
createToggle("Invisible Ghost", 8, function(state)
	if state then
		local char = LocalPlayer.Character
		if not char then return end
		local clone = char:Clone()
		for _, v in pairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 1
				v.Anchored = false
			end
		end
		clone.Parent = workspace
		char:MoveTo(Vector3.new(0, 9999, 0))
	else
		LocalPlayer.Character:MoveTo(workspace:FindFirstChildWhichIsA("SpawnLocation").Position)
	end
end)

-- Permadeath (R6)
createToggle("Permadeath (R6)", 9, function(state)
	if state then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Health = 0
		end
	end
end)
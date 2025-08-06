-- FULL ZIKRI MENU KECE ☄️ + SILENT WALKFLING FIX
-- Dibuat untuk public game / studio

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZikriMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Logo 😎
local logo = Instance.new("TextButton")
logo.Text = "😎"
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
logo.TextScaled = true
logo.Parent = screenGui

-- Frame Menu
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 320)
menuFrame.Position = UDim2.new(0, 70, 0, 10)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Parent = screenGui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ZIKRI MENU KECE ☄️"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextScaled = true
title.Parent = menuFrame

-- Efek Rainbow di Judul
task.spawn(function()
	while true do
		for i = 0, 255 do
			title.TextColor3 = Color3.fromHSV(i / 255, 1, 1)
			task.wait(0.03)
		end
	end
end)

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 0)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Parent = menuFrame

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.Parent = menuFrame

-- Fungsi buat tombol toggle
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

-- Fungsi buat tombol sekali klik
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
-- Anti Kill Part
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

-- Anti Kill NPC
createToggle("Anti Kill NPC", 60, function(state)
	if state then
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local hum = char:WaitForChild("Humanoid")
		hum.HealthChanged:Connect(function(h)
			if h < hum.MaxHealth then
				hum.Health = hum.MaxHealth
			end
		end)
	end
end)

-- God Mode
createToggle("God Mode", 110, function(state)
	if state then
		RunService.Stepped:Connect(function()
			pcall(function()
				local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
				if hum then hum.Health = hum.MaxHealth end
			end)
		end)
	end
end)

-- Noclip
createToggle("Noclip", 160, function(state)
	if state then
		RunService.Stepped:Connect(function()
			pcall(function()
				for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end)
		end)
	end
end)

-- Walkfling Silent
createToggle("Walkfling", 210, function(state)
	if state then
		RunService.Heartbeat:Connect(function()
			if not state then return end
			local char = LocalPlayer.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local otherHRP = plr.Character.HumanoidRootPart
					local dist = (hrp.Position - otherHRP.Position).Magnitude
					if dist < 6 then
						-- Lempar mereka tanpa bikin kamu mental
						otherHRP.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)
					end
				end
			end
		end)
	end
end)

-- Spawn Point (klik sekali)
local savedSpawn
createButton("Save Spawn Point", 260, function()
	local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	savedSpawn = hrp.Position
	print("[ZIKRI MENU] Spawn Point Disimpan:", savedSpawn)
end)

-- Respawn (klik sekali)
createButton("Respawn", 310, function()
	LocalPlayer:LoadCharacter()
	if savedSpawn then
		task.wait(1)
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(savedSpawn)
	end
end)

-- === Buka/Tutup Menu ===
logo.MouseButton1Click:Connect(function()
	menuFrame.Visible = true
	logo.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
	logo.Visible = true
end)

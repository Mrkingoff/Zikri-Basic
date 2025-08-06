-- ZIKRI MENU KECE ☄️ FULL UPDATE + TELEKINESIS TOOL + INVISIBLE GHOST MODE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZikriMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- === LOGO DRAGGABLE ===
local logo = Instance.new("TextButton")
logo.Text = "😎"
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
logo.TextScaled = true
logo.Parent = screenGui
logo.Active = true
logo.Draggable = true

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 700)
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
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1500)
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

-- ===== INVISIBLE GHOST MODE =====
local ghostChar
local storedPos

createToggle("Invisible Ghost Mode", 10, function(state)
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	if state then
		-- Simpan posisi awal
		storedPos = char.HumanoidRootPart.CFrame

		-- Clone ghost
		ghostChar = char:Clone()
		ghostChar.Parent = workspace
		ghostChar.Name = "GhostChar"
		ghostChar:MoveTo(char.HumanoidRootPart.Position)
		-- Set network owner agar kamu kontrol ghost
		for _, p in pairs(ghostChar:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = false
				p.CanCollide = true
			end
		end

		-- Kirim karakter asli ke atas
		char:MoveTo(Vector3.new(0, 9999, 0))
		char.HumanoidRootPart.Anchored = true
		char.Humanoid.WalkSpeed = 0
		char.Humanoid.JumpPower = 0

		-- Ganti kontrol ke ghost
		LocalPlayer.Character = ghostChar
	else
		if ghostChar and ghostChar:FindFirstChild("HumanoidRootPart") then
			local ghostPos = ghostChar.HumanoidRootPart.CFrame

			-- Balikin kontrol ke karakter asli
			LocalPlayer.Character = LocalPlayer.Character or LocalPlayer:LoadCharacter()

			task.wait(0.1)
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = ghostPos
				LocalPlayer.Character.HumanoidRootPart.Anchored = false
				LocalPlayer.Character.Humanoid.WalkSpeed = 16
				LocalPlayer.Character.Humanoid.JumpPower = 50
			end

			-- Hapus ghost
			ghostChar:Destroy()
			ghostChar = nil
		end
	end
end)

-- ===== TELEKINESIS TOOL =====
createButton("Get Telekinesis Tool", 60, function()
	local tool = Instance.new("Tool")
	tool.RequiresHandle = false
	tool.Name = "Telekinesis"
	tool.Parent = LocalPlayer.Backpack

	local selectedPart

	tool.Equipped:Connect(function(mouse)
		mouse.Button1Down:Connect(function()
			local target = mouse.Target
			if target and target:IsA("BasePart") and not target.Anchored then
				selectedPart = target
				selectedPart:SetNetworkOwner(LocalPlayer)
			end
		end)

		RunService.RenderStepped:Connect(function()
			if selectedPart then
				selectedPart.CFrame = CFrame.new(mouse.Hit.Position)
			end
		end)

		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Q and selectedPart then
				selectedPart.AssemblyLinearVelocity = (mouse.Hit.Position - selectedPart.Position).Unit * 150
				selectedPart = nil
			end
		end)
	end)
end)

-- (Fitur lama bisa ditempel di bawah ini seperti Anti Kill Part, Godmode, Fly, dll)

logo.MouseButton1Click:Connect(function()
	menuFrame.Visible = true
	logo.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
	logo.Visible = true
end)

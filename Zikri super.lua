--// SUPER GOD HUMAN NOID ☠️ V2 By Zikri
-- Support KRNL / Fluxus / Script Executor lain

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SUPER_GOD_HUMAN_NOID"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 300)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
title.Text = "SUPER GOD HUMAN NOID ☠️"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- MENU TOGGLE (+/-)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -45, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
toggleBtn.Text = "-"
toggleBtn.TextColor3 = Color3.new(0,0,0)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 24
toggleBtn.Parent = frame

-- BUTTON HOLDER
local buttonHolder = Instance.new("Frame")
buttonHolder.Size = UDim2.new(1, 0, 1, -40)
buttonHolder.Position = UDim2.new(0, 0, 0, 40)
buttonHolder.BackgroundTransparency = 1
buttonHolder.Parent = frame

-- BUTTON MAKER
local function makeButton(name, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 35)
	btn.Position = UDim2.new(0.1, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Text = name
	btn.Parent = buttonHolder
	return btn
end

-- TOMBOL
local btnAntiBlock = makeButton("ANTI KILL BLOCK: OFF", 10)
local btnAntiDamage = makeButton("ANTI DAMAGE: OFF", 55)
local btnAntiNPC = makeButton("ANTI NPC KILL: OFF", 100)
local btnAntiTools = makeButton("ANTI KILL TOOLS: OFF", 145)
local btnReset = makeButton("RESET CHARACTER", 190)

-- VAR
local antiBlock = false
local antiDamage = false
local antiNPC = false
local antiTools = false

-- ANTI KILL BLOCK
local function toggleAntiBlock(state)
	antiBlock = state
	if antiBlock then
		btnAntiBlock.Text = "ANTI KILL BLOCK: ON"
		btnAntiBlock.BackgroundColor3 = Color3.fromRGB(0,180,0)
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.CanTouch == true then
				v.CanTouch = false
			end
		end
	else
		btnAntiBlock.Text = "ANTI KILL BLOCK: OFF"
		btnAntiBlock.BackgroundColor3 = Color3.fromRGB(60,60,60)
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanTouch = true
			end
		end
	end
end
btnAntiBlock.MouseButton1Click:Connect(function()
	toggleAntiBlock(not antiBlock)
end)

-- ANTI DAMAGE
local function toggleAntiDamage(state)
	antiDamage = state
	if antiDamage then
		btnAntiDamage.Text = "ANTI DAMAGE: ON"
		btnAntiDamage.BackgroundColor3 = Color3.fromRGB(0,180,0)
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.HealthChanged:Connect(function(hp)
				if hp < hum.MaxHealth then
					hum.Health = hum.MaxHealth
				end
			end)
		end
	else
		btnAntiDamage.Text = "ANTI DAMAGE: OFF"
		btnAntiDamage.BackgroundColor3 = Color3.fromRGB(60,60,60)
	end
end
btnAntiDamage.MouseButton1Click:Connect(function()
	toggleAntiDamage(not antiDamage)
end)

-- ANTI NPC KILL
local function toggleAntiNPC(state)
	antiNPC = state
	if antiNPC then
		btnAntiNPC.Text = "ANTI NPC KILL: ON"
		btnAntiNPC.BackgroundColor3 = Color3.fromRGB(0,180,0)
		for _, npc in pairs(workspace:GetDescendants()) do
			if npc:IsA("Model") and npc ~= char and npc:FindFirstChildOfClass("Humanoid") then
				for _, part in pairs(npc:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanTouch = false
					end
				end
			end
		end
	else
		btnAntiNPC.Text = "ANTI NPC KILL: OFF"
		btnAntiNPC.BackgroundColor3 = Color3.fromRGB(60,60,60)
		for _, npc in pairs(workspace:GetDescendants()) do
			if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
				for _, part in pairs(npc:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanTouch = true
					end
				end
			end
		end
	end
end
btnAntiNPC.MouseButton1Click:Connect(function()
	toggleAntiNPC(not antiNPC)
end)

-- ANTI KILL TOOLS
local function toggleAntiTools(state)
	antiTools = state
	if antiTools then
		btnAntiTools.Text = "ANTI KILL TOOLS: ON"
		btnAntiTools.BackgroundColor3 = Color3.fromRGB(0,180,0)
		for _, tool in pairs(workspace:GetDescendants()) do
			if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
				tool.Handle.CanTouch = false
			end
		end
	else
		btnAntiTools.Text = "ANTI KILL TOOLS: OFF"
		btnAntiTools.BackgroundColor3 = Color3.fromRGB(60,60,60)
		for _, tool in pairs(workspace:GetDescendants()) do
			if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
				tool.Handle.CanTouch = true
			end
		end
	end
end
btnAntiTools.MouseButton1Click:Connect(function()
	toggleAntiTools(not antiTools)
end)

-- RESET KARAKTER
btnReset.MouseButton1Click:Connect(function()
	player.Character:BreakJoints()
end)

-- MENU LIPAT
local folded = false
toggleBtn.MouseButton1Click:Connect(function()
	folded = not folded
	if folded then
		buttonHolder.Visible = false
		frame.Size = UDim2.new(0, 280, 0, 40)
		toggleBtn.Text = "+"
	else
		buttonHolder.Visible = true
		frame.Size = UDim2.new(0, 280, 0, 300)
		toggleBtn.Text = "-"
	end
end)

-- Update karakter kalau respawn
player.CharacterAdded:Connect(function(c)
	char = c
end)

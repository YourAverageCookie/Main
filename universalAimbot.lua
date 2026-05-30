local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotEnabled = false
local SelectedPlayer = nil
local ListOpen = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 160, 0, 260)
Container.Position = UDim2.new(0, 20, 0, 20)
Container.BackgroundTransparency = 1
Container.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 0, 50)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.FredokaOne
ToggleButton.TextScaled = true
ToggleButton.Text = "AIMBOT OFF"
ToggleButton.Parent = Container

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", ToggleButton)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 0, 0)

local ListToggle = Instance.new("TextButton")
ListToggle.Size = UDim2.new(1, 0, 0, 25)
ListToggle.Position = UDim2.new(0, 0, 0, 55)
ListToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ListToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ListToggle.Font = Enum.Font.SourceSansBold
ListToggle.TextScaled = true
ListToggle.Text = "PLAYERS ▼"
ListToggle.Parent = Container

local PlayerFrame = Instance.new("ScrollingFrame")
PlayerFrame.Size = UDim2.new(1, 0, 0, 180)
PlayerFrame.Position = UDim2.new(0, 0, 0, 80)
PlayerFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
PlayerFrame.BorderSizePixel = 0
PlayerFrame.ScrollBarThickness = 6
PlayerFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerFrame.Parent = Container

local Layout = Instance.new("UIListLayout", PlayerFrame)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local dragging = false
local dragStart
local startPos

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Container.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Container.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local function UpdateButton()
	if AimbotEnabled then
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		ToggleButton.Text = "AIMBOT OFF"
	else
		ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		ToggleButton.Text = "AIMBOT ON"
	end
end

ToggleButton.MouseButton1Click:Connect(function()
	AimbotEnabled = not AimbotEnabled
	UpdateButton()
end)

ListToggle.MouseButton1Click:Connect(function()
	ListOpen = not ListOpen
	PlayerFrame.Visible = ListOpen
	ListToggle.Text = ListOpen and "PLAYERS ▼" or "PLAYERS ►"
end)

local function RefreshPlayers()
	for _, v in PlayerFrame:GetChildren() do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	for _, player in Players:GetPlayers() do
		if player ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextScaled = true
			btn.Text = player.Name
			btn.Parent = PlayerFrame

			btn.MouseButton1Click:Connect(function()
				SelectedPlayer = player
			end)
		end
	end

	PlayerFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

RefreshPlayers()

local function GetTargetHRP()
	if not SelectedPlayer then return nil end
	local char = SelectedPlayer.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

RunService.RenderStepped:Connect(function()
	if not AimbotEnabled then return end

	local targetHRP = GetTargetHRP()
	if targetHRP then
		Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetHRP.Position)
	end
end)

UpdateButton()

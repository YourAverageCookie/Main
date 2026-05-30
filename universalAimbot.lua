local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

------------------------------------------------
-- 🔐 SECRET SETUP
------------------------------------------------
local secrets = Instance.new("Folder", RS)
secrets.Name = "Secrets"

local SSC = Instance.new("StringValue", secrets)
SSC.Name = "SuperSecretCode"
SSC.Value = "NahIdWin"

local SecretKey = SSC.Value

------------------------------------------------
-- 🔐 LOGIN GUI
------------------------------------------------
local LockGui = Instance.new("ScreenGui")
LockGui.Name = "SSC_Lock"
LockGui.ResetOnSpawn = false
LockGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 190)
Frame.Position = UDim2.new(0.5, -160, 0.5, -95)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Parent = LockGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "What's the Super Secret Code? 🤫"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 40)
TextBox.Position = UDim2.new(0.05, 0, 0.45, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.PlaceholderText = "Enter code..."
TextBox.Font = Enum.Font.SourceSansBold
TextBox.TextScaled = true
TextBox.Parent = Frame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9, 0, 0, 35)
Button.Position = UDim2.new(0.05, 0, 0.78, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Font = Enum.Font.FredokaOne
Button.TextScaled = true
Button.Text = "Enter"
Button.Parent = Frame
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

------------------------------------------------
-- 🚀 ADMIN PANEL FUNCTION
------------------------------------------------
local function initAdmin()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 200, 0, 420)
Container.Position = UDim2.new(0, 20, 0, 20)
Container.BackgroundTransparency = 1
Container.Parent = ScreenGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 6)

------------------------------------------------
-- LIST MAKER
------------------------------------------------
local function MakeList(title, color)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, 0, 0, 25)
toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextScaled = true
toggle.Text = title .. " ▼"
toggle.Parent = Container

local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(1, 0, 0, 140)
frame.BackgroundColor3 = color
frame.BorderSizePixel = 0
frame.ScrollBarThickness = 6
frame.Parent = Container

Instance.new("UIListLayout", frame)

local open = true
toggle.MouseButton1Click:Connect(function()
	open = not open
	frame.Visible = open
	toggle.Text = open and (title .. " ▼") or (title .. " ►")
end)

return frame
end

local AimbotList = MakeList("AIMBOT", Color3.fromRGB(40, 90, 255))
local TeleportList = MakeList("TELEPORT", Color3.fromRGB(0, 170, 255))

------------------------------------------------
-- DRAG SYSTEM
------------------------------------------------
local dragging, dragStart, startPos

------------------------------------------------
-- REFRESH PLAYERS
------------------------------------------------
local SelectedAimbotPlayer
local SelectedTeleportPlayer
local AimbotEnabled = false

local function Refresh()

for _, v in AimbotList:GetChildren() do
	if v:IsA("TextButton") then v:Destroy() end
end

for _, v in TeleportList:GetChildren() do
	if v:IsA("TextButton") then v:Destroy() end
end

for _, p in Players:GetPlayers() do
	if p ~= LocalPlayer then

		local b1 = Instance.new("TextButton")
		b1.Size = UDim2.new(1, -10, 0, 30)
		b1.Text = p.Name
		b1.Parent = AimbotList
		b1.MouseButton1Click:Connect(function()
			SelectedAimbotPlayer = p
		end)

		local b2 = Instance.new("TextButton")
		b2.Size = UDim2.new(1, -10, 0, 30)
		b2.Text = p.Name
		b2.Parent = TeleportList
		b2.MouseButton1Click:Connect(function()
			SelectedTeleportPlayer = p
		end)

	end
end
end

Players.PlayerAdded:Connect(Refresh)
Players.PlayerRemoving:Connect(Refresh)
Refresh()

------------------------------------------------
-- TOGGLES + AIM
------------------------------------------------
RunService.RenderStepped:Connect(function()
if not AimbotEnabled then return end

local char = SelectedAimbotPlayer and SelectedAimbotPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")

if hrp then
Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, hrp.Position)
end
end)

------------------------------------------------
-- TELEPORT BUTTON
------------------------------------------------
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(1, 0, 0, 45)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TeleportButton.Text = "TELEPORT"
TeleportButton.Parent = Container

------------------------------------------------
-- DRAG HANDLE
------------------------------------------------
local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 45)
DragHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
DragHandle.Text = "AIMBOT OFF"
DragHandle.TextColor3 = Color3.fromRGB(255,255,255)
DragHandle.Font = Enum.Font.FredokaOne
DragHandle.TextScaled = true
DragHandle.Parent = Container

------------------------------------------------
-- BUTTON LOGIC
------------------------------------------------
DragHandle.MouseButton1Click:Connect(function()
AimbotEnabled = not AimbotEnabled
DragHandle.Text = AimbotEnabled and "AIMBOT ON" or "AIMBOT OFF"
DragHandle.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
end)

TeleportButton.MouseButton1Click:Connect(function()
local char = SelectedTeleportPlayer and SelectedTeleportPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")

local my = LocalPlayer.Character
local myHRP = my and my:FindFirstChild("HumanoidRootPart")

if hrp and myHRP then
myHRP.CFrame = hrp.CFrame + Vector3.new(2,0,0)
end
end)

end

------------------------------------------------
-- 🔓 LOGIN CHECK
------------------------------------------------
Button.MouseButton1Click:Connect(function()
if TextBox.Text == SecretKey then
LockGui:Destroy()
initAdmin()
else
Button.Text = "Wrong Code"
task.wait(1)
Button.Text = "Enter"
end
end)

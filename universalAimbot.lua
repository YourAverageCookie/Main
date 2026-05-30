local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- SECURE STORAGE
local secrets = Instance.new("Folder")
secrets.Name = "Secrets"
secrets.Parent = RS

local SSC = Instance.new("StringValue")
SSC.Name = "SuperSecretCode"
SSC.Value = "NahIdWin"
SSC.Parent = secrets

local SecretKey = SSC.Value

-- STATE
local SelectedAimbotPlayer = nil
local AimbotEnabled = false

----------------------------------------------------------------
-- 🔐 SSC LOGIN GUI
----------------------------------------------------------------
local LockGui = Instance.new("ScreenGui")
LockGui.Name = "SSC_Lock"
LockGui.ResetOnSpawn = false
LockGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local LockFrame = Instance.new("Frame")
LockFrame.Size = UDim2.new(0, 300, 0, 180)
LockFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
LockFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LockFrame.Parent = LockGui
Instance.new("UICorner", LockFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "What's the Super Secret Code? 🤫"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true
Title.Parent = LockFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 40)
TextBox.Position = UDim2.new(0.05, 0, 0.4, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.PlaceholderText = "Enter Code..."
TextBox.Font = Enum.Font.FredokaOne
TextBox.TextScaled = true
TextBox.Parent = LockFrame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9, 0, 0, 35)
Button.Position = UDim2.new(0.05, 0, 0.75, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Font = Enum.Font.FredokaOne
Button.TextScaled = true
Button.Text = "Enter"
Button.Parent = LockFrame
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

----------------------------------------------------------------
-- 🚀 ADMIN PANEL
----------------------------------------------------------------
local function initAdmin()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 180, 0, 420)
Container.Position = UDim2.new(0, 20, 0, 20)
Container.BackgroundTransparency = 1
Container.Parent = ScreenGui

-- DRAG HANDLE / AIMBOT TOGGLE
local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 45)
DragHandle.BackgroundColor3 = Color3.fromRGB(255,0,0)
DragHandle.Text = "AIMBOT OFF"
DragHandle.TextColor3 = Color3.fromRGB(255,255,255)
DragHandle.Font = Enum.Font.FredokaOne
DragHandle.TextScaled = true
DragHandle.Parent = Container
Instance.new("UICorner", DragHandle).CornerRadius = UDim.new(0,10)

-- LIST MAKER
local function MakeList(y, color, title)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,0,0,25)
toggle.Position = UDim2.new(0,0,0,y)
toggle.Text = title.." ▼"
toggle.Parent = Container

local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(1,0,0,260)
frame.Position = UDim2.new(0,0,0,y+25)
frame.BackgroundColor3 = color
frame.ScrollBarThickness = 6
frame.BorderSizePixel = 0
frame.Parent = Container

local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.Padding = UDim.new(0,4)

local open = true
toggle.MouseButton1Click:Connect(function()
open = not open
frame.Visible = open
toggle.Text = open and (title.." ▼") or (title.." ►")
end)

return frame
end

-- ONLY ONE LIST NOW
local AimbotList = MakeList(105, Color3.fromRGB(40,90,255), "AIMBOT")

----------------------------------------------------------------
-- PLAYER STATE
----------------------------------------------------------------
local function Refresh()

for _,v in AimbotList:GetChildren() do
if v:IsA("TextButton") then v:Destroy() end
end

for _,p in Players:GetPlayers() do
if p ~= LocalPlayer then

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1,-10,0,30)
btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.SourceSansBold
btn.TextScaled = true
btn.Text = p.Name
btn.Parent = AimbotList

btn.MouseButton1Click:Connect(function()
SelectedAimbotPlayer = p
end)

end
end
end

Players.PlayerAdded:Connect(Refresh)
Players.PlayerRemoving:Connect(Refresh)
task.wait(0.2)
Refresh()

----------------------------------------------------------------
-- AIMBOT
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
if not AimbotEnabled then return end

local char = SelectedAimbotPlayer and SelectedAimbotPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")

if hrp then
Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, hrp.Position)
end
end)

-- TOGGLE
DragHandle.MouseButton1Click:Connect(function()
	AimbotEnabled = not AimbotEnabled

	if AimbotEnabled then
		DragHandle.Text = "AIMBOT ON"
		DragHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- green
	else
		DragHandle.Text = "AIMBOT OFF"
		DragHandle.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- red
	end
end)

----------------------------------------------------------------
-- LOGIN CHECK
----------------------------------------------------------------
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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- 🔐 SSC SETUP
------------------------------------------------
local RS = game:GetService("ReplicatedStorage")

local secrets = Instance.new("Folder")
secrets.Name = "Secrets"
secrets.Parent = RS

local SSC = Instance.new("StringValue")
SSC.Name = "SuperSecretCode"
SSC.Value = "NahIdWin"
SSC.Parent = secrets

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
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Parent = LockGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "What's the Super Secret Code? 🤫"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9,0,0,40)
TextBox.Position = UDim2.new(0.05,0,0.45,0)
TextBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.PlaceholderText = "Enter code..."
TextBox.Font = Enum.Font.SourceSansBold
TextBox.TextScaled = true
TextBox.Parent = Frame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0,6)

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9,0,0,35)
Button.Position = UDim2.new(0.05,0,0.78,0)
Button.BackgroundColor3 = Color3.fromRGB(0,170,255)
Button.Text = "Enter"
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Font = Enum.Font.FredokaOne
Button.TextScaled = true
Button.Parent = Frame
Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)

------------------------------------------------
-- 🎮 ADMIN PANEL
------------------------------------------------
local function initAdmin()

local Gui = Instance.new("ScreenGui")
Gui.Name = "AdminGui"
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 220, 0, 420)
Container.Position = UDim2.new(0, 20, 0, 20)
Container.BackgroundTransparency = 1
Container.Parent = Gui

local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.Padding = UDim.new(0, 6)

------------------------------------------------
-- LIST SYSTEM (FIXED)
------------------------------------------------
local function MakeList(title, color)

local header = Instance.new("TextButton")
header.Size = UDim2.new(1,0,0,25)
header.BackgroundColor3 = Color3.fromRGB(30,30,30)
header.TextColor3 = Color3.fromRGB(255,255,255)
header.Font = Enum.Font.SourceSansBold
header.TextScaled = true
header.Text = title .. " ▼"
header.Parent = Container

local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(1,0,0,260)
frame.BackgroundColor3 = color
frame.BorderSizePixel = 0
frame.ScrollBarThickness = 6
frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
frame.Parent = Container

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 4)
list.Parent = frame

local open = true
header.MouseButton1Click:Connect(function()
open = not open
frame.Visible = open
header.Text = open and (title.." ▼") or (title.." ►")
end)

return frame
end

------------------------------------------------
-- PLAYERS LIST
------------------------------------------------
local PlayerList = MakeList("PLAYERS", Color3.fromRGB(60,120,255))

local SelectedPlayer = nil

local function Refresh()

for _,v in PlayerList:GetChildren() do
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
btn.Parent = PlayerList

btn.MouseButton1Click:Connect(function()
SelectedPlayer = p
print("Selected:", p.Name)
end)

end
end
end

Players.PlayerAdded:Connect(Refresh)
Players.PlayerRemoving:Connect(Refresh)
task.wait(0.2)
Refresh()

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

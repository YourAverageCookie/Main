local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

------------------------------------------------
-- SECURE STORAGE
------------------------------------------------
local secrets = Instance.new("Folder")
secrets.Name = "Secrets"
secrets.Parent = RS

local SSC = Instance.new("StringValue")
SSC.Name = "SuperSecretCode"
SSC.Value = "NahIdWin"
SSC.Parent = secrets

local SecretKey = SSC.Value

------------------------------------------------
-- STATE
------------------------------------------------
local SelectedAimbotPlayer = nil
local AimbotEnabled = false

------------------------------------------------
-- LOGIN GUI
------------------------------------------------
local LockGui = Instance.new("ScreenGui")
LockGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local LockFrame = Instance.new("Frame")
LockFrame.Size = UDim2.new(0,300,0,180)
LockFrame.Position = UDim2.new(0.5,-150,0.5,-90)
LockFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
LockFrame.Parent = LockGui
Instance.new("UICorner", LockFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "What's the Super Secret Code? 🤫"
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = LockFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9,0,0,40)
TextBox.Position = UDim2.new(0.05,0,0.4,0)
TextBox.PlaceholderText = "Enter Code..."
TextBox.Font = Enum.Font.FredokaOne
TextBox.TextScaled = true
TextBox.Parent = LockFrame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9,0,0,35)
Button.Position = UDim2.new(0.05,0,0.75,0)
Button.Text = "Enter"
Button.Font = Enum.Font.FredokaOne
Button.TextScaled = true
Button.BackgroundColor3 = Color3.fromRGB(0,170,255)
Button.Parent = LockFrame

------------------------------------------------
-- ADMIN PANEL
------------------------------------------------
local function initAdmin()

local Gui = Instance.new("ScreenGui")
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0,200,0,420)
Container.Position = UDim2.new(0,20,0,20)
Container.BackgroundTransparency = 1
Container.Parent = Gui

------------------------------------------------
-- DRAG DETECTOR 
------------------------------------------------
local DragBar = Instance.new("TextButton")
DragBar.Size = UDim2.new(1,0,0,35)
DragBar.Text = "DRAG"
DragBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
DragBar.TextColor3 = Color3.new(1,1,1)
DragBar.Parent = Container

Instance.new("UICorner", DragBar)

local success, dragDetector = pcall(function()
    local dd = Instance.new("DragDetector")
    dd.Parent = DragBar
    return dd
end)

local dragging = false
local dragStart
local startPos

if success and dragDetector then
    dragDetector.DragStart:Connect(function(input)
        dragging = true
        dragStart = input.Position
        startPos = Container.Position
    end)

    dragDetector.DragEnd:Connect(function()
        dragging = false
    end)

    dragDetector.DragContinue:Connect(function(input)
        if not dragging then return end

        local delta = input.Position - dragStart
        Container.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end)
else
    -- 🔁 fallback (old reliable method)
    DragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Container.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Container.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function()
        dragging = false
    end)
  end

------------------------------------------------
-- TOGGLE BUTTON
------------------------------------------------
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1,0,0,40)
Toggle.Position = UDim2.new(0,0,0,40)
Toggle.Text = "AIMBOT OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
Toggle.Font = Enum.Font.FredokaOne
Toggle.TextScaled = true
Toggle.Parent = Container

------------------------------------------------
-- LIST (UNDER BUTTON FIXED)
------------------------------------------------
local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1,0,0,330)
List.Position = UDim2.new(0,0,0,80)
List.BackgroundColor3 = Color3.fromRGB(40,90,255)
List.ScrollBarThickness = 6
List.Parent = Container

local layout = Instance.new("UIListLayout")
layout.Parent = List
layout.Padding = UDim.new(0,4)

------------------------------------------------
-- REFRESH PLAYERS FIXED
------------------------------------------------
local function Refresh()
for _,v in List:GetChildren() do
if v:IsA("TextButton") then v:Destroy() end
end

for _,p in Players:GetPlayers() do
if p ~= LocalPlayer then

local b = Instance.new("TextButton")
b.Size = UDim2.new(1,-10,0,30)
b.Text = p.Name
b.Font = Enum.Font.SourceSansBold
b.TextScaled = true
b.Parent = List

b.MouseButton1Click:Connect(function()
SelectedAimbotPlayer = p
end)

end
end

List.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(Refresh)
Players.PlayerRemoving:Connect(Refresh)
task.wait(0.2)
Refresh()

------------------------------------------------
-- AIM
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
-- TOGGLE LOGIC
------------------------------------------------
Toggle.MouseButton1Click:Connect(function()
AimbotEnabled = not AimbotEnabled

if AimbotEnabled then
Toggle.Text = "AIMBOT ON"
Toggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
else
Toggle.Text = "AIMBOT OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
end
end)

end

------------------------------------------------
-- LOGIN CHECK
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

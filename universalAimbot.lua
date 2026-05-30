local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local secrets = Instance.new("Folder", RS)
secrets.Name = "Secrets"

local SSC = Instance.new("StringValue", secrets)
SSC.Name = "SuperSecretCode"
SSC.Value = "NahIdWin"

local SecretKey = SSC.Value

local SelectedAimbotPlayer = nil
local SelectedTeleportPlayer = nil
local AimbotEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 180, 0, 420)
Container.Position = UDim2.new(0, 20, 0, 20)
Container.BackgroundTransparency = 1
Container.Parent = ScreenGui

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, 0, 0, 45)
DragHandle.Position = UDim2.new(0, 0, 0, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
DragHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
DragHandle.Font = Enum.Font.FredokaOne
DragHandle.TextScaled = true
DragHandle.Text = "AIMBOT OFF"
DragHandle.Parent = Container

Instance.new("UICorner", DragHandle).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", DragHandle)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 0, 0)

-- TELEPORT BUTTON
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(1, 0, 0, 45)
TeleportButton.Position = UDim2.new(0, 0, 0, 50)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.FredokaOne
TeleportButton.TextScaled = true
TeleportButton.Text = "TELEPORT"
TeleportButton.Parent = Container

Instance.new("UICorner", TeleportButton).CornerRadius = UDim.new(0, 10)

-- ✅ BLACK STROKE (FIX REQUEST)
local tpStroke = Instance.new("UIStroke", TeleportButton)
tpStroke.Thickness = 2
tpStroke.Color = Color3.fromRGB(0, 0, 0)

-- LIST MAKER
local function MakeList(y, color, title)
local open = true

local toggle = Instance.new("TextButton")  
toggle.Size = UDim2.new(1, 0, 0, 25)  
toggle.Position = UDim2.new(0, 0, 0, y)  
toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)  
toggle.Font = Enum.Font.SourceSansBold  
toggle.TextScaled = true  
toggle.Text = title .. " ▼"  
toggle.Parent = Container  

local frame = Instance.new("ScrollingFrame")  
frame.Size = UDim2.new(1, 0, 0, 140)  
frame.Position = UDim2.new(0, 0, 0, y + 25)  
frame.BackgroundColor3 = color  
frame.BorderSizePixel = 0  
frame.ScrollBarThickness = 6  
frame.Parent = Container  

local layout = Instance.new("UIListLayout", frame)  

toggle.MouseButton1Click:Connect(function()  
    open = not open  
    frame.Visible = open  
    toggle.Text = open and (title .. " ▼") or (title .. " ►")  
end)  

return frame, layout, toggle, frame

end

-- ✅ FIXED AUTO STACK POSITIONING
local AimbotList, layout1 = MakeList(105, Color3.fromRGB(40, 90, 255), "AIMBOT")

local gap = 0.5
local TeleportList, layout2 = MakeList(
105 + 25 + 140 + gap,
Color3.fromRGB(0, 170, 255),
"TELEPORT"
)

-- DRAG SYSTEM
local dragging = false
local dragStart
local startPos

DragHandle.InputBegan:Connect(function(input)
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

-- REFRESH LISTS
local function RefreshLists()

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
        b1.BackgroundColor3 = Color3.fromRGB(0, 120, 255)  
        b1.TextColor3 = Color3.fromRGB(255,255,255)  
        b1.Font = Enum.Font.SourceSansBold  
        b1.TextScaled = true  
        b1.Text = p.Name  
        b1.Parent = AimbotList  

        b1.MouseButton1Click:Connect(function()  
            SelectedAimbotPlayer = p  
        end)  

        local b2 = Instance.new("TextButton")  
        b2.Size = UDim2.new(1, -10, 0, 30)  
        b2.BackgroundColor3 = Color3.fromRGB(0, 200, 255)  
        b2.TextColor3 = Color3.fromRGB(255,255,255)  
        b2.Font = Enum.Font.SourceSansBold  
        b2.TextScaled = true  
        b2.Text = p.Name  
        b2.Parent = TeleportList  

        b2.MouseButton1Click:Connect(function()  
            SelectedTeleportPlayer = p  
        end)  
    end  
end  

AimbotList.CanvasSize = UDim2.new(0,0,0,layout1.AbsoluteContentSize.Y)  
TeleportList.CanvasSize = UDim2.new(0,0,0,layout2.AbsoluteContentSize.Y)

end

Players.PlayerAdded:Connect(RefreshLists)
Players.PlayerRemoving:Connect(RefreshLists)
RefreshLists()

-- TOGGLES
DragHandle.MouseButton1Click:Connect(function()
AimbotEnabled = not AimbotEnabled
DragHandle.Text = AimbotEnabled and "AIMBOT ON" or "AIMBOT OFF"
DragHandle.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
end)

TeleportButton.MouseButton1Click:Connect(function()
local char = SelectedTeleportPlayer and SelectedTeleportPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")

local myChar = LocalPlayer.Character  
local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")  

if hrp and myHRP then  
    myHRP.CFrame = hrp.CFrame + Vector3.new(2,0,0)  
end

end)

-- AIM
RunService.RenderStepped:Connect(function()
if not AimbotEnabled then return end

local char = SelectedAimbotPlayer and SelectedAimbotPlayer.Character  
local hrp = char and char:FindFirstChild("HumanoidRootPart")  

if hrp then  
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, hrp.Position)  
end

end)

Button.MouseButton1Click:Connect(function()
    if TextBox.Text == SecretKey then
        ScreenGui:Destroy()
        initAdmin()
    else
        Button.Text = "Wrong Code"
        task.wait(1)
        Button.Text = "Enter"
    end
end)

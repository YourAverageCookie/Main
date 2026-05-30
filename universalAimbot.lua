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
SSC.Value = "MueedMightBeTheGoat"

local SecretKey = game.ReplicatedStorage:WaitForChild("Secrets"):WaitForChild("SuperSecretCode").Value

local SelectedAimbotPlayer = nil
local SelectedTeleportPlayer = nil
local AimbotEnabled = false

------------------------------------------------
-- 🔐 START GUI (KEY SYSTEM)
------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StartGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 20)
TextBox.PlaceholderText = "Enter Secret Code"
TextBox.Text = ""
TextBox.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 80)
Button.Text = "Enter"
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.Parent = Frame

Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

------------------------------------------------
-- 🧠 YOUR ADMIN UI FUNCTION
------------------------------------------------

local function initAdmin()

    local ScreenGui2 = Instance.new("ScreenGui")
    ScreenGui2.Name = "AdminGui"
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0, 180, 0, 420)
    Container.Position = UDim2.new(0, 20, 0, 20)
    Container.BackgroundTransparency = 1
    Container.Parent = ScreenGui2

    -- DRAG HANDLE
    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1, 0, 0, 45)
    DragHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    DragHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
    DragHandle.Font = Enum.Font.FredokaOne
    DragHandle.TextScaled = true
    DragHandle.Text = "AIMBOT OFF"
    DragHandle.Parent = Container

    Instance.new("UICorner", DragHandle).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", DragHandle).Color = Color3.fromRGB(0,0,0)

    -- TELEPORT BUTTON
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Size = UDim2.new(1, 0, 0, 45)
    TeleportButton.Position = UDim2.new(0, 0, 0, 50)
    TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TeleportButton.Text = "TELEPORT"
    TeleportButton.Parent = Container

    Instance.new("UICorner", TeleportButton).CornerRadius = UDim.new(0, 10)
    local tpStroke = Instance.new("UIStroke", TeleportButton)
    tpStroke.Color = Color3.fromRGB(0,0,0)

    -- LIST MAKER
    local function MakeList(y, color, title)
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(1,0,0,25)
        toggle.Position = UDim2.new(0,0,0,y)
        toggle.Text = title
        toggle.Parent = Container

        local frame = Instance.new("ScrollingFrame")
        frame.Size = UDim2.new(1,0,0,140)
        frame.Position = UDim2.new(0,0,0,y+25)
        frame.BackgroundColor3 = color
        frame.Parent = Container

        local layout = Instance.new("UIListLayout", frame)

        return frame, layout
    end

    local AimbotList, layout1 = MakeList(105, Color3.fromRGB(40,90,255), "AIMBOT")

    local gap = 10
    local TeleportList, layout2 = MakeList(270, Color3.fromRGB(0,170,255), "TELEPORT")

    -- AIM
    RunService.RenderStepped:Connect(function()
        if not AimbotEnabled then return end
        local char = SelectedAimbotPlayer and SelectedAimbotPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, hrp.Position)
        end
    end)

end

------------------------------------------------
-- 🔓 KEY CHECK
------------------------------------------------

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

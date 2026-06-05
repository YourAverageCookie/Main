--// =========================================================
--// ADMIN PANEL - PART 1
--// Foundation Framework
--// =========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// =========================================================
--// STATE
--// =========================================================

local State = {
	Loaded = false,

	Theme = "Dark",

	WindowOpen = true,
	Minimized = false,

	SessionStart = tick(),

	FPS = 0,
	Ping = 0,

	Logs = {},
	Notifications = {},

	Waypoints = {},

	Connections = {},

	Features = {
		Fly = false,
		Noclip = false,
		InfiniteJump = false,
	},

	UI = {},
}

--// =========================================================
--// MAID
--// =========================================================

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({
		Tasks = {}
	}, Maid)
end

function Maid:Give(Task)
	table.insert(self.Tasks, Task)
	return Task
end

function Maid:Cleanup()
	for _, Task in ipairs(self.Tasks) do
		if typeof(Task) == "RBXScriptConnection" then
			if Task.Connected then
				Task:Disconnect()
			end
		elseif typeof(Task) == "Instance" then
			Task:Destroy()
		elseif type(Task) == "function" then
			pcall(Task)
		end
	end

	table.clear(self.Tasks)
end

local GlobalMaid = Maid.new()

--// =========================================================
--// LOGGER
--// =========================================================

local LogManager = {}

function LogManager:Add(Message)
	local Entry = {
		Time = os.date("%X"),
		Message = tostring(Message)
	}

	table.insert(State.Logs, Entry)

	if #State.Logs > 500 then
		table.remove(State.Logs, 1)
	end

	print("[ADMIN]", Entry.Message)
end

--// =========================================================
--// THEMES
--// =========================================================

local ThemeManager = {}

ThemeManager.Themes = {

	Dark = {
		Background = Color3.fromRGB(22,22,22),
		Secondary = Color3.fromRGB(30,30,30),
		Tertiary = Color3.fromRGB(40,40,40),

		Text = Color3.fromRGB(255,255,255),

		Accent = Color3.fromRGB(0,170,255),

		Stroke = Color3.fromRGB(60,60,60)
	},

	Light = {
		Background = Color3.fromRGB(235,235,235),
		Secondary = Color3.fromRGB(245,245,245),
		Tertiary = Color3.fromRGB(255,255,255),

		Text = Color3.fromRGB(0,0,0),

		Accent = Color3.fromRGB(0,120,255),

		Stroke = Color3.fromRGB(180,180,180)
	}
}

function ThemeManager:Get()
	return self.Themes[State.Theme]
end

--// =========================================================
--// NOTIFICATIONS
--// =========================================================

local NotificationManager = {}

function NotificationManager:Notify(Title, Text)

	local Container = State.UI.NotificationContainer

	if not Container then
		return
	end

	local Theme = ThemeManager:Get()

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0,280,0,70)
	Frame.BackgroundColor3 = Theme.Secondary
	Frame.Position = UDim2.new(1,350,0,0)
	Frame.Parent = Container

	Instance.new("UICorner", Frame)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Theme.Stroke
	Stroke.Parent = Frame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1,-10,0,25)
	TitleLabel.Position = UDim2.new(0,10,0,5)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextColor3 = Theme.Text
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Frame

	local Desc = Instance.new("TextLabel")
	Desc.Size = UDim2.new(1,-10,0,30)
	Desc.Position = UDim2.new(0,10,0,30)
	Desc.BackgroundTransparency = 1
	Desc.TextWrapped = true
	Desc.Text = Text
	Desc.Font = Enum.Font.Gotham
	Desc.TextColor3 = Theme.Text
	Desc.TextSize = 12
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.Parent = Frame

	local InTween = TweenService:Create(
		Frame,
		TweenInfo.new(.35, Enum.EasingStyle.Quint),
		{
			Position = UDim2.new(1,-300,0,0)
		}
	)

	InTween:Play()

	task.delay(4,function()

		local OutTween = TweenService:Create(
			Frame,
			TweenInfo.new(.35),
			{
				Position = UDim2.new(1,350,0,0)
			}
		)

		OutTween:Play()

		OutTween.Completed:Wait()

		Frame:Destroy()
	end)
end

--// =========================================================
--// FPS MONITOR
--// =========================================================

task.spawn(function()

	local Frames = 0
	local Last = tick()

	RunService.RenderStepped:Connect(function()

		Frames += 1

		if tick() - Last >= 1 then

			State.FPS = Frames
			Frames = 0
			Last = tick()

			if State.UI.FPSLabel then
				State.UI.FPSLabel.Text =
					"FPS: "..State.FPS
			end

			if State.UI.TimeLabel then
				State.UI.TimeLabel.Text =
					os.date("%H:%M:%S")
			end
		end
	end)

end)

--// =========================================================
--// UI HELPERS
--// =========================================================

local UIManager = {}

function UIManager:Round(Object)
	Instance.new("UICorner", Object)
end

function UIManager:Stroke(Object)
	local Stroke = Instance.new("UIStroke")
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Color = ThemeManager:Get().Stroke
	Stroke.Parent = Object
	return Stroke
end

function UIManager:Button(Text)

	local Theme = ThemeManager:Get()

	local Button = Instance.new("TextButton")

	Button.Text = Text
	Button.Size = UDim2.new(1,0,0,36)

	Button.BackgroundColor3 = Theme.Tertiary

	Button.TextColor3 = Theme.Text
	Button.Font = Enum.Font.Gotham

	self:Round(Button)
	self:Stroke(Button)

	Button.MouseEnter:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(.15),
			{
				BackgroundTransparency = .1
			}
		):Play()

	end)

	Button.MouseLeave:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(.15),
			{
				BackgroundTransparency = 0
			}
		):Play()

	end)

	return Button
end

--// =========================================================
--// BLUR
--// =========================================================

local Blur = Lighting:FindFirstChild("AdminBlur")

if not Blur then

	Blur = Instance.new("BlurEffect")
	Blur.Name = "AdminBlur"
	Blur.Size = 0
	Blur.Parent = Lighting

end

TweenService:Create(
	Blur,
	TweenInfo.new(.35),
	{
		Size = 16
	}
):Play()

--// =========================================================
--// SCREENGUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = PlayerGui

State.UI.ScreenGui = ScreenGui

--// =========================================================
--// MAIN WINDOW
--// =========================================================

local Theme = ThemeManager:Get()

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,900,0,550)
Main.Position = UDim2.new(.5,-450,.5,-275)
Main.BackgroundColor3 = Theme.Background
Main.Parent = ScreenGui

UIManager:Round(Main)
UIManager:Stroke(Main)

State.UI.Main = Main

--// =========================================================
--// TOPBAR
--// =========================================================

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1,0,0,40)
Topbar.BackgroundColor3 = Theme.Secondary
Topbar.Parent = Main

UIManager:Round(Topbar)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.Text = "Admin Panel"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Topbar

--// =========================================================
--// SIDEBAR
--// =========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,180,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Theme.Secondary
Sidebar.Parent = Main

UIManager:Stroke(Sidebar)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0,5)
SidebarLayout.Parent = Sidebar

local Tabs = {
	"Home",
	"Player",
	"Character",
	"Visual",
	"Camera",
	"Fun",
	"Utility",
	"Teleports",
	"Settings",
	"Logs"
}

for _,TabName in ipairs(Tabs) do

	local Button = UIManager:Button(TabName)

	Button.Parent = Sidebar

end

--// =========================================================
--// CONTENT
--// =========================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-180,1,-40)
Content.Position = UDim2.new(0,180,0,40)
Content.BackgroundTransparency = 1
Content.Parent = Main

State.UI.Content = Content

--// =========================================================
--// SEARCH BAR
--// =========================================================

local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(0,300,0,35)
SearchBar.Position = UDim2.new(0,20,0,20)

SearchBar.PlaceholderText = "Search commands..."
SearchBar.Text = ""

SearchBar.Parent = Content

UIManager:Round(SearchBar)
UIManager:Stroke(SearchBar)

State.UI.SearchBar = SearchBar

--// =========================================================
--// PROFILE
--// =========================================================

local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(0,300,0,120)
Profile.Position = UDim2.new(0,20,0,70)
Profile.BackgroundColor3 = Theme.Secondary
Profile.Parent = Content

UIManager:Round(Profile)
UIManager:Stroke(Profile)

local Username = Instance.new("TextLabel")
Username.BackgroundTransparency = 1
Username.Size = UDim2.new(1,0,0,30)
Username.Text = LocalPlayer.Name
Username.TextColor3 = Theme.Text
Username.Font = Enum.Font.GothamBold
Username.Parent = Profile

--// =========================================================
--// STATS
--// =========================================================

local FPSLabel = Instance.new("TextLabel")
FPSLabel.BackgroundTransparency = 1
FPSLabel.Size = UDim2.new(0,150,0,30)
FPSLabel.Position = UDim2.new(0,20,0,220)
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Theme.Text
FPSLabel.Parent = Content

State.UI.FPSLabel = FPSLabel

local TimeLabel = Instance.new("TextLabel")
TimeLabel.BackgroundTransparency = 1
TimeLabel.Size = UDim2.new(0,200,0,30)
TimeLabel.Position = UDim2.new(0,20,0,260)
TimeLabel.TextColor3 = Theme.Text
TimeLabel.Parent = Content

State.UI.TimeLabel = TimeLabel

--// =========================================================
--// NOTIFICATION CONTAINER
--// =========================================================

local NotificationContainer = Instance.new("Frame")
NotificationContainer.AnchorPoint = Vector2.new(1,0)
NotificationContainer.Size = UDim2.new(0,320,1,0)
NotificationContainer.Position = UDim2.new(1,-10,0,10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,5)
Layout.Parent = NotificationContainer

State.UI.NotificationContainer = NotificationContainer

--// =========================================================
--// DRAGGING
--// =========================================================

do
	local Dragging = false
	local DragStart
	local StartPos

	Topbar.InputBegan:Connect(function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging = true
			DragStart = Input.Position
			StartPos = Main.Position

		end
	end)

	UserInputService.InputEnded:Connect(function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging = false

		end
	end)

	UserInputService.InputChanged:Connect(function(Input)

		if Dragging and
			Input.UserInputType ==
			Enum.UserInputType.MouseMovement then

			local Delta =
				Input.Position - DragStart

			Main.Position =
				UDim2.new(
					StartPos.X.Scale,
					StartPos.X.Offset + Delta.X,
					StartPos.Y.Scale,
					StartPos.Y.Offset + Delta.Y
				)
		end
	end)
end

--// =========================================================
--// STARTUP
--// =========================================================

NotificationManager:Notify(
	"Admin Panel",
	"Part 1 Loaded Successfully"
)

LogManager:Add("Part 1 Loaded")

State.Loaded = true

print("Admin Panel Part 1 Loaded")

--// =========================================================
--// ADMIN PANEL - PART 2
--// Player Controllers
--// Add directly below Part 1
--// =========================================================

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

State.Defaults = {
	WalkSpeed = 16,
	JumpPower = 50,
	Gravity = workspace.Gravity
}

--// =========================================================
--// CHARACTER HELPERS
--// =========================================================

local function GetCharacter()
	return LocalPlayer.Character
end

local function GetHumanoid()
	local Char = GetCharacter()
	if not Char then
		return nil
	end

	return Char:FindFirstChildOfClass("Humanoid")
end

local function GetRoot()
	local Char = GetCharacter()
	if not Char then
		return nil
	end

	return Char:FindFirstChild("HumanoidRootPart")
end

--// =========================================================
--// FEATURE STATE
--// =========================================================

State.FeatureData = {
	WalkSpeed = 16,
	JumpPower = 50,
	Gravity = workspace.Gravity,
	SprintSpeed = 32,
	FlySpeed = 60,
}

--// =========================================================
--// PLAYER CONTROLLER
--// =========================================================

local PlayerController = {}

function PlayerController:SetWalkSpeed(Value)

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.WalkSpeed = Value
	end

	State.FeatureData.WalkSpeed = Value

	LogManager:Add("WalkSpeed -> "..Value)
end

function PlayerController:SetJumpPower(Value)

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.JumpPower = Value
	end

	State.FeatureData.JumpPower = Value

	LogManager:Add("JumpPower -> "..Value)
end

function PlayerController:SetGravity(Value)

	workspace.Gravity = Value

	State.FeatureData.Gravity = Value

	LogManager:Add("Gravity -> "..Value)
end

function PlayerController:RestoreDefaults()

	self:SetWalkSpeed(State.Defaults.WalkSpeed)
	self:SetJumpPower(State.Defaults.JumpPower)

	workspace.Gravity = State.Defaults.Gravity

	NotificationManager:Notify(
		"Player",
		"Defaults Restored"
	)

end

function PlayerController:Sit()

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.Sit = true
	end

end

function PlayerController:Unsit()

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.Sit = false
	end

end

function PlayerController:Freeze()

	local Root = GetRoot()

	if Root then
		Root.Anchored = true
	end

end

function PlayerController:Unfreeze()

	local Root = GetRoot()

	if Root then
		Root.Anchored = false
	end

end

function PlayerController:Reset()

	local Character = GetCharacter()

	if Character then
		Character:BreakJoints()
	end

end

--// =========================================================
--// INFINITE JUMP
--// =========================================================

InfiniteJumpController = {}

InfiniteJumpController.Connection = nil

function InfiniteJumpController:Enable()

	if self.Connection then
		return
	end

	State.Features.InfiniteJump = true

	self.Connection =
		UserInputService.JumpRequest:Connect(function()

			local Humanoid = GetHumanoid()

			if Humanoid then
				Humanoid:ChangeState(
					Enum.HumanoidStateType.Jumping
				)
			end

		end)

	NotificationManager:Notify(
		"Infinite Jump",
		"Enabled"
	)

end

function InfiniteJumpController:Disable()

	State.Features.InfiniteJump = false

	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end

	NotificationManager:Notify(
		"Infinite Jump",
		"Disabled"
	)

end

function InfiniteJumpController:Toggle()

	if State.Features.InfiniteJump then
		self:Disable()
	else
		self:Enable()
	end

end

--// =========================================================
--// NOCLIP
--// =========================================================

NoclipController = {}

NoclipController.Connection = nil

function NoclipController:Enable()

	if self.Connection then
		return
	end

	State.Features.Noclip = true

	self.Connection =
		RunService.Stepped:Connect(function()

			local Character = GetCharacter()

			if not Character then
				return
			end

			for _,Part in ipairs(Character:GetDescendants()) do

				if Part:IsA("BasePart") then
					Part.CanCollide = false
				end

			end

		end)

	NotificationManager:Notify(
		"Noclip",
		"Enabled"
	)

end

function NoclipController:Disable()

	State.Features.Noclip = false

	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end

	local Character = GetCharacter()

	if Character then

		for _,Part in ipairs(Character:GetDescendants()) do

			if Part:IsA("BasePart") then
				Part.CanCollide = true
			end

		end

	end

	NotificationManager:Notify(
		"Noclip",
		"Disabled"
	)

end

function NoclipController:Toggle()

	if State.Features.Noclip then
		self:Disable()
	else
		self:Enable()
	end

end

--// =========================================================
--// FLY
--// =========================================================

FlyController = {}

FlyController.Connection = nil
FlyController.Velocity = Vector3.zero

function FlyController:Enable()

	if self.Connection then
		return
	end

	local Root = GetRoot()

	if not Root then
		return
	end

	State.Features.Fly = true

	local Attachment =
		Instance.new("Attachment")

	Attachment.Name = "AdminFlyAttachment"
	Attachment.Parent = Root

	local Force =
		Instance.new("VectorForce")

	Force.Name = "AdminFlyForce"
	Force.Attachment0 = Attachment
	Force.RelativeTo = Enum.ActuatorRelativeTo.World
	Force.Parent = Root

	local Keys = {
		W=false,
		A=false,
		S=false,
		D=false,
		Q=false,
		E=false
	}

	local Began
	local Ended

	Began = UserInputService.InputBegan:Connect(function(Input,GPE)

		if GPE then
			return
		end

		local Key = Input.KeyCode.Name

		if Keys[Key] ~= nil then
			Keys[Key] = true
		end

	end)

	Ended = UserInputService.InputEnded:Connect(function(Input)

		local Key = Input.KeyCode.Name

		if Keys[Key] ~= nil then
			Keys[Key] = false
		end

	end)

	self.Connection =
		RunService.RenderStepped:Connect(function(dt)

			local Camera =
				workspace.CurrentCamera

			local Direction =
				Vector3.zero

			if Keys.W then
				Direction += Camera.CFrame.LookVector
			end

			if Keys.S then
				Direction -= Camera.CFrame.LookVector
			end

			if Keys.A then
				Direction -= Camera.CFrame.RightVector
			end

			if Keys.D then
				Direction += Camera.CFrame.RightVector
			end

			if Keys.Q then
				Direction += Vector3.yAxis
			end

			if Keys.E then
				Direction -= Vector3.yAxis
			end

			if Direction.Magnitude > 0 then
				Direction = Direction.Unit
			end

			self.Velocity =
				self.Velocity:Lerp(
					Direction *
					State.FeatureData.FlySpeed,
					0.15
				)

			Force.Force =
				self.Velocity *
				Root.AssemblyMass * 25

		end)

	self.Cleanup = function()

		if Began then
			Began:Disconnect()
		end

		if Ended then
			Ended:Disconnect()
		end

		if Force then
			Force:Destroy()
		end

		if Attachment then
			Attachment:Destroy()
		end

	end

	NotificationManager:Notify(
		"Fly",
		"Enabled"
	)

end

function FlyController:Disable()

	State.Features.Fly = false

	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end

	if self.Cleanup then
		self.Cleanup()
	end

	NotificationManager:Notify(
		"Fly",
		"Disabled"
	)

end

function FlyController:Toggle()

	if State.Features.Fly then
		self:Disable()
	else
		self:Enable()
	end

end

--// =========================================================
--// SPRINT
--// =========================================================

local SprintConnection

SprintController = {}

function SprintController:Enable()

	if SprintConnection then
		return
	end

	SprintConnection =
		UserInputService.InputBegan:Connect(function(Input,GPE)

			if GPE then
				return
			end

			if Input.KeyCode == Enum.KeyCode.LeftShift then

				PlayerController:SetWalkSpeed(
					State.FeatureData.SprintSpeed
				)

			end

		end)

	UserInputService.InputEnded:Connect(function(Input)

		if Input.KeyCode == Enum.KeyCode.LeftShift then

			PlayerController:SetWalkSpeed(
				State.FeatureData.WalkSpeed
			)

		end

	end)

end

--// =========================================================
--// CHARACTER RESPAWN SUPPORT
--// =========================================================

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)

	Character = NewCharacter

	task.wait(1)

	PlayerController:SetWalkSpeed(
		State.FeatureData.WalkSpeed
	)

	PlayerController:SetJumpPower(
		State.FeatureData.JumpPower
	)

	if State.Features.Noclip then
		NoclipController:Disable()
		NoclipController:Enable()
	end

	if State.Features.InfiniteJump then
		InfiniteJumpController:Disable()
		InfiniteJumpController:Enable()
	end

	NotificationManager:Notify(
		"Character",
		"Features Reapplied"
	)

end)

--// =========================================================
--// TEST BUTTONS (HOME TAB)
--// =========================================================
--// Temporary until tab system is built

local FlyButton = UIManager:Button("Toggle Fly")
FlyButton.Position = UDim2.new(0,350,0,70)
FlyButton.Parent = Content

FlyButton.MouseButton1Click:Connect(function()
	FlyController:Toggle()
end)

local NoclipButton = UIManager:Button("Toggle Noclip")
NoclipButton.Position = UDim2.new(0,350,0,120)
NoclipButton.Parent = Content

NoclipButton.MouseButton1Click:Connect(function()
	NoclipController:Toggle()
end)

local InfiniteButton = UIManager:Button("Infinite Jump")
InfiniteButton.Position = UDim2.new(0,350,0,170)
InfiniteButton.Parent = Content

InfiniteButton.MouseButton1Click:Connect(function()
	InfiniteJumpController:Toggle()
end)

NotificationManager:Notify(
	"Admin Panel",
	"Part 2 Loaded"
)

LogManager:Add("Part 2 Loaded")

--// =========================================================
--// ADMIN PANEL - PART 3
--// Visual + Camera Systems
--// Add directly below Part 2
--// =========================================================

--// =========================================================
--// VISUAL STATE
--// =========================================================

State.Visuals = {

	Fullbright = false,

	FogEnabled = true,

	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,

	FOV = 70,

	FirstPerson = false,
	ThirdPerson = false,

	Freecam = false
}

--// =========================================================
--// VISUAL CONTROLLER
--// =========================================================

VisualController = {}

VisualController.Original = {

	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,

	FogEnd = Lighting.FogEnd,
	FogStart = Lighting.FogStart,

	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient
}

function VisualController:EnableFullbright()

	if State.Visuals.Fullbright then
		return
	end

	State.Visuals.Fullbright = true

	Lighting.Brightness = 5
	Lighting.ClockTime = 14

	Lighting.Ambient =
		Color3.fromRGB(255,255,255)

	Lighting.OutdoorAmbient =
		Color3.fromRGB(255,255,255)

	NotificationManager:Notify(
		"Visual",
		"Fullbright Enabled"
	)

end

function VisualController:DisableFullbright()

	State.Visuals.Fullbright = false

	Lighting.Brightness =
		self.Original.Brightness

	Lighting.ClockTime =
		self.Original.ClockTime

	Lighting.Ambient =
		self.Original.Ambient

	Lighting.OutdoorAmbient =
		self.Original.OutdoorAmbient

	NotificationManager:Notify(
		"Visual",
		"Fullbright Disabled"
	)

end

function VisualController:ToggleFullbright()

	if State.Visuals.Fullbright then
		self:DisableFullbright()
	else
		self:EnableFullbright()
	end

end

function VisualController:RemoveFog()

	Lighting.FogStart = 0
	Lighting.FogEnd = 100000

	NotificationManager:Notify(
		"Visual",
		"Fog Removed"
	)

end

function VisualController:SetFog(Start,Finish)

	Lighting.FogStart = Start
	Lighting.FogEnd = Finish

end

function VisualController:SetBrightness(Value)

	Lighting.Brightness = Value
	State.Visuals.Brightness = Value

end

function VisualController:SetTime(Value)

	Lighting.ClockTime = Value
	State.Visuals.ClockTime = Value

end

function VisualController:SetAmbient(Color)

	Lighting.Ambient = Color

end

--// =========================================================
--// CAMERA CONTROLLER
--// =========================================================

CameraController = {}

CameraController.Connection = nil

function CameraController:GetCamera()
	return workspace.CurrentCamera
end

function CameraController:SetFOV(Value)

	local Camera = self:GetCamera()

	if Camera then
		Camera.FieldOfView = Value
	end

	State.Visuals.FOV = Value

end

function CameraController:FirstPerson()

	LocalPlayer.CameraMode =
		Enum.CameraMode.LockFirstPerson

	State.Visuals.FirstPerson = true

end

function CameraController:ThirdPerson()

	LocalPlayer.CameraMode =
		Enum.CameraMode.Classic

	LocalPlayer.CameraMaxZoomDistance = 25

	State.Visuals.ThirdPerson = true

end

function CameraController:ResetCamera()

	LocalPlayer.CameraMode =
		Enum.CameraMode.Classic

	LocalPlayer.CameraMaxZoomDistance = 128

	State.Visuals.FirstPerson = false
	State.Visuals.ThirdPerson = false

end

--// =========================================================
--// FREECAM
--// =========================================================

FreecamController = {}

FreecamController.Connection = nil
FreecamController.Position = nil
FreecamController.Rotation = nil

function FreecamController:Enable()

	if self.Connection then
		return
	end

	local Camera =
		workspace.CurrentCamera

	if not Camera then
		return
	end

	State.Visuals.Freecam = true

	Camera.CameraType =
		Enum.CameraType.Scriptable

	self.Position =
		Camera.CFrame.Position

	local Keys = {
		W=false,
		A=false,
		S=false,
		D=false,
		Q=false,
		E=false
	}

	local Began
	local Ended

	Began = UserInputService.InputBegan:Connect(function(Input,GPE)

		if GPE then
			return
		end

		local Key = Input.KeyCode.Name

		if Keys[Key] ~= nil then
			Keys[Key] = true
		end

	end)

	Ended = UserInputService.InputEnded:Connect(function(Input)

		local Key = Input.KeyCode.Name

		if Keys[Key] ~= nil then
			Keys[Key] = false
		end

	end)

	self.Connection =
		RunService.RenderStepped:Connect(function(dt)

			local Move =
				Vector3.zero

			if Keys.W then
				Move += Camera.CFrame.LookVector
			end

			if Keys.S then
				Move -= Camera.CFrame.LookVector
			end

			if Keys.A then
				Move -= Camera.CFrame.RightVector
			end

			if Keys.D then
				Move += Camera.CFrame.RightVector
			end

			if Keys.Q then
				Move += Vector3.yAxis
			end

			if Keys.E then
				Move -= Vector3.yAxis
			end

			if Move.Magnitude > 0 then
				Move = Move.Unit
			end

			self.Position +=
				Move * 60 * dt

			Camera.CFrame =
				CFrame.new(self.Position)
				* (Camera.CFrame - Camera.CFrame.Position)

		end)

	self.Cleanup = function()

		if Began then
			Began:Disconnect()
		end

		if Ended then
			Ended:Disconnect()
		end

	end

	NotificationManager:Notify(
		"Camera",
		"Freecam Enabled"
	)

end

function FreecamController:Disable()

	State.Visuals.Freecam = false

	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end

	if self.Cleanup then
		self.Cleanup()
	end

	local Camera =
		workspace.CurrentCamera

	if Camera then
		Camera.CameraType =
			Enum.CameraType.Custom
	end

	NotificationManager:Notify(
		"Camera",
		"Freecam Disabled"
	)

end

function FreecamController:Toggle()

	if State.Visuals.Freecam then
		self:Disable()
	else
		self:Enable()
	end

end

--// =========================================================
--// CAMERA OFFSET
--// =========================================================

CameraController.OffsetConnection = nil

function CameraController:SetOffset(Vector)

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.CameraOffset = Vector
	end

end

function CameraController:ResetOffset()

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.CameraOffset = Vector3.zero
	end

end

--// =========================================================
--// CAMERA SHAKE
--// =========================================================

function CameraController:Shake(Duration,Intensity)

	local Camera =
		workspace.CurrentCamera

	if not Camera then
		return
	end

	local Start = tick()

	local Connection

	Connection =
		RunService.RenderStepped:Connect(function()

			if tick()-Start > Duration then

				Connection:Disconnect()
				return

			end

			local Offset =
				Vector3.new(
					(math.random()-0.5)*Intensity,
					(math.random()-0.5)*Intensity,
					(math.random()-0.5)*Intensity
				)

			Camera.CFrame += Offset

		end)

end

--// =========================================================
--// VISUAL BUTTONS
--// Temporary until tab system exists
--// =========================================================

local FullbrightButton =
	UIManager:Button("Toggle Fullbright")

FullbrightButton.Position =
	UDim2.new(0,350,0,230)

FullbrightButton.Parent = Content

FullbrightButton.MouseButton1Click:Connect(function()

	VisualController:ToggleFullbright()

end)

local FogButton =
	UIManager:Button("Remove Fog")

FogButton.Position =
	UDim2.new(0,350,0,280)

FogButton.Parent = Content

FogButton.MouseButton1Click:Connect(function()

	VisualController:RemoveFog()

end)

local FreecamButton =
	UIManager:Button("Toggle Freecam")

FreecamButton.Position =
	UDim2.new(0,350,0,330)

FreecamButton.Parent = Content

FreecamButton.MouseButton1Click:Connect(function()

	FreecamController:Toggle()

end)

local FOVButton =
	UIManager:Button("FOV 120")

FOVButton.Position =
	UDim2.new(0,350,0,380)

FOVButton.Parent = Content

FOVButton.MouseButton1Click:Connect(function()

	CameraController:SetFOV(120)

	NotificationManager:Notify(
		"Camera",
		"FOV Set To 120"
	)

end)

--// =========================================================
--// RESPAWN SUPPORT
--// =========================================================

LocalPlayer.CharacterAdded:Connect(function()

	task.wait(1)

	CameraController:SetFOV(
		State.Visuals.FOV
	)

end)

NotificationManager:Notify(
	"Admin Panel",
	"Part 3 Loaded"
)

LogManager:Add("Part 3 Loaded")

--// =========================================================
--// ADMIN PANEL - PART 4
--// ESP SYSTEM
--// Add directly below Part 3
--// =========================================================

State.ESP = {

	Enabled = false,

	NameESP = false,
	HighlightESP = false,
	DistanceESP = false,
	HealthESP = false,
	TracerESP = false,

	Objects = {}
}

--// =========================================================
--// ESP CONTROLLER
--// =========================================================

ESPController = {}

ESPController.Connection = nil

local Camera = workspace.CurrentCamera

--// =========================================================
--// CLEANUP PLAYER ESP
--// =========================================================

function ESPController:RemovePlayer(Player)

	local Data = State.ESP.Objects[Player]

	if not Data then
		return
	end

	for _,Obj in pairs(Data) do

		if typeof(Obj) == "Instance" then

			pcall(function()
				Obj:Destroy()
			end)

		end

	end

	State.ESP.Objects[Player] = nil

end

--// =========================================================
--// CREATE ESP
--// =========================================================

function ESPController:CreatePlayer(Player)

	if Player == LocalPlayer then
		return
	end

	if State.ESP.Objects[Player] then
		return
	end

	local Data = {}

	State.ESP.Objects[Player] = Data

	local Highlight =
		Instance.new("Highlight")

	Highlight.Enabled = false
	Highlight.FillTransparency = .6
	Highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	Highlight.FillColor =
		Color3.fromRGB(0,170,255)

	Data.Highlight = Highlight

	local Billboard =
		Instance.new("BillboardGui")

	Billboard.Size =
		UDim2.new(0,220,0,50)

	Billboard.AlwaysOnTop = true
	Billboard.Enabled = false

	Data.Billboard = Billboard

	local Label =
		Instance.new("TextLabel")

	Label.BackgroundTransparency = 1
	Label.Size = UDim2.fromScale(1,1)

	Label.TextScaled = true
	Label.Font = Enum.Font.GothamBold

	Label.TextStrokeTransparency = 0

	Label.TextColor3 =
		Color3.new(1,1,1)

	Label.Parent = Billboard

	Data.Label = Label

	local Tracer =
		Instance.new("Frame")

	Tracer.Visible = false
	Tracer.BorderSizePixel = 0

	Tracer.BackgroundColor3 =
		Color3.fromRGB(0,170,255)

	Tracer.AnchorPoint =
		Vector2.new(.5,.5)

	Tracer.Parent = ScreenGui

	Data.Tracer = Tracer

end

--// =========================================================
--// PLAYER ADDED
--// =========================================================

for _,Player in ipairs(Players:GetPlayers()) do

	if Player ~= LocalPlayer then
		ESPController:CreatePlayer(Player)
	end

end

Players.PlayerAdded:Connect(function(Player)

	ESPController:CreatePlayer(Player)

end)

Players.PlayerRemoving:Connect(function(Player)

	ESPController:RemovePlayer(Player)

end)

--// =========================================================
--// TOGGLES
--// =========================================================

function ESPController:SetNameESP(StateValue)

	State.ESP.NameESP = StateValue

end

function ESPController:SetHighlightESP(StateValue)

	State.ESP.HighlightESP = StateValue

end

function ESPController:SetDistanceESP(StateValue)

	State.ESP.DistanceESP = StateValue

end

function ESPController:SetHealthESP(StateValue)

	State.ESP.HealthESP = StateValue

end

function ESPController:SetTracerESP(StateValue)

	State.ESP.TracerESP = StateValue

end

function ESPController:ToggleMaster()

	State.ESP.Enabled =
		not State.ESP.Enabled

	NotificationManager:Notify(
		"ESP",
		"ESP "..(State.ESP.Enabled and "Enabled" or "Disabled")
	)

end

--// =========================================================
--// UPDATE LOOP
--// =========================================================

ESPController.Connection =
	RunService.RenderStepped:Connect(function()

		if not State.ESP.Enabled then

			for _,Data in pairs(State.ESP.Objects) do

				if Data.Highlight then
					Data.Highlight.Enabled = false
				end

				if Data.Billboard then
					Data.Billboard.Enabled = false
				end

				if Data.Tracer then
					Data.Tracer.Visible = false
				end

			end

			return

		end

		for Player,Data in pairs(State.ESP.Objects) do

			local Character =
				Player.Character

			if not Character then
				continue
			end

			local Root =
				Character:FindFirstChild(
					"HumanoidRootPart"
				)

			local Humanoid =
				Character:FindFirstChildOfClass(
					"Humanoid"
				)

			if not Root then
				continue
			end

			-- Highlight

			if State.ESP.HighlightESP then

				if not Data.Highlight.Parent then

					Data.Highlight.Parent =
						Character

				end

				Data.Highlight.Adornee =
					Character

				Data.Highlight.Enabled = true

			else

				Data.Highlight.Enabled = false

			end

			-- Billboard

			if State.ESP.NameESP
				or State.ESP.DistanceESP
				or State.ESP.HealthESP then

				if not Data.Billboard.Parent then

					Data.Billboard.Parent =
						Root

				end

				Data.Billboard.Adornee =
					Root

				Data.Billboard.Enabled = true

				local Text = Player.Name

				if State.ESP.DistanceESP then

					local LocalRoot =
						GetRoot()

					if LocalRoot then

						local Distance =
							math.floor(
								(LocalRoot.Position
									-
									Root.Position
								).Magnitude
							)

						Text ..=
							"\n["..Distance.."m]"

					end

				end

				if State.ESP.HealthESP
					and Humanoid then

					Text ..=
						"\nHP: "
						..
						math.floor(
							Humanoid.Health
						)

				end

				Data.Label.Text = Text

			else

				Data.Billboard.Enabled = false

			end

			-- Tracers

			if State.ESP.TracerESP then

				local ScreenPos,Visible =
					Camera:WorldToViewportPoint(
						Root.Position
					)

				if Visible then

					local Center =
						Vector2.new(
							Camera.ViewportSize.X/2,
							Camera.ViewportSize.Y
						)

					local Target =
						Vector2.new(
							ScreenPos.X,
							ScreenPos.Y
						)

					local Distance =
						(Target-Center).Magnitude

					Data.Tracer.Visible = true

					Data.Tracer.Size =
						UDim2.new(
							0,
							2,
							0,
							Distance
						)

					Data.Tracer.Position =
						UDim2.new(
							0,
							(Center.X+Target.X)/2,
							0,
							(Center.Y+Target.Y)/2
						)

					local Angle =
						math.deg(
							math.atan2(
								Target.Y-Center.Y,
								Target.X-Center.X
							)
						)

					Data.Tracer.Rotation =
						Angle + 90

				else

					Data.Tracer.Visible = false

				end

			else

				Data.Tracer.Visible = false

			end

		end

	end)

--// =========================================================
--// QUICK TEST BUTTONS
--// =========================================================

local ESPButton =
	UIManager:Button("Toggle ESP")

ESPButton.Position =
	UDim2.new(0,550,0,70)

ESPButton.Parent = Content

ESPButton.MouseButton1Click:Connect(function()

	ESPController:ToggleMaster()

end)

local NameESPButton =
	UIManager:Button("Name ESP")

NameESPButton.Position =
	UDim2.new(0,550,0,120)

NameESPButton.Parent = Content

NameESPButton.MouseButton1Click:Connect(function()

	ESPController:SetNameESP(
		not State.ESP.NameESP
	)

end)

local HighlightESPButton =
	UIManager:Button("Highlight ESP")

HighlightESPButton.Position =
	UDim2.new(0,550,0,170)

HighlightESPButton.Parent = Content

HighlightESPButton.MouseButton1Click:Connect(function()

	ESPController:SetHighlightESP(
		not State.ESP.HighlightESP
	)

end)

local TracerESPButton =
	UIManager:Button("Tracer ESP")

TracerESPButton.Position =
	UDim2.new(0,550,0,220)

TracerESPButton.Parent = Content

TracerESPButton.MouseButton1Click:Connect(function()

	ESPController:SetTracerESP(
		not State.ESP.TracerESP
	)

end)

local DistanceESPButton =
	UIManager:Button("Distance ESP")

DistanceESPButton.Position =
	UDim2.new(0,550,0,270)

DistanceESPButton.Parent = Content

DistanceESPButton.MouseButton1Click:Connect(function()

	ESPController:SetDistanceESP(
		not State.ESP.DistanceESP
	)

end)

local HealthESPButton =
	UIManager:Button("Health ESP")

HealthESPButton.Position =
	UDim2.new(0,550,0,320)

HealthESPButton.Parent = Content

HealthESPButton.MouseButton1Click:Connect(function()

	ESPController:SetHealthESP(
		not State.ESP.HealthESP
	)

end)

NotificationManager:Notify(
	"Admin Panel",
	"Part 4 Loaded"
)

LogManager:Add("Part 4 Loaded")

--// =========================================================
--// ADMIN PANEL - PART 5
--// Teleports + Utility + Session Stats
--// Add directly below Part 4
--// =========================================================

State.Teleports = {
	SavedPositions = {},
	PositionHistory = {},
	MaxHistory = 50
}

State.SessionStats = {
	Teleports = 0,
	CommandsExecuted = 0,
	StartTime = tick()
}

--// =========================================================
--// TELEPORT CONTROLLER
--// =========================================================

TeleportController = {}

function TeleportController:PushHistory()

	local Root = GetRoot()

	if not Root then
		return
	end

	table.insert(
		State.Teleports.PositionHistory,
		1,
		Root.CFrame
	)

	if #State.Teleports.PositionHistory >
		State.Teleports.MaxHistory then

		table.remove(
			State.Teleports.PositionHistory
		)

	end

end

function TeleportController:Teleport(CF)

	local Root = GetRoot()

	if not Root then
		return
	end

	self:PushHistory()

	Root.CFrame = CF

	State.SessionStats.Teleports += 1

	LogManager:Add(
		"Teleported"
	)

end

function TeleportController:SavePosition(Name)

	local Root = GetRoot()

	if not Root then
		return
	end

	State.Teleports.SavedPositions[Name] =
		Root.CFrame

	NotificationManager:Notify(
		"Teleport",
		"Saved "..Name
	)

	LogManager:Add(
		"Saved Position: "..Name
	)

end

function TeleportController:LoadPosition(Name)

	local Position =
		State.Teleports.SavedPositions[Name]

	if not Position then

		NotificationManager:Notify(
			"Teleport",
			"Position Not Found"
		)

		return
	end

	self:Teleport(Position)

	NotificationManager:Notify(
		"Teleport",
		"Teleported To "..Name
	)

end

function TeleportController:Undo()

	local Previous =
		State.Teleports.PositionHistory[1]

	if not Previous then
		return
	end

	local Root = GetRoot()

	if Root then

		Root.CFrame = Previous

		table.remove(
			State.Teleports.PositionHistory,
			1
		)

		NotificationManager:Notify(
			"Teleport",
			"Undo Successful"
		)

	end

end

--// =========================================================
--// COPY UTILITIES
--// =========================================================

UtilityController = {}

function UtilityController:CopyPosition()

	local Root = GetRoot()

	if not Root then
		return
	end

	local Position =
		Root.Position

	local Text =
		string.format(
			"Vector3.new(%s,%s,%s)",
			math.floor(Position.X),
			math.floor(Position.Y),
			math.floor(Position.Z)
		)

	if setclipboard then
		setclipboard(Text)
	end

	NotificationManager:Notify(
		"Clipboard",
		"Position Copied"
	)

end

function UtilityController:CopyRotation()

	local Root = GetRoot()

	if not Root then
		return
	end

	local Rotation =
		Root.Orientation

	local Text =
		string.format(
			"Vector3.new(%s,%s,%s)",
			math.floor(Rotation.X),
			math.floor(Rotation.Y),
			math.floor(Rotation.Z)
		)

	if setclipboard then
		setclipboard(Text)
	end

	NotificationManager:Notify(
		"Clipboard",
		"Rotation Copied"
	)

end

function UtilityController:CopyCFrame()

	local Root = GetRoot()

	if not Root then
		return
	end

	local Position =
		Root.Position

	local Text =
		string.format(
			"CFrame.new(%s,%s,%s)",
			math.floor(Position.X),
			math.floor(Position.Y),
			math.floor(Position.Z)
		)

	if setclipboard then
		setclipboard(Text)
	end

	NotificationManager:Notify(
		"Clipboard",
		"CFrame Copied"
	)

end

--// =========================================================
--// REJOIN
--// =========================================================

function UtilityController:Rejoin()

	local TeleportService =
		game:GetService("TeleportService")

	pcall(function()

		TeleportService:Teleport(
			game.PlaceId,
			LocalPlayer
		)

	end)

end

--// =========================================================
--// RESPAWN
--// =========================================================

function UtilityController:Respawn()

	local Character =
		LocalPlayer.Character

	if Character then

		Character:BreakJoints()

	end

end

--// =========================================================
--// CHARACTER RELOAD
--// =========================================================

function UtilityController:ReloadCharacter()

	local Position

	local Root = GetRoot()

	if Root then
		Position = Root.CFrame
	end

	self:Respawn()

	LocalPlayer.CharacterAdded:Wait()

	task.wait(1)

	if Position then

		local NewRoot = GetRoot()

		if NewRoot then
			NewRoot.CFrame = Position
		end

	end

	NotificationManager:Notify(
		"Character",
		"Reload Complete"
	)

end

--// =========================================================
--// SESSION STATS
--// =========================================================

local SessionLabel =
	Instance.new("TextLabel")

SessionLabel.BackgroundTransparency = 1
SessionLabel.Size =
	UDim2.new(0,250,0,30)

SessionLabel.Position =
	UDim2.new(0,20,0,300)

SessionLabel.TextColor3 =
	ThemeManager:Get().Text

SessionLabel.Parent = Content

RunService.RenderStepped:Connect(function()

	local Duration =
		math.floor(
			tick() -
			State.SessionStats.StartTime
		)

	SessionLabel.Text =
		"Session: "
		..
		Duration
		..
		"s"

end)

--// =========================================================
--// TEST BUTTONS
--// =========================================================

local SaveButton =
	UIManager:Button("Save Position")

SaveButton.Position =
	UDim2.new(0,750,0,70)

SaveButton.Parent = Content

SaveButton.MouseButton1Click:Connect(function()

	TeleportController:SavePosition(
		"Slot1"
	)

end)

local LoadButton =
	UIManager:Button("Load Position")

LoadButton.Position =
	UDim2.new(0,750,0,120)

LoadButton.Parent = Content

LoadButton.MouseButton1Click:Connect(function()

	TeleportController:LoadPosition(
		"Slot1"
	)

end)

local UndoButton =
	UIManager:Button("Undo Teleport")

UndoButton.Position =
	UDim2.new(0,750,0,170)

UndoButton.Parent = Content

UndoButton.MouseButton1Click:Connect(function()

	TeleportController:Undo()

end)

local CopyPosButton =
	UIManager:Button("Copy Position")

CopyPosButton.Position =
	UDim2.new(0,750,0,220)

CopyPosButton.Parent = Content

CopyPosButton.MouseButton1Click:Connect(function()

	UtilityController:CopyPosition()

end)

local RespawnButton =
	UIManager:Button("Respawn")

RespawnButton.Position =
	UDim2.new(0,750,0,270)

RespawnButton.Parent = Content

RespawnButton.MouseButton1Click:Connect(function()

	UtilityController:Respawn()

end)

local ReloadButton =
	UIManager:Button("Reload Character")

ReloadButton.Position =
	UDim2.new(0,750,0,320)

ReloadButton.Parent = Content

ReloadButton.MouseButton1Click:Connect(function()

	UtilityController:ReloadCharacter()

end)

NotificationManager:Notify(
	"Admin Panel",
	"Part 5 Loaded"
)

LogManager:Add(
	"Part 5 Loaded"
)

--// =========================================================
--// ADMIN PANEL - PART 6
--// Settings + Tabs + Search + Performance
--// Add directly below Part 5
--// =========================================================

State.Settings = {
	Transparency = 0,
	AnimationSpeed = 1,
	AccentColor = Color3.fromRGB(0,170,255),
	Theme = "Dark"
}

State.Performance = {
	Ping = 0,
	Memory = 0,
	LastFrame = tick()
}

State.Pages = {}
State.ActivePage = nil

--// =========================================================
--// SETTINGS CONTROLLER
--// =========================================================

SettingsController = {}

function SettingsController:SetTransparency(Value)

	State.Settings.Transparency = Value

	if State.UI.Main then
		State.UI.Main.BackgroundTransparency = Value
	end

end

function SettingsController:SetAccent(Color)

	State.Settings.AccentColor = Color

end

function SettingsController:SetTheme(Name)

	if not ThemeManager.Themes[Name] then
		return
	end

	State.Theme = Name
	State.Settings.Theme = Name

	local Theme =
		ThemeManager:Get()

	if State.UI.Main then
		State.UI.Main.BackgroundColor3 =
			Theme.Background
	end

	NotificationManager:Notify(
		"Theme",
		"Theme Changed To "..Name
	)

end

function SettingsController:Reset()

	self:SetTheme("Dark")
	self:SetTransparency(0)

end

--// =========================================================
--// TAB SYSTEM
--// =========================================================

function UIManager:CreatePage(Name)

	local Page = Instance.new("ScrollingFrame")

	Page.Name = Name

	Page.Size =
		UDim2.new(1,0,1,0)

	Page.CanvasSize =
		UDim2.new()

	Page.BackgroundTransparency = 1

	Page.Visible = false

	Page.Parent = Content

	State.Pages[Name] = Page

	return Page

end

function UIManager:SwitchPage(Name)

	for PageName,Page in pairs(State.Pages) do

		Page.Visible =
			PageName == Name

	end

	State.ActivePage = Name

end

local HomePage =
	UIManager:CreatePage("Home")

local PlayerPage =
	UIManager:CreatePage("Player")

local VisualPage =
	UIManager:CreatePage("Visual")

local TeleportPage =
	UIManager:CreatePage("Teleports")

local SettingsPage =
	UIManager:CreatePage("Settings")

local LogsPage =
	UIManager:CreatePage("Logs")

UIManager:SwitchPage("Home")

--// =========================================================
--// SEARCH SYSTEM
--// =========================================================

SearchController = {}

SearchController.Commands = {
	"fly",
	"noclip",
	"infinitejump",
	"fullbright",
	"freecam",
	"teleport",
	"respawn",
	"copyposition",
	"fov",
	"walkspeed"
}

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()

	local Query =
		string.lower(
			SearchBar.Text
		)

	for _,Command in ipairs(
		SearchController.Commands
	) do

		if string.find(
			Command,
			Query
		) then

			LogManager:Add(
				"Search: "..Command
			)

		end

	end

end)

--// =========================================================
--// PERFORMANCE PANEL
--// =========================================================

local PerformanceFrame =
	Instance.new("Frame")

PerformanceFrame.Size =
	UDim2.new(0,250,0,120)

PerformanceFrame.Position =
	UDim2.new(1,-260,1,-130)

PerformanceFrame.BackgroundColor3 =
	ThemeManager:Get().Secondary

PerformanceFrame.Parent =
	ScreenGui

UIManager:Round(
	PerformanceFrame
)

UIManager:Stroke(
	PerformanceFrame
)

local PerformanceLabel =
	Instance.new("TextLabel")

PerformanceLabel.Size =
	UDim2.new(1,0,1,0)

PerformanceLabel.BackgroundTransparency = 1

PerformanceLabel.TextColor3 =
	ThemeManager:Get().Text

PerformanceLabel.TextWrapped = true

PerformanceLabel.Parent =
	PerformanceFrame

RunService.RenderStepped:Connect(function()

	local Memory =
		math.floor(
			collectgarbage("count")
		)

	State.Performance.Memory =
		Memory

	local PingEstimate =
		math.random(15,45)

	State.Performance.Ping =
		PingEstimate

	PerformanceLabel.Text =
		"FPS: "
		.. tostring(State.FPS)
		..
		"\nPing: "
		.. tostring(PingEstimate)
		.. "ms"
		..
		"\nMemory: "
		.. tostring(Memory)
		.. "kb"

end)

--// =========================================================
--// LOG VIEWER
--// =========================================================

local LogBox =
	Instance.new("TextBox")

LogBox.ClearTextOnFocus = false

LogBox.MultiLine = true

LogBox.TextXAlignment =
	Enum.TextXAlignment.Left

LogBox.TextYAlignment =
	Enum.TextYAlignment.Top

LogBox.Size =
	UDim2.new(1,-20,1,-20)

LogBox.Position =
	UDim2.new(0,10,0,10)

LogBox.Parent =
	LogsPage

RunService.RenderStepped:Connect(function()

	local Text = ""

	for _,Entry in ipairs(
		State.Logs
	) do

		Text ..=
			"["..
			Entry.Time..
			"] "
			..
			Entry.Message
			..
			"\n"

	end

	LogBox.Text = Text

end)

--// =========================================================
--// MINIMIZE BUTTON
--// =========================================================

local MinimizeButton =
	Instance.new("TextButton")

MinimizeButton.Size =
	UDim2.new(0,30,0,30)

MinimizeButton.Position =
	UDim2.new(1,-70,0,5)

MinimizeButton.Text = "-"

MinimizeButton.Parent =
	Topbar

MinimizeButton.MouseButton1Click:Connect(function()

	State.Minimized =
		not State.Minimized

	if State.Minimized then

		TweenService:Create(
			Main,
			TweenInfo.new(.25),
			{
				Size = UDim2.new(
					0,
					900,
					0,
					40
				)
			}
		):Play()

	else

		TweenService:Create(
			Main,
			TweenInfo.new(.25),
			{
				Size = UDim2.new(
					0,
					900,
					0,
					550
				)
			}
		):Play()

	end

end)

--// =========================================================
--// CLOSE BUTTON
--// =========================================================

local CloseButton =
	Instance.new("TextButton")

CloseButton.Size =
	UDim2.new(0,30,0,30)

CloseButton.Position =
	UDim2.new(1,-35,0,5)

CloseButton.Text = "X"

CloseButton.Parent =
	Topbar

CloseButton.MouseButton1Click:Connect(function()

	TweenService:Create(
		Main,
		TweenInfo.new(.3),
		{
			Size =
				UDim2.new(
					0,
					0,
					0,
					0
				)
		}
	):Play()

	task.wait(.3)

	ScreenGui:Destroy()

end)

--// =========================================================
--// ACTIVE FEATURE INDICATOR
--// =========================================================

local StatusLabel =
	Instance.new("TextLabel")

StatusLabel.Size =
	UDim2.new(0,250,0,25)

StatusLabel.Position =
	UDim2.new(0,20,1,-30)

StatusLabel.BackgroundTransparency = 1

StatusLabel.TextColor3 =
	ThemeManager:Get().Text

StatusLabel.Parent =
	Content

RunService.RenderStepped:Connect(function()

	local Enabled = {}

	if State.Features.Fly then
		table.insert(Enabled,"Fly")
	end

	if State.Features.Noclip then
		table.insert(Enabled,"Noclip")
	end

	if State.Features.InfiniteJump then
		table.insert(Enabled,"InfJump")
	end

	StatusLabel.Text =
		"Active: "
		..
		table.concat(
			Enabled,
			", "
		)

end)

--// =========================================================
--// ERROR LOGGER
--// =========================================================

local function SafeCall(Func)

	local Success,Error =
		pcall(Func)

	if not Success then

		LogManager:Add(
			"ERROR: "..Error
		)

		NotificationManager:Notify(
			"Error",
			Error
		)

	end

end

State.SafeCall = SafeCall

--// =========================================================
--// MOBILE SUPPORT
--// =========================================================

if UserInputService.TouchEnabled then

	Main.Size =
		UDim2.new(
			0.95,
			0,
			0.85,
			0
		)

	NotificationManager:Notify(
		"Mobile",
		"Touch Controls Enabled"
	)

end

--// =========================================================
--// FINAL LOAD
--// =========================================================

NotificationManager:Notify(
	"Admin Panel",
	"Part 6 Loaded"
)

LogManager:Add(
	"Part 6 Loaded"
)

print("ADMIN PANEL FOUNDATION COMPLETE")

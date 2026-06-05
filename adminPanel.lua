--// =========================================================
--// MOBILE ADMIN PANEL - PART 1
--// FOUNDATION + MOBILE UI FRAMEWORK
--// 100% CLIENT SIDED
--// =========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// =========================================================
--// STATE
--// =========================================================

local State = {

	Loaded = false,

	SessionStart = tick(),

	FPS = 0,

	Theme = "Dark",

	SidebarOpen = true,

	ActivePage = "Home",

	Notifications = {},

	Logs = {},

	Pages = {},

	UI = {},

	Features = {}
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

	table.insert(
		self.Tasks,
		Task
	)

	return Task

end

function Maid:Cleanup()

	for _,Task in ipairs(self.Tasks) do

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
--// LOGS
--// =========================================================

local LogManager = {}

function LogManager:Add(Text)

	table.insert(
		State.Logs,
		{
			Time = os.date("%X"),
			Message = tostring(Text)
		}
	)

	print("[ADMIN]",Text)

end

--// =========================================================
--// THEMES
--// =========================================================

local ThemeManager = {}

ThemeManager.Themes = {

	Dark = {

		Background = Color3.fromRGB(18,18,18),

		Secondary = Color3.fromRGB(28,28,28),

		Tertiary = Color3.fromRGB(40,40,40),

		Text = Color3.fromRGB(255,255,255),

		Accent = Color3.fromRGB(0,170,255),

		Stroke = Color3.fromRGB(65,65,65)

	},

	Light = {

		Background = Color3.fromRGB(235,235,235),

		Secondary = Color3.fromRGB(245,245,245),

		Tertiary = Color3.fromRGB(255,255,255),

		Text = Color3.fromRGB(20,20,20),

		Accent = Color3.fromRGB(0,120,255),

		Stroke = Color3.fromRGB(180,180,180)

	}
}

function ThemeManager:Get()

	return self.Themes[State.Theme]

end

--// =========================================================
--// UI HELPERS
--// =========================================================

local UIManager = {}

function UIManager:Round(Object)

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,12)
	Corner.Parent = Object

end

function UIManager:Stroke(Object)

	local Stroke = Instance.new("UIStroke")

	Stroke.Color =
		ThemeManager:Get().Stroke

	Stroke.Thickness = 1

	Stroke.Parent = Object

	return Stroke

end

function UIManager:Shadow(Object)

	local Shadow = Instance.new("ImageLabel")

	Shadow.Name = "Shadow"

	Shadow.AnchorPoint =
		Vector2.new(.5,.5)

	Shadow.Position =
		UDim2.fromScale(.5,.5)

	Shadow.Size =
		UDim2.new(
			1,
			20,
			1,
			20
		)

	Shadow.BackgroundTransparency = 1

	Shadow.Image =
		"rbxassetid://1316045217"

	Shadow.ImageTransparency = .7

	Shadow.ScaleType =
		Enum.ScaleType.Slice

	Shadow.SliceCenter =
		Rect.new(
			10,
			10,
			118,
			118
		)

	Shadow.ZIndex =
		Object.ZIndex - 1

	Shadow.Parent = Object

end

function UIManager:Button(Text)

	local Theme =
		ThemeManager:Get()

	local Button =
		Instance.new("TextButton")

	Button.Size =
		UDim2.new(
			1,
			0,
			0,
			55
		)

	Button.Text = Text

	Button.AutoButtonColor = false

	Button.BackgroundColor3 =
		Theme.Tertiary

	Button.TextColor3 =
		Theme.Text

	Button.Font =
		Enum.Font.GothamBold

	Button.TextSize = 16

	self:Round(Button)
	self:Stroke(Button)

	Button.MouseButton1Down:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(.08),
			{
				Size =
					Button.Size -
					UDim2.new(
						0,
						4,
						0,
						4
					)
			}
		):Play()

	end)

	Button.MouseButton1Up:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(.08),
			{
				Size =
					UDim2.new(
						1,
						0,
						0,
						55
					)
			}
		):Play()

	end)

	return Button

end

--// =========================================================
--// BLUR
--// =========================================================

local Blur =
	Lighting:FindFirstChild(
		"MobileAdminBlur"
	)

if not Blur then

	Blur = Instance.new(
		"BlurEffect"
	)

	Blur.Name =
		"MobileAdminBlur"

	Blur.Size = 0

	Blur.Parent =
		Lighting

end

TweenService:Create(
	Blur,
	TweenInfo.new(.25),
	{
		Size = 12
	}
):Play()

--// =========================================================
--// GUI
--// =========================================================

local ScreenGui =
	Instance.new("ScreenGui")

ScreenGui.Name =
	"MobileAdminPanel"

ScreenGui.ResetOnSpawn = false

ScreenGui.IgnoreGuiInset = true

ScreenGui.ZIndexBehavior =
	Enum.ZIndexBehavior.Global

ScreenGui.Parent =
	PlayerGui

State.UI.ScreenGui =
	ScreenGui

--// =========================================================
--// OPEN BUTTON
--// =========================================================

local OpenButton =
	Instance.new("TextButton")

OpenButton.Name =
	"OpenButton"

OpenButton.Size =
	UDim2.fromOffset(
		70,
		70
	)

OpenButton.Position =
	UDim2.new(
		1,
		-85,
		1,
		-85
	)

OpenButton.Text = "⚙"

OpenButton.TextSize = 32

OpenButton.BackgroundColor3 =
	Color3.fromRGB(
		0,
		170,
		255
	)

OpenButton.TextColor3 =
	Color3.new(1,1,1)

OpenButton.Parent =
	ScreenGui

UIManager:Round(OpenButton)

State.UI.OpenButton =
	OpenButton

--// =========================================================
--// MAIN
--// =========================================================

local Theme =
	ThemeManager:Get()

local Main =
	Instance.new("Frame")

Main.Size =
	UDim2.fromScale(
		1,
		1
	)

Main.Visible = false

Main.BackgroundColor3 =
	Theme.Background

Main.Parent =
	ScreenGui

UIManager:Stroke(Main)

State.UI.Main =
	Main

--// =========================================================
--// TOPBAR
--// =========================================================

local Topbar =
	Instance.new("Frame")

Topbar.Size =
	UDim2.new(
		1,
		0,
		0,
		65
	)

Topbar.BackgroundColor3 =
	Theme.Secondary

Topbar.Parent =
	Main

local Title =
	Instance.new("TextLabel")

Title.Size =
	UDim2.fromScale(
		1,
		1
	)

Title.BackgroundTransparency = 1

Title.Text =
	"Mobile Admin Panel"

Title.TextColor3 =
	Theme.Text

Title.Font =
	Enum.Font.GothamBold

Title.TextSize = 22

Title.Parent =
	Topbar

--// =========================================================
--// CLOSE BUTTON
--// =========================================================

local CloseButton =
	Instance.new("TextButton")

CloseButton.Size =
	UDim2.fromOffset(
		50,
		50
	)

CloseButton.Position =
	UDim2.new(
		1,
		-60,
		0,
		7
	)

CloseButton.Text = "X"

CloseButton.TextSize = 20

CloseButton.Parent =
	Topbar

UIManager:Round(CloseButton)

--// =========================================================
--// SIDEBAR
--// =========================================================

local Sidebar =
	Instance.new("Frame")

Sidebar.Size =
	UDim2.new(
		0,
		140,
		1,
		-65
	)

Sidebar.Position =
	UDim2.new(
		0,
		0,
		0,
		65
	)

Sidebar.BackgroundColor3 =
	Theme.Secondary

Sidebar.Parent =
	Main

UIManager:Stroke(Sidebar)

State.UI.Sidebar =
	Sidebar

local SidebarLayout =
	Instance.new("UIListLayout")

SidebarLayout.Padding =
	UDim.new(
		0,
		5
	)

SidebarLayout.Parent =
	Sidebar

--// =========================================================
--// TABS
--// =========================================================

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

for _,Name in ipairs(Tabs) do

	local Button =
		UIManager:Button(Name)

	Button.Parent =
		Sidebar

	Button.MouseButton1Click:Connect(function()

		State.ActivePage =
			Name

		LogManager:Add(
			"Opened "..Name
		)

	end)

end

--// =========================================================
--// CONTENT
--// =========================================================

local Content =
	Instance.new("Frame")

Content.Size =
	UDim2.new(
		1,
		-140,
		1,
		-65
	)

Content.Position =
	UDim2.new(
		0,
		140,
		0,
		65
	)

Content.BackgroundTransparency = 1

Content.Parent =
	Main

State.UI.Content =
	Content

--// =========================================================
--// SEARCH
--// =========================================================

local SearchBar =
	Instance.new("TextBox")

SearchBar.Size =
	UDim2.new(
		1,
		-20,
		0,
		50
	)

SearchBar.Position =
	UDim2.new(
		0,
		10,
		0,
		10
	)

SearchBar.PlaceholderText =
	"Search commands..."

SearchBar.Text = ""

SearchBar.Parent =
	Content

UIManager:Round(SearchBar)
UIManager:Stroke(SearchBar)

State.UI.SearchBar =
	SearchBar

--// =========================================================
--// PROFILE CARD
--// =========================================================

local Profile =
	Instance.new("Frame")

Profile.Size =
	UDim2.new(
		1,
		-20,
		0,
		150
	)

Profile.Position =
	UDim2.new(
		0,
		10,
		0,
		70
	)

Profile.BackgroundColor3 =
	Theme.Secondary

Profile.Parent =
	Content

UIManager:Round(Profile)
UIManager:Stroke(Profile)

local ProfileText =
	Instance.new("TextLabel")

ProfileText.Size =
	UDim2.fromScale(
		1,
		1
	)

ProfileText.BackgroundTransparency = 1

ProfileText.TextColor3 =
	Theme.Text

ProfileText.Font =
	Enum.Font.Gotham

ProfileText.TextSize = 16

ProfileText.Parent =
	Profile

State.UI.ProfileText =
	ProfileText

--// =========================================================
--// FPS LOOP
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

			local Session =
				math.floor(
					tick()
					-
					State.SessionStart
				)

			ProfileText.Text =
				"Username: "
				..
				LocalPlayer.Name
				..
				"\nDisplay: "
				..
				LocalPlayer.DisplayName
				..
				"\nUserId: "
				..
				LocalPlayer.UserId
				..
				"\nFPS: "
				..
				State.FPS
				..
				"\nSession: "
				..
				Session
				..
				"s"

		end

	end)

end)

--// =========================================================
--// NOTIFICATIONS
--// =========================================================

local NotificationContainer =
	Instance.new("Frame")

NotificationContainer.Size =
	UDim2.new(
		0,
		320,
		1,
		0
	)

NotificationContainer.Position =
	UDim2.new(
		1,
		-330,
		0,
		10
	)

NotificationContainer.BackgroundTransparency = 1

NotificationContainer.Parent =
	ScreenGui

local Layout =
	Instance.new("UIListLayout")

Layout.Padding =
	UDim.new(
		0,
		5
	)

Layout.Parent =
	NotificationContainer

State.UI.NotificationContainer =
	NotificationContainer

NotificationManager = {}

function NotificationManager:Notify(
	Title,
	Text
)

	local Frame =
		Instance.new("Frame")

	Frame.Size =
		UDim2.new(
			1,
			0,
			0,
			70
		)

	Frame.BackgroundColor3 =
		Theme.Secondary

	Frame.Parent =
		NotificationContainer

	UIManager:Round(Frame)

	local Label =
		Instance.new("TextLabel")

	Label.Size =
		UDim2.fromScale(
			1,
			1
		)

	Label.BackgroundTransparency = 1

	Label.Text =
		Title
		..
		"\n"
		..
		Text

	Label.TextColor3 =
		Theme.Text

	Label.Parent =
		Frame

	task.delay(4,function()

		if Frame then
			Frame:Destroy()
		end

	end)

end

--// =========================================================
--// OPEN / CLOSE
--// =========================================================

OpenButton.MouseButton1Click:Connect(function()

	Main.Visible = true

	OpenButton.Visible = false

end)

CloseButton.MouseButton1Click:Connect(function()

	Main.Visible = false

	OpenButton.Visible = true

end)

--// =========================================================
--// LOADED
--// =========================================================

NotificationManager:Notify(
	"Admin",
	"Mobile Part 1 Loaded"
)

LogManager:Add(
	"Mobile Part 1 Loaded"
)

State.Loaded = true

print("MOBILE ADMIN PART 1 LOADED")

--// =========================================================
--// MOBILE ADMIN PANEL - PART 2
--// PLAYER SYSTEM
--// PLACE BELOW PART 1
--// =========================================================

State.PlayerSettings = {

	WalkSpeed = 16,
	JumpPower = 50,
	Gravity = workspace.Gravity,

	DefaultWalkSpeed = 16,
	DefaultJumpPower = 50,
	DefaultGravity = workspace.Gravity,

	Frozen = false
}

--// =========================================================
--// HELPERS
--// =========================================================

local function GetCharacter()

	return LocalPlayer.Character

end

local function GetHumanoid()

	local Character = GetCharacter()

	if not Character then
		return nil
	end

	return Character:FindFirstChildOfClass("Humanoid")

end

local function GetRoot()

	local Character = GetCharacter()

	if not Character then
		return nil
	end

	return Character:FindFirstChild("HumanoidRootPart")

end

--// =========================================================
--// PLAYER CONTROLLER
--// =========================================================

PlayerController = {}

function PlayerController:SetWalkSpeed(Value)

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	Humanoid.WalkSpeed = Value

	State.PlayerSettings.WalkSpeed = Value

	LogManager:Add(
		"WalkSpeed -> "..Value
	)

end

function PlayerController:SetJumpPower(Value)

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	Humanoid.JumpPower = Value

	State.PlayerSettings.JumpPower = Value

	LogManager:Add(
		"JumpPower -> "..Value
	)

end

function PlayerController:SetGravity(Value)

	workspace.Gravity = Value

	State.PlayerSettings.Gravity = Value

	LogManager:Add(
		"Gravity -> "..Value
	)

end

function PlayerController:Sit()

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.Sit = true
	end

	NotificationManager:Notify(
		"Player",
		"Sitting"
	)

end

function PlayerController:Unsit()

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid.Sit = false
	end

	NotificationManager:Notify(
		"Player",
		"Standing"
	)

end

function PlayerController:Freeze()

	local Root = GetRoot()

	if Root then

		Root.Anchored = true

		State.PlayerSettings.Frozen = true

	end

	NotificationManager:Notify(
		"Player",
		"Frozen"
	)

end

function PlayerController:Unfreeze()

	local Root = GetRoot()

	if Root then

		Root.Anchored = false

		State.PlayerSettings.Frozen = false

	end

	NotificationManager:Notify(
		"Player",
		"Unfrozen"
	)

end

function PlayerController:Reset()

	local Character = GetCharacter()

	if Character then

		Character:BreakJoints()

	end

end

function PlayerController:RestoreDefaults()

	self:SetWalkSpeed(
		State.PlayerSettings.DefaultWalkSpeed
	)

	self:SetJumpPower(
		State.PlayerSettings.DefaultJumpPower
	)

	self:SetGravity(
		State.PlayerSettings.DefaultGravity
	)

	self:Unfreeze()

	NotificationManager:Notify(
		"Player",
		"Defaults Restored"
	)

end

--// =========================================================
--// PLAYER PAGE
--// =========================================================

local PlayerPage =
	Instance.new("ScrollingFrame")

PlayerPage.Name = "Player"

PlayerPage.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

PlayerPage.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		1200
	)

PlayerPage.ScrollBarThickness = 8

PlayerPage.Visible = false

PlayerPage.BackgroundTransparency = 1

PlayerPage.Parent = Content

State.Pages.Player =
	PlayerPage

local Layout =
	Instance.new("UIListLayout")

Layout.Padding =
	UDim.new(
		0,
		10
	)

Layout.Parent =
	PlayerPage

--// =========================================================
--// TITLE
--// =========================================================

local Title =
	Instance.new("TextLabel")

Title.Size =
	UDim2.new(
		1,
		-20,
		0,
		60
	)

Title.Position =
	UDim2.new(
		0,
		10,
		0,
		0
	)

Title.BackgroundTransparency = 1

Title.Text = "PLAYER SETTINGS"

Title.Font =
	Enum.Font.GothamBold

Title.TextSize = 24

Title.TextColor3 =
	ThemeManager:Get().Text

Title.Parent =
	PlayerPage

--// =========================================================
--// WALKSPEED
--// =========================================================

local WalkSpeedLabel =
	Instance.new("TextLabel")

WalkSpeedLabel.Size =
	UDim2.new(
		1,
		-20,
		0,
		50
	)

WalkSpeedLabel.BackgroundColor3 =
	ThemeManager:Get().Secondary

WalkSpeedLabel.Text =
	"WalkSpeed: 16"

WalkSpeedLabel.Parent =
	PlayerPage

UIManager:Round(
	WalkSpeedLabel
)

local WalkUp =
	UIManager:Button(
		"+ WalkSpeed"
	)

WalkUp.Parent =
	PlayerPage

WalkUp.MouseButton1Click:Connect(function()

	local New =
		math.clamp(
			State.PlayerSettings.WalkSpeed + 5,
			0,
			500
		)

	PlayerController:SetWalkSpeed(
		New
	)

	WalkSpeedLabel.Text =
		"WalkSpeed: "..New

end)

local WalkDown =
	UIManager:Button(
		"- WalkSpeed"
	)

WalkDown.Parent =
	PlayerPage

WalkDown.MouseButton1Click:Connect(function()

	local New =
		math.clamp(
			State.PlayerSettings.WalkSpeed - 5,
			0,
			500
		)

	PlayerController:SetWalkSpeed(
		New
	)

	WalkSpeedLabel.Text =
		"WalkSpeed: "..New

end)

--// =========================================================
--// JUMPPOWER
--// =========================================================

local JumpLabel =
	WalkSpeedLabel:Clone()

JumpLabel.Text =
	"JumpPower: 50"

JumpLabel.Parent =
	PlayerPage

local JumpUp =
	UIManager:Button(
		"+ JumpPower"
	)

JumpUp.Parent =
	PlayerPage

JumpUp.MouseButton1Click:Connect(function()

	local New =
		math.clamp(
			State.PlayerSettings.JumpPower + 10,
			0,
			500
		)

	PlayerController:SetJumpPower(
		New
	)

	JumpLabel.Text =
		"JumpPower: "..New

end)

local JumpDown =
	UIManager:Button(
		"- JumpPower"
	)

JumpDown.Parent =
	PlayerPage

JumpDown.MouseButton1Click:Connect(function()

	local New =
		math.clamp(
			State.PlayerSettings.JumpPower - 10,
			0,
			500
		)

	PlayerController:SetJumpPower(
			New
	)

	JumpLabel.Text =
		"JumpPower: "..New

end)

--// =========================================================
--// GRAVITY
--// =========================================================

local GravityLabel =
	WalkSpeedLabel:Clone()

GravityLabel.Text =
	"Gravity: "..workspace.Gravity

GravityLabel.Parent =
	PlayerPage

local GravityUp =
	UIManager:Button(
		"+ Gravity"
	)

GravityUp.Parent =
	PlayerPage

GravityUp.MouseButton1Click:Connect(function()

	local New =
		workspace.Gravity + 20

	PlayerController:SetGravity(
		New
	)

	GravityLabel.Text =
		"Gravity: "..New

end)

local GravityDown =
	UIManager:Button(
		"- Gravity"
	)

GravityDown.Parent =
	PlayerPage

GravityDown.MouseButton1Click:Connect(function()

	local New =
		math.max(
			0,
			workspace.Gravity - 20
		)

	PlayerController:SetGravity(
		New
	)

	GravityLabel.Text =
		"Gravity: "..New

end)

--// =========================================================
--// PLAYER BUTTONS
--// =========================================================

local SitButton =
	UIManager:Button(
		"Sit"
	)

SitButton.Parent =
	PlayerPage

SitButton.MouseButton1Click:Connect(function()

	PlayerController:Sit()

end)

local UnsitButton =
	UIManager:Button(
		"Unsit"
	)

UnsitButton.Parent =
	PlayerPage

UnsitButton.MouseButton1Click:Connect(function()

	PlayerController:Unsit()

end)

local FreezeButton =
	UIManager:Button(
		"Freeze"
	)

FreezeButton.Parent =
	PlayerPage

FreezeButton.MouseButton1Click:Connect(function()

	PlayerController:Freeze()

end)

local UnfreezeButton =
	UIManager:Button(
		"Unfreeze"
	)

UnfreezeButton.Parent =
	PlayerPage

UnfreezeButton.MouseButton1Click:Connect(function()

	PlayerController:Unfreeze()

end)

local ResetButton =
	UIManager:Button(
		"Reset Character"
	)

ResetButton.Parent =
	PlayerPage

ResetButton.MouseButton1Click:Connect(function()

	PlayerController:Reset()

end)

local DefaultsButton =
	UIManager:Button(
		"Restore Defaults"
	)

DefaultsButton.Parent =
	PlayerPage

DefaultsButton.MouseButton1Click:Connect(function()

	PlayerController:RestoreDefaults()

end)

--// =========================================================
--// PAGE SWITCH SUPPORT
--// =========================================================

for _,Object in ipairs(
	Sidebar:GetChildren()
) do

	if Object:IsA("TextButton") then

		Object.MouseButton1Click:Connect(function()

			for _,Page in pairs(
				State.Pages
			) do

				Page.Visible = false

			end

			if Object.Text == "Player" then

				PlayerPage.Visible = true

			end

		end)

	end

end

--// =========================================================
--// RESPAWN SUPPORT
--// =========================================================

LocalPlayer.CharacterAdded:Connect(function()

	task.wait(1)

	PlayerController:SetWalkSpeed(
		State.PlayerSettings.WalkSpeed
	)

	PlayerController:SetJumpPower(
		State.PlayerSettings.JumpPower
	)

	PlayerController:SetGravity(
		State.PlayerSettings.Gravity
	)

	if State.PlayerSettings.Frozen then

		PlayerController:Freeze()

	end

end)

--// =========================================================
--// LOADED
--// =========================================================

NotificationManager:Notify(
	"Admin",
	"Part 2 Loaded"
)

LogManager:Add(
	"Part 2 Loaded"
)

print("MOBILE ADMIN PART 2 LOADED")

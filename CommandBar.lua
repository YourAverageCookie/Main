
-- Roblox Console Style Command Bar (Cookie's Version) with Bubble UI, RemoteEvent, and Permission Check
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local CommandRemote = ReplicatedStorage:FindFirstChild("CommandInput") or Instance.new("RemoteEvent", ReplicatedStorage)
CommandRemote.Name = "CommandInput"

-- COMMUNITY PERMISSION CHECK
local function isAuthorized()
	local success, result = pcall(function()
		local groups = LocalPlayer:GetGroups()
		for _, g in ipairs(groups) do
			if g.Id == 35972935 and g.Role == "🛠 Administrator 🛠" then
				return true
			end
		end
		return false
	end)
	return success and result
end

if not isAuthorized() then return end

-- GUI BUILD
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "ConsoleCommandGui"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)
main.Name = "ConsoleMain"
main.Position = UDim2.new(0, 20, 1, -140)
main.Size = UDim2.new(0, 550, 0, 120)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.35
main.BorderSizePixel = 0
main.Visible = false

local inputBox = Instance.new("TextBox", main)
inputBox.Name = "CommandInput"
inputBox.Position = UDim2.new(0, 10, 0, 10)
inputBox.Size = UDim2.new(1, -20, 0, 40)
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 20
inputBox.PlaceholderText = "/command here"
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.BorderSizePixel = 0

local bubble = Instance.new("TextLabel", main)
bubble.Name = "BubbleHelper"
bubble.Position = UDim2.new(0, 10, 0, 60)
bubble.Size = UDim2.new(1, -20, 0, 50)
bubble.TextColor3 = Color3.fromRGB(255, 80, 80)
bubble.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bubble.Font = Enum.Font.Code
bubble.TextSize = 18
bubble.Visible = false
bubble.TextWrapped = true

-- TOGGLE ON F2
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F2 then
		main.Visible = not main.Visible
		if main.Visible then inputBox:CaptureFocus() end
	end
end)

-- COMMANDS
local commands = {}

commands["print"] = function(args)
	print(table.concat(args, " "))
end

commands["walkspeed"] = function(args)
	local speed = tonumber(args[1])
	if speed then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
	else
		bubble.Text = "[ERROR] Use: /walkspeed [number]"
		bubble.Visible = true
	end
end

commands["jump"] = function()
	LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
end

commands["morph"] = function(args)
	local user = args[1] or LocalPlayer.Name
	local ok, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(user)
	end)
	if not ok then
		bubble.Text = "[ERROR] Invalid username"
		bubble.Visible = true
		return
	end
	local desc = Players:GetHumanoidDescriptionFromUserId(userId)
	LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
end

commands["sit"] = function()
	LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Seated)
end

commands["reload"] = function()
	LocalPlayer.Character:BreakJoints()
end

commands["explode"] = function()
	local boom = Instance.new("Explosion")
	boom.Position = LocalPlayer.Character.HumanoidRootPart.Position
	boom.BlastRadius = 10
	boom.Parent = workspace
end

-- HANDLE INPUT
inputBox.FocusLost:Connect(function(enter)
	if not enter then return end
	bubble.Visible = false
	local msg = inputBox.Text
	local split = msg:split(" ")
	local cmd = split[1]:gsub("/", ""):lower()
	table.remove(split, 1)
	if commands[cmd] then
		commands[cmd](split)
	else
		bubble.Text = "[ERROR] Unknown command: " .. cmd
		bubble.Visible = true
	end
	inputBox.Text = ""
end)

-- REMOTE EVENT CONNECTION
CommandRemote.OnClientEvent:Connect(function(text)
	inputBox.Text = text
	main.Visible = true
	inputBox:CaptureFocus()
end)

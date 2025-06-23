local cookiesAddonModule = {}

cookiesAddonModule.Func = function()
    print("cookiesAddon Created")

    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "cookiesAddonGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 550, 0, 340)
    frame.Position = UDim2.new(0.5, -275, 0.5, -170)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Name = "mainFrame"
    frame.Parent = screenGui

    local tabs = {"main","visuals","exploits","modpanel","fun"}
    local tabButtons = {}

    for i, name in pairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 0, 30)
        tabButton.Position = UDim2.new(0, 10 + (i-1)*110, 0, 10)
        tabButton.Text = name
        tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Parent = frame
        tabButtons[name] = tabButton
    end

    local pages = {}
    for _, name in pairs(tabs) do
        local page = Instance.new("Frame")
        page.Size = UDim2.new(0, 520, 0, 280)
        page.Position = UDim2.new(0, 15, 0, 50)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Name = name.."Page"
        page.Parent = frame
        pages[name] = page
    end

    for name, btn in pairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            for _, page in pairs(pages) do
                page.Visible = false
            end
            pages[name].Visible = true
        end)
    end

    pages["main"].Visible = true

    local function createButton(text, parent, posY, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 200, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = text
        btn.Parent = parent
        btn.MouseButton1Click:Connect(callback)
    end

    createButton("spawn crucifix lol", pages["exploits"], 10, function()
        print("spawning crucifix now")
        local crucifixModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Teilsthebfdifan/Modhub-assets/refs/heads/main/MischievousV2Test.lua"))()
    end)
end

return cookiesAddonModule

end

print("cookiesAddon Successful")
return cookiesAddonModule

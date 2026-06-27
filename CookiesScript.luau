--// STUDIODEV CORE (Stage 1 - Step 1)
--// Single Script Foundation UI System

local plugin = plugin

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

--// RESPONSIVE SCALE HELP
local function scale(x, y)
    return UDim2.new(x, 0, y, 0)
end

--// TOOLBAR
local toolbar = plugin:CreateToolbar("StudioDev")
local openBtn = toolbar:CreateButton("StudioDev", "Open StudioDev", "")

--// DOCK WIDGET (mobile + PC friendly)
local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float,
    true,
    true,
    700, 450,   -- smaller default (mobile friendly scale)
    320, 220
)

local widget = plugin:CreateDockWidgetPluginGui("StudioDev_Core", widgetInfo)
widget.Title = "StudioDev"

--// ROOT
local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1, 1)
root.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
root.Parent = widget

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = root

--// TOP BAR (Draggable area)
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 36)
topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
topbar.BorderSizePixel = 0
topbar.Parent = root

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "StudioDev IDE"
title.TextColor3 = Color3.fromRGB(220,220,220)
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

--// MAIN LAYOUT CONTAINER
local main = Instance.new("Frame")
main.Size = UDim2.new(1, 0, 1, -36)
main.Position = UDim2.new(0, 0, 0, 36)
main.BackgroundTransparency = 1
main.Parent = root

--// SIDEBAR (Explorer placeholder)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.22, 0, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

--// EDITOR AREA
local editor = Instance.new("Frame")
editor.Size = UDim2.new(0.58, 0, 0.65, 0)
editor.Position = UDim2.new(0.22, 0, 0, 0)
editor.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
editor.BorderSizePixel = 0
editor.Parent = main

local editorLabel = Instance.new("TextLabel")
editorLabel.Size = UDim2.fromScale(1,1)
editorLabel.BackgroundTransparency = 1
editorLabel.Text = "-- editor coming in Step 2"
editorLabel.TextColor3 = Color3.fromRGB(120,120,120)
editorLabel.Font = Enum.Font.Code
editorLabel.TextSize = 14
editorLabel.Parent = editor

--// CONSOLE AREA
local console = Instance.new("Frame")
console.Size = UDim2.new(0.58, 0, 0.35, 0)
console.Position = UDim2.new(0.22, 0, 0.65, 0)
console.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
console.BorderSizePixel = 0
console.Parent = main

local consoleLabel = Instance.new("TextLabel")
consoleLabel.Size = UDim2.fromScale(1,1)
consoleLabel.BackgroundTransparency = 1
consoleLabel.Text = "-- console coming in Step 2"
consoleLabel.TextColor3 = Color3.fromRGB(100,100,100)
consoleLabel.Font = Enum.Font.Code
consoleLabel.TextSize = 13
consoleLabel.Parent = console

--// STATUS BAR (bottom)
local status = Instance.new("Frame")
status.Size = UDim2.new(0.20, 0, 1, 0)
status.Position = UDim2.new(0.80, 0, 0, 0)
status.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
status.BorderSizePixel = 0
status.Parent = main

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.fromScale(1,1)
statusText.BackgroundTransparency = 1
statusText.Text = "READY • Stage 1 Step 1"
statusText.TextColor3 = Color3.fromRGB(180,180,180)
statusText.Font = Enum.Font.Code
statusText.TextSize = 12
statusText.Parent = status

--// DRAG SYSTEM (mobile + PC)
local dragging = false
local dragStart
local startPos

topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = root.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        root.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// OPEN BUTTON
openBtn.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)
--// =========================
--// STEP 2 FIX + STEP 3 START
--// =========================

--// KEYWORDS (future syntax highlight base)
local keywords = {
    ["local"] = true,
    ["function"] = true,
    ["end"] = true,
    ["if"] = true,
    ["then"] = true,
    ["for"] = true,
    ["while"] = true,
    ["return"] = true
}

--// CONSOLE SYSTEM (STEP 3 START)
local consoleFrame = console

local consoleBox = Instance.new("TextLabel")
consoleBox.Size = UDim2.new(1, -10, 1, -10)
consoleBox.Position = UDim2.new(0, 5, 0, 5)
consoleBox.BackgroundTransparency = 1
consoleBox.TextXAlignment = Enum.TextXAlignment.Left
consoleBox.TextYAlignment = Enum.TextYAlignment.Top
consoleBox.Font = Enum.Font.Code
consoleBox.TextSize = 13
consoleBox.TextColor3 = Color3.fromRGB(180, 180, 180)
consoleBox.Text = "-- StudioDev Console Ready"
consoleBox.TextWrapped = false
consoleBox.Parent = consoleFrame

--// LOG FUNCTION (used later for executor output)
local function log(msg, typeTag)
    typeTag = typeTag or "INFO"

    consoleBox.Text = consoleBox.Text ..
        "\n[" .. typeTag .. "] " .. tostring(msg)
end

--// FIXED STATUS + LIVE LINE TRACKER
local function updateStatus()
    local lines = #string.split(textBox.Text, "\n")

    statusText.Text =
        "LINES: " .. lines ..
        " • CHARS: " .. #textBox.Text ..
        " • StudioDev Step 2/3"
end

--// EXECUTION CORE (STEP 3 FOUNDATION)
local function runCode()
    local func, err = loadstring(textBox.Text)

    if not func then
        log(err, "ERROR")
        return
    end

    local success, result = pcall(func)

    if not success then
        log(result, "ERROR")
    else
        log("Executed successfully", "OK")
    end
end

--// EXECUTE KEY (temporary for testing)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F5 then
        runCode()
    end
end)

--// LIVE UPDATE CONNECTIONS
textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)

--// INIT
updateStatus()
--// =========================
--// STAGE 1 - STEP 3 FULL SYSTEM
--// =========================

--// CONSOLE UI (upgrade Step 2 console)
consoleFrame:ClearAllChildren()

local consoleList = Instance.new("TextLabel")
consoleList.Size = UDim2.new(1, -10, 1, -40)
consoleList.Position = UDim2.new(0, 5, 0, 5)
consoleList.BackgroundTransparency = 1
consoleList.TextXAlignment = Enum.TextXAlignment.Left
consoleList.TextYAlignment = Enum.TextYAlignment.Top
consoleList.Font = Enum.Font.Code
consoleList.TextSize = 13
consoleList.TextColor3 = Color3.fromRGB(200, 200, 200)
consoleList.Text = ""
consoleList.Parent = consoleFrame

--// CONSOLE STATE
local consoleLines = {}

local function refreshConsole()
    consoleList.Text = table.concat(consoleLines, "\n")
end

--// LOG SYSTEM (IMPROVED)
local function log(msg, typeTag)
    typeTag = typeTag or "INFO"

    local colors = {
        INFO = "[INFO] ",
        OK = "[OK] ",
        ERROR = "[ERROR] "
    }

    local prefix = colors[typeTag] or "[INFO] "

    table.insert(consoleLines, prefix .. tostring(msg))

    if #consoleLines > 200 then
        table.remove(consoleLines, 1)
    end

    refreshConsole()
end

--// CLEAR CONSOLE BUTTON
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 80, 0, 25)
clearBtn.Position = UDim2.new(1, -85, 0, 5)
clearBtn.Text = "Clear"
clearBtn.Font = Enum.Font.Code
clearBtn.TextSize = 12
clearBtn.TextColor3 = Color3.fromRGB(255,255,255)
clearBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
clearBtn.Parent = consoleFrame

Instance.new("UICorner", clearBtn)

clearBtn.MouseButton1Click:Connect(function()
    consoleLines = {}
    refreshConsole()
end)

--// RUN BUTTON (UI)
local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0, 80, 0, 25)
runBtn.Position = UDim2.new(1, -170, 0, 5)
runBtn.Text = "Run"
runBtn.Font = Enum.Font.Code
runBtn.TextSize = 12
runBtn.TextColor3 = Color3.fromRGB(255,255,255)
runBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
runBtn.Parent = consoleFrame

Instance.new("UICorner", runBtn)

--// SAFE EXECUTION WRAPPER
local function runCode()
    log("Executing script...", "INFO")

    local func, err = loadstring(textBox.Text)

    if not func then
        log(err, "ERROR")
        return
    end

    local success, result = pcall(func)

    if not success then
        log(result, "ERROR")
    else
        log("Script executed successfully", "OK")
    end
end

runBtn.MouseButton1Click:Connect(runCode)

--// KEYBINDS (F5 RUN)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F5 then
        runCode()
    end
end)

--// STATUS UPDATE IMPROVED
local function updateStatus()
    statusText.Text =
        "LINES: " .. #string.split(textBox.Text, "\n") ..
        " | CHARS: " .. #textBox.Text ..
        " | LOGS: " .. #consoleLines ..
        " | StudioDev Step 3"
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)

--// INITIAL LOG
log("StudioDev Console Initialized", "OK")
--// =========================
--// STAGE 1 - STEP 4
--// TABS + SESSIONS + AUTOCOMPLETE BASE
--// =========================

--// SCRIPT STORAGE (multi-tab system)
local scripts = {
    ["Main"] = "-- Main Script\nprint('Hello from Main')"
}

local currentScript = "Main"

--// ADD TAB BUTTONS CONTAINER
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -10, 0, 25)
tabBar.Position = UDim2.new(0, 5, 0, 40)
tabBar.BackgroundTransparency = 1
tabBar.Parent = editor

local function createTab(name)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 100, 1, 0)
    tab.BackgroundColor3 = Color3.fromRGB(45,45,50)
    tab.TextColor3 = Color3.fromRGB(220,220,220)
    tab.Font = Enum.Font.Code
    tab.TextSize = 12
    tab.Text = name
    tab.Parent = tabBar

    Instance.new("UICorner", tab)

    tab.MouseButton1Click:Connect(function()
        scripts[currentScript] = textBox.Text
        currentScript = name
        textBox.Text = scripts[name] or ""
        log("Switched to script: "..name, "INFO")
    end)

    return tab
end

--// DEFAULT TAB
createTab("Main")

--// ADD NEW TAB BUTTON
local newTab = Instance.new("TextButton")
newTab.Size = UDim2.new(0, 30, 1, 0)
newTab.Position = UDim2.new(0, 105, 0, 0)
newTab.Text = "+"
newTab.Font = Enum.Font.Code
newTab.TextSize = 18
newTab.TextColor3 = Color3.fromRGB(255,255,255)
newTab.BackgroundColor3 = Color3.fromRGB(0,120,200)
newTab.Parent = tabBar
Instance.new("UICorner", newTab)

newTab.MouseButton1Click:Connect(function()
    local newName = "Script" .. tostring(#scripts + 1)

    scripts[newName] = "-- New Script\n"

    createTab(newName)

    log("Created new script: "..newName, "OK")
end)

--// SAVE SYSTEM (session memory)
local function saveCurrent()
    scripts[currentScript] = textBox.Text
end

textBox:GetPropertyChangedSignal("Text"):Connect(saveCurrent)

--// LOAD INITIAL SCRIPT
textBox.Text = scripts[currentScript]

--// BASIC AUTOCOMPLETE (lightweight)
local suggestions = {
    "print()",
    "local ",
    "function ",
    "end",
    "if ",
    "then",
    "for ",
    "while ",
    "return "
}

textBox.Focused:Connect(function()
    log("Editor focused", "INFO")
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.Tab then
        local text = textBox.Text

        for _, s in ipairs(suggestions) do
            if string.find(s, text:sub(-3)) then
                textBox.Text = text .. s
                textBox.CursorPosition = #textBox.Text
                break
            end
        end
    end
end)

--// STATUS UPDATE FINAL UPGRADE
local function updateStatus()
    statusText.Text =
        "SCRIPT: " .. currentScript ..
        " | LINES: " .. #string.split(textBox.Text, "\n") ..
        " | CHARS: " .. #textBox.Text ..
        " | TABS: " .. tostring(#scripts) ..
        " | StudioDev Step 4"
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)

log("Tab system initialized", "OK")
--// =========================
--// STAGE 2 - STEP 1
--// SYNTAX HIGHLIGHT OVERLAY
--// =========================

local highlightFrame = Instance.new("TextLabel")
highlightFrame.Size = textBox.Size
highlightFrame.Position = textBox.Position
highlightFrame.BackgroundTransparency = 1
highlightFrame.TextXAlignment = Enum.TextXAlignment.Left
highlightFrame.TextYAlignment = Enum.TextYAlignment.Top
highlightFrame.Font = Enum.Font.Code
highlightFrame.TextSize = 14
highlightFrame.RichText = true
highlightFrame.TextWrapped = false
highlightFrame.Text = ""
highlightFrame.TextColor3 = Color3.fromRGB(220,220,220)
highlightFrame.Parent = editor

-- move overlay behind textbox visually
highlightFrame.ZIndex = textBox.ZIndex - 1

--// LUA SYNTAX COLORS
local colors = {
    keyword = "rgb(86,156,214)",
    string = "rgb(214,157,133)",
    number = "rgb(181,206,168)",
    comment = "rgb(87,166,74)",
    normal = "rgb(220,220,220)"
}

local keywords = {
    ["local"]=true,["function"]=true,["end"]=true,
    ["if"]=true,["then"]=true,["else"]=true,
    ["for"]=true,["while"]=true,["return"]=true,
    ["in"]=true,["do"]=true
}

--// SIMPLE LUA TOKENIZER
local function highlight(text)
    local result = text

    -- comments
    result = result:gsub("(%-%-.-)\n", function(c)
        return "<font color='"..colors.comment.."'>"..c.."</font>\n"
    end)

    -- strings
    result = result:gsub("(['\"])(.-)%1", function(q, str)
        return "<font color='"..colors.string.."'>"..q..str..q.."</font>"
    end)

    -- numbers
    result = result:gsub("(%d+)", function(n)
        return "<font color='"..colors.number.."'>"..n.."</font>"
    end)

    -- keywords
    for word in pairs(keywords) do
        result = result:gsub("%f[%w]"..word.."%f[%W]",
            "<font color='"..colors.keyword.."'>"..word.."</font>")
    end

    return result
end

--// LIVE SYNC
local function updateHighlight()
    highlightFrame.Text = highlight(textBox.Text)
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateHighlight)

updateHighlight()
--// =========================
--// STAGE 2 - STEP 2
--// EDITOR SYNC + LINE HIGHLIGHT
--// =========================

--// MAKE EDITOR SCROLLABLE SYNC FIX
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = textBox.Size
scrollFrame.Position = textBox.Position
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.Parent = editor

textBox.Parent = scrollFrame
highlightFrame.Parent = scrollFrame

-- keep overlay same size as textBox
highlightFrame.Size = textBox.Size

--// ACTIVE LINE HIGHLIGHT (visual helper)
local lineHighlight = Instance.new("Frame")
lineHighlight.Size = UDim2.new(1, 0, 0, 18)
lineHighlight.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
lineHighlight.BackgroundTransparency = 0.5
lineHighlight.BorderSizePixel = 0
lineHighlight.ZIndex = 0
lineHighlight.Parent = scrollFrame

--// UPDATE LINE HIGHLIGHT POSITION
local function updateActiveLine()
    local _, count = textBox.Text:gsub("\n", "")
    local lines = count + 1

    -- crude approximation (Roblox limitation)
    local lineHeight = 18
    local y = (lines - 1) * lineHeight

    lineHighlight.Position = UDim2.new(0, 0, 0, y)
end

--// SYNC SCROLL + RENDER
local function syncEditor()
    highlightFrame.Position = UDim2.new(0,0,0,-scrollFrame.CanvasPosition.Y)
    textBox.Position = UDim2.new(0,0,0,-scrollFrame.CanvasPosition.Y)

    updateActiveLine()
end

--// PERFORMANCE SAFE UPDATE LOOP
local running = true

task.spawn(function()
    while running do
        syncEditor()
        task.wait(0.03)
    end
end)

--// EVENTS
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateActiveLine()
end)

scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(syncEditor)
--// =========================
--// STAGE 2 - STEP 3
--// FIND / REPLACE + AUTOSAVE + TAB UX
--// =========================

--// TAB UX (ACTIVE TAB HIGHLIGHT FIX)
local tabButtons = {}

local function setActiveTab(activeName)
    for name, btn in pairs(tabButtons) do
        if name == activeName then
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end
    end
end

-- override your createTab function behavior if exists
local oldCreateTab = createTab
createTab = function(name)
    local tab = oldCreateTab(name)
    tabButtons[name] = tab

    tab.MouseButton1Click:Connect(function()
        setActiveTab(name)
    end)

    return tab
end

--// FIND / REPLACE UI
local findFrame = Instance.new("Frame")
findFrame.Size = UDim2.new(0, 300, 0, 70)
findFrame.Position = UDim2.new(1, -310, 0, 5)
findFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
findFrame.Visible = false
findFrame.Parent = editor

Instance.new("UICorner", findFrame)

local findBox = Instance.new("TextBox")
findBox.Size = UDim2.new(1, -10, 0, 25)
findBox.Position = UDim2.new(0, 5, 0, 5)
findBox.PlaceholderText = "Find..."
findBox.Text = ""
findBox.Font = Enum.Font.Code
findBox.TextSize = 12
findBox.TextColor3 = Color3.fromRGB(255,255,255)
findBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
findBox.Parent = findFrame

Instance.new("UICorner", findBox)

local replaceBox = Instance.new("TextBox")
replaceBox.Size = UDim2.new(1, -10, 0, 25)
replaceBox.Position = UDim2.new(0, 5, 0, 35)
replaceBox.PlaceholderText = "Replace..."
replaceBox.Text = ""
replaceBox.Font = Enum.Font.Code
replaceBox.TextSize = 12
replaceBox.TextColor3 = Color3.fromRGB(255,255,255)
replaceBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
replaceBox.Parent = findFrame

Instance.new("UICorner", replaceBox)

--// FIND FUNCTION
local function findAndReplace()
    local text = textBox.Text
    local find = findBox.Text
    local replace = replaceBox.Text

    if find == "" then return end

    local newText = string.gsub(text, find, replace)
    textBox.Text = newText
end

-- ENTER triggers replace
replaceBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        findAndReplace()
    end
end)

--// TOGGLE FIND MENU (CTRL + F)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        findFrame.Visible = not findFrame.Visible
    end
end)

--// AUTOSAVE SYSTEM (SESSION MEMORY)
local autoSave = {}

local function saveScript()
    autoSave[currentScript] = textBox.Text
end

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    saveScript()
end)

-- restore on switch
local function loadScript(name)
    textBox.Text = autoSave[name] or scripts[name] or ""
end

-- patch tab switching if needed
log("Find/Replace + Autosave initialized", "OK")
--// =========================
--// STAGE 2 - STEP 4
--// EDITOR POLISH + UX UPGRADES
--// =========================

--// FONT SIZE SYSTEM
local fontSize = 14
textBox.TextSize = fontSize
highlightFrame.TextSize = fontSize

local function setFontSize(size)
    fontSize = math.clamp(size, 10, 24)
    textBox.TextSize = fontSize
    highlightFrame.TextSize = fontSize
end

-- Zoom in / out (Ctrl + Scroll)
UIS.InputChanged:Connect(function(input, gpe)
    if gpe then return end

    if input.UserInputType == Enum.UserInputType.MouseWheel then
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            if input.Position.Z > 0 then
                setFontSize(fontSize + 1)
            else
                setFontSize(fontSize - 1)
            end
        end
    end
end)

--// WORD WRAP TOGGLE
local wordWrap = false

local function applyWrap()
    textBox.TextWrapped = wordWrap
    highlightFrame.TextWrapped = wordWrap
end

-- example toggle button (attach to your UI)
local wrapBtn = Instance.new("TextButton")
wrapBtn.Size = UDim2.new(0, 120, 0, 25)
wrapBtn.Position = UDim2.new(0, 5, 0, 5)
wrapBtn.Text = "Word Wrap: OFF"
wrapBtn.Font = Enum.Font.Code
wrapBtn.TextSize = 12
wrapBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
wrapBtn.TextColor3 = Color3.fromRGB(255,255,255)
wrapBtn.Parent = editor
Instance.new("UICorner", wrapBtn)

wrapBtn.MouseButton1Click:Connect(function()
    wordWrap = not wordWrap
    wrapBtn.Text = wordWrap and "Word Wrap: ON" or "Word Wrap: OFF"
    applyWrap()
end)

applyWrap()

--// SMOOTH UI OPEN / CLOSE
local function tween(obj, props, t)
    game:GetService("TweenService"):Create(
        obj,
        TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

-- apply subtle fade-in effect on load
main.BackgroundTransparency = 1
tween(main, {BackgroundTransparency = 0}, 0.35)

--// CLEAN PERFORMANCE PASS
task.spawn(function()
    while task.wait(1) do
        -- prevent memory buildup from highlights (light cleanup hook)
        if #consoleLines and #consoleLines > 250 then
            for i = 1, 50 do
                table.remove(consoleLines, 1)
            end
        end
    end
end)

--// FINAL STATUS UPDATE CLEANUP
local function updateStatus()
    statusText.Text =
        "SCRIPT: " .. currentScript ..
        " | LINES: " .. #string.split(textBox.Text, "\n") ..
        " | FONT: " .. fontSize ..
        " | WRAP: " .. tostring(wordWrap) ..
        " | Stage 2 Complete"
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)

updateStatus()
--// =========================
--// STAGE 3 - STEP 1
--// CURSOR + EDITOR BEHAVIOR UPGRADE
--// =========================

--// CURSOR LINE INDICATOR (visual approximation)
local cursorLine = Instance.new("Frame")
cursorLine.Size = UDim2.new(1, 0, 0, fontSize + 4)
cursorLine.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
cursorLine.BackgroundTransparency = 0.6
cursorLine.BorderSizePixel = 0
cursorLine.ZIndex = 0
cursorLine.Parent = scrollFrame

--// TRACK "APPROXIMATE CURSOR POSITION"
local function getLineFromCursor()
    local text = textBox.Text
    local beforeCursor = string.sub(text, 1, textBox.CursorPosition or #text)

    local lines = select(2, beforeCursor:gsub("\n", "")) + 1
    return lines
end

--// UPDATE CURSOR VISUAL
local function updateCursorLine()
    local line = getLineFromCursor()
    local y = (line - 1) * (fontSize + 4)

    cursorLine.Position = UDim2.new(0, 0, 0, y)
end

--// IMPROVED SYNC LOOP (removes jitter)
task.spawn(function()
    while task.wait(0.016) do -- ~60fps sync
        if scrollFrame and textBox then
            local offset = scrollFrame.CanvasPosition.Y

            highlightFrame.Position = UDim2.new(0, 0, 0, -offset)
            textBox.Position = UDim2.new(0, 0, 0, -offset)

            updateCursorLine()
        end
    end
end)

--// CURSOR UPDATE HOOKS
textBox:GetPropertyChangedSignal("CursorPosition"):Connect(updateCursorLine)
textBox:GetPropertyChangedSignal("Text"):Connect(updateCursorLine)

updateCursorLine()
--// =========================
--// STAGE 3 - STEP 2
--// COMMAND PALETTE SYSTEM
--// =========================

--// COMMAND PALETTE UI
local palette = Instance.new("Frame")
palette.Size = UDim2.new(0, 300, 0, 200)
palette.Position = UDim2.new(0.5, -150, 0.5, -100)
palette.BackgroundColor3 = Color3.fromRGB(25,25,25)
palette.Visible = false
palette.Parent = main

Instance.new("UICorner", palette)

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -10, 0, 30)
search.Position = UDim2.new(0, 5, 0, 5)
search.PlaceholderText = "Search command..."
search.Text = ""
search.Font = Enum.Font.Code
search.TextSize = 12
search.TextColor3 = Color3.fromRGB(255,255,255)
search.BackgroundColor3 = Color3.fromRGB(40,40,40)
search.Parent = palette

Instance.new("UICorner", search)

local list = Instance.new("TextButton")
list.Size = UDim2.new(1, -10, 1, -45)
list.Position = UDim2.new(0, 5, 0, 40)
list.Text = ""
list.AutoButtonColor = false
list.BackgroundTransparency = 1
list.Parent = palette

--// AVAILABLE COMMANDS
local commands = {
    "Run Script",
    "Clear Console",
    "Toggle Word Wrap",
    "Increase Font",
    "Decrease Font",
    "Find",
    "New Tab"
}

local function refreshList(filter)
    list:ClearAllChildren()

    for _, cmd in ipairs(commands) do
        if not filter or string.find(cmd:lower(), filter:lower()) then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 25)
            b.BackgroundColor3 = Color3.fromRGB(40,40,40)
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.Font = Enum.Font.Code
            b.TextSize = 12
            b.Text = cmd
            b.Parent = list
            Instance.new("UICorner", b)

            b.MouseButton1Click:Connect(function()
                if cmd == "Run Script" then
                    runCode()
                elseif cmd == "Clear Console" then
                    consoleLines = {}
                    refreshConsole()
                elseif cmd == "Toggle Word Wrap" then
                    wordWrap = not wordWrap
                    applyWrap()
                elseif cmd == "Increase Font" then
                    setFontSize(fontSize + 1)
                elseif cmd == "Decrease Font" then
                    setFontSize(fontSize - 1)
                elseif cmd == "Find" then
                    findFrame.Visible = true
                elseif cmd == "New Tab" then
                    local name = "Script" .. tostring(#scripts + 1)
                    scripts[name] = ""
                    createTab(name)
                end

                palette.Visible = false
            end)
        end
    end
end

refreshList()

search:GetPropertyChangedSignal("Text"):Connect(function()
    refreshList(search.Text)
end)

--// TOGGLE PALETTE (CTRL + P)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.P and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        palette.Visible = not palette.Visible
        search.Text = ""
        refreshList()
    end
end)
--// =========================
--// STAGE 3 - STEP 3
--// FINAL IDE POLISH PASS
--// =========================

--// SESSION SAVE / LOAD SYSTEM
local sessionData = {}

local function saveSession()
    sessionData[currentScript] = textBox.Text
end

local function loadSession(name)
    textBox.Text = sessionData[name] or scripts[name] or ""
end

textBox:GetPropertyChangedSignal("Text"):Connect(saveSession)

--// MINIMAP PREVIEW (FAKE OVERVIEW)
local minimap = Instance.new("TextLabel")
minimap.Size = UDim2.new(0, 120, 0, 200)
minimap.Position = UDim2.new(1, -130, 0, 40)
minimap.BackgroundColor3 = Color3.fromRGB(20,20,20)
minimap.TextColor3 = Color3.fromRGB(120,120,120)
minimap.Font = Enum.Font.Code
minimap.TextSize = 6
minimap.TextWrapped = true
minimap.TextXAlignment = Enum.TextXAlignment.Left
minimap.TextYAlignment = Enum.TextYAlignment.Top
minimap.Text = ""
minimap.Parent = editor

Instance.new("UICorner", minimap)

-- sync minimap
local function updateMinimap()
    local raw = textBox.Text

    -- compress text visually
    local preview = raw
        :gsub("\t", "  ")
        :gsub("\n\n", "\n")
        :sub(1, 2000)

    minimap.Text = preview
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateMinimap)

updateMinimap()

--// TAB REORDER VISUAL SYSTEM (simple swap logic)
local tabOrder = {}

local function registerTab(name, btn)
    table.insert(tabOrder, {name = name, button = btn})
end

local function swapTabs(i, j)
    if tabOrder[i] and tabOrder[j] then
        tabOrder[i], tabOrder[j] = tabOrder[j], tabOrder[i]

        local offset = 0
        for _, tab in ipairs(tabOrder) do
            tab.button.Position = UDim2.new(0, offset, 0, 0)
            offset += 105
        end
    end
end

-- optional keybind for demo reorder (Ctrl + Arrow)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        if input.KeyCode == Enum.KeyCode.Right then
            swapTabs(1, 2)
        elseif input.KeyCode == Enum.KeyCode.Left then
            swapTabs(2, 1)
        end
    end
end)

--// UI CLEANUP PASS (reduce lag + polish)
task.spawn(function()
    while task.wait(2) do
        -- trim console safely
        if #consoleLines > 300 then
            for i = 1, 100 do
                table.remove(consoleLines, 1)
            end
            refreshConsole()
        end

        -- refresh minimap occasionally instead of every frame
        updateMinimap()
    end
end)

--// FINAL STATUS UPDATE
local function updateStatus()
    statusText.Text =
        "SCRIPT: " .. currentScript ..
        " | LINES: " .. #string.split(textBox.Text, "\n") ..
        " | TABS: " .. tostring(#scripts) ..
        " | STAGE 3 COMPLETE"
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)

updateStatus()

log("Stage 3 Final Polish Loaded", "OK")
--// =========================
--// STAGE 3 - STEP 4
--// FINAL UI / PRO MODE OVERHAUL
--// =========================

local TweenService = game:GetService("TweenService")

--// DIM BACKGROUND (FOCUS MODE)
local dim = Instance.new("Frame")
dim.Size = UDim2.new(1,0,1,0)
dim.BackgroundColor3 = Color3.new(0,0,0)
dim.BackgroundTransparency = 1
dim.ZIndex = 0
dim.Parent = gui

--// PRO MODE TOGGLE
local proMode = false

local function toggleProMode()
    proMode = not proMode

    TweenService:Create(dim, TweenInfo.new(0.3), {
        BackgroundTransparency = proMode and 0.5 or 1
    }):Play()

    TweenService:Create(main, TweenInfo.new(0.3), {
        Size = proMode and UDim2.new(0, 650, 0, 400) or UDim2.new(0, 520, 0, 320)
    }):Play()
end

--// PRO MODE BUTTON
local proBtn = Instance.new("TextButton")
proBtn.Size = UDim2.new(0, 100, 0, 25)
proBtn.Position = UDim2.new(1, -110, 0, 5)
proBtn.Text = "Pro Mode"
proBtn.Font = Enum.Font.Code
proBtn.TextSize = 12
proBtn.TextColor3 = Color3.fromRGB(255,255,255)
proBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
proBtn.Parent = main

Instance.new("UICorner", proBtn)

proBtn.MouseButton1Click:Connect(toggleProMode)

--// SMOOTH WINDOW DRAG (IMPROVED)
local dragging = false
local dragStart, startPos
local dragVelocity = Vector2.zero

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        dragVelocity = Vector2.new(delta.X, delta.Y)

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// MOBILE FRIENDLY RESIZE HANDLER
local resizer = Instance.new("Frame")
resizer.Size = UDim2.new(0, 20, 0, 20)
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.BackgroundColor3 = Color3.fromRGB(80,80,80)
resizer.Parent = main

Instance.new("UICorner", resizer)

local resizing = false
local resizeStart
local startSize

resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = main.Size
    end
end)

UIS.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart

        main.Size = UDim2.new(
            startSize.X.Scale,
            math.max(400, startSize.X.Offset + delta.X),
            startSize.Y.Scale,
            math.max(250, startSize.Y.Offset + delta.Y)
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

--// OPEN / CLOSE ANIMATION FIX
local function animateOpen()
    main.BackgroundTransparency = 1
    main.Size = UDim2.new(0, 480, 0, 280)

    TweenService:Create(main, TweenInfo.new(0.35), {
        BackgroundTransparency = 0
    }):Play()

    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 520, 0, 320)
    }):Play()
end

animateOpen()

--// FINAL CLEANUP PASS
task.spawn(function()
    while task.wait(3) do
        if #consoleLines > 400 then
            for i = 1, 150 do
                table.remove(consoleLines, 1)
            end
            refreshConsole()
        end
    end
end)

log("Stage 3 Fully Complete — Pro UI Loaded", "OK")

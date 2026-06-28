--// STUDIODEV CORE (LOCAL SCRIPT VERSION)
--// Stage 1 - Part 1: UI FOUNDATION

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--// UI HELPERS
local function create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        inst[i] = v
    end
    return inst
end

local function tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

--// SCREEN GUI
local gui = create("ScreenGui", {
    Name = "StudioDev",
    ResetOnSpawn = false,
    Parent = PlayerGui
})

--// MAIN WINDOW
local main = create("Frame", {
    Size = UDim2.new(0, 620, 0, 380),
    Position = UDim2.new(0.5, -310, 0.5, -190),
    BackgroundColor3 = Color3.fromRGB(25, 25, 28),
    BorderSizePixel = 0,
    Parent = gui
})

create("UICorner", {
    CornerRadius = UDim.new(0, 10),
    Parent = main
})

--// TOP BAR
local topbar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    BorderSizePixel = 0,
    Parent = main
})

create("UICorner", {
    CornerRadius = UDim.new(0, 10),
    Parent = topbar
})

local title = create("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "StudioDev IDE",
    TextColor3 = Color3.fromRGB(230,230,230),
    Font = Enum.Font.Code,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = topbar
})

--// MAIN BODY
local body = create("Frame", {
    Size = UDim2.new(1, 0, 1, -36),
    Position = UDim2.new(0, 0, 0, 36),
    BackgroundTransparency = 1,
    Parent = main
})

--// SIDEBAR
local sidebar = create("Frame", {
    Size = UDim2.new(0, 140, 1, 0),
    BackgroundColor3 = Color3.fromRGB(30, 30, 34),
    BorderSizePixel = 0,
    Parent = body
})

--// EDITOR AREA
local editor = create("Frame", {
    Size = UDim2.new(1, -140, 0.65, 0),
    Position = UDim2.new(0, 140, 0, 0),
    BackgroundColor3 = Color3.fromRGB(20, 20, 22),
    BorderSizePixel = 0,
    Parent = body
})

local editorText = create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "-- editor coming in Part 2",
    TextColor3 = Color3.fromRGB(120,120,120),
    Font = Enum.Font.Code,
    TextSize = 14,
    Parent = editor
})

--// CONSOLE AREA
local console = create("Frame", {
    Size = UDim2.new(1, -140, 0.35, 0),
    Position = UDim2.new(0, 140, 0.65, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 18),
    BorderSizePixel = 0,
    Parent = body
})

local consoleText = create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "-- console coming in Part 2",
    TextColor3 = Color3.fromRGB(120,120,120),
    Font = Enum.Font.Code,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Parent = console
})

--// STATUS BAR
local status = create("Frame", {
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 1, -22),
    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
    BorderSizePixel = 0,
    Parent = main
})

local statusText = create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "READY • Stage 1 Part 1",
    TextColor3 = Color3.fromRGB(200,200,200),
    Font = Enum.Font.Code,
    TextSize = 12,
    Parent = status
})

--// DRAG SYSTEM (PC + MOBILE)
local dragging = false
local dragStart
local startPos

topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// TOGGLE (RightShift)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)--// =========================
--// STAGE 1 - PART 2 (FIXED)
--// Editor + Console Core
--// =========================

--// KEYWORDS (syntax highlight base later)
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

--// =========================
--// CREATE REAL TEXT EDITOR
--// =========================

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, 0, 1, 0)
textBox.BackgroundTransparency = 1
textBox.Text = "-- write Lua here"
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.Font = Enum.Font.Code
textBox.TextSize = 14
textBox.TextColor3 = Color3.fromRGB(220, 220, 220)
textBox.Parent = editor

-- replace placeholder label
editorText:Destroy()

--// =========================
--// CONSOLE SYSTEM
--// =========================

consoleText:Destroy()

local consoleBox = Instance.new("TextLabel")
consoleBox.Size = UDim2.new(1, 0, 1, 0)
consoleBox.BackgroundTransparency = 1
consoleBox.TextXAlignment = Enum.TextXAlignment.Left
consoleBox.TextYAlignment = Enum.TextYAlignment.Top
consoleBox.Font = Enum.Font.Code
consoleBox.TextSize = 13
consoleBox.TextColor3 = Color3.fromRGB(180, 180, 180)
consoleBox.Text = ""
consoleBox.Parent = console

local consoleLines = {}

local function log(msg, typeTag)
    typeTag = typeTag or "INFO"

    local prefix = {
        INFO = "[INFO]",
        OK = "[OK]",
        ERROR = "[ERROR]"
    }

    table.insert(consoleLines, (prefix[typeTag] or "[INFO]") .. " " .. tostring(msg))

    if #consoleLines > 200 then
        table.remove(consoleLines, 1)
    end

    consoleBox.Text = table.concat(consoleLines, "\n")
end

--// =========================
--// STATUS SYSTEM FIXED
--// =========================

local function updateStatus()
    local lines = #string.split(textBox.Text, "\n")

    statusText.Text =
        "LINES: " .. lines ..
        " | CHARS: " .. #textBox.Text ..
        " | STAGE 1 - PART 2"
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)

--// =========================
--// EXECUTION CORE (SAFE)
--// =========================

local function runCode()
    log("Executing script...", "INFO")

    local func, err = loadstring(textBox.Text)

    if not func then
        log(err, "ERROR")
        return
    end

    local success, result = pcall(func)

    if success then
        log("Executed successfully", "OK")
    else
        log(result, "ERROR")
    end
end

--// F5 RUN KEY
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        runCode()
    end
end)

--// INITIAL STATUS
updateStatus()
log("StudioDev editor initialized", "OK")--// =========================
--// STAGE 1 - PART 3 (FIXED)
--// Console Upgrade + Run UI
--// =========================

--// REBUILD CONSOLE INTO CLEAN SYSTEM
consoleBox:Destroy()

local consoleList = Instance.new("TextLabel")
consoleList.Size = UDim2.new(1, 0, 1, -35)
consoleList.Position = UDim2.new(0, 0, 0, 0)
consoleList.BackgroundTransparency = 1
consoleList.TextXAlignment = Enum.TextXAlignment.Left
consoleList.TextYAlignment = Enum.TextYAlignment.Top
consoleList.Font = Enum.Font.Code
consoleList.TextSize = 13
consoleList.TextColor3 = Color3.fromRGB(200, 200, 200)
consoleList.Text = ""
consoleList.Parent = console

--// CONSOLE STATE
local consoleLines = {}

local function refreshConsole()
    consoleList.Text = table.concat(consoleLines, "\n")
end

--// LOG FUNCTION (GLOBAL STYLE)
local function log(msg, typeTag)
    typeTag = typeTag or "INFO"

    local prefix = {
        INFO = "[INFO]",
        OK = "[OK]",
        ERROR = "[ERROR]"
    }

    table.insert(consoleLines, (prefix[typeTag] or "[INFO]") .. " " .. tostring(msg))

    if #consoleLines > 200 then
        table.remove(consoleLines, 1)
    end

    refreshConsole()
end

--// =========================
--// BUTTONS (RUN + CLEAR)
--// =========================

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 80, 0, 25)
clearBtn.Position = UDim2.new(1, -90, 0, 5)
clearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
clearBtn.Text = "Clear"
clearBtn.TextColor3 = Color3.fromRGB(255,255,255)
clearBtn.Font = Enum.Font.Code
clearBtn.TextSize = 12
clearBtn.Parent = console

Instance.new("UICorner", clearBtn)

clearBtn.MouseButton1Click:Connect(function()
    consoleLines = {}
    refreshConsole()
end)

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0, 80, 0, 25)
runBtn.Position = UDim2.new(1, -175, 0, 5)
runBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
runBtn.Text = "Run"
runBtn.TextColor3 = Color3.fromRGB(255,255,255)
runBtn.Font = Enum.Font.Code
runBtn.TextSize = 12
runBtn.Parent = console

Instance.new("UICorner", runBtn)

--// =========================
--// SAFE EXECUTION (FIXED)
--// =========================

local function runCode()
    log("Executing script...", "INFO")

    if not textBox then
        log("Editor not found", "ERROR")
        return
    end

    local func, err = loadstring(textBox.Text)

    if not func then
        log(err, "ERROR")
        return
    end

    local success, result = pcall(func)

    if success then
        log("Script executed successfully", "OK")
    else
        log(result, "ERROR")
    end
end

runBtn.MouseButton1Click:Connect(runCode)

--// F5 HOTKEY
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        runCode()
    end
end)

--// =========================
--// STATUS UPDATE FIXED
--// =========================

local function updateStatus()
    statusText.Text =
        "LINES: " .. #string.split(textBox.Text, "\n") ..
        " | CHARS: " .. #textBox.Text ..
        " | LOGS: " .. #consoleLines ..
        " | STAGE 1 - PART 3"
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)

--// INIT LOG
log("Console system initialized", "OK")--// =========================
--// STAGE 1 - STEP 4 (FIXED ONLY)
--// TABS + SESSION SYSTEM + BASIC AUTOCOMPLETE
--// =========================

--// MAKE SURE REQUIRED VARS EXIST
-- expects:
-- textBox, editor, log, consoleLines, consoleList, statusText, UserInputService

--// SCRIPT STORAGE
local scripts = scripts or {
    Main = textBox.Text or "-- Main Script"
}

local currentScript = currentScript or "Main"

--// TAB BAR
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
        if log then log("Switched to: "..name, "INFO") end
    end)

    return tab
end

--// DEFAULT TAB
createTab("Main")

--// NEW TAB BUTTON
local newTab = Instance.new("TextButton")
newTab.Size = UDim2.new(0, 30, 1, 0)
newTab.Position = UDim2.new(0, 105, 0, 0)
newTab.Text = "+"
newTab.Font = Enum.Font.Code
newTab.TextSize = 18
newTab.BackgroundColor3 = Color3.fromRGB(0,120,200)
newTab.TextColor3 = Color3.fromRGB(255,255,255)
newTab.Parent = tabBar
Instance.new("UICorner", newTab)

newTab.MouseButton1Click:Connect(function()
    local name = "Script_" .. tostring(#scripts + 1)
    scripts[name] = "-- New Script\n"
    createTab(name)
    if log then log("Created "..name, "OK") end
end)

--// SAVE CURRENT SCRIPT LIVE
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    scripts[currentScript] = textBox.Text
end)

--// LOAD CURRENT SCRIPT
textBox.Text = scripts[currentScript]

--// BASIC AUTOCOMPLETE LIST
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

--// TAB AUTOCOMPLETE
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.Tab then
        local text = textBox.Text

        for _, s in ipairs(suggestions) do
            if string.sub(s, 1, 3) == string.sub(text, -3) then
                textBox.Text = text .. s
                textBox.CursorPosition = #textBox.Text
                break
            end
        end
    end
end)

--// STATUS UPDATE (SAFE PATCH)
local function updateStatus()
    if not statusText then return end

    statusText.Text =
        "SCRIPT: "..currentScript..
        " | LINES: "..#string.split(textBox.Text, "\n")..
        " | CHARS: "..#textBox.Text..
        " | TABS: "..tostring(#scripts)
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateStatus)--// =========================
--// STAGE 2 - STEP 1 (RENEWED CLEAN PATCH)
--// EDITOR ENGINE RESTRUCTURE (NO DUPLICATES)
--// =========================

--// DO NOT REDEFINE KEYWORDS IF THEY ALREADY EXIST
if not _G.__StudioDevKeywords then
    _G.__StudioDevKeywords = {
        ["local"] = true,
        ["function"] = true,
        ["end"] = true,
        ["if"] = true,
        ["then"] = true,
        ["else"] = true,
        ["for"] = true,
        ["while"] = true,
        ["return"] = true,
        ["true"] = true,
        ["false"] = true
    }
end

local keywords = _G.__StudioDevKeywords

--// SAFE EDITOR STATE (single source of truth)
if not _G.__StudioDevState then
    _G.__StudioDevState = {
        lines = {},
        lineCount = 0,
        charCount = 0,
        lastText = ""
    }
end

local EditorState = _G.__StudioDevState

--// UPDATE FUNCTION (NO REPLACEMENT OF OLD SYSTEMS)
local function updateEditorState(text)
    if type(text) ~= "string" then return end

    EditorState.lastText = text
    EditorState.lines = string.split(text, "\n")
    EditorState.lineCount = #EditorState.lines
    EditorState.charCount = #text
end

--// SAFE STATUS PATCH (does NOT overwrite old logic blindly)
local function patchStatus()
    if not statusText then return end

    statusText.Text =
        "LINES: " .. EditorState.lineCount ..
        " | CHARS: " .. EditorState.charCount ..
        " | SCRIPT: " .. tostring(currentScript or "Main") ..
        " | STAGE 2-1"
end

--// CONNECT ONLY ONCE (prevents stacking connections)
if not _G.__StudioDevConnectionsBound then
    _G.__StudioDevConnectionsBound = true

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateEditorState(textBox.Text)
        patchStatus()

        if scripts and currentScript then
            scripts[currentScript] = textBox.Text
        end
    end)
end

--// INITIAL SYNC
updateEditorState(textBox.Text)
patchStatus()--// =========================
--// STAGE 2 - STEP 2
--// SYNTAX HIGHLIGHT ENGINE v1
--// =========================

--// UI LAYER FOR "HIGHLIGHTED TEXT"
-- (overlay label on top of textbox)
local highlight = Instance.new("TextLabel")
highlight.Size = textBox.Size
highlight.Position = textBox.Position
highlight.BackgroundTransparency = 1
highlight.TextXAlignment = Enum.TextXAlignment.Left
highlight.TextYAlignment = Enum.TextYAlignment.Top
highlight.Font = Enum.Font.Code
highlight.TextSize = textBox.TextSize
highlight.TextColor3 = Color3.fromRGB(120, 200, 255)
highlight.RichText = true
highlight.TextWrapped = false
highlight.Text = ""
highlight.Parent = textBox.Parent

--// COLOR MAP
local colors = {
    keyword = "rgb(0,170,255)",
    number = "rgb(255,200,0)",
    string = "rgb(0,255,140)",
    normal = "rgb(220,220,220)"
}

--// SAFE ESCAPE FOR RICH TEXT
local function escape(str)
    return str
        :gsub("&", "&amp;")
        :gsub("<", "&lt;")
        :gsub(">", "&gt;")
end

--// TOKENIZER (simple but stable)
local function highlightLine(line)
    local result = escape(line)

    -- strings
    result = result:gsub("\"(.-)\"", function(s)
        return '<font color="'..colors.string..'">"'..s..'"</font>'
    end)

    result = result:gsub("'(.-)'", function(s)
        return '<font color="'..colors.string..'">\''..s..'\'</font>'
    end)

    -- numbers
    result = result:gsub("%f[%d]%d+%f[%D]", function(n)
        return '<font color="'..colors.number..'">'..n..'</font>'
    end)

    -- keywords (from GLOBAL safe table)
    for k, _ in pairs(_G.__StudioDevKeywords or {}) do
        result = result:gsub("%f[%a]"..k.."%f[%A]", function(word)
            return '<font color="'..colors.keyword..'">'..word..'</font>'
        end)
    end

    return result
end

--// MAIN RENDER FUNCTION
local function renderHighlight()
    if not EditorState then return end

    local lines = EditorState.lines
    local out = {}

    for i = 1, #lines do
        table.insert(out, highlightLine(lines[i]))
    end

    highlight.Text = table.concat(out, "\n")
end

--// HOOK INTO YOUR EXISTING UPDATE PIPELINE
local oldUpdate = updateEditorState

updateEditorState = function(text)
    oldUpdate(text)
    renderHighlight()
end

--// INITIAL RENDER
renderHighlight()--// =========================
--// STAGE 2 - STEP 3
--// CURSOR + ACTIVE LINE SYSTEM
--// =========================

--// ACTIVE LINE BACKGROUND
local lineHighlight = Instance.new("Frame")
lineHighlight.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
lineHighlight.BackgroundTransparency = 0.5
lineHighlight.BorderSizePixel = 0
lineHighlight.Size = UDim2.new(1, 0, 0, 18)
lineHighlight.Position = UDim2.new(0, 0, 0, 0)
lineHighlight.ZIndex = 0
lineHighlight.Parent = textBox

-- push highlight behind text
lineHighlight.ZIndex = 0
textBox.ZIndex = 2

--// GET CURRENT LINE INDEX
local function getCursorLine()
    local text = textBox.Text or ""
    local cursorPos = textBox.CursorPosition

    if cursorPos <= 0 then
        return 1
    end

    local beforeCursor = string.sub(text, 1, cursorPos)
    local _, count = beforeCursor:gsub("\n", "\n")

    return count + 1
end

--// UPDATE LINE HIGHLIGHT POSITION
local function updateLineHighlight()
    local line = getCursorLine()

    -- estimate line height (TextSize approximation)
    local lineHeight = textBox.TextSize + 2

    lineHighlight.Position = UDim2.new(0, 0, 0, (line - 1) * lineHeight)
end

--// SAFE UPDATE HOOK (no loops, no spam)
textBox:GetPropertyChangedSignal("CursorPosition"):Connect(updateLineHighlight)
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    task.wait() -- let layout update first
    updateLineHighlight()
end)

--// INITIAL POSITION
updateLineHighlight()--// =========================
--// STAGE 2 - STEP 4
--// LINE NUMBERS + SCROLL SYNC + SELECTION BASE
--// =========================

--// LINE NUMBER PANEL
local lineNumbers = Instance.new("TextLabel")
lineNumbers.Size = UDim2.new(0, 40, 1, 0)
lineNumbers.Position = UDim2.new(0, 0, 0, 0)
lineNumbers.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
lineNumbers.TextColor3 = Color3.fromRGB(120, 120, 120)
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = textBox.TextSize
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.TextXAlignment = Enum.TextXAlignment.Center
lineNumbers.Text = "1"
lineNumbers.Parent = textBox.Parent

-- shift editor text to the right so numbers fit
textBox.Position = UDim2.new(0, 45, 0, 5)
textBox.Size = UDim2.new(1, -50, 1, -10)

highlight.Position = textBox.Position
highlight.Size = textBox.Size

lineHighlight.Position = textBox.Position

--// UPDATE LINE NUMBERS
local function updateLineNumbers()
    local lines = EditorState.lines or {}
    local out = {}

    for i = 1, math.max(#lines, 1) do
        table.insert(out, tostring(i))
    end

    lineNumbers.Text = table.concat(out, "\n")
end

--// SCROLL SYNC (simple + safe)
local function syncScroll()
    -- keeps highlight + numbers aligned with text scroll
    highlight.Position = textBox.Position
    lineNumbers.Position = UDim2.new(0, 0, 0, 0)
end

--// SELECTION TRACKER (BASE ONLY)
local function getSelection()
    local s = textBox.SelectionStart
    local e = textBox.CursorPosition

    if not s or s == 0 then return nil end

    return {
        startPos = math.min(s, e),
        endPos = math.max(s, e)
    }
end

--// SAFE UPDATE PIPELINE HOOK
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateLineNumbers()
    syncScroll()
end)

textBox:GetPropertyChangedSignal("CursorPosition"):Connect(function()
    updateLineHighlight()
end)

--// INITIAL BUILD
updateLineNumbers()
syncScroll()--// =========================
--// STAGE 3 - STEP 1
--// REAL EDITOR CORE FIX
--// =========================

--// CREATE ACTUAL TEXTBOX EDITOR (THIS WAS MISSING BEFORE)
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -10, 1, -10)
textBox.Position = UDim2.new(0, 5, 0, 5)
textBox.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
textBox.TextColor3 = Color3.fromRGB(220, 220, 220)
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.Font = Enum.Font.Code
textBox.TextSize = 14
textBox.TextWrapped = false
textBox.Text = "-- write code here"
textBox.Parent = editor

--// LINE NUMBERS (simple version)
local lineNumbers = Instance.new("TextLabel")
lineNumbers.Size = UDim2.new(0, 40, 1, -10)
lineNumbers.Position = UDim2.new(0, 0, 0, 5)
lineNumbers.BackgroundTransparency = 1
lineNumbers.TextColor3 = Color3.fromRGB(120,120,120)
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = 13
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Text = "1"
lineNumbers.Parent = editor

--// UPDATE LINE NUMBERS
local function updateLines()
    local lines = #string.split(textBox.Text, "\n")
    local out = ""

    for i = 1, lines do
        out ..= i .. "\n"
    end

    lineNumbers.Text = out
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateLines)
updateLines()

--// BASIC STATUS FIX HOOK
statusText.Text = "EDITOR READY • Stage 3 Step 1"--// =========================
--// STAGE 3 - STEP 2 (FIXED)
--// SYNTAX OVERLAY SYSTEM (NO DUPLICATES)
--// =========================

--// SAFE KEYWORD REUSE (DO NOT DUPLICATE TABLE)
local keywordSet = keywords or {
    ["local"] = true,
    ["function"] = true,
    ["end"] = true,
    ["if"] = true,
    ["then"] = true,
    ["for"] = true,
    ["while"] = true,
    ["return"] = true,
    ["do"] = true,
    ["else"] = true
}

--// OVERLAY LABEL (syntax display layer)
local highlight = Instance.new("TextLabel")
highlight.Size = textBox.Size
highlight.Position = textBox.Position
highlight.BackgroundTransparency = 1
highlight.TextXAlignment = Enum.TextXAlignment.Left
highlight.TextYAlignment = Enum.TextYAlignment.Top
highlight.Font = Enum.Font.Code
highlight.TextSize = 14
highlight.TextWrapped = false
highlight.RichText = true
highlight.TextColor3 = Color3.fromRGB(220, 220, 220)
highlight.Parent = editor
highlight.ZIndex = textBox.ZIndex - 1

--// SAFE HIGHLIGHT FUNCTION
local function applyHighlight(text)
    local result = text

    for word in pairs(keywordSet) do
        result = result:gsub(
            "%f[%w]" .. word .. "%f[%W]",
            "<font color='rgb(86,156,214)'>" .. word .. "</font>"
        )
    end

    -- string highlight
    result = result:gsub(
        "\"(.-)\"",
        "<font color='rgb(214,157,133)'>\"%1\"</font>"
    )

    return result
end

--// REFRESH SYSTEM
local function refreshEditor()
    highlight.Text = applyHighlight(textBox.Text)
end

--// CONNECT SAFE UPDATE
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshEditor()
    updateLines()
end)

refreshEditor()

statusText.Text = "SYNTAX READY (SAFE MODE) • Stage 3 Step 2"--// =========================
--// STAGE 3 - STEP 3
--// SCROLL + SYNC SYSTEM FIX
--// =========================

--// SCROLL CONTAINER (wrap editor properly)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = textBox.Size
scrollFrame.Position = textBox.Position
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = editor

--// RE-PARENT TEXTBOX INTO SCROLLFRAME
textBox.Parent = scrollFrame
textBox.Size = UDim2.new(1, 0, 1, 0)

--// RE-PARENT HIGHLIGHT INTO SCROLLFRAME
highlight.Parent = scrollFrame
highlight.Size = textBox.Size
highlight.Position = textBox.Position

--// AUTO RESIZE CANVAS (prevents cut-off text)
local function updateCanvas()
    local lines = #string.split(textBox.Text, "\n")
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, lines * 18)
end

--// SMOOTHER UPDATE LOOP (prevents lag spam)
local lastUpdate = 0
local function safeRefresh()
    local now = tick()
    if now - lastUpdate < 0.05 then return end -- throttle
    lastUpdate = now

    refreshEditor()
    updateLines()
    updateCanvas()
end

--// CONNECT CLEAN INPUT HANDLING
textBox:GetPropertyChangedSignal("Text"):Connect(safeRefresh)

--// FIX SCROLL SYNC (overlay follows scroll position)
scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    highlight.Position = UDim2.new(
        0,
        -scrollFrame.CanvasPosition.X,
        0,
        -scrollFrame.CanvasPosition.Y
    )
end)

--// INITIAL SYNC
safeRefresh()

statusText.Text = "EDITOR SCROLL FIXED • Stage 3 Step 3"--// =========================
--// STAGE 3 - STEP 4
--// CURSOR + INDENT + INPUT UPGRADE
--// =========================

--// AUTO INDENT SYSTEM (basic but effective)
local function getIndent(line)
    local spaces = line:match("^(%s*)") or ""
    return spaces
end

textBox.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Return then
        local text = textBox.Text
        local cursorPos = textBox.CursorPosition

        local beforeCursor = string.sub(text, 1, cursorPos)
        local lines = string.split(beforeCursor, "\n")
        local lastLine = lines[#lines] or ""

        local indent = getIndent(lastLine)

        task.defer(function()
            textBox.Text = textBox.Text
                .. "\n" .. indent

            textBox.CursorPosition = #textBox.Text
        end)
    end
end)

--// TAB INDENT SUPPORT
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.Tab then
        local before = string.sub(textBox.Text, 1, textBox.CursorPosition)
        local after = string.sub(textBox.Text, textBox.CursorPosition + 1)

        textBox.Text = before .. "    " .. after
        textBox.CursorPosition = #before + 4
    end
end)

--// CURSOR SYNC FIX (keeps overlay stable)
local function syncCursor()
    highlight.TextTransparency = 0
end

textBox:GetPropertyChangedSignal("CursorPosition"):Connect(syncCursor)

--// CLEAN UPDATE WRAPPER (final stabilization)
local function fullRefresh()
    refreshEditor()
    updateLines()
    updateCanvas()
    syncCursor()
end

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    fullRefresh()
end)

--// FINAL STATUS
statusText.Text = "EDITOR UPGRADED • Stage 3 Complete"--// =========================
--// STAGE 4 - STEP 1
--// FIND / SEARCH SYSTEM
--// =========================

--// SEARCH UI
local findBox = Instance.new("TextBox")
findBox.Size = UDim2.new(0, 180, 0, 25)
findBox.Position = UDim2.new(1, -190, 0, 5)
findBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
findBox.TextColor3 = Color3.fromRGB(255, 255, 255)
findBox.PlaceholderText = "Find..."
findBox.Font = Enum.Font.Code
findBox.TextSize = 12
findBox.ClearTextOnFocus = false
findBox.Parent = editor

Instance.new("UICorner", findBox)

--// MATCH HIGHLIGHT STORAGE
local matches = {}

--// SIMPLE FIND FUNCTION
local function updateFind()
    matches = {}

    local query = findBox.Text
    if query == "" then return end

    local text = textBox.Text
    local start = 1

    while true do
        local s, e = string.find(text:lower(), query:lower(), start, true)
        if not s then break end

        table.insert(matches, {s, e})
        start = e + 1
    end
end

--// HIGHLIGHT MATCHES (overlay hack)
local function applyFindHighlight(text)
    if #matches == 0 then return text end

    local result = text
    local offset = 0

    for _, match in ipairs(matches) do
        local s, e = match[1] + offset, match[2] + offset

        local before = string.sub(result, 1, s - 1)
        local mid = string.sub(result, s, e)
        local after = string.sub(result, e + 1)

        mid = "<font color='rgb(255, 255, 0)'>" .. mid .. "</font>"

        result = before .. mid .. after
        offset = offset + 28 -- rough shift compensation for RichText tags
    end

    return result
end

--// INTEGRATE INTO EXISTING REFRESH
local oldRefresh = refreshEditor

refreshEditor = function()
    local raw = textBox.Text

    local highlighted = applyHighlight(raw)
    highlight.Text = applyFindHighlight(highlighted)
end

--// UPDATE EVENTS
findBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateFind()
    refreshEditor()
end)

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateFind()
end)

--// KEYBIND: Ctrl + F focus
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        findBox:CaptureFocus()
    end
end)

statusText.Text = "FIND SYSTEM READY • Stage 4 Step 1"--// =========================
--// STAGE 4 - STEP 2
--// FIND & REPLACE SYSTEM
--// =========================

--// REPLACE UI
local replaceBox = Instance.new("TextBox")
replaceBox.Size = UDim2.new(0, 180, 0, 25)
replaceBox.Position = UDim2.new(1, -190, 0, 35)
replaceBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
replaceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
replaceBox.PlaceholderText = "Replace..."
replaceBox.Font = Enum.Font.Code
replaceBox.TextSize = 12
replaceBox.ClearTextOnFocus = false
replaceBox.Parent = editor

Instance.new("UICorner", replaceBox)

--// REPLACE BUTTON
local replaceBtn = Instance.new("TextButton")
replaceBtn.Size = UDim2.new(0, 180, 0, 25)
replaceBtn.Position = UDim2.new(1, -190, 0, 65)
replaceBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
replaceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
replaceBtn.Text = "Replace All"
replaceBtn.Font = Enum.Font.Code
replaceBtn.TextSize = 12
replaceBtn.Parent = editor

Instance.new("UICorner", replaceBtn)

--// REPLACE FUNCTION
local function replaceAll()
    local findText = findBox.Text
    local replaceText = replaceBox.Text

    if findText == "" then return end

    local newText = string.gsub(textBox.Text, findText, replaceText)

    textBox.Text = newText
    refreshEditor()
    updateLines()

    statusText.Text = "REPLACED ALL • Stage 4 Step 2"
end

replaceBtn.MouseButton1Click:Connect(replaceAll)

--// CTRL + H FOCUS
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        replaceBox:CaptureFocus()
    end
end)

--// LIVE SYNC (keep find results updated after replace)
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateFind()
    refreshEditor()
end)

statusText.Text = "REPLACE SYSTEM READY • Stage 4 Step 2"--// =========================
--// STAGE 4 - STEP 3
--// FIND MATCH NAVIGATION (F3 SYSTEM)
--// =========================

--// CURRENT MATCH INDEX
local currentMatch = 0

--// GET NEXT MATCH
local function nextMatch()
    if #matches == 0 then return end

    currentMatch += 1
    if currentMatch > #matches then
        currentMatch = 1
    end

    local match = matches[currentMatch]
    if not match then return end

    -- jump cursor to match start
    textBox.CursorPosition = match[1]

    statusText.Text = "MATCH " .. currentMatch .. "/" .. #matches .. " • NEXT"
end

--// GET PREVIOUS MATCH
local function prevMatch()
    if #matches == 0 then return end

    currentMatch -= 1
    if currentMatch < 1 then
        currentMatch = #matches
    end

    local match = matches[currentMatch]
    if not match then return end

    textBox.CursorPosition = match[1]

    statusText.Text = "MATCH " .. currentMatch .. "/" .. #matches .. " • PREV"
end

--// RESET MATCH INDEX ON NEW SEARCH
findBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentMatch = 0
end)

--// KEYBINDS
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- F3 = next match
    if input.KeyCode == Enum.KeyCode.F3 then
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            prevMatch()
        else
            nextMatch()
        end
    end
end)

--// OPTIONAL CLICK-BASED NAV BUTTONS (small UI helpers)
local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 80, 0, 25)
nextBtn.Position = UDim2.new(1, -190, 0, 95)
nextBtn.Text = "Next"
nextBtn.Font = Enum.Font.Code
nextBtn.TextSize = 12
nextBtn.TextColor3 = Color3.fromRGB(255,255,255)
nextBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
nextBtn.Parent = editor
Instance.new("UICorner", nextBtn)

nextBtn.MouseButton1Click:Connect(nextMatch)

local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.new(0, 80, 0, 25)
prevBtn.Position = UDim2.new(1, -100, 0, 95)
prevBtn.Text = "Prev"
prevBtn.Font = Enum.Font.Code
prevBtn.TextSize = 12
prevBtn.TextColor3 = Color3.fromRGB(255,255,255)
prevBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
prevBtn.Parent = editor
Instance.new("UICorner", prevBtn)

prevBtn.MouseButton1Click:Connect(prevMatch)

--// KEEP MATCH INDEX VALID
local function clampMatchIndex()
    if currentMatch > #matches then
        currentMatch = #matches
    end
end

textBox:GetPropertyChangedSignal("Text"):Connect(clampMatchIndex)

statusText.Text = "MATCH NAV READY • Stage 4 Step 3"--// =========================
--// STAGE 4 - STEP 4
--// MATCH FOCUS + STABILITY FIX
--// =========================

--// TRACK FOCUSED MATCH
local function applyFindHighlight(text)
    if #matches == 0 then return text end

    local result = ""
    local lastIndex = 1

    for i, match in ipairs(matches) do
        local s, e = match[1], match[2]

        -- skip invalid ranges
        if s < lastIndex then continue end

        local before = string.sub(text, lastIndex, s - 1)
        local mid = string.sub(text, s, e)

        -- current match = red, others = yellow
        local color = (i == currentMatch)
            and "255,80,80"
            or "255,255,0"

        mid = "<font color='rgb(" .. color .. ")'>" .. mid .. "</font>"

        result ..= before .. mid
        lastIndex = e + 1
    end

    result ..= string.sub(text, lastIndex)

    return result
end

--// SAFE REFRESH (prevents spam lag + flicker)
local lastRefresh = 0

local function stableRefresh()
    local now = tick()
    if now - lastRefresh < 0.03 then return end -- throttle ~33fps max updates
    lastRefresh = now

    refreshEditor()
    updateLines()
    updateCanvas()
end

--// REPLACE OLD REFRESH HOOK SAFELY
textBox:GetPropertyChangedSignal("Text"):Connect(stableRefresh)

--// KEEP CURRENT MATCH SAFE
local function safeMatchClamp()
    if currentMatch < 1 then
        currentMatch = 1
    end
    if currentMatch > #matches then
        currentMatch = #matches
    end
end

--// UPDATE MATCH SYSTEM SAFELY
findBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateFind()
    currentMatch = 0
    stableRefresh()
end)

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    safeMatchClamp()
end)

--// FINAL UI STATUS
statusText.Text = "FIND SYSTEM POLISHED • Stage 4 Complete"--// =========================
--// STAGE 5 - STEP 1
--// THEME + ACCENT SYSTEM
--// =========================

--// THEME STATE
local theme = {
    background = Color3.fromRGB(25, 25, 28),
    editorBg = Color3.fromRGB(20, 20, 22),
    sidebar = Color3.fromRGB(30, 30, 34),
    console = Color3.fromRGB(15, 15, 18),
    text = Color3.fromRGB(220, 220, 220),
    accent = Color3.fromRGB(0, 120, 200)
}

--// APPLY THEME FUNCTION
local function applyTheme()
    -- main containers
    root.BackgroundColor3 = theme.background
    editor.BackgroundColor3 = theme.editorBg
    console.BackgroundColor3 = theme.console

    -- sidebar (if exists)
    if sidebar then
        sidebar.BackgroundColor3 = theme.sidebar
    end

    -- text elements
    statusText.TextColor3 = theme.text
    textBox.TextColor3 = theme.text

    -- buttons (safe update if they exist)
    if runBtn then runBtn.BackgroundColor3 = theme.accent end
    if replaceBtn then replaceBtn.BackgroundColor3 = theme.accent end
    if newTab then newTab.BackgroundColor3 = theme.accent end

    -- overlay highlight fallback safety
    if highlight then
        highlight.TextColor3 = theme.text
    end
end

--// THEME SWITCHER UI
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0, 120, 0, 25)
themeBtn.Position = UDim2.new(1, -130, 1, -30)
themeBtn.Text = "Toggle Theme"
themeBtn.Font = Enum.Font.Code
themeBtn.TextSize = 12
themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeBtn.BackgroundColor3 = theme.accent
themeBtn.Parent = editor

Instance.new("UICorner", themeBtn)

--// DARK/LIGHT TOGGLE STATE
local darkMode = true

themeBtn.MouseButton1Click:Connect(function()
    darkMode = not darkMode

    if darkMode then
        theme.background = Color3.fromRGB(25, 25, 28)
        theme.editorBg = Color3.fromRGB(20, 20, 22)
        theme.console = Color3.fromRGB(15, 15, 18)
        theme.text = Color3.fromRGB(220, 220, 220)
        theme.accent = Color3.fromRGB(0, 120, 200)
    else
        theme.background = Color3.fromRGB(235, 235, 240)
        theme.editorBg = Color3.fromRGB(255, 255, 255)
        theme.console = Color3.fromRGB(240, 240, 245)
        theme.text = Color3.fromRGB(30, 30, 30)
        theme.accent = Color3.fromRGB(0, 150, 255)
    end

    applyTheme()
end)

--// ACCENT LIVE UPDATE HOOK (safe reuse)
local function setAccent(color)
    theme.accent = color
    applyTheme()
end

--// INITIAL APPLY
applyTheme()

statusText.Text = "THEME SYSTEM READY • Stage 5 Step 1"--// =========================
--// STAGE 5 - STEP 2
--// AUTOCOMPLETE DROPDOWN
--// =========================

local suggestions = {
    "print()",
    "local ",
    "function ",
    "end",
    "if ",
    "then ",
    "for ",
    "while ",
    "return ",
    "game:GetService()"
}

--// DROPDOWN UI
local suggestionFrame = Instance.new("Frame")
suggestionFrame.Size = UDim2.new(0, 180, 0, 0)
suggestionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
suggestionFrame.BorderSizePixel = 0
suggestionFrame.Visible = false
suggestionFrame.Parent = editor

Instance.new("UICorner", suggestionFrame)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = suggestionFrame

--// CLEAR OLD BUTTONS
local function clearSuggestions()
    for _, v in ipairs(suggestionFrame:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
end

--// SHOW SUGGESTIONS
local function showSuggestions(prefix)
    clearSuggestions()

    local count = 0

    for _, s in ipairs(suggestions) do
        if string.sub(s:lower(), 1, #prefix):lower() == prefix:lower() then

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 22)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.Font = Enum.Font.Code
            btn.TextSize = 12
            btn.Text = s
            btn.Parent = suggestionFrame

            btn.MouseButton1Click:Connect(function()
                local text = textBox.Text
                local cursor = textBox.CursorPosition

                local before = string.sub(text, 1, cursor)
                local after = string.sub(text, cursor + 1)

                textBox.Text = before .. s .. after
                textBox.CursorPosition = #before + #s

                suggestionFrame.Visible = false
                clearSuggestions()
            end)

            count += 1
        end
    end

    if count > 0 then
        suggestionFrame.Size = UDim2.new(0, 180, 0, count * 22)
        suggestionFrame.Visible = true
    else
        suggestionFrame.Visible = false
    end
end

--// POSITION DROPDOWN NEAR CURSOR (simple anchored version)
local function updateDropdownPosition()
    suggestionFrame.Position = UDim2.new(0, 10, 0, 60)
end

--// INPUT DETECTION
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = textBox.Text
    local lastWord = text:match("([%w_:%.]+)$") or ""

    if #lastWord >= 2 then
        showSuggestions(lastWord)
        updateDropdownPosition()
    else
        suggestionFrame.Visible = false
    end

    refreshEditor()
end)

--// HIDE ON FOCUS LOST
textBox.FocusLost:Connect(function()
    suggestionFrame.Visible = false
end)

statusText.Text = "AUTOCOMPLETE READY • Stage 5 Step 2"--// =========================
--// STAGE 5 - STEP 3
--// SMART AUTOCOMPLETE + GHOST TEXT
--// =========================

--// PRIORITY SUGGESTIONS (context aware)
local smartMap = {
    ["game"] = {"game:GetService()", "game.Workspace", "game.Players"},
    ["print"] = {"print()"},
    ["warn"] = {"warn()"},
    ["error"] = {"error()"},
    ["local"] = {"local "},
    ["function"] = {"function name() end"},
    ["for"] = {"for i = 1, 10 do end"},
    ["if"] = {"if then end"},
}

--// GHOST TEXT LABEL
local ghost = Instance.new("TextLabel")
ghost.Size = textBox.Size
ghost.Position = textBox.Position
ghost.BackgroundTransparency = 1
ghost.TextColor3 = Color3.fromRGB(120, 120, 120)
ghost.Font = Enum.Font.Code
ghost.TextSize = 14
ghost.TextXAlignment = Enum.TextXAlignment.Left
ghost.TextYAlignment = Enum.TextYAlignment.Top
ghost.Text = ""
ghost.TextTransparency = 0.4
ghost.Parent = editor
ghost.ZIndex = textBox.ZIndex - 1

--// GET LAST TOKEN
local function getLastToken(text)
    return text:match("([%w_%.:]+)$")
end

--// PICK BEST MATCH
local function getSmartSuggestion(token)
    if not token then return nil end

    for key, list in pairs(smartMap) do
        if string.sub(token, 1, #key):lower() == key:lower() then
            return list[1]
        end
    end

    return nil
end

--// UPDATE GHOST TEXT
local function updateGhost()
    local text = textBox.Text
    local token = getLastToken(text)

    local suggestion = getSmartSuggestion(token)

    if suggestion and #token > 0 then
        ghost.Text = text .. suggestion:sub(#token + 1)
    else
        ghost.Text = ""
    end
end

--// APPLY ON TYPING
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateGhost()
end)

--// ACCEPT GHOST TEXT (TAB)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.Tab then
        if ghost.Text ~= "" then
            textBox.Text = ghost.Text
            textBox.CursorPosition = #textBox.Text
            ghost.Text = ""
        end
    end
end)

--// CLEAN UP WHEN EMPTY
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    if textBox.Text == "" then
        ghost.Text = ""
    end
end)

statusText.Text = "SMART AUTOCOMPLETE ACTIVE • Stage 5 Step 3"--// =========================
--// STAGE 5 - STEP 4
--// UNIFIED AUTOCOMPLETE ENGINE
--// =========================

--// MASTER SUGGESTION LIST
local baseSuggestions = {
    "print()",
    "warn()",
    "error()",
    "local ",
    "function ",
    "end",
    "if ",
    "then ",
    "for ",
    "while ",
    "return ",
    "game:GetService()",
    "game.Workspace",
    "game.Players"
}

--// SIMPLE RANK SYSTEM
local function scoreSuggestion(input, suggestion)
    input = (input or ""):lower()
    suggestion = suggestion:lower()

    if input == "" then return 0 end

    local score = 0

    -- starts with match = strong
    if string.sub(suggestion, 1, #input) == input then
        score += 10
    end

    -- contains match = weaker
    if string.find(suggestion, input, 1, true) then
        score += 3
    end

    -- keyword boost
    if smartMap[input] then
        score += 5
    end

    return score
end

--// GET BEST SORTED RESULTS
local function getSortedSuggestions(input)
    local results = {}

    for _, s in ipairs(baseSuggestions) do
        local score = scoreSuggestion(input, s)
        if score > 0 then
            table.insert(results, {text = s, score = score})
        end
    end

    table.sort(results, function(a, b)
        return a.score > b.score
    end)

    return results
end

--// CLEAR DROPDOWN
local function clearDropdown()
    for _, v in ipairs(suggestionFrame:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
end

--// RENDER DROPDOWN (UNIFIED)
local function renderDropdown(input)
    clearDropdown()

    local sorted = getSortedSuggestions(input)
    local count = 0

    for i = 1, math.min(#sorted, 6) do
        local item = sorted[i]

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        btn.Font = Enum.Font.Code
        btn.TextSize = 12
        btn.Text = item.text
        btn.Parent = suggestionFrame

        btn.MouseButton1Click:Connect(function()
            local text = textBox.Text
            local token = text:match("([%w_%.:]+)$") or ""

            local before = string.sub(text, 1, #text - #token)

            textBox.Text = before .. item.text
            textBox.CursorPosition = #textBox.Text

            suggestionFrame.Visible = false
            ghost.Text = ""
            clearDropdown()
        end)

        count += 1
    end

    if count > 0 then
        suggestionFrame.Size = UDim2.new(0, 180, 0, count * 22)
        suggestionFrame.Visible = true
    else
        suggestionFrame.Visible = false
    end
end

--// MASTER UPDATE PIPELINE
local function updateAutocomplete()
    local text = textBox.Text
    local token = text:match("([%w_%.:]+)$") or ""

    -- ghost update (safe fallback)
    local best = getSortedSuggestions(token)[1]
    if best and #token > 0 then
        ghost.Text = text .. best.text:sub(#token + 1)
    else
        ghost.Text = ""
    end

    -- dropdown update
    if #token >= 2 then
        renderDropdown(token)
        suggestionFrame.Position = UDim2.new(0, 10, 0, 60)
    else
        suggestionFrame.Visible = false
    end
end

--// OVERRIDE OLD SYSTEMS CLEANLY (single pipeline only)
textBox:GetPropertyChangedSignal("Text"):Connect(updateAutocomplete)

--// TAB ACCEPT (still works, but now unified)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.Tab then
        local best = getSortedSuggestions(textBox.Text:match("([%w_%.:]+)$") or "")[1]

        if best then
            local token = textBox.Text:match("([%w_%.:]+)$") or ""
            local before = string.sub(textBox.Text, 1, #textBox.Text - #token)

            textBox.Text = before .. best.text
            textBox.CursorPosition = #textBox.Text

            ghost.Text = ""
            suggestionFrame.Visible = false
            clearDropdown()
        end
    end
end)

--// FINAL CLEANUP ON EMPTY
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    if textBox.Text == "" then
        ghost.Text = ""
        suggestionFrame.Visible = false
        clearDropdown()
    end
end)

statusText.Text = "AUTOCOMPLETE SYSTEM FINALIZED • Stage 5 Complete"--// =========================
--// STAGE 6 - STEP 1
--// LAYOUT POLISH SYSTEM
--// =========================

--// SAFE UI LAYOUT ENFORCER
local function enforceLayout()

    -- prevent overlap / weird stretching
    main.ClipsDescendants = true
    editor.ClipsDescendants = true
    console.ClipsDescendants = true

    -- enforce clean proportions (VS Code style)
    sidebar.Size = UDim2.new(0.22, 0, 1, 0)

    editor.Size = UDim2.new(0.58, 0, 0.65, 0)
    console.Size = UDim2.new(0.58, 0, 0.35, 0)

    editor.Position = UDim2.new(0.22, 0, 0, 0)
    console.Position = UDim2.new(0.22, 0, 0.65, 0)

    status.Size = UDim2.new(0.20, 0, 1, 0)
    status.Position = UDim2.new(0.80, 0, 0, 0)
end

--// WINDOW RESIZE SAFE GUARD
local function clampUI()
    local absSize = root.AbsoluteSize

    -- minimum usable size (prevents mobile breakage)
    if absSize.X < 500 then
        root.Size = UDim2.new(1, 0, 1, 0)
    end

    if absSize.Y < 300 then
        root.Size = UDim2.new(1, 0, 1, 0)
    end
end

--// HOVER FEEDBACK SYSTEM (light polish)
local function addHover(button)
    if not button then return end

    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.1
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0
    end)
end

--// APPLY TO KEY UI ELEMENTS (safe checks)
if runBtn then addHover(runBtn) end
if clearBtn then addHover(clearBtn) end
if newTab then addHover(newTab) end
if themeBtn then addHover(themeBtn) end

--// LIVE RESIZE WATCHER
root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    clampUI()
    enforceLayout()
end)

--// INITIAL APPLY
enforceLayout()
clampUI()

statusText.Text = "LAYOUT POLISH ACTIVE • Stage 6 Step 1"--// =========================
--// STAGE 6 - STEP 2
--// SPLIT RESIZE SYSTEM
--// =========================

--// SPLIT STATE
local draggingSplit = false

--// SPLITTER BAR (between editor + console)
local splitter = Instance.new("Frame")
splitter.Size = UDim2.new(0, 4, 0.35, 0)
splitter.Position = UDim2.new(0.80, -4, 0.65, 0)
splitter.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
splitter.BorderSizePixel = 0
splitter.ZIndex = 10
splitter.Parent = main

Instance.new("UICorner", splitter)

--// RESIZE FUNCTION
local function applySplit(yScale)
    -- clamp to prevent breaking layout
    yScale = math.clamp(yScale, 0.3, 0.8)

    console.Size = UDim2.new(0.58, 0, 1 - yScale, 0)
    console.Position = UDim2.new(0.22, 0, yScale, 0)

    editor.Size = UDim2.new(0.58, 0, yScale, 0)
end

--// DRAG LOGIC
splitter.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSplit = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSplit = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not draggingSplit then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        local absY = input.Position.Y
        local screenY = root.AbsoluteSize.Y

        if screenY <= 0 then return end

        local ratio = absY / screenY
        applySplit(ratio)
    end
end)

--// HOVER FEEL (visual feedback)
splitter.MouseEnter:Connect(function()
    splitter.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
end)

splitter.MouseLeave:Connect(function()
    splitter.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
end)

--// INIT DEFAULT SPLIT
applySplit(0.65)

statusText.Text = "SPLIT RESIZE ACTIVE • Stage 6 Step 2"--// =========================
--// STAGE 6 - STEP 3
--// WORKSPACE MODES + ANIMATION
--// =========================

local focusMode = false
local consoleCollapsed = false

--// TWEEN HELPERS
local function tween(obj, props, t)
    TweenService:Create(
        obj,
        TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

--// FOCUS MODE (editor fullscreen toggle)
local function setFocusMode(state)
    focusMode = state

    if focusMode then
        -- hide distractions
        tween(sidebar, {Size = UDim2.new(0, 0, 1, 0)}, 0.25)
        tween(console, {Size = UDim2.new(0.58, 0, 0, 0)}, 0.25)
        tween(console, {BackgroundTransparency = 0.3}, 0.25)

        tween(editor, {
            Size = UDim2.new(0.78, 0, 1, 0)
        }, 0.25)

        editor.Position = UDim2.new(0.22, 0, 0, 0)
    else
        -- restore layout
        tween(sidebar, {Size = UDim2.new(0.22, 0, 1, 0)}, 0.25)
        tween(console, {Size = UDim2.new(0.58, 0, 0.35, 0)}, 0.25)

        tween(editor, {
            Size = UDim2.new(0.58, 0, 0.65, 0)
        }, 0.25)

        editor.Position = UDim2.new(0.22, 0, 0, 0)
    end
end

--// CONSOLE TOGGLE (collapse/expand)
local function toggleConsole()
    consoleCollapsed = not consoleCollapsed

    if consoleCollapsed then
        tween(console, {Size = UDim2.new(0.58, 0, 0, 0)}, 0.25)
        splitter.Visible = false
    else
        tween(console, {Size = UDim2.new(0.58, 0, 0.35, 0)}, 0.25)
        splitter.Visible = true
    end
end

--// UI BUTTONS (if not already existing)
local focusBtn = Instance.new("TextButton")
focusBtn.Size = UDim2.new(0, 120, 0, 25)
focusBtn.Position = UDim2.new(1, -260, 1, -30)
focusBtn.Text = "Focus Mode"
focusBtn.Font = Enum.Font.Code
focusBtn.TextSize = 12
focusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
focusBtn.BackgroundColor3 = theme and theme.accent or Color3.fromRGB(0, 120, 200)
focusBtn.Parent = editor

Instance.new("UICorner", focusBtn)

focusBtn.MouseButton1Click:Connect(function()
    setFocusMode(not focusMode)
end)

local consoleBtn = Instance.new("TextButton")
consoleBtn.Size = UDim2.new(0, 120, 0, 25)
consoleBtn.Position = UDim2.new(1, -130, 1, -30)
consoleBtn.Text = "Toggle Console"
consoleBtn.Font = Enum.Font.Code
consoleBtn.TextSize = 12
consoleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
consoleBtn.BackgroundColor3 = theme and theme.accent or Color3.fromRGB(0, 120, 200)
consoleBtn.Parent = editor

Instance.new("UICorner", consoleBtn)

consoleBtn.MouseButton1Click:Connect(function()
    toggleConsole()
end)

--// KEYBINDS (workspace control)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- F6 = focus mode toggle
    if input.KeyCode == Enum.KeyCode.F6 then
        setFocusMode(not focusMode)
    end

    -- F7 = console toggle
    if input.KeyCode == Enum.KeyCode.F7 then
        toggleConsole()
    end
end)

--// SAFE RESET HANDLER (avoid stuck UI states)
local function resetWorkspace()
    focusMode = false
    consoleCollapsed = false

    sidebar.Size = UDim2.new(0.22, 0, 1, 0)
    console.Size = UDim2.new(0.58, 0, 0.35, 0)
    editor.Size = UDim2.new(0.58, 0, 0.65, 0)

    splitter.Visible = true
end

statusText.Text = "WORKSPACE MODES ACTIVE • Stage 6 Step 3"--// =========================
--// STAGE 6 - STEP 4
--// UI STATE MEMORY + POLISH
--// =========================

--// STATE STORAGE (session memory)
local uiState = {
    focusMode = false,
    consoleCollapsed = false,
    splitRatio = 0.65
}

--// SAFE APPLY STATE
local function applyState()
    -- focus mode restore
    if uiState.focusMode then
        setFocusMode(true)
    end

    -- console restore
    if uiState.consoleCollapsed then
        toggleConsole()
    end

    -- split restore (safe fallback)
    if applySplit then
        applySplit(uiState.splitRatio or 0.65)
    end
end

--// UPDATE STATE TRACKERS
local function syncState()
    uiState.focusMode = focusMode
    uiState.consoleCollapsed = consoleCollapsed
end

--// HOOK INTO EXISTING FUNCTIONS SAFELY

-- override focus toggle to sync state
local oldSetFocus = setFocusMode
setFocusMode = function(state)
    oldSetFocus(state)
    uiState.focusMode = state
end

-- override console toggle to sync state
local oldToggleConsole = toggleConsole
toggleConsole = function()
    oldToggleConsole()
    uiState.consoleCollapsed = consoleCollapsed
end

-- override split apply to store ratio
local oldApplySplit = applySplit
applySplit = function(ratio)
    uiState.splitRatio = ratio
    oldApplySplit(ratio)
end

--// SMOOTH BUTTON POLISH SYSTEM
local function addButtonPolish(btn)
    if not btn then return end

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.1}, 0.12)
    end)

    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0}, 0.12)
    end)

    btn.MouseButton1Down:Connect(function()
        tween(btn, {Size = btn.Size - UDim2.new(0, 2, 0, 2)}, 0.08)
    end)

    btn.MouseButton1Up:Connect(function()
        tween(btn, {Size = btn.Size + UDim2.new(0, 2, 0, 2)}, 0.08)
    end)
end

--// APPLY POLISH TO EXISTING BUTTONS
if focusBtn then addButtonPolish(focusBtn) end
if consoleBtn then addButtonPolish(consoleBtn) end
if runBtn then addButtonPolish(runBtn) end
if clearBtn then addButtonPolish(clearBtn) end
if newTab then addButtonPolish(newTab) end
if themeBtn then addButtonPolish(themeBtn) end

--// STARTUP RESTORE
task.defer(function()
    task.wait(0.2)
    applyState()
end)

--// SAFE EXIT / RESET HOOK
local function resetAllUI()
    uiState = {
        focusMode = false,
        consoleCollapsed = false,
        splitRatio = 0.65
    }

    if resetWorkspace then
        resetWorkspace()
    end
end

--// FINAL STATUS UPDATE
statusText.Text = "STAGE 6 COMPLETE • UI POLISH FINISHED"--// =========================
--// STAGE 7 - STEP 1
--// COMMAND PALETTE SYSTEM
--// =========================

--// COMMAND REGISTRY
local commands = {
    {
        name = "Run Script",
        action = function()
            if runCode then runCode() end
        end
    },
    {
        name = "Clear Console",
        action = function()
            if consoleLines then
                consoleLines = {}
                if refreshConsole then refreshConsole() end
            end
        end
    },
    {
        name = "Toggle Focus Mode",
        action = function()
            if setFocusMode then
                setFocusMode(not focusMode)
            end
        end
    },
    {
        name = "Toggle Console",
        action = function()
            if toggleConsole then toggleConsole() end
        end
    },
    {
        name = "New Tab",
        action = function()
            if newTab and newTab.MouseButton1Click then
                newTab.MouseButton1Click:Fire()
            end
        end
    }
}

--// MAIN PALETTE UI
local palette = Instance.new("Frame")
palette.Size = UDim2.new(0, 420, 0, 40)
palette.Position = UDim2.new(0.5, -210, 0.2, 0)
palette.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
palette.BorderSizePixel = 0
palette.Visible = false
palette.ZIndex = 50
palette.Parent = root

Instance.new("UICorner", palette)

--// INPUT BOX
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -10, 1, -10)
input.Position = UDim2.new(0, 5, 0, 5)
input.BackgroundTransparency = 1
input.TextColor3 = Color3.fromRGB(220, 220, 220)
input.Font = Enum.Font.Code
input.TextSize = 14
input.ClearTextOnFocus = false
input.Text = ""
input.PlaceholderText = "Type a command..."
input.Parent = palette

--// RESULTS FRAME
local results = Instance.new("Frame")
results.Size = UDim2.new(0, 420, 0, 0)
results.Position = UDim2.new(0.5, -210, 0.2, 45)
results.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
results.BorderSizePixel = 0
results.Visible = false
results.Parent = root

Instance.new("UICorner", results)

local list = Instance.new("UIListLayout")
list.Parent = results

--// OPEN / CLOSE PALETTE
local function openPalette()
    palette.Visible = true
    results.Visible = true
    input:CaptureFocus()
end

local function closePalette()
    palette.Visible = false
    results.Visible = false
    input.Text = ""
end

--// CLEAR RESULTS
local function clearResults()
    for _, v in ipairs(results:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
end

--// RENDER RESULTS
local function renderCommands(query)
    clearResults()

    local count = 0

    for _, cmd in ipairs(commands) do
        if string.find(cmd.name:lower(), query:lower(), 1, true) then

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            btn.Font = Enum.Font.Code
            btn.TextSize = 13
            btn.Text = cmd.name
            btn.Parent = results

            Instance.new("UICorner", btn)

            btn.MouseButton1Click:Connect(function()
                cmd.action()
                closePalette()
            end)

            count += 1
        end
    end

    results.Size = UDim2.new(0, 420, 0, math.min(count * 28, 200))
end

--// INPUT HANDLING
input:GetPropertyChangedSignal("Text"):Connect(function()
    renderCommands(input.Text)
end)

--// GLOBAL KEYBIND (Ctrl+P feel)
UserInputService.InputBegan:Connect(function(inputObj, gpe)
    if gpe then return end

    -- toggle palette (P key or Ctrl+P feel simplified)
    if inputObj.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if palette.Visible then
            closePalette()
        else
            openPalette()
        end
    end

    -- escape closes
    if inputObj.KeyCode == Enum.KeyCode.Escape then
        closePalette()
    end
end)

--// AUTO CLOSE ON ENTER
input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = input.Text:lower()

        for _, cmd in ipairs(commands) do
            if cmd.name:lower() == text then
                cmd.action()
                break
            end
        end

        closePalette()
    end
end)

statusText.Text = "COMMAND PALETTE ACTIVE • Stage 7 Step 1"--// =========================
--// STAGE 7 - STEP 2
--// SYNTAX HIGHLIGHT ENGINE v2 (CLEAN)
--// =========================

--// IMPORTANT:
--// Uses GLOBAL Syntax.Keywords (no redefinition here)

--// COLOR SCHEME
local syntaxColors = {
    keyword = Color3.fromRGB(0, 170, 255),
    builtin = Color3.fromRGB(180, 120, 255),
    string  = Color3.fromRGB(255, 200, 120),
    number  = Color3.fromRGB(255, 120, 120),
    normal  = Color3.fromRGB(220, 220, 220)
}

--// SAFE ESCAPE (prevents RichText breaking)
local function escapeRichText(str)
    str = string.gsub(str, "&", "&amp;")
    str = string.gsub(str, "<", "&lt;")
    str = string.gsub(str, ">", "&gt;")
    return str
end

--// CORE HIGHLIGHTER
local function highlightCode(code)
    code = escapeRichText(code)

    local result = ""
    local i = 1
    local len = #code

    while i <= len do
        local char = code:sub(i,i)

        --// STRING DETECTION
        if char == "\"" or char == "'" then
            local quote = char
            local j = i + 1

            while j <= len and code:sub(j,j) ~= quote do
                j += 1
            end

            local str = code:sub(i, math.min(j, len))
            result ..= "<font color='rgb(255,200,120)'>" .. str .. "</font>"
            i = j + 1

        --// NUMBER DETECTION
        elseif char:match("%d") then
            local j = i

            while j <= len and code:sub(j,j):match("[%d%.]") do
                j += 1
            end

            local num = code:sub(i, j-1)
            result ..= "<font color='rgb(255,120,120)'>" .. num .. "</font>"
            i = j

        --// WORD DETECTION
        elseif char:match("[%a_]") then
            local j = i

            while j <= len and code:sub(j,j):match("[%w_]") do
                j += 1
            end

            local word = code:sub(i, j-1)

            --// GLOBAL SYNTAX CHECK (FIXED)
            if Syntax and Syntax.Keywords[word] then
                result ..= "<font color='rgb(0,170,255)'>" .. word .. "</font>"

            elseif Syntax and Syntax.Builtins[word] then
                result ..= "<font color='rgb(180,120,255)'>" .. word .. "</font>"

            else
                result ..= "<font color='rgb(220,220,220)'>" .. word .. "</font>"
            end

            i = j

        --// DEFAULT CHAR
        else
            result ..= char
            i += 1
        end
    end

    return result
end

--// THROTTLED UPDATE SYSTEM (performance safe)
local lastUpdate = 0

local function updateHighlight()
    if not textBox or not editorLabel then return end

    local now = tick()
    if now - lastUpdate < 0.04 then return end
    lastUpdate = now

    editorLabel.RichText = true
    editorLabel.Text = highlightCode(textBox.Text or "")
end

--// LIVE CONNECTION
textBox:GetPropertyChangedSignal("Text"):Connect(updateHighlight)

--// INITIAL RENDER
task.defer(updateHighlight)

--// STATUS UPDATE
if statusText then
    statusText.Text = "SYNTAX ENGINE v2 LOADED • Stage 7 Step 2"
end--// =========================
--// STAGE 7 - STEP 3
--// MINIMAP + LINE GUTTER SYSTEM
--// =========================

--// SAFE FALLBACKS
if not textBox or not editor then return end

--// LINE NUMBER GUTTER
local gutter = Instance.new("ScrollingFrame")
gutter.Size = UDim2.new(0, 40, 1, 0)
gutter.Position = UDim2.new(0, 0, 0, 0)
gutter.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
gutter.BorderSizePixel = 0
gutter.ScrollBarThickness = 0
gutter.Parent = editor

local gutterList = Instance.new("UIListLayout")
gutterList.Parent = gutter

--// MINIMAP (right preview)
local minimap = Instance.new("TextLabel")
minimap.Size = UDim2.new(0, 120, 1, 0)
minimap.Position = UDim2.new(1, -120, 0, 0)
minimap.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
minimap.TextColor3 = Color3.fromRGB(120, 120, 120)
minimap.Font = Enum.Font.Code
minimap.TextSize = 6
minimap.TextXAlignment = Enum.TextXAlignment.Left
minimap.TextYAlignment = Enum.TextYAlignment.Top
minimap.TextWrapped = false
minimap.Parent = editor

--// LINE NUMBER GENERATOR
local function updateGutter()
    local text = textBox.Text or ""
    local lines = string.split(text, "\n")

    -- clear old
    for _, v in ipairs(gutter:GetChildren()) do
        if v:IsA("TextLabel") then
            v:Destroy()
        end
    end

    -- rebuild numbers
    for i = 1, #lines do
        local line = Instance.new("TextLabel")
        line.Size = UDim2.new(1, 0, 0, 18)
        line.BackgroundTransparency = 1
        line.Text = tostring(i)
        line.TextColor3 = Color3.fromRGB(90, 90, 90)
        line.Font = Enum.Font.Code
        line.TextSize = 12
        line.Parent = gutter
    end
end

--// MINIMAP GENERATOR (lightweight preview)
local function updateMinimap()
    local text = textBox.Text or ""
    local lines = string.split(text, "\n")

    local preview = ""

    for i = 1, math.min(#lines, 120) do
        local line = lines[i]

        -- strip heavy chars for preview
        line = string.gsub(line, "\t", "    ")
        line = string.sub(line, 1, 80)

        preview ..= line .. "\n"
    end

    minimap.Text = preview
end

--// ERROR MARKER SYSTEM (basic foundation only)
local function detectErrors()
    local text = textBox.Text or ""
    local lines = string.split(text, "\n")

    local issues = {}

    for i, line in ipairs(lines) do
        if string.find(line, "function") and not string.find(line, "end") and i == #lines then
            table.insert(issues, i)
        end
    end

    return issues
end

--// OPTIONAL ERROR DISPLAY (visual only)
local function showErrors()
    local issues = detectErrors()

    for _, v in ipairs(gutter:GetChildren()) do
        if v:IsA("TextLabel") then
            v.TextColor3 = Color3.fromRGB(90, 90, 90)
        end
    end

    for _, lineNum in ipairs(issues) do
        local label = gutter:FindFirstChild(tostring(lineNum))
        if label then
            label.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end
end

--// LIVE UPDATE LOOP (optimized)
local last = 0

local function updateAll()
    local now = tick()
    if now - last < 0.06 then return end
    last = now

    updateGutter()
    updateMinimap()
    showErrors()
end

textBox:GetPropertyChangedSignal("Text"):Connect(updateAll)

--// INITIAL BUILD
task.defer(function()
    updateGutter()
    updateMinimap()
    showErrors()
end)

--// STATUS
if statusText then
    statusText.Text = "MINIMAP + GUTTER ACTIVE • Stage 7 Step 3"
end--// =========================
--// STAGE 7 - STEP 4
--// DEBUGGER + DIAGNOSTICS LAYER
--// =========================

if not textBox or not editor or not gutter then return end

--// BREAKPOINT STORAGE
local breakpoints = {}

--// ERROR STORAGE
local diagnostics = {}

--// INLINE ERROR PARSER (basic Lua-style checks)
local function parseErrors(code)
    diagnostics = {}

    local lines = string.split(code or "", "\n")

    for i, line in ipairs(lines) do

        -- missing "end" hint (very basic heuristic)
        if string.find(line, "function") and i == #lines then
            table.insert(diagnostics, {
                line = i,
                msg = "Possible missing 'end'",
                type = "warning"
            })
        end

        -- random unsafe pattern detection (demo only)
        if string.find(line, "loadstring") then
            table.insert(diagnostics, {
                line = i,
                msg = "Use of loadstring detected",
                type = "info"
            })
        end
    end
end

--// BREAKPOINT TOGGLE SYSTEM
local function toggleBreakpoint(lineNumber)
    if breakpoints[lineNumber] then
        breakpoints[lineNumber] = nil
    else
        breakpoints[lineNumber] = true
    end
end

--// APPLY GUTTER CLICK SUPPORT
local function attachBreakpointUI()
    for _, obj in ipairs(gutter:GetChildren()) do
        if obj:IsA("TextLabel") then
            obj.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local line = tonumber(obj.Text)
                    if line then
                        toggleBreakpoint(line)

                        -- visual update
                        if breakpoints[line] then
                            obj.TextColor3 = Color3.fromRGB(255, 80, 80)
                        else
                            obj.TextColor3 = Color3.fromRGB(90, 90, 90)
                        end
                    end
                end
            end)
        end
    end
end

--// INLINE SQUIGGLE OVERLAY (visual only)
local function updateSquiggles()
    local text = textBox.Text or ""
    parseErrors(text)

    -- reset gutter colors first
    for _, v in ipairs(gutter:GetChildren()) do
        if v:IsA("TextLabel") then
            v.TextColor3 = Color3.fromRGB(90, 90, 90)
        end
    end

    -- apply diagnostics
    for _, d in ipairs(diagnostics) do
        local label = gutter:FindFirstChild(tostring(d.line))

        if label then
            if d.type == "warning" then
                label.TextColor3 = Color3.fromRGB(255, 200, 80)
            elseif d.type == "info" then
                label.TextColor3 = Color3.fromRGB(120, 180, 255)
            end
        end
    end
end

--// PERFORMANCE PANEL (lightweight stats)
local perfLabel = Instance.new("TextLabel")
perfLabel.Size = UDim2.new(0, 200, 0, 20)
perfLabel.Position = UDim2.new(1, -210, 1, -25)
perfLabel.BackgroundTransparency = 1
perfLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
perfLabel.Font = Enum.Font.Code
perfLabel.TextSize = 12
perfLabel.TextXAlignment = Enum.TextXAlignment.Right
perfLabel.Parent = editor

local function updatePerformance()
    local lineCount = #string.split(textBox.Text or "", "\n")
    local charCount = #textBox.Text

    perfLabel.Text =
        "LINES: " .. lineCount ..
        " | CHARS: " .. charCount ..
        " | BP: " .. tostring(table.getn(breakpoints))
end

--// SAFE BREAKPOINT UI REFRESH HOOK
local function refreshDebugger()
    updateSquiggles()
    updatePerformance()
    attachBreakpointUI()
end

--// THROTTLED UPDATE LOOP
local lastUpdate = 0

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    local now = tick()
    if now - lastUpdate < 0.08 then return end
    lastUpdate = now

    refreshDebugger()
end)

--// INITIAL RUN
task.defer(function()
    refreshDebugger()
end)

--// STATUS UPDATE
if statusText then
    statusText.Text = "DEBUGGER LAYER ACTIVE • Stage 7 Step 4 COMPLETE"
end--// =========================
--// STAGE 8 - STEP 1
--// PLUGIN SYSTEM CORE
--// =========================

--// SAFE FALLBACK
if not root then return end

--// PLUGIN REGISTRY
local Plugins = {}
local PluginHooks = {
    init = {},
    update = {},
    destroy = {}
}

--// REGISTER PLUGIN
local function registerPlugin(plugin)
    if type(plugin) ~= "table" then return end
    if not plugin.name then return end

    Plugins[plugin.name] = plugin

    -- hook init
    if plugin.init then
        table.insert(PluginHooks.init, plugin.init)
    end

    -- hook update
    if plugin.update then
        table.insert(PluginHooks.update, plugin.update)
    end

    -- hook destroy
    if plugin.destroy then
        table.insert(PluginHooks.destroy, plugin.destroy)
    end
end

--// RUN HOOKS
local function runInit()
    for _, fn in ipairs(PluginHooks.init) do
        pcall(fn)
    end
end

local function runUpdate()
    for _, fn in ipairs(PluginHooks.update) do
        pcall(fn)
    end
end

local function runDestroy()
    for _, fn in ipairs(PluginHooks.destroy) do
        pcall(fn)
    end
end

--// SIMPLE PLUGIN EXAMPLE SYSTEM
local function createPlugin(name, def)
    def.name = name
    registerPlugin(def)
end

--// BUILT-IN PLUGIN: Auto Save Indicator
createPlugin("AutoSaveIndicator", {
    init = function()
        if statusText then
            statusText.Text = "PLUGIN: AutoSave Loaded"
        end
    end,

    update = function()
        -- lightweight pulse effect placeholder
        if statusText and textBox then
            if #textBox.Text % 2 == 0 then
                statusText.TextTransparency = 0
            else
                statusText.TextTransparency = 0.2
            end
        end
    end
})

--// BUILT-IN PLUGIN: Line Counter Helper
createPlugin("LineCounterPlugin", {
    init = function()
        print("[Plugin] LineCounter loaded")
    end,

    update = function()
        if statusText and textBox then
            local lines = #string.split(textBox.Text or "", "\n")
            statusText.Text = "LINES: " .. lines .. " | PLUGINS ACTIVE"
        end
    end
})

--// MAIN UPDATE LOOP (plugin engine tick)
local lastTick = 0

game:GetService("RunService").RenderStepped:Connect(function()
    local now = tick()
    if now - lastTick < 0.1 then return end
    lastTick = now

    runUpdate()
end)

--// INIT PLUGINS
task.defer(function()
    runInit()
end)

--// CLEAN SHUTDOWN HOOK
local function shutdownPlugins()
    runDestroy()
    table.clear(Plugins)
end

--// OPTIONAL SAFE RESET HOOK
if game and game.Destroying then
    game.Destroying:Connect(function()
        shutdownPlugins()
    end)
end

--// STATUS
if statusText then
    statusText.Text = "PLUGIN SYSTEM ACTIVE • Stage 8 Step 1"
end--// =========================
--// STAGE 8 - STEP 2
--// PLUGIN MANAGER UI
--// =========================

if not root then return end

--// PLUGIN STATE TRACKING
local PluginState = {}

for name, _ in pairs(Plugins or {}) do
    PluginState[name] = true
end

--// PLUGIN PANEL UI
local pluginPanel = Instance.new("Frame")
pluginPanel.Size = UDim2.new(0, 200, 0, 250)
pluginPanel.Position = UDim2.new(1, -210, 0, 40)
pluginPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
pluginPanel.BorderSizePixel = 0
pluginPanel.Parent = root

Instance.new("UICorner", pluginPanel)

local pluginTitle = Instance.new("TextLabel")
pluginTitle.Size = UDim2.new(1, 0, 0, 25)
pluginTitle.BackgroundTransparency = 1
pluginTitle.Text = "Plugins"
pluginTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
pluginTitle.Font = Enum.Font.Code
pluginTitle.TextSize = 14
pluginTitle.Parent = pluginPanel

local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, 0, 1, -25)
listFrame.Position = UDim2.new(0, 0, 0, 25)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 4
listFrame.Parent = pluginPanel

local layout = Instance.new("UIListLayout")
layout.Parent = listFrame

--// TOGGLE PLUGIN
local function togglePlugin(name)
    PluginState[name] = not PluginState[name]
end

--// RENDER PLUGIN LIST
local function renderPlugins()
    for _, v in ipairs(listFrame:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    for name, plugin in pairs(Plugins or {}) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        btn.Font = Enum.Font.Code
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = (PluginState[name] and "🟢 " or "🔴 ") .. name
        btn.Parent = listFrame

        Instance.new("UICorner", btn)

        btn.MouseButton1Click:Connect(function()
            togglePlugin(name)
            renderPlugins()
        end)
    end
end

--// FILTERED UPDATE LOOP (ONLY ACTIVE PLUGINS RUN)
local lastTick = 0

game:GetService("RunService").RenderStepped:Connect(function()
    local now = tick()
    if now - lastTick < 0.1 then return end
    lastTick = now

    for name, plugin in pairs(Plugins or {}) do
        if PluginState[name] and plugin.update then
            pcall(plugin.update)
        end
    end
end)

--// AUTO UPDATE PANEL
task.defer(function()
    renderPlugins()
end)

--// REFRESH WHEN PLUGINS CHANGE (simple hook)
local function refreshPluginUI()
    renderPlugins()
end

--// OPTIONAL GLOBAL ACCESS
_G.RefreshPluginUI = refreshPluginUI

--// STATUS UPDATE
if statusText then
    statusText.Text = "PLUGIN MANAGER ACTIVE • Stage 8 Step 2"
end--// =========================
--// STAGE 8 - STEP 3
--// PLUGIN API + SETTINGS + DEPENDENCIES
--// =========================

if not Plugins then return end

--// GLOBAL PLUGIN API (safe exposed functions)
local PluginAPI = {}

function PluginAPI.get(name)
    return Plugins[name]
end

function PluginAPI.isEnabled(name)
    return PluginState and PluginState[name] == true
end

function PluginAPI.setEnabled(name, state)
    if PluginState and PluginState[name] ~= nil then
        PluginState[name] = state
    end
end

function PluginAPI.register(name, def)
    if type(def) ~= "table" then return end
    def.name = name
    Plugins[name] = def
    PluginState[name] = true

    if def.init then
        pcall(def.init, PluginAPI)
    end
end

--// DEPENDENCY CHECKER
local function checkDependencies(plugin)
    if not plugin.dependencies then return true end

    for _, dep in ipairs(plugin.dependencies) do
        if not Plugins[dep] then
            warn("[Plugin Missing Dependency]: " .. dep)
            return false
        end
    end

    return true
end

--// SAFE PLUGIN INIT WITH DEPENDENCIES
local function safeInitPlugins()
    for name, plugin in pairs(Plugins) do
        if PluginState[name] then
            if checkDependencies(plugin) then
                if plugin.init then
                    pcall(plugin.init, PluginAPI)
                end
            else
                PluginState[name] = false
            end
        end
    end
end

--// PLUGIN SETTINGS SYSTEM
local PluginSettings = {}

function PluginAPI.getSetting(pluginName, key, default)
    if not PluginSettings[pluginName] then
        PluginSettings[pluginName] = {}
    end

    return PluginSettings[pluginName][key] or default
end

function PluginAPI.setSetting(pluginName, key, value)
    if not PluginSettings[pluginName] then
        PluginSettings[pluginName] = {}
    end

    PluginSettings[pluginName][key] = value
end

--// UPDATE LOOP (ONLY ACTIVE + VALIDATED PLUGINS)
local lastTick = 0

game:GetService("RunService").RenderStepped:Connect(function()
    local now = tick()
    if now - lastTick < 0.1 then return end
    lastTick = now

    for name, plugin in pairs(Plugins) do
        if PluginState[name] and plugin.update then
            if checkDependencies(plugin) then
                pcall(plugin.update, PluginAPI)
            end
        end
    end
end)

--// INIT ALL PLUGINS SAFELY
task.defer(function()
    safeInitPlugins()
end)

--// EXAMPLE UPDATED PLUGIN (USING API)
PluginAPI.register("FPSDisplay", {
    dependencies = {},

    init = function(api)
        print("[FPSDisplay] Initialized")
        PluginAPI.setSetting("FPSDisplay", "enabled", true)
    end,

    update = function(api)
        local enabled = PluginAPI.getSetting("FPSDisplay", "enabled", true)

        if enabled and statusText then
            statusText.Text = "FPS PLUGIN ACTIVE • Stage 8 Step 3"
        end
    end
})

--// OPTIONAL GLOBAL ACCESS
_G.PluginAPI = PluginAPI

--// STATUS
if statusText then
    statusText.Text = "PLUGIN API + SETTINGS ACTIVE • Stage 8 Step 3"
end--// =========================
--// STAGE 8 - STEP 4
--// PLUGIN INSTALLER + EXPORT SYSTEM
--// =========================

if not Plugins then return end

--// SAFE FALLBACKS
PluginState = PluginState or {}
PluginSettings = PluginSettings or {}

--// INSTALL PLUGIN (runtime)
local function installPlugin(name, def)
    if type(def) ~= "table" then return end

    def.name = name
    Plugins[name] = def
    PluginState[name] = true

    if def.init then
        pcall(def.init, PluginAPI)
    end
end

--// REMOVE PLUGIN (runtime cleanup)
local function removePlugin(name)
    local plugin = Plugins[name]
    if not plugin then return end

    if plugin.destroy then
        pcall(plugin.destroy, PluginAPI)
    end

    Plugins[name] = nil
    PluginState[name] = nil
    PluginSettings[name] = nil
end

--// EXPORT PLUGIN (simple serializable format)
local function exportPlugin(name)
    local plugin = Plugins[name]
    if not plugin then return nil end

    local data = {
        name = name,
        settings = PluginSettings[name] or {},
    }

    -- NOTE: functions cannot be serialized safely
    return game:GetService("HttpService"):JSONEncode(data)
end

--// IMPORT PLUGIN (data only - logic must be predefined)
local function importPlugin(json)
    local HttpService = game:GetService("HttpService")

    local success, data = pcall(function()
        return HttpService:JSONDecode(json)
    end)

    if not success or not data then return end

    -- reconstructed as settings-only plugin shell
    Plugins[data.name] = {
        name = data.name,
        init = function()
            print("[Imported Plugin]: " .. data.name)
        end
    }

    PluginSettings[data.name] = data.settings or {}
    PluginState[data.name] = true
end

--// PLUGIN CLEAN RESET (hard reset system)
local function resetPluginSystem()
    for name, plugin in pairs(Plugins) do
        if plugin.destroy then
            pcall(plugin.destroy, PluginAPI)
        end
    end

    table.clear(Plugins)
    table.clear(PluginState)
    table.clear(PluginSettings)
end

--// SIMPLE UI BUTTONS (optional control panel hooks)
local installBtn = Instance.new("TextButton")
installBtn.Size = UDim2.new(0, 120, 0, 25)
installBtn.Position = UDim2.new(1, -130, 1, -60)
installBtn.Text = "Reset Plugins"
installBtn.Font = Enum.Font.Code
installBtn.TextSize = 12
installBtn.TextColor3 = Color3.fromRGB(255,255,255)
installBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
installBtn.Parent = root

Instance.new("UICorner", installBtn)

installBtn.MouseButton1Click:Connect(function()
    resetPluginSystem()

    if statusText then
        statusText.Text = "PLUGIN SYSTEM RESET COMPLETE"
    end
end)

--// EXPORT TEST (example usage)
local exportBtn = Instance.new("TextButton")
exportBtn.Size = UDim2.new(0, 120, 0, 25)
exportBtn.Position = UDim2.new(1, -130, 1, -90)
exportBtn.Text = "Export Plugin"
exportBtn.Font = Enum.Font.Code
exportBtn.TextSize = 12
exportBtn.TextColor3 = Color3.fromRGB(255,255,255)
exportBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)
exportBtn.Parent = root

Instance.new("UICorner", exportBtn)

exportBtn.MouseButton1Click:Connect(function()
    local sample = exportPlugin("FPSDisplay")

    if sample then
        setclipboard(sample) -- only works in some environments (safe optional)
    end

    if statusText then
        statusText.Text = "PLUGIN EXPORTED"
    end
end)

--// IMPORT TEST INPUT (simple mock)
local importBox = Instance.new("TextBox")
importBox.Size = UDim2.new(0, 200, 0, 25)
importBox.Position = UDim2.new(1, -210, 1, -120)
importBox.PlaceholderText = "Paste plugin JSON"
importBox.Text = ""
importBox.Font = Enum.Font.Code
importBox.TextSize = 11
importBox.TextColor3 = Color3.fromRGB(220,220,220)
importBox.BackgroundColor3 = Color3.fromRGB(30,30,34)
importBox.Parent = root

Instance.new("UICorner", importBox)

importBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and importBox.Text ~= "" then
        importPlugin(importBox.Text)

        if statusText then
            statusText.Text = "PLUGIN IMPORTED"
        end
    end
end)

--// FINAL STATUS
if statusText then
    statusText.Text = "STAGE 8 COMPLETE • PLUGIN SYSTEM FINISHED"
end--// =========================
--// STAGE 9 - STEP 1
--// DOCKING LAYOUT SYSTEM CORE
--// =========================

if not root then return end

--// LAYOUT CONTAINERS
local Layout = {
    Left = Instance.new("Frame"),
    Right = Instance.new("Frame"),
    Bottom = Instance.new("Frame"),
    Center = Instance.new("Frame")
}

--// BASIC STYLES
for name, frame in pairs(Layout) do
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    frame.BorderSizePixel = 0
    frame.Parent = root

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
end

--// DEFAULT DOCK POSITIONS
Layout.Left.Size = UDim2.new(0, 220, 1, -36)
Layout.Left.Position = UDim2.new(0, 0, 0, 36)

Layout.Right.Size = UDim2.new(0, 220, 1, -36)
Layout.Right.Position = UDim2.new(1, -220, 0, 36)

Layout.Bottom.Size = UDim2.new(1, -440, 0, 160)
Layout.Bottom.Position = UDim2.new(0, 220, 1, -160)

Layout.Center.Size = UDim2.new(1, -440, 1, -196)
Layout.Center.Position = UDim2.new(0, 220, 0, 36)

--// DOCK REGISTRY
local DockRegistry = {
    explorer = Layout.Left,
    properties = Layout.Right,
    console = Layout.Bottom,
    editor = Layout.Center
}

--// DOCK FUNCTION
local function dockPanel(name, panel)
    local target = DockRegistry[name]
    if not target or not panel then return end

    panel.Parent = target
    panel.Size = UDim2.fromScale(1, 1)
    panel.Position = UDim2.fromScale(0, 0)
end

--// CREATE SAMPLE PANELS (re-attaching existing UI)
local function moveExistingUI()

    if sidebar then
        dockPanel("explorer", sidebar)
    end

    if console then
        dockPanel("console", console)
    end

    if editor then
        dockPanel("editor", editor)
    end
end

--// DRAG SNAP SYSTEM (simple layout switching)
local draggingPanel = nil

local function makeDraggable(panel, name)
    panel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingPanel = name
        end
    end)
end

--// APPLY DRAG SUPPORT TO ALL DOCKS
for name, frame in pairs(DockRegistry) do
    makeDraggable(frame, name)
end

--// DROP DETECTION (very simplified)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingPanel then

        local mousePos = UserInputService:GetMouseLocation()

        if mousePos.X < 200 then
            DockRegistry.explorer:ApplyLayout()
        elseif mousePos.X > root.AbsoluteSize.X - 200 then
            DockRegistry.properties:ApplyLayout()
        elseif mousePos.Y > root.AbsoluteSize.Y - 200 then
            DockRegistry.console:ApplyLayout()
        end

        draggingPanel = nil
    end
end)

--// APPLY INITIAL LAYOUT
task.defer(function()
    moveExistingUI()
end)

--// RESIZE SUPPORT (basic responsive correction)
game:GetService("RunService").RenderStepped:Connect(function()

    local size = root.AbsoluteSize

    Layout.Left.Size = UDim2.new(0, 220, 1, -36)
    Layout.Right.Size = UDim2.new(0, 220, 1, -36)

    Layout.Bottom.Size = UDim2.new(1, -440, 0, math.clamp(size.Y * 0.25, 120, 220))
    Layout.Center.Size = UDim2.new(1, -440, 1, -Layout.Bottom.Size.Y.Offset - 36)

end)

--// STATUS
if statusText then
    statusText.Text = "STAGE 9 STEP 1 • DOCKING SYSTEM ACTIVE"
end--// =========================
--// STAGE 9 - STEP 2
--// FLOATING PANELS + MOBILE DRAG FIX
--// =========================

if not root then return end

local UIS = game:GetService("UserInputService")

--// FLOATING CONTAINER
local FloatingLayer = Instance.new("Frame")
FloatingLayer.Size = UDim2.fromScale(1, 1)
FloatingLayer.BackgroundTransparency = 1
FloatingLayer.Parent = root

--// TRACK FLOATING PANELS
local FloatingPanels = {}

--// CREATE FLOATING WINDOW WRAPPER
local function createFloatingPanel(name, content)
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 300, 0, 200)
    window.Position = UDim2.new(0.3, 0, 0.3, 0)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    window.BorderSizePixel = 0
    window.Parent = FloatingLayer

    Instance.new("UICorner", window)

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 28)
    top.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    top.Parent = window

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 1, 0)
    title.Position = UDim2.new(0, 5, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.fromRGB(220,220,220)
    title.Font = Enum.Font.Code
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 1, -28)
    body.Position = UDim2.new(0, 0, 0, 28)
    body.BackgroundTransparency = 1
    body.Parent = window

    content.Parent = body
    content.Size = UDim2.fromScale(1, 1)

    --// DRAG SYSTEM (TOUCH + MOUSE)
    local dragging = false
    local dragStart
    local startPos

    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    FloatingPanels[name] = window
    return window
end

--// AUTO UNDCK RULE (mobile friendly behavior)
local function autoFloatIfSmallScreen()
    local size = root.AbsoluteSize

    if size.X < 700 then
        -- mobile mode: float everything important
        if sidebar and not FloatingPanels["Explorer"] then
            createFloatingPanel("Explorer", sidebar)
        end

        if console and not FloatingPanels["Console"] then
            createFloatingPanel("Console", console)
        end
    end
end

--// SMART RESIZE LOOP
game:GetService("RunService").RenderStepped:Connect(function()
    autoFloatIfSmallScreen()
end)

--// DOUBLE TAP DETECT (mobile usability boost)
local lastTap = 0

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local now = tick()

        if now - lastTap < 0.3 then
            -- double tap: reset floating panels
            for _, panel in pairs(FloatingPanels) do
                panel.Position = UDim2.new(0.3, 0, 0.3, 0)
            end
        end

        lastTap = now
    end
end)

--// STATUS
if statusText then
    statusText.Text = "STAGE 9 STEP 2 • FLOATING + MOBILE SUPPORT"
end--// =========================
--// STAGE 9 - STEP 3
--// SNAP PREVIEW + DOCK ANIMATION SYSTEM
--// =========================

if not root then return end

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

--// SNAP ZONES VISUAL OVERLAY
local SnapOverlay = Instance.new("Frame")
SnapOverlay.Size = UDim2.fromScale(1, 1)
SnapOverlay.BackgroundTransparency = 1
SnapOverlay.Parent = root

local function createSnapZone(name, pos, size)
    local zone = Instance.new("Frame")
    zone.Name = name
    zone.Position = pos
    zone.Size = size
    zone.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    zone.BackgroundTransparency = 1
    zone.BorderSizePixel = 0
    zone.Parent = SnapOverlay

    Instance.new("UICorner", zone)

    return zone
end

--// SNAP AREAS
local zones = {
    Left = createSnapZone("Left", UDim2.new(0, 0, 0, 36), UDim2.new(0, 220, 1, -36)),
    Right = createSnapZone("Right", UDim2.new(1, -220, 0, 36), UDim2.new(0, 220, 1, -36)),
    Bottom = createSnapZone("Bottom", UDim2.new(0, 220, 1, -160), UDim2.new(1, -440, 0, 160)),
    Center = createSnapZone("Center", UDim2.new(0, 220, 0, 36), UDim2.new(1, -440, 1, -196))
}

--// SHOW SNAP PREVIEW
local function showZone(name)
    for zoneName, frame in pairs(zones) do
        if zoneName == name then
            TweenService:Create(frame, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.75
            }):Play()
        else
            TweenService:Create(frame, TweenInfo.new(0.15), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
end

--// HIDE ALL PREVIEWS
local function clearZones()
    for _, frame in pairs(zones) do
        TweenService:Create(frame, TweenInfo.new(0.15), {
            BackgroundTransparency = 1
        }):Play()
    end
end

--// DRAG STATE
local draggingPanel = nil

--// DETECT SNAP AREA WHILE DRAGGING
UIS.InputChanged:Connect(function(input)
    if not draggingPanel then return end

    local mouse = UIS:GetMouseLocation()

    if mouse.X < 200 then
        showZone("Left")
    elseif mouse.X > root.AbsoluteSize.X - 200 then
        showZone("Right")
    elseif mouse.Y > root.AbsoluteSize.Y - 200 then
        showZone("Bottom")
    else
        showZone("Center")
    end
end)

--// DROP → ANIMATED DOCK
UIS.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    if not draggingPanel then return end

    local mouse = UIS:GetMouseLocation()
    local targetFrame

    if mouse.X < 200 then
        targetFrame = Layout and Layout.Left
    elseif mouse.X > root.AbsoluteSize.X - 200 then
        targetFrame = Layout and Layout.Right
    elseif mouse.Y > root.AbsoluteSize.Y - 200 then
        targetFrame = Layout and Layout.Bottom
    else
        targetFrame = Layout and Layout.Center
    end

    clearZones()

    --// SMOOTH DOCK ANIMATION
    if targetFrame and FloatingPanels and FloatingPanels[draggingPanel] then
        local panel = FloatingPanels[draggingPanel]

        TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Position = targetFrame.AbsolutePosition and UDim2.new(0, targetFrame.AbsolutePosition.X, 0, targetFrame.AbsolutePosition.Y) or panel.Position,
            Size = UDim2.fromScale(1, 1)
        }):Play()
    end

    draggingPanel = nil
end)

--// ENHANCED FLOAT START (hook into Step 2 system)
local function hookDrag(name, window)
    local topbar = window:FindFirstChildWhichIsA("Frame")

    if topbar then
        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                draggingPanel = name
            end
        end)
    end
end

--// APPLY TO EXISTING FLOATING PANELS
if FloatingPanels then
    for name, panel in pairs(FloatingPanels) do
        hookDrag(name, panel)
    end
end

--// STATUS UPDATE
if statusText then
    statusText.Text = "STAGE 9 STEP 3 • SNAP + ANIMATION ACTIVE"
end--// =========================
--// STAGE 9 - STEP 4
--// WORKSPACE SAVE / LOAD SYSTEM
--// =========================

if not root then return end

local HttpService = game:GetService("HttpService")

--// WORKSPACE DATA STORAGE
local WorkspaceProfiles = {
    Default = {}
}

local CurrentProfile = "Default"

--// CAPTURE CURRENT LAYOUT STATE
local function captureLayout()
    local layoutData = {}

    -- floating panels
    if FloatingPanels then
        layoutData.floating = {}

        for name, panel in pairs(FloatingPanels) do
            layoutData.floating[name] = {
                x = panel.Position.X.Offset,
                y = panel.Position.Y.Offset,
                sizeX = panel.Size.X.Offset,
                sizeY = panel.Size.Y.Offset
            }
        end
    end

    return layoutData
end

--// APPLY LAYOUT STATE
local function applyLayout(data)
    if not data then return end

    if data.floating and FloatingPanels then
        for name, info in pairs(data.floating) do
            local panel = FloatingPanels[name]

            if panel then
                panel.Position = UDim2.new(0, info.x, 0, info.y)
                panel.Size = UDim2.new(0, info.sizeX, 0, info.sizeY)
            end
        end
    end
end

--// SAVE WORKSPACE PROFILE
local function saveProfile(name)
    WorkspaceProfiles[name] = captureLayout()
    CurrentProfile = name

    if statusText then
        statusText.Text = "WORKSPACE SAVED: " .. name
    end
end

--// LOAD WORKSPACE PROFILE
local function loadProfile(name)
    local data = WorkspaceProfiles[name]
    if not data then return end

    applyLayout(data)
    CurrentProfile = name

    if statusText then
        statusText.Text = "WORKSPACE LOADED: " .. name
    end
end

--// RESET TO DEFAULT LAYOUT
local function resetLayout()
    if WorkspaceProfiles.Default then
        applyLayout(WorkspaceProfiles.Default)
        CurrentProfile = "Default"
    end

    if statusText then
        statusText.Text = "LAYOUT RESET"
    end
end

--// EXPORT WORKSPACE (string format)
local function exportWorkspace(name)
    local data = WorkspaceProfiles[name] or captureLayout()
    return HttpService:JSONEncode(data)
end

--// IMPORT WORKSPACE (string format)
local function importWorkspace(json)
    local success, data = pcall(function()
        return HttpService:JSONDecode(json)
    end)

    if success then
        WorkspaceProfiles.Imported = data
        loadProfile("Imported")
    end
end

--// UI BUTTONS (workspace controls)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 120, 0, 25)
saveBtn.Position = UDim2.new(1, -130, 1, -150)
saveBtn.Text = "Save Layout"
saveBtn.Font = Enum.Font.Code
saveBtn.TextSize = 12
saveBtn.TextColor3 = Color3.fromRGB(255,255,255)
saveBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
saveBtn.Parent = root
Instance.new("UICorner", saveBtn)

saveBtn.MouseButton1Click:Connect(function()
    saveProfile(CurrentProfile)
end)

local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(0, 120, 0, 25)
loadBtn.Position = UDim2.new(1, -130, 1, -180)
loadBtn.Text = "Load Layout"
loadBtn.Font = Enum.Font.Code
loadBtn.TextSize = 12
loadBtn.TextColor3 = Color3.fromRGB(255,255,255)
loadBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
loadBtn.Parent = root
Instance.new("UICorner", loadBtn)

loadBtn.MouseButton1Click:Connect(function()
    loadProfile(CurrentProfile)
end)

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 120, 0, 25)
resetBtn.Position = UDim2.new(1, -130, 1, -210)
resetBtn.Text = "Reset Layout"
resetBtn.Font = Enum.Font.Code
resetBtn.TextSize = 12
resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
resetBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
resetBtn.Parent = root
Instance.new("UICorner", resetBtn)

resetBtn.MouseButton1Click:Connect(resetLayout)

--// SIMPLE PROFILE SWITCHER EXAMPLE
WorkspaceProfiles.Gaming = {}
WorkspaceProfiles.Coding = {}
WorkspaceProfiles.Debugging = {}

--// QUICK SWITCH (TAB KEYS)
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F6 then
        saveProfile("Coding")
    elseif input.KeyCode == Enum.KeyCode.F7 then
        loadProfile("Coding")
    elseif input.KeyCode == Enum.KeyCode.F8 then
        resetLayout()
    end
end)

--// INIT DEFAULT
WorkspaceProfiles.Default = captureLayout()

--// STATUS
if statusText then
    statusText.Text = "STAGE 9 COMPLETE • WORKSPACE SYSTEM ACTIVE"
end--// =========================
--// STAGE 10 - STEP 1
--// VIRTUAL FILE SYSTEM CORE
--// =========================

if not root then return end

--// FILE SYSTEM ROOT
local FileSystem = {
    folders = {
        ["Main"] = {
            type = "folder",
            children = {
                ["Script1"] = {
                    type = "file",
                    content = "print('Hello World')"
                }
            }
        }
    }
}

local CurrentFile = nil

--// CREATE FILE
local function createFile(folderName, fileName, content)
    if not FileSystem.folders[folderName] then return end

    FileSystem.folders[folderName].children[fileName] = {
        type = "file",
        content = content or ""
    }
end

--// CREATE FOLDER
local function createFolder(name)
    if FileSystem.folders[name] then return end

    FileSystem.folders[name] = {
        type = "folder",
        children = {}
    }
end

--// READ FILE
local function readFile(folderName, fileName)
    local folder = FileSystem.folders[folderName]
    if not folder then return "" end

    local file = folder.children[fileName]
    if not file then return "" end

    return file.content
end

--// WRITE FILE
local function writeFile(folderName, fileName, content)
    local folder = FileSystem.folders[folderName]
    if not folder then return end

    local file = folder.children[fileName]
    if not file then return end

    file.content = content
end

--// SIMPLE FILE TREE UI
local explorerUI = Instance.new("Frame")
explorerUI.Size = UDim2.new(1, 0, 1, 0)
explorerUI.BackgroundTransparency = 1
explorerUI.Parent = sidebar or root

local layout = Instance.new("UIListLayout")
layout.Parent = explorerUI

--// RENDER FILE TREE
local function renderFileTree()
    for _, v in ipairs(explorerUI:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    for folderName, folder in pairs(FileSystem.folders) do
        local folderBtn = Instance.new("TextButton")
        folderBtn.Size = UDim2.new(1, -5, 0, 25)
        folderBtn.Text = "📁 " .. folderName
        folderBtn.Font = Enum.Font.Code
        folderBtn.TextSize = 12
        folderBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        folderBtn.TextColor3 = Color3.fromRGB(255,255,255)
        folderBtn.Parent = explorerUI

        Instance.new("UICorner", folderBtn)

        folderBtn.MouseButton1Click:Connect(function()
            log("Opened folder: " .. folderName, "INFO")
        end)

        for fileName, file in pairs(folder.children) do
            local fileBtn = Instance.new("TextButton")
            fileBtn.Size = UDim2.new(1, -10, 0, 22)
            fileBtn.Text = "   📄 " .. fileName
            fileBtn.Font = Enum.Font.Code
            fileBtn.TextSize = 11
            fileBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
            fileBtn.TextColor3 = Color3.fromRGB(200,200,200)
            fileBtn.Parent = explorerUI

            Instance.new("UICorner", fileBtn)

            fileBtn.MouseButton1Click:Connect(function()
                CurrentFile = {folder = folderName, file = fileName}

                if textBox then
                    textBox.Text = readFile(folderName, fileName)
                end

                log("Opened file: " .. fileName, "OK")
            end)
        end
    end
end

--// SAVE CURRENT FILE BACK
local function saveCurrentFile()
    if not CurrentFile then return end

    writeFile(CurrentFile.folder, CurrentFile.file, textBox.Text)
end

--// AUTO SAVE
if textBox then
    textBox:GetPropertyChangedSignal("Text"):Connect(saveCurrentFile)
end

--// INIT FILE TREE
task.defer(renderFileTree)

--// STATUS
if statusText then
    statusText.Text = "STAGE 10 STEP 1 • FILE SYSTEM ACTIVE"
end

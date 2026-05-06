--[=[
 _________  ___  ___  ________  _______   _______   ________       ________  _______   ___      ___
|\___   ___\\  \|\  \|\   __  \|\  ___ \ |\  ___ \ |\   __  \     |\   ___ \|\  ___ \ |\  \    /  /|
\|___ \  \_\ \  \\\  \ \  \|\  \ \   __/|\ \   __/|\ \  \|\  \    \ \  \_|\ \ \   __/|\ \  \  /  / /
     \ \  \ \ \   __  \ \   _  _\ \  \_|/_\ \  \_|/_\ \  \\\  \    \ \  \ \\ \ \  \_|/_\ \  \/  / /
      \ \  \ \ \  \ \  \ \  \\  \\ \  \_|\ \ \  \_|\ \ \  \\\  \  __\ \  \_\\ \ \  \_|\ \ \    / /
       \ \__\ \ \__\ \__\ \__\\ _\\ \_______\ \_______\ \_____  \|\__\ \_______\ \_______\ \__/ /
        \|__|  \|__|\|__|\|__|\|__|\|_______|\|_______|\|___| \__\|__|\|_______|\|_______|\|__|/
                                                             \|__|
--]=]

-- Made by vanish

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CONFIG = {
    replicatedStorage = true,
    replicatedFirst = true,
    starterGui = true,
    starterPack = false,
    starterPlayer = true,
    playerGui = true,
    backpack = false,
    playerScripts = true,
    workspace = false,
    remotes = false,
    playerData = true,
    nilInstances = false,
    lighting = false,
    sounds = false,
    animations = false,
    bindables = false,
}

local NIL_FILTER = {
    "ModuleScript", "LocalScript", "Script",
}

local SETTINGS = {
    logFontSize   = 10,
    labelFontSize = 11,
    descFontSize  = 10,
    timestampFontSize = 9,
    sidebarWidth  = 210,
}

local C = {
    bg       = Color3.fromRGB(18, 18, 18),
    surface  = Color3.fromRGB(24, 24, 24),
    surface2 = Color3.fromRGB(30, 30, 30),
    border   = Color3.fromRGB(45, 45, 45),
    border2  = Color3.fromRGB(60, 60, 60),
    text     = Color3.fromRGB(230, 230, 230),
    text2    = Color3.fromRGB(140, 140, 140),
    text3    = Color3.fromRGB(90, 90, 90),
    accent   = Color3.fromRGB(220, 220, 220),
    green    = Color3.fromRGB(74, 222, 128),
    amber    = Color3.fromRGB(251, 191, 36),
    red      = Color3.fromRGB(248, 113, 113),
    purple   = Color3.fromRGB(167, 139, 250),
    white    = Color3.fromRGB(255, 255, 255),
    black    = Color3.fromRGB(0, 0, 0),
    btnBg    = Color3.fromRGB(235, 235, 235),
    btnText  = Color3.fromRGB(10, 10, 10),
}

local FONT_MONO = Enum.Font.Code
local FONT_UI   = Enum.Font.GothamMedium
local FONT_BODY = Enum.Font.Gotham

local localPlayer = Players.LocalPlayer
local playerGuiService = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
local function generateUUID()
    local t = {"a","b","c","d","e","f","0","1","2","3","4","5","6","7","8","9"}
    local uuid = ""
    for i = 1, 8 do
        uuid = uuid .. t[math.random(1, #t)]
    end
    return uuid
end
local SESSION_UUID = generateUUID()
screenGui.Name = "Exporter_"..SESSION_UUID
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = playerGuiService

local function mkCorner(r, p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
    return c
end

local function mkStroke(thickness, color, transparency, p)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness
    s.Color = color
    s.Transparency = transparency
    s.Parent = p
    return s
end

local function mkFrame(props)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = props.bg or C.surface
    f.BorderSizePixel = 0
    if props.size   then f.Size = props.size end
    if props.pos    then f.Position = props.pos end
    if props.anchor then f.AnchorPoint = props.anchor end
    if props.clip ~= nil then f.ClipsDescendants = props.clip end
    if props.parent then f.Parent = props.parent end
    if props.name   then f.Name = props.name end
    if props.zindex then f.ZIndex = props.zindex end
    return f
end

local function mkLabel(props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = props.text or ""
    l.TextColor3 = props.color or C.text
    l.TextSize = props.size or 13
    l.Font = props.font or FONT_BODY
    l.TextXAlignment = props.xalign or Enum.TextXAlignment.Left
    l.TextYAlignment = props.yalign or Enum.TextYAlignment.Center
    l.TextWrapped = props.wrap or false
    if props.sz     then l.Size = props.sz end
    if props.pos    then l.Position = props.pos end
    if props.anchor then l.AnchorPoint = props.anchor end
    if props.parent then l.Parent = props.parent end
    if props.name   then l.Name = props.name end
    if props.zindex then l.ZIndex = props.zindex end
    return l
end

local function mkButton(props)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = props.bg or C.surface2
    b.BorderSizePixel = 0
    b.Text = props.text or ""
    b.TextColor3 = props.color or C.text
    b.TextSize = props.size or 13
    b.Font = props.font or FONT_UI
    b.AutoButtonColor = false
    if props.sz     then b.Size = props.sz end
    if props.pos    then b.Position = props.pos end
    if props.anchor then b.AnchorPoint = props.anchor end
    if props.parent then b.Parent = props.parent end
    if props.name   then b.Name = props.name end
    return b
end

local MIN_W, MAX_W = 480, 1100
local MIN_H, MAX_H = 360, 820

local mainFrame = mkFrame({
    bg = C.bg,
    size = UDim2.new(0, 620, 0, 500),
    pos = UDim2.new(0.5, 0, 0.5, 0),
    anchor = Vector2.new(0.5, 0.5),
    clip = true,
    parent = screenGui,
    name = "Main",
})
mkCorner(8, mainFrame)
mkStroke(1, C.border, 0, mainFrame)

local dragging = false
local dragStart, startPos

local function setupDrag(handle)
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local resizing = {}
local resizeStart = {}
local resizeFrameStart = {}

local EDGE_SIZE = 6

local function makeResizeHandle(name, cursor, xAnchor, yAnchor, xDir, yDir)
    local handle = Instance.new("TextButton")
    handle.Name = "Resize_"..name
    handle.BackgroundTransparency = 1
    handle.BorderSizePixel = 0
    handle.Text = ""
    handle.AutoButtonColor = false
    handle.ZIndex = 50

    if name == "Right" then
        handle.Size = UDim2.new(0, EDGE_SIZE, 1, -16)
        handle.Position = UDim2.new(1, -EDGE_SIZE, 0, 8)
        handle.AnchorPoint = Vector2.new(0, 0)
    elseif name == "Left" then
        handle.Size = UDim2.new(0, EDGE_SIZE, 1, -16)
        handle.Position = UDim2.new(0, 0, 0, 8)
        handle.AnchorPoint = Vector2.new(0, 0)
    elseif name == "Bottom" then
        handle.Size = UDim2.new(1, -16, 0, EDGE_SIZE)
        handle.Position = UDim2.new(0, 8, 1, -EDGE_SIZE)
        handle.AnchorPoint = Vector2.new(0, 0)
    elseif name == "Top" then
        handle.Size = UDim2.new(1, -16, 0, EDGE_SIZE)
        handle.Position = UDim2.new(0, 8, 0, 0)
        handle.AnchorPoint = Vector2.new(0, 0)
    elseif name == "BottomRight" then
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new(1, -12, 1, -12)
        handle.AnchorPoint = Vector2.new(0, 0)
    elseif name == "BottomLeft" then
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new(0, 0, 1, -12)
        handle.AnchorPoint = Vector2.new(0, 0)
    elseif name == "TopRight" then
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new(1, -12, 0, 0)
        handle.AnchorPoint = Vector2.new(0, 0)
    elseif name == "TopLeft" then
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new(0, 0, 0, 0)
        handle.AnchorPoint = Vector2.new(0, 0)
    end

    handle.Parent = mainFrame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing[name] = true
            resizeStart[name] = input.Position
            resizeFrameStart[name] = {
                x = mainFrame.Position.X.Offset,
                y = mainFrame.Position.Y.Offset,
                w = mainFrame.AbsoluteSize.X,
                h = mainFrame.AbsoluteSize.Y,
            }
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing[name] = false
        end
    end)
end

makeResizeHandle("Right")
makeResizeHandle("Left")
makeResizeHandle("Bottom")
makeResizeHandle("Top")
makeResizeHandle("BottomRight")
makeResizeHandle("BottomLeft")
makeResizeHandle("TopRight")
makeResizeHandle("TopLeft")

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    for name, active in pairs(resizing) do
        if not active then continue end
        local start = resizeStart[name]
        local fstart = resizeFrameStart[name]
        local delta = input.Position - start
        local newW = fstart.w
        local newH = fstart.h
        local newX = fstart.x
        local newY = fstart.y

        if name == "Right" or name == "BottomRight" or name == "TopRight" then
            newW = math.clamp(fstart.w + delta.X, MIN_W, MAX_W)
        end
        if name == "Left" or name == "BottomLeft" or name == "TopLeft" then
            newW = math.clamp(fstart.w - delta.X, MIN_W, MAX_W)
            newX = fstart.x + (fstart.w - newW)
        end
        if name == "Bottom" or name == "BottomRight" or name == "BottomLeft" then
            newH = math.clamp(fstart.h + delta.Y, MIN_H, MAX_H)
        end
        if name == "Top" or name == "TopRight" or name == "TopLeft" then
            newH = math.clamp(fstart.h - delta.Y, MIN_H, MAX_H)
            newY = fstart.y + (fstart.h - newH)
        end

        mainFrame.Size = UDim2.new(0, newW, 0, newH)
        mainFrame.Position = UDim2.new(0.5, newX - mainFrame.AbsoluteSize.X * 0.5 + newW * 0.5, 0.5, newY - mainFrame.AbsoluteSize.Y * 0.5 + newH * 0.5)
    end
end)

local titleBar = mkFrame({
    bg = C.surface,
    size = UDim2.new(1, 0, 0, 36),
    pos = UDim2.new(0, 0, 0, 0),
    parent = mainFrame,
    name = "TitleBar",
})
setupDrag(titleBar)

mkLabel({
    text = "Exporter",
    color = C.text2,
    size = 11,
    font = FONT_MONO,
    sz = UDim2.new(0, 70, 1, 0),
    pos = UDim2.new(0, 14, 0, 0),
    parent = titleBar,
})

local badgeFrame = mkFrame({
    bg = C.surface2,
    size = UDim2.new(0, 32, 0, 16),
    pos = UDim2.new(0, 74, 0.5, 0),
    anchor = Vector2.new(0, 0.5),
    parent = titleBar,
})
mkCorner(20, badgeFrame)
mkStroke(1, C.border2, 0, badgeFrame)
mkLabel({
    text = "v1.0",
    color = C.text3,
    size = 9,
    font = FONT_MONO,
    sz = UDim2.new(1, 0, 1, 0),
    pos = UDim2.new(0, 0, 0, 0),
    xalign = Enum.TextXAlignment.Center,
    parent = badgeFrame,
})

local statusLabel = mkLabel({
    text = "idle",
    color = C.text3,
    size = 9,
    font = FONT_MONO,
    sz = UDim2.new(0, 120, 1, 0),
    pos = UDim2.new(1, -128, 0, 0),
    xalign = Enum.TextXAlignment.Right,
    parent = titleBar,
    name = "StatusLabel",
})
statusLabel.Text = "id:"..SESSION_UUID

local closeBtn = mkButton({
    text = "×",
    bg = C.bg,
    color = C.text3,
    size = 16,
    font = FONT_UI,
    sz = UDim2.new(0, 28, 0, 28),
    pos = UDim2.new(1, -4, 0.5, 0),
    anchor = Vector2.new(1, 0.5),
    parent = titleBar,
    name = "CloseBtn",
})
closeBtn.BackgroundTransparency = 1
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local progBar = mkFrame({
    bg = C.surface2,
    size = UDim2.new(1, 0, 0, 2),
    pos = UDim2.new(0, 0, 0, 36),
    parent = mainFrame,
})
local progFill = mkFrame({
    bg = C.accent,
    size = UDim2.new(0, 0, 1, 0),
    pos = UDim2.new(0, 0, 0, 0),
    parent = progBar,
    name = "Fill",
})

local function setProgress(pct)
    TweenService:Create(progFill, TweenInfo.new(0.25), {
        Size = UDim2.new(pct / 100, 0, 1, 0)
    }):Play()
end

local TAB_NAMES = { "config", "settings" }
local activeTab = "config"

local tabBar = mkFrame({
    bg = C.surface,
    size = UDim2.new(1, 0, 0, 30),
    pos = UDim2.new(0, 0, 0, 38),
    parent = mainFrame,
})
mkStroke(1, C.border, 0, tabBar)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 0)
tabLayout.Parent = tabBar

local tabPad = Instance.new("UIPadding")
tabPad.PaddingLeft = UDim.new(0, 10)
tabPad.Parent = tabBar

local tabBtns = {}
local tabPanels = {}

local bodyFrame = mkFrame({
    bg = C.bg,
    size = UDim2.new(1, 0, 1, -70),
    pos = UDim2.new(0, 0, 0, 70),
    parent = mainFrame,
    name = "Body",
})

local function makeTab(name, order)
    local btn = mkButton({
        text = name,
        bg = C.surface,
        color = C.text3,
        size = 10,
        font = FONT_MONO,
        sz = UDim2.new(0, 70, 0, 24),
        parent = tabBar,
    })
    btn.LayoutOrder = order
    btn.BackgroundTransparency = 1
    mkCorner(4, btn)

    local panel = mkFrame({
        bg = C.bg,
        size = UDim2.new(1, 0, 1, 0),
        pos = UDim2.new(0, 0, 0, 0),
        parent = bodyFrame,
        name = "Panel_"..name,
    })
    panel.Visible = (name == "config")

    tabBtns[name] = btn
    tabPanels[name] = panel

    btn.MouseButton1Click:Connect(function()
        activeTab = name
        for n, b in pairs(tabBtns) do
            b.TextColor3 = (n == name) and C.text or C.text3
            b.BackgroundTransparency = (n == name) and 0 or 1
            b.BackgroundColor3 = C.surface2
        end
        for n, p in pairs(tabPanels) do
            p.Visible = (n == name)
        end
    end)

    return panel
end

local configPanel   = makeTab("config", 1)
local settingsPanel = makeTab("settings", 2)

tabBtns["config"].TextColor3 = C.text
tabBtns["config"].BackgroundTransparency = 0
tabBtns["config"].BackgroundColor3 = C.surface2

local sidebar = mkFrame({
    bg = C.bg,
    size = UDim2.new(0, SETTINGS.sidebarWidth, 1, 0),
    pos = UDim2.new(0, 0, 0, 0),
    parent = configPanel,
    name = "Sidebar",
})

mkFrame({
    bg = C.border,
    size = UDim2.new(0, 1, 1, 0),
    pos = UDim2.new(1, 0, 0, 0),
    parent = sidebar,
})

mkLabel({
    text = "SERVICES",
    color = C.text3,
    size = 9,
    font = FONT_UI,
    sz = UDim2.new(1, -14, 0, 24),
    pos = UDim2.new(0, 14, 0, 0),
    parent = sidebar,
})

local optScroll = Instance.new("ScrollingFrame")
optScroll.Size = UDim2.new(1, 0, 1, -180)
optScroll.Position = UDim2.new(0, 0, 0, 24)
optScroll.BackgroundTransparency = 1
optScroll.BorderSizePixel = 0
optScroll.ScrollBarThickness = 2
optScroll.ScrollBarImageColor3 = C.border2
optScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
optScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
optScroll.Parent = sidebar

local optList = Instance.new("UIListLayout")
optList.SortOrder = Enum.SortOrder.LayoutOrder
optList.Padding = UDim.new(0, 0)
optList.Parent = optScroll

local OPTIONS = {
    { id = "replicatedStorage", label = "ReplicatedStorage", desc = "UI + scripts" },
    { id = "replicatedFirst",   label = "ReplicatedFirst",   desc = "early-load content" },
    { id = "starterGui",        label = "StarterGui",        desc = "starter UI hierarchy" },
    { id = "starterPack",       label = "StarterPack",       desc = "starter pack items" },
    { id = "starterPlayer",     label = "StarterPlayer",     desc = "player scripts" },
    { id = "playerGui",         label = "PlayerGui",         desc = "live player UI" },
    { id = "backpack",          label = "Backpack",          desc = "tool instances" },
    { id = "playerScripts",     label = "PlayerScripts",     desc = "client scripts" },
    { id = "workspace",         label = "Workspace",         desc = "parts, models, folders" },
    { id = "remotes",           label = "Remotes",           desc = "scan all remotes" },
    { id = "playerData",        label = "PlayerData",        desc = "stats, attributes, values" },
    { id = "nilInstances",      label = "Nil Instances",     desc = "getnilinstances() scan" },
    { id = "lighting",          label = "Lighting",           desc = "properties + fog + sky" },
    { id = "sounds",            label = "Sounds",             desc = "all Sound instances" },
    { id = "animations",        label = "Animations",         desc = "Animation ids + tracks" },
    { id = "bindables",         label = "Bindables",          desc = "BindableEvent/Function" },
}

local checkboxRefs  = {}
local optLabelRefs  = {}
local optDescRefs   = {}

local function makeCheckbox(opt, order)
    local row = mkFrame({
        bg = C.bg,
        size = UDim2.new(1, 0, 0, 42),
        parent = optScroll,
    })
    row.LayoutOrder = order
    row.Name = "Row_"..opt.id

    mkFrame({ bg = Color3.fromRGB(35,35,35), size = UDim2.new(1,0,0,1), pos = UDim2.new(0,0,1,-1), parent = row })

    local chkOuter = mkFrame({
        bg = CONFIG[opt.id] and C.btnBg or C.surface2,
        size = UDim2.new(0, 14, 0, 14),
        pos = UDim2.new(0, 14, 0.5, 0),
        anchor = Vector2.new(0, 0.5),
        parent = row,
    })
    mkCorner(2, chkOuter)
    mkStroke(1, C.border2, 0, chkOuter)

    local chkTick = mkLabel({
        text = "✓",
        color = C.btnText,
        size = 9,
        font = FONT_UI,
        sz = UDim2.new(1, 0, 1, 0),
        pos = UDim2.new(0, 0, 0, 0),
        xalign = Enum.TextXAlignment.Center,
        parent = chkOuter,
    })
    chkTick.Visible = CONFIG[opt.id]

    local nameLabel = mkLabel({
        text = opt.label,
        color = C.text,
        size = SETTINGS.labelFontSize,
        font = FONT_MONO,
        sz = UDim2.new(1, -36, 0, 16),
        pos = UDim2.new(0, 34, 0, 8),
        parent = row,
    })
    local descLabel = mkLabel({
        text = opt.desc,
        color = C.text3,
        size = SETTINGS.descFontSize,
        font = FONT_BODY,
        sz = UDim2.new(1, -36, 0, 14),
        pos = UDim2.new(0, 34, 1, -20),
        parent = row,
    })

    checkboxRefs[opt.id] = { outer = chkOuter, tick = chkTick }
    table.insert(optLabelRefs, nameLabel)
    table.insert(optDescRefs, descLabel)

    local btn = mkButton({
        text = "", bg = C.bg,
        sz = UDim2.new(1,0,1,0), pos = UDim2.new(0,0,0,0),
        parent = row,
    })
    btn.BackgroundTransparency = 1
    btn.ZIndex = 5

    btn.MouseButton1Click:Connect(function()
        CONFIG[opt.id] = not CONFIG[opt.id]
        chkTick.Visible = CONFIG[opt.id]
        chkOuter.BackgroundColor3 = CONFIG[opt.id] and C.btnBg or C.surface2
    end)
    btn.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), { BackgroundColor3 = C.surface }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), { BackgroundColor3 = C.bg }):Play()
    end)
end

for i, opt in ipairs(OPTIONS) do makeCheckbox(opt, i) end

local nilSection = mkFrame({
    bg = C.surface,
    size = UDim2.new(1, 0, 0, 108),
    pos = UDim2.new(0, 0, 1, -153),
    parent = sidebar,
})
mkStroke(1, C.border, 0, nilSection)

mkLabel({
    text = "NIL FILTERS",
    color = C.text3, size = 9, font = FONT_UI,
    sz = UDim2.new(1,-14,0,24), pos = UDim2.new(0,14,0,0),
    parent = nilSection,
})

local nilTagScroll = Instance.new("ScrollingFrame")
nilTagScroll.Size = UDim2.new(1,-10,0,50)
nilTagScroll.Position = UDim2.new(0,5,0,24)
nilTagScroll.BackgroundTransparency = 1
nilTagScroll.BorderSizePixel = 0
nilTagScroll.ScrollBarThickness = 0
nilTagScroll.CanvasSize = UDim2.new(0,0,0,0)
nilTagScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
nilTagScroll.ScrollingDirection = Enum.ScrollingDirection.X
nilTagScroll.Parent = nilSection

local nilTagLayout = Instance.new("UIListLayout")
nilTagLayout.FillDirection = Enum.FillDirection.Horizontal
nilTagLayout.SortOrder = Enum.SortOrder.LayoutOrder
nilTagLayout.Padding = UDim.new(0, 4)
nilTagLayout.VerticalAlignment = Enum.VerticalAlignment.Center
nilTagLayout.Parent = nilTagScroll

local nilPad = Instance.new("UIPadding")
nilPad.PaddingLeft = UDim.new(0, 4)
nilPad.Parent = nilTagScroll

local nilFilterActive = {}
for _, cls in ipairs(NIL_FILTER) do nilFilterActive[cls] = true end

local nilTagInstances = {}

local function makeNilTag(cls)
    local tagFrame = mkFrame({ bg = C.surface2, size = UDim2.new(0,0,0,20), parent = nilTagScroll })
    tagFrame.AutomaticSize = Enum.AutomaticSize.X
    mkCorner(20, tagFrame)
    mkStroke(1, C.border2, 0, tagFrame)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = tagFrame

    local tagLabel = mkLabel({
        text = cls, color = nilFilterActive[cls] and C.text or C.text3,
        size = 9, font = FONT_MONO,
        sz = UDim2.new(0,0,1,0), pos = UDim2.new(0,0,0,0),
        xalign = Enum.TextXAlignment.Center, parent = tagFrame,
    })
    tagLabel.AutomaticSize = Enum.AutomaticSize.X
    tagFrame.BackgroundColor3 = nilFilterActive[cls] and C.surface or C.surface2

    local tagBtn = mkButton({ text = "", bg = C.bg, sz = UDim2.new(1,0,1,0), pos = UDim2.new(0,0,0,0), parent = tagFrame })
    tagBtn.BackgroundTransparency = 1; tagBtn.ZIndex = 5

    tagBtn.MouseButton1Click:Connect(function()
        nilFilterActive[cls] = not nilFilterActive[cls]
        tagFrame.BackgroundColor3 = nilFilterActive[cls] and C.surface or C.surface2
        tagLabel.TextColor3 = nilFilterActive[cls] and C.text or C.text3
        local newFilter = {}
        for k, v in pairs(nilFilterActive) do if v then table.insert(newFilter, k) end end
        NIL_FILTER = newFilter
    end)

    nilTagInstances[cls] = tagFrame
end

for _, cls in ipairs(NIL_FILTER) do makeNilTag(cls) end

local addTagBox = Instance.new("TextBox")
addTagBox.Size = UDim2.new(1,-28,0,22)
addTagBox.Position = UDim2.new(0,14,1,-28)
addTagBox.BackgroundColor3 = C.surface2
addTagBox.BorderSizePixel = 0
addTagBox.Text = ""
addTagBox.PlaceholderText = "add class..."
addTagBox.PlaceholderColor3 = C.text3
addTagBox.TextColor3 = C.text
addTagBox.TextSize = 10
addTagBox.Font = FONT_MONO
addTagBox.ClearTextOnFocus = false
addTagBox.Parent = nilSection
mkCorner(4, addTagBox)
mkStroke(1, C.border2, 0, addTagBox)
local ap = Instance.new("UIPadding"); ap.PaddingLeft = UDim.new(0,6); ap.Parent = addTagBox

local addTagBtn = mkButton({
    text = "+", bg = C.surface2, color = C.text2, size = 10, font = FONT_MONO,
    sz = UDim2.new(0,20,0,22), pos = UDim2.new(1,-22,1,-28), parent = nilSection,
})
mkCorner(4, addTagBtn)
mkStroke(1, C.border2, 0, addTagBtn)

local function addNilTag()
    local cls = addTagBox.Text:match("^%s*(.-)%s*$")
    if cls ~= "" and not nilTagInstances[cls] then
        nilFilterActive[cls] = true
        table.insert(NIL_FILTER, cls)
        makeNilTag(cls)
        addTagBox.Text = ""
    end
end
addTagBtn.MouseButton1Click:Connect(addNilTag)
addTagBox.FocusLost:Connect(function(enter) if enter then addNilTag() end end)

local runBarFrame = mkFrame({
    bg = C.surface,
    size = UDim2.new(1, 0, 0, 46),
    pos = UDim2.new(0, 0, 1, -46),
    parent = sidebar,
})
mkStroke(1, C.border, 0, runBarFrame)

local runBtn = mkButton({
    text = "run export",
    bg = C.btnBg, color = C.btnText, size = 11, font = FONT_MONO,
    sz = UDim2.new(1,-28,0,28), pos = UDim2.new(0,14,0.5,0),
    anchor = Vector2.new(0,0.5), parent = runBarFrame, name = "RunBtn",
})
mkCorner(5, runBtn)
runBtn.MouseEnter:Connect(function()
    TweenService:Create(runBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.white }):Play()
end)
runBtn.MouseLeave:Connect(function()
    TweenService:Create(runBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.btnBg }):Play()
end)

local logPanel = mkFrame({
    bg = C.bg,
    size = UDim2.new(1, -(SETTINGS.sidebarWidth + 1), 1, 0),
    pos = UDim2.new(0, SETTINGS.sidebarWidth + 1, 0, 0),
    parent = configPanel,
    clip = true,
    name = "LogPanel",
})

local logToolbar = mkFrame({
    bg = C.surface,
    size = UDim2.new(1, 0, 0, 32),
    pos = UDim2.new(0, 0, 0, 0),
    parent = logPanel,
})

local FILTER_LEVELS = { "all", "info", "warn", "error", "ok", "nil" }
local FILTER_COLORS = {
    all = C.text2, info = C.text2, warn = C.amber,
    error = C.red, ok = C.green, ["nil"] = C.purple,
}

local filterBtns = {}
local activeFilter = "all"
local logEntries = {}
local allLogs = {}
local logOrder = 0

local filterLayout = Instance.new("UIListLayout")
filterLayout.FillDirection = Enum.FillDirection.Horizontal
filterLayout.SortOrder = Enum.SortOrder.LayoutOrder
filterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
filterLayout.Padding = UDim.new(0, 2)
filterLayout.Parent = logToolbar

local filterPadding = Instance.new("UIPadding")
filterPadding.PaddingLeft = UDim.new(0, 10)
filterPadding.Parent = logToolbar

for i, level in ipairs(FILTER_LEVELS) do
    local fb = mkButton({
        text = level, bg = C.bg, color = C.text3, size = 9, font = FONT_MONO,
        sz = UDim2.new(0, 36, 0, 20), parent = logToolbar,
    })
    fb.BackgroundTransparency = 1
    fb.LayoutOrder = i
    fb.Name = "Filter_"..level
    mkCorner(20, fb)
    filterBtns[level] = fb

    fb.MouseButton1Click:Connect(function()
        activeFilter = level
        for lv, btn in pairs(filterBtns) do
            btn.BackgroundTransparency = 1; btn.TextColor3 = C.text3
        end
        fb.BackgroundTransparency = 0
        fb.BackgroundColor3 = C.surface2
        fb.TextColor3 = FILTER_COLORS[level] or C.text
        for _, entry in pairs(logEntries) do
            local show = (level == "all") or (level == entry.level) or (level == entry.mappedLevel)
            entry.row.Visible = show
        end
    end)
end
filterBtns["all"].BackgroundTransparency = 0
filterBtns["all"].BackgroundColor3 = C.surface2
filterBtns["all"].TextColor3 = C.text2

local logCountLabel = mkLabel({
    text = "0 entries", color = C.text3, size = 9, font = FONT_MONO,
    sz = UDim2.new(0, 60, 1, 0), pos = UDim2.new(1, -130, 0, 0),
    xalign = Enum.TextXAlignment.Right, parent = logToolbar,
})

local clearLogsBtn = mkButton({
    text = "clear", bg = C.surface2, color = C.text3, size = 9, font = FONT_MONO,
    sz = UDim2.new(0, 42, 0, 20), pos = UDim2.new(1, -50, 0.5, 0),
    anchor = Vector2.new(0, 0.5), parent = logToolbar,
})
mkCorner(4, clearLogsBtn)
mkStroke(1, C.border2, 0, clearLogsBtn)
clearLogsBtn.MouseEnter:Connect(function()
    clearLogsBtn.TextColor3 = C.text
end)
clearLogsBtn.MouseLeave:Connect(function()
    clearLogsBtn.TextColor3 = C.text3
end)

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, 0, 1, -64)
logScroll.Position = UDim2.new(0, 0, 0, 32)
logScroll.BackgroundTransparency = 1
logScroll.BorderSizePixel = 0
logScroll.ScrollBarThickness = 2
logScroll.ScrollBarImageColor3 = C.border2
logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logScroll.Parent = logPanel

local logListLayout = Instance.new("UIListLayout")
logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
logListLayout.Padding = UDim.new(0, 0)
logListLayout.Parent = logScroll

local statsBarFrame = mkFrame({
    bg = C.surface,
    size = UDim2.new(1, 0, 0, 32),
    pos = UDim2.new(0, 0, 1, -32),
    parent = logPanel,
})

local STAT_DEFS = {
    { key = "total",     prefix = "entries" },
    { key = "warn",      prefix = "warn"    },
    { key = "err",       prefix = "error"   },
    { key = "nil_found", prefix = "nil"     },
}

local statsLayout = Instance.new("UIListLayout")
statsLayout.FillDirection = Enum.FillDirection.Horizontal
statsLayout.SortOrder = Enum.SortOrder.LayoutOrder
statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
statsLayout.Padding = UDim.new(0, 0)
statsLayout.Parent = statsBarFrame

local statsBarPad = Instance.new("UIPadding")
statsBarPad.PaddingLeft = UDim.new(0, 14)
statsBarPad.Parent = statsBarFrame

local statLabels = {}
for i, def in ipairs(STAT_DEFS) do
    local container = mkFrame({ bg = C.bg, size = UDim2.new(0, 80, 1, 0), parent = statsBarFrame })
    container.BackgroundTransparency = 1
    container.LayoutOrder = i
    local lbl = mkLabel({
        text = def.prefix.." 0", color = C.text3, size = 9, font = FONT_MONO,
        sz = UDim2.new(1,0,1,0), pos = UDim2.new(0,0,0,0), parent = container,
    })
    statLabels[def.key] = { label = lbl, prefix = def.prefix }
end

local LEVEL_COLORS = {
    info = C.text2, warn = C.amber, error = C.red,
    success = C.green, ["nil"] = C.purple,
}
local LEVEL_BORDER = {
    info = C.border, warn = Color3.fromRGB(120,80,0), error = Color3.fromRGB(120,30,30),
    success = Color3.fromRGB(30,100,50), ["nil"] = Color3.fromRGB(90,50,150),
}

local exportStats = { total = 0, warn = 0, err = 0, nil_found = 0, ui = 0, scripts = 0 }

local function updateStatsBar()
    for key, ref in pairs(statLabels) do
        ref.label.Text = ref.prefix.." "..(exportStats[key] or 0)
    end
end

local function scrollToBottom()
    task.defer(function()
        logScroll.CanvasPosition = Vector2.new(0, math.max(0, logScroll.AbsoluteCanvasSize.Y - logScroll.AbsoluteSize.Y))
    end)
end

local function addLogEntry(msg, level)
    level = level or "info"
    logOrder = logOrder + 1
    local mappedLevel = level == "success" and "ok" or level

    local row = mkFrame({ bg = C.bg, size = UDim2.new(1,0,0,22), parent = logScroll })
    row.LayoutOrder = logOrder

    mkFrame({ bg = LEVEL_BORDER[level] or C.border, size = UDim2.new(0,2,1,0), pos = UDim2.new(0,0,0,0), parent = row })

    local timeLabel = mkLabel({
        text = os.date("%H:%M:%S"), color = C.text3,
        size = SETTINGS.timestampFontSize, font = FONT_MONO,
        sz = UDim2.new(0,58,1,0), pos = UDim2.new(0,6,0,0), parent = row,
    })
    local lvlLabel = mkLabel({
        text = "["..level:upper().."]",
        color = LEVEL_COLORS[level] or C.text2,
        size = SETTINGS.logFontSize - 1, font = FONT_MONO,
        sz = UDim2.new(0,54,1,0), pos = UDim2.new(0,62,0,0), parent = row,
    })
    local msgLabel = mkLabel({
        text = msg, color = LEVEL_COLORS[level] or C.text,
        size = SETTINGS.logFontSize, font = FONT_MONO,
        sz = UDim2.new(1,-120,1,0), pos = UDim2.new(0,118,0,0),
        parent = row, wrap = false,
    })

    local show = (activeFilter == "all") or (activeFilter == level) or (activeFilter == mappedLevel)
    row.Visible = show

    table.insert(allLogs, { msg = msg, level = level })
    logEntries[logOrder] = {
        row = row, level = level, mappedLevel = mappedLevel,
        timeLabel = timeLabel, lvlLabel = lvlLabel, msgLabel = msgLabel,
    }
    logCountLabel.Text = #allLogs.." entries"
    scrollToBottom()
end

clearLogsBtn.MouseButton1Click:Connect(function()
    for _, entry in pairs(logEntries) do entry.row:Destroy() end
    logEntries = {}
    allLogs = {}
    logOrder = 0
    logCountLabel.Text = "0 entries"
    exportStats = { total = 0, warn = 0, err = 0, nil_found = 0, ui = 0, scripts = 0 }
    updateStatsBar()
end)

local function logMsg(msg, level)
    level = level or "info"
    exportStats.total = exportStats.total + 1
    if level == "warn"    then exportStats.warn      = exportStats.warn + 1 end
    if level == "error"   then exportStats.err       = exportStats.err + 1 end
    if level == "nil"     then exportStats.nil_found = exportStats.nil_found + 1 end
    addLogEntry(msg, level)
    updateStatsBar()
end

local function applyFontSizes()
    for _, entry in pairs(logEntries) do
        if entry.timeLabel then entry.timeLabel.TextSize = SETTINGS.timestampFontSize end
        if entry.lvlLabel  then entry.lvlLabel.TextSize  = SETTINGS.logFontSize - 1 end
        if entry.msgLabel  then entry.msgLabel.TextSize  = SETTINGS.logFontSize end
    end
    for _, lbl in ipairs(optLabelRefs) do lbl.TextSize = SETTINGS.labelFontSize end
    for _, lbl in ipairs(optDescRefs)  do lbl.TextSize = SETTINGS.descFontSize end
end

local function makeSliderRow(parent, label, key, minVal, maxVal, yPos)
    mkLabel({
        text = label, color = C.text2, size = 11, font = FONT_MONO,
        sz = UDim2.new(0, 160, 0, 20), pos = UDim2.new(0, 24, 0, yPos),
        parent = parent,
    })

    local valLabel = mkLabel({
        text = tostring(SETTINGS[key]), color = C.text3, size = 10, font = FONT_MONO,
        sz = UDim2.new(0, 30, 0, 20), pos = UDim2.new(0, 190, 0, yPos),
        parent = parent,
    })

    local trackBg = mkFrame({
        bg = C.surface2,
        size = UDim2.new(0, 200, 0, 4),
        pos = UDim2.new(0, 24, 0, yPos + 26),
        parent = parent,
    })
    mkCorner(4, trackBg)

    local trackFill = mkFrame({
        bg = C.accent,
        size = UDim2.new((SETTINGS[key] - minVal) / (maxVal - minVal), 0, 1, 0),
        pos = UDim2.new(0, 0, 0, 0),
        parent = trackBg,
    })
    mkCorner(4, trackFill)

    local thumb = mkFrame({
        bg = C.white,
        size = UDim2.new(0, 10, 0, 10),
        pos = UDim2.new((SETTINGS[key] - minVal) / (maxVal - minVal), -5, 0.5, 0),
        anchor = Vector2.new(0, 0.5),
        parent = trackBg,
    })
    mkCorner(10, thumb)

    local draggingSlider = false

    local function updateSlider(inputPos)
        local rel = (inputPos.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        local newVal = math.round(minVal + rel * (maxVal - minVal))
        SETTINGS[key] = newVal
        valLabel.Text = tostring(newVal)
        trackFill.Size = UDim2.new(rel, 0, 1, 0)
        thumb.Position = UDim2.new(rel, -5, 0.5, 0)
        applyFontSizes()
    end

    trackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
            updateSlider(input.Position)
        end
    end)
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position)
        end
    end)
end

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, 0)
settingsScroll.Position = UDim2.new(0, 0, 0, 0)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 2
settingsScroll.ScrollBarImageColor3 = C.border2
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
settingsScroll.Parent = settingsPanel

mkLabel({
    text = "TYPOGRAPHY",
    color = C.text3, size = 9, font = FONT_UI,
    sz = UDim2.new(1,-24,0,24), pos = UDim2.new(0,24,0,8),
    parent = settingsScroll,
})

local settingsDivider = mkFrame({
    bg = C.border,
    size = UDim2.new(1,-24,0,1),
    pos = UDim2.new(0,12,0,32),
    parent = settingsScroll,
})

makeSliderRow(settingsScroll, "log font size",   "logFontSize",        8, 16, 40)
makeSliderRow(settingsScroll, "label font size",  "labelFontSize",      8, 16, 100)
makeSliderRow(settingsScroll, "desc font size",   "descFontSize",       8, 14, 160)
makeSliderRow(settingsScroll, "timestamp size",   "timestampFontSize",  7, 14, 220)

mkLabel({
    text = "WINDOW",
    color = C.text3, size = 9, font = FONT_UI,
    sz = UDim2.new(1,-24,0,24), pos = UDim2.new(0,24,0,290),
    parent = settingsScroll,
})
mkFrame({ bg = C.border, size = UDim2.new(1,-24,0,1), pos = UDim2.new(0,12,0,314), parent = settingsScroll })

mkLabel({
    text = "drag edges to resize   •   drag title bar to move",
    color = C.text3, size = 10, font = FONT_MONO,
    sz = UDim2.new(1,-24,0,20), pos = UDim2.new(0,24,0,322),
    parent = settingsScroll,
})

mkLabel({
    text = "min  480 × 360   •   max  1100 × 820",
    color = C.text3, size = 10, font = FONT_MONO,
    sz = UDim2.new(1,-24,0,20), pos = UDim2.new(0,24,0,346),
    parent = settingsScroll,
})

local resetBtn = mkButton({
    text = "reset settings",
    bg = C.surface2, color = C.text2, size = 10, font = FONT_MONO,
    sz = UDim2.new(0, 120, 0, 26), pos = UDim2.new(0, 24, 0, 388),
    parent = settingsScroll,
})
mkCorner(5, resetBtn)
mkStroke(1, C.border2, 0, resetBtn)
resetBtn.MouseButton1Click:Connect(function()
    SETTINGS.logFontSize = 10
    SETTINGS.labelFontSize = 11
    SETTINGS.descFontSize = 10
    SETTINGS.timestampFontSize = 9
    screenGui:Destroy()
    warn("[Export] settings reset — re-run script to apply")
end)

local SAVE_SERVICES = {
    { id = "replicatedStorage", service = game:GetService("ReplicatedStorage"), name = "ReplicatedStorage" },
    { id = "replicatedFirst",   service = game:GetService("ReplicatedFirst"),   name = "ReplicatedFirst" },
    { id = "starterGui",        service = game:GetService("StarterGui"),        name = "StarterGui" },
    { id = "starterPack",       service = game:GetService("StarterPack"),       name = "StarterPack" },
    { id = "starterPlayer",     service = game:GetService("StarterPlayer"),     name = "StarterPlayer" },
    { id = "playerGui",         service = localPlayer:WaitForChild("PlayerGui"),      name = "PlayerGui" },
    { id = "backpack",          service = localPlayer:WaitForChild("Backpack"),       name = "Backpack" },
    { id = "playerScripts",     service = localPlayer:WaitForChild("PlayerScripts"), name = "PlayerScripts" },
}

local UI_CLASSES = {
    ScreenGui=true, BillboardGui=true, SurfaceGui=true, Frame=true, TextLabel=true,
    TextButton=true, TextBox=true, ImageLabel=true, ImageButton=true, ScrollingFrame=true,
    CanvasGroup=true, ViewportFrame=true, UICorner=true, UIStroke=true, UIPadding=true,
    UIListLayout=true, UIGridLayout=true, UITableLayout=true, UIPageLayout=true, UIScale=true,
    UIGradient=true, UIAspectRatioConstraint=true, UISizeConstraint=true,
    UITextSizeConstraint=true, UIFlexItem=true, LocalScript=true, ModuleScript=true,
    Folder=true, Configuration=true, StringValue=true, IntValue=true, NumberValue=true,
    BoolValue=true, ObjectValue=true, Color3Value=true, Vector3Value=true,
    CFrameValue=true, RayValue=true, NumberRange=true,
    Sound=true, SoundGroup=true, SoundService=true,
    Animation=true, AnimationController=true, Animator=true,
    RemoteEvent=true, RemoteFunction=true, BindableEvent=true, BindableFunction=true,
    Tool=true, Script=true,
    SelectionBox=true, SelectionSphere=true,
    Decal=true, Texture=true, SpecialMesh=true, BlockMesh=true, CylinderMesh=true,
    PointLight=true, SpotLight=true, SurfaceLight=true,
    Attachment=true, WeldConstraint=true, Motor6D=true,
    ProximityPrompt=true, ClickDetector=true,
    Model=true, Part=true, UnionOperation=true, MeshPart=true,
}

local PROPERTY_MAP = {
    GuiObject = {"Size","Position","AnchorPoint","BackgroundColor3","BackgroundTransparency","BorderSizePixel","BorderColor3","Visible","ZIndex","LayoutOrder","ClipsDescendants","Rotation","AutomaticSize"},
    TextLabel = {"Text","TextColor3","TextSize","Font","TextScaled","TextWrapped","RichText","TextXAlignment","TextYAlignment","TextTransparency","LineHeight","MaxVisibleGraphemes"},
    TextButton = {"Text","TextColor3","TextSize","Font","TextScaled","TextWrapped","RichText","AutoButtonColor"},
    TextBox = {"Text","PlaceholderText","PlaceholderColor3","TextColor3","TextSize","Font","ClearTextOnFocus","MultiLine"},
    ImageLabel = {"Image","ImageColor3","ImageTransparency","ScaleType","SliceCenter","SliceScale","TileSize","ImageRectOffset","ImageRectSize","ResampleMode"},
    ImageButton = {"Image","ImageColor3","ImageTransparency","ScaleType","AutoButtonColor","SliceCenter","SliceScale"},
    ScrollingFrame = {"ScrollBarThickness","ScrollingDirection","CanvasSize","ScrollBarImageColor3","ElasticBehavior","AutomaticCanvasSize"},
    CanvasGroup = {"GroupTransparency","GroupColor3"},
    UICorner = {"CornerRadius"},
    UIStroke = {"Color","Thickness","Transparency","ApplyStrokeMode","LineJoinMode"},
    UIPadding = {"PaddingTop","PaddingBottom","PaddingLeft","PaddingRight"},
    UIListLayout = {"FillDirection","HorizontalAlignment","VerticalAlignment","Padding","SortOrder"},
    UIGridLayout = {"CellSize","CellPadding","FillDirection","SortOrder"},
    UIAspectRatioConstraint = {"AspectRatio","AspectType","DominantAxis"},
    UISizeConstraint = {"MinSize","MaxSize"},
    UITextSizeConstraint = {"MinTextSize","MaxTextSize"},
    UIScale = {"Scale"},
    UIGradient = {"Color","Offset","Rotation","Transparency"},
    ScreenGui = {"ResetOnSpawn","IgnoreGuiInset","DisplayOrder","Enabled","ZIndexBehavior"},
    BillboardGui = {"Size","StudsOffset","Active","AlwaysOnTop","MaxDistance","LightInfluence"},
    SurfaceGui = {"Face","CanvasSize","Active","LightInfluence"},
    LocalScript = {"Enabled"},
    ModuleScript = {},
    ViewportFrame = {"ImageColor3","ImageTransparency"},
    ValueBase = {"Value"},
    Sound = {"SoundId","Volume","Pitch","Looped","PlayOnRemove","RollOffMaxDistance","RollOffMinDistance","TimePosition"},
    Decal = {"Texture","Color3","Transparency","Face"},
    Texture = {"Texture","StudsPerTileU","StudsPerTileV","Face","Transparency"},
    SpecialMesh = {"MeshId","TextureId","MeshType","Scale","Offset"},
    PointLight = {"Brightness","Color","Range","Shadows"},
    SpotLight = {"Brightness","Color","Range","Angle","Shadows"},
    SurfaceLight = {"Brightness","Color","Range","Angle","Shadows"},
    Tool = {"RequiresHandle","CanBeDropped","ToolTip","GripPos","GripUp","GripRight","GripForward"},
    ProximityPrompt = {"ActionText","ObjectText","HoldDuration","MaxActivationDistance","RequiresLineOfSight"},
    ClickDetector = {"MaxActivationDistance"},
    Animation = {"AnimationId"},
    WeldConstraint = {"Enabled"},
    Motor6D = {"C0","C1","MaxVelocity"},
    BasePart = {"Size","CFrame","Anchored","CanCollide","CanTouch","CastShadow","Transparency","Reflectance","Material","Color","Massless","CollisionGroupId"},
    Model = {"PrimaryPart"},
}

local function formatValue(val)
    local t = typeof(val)
    if t=="UDim2" then return string.format("UDim2.new(%s,%s,%s,%s)",val.X.Scale,val.X.Offset,val.Y.Scale,val.Y.Offset)
    elseif t=="UDim" then return string.format("UDim.new(%s,%s)",val.Scale,val.Offset)
    elseif t=="Vector3" then return string.format("Vector3.new(%s,%s,%s)",val.X,val.Y,val.Z)
    elseif t=="Vector2" then return string.format("Vector2.new(%s,%s)",val.X,val.Y)
    elseif t=="Color3" then return string.format("Color3.fromRGB(%d,%d,%d)",val.R*255,val.G*255,val.B*255)
    elseif t=="BrickColor" then return string.format("BrickColor.new(\"%s\")",tostring(val))
    elseif t=="EnumItem" then return tostring(val)
    elseif t=="Rect" then return string.format("Rect.new(%s,%s,%s,%s)",val.Min.X,val.Min.Y,val.Max.X,val.Max.Y)
    elseif t=="ColorSequence" then
        local kps={}
        for _,kp in ipairs(val.Keypoints) do
            table.insert(kps,string.format("ColorSequenceKeypoint.new(%s,Color3.fromRGB(%d,%d,%d))",kp.Time,kp.Value.R*255,kp.Value.G*255,kp.Value.B*255))
        end
        return "ColorSequence.new({"..table.concat(kps,",").."}"
    elseif t=="NumberSequence" then
        local kps={}
        for _,kp in ipairs(val.Keypoints) do
            table.insert(kps,string.format("NumberSequenceKeypoint.new(%s,%s)",kp.Time,kp.Value))
        end
        return "NumberSequence.new({"..table.concat(kps,",").."}"
    elseif t=="boolean" then return tostring(val)
    elseif t=="number" then return tostring(val)
    elseif t=="string" then return string.format("%q",val)
    end
    return tostring(val)
end

local function getProperties(instance)
    local props = {}
    for className, propList in pairs(PROPERTY_MAP) do
        if instance:IsA(className) or instance.ClassName == className then
            for _, prop in ipairs(propList) do
                pcall(function() props[prop] = formatValue(instance[prop]) end)
            end
        end
    end
    return props
end

local function getSource(instance)
    if not (instance:IsA("LocalScript") or instance:IsA("ModuleScript")) then return nil end
    local ok, src = pcall(function()
        if decompile then return decompile(instance) end
        return nil
    end)
    if ok and src then return src end
    return nil
end

local function isRelevant(instance)
    if UI_CLASSES[instance.ClassName] then return true end
    if instance:IsA("GuiObject") or instance:IsA("UIBase") or instance:IsA("LayerCollector") then return true end
    for _, child in ipairs(instance:GetDescendants()) do
        if UI_CLASSES[child.ClassName] or child:IsA("GuiObject") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
            return true
        end
    end
    return false
end

local gameName = "Game"
pcall(function()
    gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    gameName = gameName:gsub("[^%w_ ]",""):gsub(" ","_")
end)

local ROOT = "Exporter/"..gameName.."_"..SESSION_UUID

local function ensureFolder(path)
    if not isfolder(path) then makefolder(path) end
end

local function safeName(str)
    return str:gsub("[^%w_%- ]",""):gsub(" ","_")
end

local vcounter = 0
local function nextVar()
    vcounter = vcounter + 1
    return "v"..vcounter
end

local function serializeUI(instance, parentVar, depth)
    if not isRelevant(instance) then return "" end
    if instance:IsA("LocalScript") or instance:IsA("ModuleScript") then return "" end
    depth = depth or 0
    local indent = string.rep("    ", depth)
    local lines = {}
    local var = nextVar()
    table.insert(lines, indent..string.format("local %s = Instance.new(\"%s\")", var, instance.ClassName))
    table.insert(lines, indent..string.format("%s.Name = %q", var, instance.Name))
    local props = getProperties(instance)
    for prop, val in pairs(props) do
        table.insert(lines, indent..string.format("%s.%s = %s", var, prop, val))
    end
    if parentVar then
        table.insert(lines, indent..string.format("%s.Parent = %s", var, parentVar))
    end
    table.insert(lines, "")
    for _, child in ipairs(instance:GetChildren()) do
        local out = serializeUI(child, var, depth+1)
        if out ~= "" then table.insert(lines, out) end
    end
    return table.concat(lines, "\n")
end

local function saveScriptsRecursive(instance, folderPath)
    if instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
        local src = getSource(instance)
        if src then
            local fileName = safeName(instance.Name)..".lua"
            writefile(folderPath.."/"..fileName, instance.ClassName..": "..instance:GetFullName().."\n\n"..src)
            logMsg("script: "..instance:GetFullName(), "info")
            exportStats.scripts = exportStats.scripts + 1
        end
    end
    for _, child in ipairs(instance:GetChildren()) do
        if isRelevant(child) then
            if child:IsA("LocalScript") or child:IsA("ModuleScript") then
                saveScriptsRecursive(child, folderPath)
            elseif #child:GetChildren() > 0 then
                local subFolder = folderPath.."/"..safeName(child.Name)
                local hasScripts = false
                for _, desc in ipairs(child:GetDescendants()) do
                    if desc:IsA("LocalScript") or desc:IsA("ModuleScript") then hasScripts = true break end
                end
                if hasScripts then
                    ensureFolder(subFolder)
                    saveScriptsRecursive(child, subFolder)
                end
            end
        end
    end
end

local function serializeValue(val)
    local t = typeof(val)
    if t=="string" then return string.format("%q",val)
    elseif t=="number" then return tostring(val)
    elseif t=="boolean" then return tostring(val)
    elseif t=="Vector3" then return string.format("Vector3.new(%s,%s,%s)",val.X,val.Y,val.Z)
    elseif t=="Color3" then return string.format("Color3.fromRGB(%d,%d,%d)",val.R*255,val.G*255,val.B*255)
    elseif t=="BrickColor" then return string.format("BrickColor.new(\"%s\")",tostring(val))
    elseif t=="EnumItem" then return tostring(val)
    elseif t=="CFrame" then local c={val:GetComponents()} return "CFrame.new("..table.concat(c,", ")..")"
    elseif t=="Instance" then return val:GetFullName()
    elseif t=="nil" then return "nil"
    end
    return tostring(val)
end

local function dumpInstance(instance, depth)
    depth = depth or 0
    local indent = string.rep("  ", depth)
    local lines = {}
    local attrs = {}
    pcall(function() attrs = instance:GetAttributes() end)
    local hasAttrs = false
    for _ in pairs(attrs) do hasAttrs = true break end
    local isValue = instance:IsA("ValueBase")
    local valueStr, hasValue = "", false
    if isValue then pcall(function() valueStr = serializeValue(instance.Value) hasValue = true end) end
    local header = indent.."["..instance.ClassName.."] "..instance.Name
    if hasValue then header = header.." = "..valueStr end
    table.insert(lines, header)
    if hasAttrs then
        for name, val in pairs(attrs) do
            table.insert(lines, indent.."  @"..name.." = "..serializeValue(val))
        end
    end
    for _, child in ipairs(instance:GetChildren()) do
        local out = dumpInstance(child, depth+1)
        if out ~= "" then table.insert(lines, out) end
    end
    return table.concat(lines, "\n")
end

local function savePlayerData()
    ensureFolder(ROOT.."/Data/PlayerData")
    local player = localPlayer
    local lines = {}
    table.insert(lines,"Player Data Dump")
    table.insert(lines,"Player: "..player.Name.." ("..player.UserId..")")
    table.insert(lines,os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(lines,"")
    table.insert(lines,"== PLAYER INFO ==")
    table.insert(lines,"Name: "..player.Name)
    table.insert(lines,"DisplayName: "..player.DisplayName)
    table.insert(lines,"UserId: "..player.UserId)
    pcall(function() table.insert(lines,"AccountAge: "..player.AccountAge.." days") end)
    pcall(function() table.insert(lines,"MembershipType: "..tostring(player.MembershipType)) end)
    pcall(function() table.insert(lines,"Team: "..tostring(player.Team)) end)
    table.insert(lines,"")
    table.insert(lines,"== LEADERSTATS ==")
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            pcall(function()
                table.insert(lines,"  "..stat.Name.." = "..serializeValue(stat.Value).."  ["..stat.ClassName.."]")
            end)
        end
    else table.insert(lines,"  (no leaderstats)") end
    table.insert(lines,"")
    table.insert(lines,"== PLAYER ATTRIBUTES ==")
    pcall(function()
        local attrs = player:GetAttributes()
        local hasAny = false
        for name, val in pairs(attrs) do
            table.insert(lines,"  @"..name.." = "..serializeValue(val)); hasAny = true
        end
        if not hasAny then table.insert(lines,"  (none)") end
    end)
    table.insert(lines,"")
    local skipChildren = {PlayerGui=true,Backpack=true,StarterGear=true,PlayerScripts=true,leaderstats=true}
    table.insert(lines,"== PLAYER CHILDREN ==")
    for _, child in ipairs(player:GetChildren()) do
        if not skipChildren[child.Name] then table.insert(lines, dumpInstance(child,1)) end
    end
    table.insert(lines,"")
    local character = player.Character
    if character then
        table.insert(lines,"-- CHARACTER ATTRIBUTES --")
        pcall(function()
            local attrs = character:GetAttributes()
            local hasAny = false
            for name, val in pairs(attrs) do
                table.insert(lines,"  @"..name.." = "..serializeValue(val)); hasAny = true
            end
            if not hasAny then table.insert(lines,"  (none)") end
        end)
        table.insert(lines,"")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            table.insert(lines,"-- HUMANOID --")
            pcall(function() table.insert(lines,"  Health: "..humanoid.Health.." / "..humanoid.MaxHealth) end)
            pcall(function() table.insert(lines,"  WalkSpeed: "..humanoid.WalkSpeed) end)
            pcall(function() table.insert(lines,"  JumpPower: "..humanoid.JumpPower) end)
            pcall(function() table.insert(lines,"  JumpHeight: "..humanoid.JumpHeight) end)
        end
    end
    table.insert(lines,"")
    table.insert(lines,"-- BACKPACK --")
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolLine = "  [Tool] "..tool.Name
                pcall(function() toolLine = toolLine.."  ToolTip: "..tool.ToolTip end)
                table.insert(lines, toolLine)
            end
        end
    end
    writefile(ROOT.."/Data/PlayerData/PlayerData.txt", table.concat(lines,"\n"))
    local jsonData = {}
    pcall(function()
        jsonData.player = {
            Name=player.Name, DisplayName=player.DisplayName,
            UserId=player.UserId, AccountAge=player.AccountAge,
            Attributes=player:GetAttributes(),
        }
    end)
    if leaderstats then
        jsonData.leaderstats = {}
        for _, stat in ipairs(leaderstats:GetChildren()) do
            pcall(function()
                jsonData.leaderstats[stat.Name] = { ClassName=stat.ClassName, Value=stat.Value }
            end)
        end
    end
    pcall(function()
        writefile(ROOT.."/Data/PlayerData/PlayerData.json", HttpService:JSONEncode(jsonData))
    end)
    logMsg("PlayerData saved (txt + json)", "success")
end

local remoteLines = {}
local remoteTotalFound = 0

local function scanRemotes(service, serviceName)
    local found = 0
    for _, desc in ipairs(service:GetDescendants()) do
        if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
            found = found + 1
            remoteTotalFound = remoteTotalFound + 1
            local path = desc:GetFullName():gsub("%.", "/")
            local line = string.format("%-18s %s", "["..desc.ClassName.."]", path)
            table.insert(remoteLines, line)
            logMsg("remote ["..desc.ClassName.."] "..path, "info")
        end
    end
    if found > 0 then logMsg(serviceName..": "..found.." remote(s)", "success")
    else logMsg(serviceName..": no remotes", "warn") end
end

local function flushRemotesFile()
    if remoteTotalFound == 0 then return end
    ensureFolder(ROOT.."/Misc/Remotes")
    local output = {
        "Remotes Dump",
        "Game: "..gameName,
        "Date: "..os.date("%Y-%m-%d %H:%M:%S"),
        "Total: "..remoteTotalFound,
        "",
        string.rep("-", 60),
        "",
    }
    for _, line in ipairs(remoteLines) do
        table.insert(output, line)
    end
    writefile(ROOT.."/Misc/Remotes/remotes.txt", table.concat(output, "\n"))
    logMsg("remotes.txt written — "..remoteTotalFound.." total", "success")
    remoteLines = {}
    remoteTotalFound = 0
end

local function saveWorkspace()
    ensureFolder(ROOT.."/Misc/Workspace")
    local ws = game:GetService("Workspace")
    local parts, folders = 0, 0
    local lines = {}
    for _, child in ipairs(ws:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            folders = folders + 1
            table.insert(lines, "["..child.ClassName.."] "..child.Name)
        end
    end
    for _, desc in ipairs(ws:GetDescendants()) do
        if desc:IsA("BasePart") then parts = parts + 1 end
    end
    table.insert(lines, 1, "Workspace Dump — "..os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(lines, 2, "BaseParts: "..parts.."  Folders/Models: "..folders)
    table.insert(lines, 3, "")
    writefile(ROOT.."/Misc/Workspace/workspace_map.txt", table.concat(lines,"\n"))
    logMsg("Workspace: "..parts.." parts, "..folders.." folders saved", "success")
end

local SKIP_NIL_CLASSES = {
    RemoteEvent = true, RemoteFunction = true,
    BindableEvent = true, BindableFunction = true,
}

local function dumpNilChildren(instance, depth)
    depth = depth or 0
    local indent = string.rep("  ", depth)
    local lines = {}
    for _, child in ipairs(instance:GetChildren()) do
        local childLine = indent.."  ["..child.ClassName.."] "..child.Name
        pcall(function()
            if child:IsA("ValueBase") then
                childLine = childLine.." = "..tostring(child.Value)
            end
        end)
        table.insert(lines, childLine)
        local grandChildren = dumpNilChildren(child, depth + 1)
        if grandChildren ~= "" then
            table.insert(lines, grandChildren)
        end
    end
    return table.concat(lines, "\n")
end

local function scanNilInstances()
    ensureFolder(ROOT.."/Misc/NilInstances")
    if not getnilinstances then
        logMsg("getnilinstances not available in this executor", "error")
        return
    end
    local found = 0
    local filterSet = {}
    for _, cls in ipairs(NIL_FILTER) do
        if not SKIP_NIL_CLASSES[cls] then
            filterSet[cls] = true
        end
    end
    local lines = {}
    table.insert(lines, "Nil Instances Dump — "..os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(lines, "Filters: "..table.concat(NIL_FILTER,", "))
    table.insert(lines, "(RemoteEvent, RemoteFunction, BindableEvent, BindableFunction excluded)")
    table.insert(lines, "")
    for _, v in next, getnilinstances() do
        if filterSet[v.ClassName] then
            found = found + 1
            local parentName = v.Parent and v.Parent.Name or "nil"
            local header = "["..v.ClassName.."] "..v.Name.." — parent: "..parentName
            table.insert(lines, header)
            logMsg("[!] nil: "..v.ClassName.." '"..v.Name.."' parent="..parentName, "nil")

            local childCount = #v:GetChildren()
            if childCount > 0 then
                table.insert(lines, "  children ("..childCount.."):")
                local childDump = dumpNilChildren(v, 1)
                if childDump ~= "" then
                    table.insert(lines, childDump)
                end
            end

            if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
                local src = getSource(v)
                if src then
                    local folder = ROOT.."/Misc/NilInstances/Scripts"
                    ensureFolder(folder)
                    local fileName = safeName(v.Name).."_nil.lua"
local fileContent = v.ClassName .. ": " .. v.Name
    .. "\nparent: " .. parentName
    .. "\n\n" .. src
                    writefile(folder.."/"..fileName, fileContent)
                    logMsg("decompiled: "..v.Name.." → NilInstances/Scripts/", "nil")
                end
            end

            table.insert(lines, "")
        end
    end
    if found == 0 then
        logMsg("nil scan: nothing matched filters", "warn")
    else
        logMsg("nil scan done — "..found.." instance(s)", "success")
    end
    table.insert(lines, string.rep("-", 50))
    table.insert(lines, "Total found: "..found)
    writefile(ROOT.."/Misc/NilInstances/nil_instances.txt", table.concat(lines,"\n"))
end

--------------------------------------------------------------

-- ## fix for nil instances with children

local function saveChildsFromNilScripts()
    local basefolder = ROOT.."/Misc/NilInstances/Childs"
    ensureFolder(basefolder)
    if not getnilinstances then
        logMsg("getnilinstances not available in this executor", "error")
        return
    end

    local function process(v, parentFolder)
        local currentfolder = parentFolder.."/"..safeName(v.Name)
        ensureFolder(currentfolder)
        if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
            local src = getSource(v)
            if src then
                local filepath = currentfolder.."/"..safeName(v.Name)..".lua"
                writefile(filepath, src)
            end
        end
        for _, child in ipairs(v:GetChildren()) do
            process(child, currentfolder)
        end
    end

    for _, v in next, getnilinstances() do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
            process(v, basefolder)
        end
    end
end

-- 👌👌

--------------------------------------------------------------


local function saveLighting()
    ensureFolder(ROOT.."/Misc/Lighting")
    local lighting = game:GetService("Lighting")
    local lines = {
        "Lighting Dump",
        "Date: "..os.date("%Y-%m-%d %H:%M:%S"),
        "",
        "-- PROPERTIES --",
    }
    local lightProps = {
        "Ambient","OutdoorAmbient","Brightness","ClockTime","GeographicLatitude",
        "FogColor","FogEnd","FogStart","GlobalShadows","Technology","EnvironmentDiffuseScale",
        "EnvironmentSpecularScale","ExposureCompensation",
    }
    for _, prop in ipairs(lightProps) do
        pcall(function()
            table.insert(lines, "  "..prop..": "..tostring(lighting[prop]))
        end)
    end
    table.insert(lines, "")
    table.insert(lines, "-- CHILDREN --")
    for _, child in ipairs(lighting:GetChildren()) do
        table.insert(lines, "  ["..child.ClassName.."] "..child.Name)
        pcall(function()
            local attrs = child:GetAttributes()
            for k, v in pairs(attrs) do
                table.insert(lines, "    @"..k.." = "..tostring(v))
            end
        end)
    end
    table.insert(lines, "")
    table.insert(lines, "-- SOUNDS --")
    for _, desc in ipairs(lighting:GetDescendants()) do
        if desc:IsA("Sound") then
            table.insert(lines, "  [Sound] "..desc.Name.." id="..tostring(desc.SoundId).." vol="..tostring(desc.Volume))
        end
    end
    writefile(ROOT.."/Misc/Lighting/lighting.txt", table.concat(lines, "\n"))
    logMsg("Lighting saved", "success")
end

local function saveSounds()
    ensureFolder(ROOT.."/Misc/Sounds")
    local lines = {
        "Sound Dump",
        "Date: "..os.date("%Y-%m-%d %H:%M:%S"),
        "",
        string.rep("-", 50),
        "",
    }
    local count = 0
    local services = {
        game:GetService("ReplicatedStorage"),
        game:GetService("StarterGui"),
        game:GetService("Workspace"),
        localPlayer:FindFirstChild("PlayerGui"),
    }
    for _, svc in ipairs(services) do
        if svc then
            for _, desc in ipairs(svc:GetDescendants()) do
                if desc:IsA("Sound") then
                    count = count + 1
                    local path = desc:GetFullName():gsub("%.", "/")
                    table.insert(lines, string.format("%-30s  id=%-40s  vol=%s  loop=%s",
                        desc.Name, tostring(desc.SoundId), tostring(desc.Volume), tostring(desc.Looped)))
                    table.insert(lines, "  path: "..path)
                    table.insert(lines, "")
                end
            end
        end
    end
    table.insert(lines, string.rep("-", 50))
    table.insert(lines, "Total sounds: "..count)
    writefile(ROOT.."/Misc/Sounds/sounds.txt", table.concat(lines, "\n"))
    logMsg("Sounds: "..count.." saved to Sounds/sounds.txt", "success")
end

local function saveAnimations()
    ensureFolder(ROOT.."/Misc/Animations")
    local lines = {
        "Animation Dump",
        "Date: "..os.date("%Y-%m-%d %H:%M:%S"),
        "",
        string.rep("-", 50),
        "",
    }
    local count = 0
    local services = {
        game:GetService("ReplicatedStorage"),
        game:GetService("StarterPlayer"),
        game:GetService("Workspace"),
    }
    for _, svc in ipairs(services) do
        if svc then
            for _, desc in ipairs(svc:GetDescendants()) do
                if desc:IsA("Animation") then
                    count = count + 1
                    local path = desc:GetFullName():gsub("%.", "/")
                    table.insert(lines, string.format("[Animation] %-30s  id=%s", desc.Name, tostring(desc.AnimationId)))
                    table.insert(lines, "  path: "..path)
                    table.insert(lines, "")
                end
            end
        end
    end
    local character = localPlayer.Character
    if character then
        local animator = character:FindFirstChildOfClass("Humanoid") and
                         character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
        if animator then
            table.insert(lines, "-- PLAYING ANIMATIONS --")
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                table.insert(lines, "  "..track.Name.." speed="..tostring(track.Speed).." weight="..tostring(track.WeightCurrent))
            end
        end
    end
    table.insert(lines, string.rep("-", 50))
    table.insert(lines, "Total: "..count)
    writefile(ROOT.."/Misc/Animations/animations.txt", table.concat(lines, "\n"))
    logMsg("Animations: "..count.." saved", "success")
end

local function saveBindables()
    ensureFolder(ROOT.."/Misc/Bindables")
    local lines = {
        "Bindables Dump",
        "Date: "..os.date("%Y-%m-%d %H:%M:%S"),
        "",
        string.rep("-", 50),
        "",
    }
    local count = 0
    local services = {
        game:GetService("ReplicatedStorage"),
        game:GetService("ReplicatedFirst"),
        game:GetService("StarterGui"),
        game:GetService("StarterPlayer"),
    }
    for _, svc in ipairs(services) do
        if svc then
            for _, desc in ipairs(svc:GetDescendants()) do
                if desc:IsA("BindableEvent") or desc:IsA("BindableFunction") then
                    count = count + 1
                    local path = desc:GetFullName():gsub("%.", "/")
                    table.insert(lines, string.format("%-18s %s", "["..desc.ClassName.."]", path))
                end
            end
        end
    end
    table.insert(lines, "")
    table.insert(lines, string.rep("-", 50))
    table.insert(lines, "Total: "..count)
    writefile(ROOT.."/Misc/Bindables/bindables.txt", table.concat(lines, "\n"))
    logMsg("Bindables: "..count.." saved", "success")
end



local isRunning = false

runBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    if not writefile or not makefolder or not isfolder then
        logMsg("executor missing writefile/makefolder/isfolder", "error")
        return
    end
    isRunning = true
    runBtn.Text = "running..."
    runBtn.BackgroundColor3 = C.surface2
    runBtn.TextColor3 = C.text2
    statusLabel.Text = "running"
    exportStats = { total = 0, warn = 0, err = 0, nil_found = 0, ui = 0, scripts = 0 }
    setProgress(5)

    task.spawn(function()
        logMsg("export started — game: "..gameName.." ["..SESSION_UUID.."]", "info")
        ensureFolder("Exporter")
        ensureFolder(ROOT)
        ensureFolder(ROOT.."/UI")
        ensureFolder(ROOT.."/Scripts")
        ensureFolder(ROOT.."/Data")
        ensureFolder(ROOT.."/Misc")

        local selected = {}
        for _, entry in ipairs(SAVE_SERVICES) do
            if CONFIG[entry.id] then table.insert(selected, entry) end
        end

        local step = #selected > 0 and (80 / #selected) or 0
        local prog = 5

        for _, entry in ipairs(SAVE_SERVICES) do
            if CONFIG[entry.id] then
                prog = prog + step
                setProgress(math.floor(prog))
                task.wait(0.05)
                pcall(function()
                    local service = entry.service
                    local serviceName = entry.name
                    local hasUI, hasScripts = false, false
                    for _, child in ipairs(service:GetDescendants()) do
                        if child:IsA("GuiObject") or child:IsA("LayerCollector") then hasUI = true end
                        if child:IsA("LocalScript") or child:IsA("ModuleScript") then hasScripts = true end
                        if hasUI and hasScripts then break end
                    end
                    if hasUI then
                        ensureFolder(ROOT.."/UI/"..serviceName)
                        for _, child in ipairs(service:GetChildren()) do
                            if isRelevant(child) and not (child:IsA("LocalScript") or child:IsA("ModuleScript")) then
                                vcounter = 0
                                local result = serializeUI(child, nil, 0)
                                if result ~= "" then
                                    local fileName = safeName(child.Name)..".lua"
                                    writefile(ROOT.."/UI/"..serviceName.."/"..fileName, "UI: "..child:GetFullName().."\n\n"..result)
                                    exportStats.ui = exportStats.ui + 1
                                    logMsg("UI saved: "..child:GetFullName(), "success")
                                end
                            end
                        end
                    end
                    if hasScripts then
                        ensureFolder(ROOT.."/Scripts/"..serviceName)
                        saveScriptsRecursive(service, ROOT.."/Scripts/"..serviceName)
                    end
                    if CONFIG.remotes then scanRemotes(service, serviceName) end
                end)
            end
        end

        if CONFIG.remotes then pcall(flushRemotesFile) end
        if CONFIG.workspace then pcall(saveWorkspace) end
        if CONFIG.playerData then pcall(savePlayerData) end
        if CONFIG.lighting then pcall(saveLighting) end
        if CONFIG.sounds then pcall(saveSounds) end
        if CONFIG.animations then pcall(saveAnimations) end
        if CONFIG.bindables then pcall(saveBindables) end
        if CONFIG.nilInstances then
            logMsg("nil scan started — filters: ["..table.concat(NIL_FILTER,", ").."]", "nil")
            task.wait(0.05)
            pcall(scanNilInstances)
        end

        local summary = {
            "Exporter — Session Summary",
            "-------------------------->",
            "Game:     "..gameName,
            "Session:  "..SESSION_UUID,
            "Date:     "..os.date("%Y-%m-%d %H:%M:%S"),
            "",
            "Results:",
            "  UI files:      "..exportStats.ui,
            "  Scripts:       "..exportStats.scripts,
            "  Nil instances: "..exportStats.nil_found,
            "  Warnings:      "..exportStats.warn,
            "  Errors:        "..exportStats.err,
            "",
            "Folder Structure:",
            "  Exporter/",
            "  └─ "..gameName.."_"..SESSION_UUID.."/",
            "     ├─ UI/",
            "     │  └─ <service>/  *.lua",
            "     ├─ Scripts/",
            "     │  └─ <service>/  *.lua",
            "     ├─ Data/",
            "     │  └─ PlayerData/  PlayerData.txt  PlayerData.json",
            "     ├─ Misc/",
            "     │  ├─ Remotes/     remotes.txt",
            "     │  ├─ NilInstances/nil_instances.txt",
            "     │  │  └─ Scripts/  *_nil.lua",
            "     │  ├─ Workspace/   workspace_map.txt",
            "     │  ├─ Lighting/    lighting.txt",
            "     │  ├─ Sounds/      sounds.txt",
            "     │  ├─ Animations/  animations.txt",
            "     │  └─ Bindables/   bindables.txt",
            "     └─ README.txt",
        }
        writefile(ROOT.."/README.txt", table.concat(summary,"\n"))

        setProgress(100)
        task.wait(0.3)
        logMsg("export complete — >"..ROOT.."/", "success")
        statusLabel.Text = "done"
        runBtn.Text = "run export"
        runBtn.BackgroundColor3 = C.btnBg
        runBtn.TextColor3 = C.btnText
        isRunning = false
        task.wait(3)
        setProgress(0)
        statusLabel.Text = "idle"
    end)
end)

--[[
    ObsidianModern UI Library
    ------------------------------------------------------
    Obsidian/Kavo tarzı LeftGroupBox / RightGroupBox mantığını
    korur ama daha modern, hafif kıvrımlı (rounded) ve estetik
    bir görünüm sunar (koyu tema + accent renk + UICorner + UIStroke).

    Desteklenen elemanlar:
        GroupBox:AddToggle(text, default, callback)
        GroupBox:AddKeypicker(text, defaultKey, callback)   -- Keybind seçici
        GroupBox:AddButton(text, callback)
        GroupBox:AddLabel(text)
        GroupBox:AddSlider(text, min, max, default, callback)
        GroupBox:AddDropdown(text, options, default, callback)

    Kullanım:
        local Library = loadstring(readfile("ObsidianModernLib.lua"))()
        -- veya require(...) ile modül olarak

    NOT: Bu dosya sadece bir GUI/arayüz çatısıdır. İçerisinde herhangi bir
    oyun hilesi / exploit mantığı bulunmaz; sadece pencere, toggle, keybind
    gibi arayüz elemanlarını oluşturur. Callback'lerin içine kendi
    (meşru) betik mantığınızı siz yazarsınız.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

--============================================================
-- TEMA (Renkler / Boyutlar)
--============================================================
local Theme = {
    Background   = Color3.fromRGB(24, 24, 28),
    Header       = Color3.fromRGB(30, 30, 36),
    GroupBox     = Color3.fromRGB(32, 32, 38),
    GroupBoxLine = Color3.fromRGB(46, 46, 54),
    Accent       = Color3.fromRGB(114, 137, 255),   -- modern mavi/mor accent
    AccentDim    = Color3.fromRGB(80, 96, 190),
    Text         = Color3.fromRGB(235, 235, 240),
    SubText      = Color3.fromRGB(150, 150, 160),
    Stroke       = Color3.fromRGB(50, 50, 58),
    Corner       = UDim.new(0, 10),   -- hafif kıvrım
    CornerSmall  = UDim.new(0, 6),
}

local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function create(class, props, children)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do
        inst[prop] = value
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = radius or Theme.Corner, Parent = parent})
end

local function stroke(parent, color, thickness)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = 0.2,
        Parent = parent,
    })
end

--============================================================
-- LIBRARY
--============================================================
local Library = {}
Library.__index = Library
Library.Flags = {}
Library.Toggled = true

function Library.new(title, subtitle)
    local self = setmetatable({}, Library)

    -- Eski GUI varsa temizle
    local old = PlayerGui:FindFirstChild("ObsidianModern_UI")
    if old then old:Destroy() end

    self.ScreenGui = create("ScreenGui", {
        Name = "ObsidianModern_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui,
    })

    -- Ana pencere
    self.Main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 560, 0, 380),
        Position = UDim2.new(0.5, -280, 0.5, -190),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = self.ScreenGui,
    })
    corner(self.Main, Theme.Corner)
    stroke(self.Main, Theme.Stroke, 1)

    -- Hafif gölge efekti (arka planda büyük, saydam bir çerçeve)
    local shadow = create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 0,
        Parent = self.Main,
    })

    -- Header
    self.Header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Parent = self.Main,
    })
    corner(self.Header, Theme.Corner)

    -- Header'ın alt köşelerini kare yapmak için maskeleme
    create("Frame", {
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        Parent = self.Header,
    })

    local accentBar = create("Frame", {
        Size = UDim2.new(0, 4, 0, 20),
        Position = UDim2.new(0, 12, 0.5, -10),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = self.Header,
    })
    corner(accentBar, UDim.new(1, 0))

    create("TextLabel", {
        Text = title or "Obsidian Modern",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 300, 0, 20),
        Position = UDim2.new(0, 26, 0, 6),
        Parent = self.Header,
    })

    create("TextLabel", {
        Text = subtitle or "modern ui",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 300, 0, 16),
        Position = UDim2.new(0, 26, 0, 24),
        Parent = self.Header,
    })

    -- Kapat butonu
    local closeBtn = create("TextButton", {
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -38, 0, 8),
        Parent = self.Header,
    })
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui.Enabled = false
    end)
    closeBtn.MouseEnter:Connect(function() tween(closeBtn, {TextColor3 = Theme.Accent}) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, {TextColor3 = Theme.SubText}) end)

    -- Sürükleme
    do
        local dragging, dragStart, startPos
        self.Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = self.Main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Sol / Sağ konteyner (LeftGroupBox / RightGroupBox mantığı)
    self.LeftContainer = create("ScrollingFrame", {
        Name = "LeftContainer",
        Size = UDim2.new(0.5, -18, 1, -58),
        Position = UDim2.new(0, 12, 0, 54),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Main,
    })
    create("UIListLayout", {Padding = UDim.new(0, 10), Parent = self.LeftContainer})

    self.RightContainer = create("ScrollingFrame", {
        Name = "RightContainer",
        Size = UDim2.new(0.5, -18, 1, -58),
        Position = UDim2.new(0.5, 6, 0, 54),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Main,
    })
    create("UIListLayout", {Padding = UDim.new(0, 10), Parent = self.RightContainer})

    -- Toggle tuşu (UI'yi göster/gizle)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end)

    return self
end

--============================================================
-- GROUPBOX (Sol/Sağ kutu)
--============================================================
local GroupBox = {}
GroupBox.__index = GroupBox

local function makeGroupBox(parentContainer, name)
    local box = setmetatable({}, GroupBox)

    box.Frame = create("Frame", {
        Name = name .. "GroupBox",
        Size = UDim2.new(1, 0, 0, 40), -- AutomaticSize ile büyüyecek
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.GroupBox,
        BorderSizePixel = 0,
        Parent = parentContainer,
    })
    corner(box.Frame, Theme.Corner)
    stroke(box.Frame, Theme.GroupBoxLine, 1)

    create("TextLabel", {
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 10),
        Parent = box.Frame,
    })

    box.Content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, 36),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = box.Frame,
    })
    create("UIListLayout", {Padding = UDim.new(0, 8), Parent = box.Content})
    create("UIPadding", {PaddingBottom = UDim.new(0, 12), Parent = box.Content})

    return box
end

function Library:LeftGroupBox(name)
    return makeGroupBox(self.LeftContainer, name or "Group")
end

function Library:RightGroupBox(name)
    return makeGroupBox(self.RightContainer, name or "Group")
end

--============================================================
-- ELEMANLAR
--============================================================

-- Label
function GroupBox:AddLabel(text)
    local lbl = create("TextLabel", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = self.Content,
    })
    return lbl
end

-- Button
function GroupBox:AddButton(text, callback)
    callback = callback or function() end

    local btn = create("TextButton", {
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        AutoButtonColor = false,
        BackgroundColor3 = Theme.AccentDim,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = self.Content,
    })
    corner(btn, Theme.CornerSmall)

    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Theme.Accent}) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Theme.AccentDim}) end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, {BackgroundColor3 = Theme.Accent}, 0.08)
        task.spawn(callback)
    end)

    return btn
end

-- Toggle
function GroupBox:AddToggle(text, default, callback)
    default = default or false
    callback = callback or function() end

    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Parent = self.Content,
    })

    create("TextLabel", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 1, 0),
        Parent = holder,
    })

    local switchBg = create("Frame", {
        Size = UDim2.new(0, 38, 0, 20),
        Position = UDim2.new(1, -38, 0.5, -10),
        BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(52, 52, 60),
        Parent = holder,
    })
    corner(switchBg, UDim.new(1, 0))

    local knob = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = switchBg,
    })
    corner(knob, UDim.new(1, 0))

    local state = default
    local btn = create("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = holder,
    })

    local function setState(v, fire)
        state = v
        tween(switchBg, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(52, 52, 60)})
        tween(knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
        if fire then task.spawn(callback, state) end
    end

    btn.MouseButton1Click:Connect(function()
        setState(not state, true)
    end)

    return {
        Set = function(_, v) setState(v, true) end,
        Get = function() return state end,
    }
end

-- Keypicker (Keybind seçici)
function GroupBox:AddKeypicker(text, defaultKey, callback)
    defaultKey = defaultKey or Enum.KeyCode.RightShift
    callback = callback or function() end

    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Parent = self.Content,
    })

    create("TextLabel", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -74, 1, 0),
        Parent = holder,
    })

    local keyBtn = create("TextButton", {
        Text = defaultKey.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Theme.Text,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(44, 44, 52),
        Size = UDim2.new(0, 70, 0, 22),
        Position = UDim2.new(1, -70, 0.5, -11),
        Parent = holder,
    })
    corner(keyBtn, Theme.CornerSmall)
    stroke(keyBtn, Theme.GroupBoxLine, 1)

    local currentKey = defaultKey
    local listening = false

    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyBtn.Text = "..."
        tween(keyBtn, {BackgroundColor3 = Theme.AccentDim})

        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keyBtn.Text = currentKey.Name
                listening = false
                tween(keyBtn, {BackgroundColor3 = Color3.fromRGB(44, 44, 52)})
                conn:Disconnect()
            end
        end)
    end)

    -- Seçilen tuşa basıldığında callback tetikle
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or listening then return end
        if input.KeyCode == currentKey then
            task.spawn(callback, currentKey)
        end
    end)

    return {
        Set = function(_, keyCode)
            currentKey = keyCode
            keyBtn.Text = keyCode.Name
        end,
        Get = function() return currentKey end,
    }
end

-- Slider
function GroupBox:AddSlider(text, min, max, default, callback)
    min, max = min or 0, max or 100
    default = math.clamp(default or min, min, max)
    callback = callback or function() end

    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
        Parent = self.Content,
    })

    local label = create("TextLabel", {
        Text = text .. ": " .. tostring(default),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Parent = holder,
    })

    local track = create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = Color3.fromRGB(48, 48, 56),
        Parent = holder,
    })
    corner(track, UDim.new(1, 0))

    local fill = create("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        Parent = track,
    })
    corner(fill, UDim.new(1, 0))

    local dragging = false
    local value = default

    local function updateFromX(xPos)
        local rel = math.clamp((xPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = math.floor(min + rel * (max - min))
        fill.Size = UDim2.new(rel, 0, 1, 0)
        label.Text = text .. ": " .. tostring(value)
        task.spawn(callback, value)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromX(input.Position.X)
        end
    end)

    return {
        Set = function(_, v)
            v = math.clamp(v, min, max)
            local rel = (v - min) / (max - min)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            label.Text = text .. ": " .. tostring(v)
            value = v
        end,
        Get = function() return value end,
    }
end

-- Dropdown
function GroupBox:AddDropdown(text, options, default, callback)
    options = options or {}
    callback = callback or function() end

    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent = self.Content,
    })

    create("TextLabel", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Parent = holder,
    })

    local box = create("TextButton", {
        Text = "  " .. tostring(default or options[1] or "Select"),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(44, 44, 52),
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 20),
        ZIndex = 5,
        Parent = holder,
    })
    corner(box, Theme.CornerSmall)
    stroke(box, Theme.GroupBoxLine, 1)

    local listFrame = create("Frame", {
        Visible = false,
        Size = UDim2.new(1, 0, 0, #options * 24),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = Color3.fromRGB(38, 38, 46),
        ZIndex = 10,
        Parent = box,
    })
    corner(listFrame, Theme.CornerSmall)
    stroke(listFrame, Theme.GroupBoxLine, 1)
    create("UIListLayout", {Parent = listFrame})

    for _, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Text = "  " .. tostring(opt),
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24),
            ZIndex = 11,
            Parent = listFrame,
        })
        optBtn.MouseEnter:Connect(function() tween(optBtn, {BackgroundColor3 = Theme.AccentDim}, 0.1); optBtn.BackgroundTransparency = 0 end)
        optBtn.MouseLeave:Connect(function() optBtn.BackgroundTransparency = 1 end)
        optBtn.MouseButton1Click:Connect(function()
            box.Text = "  " .. tostring(opt)
            listFrame.Visible = false
            task.spawn(callback, opt)
        end)
    end

    box.MouseButton1Click:Connect(function()
        listFrame.Visible = not listFrame.Visible
    end)

    return {
        Set = function(_, opt)
            box.Text = "  " .. tostring(opt)
        end,
    }
end

return Library

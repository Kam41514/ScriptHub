local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Observe Hub", "BloodTheme")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Loadable Scripts")

local colors = {
    SchemeColor = Color3.fromRGB(0,255,255),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}

Section:NewButton("Infinite Yield", "Press To Execute Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

local Playerr = Window:NewTab("Player")
local PlayerrSection = Playerr:NewSection("Player")


local playerDropdown = nil
local playerNames = {}

local Visual = Window:NewTab("Visual")
local VisualSection = Visual:NewSection("Observe")

local KeybindSec = Window:NewTab("Keybind")
local KeybindSection = KeybindSec:NewSection("Keybinds")

local ConfigTheme = Window:NewTab("Themes")
local ConfigThemeSection = ConfigTheme:NewSection("Change Theme")


PlayerrSection:NewToggle("Intent", "See What They Are Holding", function(state)
    if state then
local c = workspace.CurrentCamera
local ps = game:GetService("Players")
local lp = ps.LocalPlayer
local rs = game:GetService("RunService")

if state then
    espTextEnabled = true
else
    espTextEnabled = false
end

local function ftool(cr)
    for a, b in next, cr:GetChildren() do
        if b.ClassName == 'Tool' then
            return tostring(b.Name)
        end
    end
    return 'Empty'
end

local function esp(p, cr)
    local h = cr:WaitForChild("Humanoid")
    local hrp = cr:WaitForChild("HumanoidRootPart")

    local text = Drawing.new('Text')
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Color = Color3.new(1, 1, 1)
    text.Font = 20
    text.Size = 22

    local c1
    local c2
    local c3

    local function dc()
        text.Visible = false
        text:Remove()
        if c3 then
            c1:Disconnect()
            c2:Disconnect()
            c3:Disconnect()
            c1 = nil
            c2 = nil
            c3 = nil
        end
    end

    c2 = cr.AncestryChanged:Connect(function(_, parent)
        if not parent then
            dc()
        end
    end)

    c3 = h.HealthChanged:Connect(function(v)
        if (v <= 0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
            dc()
        end
    end)

    c1 = rs.Heartbeat:Connect(function()
        local hrp_pos, hrp_os = c:WorldToViewportPoint(hrp.Position)
        if hrp_os and espTextEnabled then
            text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y - 75)
            text.Text = '[ ' .. tostring(ftool(cr)) .. ' ]'
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end

local function p_added(p)
    if p.Character then
        esp(p, p.Character)
    end
    p.CharacterAdded:Connect(function(cr)
        esp(p, cr)
    end)
end

for _, b in next, ps:GetPlayers() do
    if b ~= lp then
        p_added(b)
    end
end

ps.PlayerAdded:Connect(p_added)

local function toggleEspText()
    espTextEnabled = not espTextEnabled
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.PageUp then
        toggleEspText()
    end
end)

        else espTextEnabled = false
    end
end)

local function updatePlayerNames()
    playerNames = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(playerNames, player.Name)
    end

    if playerDropdown then
        playerDropdown:Refresh(playerNames)
    end
end

playerDropdown = VisualSection:NewDropdown("Players", "List Of Players", playerNames, function(currentOption)
    local selectedPlayer = game:GetService("Players"):FindFirstChild(currentOption)
    if selectedPlayer and selectedPlayer.Character then
        local camera = game:GetService("Workspace").CurrentCamera
        camera.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")
    end
end)

game:GetService("Players").PlayerAdded:Connect(updatePlayerNames)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerNames)

updatePlayerNames()

VisualSection:NewButton("Stop Observing", "Stop Observing", function()
    local camera = game:GetService("Workspace").CurrentCamera
        camera.CameraSubject = game.Players.LocalPlayer.Character
end)

KeybindSection:NewKeybind("Toggle GUI", "Toggle GUI Key", Enum.KeyCode.M, function()
	Library:ToggleUI()
end)


local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer

-- Mod Detector

local function CheckModerator(player)
    task.spawn(function()
        local suc, rank = pcall(function()
            return player:GetRankInGroup(7450839)
        end)

        if not suc then
            return
        end

        if rank ~= 0 then
            Library:Notify({
                Title = "🔴 Mod Detected",
                Description = player.Name .. " is a moderator!",
                Duration = 5
            })

            player.Destroying:Connect(function()
                Library:Notify({
                    Title = "🔴 Mod Left",
                    Description = player.Name .. " left the server.",
                    Duration = 5
                })
            end)
        end
    end)
end

-- Halihazırda serverda olanlar
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        CheckModerator(player)
    end
end

-- Sonradan girenler
Players.PlayerAdded:Connect(function(player)
    CheckModerator(player)
end)

-- Updates:

local SelectedPlayer = ""
local FlySpeed = 125
local WalkSpeed = 16
local ToggleAutoFallValue = false
local NoclipConnection = nil
local FlyToggle = nil
local AutoFallToggle = nil
local SpeedEnabled = false
local Humanoid = nil
local SpeedValue = 100
local DefaultSpeed = 16
local JumpPower = 50
local SelectedNPC = nil
local AutoFloatNPC = false
local ESPEnabled = false
local CurrentSpeedToggleKey = nil
local CurrentNoclipKey = nil
local NoclipToggle = nil
local SpeedToggle = nil
local playerOptions = {}
local AutoExecute = AutoExecuteValue
local selectedPoint
local FruitESP = false
local farmConnection
local farming = false
local autoPickupConnection
local dangerDistance = 165
local dangerConnection
local FlyEnabled = false
local NoclipEnabled = false
local FlyBodyVelocity = nil
local FlyConnection = nil
local CurrentFlyKey = nil
local AutoLog = false
local AutoLogDistance = 50
local ProximityDistance = 375
local ProximityCheck = false
local JoinNotifier = true
local killBricks = {}
local NoKillBricks = false

local function UpdatePlayerList()
    local NewList = {}
    local playerOptions = {}

    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(NewList, player.Name)
    end

    if Options.PlayerDropdown then
        Options.PlayerDropdown:SetValues(NewList)
    end
end


local function ResetPlayerStates()
    fly = false
    ToggleAutoFallValue = false
    NoclipEnabled = false
    SpeedEnabled = false
    ESPEnabled = false

    WalkSpeed = 16
    JumpPower = 50

    if Toggles.FlyToggle then
        Toggles.FlyToggle:SetValue(false)
    end

    if Toggles.AutoFallToggle then
        Toggles.AutoFallToggle:SetValue(false)
    end

    if Toggles.SpeedToggle then
        Toggles.SpeedToggle:SetValue(false)
    end

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if Toggles.NoclipToggle then
        Toggles.NoclipToggle:SetValue(false)
    end

    
    if Toggles.AutoFloatNPCToggle then
        Toggles.AutoFloatNPCToggle:SetValue(false)
    end

    if Toggles.AutoFruit then
        Toggles.AutoFruit:SetValue(false)
    end

    if Toggles.BoxESPToggle then
        Toggles.BoxESPToggle:SetValue(false)
    end



    local player = Players.LocalPlayer

    -- SpeedValue reset
    if SpeedEnabled then
        Humanoid.WalkSpeed = SpeedValue
    else
        Humanoid.WalkSpeed = DefaultSpeed
    end

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            Humanoid.WalkSpeed = DefaultSpeed
            humanoid.JumpPower = JumpPower
        end
    end
end

local function UpdateHumanoid()
    local character = Players.LocalPlayer.Character

    if character then
        Humanoid = character:FindFirstChildOfClass("Humanoid")
    else
        Humanoid = nil
    end
end


local function UpdateOnCharacterReset()

    Players.LocalPlayer.CharacterAdded:Connect(function(character)

        task.wait(1)

        UpdateHumanoid()
        UpdatePlayerList()

        SelectedPlayer = ""
        BossList = {}

        ResetPlayerStates()


        local humanoid = character:WaitForChild("Humanoid")


        humanoid.Died:Connect(function()
            ResetPlayerStates()
        end)



        Library:Notify("Functions Updated On Character Reset!", 1)

    end)

end



-- Window
local Window = Library:CreateWindow({
    Title = "Bloodlines | Beta",
    Footer = "Version: 1.0",
    NotifySide = "Left",
    ShowCustomCursor = true,
    Center = true,
})

-- Tabs
local Tabs = {
    Main = Window:AddTab("Main", "house"),
    Player = Window:AddTab("Player", "user"),
    Visual = Window:AddTab("Visual", "eye"),
    Automation = Window:AddTab("Automation", "play"),
    Botting = Window:AddTab("Botting", "bot"),
    Exploits = Window:AddTab("Exploits", "terminal"),
    Notifications = Window:AddTab("Notifications", "bell"),
    Config = Window:AddTab("Config", "settings"),
}

-- Groupboxes For Main Tab
local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Executable Scripts", "code")
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox("Server Systems", "server")
local RightGroupBox = Tabs.Main:AddRightGroupbox("Player Systems", "user")
local RightGroupBox2 = Tabs.Main:AddRightGroupbox("UI Settings", "settings")


-- Execute Scripts

LeftGroupBox:AddButton({
    Text = "Execute Infinite Yield",
    Func = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua"
        ))()
    end
})

LeftGroupBox:AddButton({
    Text = "Execute Dex Explorer",
    Func = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"))()
    end
})


-- Copy Server ID

LeftGroupBox2:AddButton({
    Text = "Copy Server-ID",
    Func = function()
        if setclipboard then
            setclipboard(game.JobId)
            Library:Notify("Server ID Successfully Copied!", 2)
        else
            Library:Notify("Clipboard not supported!", 2)
        end
    end
})


-- Teleport Error

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    Library:Notify(
        "Teleport Failed: " .. tostring(errorMessage),
        3
    )
end)

-- ServerHop



-- Rejoin

LeftGroupBox2:AddButton({
    Text = "Rejoin Server",
    Func = function()
        Library:Notify("Rejoining The Server", 1)
        task.wait(1)

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            Players.LocalPlayer
        )
    end
})

LeftGroupBox2:AddButton({
    Text = "Rejoin Game",
    Func = function()
        Library:Notify("Rejoining The Game", 1)
        task.wait(1)

        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end
})



-- Server Functions

-- Empty


local PlayerList = {}

for _, player in ipairs(Players:GetPlayers()) do
    table.insert(PlayerList, player.Name)
end

RightGroupBox:AddDropdown("PlayerDropdown", {
    Values = {},
    Default = 1,
    Multi = false,
    Text = "Select Player",
    Tooltip = "Choose a player"
}):OnChanged(function(Value)
    SelectedPlayer = Value
end)

UpdatePlayerList()


RightGroupBox:AddButton({
    Text = "Copy Profile Link",
    Func = function()

        if SelectedPlayer ~= "" then

            local player = Players:FindFirstChild(SelectedPlayer)

            if player then

                local ProfileLink = 
                    "https://www.roblox.com/users/" 
                    .. player.UserId 
                    .. "/profile"

                if setclipboard then
                    setclipboard(ProfileLink)
                    Library:Notify("Profile Link Copied!", 2)
                else
                    Library:Notify("Clipboard not supported!", 2)
                end

            else
                Library:Notify("Player not found!", 3)
            end

        else
            Library:Notify("Select a player first!", 2)
        end

    end
})


RightGroupBox2:AddButton("Unload", function()

    -- Toggle'ları kapat
    if Toggles.FlyToggle then
        Toggles.FlyToggle:SetValue(false)
    end

    if Toggles.NoclipToggle then
        Toggles.NoclipToggle:SetValue(false)
    end

    if Toggles.AutoFallToggle then
        Toggles.AutoFallToggle:SetValue(false)
    end

    if Toggles.SpeedToggle then
        Toggles.SpeedToggle:SetValue(false)
    end

    if Toggles.AutoLogToggle then
        Toggles.AutoLogToggle:SetValue(false)
    end

    if Toggles.ProximityCheck then
        Toggles.ProximityCheck:SetValue(false)
    end

    if Toggles.AutoPick then
        Toggles.AutoPick:SetValue(false)
    end

    if Toggles.FruitESP then
        Toggles.FruitESP:SetValue(false)
    end

    if Toggles.PlayerESPToggle then
        Toggles.PlayerESPToggle:SetValue(false)
    end

    if Toggles.ObserveToggle then
        Toggles.ObserveToggle:SetValue(false)
    end

    if Toggles.NoKillBricks then
        Toggles.NoKillBricks:SetValue(false)
    end

    if Toggles.ChakraSenseStatus then
        Toggles.ChakraSenseStatus:SetValue(false)
    end

    if Toggles.JoinNotifier then
        Toggles.JoinNotifier:SetValue(false)
    end

    if Toggles.AutoExecute then
        Toggles.AutoExecute:SetValue(false)
    end


    -- Manuel olarak tuttuğun connection'lar
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if autoPickupConnection then
        autoPickupConnection:Disconnect()
        autoPickupConnection = nil
    end

    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end

    if dangerConnection then
        dangerConnection:Disconnect()
        dangerConnection = nil
    end

    if BeingObservedConnection then
        BeingObservedConnection:Disconnect()
        BeingObservedConnection = nil
    end


    -- Chakra UI
    if ChakraSenseGui then
        ChakraSenseGui:Destroy()
        ChakraSenseGui = nil
        ChakraSenseLabel = nil
        MyChakraTitle = nil
        MyChakraDescription = nil
    end


    -- Proximity UI
    if ProximityGui then
        ProximityGui:Destroy()
        ProximityGui = nil
        ProximityLabel = nil
    end


    -- Player ESP
    if RemovePlayerESP then
        RemovePlayerESP()
    end


    -- Fly BodyVelocity
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end



    Library:Unload()

end)

RightGroupBox2:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Toggle UI",
    })

Library.ToggleKeybind = Options.MenuKeybind

-- Player Tab

-- Groupboxes For Player Tab
local PlayerLeftGroupBox = Tabs.Player:AddLeftGroupbox("Flight", "wind")
local PlayerLeftGroupBox2 = Tabs.Player:AddLeftGroupbox("Extras", "user")
local PlayerLeftGroupBox3 = Tabs.Player:AddLeftGroupbox("World Settings", "globe")
local PlayerRightGroupBox = Tabs.Player:AddRightGroupbox("Speed", "wind")
local PlayerRightGroupBox2 = Tabs.Player:AddRightGroupbox("Proximity Detector", "bot")

-- Scripts For Player Tab

local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local ControlModule = PlayerModule:GetControls()

local function flyHack(state)
    FlyEnabled = state

    if not state then
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end

        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end

        return
    end

    local character = LocalPlayer.Character
    if not character then
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return
    end

    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Name = "BloodlinesFlyVelocity"
    FlyBodyVelocity.MaxForce = Vector3.new(
        math.huge,
        math.huge,
        math.huge
    )
    FlyBodyVelocity.Parent = rootPart

    FlyConnection = RunService.Stepped:Connect(function()
        if not FlyEnabled then
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then
            return
        end

        local character = LocalPlayer.Character
        if not character then
            return
        end

        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            return
        end

        if not FlyBodyVelocity
            or FlyBodyVelocity.Parent ~= rootPart then

            if FlyBodyVelocity then
                FlyBodyVelocity:Destroy()
            end

            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.Name = "BloodlinesFlyVelocity"
            FlyBodyVelocity.MaxForce = Vector3.new(
                math.huge,
                math.huge,
                math.huge
            )
            FlyBodyVelocity.Parent = rootPart
        end

        local rawMoveVector = ControlModule:GetMoveVector()
        if not rawMoveVector then
            return
        end

        local cameraMoveVector =
            camera.CFrame:VectorToWorldSpace(rawMoveVector)

        -- FlySpeed nil gelirse 50 kullan
        local speed = tonumber(FlySpeed) or 50

        FlyBodyVelocity.Velocity =
            cameraMoveVector * speed
    end)
end


local function noClip(state)
    NoclipEnabled = state

    if not state then
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        return
    end

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    NoclipConnection = RunService.Stepped:Connect(function()
        local character = LocalPlayer.Character
        if not character then
            return
        end

        debug.profilebegin("NoClip")

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        debug.profileend()
    end)
end

local FlyToggle = PlayerLeftGroupBox:AddToggle(
    "FlyToggle",
    {
        Text = "Flight",
        Default = false
    }
)


FlyToggle:AddKeyPicker(
    "FlyKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)

            CurrentFlyKey = key

        end
    }
)


UserInputService.InputBegan:Connect(
    function(input, gameProcessed)

        if gameProcessed then
            return
        end

        if CurrentFlyKey
            and input.KeyCode == CurrentFlyKey then

            FlyToggle:SetValue(
                not FlyToggle.Value
            )

        end

    end
)


FlyToggle:OnChanged(function(Value)

    FlyEnabled = Value

    if Value then
        flyHack(true)
    else
        flyHack(false)
    end

end)

NoclipToggle = PlayerLeftGroupBox:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
})

NoclipToggle:AddKeyPicker("NoclipKeybind", {
    Default = "None",
    SyncToggleState = true,

    Callback = function(key)
        CurrentNoclipKey = key
    end
})

NoclipToggle:OnChanged(function(Value)
    noClip(Value)
end)


AutoFallToggle = PlayerLeftGroupBox:AddToggle("AutoFallToggle",{
    Text = "Auto Fall",
    Default = false,
})

AutoFallToggle:OnChanged(function(Value)

    ToggleAutoFallValue = Value

end)

PlayerLeftGroupBox:AddSlider("FlySpeed",{
    Text = "Fly Speed",
    Default = 125,
    Min = 10,
    Max = 750,
    Rounding = 0,
}):OnChanged(function(Value)

    flySpeed = Value

end)

SpeedToggle = PlayerRightGroupBox:AddToggle("SpeedToggle", {
    Text = "Speed",
    Default = false
})

SpeedToggle:AddKeyPicker("SpeedToggleKeybind", {
    Default = "None",
    SyncToggleState = true,

    Callback = function(key)
        CurrentSpeedToggleKey = key
    end
})

SpeedToggle:OnChanged(function(Value)
    SpeedEnabled = Value

    local player = game:GetService("Players").LocalPlayer
    local character = workspace:FindFirstChild(player.Name)

    if character then
        local Humanoid = character:FindFirstChild("Humanoid")

        if Humanoid then
            if Value then
                Humanoid.WalkSpeed = SpeedValue
            else
                Humanoid.WalkSpeed = DefaultSpeed
            end
        end
    end
end)


game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end

    if CurrentSpeedToggleKey and input.KeyCode == CurrentSpeedToggleKey then
        SpeedToggle:SetValue(not SpeedToggle.Value)
    end
end)

PlayerRightGroupBox:AddSlider("SpeedSlider", {
    Text = "Speed Value",
    Default = 100,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Compact = false
}):OnChanged(function(Value)
    SpeedValue = Value

    if SpeedEnabled then
        local player = game:GetService("Players").LocalPlayer
        local character = workspace:FindFirstChild(player.Name)

        if character then
            local Humanoid = character:FindFirstChild("Humanoid")

            if Humanoid then
                Humanoid.WalkSpeed = Value
            end
        end
    end
end)





PlayerLeftGroupBox2:AddButton({
    Text = "Reset Character",
    Func = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

PlayerRightGroupBox2:AddToggle("AutoLogToggle", {
    Text = "Auto Log",
    Default = false,

    Callback = function(Value)
        AutoLog = Value
    end
})


local function AutoLogKick(Player, Distance)

    if not AutoLog then
        return
    end

    local LocalPlayer = game.Players.LocalPlayer

    Library:Notify({
        Title = "Auto Log",
        Description = Player.Name .. " detected at [" .. math.floor(Distance) .. "]",
        Duration = 2
    })

    task.wait(0.1)

    LocalPlayer:Kick(
        "Auto Log: " .. Player.Name ..
        " detected within " .. math.floor(Distance) .. " studs."
    )
end


PlayerRightGroupBox2:AddToggle("ProximityCheck", {
    Text = "Proximity Check",
    Default = false,

    Callback = function(Value)
        ProximityCheck = Value

        if ProximityLabel then
            ProximityLabel.Visible = false
        end
    end
})


PlayerRightGroupBox2:AddSlider("ProximityDistance", {
    Text = "Proximity Check Distance",
    Default = 375,
    Min = 100,
    Max = 2000,
    Rounding = 0,

    Callback = function(Value)
        ProximityDistance = Value
    end
})


local ProximityGui = nil
local ProximityLabel = nil


local function CreateProximityUI()

    if ProximityGui then
        return
    end

    ProximityGui = Instance.new("ScreenGui")
    ProximityGui.Name = "ProximityStatus"
    ProximityGui.ResetOnSpawn = false
    ProximityGui.IgnoreGuiInset = true
    ProximityGui.Parent =
        game.Players.LocalPlayer:WaitForChild("PlayerGui")


    ProximityLabel = Instance.new("TextLabel")
    ProximityLabel.Name = "ProximityLabel"

    ProximityLabel.AnchorPoint =
        Vector2.new(0.5, 0)

    ProximityLabel.Position =
        UDim2.new(0.5, 0, 0, 80)

    ProximityLabel.Size =
        UDim2.new(0, 400, 0, 70)

    ProximityLabel.BackgroundTransparency = 1

    ProximityLabel.Font =
        Enum.Font.GothamBold

    ProximityLabel.TextSize = 30

    ProximityLabel.TextColor3 =
        Color3.fromRGB(255, 80, 80)

    ProximityLabel.TextStrokeColor3 =
        Color3.fromRGB(0, 0, 0)

    ProximityLabel.TextStrokeTransparency = 0

    ProximityLabel.TextXAlignment =
        Enum.TextXAlignment.Center

    ProximityLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    ProximityLabel.Visible = false

    ProximityLabel.Parent = ProximityGui
end


CreateProximityUI()


local LastAutoLog = 0
local AutoLogCooldown = 3


RunService.Heartbeat:Connect(function()

    local LocalPlayer =
        game.Players.LocalPlayer

    local Character =
        LocalPlayer.Character

    if not Character then
        if ProximityLabel then
            ProximityLabel.Visible = false
        end
        return
    end


    local MyRoot =
        Character:FindFirstChild("HumanoidRootPart")

    if not MyRoot then
        if ProximityLabel then
            ProximityLabel.Visible = false
        end
        return
    end


    local closestPlayer = nil
    local closestDistance = math.huge


    for _, Player in ipairs(game.Players:GetPlayers()) do

        if Player ~= LocalPlayer
            and Player.Character then

            local TheirRoot =
                Player.Character:FindFirstChild(
                    "HumanoidRootPart"
                )


            if TheirRoot then

                local Distance =
                    (
                        MyRoot.Position
                        - TheirRoot.Position
                    ).Magnitude


                if Distance <= ProximityDistance
                    and Distance < closestDistance then

                    closestDistance = Distance
                    closestPlayer = Player

                end
            end
        end
    end


    -- PROXIMITY CHECK UI

    if ProximityCheck and closestPlayer then

        ProximityLabel.Text =
            closestPlayer.Name
            .. " On Distance ["
            .. math.floor(closestDistance)
            .. "]"

        ProximityLabel.Visible = true

    else

        ProximityLabel.Visible = false

    end


    -- AUTO LOG

    if AutoLog and closestPlayer then

        if tick() - LastAutoLog >= AutoLogCooldown then

            LastAutoLog = tick()

            AutoLogKick(
                closestPlayer,
                closestDistance
            )

        end
    end

end)



-- End Of Player Tab

-- Groupboxes For Exploits Tab
local ExploitsLeftGroupBox = Tabs.Exploits:AddLeftGroupbox("Teleportation", "wind")
local ExploitsLeftGroupBox2 = Tabs.Exploits:AddLeftGroupbox("Extras", "user")

ExploitsLeftGroupBox:AddDropdown("PlayerDropdown", {
    Values = PlayerList,
    Default = nil,
    Multi = false,
    Text = "Select Player"
}):OnChanged(function(Value)
    SelectedPlayer = Value
end)


ExploitsLeftGroupBox:AddButton("Teleport To Player", function()

    if SelectedPlayer then

        local target = game:GetService("Players"):FindFirstChild(SelectedPlayer)

        if target and target.Character then

            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")

            local character = game:GetService("Players").LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if targetHRP and hrp then
                hrp.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
            end
        end
    end

end)

ExploitsLeftGroupBox:AddLabel("Chakra Point Teleport")

local ChakraPointsFolder = workspace:WaitForChild("ChakraPoints")

local options = {}
local pointMap = {}
local selectedPoint

for _, chakraPoint in ipairs(ChakraPointsFolder:GetChildren()) do
    if chakraPoint.Name == "ChakraPoint" then
        local stringValue = chakraPoint:FindFirstChildWhichIsA("StringValue")
        if stringValue then
            table.insert(options, stringValue.Value)
            pointMap[stringValue.Value] = chakraPoint
        end
    end
end

local ChakraPointsDropdown = ExploitsLeftGroupBox:AddDropdown("ChakraDropdown", {
    Title = "Chakra Points",
    Values = options,
    Multi = false,
    Default = 1,
})

ChakraPointsDropdown:OnChanged(function(value)
    selectedPoint = value
end)

ExploitsLeftGroupBox:AddButton({
    Text = "Teleport Point",
    Callback = function()
        if not selectedPoint then
            Library:Notify({
                Title = "Teleport Failed",
                Content = "Select Chakra Point",
                Duration = 3
            })
            return
        end

        local point = pointMap[selectedPoint]
        if not point then
            return
        end

        local character = game:GetService("Players").LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = point:GetPivot() + Vector3.new(0, 3, 0)
        end
    end
})

local function getClosestSafePoint(position)
    local points = {
        workspace:GetChildren()[5527],
        workspace:GetChildren()[13321],
        workspace:GetChildren()[14398],
        workspace:GetChildren()[5550],
        workspace:GetChildren()[5910],
        workspace:GetChildren()[2787].Soil,
        workspace:GetChildren()[19318]
    }

    local closestPoint
    local closestDistance = math.huge

    for _, point in ipairs(points) do
        if point and point:IsA("BasePart") then
            local distance = (point.Position - position).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestPoint = point
            end
        end
    end

    return closestPoint
end

local function getSafePoint(position)
    local point = getClosestSafePoint(position)
    if not point then return nil end

    local topCenter = point.Position + Vector3.new(0, point.Size.Y / 2, 0)

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if (player.Character.HumanoidRootPart.Position - topCenter).Magnitude <= 250 then
                return nil
            end
        end
    end

    return topCenter
end

local character = game.Players.LocalPlayer.Character
local root = character and character:FindFirstChild("HumanoidRootPart")

ExploitsLeftGroupBox:AddLabel("Safe Point")

ExploitsLeftGroupBox:AddButton({
    Text = "Teleport Safe Point",
    Callback = function()
        local character = game:GetService("Players").LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if hrp then
            local safePoint = getSafePoint(hrp.Position)

            if safePoint then
                hrp.CFrame = CFrame.new(safePoint)
            end
        end
    end
})





local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gameManager = require(
    ReplicatedStorage:WaitForChild("GameManager")
)

local dataFunction =
    ReplicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")

local purchasableItems = {}

for itemName, item in pairs(gameManager.Items) do
    if item.Buyabble then
        table.insert(purchasableItems, itemName)
    end
end

table.sort(purchasableItems)

local SelectedItem = nil

local ItemDropdown = ExploitsLeftGroupBox2:AddDropdown(
    "ItemDropdown",
    {
        Text = "Select Item",
        Values = purchasableItems,
        Multi = false,
        Default = 1,
    }
)

ItemDropdown:OnChanged(function(Value)
    SelectedItem = Value
end)

ExploitsLeftGroupBox2:AddButton({
    Text = "Buy Item",

    Func = function()
        if not SelectedItem then
            Library:Notify({
                Title = "Buy Item",
                Description = "Please select an item first!",
                Duration = 3
            })
            return
        end

        local success, result = pcall(function()
            return dataFunction:InvokeServer(
                "Buy",
                1,
                SelectedItem,
                1
            )
        end)

        if success then
            Library:Notify({
                Title = "Item Purchased",
                Description = SelectedItem,
                Duration = 3
            })
        else
            Library:Notify({
                Title = "Purchase Failed",
                Description = tostring(result),
                Duration = 3
            })
        end
    end
})


local KILL_BRICKS_NAMES = {
    "LavarossaVoid",
    "Void"
}

local function onChildAdded(object)
    if not table.find(KILL_BRICKS_NAMES, object.Name) then
        return
    end

    table.insert(killBricks, {
        part = object,
        oldParent = object.Parent
    })

    if NoKillBricks then
        object.Parent = nil
    end
end

local function setNoKillBricks(state)
    NoKillBricks = state

    for _, killBrick in ipairs(killBricks) do
        if killBrick.part then
            killBrick.part.Parent =
                state and nil or killBrick.oldParent
        end
    end
end


PlayerLeftGroupBox3:AddToggle("NoKillBricks", {
    Text = "No Kill Bricks",
    Default = false,
    Callback = function(Value)
        setNoKillBricks(Value)
    end
})


for _, v in ipairs(workspace:GetDescendants()) do
    if table.find(KILL_BRICKS_NAMES, v.Name) then
        task.spawn(onChildAdded, v)
    end
end


workspace.DescendantAdded:Connect(onChildAdded)

local fruitNames = {
    ["Mango"] = true,
    ["Orange"] = true,
    ["Life Up Fruit"] = true,
    ["Chakra Fruit"] = true,
    ["Pear"] = true,
    ["Alluring Apple"] = true,
    ["Apple"] = true,
    ["Banana"] = true
}



local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local remotes = ReplicatedStorage.Events
local dataEvent = remotes.DataEvent

local player = Players.LocalPlayer
local pickupList = {}

local function onChildAdded(obj)
	if not obj:IsA("BasePart") then
		return
	end

	local pickupable = obj:WaitForChild("Pickupable", 10)
	if not pickupable then
		return
	end

	local id = obj:WaitForChild("ID", 10)
	if not id then
		return
	end

	local pos = obj.Position
	pickupList[pos] = obj

	obj.Destroying:Connect(function()
		pickupList[pos] = nil
	end)
end

for _, child in ipairs(workspace:GetDescendants()) do
	task.spawn(onChildAdded, child)
end

workspace.DescendantAdded:Connect(onChildAdded)


-- Visual Section

local VisualLeftGroupBox = Tabs.Visual:AddLeftGroupbox("Player ESP", "eye")
local VisualLeftGroupBox2 = Tabs.Visual:AddLeftGroupbox("Extra ESP", "eye")
local VisualRightGroupBox = Tabs.Visual:AddRightGroupbox("Leaderboard Settings")

local PlayerESPObjects = {}
local PlayerESPEnabled = false


local function CreatePlayerESP(plr)

    if plr == LocalPlayer then
        return
    end

    if PlayerESPObjects[plr] then
        return
    end


    local function SetupCharacter(char)

        if not PlayerESPEnabled then
            return
        end

        local root = char:WaitForChild("HumanoidRootPart", 5)
        local humanoid = char:WaitForChild("Humanoid", 5)

        if not root or not humanoid then
            return
        end


        -- Highlight

        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerESP"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(255,0,0)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char



        -- Yazı

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESPText"
        billboard.Size = UDim2.new(0,200,0,50)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.AlwaysOnTop = true
        billboard.Parent = root


        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1,0,1,0)
        text.BackgroundTransparency = 1
        text.TextStrokeTransparency = 0
        text.TextSize = 14
        text.Font = Enum.Font.SourceSansBold
        text.TextColor3 = Color3.fromRGB(255,0,0)
        text.Parent = billboard



        local connection

        connection = RunService.RenderStepped:Connect(function()

            if not PlayerESPEnabled
            or not char.Parent
            or humanoid.Health <= 0 then

                if connection then
                    connection:Disconnect()
                end

                return
            end


            local distance = 0

            if LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                distance = math.floor(
                    (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                )

            end


            text.Text =
                plr.Name
                ..
                "\n❤ "
                ..
                math.floor(humanoid.Health)
                ..
                "/"
                ..
                math.floor(humanoid.MaxHealth)
                ..
                " | "
                ..
                distance
                ..
                " st"

        end)



        PlayerESPObjects[plr] = {
            Highlight = highlight,
            Billboard = billboard,
            Connection = connection
        }

    end



    if plr.Character then
        SetupCharacter(plr.Character)
    end


    plr.CharacterAdded:Connect(function(char)

        task.wait(1)

        if PlayerESPEnabled then

            -- eskiyi temizle
            if PlayerESPObjects[plr] then
                local old = PlayerESPObjects[plr]

                if old.Connection then
                    old.Connection:Disconnect()
                end

                if old.Highlight then
                    old.Highlight:Destroy()
                end

                if old.Billboard then
                    old.Billboard:Destroy()
                end

                PlayerESPObjects[plr] = nil
            end


            SetupCharacter(char)

        end

    end)

end



local function RemovePlayerESP()

    for plr,data in pairs(PlayerESPObjects) do

        if data.Connection then
            data.Connection:Disconnect()
        end

        if data.Highlight then
            data.Highlight:Destroy()
        end

        if data.Billboard then
            data.Billboard:Destroy()
        end

    end

    table.clear(PlayerESPObjects)

end


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FruitESP = {Objects = {}}
local FruitESPEnabled = false

local Fruits = {
    Mango = Color3.fromRGB(255, 170, 0),
    Orange = Color3.fromRGB(255, 140, 0),
    Banana = Color3.fromRGB(255, 235, 60),
    Apple = Color3.fromRGB(255, 70, 70),
    ["Alluring Apple"] = Color3.fromRGB(200, 200, 200),
    Pear = Color3.fromRGB(100, 255, 100),
    ["Chakra Fruit"] = Color3.fromRGB(170, 0, 255)
}


local function CreateESP(obj)
    if FruitESP.Objects[obj] then return end

    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "FruitESP"
    gui.Adornee = part
    gui.Size = UDim2.fromOffset(120, 20)
    gui.StudsOffset = Vector3.new(0, 1.8, 0)
    gui.AlwaysOnTop = true
    gui.LightInfluence = 0
    gui.Enabled = FruitESPEnabled
    gui.Parent = part

    local label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextStrokeTransparency = 0.4
    label.TextStrokeColor3 = Color3.new()
    label.TextColor3 = Fruits[obj.Name]
    label.Parent = gui

    FruitESP.Objects[obj] = gui
end

-- Sadece bir kez tara
for _, obj in ipairs(workspace:GetDescendants()) do
    if Fruits[obj.Name] then
        CreateESP(obj)
    end
end

-- Yeni oluşanları ekle
workspace.DescendantAdded:Connect(function(obj)
    if Fruits[obj.Name] then
        CreateESP(obj)
    end
end)

function FruitESP:Update()
    if not FruitESPEnabled then
        return
    end

    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for obj, gui in pairs(self.Objects) do
        if not obj.Parent then
            gui:Destroy()
            self.Objects[obj] = nil
        else
            local part = gui.Adornee
            local label = gui:FindFirstChild("TextLabel")

            if part and label then
                local distance = math.floor((hrp.Position - part.Position).Magnitude)
                label.Text = ("%s [%dm]"):format(obj.Name, distance)
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.1) do
        FruitESP:Update()
    end
end)

VisualLeftGroupBox2:AddToggle("FruitESP", {
    Text = "Fruit ESP",
    Default = false,
    Callback = function(Value)
        FruitESPEnabled = Value

        for _, gui in pairs(FruitESP.Objects) do
            if gui then
                gui.Enabled = Value
            end
        end
    end
})




VisualLeftGroupBox:AddToggle("PlayerESPToggle", {
    Text = "Player ESP",
    Default = false
}):OnChanged(function(Value)

    PlayerESPEnabled = Value


    if Value then

        for _,plr in ipairs(Players:GetPlayers()) do
            CreatePlayerESP(plr)
        end


        Players.PlayerAdded:Connect(function(plr)

            if PlayerESPEnabled then
                CreatePlayerESP(plr)
            end

        end)


    else

        RemovePlayerESP()

    end

end)

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local observeEnabled = true
local currentObserveTarget

local connections = {}
local listConnection

local function clearConnections()
	for _, connection in pairs(connections) do
		connection:Disconnect()
	end

	table.clear(connections)

	if listConnection then
		listConnection:Disconnect()
		listConnection = nil
	end
end

local function getPlayerList()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then
		return nil
	end

	local clientGui = playerGui:FindFirstChild("ClientGui")
	local mainframe = clientGui and clientGui:FindFirstChild("Mainframe")
	local playerList = mainframe and mainframe:FindFirstChild("PlayerList")

	return playerList and playerList:FindFirstChild("List")
end

local function resetCamera()
	currentObserveTarget = nil

	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChild("Humanoid")

	if humanoid then
		Camera.CameraSubject = humanoid
	end
end

local function setupPlayerTemplate(template)
	if template.Name ~= "PlayerTemplate" then
		return
	end

	local connection = template.InputBegan:Connect(function(input)
		if not observeEnabled then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			local playerNameObject = template:FindFirstChild("PlayerName")
			if not playerNameObject then
				return
			end

			local target = Players:FindFirstChild(playerNameObject.Text)

			if not target or not target.Character then
				return
			end

			local humanoid = target.Character:FindFirstChild("Humanoid")
			if not humanoid then
				return
			end

			if currentObserveTarget == target then
				resetCamera()
			else
				currentObserveTarget = target
				Camera.CameraSubject = humanoid
			end
		end
	end)

	table.insert(connections, connection)
end

local function enableObserve()
	clearConnections()

	local list = getPlayerList()
	if not list then
		return
	end

	for _, template in ipairs(list:GetChildren()) do
		setupPlayerTemplate(template)
	end

	listConnection = list.ChildAdded:Connect(function(child)
		if observeEnabled then
			setupPlayerTemplate(child)
		end
	end)
end

local ObserveToggle = VisualRightGroupBox:AddToggle("ObserveToggle", {
	Text = "Leaderboard Observe",
	Default = true,
})

ObserveToggle:OnChanged(function(value)
	observeEnabled = value

	if value then
		enableObserve()
	else
		clearConnections()
		resetCamera()
	end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
	currentObserveTarget = nil

	local humanoid = character:WaitForChild("Humanoid")
	Camera.CameraSubject = humanoid

	if observeEnabled then
		task.wait(1)
		enableObserve()
	end
end)

LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
	if child.Name == "ClientGui" and observeEnabled then
		task.wait(0.5)
		enableObserve()
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if currentObserveTarget == player and observeEnabled then
			local humanoid = character:WaitForChild("Humanoid")
			Camera.CameraSubject = humanoid
		end
	end)
end)

if observeEnabled then
	enableObserve()
end





-- Automation

local AutomationLeftGroupBox = Tabs.Automation:AddLeftGroupbox("Automation")

AutomationLeftGroupBox:AddToggle("AutoPick", {
	Text = "Auto Pick",
	Default = false,

	Callback = function(Value)

		if not Value then
			if autoPickupConnection then
				autoPickupConnection:Disconnect()
				autoPickupConnection = nil
			end
			return
		end

		autoPickupConnection = RunService.Heartbeat:Connect(function()
			local character = player.Character
			if not character then return end

			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if not rootPart then return end

			for pos, obj in pairs(pickupList) do
				if obj and obj.Parent then

					local distance = (rootPart.Position - pos).Magnitude

					if distance < 25 then
						local id = obj:FindFirstChild("ID")

						if id then
							dataEvent:FireServer(
								"PickUp",
								id.Value
							)
						end
					end
				end
			end
		end)

	end
})

-- Botting

local BottingRightGroupBox = Tabs.Botting:AddRightGroupbox("Auto Farm")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    local character = getCharacter()
    return character:FindFirstChild("HumanoidRootPart")
end

local function GetActiveChakraPlayers()
    local activePlayers = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
            and plr.Character then

            local torso =
                plr.Character:FindFirstChild("Torso")
                or plr.Character:FindFirstChild("UpperTorso")

            if torso and torso:FindFirstChild("ChakraSense") then
                table.insert(activePlayers, plr.Name)
            end
        end
    end

    return activePlayers
end

local function isAnyActiveChakraUser()
    return #GetActiveChakraPlayers() > 0
end

local function isPlayerWithinDistance(position, distance)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if hrp and (hrp.Position - position).Magnitude <= distance then
                return true
            end
        end
    end

    return false
end

local function getSafePoint(position)
    local points = {
        workspace:GetChildren()[5527],
        workspace:GetChildren()[13321],
        workspace:GetChildren()[14398]
    }

    local closestPoint
    local closestDistance = math.huge

    for _, point in ipairs(points) do
        if point and point:IsA("BasePart") then
            local distance = (point.Position - position).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestPoint = point
            end
        end
    end

    if not closestPoint then
        return nil
    end

    local targetPosition =
        closestPoint.Position +
        Vector3.new(0, closestPoint.Size.Y / 2, 0)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if hrp and (hrp.Position - targetPosition).Magnitude <= 250 then
                return nil
            end
        end
    end

    return targetPosition
end

local function teleportToSafePoint()
    local hrp = getHRP()

    if not hrp then
        return false
    end

    -- 1. deneme
    local safePoint = getSafePoint(hrp.Position)

    if safePoint then
        hrp.CFrame = CFrame.new(safePoint)

        task.wait(0.05)

        if hrp.Parent and (hrp.Position - safePoint).Magnitude <= 5 then
            updateStatus(
                "Moved To Safe Point",
                Color3.fromRGB(90, 220, 130),
                "Safety mode active"
            )

            return true
        end
    end

    -- 2. deneme: closest point'i yeniden hesapla
    task.wait(0.05)

    if not hrp.Parent then
        return false
    end

    safePoint = getSafePoint(hrp.Position)

    if not safePoint then
        return false
    end

    hrp.CFrame = CFrame.new(safePoint)

    task.wait(0.05)

    if not hrp.Parent then
        return false
    end

    updateStatus(
        "Moved To Safe Point",
        Color3.fromRGB(90, 220, 130),
        "Safety mode active"
    )

    return true
end



local function getTrees()
    local trees = {}

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and string.match(obj.Name, "^Tree%d+$") then
            local fruitSpawns = obj:FindFirstChild("FruitSpawns")
            local mainBranch = obj:FindFirstChild("MainBranch")

            if fruitSpawns and mainBranch then
                table.insert(trees, {
                    Tree = obj,
                    MainBranch = mainBranch
                })
            end
        end
    end

    table.sort(trees, function(a, b)
        return a.Tree.Name < b.Tree.Name
    end)

    return trees
end

local function teleportToTree(treeData)
    if isAnyActiveChakraUser() then
        return false
    end

    local hrp = getHRP()

    if not hrp then
        return false
    end

    local mainBranch = treeData.MainBranch

    if not mainBranch or not mainBranch.Parent then
        return false
    end

    local targetCFrame = mainBranch:GetPivot()
    local targetPosition = targetCFrame.Position

    if isPlayerWithinDistance(targetPosition, 275) then
        return false
    end

    if isAnyActiveChakraUser() then
        return false
    end

    -- Center'ın 10 stud üstüne ışınlan
    local targetPosition = targetCFrame.Position + Vector3.new(0, 10, 0)

    hrp.CFrame = CFrame.new(targetPosition)

    -- Ağaç üzerinde float halinde sabit kal
    if TreeFloatVelocity then
        TreeFloatVelocity:Destroy()
        TreeFloatVelocity = nil
    end

    TreeFloatVelocity = Instance.new("BodyVelocity")
    TreeFloatVelocity.Name = "TreeFarmFloatVelocity"
    TreeFloatVelocity.MaxForce = Vector3.new(
        math.huge,
        math.huge,
        math.huge
    )
    TreeFloatVelocity.Velocity = Vector3.zero
    TreeFloatVelocity.Parent = hrp

    -- Fizik yüzünden dışarı kayarsa tekrar merkeze al
    task.wait(0.05)

    if not getgenv().TreeFarmEnabled then
        return false
    end

    if not hrp.Parent then
        return false
    end

    if isAnyActiveChakraUser() then
        return false
    end

    hrp.CFrame = CFrame.new(targetPosition)

    return true
end




local function checkNearbyPlayerAfterTeleport()
    local hrp = getHRP()

    if not hrp then
        return false
    end

    if isAnyActiveChakraUser() then
        updateStatus(
            "Active Chakra User",
            Color3.fromRGB(255, 180, 70),
            "Moving to nearest safe point..."
        )

        teleportToSafePoint()

        return true
    end

    if not isPlayerWithinDistance(hrp.Position, 150) then
        return false
    end

    updateStatus(
        "Player Detected",
        Color3.fromRGB(255, 90, 90),
        "Moving to nearest safe point..."
    )

    teleportToSafePoint()

    return true
end

local ScreenGui
local MainFrame
local Status
local TreeLabel
local StatusDot

local function createStatusGui()
    if ScreenGui then
        ScreenGui.Enabled = true
        return
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TreeFarmStatus"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "StatusFrame"
    MainFrame.Size = UDim2.fromOffset(255, 86)
    MainFrame.AnchorPoint = Vector2.new(1, 1)
    MainFrame.Position = UDim2.new(1, -30, 0.72, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 100, 190)
    MainFrame.BackgroundTransparency = 0.25
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 2
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 18)
    Corner.Parent = MainFrame

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 145, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 75, 160))
    })
    Gradient.Rotation = 35
    Gradient.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(100, 200, 255)
    Stroke.Transparency = 0.35
    Stroke.Thickness = 1.5
    Stroke.Parent = MainFrame

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.fromScale(0.5, 0.5)
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 80, 180)
    Shadow.ImageTransparency = 0.65
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = 1
    Shadow.Parent = MainFrame

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.fromScale(1, 1)
    Content.ZIndex = 3
    Content.Parent = MainFrame

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.PaddingRight = UDim.new(0, 15)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.Parent = Content

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -25, 0, 19)
    Header.BackgroundTransparency = 1
    Header.Text = "FRUIT FARM"
    Header.TextColor3 = Color3.fromRGB(245, 250, 255)
    Header.TextSize = 13
    Header.Font = Enum.Font.GothamBold
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.ZIndex = 4
    Header.Parent = Content

    StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.fromOffset(8, 8)
    StatusDot.Position = UDim2.new(1, -8, 0, 6)
    StatusDot.BackgroundColor3 = Color3.fromRGB(90, 240, 150)
    StatusDot.BorderSizePixel = 0
    StatusDot.ZIndex = 4
    StatusDot.Parent = Content

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot

    Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.fromOffset(0, 26)
    Status.BackgroundTransparency = 1
    Status.Text = "Checking Active Chakra Users..."
    Status.TextColor3 = Color3.fromRGB(225, 240, 255)
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamMedium
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.TextTruncate = Enum.TextTruncate.AtEnd
    Status.ZIndex = 4
    Status.Parent = Content

    TreeLabel = Instance.new("TextLabel")
    TreeLabel.Size = UDim2.new(1, 0, 0, 18)
    TreeLabel.Position = UDim2.fromOffset(0, 49)
    TreeLabel.BackgroundTransparency = 1
    TreeLabel.Text = "Waiting..."
    TreeLabel.TextColor3 = Color3.fromRGB(175, 220, 255)
    TreeLabel.TextSize = 11
    TreeLabel.Font = Enum.Font.Gotham
    TreeLabel.TextXAlignment = Enum.TextXAlignment.Left
    TreeLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TreeLabel.ZIndex = 4
    TreeLabel.Parent = Content
end

local function hideStatusGui()
    if ScreenGui then
        ScreenGui.Enabled = false
    end
end

function updateStatus(text, color, treeText)
    if not Status then
        return
    end

    Status.Text = text

    if color then
        Status.TextColor3 = color

        if StatusDot then
            StatusDot.BackgroundColor3 = color
        end
    end

    if treeText and TreeLabel then
        TreeLabel.Text = treeText
    end
end

local function getFruitPosition(fruit)
    if not fruit or not fruit.Parent then
        return nil
    end

    if fruit:IsA("BasePart") then
        return fruit.Position
    end

    if fruit:IsA("Model") then
        return fruit:GetPivot().Position
    end

    return nil
end

local FruitNames = {
    "Mango",
    "Orange",
    "Banana",
    "Apple",
    "Alluring Apple",
    "Pear",
    "Chakra Fruit",
    "Life Up Fruit"
}

local function getCurrentFruits()
    local result = {}
    local allowed = {}

    for _, name in ipairs(FruitNames) do
        allowed[name] = true
    end

    local hrp = getHRP()

    if not hrp then
        return result
    end

    local currentPosition = hrp.Position

    for _, obj in ipairs(workspace:GetDescendants()) do
        if allowed[obj.Name] then
            local position = getFruitPosition(obj)

            if position and (position - currentPosition).Magnitude <= 300 then
                table.insert(result, {
                    Object = obj,
                    Position = position
                })
            end
        end
    end

    return result
end


local function teleportToFruit(fruitData)
    if isAnyActiveChakraUser() then
        return false
    end

    local hrp = getHRP()

    if not hrp then
        return false
    end

    local position = getFruitPosition(fruitData.Object)

    if not position then
        return false
    end

    if isAnyActiveChakraUser() then
        return false
    end

    hrp.CFrame = CFrame.new(position)

    return true
end

local function waitForTreeFruits(treeData)
    local timeout = 10
    local startTime = tick()

    while getgenv().TreeFarmEnabled do

        if isAnyActiveChakraUser() then
            updateStatus(
                "Active Chakra User",
                Color3.fromRGB(255, 180, 70),
                "Moving to nearest safe point..."
            )

            teleportToSafePoint()

            repeat
                task.wait(0.25)
            until not isAnyActiveChakraUser()
                or not getgenv().TreeFarmEnabled

            if not getgenv().TreeFarmEnabled then
                return {}
            end

            startTime = tick()
        end

        local currentFruits = getCurrentFruits()

        if #currentFruits > 0 then
            updateStatus(
                "Fruit Detected",
                Color3.fromRGB(100, 220, 140),
                "Waiting 1 second..."
            )

            task.wait(1)

            if not getgenv().TreeFarmEnabled then
                return {}
            end

            if isAnyActiveChakraUser() then
                updateStatus(
                    "Active Chakra User",
                    Color3.fromRGB(255, 180, 70),
                    "Moving to nearest safe point..."
                )

                teleportToSafePoint()

                repeat
                    task.wait(0.25)
                until not isAnyActiveChakraUser()
                    or not getgenv().TreeFarmEnabled

                if not getgenv().TreeFarmEnabled then
                    return {}
                end
            end

            return getCurrentFruits()
        end

        if tick() - startTime >= timeout then
            return {}
        end

        updateStatus(
            "Waiting For Fruit",
            Color3.fromRGB(255, 200, 90),
            treeData.Tree.Name
        )

        task.wait(0.25)
    end

    return {}
end

local function runTreeFarm()
    local trees = getTrees()

    if #trees == 0 then
        updateStatus(
            "No Valid Trees Found",
            Color3.fromRGB(255, 90, 90),
            "Waiting for FruitSpawns..."
        )

        return
    end

    for index, treeData in ipairs(trees) do
        if not getgenv().TreeFarmEnabled then
            return
        end

        if isAnyActiveChakraUser() then
            updateStatus(
                "Active Chakra User",
                Color3.fromRGB(255, 180, 70),
                "Moving to nearest safe point..."
            )

            teleportToSafePoint()

            repeat
                task.wait(0.25)
            until not isAnyActiveChakraUser()
                or not getgenv().TreeFarmEnabled

            if not getgenv().TreeFarmEnabled then
                return
            end
        end

        updateStatus(
            "Checking Tree",
            Color3.fromRGB(100, 180, 255),
            string.format(
                "%d / %d  •  %s",
                index,
                #trees,
                treeData.Tree.Name
            )
        )

        if isAnyActiveChakraUser() then
            continue
        end

        local teleported = teleportToTree(treeData)

        if not teleported then
            updateStatus(
                "Tree Skipped",
                Color3.fromRGB(255, 190, 80),
                string.format(
                    "%d / %d  •  Player nearby",
                    index,
                    #trees
                )
            )

            task.wait(0.15)
            continue
        end

        task.wait(0.25)

        if checkNearbyPlayerAfterTeleport() then
            task.wait(0.25)
            continue
        end

        local currentFruits = waitForTreeFruits(treeData)

        if not getgenv().TreeFarmEnabled then
            return
        end

        for fruitIndex, fruitData in ipairs(currentFruits) do
            if not getgenv().TreeFarmEnabled then
                return
            end

            if isAnyActiveChakraUser() then
                updateStatus(
                    "Active Chakra User",
                    Color3.fromRGB(255, 180, 70),
                    "Moving to nearest safe point..."
                )

                teleportToSafePoint()

                repeat
                    task.wait(0.25)
                until not isAnyActiveChakraUser()
                    or not getgenv().TreeFarmEnabled

                if not getgenv().TreeFarmEnabled then
                    return
                end
            end

            if checkNearbyPlayerAfterTeleport() then
                break
            end

            if fruitData.Object and fruitData.Object.Parent then
                updateStatus(
                    "Collecting Fruit",
                    Color3.fromRGB(100, 220, 140),
                    string.format(
                        "%d / %d  •  %s",
                        fruitIndex,
                        #currentFruits,
                        treeData.Tree.Name
                    )
                )

                if not isAnyActiveChakraUser() then
                    teleportToFruit(fruitData)
                end

                task.wait(0.25)

                if checkNearbyPlayerAfterTeleport() then
                    break
                end
            end
        end

        task.wait(0.25)
    end

    updateStatus(
        "Tree Cycle Completed",
        Color3.fromRGB(90, 220, 130),
        "Restarting scan..."
    )
end

local TreeFarmToggle = BottingRightGroupBox:AddToggle("TreeFarmToggle", {
    Text = "Fruit Farm",
    Default = false,

    Callback = function(Value)
        getgenv().TreeFarmEnabled = Value

        if not Value then
            hideStatusGui()

            if autoPickupConnection then
                autoPickupConnection:Disconnect()
                autoPickupConnection = nil
            end

            if TreeFloatVelocity then
                TreeFloatVelocity:Destroy()
                TreeFloatVelocity = nil
            end

            return
        end

        createStatusGui()

        updateStatus(
            "Checking Active Chakra Users...",
            Color3.fromRGB(100, 180, 255),
            "Scanning..."
        )

        if autoPickupConnection then
            autoPickupConnection:Disconnect()
            autoPickupConnection = nil
        end

        autoPickupConnection = RunService.Heartbeat:Connect(function()
            if not getgenv().TreeFarmEnabled then
                return
            end

            local character = player.Character
            if not character then
                return
            end

            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then
                return
            end

            for pos, obj in pairs(pickupList) do
                if obj and obj.Parent then
                    local distance = (rootPart.Position - pos).Magnitude

                    if distance < 25 then
                        local id = obj:FindFirstChild("ID")

                        if id then
                            dataEvent:FireServer(
                                "PickUp",
                                id.Value
                            )
                        end
                    end
                end
            end
        end)

        task.spawn(function()

            local firstCheck = true

            while getgenv().TreeFarmEnabled do

                local activePlayers = GetActiveChakraPlayers()

                if #activePlayers > 0 then
                    updateStatus(
                        "Active Chakra Users",
                        Color3.fromRGB(255, 180, 70),
                        string.format("%d user(s) detected", #activePlayers)
                    )

                    if not firstCheck then
                        local hrp = getHRP()

                        if hrp then
                            teleportToSafePoint()
                        end
                    else
                        updateStatus(
                            "Active Chakra Users",
                            Color3.fromRGB(255, 180, 70),
                            "Waiting at current position..."
                        )
                    end

                    repeat
                        task.wait(0.25)
                        activePlayers = GetActiveChakraPlayers()
                    until #activePlayers == 0
                        or not getgenv().TreeFarmEnabled

                    if not getgenv().TreeFarmEnabled then
                        break
                    end

                    updateStatus(
                        "No Active Chakra Users",
                        Color3.fromRGB(90, 220, 130),
                        "Starting fruit farm..."
                    )

                    task.wait(0.5)
                end

                firstCheck = false

                if #GetActiveChakraPlayers() == 0 then
                    runTreeFarm()
                end

                task.wait(0.5)
            end

            if autoPickupConnection then
                autoPickupConnection:Disconnect()
                autoPickupConnection = nil
            end

            hideStatusGui()
        end)
    end
})

TreeFarmToggle:AddKeyPicker(
    "TreeFarmKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)
            CurrentTreeFarmKey = key
        end
    }
)







-- Notifications
local NotificationsLeftGroupBox = Tabs.Notifications:AddLeftGroupbox("Discord Webhook")
local NotificationsRightGroupBox = Tabs.Notifications:AddRightGroupbox("Notifier")

NotificationsLeftGroupBox:AddInput("WebhookURL", {
    Text = "Webhook URL",
    Default = "",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = false,
    Placeholder = "Discord Webhook URL...",
})


local importantItems = {
    ["Life Up Fruit"] = true,
    ["Chakra Fruit"] = true,
    ["Scalpel"] = true,
    ["Mysterious Eyes"] = true,
    ["Trait Scroll"] = true,
    ["Ring Of Favor"] = true,
    ["Sharingan Eyes"] = true,
    ["Byakugan Eyes"] = true,
    ["Lava Snakeskin"] = true,
    ["Snakeskin"] = true,
    ["Extraction Spoon"] = true,
    ["Chakra Heart"] = true,
}

local function SendInventory()

    local webhook = Options.WebhookURL.Value

    if webhook == nil or webhook == "" then
        Library:Notify({
            Title = "Inventory Logger",
            Description = "Please enter a Webhook URL.",
            Time = 4,
        })
        return
    end

    local loadout = player.PlayerGui.ClientGui.Mainframe.Loadout
    local scroll = loadout.Inventory.InventoryScroll

    local inventory = {}
    local importantInventory = {}
    local importantCount = 0

    local RED = "\27[2;31m"
    local RESET = "\27[0m"

    --------------------------------------------------
    -- ITEM EKLEME
    --------------------------------------------------

    local function addItem(itemName, amount)

        if itemName == "" then
            return
        end

        local line

        if amount ~= "" then
            line = amount .. " " .. itemName
        else
            line = itemName
        end

        local isImportant =
            importantItems[itemName]
            or itemName:match("Schematics$")

        if isImportant then

            table.insert(
                inventory,
                RED .. line .. RESET
            )

            table.insert(
                importantInventory,
                RED .. line .. RESET
            )

            importantCount = importantCount + 1

        else

            table.insert(
                inventory,
                line
            )

        end
    end

    --------------------------------------------------
    -- INVENTORY
    --------------------------------------------------

    for _, slot in ipairs(scroll:GetChildren()) do

        if slot.Name:match("^InvSlot%d+$") then

            local slotText =
                slot:FindFirstChild("SlotText")

            local itemNumber =
                slot:FindFirstChild("ItemNumber")

            if slotText
                and slotText:IsA("TextLabel")
                and slotText.Text ~= "" then

                local itemName =
                    slotText.Text

                local amount = ""

                if itemNumber then

                    local number =
                        itemNumber:FindFirstChild("Number")

                    if number
                        and number:IsA("TextLabel") then

                        amount = number.Text

                    end
                end

                addItem(itemName, amount)
            end
        end
    end

    --------------------------------------------------
    -- HOTBAR 1-12
    --------------------------------------------------

    for i = 1, 12 do

        local slot =
            loadout:FindFirstChild("Slot" .. i)

        if slot then

            local slotText =
                slot:FindFirstChild("SlotText")

            local itemNumber =
                slot:FindFirstChild("ItemNumber")

            local itemName = ""
            local amount = ""

            if itemNumber then

                local number =
                    itemNumber:FindFirstChild("Number")

                if number
                    and number:IsA("TextLabel") then

                    amount = number.Text

                end
            end

            if slotText
                and slotText:IsA("TextLabel") then

                itemName =
                    slotText.Text

            end

            addItem(itemName, amount)
        end
    end

    --------------------------------------------------
    -- TEXT
    --------------------------------------------------

    local inventoryText =
        table.concat(inventory, "\n")

    if inventoryText == "" then
        inventoryText = "Empty"
    end

    local importantText =
        table.concat(importantInventory, "\n")

    if importantText == "" then
        importantText = "None"
    end

    --------------------------------------------------
    -- ACCOUNT NAME
    --------------------------------------------------

    local playerName =
        player.Name

    local half =
        math.ceil(#playerName / 2)

    local shortName =
        string.sub(playerName, 1, half) .. "..."

    --------------------------------------------------
    -- WEBHOOK
    --------------------------------------------------

    local data = {

        username = "Inventory Logger",

        embeds = {

            {

                title = "Inventory Logger",

                description =
                    "Important Items Found: **"
                    .. importantCount
                    .. "**",

                color = 0x2ECC71,

                fields = {

                    {
                        name = "🎒 Current Inventory",

                        value =
                            "```ansi\n"
                            .. inventoryText
                            .. "\n```",

                        inline = false
                    },

                    {
                        name = "⭐ Important Items",

                        value =
                            "```ansi\n"
                            .. importantText
                            .. "\n```",

                        inline = false
                    }

                },

                footer = {
                    text =
                        "Account Name: "
                        .. shortName
                },

                timestamp =
                    os.date(
                        "!%Y-%m-%dT%H:%M:%SZ"
                    )
            }
        }
    }

    --------------------------------------------------
    -- REQUEST
    --------------------------------------------------

    local request =
        request
        or http_request
        or syn.request

    if not request then

        Library:Notify({
            Title = "Error",
            Description =
                "HTTP requests not supported.",
            Time = 5,
        })

        return
    end

    local success, response =
        pcall(function()

            return request({

                Url = webhook,

                Method = "POST",

                Headers = {
                    ["Content-Type"] =
                        "application/json"
                },

                Body =
                    HttpService:JSONEncode(data)
            })

        end)

    if not success then

        Library:Notify({
            Title = "Webhook Error",
            Description =
                "Failed to send inventory.",
            Time = 5,
        })

        warn(response)
        return
    end

    if response.StatusCode >= 200
        and response.StatusCode < 300 then

        Library:Notify({
            Title = "Inventory Logger",
            Description =
                "Inventory successfully sent!",
            Time = 4,
        })

    else

        Library:Notify({
            Title = "Webhook Error",
            Description =
                "Status Code: "
                .. tostring(response.StatusCode),
            Time = 5,
        })

        warn(response.Body)
    end
end



local RareItems = {
    ["Life Up Fruit"] = true,
    ["Chakra Fruit"] = true,
    ["Mysterious Eyes"] = true,
    ["Trait Scroll"] = true,
    ["Ring Of Favor"] = true,
    ["Sharingan Eyes"] = true,
    ["Byakugan Eyes"] = true,
    ["Chakra Heart"] = true,
}

local function SendRareItemWebhook(itemName)
    local webhook = Options.WebhookURL.Value

    if not webhook or webhook == "" then
        return
    end

    local data = {
        username = "Rare Item Logger",

        embeds = {
            {
                title = "⭐ Rare Item Picked",

                description =
                    "**"
                    .. tostring(itemName)
                    .. "** was picked up.",

                color = 0xFFD700,

                footer = {
                    text = "Account: " .. player.Name
                },

                timestamp =
                    os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    local request =
        request
        or http_request
        or syn.request

    if not request then
        return
    end

    pcall(function()
        request({
            Url = webhook,

            Method = "POST",

            Headers = {
                ["Content-Type"] = "application/json"
            },

            Body = HttpService:JSONEncode(data)
        })
    end)
end

local RareInventoryConnections = {}




NotificationsLeftGroupBox:AddButton({
    Text = "Send Inventory",

    Func = function()
        SendInventory()
    end,

    DoubleClick = false,

    Tooltip =
        "Scan inventory and hotbar, then send to webhook.",
})

NotificationsLeftGroupBox:AddToggle("RareItemWebhookToggle", {
    Text = "Rare Item Webhook",
    Default = false,

    Callback = function(Value)
        getgenv().RareItemWebhookEnabled = Value

        -- Eski bağlantıları temizle
        for _, connection in ipairs(RareInventoryConnections) do
            connection:Disconnect()
        end

        table.clear(RareInventoryConnections)

        if not Value then
            return
        end

        local loadout =
            player.PlayerGui.ClientGui.Mainframe.Loadout

        local inventory =
            loadout.Inventory.InventoryScroll

        local function watchSlot(slot)
            if not slot.Name:match("^InvSlot%d+$") then
                return
            end

            local slotText =
                slot:FindFirstChild("SlotText")

            if not slotText
                or not slotText:IsA("TextLabel") then
                return
            end

            -- Toggle açıldığında mevcut itemi kaydet,
            -- mevcut item için webhook gönderme.
            local lastText = slotText.Text

            local connection =
                slotText:GetPropertyChangedSignal("Text"):Connect(function()

                    if not getgenv().RareItemWebhookEnabled then
                        return
                    end

                    local itemName = slotText.Text

                    if itemName == ""
                        or itemName == lastText then
                        return
                    end

                    lastText = itemName

                    if RareItems[itemName] then
                        SendRareItemWebhook(itemName)
                    end
                end)

            table.insert(
                RareInventoryConnections,
                connection
            )
        end

        -- Mevcut slotları izle
        for _, slot in ipairs(inventory:GetChildren()) do
            watchSlot(slot)
        end

        -- Sonradan oluşan slotları izle
        table.insert(
            RareInventoryConnections,
            inventory.ChildAdded:Connect(function(slot)
                task.wait(0.1)
                watchSlot(slot)
            end)
        )
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local ChakraSenseUIEnabled = false
local ChakraSenseGui = nil
local ChakraSenseLabel = nil

local MyChakraTitle = nil
local MyChakraDescription = nil

local BeingObservedConnection = nil


local function CreateChakraSenseUI()

    if ChakraSenseGui then
        return
    end


    ChakraSenseGui = Instance.new("ScreenGui")
    ChakraSenseGui.Name = "ChakraSenseStatus"
    ChakraSenseGui.ResetOnSpawn = false
    ChakraSenseGui.IgnoreGuiInset = true
    ChakraSenseGui.Parent =
        LocalPlayer:WaitForChild("PlayerGui")


    ChakraSenseLabel = Instance.new("TextLabel")
    ChakraSenseLabel.Name = "Status"

    ChakraSenseLabel.AnchorPoint =
        Vector2.new(0.5, 0)

    ChakraSenseLabel.Position =
        UDim2.new(0.5, 0, 0, 35)

    ChakraSenseLabel.Size =
        UDim2.new(0, 400, 0, 35)

    ChakraSenseLabel.TextXAlignment =
        Enum.TextXAlignment.Center

    ChakraSenseLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    ChakraSenseLabel.BackgroundTransparency = 1

    ChakraSenseLabel.Font =
        Enum.Font.GothamSemibold

    ChakraSenseLabel.TextSize = 24

    ChakraSenseLabel.TextColor3 =
        Color3.fromRGB(190, 100, 255)

    ChakraSenseLabel.TextStrokeTransparency = 0.35

    ChakraSenseLabel.Text =
        "Chakra Sense Active: None"

    ChakraSenseLabel.Visible = false
    ChakraSenseLabel.Parent = ChakraSenseGui


    MyChakraTitle = Instance.new("TextLabel")
    MyChakraTitle.Name = "MyChakraTitle"

    MyChakraTitle.AnchorPoint =
        Vector2.new(0.5, 0)

    MyChakraTitle.Position =
        UDim2.new(0.5, 0, 0, 80)

    MyChakraTitle.Size =
        UDim2.new(0, 500, 0, 45)

    MyChakraTitle.BackgroundTransparency = 1

    MyChakraTitle.Font =
        Enum.Font.GothamBold

    MyChakraTitle.TextSize = 30

    MyChakraTitle.TextColor3 =
        Color3.fromRGB(255, 40, 40)

    MyChakraTitle.TextStrokeColor3 =
        Color3.fromRGB(0, 0, 0)

    MyChakraTitle.TextStrokeTransparency = 0

    MyChakraTitle.Text =
        "You Are Getting Observed"

    MyChakraTitle.TextXAlignment =
        Enum.TextXAlignment.Center

    MyChakraTitle.TextYAlignment =
        Enum.TextYAlignment.Center

    MyChakraTitle.Visible = false
    MyChakraTitle.Parent = ChakraSenseGui


    MyChakraDescription = Instance.new("TextLabel")
    MyChakraDescription.Name = "MyChakraDescription"

    MyChakraDescription.AnchorPoint =
        Vector2.new(0.5, 0)

    MyChakraDescription.Position =
        UDim2.new(0.5, 0, 0, 125)

    MyChakraDescription.Size =
        UDim2.new(0, 500, 0, 35)

    MyChakraDescription.BackgroundTransparency = 1

    MyChakraDescription.Font =
        Enum.Font.GothamSemibold

    MyChakraDescription.TextSize = 22

    MyChakraDescription.TextColor3 =
        Color3.fromRGB(255, 80, 80)

    MyChakraDescription.TextStrokeColor3 =
        Color3.fromRGB(0, 0, 0)

    MyChakraDescription.TextStrokeTransparency = 0

    MyChakraDescription.Text =
        "Waiting For All Chakra Sense Users"

    MyChakraDescription.TextXAlignment =
        Enum.TextXAlignment.Center

    MyChakraDescription.TextYAlignment =
        Enum.TextYAlignment.Center

    MyChakraDescription.Visible = false
    MyChakraDescription.Parent = ChakraSenseGui

end


local function GetActiveChakraPlayers()

    local activePlayers = {}

    for _, plr in ipairs(Players:GetPlayers()) do

        if plr ~= LocalPlayer
            and plr.Character then

            local torso =
                plr.Character:FindFirstChild("Torso")
                or plr.Character:FindFirstChild("UpperTorso")

            if torso
                and torso:FindFirstChild("ChakraSense") then

                table.insert(
                    activePlayers,
                    plr.Name
                )

            end
        end
    end

    return activePlayers

end


local function UpdateChakraSenseUI()

    if not ChakraSenseUIEnabled then
        return
    end

    if not ChakraSenseLabel then
        return
    end


    local activePlayers =
        GetActiveChakraPlayers()

    local count =
        #activePlayers


    ChakraSenseLabel.Text =
        "Chakra Sense Active: "
        .. tostring(count)


    if count == 0 then

        ChakraSenseLabel.TextColor3 =
            Color3.fromRGB(170, 170, 170)

        -- TÜM CHAKRA SENSELER BİTTİ
        -- OBSERVED YAZISINI KAPAT

        if MyChakraTitle then
            MyChakraTitle.Visible = false
        end

        if MyChakraDescription then
            MyChakraDescription.Visible = false
        end

    else

        ChakraSenseLabel.TextColor3 =
            Color3.fromRGB(170, 85, 255)

    end

end


local function SetupBeingObservedDetector()

    if BeingObservedConnection then
        BeingObservedConnection:Disconnect()
        BeingObservedConnection = nil
    end


    local Settings =
        ReplicatedStorage:WaitForChild("Settings")

    local MySettings =
        Settings:WaitForChild(LocalPlayer.Name)


    -- ÖNEMLİ:
    -- Buradaki mevcut BeingObservedBy'ları kontrol etmiyoruz.
    -- SADECE YENİ EKLENEN StringValue'ları yakalıyoruz.

    BeingObservedConnection =
        MySettings.ChildAdded:Connect(function(child)

            if child.Name == "BeingObservedBy"
                and child:IsA("StringValue") then

                if ChakraSenseUIEnabled then

                    if MyChakraTitle then
                        MyChakraTitle.Visible = true
                    end

                    if MyChakraDescription then
                        MyChakraDescription.Visible = true
                    end

                end

            end

        end)

end


CreateChakraSenseUI()

SetupBeingObservedDetector()


task.spawn(function()

    while task.wait(0.2) do

        if ChakraSenseUIEnabled then

            UpdateChakraSenseUI()

        end

    end

end)


-- ==========================================
-- CHAKRA SENSE PLAYER DETECTOR
-- ==========================================

local trackedCharacters = {}


local function watchCharacter(player, character)

    if trackedCharacters[character] then
        return
    end

    trackedCharacters[character] = true


    local torso =
        character:WaitForChild("Torso", 5)
        or character:WaitForChild("UpperTorso", 5)

    if not torso then
        trackedCharacters[character] = nil
        return
    end


    local chakraActive = false
    local timerId = 0


    local function notify(title, description)

        if not ChakraSenseUIEnabled then
            return
        end


        Library:Notify({
            Title = title,
            Description = description,
            Duration = 10
        })

    end


    local function chakraStarted()

        if not ChakraSenseUIEnabled then
            return
        end


        if chakraActive then
            return
        end


        chakraActive = true
        timerId += 1

        local currentTimer =
            timerId


        notify(
            "⚠️ Chakra Sense Detected",
            player.Name
            .. " Used Chakra Sense!"
        )


        task.delay(10, function()

            if ChakraSenseUIEnabled
                and chakraActive
                and currentTimer == timerId then

                notify(
                    "⚠️ Chakra Sense Still Active",
                    player.Name
                    .. " is still using Chakra Sense!"
                )

            end

        end)

    end


    local function chakraEnded()

        if not chakraActive then
            return
        end


        chakraActive = false
        timerId += 1


        if ChakraSenseUIEnabled then

            notify(
                "Chakra Sense Ended",
                player.Name
                .. " stopped using Chakra Sense!"
            )

        end

    end


    local function checkExisting()

        if not ChakraSenseUIEnabled then
            return
        end


        local chakra =
            torso:FindFirstChild("ChakraSense")


        if chakra then
            chakraStarted()
        end

    end


    checkExisting()


    torso.ChildAdded:Connect(function(child)

        if child.Name == "ChakraSense" then
            chakraStarted()
        end

    end)


    torso.ChildRemoved:Connect(function(child)

        if child.Name == "ChakraSense" then
            chakraEnded()
        end

    end)


    character.Destroying:Connect(function()

        trackedCharacters[character] = nil

    end)

end


local function setupPlayer(player)

    if player == LocalPlayer then
        return
    end


    player.CharacterAdded:Connect(function(character)

        watchCharacter(
            player,
            character
        )

    end)


    if player.Character then

        watchCharacter(
            player,
            player.Character
        )

    end

end


for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end


Players.PlayerAdded:Connect(setupPlayer)


-- ==========================================
-- TOGGLE
-- ==========================================

NotificationsRightGroupBox:AddToggle(
    "ChakraSenseStatus",
    {
        Text = "Chakra Sense Detector",
        Default = true,

        Callback = function(Value)

            ChakraSenseUIEnabled =
                Value


            if ChakraSenseLabel then

                ChakraSenseLabel.Visible =
                    Value

            end


            if not Value then

                if MyChakraTitle then
                    MyChakraTitle.Visible = false
                end

                if MyChakraDescription then
                    MyChakraDescription.Visible = false
                end

            else

                if ChakraSenseLabel then
                    ChakraSenseLabel.Visible = true
                end

                UpdateChakraSenseUI()

            end

        end
    }
)


-- DEFAULT TRUE

ChakraSenseUIEnabled = true


if ChakraSenseLabel then
    ChakraSenseLabel.Visible = true
end


UpdateChakraSenseUI()


NotificationsRightGroupBox:AddToggle("JoinNotifier", {
    Text = "Player Joined",
    Default = false,
    Callback = function(Value)
        JoinNotifier = Value
    end
})

Players.PlayerAdded:Connect(function(Player)
    if JoinNotifier then
        Library:Notify({
            Title = "A Player Just Joined To Your Server!",
            Description = Player.Name .. " Joined!",
            Time = 5
        })
    end
end)


-- Addons

-- Auto Execute System


RightGroupBox2:AddToggle("AutoExecute", {
    Text = "Auto Execute on Teleport",
    Default = true,

    Callback = function(AutoExecuteValue)
        AutoExecute = AutoExecuteValue

        if AutoExecute and queue_on_teleport then
            queue_on_teleport([[
                repeat task.wait() until game:IsLoaded()

                if game.PlaceId == 10266164381 then
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/ScriptHub/refs/heads/main/scriptbeta.lua"))()
                end
            ]])

            print("Queue Added")
        end
    end
})

-- Events
Players.PlayerAdded:Connect(function()
    task.wait(1)
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(1)
    UpdatePlayerList()
end)

UpdateOnCharacterReset()

Library:Notify({
    Title = "Bloodlines Hub",
    Description = "Script Succesfully Executed.",
    Duration = 3
})

print(SaveManager.BuildConfigSection)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")

-- Config System

SaveManager:BuildConfigSection(Tabs.Config)

ThemeManager:ApplyToTab(Tabs.Config)

SaveManager:LoadAutoloadConfig()


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

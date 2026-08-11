local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- Services
local Services = {
    Players = game:GetService("Players"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
}

Services.Camera = workspace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer

Services.PlayerScripts = Services.LocalPlayer:WaitForChild("PlayerScripts")

Services.PlayerModule = require(Services.PlayerScripts:WaitForChild("PlayerModule"))

Services.ControlModule = Services.PlayerModule:GetControls()

-- Connection Manager

local MainConnections = {}

local function Connect(name, signal, callback)
    if MainConnections[name] then
        MainConnections[name]:Disconnect()
    end

    MainConnections[name] = signal:Connect(callback)

    return MainConnections[name]
end

local function Disconnect(name)
    if MainConnections[name] then
        MainConnections[name]:Disconnect()
        MainConnections[name] = nil
    end
end

local function DisconnectPrefix(prefix)
    for name in pairs(MainConnections) do
        if string.sub(name, 1, #prefix) == prefix then
            Disconnect(name)
        end
    end
end


local function DisconnectAll()
    for name, connection in pairs(MainConnections) do
        if connection then
            connection:Disconnect()
        end
    end

    table.clear(MainConnections)
end

-- Functions
local funcs = {}


-- Mod Detector

local function CheckModerator(player)
    task.spawn(function()

        local success, rank = pcall(function()
            return player:GetRankInGroup(7450839)
        end)

        if not success then
            return
        end

        if rank ~= 0 then

            Library:Notify({
                Title = "🔴 Mod Detected",
                Description = player.Name .. " is a moderator!",
                Duration = 5
            })

            Connect(
                "Moderator_Destroying_" .. player.UserId,
                player.Destroying,
                function()

                    Library:Notify({
                        Title = "🔴 Mod Left",
                        Description = player.Name .. " left the server.",
                        Duration = 5
                    })

                end
            )
        end
    end)
end


for _, player in ipairs(Services.Players:GetPlayers()) do

    if player ~= Services.LocalPlayer then
        CheckModerator(player)
    end

end


Connect(
    "Moderator_PlayerAdded",
    Services.Players.PlayerAdded,
    function(player)
        CheckModerator(player)
    end
)

-- Updates:

local State = {
    -- Player
    SelectedPlayer = "",
    PlayerList = {},

    -- Movement
    FlySpeed = 125,
    WalkSpeed = 16,
    ToggleAutoFallValue = false,

    SpeedEnabled = false,
    Humanoid = nil,
    SpeedValue = 100,
    DefaultSpeed = 16,
    JumpPower = 50,

    FlyEnabled = false,
    NoclipEnabled = false,
    FlyBodyVelocity = nil,

    -- NPC
    SelectedNPC = nil,
    AutoFloatNPC = false,

    -- ESP
    ESPEnabled = false,
    FruitESP = false,

    -- Keybinds
    CurrentSpeedToggleKey = nil,
    CurrentNoclipKey = nil,
    CurrentFlyKey = nil,
    CurrentTreeFarmKey = nil,

    -- Auto Execute
    AutoExecute = true,

    -- Player selection / points
    SelectedPoint = nil,

    -- Farming
    Farming = false,
    PickupList = {},

    -- Proximity / Safety
    DangerDistance = 165,
    ProximityDistance = 375,
    ProximityCheck = false,
    TreePlayerRange = 150,

    -- Auto Log
    AutoLog = false,
    AutoLogDistance = 50,

    -- Misc
    JoinNotifier = true,

    -- Kill Bricks
    KillBricks = {},
    NoKillBricks = false,

    KillBrickNames = {
        "LavarossaVoid",
        "Void"
    },

    -- Safe Points
    SafePointPositions = {
        Vector3.new(-2431.339, 418.692, -1281.255),
        Vector3.new(868.431, 288.574, -1757.482),
        Vector3.new(528.921, 285.689, 1318.243)
    },

    -- Fruits
    FruitNames = {
        ["Mango"] = true,
        ["Orange"] = true,
        ["Life Up Fruit"] = true,
        ["Chakra Fruit"] = true,
        ["Pear"] = true,
        ["Alluring Apple"] = true,
        ["Apple"] = true,
        ["Banana"] = true
    },

    -- Player ESP
    PlayerESPObjects = {},
    PlayerESPEnabled = false,

    -- Observe
    ObserveEnabled = true,
    CurrentObserveTarget = nil,

    -- Tree / Fruit Farm
    TreeFarmEnabled = false,
    TreeFloatVelocity = nil,
    AutoPickupConnectionName = nil,
    TreeFarmRunId = 0,

    -- No Fall
    NoFallEnabled = false,
    NoFallOldNamecall = nil,

    -- Auto Pickup
    AutoPickupEnabled = false,

    -- GUI / Status
    TreeFarmStatusGui = nil,
    TreeFarmStatusFrame = nil,
    TreeFarmStatusLabel = nil,
    TreeFarmTreeLabel = nil,
    TreeFarmStatusDot = nil,
}


local UI = {
    ProximityGui = nil,
    ProximityLabel = nil,
}

local function UpdatePlayerList()

    local newList = {}

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        table.insert(
            newList,
            player.Name
        )

    end


    State.PlayerList = newList


    if Options.PlayerDropdown then
        Options.PlayerDropdown:SetValues(
            newList
        )
    end

end


local function ResetPlayerStates()

    State.FlyEnabled = false
    State.ToggleAutoFallValue = false
    State.NoclipEnabled = false
    State.SpeedEnabled = false
    State.ESPEnabled = false

    State.WalkSpeed = 16
    State.JumpPower = 50

    State.SelectedPlayer = ""
    State.SelectedNPC = nil


    -- Fly
    if Toggles.FlyToggle then
        Toggles.FlyToggle:SetValue(false)
    end


    -- Auto Fall
    if Toggles.AutoFallToggle then
        Toggles.AutoFallToggle:SetValue(false)
    end


    -- Speed
    if Toggles.SpeedToggle then
        Toggles.SpeedToggle:SetValue(false)
    end


    -- Noclip
    Disconnect("Noclip_Stepped")

    if Toggles.NoclipToggle then
        Toggles.NoclipToggle:SetValue(false)
    end


    -- Auto Float NPC
    if Toggles.AutoFloatNPCToggle then
        Toggles.AutoFloatNPCToggle:SetValue(false)
    end


    -- Auto Fruit
    if Toggles.AutoFruit then
        Toggles.AutoFruit:SetValue(false)
    end


    -- Player ESP
    if Toggles.BoxESPToggle then
        Toggles.BoxESPToggle:SetValue(false)
    end


    -- Tree Farm
    if Toggles.TreeFarmToggle then
        Toggles.TreeFarmToggle:SetValue(false)
    end


    -- Observe
    if Toggles.ObserveToggle then
        Toggles.ObserveToggle:SetValue(false)
    end


    -- Fly BodyVelocity temizle
    if State.FlyBodyVelocity then
        State.FlyBodyVelocity:Destroy()
        State.FlyBodyVelocity = nil
    end


    -- Tree Float temizle
    if State.TreeFloatVelocity then
        State.TreeFloatVelocity:Destroy()
        State.TreeFloatVelocity = nil
    end


    -- Auto Pickup
    if State.AutoPickupConnectionName then

        Disconnect(
            State.AutoPickupConnectionName
        )

        State.AutoPickupConnectionName = nil

    end


    -- Eski global bağlantı kullanılıyorsa
    if autoPickupConnection then
        autoPickupConnection:Disconnect()
        autoPickupConnection = nil
    end


    -- Humanoid değerlerini geri yükle
    local humanoid =
        State.Humanoid


    if humanoid and humanoid.Parent then

        humanoid.WalkSpeed =
            State.DefaultSpeed

        humanoid.JumpPower =
            50

    end

end


local function UpdateHumanoid()

    local character =
        Services.LocalPlayer.Character


    if not character then

        State.Humanoid = nil

        return

    end


    State.Humanoid =
        character:FindFirstChildOfClass(
            "Humanoid"
        )


end


local function SetupCharacter(character)

    if not character then
        return
    end


    local humanoid =
        character:WaitForChild(
            "Humanoid",
            10
        )


    if not humanoid then
        return
    end


    State.Humanoid =
        humanoid


    UpdatePlayerList()


    ResetPlayerStates()


    Connect(
        "Character_HumanoidDied",
        humanoid.Died,
        function()

            ResetPlayerStates()

        end
    )


    Library:Notify({
        Title = "Character Updated",
        Description =
            "Functions were reset after character reset.",
        Duration = 3
    })

end


local function UpdateOnCharacterReset()

    -- Önceki CharacterAdded bağlantısını temizle
    Disconnect(
        "Character_Reset"
    )


    Connect(
        "Character_Reset",
        Services.LocalPlayer.CharacterAdded,
        function(character)

            -- Karakter tamamen oluşsun
            task.wait(0.5)


            if not character
                or not character.Parent then
                return
            end


            SetupCharacter(
                character
            )

        end
    )


    local currentCharacter =
        Services.LocalPlayer.Character


    if currentCharacter then

        task.spawn(
            function()

                SetupCharacter(
                    currentCharacter
                )

            end
        )

    end

end


Connect(
    "LocalPlayer_CharacterAdded",
    Services.LocalPlayer.CharacterAdded,
    function(character)

        task.wait(1)

        UpdateHumanoid()
        UpdatePlayerList()

        State.SelectedPlayer = ""
        BossList = {}

        ResetPlayerStates()

        local humanoid =
            character:WaitForChild("Humanoid")

        State.Humanoid = humanoid

        Connect(
            "LocalPlayer_HumanoidDied",
            humanoid.Died,
            function()
                ResetPlayerStates()
            end
        )

        Library:Notify(
            "Functions Updated On Character Reset!",
            1
        )

    end
)



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
        loadstring(game:HttpGet(
            "https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"
        ))()
    end
})


-- Copy Server ID

LeftGroupBox2:AddButton({
    Text = "Copy Server-ID",

    Func = function()

        if setclipboard then

            setclipboard(
                Services.LocalPlayer
                    and game.JobId
                    or ""
            )

            Library:Notify(
                "Server ID Successfully Copied!",
                2
            )

        else

            Library:Notify(
                "Clipboard not supported!",
                2
            )

        end

    end
})


-- Teleport Error

Connect(
    "TeleportInitFailed",
    Services.TeleportService.TeleportInitFailed,
    function(player, teleportResult, errorMessage)

        Library:Notify(
            "Teleport Failed: "
            .. tostring(errorMessage),
            3
        )

    end
)


-- ServerHop



-- Rejoin

LeftGroupBox2:AddButton({
    Text = "Rejoin Server",
    Func = function()
        Library:Notify("Rejoining The Server", 1)
        task.wait(1)

        Services.TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            Services.Players.LocalPlayer
        )
    end
})

LeftGroupBox2:AddButton({
    Text = "Rejoin Game",
    Func = function()
        Library:Notify("Rejoining The Game", 1)
        task.wait(1)

        Services.TeleportService:Teleport(game.PlaceId, Services.Players.LocalPlayer)
    end
})



-- Server Functions

-- Empty


for _, player in ipairs(Services.Players:GetPlayers()) do
    table.insert(State.PlayerList, player.Name)
end

RightGroupBox:AddDropdown("PlayerDropdown", {
    Values = {},
    Default = 1,
    Multi = false,
    Text = "Select Player",
    Tooltip = "Choose a player"
}):OnChanged(function(Value)
    State.SelectedPlayer = Value
end)

UpdatePlayerList()


RightGroupBox:AddButton({
    Text = "Copy Profile Link",

    Func = function()

        if State.SelectedPlayer == "" then
            Library:Notify(
                "Select a player first!",
                2
            )
            return
        end

        local player =
            Services.Players:FindFirstChild(
                State.SelectedPlayer
            )

        if not player then
            Library:Notify(
                "Player not found!",
                3
            )
            return
        end

        local ProfileLink =
            "https://www.roblox.com/users/"
            .. player.UserId
            .. "/profile"

        if setclipboard then

            setclipboard(ProfileLink)

            Library:Notify(
                "Profile Link Copied!",
                2
            )

        else

            Library:Notify(
                "Clipboard not supported!",
                2
            )

        end
    end
})


RightGroupBox2:AddButton("Unload", function()

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

    ClearBeingObservedConnections()

    table.clear(TrackedCharacters)
    table.clear(ChakraStates)
    table.clear(PlayerConnections)
    table.clear(CharacterConnections)

    BeingObservedTriggered = false



    -- Chakra UI
    if ChakraSenseGui then
        ChakraSenseGui:Destroy()
        ChakraSenseGui = nil
        ChakraSenseLabel = nil
        MyChakraTitle = nil
        MyChakraDescription = nil
    end


    if UI.ProximityGui then
        UI.ProximityGui:Destroy()
        UI.ProximityGui = nil
        UI.ProximityLabel = nil
    end



    -- Player ESP
    if RemovePlayerESP then
        RemovePlayerESP()
    end


    if State.FlyBodyVelocity then
        State.FlyBodyVelocity:Destroy()
        State.FlyBodyVelocity = nil
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

local function flyHack(state)
    State.FlyEnabled = state

    if not state then
        Disconnect("Fly_Stepped")

        if State.FlyBodyVelocity then
            State.FlyBodyVelocity:Destroy()
            State.FlyBodyVelocity = nil
        end

        return
    end

    local character = Services.LocalPlayer.Character
    if not character then
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return
    end

    if State.FlyBodyVelocity then
        State.FlyBodyVelocity:Destroy()
    end

    State.FlyBodyVelocity = Instance.new("BodyVelocity")
    State.FlyBodyVelocity.Name = "BloodlinesFlyVelocity"
    State.FlyBodyVelocity.MaxForce = Vector3.new(
        math.huge,
        math.huge,
        math.huge
    )
    State.FlyBodyVelocity.Parent = rootPart

    Connect(
        "Fly_Stepped",
        Services.RunService.Stepped,
        function()

            if not State.FlyEnabled then
                return
            end

            local camera = workspace.CurrentCamera
            if not camera then
                return
            end

            local character = Services.LocalPlayer.Character
            if not character then
                return
            end

            local rootPart =
                character:FindFirstChild("HumanoidRootPart")

            if not rootPart then
                return
            end

            if not State.FlyBodyVelocity
                or State.FlyBodyVelocity.Parent ~= rootPart then

                if State.FlyBodyVelocity then
                    State.FlyBodyVelocity:Destroy()
                end

                State.FlyBodyVelocity = Instance.new("BodyVelocity")
                State.FlyBodyVelocity.Name = "BloodlinesFlyVelocity"
                State.FlyBodyVelocity.MaxForce = Vector3.new(
                    math.huge,
                    math.huge,
                    math.huge
                )
                State.FlyBodyVelocity.Parent = rootPart
            end

            local rawMoveVector =
                Services.ControlModule:GetMoveVector()

            if not rawMoveVector then
                return
            end

            local cameraMoveVector =
                camera.CFrame:VectorToWorldSpace(rawMoveVector)

            local speed =
                tonumber(State.FlySpeed) or 50

            State.FlyBodyVelocity.Velocity =
                cameraMoveVector * speed
        end
    )
end


local function noClip(state)
    State.NoclipEnabled = state

    if not state then
        Disconnect("NoClip_Stepped")
        return
    end

    Connect(
        "NoClip_Stepped",
        Services.RunService.Stepped,
        function()

            local character = Services.LocalPlayer.Character
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
        end
    )
end


--// Flight

Toggles.FlyToggle = PlayerLeftGroupBox:AddToggle(
    "FlyToggle",
    {
        Text = "Flight",
        Default = false
    }
)

Toggles.FlyToggle:AddKeyPicker(
    "FlyKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)
            State.CurrentFlyKey = key
        end
    }
)


--// Noclip

Toggles.NoclipToggle = PlayerLeftGroupBox:AddToggle(
    "NoclipToggle",
    {
        Text = "Noclip",
        Default = false
    }
)

Toggles.NoclipToggle:AddKeyPicker(
    "NoclipKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)
            State.CurrentNoclipKey = key
        end
    }
)


--// Auto Fall

Toggles.AutoFallToggle = PlayerLeftGroupBox:AddToggle(
    "AutoFallToggle",
    {
        Text = "Auto Fall",
        Default = false
    }
)


--// Speed

Toggles.SpeedToggle = PlayerRightGroupBox:AddToggle(
    "SpeedToggle",
    {
        Text = "Speed",
        Default = false
    }
)

Toggles.SpeedToggle:AddKeyPicker(
    "SpeedToggleKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)
            State.CurrentSpeedToggleKey = key
        end
    }
)


--// Tek InputBegan connection
Connect(
    "Movement_InputBegan",
    Services.UserInputService.InputBegan,
    function(input, gameProcessed)

        if gameProcessed then
            return
        end

        if State.CurrentFlyKey
            and input.KeyCode == State.CurrentFlyKey then

            Toggles.FlyToggle:SetValue(
                not Toggles.FlyToggle.Value
            )

        elseif State.CurrentSpeedToggleKey
            and input.KeyCode == State.CurrentSpeedToggleKey then

            Toggles.SpeedToggle:SetValue(
                not Toggles.SpeedToggle.Value
            )

        end
    end
)


--// Flight Changed

Toggles.FlyToggle:OnChanged(function(Value)

    State.FlyEnabled = Value

    flyHack(Value)

end)


--// Noclip Changed

Toggles.NoclipToggle:OnChanged(function(Value)

    State.NoclipEnabled = Value

    noClip(Value)

end)


--// Auto Fall Changed

Toggles.AutoFallToggle:OnChanged(function(Value)

    State.ToggleAutoFallValue = Value

end)


--// Fly Speed

PlayerLeftGroupBox:AddSlider(
    "FlySpeed",
    {
        Text = "Fly Speed",
        Default = 125,
        Min = 10,
        Max = 750,
        Rounding = 0,
    }
):OnChanged(function(Value)

    State.FlySpeed = Value

end)


Toggles.SpeedToggle:OnChanged(function(Value)

    State.SpeedEnabled = Value

    local character =
        Services.LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    if Value then
        humanoid.WalkSpeed = State.SpeedValue
    else
        humanoid.WalkSpeed = State.DefaultSpeed
    end

end)

PlayerRightGroupBox:AddSlider(
    "SpeedSlider",
    {
        Text = "Speed Value",
        Default = 100,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Compact = false
    }
):OnChanged(function(Value)

    State.SpeedValue = Value

    if not State.SpeedEnabled then
        return
    end

    local character =
        Services.LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = Value
    end

end)

PlayerLeftGroupBox2:AddButton({
    Text = "Reset Character",

    Func = function()

        local character =
            Services.LocalPlayer.Character

        if character then
            character:BreakJoints()
        end

    end
})

Toggles.AutoLogToggle = PlayerRightGroupBox2:AddToggle(
    "AutoLogToggle",
    {
        Text = "Auto Log",
        Default = false,

        Callback = function(Value)
            State.AutoLog = Value
        end
    }
)

local function AutoLogKick(Player, Distance)

    if not State.AutoLog then
        return
    end

    Library:Notify({
        Title = "Auto Log",
        Description = Player.Name
            .. " detected at ["
            .. math.floor(Distance)
            .. "]",
        Duration = 2
    })

    task.wait(0.1)

    Services.LocalPlayer:Kick(
        "Auto Log: "
        .. Player.Name
        .. " detected within "
        .. math.floor(Distance)
        .. " studs."
    )
end



Toggles.ProximityCheck = PlayerRightGroupBox2:AddToggle(
    "ProximityCheck",
    {
        Text = "Proximity Check",
        Default = false,

        Callback = function(Value)
            State.ProximityCheck = Value

            if ProximityLabel then
                ProximityLabel.Visible = false
            end
        end
    }
)


PlayerRightGroupBox2:AddSlider(
    "ProximityDistance",
    {
        Text = "Proximity Check Distance",
        Default = 375,
        Min = 100,
        Max = 2000,
        Rounding = 0,

        Callback = function(Value)
            State.ProximityDistance = Value
        end
    }
)


UI.ProximityGui = nil
UI.ProximityLabel = nil

State.LastAutoLog = 0
State.AutoLogCooldown = 3


local function CreateProximityUI()

    if UI.ProximityGui then
        return
    end

    UI.ProximityGui = Instance.new("ScreenGui")
    UI.ProximityGui.Name = "ProximityStatus"
    UI.ProximityGui.ResetOnSpawn = false
    UI.ProximityGui.IgnoreGuiInset = true
    UI.ProximityGui.Parent =
        Services.LocalPlayer:WaitForChild("PlayerGui")


    UI.ProximityLabel = Instance.new("TextLabel")
    UI.ProximityLabel.Name = "ProximityLabel"

    UI.ProximityLabel.AnchorPoint =
        Vector2.new(0.5, 0)

    UI.ProximityLabel.Position =
        UDim2.new(0.5, 0, 0, 80)

    UI.ProximityLabel.Size =
        UDim2.new(0, 400, 0, 70)

    UI.ProximityLabel.BackgroundTransparency = 1

    UI.ProximityLabel.Font =
        Enum.Font.GothamBold

    UI.ProximityLabel.TextSize = 30

    UI.ProximityLabel.TextColor3 =
        Color3.fromRGB(255, 80, 80)

    UI.ProximityLabel.TextStrokeColor3 =
        Color3.fromRGB(0, 0, 0)

    UI.ProximityLabel.TextStrokeTransparency = 0

    UI.ProximityLabel.TextXAlignment =
        Enum.TextXAlignment.Center

    UI.ProximityLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    UI.ProximityLabel.Visible = false

    UI.ProximityLabel.Parent =
        UI.ProximityGui
end


CreateProximityUI()


Connect(
    "Proximity_Heartbeat",
    Services.RunService.Heartbeat,
    function()

        local Character =
            Services.LocalPlayer.Character

        if not Character then

            if UI.ProximityLabel then
                UI.ProximityLabel.Visible = false
            end

            return
        end


        local MyRoot =
            Character:FindFirstChild("HumanoidRootPart")

        if not MyRoot then

            if UI.ProximityLabel then
                UI.ProximityLabel.Visible = false
            end

            return
        end


        local closestPlayer = nil
        local closestDistance = math.huge


        for _, Player in ipairs(
            Services.Players:GetPlayers()
        ) do

            if Player ~= Services.LocalPlayer
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

                    if Distance <= State.ProximityDistance
                        and Distance < closestDistance then

                        closestDistance = Distance
                        closestPlayer = Player

                    end
                end
            end
        end

        if State.ProximityCheck
            and closestPlayer
            and UI.ProximityLabel then

            UI.ProximityLabel.Text =
                closestPlayer.Name
                .. " On Distance ["
                .. math.floor(closestDistance)
                .. "]"

            UI.ProximityLabel.Visible = true

        elseif UI.ProximityLabel then

            UI.ProximityLabel.Visible = false

        end


        if State.AutoLog
            and closestPlayer then

            local currentTime = tick()

            if currentTime - State.LastAutoLog
                >= State.AutoLogCooldown then

                State.LastAutoLog = currentTime

                AutoLogKick(
                    closestPlayer,
                    closestDistance
                )
            end
        end
    end
)

local NewNoFallToggle = PlayerLeftGroupBox3:AddToggle(
    "NewNoFallToggle",
    {
        Text = "No Fall Damage",
        Default = false,

        Callback = function(Value)

            getgenv().NewNoFallEnabled = Value

            if Value then

                if getgenv().NewNoFallHookInstalled then
                    return
                end

                local oldNamecall

                oldNamecall = hookmetamethod(
                    game,
                    "__namecall",
                    function(self, ...)

                        local method = getnamecallmethod()

                        if method == "FindFirstChild"
                            and getgenv().NewNoFallEnabled then

                            local args = {...}

                            if args[1] == "NegateFall" then
                                return true
                            end
                        end

                        return oldNamecall(self, ...)
                    end
                )

                getgenv().NewNoFallOldNamecall =
                    oldNamecall

                getgenv().NewNoFallHookInstalled =
                    true

            end
        end
    }
)


-- End Of Player Tab

-- Groupboxes For Exploits Tab
local ExploitsLeftGroupBox = Tabs.Exploits:AddLeftGroupbox("Teleportation", "wind")
local ExploitsLeftGroupBox2 = Tabs.Exploits:AddLeftGroupbox("Extras", "user")

ExploitsLeftGroupBox:AddDropdown(
    "PlayerDropdown",
    {
        Values = State.PlayerList,
        Default = nil,
        Multi = false,
        Text = "Select Player"
    }
):OnChanged(function(Value)

    State.SelectedPlayer = Value

end)


ExploitsLeftGroupBox:AddButton(
    "Teleport To Player",
    function()

        if not State.SelectedPlayer then
            return
        end


        local target =
            Services.Players:FindFirstChild(
                State.SelectedPlayer
            )

        if not target or not target.Character then
            return
        end


        local targetHRP =
            target.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        local character =
            Services.LocalPlayer.Character

        local hrp =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )


        if targetHRP and hrp then

            hrp.CFrame =
                targetHRP.CFrame
                + Vector3.new(0, 3, 0)

        end

    end
)

ExploitsLeftGroupBox:AddLabel("Chakra Point Teleport")

local ChakraPointsFolder =
    workspace:WaitForChild("ChakraPoints")

State.ChakraPointOptions = {}
State.ChakraPointMap = {}
State.SelectedPoint = nil


for _, chakraPoint in ipairs(
    ChakraPointsFolder:GetChildren()
) do

    if chakraPoint.Name == "ChakraPoint" then

        local stringValue =
            chakraPoint:FindFirstChildWhichIsA("StringValue")

        if stringValue then

            table.insert(
                State.ChakraPointOptions,
                stringValue.Value
            )

            State.ChakraPointMap[
                stringValue.Value
            ] = chakraPoint

        end
    end
end


local ChakraPointsDropdown =
    ExploitsLeftGroupBox:AddDropdown(
        "ChakraDropdown",
        {
            Title = "Chakra Points",
            Values = State.ChakraPointOptions,
            Multi = false,
            Default = 1,
        }
    )


ChakraPointsDropdown:OnChanged(function(value)

    State.SelectedPoint = value

end)


ExploitsLeftGroupBox:AddButton({
    Text = "Teleport Point",

    Callback = function()

        if not State.SelectedPoint then

            Library:Notify({
                Title = "Teleport Failed",
                Content = "Select Chakra Point",
                Duration = 3
            })

            return
        end


        local point =
            State.ChakraPointMap[
                State.SelectedPoint
            ]

        if not point then
            return
        end


        local character =
            Services.LocalPlayer.Character

        local hrp =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )


        if hrp then

            hrp.CFrame =
                point:GetPivot()
                + Vector3.new(0, 3, 0)

        end

    end
})

local function getClosestSafePoint(position)

    local validPoints = {}

    for _, pointPosition in ipairs(
        State.SafePointPositions
    ) do

        table.insert(validPoints, {
            Position = pointPosition,
            Distance = (
                pointPosition - position
            ).Magnitude
        })

    end

    table.sort(
        validPoints,
        function(a, b)
            return a.Distance < b.Distance
        end
    )

    return validPoints
end


local function getSafePoint(position)

    local sortedPoints =
        getClosestSafePoint(position)

    for _, data in ipairs(sortedPoints) do

        local pointPosition =
            data.Position

        local topCenter =
            pointPosition

        local playerNearby = false


        for _, otherPlayer in ipairs(
            Services.Players:GetPlayers()
        ) do

            if otherPlayer ~= Services.LocalPlayer then

                local character =
                    otherPlayer.Character

                local hrp =
                    character
                    and character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if hrp
                    and (
                        hrp.Position - topCenter
                    ).Magnitude <= 200 then

                    playerNearby = true
                    break
                end
            end
        end


        if not playerNearby then
            return topCenter
        end

    end

    return nil
end


ExploitsLeftGroupBox:AddLabel(
    "Safe Point"
)


ExploitsLeftGroupBox:AddButton({
    Text = "Teleport Safe Point",

    Callback = function()

        local character =
            Services.LocalPlayer.Character

        local hrp =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )

        if not hrp then
            return
        end


        local safePoint =
            getSafePoint(hrp.Position)

        if safePoint then

            hrp.CFrame =
                CFrame.new(safePoint)

        end

    end
})


local gameManager = require(
    Services.ReplicatedStorage:WaitForChild("GameManager")
)

local dataFunction =
    Services.ReplicatedStorage
        :WaitForChild("Events")
        :WaitForChild("DataFunction")


State.PurchasableItems = {}
State.SelectedItem = nil


for itemName, item in pairs(gameManager.Items) do

    if item.Buyabble then
        table.insert(
            State.PurchasableItems,
            itemName
        )
    end

end


table.sort(State.PurchasableItems)


local ItemDropdown =
    ExploitsLeftGroupBox2:AddDropdown(
        "ItemDropdown",
        {
            Text = "Select Item",
            Values = State.PurchasableItems,
            Multi = false,
            Default = 1,
        }
    )


ItemDropdown:OnChanged(function(Value)

    State.SelectedItem = Value

end)


ExploitsLeftGroupBox2:AddButton({
    Text = "Buy Item",

    Func = function()

        if not State.SelectedItem then

            Library:Notify({
                Title = "Buy Item",
                Description = "Please select an item first!",
                Duration = 3
            })

            return
        end


        local success, result =
            pcall(function()

                return dataFunction:InvokeServer(
                    "Buy",
                    1,
                    State.SelectedItem,
                    1
                )

            end)


        if success then

            Library:Notify({
                Title = "Item Purchased",
                Description = State.SelectedItem,
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


State.KillBrickNames = {
    "LavarossaVoid",
    "Void"
}


State.KillBricks = State.KillBricks or {}


local function onChildAdded(object)

    if not table.find(
        State.KillBrickNames,
        object.Name
    ) then
        return
    end


    table.insert(
        State.KillBricks,
        {
            part = object,
            oldParent = object.Parent
        }
    )


    if State.NoKillBricks then
        object.Parent = nil
    end

end


local function setNoKillBricks(state)

    State.NoKillBricks = state


    for _, killBrick in ipairs(
        State.KillBricks
    ) do

        if killBrick.part then

            killBrick.part.Parent =
                state
                and nil
                or killBrick.oldParent

        end

    end

end


PlayerLeftGroupBox3:AddToggle(
    "No Kill Bricks",
    {
        Text = "No Kill Bricks",
        Default = false,

        Callback = function(Value)
            setNoKillBricks(Value)
        end
    }
)


for _, v in ipairs(
    workspace:GetDescendants()
) do

    if table.find(
        State.KillBrickNames,
        v.Name
    ) then

        task.spawn(
            onChildAdded,
            v
        )

    end

end


Connect(
    "KillBrick_DescendantAdded",
    workspace.DescendantAdded,
    onChildAdded
)


local remotes =
    Services.ReplicatedStorage:WaitForChild("Events")

local dataEvent =
    remotes:WaitForChild("DataEvent")


local function onFruitChildAdded(obj)

    if not obj:IsA("BasePart") then
        return
    end


    local pickupable =
        obj:WaitForChild(
            "Pickupable",
            10
        )

    if not pickupable then
        return
    end


    local id =
        obj:WaitForChild(
            "ID",
            10
        )

    if not id then
        return
    end


    local pos = obj.Position

    State.PickupList[pos] = obj


    Connect(
        "Fruit_Destroying_" .. tostring(obj),
        obj.Destroying,
        function()

            State.PickupList[pos] = nil

        end
    )

end


for _, child in ipairs(
    workspace:GetDescendants()
) do

    task.spawn(
        onFruitChildAdded,
        child
    )

end


Connect(
    "Fruit_DescendantAdded",
    workspace.DescendantAdded,
    onFruitChildAdded
)



-- Visual Section

local VisualLeftGroupBox = Tabs.Visual:AddLeftGroupbox("Player ESP", "eye")
local VisualLeftGroupBox2 = Tabs.Visual:AddLeftGroupbox("Extra ESP", "eye")
local VisualRightGroupBox = Tabs.Visual:AddRightGroupbox("Leaderboard Settings")


State.PlayerESPObjects = State.PlayerESPObjects or {}
State.PlayerESPEnabled = false


local function RemovePlayerESPFromPlayer(plr)

    local data = State.PlayerESPObjects[plr]

    if data then
        if data.RenderConnectionName then
            Disconnect(data.RenderConnectionName)
        end

        if data.Highlight then
            data.Highlight:Destroy()
        end

        if data.Billboard then
            data.Billboard:Destroy()
        end

        State.PlayerESPObjects[plr] = nil
    end

    Disconnect(
        "PlayerESP_Character_" .. plr.UserId
    )
end

local function CreatePlayerESP(plr)

    if plr == Services.LocalPlayer then
        return
    end

    if State.PlayerESPObjects[plr] then
        return
    end

    local function SetupCharacter(char)

        if not State.PlayerESPEnabled then
            return
        end

        local root =
            char:WaitForChild(
                "HumanoidRootPart",
                5
            )

        local humanoid =
            char:WaitForChild(
                "Humanoid",
                5
            )

        if not root or not humanoid then
            return
        end

        local highlight =
            Instance.new("Highlight")

        highlight.Name = "PlayerESP"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor =
            Color3.fromRGB(255, 0, 0)

        highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        highlight.Parent = char

        local billboard =
            Instance.new("BillboardGui")

        billboard.Name = "PlayerESPText"
        billboard.Size =
            UDim2.new(0, 200, 0, 50)

        billboard.StudsOffset =
            Vector3.new(0, 3, 0)

        billboard.AlwaysOnTop = true
        billboard.Parent = root

        local text =
            Instance.new("TextLabel")

        text.Size =
            UDim2.new(1, 0, 1, 0)

        text.BackgroundTransparency = 1
        text.TextStrokeTransparency = 0
        text.TextSize = 14
        text.Font =
            Enum.Font.SourceSansBold

        text.TextColor3 =
            Color3.fromRGB(255, 0, 0)

        text.Parent = billboard

        local renderConnectionName =
            "PlayerESP_Render_" .. plr.UserId

        Connect(
            renderConnectionName,
            Services.RunService.RenderStepped,
            function()

                if not State.PlayerESPEnabled then
                    Disconnect(renderConnectionName)
                    return
                end

                if not char.Parent then
                    Disconnect(renderConnectionName)
                    return
                end

                if humanoid.Health <= 0 then
                    Disconnect(renderConnectionName)
                    return
                end

                local localCharacter =
                    Services.LocalPlayer.Character

                local localRoot =
                    localCharacter
                    and localCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local distance = 0

                if localRoot then

                    distance = math.floor(
                        (
                            localRoot.Position
                            - root.Position
                        ).Magnitude
                    )

                end

                text.Text =
                    plr.Name
                    .. "\n❤ "
                    .. math.floor(
                        humanoid.Health
                    )
                    .. "/"
                    .. math.floor(
                        humanoid.MaxHealth
                    )
                    .. " | "
                    .. distance
                    .. " st"

            end
        )

        State.PlayerESPObjects[plr] = {
            Highlight = highlight,
            Billboard = billboard,
            RenderConnectionName =
                renderConnectionName
        }

    end


    -- Mevcut karakter
    if plr.Character then
        SetupCharacter(plr.Character)
    end


    -- Karakter reset / respawn
    Connect(
        "PlayerESP_Character_" .. plr.UserId,
        plr.CharacterAdded,
        function(char)

            task.wait(1)

            if not State.PlayerESPEnabled then
                return
            end

            -- Eski ESP'yi temizle
            if State.PlayerESPObjects[plr] then

                local old =
                    State.PlayerESPObjects[plr]

                if old.RenderConnectionName then
                    Disconnect(
                        old.RenderConnectionName
                    )
                end

                if old.Highlight then
                    old.Highlight:Destroy()
                end

                if old.Billboard then
                    old.Billboard:Destroy()
                end

                State.PlayerESPObjects[plr] = nil

            end

            -- Yeni karaktere ESP
            SetupCharacter(char)

        end
    )

end




local function RemovePlayerESP()

    for plr in pairs(
        State.PlayerESPObjects
    ) do

        RemovePlayerESPFromPlayer(plr)

    end


    DisconnectPrefix("PlayerESP_Character_")

end


VisualLeftGroupBox:AddToggle(
    "PlayerESPToggle",
    {
        Text = "Player ESP",
        Default = false
    }
):OnChanged(function(Value)

    State.PlayerESPEnabled = Value


    if Value then

        for _, plr in ipairs(
            Services.Players:GetPlayers()
        ) do

            if plr ~= Services.LocalPlayer then
                CreatePlayerESP(plr)
            end

        end


        Connect(
            "PlayerESP_PlayerAdded",
            Services.Players.PlayerAdded,
            function(plr)

                if State.PlayerESPEnabled then
                    CreatePlayerESP(plr)
                end

            end
        )


        Connect(
            "PlayerESP_PlayerRemoving",
            Services.Players.PlayerRemoving,
            function(plr)

                RemovePlayerESPFromPlayer(plr)

                Disconnect(
                    "PlayerESP_Character_" .. plr.UserId
                )

            end
        )

    else

        Disconnect(
            "PlayerESP_PlayerAdded"
        )

        Disconnect(
            "PlayerESP_PlayerRemoving"
        )

        RemovePlayerESP()

    end

end)

State.FruitESPObjects =
    State.FruitESPObjects or {}

State.FruitESPEnabled = false


State.Fruits = State.Fruits or {

    Mango =
        Color3.fromRGB(
            255, 170, 0
        ),

    Orange =
        Color3.fromRGB(
            255, 140, 0
        ),

    Banana =
        Color3.fromRGB(
            255, 235, 60
        ),

    Apple =
        Color3.fromRGB(
            255, 70, 70
        ),

    ["Alluring Apple"] =
        Color3.fromRGB(
            200, 200, 200
        ),

    Pear =
        Color3.fromRGB(
            100, 255, 100
        ),

    ["Chakra Fruit"] =
        Color3.fromRGB(
            170, 0, 255
        )
}


local function RemoveFruitESP(obj)

    local gui =
        State.FruitESPObjects[obj]

    if not gui then
        return
    end


    Disconnect(
        "FruitDestroy_" .. tostring(obj)
    )


    gui:Destroy()

    State.FruitESPObjects[obj] = nil

end


local function CreateFruitESP(obj)

    if State.FruitESPObjects[obj] then
        return
    end


    if not State.Fruits[obj.Name] then
        return
    end


    local part

    if obj:IsA("BasePart") then

        part = obj

    else

        part =
            obj:FindFirstChildWhichIsA(
                "BasePart"
            )

    end


    if not part then
        return
    end


    local gui =
        Instance.new("BillboardGui")

    gui.Name = "FruitESP"

    gui.Adornee = part

    gui.Size =
        UDim2.fromOffset(
            120,
            20
        )

    gui.StudsOffset =
        Vector3.new(0, 1.8, 0)

    gui.AlwaysOnTop = true
    gui.LightInfluence = 0
    gui.Enabled =
        State.FruitESPEnabled

    gui.Parent = part


    local label =
        Instance.new("TextLabel")

    label.Name = "TextLabel"

    label.BackgroundTransparency = 1

    label.Size =
        UDim2.fromScale(1, 1)

    label.Font =
        Enum.Font.GothamSemibold

    label.TextSize = 13

    label.TextStrokeTransparency = 0.4

    label.TextStrokeColor3 =
        Color3.new()

    label.TextColor3 =
        State.Fruits[obj.Name]

    label.Parent = gui


    State.FruitESPObjects[obj] = gui


    Connect(
        "FruitDestroy_" .. tostring(obj),
        obj.Destroying,
        function()

            State.FruitESPObjects[obj] = nil

            Disconnect(
                "FruitDestroy_" .. tostring(obj)
            )


            if gui then
                gui:Destroy()
            end

        end
    )

end


for _, obj in ipairs(
    workspace:GetDescendants()
) do

    if State.Fruits[obj.Name] then
        CreateFruitESP(obj)
    end

end


Connect(
    "Fruit_DescendantAdded",
    workspace.DescendantAdded,
    function(obj)

        if State.Fruits[obj.Name] then
            CreateFruitESP(obj)
        end

    end
)


Connect(
    "FruitESP_Heartbeat",
    Services.RunService.Heartbeat,
    function()

        if not State.FruitESPEnabled then
            return
        end


        local character =
            Services.LocalPlayer.Character

        local hrp =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )


        if not hrp then
            return
        end


        for obj, gui in pairs(
            State.FruitESPObjects
        ) do

            if not obj.Parent then

                RemoveFruitESP(obj)

            else

                local part =
                    gui.Adornee

                local label =
                    gui:FindFirstChild(
                        "TextLabel"
                    )


                if part and label then

                    local distance =
                        math.floor(
                            (
                                hrp.Position
                                - part.Position
                            ).Magnitude
                        )


                    label.Text =
                        ("%s [%dm]"):format(
                            obj.Name,
                            distance
                        )

                end

            end

        end

    end
)


VisualLeftGroupBox2:AddToggle(
    "FruitESP",
    {
        Text = "Fruit ESP",
        Default = false,

        Callback = function(Value)

            State.FruitESPEnabled = Value


            for _, gui in pairs(
                State.FruitESPObjects
            ) do

                if gui then
                    gui.Enabled = Value
                end

            end

        end
    }
)

State.ObserveEnabled = true
State.CurrentObserveTarget = nil

Services.Camera = workspace.CurrentCamera


local function getPlayerList()

    local playerGui =
        Services.LocalPlayer:FindFirstChild("PlayerGui")

    if not playerGui then
        return nil
    end

    local clientGui =
        playerGui:FindFirstChild("ClientGui")

    if not clientGui then
        return nil
    end

    local mainframe =
        clientGui:FindFirstChild("Mainframe")

    if not mainframe then
        return nil
    end

    local playerList =
        mainframe:FindFirstChild("PlayerList")

    if not playerList then
        return nil
    end

    return playerList:FindFirstChild("List")
end


local function resetCamera()

    State.CurrentObserveTarget = nil

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local character =
        Services.LocalPlayer.Character

    local humanoid =
        character
        and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        camera.CameraSubject = humanoid
    end
end


local function clearObserveConnections()

    for name in pairs(MainConnections) do

        if string.sub(name, 1, 8) == "Observe_" then
            Disconnect(name)
        end

    end

end


local function setupPlayerTemplate(template)

    if not template
        or template.Name ~= "PlayerTemplate" then
        return
    end

    local connectionName =
        "Observe_Template_" .. tostring(template:GetDebugId())

    Connect(
        connectionName,
        template.InputBegan,
        function(input)

            if not State.ObserveEnabled then
                return
            end

            if input.UserInputType
                ~= Enum.UserInputType.MouseButton2 then
                return
            end

            local playerNameObject =
                template:FindFirstChild("PlayerName")

            if not playerNameObject then
                return
            end

            local playerName =
                playerNameObject.Text

            if not playerName
                or playerName == "" then
                return
            end

            local target =
                Services.Players:FindFirstChild(playerName)

            if not target then
                return
            end

            local character =
                target.Character

            if not character then
                return
            end

            local humanoid =
                character:FindFirstChildOfClass("Humanoid")

            if not humanoid then
                return
            end

            local camera =
                workspace.CurrentCamera

            if not camera then
                return
            end

            if State.CurrentObserveTarget == target then

                resetCamera()

            else

                State.CurrentObserveTarget =
                    target

                camera.CameraSubject =
                    humanoid

            end

        end
    )

end


local function enableObserve()

    if not State.ObserveEnabled then
        return
    end

    clearObserveConnections()

    local list =
        getPlayerList()

    if not list then
        return
    end

    for _, template in ipairs(list:GetChildren()) do
        setupPlayerTemplate(template)
    end

    Connect(
        "Observe_PlayerListChildAdded",
        list.ChildAdded,
        function(child)

            if not State.ObserveEnabled then
                return
            end

            if child.Name ~= "PlayerTemplate" then
                return
            end

            task.defer(function()

                if State.ObserveEnabled
                    and child.Parent == list then

                    setupPlayerTemplate(child)

                end

            end)

        end
    )

end


local ObserveToggle =
    VisualRightGroupBox:AddToggle(
        "ObserveToggle",
        {
            Text = "Leaderboard Observe",
            Default = true
        }
    )


ObserveToggle:OnChanged(function(value)

    State.ObserveEnabled = value

    if value then

        enableObserve()

    else

        clearObserveConnections()
        resetCamera()

    end

end)


Connect(
    "Observe_LocalCharacterAdded",
    Services.LocalPlayer.CharacterAdded,
    function(character)

        State.CurrentObserveTarget = nil

        local humanoid =
            character:WaitForChild(
                "Humanoid",
                10
            )

        if humanoid then

            local camera =
                workspace.CurrentCamera

            if camera then
                camera.CameraSubject = humanoid
            end

        end

        if State.ObserveEnabled then

            task.wait(1)

            if State.ObserveEnabled then
                enableObserve()
            end

        end

    end
)


local playerGui = Services.LocalPlayer:WaitForChild("PlayerGui")


Connect(
    "Observe_PlayerGuiChildAdded",
    playerGui.ChildAdded,
    function(child)

        if child.Name ~= "ClientGui" then
            return
        end

        if not State.ObserveEnabled then
            return
        end

        task.wait(0.5)

        if State.ObserveEnabled then
            enableObserve()
        end

    end
)


Connect(
    "Observe_PlayerAdded",
    Services.Players.PlayerAdded,
    function(player)

        Connect(
            "Observe_TargetCharacter_" .. player.UserId,
            player.CharacterAdded,
            function(character)

                if not State.ObserveEnabled then
                    return
                end

                if State.CurrentObserveTarget
                    ~= player then
                    return
                end

                local humanoid =
                    character:WaitForChild(
                        "Humanoid",
                        10
                    )

                if not humanoid then
                    return
                end

                local camera =
                    workspace.CurrentCamera

                if not camera then
                    return
                end

                if State.CurrentObserveTarget
                    == player then

                    camera.CameraSubject =
                        humanoid

                end

            end
        )

    end
)


Connect(
    "Observe_PlayerRemoving",
    Services.Players.PlayerRemoving,
    function(player)

        if State.CurrentObserveTarget
            == player then

            resetCamera()

        end

        Disconnect(
            "Observe_TargetCharacter_" ..
            player.UserId
        )

    end
)


for _, player in ipairs(
    Services.Players:GetPlayers()
) do

    Connect(
        "Observe_TargetCharacter_" .. player.UserId,
        player.CharacterAdded,
        function(character)

            if not State.ObserveEnabled then
                return
            end

            if State.CurrentObserveTarget
                ~= player then
                return
            end

            local humanoid =
                character:WaitForChild(
                    "Humanoid",
                    10
                )

            if not humanoid then
                return
            end

            local camera =
                workspace.CurrentCamera

            if camera then
                camera.CameraSubject =
                    humanoid
            end

        end
    )

end


if State.ObserveEnabled then
    task.defer(function()
        enableObserve()
    end)
end



-- Automation

local AutomationLeftGroupBox = Tabs.Automation:AddLeftGroupbox("Automation")

AutomationLeftGroupBox:AddToggle("AutoPick", {
    Text = "Auto Pick",
    Default = false,

    Callback = function(Value)

        State.AutoPick = Value

        Disconnect("AutoPick_Heartbeat")

        if not Value then
            return
        end

        Connect(
            "AutoPick_Heartbeat",
            Services.RunService.Heartbeat,
            function()

                if not State.AutoPick then
                    Disconnect("AutoPick_Heartbeat")
                    return
                end

                local character =
                    Services.LocalPlayer.Character

                if not character then
                    return
                end

                local rootPart =
                    character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not rootPart then
                    return
                end

                for pos, obj in pairs(State.PickupList) do

                    if obj and obj.Parent then

                        local distance =
                            (
                                rootPart.Position
                                - pos
                            ).Magnitude

                        if distance < 25 then

                            local id =
                                obj:FindFirstChild("ID")

                            if id then

                                State.DataEvent:FireServer(
                                    "PickUp",
                                    id.Value
                                )

                            end

                        end

                    else

                        State.PickupList[pos] = nil

                    end

                end

            end
        )

    end
})


-- Botting

local BottingLeftGroupBox =
    Tabs.Botting:AddLeftGroupbox("Auto Farm Settings")

local BottingRightGroupBox =
    Tabs.Botting:AddRightGroupbox("Auto Farm")


State.TreeFarmEnabled =
    State.TreeFarmEnabled or false

State.TreeFloatVelocity =
    State.TreeFloatVelocity or nil

State.AutoPickupConnectionName =
    State.AutoPickupConnectionName or nil

State.TreeFarmRunId =
    State.TreeFarmRunId or 0

State.CurrentTreeFarmKey =
    State.CurrentTreeFarmKey or nil

State.TreePlayerRange =
    State.TreePlayerRange or 150

State.TreeFarmPreviousNoFallState =
    State.TreeFarmPreviousNoFallState or false

State.TreeFarmNoFallOldNamecall =
    State.TreeFarmNoFallOldNamecall or nil



local Players = Services.Players
local LocalPlayer = Services.LocalPlayer
local RunService = Services.RunService
local ReplicatedStorage = Services.ReplicatedStorage


funcs.getCharacter = function()

    local character =
        LocalPlayer.Character

    if character then
        return character
    end

    return LocalPlayer.CharacterAdded:Wait()

end


funcs.getHRP = function()

    local character =
        funcs.getCharacter()

    return character
        and character:FindFirstChild(
            "HumanoidRootPart"
        )

end

funcs.GetActiveChakraPlayers = function()

    local activePlayers = {}

    for _, plr in ipairs(
        Players:GetPlayers()
    ) do

        if plr ~= LocalPlayer
            and plr.Character then

            local torso =
                plr.Character:FindFirstChild(
                    "Torso"
                )
                or plr.Character:FindFirstChild(
                    "UpperTorso"
                )

            if torso
                and torso:FindFirstChild(
                    "ChakraSense"
                ) then

                table.insert(
                    activePlayers,
                    plr.Name
                )

            end
        end
    end

    return activePlayers

end


funcs.isAnyActiveChakraUser = function()

    return #funcs.GetActiveChakraPlayers() > 0

end

funcs.isPlayerWithinDistance = function(
    position,
    distance
)

    for _, plr in ipairs(
        Players:GetPlayers()
    ) do

        if plr ~= LocalPlayer then

            local character =
                plr.Character

            local hrp =
                character
                and character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if hrp
                and (
                    hrp.Position - position
                ).Magnitude <= distance then

                return true

            end
        end
    end

    return false

end

funcs.teleportToSafePoint = function()

    if funcs.noClip then
        funcs.noClip(false)
    elseif noClip then
        noClip(false)
    end


    if State.TreeFloatVelocity then

        State.TreeFloatVelocity:Destroy()

        State.TreeFloatVelocity = nil

    end


    local hrp =
        funcs.getHRP()

    if not hrp then
        return false
    end


    local safePoint =
        funcs.getSafePoint(
            hrp.Position
        )

    if safePoint then

        hrp.CFrame =
            CFrame.new(
                safePoint
            )

        task.wait(0.05)


        if hrp.Parent
            and (
                hrp.Position - safePoint
            ).Magnitude <= 5 then

            if funcs.updateStatus then
                funcs.updateStatus(
                    "Moved To Safe Point",
                    Color3.fromRGB(
                        90,
                        220,
                        130
                    ),
                    "Safety mode active"
                )
            end

            return true

        end
    end


    task.wait(0.05)


    if not hrp.Parent then
        return false
    end


    safePoint =
        funcs.getSafePoint(
            hrp.Position
        )

    if not safePoint then
        return false
    end


    hrp.CFrame =
        CFrame.new(
            safePoint
        )

    task.wait(0.05)


    if not hrp.Parent then
        return false
    end


    if funcs.updateStatus then
        funcs.updateStatus(
            "Moved To Safe Point",
            Color3.fromRGB(
                90,
                220,
                130
            ),
            "Safety mode active"
        )
    end


    return true

end

funcs.getTrees = function()

    local trees = {}

    for _, obj in ipairs(
        workspace:GetChildren()
    ) do

        if obj:IsA("Model")
            and string.match(
                obj.Name,
                "^Tree%d+$"
            ) then

            local fruitSpawns =
                obj:FindFirstChild(
                    "FruitSpawns"
                )

            local mainBranch =
                obj:FindFirstChild(
                    "MainBranch"
                )

            if fruitSpawns
                and mainBranch then

                table.insert(
                    trees,
                    {
                        Tree = obj,
                        MainBranch = mainBranch
                    }
                )

            end
        end
    end


    table.sort(
        trees,
        function(a, b)

            return a.Tree.Name
                < b.Tree.Name

        end
    )


    return trees

end

funcs.teleportToTree = function(
    treeData
)

    if funcs.isAnyActiveChakraUser() then
        return false
    end


    local hrp =
        funcs.getHRP()

    if not hrp then
        return false
    end


    local mainBranch =
        treeData.MainBranch


    if not mainBranch
        or not mainBranch.Parent
        or not mainBranch:IsA("BasePart") then

        return false

    end


    local targetPosition =
        mainBranch.Position


    -- Slider değerini kullan
    local playerRange =
        State.TreePlayerRange or 150


    -- Ağaca gitmeden önce oyuncu kontrolü
    if funcs.isPlayerWithinDistance(
        targetPosition,
        playerRange
    ) then

        return false

    end


    if funcs.isAnyActiveChakraUser() then
        return false
    end


    -- Ağaca giderken noclip
    if funcs.noClip then
        funcs.noClip(true)
    elseif noClip then
        noClip(true)
    end


    hrp.CFrame =
        CFrame.new(
            targetPosition
        )


    -- Eski float temizle
    if State.TreeFloatVelocity then

        State.TreeFloatVelocity:Destroy()

        State.TreeFloatVelocity = nil

    end


    -- Tree float
    State.TreeFloatVelocity =
        Instance.new("BodyVelocity")

    State.TreeFloatVelocity.Name =
        "TreeFarmFloatVelocity"

    State.TreeFloatVelocity.MaxForce =
        Vector3.new(
            math.huge,
            math.huge,
            math.huge
        )

    State.TreeFloatVelocity.Velocity =
        Vector3.zero

    State.TreeFloatVelocity.Parent =
        hrp


    task.wait(0.05)


    if not State.TreeFarmEnabled then
        return false
    end


    if not hrp.Parent then
        return false
    end


    if funcs.isAnyActiveChakraUser() then
        return false
    end


    -- Tekrar merkezle
    hrp.CFrame =
        CFrame.new(
            targetPosition
        )


    return true

end


funcs.checkNearbyPlayerAfterTeleport =
    function()

        local hrp =
            funcs.getHRP()

        if not hrp then
            return false
        end


        if funcs.isAnyActiveChakraUser() then

            if funcs.updateStatus then
                funcs.updateStatus(
                    "Active Chakra User",
                    Color3.fromRGB(
                        255,
                        180,
                        70
                    ),
                    "Moving to nearest safe point..."
                )
            end


            funcs.teleportToSafePoint()

            return true

        end


        local playerRange =
            State.TreePlayerRange or 150


        if not funcs.isPlayerWithinDistance(
            hrp.Position,
            playerRange
        ) then

            return false

        end


        if funcs.updateStatus then
            funcs.updateStatus(
                "Player Detected",
                Color3.fromRGB(
                    255,
                    90,
                    90
                ),
                "Moving to nearest safe point..."
            )
        end


        funcs.teleportToSafePoint()

        return true

    end

State.TreeFarmScreenGui =
    State.TreeFarmScreenGui or nil

State.TreeFarmMainFrame =
    State.TreeFarmMainFrame or nil

State.TreeFarmStatus =
    State.TreeFarmStatus or nil

State.TreeFarmTreeLabel =
    State.TreeFarmTreeLabel or nil

State.TreeFarmStatusDot =
    State.TreeFarmStatusDot or nil


funcs.createStatusGui = function()

    if State.TreeFarmScreenGui then

        State.TreeFarmScreenGui.Enabled =
            true

        return

    end


    local ScreenGui =
        Instance.new("ScreenGui")

    ScreenGui.Name =
        "TreeFarmStatus"

    ScreenGui.ResetOnSpawn =
        false

    ScreenGui.IgnoreGuiInset =
        true

    ScreenGui.Parent =
        LocalPlayer:WaitForChild(
            "PlayerGui"
        )


    State.TreeFarmScreenGui =
        ScreenGui


    local MainFrame =
        Instance.new("Frame")

    MainFrame.Name =
        "StatusFrame"

    MainFrame.Size =
        UDim2.fromOffset(
            255,
            86
        )

    MainFrame.AnchorPoint =
        Vector2.new(
            1,
            1
        )

    MainFrame.Position =
        UDim2.new(
            1,
            -30,
            0.72,
            0
        )

    MainFrame.BackgroundColor3 =
        Color3.fromRGB(
            20,
            100,
            190
        )

    MainFrame.BackgroundTransparency =
        0.25

    MainFrame.BorderSizePixel =
        0

    MainFrame.ZIndex =
        2

    MainFrame.Parent =
        ScreenGui


    State.TreeFarmMainFrame =
        MainFrame


    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(
            0,
            18
        )

    Corner.Parent =
        MainFrame


    local Gradient =
        Instance.new("UIGradient")

    Gradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(
                    35,
                    145,
                    255
                )
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(
                    15,
                    75,
                    160
                )
            )
        })

    Gradient.Rotation =
        35

    Gradient.Parent =
        MainFrame


    local Stroke =
        Instance.new("UIStroke")

    Stroke.Color =
        Color3.fromRGB(
            100,
            200,
            255
        )

    Stroke.Transparency =
        0.35

    Stroke.Thickness =
        1.5

    Stroke.Parent =
        MainFrame


    local Shadow =
        Instance.new("ImageLabel")

    Shadow.Name =
        "Shadow"

    Shadow.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Shadow.Position =
        UDim2.fromScale(
            0.5,
            0.5
        )

    Shadow.Size =
        UDim2.new(
            1,
            20,
            1,
            20
        )

    Shadow.BackgroundTransparency =
        1

    Shadow.Image =
        "rbxassetid://1316045217"

    Shadow.ImageColor3 =
        Color3.fromRGB(
            0,
            80,
            180
        )

    Shadow.ImageTransparency =
        0.65

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
        1

    Shadow.Parent =
        MainFrame


    local Content =
        Instance.new("Frame")

    Content.Name =
        "Content"

    Content.BackgroundTransparency =
        1

    Content.Size =
        UDim2.fromScale(
            1,
            1
        )

    Content.ZIndex =
        3

    Content.Parent =
        MainFrame


    local Padding =
        Instance.new("UIPadding")

    Padding.PaddingLeft =
        UDim.new(
            0,
            15
        )

    Padding.PaddingRight =
        UDim.new(
            0,
            15
        )

    Padding.PaddingTop =
        UDim.new(
            0,
            10
        )

    Padding.PaddingBottom =
        UDim.new(
            0,
            10
        )

    Padding.Parent =
        Content


    local Header =
        Instance.new("TextLabel")

    Header.Size =
        UDim2.new(
            1,
            -25,
            0,
            19
        )

    Header.BackgroundTransparency =
        1

    Header.Text =
        "FRUIT FARM"

    Header.TextColor3 =
        Color3.fromRGB(
            245,
            250,
            255
        )

    Header.TextSize =
        13

    Header.Font =
        Enum.Font.GothamBold

    Header.TextXAlignment =
        Enum.TextXAlignment.Left

    Header.ZIndex =
        4

    Header.Parent =
        Content


    local StatusDot =
        Instance.new("Frame")

    StatusDot.Size =
        UDim2.fromOffset(
            8,
            8
        )

    StatusDot.Position =
        UDim2.new(
            1,
            -8,
            0,
            6
        )

    StatusDot.BackgroundColor3 =
        Color3.fromRGB(
            90,
            240,
            150
        )

    StatusDot.BorderSizePixel =
        0

    StatusDot.ZIndex =
        4

    StatusDot.Parent =
        Content


    local DotCorner =
        Instance.new("UICorner")

    DotCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    DotCorner.Parent =
        StatusDot


    State.TreeFarmStatusDot =
        StatusDot


    local Status =
        Instance.new("TextLabel")

    Status.Size =
        UDim2.new(
            1,
            0,
            0,
            20
        )

    Status.Position =
        UDim2.fromOffset(
            0,
            26
        )

    Status.BackgroundTransparency =
        1

    Status.Text =
        "Checking Active Chakra Users..."

    Status.TextColor3 =
        Color3.fromRGB(
            225,
            240,
            255
        )

    Status.TextSize =
        12

    Status.Font =
        Enum.Font.GothamMedium

    Status.TextXAlignment =
        Enum.TextXAlignment.Left

    Status.TextTruncate =
        Enum.TextTruncate.AtEnd

    Status.ZIndex =
        4

    Status.Parent =
        Content


    State.TreeFarmStatus =
        Status


    local TreeLabel =
        Instance.new("TextLabel")

    TreeLabel.Size =
        UDim2.new(
            1,
            0,
            0,
            18
        )

    TreeLabel.Position =
        UDim2.fromOffset(
            0,
            49
        )

    TreeLabel.BackgroundTransparency =
        1

    TreeLabel.Text =
        "Waiting..."

    TreeLabel.TextColor3 =
        Color3.fromRGB(
            175,
            220,
            255
        )

    TreeLabel.TextSize =
        11

    TreeLabel.Font =
        Enum.Font.Gotham

    TreeLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    TreeLabel.TextTruncate =
        Enum.TextTruncate.AtEnd

    TreeLabel.ZIndex =
        4

    TreeLabel.Parent =
        Content


    State.TreeFarmTreeLabel =
        TreeLabel

end


funcs.hideStatusGui = function()

    if State.TreeFarmScreenGui then

        State.TreeFarmScreenGui.Enabled =
            false

    end

end


funcs.updateStatus = function(
    text,
    color,
    treeText
)

    local status =
        State.TreeFarmStatus

    if not status then
        return
    end


    status.Text =
        text


    if color then

        status.TextColor3 =
            color


        if State.TreeFarmStatusDot then

            State.TreeFarmStatusDot.BackgroundColor3 =
                color

        end

    end


    if treeText
        and State.TreeFarmTreeLabel then

        State.TreeFarmTreeLabel.Text =
            treeText

    end

end

funcs.getFruitPosition = function(
    fruit
)

    if not fruit
        or not fruit.Parent then

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


funcs.getCurrentFruits = function()

    local result = {}

    local allowed = {}


    if State.FruitNames then

        for name, enabled in pairs(
            State.FruitNames
        ) do

            if enabled then
                allowed[name] = true
            end

        end

    else

        local names = {
            "Mango",
            "Orange",
            "Banana",
            "Apple",
            "Alluring Apple",
            "Pear",
            "Chakra Fruit",
            "Life Up Fruit"
        }

        for _, name in ipairs(names) do
            allowed[name] = true
        end

    end


    local hrp =
        funcs.getHRP()

    if not hrp then
        return result
    end


    local currentPosition =
        hrp.Position


    for _, obj in ipairs(
        workspace:GetDescendants()
    ) do

        if allowed[obj.Name] then

            local position =
                funcs.getFruitPosition(
                    obj
                )


            if position
                and (
                    position
                    - currentPosition
                ).Magnitude <= 300 then

                local playerNearby =
                    funcs.isPlayerWithinDistance(
                        position,
                        50
                    )


                if not playerNearby then

                    table.insert(
                        result,
                        {
                            Object = obj,
                            Position = position
                        }
                    )

                end

            end
        end
    end


    return result

end


funcs.teleportToFruit = function(
    fruitData
)

    if funcs.isAnyActiveChakraUser() then
        return false
    end


    local hrp =
        funcs.getHRP()

    if not hrp then
        return false
    end


    local position =
        funcs.getFruitPosition(
            fruitData.Object
        )

    if not position then
        return false
    end


    if funcs.isAnyActiveChakraUser() then
        return false
    end


    hrp.CFrame =
        CFrame.new(position)


    return true

end

funcs.waitForTreeFruits = function(
    treeData
)

    local timeout = 10

    local startTime =
        tick()


    local currentRunId =
        State.TreeFarmRunId


    while State.TreeFarmEnabled
        and currentRunId
            == State.TreeFarmRunId do


        if funcs.isAnyActiveChakraUser() then

            funcs.updateStatus(
                "Active Chakra User",
                Color3.fromRGB(
                    255,
                    180,
                    70
                ),
                "Moving to nearest safe point..."
            )


            funcs.teleportToSafePoint()


            repeat
                task.wait(0.25)

            until not funcs.isAnyActiveChakraUser()
                or not State.TreeFarmEnabled
                or currentRunId
                    ~= State.TreeFarmRunId


            if not State.TreeFarmEnabled
                or currentRunId
                    ~= State.TreeFarmRunId then

                return {}

            end


            startTime =
                tick()

        end


        local currentFruits =
            funcs.getCurrentFruits()


        if #currentFruits > 0 then

            funcs.updateStatus(
                "Fruit Detected",
                Color3.fromRGB(
                    100,
                    220,
                    140
                ),
                "Waiting 1 second..."
            )


            task.wait(1)


            if not State.TreeFarmEnabled
                or currentRunId
                    ~= State.TreeFarmRunId then

                return {}

            end


            if funcs.isAnyActiveChakraUser() then

                funcs.updateStatus(
                    "Active Chakra User",
                    Color3.fromRGB(
                        255,
                        180,
                        70
                    ),
                    "Moving to nearest safe point..."
                )


                funcs.teleportToSafePoint()


                repeat
                    task.wait(0.25)

                until not funcs.isAnyActiveChakraUser()
                    or not State.TreeFarmEnabled
                    or currentRunId
                        ~= State.TreeFarmRunId


                if not State.TreeFarmEnabled
                    or currentRunId
                        ~= State.TreeFarmRunId then

                    return {}

                end

            end


            return funcs.getCurrentFruits()

        end


        if tick() - startTime >= timeout then
            return {}
        end


        funcs.updateStatus(
            "Waiting For Fruit",
            Color3.fromRGB(
                255,
                200,
                90
            ),
            treeData.Tree.Name
        )


        task.wait(0.25)

    end


    return {}

end

funcs.runTreeFarm = function()

    local trees =
        funcs.getTrees()


    if #trees == 0 then

        funcs.updateStatus(
            "No Valid Trees Found",
            Color3.fromRGB(
                255,
                90,
                90
            ),
            "Waiting for FruitSpawns..."
        )

        return

    end


    local currentRunId =
        State.TreeFarmRunId


    for index, treeData in ipairs(
        trees
    ) do

        if not State.TreeFarmEnabled
            or currentRunId
                ~= State.TreeFarmRunId then

            return

        end


        if funcs.isAnyActiveChakraUser() then

            funcs.updateStatus(
                "Active Chakra User",
                Color3.fromRGB(
                    255,
                    180,
                    70
                ),
                "Moving to nearest safe point..."
            )


            funcs.teleportToSafePoint()


            repeat
                task.wait(0.25)

            until not funcs.isAnyActiveChakraUser()
                or not State.TreeFarmEnabled
                or currentRunId
                    ~= State.TreeFarmRunId


            if not State.TreeFarmEnabled
                or currentRunId
                    ~= State.TreeFarmRunId then

                return

            end

        end


        funcs.updateStatus(
            "Checking Tree",
            Color3.fromRGB(
                100,
                180,
                255
            ),
            string.format(
                "%d / %d  •  %s",
                index,
                #trees,
                treeData.Tree.Name
            )
        )


        if funcs.isAnyActiveChakraUser() then
            continue
        end


        local teleported =
            funcs.teleportToTree(
                treeData
            )


        if not teleported then

            funcs.updateStatus(
                "Tree Skipped",
                Color3.fromRGB(
                    255,
                    190,
                    80
                ),
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


        if funcs.checkNearbyPlayerAfterTeleport() then

            task.wait(0.25)

            continue

        end


        local currentFruits =
            funcs.waitForTreeFruits(
                treeData
            )


        if not State.TreeFarmEnabled
            or currentRunId
                ~= State.TreeFarmRunId then

            return

        end


        for fruitIndex, fruitData in ipairs(
            currentFruits
        ) do

            if not State.TreeFarmEnabled
                or currentRunId
                    ~= State.TreeFarmRunId then

                return

            end


            if funcs.isAnyActiveChakraUser() then

                funcs.updateStatus(
                    "Active Chakra User",
                    Color3.fromRGB(
                        255,
                        180,
                        70
                    ),
                    "Moving to nearest safe point..."
                )


                funcs.teleportToSafePoint()


                repeat
                    task.wait(0.25)

                until not funcs.isAnyActiveChakraUser()
                    or not State.TreeFarmEnabled
                    or currentRunId
                        ~= State.TreeFarmRunId


                if not State.TreeFarmEnabled
                    or currentRunId
                        ~= State.TreeFarmRunId then

                    return

                end

            end


            if funcs.checkNearbyPlayerAfterTeleport() then

                break

            end


            if fruitData.Object
                and fruitData.Object.Parent then

                funcs.updateStatus(
                    "Collecting Fruit",
                    Color3.fromRGB(
                        100,
                        220,
                        140
                    ),
                    string.format(
                        "%d / %d  •  %s",
                        fruitIndex,
                        #currentFruits,
                        treeData.Tree.Name
                    )
                )


                if not funcs.isAnyActiveChakraUser() then

                    funcs.teleportToFruit(
                        fruitData
                    )

                end


                task.wait(0.25)


                if funcs.checkNearbyPlayerAfterTeleport() then
                    break
                end

            end
        end


        task.wait(0.25)

    end


    if State.TreeFarmEnabled
        and currentRunId
            == State.TreeFarmRunId then

        funcs.updateStatus(
            "Tree Cycle Completed",
            Color3.fromRGB(
                90,
                220,
                130
            ),
            "Restarting scan..."
        )

    end

end

funcs.startAutoPickup = function()

    if State.AutoPickupConnectionName then

        Disconnect(
            State.AutoPickupConnectionName
        )

        State.AutoPickupConnectionName =
            nil

    end


    local connectionName =
        "TreeFarm_AutoPickup"


    State.AutoPickupConnectionName =
        connectionName


    Connect(
        connectionName,
        RunService.Heartbeat,
        function()

            if not State.TreeFarmEnabled then
                return
            end


            local character =
                LocalPlayer.Character

            if not character then
                return
            end


            local rootPart =
                character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not rootPart then
                return
            end


            local pickupList =
                State.PickupList

            if not pickupList then
                return
            end


            local dataEvent =
                ReplicatedStorage
                :FindFirstChild("Events")
                and ReplicatedStorage.Events
                :FindFirstChild(
                    "DataEvent"
                )


            if not dataEvent then
                return
            end


            for pos, obj in pairs(
                pickupList
            ) do

                if obj
                    and obj.Parent then

                    local distance =
                        (
                            rootPart.Position
                            - pos
                        ).Magnitude


                    if distance < 25 then

                        local id =
                            obj:FindFirstChild(
                                "ID"
                            )


                        if id then

                            dataEvent:FireServer(
                                "PickUp",
                                id.Value
                            )

                        end
                    end
                end
            end

        end
    )

end


funcs.stopAutoPickup = function()

    if State.AutoPickupConnectionName then

        Disconnect(
            State.AutoPickupConnectionName
        )

        State.AutoPickupConnectionName =
            nil

    end

end

funcs.setTreeFarmNoFall = function(
    enabled
)

    if enabled then

        if getgenv().NoFallEnabled then
            return
        end


        State.TreeFarmPreviousNoFallState =
            false


        getgenv().NoFallEnabled =
            true


        if not State.TreeFarmNoFallOldNamecall then

            local oldNamecall


            oldNamecall =
                hookmetamethod(
                    game,
                    "__namecall",
                    function(self, ...)

                        local method =
                            getnamecallmethod()


                        if method
                            == "FindFirstChild" then

                            local args =
                                {...}


                            if args[1]
                                == "NegateFall"
                                and getgenv().NoFallEnabled then

                                return true

                            end
                        end


                        return oldNamecall(
                            self,
                            ...
                        )

                    end
                )


            State.TreeFarmNoFallOldNamecall =
                oldNamecall

        end

    else

        getgenv().NoFallEnabled =
            false


        if State.TreeFarmNoFallOldNamecall then

            hookmetamethod(
                game,
                "__namecall",
                State.TreeFarmNoFallOldNamecall
            )


            State.TreeFarmNoFallOldNamecall =
                nil

        end

    end

end

local TreeFarmToggle =
    BottingRightGroupBox:AddToggle(
        "TreeFarmToggle",
        {
            Text = "Fruit Farm",
            Default = false
        }
    )


TreeFarmToggle:OnChanged(
    function(Value)

        State.TreeFarmEnabled =
            Value


        -- Her toggle değişiminde eski loop'u geçersiz yap
        State.TreeFarmRunId =
            State.TreeFarmRunId + 1


        if not Value then

            funcs.stopAutoPickup()


            if funcs.noClip then
                funcs.noClip(false)
            elseif noClip then
                noClip(false)
            end


            if State.TreeFloatVelocity then

                State.TreeFloatVelocity:Destroy()

                State.TreeFloatVelocity =
                    nil

            end


            if not State.TreeFarmPreviousNoFallState then
                funcs.setTreeFarmNoFall(false)
            end


            funcs.hideStatusGui()

            return

        end


        -- Tree Farm açılmadan önceki No Fall durumu
        State.TreeFarmPreviousNoFallState =
            getgenv().NoFallEnabled == true


        if not State.TreeFarmPreviousNoFallState then
            funcs.setTreeFarmNoFall(true)
        end


        if funcs.noClip then
            funcs.noClip(true)
        elseif noClip then
            noClip(true)
        end


        funcs.createStatusGui()


        funcs.updateStatus(
            "Checking Active Chakra Users...",
            Color3.fromRGB(
                100,
                180,
                255
            ),
            "Scanning..."
        )


        funcs.startAutoPickup()


        local currentRunId =
            State.TreeFarmRunId


        task.spawn(
            function()

                local firstCheck =
                    true


                while State.TreeFarmEnabled
                    and currentRunId
                        == State.TreeFarmRunId do


                    local activePlayers =
                        funcs.GetActiveChakraPlayers()


                    if #activePlayers > 0 then

                        funcs.updateStatus(
                            "Active Chakra Users",
                            Color3.fromRGB(
                                255,
                                180,
                                70
                            ),
                            string.format(
                                "%d user(s) detected",
                                #activePlayers
                            )
                        )


                        if not firstCheck then

                            local hrp =
                                funcs.getHRP()


                            if hrp then
                                funcs.teleportToSafePoint()
                            end

                        else

                            funcs.updateStatus(
                                "Active Chakra Users",
                                Color3.fromRGB(
                                    255,
                                    180,
                                    70
                                ),
                                "Waiting at current position..."
                            )

                        end


                        repeat

                            task.wait(0.25)

                            activePlayers =
                                funcs.GetActiveChakraPlayers()

                        until #activePlayers == 0
                            or not State.TreeFarmEnabled
                            or currentRunId
                                ~= State.TreeFarmRunId


                        if not State.TreeFarmEnabled
                            or currentRunId
                                ~= State.TreeFarmRunId then

                            break

                        end


                        funcs.updateStatus(
                            "No Active Chakra Users",
                            Color3.fromRGB(
                                90,
                                220,
                                130
                            ),
                            "Starting fruit farm..."
                        )


                        task.wait(0.5)

                    end


                    firstCheck =
                        false


                    if funcs.GetActiveChakraPlayers
                        and #funcs.GetActiveChakraPlayers()
                            == 0 then

                        funcs.runTreeFarm()

                    end


                    task.wait(0.5)

                end


                -- Loop kapanınca cleanup
                funcs.stopAutoPickup()


                if funcs.noClip then
                    funcs.noClip(false)
                elseif noClip then
                    noClip(false)
                end


                if State.TreeFloatVelocity then

                    State.TreeFloatVelocity:Destroy()

                    State.TreeFloatVelocity =
                        nil

                end


                if not State.TreeFarmPreviousNoFallState then
                    funcs.setTreeFarmNoFall(false)
                end


                funcs.hideStatusGui()

            end
        )

    end
)

TreeFarmToggle:AddKeyPicker(
    "TreeFarmKeybind",
    {
        Default = "None",
        SyncToggleState = true,

        Callback = function(key)

            State.CurrentTreeFarmKey =
                key

        end
    }
)

BottingLeftGroupBox:AddSlider(
    "TreePlayerRange",
    {
        Text = "Proximity Check",

        Default =
            State.TreePlayerRange,

        Min = 50,

        Max = 500,

        Rounding = 0,

        Compact = false,

        Callback = function(Value)

            State.TreePlayerRange =
                Value

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

    
    local player =
        Services.LocalPlayer

    local webhook = Options.WebhookURL.Value

    if webhook == nil or webhook == "" then
        Library:Notify({
            Title = "Inventory Logger",
            Description = "Please enter a Webhook URL.",
            Duration = 4,
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
            Duration = 5,
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
            Duration = 5,
        })

        warn(response)
        return
    end

if not success or not response then

    Library:Notify({
        Title = "Webhook Error",
        Description = "Failed to send inventory.",
        Duration = 5
    })

    warn(response)
    return
end

local statusCode =
    tonumber(response.StatusCode)

if statusCode
    and statusCode >= 200
    and statusCode < 300 then

    Library:Notify({
        Title = "Inventory Logger",
        Description = "Inventory successfully sent!",
        Duration = 4
    })

else

    Library:Notify({
        Title = "Webhook Error",
        Description =
            "Status Code: "
            .. tostring(
                response.StatusCode
            ),
        Duration = 5
    })

    warn(
        response.Body
    )
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

        for _, slot in ipairs(inventory:GetChildren()) do
            watchSlot(slot)
        end

        table.insert(
            RareInventoryConnections,
            inventory.ChildAdded:Connect(function(slot)
                task.wait(0.1)
                watchSlot(slot)
            end)
        )
    end
})


State.ChakraSenseUIEnabled =
    State.ChakraSenseUIEnabled ~= false

State.JoinNotifier =
    State.JoinNotifier or false

local ChakraSenseGui = nil
local ChakraSenseLabel = nil

local MyChakraTitle = nil
local MyChakraDescription = nil

local BeingObservedConnections = {}

local TrackedCharacters = {}
local CharacterConnections = {}
local PlayerConnections = {}

local ChakraStates = {}

local BeingObservedTriggered = false


local function ChakraNotify(title, description)

    if not State.ChakraSenseUIEnabled then
        return
    end

    if not Library then
        return
    end

    Library:Notify({
        Title = title,
        Description = description,
        Duration = 10
    })
end


local function CreateChakraSenseUI()

    if ChakraSenseGui then
        ChakraSenseGui.Enabled =
            State.ChakraSenseUIEnabled
        return
    end

    local playerGui =
        Services.LocalPlayer:WaitForChild(
            "PlayerGui"
        )

    ChakraSenseGui = Instance.new("ScreenGui")
    ChakraSenseGui.Name = "ChakraSenseStatus"
    ChakraSenseGui.ResetOnSpawn = false
    ChakraSenseGui.IgnoreGuiInset = true
    ChakraSenseGui.Parent = playerGui


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
        "Chakra Sense Active: 0"

    ChakraSenseLabel.Visible =
        State.ChakraSenseUIEnabled

    ChakraSenseLabel.Parent =
        ChakraSenseGui


    MyChakraTitle =
        Instance.new("TextLabel")

    MyChakraTitle.Name =
        "MyChakraTitle"

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

    MyChakraTitle.Parent =
        ChakraSenseGui


    MyChakraDescription =
        Instance.new("TextLabel")

    MyChakraDescription.Name =
        "MyChakraDescription"

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

    MyChakraDescription.Parent =
        ChakraSenseGui
end


local function GetActiveChakraPlayers()

    local activePlayers = {}

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer then

            local character =
                player.Character

            if character then

                local torso =
                    character:FindFirstChild("Torso")
                    or character:FindFirstChild("UpperTorso")

                if torso
                    and torso:FindFirstChild(
                        "ChakraSense"
                    ) then

                    table.insert(
                        activePlayers,
                        player.Name
                    )
                end
            end
        end
    end

    return activePlayers
end


local function HasActiveChakraSense()

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer then

            local character =
                player.Character

            if character then

                local torso =
                    character:FindFirstChild("Torso")
                    or character:FindFirstChild("UpperTorso")

                if torso
                    and torso:FindFirstChild(
                        "ChakraSense"
                    ) then

                    return true
                end
            end
        end
    end

    return false
end


local function UpdateChakraSenseUI()

    if not ChakraSenseLabel then
        return
    end

    if not State.ChakraSenseUIEnabled then

        ChakraSenseLabel.Visible = false

        if MyChakraTitle then
            MyChakraTitle.Visible = false
        end

        if MyChakraDescription then
            MyChakraDescription.Visible = false
        end

        return
    end


    ChakraSenseLabel.Visible = true


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

    else

        ChakraSenseLabel.TextColor3 =
            Color3.fromRGB(170, 85, 255)
    end
end


local function SetObservedUI(visible)

    if not State.ChakraSenseUIEnabled then
        visible = false
    end


    if MyChakraTitle then
        MyChakraTitle.Visible =
            visible
    end


    if MyChakraDescription then

        MyChakraDescription.Visible =
            visible

        MyChakraDescription.Text =
            "Waiting For All Chakra Sense Users"
    end
end


local function UpdateObservedState()

    if not BeingObservedTriggered then
        return
    end

    if HasActiveChakraSense() then

        SetObservedUI(true)

    else

        BeingObservedTriggered = false

        SetObservedUI(false)
    end
end



local function ClearBeingObservedConnections()

    for _, connection in ipairs(
        BeingObservedConnections
    ) do

        if connection then
            connection:Disconnect()
        end
    end


    table.clear(
        BeingObservedConnections
    )
end


local function SetupBeingObservedDetector()

    ClearBeingObservedConnections()

    local settings =
        Services.ReplicatedStorage:FindFirstChild(
            "Settings"
        )

    if not settings then
        return
    end

    local mySettings =
        settings:FindFirstChild(
            Services.LocalPlayer.Name
        )

    if not mySettings then
        return
    end

    table.insert(
        BeingObservedConnections,

        mySettings.ChildAdded:Connect(
            function(child)

                if child.Name ~= "BeingObservedBy" then
                    return
                end

                if not child:IsA("StringValue") then
                    return
                end

                BeingObservedTriggered = true

                if HasActiveChakraSense() then
                    SetObservedUI(true)
                end

                ChakraNotify(
                    "⚠️ You Are Being Observed",
                    "Someone is observing you!"
                )
            end
        )
    )
end




    table.insert(
        BeingObservedConnections,

        mySettings.ChildRemoved:Connect(
            function(child)

                if child.Name ~=
                    "BeingObservedBy" then
                    return
                end


                task.defer(
                    function()

                        UpdateObservedState()

                    end
                )
            end
        )
    )




local function WatchCharacter(
    player,
    character
)

    if not character then
        return
    end


    if TrackedCharacters[character] then
        return
    end


    TrackedCharacters[character] = true
    ChakraStates[character] = false


    local torso =
        character:FindFirstChild("Torso")
        or character:FindFirstChild("UpperTorso")


    if not torso then

        torso =
            character:WaitForChild(
                "Torso",
                5
            )


        if not torso then

            torso =
                character:WaitForChild(
                    "UpperTorso",
                    5
                )
        end
    end


    if not torso then

        TrackedCharacters[character] = nil
        ChakraStates[character] = nil

        return
    end


    local function ChakraStarted()

        if ChakraStates[character] then
            return
        end


        ChakraStates[character] = true


        ChakraNotify(
            "⚠️ Chakra Sense Detected",
            player.Name
            .. " Used Chakra Sense!"
        )


        task.delay(
            10,
            function()

                if not State.ChakraSenseUIEnabled then
                    return
                end


                if not ChakraStates[character] then
                    return
                end


                ChakraNotify(
                    "⚠️ Chakra Sense Still Active",
                    player.Name
                    .. " is still using Chakra Sense!"
                )

            end
        )


        UpdateChakraSenseUI()


        if BeingObservedTriggered then
            SetObservedUI(true)
        end
    end


    local function ChakraEnded()

        if not ChakraStates[character] then
            return
        end

        ChakraStates[character] = false

        ChakraNotify(
            "Chakra Sense Ended",
            player.Name
            .. " stopped using Chakra Sense!"
        )

        UpdateChakraSenseUI()
        UpdateObservedState()
    end



    if torso:FindFirstChild(
        "ChakraSense"
    ) then

        ChakraStarted()
    end


    local addedConnection =
        torso.ChildAdded:Connect(
            function(child)

                if child.Name ~=
                    "ChakraSense" then
                    return
                end


                ChakraStarted()

            end
        )


    local removedConnection =
        torso.ChildRemoved:Connect(
            function(child)

                if child.Name ~=
                    "ChakraSense" then
                    return
                end


                ChakraEnded()

            end
        )


    local characterConnection =
        character.Destroying:Connect(
            function()

                if addedConnection then
                    addedConnection:Disconnect()
                    addedConnection = nil
                end

                if removedConnection then
                    removedConnection:Disconnect()
                    removedConnection = nil
                end

                TrackedCharacters[character] = nil
                ChakraStates[character] = nil
                CharacterConnections[character] = nil

                UpdateChakraSenseUI()
                UpdateObservedState()
            end
        )



    CharacterConnections[character] = {

        Added =
            addedConnection,

        Removed =
            removedConnection,

        Destroying =
            characterConnection
    }


    UpdateChakraSenseUI()
end


local function SetupPlayer(player)

    if player ==
        Services.LocalPlayer then
        return
    end


    if player.Character then

        task.spawn(
            function()

                WatchCharacter(
                    player,
                    player.Character
                )

            end
        )
    end


    if PlayerConnections[player] then
        return
    end


    PlayerConnections[player] =
        player.CharacterAdded:Connect(
            function(character)

                task.wait(0.1)


                WatchCharacter(
                    player,
                    character
                )


                task.wait(0.1)


                UpdateChakraSenseUI()
                UpdateObservedState()

            end
        )
end


for _, player in ipairs(
    Services.Players:GetPlayers()
) do

    SetupPlayer(player)

end


Services.Players.PlayerAdded:Connect(
    function(player)

        SetupPlayer(player)


        task.wait(0.1)


        UpdateChakraSenseUI()
        UpdateObservedState()

    end
)


    Services.Players.PlayerRemoving:Connect(
        function(player)

            if PlayerConnections[player] then
                PlayerConnections[player]:Disconnect()
                PlayerConnections[player] = nil
            end

            if player.Character then

                local character =
                    player.Character

                local connections =
                    CharacterConnections[character]

                if connections then

                    if connections.Added then
                        connections.Added:Disconnect()
                    end

                    if connections.Removed then
                        connections.Removed:Disconnect()
                    end

                    if connections.Destroying then
                        connections.Destroying:Disconnect()
                    end

                    CharacterConnections[character] = nil
                end

                TrackedCharacters[character] = nil
                ChakraStates[character] = nil
            end

            UpdateChakraSenseUI()
            UpdateObservedState()
        end
    )



CreateChakraSenseUI()

SetupBeingObservedDetector()

UpdateChakraSenseUI()


Services.LocalPlayer.CharacterAdded:Connect(
    function()

        task.wait(1)


        SetupBeingObservedDetector()

        UpdateChakraSenseUI()
        UpdateObservedState()

    end
)



NotificationsRightGroupBox:AddToggle(
    "ChakraSenseStatus",
    {
        Text = "Chakra Sense Detector",

        Default =
            State.ChakraSenseUIEnabled,

        Callback = function(Value)

            State.ChakraSenseUIEnabled =
                Value

            if ChakraSenseGui then
                ChakraSenseGui.Enabled =
                    Value
            end

            if not Value then

                if ChakraSenseLabel then
                    ChakraSenseLabel.Visible = false
                end

                SetObservedUI(false)

            else

                if ChakraSenseLabel then
                    ChakraSenseLabel.Visible = true
                end

                SetupBeingObservedDetector()
                UpdateChakraSenseUI()

                if BeingObservedTriggered then
                    UpdateObservedState()
                end
            end
        end
    }
)



NotificationsRightGroupBox:AddToggle(
    "JoinNotifier",
    {
        Text = "Player Joined",

        Default = State.JoinNotifier,


        Callback = function(Value)

            State.JoinNotifier =
                Value

        end
    }
)


Services.Players.PlayerAdded:Connect(
    function(player)

        if not State.JoinNotifier then
            return
        end


        Library:Notify({

            Title =
                "A Player Just Joined To Your Server!",

            Description =
                player.Name
                .. " Joined!",

            Duration = 5

        })
    end
)

-- Addons

-- Auto Execute System


RightGroupBox2:AddToggle(
    "AutoExecute",
    {
        Text = "Auto Execute on Teleport",
        Default = true,

        Callback = function(Value)

            State.AutoExecute =
                Value

            if State.AutoExecute
                and queue_on_teleport then

                queue_on_teleport([[
                    repeat
                        task.wait()
                    until game:IsLoaded()

                    if game.PlaceId == 10266164381 then
                        loadstring(
                            game:HttpGet(
                                "https://raw.githubusercontent.com/Kam41514/ScriptHub/refs/heads/main/scriptbeta.lua"
                            )
                        )()
                    end
                ]])

                print("Queue Added")
            end
        end
    }
)


-- Events
Services.Players.PlayerAdded:Connect(function()
    task.wait(1)
    UpdatePlayerList()
end)

Services.Players.PlayerRemoving:Connect(function()
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

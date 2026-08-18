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

local remotes = Services.ReplicatedStorage:WaitForChild("Events")
local dataEvent = remotes:WaitForChild("DataEvent")
local player = Services.Players.LocalPlayer
local gameManager = require(Services.ReplicatedStorage:WaitForChild("GameManager"))
local dataFunction = Services.ReplicatedStorage.Events:WaitForChild("DataFunction")
local DataEvent = Services.ReplicatedStorage.Events:WaitForChild("DataEvent")
local BaseLocals = {}
local GuiSettings = {}
local Modules = {}
local Groupboxes = {}

Services.Camera = workspace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer

Services.PlayerScripts = Services.LocalPlayer:WaitForChild("PlayerScripts")

Services.PlayerModule = require(Services.PlayerScripts:WaitForChild("PlayerModule"))
Services.ControlModule = Services.PlayerModule:GetControls()
Services.Blocking = Services.ReplicatedStorage
    :WaitForChild("Settings")
    :WaitForChild(Services.LocalPlayer.Name)
    :WaitForChild("Blocking")

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


-- Updates:

local State = {
    SelectedPlayer = "",
    PlayerList = {},

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

    SelectedNPC = nil,
    AutoFloatNPC = false,

    ESPEnabled = false,
    FruitESP = false,

    CurrentSpeedToggleKey = nil,
    CurrentNoclipKey = nil,
    CurrentFlyKey = nil,
    CurrentTreeFarmKey = nil,

    AutoExecute = true,

    SelectedPoint = nil,

    Farming = false,

    DangerDistance = 165,
    ProximityDistance = 375,
    ProximityCheck = false,
    TreePlayerRange = 150,

    AutoLog = false,
    AutoLogDistance = 50,

    JoinNotifier = true,

    KillBricks = {},
    NoKillBricks = false,
    LogTarget = {},
    CorruptedPointESPObjects = {},
    CorruptedPointESPEnabled = false,
    ChakraPointsFolder = workspace:WaitForChild("ChakraPoints"),

    KillBrickNames = {
        "LavarossaVoid",
        "Void"
    },

    SafePointPositions = {
        Vector3.new(-2431.339, 418.692, -1281.255),
        Vector3.new(868.431, 288.574, -1757.482),
        Vector3.new(528.921, 285.689, 1318.243)
    },

    FruitNames = {
        ["Mango"] = true,
        ["Orange"] = true,
        ["Life Up Fruit"] = true,
        ["Chakra Fruit"] = true,
        ["Pear"] = true,
        ["Alluring Apple"] = true,
        ["Apple"] = true,
        ["Banana"] = true,
        ["Fruit Of Forgetfulness"] = true,
    },

    PlayerESPObjects = {},
    PlayerESPEnabled = false,

    ObserveEnabled = true,
    CurrentObserveTarget = nil,

    TreeFarmEnabled = false,
    TreeFloatVelocity = nil,
    TreeFarmRunId = 0,
    TreeFarmPreviousNoFallState = false,

    -- Auto Pickup
    PickupList = {},
    AutoPickupConnection = nil,
    AutoPickupEnabled = false,
    AutoPick = false,

    FruitPickRange = 50,
    TreeFarmAutoPickLastRun = 0,
    TreeFarmPickupChildAdded = nil,

    AutoPickupConnectionName = nil,

    NoFallEnabled = false,
    NoFallOldNamecall = nil,

    TreeFarmStatusGui = nil,
    TreeFarmStatusFrame = nil,
    TreeFarmStatusLabel = nil,
    TreeFarmTreeLabel = nil,
    TreeFarmStatusDot = nil,

    noFogConnection = nil,
    oldFogEnd = nil,

    FullBrightConnection = nil,
    BrightnessLevel = 2,
    FullBrightEnabled = false,

    webhook = "",

     JumpCounters = Services.ReplicatedStorage.Settings[Services.Players.LocalPlayer.Name].JumpCounters,
    InitialJumpCount = nil,
    ChakraSenseOwnersGui = nil,
    ChakraSenseOwnersLabel = nil,
    ChakraSenseOwnersStroke = nil,
    ChakraSenseOwnersNextUpdate = 0,

    AutoBowls = false,
    SelectedRecipe = "Tangerine Fruit Bowl",
    RecipeNames = {},
    SellBowls = false,

    AutoBlockEnabled = false,

    ParryableEnabled = false,
    BlockableEnabled = false,

    selectedParryable = {
        WeaponM2 = true,
    },
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
    Combat = Window:AddTab("Combat", "hand-fist"),
    Player = Window:AddTab("Player", "user"),
    Visual = Window:AddTab("Visual", "eye"),
    Misc = Window:AddTab("Misc", "sparkles"),
    Exploits = Window:AddTab("Exploits", "terminal"),
    Automation = Window:AddTab("Automation", "play"),
    Botting = Window:AddTab("Botting", "bot"),
    Notifications = Window:AddTab("Notifications", "bell"),
    Config = Window:AddTab("Config", "settings"),
}
-- Groupboxes For Combat Tab
Groupboxes.InfiniteScripts = Tabs.Combat:AddLeftGroupbox("Player Scripts", "user")
Groupboxes.AutoBlocking = Tabs.Combat:AddRightGroupbox("Auto Blocking", "user")

State.AutoBlockEnabled = false
State.selectedParryable = {
    WeaponM2 = true,
}
State.ParryableEnabled = true
State.BlockableEnabled = false


BaseLocals.ParryableAnimations = {

    WeaponM2 = {
        Range = 25,

        ["rbxassetid://11330795390"] = {   
            Start = 0.13,
            Stop = 0.4,
        },

        ["rbxassetid://6360969229"] = {
            Start = 0.13,
            Stop = 0.4,
        },

        ["rbxassetid://6329840310"] = {
            Start = 0.13,
            Stop = 0.4,
        },

        ["rbxassetid://5571540174"] = {
            Start = 0.13,
            Stop = 0.4,
        },

        ["rbxassetid://6904596529"] = {
            Start = 0.13,
            Stop = 0.4,
        },

         ["rbxassetid://7275651023"] = {
            Start = 0.13,
            Stop = 0.4,
        },
    },
}


BaseLocals.BlockableAnimations = {

    PunchM1 = {
        Range = 20,

        ["rbxassetid://11330785444"] = {
            Start = 0.05,
            Stop = 0.3,
        },

        ["rbxassetid://11330787365"] = {
            Start = 0.05,
            Stop = 0.3,
        },

        ["rbxassetid://11330792100"] = {
            Start = 0.05,
            Stop = 0.3,
        },

        ["rbxassetid://11330793406"] = {
            Start = 0.05,
            Stop = 0.3,
        },

        ["rbxassetid://11330782198"] = {
            Start = 0.05,
            Stop = 0.3,
        },
    },

    GreatswordM1 = {
        Range = 20,

        ["rbxassetid://6904029998"] = {
            Start = 0.05,
            Stop = 0.50,
        },

        ["rbxassetid://6904312276"] = {
            Start = 0.05,
            Stop = 0.50,
        },

        ["rbxassetid://6904161298"] = {
            Start = 0.05,
            Stop = 0.75,
        },
    },

    SpearM1 = {
        Range = 20,

        ["rbxassetid://7275410799"] = {
            Start = 0.015,
            Stop = 0.3,
        },

        ["rbxassetid://7275470913"] = {
            Start = 0.015,
            Stop = 0.3,
        },

        ["rbxassetid://7275583556"] = {
            Start = 0.015,
            Stop = 0.30,
        },

        ["rbxassetid://7275616852"] = {
            Start = 0.015,
            Stop = 0.30,
        },
    },
}


BaseLocals.SequenceAnimations = {

    GreatswordAirM2 = {
        First = "rbxassetid://8205019911",
        Second = "rbxassetid://6329881782",

        Range = 40,

        Start = 0.05,
        Stop = 0.25,

        Window = 0.5,
    },

    PunchM2Air = {
        First = "rbxassetid://8205019911",
        Second = "rbxassetid://5571546692",

        Range = 40,

        Start = 0.05,
        Stop = 0.25,

        Window = 0.5,
    },

    KunaiM2Air = {
        First = "rbxassetid://8205019911",
        Second = "rbxassetid://6362979537",

        Range = 40,

        Start = 0.05,
        Stop = 0.25,

        Window = 0.5,
    },

    KatanaM2Air = {
        First = "rbxassetid://8205019911",
        Second = "rbxassetid://6329881782",

        Range = 40,

        Start = 0.05,
        Stop = 0.25,

        Window = 0.5,
    },

    AsumaiM2Air = {
        First = "rbxassetid://8205019911",
        Second = "rbxassetid://7913611566",

        Range = 40,

        Start = 0.05,
        Stop = 0.25,

        Window = 0.5,
    },

    SpearM2Air = {
        First = "rbxassetid://8205019911",
        Second = "rbxassetid://7275679606",

        Range = 40,

        Start = 0.05,
        Stop = 0.25,

        Window = 0.5,
    },
}


Services.Blocking = Services.ReplicatedStorage
    :WaitForChild("Settings")
    :WaitForChild(Services.LocalPlayer.Name)
    :WaitForChild("Blocking")


funcs.AnimationConnections = {}
funcs.CharacterConnections = {}
funcs.PlayerConnections = {}


function funcs.CheckBlocking()

    if not Services.Blocking then
        return false
    end

    return Services.Blocking.Value == true
end


function funcs.StartBlocking()

    if not State.AutoBlockEnabled then
        return
    end

    if funcs.CheckBlocking() then
        return
    end

    dataFunction:InvokeServer("Block")

    if Services.Blocking then
        Services.Blocking.Value = true
    end
end


function funcs.StopBlocking()

    if not Services.Blocking then
        return
    end

    dataFunction:InvokeServer("EndBlock")

    Services.Blocking.Value = false
end


function funcs.GetPlayerDistance(otherPlayer)

    local character = Services.LocalPlayer.Character
    local otherCharacter = otherPlayer.Character

    local root = character
        and character:FindFirstChild("HumanoidRootPart")

    local otherRoot = otherCharacter
        and otherCharacter:FindFirstChild("HumanoidRootPart")

    if not root or not otherRoot then
        return math.huge
    end

    return (root.Position - otherRoot.Position).Magnitude
end


function funcs.IsSelectedParryableAnimation(id)

    if not State.AutoBlockEnabled then
        return false, nil, nil
    end

    if not State.ParryableEnabled then
        return false, nil, nil
    end

    if not State.selectedParryable then
        return false, nil, nil
    end

    for animationName, selected in pairs(State.selectedParryable) do

        if selected then

            local selectedAnimations =
                BaseLocals.ParryableAnimations[animationName]

            if selectedAnimations then

                local timer = selectedAnimations[id]

                if timer then
                    return true, timer, selectedAnimations.Range
                end

            end
        end
    end

    return false, nil, nil
end


function funcs.IsBlockableAnimation(id)

    if not State.AutoBlockEnabled then
        return false, nil, nil
    end

    if not State.BlockableEnabled then
        return false, nil, nil
    end

    if not State.selectedBlockable then
        return false, nil, nil
    end

    for animationName, selected in pairs(State.selectedBlockable) do

        if selected then

            local selectedAnimations =
                BaseLocals.BlockableAnimations[animationName]

            if selectedAnimations then

                local timer = selectedAnimations[id]

                if timer then
                    return true, timer, selectedAnimations.Range
                end

            end
        end
    end

    return false, nil, nil
end


function funcs.ClearListeners()

    for _, connection in pairs(funcs.AnimationConnections) do
        if connection then
            connection:Disconnect()
        end
    end

    for _, connection in pairs(funcs.CharacterConnections) do
        if connection then
            connection:Disconnect()
        end
    end

    for _, connection in pairs(funcs.PlayerConnections) do
        if connection then
            connection:Disconnect()
        end
    end

    funcs.AnimationConnections = {}
    funcs.CharacterConnections = {}
    funcs.PlayerConnections = {}
end


function funcs.ListenPlayer(otherPlayer)

    if otherPlayer == Services.LocalPlayer then
        return
    end

    if not State.AutoBlockEnabled then
        return
    end


    local function CharacterReady(character)

        if not State.AutoBlockEnabled then
            return
        end

        local humanoid =
            character:WaitForChild("Humanoid", 5)

        if not humanoid then
            return
        end

        if not State.AutoBlockEnabled then
            return
        end

        local animator =
            humanoid:WaitForChild("Animator", 5)

        if not animator then
            return
        end

        if not State.AutoBlockEnabled then
            return
        end


        -- Her sequence için ayrı state tutuluyor.
        local sequenceStates = {}

        for sequenceName in pairs(BaseLocals.SequenceAnimations) do

            sequenceStates[sequenceName] = {
                LastAnimationId = nil,
                LastAnimationTime = 0,
            }

        end


        local connection = animator.AnimationPlayed:Connect(function(track)

            if not State.AutoBlockEnabled then
                return
            end

            if not track.Animation then
                return
            end


            local id = track.Animation.AnimationId
            local now = tick()


            --------------------------------------------------
            -- SEQUENCE ANIMATIONS
            --------------------------------------------------

            for sequenceName, sequence in
                pairs(BaseLocals.SequenceAnimations) do

                -- Boş sequence'leri yok say
                if sequence.First ~= ""
                    and sequence.Second ~= "" then

                    local sequenceState =
                        sequenceStates[sequenceName]

                    --------------------------------------------------
                    -- SECOND GELDİ Mİ?
                    --------------------------------------------------

                    if sequenceState.LastAnimationId
                        == sequence.First

                        and id == sequence.Second

                        and (now - sequenceState.LastAnimationTime)
                            <= sequence.Window then


                        -- Sequence tüketildi
                        sequenceState.LastAnimationId = nil
                        sequenceState.LastAnimationTime = 0


                        local distance =
                            funcs.GetPlayerDistance(otherPlayer)

                        local range =
                            sequence.Range or 20


                        if distance > range then
                            continue
                        end

                        if funcs.CheckBlocking() then
                            continue
                        end


                        task.wait(sequence.Start)


                        if not State.AutoBlockEnabled then
                            funcs.StopBlocking()
                            return
                        end

                        if funcs.CheckBlocking() then
                            continue
                        end


                        local currentDistance =
                            funcs.GetPlayerDistance(otherPlayer)

                        if currentDistance > range then
                            continue
                        end


                        funcs.StartBlocking()


                        task.wait(sequence.Stop)


                        funcs.StopBlocking()

                        return
                    end


                    --------------------------------------------------
                    -- FIRST GELDİ Mİ?
                    --------------------------------------------------

                    if id == sequence.First then

                        sequenceState.LastAnimationId = id
                        sequenceState.LastAnimationTime = now

                    elseif sequenceState.LastAnimationId
                        and (now - sequenceState.LastAnimationTime)
                            > sequence.Window then

                        sequenceState.LastAnimationId = nil
                        sequenceState.LastAnimationTime = 0
                    end

                end
            end


            --------------------------------------------------
            -- NORMAL ANIMATIONS
            --------------------------------------------------

            local isParryable, parryTimer, parryRange =
                funcs.IsSelectedParryableAnimation(id)

            local isBlockable, blockTimer, blockRange =
                funcs.IsBlockableAnimation(id)


            if not isParryable and not isBlockable then
                return
            end


            local distance =
                funcs.GetPlayerDistance(otherPlayer)


            local timer
            local range


            if isParryable then

                timer = parryTimer
                range = parryRange

            elseif isBlockable then

                timer = blockTimer
                range = blockRange

            end


            if not timer then
                return
            end


            range = range or 20


            if distance > range then
                return
            end


            if funcs.CheckBlocking() then
                return
            end


            task.wait(timer.Start)


            if not State.AutoBlockEnabled then
                funcs.StopBlocking()
                return
            end


            if funcs.CheckBlocking() then
                return
            end


            local currentDistance =
                funcs.GetPlayerDistance(otherPlayer)


            if currentDistance > range then
                return
            end


            funcs.StartBlocking()


            task.wait(timer.Stop)


            if not State.AutoBlockEnabled then
                funcs.StopBlocking()
                return
            end


            funcs.StopBlocking()

        end)


        table.insert(
            funcs.AnimationConnections,
            connection
        )

    end


    if otherPlayer.Character then
        CharacterReady(otherPlayer.Character)
    end


    local characterConnection =
        otherPlayer.CharacterAdded:Connect(function(character)

            if not State.AutoBlockEnabled then
                return
            end

            CharacterReady(character)

        end)


    table.insert(
        funcs.CharacterConnections,
        characterConnection
    )

end


function funcs.StartListeners()

    funcs.ClearListeners()

    if not State.AutoBlockEnabled then
        return
    end


    for _, otherPlayer in
        ipairs(Services.Players:GetPlayers()) do

        funcs.ListenPlayer(otherPlayer)

    end


    local playerConnection =
        Services.Players.PlayerAdded:Connect(function(otherPlayer)

            if not State.AutoBlockEnabled then
                return
            end

            funcs.ListenPlayer(otherPlayer)

        end)


    table.insert(
        funcs.PlayerConnections,
        playerConnection
    )

end


Modules.AutoBlockToggle =
    Groupboxes.AutoBlocking:AddToggle("AutoBlock", {

    Text = "Auto Block",
    Default = false,

    Callback = function(value)

        State.AutoBlockEnabled = value
        State.BlockableEnabled = value

        if value then

            funcs.StartListeners()

        else

            funcs.ClearListeners()

            funcs.StopBlocking()

        end

    end,
})


Modules.ParryableDropdown =
    Groupboxes.AutoBlocking:AddDropdown(
        "ParryableAnimations",
        {

        Values = (function()

            local values = {}

            for animationName in
                pairs(BaseLocals.ParryableAnimations) do

                table.insert(values, animationName)

            end

            table.sort(values)

            return values

        end)(),

        Default = {
            WeaponM2 = true,
        },

        Multi = true,

        Text = "Parryable Animation",

        Callback = function(value)

            State.selectedParryable = value

        end,

    }
)


Modules.BlockableDropdown =
    Groupboxes.AutoBlocking:AddDropdown(
        "BlockableAnimations",
        {

        Values = (function()

            local values = {}

            for animationName in
                pairs(BaseLocals.BlockableAnimations) do

                table.insert(values, animationName)

            end

            table.sort(values)

            return values

        end)(),

        Default = {
            PunchM1 = true,
        },

        Multi = true,

        Text = "Blockable Animation",

        Callback = function(value)

            State.selectedBlockable = value

        end,

    }
)

State.InitialJumpCount = nil

Modules.InfiniteStamina =
    Groupboxes.InfiniteScripts:AddToggle(
        "InfiniteStamina",
        {
            Text = "Infinite Stamina",
            Default = false,
        }
    ):OnChanged(function()

        Disconnect("InfiniteStamina")

        if not Toggles.InfiniteStamina.Value then
            State.InitialJumpCount = nil
            return
        end

        BaseLocals.currentValue = State.JumpCounters.Value

        if BaseLocals.currentValue <= 0 then
            State.InitialJumpCount = 1
        else
            State.InitialJumpCount = BaseLocals.currentValue
        end

        Connect(
            "InfiniteStamina",
            Services.RunService.Heartbeat,
            function()

                if not Toggles.InfiniteStamina.Value then
                    Disconnect("InfiniteStamina")
                    State.InitialJumpCount = nil
                    return
                end

                if State.JumpCounters then
                    State.JumpCounters.Value =
                        State.InitialJumpCount
                end

            end
        )

    end)



-- Groupboxes For Misc Tab
Groupboxes.LeftGroupBox = Tabs.Misc:AddLeftGroupbox("Executable Scripts", "code")
Groupboxes.RightGroupBox = Tabs.Misc:AddRightGroupbox("Player Systems", "user")
Groupboxes.RightGroupBox2 = Tabs.Misc:AddRightGroupbox("UI Settings", "settings")


-- Misc Tab

Groupboxes.LeftGroupBox:AddButton({
    Text = "Execute Infinite Yield",
    Func = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua"
        ))()
    end
})


Groupboxes.LeftGroupBox:AddButton({
    Text = "Execute Dex Explorer",
    Func = function()
        loadstring(game:HttpGet(
            "https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"
        ))()
    end
})


-- Empty


for _, player in ipairs(Services.Players:GetPlayers()) do
    table.insert(State.PlayerList, player.Name)
end

Groupboxes.RightGroupBox:AddDropdown("PlayerDropdown", {
    Values = {},
    Default = 1,
    Multi = false,
    Text = "Select Player",
    Tooltip = "Choose a player"
}):OnChanged(function(Value)
    State.SelectedPlayer = Value
end)

UpdatePlayerList()


Groupboxes.RightGroupBox:AddButton({
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


Groupboxes.RightGroupBox2:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Toggle UI",
    })

Library.ToggleKeybind = Options.MenuKeybind

-- Player Tab

-- Groupboxes For Player Tab
Groupboxes.PlayerLeftGroupBox = Tabs.Player:AddLeftGroupbox("Flight", "wind")
Groupboxes.PlayerLeftGroupBox3 = Tabs.Player:AddLeftGroupbox("World Settings", "globe")
Groupboxes.PlayerLeftGroupBox2 = Tabs.Player:AddLeftGroupbox("Extras", "user")
Groupboxes.PlayerRightGroupBox = Tabs.Player:AddRightGroupbox("Speed", "wind")
Groupboxes.PlayerRightGroupBox2 = Tabs.Player:AddRightGroupbox("Proximity Detector", "bot")

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

Toggles.FlyToggle = Groupboxes.PlayerLeftGroupBox:AddToggle(
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

Toggles.NoclipToggle = Groupboxes.PlayerLeftGroupBox:AddToggle(
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

Toggles.AutoFallToggle = Groupboxes.PlayerLeftGroupBox:AddToggle(
    "AutoFallToggle",
    {
        Text = "Auto Fall",
        Default = false
    }
)


--// Speed

Toggles.SpeedToggle = Groupboxes.PlayerRightGroupBox:AddToggle(
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

Groupboxes.PlayerLeftGroupBox:AddSlider(
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

Groupboxes.PlayerRightGroupBox:AddSlider(
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

Groupboxes.PlayerLeftGroupBox2:AddButton({
    Text = "Reset Character",

    Func = function()

        local character =
            Services.LocalPlayer.Character

        if character then
            character:BreakJoints()
        end

    end
})

Toggles.AutoLogToggle = Groupboxes.PlayerRightGroupBox2:AddToggle(
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



Toggles.ProximityCheck = Groupboxes.PlayerRightGroupBox2:AddToggle(
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


Groupboxes.PlayerRightGroupBox2:AddSlider(
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
        UDim2.new(0.5, 0, 0, 110)

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

getgenv().NewNoFallEnabled = false

if not getgenv().NewNoFallHookInstalled then

    local oldNamecall

    oldNamecall = hookmetamethod(
        game,
        "__namecall",
        function(self, ...)

            local method =
                getnamecallmethod()

            if method == "FindFirstChild"
                and getgenv().NewNoFallEnabled then

                local args = {...}

                if args[1] == "NegateFall" then
                    return true
                end
            end

            return oldNamecall(
                self,
                ...
            )
        end
    )

    getgenv().NewNoFallOldNamecall =
        oldNamecall

    getgenv().NewNoFallHookInstalled =
        true
end


local NewNoFallToggle =
    Groupboxes.PlayerLeftGroupBox3:AddToggle(
        "NewNoFallToggle",
        {
            Text = "No Fall Damage",
            Default = false,

            Callback = function(Value)

                getgenv().NewNoFallEnabled =
                    Value

            end
        }
    )



-- End Of Player Tab

-- Wait To Not Crash
task.wait(0.01)

-- Groupboxes For Exploits Tab
Groupboxes.ExploitsLeftGroupBox = Tabs.Exploits:AddLeftGroupbox("Teleportation", "wind")
Groupboxes.ExploitsLeftGroupBox2 = Tabs.Exploits:AddLeftGroupbox("NPC Interaction", "contact")

local ChakraPointsFolder = workspace:WaitForChild("ChakraPoints")

Groupboxes.ExploitsLeftGroupBox:AddDropdown(
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


Groupboxes.ExploitsLeftGroupBox:AddButton(
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

Groupboxes.ExploitsLeftGroupBox:AddLabel("Chakra Point Teleport")

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
    Groupboxes.ExploitsLeftGroupBox:AddDropdown(
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


Groupboxes.ExploitsLeftGroupBox:AddButton({
    Text = "Teleport Point",

    Callback = function()

        if not State.SelectedPoint then

            Library:Notify({
                Title = "Teleport Failed",
                Description = "Select Chakra Point",
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


Groupboxes.ExploitsLeftGroupBox:AddLabel(
    "Safe Point"
)


Groupboxes.ExploitsLeftGroupBox:AddButton({
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


Modules.ItemDropdown = Groupboxes.ExploitsLeftGroupBox2:AddDropdown(
        "ItemDropdown",
        {
            Text = "Select Item",
            Values = State.PurchasableItems,
            Multi = false,
            Default = 1,
        }
    )


Modules.ItemDropdown:OnChanged(function(Value)

    State.SelectedItem = Value

end)

BaseLocals.Chef = workspace:WaitForChild("Chef")
BaseLocals.Medic = workspace:WaitForChild("Medic")

BaseLocals.ChefDialogPart =
	BaseLocals.Chef:FindFirstChild("HumanoidRootPart")
	or BaseLocals.Chef:FindFirstChild("Main")
	or BaseLocals.Chef

BaseLocals.MedicDialogPart =
	BaseLocals.Medic:FindFirstChild("HumanoidRootPart")
	or BaseLocals.Medic:FindFirstChild("Main")
	or BaseLocals.Medic

funcs.buyItem = function(itemName, price, quantity)
	local result = dataFunction:InvokeServer(
		"Pay",
		price,
		itemName,
		quantity,
		BaseLocals.ChefDialogPart
	)


	return result
end


funcs.fixInjure = function(price)
	local result = dataFunction:InvokeServer(
		"Pay",
		price,
		"Injuries",
		1,
		BaseLocals.MedicDialogPart
	)


	return result
end


Groupboxes.ExploitsLeftGroupBox2:AddButton({
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

		local success, result = pcall(function()
			return funcs.buyItem(
				State.SelectedItem,
				3,
				1
			)
		end)

		if success and result == true then
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

Groupboxes.ExploitsLeftGroupBox2:AddLabel("Medic Interaction")
Groupboxes.ExploitsLeftGroupBox2:AddButton({
	Text = "Fix Injure",

	Func = function()
		local success, result = pcall(function()
			return funcs.fixInjure()
		end)

		if success and result == true then
			Library:Notify({
				Title = "Fix Injure",
				Description = "Doctor Treated You Well.",
				Duration = 3
			})
		else
			Library:Notify({
				Title = "Fix Injure Failed",
				Description = tostring(result),
				Duration = 3
			})
		end
	end
})

State.KillBrickNames = State.KillBrickNames or {
    'LavarossaVoid',
    'Void'
}

State.KillBricks = State.KillBricks or {}
State.NoKillBricks = State.NoKillBricks or false


local function onChildAdded(object)
    if not table.find(
        State.KillBrickNames,
        object.Name
    ) then
        return
    end

    -- Aynı obje daha önce eklenmişse tekrar ekleme
    for _, killBrick in ipairs(State.KillBricks) do
        if killBrick.part == object then
            return
        end
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

    for _, killBrick in ipairs(State.KillBricks) do
        if killBrick.part then
            killBrick.part.Parent =
                state
                and nil
                or killBrick.oldParent
        end
    end
end


Groupboxes.PlayerLeftGroupBox3:AddToggle(
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

Groupboxes.VisualLeftGroupBox = Tabs.Visual:AddLeftGroupbox("Player ESP", "eye")
Groupboxes.VisualLeftGroupBox2 = Tabs.Visual:AddLeftGroupbox("Extra ESP", "eye")
Groupboxes.VisualRightGroupBox = Tabs.Visual:AddRightGroupbox("Leaderboard Settings")
Groupboxes.VisualRightGroupBox2 = Tabs.Visual:AddRightGroupbox("World Settings", "globe")


State.PlayerESPObjects = State.PlayerESPObjects or {}
State.PlayerESPEnabled = false
State.ChakraPointsFolder = ChakraPointsFolder


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

                    distance =
                        math.floor(
                            (
                                localRoot.Position
                                - root.Position
                            ).Magnitude
                        )

                end


                -- En yakın ChakraPoint
                local nearestChakraPoint = nil
                local nearestChakraDistance = math.huge


                for _, chakraPoint in ipairs(
                    State.ChakraPointsFolder:GetChildren()
                ) do

                    if chakraPoint.Name == "ChakraPoint" then

                        local pointPart =
                            chakraPoint.PrimaryPart
                            or chakraPoint:FindFirstChildWhichIsA(
                                "BasePart",
                                true
                            )


                        if pointPart then

                            local pointDistance =
                                (
                                    root.Position
                                    - pointPart.Position
                                ).Magnitude


                            if pointDistance < nearestChakraDistance then

                                nearestChakraDistance =
                                    pointDistance

                                nearestChakraPoint =
                                    chakraPoint

                            end

                        end

                    end

                end


                local pointName = ""


                if nearestChakraPoint then

                    local pointNameValue =
                        nearestChakraPoint:FindFirstChild(
                            "PointName",
                            true
                        )


                    if pointNameValue
                        and pointNameValue:IsA("StringValue") then

                        pointName =
                            "["
                            .. pointNameValue.Value
                            .. "]\n"

                    end

                end


                text.Text =
                    pointName
                    .. plr.Name
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


    if plr.Character then
        SetupCharacter(plr.Character)
    end


    Connect(
        "PlayerESP_Character_" .. plr.UserId,
        plr.CharacterAdded,
        function(char)

            task.wait(1)


            if not State.PlayerESPEnabled then
                return
            end


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


    DisconnectPrefix(
        "PlayerESP_Character_"
    )

end


Groupboxes.VisualLeftGroupBox:AddToggle(
    "PlayerESPToggle",
    {
        Text = "Player ESP",
        Default = false
    }
):OnChanged(function(Value)

    State.PlayerESPEnabled =
        Value


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
        ),
    ["Fruit Of Forgetfulness"] =
        Color3.fromRGB(
            255, 0, 0
        ),

    ["Life Up Fruit"] =
        Color3.fromRGB(
            0, 95, 0
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


Groupboxes.VisualLeftGroupBox2:AddToggle(
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

-- On work
State.CorruptedPointESPObjects = {}
State.CorruptedPointESPEnabled = false

local function RemoveCorruptedPointESP()

    Disconnect("CorruptedHealth_Update")
    Disconnect("CorruptedPoint_Added")

    for part, billboard in pairs(
        State.CorruptedPointESPObjects
    ) do

        if billboard then
            billboard:Destroy()
        end

        State.CorruptedPointESPObjects[part] = nil

    end

end


local function CreateCorruptedPointBillboard(point)

    if not State.CorruptedPointESPEnabled then
        return
    end

    if not point
        or point.Name ~= "CorruptedPoint"
        or not point:IsA("Model") then
        return
    end

    local health =
        point:FindFirstChild("Health")

    local part =
        point.PrimaryPart
        or point:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    if not health
        or not health:IsA("NumberValue")
        or not part then
        return
    end

    if health.Value < 0 then
        return
    end

    if State.CorruptedPointESPObjects[part] then
        return
    end

    local billboard =
        Instance.new("BillboardGui")

    billboard.Name =
        "CorruptedPointHealthESP"

    billboard.Adornee =
        part

    billboard.Size =
        UDim2.fromOffset(
            190,
            42
        )

    billboard.StudsOffset =
        Vector3.new(
            0,
            4.5,
            0
        )

    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    billboard.MaxDistance = 10000

    billboard.Parent =
        Services.LocalPlayer:WaitForChild(
            "PlayerGui"
        )

    local text =
        Instance.new("TextLabel")

    text.Size =
        UDim2.fromScale(
            1,
            1
        )

    text.BackgroundTransparency = 1

    text.TextColor3 =
        Color3.fromRGB(
            30,
            140,
            255
        )

    text.TextStrokeColor3 =
        Color3.fromRGB(
            0,
            0,
            0
        )

    text.TextStrokeTransparency =
        0.25

    text.TextSize = 13

    text.Font =
        Enum.Font.GothamMedium

    text.TextXAlignment =
        Enum.TextXAlignment.Center

    text.TextYAlignment =
        Enum.TextYAlignment.Center

    text.Parent =
        billboard

    State.CorruptedPointESPObjects[part] =
        billboard

end


local function CreateCorruptedPointESP()

    RemoveCorruptedPointESP()

    for _, point in ipairs(
        workspace:GetChildren()
    ) do

        if point.Name == "CorruptedPoint"
            and point:IsA("Model") then

            CreateCorruptedPointBillboard(point)

        end

    end

    Connect(
        "CorruptedPoint_Added",
        workspace.ChildAdded,
        function(point)

            if not State.CorruptedPointESPEnabled then
                return
            end

            if point.Name ~= "CorruptedPoint"
                or not point:IsA("Model") then
                return
            end

            task.wait()

            CreateCorruptedPointBillboard(point)

        end
    )

    Connect(
        "CorruptedHealth_Update",
        Services.RunService.Heartbeat,
        function()

            if not State.CorruptedPointESPEnabled then
                return
            end

            local character =
                Services.LocalPlayer.Character

            local root =
                character
                and character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not root then
                return
            end

            for part, billboard in pairs(
                State.CorruptedPointESPObjects
            ) do

                if not part
                    or not part.Parent
                    or not billboard
                    or not billboard.Parent then

                    State.CorruptedPointESPObjects[part] = nil

                    if billboard then
                        billboard:Destroy()
                    end

                    continue

                end

                local point =
                    part:FindFirstAncestor(
                        "CorruptedPoint"
                    )

                if not point
                    or not point:IsA("Model") then

                    State.CorruptedPointESPObjects[part] = nil

                    billboard:Destroy()

                    continue

                end

                local health =
                    point:FindFirstChild("Health")

                if not health
                    or not health:IsA("NumberValue") then

                    continue

                end

                if health.Value < 0 then

                    State.CorruptedPointESPObjects[part] = nil

                    billboard:Destroy()

                    continue

                end

                local text =
                    billboard:FindFirstChildOfClass(
                        "TextLabel"
                    )

                if not text then
                    continue
                end

                local distance =
                    math.floor(
                        (
                            root.Position
                            - part.Position
                        ).Magnitude
                    )

                text.Text =
                    "[Corrupted Point]"
                    .. "\n"
                    .. "Health: "
                    .. tostring(
                        100 - health.Value
                    )
                    .. " | "
                    .. tostring(
                        distance
                    )
                    .. " st"

            end

        end
    )

end


Groupboxes.VisualLeftGroupBox2:AddToggle(
    "CorruptedPointESPToggle",
    {
        Text = "Corrupted Point ESP",
        Default = false
    }
):OnChanged(function(Value)

    State.CorruptedPointESPEnabled =
        Value

    if Value then

        CreateCorruptedPointESP()

    else

        RemoveCorruptedPointESP()

    end

end)



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
    Groupboxes.VisualRightGroupBox:AddToggle(
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

State.BrightnessLevel = State.BrightnessLevel or 2
State.FullBrightEnabled = State.FullBrightEnabled or false
State.FullBrightConnection = nil
State.OldBrightness = nil


Groupboxes.VisualRightGroupBox2:AddSlider("BrightnessLevel", {
    Text = "Brightness",
    Default = 2,
    Min = 0,
    Max = 10,
    Rounding = 1,

    Callback = function(Value)
        State.BrightnessLevel = Value

        if State.FullBrightEnabled then
            Services.Lighting.Brightness = Value
        end
    end
})


function funcs.fullBright(state)

    State.FullBrightEnabled = state

    if State.FullBrightConnection then
        State.FullBrightConnection:Disconnect()
        State.FullBrightConnection = nil
    end

    if state then

        State.OldBrightness = Services.Lighting.Brightness

        Services.Lighting.Brightness = State.BrightnessLevel

        State.FullBrightConnection =
            Services.RunService.RenderStepped:Connect(function()

                if not State.FullBrightEnabled then
                    return
                end

                Services.Lighting.Brightness = State.BrightnessLevel

            end)

    else

        if State.OldBrightness ~= nil then
            Services.Lighting.Brightness = State.OldBrightness
            State.OldBrightness = nil
        end

    end
end

funcs.noRain = function(state)
	if not state then
		if BaseLocals.noRainLoop then
			task.cancel(BaseLocals.noRainLoop)
			BaseLocals.noRainLoop = nil
		end

		return
	end

	BaseLocals.noRainLoop = task.spawn(function()
		while true do
			Services.ReplicatedStorage.Raining.Value = ""
			task.wait()
		end
	end)
end


Groupboxes.VisualRightGroupBox2:AddToggle(
    "FullBright",
    {
        Text = "Full Bright",
        Default = false,
    }
):OnChanged(function()
    funcs.fullBright(Toggles.FullBright.Value)
end)

Groupboxes.VisualRightGroupBox2:AddToggle("NoFog", {
	Text = "No Fog",
	Default = false,

	Callback = function(state)
		if State.noFogConnection then
			State.noFogConnection:Disconnect()
			State.noFogConnection = nil
		end

		if state then
			State.oldFogEnd = Services.Lighting.FogEnd

			-- İlk uygulama
			Services.Lighting.FogEnd = 9999999999

			State.noFogConnection = Services.Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
				if Services.Lighting.FogEnd ~= 9999999999 then
					Services.Lighting.FogEnd = 9999999999
				end
			end)
		else
			if State.oldFogEnd ~= nil then
				Services.Lighting.FogEnd = State.oldFogEnd
				State.oldFogEnd = nil
			end
		end
	end
})

Modules.NoRainToggle = Groupboxes.VisualRightGroupBox2:AddToggle("NoRain", {
	Text = "No Rain",
	Default = false
})

Modules.NoRainToggle:OnChanged(function(Value)
	funcs.noRain(Value)
end)


task.wait(0.01)

-- Automation

Groupboxes.AutomationLeftGroupBox = Tabs.Automation:AddLeftGroupbox("Automation", "bot")
Groupboxes.SellItems = Tabs.Automation:AddRightGroupbox("Auto Sell", "hand-coins")  

State.SellBowls = false

funcs.SellBowlsLoop = function()

    if State.SellBowlsLoopRunning then
        return
    end

    State.SellBowlsLoopRunning = true

    task.spawn(function()

        while State.SellBowls do

            BaseLocals.PlayerData =
                dataFunction:InvokeServer(
                    "GetData"
                )

            if not BaseLocals.PlayerData then
                task.wait(0.2)
                continue
            end

            BaseLocals.Selected = nil
            BaseLocals.SelectedIndex = nil

            BaseLocals.Loadout =
                BaseLocals.PlayerData.Loadout

            if type(BaseLocals.Loadout) == "table" then

                for Index, Value in pairs(
                    BaseLocals.Loadout
                ) do

                    if type(Value) == "table"
                        and type(Value.Item) == "string" then

                        BaseLocals.Index =
                            Index

                        BaseLocals.Value =
                            Value

                        BaseLocals.ItemName =
                            Value.Item

                        BaseLocals.ItemData =
                            gameManager.Items[
                                BaseLocals.ItemName
                            ]

                        if BaseLocals.ItemData
                            and type(BaseLocals.ItemData) == "table"
                            and BaseLocals.ItemData.ExtraInfo == "FruitBowl" then

                            BaseLocals.Selected =
                                BaseLocals.ItemName

                            BaseLocals.SelectedIndex =
                                Index

                            break

                        end

                    end

                end

            end

            if not BaseLocals.Selected then

                BaseLocals.ClientGui =
                    Services.LocalPlayer.PlayerGui:FindFirstChild(
                        "ClientGui"
                    )

                if BaseLocals.ClientGui then

                    BaseLocals.Mainframe =
                        BaseLocals.ClientGui:FindFirstChild(
                            "Mainframe"
                        )

                    BaseLocals.LoadoutGui =
                        BaseLocals.Mainframe
                        and BaseLocals.Mainframe:FindFirstChild(
                            "Loadout"
                        )

                    BaseLocals.Inventory =
                        BaseLocals.LoadoutGui
                        and BaseLocals.LoadoutGui:FindFirstChild(
                            "Inventory"
                        )

                    BaseLocals.InventoryScroll =
                        BaseLocals.Inventory
                        and BaseLocals.Inventory:FindFirstChild(
                            "InventoryScroll"
                        )

                end

                if BaseLocals.InventoryScroll then

                    for SlotIndex = 1, 100 do

                        BaseLocals.Slot =
                            BaseLocals.InventoryScroll:FindFirstChild(
                                "InvSlot" .. SlotIndex
                            )

                        if BaseLocals.Slot then

                            BaseLocals.SlotText =
                                BaseLocals.Slot:FindFirstChild(
                                    "SlotText"
                                )

                            if BaseLocals.SlotText then

                                BaseLocals.SlotValue =
                                    BaseLocals.SlotText.Text

                                if type(
                                    BaseLocals.SlotValue
                                ) == "string"
                                    and BaseLocals.SlotValue ~= "" then

                                    BaseLocals.CleanName =
                                        BaseLocals.SlotValue:lower():gsub(
                                            "%s+",
                                            ""
                                        )

                                    if BaseLocals.CleanName:find(
                                        "fruitbowl",
                                        1,
                                        true
                                    ) then

                                        BaseLocals.Selected =
                                            BaseLocals.SlotValue

                                        BaseLocals.SelectedIndex =
                                            SlotIndex

                                        break

                                    end

                                end

                            end

                        end

                    end

                end

            end

            if not BaseLocals.Selected then
                task.wait(0.2)
                continue
            end

            BaseLocals.Merchant =
                workspace:FindFirstChild(
                    "Food Merchant",
                    true
                )

            if not BaseLocals.Merchant then
                task.wait(0.2)
                continue
            end

            BaseLocals.DialogPart =
                BaseLocals.Merchant:FindFirstChild(
                    "HumanoidRootPart"
                )
                or BaseLocals.Merchant:FindFirstChild(
                    "Main"
                )
                or BaseLocals.Merchant

            BaseLocals.SelectedItem =
                BaseLocals.Selected

            BaseLocals.ItemData =
                gameManager.Items[
                    BaseLocals.SelectedItem
                ]

            if not BaseLocals.ItemData then

                for ItemName, Data in pairs(
                    gameManager.Items
                ) do

                    if type(Data) == "table"
                        and Data.ExtraInfo == "FruitBowl"
                        and ItemName:lower()
                            == BaseLocals.SelectedItem:lower() then

                        BaseLocals.ItemName =
                            ItemName

                        BaseLocals.Data =
                            Data

                        BaseLocals.SelectedItem =
                            ItemName

                        BaseLocals.ItemData =
                            Data

                        break

                    end

                end

            end

            if not BaseLocals.ItemData then
                task.wait(0.2)
                continue
            end

            BaseLocals.Events =
                Services.ReplicatedStorage:FindFirstChild(
                    "Events"
                )

            BaseLocals.DataEvent =
                BaseLocals.Events
                and BaseLocals.Events:FindFirstChild(
                    "DataEvent"
                )

            if not BaseLocals.DataEvent then
                task.wait(0.2)
                continue
            end

            BaseLocals.DataEvent:FireServer(
                "Item",
                "Selected",
                BaseLocals.SelectedItem
            )

            task.wait(0.05)

            if not State.SellBowls then
                break
            end

            BaseLocals.MerchantVillage =
                BaseLocals.DialogPart:GetAttribute(
                    "Village"
                )
                or BaseLocals.Merchant:GetAttribute(
                    "Village"
                )

            BaseLocals.PlayerVillage =
                BaseLocals.PlayerData.Village

            BaseLocals.VillageData,
            BaseLocals.VillageMonth,
            BaseLocals.VillageWeek =
                dataFunction:InvokeServer(
                    "getVillageData"
                )

            local function getVillageData(
                village,
                month,
                week
            )

                if not village
                    or not BaseLocals.VillageData then

                    return nil
                end

                BaseLocals.MonthData =
                    BaseLocals.VillageData[
                        "Month" ..
                        (month or BaseLocals.VillageMonth)
                    ]

                if not BaseLocals.MonthData then
                    return nil
                end

                BaseLocals.WeekData =
                    BaseLocals.MonthData[
                        "Week" ..
                        (week or BaseLocals.VillageWeek)
                    ]

                if not BaseLocals.WeekData then
                    return nil
                end

                return BaseLocals.WeekData[village]

            end

            local function getVillageRelationship(
                village1,
                village2
            )

                if not village1
                    or not village2 then

                    return nil
                end

                if village1 == "Rogue"
                    or village2 == "Rogue" then

                    return "War"
                end

                if village1 == "Neutral"
                    or village2 == "Neutral" then

                    return "Neutral"
                end

                if village1 == village2 then
                    return "Own"
                end

                BaseLocals.V1 =
                    getVillageData(village1)

                BaseLocals.V2 =
                    getVillageData(village2)

                if not BaseLocals.V1
                    or not BaseLocals.V2 then

                    return "Neutral"
                end

                if BaseLocals.V1.Politics
                    and BaseLocals.V1.Politics.Alliances
                    and table.find(
                        BaseLocals.V1.Politics.Alliances,
                        village2
                    ) then

                    return "Allied"
                end

                if BaseLocals.V2.Politics
                    and BaseLocals.V2.Politics.Alliances
                    and table.find(
                        BaseLocals.V2.Politics.Alliances,
                        village1
                    ) then

                    return "Allied"
                end

                if BaseLocals.V1.Politics
                    and BaseLocals.V1.Politics.Wars
                    and table.find(
                        BaseLocals.V1.Politics.Wars,
                        village2
                    ) then

                    return "War"
                end

                if BaseLocals.V2.Politics
                    and BaseLocals.V2.Politics.Wars
                    and table.find(
                        BaseLocals.V2.Politics.Wars,
                        village1
                    ) then

                    return "War"
                end

                return "Neutral"

            end

            BaseLocals.Relationship =
                getVillageRelationship(
                    BaseLocals.PlayerVillage,
                    BaseLocals.MerchantVillage
                )

            BaseLocals.Economy =
                "Average"

            if BaseLocals.MerchantVillage == "Rogue" then

                BaseLocals.Economy =
                    "Struggling"

            elseif BaseLocals.MerchantVillage
                and BaseLocals.MerchantVillage ~= "Neutral" then

                BaseLocals.MerchantData =
                    getVillageData(
                        BaseLocals.MerchantVillage
                    )

                if BaseLocals.MerchantData
                    and BaseLocals.MerchantData.Politics
                    and BaseLocals.MerchantData.Politics.Economy then

                    BaseLocals.Economy =
                        BaseLocals.MerchantData.Politics.Economy

                end

            end

            BaseLocals.BasePrice =
                gameManager:getPrice(
                    BaseLocals.SelectedItem
                )

            if not BaseLocals.BasePrice then
                task.wait(0.1)
                continue
            end

            BaseLocals.FinalPrice =
                gameManager:getModifiedPrice(
                    BaseLocals.BasePrice,
                    BaseLocals.Relationship,
                    BaseLocals.Economy,
                    "Sell"
                )

            task.wait(0.05)

            if not State.SellBowls then
                break
            end

            BaseLocals.Result =
                dataFunction:InvokeServer(
                    "SellFood",
                    BaseLocals.SelectedItem,
                    BaseLocals.FinalPrice,
                    nil,
                    BaseLocals.DialogPart
                )

            task.wait(0.05)

        end

        State.SellBowlsLoopRunning =
            false

    end)

end


Modules.SellBowls =
    Groupboxes.SellItems:AddToggle(
        "SellBowls",
        {
            Text = "Auto Sell Bowls",
            Default = false
        }
    )

Modules.SellBowls:OnChanged(function(Value)

    State.SellBowls =
        Value

    if State.SellBowls then

        State.SellBowlsLoopRunning =
            false

        funcs.SellBowlsLoop()

    else

        State.SellBowlsLoopRunning =
            false

    end

end)

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
    State.PickupList[pos] = obj

    obj.Destroying:Connect(function()
        if State.PickupList[pos] == obj then
            State.PickupList[pos] = nil
        end
    end)
end

for _, child in ipairs(workspace:GetDescendants()) do
    task.spawn(onChildAdded, child)
end

workspace.DescendantAdded:Connect(onChildAdded)

Groupboxes.AutomationLeftGroupBox:AddToggle("AutoPickup", {
    Text = "Auto Pickup",
    Default = false,

    Callback = function(state)
        State.AutoPick = state
        State.AutoPickupEnabled = state

        if State.AutoPickupConnection then
            State.AutoPickupConnection:Disconnect()
            State.AutoPickupConnection = nil
        end

        if not state then
            return
        end

        State.AutoPickupConnection =
            Services.RunService.Heartbeat:Connect(function()

                local character =
                    Services.Players.LocalPlayer.Character

                if not character then
                    return
                end

                local rootPart =
                    character:FindFirstChild("HumanoidRootPart")

                if not rootPart then
                    return
                end

                for pos, obj in pairs(State.PickupList) do
                    if obj and obj.Parent then

                        local distance =
                            (rootPart.Position - pos).Magnitude

                        if distance < State.FruitPickRange then
                            local id =
                                obj:FindFirstChild("ID")

                            if id then
                                dataEvent:FireServer(
                                    "PickUp",
                                    id.Value
                                )
                            end
                        end

                    else
                        State.PickupList[pos] = nil
                    end
                end
            end)
    end
})

BaseLocals.BowlHolder =
	workspace:WaitForChild("BowlHolderHyuga")

BaseLocals.CookingWater =
	workspace:WaitForChild("FruitCookerHyuga")
		:WaitForChild("CookingWater")

BaseLocals.BowlFinish =
	BaseLocals.BowlHolder:WaitForChild("BowlFinish")


funcs.placeBowl = function()
	if not BaseLocals.BowlHolder then
		return false
	end

	DataEvent:FireServer(
		"PlaceBowl",
		BaseLocals.BowlHolder
	)

	return true
end


funcs.addFruit = function(itemName)
	if not BaseLocals.CookingWater then
		return false
	end

	DataEvent:FireServer(
		"AddFruit",
		BaseLocals.CookingWater,
		itemName
	)

	return true
end


funcs.finishBowl = function()
	if not BaseLocals.BowlFinish then
		return false
	end

	DataEvent:FireServer(
		"BowlFinish",
		BaseLocals.BowlFinish
	)

	return true
end

State.RecipeNames = {}

BaseLocals.Recipes = {

    ["Tangerina Fruit Bowl"] = {
        Ingredients = {
            {
                Item = "Orange",
                Amount = 3
            }
        }
    },

    ["Bolive Soup"] = {
        Ingredients = {
            {
                Item = "Bolive Crops",
                Amount = 2
            },
            {
                Item = "Orange",
                Amount = 2
            },
            {
                Item = "Mango",
                Amount = 1
            }
        }
    },

    ["Alluring Fruit Bowl"] = {
        Ingredients = {
            {
                Item = "Alluring Apple",
                Amount = 2
            },
            {
                Item = "Apple",
                Amount = 3
            },
        }
    },

    ["Chakra Soup"] = {
        Ingredients = {
            {
                Item = "Chakra Crop",
                Amount = 2
            },
            {
                Item = "Seaweed",
                Amount = 2
            },
            {
                Item = "Pear",
                Amount = 1
            },
        }
    },

    ["Saltwater Seaweed Bowl"] = {
        Ingredients = {
            {
                Item = "Seaweed",
                Amount = 3
            },
        }
    },

    ["Chickenanga Meat Bowl"] = {
        Ingredients = {
            {
                Item = "Mango",
                Amount = 3
            },
            {
                Item = "Chicken",
                Amount = 2
            },
        }
    },

    ["Manganana Fruit Bowl"] = {
        Ingredients = {
            {
                Item = "Mango",
                Amount = 2
            },
            {
                Item = "Banana",
                Amount = 3
            },
        }
    },

    ["Pearapple Fruit Bowl"] = {
        Ingredients = {
            {
                Item = "Apple",
                Amount = 2
            },
            {
                Item = "Pear",
                Amount = 2
            },
        }
    },

}


for RecipeName in pairs(
    BaseLocals.Recipes
) do

    table.insert(
        State.RecipeNames,
        RecipeName
    )

end

Groupboxes.AutomationLeftGroupBox:AddToggle(
    "AutoBowls",
    {
        Text = "Auto Bowl",
        Default = false,

        Callback = function(Value)

            State.AutoBowls =
                Value

            if not Value then

                if BaseLocals.BowlLoop then

                    task.cancel(
                        BaseLocals.BowlLoop
                    )

                    BaseLocals.BowlLoop =
                        nil

                end

                return

            end


            if BaseLocals.BowlLoop then
                return
            end


            BaseLocals.BowlLoop =
                task.spawn(function()

                    while State.AutoBowls do


                        local recipe =
                            BaseLocals.Recipes[
                                State.SelectedRecipe
                            ]


                        if not recipe
                            or not recipe.Ingredients then

                            task.wait(
                                State.BowlCooldown
                            )

                            continue

                        end

                        local PlayerData =
                            dataFunction:InvokeServer(
                                "GetData"
                            )


                        local OwnedItems =
                            {}

                        if PlayerData
                            and type(
                                PlayerData.Loadout
                            ) == "table" then

                            for _, Value in pairs(
                                PlayerData.Loadout
                            ) do

                                if type(Value) == "table"
                                    and Value.Item then

                                    local quantity =
                                        tonumber(
                                            Value.Quantity
                                        ) or 0


                                    OwnedItems[
                                        Value.Item
                                    ] =
                                        (
                                            OwnedItems[
                                                Value.Item
                                            ] or 0
                                        )
                                        + quantity

                                end

                            end

                        end

                        local HasEnough =
                            true

                        local MissingItem =
                            nil

                        local OwnedAmount =
                            0

                        local RequiredAmount =
                            0


                        for _, ingredient in ipairs(
                            recipe.Ingredients
                        ) do

                            local owned =
                                OwnedItems[
                                    ingredient.Item
                                ] or 0


                            if owned <
                                ingredient.Amount then

                                HasEnough =
                                    false

                                MissingItem =
                                    ingredient.Item

                                OwnedAmount =
                                    owned

                                RequiredAmount =
                                    ingredient.Amount

                                break

                            end

                        end

                        if not HasEnough then

                            Library:Notify({
                                Title =
                                    "Not Enough Items",

                                Description =
                                    MissingItem
                                    .. " "
                                    .. tostring(
                                        OwnedAmount
                                    )
                                    .. "/"
                                    .. tostring(
                                        RequiredAmount
                                    ),

                                Time = 3
                            })


                            if Toggles.AutoBowls then

                                Toggles.AutoBowls:SetValue(
                                    false
                                )

                            else

                                State.AutoBowls =
                                    false

                            end


                            return

                        end


                        funcs.placeBowl()


                        task.wait(
                            State.BowlCooldown
                        )


                        if not State.AutoBowls then
                            break
                        end


                        for _, ingredient in ipairs(
                            recipe.Ingredients
                        ) do

                            for i = 1,
                                ingredient.Amount do

                                if not State.AutoBowls then
                                    break
                                end


                                funcs.addFruit(
                                    ingredient.Item
                                )


                                task.wait(
                                    State.BowlCooldown
                                )

                            end


                            if not State.AutoBowls then
                                break
                            end

                        end


                        if not State.AutoBowls then
                            break
                        end


                        funcs.finishBowl()


                        task.wait(
                            State.BowlCooldown
                        )

                    end


                    BaseLocals.BowlLoop =
                        nil

                end)

        end
    }
)




Groupboxes.AutomationLeftGroupBox:AddLabel(
    "Auto Bowl Settings"
)


Modules.RecipeDropdown =
    Groupboxes.AutomationLeftGroupBox:AddDropdown(
        "RecipeDropdown",
        {
            Text = "Recipes",
            Values = State.RecipeNames,
            Multi = false,
            Default = 1
        }
    )


State.SelectedRecipe =
    State.RecipeNames[1]


Modules.RecipeDropdown:OnChanged(function(Value)

    State.SelectedRecipe =
        Value

end)


Modules.BowlCooldownSlider =
    Groupboxes.AutomationLeftGroupBox:AddSlider(
        "BowlCooldown",
        {
            Text = "Bowl Cooldown",
            Default = 0.25,
            Min = 0.01,
            Max = 1,
            Rounding = 2,
            Compact = false
        }
    )


State.BowlCooldown =
    0.25


Modules.BowlCooldownSlider:OnChanged(function(Value)

    State.BowlCooldown =
        Value

end)



Groupboxes.AutomationLeftGroupBox:AddButton(
    "MakeBowlOnce",
    {
        Text = "Make Bowl",

        Func = function()

            if BaseLocals.BowlOnceRunning then
                return
            end

            BaseLocals.BowlOnceRunning = true

            task.spawn(function()

                --------------------------------------------------
                -- SELECTED RECIPE
                --------------------------------------------------

                local recipe =
                    BaseLocals.Recipes[
                        State.SelectedRecipe
                    ]

                if not recipe
                    or type(recipe.Ingredients) ~= "table" then

                    Library:Notify({
                        Title = "Recipe Error",
                        Description = "Invalid recipe selected.",
                        Time = 3
                    })

                    BaseLocals.BowlOnceRunning = nil
                    return
                end


                --------------------------------------------------
                -- GET PLAYER DATA
                --------------------------------------------------

                local PlayerData =
                    dataFunction:InvokeServer(
                        "GetData"
                    )


                --------------------------------------------------
                -- CHECK ALL INGREDIENTS
                --------------------------------------------------

                local MissingItems = {}

                if PlayerData
                    and type(PlayerData.Loadout) == "table" then

                    for _, Ingredient in ipairs(
                        recipe.Ingredients
                    ) do

                        local OwnedAmount = 0

                        for _, Value in pairs(
                            PlayerData.Loadout
                        ) do

                            if type(Value) == "table"
                                and Value.Item == Ingredient.Item then

                                OwnedAmount +=
                                    tonumber(
                                        Value.Quantity
                                    ) or 0

                            end

                        end

                        if OwnedAmount < Ingredient.Amount then

                            table.insert(
                                MissingItems,
                                Ingredient.Item
                                    .. " "
                                    .. tostring(OwnedAmount)
                                    .. "/"
                                    .. tostring(Ingredient.Amount)
                            )

                        end

                    end

                end


                --------------------------------------------------
                -- NOT ENOUGH ITEMS
                --------------------------------------------------

                if #MissingItems > 0 then

                    Library:Notify({
                        Title = "Not Enough Items",
                        Description =
                            table.concat(
                                MissingItems,
                                ", "
                            ),
                        Time = 4
                    })

                    BaseLocals.BowlOnceRunning = nil
                    return

                end


                --------------------------------------------------
                -- PLACE BOWL
                --------------------------------------------------

                funcs.placeBowl()

                task.wait(
                    State.BowlCooldown
                )


                --------------------------------------------------
                -- ADD INGREDIENTS
                --------------------------------------------------

                for _, Ingredient in ipairs(
                    recipe.Ingredients
                ) do

                    for i = 1, Ingredient.Amount do

                        funcs.addFruit(
                            Ingredient.Item
                        )

                        task.wait(
                            State.BowlCooldown
                        )

                    end

                end


                --------------------------------------------------
                -- FINISH BOWL
                --------------------------------------------------

                funcs.finishBowl()

                task.wait(
                    State.BowlCooldown
                )


                --------------------------------------------------
                -- DONE
                --------------------------------------------------

                Library:Notify({
                    Title = "Bowl Created",
                    Description =
                        State.SelectedRecipe
                        .. " completed.",
                    Time = 3
                })

                BaseLocals.BowlOnceRunning = nil

            end)

        end
    }
)

Groupboxes.AutomationLeftGroupBox:AddLabel("Buy Bowls")

State.BowlAmount = State.BowlAmount or 1

Groupboxes.AutomationLeftGroupBox:AddSlider(
    "BowlAmount",
    {
        Text = "Bowl Amount",

        Default =
            State.BowlAmount,

        Min = 1,

        Max = 100,

        Rounding = 0,

        Compact = false,

        Callback = function(Value)

            State.BowlAmount =
                Value

        end
    }
)

Groupboxes.AutomationLeftGroupBox:AddButton({
    Text = "Buy Bowl",

    Func = function()

        local success, result =
            pcall(function()

                return funcs.buyItem(
                    "Bowl",
                    3,
                    State.BowlAmount
                )

            end)

        if success and result == true then

            Library:Notify({
                Title = "Item Purchased",
                Description =
                    "Purchased "
                    .. tostring(State.BowlAmount)
                    .. " Bowl(s)",
                Duration = 3
            })

        else

            Library:Notify({
                Title = "Purchase Failed",
                Description =
                    tostring(result),
                Duration = 3
            })

        end

    end
})


-- Botting

Groupboxes.BottingLeftGroupBox = Tabs.Botting:AddLeftGroupbox("Auto Farm Settings", "settings")
Groupboxes.BottingRightGroupBox = Tabs.Botting:AddRightGroupbox("Auto Farm", "bot")

State.TreeFarmEnabled =State.TreeFarmEnabled or false
State.TreeFloatVelocity =State.TreeFloatVelocity or nil
State.AutoPickupConnectionName = State.AutoPickupConnectionName or nil
State.TreeFarmRunId = State.TreeFarmRunId or 0
State.CurrentTreeFarmKey = State.CurrentTreeFarmKey or nil
State.TreePlayerRange = State.TreePlayerRange or 150
State.TreeFarmPreviousNoFallState = State.TreeFarmPreviousNoFallState or false
State.TreeFarmNoFallOldNamecall = State.TreeFarmNoFallOldNamecall or nil
State.TreeFarmScreenGui =State.TreeFarmScreenGui or nil
State.TreeFarmMainFrame =State.TreeFarmMainFrame or nil
State.TreeFarmStatus =State.TreeFarmStatus or nil
State.TreeFarmTreeLabel =State.TreeFarmTreeLabel or nil
State.TreeFarmStatusDot =State.TreeFarmStatusDot or nil


funcs.getCharacter = function()

    local character =
        Services.LocalPlayer.Character

    if character then
        return character
    end

    return Services.LocalPlayer.CharacterAdded:Wait()

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
        Services.Players:GetPlayers()
    ) do

        if plr ~= Services.LocalPlayer
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

    if not position or not distance then
        return false
    end

    local maxDistance =
        distance * distance

    for _, plr in ipairs(
        Services.Players:GetPlayers()
    ) do

        if plr ~= Services.LocalPlayer then

            local character =
                plr.Character

            if character then

                local hrp =
                    character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if hrp then

                    local offset =
                        hrp.Position - position

                    if offset:Dot(offset)
                        <= maxDistance then

                        return true

                    end
                end
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

    if funcs.fly then
        funcs.fly(false)
    elseif fly then
        fly(false)
    end

    if State.FlyEnabled then
        State.FlyEnabled = false
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

    local safePoints =
        State.SafePointPositions

    if not safePoints then
        return false
    end

    local playerRange =
        State.TreePlayerRange or 150

    local currentPosition =
        hrp.Position

    local nearestSafePoint
    local nearestDistance = math.huge

    for _, safePoint in pairs(
        safePoints
    ) do

        local pointPosition

        if typeof(safePoint) == "Vector3" then

            pointPosition = safePoint

        elseif typeof(safePoint) == "CFrame" then

            pointPosition =
                safePoint.Position

        elseif typeof(safePoint) == "table" then

            if typeof(safePoint.Position)
                == "Vector3" then

                pointPosition =
                    safePoint.Position

            elseif typeof(safePoint.CFrame)
                == "CFrame" then

                pointPosition =
                    safePoint.CFrame.Position

            elseif typeof(safePoint[1]) == "number"
                and typeof(safePoint[2]) == "number"
                and typeof(safePoint[3]) == "number" then

                pointPosition =
                    Vector3.new(
                        safePoint[1],
                        safePoint[2],
                        safePoint[3]
                    )

            end
        end

        if pointPosition
            and not funcs.isPlayerWithinDistance(
                pointPosition,
                playerRange
            ) then

            local distance =
                (
                    pointPosition
                    - currentPosition
                ).Magnitude

            if distance < nearestDistance then

                nearestDistance =
                    distance

                nearestSafePoint =
                    pointPosition

            end
        end
    end

    if not nearestSafePoint then

        if funcs.updateStatus then

            funcs.updateStatus(
                "Safe Point",
                Color3.fromRGB(
                    255,
                    90,
                    90
                ),
                "All safe points have nearby players"
            )

        end

        return false
    end

    local humanoid =
        hrp.Parent:FindFirstChildOfClass(
            "Humanoid"
        )

    local targetPosition =
        nearestSafePoint
        + Vector3.new(0, 3, 0)

    if humanoid then
        humanoid:ChangeState(
            Enum.HumanoidStateType.Physics
        )
    end

    hrp.AssemblyLinearVelocity =
        Vector3.zero

    hrp.AssemblyAngularVelocity =
        Vector3.zero

    hrp.CFrame =
        CFrame.new(
            targetPosition
        )

    task.wait(0.1)

    if not hrp.Parent then
        return false
    end

    hrp.AssemblyLinearVelocity =
        Vector3.zero

    hrp.AssemblyAngularVelocity =
        Vector3.zero

    if (
        hrp.Position
        - targetPosition
    ).Magnitude > 5 then

        hrp.CFrame =
            CFrame.new(
                targetPosition
            )

        task.wait(0.1)

        if not hrp.Parent then
            return false
        end

        hrp.AssemblyLinearVelocity =
            Vector3.zero

        hrp.AssemblyAngularVelocity =
            Vector3.zero

    end

    if humanoid then
        humanoid:ChangeState(
            Enum.HumanoidStateType.GettingUp
        )
    end

    if funcs.updateStatus then

        funcs.updateStatus(
            "Moved To Safe Point",
            Color3.fromRGB(
                90,
                220,
                130
            ),
            "Nearest safe point selected"
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
                and mainBranch
                and mainBranch:IsA("BasePart") then

                table.insert(
                    trees,
                    {
                        Tree = obj,
                        MainBranch = mainBranch,
                        FruitSpawns = fruitSpawns
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

    if not treeData then
        return false
    end

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

    local playerRange =
        State.TreePlayerRange or 150

    if funcs.isPlayerWithinDistance(
        targetPosition,
        playerRange
    ) then

        return false

    end

    if funcs.isAnyActiveChakraUser() then
        return false
    end

    if funcs.noClip then
        funcs.noClip(true)
    elseif noClip then
        noClip(true)
    end

    hrp.CFrame =
        CFrame.new(
            targetPosition
        )

    if State.TreeFloatVelocity then

        State.TreeFloatVelocity:Destroy()
        State.TreeFloatVelocity = nil

    end

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

    hrp.CFrame =
        CFrame.new(
            targetPosition
        )

    return true

end

funcs.checkNearbyPlayerAfterTeleport = function()

    local hrp = funcs.getHRP()

    if not hrp then
        return false
    end

    if funcs.isAnyActiveChakraUser() then

        if funcs.updateStatus then
            funcs.updateStatus(
                "Active Chakra User",
                Color3.fromRGB(255, 180, 70),
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
            Color3.fromRGB(255, 90, 90),
            "Moving to nearest safe point..."
        )
    end

    funcs.teleportToSafePoint()

    return true
end

funcs.createStatusGui = function()

    if State.TreeFarmScreenGui then

        State.TreeFarmScreenGui.Enabled = true

        return

    end


    BaseLocals.ScreenGui =
        Instance.new("ScreenGui")

    BaseLocals.ScreenGui.Name =
        "TreeFarmStatus"

    BaseLocals.ScreenGui.ResetOnSpawn =
        false

    BaseLocals.ScreenGui.IgnoreGuiInset =
        true

    BaseLocals.ScreenGui.Parent =
        Services.LocalPlayer:WaitForChild(
            "PlayerGui"
        )

    State.TreeFarmScreenGui =
        BaseLocals.ScreenGui


    BaseLocals.MainFrame =
        Instance.new("Frame")

    BaseLocals.MainFrame.Name =
        "StatusFrame"

    BaseLocals.MainFrame.Size =
        UDim2.fromOffset(255, 86)

    BaseLocals.MainFrame.AnchorPoint =
        Vector2.new(1, 1)

    BaseLocals.MainFrame.Position =
        UDim2.new(1, -30, 0.72, 0)

    BaseLocals.MainFrame.BackgroundColor3 =
        Color3.fromRGB(20, 100, 190)

    BaseLocals.MainFrame.BackgroundTransparency =
        0.25

    BaseLocals.MainFrame.BorderSizePixel =
        0

    BaseLocals.MainFrame.ZIndex =
        2

    BaseLocals.MainFrame.Parent =
        BaseLocals.ScreenGui

    State.TreeFarmMainFrame =
        BaseLocals.MainFrame


    BaseLocals.Corner =
        Instance.new("UICorner")

    BaseLocals.Corner.CornerRadius =
        UDim.new(0, 18)

    BaseLocals.Corner.Parent =
        BaseLocals.MainFrame


    BaseLocals.Gradient =
        Instance.new("UIGradient")

    BaseLocals.Gradient.Color =
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

    BaseLocals.Gradient.Rotation =
        35

    BaseLocals.Gradient.Parent =
        BaseLocals.MainFrame


    BaseLocals.Stroke =
        Instance.new("UIStroke")

    BaseLocals.Stroke.Color =
        Color3.fromRGB(
            100,
            200,
            255
        )

    BaseLocals.Stroke.Transparency =
        0.35

    BaseLocals.Stroke.Thickness =
        1.5

    BaseLocals.Stroke.Parent =
        BaseLocals.MainFrame


    BaseLocals.Shadow =
        Instance.new("ImageLabel")

    BaseLocals.Shadow.Name =
        "Shadow"

    BaseLocals.Shadow.AnchorPoint =
        Vector2.new(0.5, 0.5)

    BaseLocals.Shadow.Position =
        UDim2.fromScale(0.5, 0.5)

    BaseLocals.Shadow.Size =
        UDim2.new(1, 20, 1, 20)

    BaseLocals.Shadow.BackgroundTransparency =
        1

    BaseLocals.Shadow.Image =
        "rbxassetid://1316045217"

    BaseLocals.Shadow.ImageColor3 =
        Color3.fromRGB(
            0,
            80,
            180
        )

    BaseLocals.Shadow.ImageTransparency =
        0.65

    BaseLocals.Shadow.ScaleType =
        Enum.ScaleType.Slice

    BaseLocals.Shadow.SliceCenter =
        Rect.new(
            10,
            10,
            118,
            118
        )

    BaseLocals.Shadow.ZIndex =
        1

    BaseLocals.Shadow.Parent =
        BaseLocals.MainFrame


    BaseLocals.Content =
        Instance.new("Frame")

    BaseLocals.Content.Name =
        "Content"

    BaseLocals.Content.BackgroundTransparency =
        1

    BaseLocals.Content.Size =
        UDim2.fromScale(1, 1)

    BaseLocals.Content.ZIndex =
        3

    BaseLocals.Content.Parent =
        BaseLocals.MainFrame


    BaseLocals.Padding =
        Instance.new("UIPadding")

    BaseLocals.Padding.PaddingLeft =
        UDim.new(0, 15)

    BaseLocals.Padding.PaddingRight =
        UDim.new(0, 15)

    BaseLocals.Padding.PaddingTop =
        UDim.new(0, 10)

    BaseLocals.Padding.PaddingBottom =
        UDim.new(0, 10)

    BaseLocals.Padding.Parent =
        BaseLocals.Content


    BaseLocals.Header =
        Instance.new("TextLabel")

    BaseLocals.Header.Size =
        UDim2.new(1, -25, 0, 19)

    BaseLocals.Header.BackgroundTransparency =
        1

    BaseLocals.Header.Text =
        "FRUIT FARM"

    BaseLocals.Header.TextColor3 =
        Color3.fromRGB(
            245,
            250,
            255
        )

    BaseLocals.Header.TextSize =
        13

    BaseLocals.Header.Font =
        Enum.Font.GothamBold

    BaseLocals.Header.TextXAlignment =
        Enum.TextXAlignment.Left

    BaseLocals.Header.ZIndex =
        4

    BaseLocals.Header.Parent =
        BaseLocals.Content


    BaseLocals.StatusDot =
        Instance.new("Frame")

    BaseLocals.StatusDot.Size =
        UDim2.fromOffset(8, 8)

    BaseLocals.StatusDot.Position =
        UDim2.new(1, -8, 0, 6)

    BaseLocals.StatusDot.BackgroundColor3 =
        Color3.fromRGB(
            90,
            240,
            150
        )

    BaseLocals.StatusDot.BorderSizePixel =
        0

    BaseLocals.StatusDot.ZIndex =
        4

    BaseLocals.StatusDot.Parent =
        BaseLocals.Content


    BaseLocals.DotCorner =
        Instance.new("UICorner")

    BaseLocals.DotCorner.CornerRadius =
        UDim.new(1, 0)

    BaseLocals.DotCorner.Parent =
        BaseLocals.StatusDot

    State.TreeFarmStatusDot =
        BaseLocals.StatusDot


    BaseLocals.Status =
        Instance.new("TextLabel")

    BaseLocals.Status.Size =
        UDim2.new(1, 0, 0, 20)

    BaseLocals.Status.Position =
        UDim2.fromOffset(0, 26)

    BaseLocals.Status.BackgroundTransparency =
        1

    BaseLocals.Status.Text =
        "Checking Active Chakra Users..."

    BaseLocals.Status.TextColor3 =
        Color3.fromRGB(
            225,
            240,
            255
        )

    BaseLocals.Status.TextSize =
        12

    BaseLocals.Status.Font =
        Enum.Font.GothamMedium

    BaseLocals.Status.TextXAlignment =
        Enum.TextXAlignment.Left

    BaseLocals.Status.TextTruncate =
        Enum.TextTruncate.AtEnd

    BaseLocals.Status.ZIndex =
        4

    BaseLocals.Status.Parent =
        BaseLocals.Content

    State.TreeFarmStatus =
        BaseLocals.Status


    BaseLocals.TreeLabel =
        Instance.new("TextLabel")

    BaseLocals.TreeLabel.Size =
        UDim2.new(1, 0, 0, 18)

    BaseLocals.TreeLabel.Position =
        UDim2.fromOffset(0, 49)

    BaseLocals.TreeLabel.BackgroundTransparency =
        1

    BaseLocals.TreeLabel.Text =
        "Waiting..."

    BaseLocals.TreeLabel.TextColor3 =
        Color3.fromRGB(
            175,
            220,
            255
        )

    BaseLocals.TreeLabel.TextSize =
        11

    BaseLocals.TreeLabel.Font =
        Enum.Font.Gotham

    BaseLocals.TreeLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    BaseLocals.TreeLabel.TextTruncate =
        Enum.TextTruncate.AtEnd

    BaseLocals.TreeLabel.ZIndex =
        4

    BaseLocals.TreeLabel.Parent =
        BaseLocals.Content

    State.TreeFarmTreeLabel =
        BaseLocals.TreeLabel


    BaseLocals.TimerLabel =
        Instance.new("TextLabel")

    BaseLocals.TimerLabel.Name =
        "Timer"

    BaseLocals.TimerLabel.Size =
        UDim2.fromOffset(90, 18)

    BaseLocals.TimerLabel.AnchorPoint =
        Vector2.new(1, 1)

    BaseLocals.TimerLabel.Position =
        UDim2.new(1, -8, 1, -5)

    BaseLocals.TimerLabel.BackgroundTransparency =
        1

    BaseLocals.TimerLabel.Text =
        "Timer: 00:00"

    BaseLocals.TimerLabel.TextColor3 =
        Color3.fromRGB(
            200,
            230,
            255
        )

    BaseLocals.TimerLabel.TextSize =
        10

    BaseLocals.TimerLabel.Font =
        Enum.Font.GothamMedium

    BaseLocals.TimerLabel.TextXAlignment =
        Enum.TextXAlignment.Right

    BaseLocals.TimerLabel.ZIndex =
        4

    BaseLocals.TimerLabel.Parent =
        BaseLocals.Content

    State.TreeFarmTimer =
        BaseLocals.TimerLabel


    BaseLocals.TimerStart =
        tick()

    State.TreeFarmTimerStart =
        BaseLocals.TimerStart


    task.spawn(function()

        while State.TreeFarmScreenGui
            and State.TreeFarmScreenGui.Parent do

            BaseLocals.Elapsed =
                math.floor(
                    tick()
                    - State.TreeFarmTimerStart
                )

            BaseLocals.Minutes =
                math.floor(
                    BaseLocals.Elapsed / 60
                )

            BaseLocals.Seconds =
                BaseLocals.Elapsed % 60


            if State.TreeFarmTimer then

                State.TreeFarmTimer.Text =
                    string.format(
                        "Timer: %02d:%02d",
                        BaseLocals.Minutes,
                        BaseLocals.Seconds
                    )

            end


            task.wait(1)

        end

    end)

end

funcs.hideStatusGui = function()

    if State.TreeFarmScreenGui then

        State.TreeFarmScreenGui.Enabled =false

    end
end

funcs.updateStatus = function(
    text,
    color,
    treeText
)

    BaseLocals.status =
        State.TreeFarmStatus

    if not BaseLocals.status then
        return
    end

    BaseLocals.status.Text =
        text

    if color then

        BaseLocals.status.TextColor3 =
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
            "Life Up Fruit",
            "Fruit Of Forgetfulness"
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
                ).Magnitude <= 350 then

                local playerNearby =
                    funcs.isPlayerWithinDistance(
                        position,
                        TreePlayerRange
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

    position =
        position
        - Vector3.new(
            0,
            0.5,
            0
        )

    hrp.CFrame =
        CFrame.new(position)

    return true

end

funcs.waitForTreeFruits = function(
    treeData
)

    local timeout = 10
    local startTime = tick()
    local currentRunId = State.TreeFarmRunId

    while State.TreeFarmEnabled
        and currentRunId == State.TreeFarmRunId do

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
                or currentRunId ~= State.TreeFarmRunId

            if not State.TreeFarmEnabled
                or currentRunId ~= State.TreeFarmRunId then

                return {}

            end

            startTime = tick()

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
                or currentRunId ~= State.TreeFarmRunId then

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
                    or currentRunId ~= State.TreeFarmRunId

                if not State.TreeFarmEnabled
                    or currentRunId ~= State.TreeFarmRunId then

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


funcs.isPlayerNearFruit = function(
    position
)

    if not position then
        return false
    end

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer then

            local character =
                player.Character

            if character then

                local rootPart =
                    character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if rootPart then

                    local distance =
                        (
                            rootPart.Position
                            - position
                        ).Magnitude

                    if distance <= 75 then
                        return true
                    end

                end
            end
        end
    end

    return false

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
        Services.RunService.Heartbeat,
        function()

            if not State.TreeFarmEnabled then
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

            local pickupList =
                State.PickupList

            if not pickupList then
                return
            end

            local events =
                Services.ReplicatedStorage:FindFirstChild(
                    "Events"
                )

            if not events then
                return
            end

            local dataEvent =
                events:FindFirstChild(
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

                    if typeof(pos) ~= "Vector3" then
                        continue
                    end

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

                else

                    pickupList[pos] =
                        nil

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

                        if method == "FindFirstChild" then

                            local args = {...}

                            if args[1] == "NegateFall"
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
            or currentRunId ~= State.TreeFarmRunId then

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
                or currentRunId ~= State.TreeFarmRunId

            if not State.TreeFarmEnabled
                or currentRunId ~= State.TreeFarmRunId then

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


if not State.TreeFarmEnabled
    or currentRunId ~= State.TreeFarmRunId then
    return
end

        local currentFruits =
            funcs.waitForTreeFruits(
                treeData
            )

        if not State.TreeFarmEnabled
            or currentRunId ~= State.TreeFarmRunId then

            return
        end

        for fruitIndex, fruitData in ipairs(
            currentFruits
        ) do

            if not State.TreeFarmEnabled
                or currentRunId ~= State.TreeFarmRunId then

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
                    or currentRunId ~= State.TreeFarmRunId

                if not State.TreeFarmEnabled
                    or currentRunId ~= State.TreeFarmRunId then

                    return
                end

            end

            if funcs.checkNearbyPlayerAfterTeleport() then
                break
            end

            if fruitData.Object
                and fruitData.Object.Parent then

                local fruitPosition =
                    funcs.getFruitPosition(
                        fruitData.Object
                    )

                if not fruitPosition then
                    continue
                end

                if funcs.isPlayerNearFruit(
                    fruitPosition
                ) then

                    funcs.updateStatus(
                        "Fruit Skipped",
                        Color3.fromRGB(
                            255,
                            190,
                            80
                        ),
                        string.format(
                            "%d / %d  •  Player within 75 studs",
                            fruitIndex,
                            #currentFruits
                        )
                    )

                    task.wait(0.15)

                    continue
                end

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

                    if not funcs.isPlayerNearFruit(
                        fruitPosition
                    ) then

                        local collected =
                            funcs.teleportToFruit(
                                fruitData
                            )

                        if not collected then
                            continue
                        end

                    else

                        funcs.updateStatus(
                            "Fruit Skipped",
                            Color3.fromRGB(
                                255,
                                190,
                                80
                            ),
                            "Player within 75 studs"
                        )

                        task.wait(0.15)

                        continue
                    end
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
        and currentRunId == State.TreeFarmRunId then

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

-- On Work

Modules.TreeFarmToggle =
    Groupboxes.BottingRightGroupBox:AddToggle(
        "TreeFarmToggle",
        {
            Text = "Fruit Farm",
            Default = false
        }
    )

Modules.TreeFarmToggle:OnChanged(function(Value)

    State.TreeFarmEnabled =
        Value

    State.TreeFarmRunId =
        State.TreeFarmRunId + 1

    if not Value then

        State.AutoPick = false

        Disconnect(
            "TreeFarm_AutoPick_Heartbeat"
        )

        if State.TreeFarmPickupChildAdded then

            State.TreeFarmPickupChildAdded:Disconnect()

            State.TreeFarmPickupChildAdded =
                nil

        end

        if State.TreeFarmAnimationTrack then

            State.TreeFarmAnimationTrack:Stop()
            State.TreeFarmAnimationTrack:Destroy()

            State.TreeFarmAnimationTrack =
                nil

        end

        if State.TreeFarmAnimation then

            State.TreeFarmAnimation:Destroy()

            State.TreeFarmAnimation =
                nil

        end

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

    do

        local character =
            Services.LocalPlayer.Character
            or Services.LocalPlayer.CharacterAdded:Wait()

        local humanoid =
            character:FindFirstChildOfClass(
                "Humanoid"
            )

        if humanoid then

            local animator =
                humanoid:FindFirstChildOfClass(
                    "Animator"
                )

            if not animator then

                animator =
                    Instance.new(
                        "Animator"
                    )

                animator.Parent =
                    humanoid

            end

            local animation =
                Instance.new(
                    "Animation"
                )

            animation.AnimationId =
                "rbxassetid://122919972398961"

            local track =
                animator:LoadAnimation(
                    animation
                )

            track.Looped = true
            track:Play()

            State.TreeFarmAnimation =
                animation

            State.TreeFarmAnimationTrack =
                track

        end

    end

    State.PickupList =
        State.PickupList or {}

    local function onPickupAdded(obj)

        if not obj:IsA("BasePart") then
            return
        end

        local pickupable =
            obj:FindFirstChild(
                "Pickupable"
            )

        if not pickupable then
            return
        end

        local id =
            obj:FindFirstChild(
                "ID"
            )

        if not id then
            return
        end

        local pos =
            obj.Position

        State.PickupList[pos] =
            obj

        obj.Destroying:Connect(
            function()

                if State.PickupList[pos] == obj then

                    State.PickupList[pos] =
                        nil

                end

            end
        )

    end

    for _, child in next,
        workspace:GetChildren() do

        task.spawn(
            onPickupAdded,
            child
        )

    end

    if State.TreeFarmPickupChildAdded then

        State.TreeFarmPickupChildAdded:Disconnect()

        State.TreeFarmPickupChildAdded =
            nil

    end

    State.TreeFarmPickupChildAdded =
        workspace.ChildAdded:Connect(
            onPickupAdded
        )

    State.AutoPick =
        true

    State.TreeFarmAutoPickLastRun =
        0

    Disconnect(
        "TreeFarm_AutoPick_Heartbeat"
    )

    Connect(
        "TreeFarm_AutoPick_Heartbeat",
        Services.RunService.Heartbeat,
        function()

            if not State.AutoPick
                or not State.TreeFarmEnabled then

                Disconnect(
                    "TreeFarm_AutoPick_Heartbeat"
                )

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

            local currentTime =
                tick()

            if currentTime
                - State.TreeFarmAutoPickLastRun
                < 0.1 then

                return
            end

            State.TreeFarmAutoPickLastRun =
                currentTime

            local myPosition =
                rootPart.Position

            local pickRange =
                State.FruitPickRange or 50

            for pos, obj in next,
                State.PickupList do

                if obj
                    and obj.Parent then

                    if typeof(pos) ~= "Vector3" then
                        continue
                    end

                    local distance =
                        (
                            myPosition
                            - pos
                        ).Magnitude

                    if distance <= pickRange then

                        local id =
                            obj:FindFirstChild(
                                "ID"
                            )

                        if id then

                            local events =
                                Services.ReplicatedStorage
                                    :FindFirstChild(
                                        "Events"
                                    )

                            local dataEvent =
                                events
                                and events:FindFirstChild(
                                    "DataEvent"
                                )

                            if dataEvent then

                                dataEvent:FireServer(
                                    "PickUp",
                                    id.Value
                                )

                            end

                        end

                    end

                else

                    State.PickupList[pos] =
                        nil

                end

            end

        end
    )

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

                    if State.TreeFarmAnimationTrack
                        and State.TreeFarmAnimationTrack.IsPlaying then

                        State.TreeFarmAnimationTrack:Stop()

                    end

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

                    if State.TreeFarmAnimationTrack
                        and not State.TreeFarmAnimationTrack.IsPlaying then

                        State.TreeFarmAnimationTrack:Play()

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

                    if State.TreeFarmAnimationTrack
                        and not State.TreeFarmAnimationTrack.IsPlaying then

                        State.TreeFarmAnimationTrack:Play()

                    end

                    funcs.runTreeFarm()

                end

                task.wait(0.5)

            end

            State.AutoPick =
                false

            Disconnect(
                "TreeFarm_AutoPick_Heartbeat"
            )

            if State.TreeFarmPickupChildAdded then

                State.TreeFarmPickupChildAdded:Disconnect()

                State.TreeFarmPickupChildAdded =
                    nil

            end

            if State.TreeFarmAnimationTrack then

                State.TreeFarmAnimationTrack:Stop()
                State.TreeFarmAnimationTrack:Destroy()

                State.TreeFarmAnimationTrack =
                    nil

            end

            if State.TreeFarmAnimation then

                State.TreeFarmAnimation:Destroy()

                State.TreeFarmAnimation =
                    nil

            end

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

end)

-- Toggle On Tree

Modules.TreeFarmToggle:AddKeyPicker(
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

Groupboxes.BottingLeftGroupBox:AddSlider(
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
Groupboxes.NotificationsLeftGroupBox = Tabs.Notifications:AddLeftGroupbox("Discord Webhook", "link")
Groupboxes.NotificationsRightGroupBox = Tabs.Notifications:AddRightGroupbox("Notifier", "bell")
Groupboxes.NotificationsLeftGroupBox2 = Tabs.Notifications:AddLeftGroupbox("Send Player Info", "info")

Groupboxes.NotificationsLeftGroupBox:AddInput(
"WebhookURL",
{
Text = "Webhook URL",
Default = "",
Numeric = false,
Finished = false,
ClearTextOnFocus = false,
Placeholder = "Discord Webhook URL...",
}
)

State.webhook = Options.WebhookURL.Value


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

if not player then

    Library:Notify({
        Title = "Inventory Logger",
        Description = "LocalPlayer not found.",
        Duration = 4,
    })

    return
end

State.webhook =
    Options.WebhookURL.Value

local webhook =
    State.webhook

if type(webhook) ~= "string"
    or webhook == "" then

    Library:Notify({
        Title = "Inventory Logger",
        Description = "Please enter a Webhook URL.",
        Duration = 4,
    })

    return
end

local playerGui =
    player:FindFirstChildOfClass(
        "PlayerGui"
    )

local clientGui =
    playerGui
    and playerGui:FindFirstChild(
        "ClientGui"
    )

local mainframe =
    clientGui
    and clientGui:FindFirstChild(
        "Mainframe"
    )

local loadout =
    mainframe
    and mainframe:FindFirstChild(
        "Loadout"
    )

local inventoryGui =
    loadout
    and loadout:FindFirstChild(
        "Inventory"
    )

local scroll =
    inventoryGui
    and inventoryGui:FindFirstChild(
        "InventoryScroll"
    )

if not scroll
    or not loadout then

    Library:Notify({
        Title = "Inventory Logger",
        Description = "Inventory not found.",
        Duration = 4,
    })

    return
end

local inventory = {}
local importantInventory = {}
local importantCount = 0

local RED =
    "\27[2;31m"

local RESET =
    "\27[0m"

local function addItem(
    itemName,
    amount
)

    if not itemName
        or itemName == "" then

        return
    end

    local line

    if amount
        and amount ~= "" then

        line =
            amount
            .. " "
            .. itemName

    else

        line =
            itemName

    end

    local isImportant =
        importantItems[itemName]
        or itemName:match(
            "Schematics$"
        )

    if isImportant then

        table.insert(
            inventory,
            RED
            .. line
            .. RESET
        )

        table.insert(
            importantInventory,
            RED
            .. line
            .. RESET
        )

        importantCount =
            importantCount + 1

    else

        table.insert(
            inventory,
            line
        )

    end
end


for _, slot in
    ipairs(
        scroll:GetChildren()
    ) do

    if slot.Name:match(
        "^InvSlot%d+$"
    ) then

        local slotText =
            slot:FindFirstChild(
                "SlotText"
            )

        local itemNumber =
            slot:FindFirstChild(
                "ItemNumber"
            )

        if slotText
            and slotText:IsA(
                "TextLabel"
            )
            and slotText.Text ~= "" then

            local itemName =
                slotText.Text

            local amount = ""

            if itemNumber then

                local number =
                    itemNumber:FindFirstChild(
                        "Number"
                    )

                if number
                    and number:IsA(
                        "TextLabel"
                    ) then

                    amount =
                        number.Text

                end
            end

            addItem(
                itemName,
                amount
            )
        end
    end
end


for i = 1, 12 do

    local slot =
        loadout:FindFirstChild(
            "Slot"
            .. i
        )

    if slot then

        local slotText =
            slot:FindFirstChild(
                "SlotText"
            )

        local itemNumber =
            slot:FindFirstChild(
                "ItemNumber"
            )

        local itemName = ""
        local amount = ""

        if itemNumber then

            local number =
                itemNumber:FindFirstChild(
                    "Number"
                )

            if number
                and number:IsA(
                    "TextLabel"
                ) then

                amount =
                    number.Text

            end
        end

        if slotText
            and slotText:IsA(
                "TextLabel"
            ) then

            itemName =
                slotText.Text

        end

        addItem(
            itemName,
            amount
        )
    end
end


local inventoryText =
    table.concat(
        inventory,
        "\n"
    )

if inventoryText == "" then
    inventoryText = "Empty"
end


local importantText =
    table.concat(
        importantInventory,
        "\n"
    )

if importantText == "" then
    importantText = "None"
end


local playerName =
    player.Name

local half =
    math.ceil(
        #playerName / 2
    )

local shortName =
    string.sub(
        playerName,
        1,
        half
    )
    .. "..."


local data = {
    username = "Inventory Logger",

    embeds = {
        {
            title = "Inventory Logger",

            description =
                "Important Items Found: **"
                .. tostring(
                    importantCount
                )
                .. "**",

            color = 0x2ECC71,

            fields = {
                {
                    name =
                        "🎒 Current Inventory",

                    value =
                        "```ansi\n"
                        .. inventoryText
                        .. "\n```",

                    inline = false
                },

                {
                    name =
                        "⭐ Important Items",

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


local requestFunction =
    request
    or http_request
    or (syn and syn.request)

if not requestFunction then

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

        return requestFunction({
            Url = webhook,

            Method = "POST",

            Headers = {
                ["Content-Type"] =
                    "application/json"
            },

            Body =
                Services.HttpService:JSONEncode(
                    data
                )
        })

    end)


if not success
    or not response then

    Library:Notify({
        Title = "Webhook Error",
        Description =
            "Failed to send inventory.",
        Duration = 5
    })

    warn(
        "[InventoryWebhook]",
        tostring(response)
    )

    return
end


local statusCode =
    tonumber(
        response.StatusCode
    )

if statusCode
    and statusCode >= 200
    and statusCode < 300 then

    Library:Notify({
        Title = "Inventory Logger",
        Description =
            "Inventory successfully sent!",
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
        "[InventoryWebhook]",
        tostring(
            response.Body
        )
    )
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

local RareDetectedParts = {}

local RARE_SCAN_DISTANCE = 175

local RARE_SCAN_INTERVAL =
0.5

local function SendRareItemWebhook(
itemName
)

if not getgenv().RareItemWebhookEnabled then
    return
end

local player =
    Services.LocalPlayer

if not player then

    warn(
        "[RareWebhook] LocalPlayer not found!"
    )

    return
end

State.webhook =
    Options.WebhookURL.Value

local webhook =
    State.webhook

if type(webhook) ~= "string"
    or webhook == "" then

    warn(
        "[RareWebhook] Webhook URL is empty!"
    )

    return
end


local data = {
    username = "Rare Item Logger",

    embeds = {
        {
            title =
                "⭐ Rare Item Detected",

            description =
                "**"
                .. tostring(
                    itemName
                )
                .. "** was detected.",

            color = 0xFFD700,

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


local requestFunction =
    request
    or http_request
    or (syn and syn.request)

if not requestFunction then

    warn(
        "[RareWebhook] HTTP requests not supported."
    )

    return
end


local success, response =
    pcall(function()

        return requestFunction({
            Url = webhook,

            Method = "POST",

            Headers = {
                ["Content-Type"] =
                    "application/json"
            },

            Body =
                Services.HttpService:JSONEncode(
                    data
                )
        })

    end)


if not success then

    warn(
        "[RareWebhook] Request failed:",
        tostring(response)
    )

    return
end


if not response then

    warn(
        "[RareWebhook] No response received."
    )

    return
end


local statusCode =
    tonumber(
        response.StatusCode
    )

print(
    "[RareWebhook] Status:",
    tostring(
        statusCode
    )
)

print(
    "[RareWebhook] Body:",
    tostring(
        response.Body
    )
)


if statusCode
    and statusCode >= 200
    and statusCode < 300 then

    print(
        "[RareWebhook] Webhook sent successfully:",
        tostring(itemName)
    )

else

    warn(
        "[RareWebhook] Webhook request failed:",
        tostring(statusCode),
        tostring(
            response.Body
        )
    )

end

end

local function IsRareItemName(
itemName
)

itemName =
    tostring(
        itemName or ""
    )

itemName =
    itemName
        :gsub(
            "^%s+",
            ""
        )
        :gsub(
            "%s+$",
            ""
        )

if itemName == "" then
    return false
end

if RareItems[itemName] then
    return true
end

local normalizedName =
    itemName:lower()

for rareName, _ in
    pairs(RareItems) do

    local normalizedRareName =
        tostring(
            rareName
        )
        :lower()
        :gsub(
            "^%s+",
            ""
        )
        :gsub(
            "%s+$",
            ""
        )

    if normalizedName
        == normalizedRareName then

        return true
    end
end

return false


end

local function StartRareItemScanner()

    if getgenv().RareItemScannerRunning then
        return
    end

    getgenv().RareItemScannerRunning = true

    task.spawn(function()

        local overlapParams =
            OverlapParams.new()

        overlapParams.FilterType =
            Enum.RaycastFilterType.Exclude

        while getgenv().RareItemWebhookEnabled do

            local player =
                Services.LocalPlayer

            local character =
                player
                and player.Character

            local rootPart =
                character
                and character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if rootPart then

                overlapParams.FilterDescendantsInstances = {
                    character
                }

                local nearbyParts =
                    workspace:GetPartBoundsInRadius(
                        rootPart.Position,
                        RARE_SCAN_DISTANCE,
                        overlapParams
                    )

                for _, object in
                    ipairs(nearbyParts) do

                    if object:IsA("BasePart")
                        and object.Parent then

                        local itemName =
                            tostring(
                                object.Name
                            )

                        if IsRareItemName(
                            itemName
                        ) then

                            if not RareDetectedParts[object] then

                                RareDetectedParts[object] =
                                    true

                                print(
                                    "[RareWebhook] Rare item detected:",
                                    itemName
                                )

                                SendRareItemWebhook(
                                    itemName
                                )

                            end
                        end
                    end
                end
            end

            task.wait(
                RARE_SCAN_INTERVAL
            )
        end

        getgenv().RareItemScannerRunning =
            false

        table.clear(
            RareDetectedParts
        )

    end)
end

Groupboxes.NotificationsLeftGroupBox:AddButton({
Text = "Send Inventory",

Func = function()
    SendInventory()
end,

DoubleClick = false,

Tooltip =
    "Scan inventory and hotbar, then send to webhook.",

})

getgenv().RareItemWebhookEnabled =
true

Groupboxes.NotificationsLeftGroupBox:AddToggle(
"RareItemWebhookToggle",
{
Text = "Rare Item Webhook",

    Default = true,

    Callback = function(Value)

        getgenv().RareItemWebhookEnabled =
            Value


        if not Value then

            table.clear(
                RareDetectedParts
            )

            return
        end


        StartRareItemScanner()

    end
}

)

StartRareItemScanner()






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

    local player =
        Services.LocalPlayer

    if not player then
        return
    end

    local playerGui =
        player:WaitForChild("PlayerGui")

    ChakraSenseGui =
        Instance.new("ScreenGui")

    ChakraSenseGui.Name =
        "ChakraSenseStatus"

    ChakraSenseGui.ResetOnSpawn =
        false

    ChakraSenseGui.IgnoreGuiInset =
        true

    ChakraSenseGui.Parent =
        playerGui


    ChakraSenseLabel =
        Instance.new("TextLabel")

    ChakraSenseLabel.Name =
        "Status"

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

    ChakraSenseLabel.BackgroundTransparency =
        1

    ChakraSenseLabel.Font =
        Enum.Font.GothamSemibold

    ChakraSenseLabel.TextSize =
        24

    ChakraSenseLabel.TextColor3 =
        Color3.fromRGB(190, 100, 255)

    ChakraSenseLabel.TextStrokeTransparency =
        0.35

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
        UDim2.new(0.5, 0, 0, 75)

    MyChakraTitle.Size =
        UDim2.new(0, 500, 0, 45)

    MyChakraTitle.BackgroundTransparency =
        1

    MyChakraTitle.Font =
        Enum.Font.GothamBold

    MyChakraTitle.TextSize =
        30

    MyChakraTitle.TextColor3 =
        Color3.fromRGB(255, 40, 40)

    MyChakraTitle.TextStrokeColor3 =
        Color3.fromRGB(0, 0, 0)

    MyChakraTitle.TextStrokeTransparency =
        0

    MyChakraTitle.Text =
        "Someone Observed You"

    MyChakraTitle.TextXAlignment =
        Enum.TextXAlignment.Center

    MyChakraTitle.TextYAlignment =
        Enum.TextYAlignment.Center

    MyChakraTitle.Visible =
        false

    MyChakraTitle.Parent =
        ChakraSenseGui


    MyChakraDescription =
        Instance.new("TextLabel")

    MyChakraDescription.Name =
        "MyChakraDescription"

    MyChakraDescription.AnchorPoint =
        Vector2.new(0.5, 0)

    MyChakraDescription.Position =
        UDim2.new(0.5, 0, 0, 105)

    MyChakraDescription.Size =
        UDim2.new(0, 500, 0, 35)

    MyChakraDescription.BackgroundTransparency =
        1

    MyChakraDescription.Font =
        Enum.Font.GothamSemibold

    MyChakraDescription.TextSize =
        22

    MyChakraDescription.TextColor3 =
        Color3.fromRGB(255, 80, 80)

    MyChakraDescription.TextStrokeColor3 =
        Color3.fromRGB(0, 0, 0)

    MyChakraDescription.TextStrokeTransparency =
        0

    MyChakraDescription.Text =
        "Waiting For All Chakra Sense Users"

    MyChakraDescription.TextXAlignment =
        Enum.TextXAlignment.Center

    MyChakraDescription.TextYAlignment =
        Enum.TextYAlignment.Center

    MyChakraDescription.Visible =
        false

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

        ChakraSenseLabel.Visible =
            false

        if MyChakraTitle then
            MyChakraTitle.Visible =
                false
        end

        if MyChakraDescription then
            MyChakraDescription.Visible =
                false
        end

        return
    end


    ChakraSenseLabel.Visible =
        true


    local activePlayers =
        GetActiveChakraPlayers()

    local count =
        #activePlayers


    ChakraSenseLabel.Text =
        "Chakra Sense Active: "
        .. tostring(count)


    if count == 0 then

        ChakraSenseLabel.TextColor3 =
            Color3.fromRGB(
                170,
                170,
                170
            )

    else

        ChakraSenseLabel.TextColor3 =
            Color3.fromRGB(
                170,
                85,
                255
            )
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

        BeingObservedTriggered =
            false

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


    local player =
        Services.LocalPlayer

    if not player then
        return
    end


    local mySettings =
        settings:FindFirstChild(
            player.Name
        )

    if not mySettings then
        return
    end


    table.insert(
        BeingObservedConnections,

        mySettings.ChildAdded:Connect(
            function(child)

                if child.Name ~=
                    "BeingObservedBy" then

                    return
                end


                if not child:IsA(
                    "StringValue"
                ) then

                    return
                end


                BeingObservedTriggered =
                    true


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
end


local function WatchCharacter(
    player,
    character
)

    if not player then
        return
    end

    if not character then
        return
    end


    if TrackedCharacters[character] then
        return
    end


    TrackedCharacters[character] =
        true

    ChakraStates[character] =
        false


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

        TrackedCharacters[character] =
            nil

        ChakraStates[character] =
            nil

        return
    end


    local function ChakraStarted()

        if ChakraStates[character] then
            return
        end


        ChakraStates[character] =
            true


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


        ChakraStates[character] =
            false


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

                    addedConnection =
                        nil
                end


                if removedConnection then

                    removedConnection:Disconnect()

                    removedConnection =
                        nil
                end


                TrackedCharacters[character] =
                    nil

                ChakraStates[character] =
                    nil

                CharacterConnections[character] =
                    nil


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

    if not player then
        return
    end


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

            PlayerConnections[player] =
                nil
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


                CharacterConnections[character] =
                    nil
            end


            TrackedCharacters[character] =
                nil

            ChakraStates[character] =
                nil
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

State.ChakraSenseOwnersGui = nil
State.ChakraSenseOwnersLabel = nil
State.ChakraSenseOwnersNextUpdate = 0


funcs.CreateChakraSenseOwnersUI = function()

    if State.ChakraSenseOwnersGui then

        State.ChakraSenseOwnersGui.Enabled =
            State.ChakraSenseUIEnabled

        if State.ChakraSenseOwnersLabel then

            State.ChakraSenseOwnersLabel.Visible =
                State.ChakraSenseUIEnabled

        end

        return

    end


    local player =
        Services.LocalPlayer

    if not player then
        return
    end


    local playerGui =
        player:WaitForChild(
            "PlayerGui"
        )


    State.ChakraSenseOwnersGui =
        Instance.new("ScreenGui")


    State.ChakraSenseOwnersGui.Name =
        "ChakraSenseOwnersStatus"


    State.ChakraSenseOwnersGui.ResetOnSpawn =
        false


    State.ChakraSenseOwnersGui.IgnoreGuiInset =
        true


    State.ChakraSenseOwnersGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling


    State.ChakraSenseOwnersGui.Enabled =
        State.ChakraSenseUIEnabled


    State.ChakraSenseOwnersGui.Parent =
        playerGui


    State.ChakraSenseOwnersLabel =
        Instance.new("TextLabel")


    State.ChakraSenseOwnersLabel.Name =
        "Owners"


    State.ChakraSenseOwnersLabel.AnchorPoint =
        Vector2.new(
            0.5,
            0
        )


    State.ChakraSenseOwnersLabel.Position =
        UDim2.new(
            0.5,
            0,
            0,
            55
        )


    State.ChakraSenseOwnersLabel.Size =
        UDim2.new(
            0,
            600,
            0,
            42
        )


    State.ChakraSenseOwnersLabel.BackgroundTransparency =
        1


    State.ChakraSenseOwnersLabel.BorderSizePixel =
        0


    State.ChakraSenseOwnersLabel.TextXAlignment =
        Enum.TextXAlignment.Center


    State.ChakraSenseOwnersLabel.TextYAlignment =
        Enum.TextYAlignment.Center


    State.ChakraSenseOwnersLabel.Font =
        Enum.Font.GothamSemibold


    State.ChakraSenseOwnersLabel.TextSize =
        24


    State.ChakraSenseOwnersLabel.TextColor3 =
        Color3.fromRGB(
            205,
            120,
            255
        )


    State.ChakraSenseOwnersLabel.TextStrokeColor3 =
        Color3.fromRGB(
            0,
            0,
            0
        )


    State.ChakraSenseOwnersLabel.TextStrokeTransparency =
        0.5


    State.ChakraSenseOwnersLabel.Text =
        "Chakra Sense Owners: 0"


    State.ChakraSenseOwnersLabel.Visible =
        State.ChakraSenseUIEnabled


    State.ChakraSenseOwnersLabel.Parent =
        State.ChakraSenseOwnersGui


    local padding =
        Instance.new("UIPadding")


    padding.PaddingLeft =
        UDim.new(
            0,
            14
        )


    padding.PaddingRight =
        UDim.new(
            0,
            14
        )


    padding.Parent =
        State.ChakraSenseOwnersLabel

end


funcs.UpdateChakraSenseOwnersUI = function()

    if not State.ChakraSenseUIEnabled then
        return
    end


    if not State.ChakraSenseOwnersGui
        or not State.ChakraSenseOwnersLabel then

        funcs.CreateChakraSenseOwnersUI()

    end


    if not State.ChakraSenseOwnersLabel then
        return
    end


    local cooldowns =
        Services.ReplicatedStorage:FindFirstChild(
            "Cooldowns"
        )


    if not cooldowns then

        State.ChakraSenseOwnersLabel.Text =
            "Chakra Sense Owners: 0"

        return

    end


    local owners = {}


    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        local playerFolder =
            cooldowns:FindFirstChild(
                player.Name
            )


        if playerFolder then

            local chakraSense =
                playerFolder:FindFirstChild(
                    "Chakra Sense"
                )


            if chakraSense
                and chakraSense:IsA("NumberValue") then

                table.insert(
                    owners,
                    player.Name
                )

            end

        end

    end


    table.sort(
        owners
    )


    if #owners == 0 then

        State.ChakraSenseOwnersLabel.Text =
            "Chakra Sense Owners: 0"


        State.ChakraSenseOwnersLabel.TextColor3 =
            Color3.fromRGB(
                170,
                170,
                180
            )

    else

        State.ChakraSenseOwnersLabel.Text =
            "Chakra Sense Owners: "
            .. tostring(
                #owners
            )


        State.ChakraSenseOwnersLabel.TextColor3 =
            Color3.fromRGB(
                205,
                120,
                255
            )

    end

end


Groupboxes.NotificationsRightGroupBox:AddToggle(
    "ChakraSenseStatus",
    {
        Text = "Chakra Sense Detector",

        Default =
            State.ChakraSenseUIEnabled,

        Callback = function(Value)

            State.ChakraSenseUIEnabled =
                Value


            if Value then

                funcs.CreateChakraSenseOwnersUI()

                funcs.UpdateChakraSenseOwnersUI()

            else

                if State.ChakraSenseOwnersGui then

                    State.ChakraSenseOwnersGui.Enabled =
                        false

                end

            end

        end
    }
)


Connect(
    "ChakraSenseOwners_Update",
    Services.RunService.Heartbeat,
    function()

        if not State.ChakraSenseUIEnabled then
            return
        end


        if os.clock() >=
            (State.ChakraSenseOwnersNextUpdate or 0) then

            State.ChakraSenseOwnersNextUpdate =
                os.clock() + 0.2


            funcs.UpdateChakraSenseOwnersUI()

        end

    end
)


Groupboxes.NotificationsRightGroupBox:AddToggle(
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


Modules.TargetDropdown = Groupboxes.NotificationsLeftGroupBox2:AddDropdown(
    "TargetDropdown",
    {
        Values = {},
        Default = nil,
        Multi = false,
        Text = "Select Target Player",
        Tooltip = "Choose a player"
    }
)


funcs.UpdateTargetPlayers = function()

    local TargetWebhookPlayers = {}

    local PreviousTarget =
        State.LogTarget


    for _, Player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if Player ~= Services.Players.LocalPlayer then

            table.insert(
                TargetWebhookPlayers,
                Player.Name
            )

        end

    end


    table.sort(
        TargetWebhookPlayers
    )


    Modules.TargetDropdown:SetValues(
        TargetWebhookPlayers
    )


    if #TargetWebhookPlayers == 0 then

        State.LogTarget = nil

        return

    end


    local TargetStillExists = false


    if PreviousTarget then

        for _, PlayerName in ipairs(
            TargetWebhookPlayers
        ) do

            if PlayerName == PreviousTarget then

                TargetStillExists = true

                break

            end

        end

    end


    if TargetStillExists then

        Modules.TargetDropdown:SetValue(
            PreviousTarget
        )

        State.LogTarget =
            PreviousTarget

    else

        Modules.TargetDropdown:SetValue(
            TargetWebhookPlayers[1]
        )

        State.LogTarget =
            TargetWebhookPlayers[1]

    end

end


funcs.UpdateTargetPlayers()


Services.Players.PlayerAdded:Connect(
    function()

        task.defer(
            funcs.UpdateTargetPlayers
        )

    end
)


Services.Players.PlayerRemoving:Connect(
    function()

        task.defer(
            funcs.UpdateTargetPlayers
        )

    end
)


Modules.TargetDropdown:OnChanged(
    function(Value)

        State.LogTarget =
            Value

    end
)

Modules.SendTargetInfo = Groupboxes.NotificationsLeftGroupBox2:AddButton({
    Text = "Send Target Info",
    Tooltip = "Requires Webhook URL At Webhook Tab",

    Func = function()
        if not State.webhook or State.webhook == "" then
            Library:Notify({
                Title = "Webhook Error",
                Description = "Webhook URL is empty.",
                Duration = 5
            })
            return
        end

        if not State.LogTarget or State.LogTarget == "" then
            Library:Notify({
                Title = "Target Error",
                Description = "No target player selected.",
                Duration = 5
            })
            return
        end

        local TargetPlayer = Services.Players:FindFirstChild(State.LogTarget)

        if not TargetPlayer then
            Library:Notify({
                Title = "Target Error",
                Description = "Target player is no longer in the server.",
                Duration = 5
            })
            return
        end

        local Character = workspace:FindFirstChild(State.LogTarget)

        if not Character then
            Library:Notify({
                Title = "Character Error",
                Description = "Target character was not found in workspace.",
                Duration = 5
            })
            return
        end

        local Humanoid = Character:FindFirstChild("Humanoid")

        local CharacterDisplayName = "None"
        local CharacterHealth = "None"
        local CharacterMaxHealth = "None"

        if Humanoid then
            local DisplaySuccess, DisplayValue = pcall(function()
                return Humanoid.DisplayName
            end)

            if DisplaySuccess and DisplayValue ~= nil then
                CharacterDisplayName = tostring(DisplayValue)
            end

            local HealthSuccess, HealthValue = pcall(function()
                return Humanoid.Health
            end)

            if HealthSuccess and HealthValue ~= nil then
                CharacterHealth = tostring(HealthValue)
            end

            local MaxHealthSuccess, MaxHealthValue = pcall(function()
                return Humanoid.MaxHealth
            end)

            if MaxHealthSuccess and MaxHealthValue ~= nil then
                CharacterMaxHealth = tostring(MaxHealthValue)
            end
        end

        -- Shirt / ShirtBroken
        local ShirtID = "None"
        local ShirtName = "None"
        local ShirtTemplateContent = "None"

        local Shirt = Character:FindFirstChild("Shirt")

        if not Shirt then
            Shirt = Character:FindFirstChild("ShirtBroken")
        end

        if Shirt then
            ShirtName = Shirt.Name

            local Success, Value = pcall(function()
                return Shirt.ShirtTemplate
            end)

            if Success and Value then
                ShirtID = tostring(Value):gsub("rbxassetid://", "")
            end

            local ContentSuccess, ContentValue = pcall(function()
                return Shirt.ShirtTemplateContent
            end)

            if ContentSuccess and ContentValue then
                ShirtTemplateContent = tostring(ContentValue)
            end
        end

        -- Pants / PantsBroken
        local PantsID = "None"
        local PantsName = "None"
        local PantsTemplateContent = "None"

        local Pants = Character:FindFirstChild("Pants")

        if not Pants then
            Pants = Character:FindFirstChild("PantsBroken")
        end

        if Pants then
            PantsName = Pants.Name

            local Success, Value = pcall(function()
                return Pants.PantsTemplate
            end)

            if Success and Value then
                PantsID = tostring(Value):gsub("rbxassetid://", "")
            end

            local ContentSuccess, ContentValue = pcall(function()
                return Pants.PantsTemplateContent
            end)

            if ContentSuccess and ContentValue then
                PantsTemplateContent = tostring(ContentValue)
            end
        end

        -- Body Colors
        local BodyColors = Character:FindFirstChild("Body Colors")
        local BodyColorsLua = "Body Colors not found."

        if BodyColors then
            local BodyColorValues = {
                "HeadColor = " .. tostring(BodyColors.HeadColor),
                "HeadColor3 = " .. tostring(BodyColors.HeadColor3),
                "LeftArmColor = " .. tostring(BodyColors.LeftArmColor),
                "LeftArmColor3 = " .. tostring(BodyColors.LeftArmColor3),
                "RightArmColor = " .. tostring(BodyColors.RightArmColor),
                "RightArmColor3 = " .. tostring(BodyColors.RightArmColor3),
                "LeftLegColor = " .. tostring(BodyColors.LeftLegColor),
                "LeftLegColor3 = " .. tostring(BodyColors.LeftLegColor3),
                "RightLegColor = " .. tostring(BodyColors.RightLegColor),
                "RightLegColor3 = " .. tostring(BodyColors.RightLegColor3),
                "TorsoColor = " .. tostring(BodyColors.TorsoColor),
                "TorsoColor3 = " .. tostring(BodyColors.TorsoColor3)
            }

            BodyColorsLua = table.concat(BodyColorValues, "\n")
        end

        -- Hair 1-100
        local HairData = {}

        local function ReadValueObject(Object)
            if not Object then
                return "None"
            end

            local Success, Value = pcall(function()
                return Object.Value
            end)

            if Success and Value ~= nil then
                return tostring(Value)
            end

            return "None"
        end

        local function ReadProperty(Object, PropertyName)
            if not Object then
                return "None"
            end

            local Success, Value = pcall(function()
                return Object[PropertyName]
            end)

            if Success and Value ~= nil then
                return tostring(Value)
            end

            return "None"
        end

        for i = 1, 100 do
            local Hair = Character:FindFirstChild("Hair" .. i)

            if Hair then
                local GenderObject = Hair:FindFirstChild("Gender", true)
                local GenderValue = "None"

                if GenderObject then
                    GenderValue = ReadValueObject(GenderObject)

                    if GenderValue == "None" then
                        GenderValue = ReadProperty(GenderObject, "Value")
                    end
                end

                local Offset = Hair:FindFirstChild("Offset", true)
                local Weld = Hair:FindFirstChildWhichIsA("Weld", true)
                    or Hair:FindFirstChildWhichIsA("WeldConstraint", true)
                local SpecialMesh = Hair:FindFirstChildWhichIsA("SpecialMesh", true)

                local HairLines = {
                    "Name = " .. Hair.Name,
                    "Gender = " .. GenderValue,
                    "Offset = " .. ReadProperty(Hair, "Offset")
                }

                if Offset then
                    table.insert(HairLines, "Offset.Value = " .. ReadValueObject(Offset))
                    table.insert(HairLines, "Offset.Position = " .. ReadProperty(Offset, "Position"))
                end

                if Weld then
                    table.insert(HairLines, "Weld = " .. Weld.ClassName)
                    table.insert(HairLines, "Weld.C0 = " .. ReadProperty(Weld, "C0"))
                    table.insert(HairLines, "Weld.C1 = " .. ReadProperty(Weld, "C1"))
                    table.insert(HairLines, "Weld.Part0 = " .. ReadProperty(Weld, "Part0"))
                    table.insert(HairLines, "Weld.Part1 = " .. ReadProperty(Weld, "Part1"))
                end

                if SpecialMesh then
                    table.insert(HairLines, "SpecialMesh.MeshId = " .. ReadProperty(SpecialMesh, "MeshId"))
                    table.insert(HairLines, "SpecialMesh.TextureId = " .. ReadProperty(SpecialMesh, "TextureId"))
                    table.insert(HairLines, "SpecialMesh.Offset = " .. ReadProperty(SpecialMesh, "Offset"))
                    table.insert(HairLines, "SpecialMesh.Scale = " .. ReadProperty(SpecialMesh, "Scale"))
                    table.insert(HairLines, "SpecialMesh.VertexColor = " .. ReadProperty(SpecialMesh, "VertexColor"))
                    table.insert(HairLines, "SpecialMesh.MeshType = " .. ReadProperty(SpecialMesh, "MeshType"))
                end

                table.insert(HairData, table.concat(HairLines, "\n"))
            end
        end

        local HairDataText = "No Hair1-Hair100 found."

        if #HairData > 0 then
            HairDataText = table.concat(HairData, "\n\n")
        end

        local Request = (syn and syn.request)
            or (http and http.request)
            or request
            or http_request

        if not Request then
            Library:Notify({
                Title = "Webhook Error",
                Description = "HTTP request function is not available.",
                Duration = 5
            })
            return
        end

        local HttpService = game:GetService("HttpService")

        local Payload = {
            username = "Send Target Info",

            embeds = {{
                title = "Target Player Information",
                color = 30975,

                fields = {
                    {
                        name = "👤 Player",
                        value = "```lua\n" ..
                            "Target = " .. TargetPlayer.Name .. "\n" ..
                            "DisplayName = " .. TargetPlayer.DisplayName .. "\n" ..
                            "UserId = " .. tostring(TargetPlayer.UserId) ..
                            "\n```",
                        inline = false
                    },

                    {
                        name = "🧍 Character Info",
                        value = "```lua\n" ..
                            "Humanoid.DisplayName = " .. CharacterDisplayName .. "\n" ..
                            "Humanoid.Health = " .. CharacterHealth .. "\n" ..
                            "Humanoid.MaxHealth = " .. CharacterMaxHealth ..
                            "\n```",
                        inline = false
                    },

                    {
                        name = "👕 Clothing",
                        value = "```lua\n" ..
                            ShirtName .. " = " .. ShirtID .. "\n" ..
                            "ShirtTemplateContent = " .. ShirtTemplateContent .. "\n\n" ..
                            PantsName .. " = " .. PantsID .. "\n" ..
                            "PantsTemplateContent = " .. PantsTemplateContent ..
                            "\n```",
                        inline = false
                    },

                    {
                        name = "🎨 Body Colors",
                        value = "```lua\n" ..
                            BodyColorsLua ..
                            "\n```",
                        inline = false
                    },

                    {
                        name = "💇 Hair Info",
                        value = "```lua\n" ..
                            HairDataText ..
                            "\n```",
                        inline = false
                    }
                },

                footer = {
                    text = "Send Target Info • Target Information"
                }
            }}
        }

        local Success = pcall(function()
            Request({
                Url = State.webhook,
                Method = "POST",

                Headers = {
                    ["Content-Type"] = "application/json"
                },

                Body = HttpService:JSONEncode(Payload)
            })
        end)

        if Success then
            Library:Notify({
                Title = "Success",
                Description = "Target information sent to webhook.",
                Duration = 5
            })
        else
            Library:Notify({
                Title = "Webhook Error",
                Description = "Failed to send target information.",
                Duration = 5
            })
        end
    end
})

-- Unload

Groupboxes.RightGroupBox2:AddButton("Unload", function()

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

        if State.noFogConnection then
        State.noFogConnection:Disconnect()
        State.noFogConnection = nil
    end

    if State.oldFogEnd ~= nil then
        Services.Lighting.FogEnd = State.oldFogEnd
        State.oldFogEnd = nil
    end

    RemoveCorruptedPointESP()
    State.CorruptedPointESPEnabled = false

    if BaseLocals.noRainLoop then
	task.cancel(BaseLocals.noRainLoop)
	BaseLocals.noRainLoop = nil
    end

    State.AutoBlockEnabled = false

    if Services.Blocking and Services.Blocking.Value == true then
        dataFunction:InvokeServer("EndBlock")
        Services.Blocking.Value = false
    end

    if BaseLocals.AutoBlockConnections then
        for _, connection in ipairs(BaseLocals.AutoBlockConnections) do
            if connection then
                connection:Disconnect()
            end
        end

        table.clear(BaseLocals.AutoBlockConnections)
    end

    Library:Unload()


    Library:Unload()

end)

-- Auto Execute System


Groupboxes.RightGroupBox2:AddToggle(
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

ThemeManager:SetFolder("Themes")
SaveManager:SetFolder("PermaDeathEnjoyer/Configs")
SaveManager:SetSubFolder("Bloodlines")

-- Config System

SaveManager:BuildConfigSection(Tabs.Config)

ThemeManager:ApplyToTab(Tabs.Config)

SaveManager:LoadAutoloadConfig()


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

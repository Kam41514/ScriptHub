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
local Camera = workspace.CurrentCamera

-- Execute Notify

Library:Notify({
    Title = "Everwind Hub",
    Description = "Script Succesfully Executed.",
    Duration = 3
})

-- Updates:

local SelectedPlayer = ""
local fly = false
local flySpeed = 125
local WalkSpeed = 16
local ToggleAutoFallValue = false
local NoclipConnection = nil
local NoclipEnabled = false
local FlyToggle = nil
local AutoFallToggle = nil
local SpeedEnabled = false
local Humanoid = nil
local SpeedValue = 100
local DefaultSpeed = 16
local JumpPower = 50
local AutoChest = false
local AutoCedarPlume = false
local AutoOre = false
local SelectedPlant = "CedarPlume"
local SelectedOre = "Chryite"
local SelectedNPC = nil
local AutoFloatNPC = false
local ESPEnabled = false
local CurrentFlyKey = nil
local CurrentSpeedToggleKey = nil
local CurrentNoclipKey = nil
local NoclipToggle = nil
local SpeedToggle = nil
local playerOptions = {}
local LeaderboardObserve = true
local ObservingPlayer = nil
local KillBrickConnection
local MobESPConnection
local MobESPObjects = {}
local MobESPEnabled = false
local IgnorePlayers = true
local BossList = {}
local SelectedBoss = nil
local StaffLog = false
local AutoExecute = AutoExecuteValue

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
    AutoChest = false
    AutoCedarPlume = false
    AutoOre = false
    AutoFloatNPC = false
    ESPEnabled = false
    StaffHop = Toggles.StaffLogToggle.Value
	AutoExecuteValue = Toggles.AutoExecute.Value

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

    if Toggles.AutoChestToggle then
        Toggles.AutoChestToggle:SetValue(false)
    end

    if Toggles.AutoCedarPlumeToggle then
        Toggles.AutoCedarPlumeToggle:SetValue(false)
    end
     if Toggles.AutoOreToggle then
         Toggles.AutoOreToggle:SetValue(false)
    end
    
    if Toggles.AutoFloatNPCToggle then
        Toggles.AutoFloatNPCToggle:SetValue(false)
    end

    if Toggles.BoxESPToggle then
        Toggles.BoxESPToggle:SetValue(false)
    end

    if Toggles.StaffHopToggle then
        Toggles.StaffHopToggle:SetValue(true)
    end

    local player = Players.LocalPlayer

    -- SpeedValue reset
    if player:FindFirstChild("Data") and player.Data:FindFirstChild("SpeedValue") then
        player.Data.SpeedValue.Value = 0
    end

    if player:FindFirstChild("DataOld") and player.DataOld:FindFirstChild("SpeedValue") then
        player.DataOld.SpeedValue.Value = 0
    end

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = DefaultSpeed
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
    Title = "Everwind",
    Footer = "Version: 1.0",
    Icon = 93364949241311,
    NotifySide = "Left",
    ShowCustomCursor = true,
    Center = true,
})

-- Tabs
local Tabs = {
    Main = Window:AddTab("Main", "terminal"),
    Player = Window:AddTab("Player", "user"),
    Visual = Window:AddTab("Visual", "eye"),
    Exploits = Window:AddTab("Exploits", "wrench"),
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
            "https://github.com/DarkNetworks/Infinite-Yield/blob/main/dex.lua"
        ))()
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

local function GetServers(order)
    local placeId = game.PlaceId
    local cursor = ""
    local selectedServer = nil
    local value = order == "Asc" and math.huge or -1

    for i = 1, 3 do

        local url =
            "https://games.roblox.com/v1/games/"
            .. placeId ..
            "/servers/Public?sortOrder="
            .. order ..
            "&limit=100"

        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end


        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if not success then
            Library:Notify("Could not fetch servers!", 3)
            return
        end


        local data = HttpService:JSONDecode(response)


        for _, server in ipairs(data.data) do

            if server.playing < server.maxPlayers then

                if order == "Asc" then
                    if server.playing < value then
                        value = server.playing
                        selectedServer = server
                    end
                else
                    if server.playing > value then
                        value = server.playing
                        selectedServer = server
                    end
                end

            end
        end


        cursor = data.nextPageCursor

        if not cursor then
            break
        end

        task.wait(1)
    end


    return selectedServer
end



local function JoinSmallestServer()

    local server = GetServers("Asc")

    if server then

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            server.id,
            Players.LocalPlayer
        )

    else

        Library:Notify("Server Not Found!", 3)

    end
end



local function JoinLargestServer()

    local server = GetServers("Desc")

    if server then

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            server.id,
            Players.LocalPlayer
        )

    else

        Library:Notify("Server Not Found!", 3)

    end
end

local function ServerHop()
    local placeId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/" ..
        placeId ..
        "/servers/Public?sortOrder=Asc&limit=100"

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        Library:Notify("Failed to get servers!", 3)
        return
    end

    local data = HttpService:JSONDecode(response)

    local servers = {}

    for _, server in ipairs(data.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            table.insert(servers, server)
        end
    end

    if #servers > 0 then
        local randomServer = servers[math.random(1, #servers)]

        TeleportService:TeleportToPlaceInstance(
            placeId,
            randomServer.id,
            Players.LocalPlayer
        )
    else
        Library:Notify("No server found!", 3)
    end
end


-- Serverhop

LeftGroupBox2:AddButton({
    Text = "Serverhop",
    Func = function()

        Library:Notify("Hopping To Another Server", 1)
        task.wait(1)

        ServerHop()

    end
})

LeftGroupBox2:AddButton({
    Text = "Join Smallest Server",
    Func = function()

        Library:Notify("Joining Smallest Server", 4)
        task.wait(1)

        JoinSmallestServer()

    end
})

LeftGroupBox2:AddButton({
    Text = "Join Largest Server",
    Func = function()

        Library:Notify("Joining Largest Server", 4)
        task.wait(1)

        JoinLargestServer()

    end
})

local ServerID = ""


LeftGroupBox2:AddInput("ServerInput", {
    Text = "Join With Server ID",
    Placeholder = "Enter Job ID (Server-ID)",
    Numeric = false,
    Finished = false
}):OnChanged(function(Value)

    ServerID = Value

end)



LeftGroupBox2:AddButton({
    Text = "Join With Server ID",
    Func = function()

        if ServerID ~= "" then

            Library:Notify(
                "Joining The Server: " .. ServerID,
                1
            )

            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                ServerID,
                Players.LocalPlayer
            )

        else

            Library:Notify(
                "Please enter a Server ID!",
                2
            )

        end

    end
})


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
local PlayerRightGroupBox = Tabs.Player:AddRightGroupbox("Speed", "wind")

-- Scripts For Player Tab

local player = game:GetService'Players'.LocalPlayer;
local mouse = player:GetMouse();
local camera = workspace.CurrentCamera;
local runservice = game:GetService'RunService';

local input = {
    down = {}
}

UserInputService.InputBegan:Connect(function(key, gameProcessed)
    if gameProcessed then return end

    input.down[key.KeyCode.Name:lower()] = true
end)

UserInputService.InputEnded:Connect(function(key)
    input.down[key.KeyCode.Name:lower()] = false
end)

local gayGames = {
    3016661674; -- rogue lineage checks falling humanoid state lmao
};

for i, v in ipairs(gayGames) do
    gayGames[v] = true;
    gayGames[i] = false;
end

local gay = gayGames[game.PlaceId];

shared.sfls = script;


function IsInZone(Object1, Object2, YCheck) -- broken 2 lazy 2 fix
    if (typeof(Object1) ~= 'Instance' and typeof(Object1) ~= 'table') or (typeof(Object2) ~= 'Instance' and typeof(Object2) ~= 'table') then return 'NIGGER'; end
    if YCheck ~= nil and typeof(YCheck) ~= 'boolean' then return end

    YCheck = (YCheck ~= nil and YCheck or false);

    local RYCheck = true;

    local Object = Object1;
    
    local Positive = (Object2.CFrame * CFrame.new(Object2.Size.X / 2, Object2.Size.Y / 2, Object2.Size.Z / 2));
    local Negative = (Object2.CFrame * CFrame.new(-Object2.Size.X / 2, -Object2.Size.Y / 2, -Object2.Size.Z / 2));

    if YCheck then
        RYCheck = (YCheck == true and
            (Object.Position.Y > Positive.Y) and
            (Object.Position.Y < Negative.Y));
    end

    -- print(1, (Object.Position.X < Positive.X), Object.Position.X, Positive.X)
    -- print(2, (Object.Position.X > Negative.X), Object.Position.X, Negative.X)
    -- print(3, (Object.Position.Z > Positive.Z), Object.Position.Z, Positive.Z)
    -- print(4, (Object.Position.Z < Negative.Z), Object.Position.Z, Negative.Z)
    -- print(5, RYCheck);

    return (Object.Position.X < Positive.X) and
        (Object.Position.X > Negative.X) and
        (Object.Position.Z > Positive.Z) and
        (Object.Position.Z < Negative.Z) and
        (RYCheck);
end

function GetIndex(Table, Value)
    for i, v in pairs(Table) do
        if v == Value then
            return i;
        end
    end

    return -1;
end

local PartIgnore = {};

function DisableClip(Part)
    if Part:IsA'BasePart' and Part.CanCollide then
        local Start = tick();
        local OldTransparency = Part.Transparency;
        
        table.insert(PartIgnore, Part);

        while tick() - Start < 300 and player.Character and player.Character:FindFirstChild'HumanoidRootPart' and not input.down.f4 do
            if tick() - Start > 1 and not IsInZone(player.Character.HumanoidRootPart, Part, true) and not IsInZone({Position = camera.CFrame.p}, Part, true) then
                break;
            end

            Part.CanCollide = false;
            if not gay then Part.Transparency = 0.75; end

            wait(1 / 8);
        end

        table.remove(PartIgnore, GetIndex(PartIgnore, Part));

        Part.Transparency = OldTransparency;
        Part.CanCollide = true;
    end
end

local lastSpace = 0;

local function StartFlight()
    if not fly then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if not root or not hum then return end

    if not gay then
        hum.PlatformStand = true
    end

task.spawn(function()
    while fly do
        local moveDirection = Vector3.zero

        if input.down.w then
            moveDirection += camera.CFrame.LookVector
        end

        if input.down.s then
            moveDirection -= camera.CFrame.LookVector
        end

        if input.down.a then
            moveDirection -= camera.CFrame.RightVector
        end

        if input.down.d then
            moveDirection += camera.CFrame.RightVector
        end

        if input.down.space then
            moveDirection += Vector3.new(0, 1, 0)
        end

        if input.down.leftcontrol then
            moveDirection -= Vector3.new(0, 1, 0)
        end

        if ToggleAutoFallValue then
            moveDirection -= Vector3.new(0, 0.1, 0)
        end

        if moveDirection.Magnitude > 0 then
            root.Velocity = moveDirection.Unit * flySpeed
        else
            root.Velocity = Vector3.zero
        end

        runservice.RenderStepped:Wait()
    end

    if hum then
        hum.PlatformStand = false
    end

    root.Velocity = Vector3.zero
end)

end




local function StopFlight()
    fly = false

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.PlatformStand = false
        end

        root.Velocity = Vector3.new(0, 0, 0)
    end
end

function enableNoclip()
    if NoclipConnection then return end

    NoclipEnabled = true

    NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
        local character = game.Players.LocalPlayer.Character

        if NoclipEnabled and fly and character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end

function disableNoclip()
    NoclipEnabled = false

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    local character = game.Players.LocalPlayer.Character
    if character then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

-- Toggles And Sliders For PlayerGroupBox

FlyToggle = PlayerLeftGroupBox:AddToggle("FlyToggle",{
    Text = "Flight",
    Default = false,
})

FlyToggle:AddKeyPicker("FlyKeybind", {
    Default = "None",
    SyncToggleState = true,

    Callback = function(key)
        CurrentFlyKey = key -- None ise nil olur
    end
})


game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if CurrentFlyKey and input.KeyCode == CurrentFlyKey then
        FlyToggle:SetValue(not FlyToggle.Value)
    end
end)

FlyToggle:OnChanged(function(Value)

    fly = Value

    if fly then

    if Toggles.NoclipToggle and Toggles.NoclipToggle.Value == true then
    	enableNoclip()
	end

        StartFlight()

    else
        StopFlight()
        disableNoclip()
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
    NoclipEnabled = Value

    if Value and fly then
        enableNoclip()
    else
        disableNoclip()
    end
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

    if Value then
        player.Data.SpeedValue.Value = SpeedValue * 10
        player.DataOld.SpeedValue.Value = SpeedValue * 10
    else
        player.Data.SpeedValue.Value = 0
        player.DataOld.SpeedValue.Value = 0
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
end)

Options.SpeedSlider:OnChanged(function(Value)
    SpeedValue = Value

    if SpeedEnabled then
        local player = game:GetService("Players").LocalPlayer
        player.Data.SpeedValue.Value = Value * 10
        player.DataOld.SpeedValue.Value = Value *10
    end
end)



PlayerLeftGroupBox2:AddButton({
    Text = "Reset Character",
    Func = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- End Of Player Tab

-- Groupboxes For Exploits Tab
local ExploitsLeftGroupBox = Tabs.Exploits:AddLeftGroupbox("Teleportation", "wind")
local ExploitsRightGroupBox = Tabs.Exploits:AddRightGroupbox("Botting", "bot")
local ExploitsLeftGroupBox2 = Tabs.Exploits:AddLeftGroupbox("Extras", "user")
local ExploitsRightGroupBox2 = Tabs.Exploits:AddRightGroupbox("Artifact", "bot")

local Locations = {}

for _, v in ipairs(workspace.Waypoints:GetChildren()) do
    if v.Name == "WaypointSystem" then
        continue
    end

    table.insert(Locations, v.Name)
end

ExploitsLeftGroupBox:AddDropdown("TeleportLocationDropdown", {
    Values = Locations,
    Default = Locations[1],
    Multi = false,
    Text = "Select Waypoint",
    Tooltip = "Choose a location"
}):OnChanged(function(Value)
    SelectedTeleportLocation = Value
end)

ExploitsLeftGroupBox:AddButton({
    Text = "Teleport Waypoint",
    Func = function()
        local waypoint = workspace.Waypoints:FindFirstChild(SelectedTeleportLocation)

        if waypoint and waypoint:FindFirstChild("Base") then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = waypoint.Base.CFrame
            end
        end
    end
})

ExploitsLeftGroupBox:AddButton({
    Text = "Random Chest Teleport",
    Func = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local chests = workspace.Collectibles:GetChildren()

        local validChests = {}

        for _, chest in ipairs(chests) do
            if chest:FindFirstChild("Top") then
                table.insert(validChests, chest)
            end
        end

        if #validChests > 0 then
            local randomChest = validChests[math.random(1, #validChests)]
            hrp.CFrame = randomChest.Top.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

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

local function DisableKillPart(obj)

    if obj:IsA("Script") and obj.Name:lower() == "killbrick" then

        local part = obj.Parent

        if part and part:IsA("BasePart") then
            part.CanTouch = false
        end

    end

end


local function SetKillParts(state)

    for _, obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("Script") and obj.Name:lower() == "killbrick" then

            local part = obj.Parent

            if part and part:IsA("BasePart") then
                part.CanTouch = state
            end

        end

    end

end


ExploitsLeftGroupBox2:AddToggle("KillBrickToggle", {
    Text = "Disable KillBricks",
    Default = false
}):OnChanged(function(Value)

    if Value then

        -- Var olanları kapat
        SetKillParts(false)


        -- Yeni yüklenenleri yakala
        KillBrickConnection = workspace.DescendantAdded:Connect(function(obj)

            task.wait(0.1)

            DisableKillPart(obj)

        end)

    else

        if KillBrickConnection then
            KillBrickConnection:Disconnect()
            KillBrickConnection = nil
        end


        -- Geri aç
        SetKillParts(true)

    end

end)

ExploitsRightGroupBox:AddToggle("AutoChestToggle", {
    Text = "Auto Chest",
    Default = false
}):OnChanged(function(Value)

    AutoChest = Value

    if AutoChest then
        task.spawn(function()

            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local player = Players.LocalPlayer

            while AutoChest do

                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                for _, chest in ipairs(workspace.Collectibles:GetChildren()) do

                    if not AutoChest then
                        return
                    end

                    local top = chest:FindFirstChild("Top")
                    local bottom = chest:FindFirstChild("Bottom")
                    local prompt = bottom and bottom:FindFirstChild("ProximityPrompt")

                    if top and prompt then

                        -- Sandığın altına ışınlanılacak konum
                        local lockPosition = top.CFrame + Vector3.new(0, -6.33, 0)

                        -- Işınlan
                        hrp.CFrame = lockPosition
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero

                        -- Pozisyonu sabitle
                        local connection
                        connection = RunService.Heartbeat:Connect(function()

                            if not AutoChest or not hrp or not hrp.Parent then
                                if connection then
                                    connection:Disconnect()
                                    connection = nil
                                end
                                return
                            end

                            hrp.CFrame = lockPosition
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero

                        end)

                        task.wait(0.25)

                        -- ProximityPrompt tetikle
                        fireproximityprompt(prompt)

						task.wait(0.3)
						local hrp2 = character:WaitForChild("HumanoidRootPart")
							hrp2.CFrame = top.CFrame + Vector3.new(0, -15.33, 0)
							hrp2.CFrame = lockPosition
	                        hrp2.AssemblyLinearVelocity = Vector3.zero
	                        hrp2.AssemblyAngularVelocity = Vector3.zero

                        task.wait(3.2)

                        -- Sabitlemeyi kapat
                        if connection then
                            connection:Disconnect()
                            connection = nil
                        end

                    end
                end

                task.wait(1)

            end

        end)
    end

end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer


ExploitsRightGroupBox:AddToggle("AutoPlantToggle", {
    Text = "Auto Ingredient",
    Default = false
}):OnChanged(function(Value)

    AutoPlant = Value


    if Value then

        task.spawn(function()

            local Botanical = workspace
                :WaitForChild("Gathering")
                :WaitForChild("Botanical")


            while AutoPlant do


                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")


                local found = false


                for _, plant in ipairs(Botanical:GetChildren()) do


                    if not AutoPlant then
                        break
                    end


                    if SelectedPlant
                    and plant.Name:lower() == SelectedPlant:lower() then


                        local mainPart = plant:FindFirstChild("MainPart")


                        if mainPart then


                            found = true


                            -- Bitkinin altındaki yatay pozisyon
                            local targetCFrame = CFrame.new(
                                mainPart.Position + Vector3.new(0,-3.74,0)
                            ) * CFrame.Angles(math.rad(90),0,0)



                            -- Işınlan
                            hrp.CFrame = targetCFrame


                            -- Hareketi kes
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero



                            task.wait(0.1)



                            -- Kendi promptunu bul
                            local prompt = mainPart:FindFirstChild("ProximityPrompt")



                            if prompt then


                                print(
                                    "Toplanıyor:",
                                    plant.Name,
                                    prompt:GetFullName()
                                )


                                prompt.Enabled = true

                                fireproximityprompt(prompt)


                            else


                                warn(
                                    "Prompt yok:",
                                    plant:GetFullName()
                                )


                            end




                                local stayTime = 0.099

                                local start = tick()

                                while AutoPlant and tick() - start < stayTime do

                                    if not hrp.Parent then
                                        break
                                    end


                                    hrp.CFrame = targetCFrame

                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero


                                    RunService.Heartbeat:Wait()

                                end



                            task.wait(0.15)


                        end

                    end

                end



                if not found then

                    task.wait(0.2)

                end


            end


        end)

    end

end)

ExploitsRightGroupBox:AddDropdown("PlantDropdown", {
    Values = {
        "CedarPlume",
        "Sunpetal",
        "Tallancus",
        "Knife Lily"
    },
    Default = "CedarPlume",
    Multi = false,
    Text = "Select Plant"
}):OnChanged(function(Value)
    SelectedPlant = Value
end)


ExploitsRightGroupBox:AddToggle("AutoOreToggle", {
    Text = "Auto Mine",
    Default = false
}):OnChanged(function(Value)

   AutoOre = Value

if AutoOre then
    task.spawn(function()

        local player = game:GetService("Players").LocalPlayer
        local RunService = game:GetService("RunService")
        local Ores = workspace:WaitForChild("Gathering"):WaitForChild("Ores")

        while AutoOre do

            for _, ore in ipairs(Ores:GetChildren()) do

                if not AutoOre then
                    return
                end

                if ore.Name == SelectedOre then

                    local target = ore:FindFirstChild("MainPart", true)

                    if target then

                        local character = player.Character or player.CharacterAdded:Wait()
                        local hrp = character:WaitForChild("HumanoidRootPart")

                        -- Işınlanacağı konum
                        local lockPosition = CFrame.new(
                            target.Position + Vector3.new(0, -4.5, 0),
                            target.Position
                        )

                        -- Işınlan
                        hrp.CFrame = lockPosition
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero

                        -- Karakteri sabit tut
                        local connection
                        connection = RunService.Heartbeat:Connect(function()

                            if not AutoOre or not hrp or not hrp.Parent then
                                if connection then
                                    connection:Disconnect()
                                    connection = nil
                                end
                                return
                            end

                            hrp.CFrame = lockPosition
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero

                        end)

                        task.wait(0.3)

                        -- ProximityPrompt çalıştır
                        local prompt = target:FindFirstChild("ProximityPrompt")

                        if prompt then
                            fireproximityprompt(prompt)
                        else
                            warn("ProximityPrompt bulunamadı:", target:GetFullName())
                        end

                        task.wait(3)

                        -- Sabitlemeyi kapat
                        if connection then
                            connection:Disconnect()
                            connection = nil
                        end

                    else
                        warn("MainPart bulunamadı:", ore:GetFullName())
                    end

                end
            end

            task.wait(0.5)

        end

    end)
end
end)

ExploitsRightGroupBox:AddDropdown("OreDropdown", {
    Values = {
        "Chryite",
        "Ferrite",
        "Moonstone",
        "Prismite",
        "Silvershard"
    },
    Default = "Chryite",
    Multi = false,
    Text = "Select Ore"
}):OnChanged(function(Value)
    SelectedOre = Value
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local AutoTeleportM1 = false
local SelectedNPC = nil
local ReturnCFrame = nil
local Teleporting = false



local function IsValidNPC(npc)

    if not npc:IsA("Model") then
        return false
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character == npc then
            return false
        end
    end

    if npc.Name:find("FriendlyNPC") then
        return false
    end

        local root = npc:FindFirstChild("UpperTorso")
            or npc:FindFirstChild("Torso")
            or npc:FindFirstChild("HumanoidRootPart")
            or npc.PrimaryPart

    if not root then
        return false
    end

    return true
end



local function GetNPCList()

    local list = {}
    local added = {}

    local entities = workspace:FindFirstChild("Entities")

    if not entities then
        return list
    end


    for _, npc in ipairs(entities:GetChildren()) do

        if IsValidNPC(npc) then

            if not added[npc.Name] then
                added[npc.Name] = true
                table.insert(list, npc.Name)
            end

        end

    end


    table.sort(list)

    return list
end



local function GetNearestNPC(name)

    local character = player.Character

    if not character then
        return nil
    end


    local hrp = character:FindFirstChild("HumanoidRootPart")

    if not hrp then
        return nil
    end


    local entities = workspace:FindFirstChild("Entities")

    if not entities then
        return nil
    end


    local nearest = nil
    local shortest = math.huge


    for _, npc in ipairs(entities:GetChildren()) do

        if npc.Name == name and IsValidNPC(npc) then

            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local root = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart


            if humanoid and humanoid.Health > 0 and root then

                local distance = (hrp.Position - root.Position).Magnitude

                if distance < shortest then
                    shortest = distance
                    nearest = npc
                end

            end

        end

    end


    return nearest
end



local NPCDropdown = ExploitsRightGroupBox:AddDropdown("NPCDropdown", {

    Values = GetNPCList(),
    Default = nil,
    Multi = false,
    Text = "Select NPC",

    Callback = function(Value)

        SelectedNPC = Value
        print("Selected NPC:", Value)

    end

})



ExploitsRightGroupBox:AddButton({

    Text = "Refresh NPCs",

    Func = function()

        NPCDropdown:SetValues(GetNPCList())

    end

})



ExploitsRightGroupBox:AddToggle("AutoTeleportM1", {

    Text = "M1 Teleport Farm",
    Default = false

}):OnChanged(function(Value)

    AutoTeleportM1 = Value


    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")


    if Value then

        if hrp then

            ReturnCFrame = hrp.CFrame
            print("Saved return position")

        end

    else

        ReturnCFrame = nil
        print("Cleared return position")

    end

end)

local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")


local AutoClick = false



ExploitsRightGroupBox:AddToggle("AutoClickToggle", {

    Text = "Auto Click",
    Default = false

}):OnChanged(function(Value)

    AutoClick = Value

end)



local function TeleportToNPC()

    if AutoTeleportM1 and SelectedNPC and not Teleporting then


        Teleporting = true


        local character = player.Character


        if character then

            local hrp = character:FindFirstChild("HumanoidRootPart")


            if hrp then


                local npc = GetNearestNPC(SelectedNPC)


                if npc then


                    local root = npc:FindFirstChild("UpperTorso")
                        or npc:FindFirstChild("Torso")
                        or npc:FindFirstChild("HumanoidRootPart")
                        or npc.PrimaryPart



                    if root then


                        task.wait(0.073)


                        hrp.CFrame = CFrame.new(
                            root.Position + Vector3.new(-0.1,2,0),
                            root.Position
                        )

                        local head = character:FindFirstChild("Head")

                        if head then
                            head.CFrame = CFrame.lookAt(
                                head.Position,
                                root.Position
                            )
                        end



                        task.wait(0.535)



                        if hrp and ReturnCFrame then

                            hrp.CFrame = ReturnCFrame

                        end


                    end

                end

            end

        end



        task.wait(0.05)


        Teleporting = false


    end

end




-- Elle M1 basınca teleport
UserInputService.InputBegan:Connect(function(input, gameProcessed)


    if gameProcessed then
        return
    end



    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        TeleportToNPC()

    end


end)




-- Auto Click
task.spawn(function()


    while task.wait(1.3) do


        if AutoClick then



            VirtualInputManager:SendMouseButtonEvent(
                0,
                0,
                0,
                true,
                game,
                0
            )



            task.wait(0.05)



            VirtualInputManager:SendMouseButtonEvent(
                0,
                0,
                0,
                false,
                game,
                0
            )



            -- Auto click sonrası teleport
            TeleportToNPC()


        end


    end


end)

local ArtifactFolder = workspace
    :WaitForChild("artifactImportantLocations")
    :WaitForChild("artifactStoneSpawnPoints")

local ArtifactLocations = {}
local SelectedArtifactLocation

local function GetArtifactLocations()
    table.clear(ArtifactLocations)

    local list = {}

    for i, obj in ipairs(ArtifactFolder:GetChildren()) do
        local displayName = "Location " .. i

        ArtifactLocations[displayName] = obj
        table.insert(list, displayName)
    end

    return list
end

local ArtifactDropdown = ExploitsRightGroupBox2:AddDropdown("ArtifactLocationDropdown", {
    Text = "Artifact Location",
    Values = GetArtifactLocations(),
    Default = nil,
    Multi = false
})

ArtifactDropdown:OnChanged(function(Value)
    SelectedArtifactLocation = ArtifactLocations[Value]
end)

ArtifactFolder.ChildAdded:Connect(function()
    task.wait(0.1)
    ArtifactDropdown:SetValues(GetArtifactLocations())
end)

ArtifactFolder.ChildRemoved:Connect(function()
    task.wait(0.1)
    ArtifactDropdown:SetValues(GetArtifactLocations())
end)

ExploitsRightGroupBox2:AddButton({
    Text = "Teleport Location",
    Func = function()
        local character = game.Players.LocalPlayer.Character
            if character then
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = SelectedArtifactLocation.CFrame
end
    end
})

local BossFolder = game:GetService("ReplicatedStorage").EnemyNPCs.Bosses
local BossDropdown

local function UpdateBossList()
    table.clear(BossList)

    for _, v in ipairs(BossFolder:GetChildren()) do
        if v:IsA("Model") then
            table.insert(BossList, v.Name)
        end
    end

    if BossDropdown then
        BossDropdown:SetValues(BossList)
    end
end

-- Önce listeyi doldur
UpdateBossList()

ExploitsRightGroupBox:AddLabel("Boss Section")

BossDropdown = ExploitsRightGroupBox:AddDropdown({
    Name = "Bosses",
    Options = BossList,
    Default = nil,
    Callback = function(Value)
        SelectedBoss = Value
        print("Selected Boss:", SelectedBoss)
    end
})

-- Dropdown oluşturulduktan sonra tekrar güncelle
UpdateBossList()

BossFolder.ChildAdded:Connect(UpdateBossList)
BossFolder.ChildRemoved:Connect(UpdateBossList)

ExploitsRightGroupBox:AddButton({
    Text = "Teleport Location",
    Func = function()
        if SelectedBoss then
            local BossModel = BossFolder:FindFirstChild(SelectedBoss)

            if BossModel and BossModel:IsA("Model") then
                local character = game.Players.LocalPlayer.Character

                if character then
                    local hrp = character:WaitForChild("HumanoidRootPart")

                    local bossRoot = BossModel:FindFirstChild("HumanoidRootPart")
                        or BossModel.PrimaryPart

                    if bossRoot then
                        hrp.CFrame = bossRoot.CFrame
                    else
                        warn("Boss root bulunamadı")
                    end
                end
            end
        else
            warn("Boss seçilmedi")
        end
    end
})

-- Visual Section

local VisualLeftGroupBox = Tabs.Visual:AddLeftGroupbox("Player ESP", "box")
local VisualLeftGroupBox2 = Tabs.Visual:AddLeftGroupbox("Mob ESP", "box")
local VisualLeftGroupBox3 = Tabs.Visual:AddLeftGroupbox("Item ESP", "box")
local VisualRightGroupBox = Tabs.Visual:AddRightGroupbox("Observe Camera", "camera")
local VisualRightGroupBox2 = Tabs.Visual:AddRightGroupbox("Notifier", "warning")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

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
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer


local function IsPlayerEntity(model)

    for _, plr in ipairs(Players:GetPlayers()) do

        if model.Name == plr.Name then
            return true
        end

    end

    return false

end



local function CreateMobESP(mob)

    if not MobESPEnabled then
        return
    end

    if not mob:IsA("Model") then
        return
    end

    if mob:FindFirstChild("MobESP") then
        return
    end


    local isPlayer = IsPlayerEntity(mob)


    if IgnorePlayers and isPlayer then
        return
    end



    local root = mob:FindFirstChild("HumanoidRootPart")
        or mob.PrimaryPart
        or mob:FindFirstChildWhichIsA("BasePart", true)


    if not root then
        return
    end


    local humanoid = mob:FindFirstChildOfClass("Humanoid")



    local highlight = Instance.new("Highlight")
    highlight.Name = "MobESP"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    if isPlayer then
        highlight.OutlineColor = Color3.fromRGB(255,0,0)
    else
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
    end

    highlight.Parent = mob



    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MobESP"
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root



    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1,0,1,0)
    text.TextStrokeTransparency = 0
    text.TextSize = 14
    text.Font = Enum.Font.SourceSansBold
    text.Parent = billboard



    local connection

    connection = RunService.RenderStepped:Connect(function()

        if not mob.Parent then
            connection:Disconnect()
            return
        end


        local distance = 0

        if player.Character
        and player.Character:FindFirstChild("HumanoidRootPart") then

            distance = math.floor(
                (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
            )

        end


        local hp = ""

        if humanoid then

            hp =
                math.floor(humanoid.Health)
                ..
                "/"
                ..
                math.floor(humanoid.MaxHealth)

        end



        text.Text =
            mob.Name
            ..
            "\n❤ "
            ..
            hp
            ..
            " | "
            ..
            distance
            ..
            " st"



        if isPlayer then
            text.TextColor3 = Color3.fromRGB(255,0,0)
        else
            text.TextColor3 = Color3.fromRGB(255,255,255)
        end

    end)



    table.insert(MobESPObjects,{
        Highlight = highlight,
        Billboard = billboard,
        Connection = connection
    })

end




local function RemoveMobESP()

    for _,data in ipairs(MobESPObjects) do

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


    table.clear(MobESPObjects)

end




local function RefreshMobESP()

    RemoveMobESP()

    if not MobESPEnabled then
        return
    end


    local entities = workspace:FindFirstChild("Entities")

    if not entities then
        return
    end


    for _,mob in ipairs(entities:GetChildren()) do
        CreateMobESP(mob)
    end

end




VisualLeftGroupBox2:AddToggle("MobESPToggle", {
    Text = "Mob ESP",
    Default = false
}):OnChanged(function(Value)

    MobESPEnabled = Value


    if MobESPEnabled then

        local entities = workspace:FindFirstChild("Entities")

        if entities then

            for _,mob in ipairs(entities:GetChildren()) do
                CreateMobESP(mob)
            end


            if MobESPConnection then
                MobESPConnection:Disconnect()
            end


            MobESPConnection = entities.ChildAdded:Connect(function(mob)

                task.wait(0.2)

                CreateMobESP(mob)

            end)

        end


    else

        if MobESPConnection then
            MobESPConnection:Disconnect()
            MobESPConnection = nil
        end


        RemoveMobESP()

    end

end)

Players.LocalPlayer.CharacterAdded:Connect(function(Character)
    task.wait(1)

    if MobESPEnabled then
        RemoveMobESP()
        RefreshMobESP()
    else
        RemoveMobESP()
    end
end)



VisualLeftGroupBox2:AddToggle("IgnorePlayersToggle", {
    Text = "Ignore Players",
    Default = true
}):OnChanged(function(Value)

    IgnorePlayers = Value



    if MobESPEnabled then
        RefreshMobESP()
    end

end)
--Start Of ChestESP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local ChestESP = false

local ChestConnections = {
    Render = nil,
    ChildAdded = nil
}


local function GetChestPart(chest)

    for _,v in ipairs(chest:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency < 1 then
            return v
        end
    end

    return nil
end


local function ClearChestESP()

    local folder = workspace:FindFirstChild("Collectibles")

    if folder then
        for _,chest in ipairs(folder:GetChildren()) do

            if chest.Name == "Chest" then

                local highlight = chest:FindFirstChild("ChestHighlight")

                if highlight then
                    highlight:Destroy()
                end


                local billboard = chest:FindFirstChild("ChestBillboard")

                if billboard then
                    billboard:Destroy()
                end

            end
        end
    end


    if ChestConnections.Render then
        ChestConnections.Render:Disconnect()
        ChestConnections.Render = nil
    end


    if ChestConnections.ChildAdded then
        ChestConnections.ChildAdded:Disconnect()
        ChestConnections.ChildAdded = nil
    end

end


local function CreateESP(chest)

    if chest:FindFirstChild("ChestHighlight") then
        return
    end


    local part = GetChestPart(chest)

    if not part then
        return
    end


    local highlight = Instance.new("Highlight")

    highlight.Name = "ChestHighlight"
    highlight.Adornee = part
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.FillTransparency = 0.25
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = chest


    if not highlight.Adornee then
        highlight:Destroy()
        return
    end


    local billboard = Instance.new("BillboardGui")

    billboard.Name = "ChestBillboard"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0,90,0,40)
    billboard.StudsOffset = Vector3.new(0,4,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = chest


    local text = Instance.new("TextLabel")

    text.Name = "ChestText"
    text.Size = UDim2.fromScale(1,1)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255,255,255)
    text.TextStrokeTransparency = 0.25
    text.TextSize = 14
    text.Font = Enum.Font.GothamBold
    text.Text = "Chest\n0 studs"
    text.Parent = billboard

end


local function UpdateChestESP()

    local folder = workspace:FindFirstChild("Collectibles")

    if not folder then
        return
    end


    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end


    for _,chest in ipairs(folder:GetChildren()) do

        if chest.Name == "Chest" and chest:IsA("Model") then

            local part = GetChestPart(chest)

            local highlight = chest:FindFirstChild("ChestHighlight")
            local billboard = chest:FindFirstChild("ChestBillboard")


            if not part or not highlight or highlight.Adornee == nil or highlight.Parent == nil then

                if highlight then
                    highlight:Destroy()
                end

                if billboard then
                    billboard:Destroy()
                end

                continue
            end


            if not billboard then
                CreateESP(chest)
                continue
            end


            if billboard:FindFirstChild("ChestText") then

                local distance = (root.Position - part.Position).Magnitude

                billboard.ChestText.Text =
                    "Chest\n" .. math.floor(distance) .. " studs"

            end

        end

    end

end


local AdminPanelShowChests = VisualLeftGroupBox3:AddToggle("ChestESPToggle", {
    Text = "Chest ESP",
    Default = false
})


AdminPanelShowChests:OnChanged(function(Value)

    ChestESP = Value


    if not Value then
        ClearChestESP()
        return
    end


    local folder = workspace:FindFirstChild("Collectibles")

    if not folder then
        return
    end


    for _,chest in ipairs(folder:GetChildren()) do

        if chest.Name == "Chest" and chest:IsA("Model") then
            CreateESP(chest)
        end

    end


    ChestConnections.ChildAdded = folder.ChildAdded:Connect(function(chest)

        if ChestESP and chest.Name == "Chest" and chest:IsA("Model") then

            task.wait(0.2)

            CreateESP(chest)

        end

    end)


    ChestConnections.Render = RunService.RenderStepped:Connect(function()

        if ChestESP then
            UpdateChestESP()
        end

    end)

end)

-- Observe Leaderboard
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera


local LeaderboardObserve = true
local ObservingPlayer = nil
local SelectedInfoPlayer = nil



-- Bilgi GUI
local PlayerInfoGui = Instance.new("ScreenGui")
PlayerInfoGui.Name = "LeaderboardPlayerInfo"
PlayerInfoGui.ResetOnSpawn = false
PlayerInfoGui.Parent = LocalPlayer.PlayerGui


local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0,300,0,130)
InfoFrame.Position = UDim2.new(0.5,-150,0,40)
InfoFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
InfoFrame.Visible = false
InfoFrame.Parent = PlayerInfoGui


local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,10)
Corner.Parent = InfoFrame



local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Size = UDim2.new(1,0,0,35)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.TextColor3 = Color3.new(1,1,1)
PlayerNameLabel.TextSize = 22
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.Parent = InfoFrame



local RaceLabel = Instance.new("TextLabel")
RaceLabel.Position = UDim2.new(0,10,0,45)
RaceLabel.Size = UDim2.new(1,-20,0,25)
RaceLabel.BackgroundTransparency = 1
RaceLabel.TextColor3 = Color3.new(1,1,1)
RaceLabel.TextSize = 18
RaceLabel.TextXAlignment = Enum.TextXAlignment.Left
RaceLabel.Parent = InfoFrame

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Position = UDim2.new(0,10,0,75)
LevelLabel.Size = UDim2.new(1,-20,0,25)
LevelLabel.BackgroundTransparency = 1
LevelLabel.TextColor3 = Color3.new(1,1,1)
LevelLabel.TextSize = 18
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
LevelLabel.Parent = InfoFrame

local HealthLabel = Instance.new("TextLabel")
HealthLabel.Position = UDim2.new(0,10,0,105)
HealthLabel.Size = UDim2.new(1,-20,0,25)
HealthLabel.BackgroundTransparency = 1
HealthLabel.TextColor3 = Color3.new(1,1,1)
HealthLabel.TextSize = 18
HealthLabel.TextXAlignment = Enum.TextXAlignment.Left
HealthLabel.Parent = InfoFrame





-- Toggle (VisualRightGroupBox + Default true)
VisualRightGroupBox:AddToggle("LeaderboardObserveToggle", {
    Text = "Leaderboard Observe",
    Default = true
}):OnChanged(function(Value)

    LeaderboardObserve = Value


    if not Value then

        local char = LocalPlayer.Character 
            or LocalPlayer.CharacterAdded:Wait()

        local hum = char:FindFirstChildOfClass("Humanoid")


        if hum then
            Camera.CameraSubject = hum
        end


        ObservingPlayer = nil
        SelectedInfoPlayer = nil
        InfoFrame.Visible = false

    end

end)





local scrollingFrame = LocalPlayer.PlayerGui
    :WaitForChild("OryLeaderboard")
    :WaitForChild("ImageLabel")
    :WaitForChild("ScrollingFrame")







local function StopObserve()

    local char = LocalPlayer.Character 
        or LocalPlayer.CharacterAdded:Wait()

    local hum = char:FindFirstChildOfClass("Humanoid")


    if hum then
        Camera.CameraSubject = hum
    end


    ObservingPlayer = nil

end






-- DisplayName (@Username)
local function FindPlayerFromText(text)

    local displayName = text:match("^(.-)%s%(")
    local username = text:match("%(@(.-)%)")


    for _,player in ipairs(Players:GetPlayers()) do


        if username and player.Name == username then
            return player
        end


        if displayName and player.DisplayName == displayName then
            return player
        end


    end


    return nil

end






local function ObservePlayer(player)


    if not LeaderboardObserve then
        return
    end


    if ObservingPlayer == player then

        StopObserve()
        return

    end



    local char = player.Character 
        or player.CharacterAdded:Wait()


    local hum = char:FindFirstChildOfClass("Humanoid")


    if hum then

        Camera.CameraSubject = hum
        ObservingPlayer = player

    end

end






local function ShowPlayerInfo(player)

    if SelectedInfoPlayer == player and InfoFrame.Visible then
        InfoFrame.Visible = false
        SelectedInfoPlayer = nil
        return
    end

    local data = player:FindFirstChild("Data")

    if not data then
        return
    end

    local race = data:FindFirstChild("Race")
    local level = data:FindFirstChild("Level")

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    local health = "Unknown"

    if hum then
        health = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
    end

    PlayerNameLabel.Text = player.Name

    RaceLabel.Text = "Race: " .. (
        race and race.Value or "Unknown"
    )

    LevelLabel.Text = "Level: " .. (
        level and level.Value or "Unknown"
    )

    -- Yeni eklenenler
    HealthLabel.Text = "Health: " .. health

    SelectedInfoPlayer = player
    InfoFrame.Visible = true

end






local function ConnectLeaderboardObject(obj)


    if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then
        return
    end


    obj.Active = true



    obj.InputBegan:Connect(function(input)



        -- Sol click bilgi
        if input.UserInputType == Enum.UserInputType.MouseButton1 then


            local player = FindPlayerFromText(obj.Text)


            if player then
                ShowPlayerInfo(player)
            end


        end






        -- Sağ click observe
        if input.UserInputType == Enum.UserInputType.MouseButton2 then


            local player = FindPlayerFromText(obj.Text)


            if player then
                ObservePlayer(player)
            end


        end


    end)


end





for _,obj in ipairs(scrollingFrame:GetDescendants()) do

    ConnectLeaderboardObject(obj)

end



scrollingFrame.DescendantAdded:Connect(function(obj)

    task.wait(0.2)

    ConnectLeaderboardObject(obj)

end)

local Players = game:GetService("Players")

local JoinNotifier = false

VisualRightGroupBox2:AddToggle("JoinNotifier", {
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
            Time = 3
        })
    end
end)


local StaffList = {
    ["terrapad"] = true,
    ["rapidfire_rocket"] = true,
    ["soryuu02"] = true,
    ["residereso"] = true,
    ["iamarandomnubman"] = true,
    ["epic109791"] = true,
    ["sibstab"] = true,
    ["maxedict"] = true,
    ["x3_paws"] = true,
    ["onnett"] = true,
    ["73pc"] = true,
    ["iammowcow"] = true,
    ["lucasx3486"] = true,
    ["chibaa"] = true,
    ["maidenaudi"] = true,
    ["koyashfr"] = true,
    ["voidcrowx"] = true,
    ["orythegamer"] = true,
    ["thegamer_dev2"] = true,
    ["noobsukee"] = true,
    ["kb4x"] = true,
    ["fujao2"] = true,
    ["keiteudrx"] = true,
    ["mineboxdj22"] = true,
    ["relishisgood"] = true,
    ["endof_eva"] = true,
    ["victoriousprkman"] = true,
    ["jaym289"] = true,
    ["sibstab2"] = true,
    ["refortuneate"] = true,
    ["lazyyjem"] = true,
    ["ampley22"] = true,
    ["atychiphobia2006"] = true,
}

local AdminRaces = {
    "Lychee",
    "Blood Orange",
    "Durian",
    "Duckfish",
    "Cherry",
    "Golden Leafling",
}

local function IsAdminRace(RaceValue)
    for _, RaceName in ipairs(AdminRaces) do
        if RaceValue == RaceName then
            return true
        end
    end
    return false
end

VisualRightGroupBox2:AddToggle("StaffLogToggle", {
    Text = "Mod Team Log (Auto-Log)",
    Default = false,
    Callback = function(Value)
        StaffLog = Value

        if StaffLog then
            for _, Player in ipairs(Players:GetPlayers()) do

                if Player == Players.LocalPlayer then
                    continue
                end

                local IsStaff = StaffList[Player.Name:lower()]
                local HasAdminRace = false
                local FoundRace = nil

                -- Data.Race kontrolü
                local Data = Player:FindFirstChild("Data")
                local Race = Data and Data:FindFirstChild("Race")

                if Race and IsAdminRace(Race.Value) then
                    HasAdminRace = true
                    FoundRace = Race.Value
                end

                if IsStaff then
                    Library:Notify({
                        Title = "Staff Detected!",
                        Description = Player.Name .. " found in StaffList",
                        Time = 5
                    })

                    JoinSmallestServer()
                    return

                elseif HasAdminRace then
                    Library:Notify({
                        Title = "Admin Race Detected!",
                        Description = Player.Name .. " has " .. FoundRace,
                        Time = 5
                    })

                    JoinSmallestServer()
                    return
                end
            end
        end
    end
})

Players.PlayerAdded:Connect(function(Player)
    local Username = string.lower(Player.Name)

    if StaffLog and StaffList[Username] then
        Library:Notify({
            Title = "Admin Notified!",
            Description = Player.Name .. " joined the server!",
            Time = 15
        })
    end
end)

local function CheckStaff(Player)
    local Username = string.lower(Player.Name)

    if StaffList[Username] then
        
        Library:Notify({
            Title = "Admin Notified!",
            Description = Player.Name .. " is in the server!",
            Time = 15
        })

        if StaffHop then
            task.wait(1)

            Library:Notify({
                Title = "Staff Hop Detected!",
                Description = "Hopping To Smallest Server...",
                Time = 3
            })

            task.wait(1)
            JoinSmallestServer()
        end
    end
end


-- Script açılınca mevcut oyuncuları kontrol eder
for _, Player in ipairs(Players:GetPlayers()) do
    CheckStaff(Player)
end


-- Sonradan girenleri kontrol eder
Players.PlayerAdded:Connect(function(Player)
    CheckStaff(Player)
end)

local AutoLog = false
local AutoLogDistance = 50

VisualRightGroupBox2:AddToggle("AutoLogToggle", {
    Text = "Auto Log",
    Default = false,
    Callback = function(Value)
        AutoLog = Value
    end
})

VisualRightGroupBox2:AddSlider("AutoLogDistance", {
    Text = "Auto Log Distance",
    Default = 50,
    Min = 10,
    Max = 1500,
    Rounding = 0,
    Callback = function(Value)
        AutoLogDistance = Value
    end
})

local LastAutoLog = 0
local AutoLogCooldown = 10 -- saniye

local function CheckDistance(Player)
    if not AutoLog then return end
    if not Player.Character then return end
    if not game.Players.LocalPlayer.Character then return end

    local MyRoot = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local TheirRoot = Player.Character:FindFirstChild("HumanoidRootPart")

    if MyRoot and TheirRoot then
        local Distance = (MyRoot.Position - TheirRoot.Position).Magnitude

        if Distance <= AutoLogDistance then
            
            if tick() - LastAutoLog < AutoLogCooldown then
                return
            end

            LastAutoLog = tick()

            Library:Notify({
                Title = "Hopping Server!",
                Description = Player.Name .. " is too close!",
                Time = 3
            })

            JoinSmallestServer()
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, Player in ipairs(game.Players:GetPlayers()) do
        if Player ~= game.Players.LocalPlayer then
            CheckDistance(Player)
        end
    end
end)



-- Addons

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

SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

local AutoRejoinGame = false

RightGroupBox2:AddToggle("AutoRejoinGame", {
    Text = "Auto Rejoin Game",
    Default = false,

    Callback = function(Value)
        AutoRejoinGame = Value

        if AutoRejoinGame then
            task.spawn(function()
                print("5 Minutes Cooldown Started")

                task.wait(300)

                if AutoRejoinGame then
                    print("Rejoining Game")

                    game:GetService("TeleportService"):Teleport(
                        game.PlaceId,
                        game:GetService("Players").LocalPlayer
                    )
                end
            end)
        end
    end
})

RightGroupBox2:AddToggle("AutoExecute", {
    Text = "Auto Execute on Teleport",
    Default = true,

    Callback = function(AutoExecuteValue)
        AutoExecute = AutoExecuteValue

        if AutoExecute and queue_on_teleport then
            queue_on_teleport([[
                repeat task.wait() until game:IsLoaded()

                if game.PlaceId == 76606442853797 then
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/ScriptHub/main/script.lua"))()
                end
            ]])

            print("Queue Added")
        end
    end
})


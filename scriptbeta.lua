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
    Title = "Universal Hub",
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
local SelectedNPC = nil
local AutoFloatNPC = false
local ESPEnabled = false
local CurrentFlyKey = nil
local CurrentSpeedToggleKey = nil
local CurrentNoclipKey = nil
local NoclipToggle = nil
local SpeedToggle = nil
local playerOptions = {}
local KillBrickConnection
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
    ESPEnabled = false
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

    
    if Toggles.AutoFloatNPCToggle then
        Toggles.AutoFloatNPCToggle:SetValue(false)
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
    Title = "Universal",
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
        Humanoid.WalkSpeed = SpeedValue
    else
        Humanoid.WalkSpeed = DefaultSpeed
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

local ChakraPointsFolder = workspace:WaitForChild("ChakraPoints")

local options = {}

for _, chakraPoint in ipairs(ChakraPointsFolder:GetChildren()) do
	if chakraPoint.Name == "ChakraPoint" then
		local stringValue = chakraPoint:FindFirstChildWhichIsA("StringValue")
		if stringValue then
			table.insert(options, stringValue.Value)
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

        SetKillParts(false)


        KillBrickConnection = workspace.DescendantAdded:Connect(function(obj)

            task.wait(0.1)

            DisableKillPart(obj)

        end)

    else

        if KillBrickConnection then
            KillBrickConnection:Disconnect()
            KillBrickConnection = nil
        end


        SetKillParts(true)

    end

end)


-- Visual Section

local VisualLeftGroupBox = Tabs.Visual:AddLeftGroupbox("Player ESP", "box")
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
            Time = 5
        })
    end
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
local AutoLogCooldown = 10 

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

                if game.PlaceId == 10266164381 then
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/ScriptHub/refs/heads/main/scriptbeta.lua"))()
                      else
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kam41514/ScriptHub/main/universal.lua"))()
                end
            ]])

            print("Queue Added")
        end
    end
})

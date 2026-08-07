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
    Title = "Bloodlines Hub",
    Description = "Script Succesfully Executed.",
    Duration = 3
})

-- Observe Notify

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local trackedCharacters = {}

local function watchCharacter(player, character)
	if trackedCharacters[character] then
		return
	end

	trackedCharacters[character] = true

	local torso = character:WaitForChild("Torso", 5) or character:WaitForChild("UpperTorso", 5)
	if not torso then return end

	local chakraActive = false
	local timerId = 0

	local function notify(title, description)
		Library:Notify({
			Title = title,
			Description = description,
			Duration = 10
		})
	end

	local function chakraStarted()
		if chakraActive then
			return
		end

		chakraActive = true
		timerId += 1

		local currentTimer = timerId

		notify(
			"⚠️ Chakra Sense Detected",
			player.Name .. " Used Chakra Sense!"
		)

		task.delay(10, function()
			if chakraActive and currentTimer == timerId then
				notify(
					"⚠️ Chakra Sense Still Active",
					player.Name .. " is still using Chakra Sense!"
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

		notify(
			"Chakra Sense Ended",
			player.Name .. " stopped using Chakra Sense!"
		)
	end

	local function checkExisting()
		local chakra = torso:FindFirstChild("ChakraSense")

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
		watchCharacter(player, character)
	end)

	if player.Character then
		watchCharacter(player, player.Character)
	end
end


for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)

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
local selectedPoint
local FruitESP = false
local farmConnection
local farming = false
local autoPickupConnection
local dangerDistance = 165
local dangerConnection

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local BodyGyro
local BodyVelocity
local FlyConnection


local function StartFlight()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    hum.PlatformStand = true

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    BodyGyro.CFrame = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = root


    FlyConnection = RunService.RenderStepped:Connect(function()

        if not fly then
            return
        end

        local camera = workspace.CurrentCamera
        local move = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move += camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move -= camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move -= camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move += camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move += Vector3.yAxis
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            move -= Vector3.yAxis
        end


        if move.Magnitude > 0 then
            BodyVelocity.Velocity = move.Unit * FlySpeed
        else
            BodyVelocity.Velocity = Vector3.zero
        end

        BodyGyro.CFrame = camera.CFrame
    end)
end



local function StopFlight()

    fly = false

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end


    local char = player.Character

    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
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

-- End Of Player Tab

-- Groupboxes For Exploits Tab
local ExploitsLeftGroupBox = Tabs.Exploits:AddLeftGroupbox("Teleportation", "wind")
local ExploitsRightGroupBox = Tabs.Exploits:AddRightGroupbox("Botting", "bot")
local ExploitsLeftGroupBox3 = Tabs.Exploits:AddLeftGroupbox("Automation", "bot")
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

local function getRoot()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:WaitForChild("HumanoidRootPart")
end

local function getTrees()
	local trees = {}

	for _, tree in ipairs(workspace:GetDescendants()) do
		if tree.Name:match("^Tree") then
			local fruitSpawns = tree:FindFirstChild("FruitSpawns", true)

			if fruitSpawns then
				table.insert(trees, tree)
			end
		end
	end

	return trees
end

local function getTreePart(tree)
	if tree:IsA("BasePart") then
		return tree
	end

	if tree:IsA("Model") then
		return tree.PrimaryPart or tree:FindFirstChildWhichIsA("BasePart", true)
	end
end

local function isPlayerNearby(position)
	for _, plr in ipairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local root = plr.Character:FindFirstChild("HumanoidRootPart")

			if root then
				local distance = (position - root.Position).Magnitude

				if distance <= 250 then
					return true
				end
			end
		end
	end

	return false
end

local function checkChakraSense()
	local character = player.Character
	if not character then return false end

	local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
	if not torso then return false end

	return torso:FindFirstChild("ChakraSense") ~= nil
end

local function getFruits(position)
	local fruits = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and fruitNames[obj.Name] then

			local distance = (position - obj.Position).Magnitude

			if distance <= 200 then
				table.insert(fruits, {
					part = obj,
					distance = distance
				})
			end
		end
	end

	table.sort(fruits, function(a, b)
		return a.distance < b.distance
	end)

	return fruits
end

local function stopFarm()
	farming = false

	if Toggles.AutoFruit then
		Toggles.AutoFruit:SetValue(false)
	end
end


local function startFarm()
	farming = true

	local root = getRoot()

	for _, tree in ipairs(getTrees()) do
		if not farming then return end

		if checkChakraSense() then
			stopFarm()
			return
		end

		local target = getTreePart(tree)

		if target then

			if isPlayerNearby(target.Position) then
				continue
			end

			if checkChakraSense() then
				stopFarm()
				return
			end

			root.CFrame = target.CFrame

			for i = 1, 12 do
				if not farming then return end

				if checkChakraSense() then
					stopFarm()
					return
				end

				task.wait(1)
			end

			local fruits = getFruits(target.Position)

			for _, fruit in ipairs(fruits) do
				if not farming then return end

				if checkChakraSense() then
					stopFarm()
					return
				end

				if fruit.part and fruit.part.Parent then
					root.CFrame = fruit.part.CFrame
					task.wait(1)
				end
			end
		end
	end

	farming = false
end

local function startDangerCheck()
	if dangerConnection then
		dangerConnection:Disconnect()
	end

	dangerConnection = RunService.Heartbeat:Connect(function()
		if not farming then
			return
		end

		local character = player.Character
		if not character then return end

		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then return end

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then

				local enemyRoot = plr.Character:FindFirstChild("HumanoidRootPart")

				if enemyRoot then
					local distance = (rootPart.Position - enemyRoot.Position).Magnitude

					if distance <= dangerDistance then
						game.Players.LocalPlayer.Character:BreakJoints()
						return
					end
				end
			end
		end
	end)
end

local function stopDangerCheck()
	if dangerConnection then
		dangerConnection:Disconnect()
		dangerConnection = nil
	end
end


ExploitsRightGroupBox:AddToggle("AutoFruit", {
	Text = "Auto Fruit",
	Default = false,

	Callback = function(Value)
		if Value then
			if farming then return end

			farming = true
			startDangerCheck()

			task.spawn(function()
				startFarm()
			end)
		else
			farming = false
			stopDangerCheck()
		end
	end
})

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


ExploitsLeftGroupBox3:AddToggle("AutoPick", {
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

-- Visual Section

local VisualLeftGroupBox = Tabs.Visual:AddLeftGroupbox("Player ESP", "eye")
local VisualLeftGroupBox2 = Tabs.Visual:AddLeftGroupbox("Extra ESP", "eye")
local VisualRightGroupBox = Tabs.Visual:AddRightGroupbox("Leaderboard Settings")
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

local list = LocalPlayer.PlayerGui.ClientGui.Mainframe.PlayerList.List

local observeEnabled = false
local currentObserveTarget

local connections = {}

local function clearConnections()
	for _, connection in pairs(connections) do
		connection:Disconnect()
	end

	table.clear(connections)
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
			local playerName = template.PlayerName.Text
			local target = Players:FindFirstChild(playerName)

			if not target or not target.Character then
				return
			end

			if currentObserveTarget == target then
				currentObserveTarget = nil
				Camera.CameraSubject = LocalPlayer.Character:WaitForChild("Humanoid")
			else
				currentObserveTarget = target
				Camera.CameraSubject = target.Character:WaitForChild("Humanoid")
			end
		end
	end)

	table.insert(connections, connection)
end

local function enableObserve()
	clearConnections()

	for _, template in ipairs(list:GetChildren()) do
		setupPlayerTemplate(template)
	end
end

local ObserveToggle = VisualRightGroupBox:AddToggle("ObserveToggle", {
	Text = "Leaderboard Observe",
	Default = false,
})

ObserveToggle:OnChanged(function(value)
	observeEnabled = value

	if value then
		enableObserve()
	else
		clearConnections()
		currentObserveTarget = nil

		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			Camera.CameraSubject = LocalPlayer.Character.Humanoid
		end
	end
end)

list.ChildAdded:Connect(function(child)
	if observeEnabled then
		setupPlayerTemplate(child)
	end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
	if not currentObserveTarget then
		Camera.CameraSubject = character:WaitForChild("Humanoid")
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if currentObserveTarget == player then
			if observeEnabled then
				Camera.CameraSubject = character:WaitForChild("Humanoid")
			end
		end
	end)
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

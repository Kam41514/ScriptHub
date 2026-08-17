local Services = {
    Players = game:GetService("Players"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
}

Services.LocalPlayer = Services.Players.LocalPlayer

local State = {}
local funcs = {}
local Modules = {}
local BaseLocals = {}


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

    BaseLocals.character = Services.LocalPlayer.Character

    if BaseLocals.character then
        return BaseLocals.character
    end

    return Services.LocalPlayer.CharacterAdded:Wait()

end

funcs.getHRP = function()

    BaseLocals.character = funcs.getCharacter()

    return BaseLocals.character
        and BaseLocals.character:FindFirstChild(
            "HumanoidRootPart"
        )

end

funcs.GetActiveChakraPlayers = function()

    BaseLocals.activePlayers = {}

    for _, plr in ipairs(Services.Players:GetPlayers()) do

        if plr ~= Services.LocalPlayer and plr.Character then

            BaseLocals.torso =
                plr.Character:FindFirstChild("Torso")
                or plr.Character:FindFirstChild("UpperTorso")

            if BaseLocals.torso
                and BaseLocals.torso:FindFirstChild("ChakraSense") then

                table.insert(
                    BaseLocals.activePlayers,
                    plr.Name
                )

            end
        end
    end

    return BaseLocals.activePlayers

end

funcs.isAnyActiveChakraUser = function()

    return #funcs.GetActiveChakraPlayers() > 0

end

funcs.isPlayerWithinDistance = function(
    position,
    distance
)

    if not position then
        return false
    end

    BaseLocals.maxDistance =
        distance * distance

    for _, plr in ipairs(
        Services.Players:GetPlayers()
    ) do

        if plr ~= Services.LocalPlayer then

            BaseLocals.character =
                plr.Character

            if BaseLocals.character then

                BaseLocals.hrp =
                    BaseLocals.character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if BaseLocals.hrp then

                    BaseLocals.offset =
                        BaseLocals.hrp.Position - position

                    if BaseLocals.offset:Dot(
                        BaseLocals.offset
                    ) <= BaseLocals.maxDistance then

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

    BaseLocals.hrp = funcs.getHRP()

    if not BaseLocals.hrp then
        return false
    end

    BaseLocals.safePoints =
        State.SafePointPositions

    if not BaseLocals.safePoints then
        return false
    end

    BaseLocals.playerRange =
        State.TreePlayerRange or 150

    BaseLocals.currentPosition =
        BaseLocals.hrp.Position

    BaseLocals.nearestSafePoint = nil
    BaseLocals.nearestDistance = math.huge

    for _, safePoint in pairs(
        BaseLocals.safePoints
    ) do

        BaseLocals.pointPosition = nil

        if typeof(safePoint) == "Vector3" then

            BaseLocals.pointPosition =
                safePoint

        elseif typeof(safePoint) == "CFrame" then

            BaseLocals.pointPosition =
                safePoint.Position

        elseif typeof(safePoint) == "table" then

            if typeof(safePoint.Position) == "Vector3" then

                BaseLocals.pointPosition =
                    safePoint.Position

            elseif typeof(safePoint.CFrame) == "CFrame" then

                BaseLocals.pointPosition =
                    safePoint.CFrame.Position

            elseif safePoint[1]
                and typeof(safePoint[1]) == "number"
                and safePoint[2]
                and typeof(safePoint[2]) == "number"
                and safePoint[3]
                and typeof(safePoint[3]) == "number" then

                BaseLocals.pointPosition =
                    Vector3.new(
                        safePoint[1],
                        safePoint[2],
                        safePoint[3]
                    )

            end
        end

        if BaseLocals.pointPosition then

            BaseLocals.playerNearby =
                funcs.isPlayerWithinDistance(
                    BaseLocals.pointPosition,
                    BaseLocals.playerRange
                )

            if not BaseLocals.playerNearby then

                BaseLocals.distance =
                    (
                        BaseLocals.pointPosition
                        - BaseLocals.currentPosition
                    ).Magnitude

                if BaseLocals.distance
                    < BaseLocals.nearestDistance then

                    BaseLocals.nearestDistance =
                        BaseLocals.distance

                    BaseLocals.nearestSafePoint =
                        BaseLocals.pointPosition

                end
            end
        end
    end

    if not BaseLocals.nearestSafePoint then

        if funcs.updateStatus then

            funcs.updateStatus(
                "   Safe Point",
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

    BaseLocals.humanoid =
        BaseLocals.hrp.Parent:FindFirstChildOfClass(
            "Humanoid"
        )

    BaseLocals.targetPosition =
        BaseLocals.nearestSafePoint
        + Vector3.new(0, 3, 0)

    if BaseLocals.humanoid then

        BaseLocals.humanoid:ChangeState(
            Enum.HumanoidStateType.Physics
        )

    end

    BaseLocals.hrp.AssemblyLinearVelocity =
        Vector3.zero

    BaseLocals.hrp.AssemblyAngularVelocity =
        Vector3.zero

    BaseLocals.hrp.CFrame =
        CFrame.new(
            BaseLocals.targetPosition
        )

    task.wait(0.1)

    if not BaseLocals.hrp.Parent then
        return false
    end

    BaseLocals.hrp.AssemblyLinearVelocity =
        Vector3.zero

    BaseLocals.hrp.AssemblyAngularVelocity =
        Vector3.zero

    if (
        BaseLocals.hrp.Position
        - BaseLocals.targetPosition
    ).Magnitude > 5 then

        BaseLocals.hrp.CFrame =
            CFrame.new(
                BaseLocals.targetPosition
            )

        task.wait(0.1)

        if not BaseLocals.hrp.Parent then
            return false
        end

        BaseLocals.hrp.AssemblyLinearVelocity =
            Vector3.zero

        BaseLocals.hrp.AssemblyAngularVelocity =
            Vector3.zero

    end

    if BaseLocals.humanoid then

        BaseLocals.humanoid:ChangeState(
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

    BaseLocals.trees = {}

    for _, obj in ipairs(
        workspace:GetChildren()
    ) do

        if obj:IsA("Model")
            and string.match(
                obj.Name,
                "^Tree%d+$"
            ) then

            BaseLocals.fruitSpawns =
                obj:FindFirstChild(
                    "FruitSpawns"
                )

            BaseLocals.mainBranch =
                obj:FindFirstChild(
                    "MainBranch"
                )

            if BaseLocals.fruitSpawns
                and BaseLocals.mainBranch
                and BaseLocals.mainBranch:IsA("BasePart") then

                table.insert(
                    BaseLocals.trees,
                    {
                        Tree = obj,
                        FruitSpawns =
                            BaseLocals.fruitSpawns,
                        MainBranch =
                            BaseLocals.mainBranch
                    }
                )

            end
        end
    end

    table.sort(
        BaseLocals.trees,
        function(a, b)

            return a.Tree.Name
                < b.Tree.Name

        end
    )

    return BaseLocals.trees

end


funcs.teleportToTree = function(
    treeData
)

    if not treeData
        or not treeData.Tree
        or not treeData.Tree.Parent then

        return false

    end

    if funcs.isAnyActiveChakraUser() then
        return false
    end

    BaseLocals.hrp =
        funcs.getHRP()

    if not BaseLocals.hrp then
        return false
    end

    BaseLocals.mainBranch =
        treeData.MainBranch

    if not BaseLocals.mainBranch
        or not BaseLocals.mainBranch.Parent
        or not BaseLocals.mainBranch:IsA("BasePart") then

        return false
    end

    BaseLocals.targetPosition =
        BaseLocals.mainBranch.Position

    BaseLocals.playerRange =
        State.TreePlayerRange or 150

    if funcs.isPlayerWithinDistance(
        BaseLocals.targetPosition,
        BaseLocals.playerRange
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
        BaseLocals.hrp

    BaseLocals.hrp.CFrame =
        CFrame.new(
            BaseLocals.targetPosition
        )

    task.wait(0.1)

    if not State.TreeFarmEnabled then
        return false
    end

    if not BaseLocals.hrp.Parent then
        return false
    end

    if funcs.isAnyActiveChakraUser() then
        return false
    end

    BaseLocals.hrp.AssemblyLinearVelocity =
        Vector3.zero

    BaseLocals.hrp.AssemblyAngularVelocity =
        Vector3.zero

    BaseLocals.hrp.CFrame =
        CFrame.new(
            BaseLocals.targetPosition
        )

    return true

end

funcs.checkNearbyPlayerAfterTeleport = function()

    BaseLocals.hrp =
        funcs.getHRP()

    if not BaseLocals.hrp then
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

    BaseLocals.playerRange = State.TreePlayerRange or 150

    if not funcs.isPlayerWithinDistance(
        BaseLocals.hrp.Position,
        BaseLocals.playerRange
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

    BaseLocals.result = {}
    BaseLocals.allowed = {}

    if State.FruitNames then

        for name, enabled in pairs(
            State.FruitNames
        ) do

            if enabled then
                BaseLocals.allowed[name] = true
            end

        end

    else

        BaseLocals.names = {
            "Mango",
            "Orange",
            "Banana",
            "Apple",
            "Alluring Apple",
            "Pear",
            "Chakra Fruit",
            "Life Up Fruit",
            "Fruit Of Forgetfulness",
        }

        for _, name in ipairs(
            BaseLocals.names
        ) do

            BaseLocals.allowed[name] = true

        end

    end


    BaseLocals.hrp =
        funcs.getHRP()

    if not BaseLocals.hrp then
        return BaseLocals.result
    end


    BaseLocals.currentPosition =
        BaseLocals.hrp.Position


    for _, obj in ipairs(
        workspace:GetDescendants()
    ) do

        if BaseLocals.allowed[obj.Name] then

            BaseLocals.position =
                funcs.getFruitPosition(
                    obj
                )

            if BaseLocals.position
                and (
                    BaseLocals.position
                    - BaseLocals.currentPosition
                ).Magnitude <= 300 then

                BaseLocals.playerNearby =
                    funcs.isPlayerWithinDistance(
                        BaseLocals.position,
                        50
                    )

                if not BaseLocals.playerNearby then

                    table.insert(
                        BaseLocals.result,
                        {
                            Object = obj,
                            Position = BaseLocals.position
                        }
                    )

                end

            end
        end
    end


    return BaseLocals.result

end

funcs.teleportToFruit = function(
    fruitData
)

    if funcs.isAnyActiveChakraUser() then
        return false
    end


    BaseLocals.hrp =
        funcs.getHRP()

    if not BaseLocals.hrp then
        return false
    end


    BaseLocals.position =
        funcs.getFruitPosition(
            fruitData.Object
        )

    if not BaseLocals.position then
        return false
    end


    if funcs.isAnyActiveChakraUser() then
        return false
    end


    BaseLocals.position =
        BaseLocals.position
        - Vector3.new(
            0,
                       0.5,
            0
        )


    BaseLocals.hrp.CFrame =
        CFrame.new(
            BaseLocals.position
        )


    return true

end

funcs.waitForTreeFruits = function(
    treeData
)

    BaseLocals.timeout = 10

    BaseLocals.startTime =
        tick()

    BaseLocals.currentRunId =
        State.TreeFarmRunId


    while State.TreeFarmEnabled
        and BaseLocals.currentRunId
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
                or BaseLocals.currentRunId
                    ~= State.TreeFarmRunId


            if not State.TreeFarmEnabled
                or BaseLocals.currentRunId
                    ~= State.TreeFarmRunId then

                return {}

            end


            BaseLocals.startTime =
                tick()

        end


        BaseLocals.currentFruits =
            funcs.getCurrentFruits()


        if #BaseLocals.currentFruits > 0 then

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
                or BaseLocals.currentRunId
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
                    or BaseLocals.currentRunId
                        ~= State.TreeFarmRunId


                if not State.TreeFarmEnabled
                    or BaseLocals.currentRunId
                        ~= State.TreeFarmRunId then

                    return {}

                end

            end


            return funcs.getCurrentFruits()

        end


        if tick() - BaseLocals.startTime
            >= BaseLocals.timeout then

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

funcs.isPlayerNearFruit = function(position)

    if not position then
        return false
    end

    for _, player in ipairs(
        Services.Players:GetPlayers()
    ) do

        if player ~= Services.LocalPlayer then

            BaseLocals.character =
                player.Character

            if BaseLocals.character then

                BaseLocals.rootPart =
                    BaseLocals.character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if BaseLocals.rootPart then

                    BaseLocals.distance =
                        (
                            BaseLocals.rootPart.Position
                            - position
                        ).Magnitude

                    if BaseLocals.distance <= 75 then
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

    BaseLocals.connectionName =
        "TreeFarm_AutoPickup"

    State.AutoPickupConnectionName =
        BaseLocals.connectionName

    Connect(
        BaseLocals.connectionName,
        Services.RunService.Heartbeat,
        function()

            if not State.TreeFarmEnabled then
                return
            end

            BaseLocals.character =
                Services.LocalPlayer.Character

            if not BaseLocals.character then
                return
            end

            BaseLocals.rootPart =
                BaseLocals.character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not BaseLocals.rootPart then
                return
            end

            BaseLocals.pickupList =
                State.PickupList

            if not BaseLocals.pickupList then
                return
            end

            BaseLocals.dataEvent =
                Services.ReplicatedStorage
                    :FindFirstChild("Events")
                    and Services.ReplicatedStorage.Events
                        :FindFirstChild("DataEvent")

            if not BaseLocals.dataEvent then
                return
            end

            for pos, obj in pairs(
                BaseLocals.pickupList
            ) do

                if obj
                    and obj.Parent then

                    BaseLocals.distance =
                        (
                            BaseLocals.rootPart.Position
                            - pos
                        ).Magnitude

                    if BaseLocals.distance < 25 then

                        BaseLocals.id =
                            obj:FindFirstChild(
                                "ID"
                            )

                        if BaseLocals.id then

                            BaseLocals.dataEvent:FireServer(
                                "PickUp",
                                BaseLocals.id.Value
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

funcs.runTreeFarm = function()

    BaseLocals.trees =
        funcs.getTrees()

    if #BaseLocals.trees == 0 then

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

    BaseLocals.currentRunId =
        State.TreeFarmRunId

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

                BaseLocals.character =
                    player.Character

                if BaseLocals.character then

                    BaseLocals.rootPart =
                        BaseLocals.character:FindFirstChild(
                            "HumanoidRootPart"
                        )

                    if BaseLocals.rootPart then

                        BaseLocals.distance =
                            (
                                BaseLocals.rootPart.Position
                                - position
                            ).Magnitude

                        if BaseLocals.distance <= 75 then
                            return true
                        end

                    end

                end

            end

        end

        return false

    end


    for index, treeData in ipairs(
        BaseLocals.trees
    ) do

        if not State.TreeFarmEnabled
            or BaseLocals.currentRunId
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
                or BaseLocals.currentRunId
                    ~= State.TreeFarmRunId


            if not State.TreeFarmEnabled
                or BaseLocals.currentRunId
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
                #BaseLocals.trees,
                treeData.Tree.Name
            )
        )


        if funcs.isAnyActiveChakraUser() then
            continue
        end


        BaseLocals.teleported =
            funcs.teleportToTree(
                treeData
            )


        if not BaseLocals.teleported then

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
                    #BaseLocals.trees
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


        BaseLocals.currentFruits =
            funcs.waitForTreeFruits(
                treeData
            )


        if not State.TreeFarmEnabled
            or BaseLocals.currentRunId
                ~= State.TreeFarmRunId then

            return

        end


        for fruitIndex, fruitData in ipairs(
            BaseLocals.currentFruits
        ) do

            if not State.TreeFarmEnabled
                or BaseLocals.currentRunId
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
                    or BaseLocals.currentRunId
                        ~= State.TreeFarmRunId


                if not State.TreeFarmEnabled
                    or BaseLocals.currentRunId
                        ~= State.TreeFarmRunId then

                    return

                end

            end


            if funcs.checkNearbyPlayerAfterTeleport() then
                break
            end


            if fruitData.Object
                and fruitData.Object.Parent then

                BaseLocals.fruitPosition =
                    funcs.getFruitPosition(
                        fruitData.Object
                    )


                if not BaseLocals.fruitPosition then
                    continue
                end


                if funcs.isPlayerNearFruit(
                    BaseLocals.fruitPosition
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
                            #BaseLocals.currentFruits
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
                        #BaseLocals.currentFruits,
                        treeData.Tree.Name
                    )
                )


                if not funcs.isAnyActiveChakraUser() then

                    if not funcs.isPlayerNearFruit(
                        BaseLocals.fruitPosition
                    ) then

                        funcs.teleportToFruit(
                            fruitData
                        )

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
        and BaseLocals.currentRunId
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

        BaseLocals.character =
            Services.LocalPlayer.Character
            or Services.LocalPlayer.CharacterAdded:Wait()

        BaseLocals.humanoid =
            BaseLocals.character:FindFirstChildOfClass(
                "Humanoid"
            )

        if BaseLocals.humanoid then

            BaseLocals.animator =
                BaseLocals.humanoid:FindFirstChildOfClass(
                    "Animator"
                )

            if not BaseLocals.animator then

                BaseLocals.animator =
                    Instance.new(
                        "Animator"
                    )

                BaseLocals.animator.Parent =
                    BaseLocals.humanoid

            end

            BaseLocals.animation =
                Instance.new(
                    "Animation"
                )

            BaseLocals.animation.AnimationId =
                "rbxassetid://122919972398961"

            BaseLocals.track =
                BaseLocals.animator:LoadAnimation(
                    BaseLocals.animation
                )

            BaseLocals.track.Looped = true

            BaseLocals.track:Play()

            State.TreeFarmAnimation =
                BaseLocals.animation

            State.TreeFarmAnimationTrack =
                BaseLocals.track

        end

    end

    State.PickupList =
        State.PickupList or {}

    local function onPickupAdded(obj)

        if not obj:IsA("BasePart") then
            return
        end

        BaseLocals.pickupable =
            obj:FindFirstChild(
                "Pickupable"
            )

        if not BaseLocals.pickupable then
            return
        end

        BaseLocals.id =
            obj:FindFirstChild(
                "ID"
            )

        if not BaseLocals.id then
            return
        end

        BaseLocals.pos =
            obj.Position

        State.PickupList[
            BaseLocals.pos
        ] = obj

        obj.Destroying:Connect(
            function()

                if State.PickupList[
                    BaseLocals.pos
                ] == obj then

                    State.PickupList[
                        BaseLocals.pos
                    ] = nil

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

            BaseLocals.character =
                Services.LocalPlayer.Character

            if not BaseLocals.character then
                return
            end

            BaseLocals.rootPart =
                BaseLocals.character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not BaseLocals.rootPart then
                return
            end

            BaseLocals.currentTime =
                tick()

            if BaseLocals.currentTime
                - State.TreeFarmAutoPickLastRun
                < 0.1 then

                return
            end

            State.TreeFarmAutoPickLastRun =
                BaseLocals.currentTime

            BaseLocals.myPosition =
                BaseLocals.rootPart.Position

            BaseLocals.pickRange =
                State.FruitPickRange or 50

            for pos, obj in next,
                State.PickupList do

                if obj
                    and obj.Parent then

                    BaseLocals.distance =
                        (
                            BaseLocals.myPosition
                            - pos
                        ).Magnitude

                    if BaseLocals.distance
                        <= BaseLocals.pickRange then

                        BaseLocals.id =
                            obj:FindFirstChild(
                                "ID"
                            )

                        if BaseLocals.id then

                            Services.ReplicatedStorage
                                :WaitForChild(
                                    "Events"
                                )
                                :WaitForChild(
                                    "DataEvent"
                                )
                                :FireServer(
                                    "PickUp",
                                    BaseLocals.id.Value
                                )

                        end

                    end

                else

                    State.PickupList[pos] =
                        nil

                end

            end

        end
    )

    BaseLocals.currentRunId =
        State.TreeFarmRunId

    task.spawn(
        function()

            BaseLocals.firstCheck =
                true

            while State.TreeFarmEnabled
                and BaseLocals.currentRunId
                    == State.TreeFarmRunId do

                BaseLocals.activePlayers =
                    funcs.GetActiveChakraPlayers()

                if #BaseLocals.activePlayers > 0 then

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
                            #BaseLocals.activePlayers
                        )
                    )

                    if not BaseLocals.firstCheck then

                        BaseLocals.hrp =
                            funcs.getHRP()

                        if BaseLocals.hrp then
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

                        BaseLocals.activePlayers =
                            funcs.GetActiveChakraPlayers()

                    until #BaseLocals.activePlayers == 0
                        or not State.TreeFarmEnabled
                        or BaseLocals.currentRunId
                            ~= State.TreeFarmRunId

                    if not State.TreeFarmEnabled
                        or BaseLocals.currentRunId
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

                BaseLocals.firstCheck =
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

--




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

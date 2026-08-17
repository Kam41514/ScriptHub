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

    local nearestSafePoint = nil
    local nearestDistance = math.huge

    for _, safePoint in pairs(
        safePoints
    ) do

        local pointPosition = nil

        if typeof(safePoint) == "Vector3" then

            pointPosition =
                safePoint

        elseif typeof(safePoint) == "CFrame" then

            pointPosition =
                safePoint.Position

        elseif typeof(safePoint) == "table" then

            if typeof(safePoint.Position) == "Vector3" then

                pointPosition =
                    safePoint.Position

            elseif typeof(safePoint.CFrame) == "CFrame" then

                pointPosition =
                    safePoint.CFrame.Position

            elseif safePoint[1]
                and typeof(safePoint[1]) == "number"
                and safePoint[2]
                and typeof(safePoint[2]) == "number"
                and safePoint[3]
                and typeof(safePoint[3]) == "number" then

                pointPosition =
                    Vector3.new(
                        safePoint[1],
                        safePoint[2],
                        safePoint[3]
                    )

            end
        end

        if pointPosition then

            local playerNearby =
                funcs.isPlayerWithinDistance(
                    pointPosition,
                    playerRange
                )

            if not playerNearby then

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
    end

    if not nearestSafePoint then

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

    local humanoid =
        hrp.Parent:FindFirstChildOfClass("Humanoid")

    local targetPosition =
        nearestSafePoint + Vector3.new(0, 3, 0)

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

    local TimerLabel =
    Instance.new("TextLabel")

    TimerLabel.Name =
    "Timer"

    TimerLabel.Size =
    UDim2.fromOffset(
    90,
    18
    )

    TimerLabel.AnchorPoint =
    Vector2.new(
    1,
    1
    )

    TimerLabel.Position =
    UDim2.new(
    1,
    -8,
    1,
    -5
    )

    TimerLabel.BackgroundTransparency =
    1

    TimerLabel.Text =
    "Timer: 00:00"

    TimerLabel.TextColor3 =
    Color3.fromRGB(
    200,
    230,
    255
    )

    TimerLabel.TextSize =
    10

    TimerLabel.Font =
    Enum.Font.GothamMedium

    TimerLabel.TextXAlignment =
    Enum.TextXAlignment.Right

    TimerLabel.ZIndex =
    4

    TimerLabel.Parent =
    Content

    State.TreeFarmTimer =
    TimerLabel

    local TimerStart =
    tick()

    State.TreeFarmTimerStart =
    TimerStart

    task.spawn(function()

    while State.TreeFarmScreenGui
        and State.TreeFarmScreenGui.Parent do

        local Elapsed =
            math.floor(
                tick() - State.TreeFarmTimerStart
            )

        local Minutes =
            math.floor(
                Elapsed / 60
            )

        local Seconds =
            Elapsed % 60

        if State.TreeFarmTimer then

            State.TreeFarmTimer.Text =
                string.format(
                    "Timer: %02d:%02d",
                    Minutes,
                    Seconds
                )

        end

        task.wait(1)

    end

    end)


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
            "Life Up Fruit",
            "Fruit Of Forgetfulness",
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

    local Players =
        game:GetService("Players")

    local function isPlayerNearFruit(position)

        for _, player in ipairs(
            Players:GetPlayers()
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

                local fruitPosition =
                    fruitData.Object.Position

                if isPlayerNearFruit(
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

                    if not isPlayerNearFruit(
                        fruitPosition
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
    Groupboxes.BottingRightGroupBox:AddToggle(
        "TreeFarmToggle",
        {
            Text = "Fruit Farm",
            Default = false
        }
    )

TreeFarmToggle:OnChanged(function(Value)

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

    -- TREE FARM ANIMATION
    do

        local player =
            Services.Players.LocalPlayer

        local character =
            player.Character
            or player.CharacterAdded:Wait()

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

    -- AUTO PICK
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
                Services.Players.LocalPlayer.Character

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

                            Services.ReplicatedStorage
                                :WaitForChild(
                                    "Events"
                                )
                                :WaitForChild(
                                    "DataEvent"
                                )
                                :FireServer(
                                    "PickUp",
                                    id.Value
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

                    -- CHAKRA ALGILANDI: ANIMASYONU BOZ
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

                    -- CHAKRA BİTTİ: ANİMASYONU TEKRAR OYNAT
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

                    -- NORMAL FARM: ANİMASYON ÇALIŞIYOR
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

local LocalPlayer = game.Players.LocalPlayer;
local u1 = LocalPlayer:GetMouse();
local CurrentCamera = workspace.CurrentCamera;
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local _ = RunService.RenderStepped;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("HttpService");
local StarterGui = game:GetService("StarterGui");
local MarketplaceService = game:GetService("MarketplaceService");
local CollectionService = game:GetService("CollectionService");
local u2 = {};
local LocalTween = require(ReplicatedStorage:WaitForChild("LocalTween"));
local Signal = require(ReplicatedStorage:WaitForChild("Signal"));
local u3 = {
    UpdatedData = Signal.new(),
    RainAboveUpdated = Signal.new()
};
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
StarterGui:SetCoreGuiEnabled("Health", false);
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
GUI = script.Parent;
xmas = false;
halloween = false;
valentine = false;
LocalPlayer.Backpack.ChildAdded:Connect(function() -- Line: 39
    print("Attempted to add to backpack");
end);
require(ReplicatedStorage.WeldManager);
local GameManager = require(ReplicatedStorage.GameManager);
local DataEvent = ReplicatedStorage.Events.DataEvent;
local DataFunction = ReplicatedStorage.Events.DataFunction;
local Emit = require(ReplicatedStorage:WaitForChild("Emit"));
local u4 = require(ReplicatedStorage:WaitForChild("forge-vfx"));
local Mainframe = script.Parent:WaitForChild("Mainframe");
local EmoteFrame = Mainframe:WaitForChild("EmoteFrame");
local TraitFrame = Mainframe:WaitForChild("TraitFrame");
local ModPanel = Mainframe:WaitForChild("ModPanel");
local KotoamatsukamiCommands = Mainframe:WaitForChild("KotoamatsukamiCommands");
local RiftFrame = Mainframe:WaitForChild("RiftFrame");
local Danger = Mainframe:WaitForChild("Danger");
local PlayerList = Mainframe:WaitForChild("PlayerList");
local Loadout = Mainframe:WaitForChild("Loadout");
local Rest = Mainframe:WaitForChild("Rest");
local MainMenuFrame = Rest:WaitForChild("MainMenuFrame");
local TravelFrame = Rest:WaitForChild("TravelFrame");
local SettingsFrame = Rest:WaitForChild("SettingsFrame");
local TitlesFrame = Rest:WaitForChild("TitlesFrame");
local ServerList = Rest:WaitForChild("ServerList");
local DestroyFrame = Rest:WaitForChild("DestroyFrame");
local SkillsFrame = Rest:WaitForChild("SkillsFrame");
local SkillView = Rest:WaitForChild("SkillView");
MainMenuFrame.Position = UDim2.new(-0.4, 0, 0, 0);
TravelFrame.Position = UDim2.new(1.1, 0, 0, 0);
Rest:WaitForChild("TitleImage").Position = UDim2.new(0.1, 0, -0.2, 0);
local Ryo = Mainframe:WaitForChild("Ryo");
local Acumen = Mainframe:WaitForChild("Acumen");
local Embers = Mainframe:WaitForChild("Embers");
local Dialog = Loadout:WaitForChild("Dialog");
local Inventory = Loadout:WaitForChild("Inventory");
local InventoryScroll = Inventory:WaitForChild("InventoryScroll");
local LeftFrame = Loadout:WaitForChild("LeftFrame");
local RightFrame = Loadout:WaitForChild("RightFrame");
local TopFrame = Loadout:WaitForChild("TopFrame");
local HUD = Loadout:WaitForChild("HUD");
local JumpCounters = Loadout:WaitForChild("JumpCounters");
local FoodCounters = Loadout:WaitForChild("FoodCounters");
local Chakra = HUD:WaitForChild("ChakraTop"):WaitForChild("Chakra");
local Health = HUD:WaitForChild("HealthTop"):WaitForChild("Health");
local LifeForce = HUD:WaitForChild("LifeForce");
local PerfectGuard = HUD:WaitForChild("PerfectGuard");
local SubIndicator = HUD:WaitForChild("SubIndicator");
local Awakening = HUD:WaitForChild("Awakening");
local BloodlinesFrame = Mainframe:WaitForChild("BloodlinesFrame");
local MenuScreen = script.Parent:WaitForChild("MenuScreen");
local LoadingScreen = MenuScreen:WaitForChild("LoadingScreen");
local Menu = MenuScreen:WaitForChild("Menu");
local MenuSelect = MenuScreen:WaitForChild("MenuSelect");
local ServerList2 = MenuScreen:WaitForChild("ServerList");
local SlideScreen = script.Parent:WaitForChild("SlideScreen");

function TweenSlideScreen(p5)
    -- upvalues: SlideScreen (copy)
    SlideScreen.Position = UDim2.new(-2, 0, 0, -80);
    SlideScreen:TweenPosition(UDim2.new(1, 0, 0, -80), "In", "Linear", p5);
end;

if not ReplicatedStorage.Loaded:FindFirstChild(LocalPlayer.Name) then
    MenuScreen.Visible = true;
    LoadingScreen.Visible = true;
end;

local u6;

if LocalPlayer:FindFirstChild("SoundPlaylist") then
    u6 = LocalPlayer:FindFirstChild("SoundPlaylist");
else
    u6 = Instance.new("Folder");
    u6.Name = "SoundPlaylist";

    for _, child in ipairs(ReplicatedStorage.LocalSounds:GetChildren()) do
        child:Clone().Parent = u6;
    end;

    u6.Parent = LocalPlayer;
end;

local u7 = DataFunction:InvokeServer("PlaceType");
local v8 = DataFunction:InvokeServer("AmITester");

if v8 == true then
    Menu:WaitForChild("Testing").Visible = true;
end;

if v8 then
    game:GetService("TextChatService").ChatWindowConfiguration.Enabled = true;
else
    game:GetService("TextChatService").ChatWindowConfiguration.Enabled = false;
end;

if ReplicatedStorage.Loaded:FindFirstChild(LocalPlayer.Name) or u7 ~= "Main" then
    if u7 == "Arena" then
        if not game:IsLoaded() then
            game.Loaded:Wait();
        end;

        wait(1);
        TweenService:Create(LoadingScreen, TweenInfo.new(1), {
            Transparency = 1
        }):Play();
    end;
else
    if not (RunService:IsStudio() or v8) then
        wait(0.5);
    end;

    if halloween then
        u6.HallowMenuTrack:Play();
        LoadingScreen.Bloodlines.Image = "rbxassetid://11638923485";
    elseif xmas then
        u6.HallowMenuTrack:Play();
        LoadingScreen.Bloodlines.Image = "rbxassetid://11883711611";
    elseif valentine then
        u6.HallowMenuTrack:Play();
        LoadingScreen.Bloodlines.Image = "rbxassetid://106190052235265";
    else
        u6.MenuTrack:Play();
    end;

    TweenService:Create(LoadingScreen.Bloodlines, TweenInfo.new(1), {
        ImageTransparency = 0
    }):Play();

    if not (RunService:IsStudio() or v8) then
        wait(13);
    end;
end;

local u9 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local Humanoid = u9:WaitForChild("Humanoid");
local HumanoidRootPart = u9:WaitForChild("HumanoidRootPart");
local u10 = game.ReplicatedStorage.Settings:WaitForChild(u9.Name);
local u11, v12, u13 = DataFunction:InvokeServer("GetData");
local u14 = nil;

if not u11 then
    local v15 = 0;

    repeat
        local v16, v17;
        v16, v12, v17 = DataFunction:InvokeServer("GetData");
        u11 = v16;
        u13 = v17;
        task.wait(1);
        print("waiting for your data to load");
        v15 = v15 + 1;
    until u11 or v15 == 20;

    local _ = v15 == 20;
end;

local v18, v19, v20 = DataFunction:InvokeServer("getVillageData");
VillageData = v18;
villageMonth = v19;
villageWeek = v20;

function getVillageData(p21, p22, p23)
    return VillageData["Month" .. (p22 or villageMonth)]["Week" .. (p23 or villageWeek)][p21];
end;

function getEconomy(p24)
    return p24 == "Rogue" and "Struggling" or (p24 == "Neutral" and "Average" or (not p24 and "Average" or getVillageData(p24).Politics.Economy));
end;

function getVillageRelationship(p25, p26)
    if not (p25 and p26) then
        return nil;
    end;

    if p25 == "Rogue" or p26 == "Rogue" then
        return "War";
    end;

    if p25 == "Neutral" or p26 == "Neutral" then
        return "Neutral";
    end;

    local v27 = getVillageData(p25);
    local v28 = getVillageData(p26);

    return p25 == p26 and "Own" or ((table.find(v27.Politics.Alliances, p26) or table.find(v28.Politics.Alliances, p25)) and "Allied" or ((table.find(v27.Politics.Wars, p26) or table.find(v28.Politics.Wars, p25)) and "War" or "Neutral"));
end;

local LoadoutKeybinds = u11.LoadoutKeybinds;
local ServerAge = ReplicatedStorage.ServerAge;
TopFrame:WaitForChild("Version").Text = "Place Version : v" .. game.PlaceVersion / 1000;
TopFrame:WaitForChild("Region").Text = "Server Region : " .. v12;
TopFrame:WaitForChild("Age").Text = "Server Age : " .. ServerAge.Value;
MainMenuFrame:WaitForChild("ServerName").Text = "Server Name : " .. u13;
ServerAge.Changed:Connect(function(p29) -- Line: 266
    -- upvalues: TopFrame (copy)
    TopFrame.Age.Text = "Server Age : " .. p29;
end);

if not ReplicatedStorage.Loaded:FindFirstChild(LocalPlayer.Name) and u7 == "Main" then
    TweenService:Create(LoadingScreen.Bloodlines, TweenInfo.new(1), {
        ImageTransparency = 1
    }):Play();
    wait(0.5);
    game.Lighting.FogStart = 0;
    game.Lighting.FogEnd = 300;
    game.Lighting.FogColor = Color3.fromRGB(87, 180, 111);
    game.Lighting.Ambient = Color3.new(0.49019607843137253, 0.49019607843137253, 0.49019607843137253);
    game.Lighting.OutdoorAmbient = Color3.new(0.39215686274509803, 0.39215686274509803, 0.39215686274509803);

    if halloween then
        game.Lighting.FogColor = Color3.fromRGB(90, 51, 12);
    elseif xmas then
        game.Lighting.FogColor = Color3.fromRGB(220, 220, 220);
    elseif valentine then
        game.Lighting.FogColor = Color3.fromRGB(72, 25, 62);
    end;

    if u11.PlayedBefore == false then
        LoadingScreen:WaitForChild("PinFrame").Visible = true;
        LoadingScreen.PinFrame.Pin.Text = u11.Pin;
        wait(5);
        LoadingScreen.PinFrame.SavedIt.Visible = true;
        local u30 = false;
        LoadingScreen.PinFrame.SavedIt.MouseButton1Down:Connect(function() -- Line: 296
            -- upvalues: u30 (ref)
            u30 = true;
        end);

        repeat
            wait();
        until u30 == true;

        LoadingScreen.PinFrame.Visible = false;
        wait(0.5);
    end;

    TweenService:Create(LoadingScreen, TweenInfo.new(1), {
        Transparency = 1
    }):Play();
end;

local u31 = nil;
observingCharacter = nil;
local u32 = {
    CharFacing = false,
    DebrisCooldown = false,
    InventoryType = "Icon",
    Fall_Damage_Begin = 80,
    Fall_Damage_Scale = 0.4,
    HUDHidden = false,
    lavaTick = 0,
    voidTick = 0,
    Last_Y = u9:WaitForChild("Torso").Position.Y,
    expLast_Y = nil,
    ShortCooldown = false,
    myTrinkets = {},
    myFruits = {},
    pickUpCooldown = false,
    fixWeaponAnim = false,
    actualRainAbove = false,
    rangeToHighlight = 100,
    RingCooldown = false,
    dynamicCamera = false,
    InDangerText = "",
    CurrentEmote = "",
    EmotePosition = Vector3.new(0, 0, 0),
    AilmentCooldown = false,
    Inventory = u11.Inventory,
    Loadout = u11.Loadout,
    SlotCount = 10,
    InventorySlotCount = 0,
    SelectedSlot = "",
    CurrentPage = "",
    ChangingPage = true,
    PreviousSlotSize = UDim2.new(0, 0, 0, 0),
    PreviousSlotPosition = UDim2.new(0, 0, 0, 0),
    EnlargedSlot = 0,
    Dragging = GUI:WaitForChild("Dragging"),
    oldInfo = nil,
    oldQuantity = nil,
    holding = 0,
    prevHoldingSlot = 0,
    diffx = 0,
    diffy = 0,
    DisplayingText = false,
    camIntensity = 0,
    FPS = 0,
    AwakeningImageWaitTime = 0,
    AwakeningImageNumber = 1,
    currentSkillsModule = {},
    totalRarity = 0,
    bloodlineHeight = 0.05,
    DropCooldown = false,
    ABV = { "AsakujakuBV", "AttackBV", "SlideBV", "VaultBV", "DashBV", "DynamicBV", "WillowDanceBV", "CrowIllusionBV", "ZigZagPounceBV", "ShukakuCloakBV", "DirectionalBV", "GrappleBV", "KnockbackBV", "CustomForceBV", "JumpBV", "WoodenDragonBV", "IceDragonBV", "VacuumRotationBV", "IsobuSwallowBP", "IsobuBashBP", "IceSkateBV" },
    EmoteFramePage = "Emotes",
    emoteFrameVisible = false,
    commandCooldown = 0,
    streamermode = LocalPlayer.Backpack:WaitForChild("streamermode"),
    ScrollCommands = ModPanel:WaitForChild("ScrollCommands"),
    ScrollShop = ModPanel:WaitForChild("ScrollShop"),
    CommandsButton = ModPanel:WaitForChild("CommandsButton"),
    ShopButton = ModPanel:WaitForChild("ShopButton"),
    ModPage = "Commands",
    modPanelVisible = false,
    moderator = DataFunction:InvokeServer("AmIModerator"),
    moderatorCooldown = false,
    InDanger = false,
    Shiftlocked = false,
    Settings = GameManager:getSettings(u9),
    CurrentChakraPoint = nil,
    PlaceNameCounter = 1,
    SelectedLocation = "",
    Sliding = false,
    CurrentArea = "",
    currentLocation = "",
    ChakraFeet = false,
    ChakraFeetCooldown = false,
    Consuming = false,
    CanSwitch = true,
    HoldingSkill = false,
    HoldingSkillButton = "",
    jumpBlocked = false,
    Casting = "",
    idleAnim = false,
    runningIdleAnim = false,
    Vaulting = false,
    VaultingID = 1,
    fakeVaultActive = false,
    waterSpeed = 0,
    awakeningSpeed = 0,
    consumableSpeed = 0,
    KeyCooldown = false,
    ExtractionCooldown = false,
    scammed = false,
    chakraColor = nil,
    CurrentWeapon = u11.CurrentWeapon,
    WeaponEquipped = false,
    Selected = "",
    skillInUse = "",
    ToolAnimation = "",
    usedSingleSkillDash = false,
    weatherInc = 0,
    camerablock = Instance.new("Part"),
    camInWater = false,
    InDialog = false,
    optionCount = 1,
    NPCModule = {},
    CurrentQuest = "",
    dialogPart = nil,
    AccessoryCooldown = false,
    RamenContest = false,
    RamenContestRealStart = false,
    RamenCountStart = false,
    RamenEaten = 0,
    SpinningHumanBoulder = false,
    Carrying = false,
    CarryCooldown = false,
    Knocked = false,
    GripCooldown = false,
    ChargingChakra = false,
    WDash = false,
    BDash = false,
    LedgeClimbing = false,
    HoldingForward = 0,
    HoldingLeft = 0,
    HoldingRight = 0,
    HoldingBack = 0,
    Dashing = false,
    DashCooldown = false,
    canTreeJump = false,
    JumpCounters = 5,
    Jumped = false,
    Falling = false,
    FallingVar = false,
    jumpAmount = 0,
    Running = false,
    CanRun = true,
    CanSkillRun = false,
    OriginSpeed = GameManager.Settings.BaseSpeed * GameManager.Clothing[u11.Clothing].SpeedBoost * GameManager:unchainedSpeed(u11) * GameManager:chainedSpeed(u11),
    OriginJump = GameManager.Settings.BaseJump,
    canDoubleJump = false,
    hasDoubleJumped = false,
    canTripleJump = false,
    hasTripleJumped = false,
    oldPower = Humanoid.JumpPower,
    JumpInterval = 0.6,
    DoubleJumpMultiplier = 1.6,
    TripleJumpMultiplier = 1.6,
    CombatTable = {},
    Occupied = false,
    CombatCount = 0,
    MeleeCooldown = 0,
    CombatType = GameManager:getBaseCombat(u11),
    CombatLength = 5,
    ActionAnim = nil,
    OldActionAnim = nil,
    ActionTime = 0.13,
    TotalAnimTime = 0.4,
    Stunned = false,
    StunID = 0,
    Broken = false,
    Blocking = false,
    BlockCooldown = false,
    BlockStartCooldown = false,
    BlockTable = {}
};

local function getOriginSpeed() -- Line: 540
    -- upvalues: u9 (copy), GameManager (copy), u11 (ref)
    local v33 = 1;

    if u9:GetAttribute("Inspire") then
        v33 = v33 * (1 + u9:GetAttribute("Inspire") / 100);
    end;

    if u9:GetAttribute("Fear") then
        v33 = v33 * (1 - u9:GetAttribute("Fear") / 100);
    end;

    local v34 = GameManager.Settings.BaseSpeed * GameManager.Clothing[u11.Clothing].SpeedBoost * GameManager:unchainedSpeed(u11) * GameManager:chainedSpeed(u11) * v33;
    local v35 = GameManager:hasAilment(u9, "Ice");

    if v35 then
        if v35:GetAttribute("Yuki") then
            warn(GameManager.Ailments.Ice.SpeedMultiplierForYukis);

            return v34 * GameManager.Ailments.Ice.SpeedMultiplierForYukis;
        end;

        warn(GameManager.Ailments.Ice.SpeedMultiplier);
        v34 = v34 * GameManager.Ailments.Ice.SpeedMultiplier;
    end;

    return v34;
end;

if u32.Settings == false then
    while u32.Settings == false do
        u32.Settings = GameManager:getSettings(u9);
        wait(1);
    end;
end;

u1.TargetFilter = workspace.Debris;
local u36 = false;

if ReplicatedStorage.Loaded:FindFirstChild(LocalPlayer.Name) or u7 ~= "Main" then
    if u7 == "Arena" then
        HumanoidRootPart.CFrame = DataFunction:InvokeServer("LoadedIn");
    end;
else
    local u37;

    if halloween then
        u37 = ReplicatedStorage.HallowPlayerMenuModel:Clone();
    elseif xmas then
        u37 = ReplicatedStorage.SnowPlayerMenuModel:Clone();
    elseif valentine then
        u37 = ReplicatedStorage.ValentinePlayerMenuModel:Clone();
    else
        u37 = ReplicatedStorage.PlayerMenuModel:Clone();
    end;

    u37.Parent = workspace;
    math.randomseed(os.clock());
    local u38 = math.random(1, 3);
    HumanoidRootPart.CFrame = u37["PlayerBlock" .. u38].CFrame * CFrame.new(0, 4, 0);
    u32.EmotePosition = HumanoidRootPart.Position;

    if u38 == 1 then
        u32.CurrentEmote = "seated";
    elseif u38 == 2 then
        u32.CurrentEmote = "lean";
    elseif u38 == 3 then
        u32.CurrentEmote = "relax";
    end;

    GameManager:getAnimation(u32.CurrentEmote, Humanoid, Enum.AnimationPriority.Action3):Play();

    if ReplicatedStorage.DayState.Value == "Day" then
        u37.NightTorch1.Main.Smoke.Enabled = false;
        u37.NightTorch1.Main.TorchLight.Enabled = false;
        u37.NightTorch2.Main.Smoke.Enabled = false;
        u37.NightTorch2.Main.TorchLight.Enabled = false;
        u37.NightTorch3.Main.Smoke.Enabled = false;
        u37.NightTorch3.Main.TorchLight.Enabled = false;
        ReplicatedStorage.LocalSounds.ForestDay:Clone().Parent = u37["PlayerBlock" .. u38];
        u37["PlayerBlock" .. u38].ForestDay:Play();
    else
        u37.NightTorch1.Main.Smoke.Enabled = true;
        u37.NightTorch1.Main.TorchLight.Enabled = true;
        u37.NightTorch2.Main.Smoke.Enabled = true;
        u37.NightTorch2.Main.TorchLight.Enabled = true;
        u37.NightTorch3.Main.Smoke.Enabled = true;
        u37.NightTorch3.Main.TorchLight.Enabled = true;
        ReplicatedStorage.LocalSounds.ForestNight:Clone().Parent = u37["PlayerBlock" .. u38];
        u37["PlayerBlock" .. u38].ForestNight:Play();
    end;

    local v39 = nil;

    if not xmas and ReplicatedStorage.Raining.Value ~= "" then
        if ReplicatedStorage.Raining.Value == "ChakraTrue" then
            v39 = Color3.fromRGB(0, 179, 255);
            print("its is chakra raining");
        end;

        for _, child in ipairs(u37:GetChildren()) do
            if child.Name == "RainPart" then
                if snowing then
                    child.PE.Enabled = false;
                    child.SnowPE.Enabled = true;
                else
                    child.SnowPE.Enabled = false;
                    child.PE.Enabled = true;
                end;

                if v39 then
                    child.PE.Color = ColorSequence.new(v39, v39);
                end;
            end;
        end;

        u37["MainCam" .. u38].RainSound:Play();
    end;

    CurrentCamera.CameraType = "Scriptable";
    CurrentCamera.CameraSubject = nil;
    CurrentCamera.CFrame = u37["MainCam" .. u38].CFrame;
    local ForceField = u9:WaitForChild("ForceField");
    ForceField.Visible = false;
    Menu.Visible = true;
    Menu.Position = UDim2.new(0, -300, 1, -200);
    TweenService:Create(Menu, TweenInfo.new(1), {
        Position = UDim2.new(0, 0, 1, -200)
    }):Play();
    local u40 = false;

    if u11.PlayedBefore == false then
        Menu.Continue.Visible = false;
        Menu.NewGame.Visible = true;
        Menu.NewGame.ButtonText.Text = "Play";
    elseif u11.LifeForce == 0 then
        Menu.Continue.Visible = true;
        Menu.NewGame.Visible = false;
        Menu.Continue.Position = UDim2.new(0, 25, -0.33, 0);
    end;

    Menu.Continue.MouseEnter:Connect(function() -- Line: 682
        -- upvalues: u6 (ref), Menu (copy)
        u6.ButtonHover:Play();
        Menu.Continue.ButtonHover.Visible = true;
    end);
    Menu.Continue.MouseLeave:Connect(function() -- Line: 686
        -- upvalues: Menu (copy)
        Menu.Continue.ButtonHover.Visible = false;
    end);
    Menu.NewGame.MouseEnter:Connect(function() -- Line: 690
        -- upvalues: u6 (ref), Menu (copy)
        u6.ButtonHover:Play();
        Menu.NewGame.ButtonHover.Visible = true;
    end);
    Menu.NewGame.MouseLeave:Connect(function() -- Line: 694
        -- upvalues: Menu (copy)
        Menu.NewGame.ButtonHover.Visible = false;
    end);
    Menu.Controls.MouseEnter:Connect(function() -- Line: 698
        -- upvalues: u6 (ref), Menu (copy)
        u6.ButtonHover:Play();
        Menu.Controls.ButtonHover.Visible = true;
    end);
    Menu.Controls.MouseLeave:Connect(function() -- Line: 702
        -- upvalues: Menu (copy)
        Menu.Controls.ButtonHover.Visible = false;
    end);
    Menu.ServerList.MouseEnter:Connect(function() -- Line: 706
        -- upvalues: u6 (ref), Menu (copy)
        u6.ButtonHover:Play();
        Menu.ServerList.ButtonHover.Visible = true;
    end);
    Menu.ServerList.MouseLeave:Connect(function() -- Line: 710
        -- upvalues: Menu (copy)
        Menu.ServerList.ButtonHover.Visible = false;
    end);
    Menu.Codes.MouseEnter:Connect(function() -- Line: 714
        -- upvalues: u6 (ref), Menu (copy)
        u6.ButtonHover:Play();
        Menu.Codes.ButtonHover.Visible = true;
    end);
    Menu.Codes.MouseLeave:Connect(function() -- Line: 718
        -- upvalues: Menu (copy)
        Menu.Codes.ButtonHover.Visible = false;
    end);

    function LoadIntoGame(p41)
        -- upvalues: u40 (ref), MenuSelect (copy), ServerList2 (ref), u14 (ref), DataFunction (copy), ReplicatedStorage (copy), u37 (ref), u38 (copy), Debris (copy), GameManager (copy), u6 (ref), Rest (copy), MenuScreen (copy), ForceField (copy), CurrentCamera (copy), Humanoid (copy)
        if u40 == false then
            MenuSelect.Visible = false;
            ServerList2.Visible = false;
            u40 = true;

            if p41 then
                u14 = DataFunction:InvokeServer("LoadedIn");
            end;

            local v42 = ReplicatedStorage.Models.SubstitutionLog:Clone();
            v42.Position = (u37["PlayerBlock" .. u38].CFrame * CFrame.new(0, 5, 0)).p;
            Debris:AddItem(v42, 3);
            v42.Parent = workspace;
            v42.Sub:Play();
            local CFrame2 = v42.CFrame;
            local Angles = CFrame.Angles;
            local v43 = math.random(0, 90);
            local v44 = math.rad(v43);
            local v45 = math.random(0, 90);
            v42.CFrame = CFrame2 * Angles(v44, 0.7853981633974483, (math.rad(v45)));
            GameManager:playEffect(nil, { v42.Smoke }, 0.5, "Particle");
            GameManager:TweenObject(u6.MenuTrack, {
                Volume = 0
            }, 1);
            GameManager:TweenObject(u6.HallowMenuTrack, {
                Volume = 0
            }, 1);
            wait(1);
            ServerList2 = Rest.ServerList;
            MenuScreen.ServerList:Destroy();
            ServerList2.GuiHandler.Disabled = false;
            u6.MenuTrack:Stop();
            u6.HallowMenuTrack:Stop();
            TweenSlideScreen(0.5);
            wait(0.25);
            u40 = "Proceed";
            MenuScreen.Visible = false;
            Debris:AddItem(u37, 2);

            if ForceField then
                ForceField.Visible = true;
            end;

            CurrentCamera.CameraType = Enum.CameraType.Custom;
            CurrentCamera.CameraSubject = Humanoid;
        end;
    end;

    local function clearMenuSelect() -- Line: 761
        -- upvalues: MenuSelect (copy)
        MenuSelect.Controls.Visible = false;
        MenuSelect.Action.Visible = false;
        MenuSelect.EnterNumber.Visible = false;
        MenuSelect.Info.Text = "";
        MenuSelect.SecondaryInfo.Text = "";
    end;

    Menu.Continue.MouseButton1Down:Connect(function() -- Line: 770
        LoadIntoGame(true);
    end);
    Menu.Testing.MouseButton1Down:Connect(function() -- Line: 774
        -- upvalues: DataEvent (copy)
        DataEvent:FireServer("TestTeleport");
    end);
    Menu.NewGame.MouseButton1Down:Connect(function() -- Line: 778
        -- upvalues: u6 (ref), u11 (ref), MenuSelect (copy), ServerList2 (ref), MenuScreen (copy)
        u6.MainButtonClick:Play();

        if u11.PlayedBefore == false then
            LoadIntoGame(true);
        else
            MenuSelect.Controls.Visible = false;
            MenuSelect.Action.Visible = false;
            MenuSelect.EnterNumber.Visible = false;
            MenuSelect.Info.Text = "";
            MenuSelect.SecondaryInfo.Text = "";
            MenuSelect.Visible = true;
            ServerList2.Visible = false;
            MenuSelect.Action.Visible = true;
            MenuSelect.EnterNumber.Visible = true;
            MenuSelect.Action.Text = "Start New Game";
            MenuSelect.Info.RichText = true;
            MenuSelect.Info.Text = "Type <b>Yes</b> for confirmation";
            MenuSelect.SecondaryInfo.Text = "(Your lifeforce  will be reduced to 0)";
            MenuSelect.EnterNumber.Text = "";
        end;

        MenuScreen.CodesFrame.Visible = false;
    end);
    Menu.ServerList.MouseButton1Down:Connect(function() -- Line: 798
        -- upvalues: u6 (ref), MenuSelect (copy), ServerList2 (ref), MenuScreen (copy)
        u6.MainButtonClick:Play();
        MenuSelect.Controls.Visible = false;
        MenuSelect.Action.Visible = false;
        MenuSelect.EnterNumber.Visible = false;
        MenuSelect.Info.Text = "";
        MenuSelect.SecondaryInfo.Text = "";
        ServerList2.Visible = true;
        MenuSelect.Visible = false;
        MenuScreen.CodesFrame.Visible = false;
    end);
    Menu.Controls.MouseButton1Down:Connect(function() -- Line: 807
        -- upvalues: u6 (ref), MenuSelect (copy), ServerList2 (ref), MenuScreen (copy)
        u6.MainButtonClick:Play();
        MenuSelect.Visible = true;
        ServerList2.Visible = false;
        MenuSelect.Controls.Visible = false;
        MenuSelect.Action.Visible = false;
        MenuSelect.EnterNumber.Visible = false;
        MenuSelect.Info.Text = "";
        MenuSelect.SecondaryInfo.Text = "";
        MenuSelect.Controls.Visible = true;
        MenuScreen.CodesFrame.Visible = false;
    end);
    Menu.Codes.MouseButton1Down:Connect(function() -- Line: 817
        -- upvalues: u6 (ref), MenuScreen (copy), MenuSelect (copy), ServerList2 (ref)
        u6.MainButtonClick:Play();
        MenuScreen.CodesFrame.Visible = not MenuScreen.CodesFrame.Visible;
        MenuSelect.Visible = false;
        ServerList2.Visible = false;
        MenuSelect.Controls.Visible = false;
        MenuSelect.Action.Visible = false;
        MenuSelect.EnterNumber.Visible = false;
        MenuSelect.Info.Text = "";
        MenuSelect.SecondaryInfo.Text = "";
    end);
    MenuScreen.CodesFrame.Claim.MouseButton1Down:Connect(function() -- Line: 827
        -- upvalues: u6 (ref), MenuScreen (copy), DataFunction (copy)
        u6.MainButtonClick:Play();
        local v46 = DataFunction:InvokeServer("CheckInviteCode", MenuScreen.CodesFrame.TextBox.Text);
        MenuScreen.CodesFrame.TextBox.Text = "";
        MenuScreen.CodesFrame.TextBox.PlaceholderText = v46 or "INVALID CODE!";
        task.delay(1.5, function() -- Line: 835
            -- upvalues: MenuScreen (ref)
            MenuScreen.CodesFrame.TextBox.PlaceholderText = "Enter Code";
        end);
    end);
    MenuScreen.CodesFrame.Code.Text = u11.MyInviteCode;
    MenuSelect.Action.MouseButton1Down:Connect(function() -- Line: 842
        -- upvalues: MenuSelect (copy), u11 (ref), u6 (ref), u36 (ref), DataEvent (copy)
        if MenuSelect.Action.Text ~= "Start New Game" or u11.LifeForce == 0 then
            return;
        end;

        u6.MainButtonClick:Play();

        if MenuSelect.EnterNumber.Text ~= "Yes" or u36 ~= false then
            MenuSelect.SecondaryInfo.Text = "Please Type Yes to continue";

            return;
        end;

        u36 = true;
        DataEvent:FireServer("NewGame");
        u11.LifeForce = 0;
        LoadIntoGame();
    end);

    repeat
        wait();
    until u40 == "Proceed";
end;

Loadout.Visible = true;
Ryo.Visible = true;
Acumen.Visible = true;
Embers.Visible = u11.Embers > 0;
PlayerList.Visible = true;
local Part = Instance.new("Part");
Part.Name = "RainBlock";
Part.Parent = u9;
Part.Transparency = 1;
Part.CanCollide = false;
Part.Anchored = true;
Part.Position = HumanoidRootPart.Position;
Part.Size = Vector3.new(0.05, 0.05, 0.05);
Part.Massless = true;

if not u11 then
    local v47 = 0;

    while v47 < 10 do
        v47 = v47 + 1;
        wait(1);
        u11 = DataFunction:InvokeServer("GetData");
        print("ATTEMPTING TO LOAD DATA | TRIES = " .. v47);
    end;

    if v47 >= 10 then
        print("FAILED TO LOAD DATA");
    else
        print("LOADED DATA");
    end;
end;

local u48 = {
    Run = GameManager:getAnimation("Run", Humanoid),
    Swimming = GameManager:getAnimation("Swimming", Humanoid),
    Sleep = GameManager:getAnimation("Sleep", Humanoid)
};
local u49 = {
    ["1"] = Enum.KeyCode.One,
    ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,
    ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven,
    ["8"] = Enum.KeyCode.Eight,
    ["9"] = Enum.KeyCode.Nine,
    ["0"] = Enum.KeyCode.Zero,
    ["-"] = Enum.KeyCode.Minus,
    ["="] = Enum.KeyCode.Equals,
    Run = Enum.KeyCode.W,
    Block = Enum.KeyCode.F
};

if UserInputService.GamepadEnabled then
    u49.Run = Enum.KeyCode.ButtonR3;
    u49.Block = Enum.KeyCode.ButtonL2;
end;

local function getKey(p50) -- Line: 1046
    -- upvalues: u49 (copy)
    if u49[p50] then
        return u49[p50];
    end;

    if tostring(p50) == p50 then
        return Enum.KeyCode[p50:upper()];
    end;
end;

local Model = Instance.new("Model");
Model.Name = "RainParts";
Model.Parent = workspace;
u32.camerablock.Parent = workspace;
u32.camerablock.Transparency = 1;
u32.camerablock.CanCollide = false;
u32.camerablock.Anchored = true;
u32.camerablock.CanTouch = true;
u32.camerablock.Size = Vector3.new(1, 1, 1);
u32.camerablock.CFrame = CurrentCamera.CFrame;
SHARKTRANSFORMATION_WATER_RUN_SPEED_BONUS = 8;
ISOBUCLOAK_WATER_RUN_SPEED_BONUS = 1;
ISOBUDOMAIN_WATER_RUN_SPEED_BONUS = 5;
HOSHIGAKI_WATERSPEED = 5;

local function setRunSpeed(p51) -- Line: 1073
    -- upvalues: u9 (copy), Humanoid (copy), u32 (copy), ReplicatedStorage (copy), LocalPlayer (copy), u11 (ref)
    if u9:GetAttribute("FlickerStep") then
        return;
    end;

    if p51 then
        Humanoid.WalkSpeed = u32.OriginSpeed;

        return;
    end;

    if ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Earth") then
        Humanoid.WalkSpeed = u32.OriginSpeed + 12;
    else
        Humanoid.WalkSpeed = u32.OriginSpeed + 12 + u32.awakeningSpeed + u32.consumableSpeed;
    end;

    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        Humanoid.WalkSpeed = Humanoid.WalkSpeed + u32.waterSpeed;

        if u32.Settings.Awakened.Value == "Shark Transformation" then
            local v52 = Humanoid;
            v52.WalkSpeed = v52.WalkSpeed + SHARKTRANSFORMATION_WATER_RUN_SPEED_BONUS;
        elseif u32.Settings.Awakened.Value == "Isobu Cloak" then
            local v53 = Humanoid;
            v53.WalkSpeed = v53.WalkSpeed + ISOBUCLOAK_WATER_RUN_SPEED_BONUS;

            if u32.currentLocation == "Isobu\'s Belly" then
                local v54 = Humanoid;
                v54.WalkSpeed = v54.WalkSpeed + ISOBUDOMAIN_WATER_RUN_SPEED_BONUS;
            end;
        end;

        if u11.Bloodline ~= "Hoshigaki" and u32.Settings.Awakened.Value ~= "Isobu Cloak" then
            local v55 = Humanoid;
            v55.WalkSpeed = v55.WalkSpeed - 3;
        end;
    end;
end;

for _, child in ipairs(workspace.WaterBlocks:GetChildren()) do
    child.CanTouch = true;
end;

local u56 = {};
local u57 = {};
local Cooldowns = ReplicatedStorage.Cooldowns;
local u58 = {
    CinematicMode = "Off",
    FakeCinematic = "Off",
    ItemDisplayChoice = SettingsFrame:WaitForChild("ItemDisplayChoice"),
    ItemDisplayRight = SettingsFrame:WaitForChild("ItemDisplayRight"),
    ItemDisplayLeft = SettingsFrame:WaitForChild("ItemDisplayLeft"),
    GraphicsLevelChoice = SettingsFrame:WaitForChild("GraphicsLevelChoice"),
    GraphicsLevelRight = SettingsFrame:WaitForChild("GraphicsLevelRight"),
    GraphicsLevelLeft = SettingsFrame:WaitForChild("GraphicsLevelLeft"),
    CinematicModeChoice = SettingsFrame:WaitForChild("CinematicModeChoice"),
    CinematicModeRight = SettingsFrame:WaitForChild("CinematicModeRight"),
    CinematicModeLeft = SettingsFrame:WaitForChild("CinematicModeLeft"),
    FOVChoice = SettingsFrame:WaitForChild("FOVChoice"),
    FOVRight = SettingsFrame:WaitForChild("FOVRight"),
    FOVLeft = SettingsFrame:WaitForChild("FOVLeft"),
    VisibleCooldownsChoice = SettingsFrame:WaitForChild("VisibleCooldownsChoice"),
    VisibleCooldownsRight = SettingsFrame:WaitForChild("VisibleCooldownsRight"),
    VisibleCooldownsLeft = SettingsFrame:WaitForChild("VisibleCooldownsLeft"),
    FootstepsChoice = SettingsFrame:WaitForChild("FootstepsChoice"),
    FootstepsRight = SettingsFrame:WaitForChild("FootstepsRight"),
    FootstepsLeft = SettingsFrame:WaitForChild("FootstepsLeft"),
    InstantCastChoice = SettingsFrame:WaitForChild("InstantCastChoice"),
    InstantCastRight = SettingsFrame:WaitForChild("InstantCastRight"),
    InstantCastLeft = SettingsFrame:WaitForChild("InstantCastLeft"),
    TiltChoice = SettingsFrame:WaitForChild("TiltChoice"),
    TiltRight = SettingsFrame:WaitForChild("TiltRight"),
    TiltLeft = SettingsFrame:WaitForChild("TiltLeft"),
    HighQRainChoice = SettingsFrame:WaitForChild("HighQRainChoice"),
    HighQRainRight = SettingsFrame:WaitForChild("HighQRainRight"),
    HighQRainLeft = SettingsFrame:WaitForChild("HighQRainLeft"),
    KeybindsButton = SettingsFrame:WaitForChild("Keybinds"),
    SettingsReturn = SettingsFrame:WaitForChild("SettingsReturn"),
    KeybindsFrame = SettingsFrame:WaitForChild("KeybindsFrame")
};

if u11 then
    HumanoidRootPart.Anchored = false;
    Humanoid.JumpPower = u32.OriginJump;
    Humanoid.WalkSpeed = u32.OriginSpeed;
    DataEvent:FireServer("LoadedIn");
else
    print("Data was not fetched");
end;

GameManager:loadAnimations(Humanoid);
Mainframe:WaitForChild("Ryo"):WaitForChild("Amount").Text = u11.Ryo;
Mainframe:WaitForChild("Acumen"):WaitForChild("Amount").Text = u11.Acumen;
Mainframe:WaitForChild("Embers"):WaitForChild("Amount").Text = u11.Embers;
HUD:WaitForChild("PlayerName").Text = u11.Name;
HUD:WaitForChild("PlayerTitle").Text = u11.Title;
HUD:WaitForChild("LifeForce"):WaitForChild("Value").Value = u11.LifeForce;
RightFrame.Age.Text = "Age : " .. u11.Age;
RightFrame.Bloodline.Text = "Bloodline : " .. u11.Bloodline;
RightFrame.Sins.Text = "Sins : " .. u11.Sins;
RightFrame.ChakraLink.Text = "Chakra Link : " .. u11.ChakraShardsGiven / GameManager:getMaxShards(u11) * 100 .. "%";

if u11.ChakraColor_R ~= false then
    u32.chakraColor = Color3.new(u11.ChakraColor_R, u11.ChakraColor_G, u11.ChakraColor_B);

    for _, child in ipairs(HumanoidRootPart.ChakraJumpVFXAttachment:GetChildren()) do
        child.Color = ColorSequence.new(u32.chakraColor, u32.chakraColor);
    end;
end;

local function updateTitles() -- Line: 1206
    -- upvalues: TitlesFrame (copy), u11 (ref), DataEvent (copy), u6 (ref), updateTitles (copy)
    for _, child in TitlesFrame.ScrollingFrame:GetChildren() do
        if not child:IsA("UIListLayout") then
            child:Destroy();
        end;
    end;

    for _, v in u11.Titles do
        local u59 = TitlesFrame.TitleTemplate:Clone();
        u59.Visible = true;
        u59.TitleName.Text = v;

        if v == u11.Title then
            u59.ImageTransparency = 0;
        end;

        u59.Parent = TitlesFrame.ScrollingFrame;
        u59.MouseButton1Down:Connect(function() -- Line: 1223
            -- upvalues: u59 (copy), DataEvent (ref), u11 (ref), u6 (ref), updateTitles (ref)
            if u59.TitleName.Text ~= "" then
                DataEvent:FireServer("EquipTitle", u59.TitleName.Text);

                if u59.TitleName.Text == "No Title" then
                    u11.Title = "";
                else
                    u11.Title = u59.TitleName.Text;
                end;

                u6.ButtonSelect:Play();
                updateTitles();
            end;
        end);
    end;
end;

if u11.Titles == {} then
    TitlesFrame.NoTitles.Visible = true;
else
    updateTitles();
end;

local u60 = workspace.Debris:FindFirstChild("InvertedSphere") or ReplicatedStorage.Models.InvertedSphere:Clone();
u60.Parent = workspace.Debris;
u60.Anchored = true;

local function updateLocation(p61, p62) -- Line: 1251
    -- upvalues: u32 (copy), GameManager (copy), u9 (copy), TweenService (copy), u6 (ref), ReplicatedStorage (copy), u60 (copy), HumanoidRootPart (copy)
    u32.currentLocation = p61;
    local FogColor = GameManager.Locations[p61].FogColor;
    local v63 = TweenInfo.new(p62 and 0 or 2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0);
    local v64 = (u9:FindFirstChild("Sandstorm") or u9:FindFirstChild("Snowstorm")) and 200 or GameManager.Locations[p61].FogEnd;

    if u9:GetAttribute("IceUltimate") then
        v64 = math.max(v64, 1000);
    end;

    local v65 = {
        FogStart = GameManager.Locations[p61].FogStart,
        FogEnd = v64,
        FogColor = FogColor,
        Ambient = GameManager.Locations[p61].Ambient,
        OutdoorAmbient = GameManager.Locations[p61].OutdoorAmbient
    };

    if v65.FogColor == Color3.new(0, 0.35294117647058826, 0.2627450980392157) then
        if halloween then
            v65.FogColor = Color3.fromRGB(90, 51, 12);
        elseif xmas then
            v65.FogColor = Color3.fromRGB(220, 220, 220);
        elseif valentine then
            v65.FogColor = Color3.fromRGB(72, 25, 62);
        end;
    end;

    TweenService:Create(game.Lighting, v63, v65):Play();
    GameManager:stopBackgroundSound(u6);
    u6[GameManager.Locations[p61][ReplicatedStorage.DayState.Value .. "Sound"]]:Play();
    u60.Anchored = true;
    u60.Position = HumanoidRootPart.Position;
    local v66 = p62 and 0 or 3;

    if GameManager.Locations[p61].SphereSize then
        TweenService:Create(u60, TweenInfo.new(v66), {
            Transparency = 0,
            Color = FogColor,
            Size = Vector3.new(GameManager.Locations[p61].FogEnd * 2, GameManager.Locations[p61].FogEnd * 2, GameManager.Locations[p61].FogEnd * 2)
        }):Play();
    else
        TweenService:Create(u60, TweenInfo.new(v66), {
            Transparency = 1
        }):Play();
    end;

    if GameManager.Locations[p61].Blur and GameManager.Locations[p61].Blur ~= game.Lighting.WorldBlur.Size then
        TweenService:Create(game.Lighting.WorldBlur, TweenInfo.new(2), {
            Size = GameManager.Locations[p61].Blur
        }):Play();
    elseif not GameManager.Locations[p61].Blur and game.Lighting.WorldBlur.Size ~= 0 then
        TweenService:Create(game.Lighting.WorldBlur, TweenInfo.new(2), {
            Size = 0
        }):Play();
    end;

    if not GameManager.Locations[p61] then
        return;
    end;

    if GameManager.Locations[p61].PermanentRain then
        toggleSnow(false);
        updateWeather("True");

        return;
    end;

    if GameManager.Locations[p61].RainingDisabled then
        toggleSnow(false);
        updateWeather("");

        return;
    end;

    if GameManager.Locations[p61].PermanentSnow then
        toggleSnow(true);

        return;
    end;

    toggleSnow(false);
    updateWeather(ReplicatedStorage.Raining.Value);
end;

ReplicatedStorage.DayState.Changed:Connect(function(p67) -- Line: 1325
    -- upvalues: GameManager (copy), u32 (copy), u6 (ref)
    if GameManager.Locations[u32.CurrentArea] and GameManager.Locations[u32.CurrentArea].DaySound ~= GameManager.Locations[u32.CurrentArea].NightSound then
        GameManager:stopBackgroundSound(u6);
        u6[GameManager.Locations[u32.CurrentArea][p67 .. "Sound"]]:Play();
    end;
end);
snowing = false;

if GameManager.Locations[u32.currentLocation] and GameManager.Locations.PermanentSnow then
    snowing = true;
end;

function updateWeather(p68)
    -- upvalues: u32 (copy), GameManager (copy), u11 (ref), u9 (copy), Part (copy), Model (copy), u6 (ref), ReplicatedStorage (copy)
    local currentLocation = u32.currentLocation;
    local v69 = p68 == "True" and true or p68 == "ChakraTrue";

    if GameManager.Locations[currentLocation] then
        if GameManager.Locations[currentLocation].RainingDisabled then
            v69 = false;
        end;

        v69 = GameManager.Locations[currentLocation].PermanentRain and true or v69;
    end;

    if v69 and not snowing then
        if u11.HighQRain == "Off" then
            print("starting low qual rain");
            GameManager:weather(u9, "StartRain", Part, "LowQuality", Model);
        else
            print("starting normal rain");
            GameManager:weather(u9, "StartRain", Part, nil, Model);
        end;

        if xmas == false then
            u6.RainSound.Volume = 0;
            u6.RainSound:Play();
            GameManager:TweenObject(u6.RainSound, {
                Volume = ReplicatedStorage.LocalSounds.RainSound.Volume
            }, 1);
        end;
    elseif p68 == "" and not snowing then
        GameManager:weather(u9, "Stop", nil, nil, Model);
        GameManager:TweenObject(u6.RainSound, {
            Volume = 0
        }, 1);
    end;
end;

ReplicatedStorage.Raining.Changed:Connect(function(p70) -- Line: 1373
    updateWeather(p70);
end);
updateWeather(ReplicatedStorage.Raining.Value);

function toggleSnow(p71)
    -- upvalues: u32 (copy), u3 (copy), u11 (ref), GameManager (copy), u9 (copy), Part (copy), Model (copy), u6 (ref), ReplicatedStorage (copy)
    snowing = p71;

    if not p71 then
        print("Snow stopped - checking if rain should resume");
        GameManager:weather(u9, "Stop", nil, nil, Model);
        GameManager:TweenObject(u6.RainSound, {
            Volume = 0
        }, 1);

        if ReplicatedStorage.Raining.Value == "True" or ReplicatedStorage.Raining.Value == "ChakraTrue" then
            updateWeather(ReplicatedStorage.Raining.Value);
        end;

        return;
    end;

    print("Snow started - disabling rain");
    u32.actualRainAbove = false;
    u3.RainAboveUpdated:Fire();

    if u11.HighQRain == "Off" then
        GameManager:weather(u9, "StartRain", Part, "LowQuality", Model, true);
    else
        GameManager:weather(u9, "StartRain", Part, nil, Model, true);
    end;

    u6.RainSound:Stop();
    GameManager:TweenObject(u6.RainSound, {
        Volume = ReplicatedStorage.LocalSounds.RainSound.Volume
    }, 0);
end;

local success, result = pcall(function() -- Line: 1414
    -- upvalues: updateLocation (copy), u11 (ref)
    updateLocation(u11.Location);
end);

if not success then
    warn(result);
end;

local function updatePlayerList() -- Line: 1423
    -- upvalues: DataFunction (copy), PlayerList (copy), GameManager (copy), u32 (copy), ModPanel (copy), DataEvent (copy)
    local v72 = DataFunction:InvokeServer("GetPlayerList");

    for _, child in PlayerList.List:GetChildren() do
        if child:IsA("ImageButton") then
            child:Destroy();
        elseif child:IsA("Frame") then
            child.Visible = false;
        end;
    end;

    local v73 = {};

    for _, v in v72 do
        if not v73[v.Village] then
            v73[v.Village] = true;
        end;
    end;

    for i, _ in v73 do
        PlayerList.List[i].Visible = true;
    end;

    local v74 = {};

    for _, v in v72 do
        if not v74[v.Village] then
            v74[v.Village] = {};
        end;

        table.insert(v74[v.Village], v);
    end;

    for i, v in v74 do
        local u75 = {};

        for i2, v2 in GameManager.SortedRanks[i] do
            u75[v2] = i2;
        end;

        table.sort(v, function(p76, p77) -- Line: 1464
            -- upvalues: u75 (copy)
            return (u75[p76.Rank] or 0) > (u75[p77.Rank] or 0);
        end);
    end;

    for i, v in v74 do
        for i2, v2 in v do
            local u78 = PlayerList.PlayerTemplate:Clone();
            u78.Visible = true;
            u78.PlayerName.Text = v2.GameName;
            u78.Rank.Text = v2.Rank and ("- " .. v2.Rank .. " -" or "") or "";
            u78.Rank.Visible = u78.Rank.Text ~= "";

            if v2.Title ~= "" then
                if v2.Title:sub(1, 6) == "of the" then
                    u78.PlayerName.Text = v2.GameName .. " " .. v2.Title;
                else
                    u78.PlayerName.Text = v2.GameName .. ", " .. v2.Title;
                end;
            end;

            u78.LayoutOrder = PlayerList.List[i].LayoutOrder + i2 + (i2 - 1) * 2;

            if i2 == #v then
                u78.Image = "rbxassetid://" .. GameManager.UI.BottomFrame;
            else
                local v79 = PlayerList.LineTemplate:Clone();
                v79.Visible = true;
                v79.LayoutOrder = u78.LayoutOrder + 1;
                v79.Parent = PlayerList.List;
            end;

            u78.Parent = PlayerList.List;
            u78.MouseEnter:connect(function() -- Line: 1504
                -- upvalues: u78 (copy), v2 (copy)
                u78.PlayerName.Text = v2.RealName;
            end);
            u78.MouseLeave:connect(function() -- Line: 1507
                -- upvalues: u78 (copy), v2 (copy), u78 (copy)
                u78.PlayerName.Text = v2.GameName;

                if v2.Title ~= "" then
                    if v2.Title:sub(1, 6) == "of the" then
                        u78.PlayerName.Text = v2.GameName .. " " .. v2.Title;

                        return;
                    end;

                    u78.PlayerName.Text = v2.GameName .. ", " .. v2.Title;
                end;
            end);
            u78.MouseButton1Down:Connect(function() -- Line: 1519
                -- upvalues: v2 (copy), u32 (ref), ModPanel (ref), DataEvent (ref)
                print("trying to view" .. v2.ID);

                if u32.Settings.CurrentSkill.Value == "Chakra Sense" or u32.moderator and ModPanel.ScrollCommands.Observe.TextStrokeTransparency == 0 then
                    DataEvent:FireServer("observe", v2.ID);
                end;
            end);
        end;
    end;

    local function hasHigherPriorityElement(p80) -- Line: 1529
        -- upvalues: PlayerList (ref)
        for _, child in PlayerList.List:GetChildren() do
            if not child:IsA("UIListLayout") and (not child:IsA("Frame") or child.Visible) and (child ~= p80 and child.LayoutOrder > p80.LayoutOrder) then
                return true;
            end;
        end;
    end;

    for _, child in PlayerList.List:GetChildren() do
        if child:IsA("ImageButton") and (child.Image == "rbxassetid://" .. GameManager.UI.BottomFrame and hasHigherPriorityElement(child)) then
            child.Image = "rbxassetid://" .. GameManager.UI.MiddleFrame;
        end;
    end;
end;

skillsModule = {};
Lines = SkillsFrame:WaitForChild("Lines");

local function updateSkills() -- Line: 1553
    -- upvalues: DataFunction (copy), u11 (ref), SkillsFrame (copy), GameManager (copy)
    local v81, v82, v83 = DataFunction:InvokeServer("getSkillInformation");
    skillsModule = v81;

    for i, v in next, v82 do
        local v84 = Lines.cloneLine:Clone();
        v84.Name = i;

        if Lines:FindFirstChild(i) then
            v84 = Lines:FindFirstChild(i);
        end;

        v84.Parent = Lines;
        v84.Rotation = v.Rotation;
        v84.Position = v.Position;
        v84.Size = v.Size;
        v84.Line.Value = v.MainSkill;
        v84.BackgroundColor3 = v.Color;
        v84.Name = i;
        v84.Visible = v.Visible;
    end;

    u11 = v83;

    for i, v in next, skillsModule do
        if v.GUIName and v.GUIName ~= "" then
            local v85 = SkillsFrame[v.GUIName];
            v85.Visible = true;
            v85.SlotText.Text = i;

            if GameManager:hasSkill(u11, i) then
                v85.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.SelectedBorder;
            elseif GameManager:isSkillBlocked(u11, i) then
                v85.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.LockedBorder;
            else
                v85.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.StandardBorder;
            end;

            if v.ID == "" then
                v85.SlotText.TextTransparency = 0;
            else
                v85.Image = "rbxassetid://" .. v.ID;
                v85.SlotText.TextTransparency = 1;
            end;
        end;
    end;
end;

updateSkills();

local function selectedLocation(p86) -- Line: 1599
    -- upvalues: TravelFrame (copy), u32 (copy), u6 (ref), GameManager (copy)
    for _, child in TravelFrame.Locations:GetChildren() do
        if child:FindFirstChild("LocationSelect") then
            child.LocationSelect.Visible = false;
        end;
    end;

    if p86.TextLabel.Text ~= "" and u32.ChangingPage == false then
        u6.ButtonSelect:Play();
        p86.LocationSelect.Visible = true;
        TravelFrame.Travel.Visible = true;
        TravelFrame.LocationImage.Image = "rbxassetid://" .. GameManager.TeleportLocations[p86.TextLabel.Text].ID;
        u32.SelectedLocation = p86.TextLabel.Text;
    end;
end;

function isPointDestroyed(p87)
    -- upvalues: u11 (ref), GameManager (copy)
    return u11.DestroyedChakraPoints and GameManager:searchInList(u11.DestroyedChakraPoints, p87) and true or false;
end;

local function updateTeleportLocations() -- Line: 1622
    -- upvalues: TravelFrame (copy), GameManager (copy), u11 (ref), selectedLocation (copy)
    for _, child in TravelFrame.Locations:GetChildren() do
        if not child:IsA("UIListLayout") then
            child:Destroy();
        end;
    end;

    for i, v in GameManager.TeleportLocations do
        if u11.ChakraPoints and (GameManager:searchInList(u11.ChakraPoints, i) and not GameManager:searchInList(u11.DestroyedChakraPoints, i)) then
            local u88 = TravelFrame.Template:Clone();
            u88.TextLabel.Text = i;
            u88.Visible = true;
            u88.LayoutOrder = v.OrderNumber;
            u88.Parent = TravelFrame.Locations;
            u88.MouseButton1Down:Connect(function() -- Line: 1636
                -- upvalues: selectedLocation (ref), u88 (copy)
                selectedLocation(u88);
            end);
        end;
    end;
end;

local function slotItemAction(p89, p90, p91) -- Line: 1644
    -- upvalues: u32 (copy), DataEvent (copy), GameManager (copy), Humanoid (copy), u11 (ref), u9 (copy), Inventory (copy), Loadout (copy), DataFunction (copy)
    if p90 ~= "" and (u32.Settings.CurrentSkill.Value ~= "" and (skillsModule[u32.Settings.CurrentSkill.Value] and (skillsModule[u32.Settings.CurrentSkill.Value].CanDeactivate == true and (u32.skillInUse == u32.Settings.CurrentSkill.Value and (u32.Casting == false and u32.Settings.CurrentSkill.Value == "Chakra Sense"))))) then
        DataEvent:FireServer("DeactivateSkill");
    end;

    local v92 = GameManager.Items[p90] and GameManager.Items[p90].Weapon and "Weapon" or (GameManager.Items[p90] and GameManager.Items[p90].Type == "Accessory" and "Accessory" or (GameManager.Items[p90] and GameManager.Items[p90].Type == "Ring" and "Ring" or (GameManager.Items[p90] and "Random" or (skillsModule[p90] and skillsModule[p90].RequiresWeapon and "WeaponbySkill" or nil))));

    if u32.ToolAnimation ~= "" then
        GameManager:stopAnimation(u32.ToolAnimation, Humanoid);
        print("stopped previous tool animation");
    end;

    if p89 == "Selected" then
        u32.Selected = p90;

        if v92 == "Weapon" or v92 == "WeaponbySkill" then
            if not (skillsModule[p90] and GameManager:inBaseCombat(skillsModule[p90].RequiresWeapon)) then
                if v92 == "WeaponbySkill" then
                    u32.CombatType = skillsModule[p90].RequiresWeapon[1];
                else
                    u32.CombatType = GameManager.Items[p90].CombatType;
                end;

                u32.CombatTable = GameManager:getCombatTable(u32.CombatType);
            end;

            if u32.WeaponEquipped == false then
                if u32.CombatTable.UnsheatheAnimation then
                    GameManager:getAnimation(u32.CombatTable.UnsheatheAnimation, Humanoid):Play();
                end;

                if u32.CombatTable.Idle then
                    if u32.idleAnim then
                        u32.idleAnim:Stop();
                    end;

                    if u32.runningIdleAnim then
                        u32.runningIdleAnim:Stop();
                    end;

                    if u32.Running == true and (u32.CombatTable.RunningIdle and (u11.Bloodline ~= "Otsutsuki" or not u9:GetAttribute("otsuAnimations"))) then
                        u32.runningIdleAnim = GameManager:getAnimation(u32.CombatTable.RunningIdle, Humanoid);
                        u32.runningIdleAnim:Play();
                    else
                        u32.idleAnim = GameManager:getAnimation(u32.CombatTable.Idle, Humanoid);
                        u32.idleAnim:Play();
                    end;
                end;

                u32.WeaponEquipped = true;
            end;
        elseif u32.WeaponEquipped == true and (v92 ~= "Weapon" and v92 ~= "WeaponbySkill") then
            DataEvent:FireServer("Item", "Unselected", u32.CurrentWeapon);

            if u32.CombatTable.Idle then
                GameManager:stopAnimation(u32.CombatTable.Idle, Humanoid);
            end;

            if u32.CombatTable.RunningIdle then
                GameManager:stopAnimation(u32.CombatTable.RunningIdle, Humanoid);
            end;

            u32.CombatType = GameManager:getBaseCombat(u11, u32.Settings);
            u32.CombatTable = GameManager:getCombatTable(u32.CombatType);
            u32.WeaponEquipped = false;
        end;

        if v92 == "Random" then
            GameManager:getAnimation(GameManager.Items[p90].HoldingAnimation, Humanoid):Play();
            u32.ToolAnimation = GameManager.Items[p90].HoldingAnimation;
        elseif v92 == "Accessory" then
            print("Data[WearingAccessory] is " .. u11.WearingAccessory .. " | itemName is " .. p90);

            if u11.WearingAccessory == p90 or u11.WearingAccessory2 == p90 then
                GameManager:stopAnimation(u32.ToolAnimation, Humanoid);
                u32.ToolAnimation = "";
            else
                GameManager:getAnimation(GameManager.Items[p90].HoldingAnimation, Humanoid):Play();
                u32.ToolAnimation = GameManager.Items[p90].HoldingAnimation;
            end;
        elseif v92 == "Ring" then
            if u11.Ring == p90 then
                GameManager:stopAnimation(u32.ToolAnimation, Humanoid);
                u32.ToolAnimation = "";
            else
                GameManager:getAnimation(GameManager.Items[p90].HoldingAnimation, Humanoid):Play();
                u32.ToolAnimation = GameManager.Items[p90].HoldingAnimation;
            end;
        end;

        if Inventory.Visible == true then
            Loadout.RightFrame.ItemName.Text = p90;

            if GameManager.Items[p90] and GameManager.Items[p90].Description then
                Loadout.RightFrame.ItemDescription.Text = "<i>" .. GameManager.Items[p90].Description .. "</i>";
            elseif skillsModule[p90] and skillsModule[p90].Description then
                Loadout.RightFrame.ItemDescription.Text = "<i>" .. skillsModule[p90].Description .. "</i>";
            end;
        end;
    elseif p89 == "Unselected" and u32.Selected == p90 then
        u32.Selected = "";
        u32.skillInUse = "";

        if u32.WeaponEquipped == true and (u32.Settings.Blocking.Value == true and u32.Settings.Stunned.Value == false) then
            u32.Occupied = false;
            Humanoid.WalkSpeed = u32.OriginSpeed;
            Humanoid.JumpPower = u32.OriginJump;
            u32.BlockCooldown = true;

            if DataFunction:InvokeServer("EndBlock") then
                Humanoid.WalkSpeed = u32.OriginSpeed;
                Humanoid.JumpPower = u32.OriginJump;
            end;

            if u32.Settings.Blocking.Value == true and u32.Settings.Stunned.Value == false then
                wait(GameManager.Settings.BlockCooldown);
            end;

            u32.BlockCooldown = false;
        end;

        if u32.WeaponEquipped == true and (v92 == "Weapon" or v92 == "WeaponbySkill") then
            if u32.CombatTable.SheatheAnimation then
                GameManager:getAnimation(u32.CombatTable.SheatheAnimation, Humanoid):Play();
            end;

            if u32.idleAnim then
                u32.idleAnim:Stop();
                u32.idleAnim = nil;
            end;

            if u32.runningIdleAnim then
                u32.runningIdleAnim:Stop();
                u32.runningIdleAnim = nil;
            end;

            if u32.CombatTable.Idle then
                GameManager:stopAnimation(u32.CombatTable.Idle, Humanoid);
            end;

            if u32.CombatTable.RunningIdle then
                GameManager:stopAnimation(u32.CombatTable.RunningIdle, Humanoid);
            end;

            u32.CombatType = GameManager:getBaseCombat(u11, u32.Settings);
            u32.CombatTable = GameManager:getCombatTable(u32.CombatType);
            u32.WeaponEquipped = false;

            if v92 ~= "Weapon" and not p91 then
                DataEvent:FireServer("Item", "Unselected", u32.CurrentWeapon);
            end;
        else
            GameManager:stopAnimation(u32.ToolAnimation, Humanoid);
            u32.ToolAnimation = "";
        end;
    end;

    DataEvent:FireServer("Item", p89, p90);
end;

local function changeSlotSize(p93, p94) -- Line: 1820
    -- upvalues: u32 (copy), GameManager (copy), slotItemAction (copy), Loadout (copy)
    if u32.EnlargedSlot ~= 0 then
        u32.EnlargedSlot:TweenSize(u32.PreviousSlotSize, "Out", "Quad", GameManager.Settings.SlotTweenTime, true);
        u32.EnlargedSlot.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.StandardBorder;
        u32.SelectedSlot = "";
        u32.EnlargedSlot = 0;
    end;

    if p94 ~= "Enlargen" then
        slotItemAction("Unselected", p93.SlotText.Text);

        return;
    end;

    slotItemAction("Selected", p93.SlotText.Text);

    if p93.Parent == Loadout then
        u32.PreviousSlotSize = UDim2.new(0.09, 0, 1, 0);
    else
        u32.PreviousSlotSize = UDim2.new(0.12, 0, 0.055, 0);
    end;

    u32.PreviousSlotPosition = p93.Position;
    u32.EnlargedSlot = p93;
    u32.EnlargedSlot.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.SelectedBorder;

    if p93.Parent == Loadout then
        p93:TweenSize(UDim2.new(p93.Size.X.Scale * 1.12, 0, p93.Size.Y.Scale * 1.12, 0), "Out", "Quad", GameManager.Settings.SlotTweenTime, true);

        return;
    end;

    p93:TweenSize(UDim2.new(p93.Size.X.Scale * 1.12, 0, p93.Size.Y.Scale * 1.12, 0), "Out", "Quad", GameManager.Settings.SlotTweenTime, true);
end;

local function HideInventorySlots() -- Line: 1847
    -- upvalues: InventoryScroll (copy)
    for _, child in ipairs(InventoryScroll:GetChildren()) do
        if string.match(child.Name, "Slot") == "Slot" then
            child.Visible = false;
            child.SlotText.Visible = false;
            child.SlotText.Text = "";
            child.Image = "";
            child.SlotBorder.Visible = false;
        end;
    end;
end;

local function loadInventory() -- Line: 1859
    -- upvalues: u32 (copy), InventoryScroll (copy), GameManager (copy), u11 (ref)
    local v95 = 0;

    for i = 1, 105 do
        local Item = u32.Inventory[tostring(i)].Item;
        v95 = v95 + 1;
        local v96 = InventoryScroll:FindFirstChild("InvSlot" .. v95);
        v96.Background:Destroy();
        v96.BackgroundColor3 = Color3.new(0.18823529411764706, 0.18823529411764706, 0.18823529411764706);
        v96.Visible = true;
        v96.BackgroundTransparency = 0;
        v96.SlotNumber.Visible = false;
        v96.SlotText.TextColor3 = Color3.new(255, 255, 255);
        v96.Position = UDim2.new(v96.Position.X.Scale + 0.06, 0, v96.Position.Y.Scale + 0.0275, 0);
        local StringValue = Instance.new("StringValue");
        StringValue.Parent = v96;
        StringValue.Value = i;
        StringValue.Name = "SlotNum";

        if Item == "" then
            v96.SlotBorder.Visible = false;
            v96.BackgroundTransparency = 0.99;
        else
            v96.SlotText.Text = Item;
            local v97 = GameManager:getImageId(Item);

            if u11.ItemDisplayType == "Icon" and (v97 ~= false and v97 ~= "") then
                v96.Image = "rbxassetid://" .. v97;
                v96.ImageColor3 = GameManager:getImageColor(Item);
                v96.SlotText.TextTransparency = 1;
            else
                v96.SlotText.TextTransparency = 0;
                v96.Image = "";
            end;

            u32.InventorySlotCount = u32.InventorySlotCount + 1;
            v96.SlotBorder.Visible = true;
            v96.BackgroundTransparency = 0;
        end;
    end;
end;

local function HideLoadoutSlots() -- Line: 1900
    -- upvalues: Loadout (copy)
    for _, child in ipairs(Loadout:GetChildren()) do
        if string.match(child.Name, "Slot") == "Slot" then
            child.Visible = false;
        end;
    end;
end;

local function loadLoadout() -- Line: 1908
    -- upvalues: u32 (copy), Loadout (copy), u11 (ref)
    for i, _ in next, u32.Loadout do
        local StringValue = Instance.new("StringValue");
        local v98 = Loadout:FindFirstChild("Slot" .. i);
        StringValue.Parent = v98;
        v98.BackgroundColor3 = Color3.new(0.18823529411764706, 0.18823529411764706, 0.18823529411764706);
        v98.SlotNumber.Number.Text = u11.LoadoutKeybinds["Slot" .. i].Keybind;
        StringValue.Value = i;
        StringValue.Name = "SlotNum";
    end;
end;

local function len(p99) -- Line: 1923
    local v100 = 0;

    for _, _ in next, p99 do
        v100 = v100 + 1;
    end;

    return v100;
end;

local function slotCount(p101) -- Line: 1931
    -- upvalues: u32 (copy)
    local v102 = 0;

    if p101 == "Inventory" then
        return 12;
    end;

    for _, v in next, u32.Loadout do
        if v.Item ~= "" then
            v102 = v102 + 1;
        end;
    end;

    return v102;
end;

local function Unselect(p103) -- Line: 1945
    -- upvalues: slotItemAction (copy), u32 (copy), GameManager (copy)
    slotItemAction("Unselected", p103);

    if u32.PreviousSlotSize and u32.EnlargedSlot ~= 0 then
        u32.EnlargedSlot:TweenSize(u32.PreviousSlotSize, "Out", "Quad", GameManager.Settings.SlotTweenTime, true);
        u32.EnlargedSlot.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.StandardBorder;
    end;

    u32.SelectedSlot = "";
    u32.EnlargedSlot = 0;
end;

local function customRequirement(p104, p105, p106) -- Line: 1955
    -- upvalues: GameManager (copy), Humanoid (copy), LocalPlayer (copy), HumanoidRootPart (copy), u9 (copy), u32 (copy), u1 (copy), Model (copy), CollectionService (copy), UserInputService (copy), CurrentCamera (copy)
    if p105 == "Lightning Teleport" or p105 == "Flicker Teleport" then
        local v107 = GameManager:getHealthPercentage(Humanoid) < 25 and 150 or 500;
        local v108 = GameManager:createRegion3(p104 + Vector3.new(7, 7, 7), p104 + Vector3.new(-7, -7, -7));

        for _, v in pairs(game.Workspace:FindPartsInRegion3(v108, nil, (1 / 0))) do
            if v and (v.Parent and (v.Parent.Name ~= LocalPlayer.Name and (v.Parent:FindFirstChild("Humanoid") and (v.Parent:FindFirstChild("HumanoidRootPart") and (game.Players:GetPlayerFromCharacter(v.Parent) and (v.Parent.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude < v107))))) then
                return v.Parent;
            end;
        end;

        return false;
    end;

    if p105 ~= "Instantaneous Swap" then
        if p105 == "Intangibility" then
            if u9:FindFirstChild("ragdolled") then
                return;
            end;

            if u32.Settings.Knocked.Value == true then
                return;
            end;

            if Humanoid.PlatformStand then
                return;
            end;
        else
            if p105 == "Amaterasu" then
                return (HumanoidRootPart.Position - u1.Hit.Position).magnitude < 350;
            end;

            if p105 == "Wooden Spire" then
                return (HumanoidRootPart.Position - u1.Hit.Position).magnitude < 150;
            end;

            if p105 == "Ice Dragon" then
                return (HumanoidRootPart.Position - u1.Hit.Position).magnitude < 200;
            end;

            if p105 == "Wired Kunai" then
                local v109 = u32.InDanger == true and 150 or 200;
                local v110 = GameManager:createRegion3(p104 + Vector3.new(7, 7, 7), p104 + Vector3.new(-7, -7, -7));
                local v111 = false;

                for _, v in pairs(game.Workspace:FindPartsInRegion3(v110, nil, (1 / 0))) do
                    if v and (v.Parent and (v.Parent.Name ~= LocalPlayer.Name and (v.Parent:FindFirstChild("Humanoid") and (not v.Parent:FindFirstChild("ForceField") and (not v.Parent:GetAttribute("WiredKunaiCD") and (v.Parent:FindFirstChild("HumanoidRootPart") and ((v.Parent.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude < v109 and v.Parent.HumanoidRootPart.Position.Y + 5 > HumanoidRootPart.Position.Y))))))) then
                        v111 = v.Parent;
                    end;
                end;

                local v112;

                if v111 == false then
                    local v113 = u32.InDanger == true and (GameManager:getHealthPercentage(Humanoid) < 25 and 75 or 90) or 180;
                    local v114;
                    v114, v112 = GameManager:CastRayParams(HumanoidRootPart.Position, (u1.Hit.Position - HumanoidRootPart.Position).unit, {
                        u9,
                        workspace.Locations,
                        Model,
                        workspace.Debris
                    }, v113);

                    if v114 then
                        print("WIRED KUNAI HIT " .. v114.Name);
                    else
                        print("WIRED KUNAI DID NOT HIT ANYTHING");
                    end;

                    if v114 then
                        if v112.Y <= HumanoidRootPart.Position.Y then
                            v112 = v111;
                        end;
                    else
                        v112 = v111;
                    end;
                else
                    v112 = v111;
                end;

                return v112;
            end;

            if p105 == "Ice Flicker" then
                local v115 = u9:GetAttribute("IceUltimate") and 300 or 100;
                local v116 = u9:GetAttribute("InsideMirror");
                local v117 = CollectionService:GetTagged("Ice Mirror");
                local v118 = false;

                for i = #v117, 1, -1 do
                    local v119 = v117[i];

                    if v119.Name == v116 or (v119:GetAttribute("Occupied") or (v119:GetAttribute("Disabled") or (not v119:GetAttribute("Enabled") or v119:GetAttribute("Owner") ~= u9.Name))) then
                        table.remove(v117, i);
                    end;
                end;

                local v120 = RaycastParams.new();
                v120.FilterDescendantsInstances = v117;
                v120.FilterType = Enum.RaycastFilterType.Include;
                local v121 = UserInputService:GetMouseLocation();
                local v122 = CurrentCamera:ViewportPointToRay(v121.X, v121.Y);
                local Origin = v122.Origin;
                local v123 = workspace:Raycast(Origin, v122.Direction * v115, v120);

                if v123 then
                    v118 = v123.Instance.Parent;
                end;

                local v124;

                if v118 == false and v116 then
                    local v125 = u9:GetAttribute("IceUltimate") and 300 or 125;
                    local v126 = GameManager:createRegion3(u1.Hit.Position + Vector3.new(7, 7, 7), p104 + Vector3.new(-7, -7, -7));

                    for _, v in pairs(game.Workspace:FindPartsInRegion3(v126, nil, (1 / 0))) do
                        if v and (v.Parent and (v.Parent.Name ~= LocalPlayer.Name and (v.Parent:FindFirstChild("Humanoid") and (not v.Parent:FindFirstChild("ForceField") and (v.Parent:FindFirstChild("HumanoidRootPart") and (v.Parent.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude < v125))))) then
                            local Unit = (v.Parent.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit;

                            return v.Parent:GetPivot().Position + Unit * 3;
                        end;
                    end;

                    local v127;
                    v127, v124 = GameManager:CastRayParams(Origin, (u1.Hit.Position - Origin).unit, {
                        u9,
                        workspace.Locations,
                        Model,
                        workspace.Debris,
                        workspace:FindFirstChild(v116)
                    }, v125);

                    if v127 then
                        print("Ice Flicker HIT " .. v127.Name);
                    else
                        print("Ice Flicker DID NOT HIT ANYTHING");
                    end;

                    if not v127 then
                        v124 = v118;
                    end;
                else
                    v124 = v118;
                end;

                return v124;
            end;

            if p105 == "Matatabi Cross Slash" then
                for _, child in workspace:GetChildren() do
                    if child:GetAttribute("ZigZagPounce") == u9.Name then
                        return child;
                    end;
                end;

                local v128 = GameManager:createRegion3(p104 + Vector3.new(7, 7, 7), p104 + Vector3.new(-7, -7, -7));
                local v129 = false;

                for _, v in pairs(game.Workspace:FindPartsInRegion3(v128, nil, (1 / 0))) do
                    if v and (v.Parent and (v.Parent.Name ~= LocalPlayer.Name and (v.Parent:FindFirstChild("Humanoid") and (not v.Parent:FindFirstChild("ForceField") and (v.Parent:FindFirstChild("HumanoidRootPart") and ((v.Parent.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude < 200 and GameManager:canBeDamaged(v.Parent))))))) then
                        v129 = v.Parent;
                    end;
                end;

                return v129;
            end;
        end;

        return true;
    end;

    local v130 = GameManager:createRegion3(p104 + Vector3.new(10, 10, 10), p104 + Vector3.new(-10, -10, -10));
    local v131 = GameManager.Skills["Instantaneous Swap"];
    local MaxRange = v131.MaxRange;

    if GameManager:getHealthPercentage(Humanoid) < 25 then
        MaxRange = MaxRange * 0.7;
    end;

    for _, v in pairs(game.Workspace:FindPartsInRegion3(v130, nil, (1 / 0))) do
        if v and (v.Parent and (v.Parent.Name ~= LocalPlayer.Name and (v.Parent:FindFirstChild("Humanoid") and (v.Parent:FindFirstChild("HumanoidRootPart") and (not v.Parent:FindFirstChild("ForceField") and (not v.Parent:FindFirstChild("NPC") or v.Parent.NPC.Value == "Combat")))))) and (v.Parent.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude < MaxRange then
            return v.Parent;
        end;
    end;

    for _, v in pairs(game.Workspace:FindPartsInRegion3(v130, nil, (1 / 0))) do
        if v and v.Parent and (v131.ValidPartSwaps[GameManager:formatSwapPart(v.Name)] and (v.Position - HumanoidRootPart.Position).magnitude < v131.MaxRange or v131.ValidParentSwaps[v.Parent.Name] and (v.Position - HumanoidRootPart.Position).magnitude < MaxRange) then
            if v131.ValidPartSwaps[GameManager:formatSwapPart(v.Name)] then
                print("returned part");

                return v;
            end;

            if v131.ValidParentSwaps[v.Parent.Name] then
                print("returned parent");

                return v.Parent;
            end;
        end;
    end;

    print("returned false");

    return false;
end;

local chakra = LocalPlayer.Backpack:WaitForChild("chakra");
local maxChakra = LocalPlayer.Backpack:WaitForChild("maxChakra");
local running = LocalPlayer.Backpack:WaitForChild("running");
local blood = LocalPlayer.Backpack:WaitForChild("blood");
local MaxHealth = Humanoid.MaxHealth;
local Blood = HUD:WaitForChild("Blood");
local u132 = 0;
blood.Changed:Connect(function(p133) -- Line: 2183
    -- upvalues: u132 (ref), Blood (copy), TweenService (copy)
    if u132 <= p133 then
        local v134 = math.random(1, 5);

        if v134 == 1 then
            Blood.Splatter.Image = "rbxassetid://5107493082";
        elseif v134 == 2 then
            Blood.Splatter.Image = "rbxassetid://5107556224";
        elseif v134 == 3 then
            Blood.Splatter.Image = "rbxassetid://5107602005";
        elseif v134 == 4 then
            Blood.Splatter.Image = "rbxassetid://5107631704";
        else
            Blood.Splatter.Image = "rbxassetid://5107655011";
        end;

        Blood.Splatter.ImageTransparency = 0;
        TweenService:Create(Blood.Splatter, TweenInfo.new(1), {
            ImageTransparency = 1
        }):Play();
    end;

    Blood.Visible = p133 >= 1;
    Blood.Amount.Text = math.floor(p133) .. "%";
    u132 = p133;
end);

local function disableRun(p135) -- Line: 2208
    -- upvalues: u32 (copy), running (copy), GameManager (copy), Humanoid (copy), u48 (copy), u11 (ref), u9 (copy)
    u32.Running = false;
    running.Value = false;
    GameManager:TweenObject(workspace.CurrentCamera, {
        FieldOfView = 70
    }, 0.5);

    if u32.ActionAnim and (u32.ActionAnim.Name == "ArmRunningForward" and u32.skillInUse ~= "") then
        u32.ActionAnim:Stop();
        u32.ActionAnim = GameManager:getAnimation("SkillHold", Humanoid);
        u32.ActionAnim:Play();
    elseif u32.ActionAnim and (u32.ActionAnim.Name == "DoubleArmsRunningForward" and u32.skillInUse ~= "") then
        u32.ActionAnim:Stop();
        u32.ActionAnim = GameManager:getAnimation("DoubleSkillHold", Humanoid);
        u32.ActionAnim:Play();
    end;

    if u32.runningIdleAnim and u32.CombatTable.RunningIdle then
        u32.runningIdleAnim:Stop();
        u32.runningIdleAnim = nil;

        if u32.Settings.Blocking.Value == false and u32.Settings.MeleeCooldown.Value == false then
            u32.idleAnim = GameManager:getAnimation(u32.CombatTable.Idle, Humanoid);
            u32.idleAnim:Play();
        elseif u32.Settings.MeleeCooldown.Value == true then
            u32.fixWeaponAnim = true;
        end;
    end;

    if p135 then
        if p135 == "Stop" then
            Humanoid.WalkSpeed = 0;
        elseif p135 == "StopStun" then
            Humanoid.WalkSpeed = 3;
        end;
    else
        Humanoid.WalkSpeed = u32.OriginSpeed;
    end;

    u48.Run:Stop();
    u48.Swimming:Stop();

    if GameManager.Clothing[u11.Clothing].RunAnim and u9:FindFirstChild(u11.Clothing) then
        local v136;

        if u9[u11.Clothing]:FindFirstChild("AC") then
            v136 = u9[u11.Clothing].AC;
        else
            v136 = u9[u11.Clothing].Original.AC;
        end;

        GameManager:stopAnimation(GameManager.Clothing[u11.Clothing].RunAnim, v136);

        if GameManager.Clothing[u11.Clothing].IdleAnim then
            GameManager:getAnimation(GameManager.Clothing[u11.Clothing].IdleAnim, v136):Play();
        end;
    end;
end;

if GameManager.Clothing[u11.Clothing].IdleAnim and u9:FindFirstChild(u11.Clothing) then
    local v137;

    if u9[u11.Clothing]:FindFirstChild("AC") then
        v137 = u9[u11.Clothing].AC;
    else
        v137 = u9[u11.Clothing].Original.AC;
    end;

    GameManager:getAnimation(GameManager.Clothing[u11.Clothing].IdleAnim, v137):Play();
end;

local function slotDown(p138) -- Line: 2268
    -- upvalues: Loadout (copy), InventoryScroll (copy), u32 (copy), GameManager (copy), slotItemAction (copy), changeSlotSize (copy)
    local u139 = Loadout:FindFirstChild(p138) or InventoryScroll:FindFirstChild(p138);

    if (function() -- Line: 2272, Name: falseMelee
        -- upvalues: u32 (ref), u139 (copy)
        return u32.Settings.MeleeCooldown.Value == false and true or (u32.Settings.MeleeCooldown.Value == true and (skillsModule[u139.SlotText.Text] and (skillsModule[u139.SlotText.Text].SkillType2 and (skillsModule[u139.SlotText.Text].SkillType2 == "Taijutsu" or skillsModule[u139.SlotText.Text].SkillType2 == "Close Combat"))) and true or false);
    end)() and (u32.CanSwitch == true and u139.SlotText.Text ~= "") then
        if u32.SelectedSlot == u139.Name then
            if u32.EnlargedSlot ~= 0 then
                u32.EnlargedSlot:TweenSize(u32.PreviousSlotSize, "Out", "Quad", GameManager.Settings.SlotTweenTime, true);
                u32.EnlargedSlot.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.StandardBorder;
                u32.SelectedSlot = "";
                u32.EnlargedSlot = 0;
            end;

            slotItemAction("Unselected", u139.SlotText.Text);
            u32.SelectedSlot = "";
            u32.EnlargedSlot = 0;

            return;
        end;

        if u139.BackgroundTransparency == 0 then
            changeSlotSize(u139, "Enlargen");
            u32.SelectedSlot = u139.Name;
        end;
    end;
end;

function hasInventoryItem(p140, p141)
    -- upvalues: u32 (copy)
    if p140 then
        for _, v in next, u32.Loadout do
            if v.Item == p141 then
                return true;
            end;
        end;

        for _, v in next, u32.Inventory do
            if v.Item == p141 then
                return true;
            end;
        end;
    end;
end;

local function selectNewItem(p142, p143) -- Line: 2315
    -- upvalues: u32 (copy), slotDown (copy)
    local v144 = false;

    if p142 then
        for i, v in next, u32.Loadout do
            if v.Item == p143 then
                slotDown("Slot" .. i);
                v144 = true;
            end;
        end;

        if v144 == false then
            for i, v in next, u32.Inventory do
                if v.Item == p143 then
                    slotDown("InvSlot" .. i);
                end;
            end;
        end;
    end;
end;

local function newCooldown(p145) -- Line: 2336
    -- upvalues: Mainframe (copy), TweenService (copy), GameManager (copy), u9 (copy), u32 (copy)
    for _, child in Mainframe.MessageFrame:GetChildren() do
        if child.Name == p145 then
            child:Destroy();
        end;
    end;

    local v146 = Mainframe.MessageFrame.CooldownClone:Clone();

    for _, child in ipairs(Mainframe.MessageFrame:GetChildren()) do
        if child.Name ~= "CooldownClone" then
            TweenService:Create(child, TweenInfo.new(0.25), {
                Position = UDim2.new(0.5, 0, child.Position.Y.Scale - 1, 0)
            }):Play();
        end;
    end;

    local v147 = GameManager:getCooldown(u9, p145, u32.Settings);
    v146.Name = p145;
    v146.Amount.Value = v147;
    v146.totalCooldown.Value = v147;
    v146.abilityName.Value = p145;
    v146.UsedAt.Value = workspace:GetServerTimeNow();
    v146.Position = UDim2.new(0.5, 0, -2, 0);
    v146.Parent = Mainframe.MessageFrame;
    TweenService:Create(v146, TweenInfo.new(0.25), {
        TextTransparency = 0,
        Position = UDim2.new(0.5, 0, -1, 0)
    }):Play();
    v146.Text = p145 .. " [" .. v147 .. "]";
    v146.Visible = true;
end;

function activateSkill(p148, p149, p150)
    -- upvalues: u9 (copy), u32 (copy), GameManager (copy), u11 (ref), u10 (copy), customRequirement (copy), u1 (copy), LocalPlayer (copy), HumanoidRootPart (copy), DataFunction (copy), Humanoid (copy), CollectionService (copy), Cooldowns (copy), disableRun (copy), newCooldown (copy), DataEvent (copy), selectNewItem (copy), Unselect (copy), getOriginSpeed (copy), u31 (ref), setRunSpeed (copy)
    if u9:GetAttribute("KotoamatsukamiForceMove") then
        return;
    end;

    if u9:GetAttribute("KotoamatsukamiAttacking") then
        return;
    end;

    u32.skillInUse = p149 or u32.Selected;
    local _ = u32.skillInUse;
    local u151 = nil;

    if not skillsModule[u32.skillInUse] then
        local _ = GameManager.Skills[u32.skillInUse];
    end;

    local v152 = 0;
    local u153 = nil;

    if p148 == "MouseButton1" and p149 then
        if u32.ChargingChakra == true then
            u32.skillInUse = skillsModule[u32.Selected]["C + M1"] or skillsModule[u32.Selected].MouseButton1;
        else
            u32.skillInUse = skillsModule[u32.Selected].MouseButton1;
        end;
    elseif p148 == "MouseButton2" then
        if u32.ChargingChakra == true then
            u32.skillInUse = skillsModule[u32.Selected]["C + M2"] or (skillsModule[u32.Selected].MouseButton2 or u32.skillInUse);
        else
            u32.skillInUse = skillsModule[u32.Selected].MouseButton2 or u32.skillInUse;
        end;
    end;

    local u154 = skillsModule[u32.skillInUse] or GameManager.Skills[u32.skillInUse];
    local skillInUse = u32.skillInUse;
    u32.usedSingleSkillDash = false;

    if not u32.skillInUse then
        return;
    end;

    local u155;

    if p148 == "MouseButton2" then
        u155 = u154.Handsigns and GameManager:isJutsuMastered(u11, u32.skillInUse);
    else
        u155 = false;
    end;

    if p148 == "MouseButton2" and (u154.Handsigns and not (u155 or GameManager:isAwakeningSkill(u32.skillInUse))) then
        return;
    end;

    if u10.Awakened.Value == "Jinchuriki [Stage 3]" then
        local v156 = GameManager.Skills[u10.Awakened.Value];
        local skillInUse2 = u32.skillInUse;

        if skillInUse2 ~= v156.MouseButton1 and (skillInUse2 ~= v156.MouseButton2 and (skillInUse2 ~= v156["C + M1"] and skillInUse2 ~= v156["C + M2"])) then
            return;
        end;
    end;

    if (u9:GetAttribute("BlueGatesTimer") or u9:GetAttribute("RedGatesQuest")) and GameManager.Skills[u32.skillInUse].SkillType2 ~= "Taijutsu" then
        return;
    end;

    if u9:GetAttribute("PurpleBody") and (u32.skillInUse ~= "Cloak Of Lightning" and (u32.skillInUse ~= "Lightning Drop" and u32.skillInUse ~= "Lightning Teleport")) then
        return;
    end;

    u32.currentSkillsModule = u154;
    local v157 = p150 or customRequirement(u1.Hit.Position, u32.skillInUse);

    if u32.Breaking == true then
        return;
    end;

    if u32.ShortCooldown == false and (u32.Broken == false and (u32.Settings.Blocking.Value == false and (v157 and (not u9:FindFirstChild("ForceField") and (u32.Settings.CurrentSkill.Value == "" and (u32.Selected ~= "" or u154.BypassSelection)))))) and ((u32.Occupied == false or u154.BypassOccupied and (skillInUse ~= "Burrow" or u32.Settings.Burrowing.Value ~= false)) and ((u32.Settings.Stunned.Value == false or (u154.BypassStun or GameManager:canBypassIceFlickerStun(u9, u32.skillInUse))) and (u32.Knocked == true and (u154.UseWhileKnocked == true or u154.BypassKnocked) or u32.Knocked == false and u154.UseWhileKnocked == false))) then
        u32.ShortCooldown = true;
        task.delay(0.2, function() -- Line: 2446
            -- upvalues: u32 (ref)
            u32.ShortCooldown = false;
        end);
        local skillInUse2 = u32.skillInUse;
        local skillInUse3 = u32.skillInUse;
        u32.Casting = true;

        local function preConditions() -- Line: 2454
            -- upvalues: u154 (ref), u11 (ref), u32 (ref), GameManager (ref), u10 (ref), u155 (copy), u9 (ref), LocalPlayer (ref), HumanoidRootPart (ref), DataFunction (ref), u1 (ref), u153 (ref), Humanoid (ref), CollectionService (ref)
            if u154.AgeCooldown and (u11.AgeCDSkills and u11.AgeCDSkills[u32.skillInUse]) then
                local AgeCooldown = u154.AgeCooldown;

                if u32.skillInUse == "Kotoamatsukami" then
                    if u32.Settings.Awakened.Value == "Shisui\'s Mangekyo" then
                        AgeCooldown = (u11.Bloodline == "Senju" or GameManager:hasImplantedArm(u11, "Torn Senju Arm")) and 3 or 5;
                    elseif u10.Awakened.Value == "Shisui\'s Eternal Mangekyo" then
                        GameManager:hasImplantedArm(u11, "Torn Senju Arm");
                        AgeCooldown = 1;
                    end;
                end;

                if u11.Age - u11.AgeCDSkills[u32.skillInUse] < AgeCooldown then
                    return;
                end;
            end;

            if u155 and u9:GetAttribute("SnapCD") then
                return;
            end;

            if (u32.skillInUse == "Isobu Swallow" or (u32.skillInUse == "Rift" or (u32.skillInUse == "Sasuke Portal" or (u32.skillInUse == "Water Region" or u32.skillInUse == "Kamui Self-Warp")))) and u32.currentLocation == "Isobu\'s Belly" then
                return;
            end;

            if u32.skillInUse ~= "Kotoamatsukami" then
                if u32.skillInUse == "Kotoamatsukami Explode" or (u32.skillInUse == "Kotoamatsukami Betray" or u32.skillInUse == "Kotoamatsukami Defend") then
                    local v158 = GameManager:getKotoamatsukamiPuppet(LocalPlayer);

                    if v158 then
                        local v159 = GameManager:getSettings(v158);

                        if not v159 or (v159.Invincible.Value == true or v158:FindFirstChild("ForceField")) then
                            return;
                        end;

                        if u32.skillInUse == "Kotoamatsukami Betray" then
                            if not v158:FindFirstChild("ragdolled") and v159.Knocked.Value ~= true then
                                if DataFunction:InvokeServer("getClosestKotoamatsukamiAlly") then
                                    return true;
                                end;

                                newNotification("No target found to betray.");

                                return false;
                            end;

                            return;
                        end;
                    end;

                    return v158;
                end;

                if u32.skillInUse == "Izanagi" then
                    if not GameManager:hasSkill(u11, "Izanagi") then
                        return;
                    end;

                    if u11.MissingArm then
                        return;
                    end;

                    if not u11.DanzoArm then
                        return;
                    end;

                    if u11.DanzoArm.Sharingans == 0 then
                        return;
                    end;

                    if u32.Settings.Awakened.Value == "Red Gates" and u32.Settings.Knocked.Value == true then
                        return;
                    end;
                end;

                if u32.skillInUse == "Lightning Drop" then
                    local _, v160 = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);

                    if v160 and (v160 - HumanoidRootPart.Position).magnitude < 25 then
                        return false;
                    end;
                elseif u32.skillInUse == "Kirin" then
                    if not u1.Hit or (u1.Hit.p - HumanoidRootPart.Position).Magnitude >= u154.MaxLightningDistance then
                        return false;
                    end;

                    u153 = u1.Hit.p;
                else
                    if u32.skillInUse == "Wooden Dragon" then
                        local v161 = workspace.CurrentCamera:ScreenPointToRay(u1.X, u1.Y);
                        local v162 = GameManager:getHealthPercentage(Humanoid) < 25 and 150 or 250;
                        local v163 = RaycastParams.new();
                        v163.FilterDescendantsInstances = { workspace.Debris, workspace.Locations, u9 };
                        v163.FilterType = Enum.RaycastFilterType.Exclude;
                        local v164 = workspace:Raycast(v161.Origin, v161.Direction * v162, v163);

                        if not v164 then
                            return;
                        end;

                        if v162 >= (v164.Position - u9:GetPivot().Position).Magnitude then
                            return v164.Position;
                        end;

                        return;
                    end;

                    if u32.skillInUse == "Infestation" or (u32.skillInUse == "Bugs Swarm" or u32.skillInUse == "Bugs Strike") then
                        if u32.Settings.Awakened.Value ~= "" then
                            return false;
                        end;
                    elseif u32.skillInUse == "Bones" then
                        if u32.Settings.Awakened.Value ~= "" then
                            return false;
                        end;
                    elseif u32.skillInUse == "Water Region" then
                        local v165, _ = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);
                        local v166, _ = GameManager:CastRay(HumanoidRootPart.Position + Vector3.new(50, 0, 0), HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);
                        local v167, _ = GameManager:CastRay(HumanoidRootPart.Position + Vector3.new(-50, 0, 0), HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);
                        local v168, _ = GameManager:CastRay(HumanoidRootPart.Position + Vector3.new(0, 0, 50), HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);
                        local _, _ = GameManager:CastRay(HumanoidRootPart.Position + Vector3.new(0, 0, -50), HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);
                        local v169, _ = GameManager:CastRay(HumanoidRootPart.Position + Vector3.new(-25, 0, 0), HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);
                        local v170, _ = GameManager:CastRay(HumanoidRootPart.Position + Vector3.new(0, 0, 25), HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);
                        local v171, _ = GameManager:CastRay(HumanoidRootPart.Position + Vector3.new(0, 0, -25), HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)).p, u9);

                        if v165 and v165.Name == "Water" or (v166 and v166.Name == "Water" or (v167 and v167.Name == "Water" or (v168 and v168.Name == "Water" or (v169 and v169.Name == "Water" or (v170 and v170.Name == "Water" or v171 and v171.Name == "Water"))))) then
                            return false;
                        end;

                        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                            return false;
                        end;
                    elseif u32.skillInUse == "Pool Expansion" then
                        local v172, _ = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)).p, u9);

                        if not v172 or v172.Name ~= "Water" then
                            return false;
                        end;
                    elseif u32.skillInUse == "Burrow" then
                        local v173, _ = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 3.5, 0)).p, u9);

                        if (not v173 or v173.Material ~= Enum.Material.Grass and (v173.Material ~= Enum.Material.Sand and (not v173:FindFirstChild("partMaterial") or v173.partMaterial.Value ~= "Grass" and v173.partMaterial.Value ~= "Sand"))) and u32.Settings.Burrowing.Value == false then
                            return false;
                        end;
                    elseif u32.skillInUse == "Burrow Teleport" then
                        local _ = u32.InDanger;

                        if u1.Hit and (u1.Hit.p and (u1.Hit.p - HumanoidRootPart.Position).magnitude > 250) then
                            return false;
                        end;
                    else
                        if u32.skillInUse == "Blood Transfusion" then
                            local Point1 = u154.Point1;
                            local Point2 = u154.Point2;

                            if u32.Settings.Awakened.Value:find("Stage 3") then
                                Point1 = CFrame.new(-75, -75, -75);
                                Point2 = CFrame.new(75, 75, 75);
                            end;

                            local Position = (HumanoidRootPart.CFrame * Point1).Position;
                            local Position2 = (HumanoidRootPart.CFrame * Point2).Position;
                            local v174 = (Position + Position2) / 2;
                            local v175 = (Position2 - Position) * 0.7 / 2;
                            local v176 = GameManager:createRegion3(v174 - v175, v174 + v175);

                            for _, v in workspace:FindPartsInRegion3(v176, nil, (1 / 0)) do
                                if v.Parent:FindFirstChild("Humanoid") and not v:IsDescendantOf(u9) then
                                    local Parent = v.Parent;
                                    local v177 = GameManager:getSettings(Parent);

                                    if v177 and (v177.Blocking.Value ~= true and (v177.Invincible.Value ~= true and (not Parent:FindFirstChild("ForceField") and (not Parent:FindFirstChild("NPC") or Parent.NPC.Value ~= "Dialog")))) then
                                        return true;
                                    end;
                                end;
                            end;

                            return false;
                        end;

                        if u32.skillInUse == "Rift" or (u32.skillInUse == "Sasuke Portal" or (string.match(u32.skillInUse, "Kamui") or (u32.skillInUse == "Clone Swap" or u32.skillInUse == "Chakra Sense"))) then
                            if u9:GetAttribute("Subconscious") or u9:GetAttribute("Realm") then
                                return false;
                            end;

                            if u32.skillInUse == "Kamui Self-Warp" then
                                if u9:GetAttribute("InsideWall") then
                                    warn("inside");

                                    return;
                                end;

                                warn("outside");
                            end;

                            if u32.skillInUse == "Kamui Self-Warp" then
                                local v178 = RaycastParams.new();
                                v178.FilterDescendantsInstances = { workspace.Debris, workspace.Locations, GameManager:getCharacters() };
                                v178.FilterType = Enum.RaycastFilterType.Exclude;
                                local v179 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -15, 0), v178);

                                if v179 and (v179.Instance and CollectionService:HasTag(v179.Instance, "Void")) then
                                    return;
                                end;
                            end;
                        else
                            if u154.SkillType2 == "Wood" then
                                return (u11.Bloodline == "Senju" or u11.Bloodline == "Zetsu") and true or ((GameManager:hasImplantedArm(u11, "Torn Senju Arm") or GameManager:hasImplantedArm(u11, "Torn Zetsu Arm")) and true or false);
                            end;

                            if u32.skillInUse == "Shukaku Cloak Arm Emerge" then
                                local v180 = GameManager:getNearbyEnemies(HumanoidRootPart.Position, 100, { u9 });
                                local v181 = RaycastParams.new();
                                v181.FilterDescendantsInstances = {
                                    u9,
                                    workspace.Debris,
                                    { u9 }
                                };
                                v181.FilterType = Enum.RaycastFilterType.Exclude;

                                for _, v in v180 do
                                    local v182 = v:FindFirstChild("Ailments") or game.ReplicatedStorage.Ailments:FindFirstChild(v.Name);

                                    if v182 and v182:FindFirstChild("Magnetic") then
                                        local v183, v184 = v:GetBoundingBox();

                                        if workspace:Raycast(v183.Position, Vector3.new(0, -v184.Y / 2 - 10, 0), v181) then
                                            return true;
                                        end;
                                    end;
                                end;

                                return false;
                            end;
                        end;
                    end;
                end;

                return true;
            end;

            local v185 = GameManager:getClosestEnemy(HumanoidRootPart.Position, 40, GameManager.Skills[u32.skillInUse].AffectsSelf and {} or { LocalPlayer.Name }, nil, nil, nil, true);

            if not v185 then
                return false;
            end;

            if not v185.Character:GetAttribute("UnderKotoamatsukami") then
                return true;
            end;
        end;

        local v186 = GameManager:hasSkillCosts(LocalPlayer, u11, u32.skillInUse, u155);

        if (not u32.Occupied or u154.BypassOccupied) and (u154 and (v186 and (not u154.RequiresGrounded or u154.RequiresGrounded and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall))) and (not u154.RequiresWeapon or u154.RequiresWeapon and GameManager:searchInList(u154.RequiresWeapon, u32.CombatType)) then
            local v187;

            if Cooldowns[LocalPlayer.Name]:FindFirstChild(u32.skillInUse) then
                u32.Occupied = true;
                v187 = DataFunction:InvokeServer("CheckCooldown", u32.skillInUse);
                u32.Occupied = false;
            else
                v187 = true;
            end;

            if v187 then
                local v188 = preConditions();

                if v188 then
                    u32.Occupied = true;
                    u32.HoldingSkill = true;
                    u32.HoldingSkillButton = p148;

                    if u154.WindUpMovement then
                        if u154.WindUpMovement == "Stop" then
                            disableRun("Stop");
                        elseif u154.WindUpMovement == "Walk" then
                            disableRun();
                        end;
                    end;

                    if u154.Anchored == true then
                        HumanoidRootPart.Anchored = true;
                    end;

                    if u32.skillInUse == "Butterfly Flight" then
                        u32.CharFacing = true;
                    elseif u32.skillInUse == "Instantaneous Swap" then
                        GameManager:swapEffect(LocalPlayer);
                    elseif u32.skillInUse == "Matatabi Bullets" then
                        local v189, v190 = GameManager:getAnimation("Matatabi Cloak Bullets", Humanoid, Enum.AnimationPriority.Action3);
                        v189:Play();
                        v189:AdjustSpeed(v190);
                    end;

                    if u154.Cooldown >= 1 then
                        newCooldown(u32.skillInUse, u154.Cooldown);
                    end;

                    u153 = u153 or u1.Hit.p;

                    if u32.skillInUse == "Wooden Dragon" then
                        u153 = v188;
                    end;

                    DataEvent:FireServer("startSkill", skillInUse3, u153, v157, p148);
                    local v191 = 1;
                    local v192 = 1;

                    if u32.Settings.Awakened.Value:find("Sharingan") or u32.Settings.Awakened.Value:find("Mangekyo") then
                        v191 = v191 - 0.2;
                        v192 = v192 + 0.2;
                    end;

                    if u11.Ring == "Ring Of Dexterity" then
                        v191 = v191 - 0.12;
                        v192 = v192 + 0.12;
                    elseif u11.Ring == "Ring Of Dexterity +1" then
                        v191 = v191 - 0.18;
                        v192 = v192 + 0.18;
                    elseif u11.Ring == "Ring Of Dexterity +2" then
                        v191 = v191 - 0.25;
                        v192 = v192 + 0.25;
                    elseif u11.Ring == "Ring Of Dexterity +3" then
                        v191 = v191 - 0.3;
                        v192 = v192 + 0.3;
                    end;

                    if u9:GetAttribute("CombatFluidity") then
                        v191 = v191 - 0.5;
                        v192 = v192 + 0.5;
                    end;

                    local v193 = math.min(1.5, v192);
                    local v194 = math.max(0.5, v191);

                    if u11.MissingArm then
                        v193 = v193 - 0.25;
                        v194 = v194 + 0.25;
                    end;

                    local u195 = nil;
                    local v196 = u32.Settings.Stunned:GetPropertyChangedSignal("Value"):Once(function() -- Line: 2857
                        -- upvalues: u195 (ref), u32 (ref)
                        u195 = u32.Settings.Stunned.Value;
                        u32.skillInUse = "";
                    end);

                    if u154.Handsigns then
                        for i = u155 and not u11.MissingArm and 1 or nil or u154.Handsigns, 1, -1 do
                            u32.ActionAnim = GameManager:getAnimation("Handsigns" .. i, Humanoid, Enum.AnimationPriority.Action3);
                            u151 = u32.ActionAnim;
                            u32.ActionAnim:AdjustSpeed(v193);
                            u32.ActionAnim:Play();
                            wait(v194 * 0.34);
                        end;
                    else
                        if u154.StartUpAnim then
                            if u154.StartUpAnim ~= nil then
                                u32.ActionAnim = GameManager:getAnimation(u154.StartUpAnim, Humanoid, Enum.AnimationPriority.Action3);
                                u151 = u32.ActionAnim;
                            end;
                        elseif u154.ActionAnim then
                            u32.ActionAnim = GameManager:getAnimation(u154.ActionAnim, Humanoid, Enum.AnimationPriority.Action3);
                            u151 = u32.ActionAnim;
                        end;

                        if u32.ActionAnim then
                            u32.ActionAnim:Play();
                            local ActionAnim = u32.ActionAnim;
                            ActionAnim:AdjustSpeed((skillInUse3 == "Tail Roar" and 0.7 or (u154.ActionAnimSpeed or ActionAnim.Speed)) * (1 + (u9:GetAttribute("CombatFluidity") or 1) / 100));

                            if u154.StartUpAnim and GameManager.Animations[u154.StartUpAnim].Snap or u154.ActionAnim and GameManager.Animations[u154.ActionAnim].Snap then
                                print("snap exists");
                                u32.ActionAnim:GetMarkerReachedSignal("Snap"):Connect(function() -- Line: 2903
                                    -- upvalues: GameManager (ref), u9 (ref)
                                    print("reached snap event");
                                    GameManager:AfterEffect(u9);
                                end);
                            end;

                            if u154.LoadUpTime then
                                local v197 = u154.LoadUpTime * (1 - (u9:GetAttribute("CombatFluidity") or 1) / 100);
                                task.wait(v197);
                            end;
                        end;
                    end;

                    v196:Disconnect();

                    if u195 then
                        if u32.ActionAnim and (not u154.EndActionAnim or u154.EndActionAnim ~= 0) then
                            u32.ActionAnim:Stop();
                        end;

                        if u154.Anchored == true then
                            HumanoidRootPart.Anchored = true;
                            HumanoidRootPart.Anchored = false;
                        end;

                        return;
                    end;

                    if u154.BlocksJumping then
                        u32.jumpBlocked = true;
                    end;

                    local v198 = GameManager.Skills[u32.Selected];

                    if v198 then
                        if GameManager.Skills[u32.Selected].MouseButton1 == u32.skillInUse or GameManager.Skills[u32.Selected]["C + M1"] == u32.skillInUse then
                            v198 = GameManager.Skills[u32.skillInUse].Unselect;
                        else
                            v198 = false;
                        end;
                    end;

                    if (u32.Selected == u32.skillInUse or (v198 or GameManager.Skills[u32.Selected] and (GameManager.Skills[u32.Selected].MouseButton2 == u32.skillInUse and true or GameManager.Skills[u32.Selected]["C + M2"] == u32.skillInUse))) and not u154.CanDeactivate then
                        if u154.RequiresWeapon and not GameManager:inBaseCombat(u154.RequiresWeapon) then
                            selectNewItem(u11, u11.CurrentWeapon);
                        elseif not (GameManager.Skills[u32.skillInUse] and GameManager.Skills[u32.skillInUse].NoUnselect) then
                            Unselect(u32.Selected);
                        end;
                    end;

                    local u199 = u154.ClientOccupiedTime or u154.OccupiedTime;

                    if u199 then
                        u199 = u199 * (1 - (u9:GetAttribute("CombatFluidity") or 1) / 100);
                    end;

                    if u32.Settings.Stunned.Value == false then
                        local v200 = 0;
                        u32.Casting = false;

                        if u32.HoldingSkill == true and not u154.NoHold then
                            local v201 = u154.MaxHoldTime or 3;

                            repeat
                                v200 = v200 + task.wait();
                            until u32.HoldingSkill == false or (v201 <= v200 or (u32.Settings.Stunned.Value == true or u32.HoldingSkillButton == "MouseButton1" and not u32.HoldingMouseButton1)) or u32.HoldingSkillButton == "MouseButton2" and not u32.HoldingMouseButton2;

                            if u32.Settings.Stunned.Value == false then
                                DataEvent:FireServer("ReleaseSkill");
                            end;

                            if u154.Handsigns and (not u32.HoldingSkill or v201 <= v200) and (u32.Settings.Stunned.Value == false and GameManager.Settings.HoldTimeToPunish <= v200) then
                                task.wait(GameManager.Settings.HoldPunish);
                            end;

                            u32.HoldingSkill = false;
                            u32.HoldingSkillButton = "";
                        end;

                        if u154.SkillSpeedBoost then
                            u32.OriginSpeed = getOriginSpeed() * u154.SkillSpeedBoost;
                            Humanoid.WalkSpeed = u32.OriginSpeed;
                        elseif u154.ActionMovement and u154.ActionMovement == "Stop" then
                            if u154.IgnoreActionIfMastered and u155 then
                                if u154.IgnoreActionIfMastered == "Walk" then
                                    disableRun();
                                end;

                                print("did not stop - ArkhamDeluxe");
                            else
                                Humanoid.WalkSpeed = 0;
                                Humanoid.JumpPower = 0;
                            end;
                        else
                            local _ = u154.ActionMovement;
                        end;

                        if u154.DisableJumping then
                            Humanoid.JumpPower = 0;
                        end;

                        if not u154.DontStopStart and (not u154.ActionAnim or u32.ActionAnim and u32.ActionAnim ~= GameManager:getAnimation(u154.ActionAnim, Humanoid)) and u32.ActionAnim then
                            u32.ActionAnim:Stop();
                        end;

                        if u154.ActionTime and u154.InitialActionAnim then
                            if u32.ActionAnim then
                                local v202, v203 = GameManager:getAnimation(u155 and u154.MasteredInitialActionAnim or u154.InitialActionAnim, Humanoid, Enum.AnimationPriority.Action3);
                                u32.ActionAnim = v202;

                                if u151 then
                                    u151 = u32.ActionAnim;
                                end;

                                u32.ActionAnim:Play();
                                u32.ActionAnim:AdjustSpeed(v203 or 1);
                                local ActionAnim = u32.ActionAnim;
                                ActionAnim:AdjustSpeed(ActionAnim.Speed * (1 + (u9:GetAttribute("CombatFluidity") or 1) / 100));
                            end;

                            if u154.InitialStop then
                                disableRun("Stop");
                            end;

                            local v204 = (u155 and u154.MasteredActionTime or u154.ActionTime) * (1 - (u9:GetAttribute("CombatFluidity") or 1) / 100);
                            task.wait(v204);

                            if skillInUse3 == "Rasenshuriken" and u32.ActionAnim then
                                u32.ActionAnim:Stop();
                            end;

                            if u32.Settings.Stunned.Value == false then
                                Humanoid.WalkSpeed = u32.OriginSpeed;
                            end;
                        end;

                        if u32.Settings.Stunned.Value == false then
                            if u154.CanSkillRun or u154.CanSkillRunMastered and u155 then
                                u32.CanSkillRun = true;
                            end;

                            if u32.ActionAnim and (u154.ActionAnim and (u154.StartUpAnim or u154.Handsigns)) then
                                u32.ActionAnim = GameManager:getAnimation(u154.ActionAnim, Humanoid, Enum.AnimationPriority.Action3);

                                if u151 then
                                    u151 = u32.ActionAnim;
                                end;

                                u32.ActionAnim:Play();
                                local ActionAnim = u32.ActionAnim;
                                ActionAnim:AdjustSpeed((skillInUse3 == "Ice Skate" and 1.5 or ActionAnim.Speed) * (1 + (u9:GetAttribute("CombatFluidity") or 1) / 100));
                            end;

                            if u154.ActivateState and (u154.ActivateState == "Landed" and Humanoid:GetState() == Enum.HumanoidStateType.Freefall) then
                                local v205 = 0;

                                repeat
                                    v205 = v205 + wait(0.05);
                                until Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and u199 / 3 < v205 or v205 > 2;
                            else
                                v152 = u199 or (u32.ActionAnim and u32.ActionAnim.Length or 0.01);
                            end;
                        end;
                    end;

                    if u154.CustomWindup then
                        v152 = v152 + u154.CustomWindup;
                    end;

                    if u154.CustomRemainingTime then
                        v152 = u154.CustomRemainingTime;
                    end;

                    u31 = task.delay(v152, function() -- Line: 3116
                        -- upvalues: skillInUse2 (copy), u32 (ref), u154 (ref), u151 (ref), GameManager (ref), Humanoid (ref), u199 (ref), selectNewItem (ref), u11 (ref), Unselect (ref), HumanoidRootPart (ref), getOriginSpeed (ref), setRunSpeed (ref)
                        if skillInUse2 == "Butterfly Flight" and u32.InDanger == false then
                            task.wait(2);
                        end;

                        if skillInUse2 ~= "Improved Barrage" and skillInUse2 ~= "Lions Barrage" then
                            u32.Occupied = false;
                        end;

                        u32.Casting = false;

                        if u154.EndActionAnim then
                            local function stopAnim() -- Line: 3128
                                -- upvalues: u151 (ref), GameManager (ref), Humanoid (ref), skillInUse2 (ref), u32 (ref)
                                if u151 then
                                    if u151.Name == "SkillHold" or (u151.Name == "ArmRunningForward" or (u151.Name == "DoubleSkillHold" or u151.Name == "DoubleArmsRunningForward")) then
                                        GameManager:stopAnimation("SkillHold", Humanoid);
                                        GameManager:stopAnimation("ArmRunningForward", Humanoid);
                                        GameManager:stopAnimation("DoubleSkillHold", Humanoid);
                                        GameManager:stopAnimation("DoubleArmsRunningForward", Humanoid);
                                    end;

                                    u151:Stop();

                                    if skillInUse2 == u32.skillInUse then
                                        u32.ActionAnim = nil;
                                    end;
                                end;
                            end;

                            if u199 and u199 < u154.EndActionAnim then
                                task.delay(u154.EndActionAnim - u199, function() -- Line: 3146
                                    -- upvalues: stopAnim (copy)
                                    stopAnim();
                                end);
                            else
                                stopAnim();
                            end;
                        end;

                        if u154.CanDeactivate then
                            if u154.RequiresWeapon and not GameManager:inBaseCombat(u154.RequiresWeapon) then
                                if not u32.Selected or (not GameManager.Items[u32.Selected] or GameManager.Items[u32.Selected].CombatType ~= u154.RequiresWeapon[1]) then
                                    selectNewItem(u11, u11.CurrentWeapon);
                                end;
                            else
                                Unselect(u32.Selected);
                            end;
                        end;

                        if u154.Anchored == true then
                            HumanoidRootPart.Anchored = true;
                            HumanoidRootPart.Anchored = false;
                        end;

                        if u199 or u154.EndActionAnim then
                            u32.jumpBlocked = false;
                            u32.CanSkillRun = false;
                            u32.OriginSpeed = getOriginSpeed();
                            local v206 = u32;
                            v206.OriginSpeed = v206.OriginSpeed * (skillInUse2 == "Combat Fluidity" and 1.1 or 1);

                            if not game.Lighting:FindFirstChild("PerfectBlock") then
                                if u32.Running then
                                    setRunSpeed();
                                else
                                    Humanoid.WalkSpeed = u32.OriginSpeed;
                                end;

                                Humanoid.JumpPower = u32.OriginJump;
                            end;

                            u32.Casting = false;
                        end;
                    end);
                else
                    u32.Casting = false;
                    u32.skillInUse = "";
                end;
            end;
        end;
    end;
end;

if #u11.Traits > 0 then
    if u11.Traits[1] then
        LeftFrame.Trait1.Text = "- " .. u11.Traits[1];
    end;

    if u11.Traits[2] then
        LeftFrame.Trait2.Text = "- " .. u11.Traits[2];
    end;

    if u11.Traits[3] then
        LeftFrame.Trait3.Text = "- " .. u11.Traits[3];
    end;

    if u11.Traits[4] then
        LeftFrame.Trait4.Text = "- " .. u11.Traits[4];
    end;
end;

if #u11.Flaws > 0 then
    if u11.Flaws[1] then
        LeftFrame.Flaw1.Text = "- " .. u11.Flaws[1];
    end;

    if u11.Flaws[2] then
        LeftFrame.Flaw2.Text = "- " .. u11.Flaws[2];
    end;
end;

LeftFrame.Armor.Text = u11.Clothing;

local function UpdateLoadout(p207) -- Line: 3226
    -- upvalues: Inventory (copy), Loadout (copy), HideLoadoutSlots (copy), u32 (copy), GameManager (copy), u11 (ref)
    local v208 = 0;

    if p207 == "Normal" then
        Inventory.Visible = false;
        Loadout.RightFrame.Visible = false;
        Loadout.LeftFrame.Visible = false;
        Loadout.TopFrame.Visible = false;
        Loadout.SearchedItem.Visible = false;
    end;

    HideLoadoutSlots();

    for i = 1, 12 do
        for i2, v in next, u32.Loadout do
            if i2 == tostring(i) and v.Item ~= "" or i2 == tostring(i) and p207 == "Inventory" then
                local v209 = Loadout:FindFirstChild("Slot" .. i2);
                v208 = v208 + 1;
                local v210 = 0;

                if p207 == "Inventory" then
                    v210 = 12;
                else
                    for _, v2 in next, u32.Loadout do
                        if v2.Item ~= "" then
                            v210 = v210 + 1;
                        end;
                    end;
                end;

                v209.Position = UDim2.new(v208 * 0.1 + 0.45 - v210 * 0.05, 0, 0.5, 0);
                v209.Visible = true;

                if v.Item == "" then
                    v209.BackgroundTransparency = 1;
                    v209.Visible = false;
                    v209.SlotText.Text = "";
                    v209.Image = "";
                    v209.ItemNumber.Visible = false;

                    if p207 == "Inventory" then
                        v209.Visible = true;
                    end;
                elseif v.Quantity then
                    v209.BackgroundTransparency = 0;
                    v209.SlotText.Text = v.Item;
                    v209.Visible = true;
                    local v211 = GameManager:getImageId(v.Item);

                    if u11.ItemDisplayType == "Icon" and v211 ~= "" then
                        v209.Image = "rbxassetid://" .. v211;
                        v209.ImageColor3 = GameManager:getImageColor(v.Item);
                        v209.SlotText.TextTransparency = 1;
                    else
                        v209.SlotText.TextTransparency = 0;
                        v209.Image = "";
                    end;

                    if v.Quantity > 1 then
                        v209.ItemNumber.Visible = true;
                        v209.ItemNumber.Number.Text = "x" .. v.Quantity;
                    else
                        v209.ItemNumber.Number.Text = "x" .. 1;
                    end;
                end;

                v209.SlotNumber.Number.Text = u11.LoadoutKeybinds["Slot" .. i2].Keybind;
            end;
        end;
    end;
end;

local function UpdateInventory(p212) -- Line: 3280
    -- upvalues: HideInventorySlots (copy), UpdateLoadout (copy), Inventory (copy), Loadout (copy), u32 (copy), InventoryScroll (copy), GameManager (copy), u11 (ref)
    HideInventorySlots();

    if p212 then
        UpdateLoadout();
    else
        UpdateLoadout("Inventory");
    end;

    Inventory.Visible = true;
    Loadout.RightFrame.Visible = true;
    Loadout.LeftFrame.Visible = true;
    Loadout.TopFrame.Visible = true;
    local v213 = {
        ["1"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["2"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["3"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["4"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["5"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["6"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["7"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["8"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["9"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["10"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["11"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["12"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["13"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["14"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["15"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["16"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["17"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["18"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["19"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["20"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["21"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["22"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["23"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["24"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["25"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["26"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["27"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["28"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["29"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["30"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["31"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["32"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["33"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["34"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["35"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["36"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["37"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["38"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["39"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["40"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["41"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["42"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["43"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["44"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["45"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["46"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["47"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["48"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["49"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["50"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["51"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["52"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["53"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["54"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["55"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["56"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["57"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["58"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["59"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["60"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["61"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["62"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["63"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["64"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["65"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["66"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["67"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["68"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["69"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["70"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["71"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["72"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["73"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["74"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["75"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["76"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["77"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["78"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["79"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["80"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["81"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["82"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["83"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["84"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["85"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["86"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["87"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["88"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["89"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["90"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["91"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["92"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["93"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["94"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["95"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["96"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["97"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["98"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["99"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["100"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["101"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["102"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["103"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["104"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        },
        ["105"] = {
            Item = "",
            Quantity = 1,
            Data = {}
        }
    };
    local v214 = 0;

    for i = 1, 105 do
        local Item = u32.Inventory[tostring(i)].Item;
        local Quantity = u32.Inventory[tostring(i)].Quantity;
        local Data = u32.Inventory[tostring(i)].Data;

        if Item == "" then
            local v215 = InventoryScroll["InvSlot" .. i];
            v215.BackgroundTransparency = 0.95;
            v215.SlotBorder.Visible = false;
            v215.SlotText.Visible = false;
            v215.ItemNumber.Visible = false;
            v213[tostring(i)].Item = "";
        else
            v214 = v214 + 1;
            local v216 = InventoryScroll:FindFirstChild("InvSlot" .. v214);
            v216.SlotText.Text = Item;
            local v217 = GameManager:getImageId(Item);

            if u11.ItemDisplayType == "Icon" and v217 ~= "" then
                v216.Image = "rbxassetid://" .. v217;
                v216.ImageColor3 = GameManager:getImageColor(Item);
                v216.SlotText.TextTransparency = 1;
            else
                v216.SlotText.TextTransparency = 0;
                v216.Image = "";
            end;

            v216.BackgroundTransparency = 0;
            v216.SlotBorder.Visible = true;
            v213[tostring(v214)].Item = Item;
            v213[tostring(v214)].Quantity = Quantity;
            v213[tostring(v214)].Data = Data;
        end;

        InventoryScroll["InvSlot" .. i].ItemNumber.Visible = false;
        InventoryScroll["InvSlot" .. i].SlotText.Visible = true;
        InventoryScroll["InvSlot" .. i].Visible = true;
    end;

    u32.Inventory = v213;

    for i = 1, 105 do
        local Item = u32.Inventory[tostring(i)].Item;
        local Quantity = u32.Inventory[tostring(i)].Quantity;
        local _ = u32.Inventory[tostring(i)].Data;
        local v218 = InventoryScroll["InvSlot" .. i];

        if Item == "" then
            v218.SlotBorder.Visible = false;
            v218.SlotText.Text = "";
            v218.Image = "";
            v218.BackgroundTransparency = 0.95;
            v218.SlotText.Visible = false;
        else
            if Quantity > 1 then
                v218.ItemNumber.Visible = true;
                v218.ItemNumber.Number.Text = "x" .. Quantity;
            else
                v218.ItemNumber.Visible = false;
                v218.ItemNumber.Number.Text = "x" .. 1;
            end;

            local v219 = GameManager:getImageId(Item);

            if u11.ItemDisplayType == "Icon" and v219 ~= "" then
                v218.Image = "rbxassetid://" .. v219;
                v218.ImageColor3 = GameManager:getImageColor(Item);
                v218.SlotText.TextTransparency = 1;
            else
                v218.SlotText.TextTransparency = 0;
                v218.Image = "";
            end;
        end;

        v218.Visible = true;
    end;

    u32.InventorySlotCount = v214;
end;

loadInventory();
loadLoadout();
UpdateLoadout("Normal");

local function resetHoldings() -- Line: 3904
    -- upvalues: u32 (copy)
    if u32.HoldingForward > 0 then
        u32.HoldingForward = 1;
    end;

    if u32.HoldingRight > 0 then
        u32.HoldingRight = 1;
    end;

    if u32.HoldingLeft > 0 then
        u32.HoldingLeft = 1;
    end;

    if u32.HoldingBack > 0 then
        u32.HoldingBack = 1;
    end;
end;

local function compareHoldings(p220) -- Line: 3919
    -- upvalues: u32 (copy)
    local v221 = 0;

    if u32.HoldingForward < p220 then
        v221 = v221 + 1;
    end;

    if u32.HoldingRight < p220 then
        v221 = v221 + 1;
    end;

    if u32.HoldingLeft < p220 then
        v221 = v221 + 1;
    end;

    if u32.HoldingBack < p220 then
        v221 = v221 + 1;
    end;

    return v221 >= 3;
end;

RightFrame.MaxHealth.Text = "Max Health : " .. math.floor(Humanoid.MaxHealth);
RightFrame.MaxChakra.Text = "Max Chakra : " .. math.floor(maxChakra.Value);
Humanoid.HealthChanged:Connect(function(p222) -- Line: 3944
    -- upvalues: Health (copy), Humanoid (copy), RightFrame (copy), HUD (copy)
    Health:TweenSize(UDim2.new(p222 / Humanoid.MaxHealth, 0, 1, 0), "Out", "Quad", 0.2, true);
    RightFrame.MaxHealth.Text = "Max Health : " .. math.floor(Humanoid.MaxHealth);
    HUD.HealthTop.HealthAmount.Text = math.floor(Humanoid.Health) .. " / " .. math.floor(Humanoid.MaxHealth);
end);
chakra.Changed:Connect(function(p223) -- Line: 3950
    -- upvalues: Chakra (copy), maxChakra (copy), RightFrame (copy), HUD (copy), LocalPlayer (copy)
    Chakra:TweenSize(UDim2.new(p223 / maxChakra.Value, 0, 1, 0), "Out", "Quad", 0.2, true);
    Chakra:TweenPosition(UDim2.new(1 - p223 / maxChakra.Value, 0, 0, 0), "Out", "Quad", 0.2, true);
    RightFrame.MaxChakra.Text = "Max Chakra : " .. math.floor(maxChakra.Value);
    HUD.ChakraTop.ChakraAmount.Text = math.floor(LocalPlayer.Backpack.chakra.Value) .. " / " .. math.floor(maxChakra.Value);
end);
Health.Size = UDim2.new(Humanoid.Health / MaxHealth, 0, 1, 0);
Chakra.Size = UDim2.new(LocalPlayer.Backpack.chakra.Value / maxChakra.Value, 0, 1, 0);
Chakra.Position = UDim2.new(1 - LocalPlayer.Backpack.chakra.Value / maxChakra.Value);
LifeForce:WaitForChild("ImageLabel").MouseEnter:Connect(function() -- Line: 3961
    -- upvalues: LifeForce (copy)
    LifeForce.LifeForce.Visible = true;
    LifeForce.Percent.Visible = true;
end);
LifeForce.ImageLabel.MouseLeave:Connect(function() -- Line: 3966
    -- upvalues: LifeForce (copy)
    LifeForce.LifeForce.Visible = false;
    LifeForce.Percent.Visible = false;
end);
HUD.ChakraTop.Sealed.MouseEnter:Connect(function() -- Line: 3971
    -- upvalues: HUD (copy)
    HUD.ChakraTop.ChakraAmount.Visible = true;
end);
HUD.ChakraTop.Sealed.MouseLeave:Connect(function() -- Line: 3974
    -- upvalues: HUD (copy)
    HUD.ChakraTop.ChakraAmount.Visible = false;
end);
HUD.HealthTop.Sealed.MouseEnter:Connect(function() -- Line: 3978
    -- upvalues: HUD (copy)
    HUD.HealthTop.HealthAmount.Visible = true;
end);
HUD.HealthTop.Sealed.MouseLeave:Connect(function() -- Line: 3981
    -- upvalues: HUD (copy)
    HUD.HealthTop.HealthAmount.Visible = false;
end);
HUD.HealthTop.HealthAmount.Text = math.floor(Humanoid.Health) .. " / " .. math.floor(Humanoid.MaxHealth);
HUD.ChakraTop.ChakraAmount.Text = math.floor(LocalPlayer.Backpack.chakra.Value) .. " / " .. math.floor(maxChakra.Value);
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
Humanoid.StateChanged:connect(function(p224, p225) -- Line: 3992
    -- upvalues: u32 (copy), GameManager (copy), u11 (ref), u9 (copy), u48 (copy), disableRun (copy), DataFunction (copy), selectNewItem (copy), ReplicatedStorage (copy), LocalPlayer (copy), DataEvent (copy), Humanoid (copy)
    if p225 == Enum.HumanoidStateType.Freefall then
        u32.Falling = true;

        if GameManager.Clothing[u11.Clothing].FallAnim and u9:FindFirstChild(u11.Clothing) then
            local v226;

            if u9[u11.Clothing]:FindFirstChild("AC") then
                v226 = u9[u11.Clothing].AC;
            else
                v226 = u9[u11.Clothing].Original.AC;
            end;

            GameManager:getAnimation(GameManager.Clothing[u11.Clothing].FallAnim, v226):Play();
        end;
    elseif p225 == Enum.HumanoidStateType.Swimming then
        if u32.Running == true then
            if u11.Bloodline == "Hoshigaki" or (GameManager:hasImplantedArm(u11, "Torn Hoshigaki Arm") or u32.Settings.Awakened.Value == "Isobu Cloak") then
                u48.Swimming:Play();
                u48.Run:Stop();
            else
                disableRun();
            end;
        end;

        if u32.Selected == "Bowl" or (u32.Selected == "Torch" or u32.Selected == "InnKeeper\'s Letter") then
            local v227 = nil;
            local v228 = nil;

            if u32.Selected == "Bowl" then
                v227 = DataFunction:InvokeServer("WaterBowl");
                v228 = "Water Bowl";
            elseif u32.Selected == "Torch" then
                v227 = DataFunction:InvokeServer("WaterTorch");
            elseif u32.Selected == "InnKeeper\'s Letter" then
                v227 = DataFunction:InvokeServer("WaterLetter");
                v228 = "Soaked InnKeeper\'s Letter";
            end;

            if v228 then
                selectNewItem(v227, v228);
            end;
        end;

        if ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Fire") then
            DataEvent:FireServer("RemoveFireAilment");
        end;
    elseif p225 == Enum.HumanoidStateType.Landed then
        u32.fakeVaultCD = nil;
        u32.Falling = false;
        u32.Jumped = false;
        u32.jumpAmount = 0;
        u32.canDoubleJump = false;
        u32.hasDoubleJumped = false;
        u32.canTripleJump = false;

        if u32.Settings.Blocking.Value == true then
            Humanoid.JumpPower = 0;
        else
            Humanoid.JumpPower = u32.oldPower;
        end;

        if GameManager.Clothing[u11.Clothing].FallAnim and u9:FindFirstChild(u11.Clothing) then
            local v229;

            if u9[u11.Clothing]:FindFirstChild("AC") then
                v229 = u9[u11.Clothing].AC;
            else
                v229 = u9[u11.Clothing].Original.AC;
            end;

            GameManager:stopAnimation(GameManager.Clothing[u11.Clothing].FallAnim, v229);
        end;

        if u32.Knocked == true then
            Humanoid.PlatformStand = true;
            delay(0.5, function() -- Line: 4059
                -- upvalues: Humanoid (ref)
                Humanoid.PlatformStand = false;
            end);
        end;

        if u32.SpinningHumanBoulder == "Jumping" then
            u32.SpinningHumanBoulder = true;
            Humanoid.JumpPower = 90;
        end;
    end;

    if u32.Running == true and (p225 ~= Enum.HumanoidStateType.Swimming and (u11.Bloodline == "Hoshigaki" or (GameManager:hasImplantedArm(u11, "Torn Hoshigaki Arm") or u32.Settings.Awakened.Value == "Isobu Cloak"))) then
        if not u32.Dashing then
            Humanoid.WalkSpeed = u32.OriginSpeed + 12;
        end;

        u48.Swimming:Stop();

        if u11.Bloodline == "Otsutsuki" and u9:GetAttribute("otsuAnimations") then
            return;
        end;

        u48.Run:Play();
    end;
end);
u32.Settings:WaitForChild("JumpCounters").Changed:Connect(function(p230) -- Line: 4091
    -- upvalues: JumpCounters (copy)
    for _, child in ipairs(JumpCounters:GetChildren()) do
        if tonumber(child.Name) <= p230 then
            child.Visible = true;
        else
            child.Visible = false;
        end;
    end;
end);
u32.Settings:WaitForChild("FoodCounters").Changed:Connect(function(p231) -- Line: 4101
    -- upvalues: FoodCounters (copy)
    for _, child in ipairs(FoodCounters:GetChildren()) do
        if tonumber(child.Name) then
            if p231 < tonumber(child.Name) then
                child.Visible = false;
            else
                child.Visible = true;
            end;
        end;
    end;
end);

for i = 1, u32.Settings.JumpCounters.Value do
    JumpCounters[tostring(i)].Visible = true;
end;

for i = 1, u32.Settings.FoodCounters.Value do
    FoodCounters[tostring(i)].Visible = true;
end;

if u11.Reanimated then
    for _, child in ipairs(FoodCounters:GetChildren()) do
        child.ImageColor3 = Color3.fromRGB();
    end;
end;

local function HeavyAttack() -- Line: 4128
    -- upvalues: u32 (copy), u9 (copy), GameManager (copy), Humanoid (copy), HumanoidRootPart (copy), u11 (ref), u10 (copy), DataEvent (copy), disableRun (copy), LocalPlayer (copy)
    if u32.Broken ~= false or (u32.Settings.CurrentSkill.Value ~= "" or (tick() - u32.MeleeCooldown <= 0.1 or (u32.Consuming ~= false or (u32.Settings.HeavyCooldown.Value ~= false or (u32.Settings.MeleeCooldown.Value ~= false or (u32.Occupied ~= false or (u32.Settings.Stunned.Value ~= false or (u32.Settings.Blocking.Value ~= false or (u32.Settings.Gripping.Value ~= "None" or (u32.Knocked ~= false or (u32.Dashing ~= false or (u9:GetAttribute("KotoamatsukamiForceMove") or u9:GetAttribute("KotoamatsukamiAttacking"))))))))))))) then
        local _ = tick() - u32.MeleeCooldown <= 0.1;
        local _ = u32.Settings.MeleeCooldown.Value == true;
        local _ = u32.Occupied == true;
        local _ = u32.Carrying == true;
        local _ = u32.Knocked == true;

        return;
    end;

    u32.MeleeCooldown = tick();
    u32.Occupied = true;
    u32.CombatType = u32.Settings.CombatType.Value;
    u32.CombatTable = GameManager:getCombatTable(u32.CombatType);
    local v232 = u32.Falling == true and (Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming and (GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)).p, u9, "Hit") == false and GameManager:hasSkill(u11, "Aerial Heavy Attack"))) and "Air" or nil or "Ground";

    if v232 == "Ground" and (u9:GetAttribute("GunbaiCharged") and (u11.CurrentWeapon == "Gunbai" or (u11.CurrentWeapon == "Spider Gunbai" or u11.CurrentWeapon == "Gingerbread Gunbai"))) and u10.CombatType.Value == "Greatsword" then
        DataEvent:FireServer("startSkill", "Gunbai Twister");
    else
        DataEvent:FireServer("CheckMeleeHit", v232, "HeavyAttack");
    end;

    local v233, v234 = GameManager:getAnimation(u32.CombatTable.HeavyAttack[v232].Animation, Humanoid, Enum.AnimationPriority.Action3);
    v233:Play();

    if v234 then
        v233:AdjustSpeed(v234);
    end;

    v233:AdjustSpeed(v233.Speed * (1 + (u9:GetAttribute("CombatFluidity") or 1) / 100));
    u32.ActionTime = u32.CombatTable.HeavyAttack[v232].ActionTime;

    if v232 == "Air" then
        if GameManager:searchInList(u11.Traits, "Airborne") then
            GameManager:createBodyVelocity(HumanoidRootPart, (HumanoidRootPart.Position - (HumanoidRootPart.CFrame * u32.CombatTable.HeavyAttack[v232].Direction).p).unit, u32.CombatTable.HeavyAttack[v232].Speed * GameManager.Traits.Airborne.SpeedDiff, 0.3 / GameManager.Traits.Airborne.SpeedDiff, "AttackBV", Vector3.new(1, 1, 1));
        else
            GameManager:createBodyVelocity(HumanoidRootPart, (HumanoidRootPart.Position - (HumanoidRootPart.CFrame * u32.CombatTable.HeavyAttack[v232].Direction).p).unit, u32.CombatTable.HeavyAttack[v232].Speed, 0.3, "AttackBV", Vector3.new(1, 1, 1));
        end;
    end;

    wait(u32.ActionTime);

    if u32.Running == true then
        disableRun("Stop");
    end;

    if u32.Settings.Stunned.Value ~= false then
        u32.Occupied = false;

        return;
    end;

    local v235 = GameManager:createRegion3((HumanoidRootPart.CFrame * u32.CombatTable.Point1).p, (HumanoidRootPart.CFrame * u32.CombatTable.Point2).p);
    local v236 = false;

    for _, v in pairs(game.Workspace:FindPartsInRegion3(v235, nil, (1 / 0))) do
        if v.Parent then
            local v237 = v.Parent:FindFirstChild("Settings") and v.Parent.Settings:FindFirstChild("NPC") and true or false;

            if (game.Players:FindFirstChild(v.Parent.Name) or v237 == true) and (v236 == false and (v.Parent:FindFirstChild("Humanoid") and v.Parent.Name ~= LocalPlayer.Name)) then
                GameManager:CameraShake(u9, 2, 0.25);
                v236 = true;
            end;
        end;
    end;
end;

local function finishDrag() -- Line: 4242
    -- upvalues: u32 (copy), RunService (copy)
    u32.Dragging.Visible = false;
    u32.Dragging.ItemNumber.Visible = false;
    u32.Dragging.ZIndex = 9;
    u32.oldInfo = nil;
    u32.oldQuantity = nil;
    u32.oldItemData = nil;
    u32.holding = 0;
    u32.prevHoldingSlot = 0;
    RunService:UnbindFromRenderStep("slotdrag");
end;

local function closeInventory(p238) -- Line: 4254
    -- upvalues: UpdateLoadout (copy), Loadout (copy), u32 (copy), GameManager (copy), u11 (ref), RunService (copy)
    UpdateLoadout("Normal");

    if p238 and not Loadout:FindFirstChild("SharinganHUD") then
        Loadout.HUD.Visible = true;
    end;

    if u32.holding ~= 0 and u32.oldInfo then
        u32.prevHoldingSlot.SlotText.Text = u32.oldInfo;
        u32.prevHoldingSlot.SlotText.Visible = true;
        local v239 = GameManager:getImageId(u32.prevHoldingSlot.SlotNum.Value);

        if u11.ItemDisplayType == "Icon" and (v239 and v239 ~= "") then
            u32.prevHoldingSlot.Image = "rbxassetid://" .. v239;
            u32.ImageColor3 = GameManager:getImageColor(u32.prevHoldingSlot.SlotNum.Value);
            u32.prevHoldingSlot.SlotText.TextTransparency = 1;
        else
            u32.prevHoldingSlot.SlotText.TextTransparency = 0;
            u32.prevHoldingSlot.Image = "";
        end;

        u32.prevHoldingSlot.BackgroundTransparency = 0;
        u32.prevHoldingSlot.SlotBorder.Visible = true;
        u32.Dragging.Visible = false;
        u32.Dragging.ItemNumber.Visible = false;
        u32.Dragging.ZIndex = 9;
        u32.oldInfo = nil;
        u32.oldQuantity = nil;
        u32.oldItemData = nil;
        u32.holding = 0;
        u32.prevHoldingSlot = 0;
        RunService:UnbindFromRenderStep("slotdrag");
    end;
end;

local function hideHovers() -- Line: 4278
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;
end;

local function TweenOutCurrentPage() -- Line: 4289
    -- upvalues: u32 (copy), TravelFrame (copy), Rest (copy), SettingsFrame (copy), TitlesFrame (copy), ServerList (copy), DestroyFrame (copy), SkillsFrame (copy), SkillView (copy), MainMenuFrame (copy)
    if u32.CurrentPage == "Travel" then
        TravelFrame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
        wait(0.5);

        for _, descendant in TravelFrame.Locations:GetDescendants() do
            if descendant.Name == "LocationSelect" then
                descendant.Visible = false;
            end;
        end;

        TravelFrame.LocationImage.Image = "";

        return;
    end;

    if u32.CurrentPage == "Settings" then
        SettingsFrame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
        wait(0.5);

        return;
    end;

    if u32.CurrentPage == "Titles" then
        TitlesFrame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
        wait(0.5);

        return;
    end;

    if u32.CurrentPage == "Servers" then
        ServerList:TweenPosition(UDim2.new(1.1, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
        wait(0.5);

        return;
    end;

    if u32.CurrentPage ~= "Destroy" then
        if u32.CurrentPage == "Skills" then
            SkillsFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.Return.Visible = false;
            Rest.Return.ButtonHover.Visible = true;
            wait(0.5);
            SkillView.Visible = false;
            Rest.Return.ButtonHover.Visible = false;
            SkillsFrame.Visible = false;
            MainMenuFrame.Travel.ButtonHover.Visible = false;
            MainMenuFrame.Skills.ButtonHover.Visible = false;
            MainMenuFrame.Settings.ButtonHover.Visible = false;
            MainMenuFrame.Titles.ButtonHover.Visible = false;
            MainMenuFrame.Servers.ButtonHover.Visible = false;
            MainMenuFrame.Leave.ButtonHover.Visible = false;
            MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
            TravelFrame.Travel.ButtonHover.Visible = false;
            MainMenuFrame:TweenPosition(UDim2.new(0.04, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
            u32.ChangingPage = false;
        end;

        return;
    end;

    DestroyFrame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "Out", "Quad", 0.5, true);
    Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
    wait(0.5);
end;

local function ChangePage(p240, p241) -- Line: 4332
    -- upvalues: u32 (copy), TweenOutCurrentPage (copy), TravelFrame (copy), Rest (copy), SettingsFrame (copy), TitlesFrame (copy), ServerList (copy), DestroyFrame (copy), SkillsFrame (copy), MainMenuFrame (copy)
    u32.ChangingPage = true;

    if u32.CurrentPage ~= "" then
        TweenOutCurrentPage();
    end;

    if p240 then
        u32.CurrentPage = p240;

        if p240 == "Travel" then
            TravelFrame:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage.PlaceName.Text = u32.CurrentChakraPoint.PointName.Value;
            TravelFrame.Travel.Visible = false;

            for _, descendant in TravelFrame.Locations:GetDescendants() do
                if descendant.Name == "LocationSelect" then
                    descendant.Visible = false;
                end;
            end;

            TravelFrame.LocationImage.Image = "";
            u32.SelectedLocation = "";
            wait(0.5);
        elseif p240 == "Settings" then
            SettingsFrame:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
            wait(0.5);
        elseif p240 == "Titles" then
            TitlesFrame:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
            wait(0.5);
        elseif p240 == "Servers" then
            ServerList:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
            wait(0.5);
        elseif p240 == "Destroy" then
            print("went into destroy page");
            DestroyFrame:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
            DestroyFrame.DestroyPoint.Visible = true;
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
            wait(0.5);
        elseif p240 == "Skills" then
            SkillsFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
            SkillsFrame.Size = UDim2.new(0, 0, 0, 0);
            SkillsFrame.Visible = true;
            MainMenuFrame:TweenPosition(UDim2.new(-0.4, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
            wait(0.5);
            SkillsFrame:TweenSize(UDim2.new(5, 0, 5, 0), "Out", "Quad", 0.5, true);
            wait(0.5);
            Rest.Return.Visible = true;
        end;

        u32.ChangingPage = false;
    end;
end;

local function MenuTween(p242) -- Line: 4385
    -- upvalues: MainMenuFrame (copy), Rest (copy)
    if p242 ~= "In" then
        if p242 == "Out" then
            MainMenuFrame:TweenPosition(UDim2.new(-0.4, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
        end;

        return;
    end;

    MainMenuFrame:TweenPosition(UDim2.new(0.04, 0, 0, 0), "Out", "Quad", 0.5, true);
    Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
end;

MainMenuFrame.Travel.MouseButton1Down:Connect(function() -- Line: 4395
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), u6 (ref), ChangePage (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if u32.ChangingPage == false and u32.CurrentPage ~= "Travel" then
        MainMenuFrame.Travel.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        ChangePage("Travel");
    end;
end);
MainMenuFrame.Titles.MouseButton1Down:Connect(function() -- Line: 4404
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), u6 (ref), TweenOutCurrentPage (copy), TitlesFrame (copy), Rest (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if u32.ChangingPage == false and u32.CurrentPage ~= "Titles" then
        MainMenuFrame.Titles.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        u32.ChangingPage = true;

        if u32.CurrentPage ~= "" then
            TweenOutCurrentPage();
        end;

        u32.CurrentPage = "Titles";
        TitlesFrame:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
        wait(0.5);
        u32.ChangingPage = false;
    end;
end);
MainMenuFrame.Servers.MouseButton1Down:Connect(function() -- Line: 4413
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), u6 (ref), TweenOutCurrentPage (copy), ServerList (copy), Rest (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if u32.ChangingPage == false and u32.CurrentPage ~= "Servers" then
        MainMenuFrame.Servers.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        u32.ChangingPage = true;

        if u32.CurrentPage ~= "" then
            TweenOutCurrentPage();
        end;

        u32.CurrentPage = "Servers";
        ServerList:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
        wait(0.5);
        u32.ChangingPage = false;
    end;
end);
MainMenuFrame.Settings.MouseButton1Down:Connect(function() -- Line: 4422
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), u6 (ref), TweenOutCurrentPage (copy), SettingsFrame (copy), Rest (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if u32.ChangingPage == false and u32.CurrentPage ~= "Settings" then
        MainMenuFrame.Settings.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        u32.ChangingPage = true;

        if u32.CurrentPage ~= "" then
            TweenOutCurrentPage();
        end;

        u32.CurrentPage = "Settings";
        SettingsFrame:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
        wait(0.5);
        u32.ChangingPage = false;
    end;
end);
MainMenuFrame.Skills.MouseButton1Down:Connect(function() -- Line: 4431
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), u6 (ref), ChangePage (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if u32.ChangingPage == false and u32.CurrentPage ~= "Skills" then
        MainMenuFrame.Skills.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        ChangePage("Skills");
    end;
end);
Rest.Return.MouseButton1Down:Connect(function() -- Line: 4440
    -- upvalues: u32 (copy), u6 (ref), ChangePage (copy)
    if u32.ChangingPage == false and u32.CurrentPage == "Skills" then
        u6.MainButtonClick:Play();
        ChangePage();
        u32.CurrentPage = "";
    end;
end);
MainMenuFrame.DestroyButton.MouseButton1Down:Connect(function() -- Line: 4448
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), u6 (ref), TweenOutCurrentPage (copy), DestroyFrame (copy), Rest (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if u32.ChangingPage == false and u32.CurrentPage ~= "Destroy" then
        MainMenuFrame.DestroyButton.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        u32.ChangingPage = true;

        if u32.CurrentPage ~= "" then
            TweenOutCurrentPage();
        end;

        u32.CurrentPage = "Destroy";
        print("went into destroy page");
        DestroyFrame:TweenPosition(UDim2.new(0.55, 0, 0, 0), "Out", "Quad", 0.5, true);
        DestroyFrame.DestroyPoint.Visible = true;
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
        wait(0.5);
        u32.ChangingPage = false;
    end;
end);

if u11.Bloodline ~= "Otsutsuki" and #u11.DestroyedChakraPoints >= 4 or #u11.DestroyedChakraPoints >= 5 and u11.Bloodline == "Otsutsuki" then
    MainMenuFrame.DestroyButton.Visible = false;
end;

MainMenuFrame.Leave.MouseButton1Down:Connect(function() -- Line: 4461
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), u7 (copy), DataFunction (copy), DataEvent (copy), u11 (ref), u6 (ref), Rest (copy), ChangePage (copy), Humanoid (copy), GameManager (copy), LoadoutKeybinds (copy), Loadout (copy), u58 (copy), Ryo (copy), Embers (copy), PlayerList (copy), HumanoidRootPart (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if u32.ChangingPage == false and u7 == "Main" then
        if not u32.CurrentChakraPoint then
            print("there is no v.CurrentChakraPoint");

            return;
        end;

        if DataFunction:InvokeServer("ChakraPointStand", u32.CurrentChakraPoint) then
            DataEvent:FireServer("UpdateSettings", {
                u11.ItemDisplayType,
                u11.GraphicsLevel,
                u11.FOV,
                u11.Footsteps,
                u11.InstantCast,
                u11.Tilt,
                u11.HighQRain,
                u11.VisibleCooldowns
            });
            MainMenuFrame.Leave.ButtonHover.Visible = true;
            u6.MainButtonClick:Play();
            u32.ChangingPage = true;
            u6.ChakraPointStand:Play();
            u32.CurrentChakraPoint.Main.ChakraSmoke.Enabled = false;
            MainMenuFrame:TweenPosition(UDim2.new(-0.4, 0, 0, 0), "Out", "Quad", 0.5, true);
            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
            ChangePage();

            for i = -0.5, -1, -0.01 do
                Rest.BackDrop.BackgroundTransparency = i * -1;
                game.Lighting.PointBlur.Size = game.Lighting.PointBlur.Size - 0.5;
                task.wait();
            end;

            Rest.BackDrop.BackgroundTransparency = 1;
            game.Lighting.PointBlur:Destroy();
            u32.Occupied = false;
            u6.ChakraPointLoop:Stop();
            Humanoid.AutoRotate = true;
            u32.Occupied = false;
            GameManager:stopAnimation("SittingCrossLegged", Humanoid);
            Rest.Visible = false;
            u11.LoadoutKeybinds = LoadoutKeybinds;

            for i, _ in next, u32.Loadout do
                Loadout["Slot" .. i].SlotNumber.Number.Text = u11.LoadoutKeybinds["Slot" .. i].Keybind;
            end;

            DataEvent:FireServer("SaveSlots", u11.LoadoutKeybinds);

            if u58.CinematicMode == "Off" and u32.HUDHidden == false then
                Loadout.Visible = true;
                Loadout.HUD.Visible = true;
                Ryo.Visible = true;
                Embers.Visible = u11.Embers > 0;
            else
                PlayerList.Visible = false;
                Ryo.Visible = false;
                Embers.Visible = false;
            end;

            HumanoidRootPart.Anchored = false;
            u32.CurrentChakraPoint = nil;
            MainMenuFrame.Leave.ButtonHover.Visible = false;
            u32.CurrentPage = "";
        end;
    else
        print("v.Changing Page is true");
    end;
end);

if u11.Quests["A Run For Your Life"] and (string.match(u11.Quests["A Run For Your Life"].Progress, "Finished") == "Finished" and workspace:FindFirstChild("The Scarlet Slowcoach")) then
    print(" HAS ALREADY COMPLETED RUN FOR YOUR LIFE NOW DESTROYING NPC");
    workspace["The Scarlet Slowcoach"]:Destroy();
end;

if u11.Quests["Parkour Training"] and string.match(u11.Quests["Parkour Training"].Progress, "Finished") == "FinishedBad" then
    local v243 = workspace["Training Instructor"];
    GameManager:getAnimation("StunnedKneeling", (v243:WaitForChild("Humanoid"))):Play();
    GameManager:sealingStun(v243.HumanoidRootPart);
end;

if u11.Quests["Bracelet Retrieval"] and (string.match(u11.Quests["Bracelet Retrieval"].Progress, "Finished") == "Finished" and workspace:FindFirstChild("The Deprived Damsel")) then
    workspace["The Deprived Damsel"]:Destroy();
    workspace.DeprivedDamselLines.Transparency = 0.2;
end;

if u11.Quests["A Search For A Flaming Heart"] and (string.match(u11.Quests["A Search For A Flaming Heart"].Progress, "Finished") == "Finished" and (workspace:FindFirstChild("Bob") and workspace:FindFirstChild("Bob"))) then
    workspace.Bob:Destroy();
end;

if u11.Quests["Reaver\'s Revenge"] and (string.match(u11.Quests["Reaver\'s Revenge"].Progress, "Finished") == "Finished" and (workspace:FindFirstChild("The Reanimated Reaver") and workspace:FindFirstChild("The Reanimated Reaver"))) then
    workspace["The Reanimated Reaver"]:Destroy();
end;

if u11.FirstZetsu and u11.FirstZetsu == true then
    workspace["The 1st Zetsu"].Shirt.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 1st Zetsu"].Pants.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 1st Zetsu"].FakeHead.Color = Color3.fromRGB(50, 50, 50);
    GameManager:getAnimation("ZetsuActivated", workspace["The 1st Zetsu"].Humanoid):Play();
end;

if u11.SecondZetsu and u11.SecondZetsu == true then
    workspace["The 2nd Zetsu"].Shirt.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 2nd Zetsu"].Pants.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 2nd Zetsu"].FakeHead.Color = Color3.fromRGB(50, 50, 50);
    GameManager:getAnimation("ZetsuActivated", workspace["The 2nd Zetsu"].Humanoid):Play();
end;

if u11.ThirdZetsu and u11.ThirdZetsu == true then
    workspace["The 3rd Zetsu"].Shirt.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 3rd Zetsu"].Pants.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 3rd Zetsu"].FakeHead.Color = Color3.fromRGB(50, 50, 50);
    GameManager:getAnimation("ZetsuActivated", workspace["The 3rd Zetsu"].Humanoid):Play();
end;

if u11.FourthZetsu and u11.FourthZetsu == true then
    workspace["The 4th Zetsu"].Shirt.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 4th Zetsu"].Pants.Color3 = Color3.fromRGB(50, 50, 50);
    workspace["The 4th Zetsu"].FakeHead.Color = Color3.fromRGB(50, 50, 50);
    GameManager:getAnimation("ZetsuActivated", workspace["The 4th Zetsu"].Humanoid):Play();
end;

local function activateShark(p244) -- Line: 4577
    p244.Color = Color3.fromRGB(51, 88, 130);
    p244.Material = "Neon";
    p244.Transparency = 0.5;
end;

local function updateSharks() -- Line: 4583
    -- upvalues: u11 (ref)
    if u11.WaterXP and u11.WaterXP >= 150 then
        local XPShark = workspace:WaitForChild("XPShark");
        XPShark.Color = Color3.fromRGB(51, 88, 130);
        XPShark.Material = "Neon";
        XPShark.Transparency = 0.5;
    end;

    if u11.Quests["Quenching Thirst"] and u11.Quests["Quenching Thirst"].Progress:find("FinishedGood") then
        local SharkmanShark = workspace:WaitForChild("SharkmanShark");
        SharkmanShark.Color = Color3.fromRGB(51, 88, 130);
        SharkmanShark.Material = "Neon";
        SharkmanShark.Transparency = 0.5;
    end;

    if u11.Quests["A Run For Your Life"] and u11.Quests["A Run For Your Life"].Progress:find("FinishedBad") then
        local ScarletShark = workspace:WaitForChild("ScarletShark");
        ScarletShark.Color = Color3.fromRGB(51, 88, 130);
        ScarletShark.Material = "Neon";
        ScarletShark.Transparency = 0.5;
    end;

    if u11.SwimTime > 300 then
        local SwimmingShark = workspace:WaitForChild("SwimmingShark");
        SwimmingShark.Color = Color3.fromRGB(51, 88, 130);
        SwimmingShark.Material = "Neon";
        SwimmingShark.Transparency = 0.5;
    end;
end;

if u11.Bloodline == "Hoshigaki" then
    updateSharks();
end;

local function sharksActivated() -- Line: 4602
    return workspace.XPShark.Transparency == 0.5 and (workspace.SwimmingShark.Transparency == 0.5 and (workspace.ScarletShark.Transparency == 0.5 and workspace.SharkmanShark.Transparency == 0.5));
end;

local function activateChain(p245) -- Line: 4609
    p245.Color = Color3.fromRGB(253, 234, 141);
end;

local function updateChains() -- Line: 4615
    -- upvalues: u11 (ref)
    if u11.SealingXP and u11.SealingXP >= 100 then
        workspace:WaitForChild("XPChain").Color = Color3.fromRGB(253, 234, 141);
    end;

    if u11.Quests["Parkour Training"] and u11.Quests["Parkour Training"].Progress:find("FinishedBad") or u11.BellsDrop == true then
        workspace:WaitForChild("QuestChain").Color = Color3.fromRGB(253, 234, 141);
    end;

    if u11.ReanimatedSoul == true then
        workspace:WaitForChild("SoulChain").Color = Color3.fromRGB(253, 234, 141);
    end;

    if u11.ButtonChain == true then
        workspace:WaitForChild("ButtonChain").Color = Color3.fromRGB(253, 234, 141);
    end;

    if workspace.XPChain.Color == Color3.fromRGB(253, 234, 141) and (workspace.QuestChain.Color == Color3.fromRGB(253, 234, 141) and (workspace.SoulChain.Color == Color3.fromRGB(253, 234, 141) and workspace.ButtonChain.Color == Color3.fromRGB(253, 234, 141))) then
        workspace["Uzumaki Heirloom"].Color = Color3.fromRGB(253, 234, 141);
    end;
end;

if u11.Bloodline == "Uzumaki" then
    updateChains();
end;

local function chainsActivated() -- Line: 4637
    return workspace.XPChain.Color == Color3.fromRGB(253, 234, 141) and (workspace.QuestChain.Color == Color3.fromRGB(253, 234, 141) and (workspace.SoulChain.Color == Color3.fromRGB(253, 234, 141) and workspace.ButtonChain.Color == Color3.fromRGB(253, 234, 141)));
end;

local function clearViewSkill() -- Line: 4651
    -- upvalues: SkillView (copy)
    SkillView.Back:WaitForChild("Required1Image").Image = "";
    SkillView.Back:WaitForChild("Required2Image").Image = "";
    SkillView.Back:WaitForChild("Required3Image").Image = "";
    SkillView.Back:WaitForChild("Required1").Text = "";
    SkillView.Back:WaitForChild("Required2").Text = "";
    SkillView.Back:WaitForChild("Required3").Text = "";
end;

local function viewSkill(p246) -- Line: 4660
    -- upvalues: u6 (ref), clearViewSkill (copy), GameManager (copy), u11 (ref), SkillView (copy)
    u6.ButtonSelect:Play();
    clearViewSkill();
    local Text = p246.SlotText.Text;

    if GameManager:isSkillBlocked(u11, Text) then
        SkillView.Unlock.Visible = false;
        SkillView.Back.Required.Text = "Permalocked";
        SkillView.Back.Description.Text = skillsModule[Text].Description;
    elseif GameManager:hasSkill(u11, Text) then
        SkillView.Unlock.Visible = false;
        SkillView.Back.Required.Text = "Owned";
    else
        SkillView.Unlock.Visible = true;
        SkillView.Back.Required.Text = "Required : ";
    end;

    if skillsModule[Text] then
        SkillView.Visible = true;
        SkillView.HeaderBack.Header.Text = Text;

        if not GameManager:isSkillBlocked(u11, Text) then
            SkillView.Back.Description.Text = skillsModule[Text].Description;
            local v247 = 1;

            for i, v in next, skillsModule[Text].Requirements do
                if i == "Ryo" then
                    SkillView.Back.Required1Image.Image = "rbxassetid://" .. GameManager.UI.RyoSign;
                    SkillView.Back.Required1Image.ImageColor3 = Color3.fromRGB(255, 235, 131);
                    SkillView.Back.Required1.Text = v;
                elseif i == "Acumen" then
                    SkillView.Back.Required1Image.Image = "rbxassetid://" .. GameManager.UI.RyoSign;
                    SkillView.Back.Required1Image.ImageColor3 = Color3.fromRGB(255, 128, 190);
                    SkillView.Back.Required1.Text = v;
                elseif GameManager.Items[i] then
                    v247 = v247 + 1;
                    SkillView.Back["Required" .. v247 .. "Image"].Image = "rbxassetid://" .. GameManager.Items[i].ID;
                    SkillView.Back["Required" .. v247 .. "Image"].ImageColor3 = GameManager:getImageColor(i);

                    if v == true then
                        SkillView.Back["Required" .. v247].Text = i;
                    else
                        SkillView.Back["Required" .. v247].Text = i .. " x" .. v;
                    end;
                elseif i == "Unknown" then
                    SkillView.Back.Required1.Text = "???";
                end;
            end;
        end;
    end;
end;

SkillView.Unlock.MouseButton1Down:Connect(function() -- Line: 4708
    -- upvalues: DataFunction (copy), SkillView (copy), updateSkills (copy), clearViewSkill (copy), u6 (ref)
    if DataFunction:InvokeServer("UnlockSkill", SkillView.HeaderBack.Header.Text) then
        updateSkills();
        clearViewSkill();
        u6.SellMultiple:Play();
        SkillView.Unlock.Visible = false;
    end;
end);

local function hasTeleported(p248) -- Line: 4720
    -- upvalues: MainMenuFrame (copy), TravelFrame (copy), u32 (copy), HumanoidRootPart (copy), Rest (copy), GameManager (copy), Humanoid (copy), ReplicatedStorage (copy), u6 (ref), DataEvent (copy), Inventory (copy), closeInventory (copy), Loadout (copy)
    MainMenuFrame.Travel.ButtonHover.Visible = false;
    MainMenuFrame.Skills.ButtonHover.Visible = false;
    MainMenuFrame.Settings.ButtonHover.Visible = false;
    MainMenuFrame.Titles.ButtonHover.Visible = false;
    MainMenuFrame.Servers.ButtonHover.Visible = false;
    MainMenuFrame.Leave.ButtonHover.Visible = false;
    MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
    TravelFrame.Travel.ButtonHover.Visible = false;

    if p248 then
        u32.CurrentChakraPoint = p248;
    else
        for _, child in ipairs(workspace.ChakraPoints:GetChildren()) do
            p248 = child;
        end;

        print();
    end;

    u32.CurrentChakraPoint = p248;
    HumanoidRootPart.Anchored = true;
    Rest.Visible = true;
    u32.Occupied = true;
    MainMenuFrame.Visible = true;
    Rest.TitleImage.Visible = true;
    Rest.TitleImage.PlaceName.Text = u32.CurrentChakraPoint.PointName.Value;
    GameManager:getAnimation("SittingCrossLegged", Humanoid):Play();
    local _ = u32.CurrentChakraPoint.PointName.Value;
    MainMenuFrame:TweenPosition(UDim2.new(0.04, 0, 0, 0), "Out", "Quad", 0.5, true);
    Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
    u32.SelectedLocation = "";
    local Position = CFrame.new(u32.CurrentChakraPoint.Main.Position.X, HumanoidRootPart.Position.Y, u32.CurrentChakraPoint.Main.Position.Z).Position;
    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, Position);
    u32.CurrentChakraPoint.Main.ChakraSmoke.Enabled = true;
    ReplicatedStorage.UI.PointBlur:Clone().Parent = game.Lighting;
    game.Lighting.PointBlur.Enabled = true;
    Rest.BackDrop.BackgroundTransparency = 1;
    Rest.BackDrop.Visible = true;
    u6.ChakraPointSit:Play();
    DataEvent:FireServer("SetLastChakraPoint", u32.CurrentChakraPoint.PointName.Value);
    Humanoid.AutoRotate = false;

    if Inventory.Visible == true then
        closeInventory();
    else
        Loadout.HUD.Visible = false;
    end;

    Loadout.Visible = false;

    for i = 1, 0.5, -0.02 do
        Rest.BackDrop.BackgroundTransparency = i;
        game.Lighting.PointBlur.Size = game.Lighting.PointBlur.Size + 1;
        task.wait();
    end;

    game.Lighting.PointBlur.Size = 24;
    u6.ChakraPointLoop:Play();
    u32.ChangingPage = false;
end;

DestroyFrame:WaitForChild("DestroyPoint").MouseButton1Down:Connect(function() -- Line: 4768
    -- upvalues: GameManager (copy), u11 (ref), DataFunction (copy), u32 (copy), TravelFrame (copy), u6 (ref), MainMenuFrame (copy), Rest (copy), ChangePage (copy), Humanoid (copy), u58 (copy), Loadout (copy), Ryo (copy), Embers (copy), PlayerList (copy), HumanoidRootPart (copy), updateTeleportLocations (copy), DestroyFrame (copy)
    if GameManager:hasItem(u11, "Chakra Fragments") and u11.Ryo >= 100 then
        if not DataFunction:InvokeServer("DestroyChakraPoint", u32.CurrentChakraPoint) then
            DestroyFrame.AgeCondition.Visible = true;
            wait(5);
            DestroyFrame.AgeCondition.Visible = false;

            return;
        end;

        u32.CurrentChakraPoint.Main.Transparency = 1;
        u32.CurrentChakraPoint.OuterShard.Transparency = 1;
        u32.CurrentChakraPoint.Main.CanCollide = false;
        u32.CurrentChakraPoint.OuterShard.CanCollide = false;
        u32.CurrentChakraPoint.InnerPool.Color = Color3.new(0, 0, 0);

        for _, child in u32.CurrentChakraPoint:GetChildren() do
            if child.Name == "ShardBeam" or child.Name == "ShardArea" then
                child:Destroy();
            end;
        end;

        GameManager:generateDebris(u32.CurrentChakraPoint.Main.Position, "FIXEDSETTINGS", "ChakraBlock", 2, 4);
        TravelFrame.Travel.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        u32.ChangingPage = true;
        u6.ChakraPointStand:Play();
        u32.CurrentChakraPoint.Main.ChakraSmoke.Enabled = false;
        u32.CurrentChakraPoint.Main.GUI.Msg.Text = "[Destroyed]";
        MainMenuFrame:TweenPosition(UDim2.new(-0.4, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
        ChangePage();

        for i = -0.5, -1, -0.01 do
            Rest.BackDrop.BackgroundTransparency = i * -1;
            game.Lighting.PointBlur.Size = game.Lighting.PointBlur.Size - 0.5;
            task.wait();
        end;

        Rest.BackDrop.BackgroundTransparency = 1;
        game.Lighting.PointBlur:Destroy();
        u32.CurrentPage = "";
        u6.ChakraPointLoop:Stop();
        Humanoid.AutoRotate = true;
        u32.Occupied = false;
        GameManager:stopAnimation("SittingCrossLegged", Humanoid);
        Rest.Visible = false;

        if u58.CinematicMode == "Off" and u32.HUDHidden == false then
            Loadout.Visible = true;
            Loadout.HUD.Visible = true;
            Ryo.Visible = true;
            Embers.Visible = u11.Embers > 0;
        else
            PlayerList.Visible = false;
            Ryo.Visible = false;
            Embers.Visible = false;
        end;

        HumanoidRootPart.Anchored = false;
        u32.CurrentChakraPoint = nil;
        updateTeleportLocations();

        if u11.Bloodline ~= "Otsutsuki" and #u11.DestroyedChakraPoints >= 4 or #u11.DestroyedChakraPoints >= 5 and u11.Bloodline == "Otsutsuki" then
            MainMenuFrame.DestroyButton.Visible = false;
        end;
    else
        DestroyFrame.ItemCondition.Visible = true;
        wait(3);
        DestroyFrame.ItemCondition.Visible = false;
    end;
end);
TravelFrame.Travel.MouseButton1Down:Connect(function() -- Line: 4839
    -- upvalues: u32 (copy), Rest (copy), u11 (ref), MainMenuFrame (copy), TravelFrame (copy), u6 (ref), ChangePage (copy), DataFunction (copy), hasTeleported (copy)
    if u32.CurrentPage == "Travel" and (u32.ChangingPage == false and (u32.SelectedLocation and u32.SelectedLocation ~= Rest.TitleImage.PlaceName.Text)) then
        print("chosen location is " .. u32.SelectedLocation);
        local v249 = nil;

        for _, child in ipairs(workspace.ChakraPoints:GetChildren()) do
            if child.PointName.Value == u32.SelectedLocation then
                print("found newchakrapoint");
                v249 = child;
            end;
        end;

        local Village = u11.Village;
        local v250 = v249:GetAttribute("Village");

        if getVillageRelationship(Village, v250) == "War" then
            newNotification("Chakra Point Disabled, Villages at War!");

            return;
        end;

        MainMenuFrame.Travel.ButtonHover.Visible = false;
        MainMenuFrame.Skills.ButtonHover.Visible = false;
        MainMenuFrame.Settings.ButtonHover.Visible = false;
        MainMenuFrame.Titles.ButtonHover.Visible = false;
        MainMenuFrame.Servers.ButtonHover.Visible = false;
        MainMenuFrame.Leave.ButtonHover.Visible = false;
        MainMenuFrame.DestroyButton.ButtonHover.Visible = false;
        TravelFrame.Travel.ButtonHover.Visible = false;
        TravelFrame.Travel.ButtonHover.Visible = true;
        u6.MainButtonClick:Play();
        u32.ChangingPage = true;
        u6.ChakraPointStand:Play();
        u32.CurrentChakraPoint.Main.ChakraSmoke.Enabled = false;
        MainMenuFrame:TweenPosition(UDim2.new(-0.4, 0, 0, 0), "Out", "Quad", 0.5, true);
        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
        ChangePage();

        for i = -0.5, -1, -0.01 do
            Rest.BackDrop.BackgroundTransparency = i * -1;
            game.Lighting.PointBlur.Size = game.Lighting.PointBlur.Size - 0.5;
            task.wait();
        end;

        Rest.BackDrop.BackgroundTransparency = 1;
        game.Lighting.PointBlur:Destroy();
        u32.CurrentPage = "";
        print("sent teleport request");

        if DataFunction:InvokeServer("Travel", u32.CurrentChakraPoint, v249) then
            hasTeleported(v249);
        end;
    end;
end);

local function updateItems(p251, p252) -- Line: 4887
    -- upvalues: u32 (copy), Inventory (copy), UpdateInventory (copy), UpdateLoadout (copy)
    u32.Inventory = p251;
    u32.Loadout = p252;

    if Inventory.Visible == true then
        UpdateInventory();

        return;
    end;

    UpdateLoadout();
end;

local function resetDialogText(p253) -- Line: 4898
    -- upvalues: Dialog (copy)
    for _, child in ipairs(Dialog:GetChildren()) do
        if child:FindFirstChild("DialogText") then
            child.DialogText.Text = "";

            if p253 then
                child.Visible = false;
            end;
        elseif child.Name == "DialogBack" then
            child.InfoText.Text = "";
        end;
    end;
end;

local function checkAlternativeDialog(p254) -- Line: 4911
    -- upvalues: u11 (ref), GameManager (copy)
    return p254 == "WeaponBound" and u11.WeaponBound == true and true or (p254 == "DoesntHaveBlessing" and not GameManager:hasItem(u11, "Arkoromo\'s Blessing") and true or (p254 == "HasButterflyModeStage2" and (GameManager:hasSkill(u11, "Butterfly Mode [Stage 2]") or u11.WonRamenContest == true) and true or false));
end;

local Cookbook = Mainframe:WaitForChild("Cookbook");

local function updateCookbook() -- Line: 4924
    -- upvalues: Cookbook (copy), u11 (ref), GameManager (copy)
    for _, child in ipairs(Cookbook.ScrollBook:GetChildren()) do
        if child.Name ~= "CookClone" then
            child:Destroy();
        end;
    end;

    local v255 = 0;
    local v256 = 0.03;

    for i, v in next, u11.Recipes do
        v255 = v255 + 1;

        if GameManager.Items[i] then
            local v257 = 0;
            local v258 = Cookbook.ScrollBook.CookClone:Clone();
            v258.Parent = Cookbook.ScrollBook;
            v258.Position = UDim2.new(0.035, 0, v256, 0);
            v258.Name = "Recipe" .. v255;
            v258.Visible = true;

            if GameManager.Items[i] and GameManager.Items[i].ID ~= "" then
                v258.BowlImage.Image = "rbxassetid://" .. GameManager.Items[i].ID;
                v258.BowlImage.ImageColor3 = GameManager:getImageColor(i);
            end;

            v258.BowlName.Text = i;

            for i2, v2 in next, v do
                for _ = 1, v2 do
                    v257 = v257 + 1;

                    if v258:FindFirstChild("Ingredient" .. v257) then
                        v258["Ingredient" .. v257].Image = "rbxassetid://" .. GameManager.Items[i2].ID;
                        v258["Ingredient" .. v257].ImageColor3 = GameManager:getImageColor(i2);

                        if v257 > 1 then
                            v258["Add" .. v257 - 1].Visible = true;
                        end;
                    end;
                end;
            end;

            v256 = v256 + 0.11;
        end;
    end;
end;

Cookbook:WaitForChild("ExitCook").MouseButton1Down:Connect(function() -- Line: 4968
    -- upvalues: Cookbook (copy)
    Cookbook.Visible = false;
end);

local function newText(p259, p260, p261) -- Line: 4974
    -- upvalues: Dialog (copy), u6 (ref), resetDialogText (copy), u32 (copy), u11 (ref), GameManager (copy), DataEvent (copy), BloodlinesFrame (copy), DataFunction (copy), LocalPlayer (copy), Ryo (copy), u9 (copy), chainsActivated (copy), ReplicatedStorage (copy), Humanoid (copy), Mainframe (copy), slotItemAction (copy), Inventory (copy), UpdateInventory (copy), UpdateLoadout (copy), u10 (copy)
    local v262 = true;
    local v263 = nil;
    local v264 = p260 or "";

    if Dialog.Visible == true then
        u6.ButtonSelect:Play();
    end;

    resetDialogText(p259);

    if u32.NPCModule and u32.NPCModule.AlternativeDialog then
        local AlternativeCondition = u32.NPCModule.AlternativeCondition;

        if (AlternativeCondition == "WeaponBound" and u11.WeaponBound == true and true or (AlternativeCondition == "DoesntHaveBlessing" and not GameManager:hasItem(u11, "Arkoromo\'s Blessing") and true or (AlternativeCondition == "HasButterflyModeStage2" and (GameManager:hasSkill(u11, "Butterfly Mode [Stage 2]") or u11.WonRamenContest == true) and true or false))) == true then
            if u32.NPCModule.AlternativeCondition == "HasButterflyModeStage2" then
                if u11.WonRamenContest == true and (GameManager:hasSkill(u11, "Butterfly Mode") and not GameManager:hasSkill(u11, "Butterfly Mode [Stage 2]")) then
                    DataEvent:FireServer("UpgradeButterfly");
                    u32.NPCModule = u32.NPCModule.AlternativeDialog.FirstTime;
                else
                    u32.NPCModule = u32.NPCModule.AlternativeDialog;
                end;
            else
                u32.NPCModule = u32.NPCModule.AlternativeDialog;
            end;
        end;
    end;

    if u32.NPCModule and u32.NPCModule.Type then
        print("Went into Type : " .. u32.NPCModule.Type);

        if u32.NPCModule.Type == "Quit" then
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "TBArtifactSpawn" or u32.NPCModule.Type == "TBRobuxSpawn" then
            v262 = DataFunction:InvokeServer(u32.NPCModule.Type, u32.NPCModule.ExtraInfo);
        elseif u32.NPCModule.Type == "VillageEconomy" or (u32.NPCModule.Type == "VillagePolitics" or u32.NPCModule.Type == "VillageData") then
            v263 = DataFunction:InvokeServer(u32.NPCModule.Type, u32.NPCModule.ExtraInfo);
        elseif u32.NPCModule.Type == "Crate Delivery" then
            v262 = DataFunction:InvokeServer("Crate Delivery", nil, nil, nil, u32.dialogPart);
        elseif u32.NPCModule.Type == "trickOrTreat" then
            v262 = DataFunction:InvokeServer("trickOrTreat", u32.dialogPart);
        elseif u32.NPCModule.Type == "Event" then
            GameManager:StartEvent(u32.NPCModule.ExtraInfo);
            DataEvent:FireServer("PlayerEvent", u32.NPCModule.ExtraInfo);
        elseif u32.NPCModule.Type == "GivePin" then
            v264 = u11.Pin;
        elseif u32.NPCModule.Type == "BloodbiteCheck" then
            if GameManager:hasItem(u11, "Bloodbite Ring") or (GameManager:hasItem(u11, "Bloodbite Ring +1") or GameManager:hasItem(u11, "Bloodbite Ring +2")) then
                v262 = DataFunction:InvokeServer("BloodbiteCheck");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "BugsCheck" and u11.Bloodline == "Aburame" then
            if u11.BugPunches >= 200 then
                v262 = true;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "AkimichiCheck" and u11.Bloodline == "Akimichi" then
            if u32.Settings.FoodCounters.Value >= 14 then
                v262 = true;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "HasButterflyMode" and (u11.Bloodline == "Akimichi" and (GameManager:hasSkill(u11, "Butterfly Mode") and u11.WonRamenContest == false)) then
            v262 = true;
        elseif u32.NPCModule.Type == "CheckButterflyXP" and u11.Bloodline == "Akimichi" then
            if u11.ButterflyXP >= 350 then
                v262 = true;
            else
                v262 = "FailedV1";
            end;
        elseif u32.NPCModule.Type == "RamenContestStart" and (u11.Bloodline == "Akimichi" and GameManager:hasSkill(u11, "Butterfly Mode")) then
            if GameManager:hasItem(u11, "Ramen", 15) then
                u32.RamenContestRealStart = false;
                DataEvent:FireServer("StartRamenContest");
            else
                newNotification("Make sure you have 15x Ramen before beginning the Ramen contest!");
            end;

            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
        elseif u32.NPCModule.Type == "RamenContestRealStart" then
            u32.RamenContestRealStart = "Loading";
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
        elseif u32.NPCModule.Type == "ExtractionSpoonCheck" then
            if GameManager:hasSkill(u11, "Bugs Swarm") and GameManager:hasSkill(u11, "Bugs Strike") then
                v262 = "FailedV1";
            elseif GameManager:hasItem(u11, "Extraction Spoon") then
                v262 = DataFunction:InvokeServer("ExtractionSpoonCheck");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "AllStarCheck" then
            if GameManager:hasItem(u11, "All Star Fruit Bowl") then
                v262 = DataFunction:InvokeServer("AllStarCheck");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "Check1Fragment" then
            if GameManager:hasItem(u11, "Chakra Fragments") then
                v262 = DataFunction:InvokeServer("1FragmentExchange");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "Check5Fragments" then
            if GameManager:hasItem(u11, "Chakra Fragments", 5) then
                v262 = DataFunction:InvokeServer("5FragmentsExchange");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "HalloByakuganCheck" then
            if GameManager:hasSkill(u11, "Byakugan") and GameManager:hasItem(u11, "Infernal Fragments", 30) then
                v262 = DataFunction:InvokeServer("HalloByakuganCheck");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "SasukeSusanooCheck" then
            if (GameManager:hasSkill(u11, "Sasuke\'s Mangekyo") or GameManager:hasSkill(u11, "Sasuke\'s Eternal Mangekyo")) and GameManager:hasItem(u11, "Infernal Fragments", 30) then
                v262 = DataFunction:InvokeServer("SasukeSusanooCheck");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "ItachiSusanooCheck" then
            if (GameManager:hasSkill(u11, "Itachi\'s Mangekyo") or GameManager:hasSkill(u11, "Itachi\'s Eternal Mangekyo")) and GameManager:hasItem(u11, "Infernal Fragments", 30) then
                v262 = DataFunction:InvokeServer("ItachiSusanooCheck");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type:find("PumpkinCheck") then
            if GameManager:hasItem(u11, "Infernal Fragments", 25) then
                v262 = DataFunction:InvokeServer("PumpkinCheck", u32.NPCModule.Type);
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "InfernalSchematicsCheck" then
            if GameManager:hasItem(u11, "Infernal Fragments", 40) then
                v262 = DataFunction:InvokeServer("InfernalSchematicsCheck");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "Payment" then
            local v265 = nil;
            local v266 = nil;
            local v267 = u32.NPCModule.Quantity or 1;

            if u32.NPCModule.Amount == "Injuries" then
                v265 = GameManager:calculateInjuryPrice(u11.Injuries);
                v266 = "Injuries";
            elseif u32.NPCModule.Amount == "Sins" then
                v265 = GameManager:calculateSinsPrice(u11);
                v266 = "Sins";
            elseif u32.NPCModule.Item and (u32.NPCModule.Item == "NewHair" or u32.NPCModule.Item == "Bald") then
                v265 = u32.NPCModule.Amount;
                v266 = u32.NPCModule.Item;
            elseif u32.NPCModule.Item and u32.NPCModule.Item == "NewHairColor" then
                v265 = u32.NPCModule.Amount;
                v266 = u32.NPCModule.Item;
            elseif not u32.NPCModule.Item or (not GameManager.Items[u32.NPCModule.Item] or (not GameManager.Items[u32.NPCModule.Item].Condition or GameManager:checkOptionCondition(LocalPlayer, u11, GameManager.Items[u32.NPCModule.Item].Condition) ~= false)) then
                if u32.NPCModule.Item and (u32.NPCModule.Item == "NewAccessory" or u32.NPCModule.Item == "NewAccessoryDiscount") then
                    v265 = u32.NPCModule.Amount;
                    v266 = u32.NPCModule.Item;
                elseif u32.NPCModule.Item then
                    v266 = u32.NPCModule.Item;
                    v265 = GameManager:getPrice(v266);
                else
                    v265 = u32.NPCModule.Amount;
                end;
            end;

            if v265 then
                v265 = GameManager:getModifiedPrice(v265, getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Buy") * v267;
            end;

            if v265 and u11.Ryo >= v265 then
                local v268 = u11.Ryo - v265;
                v262 = DataFunction:InvokeServer("Pay", v265, v266, v267, u32.dialogPart);

                if v262 then
                    if u32.NPCModule.Amount == "Injuries" then
                        u11.Injuries = {};
                        u11.ArmorBroken = false;
                    end;

                    u6.SellMultiple:Play();
                    Ryo.Amount.Text = v268;
                    print("payment requirement was met");
                else
                    print("payment requirement was not met");
                end;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "AccessoryCheck" then
            if u11.LastAgeAccessory == u11.Age then
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "ZetsuCheck" then
            if u11.Bloodline == "Zetsu" then
                if Dialog.DialogBack.NPCName.Text == "The 1st Zetsu" and (u11.FirstZetsu and u11.FirstZetsu == true) or (Dialog.DialogBack.NPCName.Text == "The 2nd Zetsu" and (u11.SecondZetsu and u11.SecondZetsu == true) or Dialog.DialogBack.NPCName.Text == "The 3rd Zetsu" and (u11.ThirdZetsu and u11.ThirdZetsu == true)) then
                    v262 = "FailedV1";
                elseif Dialog.DialogBack.NPCName.Text == "The 4th Zetsu" and (u11.FourthZetsu and u11.FourthZetsu == true) then
                    v262 = "FailedV1";
                else
                    v262 = true;
                end;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "ZetsuPoisonCheck" then
            v262 = DataFunction:InvokeServer("ZetsuPoisonCheck");
        elseif u32.NPCModule.Type == "TraitCheck" then
            v262 = DataFunction:InvokeServer("TraitCheck");
        elseif u32.NPCModule.Type == "TraitReshuffle" then
            v262 = DataFunction:InvokeServer("TraitReshuffle");
        elseif u32.NPCModule.Type == "FlawCheck" then
            v262 = DataFunction:InvokeServer("FlawCheck");
        elseif u32.NPCModule.Type == "FlawReshuffle" then
            v262 = DataFunction:InvokeServer("FlawReshuffle");
        elseif u32.NPCModule.Type == "ZetsuDonateCheck" and u11.Bloodline == "Zetsu" then
            if u11.Acumen >= 50 and GameManager:hasItem(u11, "Mashed Up Cells") then
                v262 = DataFunction:InvokeServer("ZetsuDonate", Dialog.DialogBack.NPCName.Text);

                if v262 == true then
                    GameManager:activateZetsu(workspace[Dialog.DialogBack.NPCName.Text]);
                end;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "NewFace" then
            if u11.Ryo >= GameManager.Settings.SwitchFacePrice and GameManager:hasItem(u11, "Switchpowder") then
                v262 = DataFunction:InvokeServer("NewFace");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "BuyBasalt" then
            if u11.Ryo >= 35 then
                v262 = DataFunction:InvokeServer("BuyBasalt");
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "GiveCookbook" then
            DataEvent:FireServer("GiveCookbook");
        elseif u32.NPCModule.Type == "SelfLockUp" then
            v262 = DataFunction:InvokeServer("LockMeUp");
            u32.Broken = true;

            if not u9:FindFirstChild("ragdolled") then
                GameManager:getAnimation("Jailed", GameManager:getHumanoid(u9)):Play();
            end;
        elseif u32.NPCModule.Type == "CriminalLockUp" then
            v262 = DataFunction:InvokeServer("LockCriminal");
        elseif u32.NPCModule.Type == "DoublingCheck" then
            if u11.Ryo < 10 then
                v262 = "FailedV1";
            elseif u11.Ryo > 500 then
                v262 = "FailedV2";
            else
                u32.scammed = true;
                v262 = DataFunction:InvokeServer("DoubleMyMoneyPlease");

                if v262 == true then
                    u6.SellMultiple:Play();
                    u32.scammed = false;
                else
                    delay(3, function() -- Line: 5254
                        -- upvalues: u32 (ref)
                        u32.scammed = false;
                    end);
                end;
            end;
        elseif u32.NPCModule.Type == "ChainUnlock" then
            DataEvent:FireServer("ChainUnlock");
        elseif u32.NPCModule.Type == "ChainCheck" then
            if u11.Bloodline == "Uzumaki" then
                if GameManager:hasSkill(u11, "Adamantine Sealing Chains") or GameManager:hasItem(u11, "Uzumaki Affinity") then
                    v262 = "FailedV1";
                elseif chainsActivated() == true then
                    v262 = "FailedV2";
                else
                    v262 = true;
                end;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "SharkUnlock" then
            DataEvent:FireServer("SharkUnlock");
        elseif u32.NPCModule.Type == "SharkCheck" then
            if u11.Bloodline == "Hoshigaki" then
                if GameManager:hasSkill(u11, "Shark Transformation") or GameManager:hasItem(u11, "Hoshigaki Affinity") then
                    v262 = "FailedV2";
                elseif (workspace.XPShark.Transparency == 0.5 and (workspace.SwimmingShark.Transparency == 0.5 and (workspace.ScarletShark.Transparency == 0.5 and workspace.SharkmanShark.Transparency == 0.5))) == true then
                    v262 = "FailedV3";
                else
                    v262 = true;
                end;
            elseif u11.Reanimated == true then
                v262 = "FailedV1";
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "JutsuMasteryCheck" then
            v262 = false;
            local v269 = GameManager:getPotentialMasteredJutsu(u11);

            if #u11.MasteredJutsus > 0 then
                if v269 then
                    v264 = v269 .. " Jutsu. Mastering it will require " .. GameManager.Settings.JutsuMasteryAcumen .. " Acumen.";
                    v262 = "Response2";
                end;
            elseif v269 then
                v264 = v269 .. " Jutsu. Mastering it will require " .. GameManager.Settings.JutsuMasteryAcumen .. " Acumen.";
                v262 = true;
            end;
        elseif u32.NPCModule.Type == "MasterJutsu" then
            local v270 = GameManager:getPotentialMasteredJutsu(u11);

            if u11.Acumen >= GameManager.Settings.JutsuMasteryAcumen then
                v262 = DataFunction:InvokeServer("MasterJutsu");
                v264 = "the " .. v270 .. " Jutsu.";
            else
                v262 = false;
            end;

            if v262 == false and u11.Acumen >= GameManager.Settings.JutsuMasteryAcumen then
                v262 = "FailedV1";
            end;
        elseif u32.NPCModule.Type == "SwapMasteredJutsu" then
            if u11.Acumen >= GameManager.Settings.JutsuMasteryAcumen then
                local u271 = ReplicatedStorage.UI.MasteredJutsusFrame:Clone();
                u271.Parent = LocalPlayer.PlayerGui.ClientGui.Mainframe;

                for _, v in u11.MasteredJutsus do
                    local v272 = u271.Template:Clone();
                    v272.ButtonText.Text = v;
                    v272.Visible = true;
                    v272.Parent = u271.ScrollingFrame;
                    v272.MouseButton1Down:Once(function() -- Line: 5333
                        -- upvalues: DataEvent (ref), v (copy), u271 (copy)
                        DataEvent:FireServer("SwapMasteredJutsu", v);
                        u271:Destroy();
                    end);
                end;

                u271.Close.TextButton.MouseButton1Down:Once(function() -- Line: 5339
                    -- upvalues: u271 (copy)
                    u271:Destroy();
                end);
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "JutsuMasteryCheck2" then
            v262 = false;
            local v273 = GameManager:getPotentialMasteredJutsu(u11);

            if #u11.MasteredJutsus < 1 then
                v262 = false;
            elseif v273 then
                v262 = true;
            end;
        elseif u32.NPCModule.Type == "JutsuMasterySacrifice" then
            if #u11.MasteredJutsus >= 10 then
                v262 = "FailedV2";
            elseif GameManager:hasTornArmItem(u11) then
                if u11.Acumen < GameManager.Settings.JutsuMasteryAcumen then
                    v262 = "FailedV1";
                else
                    local v274;
                    v262, v274 = DataFunction:InvokeServer("JutsuMasterySacrifice");

                    if v274 then
                        v264 = "the " .. v274 .. " Jutsu.";
                    end;
                end;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "AwakeningUpgradeDetails" then
            local v275 = u11.AwakeningLevel == 1 and 25 or (u11.AwakeningLevel == 2 and 60 or (u11.AwakeningLevel == 3 and 150 or (u11.AwakeningLevel == 4 and 300 or (u11.AwakeningLevel == 5 and 500 or (u11.AwakeningLevel == 6 and 750 or nil)))));

            if v275 then
                v264 = v275 .. " Acumen";
                v262 = true;
            elseif u11.AwakeningLevel == 7 then
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "AwakeningUpgrade" then
            if (u11.AwakeningLevel == 1 and 25 or (u11.AwakeningLevel == 2 and 60 or (u11.AwakeningLevel == 3 and 150 or (u11.AwakeningLevel == 4 and 300 or (u11.AwakeningLevel == 5 and 500 or (u11.AwakeningLevel == 6 and 750 or nil)))))) <= u11.Acumen then
                DataEvent:FireServer("UpgradeAwakeningLevel");
                v262 = true;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "ArmorUpgrade" then
            v262 = DataFunction:InvokeServer("ArmorUpgrade");

            if v262 == true then
                u6.SellMultiple:Play();
            end;
        elseif u32.NPCModule.Type == "RingUpgrade" then
            if u32.Selected == "" or (not GameManager.Items[u32.Selected] or GameManager.Items[u32.Selected].Type ~= "Ring") then
                v262 = "FailedV1";
            elseif GameManager.Items[u32.Selected] and (GameManager.Items[u32.Selected].Type == "Ring" and not GameManager.Items[u32.Selected].UpgradedVersion) then
                v262 = "FailedV2";
            else
                v262 = DataFunction:InvokeServer("RingUpgrade");

                if v262 == true then
                    u6.SellMultiple:Play();
                end;
            end;
        elseif u32.NPCModule.Type == "SetSpawn" then
            if GameManager.Locations[u32.CurrentArea] and GameManager.Locations[u32.CurrentArea].SpawnPoint then
                v262 = DataFunction:InvokeServer("SetSpawn", u32.CurrentArea);
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "CheckByakuganUpgrade" then
            v262 = DataFunction:InvokeServer("checkEyesUpgrade", "Byakugan");
        elseif u32.NPCModule.Type == "CheckSharinganUpgrade" then
            v262 = DataFunction:InvokeServer("checkEyesUpgrade", "Sharingan");
        elseif u32.NPCModule.Type == "CheckKetsuryuganUpgrade" then
            v262 = DataFunction:InvokeServer("checkEyesUpgrade", "Ketsuryugan");
        elseif u32.NPCModule.Type == "CheckAyruiLightning" then
            v262 = DataFunction:InvokeServer("checkAyruiLightning");
        elseif u32.NPCModule.Type == "UpgradeByakugan" then
            DataEvent:FireServer("UpgradeByakugan");
        elseif u32.NPCModule.Type == "UpgradeSharingan" then
            DataEvent:FireServer("UpgradeSharingan");
        elseif u32.NPCModule.Type == "UpgradeKetsuryugan" then
            DataEvent:FireServer("UpgradeKetsuryugan");
        elseif u32.NPCModule.Type == "UnlockAyruiAffinity" then
            DataEvent:FireServer("UnlockAyruiAffinity");
        elseif u32.NPCModule.Type == "CheckEyes" then
            local v276 = GameManager:hasSpecialEyes(u11);

            if u11.Bloodline == "Uchiha" then
                if u32.Selected:find("Rinnegan") then
                    v276 = GameManager:hasSpecialEyes(u11, { "Sharingan" });
                elseif u32.Selected:find("Sharingan") or u32.Selected:find("Mangekyo") then
                    v276 = GameManager:hasSpecialEyes(u11, { "Rinnegan" });
                end;
            end;

            if v276 then
                v262 = "FailedV2";
            elseif u11.Age < GameManager.Settings.MinImplantAge then
                v262 = "FailedV1";
            elseif (u32.Selected:find("gan Eyes") or u32.Selected:find("gekyo Eyes")) and (GameManager:hasItem(u11, "Sharingan Eyes") or (GameManager:hasItem(u11, "Rinnegan Eyes") or (GameManager:hasItem(u11, "Mangekyo Eyes") or (GameManager:hasItem(u11, "Byakugan Eyes") or GameManager:hasItem(u11, "Ketsuryugan Eyes"))))) then
                v262 = true;
            else
                print("what eyes false");
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "CheckArm" then
            if u11.MissingArm then
                if u11.Age < GameManager.Settings.MinImplantArmAge then
                    v262 = "FailedV1";
                elseif string.match(u32.Selected, "Torn") and (string.match(u32.Selected, "Arm") and GameManager:hasItem(u11, u32.Selected)) then
                    v262 = true;
                else
                    print("what arm false");
                    v262 = false;
                end;
            else
                v262 = "FailedV2";
            end;
        elseif u32.NPCModule.Type == "ImplantEyes" then
            if u11.Ryo < GameManager.Settings.ImplantPrice then
                v262 = false;
            else
                DataEvent:FireServer("ImplantEyes");
                u32.Occupied = true;
            end;
        elseif u32.NPCModule.Type == "ImplantArm" then
            if u11.Ryo < GameManager.Settings.ImplantArmPrice then
                v262 = false;
            else
                DataEvent:FireServer("ImplantArm");
                u32.Occupied = true;
            end;
        elseif u32.NPCModule.Type == "EnterMatchmaking" and u32.InDanger == false then
            if GameManager:hasItem(u11, "Arkoromo\'s Blessing") then
                v262 = false;
            else
                DataEvent:FireServer("Matchmaking");
                Humanoid.WalkSpeed = 0;
                Humanoid.JumpPower = 0;
                wait(0.1);
            end;
        elseif u32.NPCModule.Type == "CreateClan" then
            if u11.Clan == "" and u11.Age >= GameManager.Settings.ClanCreationAge then
                if u11.Ryo >= 500 then
                    Mainframe.ClanCreation.Visible = true;
                    Mainframe.ClanCreation.ClanName.Text = "";
                    Mainframe.ClanCreation.ClanImageID.Text = "";
                    Mainframe.ClanCreation.ClanImage.Image = "";
                else
                    v262 = "FailedV1";
                end;
            else
                v262 = false;
            end;
        elseif u32.NPCModule.Type == "FreeHair" then
            DataEvent:FireServer("FreeHair", "NewHair");
        elseif u32.NPCModule.Type == "FreeHairColor" then
            DataEvent:FireServer("FreeHairColor", "NewHairColor");
        elseif u32.NPCModule.Type == "SuperKamuiDangerCheck" or u32.NPCModule.Type == "KamuiDangerCheck" and u32.InDanger == false then
            DataEvent:FireServer("KamuiExit", u32.NPCModule.Type);
        elseif u32.NPCModule.Type == "LeaveClan" and u11.Clan ~= "" then
            DataEvent:FireServer("LeaveClan");
            u11.Clan = "";

            if u11.Gender == "Male" then
                u11.ClanLeader = "";
            else
                u11.ClanLeader = "";
            end;
        elseif u32.NPCModule.Type == "WeaponBind" and (GameManager:hasItem(u11, "Chakra Fragments") and DataFunction:InvokeServer("GetWeapon")) then
            DataEvent:FireServer("WeaponBind");
        elseif u32.NPCModule.Type == "ChefsKissPrice" then
            v264 = GameManager:getModifiedPrice(GameManager.Items["Chef\'s Kiss"].SalePrice, getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Buy") .. " Ryo.";
        elseif u32.NPCModule.Type == "SellingWeapon" then
            if u11.CurrentWeapon == "" then
                v262 = false;
            else
                v264 = GameManager:getModifiedPrice(math.floor(GameManager.Items[u11.CurrentWeapon].SalePrice / 2), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell") .. " Ryo";
                v262 = true;
            end;
        elseif u32.NPCModule.Type == "Selling" or u32.NPCModule.Type == "SellingBulk" then
            if u32.NPCModule.Type == "Selling" and u32.NPCModule.Amount == "Trinket" then
                if GameManager.Items[u32.Selected] and (GameManager.Items[u32.Selected].Type == "Trinket" or (GameManager.Items[u32.Selected].Type == "Gem" or (GameManager.Items[u32.Selected].Type == "Ring" or GameManager.Items[u32.Selected].Type == "FakeSellable"))) then
                    v264 = GameManager:getModifiedPrice(GameManager.Items[u32.Selected].SalePrice, getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell") .. " Ryo";
                    v262 = true;
                else
                    v262 = false;
                end;
            elseif u32.NPCModule.Type == "Selling" and u32.NPCModule.Amount == "Fruit" and (GameManager.Items[u32.Selected] and (GameManager.Items[u32.Selected].ExtraInfo and GameManager.Items[u32.Selected].ExtraInfo == "Fruit")) then
                v264 = GameManager:getModifiedPrice(GameManager.Items[u32.Selected].SalePrice, getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell") .. " Ryo";
                v262 = true;
            else
                v262 = false;
            end;

            if u32.NPCModule.Type == "SellingBulk" then
                if GameManager:getModifiedPrice(GameManager:calculateBulk(u32.Inventory, u32.Loadout, u32.NPCModule.Amount, nil, "Sale"), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell") then
                    print("GOT PRICE CHECK");
                    v262 = true;
                else
                    v262 = false;
                end;
            end;

            if u32.NPCModule.Function and (u32.NPCModule.Function == "SelectedFood" or u32.NPCModule.Function == "SelectedTrinket") then
                if GameManager.Items[u32.Selected] then
                    v262 = true;
                else
                    v262 = false;
                end;
            end;
        elseif u32.NPCModule.Type == "SellWeaponReward" then
            v262 = DataFunction:InvokeServer("SellingWeapon", nil, nil, nil, u32.dialogPart);

            if v262 == true then
                u6.SellSingle:Play();
                slotItemAction("Unselected", u32.Selected);
                local Loadout2 = u11.Loadout;
                u32.Inventory = u11.Inventory;
                u32.Loadout = Loadout2;

                if Inventory.Visible == true then
                    UpdateInventory();
                else
                    UpdateLoadout();
                end;

                Ryo.Amount.Text = u11.Ryo;

                if u32.CombatTable.Idle then
                    GameManager:stopAnimation(u32.CombatTable.Idle, Humanoid);
                end;

                if u32.CombatTable.RunningIdle then
                    GameManager:stopAnimation(u32.CombatTable.RunningIdle, Humanoid);
                end;

                u32.CombatType = GameManager:getBaseCombat(u11, u32.Settings);
                u32.CombatTable = GameManager:getCombatTable(u32.CombatType);
                u32.WeaponEquipped = false;
            end;
        elseif u32.NPCModule.Type == "RyoReward" then
            if not tonumber(u32.NPCModule.Amount) then
                local Amount = u32.NPCModule.Amount;
                local v277 = u32.NPCModule.Amount2 or nil;

                if u32.NPCModule.Function and u32.NPCModule.Function == "Bulk" then
                    v262 = DataFunction:InvokeServer("SellingBulk", GameManager:getModifiedPrice(GameManager:calculateBulk(u32.Inventory, u32.Loadout, Amount, v277), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell"), Amount, v277, u32.dialogPart);
                    print("stage 2 requirements met");

                    if v262 == true then
                        u6.SellMultiple:Play();
                    end;
                elseif u32.NPCModule.Function and GameManager.Items[u32.Selected] and (u32.NPCModule.Function == "SelectedFood" and (GameManager:itemType(u32.Selected) == "Fruit" or GameManager:itemType(u32.Selected) == "Fish") or u32.NPCModule.Function == "SelectedTrinket" and (GameManager:itemType(u32.Selected) == "Trinket" or GameManager:itemType(u32.Selected) == "Gem")) then
                    local v278 = GameManager:getModifiedPrice(GameManager:getPrice(u32.Selected), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell");

                    if u32.NPCModule.Function == "SelectedFood" then
                        v262 = DataFunction:InvokeServer("SellFood", u32.Selected, v278, nil, u32.dialogPart);
                    elseif u32.NPCModule.Function == "SelectedTrinket" then
                        v262 = DataFunction:InvokeServer("SellTrinket", u32.Selected, v278, nil, u32.dialogPart);
                    end;

                    if v262 == true then
                        u6.SellSingle:Play();
                        slotItemAction("Unselected", u32.Selected);
                        local Loadout2 = u11.Loadout;
                        u32.Inventory = u11.Inventory;
                        u32.Loadout = Loadout2;

                        if Inventory.Visible == true then
                            UpdateInventory();
                        else
                            UpdateLoadout();
                        end;
                    end;
                end;

                Ryo.Amount.Text = u11.Ryo;
                print("stage 1 requirements met");

                if Inventory.Visible == true then
                    UpdateInventory();
                else
                    UpdateLoadout();
                end;
            end;
        elseif u32.NPCModule.Type == "Quest" then
            local v279 = {};

            if type(u32.NPCModule.QuestName) == "string" then
                v279 = { u32.NPCModule.QuestName };
            elseif type(u32.NPCModule.QuestName) == "table" then
                v279 = u32.NPCModule.QuestName;
            elseif u32.NPCModule.QuestList then
                v279 = u32.NPCModule.QuestList;
            end;

            local v280, _, _ = GameManager:GetBestQuest(LocalPlayer, u11, v279);

            if v280 then
                local v281, v282 = DataFunction:InvokeServer("GetQuestProgress", v280);
                u32.CurrentQuest = v280;

                if v281 == "Ongoing" and GameManager.Quests[v280].UsesOngoing == false then
                    print("Does not use Ongoing");
                elseif v282 == "" and (v281 == "Finished" and GameManager.Quests[v280].UsesFinished == false) then
                    print("Does not use Finished");
                else
                    if not u32.NPCModule.BlockAutoStart and (v281 == "Start" and (not GameManager:searchInDict(u11.Quests, v280) or u11.Quests[v280] == "Repeatable")) then
                        u11 = DataFunction:InvokeServer("StartQuest", v280);
                    end;

                    v263 = GameManager.Quests[v280][v281 .. v282 .. "Response"];
                    u32.NPCModule = GameManager.Quests[v280][v281 .. v282] or GameManager.Quests[v280][v281];
                end;

                print("Progress is " .. v281);
            else
                print("No suitable quest found in quest list");
                u32.CurrentQuest = nil;
            end;
        elseif u32.NPCModule.Type == "JoinVillage" then
            v263 = DataFunction:InvokeServer("JoinVillage", u32.NPCModule.ExtraInfo);
            v262 = true;
        elseif u32.NPCModule.Type == "LeaveVillage" then
            v263 = DataFunction:InvokeServer("LeaveVillage");
            v262 = true;
        elseif u32.NPCModule.Type == "RedeemSelf" then
            v262 = DataFunction:InvokeServer("RedeemSelf");
        elseif u32.NPCModule.Type == "GeninExam" or (u32.NPCModule.Type == "ChuninExam" or u32.NPCModule.Type == "JoninExam") then
            v262 = DataFunction:InvokeServer(u32.NPCModule.Type);
        elseif u32.NPCModule.Type == "ExamCheck" then
            if DataFunction:InvokeServer(u32.NPCModule.Type) == "Completed" then
                u32.NPCModule = u32.NPCModule.Completed;
            else
                u32.NPCModule = u32.NPCModule.Normal;
            end;

            v263 = u32.NPCModule.Response;
        elseif u32.NPCModule.Type == "PaymentCheck" then
            if GameManager.Items[u32.NPCModule.Item] then
                v264 = GameManager:getModifiedPrice(GameManager.Items[u32.NPCModule.Item].SalePrice * u32.NPCModule.Quantity, getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Buy") .. " Ryo.";
            end;
        elseif u32.NPCModule.Type == "StabilizeRift" then
            v262 = DataFunction:InvokeServer("StabilizeRift");
        elseif u32.NPCModule.Type == "OpenSnowGate" then
            v262 = DataFunction:InvokeServer("OpenSnowGate");
        elseif u32.NPCModule.Type == "exitTheSubconscious" then
            DataEvent:FireServer("exitTheSubconscious");
        elseif u32.NPCModule.Type == "HealMissingArmCheck" then
            if u11.MissingArm then
                v262 = true;

                if u11.Ryo < GameManager.Settings.ArmRestorationPrice then
                    v262 = "FailedV1";
                elseif u11.SenjuArm then
                    v263 = "Interesting. I can sense that you have some leftover Hashirama Cells in your torn arm... I can enhance them with my jutsu to grow it back. With a price of " .. GameManager.Settings.ArmRestorationPrice .. " Ryo of course...";
                end;
            else
                v262 = "Failed";
            end;
        elseif u32.NPCModule.Type == "HealMissingArm" then
            DataEvent:FireServer("HealMissingArm");
        elseif u32.NPCModule.Type == "SaunaLeafCheck" then
            v262 = DataFunction:InvokeServer("SaunaLeafCheck");
        elseif u32.NPCModule.Type == "ActivateSauna" then
            DataEvent:FireServer("ActivateSauna");
        elseif u32.NPCModule.Type == "hasScalpel" then
            v262 = DataFunction:InvokeServer("hasScalpel");
        elseif u32.NPCModule.Type == "ScalpelNPC" then
            DataEvent:FireServer("ScalpelNPC");
        elseif u32.NPCModule.Type == "wiseTreeCheck1" then
            if u11.Bloodline == "Senju" or (u11.Bloodline == "Zetsu" or (u11.ImplantedArm == "Torn Senju Arm" or u11.ImplantedArm == "Torn Zetsu Arm")) then
                if u11.EarthXP < 500 or (u11.WaterXP < 500 or not (GameManager:hasSkill(u11, "Earth Golem") and GameManager:hasSkill(u11, "Pool Expansion"))) then
                    v262 = "FailedV1";
                end;
            else
                v262 = "Failed";
            end;
        elseif u32.NPCModule.Type == "removeArm" then
            if u11.MissingArm then
                v262 = "Failed";
            else
                DataEvent:FireServer("removeArm");
            end;
        elseif u32.NPCModule.Type == "keytoraStart" then
            DataEvent:FireServer("keytoraStart");
        elseif u32.NPCModule.Type == "beastKey" then
            v262 = DataFunction:InvokeServer("beastKey");
        elseif u32.NPCModule.Type == "startBeastFight" then
            DataEvent:FireServer("startBeastFight");
        elseif u32.NPCModule.Type == "buyFlowerBouquet" then
            v262 = DataFunction:InvokeServer("buyFlowerBouquet");
        elseif u32.NPCModule.Type == "openWipeShop" then
            LocalPlayer.PlayerGui.WipeShop.Enabled = true;
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "openHalloweenShop" then
            LocalPlayer.PlayerGui.HalloweenShop.Enabled = true;
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "openXmasShop" then
            LocalPlayer.PlayerGui.XmasShop.Enabled = true;
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "openValentineShop" then
            LocalPlayer.PlayerGui.ValentineShop.Enabled = true;
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "openEventCollectionShop" then
            v262 = #u11.EventPurchases > 0;

            if v262 then
                LocalPlayer.PlayerGui.EventCollectionShop.Enabled = true;
                u32.InDialog = false;
                Dialog.Visible = false;
                u32.dialogPart = nil;
                BloodlinesFrame.Visible = false;
            end;
        elseif u32.NPCModule.Type == "exitRealm" then
            LocalPlayer.PlayerGui.WipeShop.Enabled = false;
            DataEvent:FireServer("exitRealm");
        elseif u32.NPCModule.Type == "dogCheck" then
            v262 = DataFunction:InvokeServer("dogCheck");
        elseif u32.NPCModule.Type == "OutKeeperDeliver" then
            DataEvent:FireServer("OutKeeperDeliver", u32.dialogPart);
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "OutKeeperExplosion" then
            DataEvent:FireServer("OutKeeperExplosion");
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "giveEvergreenHeart" then
            v262 = DataFunction:InvokeServer("giveEvergreenHeart");
        elseif u32.NPCModule.Type == "refuseEvergreenHeart" then
            DataEvent:FireServer("refuseEvergreenHeart");
        elseif u32.NPCModule.Type == "canUnlockBlueGates" then
            v262 = GameManager:canUnlockBlueGates(u11);
        elseif u32.NPCModule.Type == "hasKaguyaRequirements" then
            v262 = GameManager:hasKaguyaRequirements(u11);
        elseif u32.NPCModule.Type == "startBlueGatesQuest" then
            DataEvent:FireServer("startBlueGatesQuest");
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type == "canUnlockRedGates" then
            v262 = GameManager:canUnlockRedGates(u11);
        elseif u32.NPCModule.Type == "startRedGatesQuest" then
            DataEvent:FireServer("startRedGatesQuest");
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            BloodlinesFrame.Visible = false;
        elseif u32.NPCModule.Type ~= "checkCustomHairstyle" then
            if u32.NPCModule.Type == "customHairstyle" then
                u32.InDialog = false;
                Dialog.Visible = false;
                u32.dialogPart = nil;
                BloodlinesFrame.Visible = false;
                local u283 = ReplicatedStorage.UI.CustomHairstyle:Clone();
                u283.Parent = LocalPlayer.PlayerGui.ClientGui.Mainframe;
                u283.Close.MouseButton1Down:Once(function() -- Line: 5883
                    -- upvalues: u283 (copy)
                    u283:Destroy();
                end);
                u283.Confirm.MouseButton1Down:Once(function() -- Line: 5887
                    -- upvalues: DataEvent (ref), u283 (copy)
                    DataEvent:FireServer("customHairstyle", u283.TextBox.Text);
                    u283:Destroy();
                end);
            elseif u32.NPCModule.Type == "rollTitle" then
                v262 = DataFunction:InvokeServer("rollTitle");
            elseif u32.NPCModule.Type == "canAwakenRinnegan" then
                v262 = GameManager:canAwakenRinnegan(u11);
            elseif u32.NPCModule.Type == "awakenRinnegan" then
                DataEvent:FireServer("awakenRinnegan");
            elseif u32.NPCModule.Type == "claimStarterPack" then
                DataEvent:FireServer("claimStarterPack");
            elseif u32.NPCModule.Type == "akatsukiLeaderSteal" then
                DataEvent:FireServer("akatsukiLeaderSteal");
            elseif u32.NPCModule.Type == "canUnlockByakuganStage5" then
                v262 = GameManager:canUnlockByakuganStage5(u11);
            elseif u32.NPCModule.Type == "hasDanzoRequirements" then
                v262 = GameManager:hasDanzoRequirements(u11);
            elseif u32.NPCModule.Type == "hasIceReleaseRequirements" then
                v262 = GameManager:hasIceReleaseRequirements(u11);
            elseif u32.NPCModule.Type == "canStartYukiQuest" then
                v262 = GameManager:canStartYukiQuest(u11);
            elseif u32.NPCModule.Type == "enterMirrorRealm" then
                v262 = DataFunction:InvokeServer("enterMirrorRealm");
            elseif u32.NPCModule.Type == "leaveMirrorRealm" then
                v262 = DataFunction:InvokeServer("leaveMirrorRealm");
            elseif u32.NPCModule.Type == "EyeReroll" then
                if u10.Awakened.Value:find("Mangekyo") or (u10.Awakened.Value:find("Rinnegan") or (u10.Awakened.Value == "Neji\'s Byakugan" or u10.Awakened.Value == "Hinata\'s Byakugan")) then
                    GameManager:hasSkill(u11, u10.Awakened.Value);
                end;

                if GameManager:hasItem(u11, "Mysterious Eyes") then
                    u32.Occupied = true;
                    v262 = DataFunction:InvokeServer(u32.NPCModule.Type);

                    if v262 ~= true then
                        u32.Occupied = false;
                    end;
                else
                    v262 = "FailedV2";
                end;
            elseif u32.NPCModule.Type == "EyeRerollRobux" then
                if GameManager:hasItem(u11, "Mysterious Eyes", GameManager.Items["Mysterious Eyes"].MaxHold) then
                    newNotification("You\'re already holding the max amount of this item!");
                    u32.InDialog = false;
                    Dialog.Visible = false;
                    u32.dialogPart = nil;
                    BloodlinesFrame.Visible = false;

                    return;
                end;

                v262 = DataFunction:InvokeServer(u32.NPCModule.Type);
            elseif u32.NPCModule.Type == "canStartAyruiQuest2" then
                v262 = GameManager:canStartAyruiQuest2(u11);
            elseif u32.NPCModule.Type == "IsobuExit" then
                v262 = DataFunction:InvokeServer("IsobuExit");
            end;
        end;
    end;

    if u32.InDialog ~= true then
        print("requirement not met");

        return;
    end;

    print("indeed u are in dialog");
    local v284, v285;

    if v262 == true then
        v284 = v263 or u32.NPCModule.Response .. " " .. (v264 or "");
        v285 = 0;

        for i = 1, 5 do
            local v286 = u32.NPCModule["Option" .. i];

            if v286 and (not v286.Condition or GameManager:checkOptionCondition(LocalPlayer, u11, v286.Condition)) then
                v285 = v285 + 1;
            end;
        end;
    elseif v262 == "FailedV1" then
        u32.NPCModule = u32.NPCModule.FailedV1;
        v284 = u32.NPCModule.Response .. " " .. v264;
        v285 = 1;
    elseif v262 == "FailedV2" then
        u32.NPCModule = u32.NPCModule.FailedV2;
        v284 = u32.NPCModule.Response .. " " .. v264;
        v285 = 1;
    elseif v262 == "FailedV3" then
        u32.NPCModule = u32.NPCModule.FailedV3;
        v284 = u32.NPCModule.Response .. " " .. v264;
        v285 = 1;
    elseif v262 == "FailedV4" then
        u32.NPCModule = u32.NPCModule.FailedV4;
        v284 = u32.NPCModule.Response .. " " .. v264;
        v285 = 1;
    elseif typeof(v262) == "string" and u32.NPCModule[v262] then
        u32.NPCModule = u32.NPCModule[v262];
        v284 = u32.NPCModule.Response .. " " .. v264;
        v285 = u32.NPCModule.Type == "Quit" and 1 or 0;

        for i = 1, 5 do
            local v287 = u32.NPCModule["Option" .. i];

            if v287 and (not v287.Condition or GameManager:checkOptionCondition(LocalPlayer, u11, v287.Condition)) then
                v285 = v285 + 1;
            end;
        end;

        warn(v285);
    else
        u32.NPCModule = u32.NPCModule.Failed;
        v284 = u32.NPCModule.Response .. " " .. v264;
        v285 = 1;
    end;

    u32.DisplayingText = true;
    local v288 = v284:gsub("<br%s*/>", "\n");
    v288:gsub("<[^<>]->", "");
    Dialog.DialogBack.InfoText.Text = v288;

    for i = 1, #v288 + 1, 2 do
        Dialog.DialogBack.InfoText.MaxVisibleGraphemes = i;
        wait();
    end;

    u32.DisplayingText = false;

    if v262 ~= false and (v262 ~= "FailedV1" and v262 ~= "FailedV2") then
        for i = 1, v285 do
            Dialog["Dialog" .. v285 .. "_Option" .. i].Visible = true;

            if u32.NPCModule["Option" .. i] then
                Dialog["Dialog" .. v285 .. "_Option" .. i].DialogText.Text = u32.NPCModule["Option" .. i].Text;
            end;

            if i == 1 then
                Dialog["Dialog" .. v285 .. "_Option" .. i].DialogText.Text = "[E] - " .. Dialog["Dialog" .. v285 .. "_Option" .. i].DialogText.Text;
            end;
        end;

        return;
    end;

    Dialog.Dialog1_Option1.Visible = true;
    Dialog.Dialog1_Option1.DialogText.Text = u32.NPCModule.Text or u32.NPCModule.Option1.Text;
end;

function newNotification(p289, p290, p291, p292)
    -- upvalues: u11 (ref), updateChains (copy), updateSharks (copy), Mainframe (copy), Debris (copy), TweenService (copy)
    local v293;

    if p289 == "Sinless Restored" or (p289 == "Sins Decreased" or p289 == "A chain has been converted...") then
        v293 = Color3.fromRGB(255, 160, 43);

        if u11.Bloodline == "Uzumaki" then
            updateChains();
        end;
    elseif p289 == "Sins Increased" then
        v293 = Color3.fromRGB(255, 41, 116);
    elseif p289 == "New Chakra Point" or p289 == "A shark has awakened..." then
        if u11.Bloodline == "Hoshigaki" then
            updateSharks();
        end;

        v293 = Color3.fromRGB(47, 175, 255);
    elseif p289 == "Aged Up" then
        v293 = Color3.fromRGB(20, 255, 157);
    elseif p289 == "Quest Completed" then
        v293 = Color3.fromRGB(255, 123, 141);
    else
        v293 = p292 or Color3.fromRGB(225, 225, 175);
    end;

    local Notification = Mainframe:WaitForChild("Notification");
    Notification.Visible = true;
    local u294 = Notification[(p290 or "Short") .. "MessageTemplate"]:Clone();
    u294.Parent = Notification;
    local v295 = 0.5;

    if Mainframe.NewArea.Visible == true then
        v295 = v295 + 0.5;
    end;

    local v296 = nil;

    if Notification:FindFirstChild("Notif1") then
        if Notification:FindFirstChild("Notif" .. 1) then
            v296 = "Notif" .. 2;
            v295 = v295 + 0.8;
        end;

        if Notification:FindFirstChild("Notif" .. 2) then
            v296 = "Notif" .. 3;
            v295 = v295 + 0.8;
        end;

        if Notification:FindFirstChild("Notif" .. 3) then
            v296 = "Notif" .. 4;
            v295 = v295 + 0.8;
        end;

        if Notification:FindFirstChild("Notif" .. 4) then
            v296 = "Notif" .. 5;
            v295 = v295 + 0.8;
        end;

        if Notification:FindFirstChild("Notif" .. 5) then
            v296 = "Notif" .. 6;
            v295 = v295 + 0.8;
        end;
    else
        v296 = "Notif1";
    end;

    u294.Name = v296;
    u294.Position = UDim2.new(0.5, 0, v295, 0);
    local Message = u294.Message;
    Message.Text = p289;
    Message.TextColor3 = v293;
    local u297 = p291 or 4;
    Debris:AddItem(u294, u297 + 1);
    TweenService:Create(u294, TweenInfo.new(0.5), {
        ImageTransparency = 0.5,
        Position = UDim2.new(0.5, 0, u294.Position.Y.Scale - 0.5, 0)
    }):Play();
    TweenService:Create(Message, TweenInfo.new(0.5), {
        TextTransparency = 0,
        TextStrokeTransparency = 0.5
    }):Play();
    delay(0.5, function() -- Line: 6129
        -- upvalues: u297 (copy), TweenService (ref), u294 (copy), Message (copy)
        wait(u297);
        TweenService:Create(u294, TweenInfo.new(0.5), {
            ImageTransparency = 1,
            Position = UDim2.new(0.5, 0, u294.Position.Y.Scale - 0.5, 0)
        }):Play();
        TweenService:Create(Message, TweenInfo.new(0.5), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play();
    end);
end;

local function endSlide(p298) -- Line: 6139
    -- upvalues: u32 (copy), DataEvent (copy), GameManager (copy), Humanoid (copy), u11 (ref), u9 (copy), HumanoidRootPart (copy), disableRun (copy)
    u32.Sliding = false;
    u32.Occupied = false;
    DataEvent:FireServer("StopSound", "GrassSlide", true, 0.5);
    GameManager:stopAnimation("Slide", Humanoid);

    if u11.FOV == "On" then
        GameManager:TweenObject(workspace.CurrentCamera, {
            FieldOfView = GameManager.Settings.DefaultFOV
        }, 0.5);
    end;

    for _, child in ipairs(u9.Torso:GetChildren()) do
        if child.Name == "SlideSmoke" then
            child:Destroy();
        end;
    end;

    for _, child in ipairs(HumanoidRootPart:GetChildren()) do
        if child.Name == "SlideBV" then
            child:Destroy();
        end;
    end;

    Humanoid.AutoRotate = true;

    if p298 then
        disableRun("Stop");

        return;
    end;

    disableRun();
end;

local function detectLedge() -- Line: 6167
    -- upvalues: HumanoidRootPart (copy), u9 (copy), Humanoid (copy), GameManager (copy), u11 (ref), u32 (copy)
    local v299 = HumanoidRootPart.CFrame.p + Vector3.new(0, -0.4, 0);
    local v300 = HumanoidRootPart.CFrame.lookVector * 2;
    local v301 = RaycastParams.new();
    v301.FilterDescendantsInstances = { u9 };
    v301.FilterType = Enum.RaycastFilterType.Exclude;
    local _ = HumanoidRootPart.CFrame - HumanoidRootPart.CFrame.p;
    local v302 = nil;
    local v303 = false;

    for i = 1, 20 do
        v299 = v299 + Vector3.new(0, 0.2, 0);
        v300 = v300 + Vector3.new(0, 0.3, 0);
        local v304 = workspace:Raycast(v299, v300, v301);

        if v304 and (not v304.Instance.Parent:FindFirstChild("Humanoid") and v304.Instance.CanCollide == true) then
            v302 = v304.Position.Y - 0.5;
            v303 = true;
        end;

        if not v304 and v303 then
            print("VaultOverLedge");
            Humanoid.AutoRotate = false;

            if GameManager:hasSkill(u11, "Core Strength") then
                GameManager:createBodyPosition(HumanoidRootPart, Vector3.new(HumanoidRootPart.Position.X, v302, HumanoidRootPart.Position.Z), Vector3.new(200000, 200000, 200000), nil, nil, 15, "VaultBV");
            else
                GameManager:createBodyPosition(HumanoidRootPart, Vector3.new(HumanoidRootPart.Position.X, v302, HumanoidRootPart.Position.Z), Vector3.new(200000, 200000, 200000), nil, nil, 2.5, "VaultBV");
            end;

            return true;
        end;

        if i == 20 and (v303 and (u32.hasDoubleJumped == true and (u32.canDoubleJump == false and (u32.canTripleJump == false and (not u32.fakeVaultCD and (u32.InDanger == false or u32.Settings.JumpCounters.Value > 0)))))) then
            u32.fakeVaultCD = true;
            u32.fakeVaultActive = true;
            Humanoid.AutoRotate = false;

            if GameManager:hasSkill(u11, "Core Strength") then
                GameManager:createBodyPosition(HumanoidRootPart, Vector3.new(HumanoidRootPart.Position.X, v302, HumanoidRootPart.Position.Z), Vector3.new(200000, 200000, 200000), nil, nil, 15, "VaultBV");
            else
                GameManager:createBodyPosition(HumanoidRootPart, Vector3.new(HumanoidRootPart.Position.X, v302, HumanoidRootPart.Position.Z), Vector3.new(200000, 200000, 200000), nil, nil, 2.5, "VaultBV");
            end;

            return true;
        end;
    end;

    return nil;
end;

local function jumpReset() -- Line: 6226
    -- upvalues: u32 (copy), Humanoid (copy)
    u32.Jumped = false;
    u32.jumpAmount = 0;
    u32.hasDoubleJumped = false;
    u32.canTripleJump = false;

    if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        u32.canDoubleJump = true;
    end;
end;

local function visualAilment(p305, p306, p307, p308) -- Line: 6237
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), Debris (copy)
    local u309 = p307 or 0.5;
    local u310 = nil;
    local v311 = 0;

    if p305 == "Blood" or (p305 == "minorBlood" or p305 == "superMinorBlood") then
        u310 = ReplicatedStorage.UI.BasicOverlay:Clone();
        u310.ImageColor3 = Color3.fromRGB(255, 0, 4);

        if p305 == "Blood" then
            v311 = 0.2;
        elseif p305 == "minorBlood" then
            v311 = 0.5;
        elseif p305 == "superMinorBlood" then
            v311 = 0.7;
        end;
    elseif p305 == "SmokeOverlay" then
        u310 = ReplicatedStorage.UI.SmokeOverlay:Clone();
        u310.ImageColor3 = p308 or Color3.fromRGB(97, 200, 255);
        v311 = 0;
    elseif p305 == "TunnelVision" then
        u310 = ReplicatedStorage.UI.BasicOverlay:Clone();
        u310.ImageColor3 = Color3.fromRGB(0, 0, 0);
        v311 = 0.3;
    elseif p305 == "RedTunnelVision" then
        u310 = ReplicatedStorage.UI.BasicOverlay:Clone();
        u310.ImageColor3 = Color3.fromRGB(255, 0, 0);
        v311 = 0.7;
    elseif p305 == "FullScreen" then
        u310 = ReplicatedStorage.UI.FullOverlay:Clone();
        u310.ImageColor3 = p308 or Color3.fromRGB(0, 0, 0);
        v311 = 0;
    end;

    u310.Name = p305;
    u310.Parent = GUI;
    u310.ImageTransparency = 1;
    TweenService:Create(u310, TweenInfo.new(u309), {
        ImageTransparency = v311
    }):Play();
    delay(u309 + (p306 or 0), function() -- Line: 6277
        -- upvalues: u310 (ref), TweenService (ref), u309 (copy), Debris (ref)
        if u310 then
            TweenService:Create(u310, TweenInfo.new(u309), {
                ImageTransparency = 1
            }):Play();
            Debris:AddItem(u310, u309);
        end;
    end);
end;

local function chakraLandCheck(p312) -- Line: 6285
    -- upvalues: u32 (copy), GameManager (copy), u11 (ref), LocalPlayer (copy), DataEvent (copy), visualAilment (copy)
    if u32.ChargingChakra ~= true or (u32.Knocked ~= false or (not GameManager:hasSkill(u11, "Chakra Land") or LocalPlayer.Backpack.chakra.Value <= p312 / 1.8)) then
        return false;
    end;

    DataEvent:FireServer("TakeChakra", p312 / 1.8);
    visualAilment("SmokeOverlay");

    return true;
end;

local Fall_Damage_Scale = u32.Fall_Damage_Scale;

local function fallDamage(p313) -- Line: 6298
    -- upvalues: u9 (copy), u10 (copy), u32 (copy), Fall_Damage_Scale (copy), GameManager (copy), u11 (ref), u6 (ref), ReplicatedStorage (copy), LocalPlayer (copy), chakraLandCheck (copy), DataEvent (copy), visualAilment (copy), HumanoidRootPart (copy), Humanoid (copy), disableRun (copy)
    if u9:FindFirstChild("ForceField") or (u10.BeingCarried.Value ~= "None" or (u9:GetAttribute("FallDamageImmunity") or (u10.Awakened.Value == "Matatabi Cloak" or u9:FindFirstChild("NegateFall")))) then
        u32.Last_Y = u9.Torso.Position.Y;

        return;
    end;

    if u32.Last_Y and (u9 and (not u9:FindFirstChild("ForceField") and u9:FindFirstChild("Torso"))) then
        local v314 = u32.Last_Y - u9.Torso.Position.Y;
        u32.Fall_Damage_Scale = Fall_Damage_Scale;

        if u32.Fall_Damage_Begin < v314 then
            local v315 = math.min(99, (v314 - u32.Fall_Damage_Begin) * u32.Fall_Damage_Scale);

            if GameManager:hasSkill(u11, "Lightweight") then
                v315 = v315 * 0.85;
            end;

            if GameManager:searchInList(u11.Injuries, "Fractured Ribs") then
                v315 = v315 * 1.15;
                u6.BoneCrack:Play();
            end;

            if ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Wind") then
                v315 = v315 * 1.5;
            end;

            if u9:GetAttribute("FallDamageMultiplier") then
                v315 = v315 * u9:GetAttribute("FallDamageMultiplier");
            end;

            if GameManager.Clothing[u11.Clothing].FallResistance then
                v315 = v315 * GameManager.Clothing[u11.Clothing].FallResistance;
            end;

            if not chakraLandCheck(v315) and u11.Ring ~= "Ring Of The Neoncat" then
                DataEvent:FireServer("TakeDamage", v315);
                visualAilment("superMinorBlood");
            end;

            if v315 > 25 and (u32.Knocked == true and u11.Reanimated == false) then
                DataEvent:FireServer("KillMe");
            end;

            if p313 then
                u32.Last_Y = nil;
                local v316, _ = GameManager:downwardsRay(u9);
                local v317;

                if v316 then
                    v317 = v316.Color;
                else
                    v317 = nil;
                end;

                GameManager:smokeBlock(HumanoidRootPart.Position + Vector3.new(0, 0, -3), "Big", v317 or Color3.new(150, 150, 150));
                GameManager:getAnimation("Landed", Humanoid):Play();
                u6.Landed:Play();
            else
                u32.Last_Y = u9.Torso.Position.Y;
            end;

            disableRun();
        end;
    end;
end;

local u318 = nil;
local u319 = nil;
local u320 = nil;
local u321 = nil;

local function updatePosition(p322) -- Line: 6357
    -- upvalues: u320 (ref), SkillsFrame (copy), u321 (ref)
    local v323 = p322.Position - u320;
    SkillsFrame.Position = UDim2.new(u321.X.Scale, u321.X.Offset + v323.X, u321.Y.Scale, u321.Y.Offset + v323.Y);
end;

local function startDrag(u324) -- Line: 6362
    -- upvalues: u318 (ref), u320 (ref), u321 (ref), SkillsFrame (copy)
    u318 = true;
    u320 = u324.Position;
    u321 = SkillsFrame.Position;
    u324.Changed:Connect(function() -- Line: 6367
        -- upvalues: u324 (copy), u318 (ref)
        if u324.UserInputState == Enum.UserInputState.End then
            u318 = false;
        end;
    end);
end;

local function distanceCheck(p325) -- Line: 6374
    -- upvalues: HumanoidRootPart (copy)
    return (p325.Position - HumanoidRootPart.Position).magnitude <= 30;
end;

local function awakening(p326) -- Line: 6381
    -- upvalues: u32 (copy), DataFunction (copy), GameManager (copy), Humanoid (copy), setRunSpeed (copy), TweenService (copy), LocalPlayer (copy)
    local v327 = p326 or u32.Selected;

    if u32.Settings.Awakened.Value == "" and (u32.Settings.AwakeningCooldown.Value == 0 and DataFunction:InvokeServer("Awaken", v327)) then
        if skillsModule[v327].ActivationAnimation then
            GameManager:getAnimation(skillsModule[v327].ActivationAnimation, Humanoid):Play();
        end;

        if skillsModule[v327].SpeedIncrease then
            u32.awakeningSpeed = skillsModule[v327].SpeedIncrease;

            if u32.Running then
                setRunSpeed();
            else
                Humanoid.WalkSpeed = u32.OriginSpeed;
            end;
        end;

        if v327:find("Sharingan") then
            return;
        end;

        if v327:find("Byakugan") then
            TweenService:Create(LocalPlayer, TweenInfo.new(0.5), {
                CameraMaxZoomDistance = 60
            }):Play();
        end;
    end;
end;

local function skillAllowedDash() -- Line: 6409
    -- upvalues: u9 (copy), u32 (copy), GameManager (copy), u11 (ref)
    local v328 = u9:GetAttribute("UsingMasteredJutsu", u32.skillInUse);

    return u32.Occupied == true and skillsModule[u32.skillInUse] and (skillsModule[u32.skillInUse].AllowsDashing or v328 and (GameManager:isJutsuMastered(u11, u32.skillInUse) and skillsModule[u32.skillInUse].MasteryAllowsDashing) or u32.usedSingleSkillDash == false and skillsModule[u32.skillInUse].AllowsOneDashInBase) and true or false;
end;

local u329 = nil;

local function dashInfo(p330) -- Line: 6419
    -- upvalues: u32 (copy), GameManager (copy), u11 (ref), skillAllowedDash (copy), Humanoid (copy), HumanoidRootPart (copy), u329 (ref)
    local v331 = nil;
    local v332 = nil;
    local v333 = (p330 or u32.ChargingChakra ~= true) and (p330 or 30) or 36;

    if GameManager:searchInList(u11.Traits, "Agile") then
        v333 = v333 * GameManager.Traits.Agile.SpeedDiff;
    end;

    if u32.Settings.Awakened.Value == "Red Gates" then
        v333 = v333 * 2.5;
    end;

    local v334;

    if u32.HoldingForward == 2 then
        if skillAllowedDash() then
            v334 = GameManager:getAnimation("ForwardAirDash", Humanoid);
            v333 = v333 * 1.5;
            print("skill allowed dash");
        else
            v334 = GameManager:getAnimation("ForwardDash", Humanoid);
            print("normal dash");
        end;

        return v334, (HumanoidRootPart.CFrame * CFrame.new(0, 0, v333 * -1)).p;
    end;

    local v335, v336;

    if u32.HoldingForward == 1 then
        local HoldingForward = u32.HoldingForward;
        local v337 = 0;

        if u32.HoldingForward < HoldingForward then
            v337 = v337 + 1;
        end;

        if u32.HoldingRight < HoldingForward then
            v337 = v337 + 1;
        end;

        if u32.HoldingLeft < HoldingForward then
            v337 = v337 + 1;
        end;

        if u32.HoldingBack < HoldingForward then
            v337 = v337 + 1;
        end;

        if v337 >= 3 == true then
            if skillAllowedDash() then
                v334 = GameManager:getAnimation("ForwardAirDash", Humanoid);
                v333 = v333 * 1.5;
                print("skill allowed dash");
            else
                v334 = GameManager:getAnimation("ForwardDash", Humanoid);
                print("normal dash");
            end;

            return v334, (HumanoidRootPart.CFrame * CFrame.new(0, 0, v333 * -1)).p;
        end;

        if u32.Shiftlocked == false then
            if skillAllowedDash() then
                v334 = GameManager:getAnimation("ForwardAirDash", Humanoid);
                v333 = v333 * 1.5;
                print("skill allowed dash");
            else
                v334 = GameManager:getAnimation("ForwardDash", Humanoid);
                print("normal dash");
            end;

            return v334, (HumanoidRootPart.CFrame * CFrame.new(0, 0, v333 * -1)).p;
        end;

        if u32.HoldingRight == 2 then
            return GameManager:getAnimation("RightGroundDash", Humanoid), (HumanoidRootPart.CFrame * CFrame.new(v333, 0, 0)).p;
        end;

        if u32.HoldingRight == 1 then
            v335 = u32.HoldingRight;
            v336 = 0;

            if u32.HoldingForward < v335 then
                v336 = v336 + 1;
            end;

            if u32.HoldingRight < v335 then
                v336 = v336 + 1;
            end;

            if u32.HoldingLeft < v335 then
                v336 = v336 + 1;
            end;

            if u32.HoldingBack < v335 then
                v336 = v336 + 1;
            end;

            if v336 >= 3 == true then
                return GameManager:getAnimation("RightGroundDash", Humanoid), (HumanoidRootPart.CFrame * CFrame.new(v333, 0, 0)).p;
            end;
        end;
    else
        if u32.Shiftlocked == false then
            if skillAllowedDash() then
                v334 = GameManager:getAnimation("ForwardAirDash", Humanoid);
                v333 = v333 * 1.5;
                print("skill allowed dash");
            else
                v334 = GameManager:getAnimation("ForwardDash", Humanoid);
                print("normal dash");
            end;

            return v334, (HumanoidRootPart.CFrame * CFrame.new(0, 0, v333 * -1)).p;
        end;

        if u32.HoldingRight == 2 then
            return GameManager:getAnimation("RightGroundDash", Humanoid), (HumanoidRootPart.CFrame * CFrame.new(v333, 0, 0)).p;
        end;

        if u32.HoldingRight == 1 then
            v335 = u32.HoldingRight;
            v336 = 0;

            if u32.HoldingForward < v335 then
                v336 = v336 + 1;
            end;

            if u32.HoldingRight < v335 then
                v336 = v336 + 1;
            end;

            if u32.HoldingLeft < v335 then
                v336 = v336 + 1;
            end;

            if u32.HoldingBack < v335 then
                v336 = v336 + 1;
            end;

            if v336 >= 3 == true then
                return GameManager:getAnimation("RightGroundDash", Humanoid), (HumanoidRootPart.CFrame * CFrame.new(v333, 0, 0)).p;
            end;
        end;
    end;

    if u32.HoldingLeft == 2 then
        return GameManager:getAnimation("LeftGroundDash", Humanoid), (HumanoidRootPart.CFrame * CFrame.new(v333 * -1, 0, 0)).p;
    end;

    if u32.HoldingLeft == 1 then
        local HoldingLeft = u32.HoldingLeft;
        local v338 = 0;

        if u32.HoldingForward < HoldingLeft then
            v338 = v338 + 1;
        end;

        if u32.HoldingRight < HoldingLeft then
            v338 = v338 + 1;
        end;

        if u32.HoldingLeft < HoldingLeft then
            v338 = v338 + 1;
        end;

        if u32.HoldingBack < HoldingLeft then
            v338 = v338 + 1;
        end;

        if v338 >= 3 == true then
            return GameManager:getAnimation("LeftGroundDash", Humanoid), (HumanoidRootPart.CFrame * CFrame.new(v333 * -1, 0, 0)).p;
        end;
    end;

    if u32.HoldingBack == 2 then
        if GameManager:hasSkill(u11, "Aerial Backflip") and not u329 then
            u329 = true;
            v331 = GameManager:getAnimation("AerialBackDash", Humanoid);
            task.delay(6, function() -- Line: 6455
                -- upvalues: u329 (ref)
                u329 = nil;
            end);
        else
            v331 = GameManager:getAnimation("BackGroundDash", Humanoid);
        end;

        v332 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, v333)).p;
    elseif u32.HoldingBack == 1 then
        local HoldingBack = u32.HoldingBack;
        local v339 = 0;

        if u32.HoldingForward < HoldingBack then
            v339 = v339 + 1;
        end;

        if u32.HoldingRight < HoldingBack then
            v339 = v339 + 1;
        end;

        if u32.HoldingLeft < HoldingBack then
            v339 = v339 + 1;
        end;

        if u32.HoldingBack < HoldingBack then
            v339 = v339 + 1;
        end;

        if v339 >= 3 == true then
            if GameManager:hasSkill(u11, "Aerial Backflip") and not u329 then
                u329 = true;
                v331 = GameManager:getAnimation("AerialBackDash", Humanoid);
                task.delay(6, function() -- Line: 6455
                    -- upvalues: u329 (ref)
                    u329 = nil;
                end);
            else
                v331 = GameManager:getAnimation("BackGroundDash", Humanoid);
            end;

            v332 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, v333)).p;
        end;
    end;

    return v331, v332;
end;

function canM1()
    -- upvalues: u32 (copy), u9 (copy)
    local v340;

    if u32.Settings.CurrentSkill.Value == "" and (u32.Consuming == false and (tick() - u32.MeleeCooldown > 0.1 and (u32.Settings.Gripping.Value == "None" and (u32.Settings.MeleeCooldown.Value == false and (u32.Occupied == false and (u32.Settings.Stunned.Value == false and (u32.Settings.Blocking.Value == false and u32.Knocked == false))))))) then
        v340 = not u9:FindFirstChild("ForceField");

        if v340 then
            if u32.Dashing == false then
                v340 = not u9:GetAttribute("KotoamatsukamiForceMove") and not u9:GetAttribute("KotoamatsukamiAttacking");
            else
                v340 = false;
            end;
        end;
    else
        v340 = false;
    end;

    return v340;
end;

function performM1()
    -- upvalues: u32 (copy), GameManager (copy), HumanoidRootPart (copy), DataEvent (copy), Humanoid (copy), u9 (copy), u11 (ref), disableRun (copy), LocalPlayer (copy)
    local v341 = u32.Settings.CombatCount.Value + 1;
    u32.Occupied = true;
    u32.MeleeCooldown = tick();
    u32.CombatType = u32.Settings.CombatType.Value;
    u32.CombatTable = GameManager:getCombatTable(u32.CombatType);

    if v341 == 1 and u32.Running then
        GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 55, 0.2, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update");
    end;

    DataEvent:FireServer("CheckMeleeHit", nil, "NormalAttack", u32.Running);

    for i, v in next, u32.CombatTable.Combo do
        if tonumber(i) == v341 then
            if v.Animation ~= "" then
                local v342, v343 = GameManager:getAnimation(v.Animation, Humanoid, Enum.AnimationPriority.Action3);
                v342:Play();

                if v343 then
                    v342:AdjustSpeed(v343);
                end;

                v342:AdjustSpeed(v342.Speed * (1 + (u9:GetAttribute("CombatFluidity") or 1) / 100));
            end;

            u32.ActionTime = v.ActionTime;
        end;
    end;

    if v341 == u32.CombatTable.ComboLength then
        if u32.Running == true then
            task.delay(u32.ActionTime, function() -- Line: 6519
                -- upvalues: u32 (ref), disableRun (ref)
                if u32.Running == true then
                    disableRun("Stop");
                end;
            end);
        end;
    else
        task.wait(u32.ActionTime);

        if u32.Running == true and (u11.Bloodline ~= "Hoshigaki" and (not GameManager:hasImplantedArm(u11, "Torn Hoshigaki Arm") and u32.Settings.Awakened.Value ~= "Isobu Cloak") or Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming) then
            if v341 == 1 then
                task.delay(u32.ActionTime, function() -- Line: 6510
                    -- upvalues: disableRun (ref)
                    disableRun();
                end);
            else
                disableRun();
            end;
        end;
    end;

    if u32.Settings.Stunned.Value ~= false then
        u32.Occupied = false;

        return;
    end;

    local v344 = GameManager:createRegion3((HumanoidRootPart.CFrame * u32.CombatTable.Point1).p, (HumanoidRootPart.CFrame * u32.CombatTable.Point2).p);
    local v345 = false;

    for _, v in pairs(game.Workspace:FindPartsInRegion3(v344, nil, (1 / 0))) do
        if v.Parent then
            local v346 = v.Parent:FindFirstChild("Settings") and v.Parent.Settings:FindFirstChild("NPC") and true or false;

            if (game.Players:FindFirstChild(v.Parent.Name) or v346 == true) and (v345 == false and (v.Parent:FindFirstChild("Humanoid") and v.Parent.Name ~= LocalPlayer.Name)) then
                GameManager:CameraShake(u9, 6, 0.25);
                v345 = true;
            end;
        end;
    end;
end;

function attemptMelee()
    -- upvalues: u32 (copy), u9 (copy), GameManager (copy), HumanoidRootPart (copy), DataEvent (copy), Humanoid (copy), u11 (ref), disableRun (copy), LocalPlayer (copy)
    if u32.Settings.CurrentSkill.Value == "" and (u32.Consuming == false and (tick() - u32.MeleeCooldown > 0.1 and (u32.Settings.Gripping.Value == "None" and (u32.Settings.MeleeCooldown.Value == false and (u32.Occupied == false and (u32.Settings.Stunned.Value == false and (u32.Settings.Blocking.Value == false and (u32.Knocked == false and (not u9:FindFirstChild("ForceField") and u32.Dashing == false))))))))) then
        local v347 = u32.Settings.CombatCount.Value + 1;
        u32.Occupied = true;
        u32.MeleeCooldown = tick();
        u32.CombatType = u32.Settings.CombatType.Value;
        u32.CombatTable = GameManager:getCombatTable(u32.CombatType);

        if v347 == 1 and u32.Running then
            GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 55, 0.2, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update");
        end;

        DataEvent:FireServer("CheckMeleeHit", nil, "NormalAttack", u32.Running);

        for i, v in next, u32.CombatTable.Combo do
            if tonumber(i) == v347 then
                if v.Animation ~= "" then
                    local v348, v349 = GameManager:getAnimation(v.Animation, Humanoid, Enum.AnimationPriority.Action3);
                    v348:Play();

                    if v349 then
                        v348:AdjustSpeed(v349);
                    end;

                    v348:AdjustSpeed(v348.Speed * (1 + (u9:GetAttribute("CombatFluidity") or 1) / 100));
                end;

                u32.ActionTime = v.ActionTime;
            end;
        end;

        if v347 == u32.CombatTable.ComboLength then
            if u32.Running == true then
                task.delay(u32.ActionTime, function() -- Line: 6612
                    -- upvalues: u32 (ref), disableRun (ref)
                    if u32.Running == true then
                        disableRun("Stop");
                    end;
                end);
            end;
        else
            task.wait(u32.ActionTime);

            if u32.Running == true and (u11.Bloodline ~= "Hoshigaki" and (not GameManager:hasImplantedArm(u11, "Torn Hoshigaki Arm") and u32.Settings.Awakened.Value ~= "Isobu Cloak") or Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming) then
                if v347 == 1 then
                    task.delay(u32.ActionTime, function() -- Line: 6603
                        -- upvalues: disableRun (ref)
                        disableRun();
                    end);
                else
                    disableRun();
                end;
            end;
        end;

        if u32.Settings.Stunned.Value == false then
            local v350 = GameManager:createRegion3((HumanoidRootPart.CFrame * u32.CombatTable.Point1).p, (HumanoidRootPart.CFrame * u32.CombatTable.Point2).p);
            local v351 = false;

            for _, v in pairs(game.Workspace:FindPartsInRegion3(v350, nil, (1 / 0))) do
                if v.Parent then
                    local v352 = v.Parent:FindFirstChild("Settings") and v.Parent.Settings:FindFirstChild("NPC") and true or false;

                    if (game.Players:FindFirstChild(v.Parent.Name) or v352 == true) and (v351 == false and (v.Parent:FindFirstChild("Humanoid") and v.Parent.Name ~= LocalPlayer.Name)) then
                        GameManager:CameraShake(u9, 6, 0.25);
                        v351 = true;
                    end;
                end;
            end;

            return;
        end;

        u32.Occupied = false;
    end;
end;

local function onKeyDown(u353, p354) -- Line: 6658
    -- upvalues: u9 (copy), u32 (copy), SkillsFrame (copy), u318 (ref), u320 (ref), u321 (ref), u1 (copy), HumanoidRootPart (copy), DataEvent (copy), GameManager (copy), selectNewItem (copy), u11 (ref), slotItemAction (copy), LocalPlayer (copy), Cookbook (copy), ReplicatedStorage (copy), Emit (copy), Debris (copy), u6 (ref), Humanoid (copy), disableRun (copy), Dialog (copy), newText (copy), Unselect (copy), DataFunction (copy), awakening (copy), RunService (copy), HeavyAttack (copy), PlayerList (copy), Rest (copy), u58 (copy), SettingsFrame (copy), Loadout (copy), Ryo (copy), Embers (copy), Inventory (copy), UpdateInventory (copy), closeInventory (copy), Mainframe (copy), u7 (copy), u57 (copy), MainMenuFrame (copy), updateTeleportLocations (copy), u56 (copy), Acumen (copy), running (copy), setRunSpeed (copy), u48 (copy), UserInputService (copy), u49 (copy), slotDown (copy), CollectionService (copy), u10 (copy), detectLedge (copy), fallDamage (copy), skillAllowedDash (copy), dashInfo (copy), SubIndicator (copy), InventoryScroll (copy)
    local v355 = u353.UserInputType == Enum.UserInputType.MouseButton1;

    if u9:GetAttribute("ScrambledMind") then
        v355 = u353.KeyCode == Enum.KeyCode.F;
    end;

    local v356 = u353.UserInputType == Enum.UserInputType.MouseButton2;

    if u9:GetAttribute("ScrambledMind") then
        v356 = u353.KeyCode == Enum.KeyCode.Q;
    end;

    if v355 then
        u32.HoldingMouseButton1 = true;
    elseif v356 then
        u32.HoldingMouseButton2 = true;
    end;

    if u353.UserInputType == Enum.UserInputType.MouseButton1 then
        u32.OriginalHoldingMouseButton1 = true;
    elseif u353.UserInputType == Enum.UserInputType.MouseButton2 then
        u32.OriginalHoldingMouseButton1 = true;
    end;

    if p354 and (u353.KeyCode ~= Enum.KeyCode.Return and (u353.KeyCode ~= Enum.KeyCode.ButtonA and (u353.KeyCode ~= Enum.KeyCode.ButtonB and (u353.KeyCode ~= Enum.KeyCode.ButtonR3 and (u353.KeyCode ~= Enum.KeyCode.DPadLeft and u353.KeyCode ~= Enum.KeyCode.DPadRight))))) then
        return;
    end;

    local v357 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.S or Enum.KeyCode.W;
    local v358 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.W or Enum.KeyCode.S;
    local v359 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.D or Enum.KeyCode.A;
    local v360 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.A or Enum.KeyCode.D;
    local v361 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.Q or Enum.KeyCode.R;
    local v362 = u353.KeyCode == Enum.KeyCode.F;

    if u9:GetAttribute("ScrambledMind") then
        v362 = u353.UserInputType == Enum.UserInputType.MouseButton1;
    end;

    local v363 = u353.KeyCode == Enum.KeyCode.Q;

    if u9:GetAttribute("ScrambledMind") then
        v363 = u353.UserInputType == Enum.UserInputType.MouseButton2;
    end;

    if u353.UserInputType == Enum.UserInputType.Touch then
        if SkillsFrame.Visible == true then
            u318 = true;
            u320 = u353.Position;
            u321 = SkillsFrame.Position;
            u353.Changed:Connect(function() -- Line: 6367
                -- upvalues: u353 (copy), u318 (ref)
                if u353.UserInputState == Enum.UserInputState.End then
                    u318 = false;
                end;
            end);
        end;
    elseif v355 then
        local v364 = false;

        if SkillsFrame.Visible == true then
            u318 = true;
            u320 = u353.Position;
            u321 = SkillsFrame.Position;
            u353.Changed:Connect(function() -- Line: 6367
                -- upvalues: u353 (copy), u318 (ref)
                if u353.UserInputState == Enum.UserInputState.End then
                    u318 = false;
                end;
            end);
        end;

        if u32.Broken == false then
            if u1.Target and (u1.Target.Name == "ActivationButton" and u1.Target.Parent.Activated.Value == false) and (u1.Target.Position - HumanoidRootPart.Position).magnitude <= 30 then
                DataEvent:FireServer("ActivateButton", u1.Target.Parent);
            end;

            if skillsModule[u32.Settings.CurrentSkill.Value] and (skillsModule[u32.Settings.CurrentSkill.Value].CanDeactivate == true and u32.Casting == false) then
                DataEvent:FireServer("DeactivateSkill");
                local v365 = skillsModule[u32.Settings.CurrentSkill.Value];

                if v365.RequiresWeapon and not GameManager:inBaseCombat(v365.RequiresWeapon) then
                    selectNewItem(u11, u11.CurrentWeapon);
                end;
            elseif u1.Target and (u1.Target.Name:sub(1, 10) == "BowlHolder" and (u1.Target.Occupied.Value == "" and u32.Selected == "Bowl")) then
                DataEvent:FireServer("PlaceBowl", u1.Target);
                slotItemAction("Unselected", u32.Selected);
            elseif u1.Target and (u1.Target.Name == "Blue Stone" and u32.Selected == "Flower Bouquet") then
                DataEvent:FireServer("PlaceFlowerBouquet", u1.Target);
            elseif u1.Target and (u1.Target.Name:sub(1, 12) == "CookingWater" and (workspace:FindFirstChild("BowlHolder" .. u1.Target.Parent.Name:sub(12)).Occupied.Value == LocalPlayer.Name and GameManager.Items[u32.Selected])) and (GameManager.Items[u32.Selected].ExtraInfo and GameManager.Items[u32.Selected].ExtraInfo == "Fruit" or GameManager.Items[u32.Selected].Cookable) then
                DataEvent:FireServer("AddFruit", u1.Target, u32.Selected);
            elseif u1.Target and (u1.Target.Name == "BowlFinish" and u1.Target.Parent.Occupied.Value == LocalPlayer.Name) then
                DataEvent:FireServer("BowlFinish", u1.Target);
            elseif u32.Selected == "Crimson Ring" and game.Players:FindFirstChild(u1.Target.Parent.Name) then
                DataEvent:FireServer("InviteToClan", u1.Target.Parent.Name);
            elseif u32.Selected == "" or (u32.Consuming or (not skillsModule[u32.Selected] or (skillsModule[u32.Selected].SkillType ~= "Awakening" or (u32.Settings.Awakened.Value ~= u32.Selected or not (skillsModule[u32.Selected].MouseButton1 or skillsModule[u32.Selected]["C + M1"]))))) then
                if u1.Target and (u1.Target.Name:sub(1, 5) == "Lever" and u1.Target.Parent.Parent.Active.Value == false) then
                    DataEvent:FireServer("ActivateLever", u1.Target.Parent.Parent);
                elseif u32.Selected == "Cookbook" then
                    Cookbook.Visible = true;
                elseif u1.Target and u1.Target:FindFirstChild("Pickupable") then
                    local Active = u1.Target:FindFirstChild("Active");
                    local ID = u1.Target:FindFirstChild("ID");

                    if u32.pickUpCooldown == false and (Active and Active.Value == true) then
                        local v366 = nil;

                        if u1.Target:IsA("BasePart") then
                            v366 = u1.Target;
                        else
                            for _, child in ipairs(u1.Target:GetChildren()) do
                                if child:IsA("BasePart") then
                                    v366 = child;
                                end;
                            end;
                        end;

                        local v367 = u1.Target:GetAttribute("RealName");
                        local v368;

                        if v367 and (GameManager.Items[v367] and (GameManager.Items[v367].MaxHold and GameManager:hasItem(u11, v367, GameManager.Items[v367].MaxHold))) then
                            newNotification("You can\'t hold more of this item!");
                            v368 = false;
                        else
                            v368 = true;
                        end;

                        local v369 = u1.Target.Parent:IsA("Model") and u1.Target.Parent ~= workspace and u1.Target.Parent or u1.Target;

                        if v369:FindFirstChild("ClearedToPickUp") and not v369.ClearedToPickUp.Value:find(LocalPlayer.Name) then
                            newNotification("You can\'t pick this item!");
                            v368 = false;
                        end;

                        if (HumanoidRootPart.Position - v366.Position).Magnitude < 8 and v368 then
                            Active.Value = false;
                            DataEvent:FireServer("PickUp", ID.Value);
                            local v370 = ReplicatedStorage.Particles.PickUpEmit:Clone();
                            v370.Position = v366.Position;
                            v370.Parent = workspace.Debris;
                            Emit(v370);
                            Debris:AddItem(v370, 2);
                            u6.PickUp:Play();
                            GameManager:getAnimation("Harvest", Humanoid):Play();
                            HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, (Vector3.new(v366.Position.X, HumanoidRootPart.Position.Y, v366.Position.Z)));
                            HumanoidRootPart.Anchored = true;
                            u32.pickUpCooldown = true;
                            wait(0.2);
                            u32.pickUpCooldown = false;
                            HumanoidRootPart.Anchored = false;
                        end;
                    end;
                elseif u1.Target and (u1.Target.Name == "Festive Cracker" and (u1.Target.Parent and u1.Target.Parent.Name ~= LocalPlayer.Name)) then
                    DataEvent:FireServer("OpenFestiveCracker", u1.Target);
                elseif u1.Target and (u1.Target.Name:find("Relic") and (u1.Target.Parent == workspace and (u1.Target.Transparency == 0 and (u1.Target.Position - HumanoidRootPart.Position).magnitude < 15))) then
                    DataEvent:FireServer("Relic", u1.Target.Name);
                elseif u32.Selected == "Worm Stone" and (workspace.WormDoor.Unlocked.Value == false and (workspace.WormDoor.WormStone.Position - HumanoidRootPart.Position).magnitude < 15) then
                    DataEvent:FireServer("UnlockWormDoor");
                elseif u32.Selected == "Progression Soul" or u32.Selected == "Memory Soul" then
                    DataEvent:FireServer(u32.Selected);
                elseif u32.Selected == "Basalt Stone" and (workspace.BasaltDoor.Unlocked.Value == false and (workspace.BasaltDoor.BasaltStone.Position - HumanoidRootPart.Position).magnitude < 15) then
                    DataEvent:FireServer("UnlockBasaltDoor");
                elseif u32.Selected == "" or (not GameManager.Items[u32.Selected] or GameManager.Items[u32.Selected].BlockedByDanger and u32.InDanger == true) or (GameManager.Items[u32.Selected].Type ~= "Consumable" and GameManager.Items[u32.Selected].Type2 ~= "Consumable" or (u32.Knocked ~= false or (u32.Consuming ~= false or u32.Occupied and u32.RamenContest ~= true))) then
                    if u1.Target and (u1.Target:FindFirstChild("Buyable") and Dialog.Visible == false) and (u1.Target.Position - HumanoidRootPart.Position).magnitude <= 30 then
                        u32.dialogPart = u1.Target;
                        local Value = u1.Target.Buyable.Value;
                        local v371 = GameManager:getModifiedPrice(GameManager:getPrice(Value), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Buy");
                        u32.NPCModule = {
                            Response = "Purchase " .. Value .. " for " .. v371 .. " Ryo" .. (Value == "Biyo Armor" and " and 5 Broken Biyo Armor?" or (Value == "Peacemaker" and " and 3 Black Flame Gems?" or (Value == "Fighter\'s Outfit" and " and 2 Fighter\'s Wraps?" or (Value == "Reanimated Cloak" and " and a Reanimated Soul?" or (Value == "Ring Schematics" and " and 3 Chakra Fragments?" or (Value == "Thunder Cloak" and " and 5 Spark Gems?" or (Value == "Slithering Outfit" and " and a Snakeskin?" or (Value == "Martial Artist" and " and Martial Wraps?" or (Value == "Haku Outfit" and " and Ice Wraps?" or (Value == "Shisui Outfit" and " and Mangekyo Eyes?" or (Value == "Executioner\'s Blade" and " and an Executioner Schematic?" or (Value == "Bloody Executioner\'s Blade" and " and a Bloody Executioner Schematic?" or (Value == "Frozen Executioner\'s Blade" and " and a Frozen Executioner Schematic?" or (Value == "Samehada" and " and a Samehada Schematic?" or (Value == "Pumpkin Samehada" and " and a Pumpkin Samehada Schematic?" or (Value == "Tree Samehada" and " and a Tree Samehada Schematic?" or (Value == "Gunbai" and " and a Gunbai Schematic?" or (Value == "Spider Gunbai" and " and a Spider Gunbai Schematic?" or (Value == "Gingerbread Gunbai" and " and a Gingerbread Gunbai Schematic?" or (Value == "Kusanagi" and " and a Kusanagi Schematic?" or (Value == "Hallowed Kusanagi" and " and a Hallowed Kusanagi Schematic?" or (Value == "Candy Cane Kusanagi" and " and a Candy Cane Kusanagi Schematic?" or (Value:find("Cursed") and " and a Cursed Schematic?" or (Value:find("Infernal") and " and an Infernal Schematic?" or (Value:find("Raijin Kunai") and " and a Raijin Schematic?" or (Value:find("Chakra Bow") and ", Lava Snakeskin and a Samurai Soul?" or (Value:find("Spooky Raijin Kunai") and " and a Spooky Raijin Schematic?" or (Value:find("Nutcracker Raijin") and " and a Nutcracker Raijin Schematic?" or (Value == "Adamantine Staff" and " and a Staff Schematic?" or (Value == "Skeletal Adamantine Staff" and " and a Skeletal Staff Schematic?" or (Value == "Jingle Bell Staff" and " and a Jingle Bell Staff Schematic?" or "?"))))))))))))))))))))))))))))))),
                            Option1 = {
                                Text = "I\'ll pay.",
                                Type = "Payment",
                                Amount = v371,
                                Item = Value,
                                Response = "Item Purchase Complete.",
                                Option1 = {
                                    Text = "...",
                                    Type = "Quit"
                                },
                                Failed = {
                                    Response = "You\'re not able to purchase this.",
                                    Text = "...",
                                    Type = "Quit"
                                }
                            },
                            Option2 = {
                                Text = "Bye.",
                                Type = "Quit"
                            }
                        };
                        u32.InDialog = true;
                        Dialog.Visible = true;
                        Dialog.DialogBack.NPCName.Text = "???";
                        newText("HideBoxes");
                    elseif GameManager.Items[u32.Selected] and (GameManager.Items[u32.Selected].Type == "Accessory" and (u32.AccessoryCooldown == false and (u32.Knocked == false and u32.Occupied == false))) then
                        u32.AccessoryCooldown = true;
                        u32.Occupied = true;
                        local v372;

                        if GameManager.Items[u32.Selected].CustomEquipAnimation and (u11.WearingAccessory == "" or u11.WearingAccessory2 == "") then
                            v372 = GameManager:getAnimation(GameManager.Items[u32.Selected].CustomEquipAnimation, Humanoid);
                        else
                            v372 = GameManager:getAnimation(GameManager.Items[u32.Selected].Animation, Humanoid);
                        end;

                        v372:Play();
                        wait(0.18);

                        if u11.WearingAccessory == u32.Selected then
                            DataEvent:FireServer("Accessory", "UnEquip", u32.Selected);
                            u11.WearingAccessory = "";
                            GameManager:getAnimation(GameManager.Items[u32.Selected].HoldingAnimation, Humanoid):Play();
                            u32.ToolAnimation = GameManager.Items[u32.Selected].HoldingAnimation;
                        elseif u11.WearingAccessory2 == u32.Selected then
                            DataEvent:FireServer("Accessory", "UnEquip", u32.Selected);
                            u11.WearingAccessory2 = "";
                            GameManager:getAnimation(GameManager.Items[u32.Selected].HoldingAnimation, Humanoid):Play();
                            u32.ToolAnimation = GameManager.Items[u32.Selected].HoldingAnimation;
                        else
                            DataEvent:FireServer("Accessory", "Equip", u32.Selected);

                            if u11.WearingAccessory == "" then
                                u11.WearingAccessory = u32.Selected;
                            elseif u11.WearingAccessory2 == "" then
                                u11.WearingAccessory2 = u32.Selected;
                            else
                                u11.WearingAccessory2 = u32.Selected;
                            end;

                            GameManager:stopAnimation(u32.ToolAnimation, Humanoid);
                            u32.ToolAnimation = "";
                        end;

                        delay(math.max(0.3, v372.Length), function() -- Line: 7053
                            -- upvalues: u32 (ref)
                            u32.AccessoryCooldown = false;

                            if u32.Settings.Stunned.Value == false and u32.Knocked == false then
                                u32.Occupied = false;
                            end;
                        end);
                    elseif u32.Selected == "" or (not GameManager.Items[u32.Selected] or GameManager.Items[u32.Selected].Type ~= "Key") then
                        if u32.Selected == "Extraction Spoon" and GameManager:hasItem(u11, "Extraction Spoon") then
                            print("checking extraction start");

                            if u32.ExtractionCooldown == false then
                                u32.ExtractionCooldown = true;
                                delay(2, function() -- Line: 7072
                                    -- upvalues: u32 (ref)
                                    u32.ExtractionCooldown = false;
                                end);
                                GameManager:getAnimation("SpoonExtraction", Humanoid):Play();
                                DataEvent:FireServer("ExtractNearby");
                                print("Running extraction anim");
                            end;
                        elseif u32.Selected == "Scalpel" and GameManager:hasItem(u11, "Scalpel") then
                            print("checking scalpel start");

                            if u32.ExtractionCooldown == false then
                                u32.ExtractionCooldown = true;
                                delay(2, function() -- Line: 7085
                                    -- upvalues: u32 (ref)
                                    u32.ExtractionCooldown = false;
                                end);
                                GameManager:getAnimation("SpoonExtraction", Humanoid):Play();
                                DataEvent:FireServer("ScalpelNearby");
                                print("Running scalpel anim");
                            end;
                        elseif u32.Selected == "Torch" and GameManager:hasItem(u11, "Torch") then
                            if u32.ExtractionCooldown == false then
                                u32.ExtractionCooldown = true;
                                delay(2, function() -- Line: 7097
                                    -- upvalues: u32 (ref)
                                    u32.ExtractionCooldown = false;
                                end);
                                GameManager:getAnimation("SpoonExtraction", Humanoid):Play();
                                wait(0.8);
                                DataEvent:FireServer("SetOnFire");
                                print("Running extraction anim");
                            end;
                        elseif (u32.Selected == "Freshwater Bowl" or u32.Selected == "Water Bowl") and GameManager:hasItem(u11, u32.Selected) then
                            if u32.ExtractionCooldown == false then
                                u32.ExtractionCooldown = true;
                                delay(2, function() -- Line: 7110
                                    -- upvalues: u32 (ref)
                                    u32.ExtractionCooldown = false;
                                end);
                                GameManager:getAnimation("SpoonExtraction", Humanoid):Play();
                                wait(0.1);
                                DataEvent:FireServer("WaterTheCrops", u32.Selected);
                                print("Running extraction anim");
                            end;
                        elseif u32.Selected == "" or (not GameManager.Items[u32.Selected] or GameManager.Items[u32.Selected].Type ~= "Ring") then
                            if u32.Selected == "" or (u11.CurrentWeapon == "" or (GameManager:inBaseCombat(u11.CurrentWeapon) or (not GameManager.Items[u32.Selected] or (skillsModule[u32.Selected] or (not GameManager.Items[u32.Selected].ExtraInfo or (GameManager.Items[u32.Selected].ExtraInfo ~= "Infusion" or (u32.Settings.Stunned.Value ~= false or (u32.Knocked ~= false or u32.Occupied ~= false)))))))) then
                                if u32.Selected == "" or (not skillsModule[u32.Selected] or (u32.Occupied ~= false or (u32.Settings.Stunned.Value ~= false or skillsModule[u32.Selected].SkillType ~= "Awakening"))) then
                                    if u32.Settings.CurrentSkill.Value == "" and (u32.Selected ~= "" and (skillsModule[u32.Selected] and (u32.Occupied == false or skillsModule[u32.Selected].BypassOccupied))) and ((u32.Settings.Stunned.Value == false or (skillsModule[u32.Selected].BypassStun or GameManager:canBypassIceFlickerStun(u9, u32.Selected))) and (u32.Knocked == true and (skillsModule[u32.Selected].UseWhileKnocked == true or skillsModule[u32.Selected].BypassKnocked) or u32.Knocked == false and skillsModule[u32.Selected].UseWhileKnocked == false)) and not u32.Consuming then
                                        if not u9:FindFirstChild("ForceField") then
                                            activateSkill("MouseButton1");
                                        end;
                                    elseif u32.Selected == "" or (not GameManager.Items[u32.Selected] or GameManager.Items[u32.Selected].Type ~= "Misc") then
                                        if canM1() and v364 == false then
                                            performM1();
                                        else
                                            local _ = u32.Occupied == true;
                                        end;
                                    end;
                                else
                                    awakening();
                                end;
                            elseif DataFunction:InvokeServer("RequestToInfuse", u32.Selected) then
                                selectNewItem(u11, u11.CurrentWeapon);
                            end;
                        elseif u11.Ring == u32.Selected then
                            if u32.Occupied == false and not u32.InDanger then
                                GameManager:getAnimation("RingView", Humanoid):Play();
                                disableRun();
                                DataEvent:FireServer("RingFlex");
                                u32.Occupied = true;
                                delay(2.5, function() -- Line: 7125
                                    -- upvalues: u32 (ref)
                                    u32.Occupied = false;
                                end);
                            end;
                        elseif u32.RingCooldown == false and not u32.InDanger then
                            u32.RingCooldown = true;
                            u11.Ring = u32.Selected;
                            DataEvent:FireServer("EquipRing", u32.Selected);
                            Unselect(u32.Selected);
                            delay(0.5, function() -- Line: 7134
                                -- upvalues: u32 (ref)
                                u32.RingCooldown = false;
                            end);
                        end;
                    elseif u32.KeyCooldown == false then
                        GameManager:getAnimation("KeyUnlock", Humanoid):Play();
                        DataEvent:FireServer("GateUnlock");
                        u32.KeyCooldown = true;
                        delay(2, function() -- Line: 7064
                            -- upvalues: u32 (ref)
                            u32.KeyCooldown = false;
                        end);
                    end;
                else
                    if u32.Selected == "Sharingan Eyes" or u32.Selected == "Mangekyo Eyes" then
                        if not GameManager:hasSkill(u11, "Izanagi") then
                            return;
                        end;

                        if u11.MissingArm then
                            return;
                        end;

                        if not u11.DanzoArm then
                            return;
                        end;

                        if u11.DanzoArm.Sharingans >= 10 then
                            return;
                        end;
                    end;

                    local v373 = GameManager.Items[u32.Selected].LifeForceAddition and u11.LifeForce == 100 and true or false;

                    if u32.Settings.Awakened.Value == "Red Gates" then
                        local Selected = u32.Selected;
                        v373 = (Selected == "Life Up Fruit" or (Selected == "Chakra Fruit" or Selected == "Fruit Of Forgetfulness")) and true or v373;
                    end;

                    if v373 == false then
                        local Selected = u32.Selected;
                        local v374;

                        if GameManager.Items[u32.Selected].Animation == "" then
                            v374 = nil;
                        else
                            local v375 = GameManager:getAnimation(u32.Selected == "Ramen" and u32.RamenContestRealStart == true and "SlurpingHighAction" or GameManager.Items[u32.Selected].Animation, Humanoid);
                            v375:Play();

                            if GameManager.Items[u32.Selected].ActionTime then
                                v374 = GameManager.Items[u32.Selected].ActionTime;
                            else
                                v374 = v375.Length;
                            end;
                        end;

                        if u11.Ring ~= "Ring Of Nourishment" then
                            if GameManager.Items[u32.Selected].StopMovement then
                                disableRun("Stop");
                                Humanoid.JumpPower = 0;
                            elseif u32.Running == true then
                                disableRun();
                            end;
                        end;

                        DataEvent:FireServer("Consumed", u32.Selected, v374);

                        if u32.Selected == "Ramen" and u32.RamenContestRealStart == true then
                            DataEvent:FireServer("RamenInventorySwap");
                            task.delay(1.2, function() -- Line: 6869
                                -- upvalues: u32 (ref), GameManager (ref), ReplicatedStorage (ref), HumanoidRootPart (ref)
                                local v376 = u32;
                                v376.RamenEaten = v376.RamenEaten + 1;
                                workspace["Ramen Shop"].BR1.BR2.BowlsGUIBlock.YourBowlsGUI.ImageLabel.Amount.Text = u32.RamenEaten;
                                workspace["Ramen Shop"].PlayerBowls["Bowl" .. u32.RamenEaten].Transparency = 0;
                                GameManager:playTempSound(ReplicatedStorage.LocalSounds.BowlPlace:Clone(), HumanoidRootPart);
                            end);
                        end;

                        local Selected2 = u32.Selected;

                        if Selected2 == "Chakrabone" or Selected2 == "Curious Bone" then
                            u32.Occupied = true;
                        end;

                        u32.Consuming = true;

                        if v374 then
                            wait(v374);
                        end;

                        if GameManager.Items[u32.Selected] and GameManager.Items[u32.Selected].ActionEndingTime then
                            wait(GameManager.Items[u32.Selected].ActionEndingTime);
                        end;

                        u32.Consuming = false;

                        if Selected2 == "Chakrabone" or Selected2 == "Curious Bone" then
                            u32.Occupied = false;
                        end;

                        print("false");

                        if (Selected ~= u32.Selected or GameManager.Items[u32.Selected].StopMovement) and (u32.Knocked == false and (u32.Settings.Stunned.Value == false and u32.Settings.Blocking.Value == false)) then
                            Humanoid.WalkSpeed = u32.OriginSpeed;
                            Humanoid.JumpPower = u32.OriginJump;
                        end;
                    end;
                end;
            else
                activateSkill("MouseButton1", skillsModule[u32.Selected].MouseButton1 or skillsModule[u32.Selected]["C + M1"]);
            end;
        end;

        if u32.holding ~= 0 and u32.oldInfo then
            u32.prevHoldingSlot.SlotText.Text = u32.oldInfo;
            u32.prevHoldingSlot.SlotText.Visible = true;
            u32.prevHoldingSlot.BackgroundTransparency = 0;
            local v377 = GameManager:getImageId(u32.oldInfo);

            if u11.ItemDisplayType == "Icon" and v377 ~= "" then
                u32.prevHoldingSlot.Image = "rbxassetid://" .. v377;
                u32.prevHoldingSlot.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                u32.prevHoldingSlot.SlotText.TextTransparency = 1;
            else
                u32.prevHoldingSlot.SlotText.TextTransparency = 0;
                u32.prevHoldingSlot.Image = "";
            end;

            u32.prevHoldingSlot.SlotBorder.Visible = true;

            if u32.Dragging.ItemNumber.Visible == true then
                u32.prevHoldingSlot.ItemNumber.Visible = true;
                u32.prevHoldingSlot.ItemNumber.Number.Text = u32.Dragging.ItemNumber.Number.Text;
            end;

            u32.Dragging.Visible = false;
            u32.Dragging.ItemNumber.Visible = false;
            u32.Dragging.ZIndex = 9;
            u32.oldInfo = nil;
            u32.oldQuantity = nil;
            u32.oldItemData = nil;
            u32.holding = 0;
            u32.prevHoldingSlot = 0;
            RunService:UnbindFromRenderStep("slotdrag");
        end;
    elseif v356 then
        if skillsModule[u32.Settings.CurrentSkill.Value] and (skillsModule[u32.Settings.CurrentSkill.Value].CanDeactivate == true and (u32.skillInUse == u32.Settings.CurrentSkill.Value and (u32.Casting == false and (skillsModule[u32.Settings.CurrentSkill.Value].MouseButton2 and skillsModule[u32.Settings.CurrentSkill.Value].MouseButton2 == u32.Settings.CurrentSkill.Value)))) then
            print("continued deactivate");
            DataEvent:FireServer("DeactivateSkill");

            return;
        end;

        if u32.Settings.CurrentSkill.Value == "" and (u32.Selected ~= "" and (not u32.Consuming and (skillsModule[u32.Selected] and (skillsModule[u32.Selected].MouseButton2 and (GameManager:hasSkill(u11, skillsModule[u32.Selected].MouseButton2) and (u32.Occupied == false or skillsModule[u32.Selected].BypassOccupied)))))) and ((u32.Settings.Stunned.Value == false or (skillsModule[u32.Selected].BypassStun or GameManager:canBypassIceFlickerStun(u9, u32.Selected))) and (u32.Knocked == true and (skillsModule[u32.Selected].UseWhileKnocked == true or skillsModule[u32.Selected].BypassKnocked) or u32.Knocked == false and skillsModule[u32.Selected].UseWhileKnocked == false)) then
            if not u9:FindFirstChild("ForceField") then
                activateSkill("MouseButton2");
            end;
        elseif u32.Settings.CurrentSkill.Value == "" and (u32.Selected ~= "" and (not u32.Consuming and (skillsModule[u32.Selected] and (GameManager:isJutsuMastered(u11, u32.Selected) and (u32.Occupied == false or skillsModule[u32.Selected].BypassOccupied))))) and ((u32.Settings.Stunned.Value == false or (skillsModule[u32.Selected].BypassStun or GameManager:canBypassIceFlickerStun(u9, u32.Selected))) and (u32.Knocked == true and (skillsModule[u32.Selected].UseWhileKnocked == true or skillsModule[u32.Selected].BypassKnocked) or u32.Knocked == false and skillsModule[u32.Selected].UseWhileKnocked == false)) then
            if not u9:FindFirstChild("ForceField") then
                activateSkill("MouseButton2");
            end;
        else
            if u32.Selected == "Crimson Ring" and game.Players:FindFirstChild(u1.Target.Parent.Name) then
                DataEvent:FireServer("RemoveFromClan", u1.Target.Parent.Name);

                return;
            end;

            if u32.Selected ~= "" and (not u32.Consuming and (skillsModule[u32.Selected] and (skillsModule[u32.Selected].SkillType == "Awakening" and (u32.Settings.Awakened.Value == u32.Selected and skillsModule[u32.Selected].MouseButton2)))) then
                activateSkill("MouseButton2", skillsModule[u32.Selected].MouseButton2);

                return;
            end;

            if u32.Shiftlocked == true and (not u9:FindFirstChild("ForceField") and (u32.Selected == "" or not skillsModule[u32.Selected])) then
                HeavyAttack();
            end;
        end;
    else
        if u353.KeyCode == Enum.KeyCode.Tab then
            PlayerList.Visible = not PlayerList.Visible;

            return;
        end;

        if u353.KeyCode == Enum.KeyCode.Backquote or (u353.KeyCode == Enum.KeyCode.DPadLeft or u353.KeyCode == Enum.KeyCode.M and (u32.holding == 0 and (Rest.Visible == false and (u32.HUDHidden == false and u32.RamenContestRealStart == false)))) then
            if u58.CinematicMode == "On" then
                u58.CinematicMode = "Off";
                SettingsFrame.CinematicModeChoice.Text = "Off";
                Loadout.Visible = true;
                Loadout.HUD.Visible = true;
                PlayerList.Visible = true;
                Ryo.Visible = true;
                Embers.Visible = u11.Embers > 0;
            elseif Inventory.Visible == false then
                UpdateInventory();
                Loadout.HUD.Visible = false;
            else
                closeInventory("HUD");
            end;

            if u32.Inventory and u32.Loadout then
                DataEvent:FireServer("UpdateItems", u32.Inventory, u32.Loadout);

                return;
            end;

            u32.Inventory = u11.Inventory;
            u32.Loadout = u11.Loadout;

            return;
        end;

        if u353.KeyCode == Enum.KeyCode.Return and Mainframe.ClanCreation.Visible == true then
            Mainframe.ClanCreation.ClanImage.Image = "rbxassetid://" .. Mainframe.ClanCreation.ClanImageID.Text;

            return;
        end;

        if u353.KeyCode == Enum.KeyCode.E and (u32.Knocked == false and u32.Occupied == false) then
            local v378 = GameManager:findNearbyNPC(HumanoidRootPart.CFrame);

            if type(v378) ~= "boolean" then
                if v378:FindFirstChild("HumanoidRootPart") then
                    u32.dialogPart = v378.HumanoidRootPart;
                elseif v378:FindFirstChild("Main") then
                    u32.dialogPart = v378.Main;
                else
                    u32.dialogPart = v378;
                end;
            end;

            if v378 and v378:GetAttribute("DisabledDialogue") then
                return;
            end;

            local v379;

            if type(v378) == "boolean" then
                v379 = false;
            else
                v379 = GameManager:getSettings(v378) and v378.Settings.NPCName.Value or v378.Name;
            end;

            if v378 and (GameManager.NPC[v379] and (GameManager.NPC[v379].NPCType == "Dialog" and (u32.InDialog == false and u32.DisplayingText == false))) then
                if u32.Settings.Carrying.Value == nil or (not u32.Settings.Carrying.Value:IsA("BasePart") or (not u32.Settings.Carrying.Value.Name:find("Crate") or u9:GetAttribute("MissionTarget") ~= v379)) then
                    if u32.Selected == "Treat Basket" then
                        u32.NPCModule = {
                            Response = "Happy Halloween!",
                            Option1 = {
                                Text = "Trick or Treat?",
                                Type = "trickOrTreat",
                                Response = "Treat!",
                                Option1 = {
                                    Text = "Thanks!",
                                    Type = "Quit"
                                },
                                Failed = {
                                    Response = "Trick!",
                                    Text = "...",
                                    Type = "Quit"
                                }
                            },
                            Option2 = {
                                Text = "Bye",
                                Type = "Quit"
                            }
                        };
                    else
                        local v380;

                        if type(GameManager.NPC[v379].Quest) == "string" then
                            v380 = { GameManager.NPC[v379].Quest };
                        else
                            v380 = type(GameManager.NPC[v379].Quest) ~= "table" and {} or GameManager.NPC[v379].Quest;
                        end;

                        local v381, _, v382 = GameManager:GetBestQuest(LocalPlayer, u11, v380);
                        local v383, v384;

                        if v381 then
                            u32.CurrentQuest = v381;
                            v383, v384 = DataFunction:InvokeServer("GetQuestProgress", v381, "DontComplete");
                        else
                            v383 = nil;
                            v384 = nil;
                        end;

                        if GameManager.NPC[v379].SinsMax and (u11.Sins >= GameManager.NPC[v379].SinsMax and not GameManager:searchInList(u11.Traits, "Influential")) then
                            u32.NPCModule = GameManager.NPC[v379].Sins;
                        elseif v379 == "Crabuto" and workspace.ImplantBed.Occupied.Value ~= "" then
                            u32.NPCModule = GameManager.NPC[v379].Busy;
                        elseif v379 == "Hyuga Elder" and not (GameManager:hasSkill(u11, "Byakugan [Stage 1]") or (GameManager:hasSkill(u11, "Byakugan [Stage 2]") or GameManager:hasSkill(u11, "Byakugan [Stage 3]"))) then
                            if GameManager:hasSkill(u11, "Byakugan [Stage 4]") then
                                u32.NPCModule = GameManager.NPC[v379].Progressed;
                            else
                                u32.NPCModule = GameManager.NPC[v379].ProgressRejected;
                            end;
                        elseif v379 == "Chino" and not (GameManager:hasSkill(u11, "Ketsuryugan [Stage 1]") or GameManager:hasSkill(u11, "Ketsuryugan [Stage 2]")) then
                            if GameManager:hasSkill(u11, "Ketsuryugan [Stage 3]") or u11.Bloodline ~= "Chinoike" and GameManager:hasSkill(u11, "Ketsuryugan [Stage 2]") then
                                u32.NPCModule = GameManager.NPC[v379].Progressed;
                            else
                                u32.NPCModule = GameManager.NPC[v379].ProgressRejected;
                            end;
                        elseif string.match(v379, "Sensei") then
                            if GameManager.NPC[v379].Village == u11.Village then
                                u32.NPCModule = GameManager.NPC[v379].InVillageResponse;
                            else
                                u32.NPCModule = GameManager.NPC[v379].NotInVillageResponse;
                            end;
                        elseif string.match(v379, "Kage") then
                            local Village = GameManager.NPC[v379].Village;

                            if u11.Village == Village then
                                u32.NPCModule = GameManager.NPC[v379].InVillageResponse;
                            elseif u11.Village == "Neutral" then
                                u32.NPCModule = GameManager.NPC[v379].NeutralResponse;
                            elseif getVillageRelationship(Village, u11.Village) == "Allied" then
                                u32.NPCModule = GameManager.NPC[v379].AlliedResponse;
                            elseif getVillageRelationship(Village, u11.Village) == "War" then
                                u32.NPCModule = GameManager.NPC[v379].EnemyResponse;
                            elseif getVillageRelationship(Village, u11.Villlage) == "Neutral" then
                                u32.NPCModule = GameManager.NPC[v379].BusyResponse;
                            else
                                u32.NPCModule = GameManager.NPC[v379].NeutralResponse;
                            end;
                        elseif v379 == "Akatsuki Leader" then
                            if u11.Rank == "Akatsuki" then
                                u32.NPCModule = GameManager.NPC[v379].AkatsukiResponse;
                            else
                                u32.NPCModule = GameManager.NPC[v379].DefaultResponse;
                            end;
                        elseif v379 == "Rogue Accountant" then
                            if u11.Village == "Rogue" then
                                u32.NPCModule = GameManager.NPC[v379].InVillageResponse;
                            else
                                u32.NPCModule = GameManager.NPC[v379].NotInVillageResponse;
                            end;
                        elseif GameManager.NPC[v379].OutKeeperResponse then
                            if u11.Quests.OutKeeper and u11.Quests.OutKeeper.Progress == "Ongoing" then
                                u32.NPCModule = GameManager.NPC[v379].OutKeeperResponse;
                            else
                                u32.NPCModule = GameManager.NPC[v379].NormalResponse;
                            end;
                        elseif v379 == "Tairock" or (v379 == "Hallowed Tairock" or (v379 == "Frostrock" or v379 == "Enchanted Tairock")) then
                            local v385 = nil;

                            for _, child in workspace:GetChildren() do
                                if (child.Name == "Tairock" or (child.Name == "Hallowed Tairock" or (child.Name == "Frostrock" or child.Name == "Enchanted Tairock"))) and (child:GetAttribute("Occupied") and child:GetAttribute("Occupied") ~= LocalPlayer.UserId) then
                                    v385 = true;
                                    break;
                                end;
                            end;

                            if GameManager:hasItem(u11, "Lee Affinity") or GameManager:hasSkill(u11, "Blue Gates") then
                                u32.NPCModule = GameManager.NPC[v379].CompletedDialogue;
                            elseif u9:GetAttribute("BlueGatesTimer") then
                                if DataFunction:InvokeServer("finishBlueGatesQuest") then
                                    u32.NPCModule = GameManager.NPC[v379].SuccessDialogue;
                                else
                                    u32.NPCModule = GameManager.NPC[v379].Ongoing;
                                end;
                            elseif v385 then
                                u32.NPCModule = GameManager.NPC[v379].Occupied;
                            elseif u11.BlueGatesAttemptAge == u11.Age then
                                u32.NPCModule = GameManager.NPC[v379].CooldownDialogue;
                            elseif u11.BlueGatesAttemptAge and u11.Age > u11.BlueGatesAttemptAge then
                                u32.NPCModule = GameManager.NPC[v379].RetryDialogue;
                            else
                                u32.NPCModule = GameManager.NPC[v379].NormalDialogue;
                            end;
                        elseif v379 == "Might Guy" then
                            local v386 = workspace:FindFirstChild("Might Guy");
                            local v387 = (not v386 or v386.NPC.Value ~= "Dialog") and true or nil;

                            if GameManager:hasItem(u11, "Lee Affinity") or GameManager:hasSkill(u11, "Red Gates") then
                                u32.NPCModule = GameManager.NPC[v379].CompletedDialogue;
                            elseif u9:GetAttribute("RedGatesSuccess") and DataFunction:InvokeServer("finishRedGatesQuest") then
                                u32.NPCModule = GameManager.NPC[v379].SuccessDialogue;
                            elseif v387 then
                                u32.NPCModule = GameManager.NPC[v379].Occupied;
                            elseif u11.RedGatesAttemptAge == u11.Age then
                                u32.NPCModule = GameManager.NPC[v379].CooldownDialogue;
                            elseif u11.RedGatesAttemptAge and u11.Age > u11.RedGatesAttemptAge then
                                u32.NPCModule = GameManager.NPC[v379].RetryDialogue;
                            else
                                u32.NPCModule = GameManager.NPC[v379].NormalDialogue;
                            end;
                        elseif v379 == "Keytora" then
                            if u11.KeytoraCD then
                                u32.NPCModule = GameManager.NPC[v379].KeytoraCD;
                            elseif GameManager:hasSkill(u11, "Shukaku Cloak") or (GameManager:hasSkill(u11, "Matatabi Cloak") or GameManager:hasSkill(u11, "Isobu Cloak")) then
                                u32.NPCModule = GameManager.NPC[v379].Progressed;
                            elseif u11.KeytoraStart then
                                u32.NPCModule = GameManager.NPC[v379].Returning;
                            elseif u11.BerserkCount >= 5 and GameManager:hasSkill(u11, "Jinchuriki [Stage 2]") then
                                u32.NPCModule = GameManager.NPC[v379].CanSpeak;
                            else
                                u32.NPCModule = GameManager.NPC[v379];
                                u32.CurrentQuest = "";
                            end;
                        elseif v379 == "Caged Shukaku" or (v379 == "Caged Matatabi" or v379 == "Caged Isobu") then
                            if u11.Jinchuriki and GameManager:hasSkill(u11, u11.Jinchuriki .. " Cloak") then
                                u32.NPCModule = GameManager.NPC[v379].TeamResponse;
                            else
                                u32.NPCModule = GameManager.NPC[v379];
                                u32.CurrentQuest = "";
                            end;
                        elseif GameManager.NPC[v379].SinsMin and (u11.Sins <= GameManager.NPC[v379].SinsMin and not GameManager:searchInList(u11.Traits, "Influential")) then
                            u32.NPCModule = GameManager.NPC[v379].Sins;
                        elseif v383 and v383 ~= "Start" and (v383 == "Ongoing" and GameManager.Quests[v381].UsesOngoing == true or v383:sub(1, 8) == "Finished" and (v384 ~= "" or GameManager.Quests[v381].UsesFinished == true)) then
                            u32.NPCModule = GameManager.Quests[v381];
                        elseif v383 and v383 == "Start" then
                            u32.NPCModule = v382 > 1 and GameManager.NPC[v379][v381] or GameManager.NPC[v379];
                        else
                            u32.NPCModule = GameManager.NPC[v379];
                            u32.CurrentQuest = "";
                        end;
                    end;
                else
                    u32.NPCModule = {
                        Response = "Is that the crate I asked for?",
                        Option1 = {
                            Text = "Yes",
                            Type = "Crate Delivery",
                            Response = "Thank you so much!",
                            Option1 = {
                                Text = "Bye",
                                Type = "Quit"
                            },
                            Failed = {
                                Response = "No it\'s not.",
                                Text = "Bye",
                                Type = "Quit"
                            }
                        },
                        Option2 = {
                            Text = "No",
                            Type = "Quit"
                        }
                    };
                end;

                u32.InDialog = true;
                Dialog.Visible = true;
                Dialog.DialogBack.NPCName.Text = v378.Name;
                newText("HideBoxes");
            elseif u32.InDialog == true and u32.DisplayingText == false then
                clickedOption1();
            elseif u32.Settings.Stunned.Value == false and (u32.Settings.MeleeCooldown.Value == false and (u32.CurrentChakraPoint == nil and u7 == "Main")) then
                local v388 = (1 / 0);
                local v389 = nil;

                for i = 1, #u57 do
                    if u57[i] then
                        if u57[i]:FindFirstChild("Main") then
                            if (HumanoidRootPart.Position - u57[i].Main.Position).magnitude < v388 then
                                v388 = (HumanoidRootPart.Position - u57[i].Main.Position).magnitude;
                                v389 = u57[i];
                            end;
                        else
                            table.remove(u57, i);
                        end;
                    end;
                end;

                if v389 and GameManager:searchInList(u11.DestroyedChakraPoints, v389.PointName.Value) then
                    v389 = nil;
                end;

                if v389 and v388 < 12 then
                    if v389.Unlocked.Value == true and (u32.InDanger == false and v389.Unlocking.Value == false) then
                        if Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and (u32.Settings.Burrowing.Value == false and DataFunction:InvokeServer("ChakraPointSit", v389)) then
                            if v389.PointName.Value == "Makeshift Point" or u11.ChakraShardsGiven >= GameManager:getMaxShards(u11) then
                                MainMenuFrame.DestroyButton.Visible = false;
                            else
                                MainMenuFrame.DestroyButton.Visible = true;
                                MainMenuFrame.Leave.Position = UDim2.new(0.05, 0, 0.74, 0);
                                MainMenuFrame.ServerName.Position = UDim2.new(0.1, 0, 0.85, 0);
                            end;

                            HumanoidRootPart.Anchored = true;
                            Rest.Visible = true;
                            MainMenuFrame.Visible = true;
                            Rest.TitleImage.Visible = true;
                            local _ = v389.PointName.Value;
                            MainMenuFrame:TweenPosition(UDim2.new(0.04, 0, 0, 0), "Out", "Quad", 0.5, true);
                            Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, 0.05, 0), "Out", "Quad", 0.5, true);
                            u32.CurrentChakraPoint = v389;
                            Rest.TitleImage.PlaceName.Text = u32.CurrentChakraPoint.PointName.Value;
                            GameManager:getAnimation("SittingCrossLegged", Humanoid):Play();
                            u32.Occupied = true;
                            local Position = CFrame.new(v389.Main.Position.X, HumanoidRootPart.Position.Y, v389.Main.Position.Z).Position;
                            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, Position);
                            v389.Main.ChakraSmoke.Enabled = true;
                            ReplicatedStorage.UI.PointBlur:Clone().Parent = game.Lighting;
                            game.Lighting.PointBlur.Enabled = true;
                            Rest.BackDrop.BackgroundTransparency = 1;
                            Rest.BackDrop.Visible = true;
                            u6.ChakraPointSit:Play();
                            Humanoid.AutoRotate = false;

                            if Inventory.Visible == true then
                                closeInventory();
                            else
                                Loadout.HUD.Visible = false;
                            end;

                            Loadout.Visible = false;

                            for i = 1, 0.5, -0.02 do
                                Rest.BackDrop.BackgroundTransparency = i;
                                game.Lighting.PointBlur.Size = game.Lighting.PointBlur.Size + 1;
                                task.wait();
                            end;

                            game.Lighting.PointBlur.Size = 24;
                            u6.ChakraPointLoop:Play();
                            u32.ChangingPage = false;
                        end;
                    elseif v389.Unlocking.Value == false and not u9:GetAttribute("ChakraUnlockCD") then
                        u9:SetAttribute("ChakraUnlockCD", true);
                        task.delay(5, function() -- Line: 7535
                            -- upvalues: u9 (ref)
                            u9:SetAttribute("ChakraUnlockCD", nil);
                        end);

                        if DataFunction:InvokeServer("ChakraPointUnlock", v389) == true then
                            u6.ChakraPointUnlocked:Play();
                            newNotification("New Chakra Point");
                            v389.Unlocking.Value = true;
                            GameManager:unlockChakraPoint(v389);
                            task.wait(2);
                            v389.Unlocking.Value = false;
                            v389.Unlocked.Value = true;
                            table.insert(u11.ChakraPoints, v389.PointName.Value);
                            updateTeleportLocations();
                        end;
                    end;
                end;
            end;

            for i = 1, #u56 do
                if (HumanoidRootPart.Position - u56[i].ClosedDoor.Position).magnitude < 15 and u56[i].Changing.Value == false and (u32.InDialog == false or u32.InDialog == true and (HumanoidRootPart.Position - u56[i].ClosedDoor.Position).magnitude < 8) then
                    DataEvent:FireServer("Door", u56[i]);
                end;
            end;

            return;
        end;

        if u353.KeyCode == Enum.KeyCode.N and (LocalPlayer.Name == "ArkhamDeluxe" or LocalPlayer.Name == "Etheriox") then
            if u58.FakeCinematic == true then
                u58.FakeCinematic = false;
                Loadout.Visible = true;
                Loadout.HUD.Visible = true;
                PlayerList.Visible = true;
                Loadout.FoodCounters.Visible = true;
                Loadout.JumpCounters.Visible = true;
                Ryo.Visible = true;
                Embers.Visible = u11.Embers > 0;
                Acumen.Visible = true;

                return;
            end;

            u58.FakeCinematic = true;
            Loadout.Visible = true;
            Loadout.HUD.Visible = false;
            PlayerList.Visible = false;
            Loadout.FoodCounters.Visible = false;
            Loadout.JumpCounters.Visible = false;
            Ryo.Visible = true;
            Embers.Visible = u11.Embers > 0;
            Acumen.Visible = true;

            return;
        end;

        if u353.KeyCode == v361 and not u9:FindFirstChild("ForceField") then
            if u32.Selected == "" or not skillsModule[u32.Selected] then
                HeavyAttack();
            end;
        elseif u353.KeyCode == v357 and (u32.Broken == false and (not u9:FindFirstChild("ragdolled") and u32.Settings.Stunned.Value == false)) and (u32.Occupied == false or u32.Occupied == true and u32.CanSkillRun == true or u32.Occupied == true and (u32.HoldingSkill == true and (u32.currentSkillsModule and u32.currentSkillsModule.WindUpMovement == "Run"))) and (u32.Settings.Blocking.Value == false and (u32.Knocked == false and (u32.Consuming == false and (Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming or (u11.Bloodline == "Hoshigaki" or (u32.Settings.Awakened.Value == "Isobu Cloak" or GameManager:hasImplantedArm(u11, "Torn Hoshigaki Arm"))))))) then
            if u32.HoldingForward > 0 then
                u32.HoldingForward = 1;
            end;

            if u32.HoldingRight > 0 then
                u32.HoldingRight = 1;
            end;

            if u32.HoldingLeft > 0 then
                u32.HoldingLeft = 1;
            end;

            if u32.HoldingBack > 0 then
                u32.HoldingBack = 1;
            end;

            u32.HoldingForward = 2;
            local v390 = u9:FindFirstChild("Sandstorm") or u9:FindFirstChild("Snowstorm");

            if u9:GetAttribute("IceUltimate") then
                v390 = false;
            end;

            if u32.WDash == false then
                u32.WDash = true;
                wait(0.25);
                u32.WDash = false;

                return;
            end;

            if u32.WDash == true and (u32.CanRun == true and (not v390 and u32.SpinningHumanBoulder == false)) then
                u32.Running = true;
                running.Value = true;
                setRunSpeed();

                if Humanoid:GetState() == Enum.HumanoidStateType.Swimming and (u11.Bloodline == "Hoshigaki" or (GameManager:hasImplantedArm(u11, "Torn Hoshigaki Arm") or u32.Settings.Awakened.Value == "Isobu Cloak")) then
                    u48.Swimming:Play();
                elseif u11.Bloodline ~= "Otsutsuki" or not u9:GetAttribute("otsuAnimations") then
                    u48.Run:Play();

                    if u32.ActionAnim and (u32.ActionAnim.Name == "SkillHold" and u32.skillInUse ~= "") then
                        u32.ActionAnim:Stop();
                        u32.ActionAnim = GameManager:getAnimation("ArmRunningForward", Humanoid);
                        u32.CurrentActionAnim = u32.ActionAnim;
                        u32.ActionAnim:Play();
                    elseif u32.ActionAnim and (u32.ActionAnim.Name == "DoubleSkillHold" and u32.skillInUse ~= "") then
                        u32.ActionAnim:Stop();
                        u32.ActionAnim = GameManager:getAnimation("DoubleArmsRunningForward", Humanoid);
                        u32.CurrentActionAnim = u32.ActionAnim;
                        u32.ActionAnim:Play();
                    end;

                    if u32.idleAnim and (u32.CombatTable.RunningIdle and (u11.Bloodline ~= "Otsutsuki" or not u9:GetAttribute("otsuAnimations"))) then
                        u32.idleAnim:Stop();
                        u32.idleAnim = nil;
                        u32.runningIdleAnim = GameManager:getAnimation(u32.CombatTable.RunningIdle, Humanoid);
                        u32.runningIdleAnim:Play();
                    end;
                end;

                if u11.FOV == "On" then
                    GameManager:TweenObject(workspace.CurrentCamera, {
                        FieldOfView = GameManager.Settings.RunFOV
                    }, 0.5);
                end;

                if GameManager.Clothing[u11.Clothing].RunAnim and u9:FindFirstChild(u11.Clothing) then
                    local v391;

                    if u9[u11.Clothing]:FindFirstChild("AC") then
                        v391 = u9[u11.Clothing].AC;
                    else
                        v391 = u9[u11.Clothing].Original.AC;
                    end;

                    if GameManager.Clothing[u11.Clothing].IdleAnim then
                        GameManager:stopAnimation(GameManager.Clothing[u11.Clothing].IdleAnim, v391);
                    end;

                    GameManager:getAnimation(GameManager.Clothing[u11.Clothing].RunAnim, v391):Play();
                end;
            end;
        elseif v362 then
            local function attemptBlock() -- Line: 7653
                -- upvalues: u32 (ref), u9 (ref), disableRun (ref), Humanoid (ref), DataFunction (ref)
                if u32.Occupied == false and (u32.BlockCooldown == false and (u32.ShortCooldown == false and (u32.BlockStartCooldown == false and (u32.Settings.Stunned.Value == false and (u32.Knocked == false and not (u9:FindFirstChild("ForceField") or (u9:GetAttribute("KotoamatsukamiAttacking") or u9:GetAttribute("KotoamatsukamiForceMove")))))))) then
                    u32.BlockStartCooldown = true;
                    u32.Settings.Blocking.Value = true;
                    u32.Occupied = true;

                    if u32.Running == true then
                        disableRun();
                    end;

                    Humanoid.WalkSpeed = 5;
                    Humanoid.JumpPower = 0;

                    if DataFunction:InvokeServer("Block") == true then
                        Humanoid.WalkSpeed = 5;
                        Humanoid.JumpPower = 0;
                        u32.BlockStartCooldown = false;

                        return;
                    end;

                    u32.Settings.Blocking.Value = false;
                    u32.BlockStartCooldown = false;
                    u32.Occupied = false;
                end;
            end;

            while u9:GetAttribute("ScrambledMind") and u32.OriginalHoldingMouseButton1 or UserInputService:IsKeyDown(Enum.KeyCode.F) do
                attemptBlock();

                if u32.Settings.Blocking.Value == true then
                    break;
                end;

                task.wait();
            end;
        else
            local KeyCode = u353.KeyCode;
            local Text = Loadout.Slot1.SlotNumber.Number.Text;
            local v392;

            if u49[Text] then
                v392 = u49[Text];
            elseif tostring(Text) == Text then
                v392 = Enum.KeyCode[Text:upper()];
            else
                v392 = nil;
            end;

            if KeyCode == v392 then
                slotDown("Slot1");

                return;
            end;

            local KeyCode2 = u353.KeyCode;
            local Text2 = Loadout.Slot2.SlotNumber.Number.Text;
            local v393;

            if u49[Text2] then
                v393 = u49[Text2];
            elseif tostring(Text2) == Text2 then
                v393 = Enum.KeyCode[Text2:upper()];
            else
                v393 = nil;
            end;

            if KeyCode2 == v393 then
                slotDown("Slot2");

                return;
            end;

            local KeyCode3 = u353.KeyCode;
            local Text3 = Loadout.Slot3.SlotNumber.Number.Text;
            local v394;

            if u49[Text3] then
                v394 = u49[Text3];
            elseif tostring(Text3) == Text3 then
                v394 = Enum.KeyCode[Text3:upper()];
            else
                v394 = nil;
            end;

            if KeyCode3 == v394 then
                slotDown("Slot3");

                return;
            end;

            local KeyCode4 = u353.KeyCode;
            local Text4 = Loadout.Slot4.SlotNumber.Number.Text;
            local v395;

            if u49[Text4] then
                v395 = u49[Text4];
            elseif tostring(Text4) == Text4 then
                v395 = Enum.KeyCode[Text4:upper()];
            else
                v395 = nil;
            end;

            if KeyCode4 == v395 then
                slotDown("Slot4");

                return;
            end;

            local KeyCode5 = u353.KeyCode;
            local Text5 = Loadout.Slot5.SlotNumber.Number.Text;
            local v396;

            if u49[Text5] then
                v396 = u49[Text5];
            elseif tostring(Text5) == Text5 then
                v396 = Enum.KeyCode[Text5:upper()];
            else
                v396 = nil;
            end;

            if KeyCode5 == v396 then
                slotDown("Slot5");

                return;
            end;

            local KeyCode6 = u353.KeyCode;
            local Text6 = Loadout.Slot6.SlotNumber.Number.Text;
            local v397;

            if u49[Text6] then
                v397 = u49[Text6];
            elseif tostring(Text6) == Text6 then
                v397 = Enum.KeyCode[Text6:upper()];
            else
                v397 = nil;
            end;

            if KeyCode6 == v397 then
                slotDown("Slot6");

                return;
            end;

            local KeyCode7 = u353.KeyCode;
            local Text7 = Loadout.Slot7.SlotNumber.Number.Text;
            local v398;

            if u49[Text7] then
                v398 = u49[Text7];
            elseif tostring(Text7) == Text7 then
                v398 = Enum.KeyCode[Text7:upper()];
            else
                v398 = nil;
            end;

            if KeyCode7 == v398 then
                slotDown("Slot7");

                return;
            end;

            local KeyCode8 = u353.KeyCode;
            local Text8 = Loadout.Slot8.SlotNumber.Number.Text;
            local v399;

            if u49[Text8] then
                v399 = u49[Text8];
            elseif tostring(Text8) == Text8 then
                v399 = Enum.KeyCode[Text8:upper()];
            else
                v399 = nil;
            end;

            if KeyCode8 == v399 then
                slotDown("Slot8");

                return;
            end;

            local KeyCode9 = u353.KeyCode;
            local Text9 = Loadout.Slot9.SlotNumber.Number.Text;
            local v400;

            if u49[Text9] then
                v400 = u49[Text9];
            elseif tostring(Text9) == Text9 then
                v400 = Enum.KeyCode[Text9:upper()];
            else
                v400 = nil;
            end;

            if KeyCode9 == v400 then
                slotDown("Slot9");

                return;
            end;

            local KeyCode10 = u353.KeyCode;
            local Text10 = Loadout.Slot10.SlotNumber.Number.Text;
            local v401;

            if u49[Text10] then
                v401 = u49[Text10];
            elseif tostring(Text10) == Text10 then
                v401 = Enum.KeyCode[Text10:upper()];
            else
                v401 = nil;
            end;

            if KeyCode10 == v401 then
                slotDown("Slot10");

                return;
            end;

            local KeyCode11 = u353.KeyCode;
            local Text11 = Loadout.Slot11.SlotNumber.Number.Text;
            local v402;

            if u49[Text11] then
                v402 = u49[Text11];
            elseif tostring(Text11) == Text11 then
                v402 = Enum.KeyCode[Text11:upper()];
            else
                v402 = nil;
            end;

            if KeyCode11 == v402 then
                slotDown("Slot11");

                return;
            end;

            local KeyCode12 = u353.KeyCode;
            local Text12 = Loadout.Slot12.SlotNumber.Number.Text;
            local v403;

            if u49[Text12] then
                v403 = u49[Text12];
            elseif tostring(Text12) == Text12 then
                v403 = Enum.KeyCode[Text12:upper()];
            else
                v403 = nil;
            end;

            if KeyCode12 == v403 then
                slotDown("Slot12");

                return;
            end;

            if u353.KeyCode == Enum.KeyCode.B then
                if u32.Settings.MeleeCooldown.Value == false and (u32.Occupied == false and (u32.Settings.Gripping.Value == "None" and (u32.Settings.Stunned.Value == false and (u32.Settings.Blocking.Value == false and (u32.Knocked == false and (u32.GripCooldown == false and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall)))))) then
                    DataEvent:FireServer("Grip");
                    u32.GripCooldown = true;
                    u32.Occupied = true;
                    task.delay(1, function() -- Line: 7718
                        -- upvalues: u32 (ref)
                        u32.GripCooldown = false;
                    end);
                end;
            elseif u353.KeyCode == Enum.KeyCode.LeftControl then
                if u32.Sliding == false and (u32.Occupied == false and (u32.Settings.Stunned.Value == false and Humanoid.MoveDirection.Magnitude > 0)) then
                    local v404 = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)).p, u9, "Hit");
                    local v405 = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 6, 10)).p, u9, "Hit");

                    if v404 and (v404:FindFirstChild("Slope") or CollectionService:HasTag(v404, "Slope")) and not v405 then
                        DataEvent:FireServer("PlaySound", "GrassSlide", true, 0.5);

                        if u11.FOV == "On" then
                            GameManager:TweenObject(workspace.CurrentCamera, {
                                FieldOfView = GameManager.Settings.SlideFOV
                            }, 0.5);
                        end;

                        u32.Occupied = true;
                        u32.Sliding = true;
                        Humanoid.AutoRotate = false;
                        GameManager:getAnimation("Slide", Humanoid):Play();
                        GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, Humanoid.WalkSpeed * 2, nil, "SlideBV", Vector3.new(1, 0, 1), nil);
                        local v406 = ReplicatedStorage.Particles.SlideSmoke:Clone();
                        v406.Parent = u9.Torso;
                        local Color = v404.Color;
                        local v407 = Color3.new(Color.R / 2, Color.G / 2, Color.B / 2);
                        v406.Color = ColorSequence.new(v407, v407);
                    end;
                end;
            elseif (u353.KeyCode == Enum.KeyCode.Space or u353.KeyCode == Enum.KeyCode.ButtonA) and Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
                if u32.jumpAmount > 5 and u10.Awakened.Value ~= "Red Gates" then
                    DataEvent:FireServer("BanMe", "Offense 1G");
                end;

                u48.Sleep:Stop();

                if u32.Settings.Blocking.Value == true or u32.Settings.Stunned.Value == true then
                    Humanoid.JumpPower = 0;
                end;

                local v408 = u9:GetAttribute("NightGuy");
                DataEvent:FireServer("IJumped");

                if u32.Broken == false and (u32.Settings.MeleeCooldown.Value == false and (v408 or u32.Settings.Stunned.Value == false)) and (u32.Settings.Blocking.Value == false and (u32.Dashing == false and (u32.Knocked == false and (u9 and (Humanoid and (u9:IsDescendantOf(workspace) and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead)))))) then
                    if u32.jumpBlocked == true then
                        return;
                    end;

                    if u32.Occupied or (u32.Vaulting ~= false or (u32.VaultingID == 0 or (u11.MissingArm or (detectLedge() ~= true or u32.Settings.CurrentSkill.Value == "Ice Skate")))) then
                        local v409 = (Humanoid.JumpPower > 0 and (not ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Earth") and (u32.canDoubleJump and (not u32.hasDoubleJumped and u32.Settings.JumpCounters.Value > 0))) or not u32.hasDoubleJumped and (u32.Settings.JumpCounters.Value > 0 and u32.Falling == true)) and true or (u9:GetAttribute("NightGuy") or u32.Settings.Awakened.Value == "Red Gates");
                        local v410;

                        if Humanoid.JumpPower > 0 then
                            v410 = u32.canTripleJump;

                            if v410 then
                                if u32.Settings.JumpCounters.Value > 0 then
                                    v410 = GameManager:hasSkill(u11, "Triple Jump") and not ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Earth");
                                else
                                    v410 = false;
                                end;
                            end;
                        else
                            v410 = false;
                        end;

                        if v409 and u32.Settings.CurrentSkill.Value ~= "Ice Skate" then
                            if not u9:FindFirstChild("ForceField") then
                                GameManager:jump(u9, "DoubleJump");
                                DataEvent:FireServer("Jump");
                                u32.canDoubleJump = false;
                                u32.hasDoubleJumped = true;
                                u32.Dashing = true;
                                fallDamage();

                                if u32.Knocked == false then
                                    wait(u32.JumpInterval / 2);
                                    u32.canTripleJump = true;
                                    u32.Dashing = false;
                                    u32.jumpAmount = u32.jumpAmount + 1;
                                end;
                            end;
                        elseif v410 and u32.Settings.CurrentSkill.Value ~= "Ice Skate" then
                            if not u9:FindFirstChild("ForceField") then
                                GameManager:jump(u9, "TripleJump");
                                DataEvent:FireServer("Jump");
                                u32.canTripleJump = false;
                                u32.Dashing = true;
                                fallDamage();

                                if u32.Knocked == false then
                                    wait(u32.JumpInterval / 2);
                                    u32.Dashing = false;
                                    u32.jumpAmount = u32.jumpAmount + 1;
                                end;
                            end;
                        elseif not u32.hasDoubleJumped then
                            if u32.Jumped == false then
                                HumanoidRootPart.Jump:Play();
                                u32.Jumped = true;
                                u32.jumpAmount = u32.jumpAmount + 1;
                                GameManager:getAnimation("JumpLowPriority", Humanoid):Play();

                                if u32.canTreeJump == true and (GameManager:hasSkill(u11, "Chakra Tree Jump") and u32.Settings.CurrentSkill.Value ~= "Ice Skate") then
                                    if u32.Settings.JumpCounters.Value > 0 then
                                        DataEvent:FireServer("Jump");
                                        print("canTreeJump is true");
                                    else
                                        u32.canTreeJump = false;
                                        print("canTreeJump is false");
                                    end;

                                    if u32.canTreeJump == true then
                                        DataEvent:FireServer("TreeJump");
                                        local v411 = nil;

                                        if u32.HoldingForward == 2 then
                                            v411 = CFrame.new(0, -100, 100);
                                        elseif u32.HoldingBack == 2 then
                                            v411 = CFrame.new(0, -100, -100);
                                        elseif u32.HoldingRight == 2 then
                                            v411 = CFrame.new(-100, -100, 0);
                                        elseif u32.HoldingLeft == 2 then
                                            v411 = CFrame.new(100, -100, 0);
                                        end;

                                        local v412 = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)).p, u9, "Hit");
                                        local v413 = v412 and v412.Name == "Water" and 0.3 or 0.5;

                                        if v411 then
                                            GameManager:createBodyVelocity(HumanoidRootPart, (HumanoidRootPart.Position - (HumanoidRootPart.CFrame * v411).p).unit, 100, v413, "DashBV", Vector3.new(1000, 1000, 1000), "Reduce");
                                        else
                                            GameManager:createBodyVelocity(HumanoidRootPart, (HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, -100, 0)).p).unit, 100, v413, "DashBV", Vector3.new(0, 1000, 0), "Reduce");
                                        end;

                                        u32.canTreeJump = false;

                                        if u32.Settings.Stunned.Value == false and u32.Knocked == false then
                                            Humanoid.JumpPower = u32.OriginJump;
                                        end;

                                        Emit(HumanoidRootPart.ChakraJumpVFXAttachment);
                                    end;
                                end;
                            end;

                            u32.canDoubleJump = true;
                        end;
                    else
                        if u32.Running == true then
                            disableRun();
                        end;

                        u32.Occupied = true;
                        u32.Vaulting = true;
                        u32.VaultingID = math.random(1, 9999);
                        local VaultingID = u32.VaultingID;
                        GameManager:getAnimation("LedgeHold", Humanoid):Play();
                        u6.LedgeGrab:Play();
                        u32.Dashing = true;
                        task.wait(2);

                        if u32.Vaulting == true and u32.VaultingID == VaultingID then
                            GameManager:stopAnimation("LedgeHold", Humanoid);
                            Humanoid.AutoRotate = true;
                            u32.Vaulting = false;
                            u32.Occupied = false;
                            u32.Dashing = false;
                            u32.fakeVaultActive = false;

                            if HumanoidRootPart:FindFirstChild("VaultBV") then
                                HumanoidRootPart.VaultBV:Destroy();
                            end;
                        end;
                    end;
                end;
            elseif (u353.KeyCode == Enum.KeyCode.C or u353.KeyCode == Enum.KeyCode.ButtonY) and (u32.Knocked == false and not ReplicatedStorage.Ailments:FindFirstChild(LocalPlayer.Name):FindFirstChild("Bugs")) then
                u32.ChargingChakra = true;
                DataEvent:FireServer("Charging");

                if GameManager:hasSkill(u11, "Chakra Feet") then
                    if u32.ChakraFeetCooldown ~= true or (u32.Occupied ~= false or (u32.Settings.Stunned.Value ~= false or u32.Settings.Blocking.Value ~= false)) then
                        u32.ChakraFeetCooldown = true;
                        wait(0.25);
                        u32.ChakraFeetCooldown = false;

                        return;
                    end;

                    if u32.ChakraFeet == true then
                        u32.ChakraFeet = false;
                        GameManager:watersCollision(u32.ChakraFeet);
                        DataEvent:FireServer("ChakraFeet", u32.ChakraFeet);

                        return;
                    end;

                    if u32.ChakraFeet == false and Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
                        u32.ChakraFeet = true;
                        GameManager:watersCollision(u32.ChakraFeet);
                        DataEvent:FireServer("ChakraFeet", u32.ChakraFeet);
                    end;
                end;
            else
                if u353.KeyCode == v357 then
                    if u32.HoldingForward > 0 then
                        u32.HoldingForward = 1;
                    end;

                    if u32.HoldingRight > 0 then
                        u32.HoldingRight = 1;
                    end;

                    if u32.HoldingLeft > 0 then
                        u32.HoldingLeft = 1;
                    end;

                    if u32.HoldingBack > 0 then
                        u32.HoldingBack = 1;
                    end;

                    u32.HoldingForward = 2;

                    return;
                end;

                if u353.KeyCode == v359 then
                    if u32.HoldingForward > 0 then
                        u32.HoldingForward = 1;
                    end;

                    if u32.HoldingRight > 0 then
                        u32.HoldingRight = 1;
                    end;

                    if u32.HoldingLeft > 0 then
                        u32.HoldingLeft = 1;
                    end;

                    if u32.HoldingBack > 0 then
                        u32.HoldingBack = 1;
                    end;

                    u32.HoldingLeft = 2;

                    return;
                end;

                if u353.KeyCode == v358 then
                    if u32.HoldingForward > 0 then
                        u32.HoldingForward = 1;
                    end;

                    if u32.HoldingRight > 0 then
                        u32.HoldingRight = 1;
                    end;

                    if u32.HoldingLeft > 0 then
                        u32.HoldingLeft = 1;
                    end;

                    if u32.HoldingBack > 0 then
                        u32.HoldingBack = 1;
                    end;

                    u32.HoldingBack = 2;

                    return;
                end;

                if u353.KeyCode == v360 then
                    if u32.HoldingForward > 0 then
                        u32.HoldingForward = 1;
                    end;

                    if u32.HoldingRight > 0 then
                        u32.HoldingRight = 1;
                    end;

                    if u32.HoldingLeft > 0 then
                        u32.HoldingLeft = 1;
                    end;

                    if u32.HoldingBack > 0 then
                        u32.HoldingBack = 1;
                    end;

                    u32.HoldingRight = 2;

                    return;
                end;

                if v363 and u32.Broken == false then
                    if (u32.Occupied == false or skillAllowedDash()) and (u32.Settings.Stunned.Value == false and (u32.Dashing == false and (u32.DashCooldown == false and (u32.Settings.Blocking.Value == false and (u32.Knocked == false and not (u9:FindFirstChild("ragdolled") or (u9:GetAttribute("KotoamatsukamiForceMove") or u9:GetAttribute("KotoamatsukamiAttacking")))))))) then
                        if u32.HoldingForward > 0 or (u32.HoldingBack > 0 or (u32.HoldingRight > 0 or u32.HoldingLeft > 0)) then
                            if not u11.SeamlessRun then
                                disableRun();
                            end;

                            u32.Dashing = true;
                            u32.DashCooldown = true;
                            local v414 = false;
                            local v415, v416 = dashInfo(u32.ChargingChakra == true and (GameManager:hasSkill(u11, "Chakra Dash") and GameManager:hasSkill(u11, "Lightning Dodge")) and 22 or nil);

                            if v415 then
                                v415.Priority = Enum.AnimationPriority.Action2;
                            end;

                            local v417 = nil;
                            local v418 = nil;
                            local v419 = u32.Settings.Awakened.Value == "Shisui\'s Eternal Mangekyo";

                            if v416 then
                                local v420 = 40000;

                                if u32.ChargingChakra == true and GameManager:hasSkill(u11, "Chakra Dash") then
                                    v420 = v420 + 20000;
                                    DataEvent:FireServer("Dash", "Chakra", v416);
                                    v414 = true;
                                else
                                    DataEvent:FireServer("Dash");
                                end;

                                if skillAllowedDash() then
                                    v420 = v420 + 100000;
                                end;

                                if v414 == true and (GameManager:hasSkill(u11, "Flicker Step") or (GameManager:hasSkill(u11, "Lightning Dodge") or u32.Settings.Awakened.Value == "Isobu Cloak" and Humanoid:GetState() == Enum.HumanoidStateType.Swimming) or v419) then
                                    if v419 then
                                        u9:SetAttribute("FlickerStep", true);
                                        Humanoid.WalkSpeed = 100;
                                        v417 = 0.4;
                                        v418 = true;
                                    elseif GameManager:hasSkill(u11, "Flicker Step") then
                                        u9:SetAttribute("FlickerStep", true);
                                        Humanoid.WalkSpeed = 80;

                                        if GameManager:searchInList(u11.Traits, "Agile") then
                                            Humanoid.WalkSpeed = 100;
                                            v417 = 0.4;
                                        else
                                            v417 = 0.5;
                                        end;

                                        if u32.Settings.Awakened.Value == "Red Gates" then
                                            Humanoid.WalkSpeed = 150;
                                            v418 = true;
                                        else
                                            v418 = true;
                                        end;
                                    elseif GameManager:hasSkill(u11, "Lightning Dodge") then
                                        v417 = 0;
                                    elseif u32.Settings.Awakened.Value == "Isobu Cloak" and Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                                        u9:SetAttribute("FlickerStep", true);
                                        Humanoid.WalkSpeed = 80;

                                        if GameManager:searchInList(u11.Traits, "Agile") then
                                            Humanoid.WalkSpeed = 100;
                                            v417 = 0.4;
                                        else
                                            v417 = 0.5;
                                        end;

                                        if u32.Settings.Awakened.Value == "Red Gates" then
                                            Humanoid.WalkSpeed = 150;
                                            v418 = true;
                                        else
                                            v418 = true;
                                        end;
                                    end;
                                else
                                    if GameManager:searchInList(u11.Traits, "Agile") then
                                        v420 = v420 * GameManager.Traits.Agile.SpeedDiff;
                                    end;

                                    local v421 = Vector3.new(1, 0, 1) * v420;

                                    if GameManager:searchInList(u11.Traits, "Agile") then
                                        GameManager:createBodyPosition(HumanoidRootPart, v416, v421, nil, nil, 0.5 / GameManager.Traits.Agile.SpeedDiff, "DashBV", true);
                                    else
                                        GameManager:createBodyPosition(HumanoidRootPart, v416, v421, nil, nil, 0.5, "DashBV", true);
                                    end;

                                    if v415 then
                                        if skillAllowedDash() then
                                            v415 = GameManager:getAnimation("ForwardAirDash", Humanoid);

                                            if u32.usedSingleSkillDash == false and skillsModule[u32.skillInUse].AllowsOneDashInBase then
                                                u32.usedSingleSkillDash = true;
                                                local skillInUse = u32.skillInUse;
                                                task.delay(1, function() -- Line: 8078
                                                    -- upvalues: u32 (ref), skillInUse (copy), DataEvent (ref), GameManager (ref), selectNewItem (ref), u11 (ref)
                                                    if u32.skillInUse == skillInUse then
                                                        DataEvent:FireServer("DeactivateSkill");
                                                        local v422 = skillsModule[u32.Settings.CurrentSkill.Value];

                                                        if v422.RequiresWeapon and not GameManager:inBaseCombat(v422.RequiresWeapon) then
                                                            selectNewItem(u11, u11.CurrentWeapon);
                                                        end;
                                                    end;
                                                end);
                                            end;
                                        elseif u32.Shiftlocked == false then
                                            v415 = GameManager:getAnimation("ForwardDash", Humanoid);
                                        end;

                                        v415:Play();

                                        if GameManager:searchInList(u11.Traits, "Agile") then
                                            v415:AdjustSpeed(1 * GameManager.Traits.Agile.SpeedDiff);
                                        end;
                                    end;
                                end;
                            end;

                            task.delay(v419 and 0.3 or (v417 or 0.3), function() -- Line: 8105
                                -- upvalues: u32 (ref)
                                u32.Dashing = false;
                            end);
                            task.wait(v417 or 0.3);
                            u32.Jumped = false;
                            u32.jumpAmount = 0;
                            u32.hasDoubleJumped = false;
                            u32.canTripleJump = false;

                            if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                                u32.canDoubleJump = true;
                            end;

                            if GameManager:hasSkill(u11, "Aerial Backflip") and (v415 and (v415.Name == "AerialBackDash" and v414 == false)) then
                                local v423, _ = GameManager:downwardsRay(u9);

                                if v423 then
                                    task.delay(0.1, function() -- Line: 8122
                                        -- upvalues: GameManager (ref), HumanoidRootPart (ref)
                                        GameManager:createBodyVelocity(HumanoidRootPart, (HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, -100, 0)).p).unit, math.random(60, 70), 0.2, "DashBV", Vector3.new(0, 1000, 0), "Reduce");
                                    end);
                                end;
                            end;

                            u9:SetAttribute("FlickerStep", nil);

                            if v418 then
                                if u32.Running then
                                    setRunSpeed();
                                else
                                    Humanoid.WalkSpeed = math.min(Humanoid.WalkSpeed, u32.OriginSpeed);
                                end;
                            end;

                            if ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Fire") then
                                DataEvent:FireServer("RemoveFireAilment");
                            end;

                            if v417 and v417 == 0 then
                                task.wait(1);
                            else
                                task.wait(0.4);
                            end;

                            if skillAllowedDash() then
                                task.wait(0.8);
                            end;

                            local v424 = GameManager.Settings.DashCooldown - 1;

                            if u10.Awakened.Value == "Red Gates" then
                                v424 = v424 * 0.5;
                            end;

                            if v419 then
                                v424 = v424 * 0.7;
                            end;

                            task.wait(v424);
                            u32.DashCooldown = false;
                        end;
                    elseif GameManager:hasSkill(u11, "Substitution") and (not u9:GetAttribute("DisabledSubstitution") and (not u9:FindFirstChild("ragdolled") and (u32.Settings.RecentDamage.Value ~= 0 and (LocalPlayer.Backpack.chakra.Value >= GameManager.Settings.SubCost or GameManager:hasSkill(u11, "Efficient Substitution"))))) and (u32.Settings.JumpCounters.Value >= 1 and (u32.DashCooldown == false and (u32.Settings.Blocking.Value == false and (u32.Knocked == false and u32.Settings.Invincible.Value == false)))) then
                        local v425 = workspace:GetServerTimeNow() - u32.Settings.SubCooldown.Value;

                        if math.abs(v425) > GameManager.Settings.SubCooldown and u32.Settings.Burrowing.Value == false then
                            local v426 = nil;
                            u32.Occupied = false;
                            u32.DashCooldown = true;
                            u32.CanRun = false;

                            if u32.HoldingForward > 0 or (u32.HoldingBack > 0 or (u32.HoldingRight > 0 or u32.HoldingLeft > 0)) then
                                if u32.HoldingForward == 2 then
                                    v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, -15)).p;
                                else
                                    local v427, v428, v429, v430, v431, v432;

                                    if u32.HoldingForward == 1 then
                                        local HoldingForward = u32.HoldingForward;
                                        local v433 = 0;

                                        if u32.HoldingForward < HoldingForward then
                                            v433 = v433 + 1;
                                        end;

                                        if u32.HoldingRight < HoldingForward then
                                            v433 = v433 + 1;
                                        end;

                                        if u32.HoldingLeft < HoldingForward then
                                            v433 = v433 + 1;
                                        end;

                                        if u32.HoldingBack < HoldingForward then
                                            v433 = v433 + 1;
                                        end;

                                        if v433 >= 3 == true then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, -15)).p;
                                        elseif u32.HoldingRight == 2 then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(15, 0, 0)).p;
                                        elseif u32.HoldingRight == 1 then
                                            v427 = u32.HoldingRight;
                                            v428 = 0;

                                            if u32.HoldingForward < v427 then
                                                v428 = v428 + 1;
                                            end;

                                            if u32.HoldingRight < v427 then
                                                v428 = v428 + 1;
                                            end;

                                            if u32.HoldingLeft < v427 then
                                                v428 = v428 + 1;
                                            end;

                                            if u32.HoldingBack < v427 then
                                                v428 = v428 + 1;
                                            end;

                                            if v428 >= 3 == true then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(15, 0, 0)).p;
                                            elseif u32.HoldingLeft == 2 then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                            elseif u32.HoldingLeft == 1 then
                                                v429 = u32.HoldingLeft;
                                                v430 = 0;

                                                if u32.HoldingForward < v429 then
                                                    v430 = v430 + 1;
                                                end;

                                                if u32.HoldingRight < v429 then
                                                    v430 = v430 + 1;
                                                end;

                                                if u32.HoldingLeft < v429 then
                                                    v430 = v430 + 1;
                                                end;

                                                if u32.HoldingBack < v429 then
                                                    v430 = v430 + 1;
                                                end;

                                                if v430 >= 3 == true then
                                                    v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                                elseif u32.HoldingBack == 2 then
                                                    v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                                elseif u32.HoldingBack == 1 then
                                                    v431 = u32.HoldingBack;
                                                    v432 = 0;

                                                    if u32.HoldingForward < v431 then
                                                        v432 = v432 + 1;
                                                    end;

                                                    if u32.HoldingRight < v431 then
                                                        v432 = v432 + 1;
                                                    end;

                                                    if u32.HoldingLeft < v431 then
                                                        v432 = v432 + 1;
                                                    end;

                                                    if u32.HoldingBack < v431 then
                                                        v432 = v432 + 1;
                                                    end;

                                                    if v432 >= 3 == true then
                                                        v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                                    end;
                                                end;
                                            elseif u32.HoldingBack == 2 then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                            elseif u32.HoldingBack == 1 then
                                                v431 = u32.HoldingBack;
                                                v432 = 0;

                                                if u32.HoldingForward < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingRight < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingLeft < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingBack < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if v432 >= 3 == true then
                                                    v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                                end;
                                            end;
                                        elseif u32.HoldingLeft == 2 then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                        elseif u32.HoldingLeft == 1 then
                                            v429 = u32.HoldingLeft;
                                            v430 = 0;

                                            if u32.HoldingForward < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if u32.HoldingRight < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if u32.HoldingLeft < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if u32.HoldingBack < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if v430 >= 3 == true then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                            elseif u32.HoldingBack == 2 then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                            elseif u32.HoldingBack == 1 then
                                                v431 = u32.HoldingBack;
                                                v432 = 0;

                                                if u32.HoldingForward < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingRight < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingLeft < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingBack < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if v432 >= 3 == true then
                                                    v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                                end;
                                            end;
                                        elseif u32.HoldingBack == 2 then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                        elseif u32.HoldingBack == 1 then
                                            v431 = u32.HoldingBack;
                                            v432 = 0;

                                            if u32.HoldingForward < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingRight < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingLeft < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingBack < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if v432 >= 3 == true then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                            end;
                                        end;
                                    elseif u32.HoldingRight == 2 then
                                        v426 = (HumanoidRootPart.CFrame * CFrame.new(15, 0, 0)).p;
                                    elseif u32.HoldingRight == 1 then
                                        v427 = u32.HoldingRight;
                                        v428 = 0;

                                        if u32.HoldingForward < v427 then
                                            v428 = v428 + 1;
                                        end;

                                        if u32.HoldingRight < v427 then
                                            v428 = v428 + 1;
                                        end;

                                        if u32.HoldingLeft < v427 then
                                            v428 = v428 + 1;
                                        end;

                                        if u32.HoldingBack < v427 then
                                            v428 = v428 + 1;
                                        end;

                                        if v428 >= 3 == true then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(15, 0, 0)).p;
                                        elseif u32.HoldingLeft == 2 then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                        elseif u32.HoldingLeft == 1 then
                                            v429 = u32.HoldingLeft;
                                            v430 = 0;

                                            if u32.HoldingForward < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if u32.HoldingRight < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if u32.HoldingLeft < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if u32.HoldingBack < v429 then
                                                v430 = v430 + 1;
                                            end;

                                            if v430 >= 3 == true then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                            elseif u32.HoldingBack == 2 then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                            elseif u32.HoldingBack == 1 then
                                                v431 = u32.HoldingBack;
                                                v432 = 0;

                                                if u32.HoldingForward < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingRight < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingLeft < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if u32.HoldingBack < v431 then
                                                    v432 = v432 + 1;
                                                end;

                                                if v432 >= 3 == true then
                                                    v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                                end;
                                            end;
                                        elseif u32.HoldingBack == 2 then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                        elseif u32.HoldingBack == 1 then
                                            v431 = u32.HoldingBack;
                                            v432 = 0;

                                            if u32.HoldingForward < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingRight < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingLeft < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingBack < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if v432 >= 3 == true then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                            end;
                                        end;
                                    elseif u32.HoldingLeft == 2 then
                                        v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                    elseif u32.HoldingLeft == 1 then
                                        v429 = u32.HoldingLeft;
                                        v430 = 0;

                                        if u32.HoldingForward < v429 then
                                            v430 = v430 + 1;
                                        end;

                                        if u32.HoldingRight < v429 then
                                            v430 = v430 + 1;
                                        end;

                                        if u32.HoldingLeft < v429 then
                                            v430 = v430 + 1;
                                        end;

                                        if u32.HoldingBack < v429 then
                                            v430 = v430 + 1;
                                        end;

                                        if v430 >= 3 == true then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                                        elseif u32.HoldingBack == 2 then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                        elseif u32.HoldingBack == 1 then
                                            v431 = u32.HoldingBack;
                                            v432 = 0;

                                            if u32.HoldingForward < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingRight < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingLeft < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if u32.HoldingBack < v431 then
                                                v432 = v432 + 1;
                                            end;

                                            if v432 >= 3 == true then
                                                v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                            end;
                                        end;
                                    elseif u32.HoldingBack == 2 then
                                        v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                    elseif u32.HoldingBack == 1 then
                                        v431 = u32.HoldingBack;
                                        v432 = 0;

                                        if u32.HoldingForward < v431 then
                                            v432 = v432 + 1;
                                        end;

                                        if u32.HoldingRight < v431 then
                                            v432 = v432 + 1;
                                        end;

                                        if u32.HoldingLeft < v431 then
                                            v432 = v432 + 1;
                                        end;

                                        if u32.HoldingBack < v431 then
                                            v432 = v432 + 1;
                                        end;

                                        if v432 >= 3 == true then
                                            v426 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)).p;
                                        end;
                                    end;
                                end;
                            elseif math.random(1, 2) == 1 then
                                v426 = (HumanoidRootPart.CFrame * CFrame.new(15, 0, 0)).p;
                            else
                                v426 = (HumanoidRootPart.CFrame * CFrame.new(-15, 0, 0)).p;
                            end;

                            local v434 = {};

                            for _, v in ipairs(game.Players:GetPlayers()) do
                                if v.Character then
                                    table.insert(v434, v.Character);
                                end;
                            end;

                            local _, v435 = GameManager:CastRayParams(HumanoidRootPart.Position, Humanoid.MoveDirection, v434, 15, "AvoidHitbox");
                            SubIndicator.Cooldown.Text = GameManager.Settings.SubCooldown;
                            print(LocalPlayer.Name .. " SUBBED");
                            DataEvent:FireServer("Dash", "Sub", v435 or v426);
                            u32.Occupied = false;
                            u32.CanRun = true;
                            u32.DashCooldown = false;
                        end;
                    end;
                else
                    if u353.KeyCode == Enum.KeyCode.V and (u32.Occupied == false and (u32.Settings.Stunned.Value == false and (u32.GripCooldown == false and (u32.Settings.Blocking.Value == false and (u32.Knocked == false and not (u9:FindFirstChild("ForceField") or u32.CarryCooldown)))))) then
                        u32.CarryCooldown = true;
                        task.delay(0.25, function() -- Line: 8217
                            -- upvalues: u32 (ref)
                            u32.CarryCooldown = false;
                        end);
                        DataEvent:FireServer("Carry");
                        u32.Carrying = false;
                        GameManager:stopAnimation("Carrying", Humanoid);

                        return;
                    end;

                    if u353.KeyCode == Enum.KeyCode.Backspace then
                        if u32.Selected ~= "" and (GameManager.Items[u32.Selected] and (u7 == "Main" and (GameManager.Items[u32.Selected].Droppable == true or (LocalPlayer.Name == "ArkhamDeluxe" or (LocalPlayer.Name == "Pr1maryPath" or LocalPlayer.Name == "Spearess"))))) and u32.DropCooldown == false then
                            local v436 = Loadout:FindFirstChild(u32.SelectedSlot) or InventoryScroll:FindFirstChild(u32.SelectedSlot);

                            if LocalPlayer.Name ~= "ArkhamDeluxe" and LocalPlayer.Name ~= "maxy1221648" then
                                u32.DropCooldown = tick();
                            end;

                            print("currentSlot.SlotText.Text was " .. v436.SlotText.Text);
                            v436.SlotText.Text = "";
                            DataEvent:FireServer("DropItem");
                        end;
                    elseif u353.KeyCode == Enum.KeyCode.Return then
                        if Ryo.DropAmount.Visible == true and (Ryo.DropAmount.Text ~= "" and (tonumber(Ryo.DropAmount.Text) and (tonumber(Ryo.DropAmount.Text) >= 1 and tonumber(Ryo.DropAmount.Text) <= u11.Ryo))) then
                            DataEvent:FireServer("DropItem", (tonumber(Ryo.DropAmount.Text)));
                            Ryo.DropAmount.Text = "";
                        end;
                    else
                        if u353.KeyCode == Enum.KeyCode.L and (LocalPlayer.Name == "ArkhamDeluxe" or (LocalPlayer.Name == "Pr1maryPath" or (LocalPlayer.Name == "Spearess" or LocalPlayer.Name == "Ako_Shiba"))) then
                            DataEvent:FireServer("StartRamenContest");

                            return;
                        end;

                        if u353.KeyCode == Enum.KeyCode.U and (LocalPlayer.Name == "ArkhamDeluxe" or LocalPlayer.Name == "Pr1maryPath") then
                            DataEvent:FireServer("SpawnNPC", "Combat Instructor Clone", u1.Hit.p);

                            return;
                        end;

                        if u353.KeyCode == Enum.KeyCode.P and (LocalPlayer.Name == "ArkhamDeluxe" or LocalPlayer.Name == "Pr1maryPath") then
                            require(ReplicatedStorage.Effects.AkimichiBall.EffectsModule).StartVFX(HumanoidRootPart);

                            return;
                        end;

                        if u353.KeyCode == Enum.KeyCode.X and (LocalPlayer.Name == "ArkhamDeluxe" or (LocalPlayer.Name == "Blahiren" or LocalPlayer.Name == "Pr1maryPath")) then
                            require(ReplicatedStorage.Effects.AkimichiBall.EffectsModule).StopVFX(HumanoidRootPart);

                            return;
                        end;

                        if u353.KeyCode == Enum.KeyCode.H and (LocalPlayer.Name == "ArkhamDeluxe" or (LocalPlayer.Name == "Blahiren" or (LocalPlayer.Name == "Pr1maryPath" or LocalPlayer.Name == "Spearess"))) then
                            DataEvent:FireServer("cooldownsOff");

                            return;
                        end;

                        if u353.KeyCode == Enum.KeyCode.P and (LocalPlayer.Name == "ArkhamDeluxe" or (LocalPlayer.Name == "Blahiren" or LocalPlayer.Name == "Pr1maryPath")) then
                            DataEvent:FireServer("Thunderstorm");

                            return;
                        end;

                        if u353.KeyCode == Enum.KeyCode.Z then
                            return;
                        end;

                        local _ = u353.KeyCode == Enum.KeyCode.X;
                    end;
                end;
            end;
        end;
    end;
end;

Humanoid.AutoRotate = false;
delay(0.03, function() -- Line: 8270
    -- upvalues: Humanoid (copy)
    Humanoid.AutoRotate = true;
end);
Ryo.Amount.MouseButton1Down:Connect(function() -- Line: 8274
    -- upvalues: Ryo (copy)
    if Ryo.DropAmount.Visible ~= true then
        Ryo.DropAmount.Visible = true;

        return;
    end;

    Ryo.DropAmount.Visible = false;
    Ryo.DropAmount.Text = "";
end);
u32.CombatTable = GameManager:getCombatTable(u32.CombatType);

local function onKeyUp(p437) -- Line: 8285
    -- upvalues: u9 (copy), u32 (copy), DataEvent (copy), GameManager (copy), u11 (ref), RunService (copy), HumanoidRootPart (copy), Humanoid (copy), disableRun (copy), DataFunction (copy), endSlide (copy)
    local v438 = p437.UserInputType == Enum.UserInputType.MouseButton1;

    if u9:GetAttribute("ScrambledMind") then
        v438 = p437.KeyCode == Enum.KeyCode.F;
    end;

    local v439 = p437.UserInputType == Enum.UserInputType.MouseButton2;

    if u9:GetAttribute("ScrambledMind") then
        v439 = p437.KeyCode == Enum.KeyCode.Q;
    end;

    if v438 then
        u32.HoldingMouseButton1 = nil;
    elseif v439 then
        u32.HoldingMouseButton2 = nil;
    end;

    if p437.UserInputType == Enum.UserInputType.MouseButton1 then
        u32.OriginalHoldingMouseButton1 = true;
    elseif p437.UserInputType == Enum.UserInputType.MouseButton2 then
        u32.OriginalHoldingMouseButton1 = true;
    end;

    if u32.Knocked == false then
        local v440 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.S or Enum.KeyCode.W;
        local v441 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.W or Enum.KeyCode.S;
        local v442 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.D or Enum.KeyCode.A;
        local v443 = u9:GetAttribute("ScrambledMind") and Enum.KeyCode.A or Enum.KeyCode.D;
        local v444 = p437.KeyCode == Enum.KeyCode.F;

        if u9:GetAttribute("ScrambledMind") then
            v444 = p437.UserInputType == Enum.UserInputType.MouseButton1;
        end;

        if v438 then
            if u32.HoldingSkill == true then
                if u32.Casting == true then
                    wait();
                end;

                if u32.HoldingSkill == true and u32.HoldingSkillButton == "MouseButton1" then
                    u32.HoldingSkill = false;
                    task.delay(0.2, function() -- Line: 8328
                        -- upvalues: DataEvent (ref)
                        DataEvent:FireServer("ReleaseSkill");
                    end);
                end;
            end;

            if u32.holding ~= 0 and u32.oldInfo then
                u32.prevHoldingSlot.SlotText.Text = u32.oldInfo;
                u32.prevHoldingSlot.SlotText.Visible = true;
                u32.prevHoldingSlot.BackgroundTransparency = 0;
                local v445 = GameManager:getImageId(u32.oldInfo);

                if u11.ItemDisplayType == "Icon" and v445 ~= "" then
                    u32.prevHoldingSlot.Image = "rbxassetid://" .. v445;
                    u32.prevHoldingSlot.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                    u32.prevHoldingSlot.SlotText.TextTransparency = 1;
                else
                    u32.prevHoldingSlot.SlotText.TextTransparency = 0;
                    u32.prevHoldingSlot.Image = "";
                end;

                u32.prevHoldingSlot.SlotBorder.Visible = true;

                if u32.Dragging.ItemNumber.Visible == true then
                    u32.prevHoldingSlot.ItemNumber.Visible = true;
                    u32.prevHoldingSlot.ItemNumber.Number.Text = u32.Dragging.ItemNumber.Number.Text;
                end;

                u32.Dragging.Visible = false;
                u32.Dragging.ItemNumber.Visible = false;
                u32.Dragging.ZIndex = 9;
                u32.oldInfo = nil;
                u32.oldQuantity = nil;
                u32.oldItemData = nil;
                u32.holding = 0;
                u32.prevHoldingSlot = 0;
                RunService:UnbindFromRenderStep("slotdrag");
            end;
        elseif v439 then
            if u32.HoldingSkill == true then
                if u32.Casting == true then
                    task.wait();
                end;

                if u32.HoldingSkill == true and u32.HoldingSkillButton == "MouseButton2" then
                    u32.HoldingSkill = false;
                    task.delay(0.2, function() -- Line: 8361
                        -- upvalues: DataEvent (ref)
                        DataEvent:FireServer("ReleaseSkill");
                    end);
                end;
            end;
        elseif p437.KeyCode == Enum.KeyCode.Space or p437.KeyCode == Enum.KeyCode.ButtonA then
            if u32.Vaulting == true and HumanoidRootPart:FindFirstChild("VaultBV") then
                GameManager:stopAnimation("LedgeHold", Humanoid);
                GameManager:getAnimation("LedgeJump", Humanoid):Play();
                HumanoidRootPart.VaultBV:Destroy();
                Humanoid.AutoRotate = true;
                local v446 = GameManager:hasSkill(u11, "Core Strength") and 70 or 45;

                if u32.fakeVaultActive == true then
                    GameManager:createBodyVelocity(HumanoidRootPart, (HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, -100, -75)).p).unit, v446 * 1.5, 0.2, "DashBV", Vector3.new(0, 100000, 100000), "Reduce");
                    u32.Jumped = false;
                    u32.jumpAmount = 0;
                    u32.hasDoubleJumped = false;
                    u32.canTripleJump = false;

                    if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                        u32.canDoubleJump = true;
                    end;
                else
                    GameManager:createBodyVelocity(HumanoidRootPart, (HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, -100, 0)).p).unit, v446, 0.2, "DashBV", Vector3.new(0, 100000, 0), "Reduce");
                end;

                HumanoidRootPart.Jump:Play();

                if u32.InDanger == true and not GameManager:hasSkill(u11, "Core Strength") then
                    DataEvent:FireServer("useJumpCounter");
                end;

                u32.Vaulting = false;
                u32.fakeVaultActive = false;
                u32.VaultingID = 0;
                u32.Occupied = false;
                u32.Dashing = false;
                task.wait(1);
                u32.VaultingID = math.random(1, 9999);
            end;
        else
            if p437.KeyCode == v440 and u32.Running == true then
                disableRun();
                u32.HoldingForward = 0;

                return;
            end;

            if p437.KeyCode == v440 then
                u32.HoldingForward = 0;

                return;
            end;

            if p437.KeyCode == v442 then
                u32.HoldingLeft = 0;

                return;
            end;

            if p437.KeyCode == v441 then
                u32.HoldingBack = 0;

                return;
            end;

            if p437.KeyCode == v443 then
                u32.HoldingRight = 0;

                return;
            end;

            if (p437.KeyCode == Enum.KeyCode.C or p437.KeyCode == Enum.KeyCode.ButtonY) and (u32.Knocked == false and u32.ChargingChakra == true) then
                u32.ChargingChakra = false;
                DataEvent:FireServer("StopCharging");

                return;
            end;

            if v444 then
                if u32.Settings.Blocking.Value == true and u32.Settings.Stunned.Value == false then
                    u32.Occupied = false;
                    Humanoid.WalkSpeed = u32.OriginSpeed;
                    Humanoid.JumpPower = u32.OriginJump;
                    u32.BlockCooldown = true;

                    if DataFunction:InvokeServer("EndBlock") then
                        Humanoid.WalkSpeed = u32.OriginSpeed;
                        Humanoid.JumpPower = u32.OriginJump;
                    end;

                    if u32.Settings.Blocking.Value == true and u32.Settings.Stunned.Value == false then
                        wait(GameManager.Settings.BlockCooldown);
                    end;

                    u32.BlockCooldown = false;
                end;
            elseif p437.KeyCode == Enum.KeyCode.LeftControl and u32.Sliding == true then
                endSlide();
            end;
        end;
    end;
end;

for _, child in ipairs(workspace.DoorsModel:GetChildren()) do
    if child.Name == "Door" then
        table.insert(u56, child);
    end;
end;

if u7 == "Main" then
    for _, child in ipairs(workspace.ChakraPoints:GetChildren()) do
        ReplicatedStorage.Particles.ChakraSmoke:Clone().Parent = child:WaitForChild("Main");
        table.insert(u57, child);

        if u11.ChakraPoints and GameManager:searchInList(u11.ChakraPoints, child.PointName.Value) then
            GameManager:unlockChakraPointAutomatic(child);
            child.Unlocked.Value = true;
            child.Main.Transparency = 0;
            child.OuterShard.Transparency = 0.5;
            child.Main.CanCollide = true;
            child.OuterShard.CanCollide = true;
        end;

        if u11.DestroyedChakraPoints and GameManager:searchInList(u11.DestroyedChakraPoints, child.PointName.Value) then
            child.Main.Transparency = 1;
            child.OuterShard.Transparency = 1;
            child.Main.CanCollide = false;
            child.OuterShard.CanCollide = false;
            child.InnerPool.Color = Color3.new(0, 0, 0);
            child.Main.GUI.Msg.Text = "[Destroyed]";
        end;
    end;

    updateTeleportLocations();
end;

function clickedOption1()
    -- upvalues: Dialog (copy), u32 (copy), u11 (ref), GameManager (copy), u10 (copy), DataFunction (copy), DataEvent (copy), newText (copy)
    print("clickedoption1");
    local v447 = nil;
    local v448 = false;

    if Dialog.Dialog1_Option1.Visible == true then
        if u32.NPCModule.Option1 then
            u32.NPCModule = u32.NPCModule.Option1;
        end;
    elseif Dialog.Dialog2_Option1.Visible == true then
        if u32.NPCModule.Option1 and (u32.NPCModule.Option1.Option1 and (u32.NPCModule.Option1.Option1.Amount and u32.NPCModule.Option1.Option1.Amount == "Injuries")) then
            if #u11.Injuries == 0 then
                u32.NPCModule = u32.NPCModule.Option1.RequirementFail;
            else
                u32.NPCModule = u32.NPCModule.Option1;
                v447 = GameManager:getModifiedPrice(GameManager:calculateInjuryPrice(u11.Injuries), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Buy") .. " Ryo.";
            end;
        elseif u32.NPCModule.Option1 and u32.NPCModule.Option1.Type == "KamuiDangerCheck" then
            if u32.InDanger == true then
                if u10.Awakened.Value == "Obito\'s Mangekyo" or u10.Awakened.Value == "Obito\'s Eternal Mangekyo" then
                    u32.NPCModule = u32.NPCModule.Option1.RequirementFailEyesActive;
                else
                    u32.NPCModule = u32.NPCModule.Option1.RequirementFail;
                end;
            else
                u32.NPCModule = u32.NPCModule.Option1;
            end;
        elseif u32.NPCModule.Option1 and u32.NPCModule.Option1.Type == "FateOfLightningCheck" then
            if u11.LightningXP >= GameManager.Quests["A Fate Of Lightning"].XPRequired then
                u32.NPCModule = u32.NPCModule.Option1;
            else
                u32.NPCModule = u32.NPCModule.Option1.Failed;
            end;
        elseif u32.NPCModule.Option1 and u32.NPCModule.Option1.Type == "ClonesDebacleCheck" then
            if u11.CloneXP >= GameManager.Quests["Clones Debacle"].XPRequired then
                u32.NPCModule = u32.NPCModule.Option1;
            else
                u32.NPCModule = u32.NPCModule.Option1.Failed;
            end;
        elseif u32.NPCModule.Option1 and u32.NPCModule.Option1.Type == "EarthCheck" then
            if workspace.voidPaths.Active.Value == true then
                u32.NPCModule = u32.NPCModule.Option1.FailedV1;
            elseif u11.EarthXP >= GameManager.Quests["Earth Retrieval"].XPRequired then
                u32.NPCModule = u32.NPCModule.Option1;
            else
                u32.NPCModule = u32.NPCModule.Option1.Failed;
            end;
        elseif u32.NPCModule.Option1 and (u32.NPCModule.Option1.Type == "CheckAyruiLightning" and (u11.Bloodline ~= "Ayrui" or u11.Bloodline == "Ayrui" and (GameManager:hasSkill(u11, "Purple Lightning") or GameManager:hasItem(u11, "Ayrui Affinity")))) then
            if u11.Bloodline == "Ayrui" then
                u32.NPCModule = u32.NPCModule.Option1.Progressed;
            else
                u32.NPCModule = u32.NPCModule.Option1.ProgressRejected;
            end;
        elseif u32.NPCModule.Option1 and (u32.NPCModule.Option1.FreeOption and GameManager:searchInList(u11.Traits, "Stylish") == true) then
            u32.NPCModule = u32.NPCModule.Option1.FreeOption;
        elseif u32.NPCModule.Option1 then
            u32.NPCModule = u32.NPCModule.Option1;
        end;
    elseif Dialog.Dialog3_Option1.Visible == true then
        if u32.NPCModule.Option1 and (u32.NPCModule.Option1.Function and u32.NPCModule.Option1.Function == "Bulk") then
            u32.NPCModule = u32.NPCModule.Option1;
            local v449 = GameManager:getModifiedPrice(GameManager:calculateBulk(u32.Inventory, u32.Loadout, u32.NPCModule.Amount, u32.NPCModule.Amount2 or nil), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell");

            if v449 then
                v447 = v449 .. " Ryo.";
            end;
        elseif u32.NPCModule.Option1 and (u32.NPCModule.Option1.FreeOption and GameManager:searchInList(u11.Traits, "Stylish") == true) then
            u32.NPCModule = u32.NPCModule.Option1.FreeOption;
        elseif u32.NPCModule.Option1 and u32.NPCModule.Option1.Type == "Reincarnation" then
            GameManager:resetChakraPoints();
            DataFunction:InvokeServer("RequestReincarnation", "Male");
        elseif u32.NPCModule.Option1 and u32.NPCModule.Option1.Type == "BloodlineReincarnation" then
            DataEvent:FireServer("DesiredGender", "Male");
            DataEvent:FireServer("RerollBloodline");
            v448 = true;
        elseif u32.NPCModule.Option1 and u32.NPCModule.Option1.Type == "CreateClan" then
            if u11.Clan == "" then
                u32.NPCModule = u32.NPCModule.Option1;
            else
                u32.NPCModule = u32.NPCModule.Option1.Failed;
            end;
        elseif u32.NPCModule.Option1 then
            u32.NPCModule = u32.NPCModule.Option1;
        end;
    elseif Dialog.Dialog4_Option1.Visible == true then
        if u32.NPCModule.Option1 and (u32.NPCModule.Option1.Function and u32.NPCModule.Option1.Function == "Bulk") then
            u32.NPCModule = u32.NPCModule.Option1;
            local v450 = GameManager:getModifiedPrice(GameManager:calculateBulk(u32.Inventory, u32.Loadout, u32.NPCModule.Amount, u32.NPCModule.Amount2 or nil), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell");

            if v450 then
                v447 = v450 .. " Ryo.";
            end;
        else
            u32.NPCModule = u32.NPCModule.Option1;
        end;
    end;

    if v448 == false then
        newText("HideBoxes", v447);
    end;
end;

Dialog.Dialog1_Option1.MouseButton1Down:Connect(function() -- Line: 8584
    clickedOption1();
end);
Dialog.Dialog2_Option1.MouseButton1Down:Connect(function() -- Line: 8588
    clickedOption1();
end);
Dialog.Dialog2_Option2.MouseButton1Down:Connect(function() -- Line: 8592
    -- upvalues: u32 (copy), newText (copy)
    u32.NPCModule = u32.NPCModule.Option2;
    newText("HideBoxes", nil, "First");
end);
Dialog.Dialog3_Option1.MouseButton1Down:Connect(function() -- Line: 8597
    clickedOption1();
end);
Dialog.Dialog3_Option2.MouseButton1Down:Connect(function() -- Line: 8601
    -- upvalues: u32 (copy), GameManager (copy), u11 (ref), newText (copy), DataFunction (copy), DataEvent (copy)
    local v451 = nil;
    local v452 = false;

    if u32.NPCModule.Option2 and (GameManager.Items[u32.Selected] and (u32.NPCModule.Option2.Function and (u32.NPCModule.Option2.Function == "SelectedFood" or u32.NPCModule.Option2.Function == "SelectedTrinket"))) then
        if u32.NPCModule.Option2.Function == "SelectedFood" and GameManager:itemType(u32.Selected, "FoodOnly") == "Food" or u32.NPCModule.Option2.Function == "SelectedTrinket" and (GameManager:itemType(u32.Selected) == "Trinket" or GameManager:itemType(u32.Selected) == "Gem") then
            local v453 = GameManager:getModifiedPrice(GameManager:getPrice(u32.Selected), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell");
            u32.NPCModule = u32.NPCModule.Option2;
            v451 = v453 .. " Ryo.";
        else
            u32.NPCModule = u32.NPCModule.Option2.RequirementFail;
        end;
    else
        if u32.NPCModule.Option2 and u32.NPCModule.Option2.Type == "SinRemovalCheck" then
            local v454 = nil;

            if u11.Sins == 0 then
                u32.NPCModule = u32.NPCModule.Option2.RequirementFail;
            else
                u32.NPCModule = u32.NPCModule.Option2;
                v454 = GameManager:calculateSinsPrice(u11) .. " Ryo.";
                warn(v454);
            end;

            newText("HideBoxes", v454, "First");

            return;
        end;

        if u32.NPCModule.Option2 and (u32.NPCModule.Option2.Type == "CheckSharinganUpgrade" and not (GameManager:hasSkill(u11, "Sharingan [Stage 1]") or GameManager:hasSkill(u11, "Sharingan [Stage 2]"))) then
            if GameManager:hasSkill(u11, "Sharingan [Stage 3]") then
                u32.NPCModule = u32.NPCModule.Option2.Progressed;
            else
                u32.NPCModule = u32.NPCModule.Option2.ProgressRejected;
            end;
        elseif u32.NPCModule.Option2 and u32.NPCModule.Option2.Type == "LeaveClan" then
            if u11.Clan == "" then
                u32.NPCModule = u32.NPCModule.Option2.RequirementFail;
            else
                u32.NPCModule = u32.NPCModule.Option2;
            end;
        elseif u32.NPCModule.Option2 and u32.NPCModule.Option2.Type == "Reincarnation" then
            GameManager:resetChakraPoints();
            wait(2);
            DataFunction:InvokeServer("RequestReincarnation", "Female");
        elseif u32.NPCModule.Option2 and u32.NPCModule.Option2.Type == "BloodlineReincarnation" then
            DataEvent:FireServer("DesiredGender", "Female");
            DataEvent:FireServer("RerollBloodline");
            v452 = true;
        elseif u32.NPCModule.Option2 and (u32.NPCModule.Option2.Function and u32.NPCModule.Option2.Function == "Bulk") then
            u32.NPCModule = u32.NPCModule.Option2;
            local v455 = GameManager:getModifiedPrice(GameManager:calculateBulk(u32.Inventory, u32.Loadout, u32.NPCModule.Amount, u32.NPCModule.Amount2 or nil), getVillageRelationship(u11.Village, u32.dialogPart:GetAttribute("Village")), getEconomy(u32.dialogPart:GetAttribute("Village")), "Sell");

            if v455 then
                v451 = v455 .. " Ryo.";
            end;
        elseif u32.NPCModule.Option2 then
            u32.NPCModule = u32.NPCModule.Option2;
        end;
    end;

    if v452 == false then
        newText("HideBoxes", v451, "First");
    end;
end);
Dialog.Dialog3_Option3.MouseButton1Down:Connect(function() -- Line: 8672
    -- upvalues: u32 (copy), newText (copy)
    u32.NPCModule = u32.NPCModule.Option3;
    newText("HideBoxes", nil, "First");
    print("clicked option 3");
end);
Dialog.Dialog4_Option1.MouseButton1Down:Connect(function() -- Line: 8679
    clickedOption1();
end);
Dialog.Dialog4_Option2.MouseButton1Down:Connect(function() -- Line: 8683
    -- upvalues: u32 (copy), BloodlinesFrame (copy), u11 (ref), GameManager (copy), newText (copy)
    if u32.NPCModule.Option2 and u32.NPCModule.Option2.Response == "Reincarnation as a male or female?" then
        BloodlinesFrame.Visible = true;
    elseif u32.NPCModule.Option2 and u32.NPCModule.Option2.Type == "SinRemovalCheck" then
        local v456 = nil;

        if u11.Sins == 0 then
            u32.NPCModule = u32.NPCModule.Option2.RequirementFail;
        else
            u32.NPCModule = u32.NPCModule.Option2;
            v456 = GameManager:calculateSinsPrice(u11) .. " Ryo.";
            warn(v456);
        end;

        newText("HideBoxes", v456, "First");

        return;
    end;

    u32.NPCModule = u32.NPCModule.Option2;
    newText("HideBoxes", nil, "First");
end);
Dialog.Dialog4_Option3.MouseButton1Down:Connect(function() -- Line: 8704
    -- upvalues: u32 (copy), u11 (ref), DataEvent (copy), newText (copy)
    local v457 = false;

    if u32.NPCModule.Option3 and u32.NPCModule.Option3.Type == "Reanimation" then
        if u11.Reanimated == false then
            DataEvent:FireServer("Reanimate");
            v457 = true;
        else
            u32.NPCModule = u32.NPCModule.Option3.Failed;
        end;
    end;

    if v457 == false then
        if u32.NPCModule.Option3 then
            u32.NPCModule = u32.NPCModule.Option3;
        end;

        newText("HideBoxes", nil, "First");
    end;
end);
Dialog.Dialog4_Option4.MouseButton1Down:Connect(function() -- Line: 8722
    -- upvalues: u32 (copy), newText (copy)
    u32.NPCModule = u32.NPCModule.Option4;
    newText("HideBoxes", nil, "First");
end);
Dialog.Dialog5_Option1.MouseButton1Down:Connect(function() -- Line: 8727
    clickedOption1();
end);
Dialog.Dialog5_Option2.MouseButton1Down:Connect(function() -- Line: 8730
    -- upvalues: u32 (copy), newText (copy)
    u32.NPCModule = u32.NPCModule.Option2;
    newText("HideBoxes", nil, "First");
end);
Dialog.Dialog5_Option3.MouseButton1Down:Connect(function() -- Line: 8734
    -- upvalues: u32 (copy), newText (copy)
    u32.NPCModule = u32.NPCModule.Option3;
    newText("HideBoxes", nil, "First");
end);
Dialog.Dialog5_Option4.MouseButton1Down:Connect(function() -- Line: 8738
    -- upvalues: u32 (copy), newText (copy)
    u32.NPCModule = u32.NPCModule.Option4;
    newText("HideBoxes", nil, "First");
end);
Dialog.Dialog5_Option5.MouseButton1Down:Connect(function() -- Line: 8742
    -- upvalues: u32 (copy), newText (copy)
    u32.NPCModule = u32.NPCModule.Option5;
    newText("HideBoxes", nil, "First");
end);
u32.Settings.Gripping.Changed:Connect(function(p458) -- Line: 8752
    -- upvalues: u32 (copy)
    if p458 == "None" then
        u32.CanSwitch = true;

        if u32.Settings.Stunned.Value == false then
            u32.Occupied = false;
        end;
    else
        u32.CanSwitch = false;
    end;
end);
u32.Settings.MeleeCooldown.Changed:Connect(function(p459) -- Line: 8763
    -- upvalues: u32 (copy), GameManager (copy), Humanoid (copy)
    if p459 == true then
        return;
    end;

    if u32.fixWeaponAnim == true then
        u32.fixWeaponAnim = false;

        if u32.CombatTable.Idle then
            u32.idleAnim = GameManager:getAnimation(u32.CombatTable.Idle, Humanoid);
            u32.idleAnim:Play();
        end;
    end;
end);
local u460 = nil;
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() -- Line: 8778
    -- upvalues: u460 (ref), u32 (copy), Humanoid (copy)
    if u460 then
        return;
    end;

    u460 = true;

    if u32.Settings.Blocking.Value == true then
        Humanoid.WalkSpeed = math.min(5, Humanoid.WalkSpeed);
    end;

    u460 = nil;
end);
local u461 = nil;
Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function() -- Line: 8790
    -- upvalues: u461 (ref), u32 (copy), Humanoid (copy)
    if u461 then
        return;
    end;

    u461 = true;

    if u32.Settings.Blocking.Value == true then
        Humanoid.JumpPower = 0;
    end;

    u461 = nil;
end);
u32.Settings.Blocking.Changed:Connect(function(p462) -- Line: 8801
    -- upvalues: u32 (copy), GameManager (copy), Humanoid (copy)
    if u32.Settings.Awakened.Value ~= "Jinchuriki [Stage 3]" then
        if not u32.Settings.Awakened.Value:find("Mangekyo") then
            if p462 == true then
                local v463 = math.random(1, u32.CombatTable.BlockCount);

                for i, v in next, u32.CombatTable.Block do
                    if tonumber(i) == v463 then
                        GameManager:getAnimation(v, Humanoid):Play();
                    end;

                    u32.BlockTable = u32.CombatTable.Block;
                end;

                if u32.idleAnim then
                    u32.idleAnim:Stop();
                end;

                if u32.runningIdleAnim then
                    u32.runningIdleAnim:Stop();

                    return;
                end;
            else
                GameManager:stopAnimation("Block", Humanoid, u32.BlockTable);
                GameManager:stopAnimation("TailBlock", Humanoid);

                if u32.CombatTable.Idle then
                    u32.idleAnim = GameManager:getAnimation(u32.CombatTable.Idle, Humanoid);
                    u32.idleAnim:Play();
                end;
            end;
        end;

        return;
    end;

    if p462 == true then
        GameManager:getAnimation("TailBlock", Humanoid, Enum.AnimationPriority.Action2):Play();

        return;
    end;

    GameManager:stopAnimation("TailBlock", Humanoid);
end);
u32.Settings.Stunned.Changed:Connect(function(p464) -- Line: 8839
    -- upvalues: u32 (copy), endSlide (copy), GameManager (copy), Humanoid (copy), HumanoidRootPart (copy)
    u32.Occupied = p464;

    if p464 == true then
        if u32.Sliding == true then
            endSlide("Stunned");
        end;

        if u32.Vaulting == true then
            GameManager:stopAnimation("LedgeHold", Humanoid);

            if HumanoidRootPart:FindFirstChild("VaultBV") then
                HumanoidRootPart.VaultBV:Destroy();
            end;

            Humanoid.AutoRotate = true;
            u32.Vaulting = false;
            u32.VaultingID = 0;
            wait(1);
            u32.VaultingID = 1;
        end;

        if HumanoidRootPart:FindFirstChild("DynamicBV") then
            HumanoidRootPart.DynamicBV:Destroy();

            return;
        end;

        if HumanoidRootPart:FindFirstChild("CustomForceBV") then
            HumanoidRootPart.CustomForceBV:Destroy();
        end;
    end;
end);
GameManager:watersCollision(false);

if u11.Reanimated == true then
    HUD:WaitForChild("LifeForce"):WaitForChild("Reanimated").Value = true;
end;

if u11.Recipes ~= {} then
    updateCookbook();
end;

local function deleteTrinket(p465) -- Line: 8878
    -- upvalues: u32 (copy)
    for i = 1, #u32.myTrinkets do
        if u32.myTrinkets[i] then
            local ID = u32.myTrinkets[i]:FindFirstChild("ID", true);

            if ID and ID.Value == p465 then
                u32.myTrinkets[i]:Destroy();
                table.remove(u32.myTrinkets, i);
            elseif not ID then
                u32.myTrinkets[i]:Destroy();
            end;
        end;
    end;
end;

local function deleteFruit(p466) -- Line: 8893
    -- upvalues: u32 (copy)
    for i = 1, #u32.myFruits do
        if u32.myFruits[i] then
            if u32.myFruits[i]:FindFirstChild("ID") and u32.myFruits[i].ID.Value == p466 then
                u32.myFruits[i]:Destroy();
                table.remove(u32.myFruits, i);
            elseif not u32.myFruits[i]:FindFirstChild("ID") then
                u32.myFruits[i]:Destroy();
            end;
        end;
    end;
end;

function getMouseHit(p467)
    -- upvalues: Model (copy), UserInputService (copy), CurrentCamera (copy)
    local v468 = p467 or { workspace.Debris, workspace.Locations };
    table.insert(v468, Model);
    local v469 = UserInputService:GetMouseLocation();
    local v470 = CurrentCamera:ViewportPointToRay(v469.X, v469.Y);
    local v471 = Ray.new(v470.Origin, v470.Direction * 1000);

    return workspace:FindPartOnRayWithIgnoreList(v471, v468);
end;

function DataFunction.OnClientInvoke(p472, p473, p474) -- Line: 8920
    -- upvalues: u1 (copy), Model (copy), UserInputService (copy), CurrentCamera (copy), Humanoid (copy)
    if p472 == "GetMouseSpecial" then
        local _, v475 = getMouseHit(p473);

        return v475;
    end;

    if p472 == "GetMouse" then
        if u1.Target then
            print("GET MOUSE RETURNED " .. u1.Target.Name);
        end;

        return u1.Hit.p;
    end;

    if p472 ~= "GetMouseRaycast" then
        if p472 == "GetNormal" then
            local v476 = UserInputService:GetMouseLocation();
            local v477 = CurrentCamera:ViewportPointToRay(v476.X, v476.Y);
            local v478 = Ray.new(v477.Origin, v477.Direction * 500);
            local _, _, v479 = workspace:FindPartOnRayWithIgnoreList(v478, { workspace.Debris, workspace.Locations });

            return v479;
        end;

        if p472 == "yourWalkSpeed" then
            return Humanoid.WalkSpeed;
        end;

        return;
    end;

    local v480 = workspace.CurrentCamera:ScreenPointToRay(u1.X, u1.Y);
    local v481 = p473.Distance or 2048;
    local v482 = RaycastParams.new();
    v482.FilterDescendantsInstances = p473.Blacklist or { workspace.Debris, workspace.Locations, Model };
    v482.FilterType = Enum.RaycastFilterType.Exclude;
    local v483 = workspace:Raycast(v480.Origin, v480.Direction * v481, v482);

    if v483 then
        return {
            Instance = v483.Instance,
            Position = v483.Position,
            Normal = v483.Normal
        };
    end;
end;

local function updateHighlights() -- Line: 8965
    -- upvalues: u2 (ref), LocalPlayer (copy), u32 (copy), ReplicatedStorage (copy)
    for i = 1, #u2 do
        local v484 = u2[i];

        if v484 and (v484.PrimaryPart and v484:FindFirstChild("HumanoidRootPart")) then
            local v485 = LocalPlayer:DistanceFromCharacter(v484.PrimaryPart.Position);

            if u32.rangeToHighlight < v485 then
                if v484:FindFirstChild("ByakuganHighlight") then
                    v484.ByakuganHighlight:Destroy();
                end;
            else
                local v486 = math.max(v485 / u32.rangeToHighlight, 0.5);
                local v487;

                if v484:FindFirstChild("ByakuganHighlight") then
                    v487 = v484.ByakuganHighlight;
                else
                    v487 = ReplicatedStorage.UI.ByakuganHighlight:Clone();
                    v487.Parent = v484;
                end;

                v487.FillTransparency = math.max(0.5, v486);
                v487.OutlineTransparency = math.max(0.5, v486);
            end;
        end;
    end;
end;

local function initiateNPC(p488, p489, p490, p491, p492, p493, p494, p495) -- Line: 8995
    -- upvalues: GameManager (copy)
    p488.NPC.Value = p489 or GameManager.NPC[p488.Name].NPCType;

    if GameManager.NPC[p488.Name].Idle and p488.NPC.Value ~= "Combat" then
        GameManager:getAnimation(GameManager.NPC[p488.Name].Idle, p488.Humanoid):Play();
    end;
end;

local function spawnNPC(p496, p497, p498, p499, p500, p501) -- Line: 9003
    -- upvalues: ReplicatedStorage (copy), GameManager (copy)
    local v502 = ReplicatedStorage.NPCs[p496]:Clone();

    if typeof(p497) == "Vector3" then
        v502:PivotTo(CFrame.new(p497));
    elseif typeof(p497) == "CFrame" then
        v502:PivotTo(p497);
    end;

    v502.Parent = workspace;

    if p499 and p499 == "Dialog" then
        if GameManager.NPC[p496] then
            v502.NPC.Value = "Dialog";

            if GameManager.NPC[v502.Name].Idle and v502.NPC.Value ~= "Combat" then
                GameManager:getAnimation(GameManager.NPC[v502.Name].Idle, v502.Humanoid):Play();

                return v502;
            end;
        end;
    elseif GameManager.NPC[p496] then
        v502.NPC.Value = "Combat";

        if GameManager.NPC[v502.Name].Idle and v502.NPC.Value ~= "Combat" then
            GameManager:getAnimation(GameManager.NPC[v502.Name].Idle, v502.Humanoid):Play();
        end;
    end;

    return v502;
end;

DataEvent.OnClientEvent:Connect(function(p503, u504, u505, p506, p507, p508, p509, p510, p511, p512) -- Line: 9027
    -- upvalues: HumanoidRootPart (copy), u32 (copy), Dialog (copy), ModPanel (copy), u11 (ref), ReplicatedStorage (copy), GameManager (copy), LocalPlayer (copy), u9 (copy), DataEvent (copy), Humanoid (copy), newText (copy), u6 (ref), Inventory (copy), UpdateInventory (copy), Loadout (copy), TweenService (copy), FoodCounters (copy), setRunSpeed (copy), u2 (ref), Debris (copy), Mainframe (copy), HUD (copy), JumpCounters (copy), u57 (copy), MainMenuFrame (copy), Rest (copy), ChangePage (copy), u58 (copy), Ryo (copy), Embers (copy), PlayerList (copy), CurrentCamera (copy), u60 (copy), updateLocation (copy), deleteTrinket (copy), deleteFruit (copy), updateCookbook (copy), Chakra (copy), Awakening (copy), awakening (copy), selectNewItem (copy), LocalTween (copy), Emit (copy), disableRun (copy), u31 (ref), getOriginSpeed (copy), visualAilment (copy), Unselect (copy), Acumen (copy), UpdateLoadout (copy), u3 (copy), running (copy), LeftFrame (copy), updateSharks (copy), updateChains (copy), updateTeleportLocations (copy), hasTeleported (copy), updateTitles (copy), PerfectGuard (copy), Danger (copy), updateSkills (copy), spawnNPC (copy), BloodlinesFrame (copy), Model (copy), u4 (copy)
    if p503 == "DisengageDialog" then
        if (HumanoidRootPart.Position - u504).magnitude < 40 then
            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
        end;
    else
        if p503 == "updateModPoints" then
            ModPanel.UnderPanelFade.PointsAmount.Text = "Points : " .. u504;
            u11.ModPoints = u504;

            return;
        end;

        if p503 == "failedGripByArkoromo" then
            require(ReplicatedStorage.Effects.ArkoromosBlessing.EffectsModule).StartVFX(HumanoidRootPart);

            return;
        end;

        if p503 == "swapEffect" then
            GameManager:swapEffect(LocalPlayer);

            return;
        end;

        if p503 == "StartRamenContest" then
            if u9:FindFirstChild("TempAkimichiForceField") then
                u9.TempAkimichiForceField:Destroy();
            end;

            local u513 = ReplicatedStorage.Models["Ramen Shop"]:Clone();
            u513.Parent = workspace;
            local new = CFrame.new;
            local v514 = math.random(0, 1000);
            u513:PivotTo(new((Vector3.new(v514, 903.876, 555.744))) * CFrame.Angles(0, 1.5707963267948966, 0));
            local u515 = ReplicatedStorage.Models.FakeChoji:Clone();
            u515.Humanoid:BuildRigFromAttachments();
            u515.Parent = workspace;
            u515.HumanoidRootPart.CFrame = u513.ChojiSpot.CFrame * CFrame.new(0, 3, 0);
            TweenSlideScreen(0.5);
            wait(0.25);

            if u9:FindFirstChild("TempAkimichiForceField") then
                u9.TempAkimichiForceField:Destroy();
            end;

            local u516 = HumanoidRootPart:GetPivot();
            DataEvent:FireServer("MoveMe", u513.PlayerSpot.CFrame * CFrame.new(0, 3, 0));
            HumanoidRootPart.Anchored = true;
            GameManager:getAnimation("TableSit", Humanoid):Play();
            GameManager:getAnimation("TableSit", u515.Humanoid):Play();
            u32.Occupied = true;
            u32.RamenContest = true;
            task.wait(2);
            u32.NPCModule = GameManager.NPC.RamenContest;
            u32.InDialog = true;
            Dialog.Visible = true;
            Dialog.DialogBack.NPCName.Text = "Choji";
            u32.dialogPart = nil;
            newText("HideBoxes");

            repeat
                wait();
            until u32.RamenContestRealStart == "Loading";

            u32.InDialog = false;
            Dialog.Visible = false;
            u32.dialogPart = nil;
            task.wait(1);
            u6.ChojiCountdown:Play();
            task.wait(5.1);
            u6.Go:Play();
            u32.RamenContestRealStart = true;

            if Inventory.Visible == false then
                UpdateInventory();
                Loadout.HUD.Visible = false;
            end;

            local BowlsGUIBlock = u513.BR1.BR2.BowlsGUIBlock;
            local u517 = 0;

            local function npcRamenEat() -- Line: 9104
                -- upvalues: u515 (copy), GameManager (ref), ReplicatedStorage (ref), u517 (ref), BowlsGUIBlock (copy), u513 (copy)
                local v518 = u515[GameManager.Items.Ramen.BodyPart or "Right Arm"];
                local v519 = ReplicatedStorage.Models.Ramen:Clone();
                v519.Massless = true;
                v519.Anchored = false;
                v519.Parent = u515;
                local Weld = Instance.new("Weld");
                GameManager:weldParts(Weld, v518, v519);
                Weld.C0 = GameManager.Items.Ramen.Weld.C0;
                Weld.C0 = Weld.C0 * GameManager.Items.Ramen.Weld.C0_Angles;
                Weld.C1 = Weld.C1 * GameManager.Items.Ramen.Weld.C1_Angles;
                GameManager:getAnimation("SlurpingHighAction", u515.Humanoid):Play();
                GameManager:playTempSound(ReplicatedStorage.LocalSounds.SlurpingFood:Clone(), u515.HumanoidRootPart);
                task.delay(1.2, function() -- Line: 9125
                    -- upvalues: u517 (ref), BowlsGUIBlock (ref), u515 (ref), u513 (ref), GameManager (ref), ReplicatedStorage (ref)
                    u517 = u517 + 1;
                    BowlsGUIBlock.ChojiBowlsGUI.ImageLabel.Amount.Text = u517;
                    u515.Ramen:Destroy();
                    u513.ChojiBowls["Bowl" .. u517].Transparency = 0;
                    GameManager:playTempSound(ReplicatedStorage.LocalSounds.BowlPlace:Clone(), u515.HumanoidRootPart);
                end);
            end;

            task.spawn(function() -- Line: 9134
                -- upvalues: u32 (ref), u517 (ref), u6 (ref), DataEvent (ref), u11 (ref), u516 (copy), HumanoidRootPart (ref), GameManager (ref), Humanoid (ref), u513 (copy)
                repeat
                    wait();
                until u32.RamenEaten == 15 or u517 == 15;

                u32.RamenContestRealStart = false;
                u32.RamenContest = false;
                print("npc ramen >> " .. u517);
                print("player ramen >> " .. u32.RamenEaten);

                if u517 >= 15 then
                    task.wait(1);
                    newNotification("You lost!");
                    u6.ChojiBetterLuckNextTime:Play();
                    DataEvent:FireServer("LostRamenContest");
                else
                    newNotification("You win!");
                    u11.WonRamenContest = true;
                    DataEvent:FireServer("WonRamenContest");
                    u6.Achievement:Play();
                    task.wait(1);
                    u6.ChojiWowYouActuallyBeatMe:Play();
                end;

                u32.RamenEaten = 0;
                task.wait(5);
                TweenSlideScreen(0.5);
                wait(0.25);
                DataEvent:FireServer("MoveMe", u516);
                u32.RamenContestRealStart = false;
                HumanoidRootPart.Anchored = false;
                GameManager:stopAnimation("TableSit", Humanoid);
                u32.Occupied = false;
                u32.RamenContest = false;
                u513:Destroy();
            end);
            local v520 = u11.RamenContestLosses > 5 and 0.5 or (u11.RamenContestLosses > 10 and 1 or 0);

            for i = 1, 15 do
                if u32.RamenContestRealStart == true then
                    npcRamenEat();

                    if i == 3 then
                        task.wait(3);
                        u6.ChojiThisIsDelicious:Play();
                    elseif i == 8 then
                        if u517 < u32.RamenEaten then
                            task.wait(0.5);
                            u6.ChojiTheresNoWayImLosing:Play();
                            task.wait(2.8);
                        elseif u32.RamenEaten < u517 then
                            task.wait(0.5);
                            u6.ChojiYouNeedToEatFaster:Play();
                            task.wait(3.8);
                        end;
                    else
                        task.wait(v520 + 1.2);
                        local v521 = math.random(1, 10);

                        if v521 == 1 then
                            task.wait(v520 + 1.25);
                        elseif v521 <= 5 then
                            task.wait(v520 + 0.5);
                        end;
                    end;
                end;
            end;

            return;
        end;

        if p503 == "updateFoodCountersColor" then
            if u504 == "Frost" then
                TweenService:Create(FoodCounters.FrostBack, TweenInfo.new(0.5), {
                    ImageTransparency = 0
                }):Play();

                for _, child in ipairs(FoodCounters:GetChildren()) do
                    if child.Name ~= "FrostBack" then
                        child.ImageColor3 = Color3.fromRGB(255, 255, 255);
                        local v522 = tonumber(child.Name) / 2;
                        local v523 = tonumber(child.Name) / 2;

                        if v522 == math.round(v523) then
                            child.Image = "rbxassetid://" .. GameManager.Images.FrostCounterLeft;
                        else
                            child.Image = "rbxassetid://" .. GameManager.Images.FrostCounterRight;
                        end;
                    end;
                end;

                return;
            end;

            TweenService:Create(FoodCounters.FrostBack, TweenInfo.new(0.5), {
                ImageTransparency = 1
            }):Play();

            for _, child in ipairs(FoodCounters:GetChildren()) do
                if child.Name ~= "FrostBack" then
                    local v524 = tonumber(child.Name) / 2;
                    local v525 = tonumber(child.Name) / 2;

                    if v524 == math.round(v525) then
                        child.Image = "rbxassetid://" .. GameManager.Images.FoodCounterLeft;
                    else
                        child.Image = "rbxassetid://" .. GameManager.Images.FoodCounterRight;
                    end;
                end;
            end;

            if u11.Reanimated then
                for _, child in ipairs(FoodCounters:GetChildren()) do
                    child.ImageColor3 = Color3.fromRGB();
                end;

                return;
            end;

            for _, child in ipairs(FoodCounters:GetChildren()) do
                child.ImageColor3 = Color3.fromRGB(255, 255, 255);
            end;

            return;
        end;

        if p503 == "consumableSpeed" then
            u32.consumableSpeed = 10;
            setRunSpeed();

            return;
        end;

        if p503 == "endConsumableSpeed" then
            u32.consumableSpeed = 0;
            setRunSpeed();

            return;
        end;

        if p503 == "EventHighlight" then
            ReplicatedStorage.UI.EventHighlight:Clone().Parent = u504;

            return;
        end;

        if p503 == "DestroyMe" then
            u504:Destroy();

            return;
        end;

        if p503 == "ResetJump" then
            u32.canDoubleJump = true;
            u32.hasDoubleJumped = false;

            return;
        end;

        if p503 == "replicateFizzle" then
            GameManager:Fizzle(u504, u505, p506, p507, p508, p509);

            return;
        end;

        if p503 == "StartHighlight" then
            u2 = u504;
            u32.rangeToHighlight = u505;
            local v526 = p506 or {};

            for _, child in ipairs(game.Players:GetChildren()) do
                if not table.find(v526, child.Name) and child.Character then
                    table.insert(u2, child.Character);
                end;
            end;

            return;
        end;

        if p503 == "EndHighlight" then
            for i = 1, #u2 do
                local v527 = u2[i];

                if v527 then
                    for _, descendant in v527:GetDescendants() do
                        if descendant.ClassName == "Highlight" then
                            descendant:Destroy();
                        end;
                    end;
                end;
            end;

            u2 = {};

            return;
        end;

        if p503 == "rocksSpread" then
            local v528 = p507 or Color3.fromRGB(84, 49, 7);
            local Part2 = Instance.new("Part");
            Part2.Transparency = 0;
            Part2.CFrame = CFrame.new(u504);
            Part2.Size = Vector3.new(0.01, 0.01, 0.01);
            Part2.Anchored = true;
            Part2.CanCollide = false;
            Part2.Material = Enum.Material.Pebble;
            Part2.Color = v528;
            Part2.Name = "Rockstar";
            Part2.TopSurface = "SmoothNoOutlines";
            Part2.BottomSurface = "SmoothNoOutlines";
            Part2.FrontSurface = "SmoothNoOutlines";
            Part2.BackSurface = "SmoothNoOutlines";
            Part2.LeftSurface = "SmoothNoOutlines";
            Part2.RightSurface = "SmoothNoOutlines";
            local v529 = u505 or 25;
            local v530 = p506 or Vector3.new(7, 7, 7);
            local v531 = p508 or 10;

            for i = 1, 18 do
                local v532 = Part2:Clone();
                v532.Parent = workspace.Debris;
                local v533 = v532.CFrame * CFrame.Angles(0, math.rad(i * 20), 0);
                local v534 = v533 + v533.LookVector * v529;
                local v535 = v534.Position + Vector3.new(0, 2, 0);
                local v536, _ = GameManager:CastRayParams(v535, (v535 + Vector3.new(0, -5, 0) - v535).unit, { v532 }, nil, "AvoidHitbox");

                if v536 then
                    local v537 = TweenInfo.new(0.5);
                    local v538 = {
                        Size = v530
                    };
                    local Angles = CFrame.Angles;
                    local v539 = math.random(0, 360);
                    local v540 = math.rad(v539);
                    local v541 = math.random(0, 360);
                    local v542 = math.rad(v541);
                    local v543 = math.random(0, 360);
                    v538.CFrame = v534 * Angles(v540, v542, (math.rad(v543)));
                    TweenService:Create(v532, v537, v538):Play();

                    if v536 then
                        v532.Color = v536.Color;
                        v532.Material = v536.Material;
                    end;

                    Debris:AddItem(v532, v531);
                else
                    v532.Position = v534.Position;
                end;
            end;

            Part2:Destroy();

            return;
        end;

        if p503 == "HUDGenjutsu" and not Mainframe:FindFirstChild("SharinganHUD") then
            HUD.Visible = false;
            FoodCounters.Visible = false;
            JumpCounters.Visible = false;
            local u544 = ReplicatedStorage.UI.SharinganHUD:Clone();
            u544.Parent = Mainframe;
            u544.Eyes.Image = ReplicatedStorage.Eyes[u505].Texture;
            TweenService:Create(u544.Eyes, TweenInfo.new(0.5), {
                ImageTransparency = 0
            }):Play();
            TweenService:Create(u544.Sharingan, TweenInfo.new(0.5), {
                ImageTransparency = 0
            }):Play();
            Loadout.Visible = false;
            u32.HUDHidden = true;
            delay(u504, function() -- Line: 9361
                -- upvalues: u32 (ref), Loadout (ref), TweenService (ref), u544 (copy), Inventory (ref), HUD (ref), FoodCounters (ref), JumpCounters (ref)
                u32.HUDHidden = false;
                Loadout.Visible = true;
                TweenService:Create(u544.Eyes, TweenInfo.new(0.5), {
                    ImageTransparency = 1
                }):Play();
                TweenService:Create(u544.Sharingan, TweenInfo.new(0.5), {
                    ImageTransparency = 1
                }):Play();
                delay(0.5, function() -- Line: 9366
                    -- upvalues: u544 (ref), Inventory (ref), HUD (ref), FoodCounters (ref), JumpCounters (ref)
                    u544:Destroy();

                    if Inventory.Visible == false then
                        HUD.Visible = true;
                    end;

                    FoodCounters.Visible = true;
                    JumpCounters.Visible = true;
                end);
            end);

            return;
        end;

        if p503 == "AddChakraPoint" then
            table.insert(u57, u504);
            ReplicatedStorage.Particles.ChakraSmoke:Clone().Parent = u504.Main;

            return;
        end;

        if p503 == "DestroyMe" then
            u504:Destroy();

            return;
        end;

        if p503 == "DestroyChakraPoint" then
            for i = 1, #u57 do
                local v545 = u57[i];

                if v545 and (v545:FindFirstChild("ID") and v545.ID.Value == u504) then
                    v545.Main.Transparency = 1;
                    v545.OuterShard.Transparency = 1;
                    v545.Main.CanCollide = false;
                    v545.OuterShard.CanCollide = false;
                    v545.InnerPool.Color = Color3.new(0, 0, 0);

                    for _, child in v545:GetChildren() do
                        if child.Name == "ShardBeam" or child.Name == "ShardArea" then
                            child:Destroy();
                        end;
                    end;

                    GameManager:playTempSound(ReplicatedStorage.LocalSounds.ChakraPointDestroy:Clone(), v545.Main);
                    GameManager:generateDebris(v545.Main.Position, "FIXEDSETTINGS", "ChakraBlock", 2, 4);

                    if u32.CurrentChakraPoint == v545 and MainMenuFrame.Leave.ButtonHover.Visible == false then
                        DataEvent:FireServer("UpdateSettings", u11.ItemDisplayType, u11.GraphicsLevel, u11.FOV, u11.Footsteps, u11.InstantCast, u11.Tilt, u11.HighQRain, u11.VisibleCooldowns);
                        MainMenuFrame.Leave.ButtonHover.Visible = true;
                        u6.MainButtonClick:Play();
                        u32.ChangingPage = true;
                        u6.ChakraPointStand:Play();
                        u32.CurrentChakraPoint.Main.ChakraSmoke.Enabled = false;
                        MainMenuFrame:TweenPosition(UDim2.new(-0.4, 0, 0, 0), "Out", "Quad", 0.5, true);
                        Rest.TitleImage:TweenPosition(UDim2.new(0.1, 0, -0.2, 0), "Out", "Quad", 0.5, true);
                        ChangePage();

                        for i2 = -0.5, -1, -0.01 do
                            Rest.BackDrop.BackgroundTransparency = i2 * -1;
                            game.Lighting.PointBlur.Size = game.Lighting.PointBlur.Size - 0.5;
                            task.wait();
                        end;

                        Rest.BackDrop.BackgroundTransparency = 1;
                        game.Lighting.PointBlur:Destroy();
                        u32.Occupied = false;
                        u6.ChakraPointLoop:Stop();
                        Humanoid.AutoRotate = true;
                        u32.Occupied = false;
                        GameManager:stopAnimation("SittingCrossLegged", Humanoid);
                        Rest.Visible = false;

                        if u58.CinematicMode == "Off" then
                            Loadout.Visible = true;
                            Loadout.HUD.Visible = true;
                            Ryo.Visible = true;
                            Embers.Visible = u11.Embers > 0;
                        else
                            PlayerList.Visible = false;
                            Ryo.Visible = false;
                            Embers.Visible = false;
                        end;

                        HumanoidRootPart.Anchored = false;
                        u32.CurrentChakraPoint = nil;
                        MainMenuFrame.Leave.ButtonHover.Visible = false;
                        u32.CurrentPage = "";
                    end;

                    table.remove(u57, i);
                end;
            end;

            return;
        end;

        if p503 == "Observe" then
            if u504 and (u504.Character and u504.Character:FindFirstChild("Humanoid")) then
                local v546 = nil;
                local v547 = nil;
                local v548 = u504.Character:GetAttribute("Clothing");

                if GameManager.Clothing[v548] then
                    if GameManager.Clothing[v548].ObserveBlock then
                        v547 = true;
                    elseif GameManager.Clothing[v548].ObserveBlur then
                        v546 = true;
                    end;
                end;

                if u32.moderator == "Dev" or (u32.moderator == "SeniorMod" or (u32.moderator == "Mod" or (u32.moderator == "JMod" or u32.moderator == "Admin"))) then
                    v547 = false;
                    v546 = false;
                end;

                if v547 then
                    return;
                end;

                CurrentCamera.CameraSubject = u504.Character.Humanoid;
                observingCharacter = u504.Character;

                if v546 then
                    TweenService:Create(game.Lighting, TweenInfo.new(0, Enum.EasingStyle.Linear), {
                        FogStart = 0,
                        FogEnd = 40,
                        FogColor = Color3.fromRGB(0, 0, 0)
                    }):Play();
                    TweenService:Create(u60, TweenInfo.new(0), {
                        Transparency = 0,
                        Size = Vector3.new(150, 150, 150),
                        Color = Color3.fromRGB()
                    }):Play();

                    return;
                end;

                if game.Lighting.FogStart == 0 and game.Lighting.FogEnd == 40 then
                    updateLocation(u32.currentLocation, true);
                end;
            end;
        else
            if p503 == "FixCamera" then
                CurrentCamera.CameraSubject = Humanoid;
                observingCharacter = nil;
                updateLocation(u32.currentLocation);

                return;
            end;

            if p503 == "deleteTrinket" then
                deleteTrinket(u504);

                return;
            end;

            if p503 == "deleteFruit" then
                deleteFruit(u504);

                return;
            end;

            if p503 == "YouveBeenDropped" then
                u32.Last_Y = u9.Torso.Position.Y;
                print("v.Last_Y SET TO VIA DROP");

                return;
            end;

            if p503 == "AdjustZoomDistance" then
                TweenService:Create(LocalPlayer, TweenInfo.new(0.5), {
                    CameraMinZoomDistance = u504 or GameManager.Settings.DefaultMinZoom
                }):Play();
                TweenService:Create(LocalPlayer, TweenInfo.new(0.5), {
                    CameraMaxZoomDistance = u505 or GameManager.Settings.DefaultMaxZoom
                }):Play();

                return;
            end;

            if p503 == "ZoomDistance" then
                local v549 = u505 or 1;
                local v550 = p506 or 0.5;

                if u504 == "Reset" then
                    TweenService:Create(LocalPlayer, TweenInfo.new(v550), {
                        CameraMinZoomDistance = GameManager.Settings.DefaultMinZoom
                    }):Play();
                    TweenService:Create(LocalPlayer, TweenInfo.new(v550), {
                        CameraMaxZoomDistance = GameManager.Settings.DefaultMaxZoom
                    }):Play();

                    return;
                end;

                TweenService:Create(LocalPlayer, TweenInfo.new(v550), {
                    CameraMinZoomDistance = u504
                }):Play();
                TweenService:Create(LocalPlayer, TweenInfo.new(v550), {
                    CameraMaxZoomDistance = u504
                }):Play();

                if v549 and u505 then
                    wait(v550 + v549);
                    TweenService:Create(LocalPlayer, TweenInfo.new(v550), {
                        CameraMinZoomDistance = GameManager.Settings.DefaultMinZoom
                    }):Play();
                    TweenService:Create(LocalPlayer, TweenInfo.new(v550), {
                        CameraMaxZoomDistance = GameManager.Settings.DefaultMaxZoom
                    }):Play();
                end;
            else
                if p503 == "WoodenDragon" then
                    u504.Velocity = u504.Velocity or 70;
                    local v551 = GameManager:createBodyVelocity(HumanoidRootPart, CurrentCamera.CFrame.LookVector, u504.Velocity, 5, "WoodenDragonBV", Vector3.new(1, 1, 1), nil, nil, "Update");
                    game:GetService("RunService");
                    local CurrentCamera2 = workspace.CurrentCamera;
                    local v552 = LocalPlayer:GetMouse();
                    local v553 = tick();

                    while v551.Parent do
                        Humanoid.AutoRotate = false;
                        Humanoid.PlatformStand = true;
                        local v554 = tick();
                        local v555 = v554 - v553;
                        v553 = v554;
                        local Direction = CurrentCamera2:ScreenPointToRay(v552.X, v552.Y).Direction;
                        local v556 = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + Direction);
                        local Rotation = HumanoidRootPart.CFrame.Rotation;
                        local v557, v558 = Rotation:ToObjectSpace(v556.Rotation):ToAxisAngle();

                        if v558 > 0.0001 then
                            local v559 = math.min(v558, 3.141592653589793 * v555);
                            local v560 = Rotation * CFrame.fromAxisAngle(v557, v559);
                            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * v560;
                        end;

                        task.wait();
                    end;

                    Humanoid.AutoRotate = true;
                    Humanoid.PlatformStand = false;

                    return;
                end;

                if p503 == "StopWoodenDragon" and HumanoidRootPart:FindFirstChild("WoodenDragonBV") then
                    HumanoidRootPart.WoodenDragonBV:Destroy();

                    return;
                end;

                if p503 == "Lotus" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 15, 0.3, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "Asakujaku" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 15, 0.3, "AsakujakuBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "AsakujakuMovement" then
                    for _, descendant in u9:GetDescendants() do
                        if descendant:IsA("BodyVelocity") then
                            descendant:Destroy();
                        end;
                    end;

                    GameManager:createBodyVelocity(u504, HumanoidRootPart.CFrame.LookVector, 20, u505, "AsakujakuBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "Dynamic" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 82, 0.85, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "WillowDance" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, u504, u505, "CustomForceBV", Vector3.new(1000000, 0, 1000000), nil, nil, "Update", nil, true);

                    return;
                end;

                if p503 == "CrowIllusionBV" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, u504, u505, "CustomForceBV", Vector3.new(100000, 0, 100000), nil, nil, "Update", nil, true);

                    return;
                end;

                if p503 == "CrowIllusionMasteredBV" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, u504, u505, "CustomForceBV", Vector3.new(100000, 0, 100000), nil, nil, "Update", nil, true);

                    return;
                end;

                if p503 == "Zig Zag Pounce" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, u504, u505, "CustomForceBV", Vector3.new(100000, 0, 100000), nil, nil, "Update", nil, true);

                    return;
                end;

                if p503 == "ChargedRam" then
                    local v561 = GameManager:getHealthPercentage(Humanoid) < 25 and 45 or 60;
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, v561, 3, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "SpinningHumanBoulder" then
                    local v562 = GameManager:getHealthPercentage(Humanoid) < 25 and 60 or 70;
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, v562, 3.9, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "Lions" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 40, 0.7, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "Thrust" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 100, 0.43, "DynamicBV", Vector3.new(1, 0, 1), nil, nil, "Update", nil, true);

                    return;
                end;

                if p503 == "Cleave Rush" then
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, 80, 0.5, "CleaveRushBV", Vector3.new(1, 0, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "CleaveRushDestroy" then
                    for _, child in HumanoidRootPart:GetChildren() do
                        if child.Name == "CleaveRushBV" then
                            child:Destroy();
                        end;
                    end;

                    return;
                end;

                if p503 == "WingsFlight" then
                    print("WINGS FLIGHT");
                    print(u505);
                    local v563 = GameManager:getHealthPercentage(Humanoid) < 25 and 40 or 50;
                    GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, v563 + u505, 4 + u504, "DynamicBV", Vector3.new(1, 1, 1), nil, nil, "Update");

                    return;
                end;

                if p503 == "DestroyDynamic" and HumanoidRootPart:FindFirstChild("DynamicBV") then
                    HumanoidRootPart.DynamicBV:Destroy();

                    return;
                end;

                if p503 == "DestroyCustomForceBV" and HumanoidRootPart:FindFirstChild("CustomForceBV") then
                    HumanoidRootPart.CustomForceBV:Destroy();

                    return;
                end;

                if p503 == "DestroyBV" then
                    for _, child in HumanoidRootPart:GetChildren() do
                        if child.Name == "arg2" then
                            child:Destroy();
                        end;
                    end;

                    return;
                end;

                if p503 == "Shutting Down" then
                    return;
                end;

                if p503 == "ReturnToBloodlines" then
                    return;
                end;

                if p503 == "RemovePlayer" then
                    return;
                end;

                if p503 == "updateCookBook" then
                    updateCookbook();

                    return;
                end;

                if p503 == "GroundRocks" then
                    local v564 = Vector3.new(0, 0, 0);

                    while u504 and (u504.Parent and u504.Parent == workspace) do
                        local v565 = { u504, u9 };
                        local v566, v567 = GameManager:CastRay(u504.Position, u504.Position - (u504.CFrame * CFrame.new(0, 10, 0)).p, v565);

                        if v566 and (v567 and v567 ~= v564) then
                            v564 = v567;

                            if u504:FindFirstChild("Dust") then
                                u504.Dust.Particle.Enabled = true;
                                u504.Dust.Particle.Color = ColorSequence.new(v566.Color, v566.Color);
                            end;

                            local Part2 = Instance.new("Part");
                            Part2.Material = v566.Material;
                            Part2.Color = v566.Color;
                            Part2.Size = Vector3.new(5, 5, 5);
                            local v568 = CFrame.new(v567);
                            local Angles = CFrame.Angles;
                            local v569 = math.random(0, 180);
                            local v570 = math.rad(v569);
                            local v571 = math.random(0, 180);
                            local v572 = math.rad(v571);
                            local v573 = math.random(0, 180);
                            Part2.CFrame = v568 * Angles(v570, v572, (math.rad(v573)));
                            Part2.Anchored = true;
                            Part2.CanCollide = false;
                            Part2.Parent = workspace.Debris;
                            Debris:AddItem(Part2, 15);
                        elseif u504:FindFirstChild("Dust") then
                            u504.Dust.Particle.Enabled = false;
                        end;

                        wait(0.15);
                    end;
                else
                    if p503 == "Sealed" or (p503 == "FireSealed" or (p503 == "GreenFireSealed" or (p503 == "ChakraSealed" or p503 == "WoodSealed"))) then
                        if p503 == "Sealed" then
                            Chakra.Parent.Sealed.ImageColor3 = GameManager.UI.SealingColor;
                        elseif p503 == "FireSealed" then
                            Chakra.Parent.Sealed.ImageColor3 = GameManager.UI.FireSealingColor;
                        elseif p503 == "GreenFireSealed" then
                            Chakra.Parent.Sealed.ImageColor3 = GameManager.UI.GreenFireSealingColor;
                        elseif p503 == "WoodSealed" then
                            Chakra.Parent.Sealed.ImageColor3 = GameManager.UI.WoodSealingColor;
                        else
                            Chakra.Parent.Sealed.ImageColor3 = GameManager.UI.ChakraColor;
                        end;

                        for _ = 1, u504 do
                            TweenService:Create(Chakra.Parent.Sealed, TweenInfo.new(0.5), {
                                ImageTransparency = 0
                            }):Play();
                            task.wait(0.5);
                            TweenService:Create(Chakra.Parent.Sealed, TweenInfo.new(0.5), {
                                ImageTransparency = 1
                            }):Play();
                            task.wait(0.5);
                        end;

                        return;
                    end;

                    if p503 == "NowCarrying" then
                        if not u504 then
                            GameManager:getAnimation("Carrying", Humanoid):Play();
                        end;

                        u32.Carrying = true;

                        return;
                    end;

                    if p503 == "Jailed" then
                        u32.Broken = true;

                        if not u9:FindFirstChild("ragdolled") then
                            GameManager:getAnimation("Jailed", GameManager:getHumanoid(u9)):Play();
                        end;
                    else
                        if p503 == "OutOfJail" then
                            GameManager:stopAnimation("Jailed", GameManager:getHumanoid(u9));
                            u32.Broken = false;

                            return;
                        end;

                        if p503 == "ForcedAwaken" then
                            if not GameManager:hasAnAwakening(u11) then
                                Awakening.Visible = true;
                            end;

                            u11 = u505;
                            awakening(u504);

                            return;
                        end;

                        if p503 == "LineCreate" then
                            if p511 then
                                GameManager:smokeBlock(u505.p, p511, p512);
                            end;

                            GameManager:LineCreate(u504, u505, p506, p507, p508, p509, p510);

                            return;
                        end;

                        if p503 == "SmokeBlock" then
                            GameManager:smokeBlock(u504, u505, p506);

                            return;
                        end;

                        if p503 == "generateDebris" and u32.DebrisCooldown == false then
                            u32.DebrisCooldown = true;
                            local v574;

                            if u505 then
                                v574 = u505.Color;
                            else
                                v574 = nil;
                            end;

                            GameManager:smokeBlock(u504, "Big", v574);
                            GameManager:generateDebris(u504, u505, p506, p507, p508, p509, p510);
                            wait(0.4);
                            u32.DebrisCooldown = false;

                            return;
                        end;

                        if p503 == "chibakuTensei" then
                            require(ReplicatedStorage.Effects.ChibakuTensei.EffectsModule).StartVFX(u504, (u504.Position - HumanoidRootPart.Position).Magnitude, u505);

                            return;
                        end;

                        if p503 == "SelectWeapon" then
                            selectNewItem(u11, u11.CurrentWeapon);

                            return;
                        end;

                        if p503 == "WaterExplode" then
                            GameManager:WaterExplode(u504);

                            return;
                        end;

                        if p503 == "BloodExplode" then
                            GameManager:BloodExplode(u504);

                            return;
                        end;

                        if p503 == "LoveExplode" then
                            GameManager:LoveExplode(u504);

                            return;
                        end;

                        if p503 == "HealExplode" or p503 == "ShockwaveExplode" then
                            local v575 = ReplicatedStorage.Models.Shockwave:Clone();

                            if u505 then
                                v575.Color = u505;
                            end;

                            v575.Parent = workspace.Debris;
                            v575.CFrame = u504 * CFrame.new(0, -3, 0);
                            v575.Size = Vector3.new(0, 0, 0);
                            Debris:AddItem(v575, 1);
                            TweenService:Create(v575, TweenInfo.new(1), {
                                Transparency = 1,
                                Size = p506 or Vector3.new(30, 20, 30),
                                CFrame = v575.CFrame * CFrame.new(0, 6.5, 0) * CFrame.Angles(0, 3.141592653589793, 0)
                            }):Play();
                            u32.camIntensity = u32.camIntensity + (5 - (u504.Position - HumanoidRootPart.Position).magnitude / 100);
                            GameManager:smokeBlock(u504.Position, "Big", v575.Color);

                            return;
                        end;

                        if p503 == "Explosion" then
                            GameManager:Explosion(u504, u505, p506, Vector3.new(30, 30, 30));
                            GameManager:smokeBlock(u504.Position, "Big", Color3.fromRGB(30, 30, 30));

                            return;
                        end;

                        if p503 == "Dragon" then
                            if u504.Parent.Name == "WoodenDragonHead" then
                                local u576 = {};
                                local u577 = 0;

                                local function createSegment() -- Line: 9782
                                    -- upvalues: u577 (ref), ReplicatedStorage (ref), u576 (copy)
                                    u577 = u577 + 0.4;
                                    local v578 = ReplicatedStorage.Models.WoodenDragonSegment:Clone();
                                    v578.Parent = workspace.Debris;
                                    table.insert(u576, v578);

                                    return v578;
                                end;

                                local Position = u504.Position;

                                while u504 and (u504.Parent and (u504.Collision.Value == false and not u504:GetAttribute("Inactive"))) do
                                    if (u504.Position - Position).Magnitude >= 6 then
                                        u577 = u577 + 0.4;
                                        local v579 = ReplicatedStorage.Models.WoodenDragonSegment:Clone();
                                        v579.Parent = workspace.Debris;
                                        table.insert(u576, v579);
                                        v579:PivotTo(u504.CFrame - u504.CFrame.RightVector * 9);
                                        Position = u504.Position;
                                    end;

                                    task.wait();
                                end;

                                task.delay(9, function() -- Line: 9809
                                    -- upvalues: u576 (copy), TweenService (ref), u504 (copy)
                                    for _, v in u576 do
                                        local v580 = TweenService:Create(v.PrimaryPart, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
                                            Size = Vector3.new(0, v.PrimaryPart.Size.Y, v.PrimaryPart.Size.Z),
                                            CFrame = v:GetPivot() * CFrame.new(v.PrimaryPart.Size.X / 2, 0, 0)
                                        });
                                        v580:Play();
                                        v580.Completed:Wait();
                                        v:Destroy();
                                    end;

                                    if u504 and u504.Parent then
                                        u504.Parent:Destroy();
                                    end;
                                end);

                                return;
                            end;

                            if u504.Parent.Name == "IceDragonHead" then
                                local u581 = {};
                                local u582 = 0;

                                local function _() -- Line: 9833
                                    -- upvalues: u582 (ref), ReplicatedStorage (ref), u581 (copy)
                                    u582 = u582 + 0.4;
                                    local v583 = ReplicatedStorage.Models.IceDragonSegment:Clone();
                                    v583:SetAttribute("OriginalSize", v583.PrimaryPart.Size);
                                    v583.PrimaryPart.Size = Vector3.new(0, 0, 0);
                                    v583.Parent = workspace.Debris;
                                    table.insert(u581, v583);

                                    return v583;
                                end;

                                local Position = u504.Position;
                                local v584 = 1;

                                while u504 and (u504.Parent and (u504.Collision.Value == false and not u504:GetAttribute("Inactive"))) do
                                    if (u504.Position - Position).Magnitude >= 6 then
                                        u582 = u582 + 0.4;
                                        local v585 = ReplicatedStorage.Models.IceDragonSegment:Clone();
                                        v585:SetAttribute("OriginalSize", v585.PrimaryPart.Size);
                                        v585.PrimaryPart.Size = Vector3.new(0, 0, 0);
                                        v585.Parent = workspace.Debris;
                                        table.insert(u581, v585);
                                        local v586 = v585;
                                        v584 = v584 + 1;
                                        local v587 = u504:GetAttribute("DisableScaling") and 1 or v584 * 0.075 + 1;
                                        LocalTween:Tween(v586.PrimaryPart, { 0.1 }, {
                                            Size = v586:GetAttribute("OriginalSize") * v587
                                        });
                                        v586:PivotTo(u504.CFrame - u504.CFrame.RightVector * 9);
                                        Position = u504.Position;
                                    end;

                                    task.wait();
                                end;

                                task.delay(3, function() -- Line: 9879
                                    -- upvalues: u581 (copy), u504 (copy), GameManager (ref), ReplicatedStorage (ref), Emit (ref), Debris (ref)
                                    local v588 = {};

                                    for _, v in u581 do
                                        table.insert(v588, v);
                                    end;

                                    if u504.Parent then
                                        table.insert(v588, u504.Parent);
                                    end;

                                    for _, v in v588 do
                                        if v:IsA("Model") then
                                            for _, descendant in v:GetDescendants() do
                                                if descendant:IsA("BasePart") then
                                                    task.spawn(function() -- Line: 9899
                                                        -- upvalues: GameManager (ref), ReplicatedStorage (ref), descendant (copy), Emit (ref)
                                                        for i = 1, 18 do
                                                            if i == 18 then
                                                                GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceShatter:Clone(), descendant);
                                                            end;

                                                            local v589 = descendant;

                                                            if i == 1 then
                                                                v589:SetAttribute("originalPos", v589.Position);
                                                            end;

                                                            if i == 18 then
                                                                for _, descendant2 in v589:GetDescendants() do
                                                                    if descendant2:IsA("Texture") then
                                                                        descendant2:Destroy();
                                                                    elseif descendant2:IsA("ParticleEmitter") then
                                                                        descendant2.Enabled = false;
                                                                    elseif descendant2:IsA("BasePart") then
                                                                        descendant2.Transparency = 1;
                                                                    end;
                                                                end;

                                                                descendant.Transparency = 1;

                                                                if v589:FindFirstChild("IceDestroy") then
                                                                    Emit(v589.IceDestroy);
                                                                end;
                                                            elseif i / 2 == math.round(i / 2) then
                                                                local v590 = v589.Position.X + math.random(-1, 1) / 3;
                                                                local v591 = v589.Position.Y + math.random(-1, 1) / 3;
                                                                local v592 = v589.Position.Z + math.random(-1, 1) / 3;
                                                                v589.Position = Vector3.new(v590, v591, v592);
                                                            else
                                                                v589.Position = v589:GetAttribute("originalPos");
                                                            end;

                                                            task.wait(0.05);
                                                        end;
                                                    end);
                                                end;
                                            end;
                                        else
                                            task.spawn(function() -- Line: 9945
                                                -- upvalues: GameManager (ref), ReplicatedStorage (ref), v (copy), Emit (ref)
                                                for i = 1, 18 do
                                                    if i == 18 then
                                                        GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceShatter:Clone(), v);
                                                    end;

                                                    local v593 = v;

                                                    if i == 1 then
                                                        v593:SetAttribute("originalPos", v593.Position);
                                                    end;

                                                    if i == 18 then
                                                        for _, descendant in v593:GetDescendants() do
                                                            if descendant:IsA("Texture") then
                                                                descendant:Destroy();
                                                            elseif descendant:IsA("ParticleEmitter") then
                                                                descendant.Enabled = false;
                                                            elseif descendant:IsA("BasePart") then
                                                                descendant.Transparency = 1;
                                                            end;
                                                        end;

                                                        v.Transparency = 1;

                                                        if v593:FindFirstChild("IceDestroy") then
                                                            Emit(v593.IceDestroy);
                                                        end;
                                                    elseif i / 2 == math.round(i / 2) then
                                                        local v594 = v593.Position.X + math.random(-1, 1) / 3;
                                                        local v595 = v593.Position.Y + math.random(-1, 1) / 3;
                                                        local v596 = v593.Position.Z + math.random(-1, 1) / 3;
                                                        v593.Position = Vector3.new(v594, v595, v596);
                                                    else
                                                        v593.Position = v593:GetAttribute("originalPos");
                                                    end;

                                                    task.wait(0.05);
                                                end;
                                            end);
                                        end;

                                        Debris:AddItem(v, 5);
                                    end;
                                end);

                                return;
                            end;

                            while u504 and (u504.Parent and u504.Collision.Value == false) do
                                local Part2 = Instance.new("Part");
                                Part2.Shape = Enum.PartType.Cylinder;
                                Part2.CFrame = u504.CFrame - u504.CFrame.RightVector * 3;
                                Part2.Anchored = true;
                                Part2.Color = u504.Color;
                                Part2.Material = u504.Material;
                                Part2.Transparency = u504.Transparency;
                                Part2.Parent = u504;
                                Part2.Size = Vector3.new(12, 4, 4);
                                Part2.CanTouch = false;
                                Part2.CanCollide = false;
                                Part2.CastShadow = false;
                                TweenService:Create(Part2, TweenInfo.new(1), {
                                    Size = Vector3.new(12, 0, 0)
                                }):Play();
                                Debris:AddItem(Part2, 1);
                                task.wait(0.06);
                            end;
                        else
                            if p503 == "TriggerEvent" then
                                if u504 == "The Deprived Damsel" then
                                    local v597 = workspace["The Deprived Damsel"];
                                    GameManager:getAnimation("DeprivedDamsel", (v597:WaitForChild("Humanoid"))):Play();
                                    Debris:AddItem(v597, 8);
                                    TweenService:Create(workspace.DeprivedDamselLines, TweenInfo.new(10), {
                                        Transparency = 0.2
                                    }):Play();
                                    wait(6);

                                    for _, child in ipairs(v597:GetChildren()) do
                                        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                            TweenService:Create(child, TweenInfo.new(2), {
                                                Transparency = 0.8
                                            }):Play();

                                            for _, child2 in ipairs(child:GetChildren()) do
                                                if child2.ClassName == "Decal" then
                                                    TweenService:Create(child2, TweenInfo.new(2), {
                                                        Transparency = 0.8
                                                    }):Play();
                                                end;
                                            end;
                                        end;
                                    end;

                                    return;
                                end;

                                if u504 == "Reaver\'s Revenge" then
                                    local v598 = workspace["The Reanimated Reaver"];
                                    GameManager:getAnimation("StunnedKneeling", (v598:WaitForChild("Humanoid"))):Play();
                                    GameManager:playTempSound(ReplicatedStorage.LocalSounds.Wiped:Clone(), LocalPlayer.Character.HumanoidRootPart);
                                    GameManager:wipedEffect(v598, true);
                                    TweenService:Create(v598.FakeHead.Pupil1, TweenInfo.new(3), {
                                        Color3 = Color3.new(0, 0, 0)
                                    }):Play();
                                    TweenService:Create(v598.FakeHead.Eyes1, TweenInfo.new(3), {
                                        Color3 = Color3.new(0, 0, 0)
                                    }):Play();
                                    TweenService:Create(v598.FakeHead.Mouth4, TweenInfo.new(3), {
                                        Color3 = Color3.new(0, 0, 0)
                                    }):Play();

                                    return;
                                end;

                                if u504 == "Parkour Sealing" then
                                    local v599 = workspace["Training Instructor"];
                                    GameManager:getAnimation("StunnedKneeling", (v599:WaitForChild("Humanoid"))):Play();
                                    GameManager:sealingStun(v599.HumanoidRootPart);

                                    return;
                                end;

                                if u504 ~= "The Scarlet Slowcoach" then
                                    GameManager:StartEvent(u504);

                                    return;
                                end;

                                local v600;

                                if workspace:FindFirstChild("The Scarlet Slowcoach") then
                                    v600 = workspace["The Scarlet Slowcoach"].HumanoidRootPart.CFrame;
                                    workspace["The Scarlet Slowcoach"]:Destroy();
                                else
                                    v600 = nil;
                                end;

                                local u601 = ReplicatedStorage.Models["The Scarlet Slowcoach"]:Clone();
                                local Humanoid2 = u601:WaitForChild("Humanoid");
                                u601.Parent = workspace;
                                u601.HumanoidRootPart.CFrame = v600;
                                local u602 = GameManager:getAnimation("Run", Humanoid2);
                                u602:Play();
                                local u603 = game:GetService("PathfindingService"):CreatePath();
                                local u604 = nil;
                                local u605 = nil;
                                local u606 = nil;
                                local u607 = nil;

                                local function followPath(u608) -- Line: 10143
                                    -- upvalues: u603 (copy), u601 (copy), u604 (ref), u607 (ref), u605 (ref), followPath (copy), u606 (ref), Humanoid2 (copy), u602 (copy), Debris (ref), GameManager (ref)
                                    local success2, result2 = pcall(function() -- Line: 10145
                                        -- upvalues: u603 (ref), u601 (ref), u608 (copy)
                                        u603:ComputeAsync(u601.PrimaryPart.Position, u608);
                                    end);

                                    if not success2 or u603.Status ~= Enum.PathStatus.Success then
                                        warn("Path not computed!", result2);

                                        return;
                                    end;

                                    u604 = u603:GetWaypoints();
                                    u607 = u603.Blocked:Connect(function(p609) -- Line: 10154
                                        -- upvalues: u605 (ref), u607 (ref), followPath (ref), u608 (copy)
                                        if u605 <= p609 then
                                            u607:Disconnect();
                                            followPath(u608);
                                        end;
                                    end);

                                    if not u606 then
                                        u606 = Humanoid2.MoveToFinished:Connect(function(p610) -- Line: 10166
                                            -- upvalues: u605 (ref), u604 (ref), Humanoid2 (ref), u602 (ref), Debris (ref), u601 (ref), GameManager (ref), u606 (ref), u607 (ref)
                                            if p610 and u605 < #u604 then
                                                u605 = u605 + 1;
                                                Humanoid2:MoveTo(u604[u605].Position);

                                                return;
                                            end;

                                            u602:Stop();
                                            Debris:AddItem(u601, 1);
                                            GameManager:teleportBubble(u601);
                                            u606:Disconnect();
                                            u607:Disconnect();
                                        end);
                                    end;

                                    u605 = 2;
                                    Humanoid2:MoveTo(u604[u605].Position);
                                end;

                                followPath(workspace.ScarletSlowcoachEnd.Position);

                                return;
                            end;

                            if p503 == "bloodlineTransformation" then
                                local v611 = u505 + 0.25 + 0.5;
                                local v612 = Color3.fromRGB(102, 24, 165);
                                local v613 = Color3.fromRGB(255, 255, 255);

                                if p506 == "Yuki" then
                                    v612 = Color3.fromRGB(21, 141, 165);
                                end;

                                local v614 = ReplicatedStorage.Models.Oval:Clone();
                                v614.Color = v612;
                                v614.Parent = workspace.Debris;
                                v614.Position = u504;
                                v614.Size = Vector3.new(0.01, 0.01, 0.01);
                                Debris:AddItem(v614, v611);
                                TweenService:Create(v614, TweenInfo.new(0.25), {
                                    Size = Vector3.new(6, 8, 6)
                                }):Play();
                                wait(0.25);
                                TweenService:Create(v614, TweenInfo.new(v611), {
                                    Color = v613
                                }):Play();

                                for _ = 1, 15 do
                                    local v615 = ReplicatedStorage.Models.ShockRing:Clone();
                                    v615.Color = v614.Color;
                                    v615.Transparency = 0;
                                    v615.Parent = workspace.Debris;
                                    v615.Size = Vector3.new(0.05, 0.05, 0.05);
                                    v615.CFrame = CFrame.new(u504 + Vector3.new(0, -2.5, 0));
                                    TweenService:Create(v615, TweenInfo.new(0.4), {
                                        Size = Vector3.new(32, 1, 32),
                                        Transparency = 1
                                    }):Play();
                                    Debris:AddItem(v615, 0.2);
                                    wait(0.2);
                                end;

                                TweenService:Create(v614, TweenInfo.new(0.25), {
                                    Transparency = 1
                                }):Play();

                                return;
                            end;

                            if p503 == "ShockRing" then
                                local v616;

                                if u505 and u505.Size then
                                    if u505.Size.X < 45 then
                                        v616 = ReplicatedStorage.Particles.smallSlam:Clone();
                                    elseif u505.Size.X < 65 then
                                        v616 = ReplicatedStorage.Particles.mediumSlam:Clone();
                                    elseif u505.Size.X < 90 then
                                        v616 = ReplicatedStorage.Particles.largeSlam:Clone();
                                    else
                                        v616 = ReplicatedStorage.Particles.giantSlam:Clone();
                                    end;
                                else
                                    v616 = nil;
                                end;

                                if p509 then
                                    for _, descendant in ipairs(v616:GetDescendants()) do
                                        if descendant:IsA("ParticleEmitter") and (descendant.Name ~= "Black" and descendant.LightEmission ~= 0) then
                                            descendant.Color = ColorSequence.new(p509, p509);
                                        end;
                                    end;
                                end;

                                v616.CFrame = u504;
                                v616.Parent = workspace.Debris;
                                Emit(v616);
                                Debris:AddItem(v616, 3);

                                for _ = 1, p506 or 16 do
                                    local v617 = ReplicatedStorage.Models.ShockRing:Clone();
                                    v617.Color = p509 or Color3.fromRGB(73, 100, 255);
                                    v617.Parent = workspace.Debris;
                                    v617.Size = Vector3.new(0.05, 0.05, 0.05);
                                    v617.CFrame = u504;
                                    TweenService:Create(v617, TweenInfo.new(p507 or 0.5), u505):Play();

                                    if p510 and p510 == "YellowSasuke" then
                                        ReplicatedStorage.Particles.HO2Lightning1:Clone().Parent = v617;
                                        ReplicatedStorage.Particles.HO2Lightning2:Clone().Parent = v617;
                                    elseif p510 and p510 == "XmasSasuke" then
                                        ReplicatedStorage.Particles.XmasHO2Lightning1:Clone().Parent = v617;
                                        ReplicatedStorage.Particles.XmasHO2Lightning2:Clone().Parent = v617;
                                    end;

                                    Debris:AddItem(v617, p507 or 0.5);
                                    wait(p508 or 0.5);
                                end;

                                return;
                            end;

                            if p503 == "festiveEffects" then
                                local v618 = ReplicatedStorage.Effects.festiveEffects:Clone();
                                v618.Parent = workspace.Debris;
                                v618.Position = u504;
                                task.delay(0.4, function() -- Line: 10286
                                    -- upvalues: GameManager (ref), u9 (ref)
                                    GameManager:CameraShake(u9, 6, 0.5);
                                end);
                                Debris:AddItem(v618, 4);
                                Emit(v618);

                                return;
                            end;

                            if p503 == "replicateAlmightyPush" then
                                local v619 = ReplicatedStorage.Models.AlmightyPush:Clone();
                                v619.Parent = workspace.Debris;
                                v619.CFrame = u504;
                                Debris:AddItem(v619, 4);

                                if u11.GraphicsLevel == "High" then
                                    for _, descendant in ipairs(v619:GetDescendants()) do
                                        if descendant.ClassName == "ParticleEmitter" then
                                            descendant:Emit(descendant:GetAttribute("EmitCount"));
                                        end;
                                    end;

                                    return;
                                end;

                                for _, descendant in ipairs(v619:GetDescendants()) do
                                    if descendant.ClassName == "ParticleEmitter" then
                                        local v620 = descendant:GetAttribute("EmitCount") / 2;
                                        descendant:Emit(math.round(v620) + 1);
                                    end;
                                end;

                                return;
                            end;

                            if p503 == "replicateLoveAlmightyPush" then
                                local v621 = ReplicatedStorage.Models.LoveAlmightyPush:Clone();
                                v621.Parent = workspace.Debris;
                                v621.CFrame = u504;
                                Debris:AddItem(v621, 4);

                                if u11.GraphicsLevel == "High" then
                                    for _, descendant in ipairs(v621:GetDescendants()) do
                                        if descendant.ClassName == "ParticleEmitter" then
                                            descendant:Emit(descendant:GetAttribute("EmitCount"));
                                        end;
                                    end;

                                    return;
                                end;

                                for _, descendant in ipairs(v621:GetDescendants()) do
                                    if descendant.ClassName == "ParticleEmitter" then
                                        local v622 = descendant:GetAttribute("EmitCount") / 2;
                                        descendant:Emit(math.round(v622) + 1);
                                    end;
                                end;

                                return;
                            end;

                            if p503 == "replicateSharks" then
                                local function moveShark(u623) -- Line: 10348
                                    -- upvalues: u504 (copy), u505 (copy), moveShark (copy)
                                    u623:PivotTo(CFrame.lookAt(u623:GetPivot().Position, u504));
                                    local v624 = {};
                                    local v625 = u623:GetPivot();
                                    local Angles = CFrame.Angles;
                                    local v626 = math.random(-40, 40);
                                    local v627 = math.rad(v626);
                                    local v628 = math.random(-40, 40);
                                    local v629 = math.rad(v628);
                                    local v630 = math.random(-40, 40);
                                    v624.CFrame = v625 * Angles(v627, v629, (math.rad(v630))) * CFrame.new(0, 0, -u505);
                                    local v631 = game:GetService("TweenService"):Create(u623.PrimaryPart, TweenInfo.new(math.random(40, 50) / 100, Enum.EasingStyle.Linear), v624);
                                    v631:Play();
                                    v631.Completed:Once(function() -- Line: 10362
                                        -- upvalues: u623 (copy), moveShark (ref)
                                        if not u623.Parent then
                                            return;
                                        end;

                                        moveShark(u623);
                                    end);
                                end;

                                local function getRandomPointOnSphere(p632, p633) -- Line: 10331
                                    local v634 = math.random();
                                    local v635 = math.random();
                                    local v636 = 6.283185307179586 * v634;
                                    local v637 = math.acos(2 * v635 - 1);
                                    local v638 = p633 * math.sin(v637) * math.cos(v636);
                                    local v639 = p633 * math.sin(v637) * math.sin(v636);
                                    local v640 = p633 * math.cos(v637);

                                    return p632 + Vector3.new(v638, v639, v640);
                                end;

                                for _ = 1, 8 do
                                    local v641 = getRandomPointOnSphere(u504, u505);
                                    local u642 = game.ReplicatedStorage.Models.SharkBoi:Clone();
                                    u642:PivotTo(CFrame.lookAt(v641, u504));
                                    u642.Parent = workspace.Debris;
                                    task.delay(GameManager.Skills["Water Region"].maxRepeats * GameManager.Skills["Water Region"].repeatWaitTime, function() -- Line: 10374
                                        -- upvalues: u642 (copy)
                                        u642.PrimaryPart.ConsumableTrail.Enabled = false;
                                        local v643 = game:GetService("TweenService"):Create(u642.PrimaryPart, TweenInfo.new(1), {
                                            Transparency = 1
                                        });
                                        v643:Play();
                                        v643.Completed:Once(function() -- Line: 10382
                                            -- upvalues: u642 (ref)
                                            u642:Destroy();
                                        end);
                                    end);
                                    moveShark(u642);
                                end;

                                return;
                            end;

                            if p503 == "replicateRings" then
                                for _ = 1, 10 do
                                    if u504 then
                                        local v644 = ReplicatedStorage.Models.SpinCircle:Clone();
                                        v644.Parent = workspace.Debris;
                                        v644.CFrame = u504.CFrame * CFrame.new(0, 0, -5) * CFrame.Angles(1.5707963267948966, 0, 0);

                                        if u504.Name == "GalePalm" then
                                            v644.Color = u504.Emitter.Wind.Color;
                                        end;

                                        TweenService:Create(v644, TweenInfo.new(1), {
                                            Transparency = 1,
                                            Size = Vector3.new(25, 1, 25)
                                        }):Play();
                                        Debris:AddItem(v644, 1);
                                        wait(0.5);
                                    end;
                                end;

                                return;
                            end;

                            if p503 == "replicateRisingWind" then
                                for i = 1, u504.maxRepeats do
                                    local v645 = ReplicatedStorage.Models.LongTrailBlock:Clone();
                                    v645.CFrame = u505.CFrame * CFrame.new(0, i * 5 - 5, 0);
                                    v645.Parent = workspace.Debris;
                                    v645.Trail1.Enabled = true;
                                    v645.Trail1A.Enabled = true;
                                    local v646;

                                    if p506 then
                                        v645.Attachment0.Position = Vector3.new(-0.6, 0, 15);
                                        v645.Attachment0A.Position = Vector3.new(-0.6, 0, -15);
                                        v645.Attachment1.Position = Vector3.new(0.6, 0, 15);
                                        v645.Attachment1A.Position = Vector3.new(0.6, 0, -15);
                                        v646 = 5;
                                    else
                                        v646 = 0;
                                    end;

                                    local v647 = TweenService:Create(v645, TweenInfo.new(0.65, Enum.EasingStyle.Linear), {
                                        CFrame = v645.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(0, 3.141592653589793, 0)
                                    });
                                    local u648 = TweenService:Create(v645, TweenInfo.new(0.65, Enum.EasingStyle.Linear), {
                                        CFrame = v645.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, 6.283185307179586, 0)
                                    });
                                    v647:Play();
                                    v647.Completed:Connect(function() -- Line: 10430
                                        -- upvalues: u648 (copy)
                                        u648:Play();
                                    end);
                                    Debris:AddItem(v645, 4);

                                    for _ = 1, 10 do
                                        local v649 = ReplicatedStorage.Models.WindBlock:Clone();
                                        v649.CFrame = u505.CFrame * CFrame.new(math.random(-9 - v646, 9 + v646), math.random(2, 8), math.random(-9 - v646, 9 + v646)) * CFrame.Angles(0, 0, 1.5707963267948966);
                                        v649.Parent = workspace.Debris;
                                        GameManager:TweenObject(v649, {
                                            Transparency = 1,
                                            CFrame = v649.CFrame * CFrame.new(math.random(9 + v646, 18 + v646), 0, 0)
                                        }, 1);
                                        Debris:AddItem(v649, 1);
                                    end;

                                    local v650 = ReplicatedStorage.Models.ShockRing:Clone();
                                    v650.Parent = workspace.Debris;
                                    v650.Size = Vector3.new(0.05, 0.05, 0.05);
                                    v650.CFrame = u505.CFrame;
                                    local v651 = v650.CFrame * CFrame.new(0, 1, 0) * CFrame.Angles(0, 3.141592653589793, 0);

                                    if p506 then
                                        GameManager:TweenObject(v650, {
                                            Size = Vector3.new(34, 3, 34),
                                            Transparency = 1,
                                            CFrame = v651
                                        }, 1, nil, 0.8);
                                    else
                                        GameManager:TweenObject(v650, {
                                            Size = Vector3.new(25, 2, 25),
                                            Transparency = 1,
                                            CFrame = v651
                                        }, 1, nil, 0.8);
                                    end;

                                    Debris:AddItem(v650, 1);
                                    wait(u504.repeatWaitTime);
                                end;

                                return;
                            end;

                            if p503 == "replicateVerticalSlash" then
                                local v652 = ReplicatedStorage.Models.ShockRing:Clone();
                                v652.Parent = workspace.Debris;
                                v652.Size = Vector3.new(0.05, 0.05, 0.05);
                                v652.CFrame = u504;
                                local v653 = v652.CFrame * CFrame.new(0, 1, 0) * CFrame.Angles(0, 3.141592653589793, 0);

                                if u505 then
                                    v652.Color = u505;
                                end;

                                GameManager:TweenObject(v652, {
                                    Size = Vector3.new(20, 2, 20),
                                    Transparency = 1,
                                    CFrame = v653
                                }, 1, nil, 0.8);
                                Debris:AddItem(v652, 1);
                                local u654 = ReplicatedStorage.Models.GroundVertical:Clone();
                                u654.Parent = workspace.Debris;
                                u654.CFrame = u504;
                                Debris:AddItem(u654, 2);
                                u654.ThrustAttach1.RecolorWhirl.Color = ColorSequence.new(u505, u505);
                                u654.ThrustAttach2.Aura.Color = ColorSequence.new(u505, u505);
                                u654.ThrustAttach2.Recolor.Color = ColorSequence.new(u505, u505);
                                delay(0.6, function() -- Line: 10485
                                    -- upvalues: u654 (copy)
                                    if u654 then
                                        u654.ThrustAttach1.RecolorWhirl.Enabled = false;
                                        u654.ThrustAttach2.Aura.Enabled = false;
                                        u654.ThrustAttach2.Recolor.Enabled = false;
                                    end;
                                end);

                                return;
                            end;

                            if p503 == "replicateSpin" then
                                local v655;

                                if u504 and (u504.Parent and (u504.Parent:FindFirstChild("Settings") and u504.Parent.Settings:FindFirstChild("CurrentSkill"))) then
                                    v655 = u504.Parent.Settings:FindFirstChild("CurrentSkill");
                                else
                                    v655 = nil;
                                end;

                                for _ = 0.5, 3, 0.25 do
                                    if u504 and (GameManager:getSettings(u504.Parent) and (GameManager:getSettings(u504.Parent).Stunned.Value == false and (v655 and v655.Value == "Overhead Spin"))) then
                                        local v656 = ReplicatedStorage.Models.ThinRing:Clone();
                                        v656.Parent = workspace.Debris;
                                        v656.Size = Vector3.new(12, 0.2, 12);
                                        v656.CFrame = u504.CFrame * CFrame.new(0, 3, 0);

                                        if u505 then
                                            v656.Color = u505;
                                        end;

                                        Debris:AddItem(v656, 0.7);
                                        TweenService:Create(v656, TweenInfo.new(0.7), {
                                            Transparency = 1,
                                            Size = Vector3.new(23, 0.2, 23)
                                        }):Play();
                                    end;

                                    wait(0.23);
                                end;

                                return;
                            end;

                            if p503 == "replicateKamuiSuck" or p503 == "replicateKamuiWarp" then
                                for _ = 30, 1, -1 do
                                    if u504 then
                                        local v657 = ReplicatedStorage.Models.WindBlock:Clone();
                                        local p = (u504.CFrame * u505).p;
                                        local v658 = math.random(-20, 20);
                                        local v659 = math.random(-20, 20);
                                        v657.Position = p + Vector3.new(v658, v659, math.random(-20, 20));
                                        v657.Parent = workspace.Debris;
                                        v657.Size = Vector3.new(6, 0.25, 0.25);
                                        v657.CFrame = CFrame.lookAt(v657.Position, u504.Position) * CFrame.Angles(0, 1.5707963267948966, 0);
                                        v657.Color = Color3.new(0, 0, 0);
                                        TweenService:Create(v657, TweenInfo.new(0.5), {
                                            Size = Vector3.new(0, 0, 0),
                                            Transparency = 0.5,
                                            Position = u504.Position
                                        }):Play();
                                        Debris:AddItem(v657, 1);
                                    end;

                                    if p503 == "replicateKamuiSuck" then
                                        wait(0.07);
                                    else
                                        wait(0.2);
                                    end;
                                end;

                                return;
                            end;

                            if p503 == "FirstAwakening" then
                                Awakening.Visible = true;

                                return;
                            end;

                            if p503 == "EnableGUI" then
                                u504.Enabled = true;

                                return;
                            end;

                            if p503 == "EnableAllGuis" then
                                for _, child in ipairs(game.Players:GetChildren()) do
                                    if child.Character and child.Character:FindFirstChild("FakeHead") then
                                        for i = 1, #u504 do
                                            if child.Character.FakeHead:FindFirstChild(u504[i]) then
                                                if u32.Settings.Awakened.Value == "Byakugan [Stage 4]" and u504[i].Name == "healthGUI" then
                                                    u504[i].AlwaysOnTop = true;
                                                    u504[i].MaxDistance = 400;
                                                end;

                                                child.Character.FakeHead[u504[i]].Enabled = true;
                                            end;
                                        end;
                                    end;
                                end;

                                return;
                            end;

                            if p503 == "DisableAllGuis" then
                                GameManager:DisableAllGuis(u9, u504);

                                return;
                            end;

                            if p503 == "StopRun" then
                                if u32.Running == true then
                                    disableRun();
                                end;
                            elseif p503 == "EndActionAnim" then
                                if u31 then
                                    pcall(function() -- Line: 10583
                                        -- upvalues: u31 (ref)
                                        task.cancel(u31);
                                    end);
                                end;

                                local v660 = GameManager.Skills[u32.skillInUse] or GameManager.Skills[u32.Settings.CurrentSkill.Value];

                                if v660 and v660.Anchored then
                                    HumanoidRootPart.Anchored = false;
                                end;

                                local skillInUse = u32.skillInUse;
                                u32.Occupied = false;
                                u32.skillInUse = "";

                                if u32.Settings.CurrentSkill.Value == "Intangibility" and GUI:FindFirstChild("BasicOverlay") then
                                    TweenService:Create(GUI.BasicOverlay, TweenInfo.new(0.25), {
                                        ImageTransparency = 1
                                    }):Play();
                                elseif u32.Settings.CurrentSkill.Value == "Butterfly Flight" then
                                    u32.CharFacing = false;
                                end;

                                u32.Casting = false;

                                if u32.ActionAnim then
                                    if not u504 or u504 and skillInUse == u504 then
                                        u32.ActionAnim:Stop();
                                        u32.ActionAnim = nil;

                                        if v660 and v660.Anchored then
                                            HumanoidRootPart.Anchored = false;
                                        end;

                                        u32.jumpBlocked = false;
                                        u32.OriginSpeed = getOriginSpeed();
                                        local v661 = u32;
                                        v661.OriginSpeed = v661.OriginSpeed * (u9:GetAttribute("CombatFluidity") and 1.2 or 1);

                                        if u32.Running then
                                            setRunSpeed();
                                        elseif u32.Settings.Stunned.Value == false then
                                            Humanoid.WalkSpeed = u32.OriginSpeed;
                                        else
                                            print("humanoid waalkspeed has not been set in endactionanim, show to arkham if bug with not being able to move happens");
                                        end;

                                        Humanoid.JumpPower = u32.OriginJump;
                                        u32.CanSkillRun = false;
                                    end;

                                    if u32.ActionAnim and (u32.ActionAnim.Name == "SkillHold" or (u32.ActionAnim.Name == "ArmRunningForward" or (u32.ActionAnim.Name == "DoubleSkillHold" or u32.ActionAnim.Name == "DoubleArmsRunningForward"))) then
                                        GameManager:stopAnimation("SkillHold", Humanoid);
                                        GameManager:stopAnimation("ArmRunningForward", Humanoid);
                                        GameManager:stopAnimation("DoubleSkillHold", Humanoid);
                                        GameManager:stopAnimation("DoubleArmsRunningForward", Humanoid);
                                    end;
                                end;
                            else
                                if p503 == "UnblockJump" then
                                    u32.jumpBlocked = false;

                                    return;
                                end;

                                if p503 == "ClanInvitation" then
                                    Mainframe.ClanInvitation.Visible = true;
                                    Mainframe.ClanInvitation.ClanName.Text = u504;
                                    Mainframe.ClanInvitation.ClanImage.Image = u505;

                                    return;
                                end;

                                if p503 == "Stun" then
                                    u32.Occupied = true;
                                    u32.Dashing = false;

                                    if u32.Settings.Stunned.Value == true then
                                        local _ = u32.Settings.StunID.Value;
                                        local Value = u32.Settings.StunID.Value;
                                        delay(u504, function() -- Line: 10651
                                            -- upvalues: u32 (ref), Value (copy)
                                            if u32.Settings.Stunned.Value == true and u32.Settings.StunID.Value == Value then
                                                u32.Occupied = false;
                                            end;
                                        end);
                                    end;

                                    if u505 then
                                        disableRun("Stop");
                                    else
                                        disableRun("StopStun");
                                    end;

                                    if u32.Settings.Blocking.Value == true then
                                        GameManager:stopAnimation("Block", Humanoid, u32.CombatTable.Block);
                                    end;
                                else
                                    if p503 == "EndStun" then
                                        u32.Occupied = false;
                                        Humanoid.WalkSpeed = u32.OriginSpeed;
                                        Humanoid.JumpPower = u32.OriginJump;

                                        return;
                                    end;

                                    if p503 == "ResetWalkSpeed" then
                                        Humanoid.WalkSpeed = u32.OriginSpeed;

                                        return;
                                    end;

                                    if p503 == "ResetJumpPower" then
                                        Humanoid.JumpPower = u32.OriginJump;

                                        return;
                                    end;

                                    if p503 == "DeAwakening" then
                                        if not u504:find("Sharingan") and u504:find("Byakugan") then
                                            TweenService:Create(LocalPlayer, TweenInfo.new(0.5), {
                                                CameraMaxZoomDistance = GameManager.Settings.DefaultMaxZoom
                                            }):Play();
                                        end;

                                        if skillsModule[u504].SpeedIncrease then
                                            u32.awakeningSpeed = 0;

                                            if u32.Running then
                                                setRunSpeed();

                                                return;
                                            end;

                                            if u32.Settings.Stunned.Value == false then
                                                Humanoid.WalkSpeed = u32.OriginSpeed;
                                            end;
                                        end;
                                    else
                                        if p503 == "UpdateBlindness" then
                                            if script.Parent:FindFirstChild("Blindness1") then
                                                TweenService:Create(script.Parent.Blindness1, TweenInfo.new(0.5), {
                                                    ImageTransparency = 1 - u504 / 100
                                                }):Play();
                                                TweenService:Create(script.Parent.Blindness2, TweenInfo.new(0.5), {
                                                    ImageTransparency = 1 - u504 / 100
                                                }):Play();

                                                return;
                                            end;

                                            local v662 = ReplicatedStorage.UI.BasicOverlay:Clone();
                                            v662.ImageTransparency = 1 - u504 / 100;
                                            v662.ImageColor3 = Color3.new(0, 0, 0);
                                            v662.Parent = script.Parent;
                                            v662.Name = "Blindness1";
                                            local v663 = ReplicatedStorage.UI.FullOverlay:Clone();
                                            v663.ImageTransparency = 1 - u504 / 100;
                                            v663.Parent = script.Parent;
                                            v663.Name = "Blindness2";

                                            return;
                                        end;

                                        if p503 == "VisualEffect" then
                                            print("TRIGGERED VISUALS");

                                            if u504 == "Sharingan" or (u504 == "Byakugan" or (u504 == "Rinnegan" or u504 == "Ketsuryugan")) then
                                                GameManager:TweenObject(workspace.CurrentCamera, {
                                                    FieldOfView = 85
                                                }, 0.8);

                                                if u504 == "Sharingan" then
                                                    GameManager:awakeningEffects("Sharingan", u505, u11);

                                                    return;
                                                end;

                                                if u504 == "Byakugan" then
                                                    GameManager:awakeningEffects("Byakugan", u505, u11);

                                                    return;
                                                end;

                                                if u504 == "Rinnegan" then
                                                    GameManager:awakeningEffects("Rinnegan", u505, u11);

                                                    return;
                                                end;

                                                if u504 == "Ketsuryugan" then
                                                    GameManager:awakeningEffects("Ketsuryugan", u505, u11);
                                                end;
                                            elseif u504 == "MangekyoAwakening" or u504 == "Rinnegan" then
                                                GameManager:TweenObject(workspace.CurrentCamera, {
                                                    FieldOfView = 90
                                                }, 3);
                                                GameManager:awakeningEffects(u504);
                                                GameManager:getAnimation("StunnedKneeling", Humanoid):Play();
                                                delay(5, function() -- Line: 10721
                                                    -- upvalues: GameManager (ref), Humanoid (ref)
                                                    GameManager:stopAnimation("StunnedKneeling", Humanoid);
                                                end);
                                            end;
                                        else
                                            if p503 == "Blinded" or p503 == "WeakBlinded" then
                                                local v664 = ReplicatedStorage.UI.FullOverlay:Clone();
                                                v664.ImageColor3 = Color3.fromRGB(0, 0, 0);
                                                v664.ImageTransparency = 1;
                                                v664.Parent = script.Parent;
                                                local v665 = p503 == "WeakBlinded" and 3 or 1;
                                                local BlurEffect = Instance.new("BlurEffect");
                                                BlurEffect.Size = 0;
                                                BlurEffect.Parent = game.Lighting;
                                                TweenService:Create(v664, TweenInfo.new(0.25), {
                                                    ImageTransparency = 0
                                                }):Play();
                                                TweenService:Create(BlurEffect, TweenInfo.new(0.25), {
                                                    Size = 50
                                                }):Play();
                                                wait(0.5);
                                                local v666 = ReplicatedStorage.UI.BasicOverlay:Clone();
                                                v666.ImageColor3 = Color3.fromRGB(0, 0, 0);
                                                v666.Parent = script.Parent;
                                                TweenService:Create(v664, TweenInfo.new(5 / v665), {
                                                    ImageTransparency = 1
                                                }):Play();
                                                TweenService:Create(v666, TweenInfo.new(9 / v665), {
                                                    ImageTransparency = 1
                                                }):Play();
                                                TweenService:Create(BlurEffect, TweenInfo.new(11 / v665), {
                                                    Size = 0
                                                }):Play();

                                                return;
                                            end;

                                            if p503 == "VisualAilment" then
                                                visualAilment(u504, u505, p506, p507);

                                                return;
                                            end;

                                            if p503 == "endVisualAilment" then
                                                local v667 = u505 or 0.5;
                                                local v668 = GUI:FindFirstChild(u504);

                                                if v668 then
                                                    TweenService:Create(v668, TweenInfo.new(v667), {
                                                        ImageTransparency = 1
                                                    }):Play();
                                                    Debris:AddItem(v668, v667);

                                                    return;
                                                end;

                                                if u504 == "Byakugan" then
                                                    for _, child in game.Lighting:GetChildren() do
                                                        if child.Name == "Byakugan1" or child.Name == "Byakugan2" then
                                                            child:Destroy();
                                                        end;
                                                    end;
                                                end;
                                            else
                                                if p503 == "shakeCam" then
                                                    u32.camIntensity = u32.camIntensity + u504;

                                                    return;
                                                end;

                                                if p503 == "EndOccupied" then
                                                    u32.Occupied = false;
                                                    u32.Dashing = false;

                                                    return;
                                                end;

                                                if p503 == "BlockedAttack" and not u9:FindFirstChild("Ribcage") then
                                                    if u32.Settings.Blocking.Value == true then
                                                        GameManager:stopAnimation("Block", Humanoid, u32.BlockTable);
                                                        local v669 = math.random(1, u32.CombatTable.BlockCount);

                                                        for i, v in next, u32.CombatTable.Block do
                                                            if tonumber(i) == v669 then
                                                                GameManager:getAnimation(v, Humanoid):Play();
                                                            end;
                                                        end;
                                                    end;
                                                else
                                                    if p503 == "Unselect" then
                                                        Unselect(u32.Selected);

                                                        return;
                                                    end;

                                                    if p503 == "UpdateData" then
                                                        u11 = u504;
                                                        Ryo.Amount.Text = u11.Ryo;
                                                        Acumen.Amount.Text = u11.Acumen;
                                                        Embers.Amount.Text = u11.Embers;
                                                        local Loadout2 = u11.Loadout;
                                                        u32.Inventory = u11.Inventory;
                                                        u32.Loadout = Loadout2;

                                                        if Inventory.Visible == true then
                                                            UpdateInventory();
                                                        else
                                                            UpdateLoadout();
                                                        end;

                                                        u3.UpdatedData:Fire();
                                                        local v670 = skillsModule[u32.skillInUse];
                                                        local v671 = v670 and v670.SkillSpeedBoost or 1;
                                                        u32.OriginSpeed = getOriginSpeed() * v671;
                                                        local v672 = u32;
                                                        v672.OriginSpeed = v672.OriginSpeed * (u9:GetAttribute("CombatFluidity") and 1.2 or 1);

                                                        if Humanoid.WalkSpeed >= GameManager.Settings.BaseSpeed * GameManager.Clothing[u11.Clothing].SpeedBoost and u32.Settings.Stunned.Value == false then
                                                            if running.Value == true then
                                                                setRunSpeed();
                                                            else
                                                                Humanoid.WalkSpeed = u32.OriginSpeed;
                                                            end;
                                                        end;

                                                        if not Awakening.Visible then
                                                            Awakening.Visible = GameManager:hasAnAwakening(u11);
                                                        end;

                                                        HUD.PlayerName.Text = u11.Name;
                                                        HUD.PlayerTitle.Text = u11.Title;
                                                        Loadout.RightFrame.Age.Text = "Age : " .. u11.Age;
                                                        Loadout.RightFrame.Bloodline.Text = "Bloodline : " .. u11.Bloodline;
                                                        Loadout.RightFrame.Sins.Text = "Sins : " .. u11.Sins;
                                                        Loadout.RightFrame.ChakraLink.Text = "Chakra Link : " .. u11.ChakraShardsGiven / GameManager:getMaxShards(u11) * 100 .. "%";
                                                        LeftFrame.Armor.Text = u11.Clothing;
                                                        u32.waterSpeed = 0;

                                                        if #u11.Traits > 0 then
                                                            if u11.Traits[1] then
                                                                LeftFrame.Trait1.Text = "- " .. u11.Traits[1];
                                                            else
                                                                LeftFrame.Trait1.Text = "";
                                                            end;

                                                            if u11.Traits[2] then
                                                                LeftFrame.Trait2.Text = "- " .. u11.Traits[2];
                                                            else
                                                                LeftFrame.Trait2.Text = "";
                                                            end;

                                                            if u11.Traits[3] then
                                                                LeftFrame.Trait3.Text = "- " .. u11.Traits[3];
                                                            else
                                                                LeftFrame.Trait3.Text = "";
                                                            end;

                                                            if u11.Traits[4] then
                                                                LeftFrame.Trait4.Text = "- " .. u11.Traits[4];
                                                            else
                                                                LeftFrame.Trait4.Text = "";
                                                            end;

                                                            if GameManager:searchInList(u11.Traits, "Aquaspeed") then
                                                                u32.waterSpeed = GameManager.Traits.Aquaspeed.Amount;
                                                            end;
                                                        else
                                                            LeftFrame.Trait1.Text = "";
                                                            LeftFrame.Trait2.Text = "";
                                                            LeftFrame.Trait3.Text = "";
                                                            LeftFrame.Trait4.Text = "";
                                                        end;

                                                        if u11.Bloodline == "Hoshigaki" then
                                                            u32.waterSpeed = HOSHIGAKI_WATERSPEED;
                                                        end;

                                                        if #u11.Flaws > 0 then
                                                            if u11.Flaws[1] then
                                                                LeftFrame.Flaw1.Text = "- " .. u11.Flaws[1];
                                                            else
                                                                LeftFrame.Flaw1.Text = "";
                                                            end;

                                                            if u11.Flaws[2] then
                                                                LeftFrame.Flaw2.Text = "- " .. u11.Flaws[2];
                                                            else
                                                                LeftFrame.Flaw2.Text = "";
                                                            end;
                                                        else
                                                            LeftFrame.Flaw1.Text = "";
                                                            LeftFrame.Flaw2.Text = "";
                                                        end;

                                                        if u11.Bloodline == "Hoshigaki" then
                                                            updateSharks();
                                                        elseif u11.Bloodline == "Uzumaki" then
                                                            updateChains();
                                                        end;

                                                        if u11.Blindness ~= 0 and (not script.Parent:FindFirstChild("Blindness1") and (not script.Parent:FindFirstChild("Blindness2") and (script.Parent:FindFirstChild("Blindness1").Visible ~= false and (script.Parent:FindFirstChild("Blindness2").Visible ~= false and script.Parent:FindFirstChild("Blindness2").ImageTransparency ~= 1)))) then
                                                            DataEvent:FireServer("BanMe", "Offense 1B");
                                                        end;

                                                        updateTeleportLocations();

                                                        return;
                                                    end;

                                                    if p503 == "UpdateDataKey" then
                                                        u11[u504] = u505;

                                                        return;
                                                    end;

                                                    if p503 == "AgeIncrease" then
                                                        Loadout.RightFrame.Age.Text = "Age : " .. u504;
                                                        newNotification("Aged Up");

                                                        return;
                                                    end;

                                                    if p503 == "UpdateClothingStats" then
                                                        u11.Clothing = u504;
                                                        u32.OriginSpeed = getOriginSpeed();
                                                        local v673 = u32;
                                                        v673.OriginSpeed = v673.OriginSpeed * (u9:GetAttribute("CombatFluidity") and 1.2 or 1);

                                                        if u32.Running == true then
                                                            disableRun("Stop");
                                                        end;

                                                        Humanoid.WalkSpeed = u32.OriginSpeed;

                                                        if GameManager.Clothing[u11.Clothing].IdleAnim and u9:FindFirstChild(u11.Clothing) then
                                                            local v674;

                                                            if u9[u11.Clothing]:FindFirstChild("AC") then
                                                                v674 = u9[u11.Clothing].AC;
                                                            else
                                                                v674 = u9[u11.Clothing].Original.AC;
                                                            end;

                                                            GameManager:getAnimation(GameManager.Clothing[u11.Clothing].IdleAnim, v674):Play();
                                                        end;
                                                    elseif p503 == "UpdateArmorBrokenSpeed" then
                                                        u11.ArmorBroken = true;
                                                        u32.OriginSpeed = getOriginSpeed();
                                                        local v675 = u32;
                                                        v675.OriginSpeed = v675.OriginSpeed * (u9:GetAttribute("CombatFluidity") and 1.2 or 1);

                                                        if Humanoid.WalkSpeed == GameManager.Settings.BaseSpeed * GameManager.Clothing[u11.Clothing].SpeedBoost and u32.Settings.Stunned.Value == false then
                                                            if u32.Running ~= true then
                                                                Humanoid.WalkSpeed = u32.OriginSpeed;

                                                                return;
                                                            end;

                                                            if ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Earth") then
                                                                Humanoid.WalkSpeed = u32.OriginSpeed + 12 + u32.waterSpeed;

                                                                return;
                                                            end;

                                                            Humanoid.WalkSpeed = u32.OriginSpeed + 12 + u32.waterSpeed + u32.awakeningSpeed;
                                                        end;
                                                    else
                                                        if p503 == "AddPlayer" and u504.Name ~= LocalPlayer.Name then
                                                            return;
                                                        end;

                                                        if p503 == "Teleported" and u32.Broken == false then
                                                            hasTeleported(u504);

                                                            return;
                                                        end;

                                                        if p503 == "UpdatePlayerName" then
                                                            HUD.PlayerName.Text = u504;

                                                            return;
                                                        end;

                                                        if p503 == "UpdateChakraColor" then
                                                            u32.chakraColor = u504;

                                                            if u32.chakraColor ~= false then
                                                                for _, child in ipairs(HumanoidRootPart.ChakraJumpVFXAttachment:GetChildren()) do
                                                                    child.Color = ColorSequence.new(child.chakraColor, child.chakraColor);
                                                                end;
                                                            end;
                                                        else
                                                            if p503 == "SwitchOffChakraFeet" then
                                                                u32.ChakraFeet = false;
                                                                GameManager:watersCollision(u32.ChakraFeet);

                                                                return;
                                                            end;

                                                            if p503 == "Notification" then
                                                                if u504 == "Sinless Restored" then
                                                                    u11.Sins = 0;
                                                                end;

                                                                if u504:find("New Title") then
                                                                    updateTitles();
                                                                end;

                                                                newNotification(u504, u505, p506, p507);

                                                                return;
                                                            end;

                                                            if p503 == "ResetChakraPoints" then
                                                                GameManager:resetChakraPoints();

                                                                return;
                                                            end;

                                                            if p503 == "NewLifeForce" then
                                                                if u504 == 100 and u11.LifeForce == 0 then
                                                                    HUD.LifeForce.Value.Value = u504;
                                                                else
                                                                    TweenService:Create(HUD.LifeForce.Value, TweenInfo.new(1), {
                                                                        Value = u504
                                                                    }):Play();
                                                                end;

                                                                if u32.Settings.Awakened.Value ~= "Red Gates" then
                                                                    u6.LifeLost:Play();
                                                                end;

                                                                if p506 then
                                                                    u11.Died = true;
                                                                    u32.Occupied = true;

                                                                    if tonumber(Ryo.Amount.Text) > u11.Ryo then
                                                                        u6.SellMultiple:Play();
                                                                    end;

                                                                    Ryo.Amount.Text = u11.Ryo;
                                                                end;
                                                            else
                                                                if p503 == "UpdateItems" then
                                                                    u32.Inventory = u504;
                                                                    u32.Loadout = u505;

                                                                    if Inventory.Visible == true then
                                                                        UpdateInventory();

                                                                        return;
                                                                    end;

                                                                    UpdateLoadout();

                                                                    return;
                                                                end;

                                                                if p503 == "UpdateLocation" then
                                                                    u11.Location = u504;
                                                                    updateLocation(u504);

                                                                    return;
                                                                end;

                                                                if p503 == "BlurEffect" then
                                                                    GameManager:BlurEffect(u504 or 1);

                                                                    return;
                                                                end;

                                                                if p503 == "CarryCooldownOver" then
                                                                    print("Carry Cooldown Set to false");
                                                                    u32.CarryCooldown = false;

                                                                    return;
                                                                end;

                                                                if p503 == "FinishedAttack" then
                                                                    if u32.Settings.Stunned.Value == false and u504 then
                                                                        u32.Occupied = false;
                                                                    end;

                                                                    if u32.CombatTable.Idle then
                                                                        if u32.ActionAnim then
                                                                            u32.ActionAnim.Stopped:Wait();
                                                                        end;

                                                                        u32.idleAnim = GameManager:getAnimation(u32.CombatTable.Idle, Humanoid);
                                                                        u32.idleAnim:Play();
                                                                    end;
                                                                else
                                                                    if p503 == "ArmorBroken" then
                                                                        table.insert(u11.Injuries, "ArmorBreak");

                                                                        return;
                                                                    end;

                                                                    if p503 == "Knocked" then
                                                                        u32.Occupied = true;
                                                                        u32.Knocked = true;

                                                                        if u32.Running == true then
                                                                            disableRun();
                                                                        end;

                                                                        Humanoid.WalkSpeed = 0;
                                                                        Humanoid.JumpPower = 0;

                                                                        if u32.Carrying == true then
                                                                            print("was carrying!");
                                                                            u32.Carrying = false;
                                                                            GameManager:stopAnimation("Carrying", Humanoid);
                                                                        else
                                                                            print("was not carrying!");
                                                                        end;

                                                                        u32.Last_Y = u9.Torso.Position.Y;

                                                                        return;
                                                                    end;

                                                                    if p503 == "Revive" then
                                                                        u32.Settings.Stunned.Value = false;
                                                                        u32.Occupied = false;
                                                                        u32.Knocked = false;
                                                                        Humanoid.WalkSpeed = u32.OriginSpeed;
                                                                        Humanoid.JumpPower = u32.OriginJump;

                                                                        return;
                                                                    end;

                                                                    if p503 == "BeingCarried" then
                                                                        GameManager:getAnimation("BeingCarried", Humanoid):Play();

                                                                        return;
                                                                    end;

                                                                    if p503 == "EndCarry" then
                                                                        u32.Carrying = false;
                                                                        GameManager:stopAnimation("Carrying", Humanoid);

                                                                        return;
                                                                    end;

                                                                    if p503 == "StopAnimations" then
                                                                        return;
                                                                    end;

                                                                    if p503 == "CreateVelocity" then
                                                                        GameManager:createBodyVelocity(HumanoidRootPart, u504, u505, p506, p507, p508, p509, p510, p511, p512);

                                                                        return;
                                                                    end;

                                                                    if p503 == "NoLongerCarried" then
                                                                        GameManager:stopAnimation("BeingCarried", Humanoid);

                                                                        return;
                                                                    end;

                                                                    if p503 == "PerfectBlock" then
                                                                        local v676 = ReplicatedStorage.UI.PerfectBlock:Clone();
                                                                        v676.Parent = game.Lighting;
                                                                        Debris:AddItem(v676, 0.75);

                                                                        if u504 and u504 == "Victim" then
                                                                            u32.Occupied = true;
                                                                            disableRun("Stop");
                                                                        end;
                                                                    else
                                                                        if p503 == "PerfectGuarded" then
                                                                            PerfectGuard.GuardImage.ImageTransparency = 0.5;

                                                                            for i = 30, 1, -1 do
                                                                                PerfectGuard.Cooldown.Text = i;
                                                                                wait(1);
                                                                            end;

                                                                            PerfectGuard.GuardImage.ImageTransparency = 0;
                                                                            PerfectGuard.Cooldown.Text = "";

                                                                            return;
                                                                        end;

                                                                        if p503 == "DisableRun" then
                                                                            if u32.Running == true then
                                                                                disableRun();
                                                                            end;
                                                                        else
                                                                            if p503 == "CancelChakra" then
                                                                                u32.ChargingChakra = false;

                                                                                return;
                                                                            end;

                                                                            if p503 == "CamShake" then
                                                                                GameManager:OGCamShake(u504, u505, p506);

                                                                                return;
                                                                            end;

                                                                            if p503 == "OGCamShake" then
                                                                                GameManager:OGCamShake(u504, u505, p506);

                                                                                return;
                                                                            end;

                                                                            if p503 == "setCamera" then
                                                                                CurrentCamera.CameraSubject = u504;

                                                                                return;
                                                                            end;

                                                                            if p503 == "InDanger" then
                                                                                u32.InDanger = true;
                                                                                Danger.Visible = true;

                                                                                return;
                                                                            end;

                                                                            if p503 == "BecomeOccupied" then
                                                                                u32.Occupied = true;
                                                                                wait(u504);
                                                                                print("occupied false");
                                                                                u32.Occupied = false;

                                                                                return;
                                                                            end;

                                                                            if p503 == "OutOfDanger" then
                                                                                u32.InDanger = false;
                                                                                Danger.Visible = false;

                                                                                return;
                                                                            end;

                                                                            if p503 == "TsukuyomiStart" and LocalPlayer.Name == "ArkhamDeluxe" then
                                                                                game.StarterGui:SetCoreGuiEnabled("All", false);
                                                                                local v677 = ReplicatedStorage.UI.Tsukuyomi:Clone();
                                                                                v677.Parent = game.Lighting;
                                                                                disableRun("Stop");
                                                                                local v678 = ReplicatedStorage.Sounds.Mangekyou:Clone();
                                                                                v678.Parent = game.SoundService;
                                                                                v678:Play();
                                                                                local ImageLabel = Instance.new("ImageLabel");
                                                                                ImageLabel.Parent = script.Parent;
                                                                                ImageLabel.Position = UDim2.fromScale(0.238, 0.236);
                                                                                ImageLabel.BackgroundTransparency = 1;
                                                                                ImageLabel.Size = UDim2.fromOffset(0, 0);
                                                                                ImageLabel.Image = "http://www.roblox.com/asset/?id=13015957";
                                                                                local ImageLabel2 = Instance.new("ImageLabel");
                                                                                ImageLabel2.Parent = script.Parent;
                                                                                ImageLabel2.Position = UDim2.fromScale(0.651, 0.236);
                                                                                ImageLabel2.BackgroundTransparency = 1;
                                                                                ImageLabel2.Size = UDim2.fromOffset(0, 0);
                                                                                ImageLabel2.Image = "http://www.roblox.com/asset/?id=13015957";
                                                                                local v679 = {
                                                                                    Size = UDim2.fromOffset(200, 200),
                                                                                    Position = UDim2.new(0.238, -100, 0.236, -100),
                                                                                    Rotation = 1480,
                                                                                    ImageTransparency = 1
                                                                                };
                                                                                TweenService:Create(ImageLabel, TweenInfo.new(2, Enum.EasingStyle.Linear), v679):Play();
                                                                                v679.Position = UDim2.new(0.651, -100, 0.236, -100);
                                                                                TweenService:Create(ImageLabel2, TweenInfo.new(2, Enum.EasingStyle.Linear), v679):Play();
                                                                                Debris:AddItem(ImageLabel, 5);
                                                                                Debris:AddItem(ImageLabel2, 5);
                                                                                Debris:AddItem(v677, 5);
                                                                                Debris:AddItem(v678, 5);

                                                                                return;
                                                                            end;

                                                                            if p503 == "TsukuyomiEnd" then
                                                                                game.StarterGui:SetCoreGuiEnabled("All", true);
                                                                                disableRun();

                                                                                return;
                                                                            end;

                                                                            if p503 == "EnableBillboardGui" then
                                                                                u504.Enabled = true;

                                                                                return;
                                                                            end;

                                                                            if p503 == "DisableBillboardGui" then
                                                                                u504.Enabled = false;

                                                                                return;
                                                                            end;

                                                                            if p503 == "quickEffect" then
                                                                                if u504 == "ArrowBarrageAura" then
                                                                                    local u680 = ReplicatedStorage.Effects.ArrowBarrageAura:Clone();
                                                                                    u680.Parent = workspace.Debris;
                                                                                    GameManager:weldParts(Instance.new("Weld"), u505, u680, CFrame.new(0, -2.8, 0));
                                                                                    task.delay(2, function() -- Line: 11153
                                                                                        -- upvalues: u680 (copy), Debris (ref)
                                                                                        for _, descendant in ipairs(u680:GetDescendants()) do
                                                                                            if descendant:IsA("ParticleEmitter") then
                                                                                                descendant.Enabled = false;
                                                                                            end;
                                                                                        end;

                                                                                        Debris:AddItem(u680, 1.5);
                                                                                    end);

                                                                                    return;
                                                                                end;

                                                                                if u504 == "arrowShot" or u504 == "arrowShotQuick" then
                                                                                    local _ = u505.Parent;
                                                                                    local u681 = u505:Clone();
                                                                                    local _ = u504 == "arrowShotQuick";
                                                                                    local u682 = 1;
                                                                                    u505.Transparency = 1;
                                                                                    u681.CFrame = u505.CFrame;
                                                                                    u681.Parent = workspace.Debris;
                                                                                    u681.Transparency = 0;
                                                                                    u681.Trail.Enabled = true;
                                                                                    Debris:AddItem(u681, u682 * 1);

                                                                                    if p507 then
                                                                                        u681.Color = p507;
                                                                                        u681.Trail.Color = ColorSequence.new(p507);
                                                                                    end;

                                                                                    for _, descendant in ipairs(u681:GetDescendants()) do
                                                                                        if descendant:IsA("ParticleEmitter") then
                                                                                            descendant.Enabled = true;

                                                                                            if p507 and descendant.Parent.Name == "blueAttach" then
                                                                                                descendant.Color = ColorSequence.new(p507, p507);

                                                                                                if p507 == GameManager.UI.BlackFireColor then
                                                                                                    descendant.LightEmission = 0;
                                                                                                end;
                                                                                            end;
                                                                                        end;
                                                                                    end;

                                                                                    local Magnitude = (u681.Position - p506.Position).Magnitude;
                                                                                    u681.CFrame = CFrame.lookAt(u681.Position, p506.Position) * CFrame.new(0, 0, 2.5);
                                                                                    u681.Anchored = true;
                                                                                    local v683;

                                                                                    if p508 and p508 == "Valentine Bow" then
                                                                                        v683 = ReplicatedStorage.Particles.arrowValentineShotEmit:Clone();
                                                                                    else
                                                                                        v683 = ReplicatedStorage.Particles.arrowShotEmit:Clone();
                                                                                    end;

                                                                                    v683.Parent = workspace.Debris;
                                                                                    v683.CFrame = u681.CFrame * CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(2, 0, 0);

                                                                                    for _, descendant in ipairs(v683:GetDescendants()) do
                                                                                        if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("EmitCount") then
                                                                                            descendant:Emit(descendant:GetAttribute("EmitCount"));
                                                                                        end;
                                                                                    end;

                                                                                    Debris:AddItem(v683, 3);
                                                                                    TweenService:Create(u681, TweenInfo.new(0.3 * u682), {
                                                                                        Position = (u681.CFrame * CFrame.new(0, 0, Magnitude * -1.2)).Position
                                                                                    }):Play();
                                                                                    task.delay(0.18 * u682, function() -- Line: 11239
                                                                                        -- upvalues: u681 (copy), u682 (ref), TweenService (ref)
                                                                                        for _, descendant in ipairs(u681:GetDescendants()) do
                                                                                            if descendant:IsA("ParticleEmitter") then
                                                                                                descendant.Enabled = false;
                                                                                            end;
                                                                                        end;

                                                                                        task.delay(u682 * 0.04, function() -- Line: 11245
                                                                                            -- upvalues: TweenService (ref), u681 (ref)
                                                                                            TweenService:Create(u681, TweenInfo.new(0.1), {
                                                                                                Transparency = 1
                                                                                            }):Play();
                                                                                        end);
                                                                                    end);

                                                                                    return;
                                                                                end;

                                                                                if u504 == "slashMesh" then
                                                                                    local v684 = ReplicatedStorage.Models[p506 or "SlashMesh"]:Clone();
                                                                                    v684.Parent = workspace.Debris;
                                                                                    v684.CFrame = u505;
                                                                                    TweenService:Create(v684, TweenInfo.new(0.5), {
                                                                                        Transparency = 1,
                                                                                        CFrame = v684.CFrame * CFrame.new(0, 0, -14)
                                                                                    }):Play();
                                                                                    Debris:AddItem(v684, 1.5);

                                                                                    for _, child in ipairs(v684:GetChildren()) do
                                                                                        child:Emit(child:GetAttribute("EmitCount"));
                                                                                    end;

                                                                                    return;
                                                                                end;

                                                                                if u504 == "genderSwitchEffect" then
                                                                                    local v685 = ReplicatedStorage.Particles.genderSwitchEmit:Clone();
                                                                                    v685.Parent = workspace.Debris;
                                                                                    v685.Position = u505;
                                                                                    Debris:AddItem(v685, 4);

                                                                                    for _, descendant in ipairs(v685:GetDescendants()) do
                                                                                        if descendant:IsA("ParticleEmitter") then
                                                                                            descendant:Emit(descendant:GetAttribute("EmitCount"));
                                                                                        end;
                                                                                    end;

                                                                                    return;
                                                                                end;

                                                                                if u504 == "MatatabiSlashMesh" then
                                                                                    local v686 = ReplicatedStorage.Models[p506 or "SlashMesh"]:Clone();
                                                                                    v686.Parent = workspace.Debris;
                                                                                    v686.CFrame = u505;
                                                                                    TweenService:Create(v686, TweenInfo.new(0.4), {
                                                                                        Transparency = 1,
                                                                                        CFrame = v686.CFrame * CFrame.new(0, 0, -30)
                                                                                    }):Play();
                                                                                    Debris:AddItem(v686, 0.75);

                                                                                    for _, child in ipairs(v686:GetChildren()) do
                                                                                        child:Emit(child:GetAttribute("EmitCount"));
                                                                                    end;

                                                                                    return;
                                                                                end;

                                                                                if u504 == "SmallMatatabiSlashMesh" then
                                                                                    local v687 = ReplicatedStorage.Models[p506 or "SlashMesh"]:Clone();
                                                                                    v687.Parent = workspace.Debris;
                                                                                    v687.CFrame = u505;
                                                                                    TweenService:Create(v687, TweenInfo.new(0.4), {
                                                                                        Transparency = 1,
                                                                                        CFrame = v687.CFrame * CFrame.new(0, 0, -10)
                                                                                    }):Play();
                                                                                    Debris:AddItem(v687, 0.75);

                                                                                    for _, child in ipairs(v687:GetChildren()) do
                                                                                        child:Emit(child:GetAttribute("EmitCount"));
                                                                                    end;

                                                                                    return;
                                                                                end;

                                                                                if u504 == "iceSpike" then
                                                                                    local v688 = ReplicatedStorage.Models.IceSpike:Clone();
                                                                                    v688.Anchored = true;
                                                                                    v688.CFrame = u505 * CFrame.new(0, -12, 0);
                                                                                    v688.Parent = workspace.Debris;
                                                                                    v688.Size = Vector3.new(p506.X * 1.1, p506.Y, p506.Z * 1.51);
                                                                                    TweenService:Create(v688, TweenInfo.new(0.4), {
                                                                                        CFrame = v688.CFrame * CFrame.new(0, 12, 0)
                                                                                    }):Play();
                                                                                    GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceSpike:Clone(), v688);
                                                                                    local v689 = GameManager:createBlock("IceBurst", (u505 * CFrame.new(0, p506.Y * -0.47, 0)).Position, 4);
                                                                                    v688.Burst.Parent = v689;
                                                                                    Emit(v689.Burst);
                                                                                    Debris:AddItem(v688, 8.5);
                                                                                    task.wait(3);

                                                                                    for i = 1, 18 do
                                                                                        if i == 18 then
                                                                                            GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceShatter:Clone(), v688);
                                                                                        end;

                                                                                        if i == 1 then
                                                                                            v688:SetAttribute("originalPos", v688.Position);
                                                                                        end;

                                                                                        if i == 18 then
                                                                                            v688.Texture1:Destroy();
                                                                                            v688.Texture2:Destroy();
                                                                                            v688.Texture3:Destroy();
                                                                                            v688.Texture4:Destroy();
                                                                                            v688.Texture5:Destroy();
                                                                                            v688.Texture6:Destroy();
                                                                                            v688.Flare1.Enabled = false;
                                                                                            v688.Smoke1.Enabled = false;
                                                                                            v688.Smoke2.Enabled = false;
                                                                                            v688.Sparks1.Enabled = false;
                                                                                            v688.Transparency = 1;
                                                                                            Emit(v688.IceDestroy);
                                                                                        elseif i / 2 == math.round(i / 2) then
                                                                                            local v690 = v688.Position.X + math.random(-1, 1) / 3;
                                                                                            local v691 = v688.Position.Y + math.random(-1, 1) / 3;
                                                                                            local v692 = v688.Position.Z + math.random(-1, 1) / 3;
                                                                                            v688.Position = Vector3.new(v690, v691, v692);
                                                                                        else
                                                                                            v688.Position = v688:GetAttribute("originalPos");
                                                                                        end;

                                                                                        task.wait(0.05);
                                                                                    end;

                                                                                    return;
                                                                                end;

                                                                                if u504 == "iceSeal" then
                                                                                    local v693 = p508 or 1;
                                                                                    local v694 = ReplicatedStorage.Models.IceSeal:Clone();
                                                                                    v694:PivotTo(u505 * CFrame.Angles(0, 0, -1.5707963267948966) + Vector3.new(0, -3.25, 0));
                                                                                    v694:ScaleTo(v693);
                                                                                    v694.Parent = workspace.Debris;

                                                                                    for _, child in v694:GetChildren() do
                                                                                        if child:IsA("BasePart") then
                                                                                            local Size = child.Size;
                                                                                            child.Size = Vector3.new(0, child.Size.Y, 0);
                                                                                            LocalTween:Tween(child, { 0.25 }, {
                                                                                                Size = Size
                                                                                            });
                                                                                        end;
                                                                                    end;

                                                                                    local v695 = ReplicatedStorage.Models.FadeCylinder:Clone();
                                                                                    v695.CFrame = u505;
                                                                                    v695.Size = Vector3.new(p506.Z + 5, v695.Size.Y, p506.Z + 5);
                                                                                    v695.Size = v695.Size * v693;
                                                                                    v695.CollisionGroup = "AvoidHitbox";
                                                                                    v695.Parent = workspace.Debris;

                                                                                    for _, child in ipairs(v695:GetChildren()) do
                                                                                        if child.Name == "Floor" then
                                                                                            child:Destroy();
                                                                                        end;
                                                                                    end;

                                                                                    GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceSpike:Clone(), v694.PrimaryPart);
                                                                                    Emit(v694.PrimaryPart.Burst);
                                                                                    Debris:AddItem(v694, p507 + 3);
                                                                                    task.wait(p507);

                                                                                    for i = 1, 18 do
                                                                                        if i == 18 then
                                                                                            GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceShatter:Clone(), v694.PrimaryPart);
                                                                                        end;

                                                                                        if i == 1 then
                                                                                            for _, child in v694:GetChildren() do
                                                                                                child:SetAttribute("originalPos", child.Position);
                                                                                            end;
                                                                                        end;

                                                                                        if i == 18 then
                                                                                            for _, descendant in v694:GetDescendants() do
                                                                                                if descendant:IsA("Texture") then
                                                                                                    descendant:Destroy();
                                                                                                elseif descendant:IsA("ParticleEmitter") then
                                                                                                    descendant.Enabled = false;
                                                                                                elseif descendant:IsA("BasePart") then
                                                                                                    descendant.Transparency = 1;
                                                                                                end;
                                                                                            end;

                                                                                            Emit(v694.PrimaryPart.IceDestroy);
                                                                                        else
                                                                                            local v696 = math.random(-1, 1) / 3;
                                                                                            local v697 = math.random(-1, 1) / 3;
                                                                                            local v698 = math.random(-1, 1) / 3;

                                                                                            for _, child in v694:GetChildren() do
                                                                                                if i / 2 == math.round(i / 2) then
                                                                                                    child.Position = Vector3.new(child.Position.X + v696, child.Position.Y + v697, child.Position.Z + v698);
                                                                                                else
                                                                                                    child.Position = child:GetAttribute("originalPos");
                                                                                                end;
                                                                                            end;
                                                                                        end;

                                                                                        task.wait(0.05);
                                                                                    end;

                                                                                    Debris:AddItem(v695, 1);

                                                                                    return;
                                                                                end;

                                                                                if u504 == "tripleSlash" then
                                                                                    local u699 = ReplicatedStorage.Models.Slash:Clone();
                                                                                    u699.Parent = workspace.Debris;
                                                                                    u699.CFrame = p507.CFrame * CFrame.new(0, 0, -1);
                                                                                    u699.Size = Vector3.new(u699.Size.X, u699.Size.Y, u699.Size.Z);
                                                                                    u699.Anchored = true;
                                                                                    task.delay(0.45, function() -- Line: 11461
                                                                                        -- upvalues: u699 (copy)
                                                                                        u699.Dots1.Enabled = false;
                                                                                        u699.Shards1.Enabled = false;
                                                                                    end);
                                                                                    Debris:AddItem(u699, 2.5);

                                                                                    if p508 == 1 then
                                                                                        u505.CFrame = u505.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
                                                                                        TweenService:Create(u699, TweenInfo.new(0.5), {
                                                                                            Transparency = 1,
                                                                                            CFrame = p507.CFrame * CFrame.new(0, 0, -35)
                                                                                        }):Play();

                                                                                        return;
                                                                                    end;

                                                                                    if p508 == 2 then
                                                                                        u505.CFrame = u505.CFrame * CFrame.Angles(0, 0, 0.7853981633974483);
                                                                                        u699.CFrame = u699.CFrame * CFrame.Angles(0, 0, -0.7853981633974483);
                                                                                        TweenService:Create(u699, TweenInfo.new(0.5), {
                                                                                            Transparency = 1,
                                                                                            CFrame = p507.CFrame * CFrame.new(0, 0, -35) * CFrame.Angles(0, 0, -0.7853981633974483)
                                                                                        }):Play();

                                                                                        return;
                                                                                    end;

                                                                                    if p508 == 3 then
                                                                                        u505.CFrame = u505.CFrame * CFrame.Angles(0, 0, -0.7853981633974483);
                                                                                        u699.CFrame = u699.CFrame * CFrame.Angles(0, 0, 0.7853981633974483);
                                                                                        TweenService:Create(u699, TweenInfo.new(0.5), {
                                                                                            Transparency = 1,
                                                                                            CFrame = p507.CFrame * CFrame.new(0, 0, -35) * CFrame.Angles(0, 0, 0.7853981633974483)
                                                                                        }):Play();
                                                                                    end;
                                                                                end;
                                                                            else
                                                                                if p503 == "SyncProjectile" then
                                                                                    u504.CFrame = u505;

                                                                                    return;
                                                                                end;

                                                                                if p503 == "UpdateSkills" then
                                                                                    updateSkills();

                                                                                    return;
                                                                                end;

                                                                                if p503 == "StabilizeRift" then
                                                                                    local v700 = GameManager:getRift(u504);

                                                                                    if u505 then
                                                                                        v700:Destroy();

                                                                                        return;
                                                                                    end;

                                                                                    GameManager:playTempSound(ReplicatedStorage.LocalSounds.Rift_Close:Clone(), HumanoidRootPart);
                                                                                    local v701 = game:GetService("TweenService"):Create(v700, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {
                                                                                        Size = Vector3.new(0, 0, 0)
                                                                                    });
                                                                                    v701:Play();
                                                                                    v701.Completed:Wait();
                                                                                    v700:Destroy();

                                                                                    return;
                                                                                end;

                                                                                if p503 == "playSound" then
                                                                                    GameManager:playTempSound(ReplicatedStorage.LocalSounds[u504]:Clone(), u505);

                                                                                    return;
                                                                                end;

                                                                                if p503 == "stopAnimation" then
                                                                                    GameManager:stopAnimation(u504, u505, p506, p507, p508);

                                                                                    return;
                                                                                end;

                                                                                if p503 == "PivotTo" then
                                                                                    u504:PivotTo(u505);

                                                                                    return;
                                                                                end;

                                                                                if p503 == "pivotCharacter" then
                                                                                    GameManager:pivotCharacter(u9, u504);

                                                                                    return;
                                                                                end;

                                                                                if p503 == "clearBodyForces" then
                                                                                    GameManager:clearBodyForces(u9);

                                                                                    return;
                                                                                end;

                                                                                if p503 == "spawnNPC" then
                                                                                    local v702 = spawnNPC(u504, u505, p506, p507, p508, p509);

                                                                                    if u504 == "Arkoromo Shadow" then
                                                                                        game.Debris:AddItem(v702, 20);
                                                                                    end;
                                                                                else
                                                                                    if p503 == "SusanooPose" then
                                                                                        local v703 = ReplicatedStorage.Effects[u505]:Clone();
                                                                                        v703:PivotTo(CFrame.new(u504));
                                                                                        v703.Parent = workspace.Debris;
                                                                                        Emit(v703);
                                                                                        local Start = v703.FireBurst.GroundWind1.Start;
                                                                                        Start.Transparency = 0;

                                                                                        for _, child in Start:GetChildren() do
                                                                                            child.Enabled = true;
                                                                                        end;

                                                                                        task.delay(1, function() -- Line: 11541
                                                                                            -- upvalues: Start (copy)
                                                                                            for _, child in Start:GetChildren() do
                                                                                                child.Enabled = false;
                                                                                            end;
                                                                                        end);
                                                                                        game:GetService("TweenService"):Create(Start, TweenInfo.new(1.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.1), {
                                                                                            Size = v703.FireBurst.GroundWind1.End.Size,
                                                                                            CFrame = v703.FireBurst.GroundWind1.End.CFrame
                                                                                        }):Play();
                                                                                        game:GetService("TweenService"):Create(Start, TweenInfo.new(1.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.In, 0, false, 0.1), {
                                                                                            Transparency = 1
                                                                                        }):Play();
                                                                                        Debris:AddItem(v703, 5);

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "Wooden Roots" then
                                                                                        GameManager:woodenRoots(u504);

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "Deep Forest Emergence" then
                                                                                        local v704 = ReplicatedStorage.LocalSounds.earthquake:Clone();
                                                                                        v704.Parent = workspace;
                                                                                        v704:Play();

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "endDialogue" then
                                                                                        u32.InDialog = false;
                                                                                        Dialog.Visible = false;
                                                                                        u32.dialogPart = nil;
                                                                                        BloodlinesFrame.Visible = false;

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "PrintServerError" then
                                                                                        print("-----------------------------------------------------------------");
                                                                                        print("---------------------THIS IS A SERVER ERROR----------------------");
                                                                                        print("-----------------------------------------------------------------");
                                                                                        print("-----------------------REPORT TO ARKHAM--------------------------");
                                                                                        print("-----------------------------------------------------------------");

                                                                                        if u504 then
                                                                                            warn("---------------SCRIPT NAME IS : " .. u504 .. "-----------------");
                                                                                        else
                                                                                            warn("---------------SCRIPT NAME IS : UNKNOWN-----------------");
                                                                                        end;

                                                                                        warn("---------------REASON IS : " .. u505 .. "-----------------");
                                                                                        warn("---------------TRACE IS : " .. p506 .. "-----------------");
                                                                                        print("-----------------------------------------------------------------");

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "updateWipeShop" then
                                                                                        updateWipeShop();

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "updateHalloweenShop" then
                                                                                        updateHalloweenShop();

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "updateXmasShop" then
                                                                                        updateXmasShop();

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "updateValentineShop" then
                                                                                        updateValentineShop();

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "updateEventCollectionShop" then
                                                                                        updateEventCollectionShop();

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "updateDog" then
                                                                                        updateDog();

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "startBlueGatesQuest" then
                                                                                        local v705 = nil;

                                                                                        for _, child in workspace:GetChildren() do
                                                                                            if (child.Name == "Tairock" or (child.Name == "Hallowed Tairock" or (child.Name == "Frostrock" or child.Name == "Enchanted Tairock"))) and child:GetAttribute("Occupied") == LocalPlayer.UserId then
                                                                                                v705 = child;
                                                                                                break;
                                                                                            end;
                                                                                        end;

                                                                                        local u706 = ReplicatedStorage.UI.BlueGatesTimer:Clone();
                                                                                        u706.Parent = v705.PrimaryPart;
                                                                                        local u707 = nil;
                                                                                        u707 = u9.AttributeChanged:Connect(function(p708) -- Line: 11618
                                                                                            -- upvalues: u9 (ref), u707 (ref), u706 (copy)
                                                                                            if u9:GetAttribute("BlueGatesTimer") then
                                                                                                u706.TextLabel.Text = u9:GetAttribute("BlueGatesTimer");

                                                                                                return;
                                                                                            end;

                                                                                            u707:Disconnect();
                                                                                            u706:Destroy();
                                                                                        end);

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "highlightTarget" then
                                                                                        local v709 = u505 or {};
                                                                                        local Highlight = Instance.new("Highlight", u504);
                                                                                        Highlight.Name = "RemoteHighlight";
                                                                                        Highlight.FillTransparency = v709.FillTransparency or 1;
                                                                                        Highlight.OutlineTransparency = v709.OutlineTransparency or 0;
                                                                                        Highlight.FillColor = v709.FillColor or Color3.fromRGB(0, 255, 0);
                                                                                        Highlight.OutlineColor = v709.OutlineColor or Color3.fromRGB(255, 255, 255);

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "removeHighlight" then
                                                                                        for _, child in u504:GetChildren() do
                                                                                            if child.Name == "RemoteHighlight" then
                                                                                                child:Destroy();
                                                                                            end;
                                                                                        end;

                                                                                        return;
                                                                                    end;

                                                                                    if p503 == "initializeRedGatesTargets" then
                                                                                        while u32.Settings.Awakened.Value == "Red Gates" do
                                                                                            for _, v in game.Players:GetPlayers() do
                                                                                                if v.UserId ~= LocalPlayer.UserId and (v.Character and not (v.Character:FindFirstChild("ForceField") or v.Character:FindFirstChild("RedGatesTarget"))) then
                                                                                                    local v710 = ReplicatedStorage.UI.RedGatesTarget:Clone();
                                                                                                    v710.Adornee = v.Character.PrimaryPart;
                                                                                                    v710.Parent = LocalPlayer.PlayerGui;
                                                                                                    v710.TextButton.MouseButton1Down:Connect(function() -- Line: 11657
                                                                                                        -- upvalues: u32 (ref), v (copy)
                                                                                                        local Selected = u32.Selected;
                                                                                                        u32.Selected = "Red Gates";
                                                                                                        activateSkill("MouseButton1", "Flicker Teleport", v.Character);
                                                                                                        u32.Selected = Selected;
                                                                                                    end);
                                                                                                end;
                                                                                            end;

                                                                                            task.wait(1);
                                                                                        end;
                                                                                    else
                                                                                        if p503 == "removeRedGatesTargets" then
                                                                                            for _, child in LocalPlayer.PlayerGui:GetChildren() do
                                                                                                if child.Name == "RedGatesTarget" then
                                                                                                    child:Destroy();
                                                                                                end;
                                                                                            end;

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "updateVillageData" then
                                                                                            VillageData = u504;

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "updateVillageDataSingleVillage" then
                                                                                            VillageData[u504][u505][p506] = p507;

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "stopEmotes" then
                                                                                            for _, v in u504:GetPlayingAnimationTracks() do
                                                                                                for i, _ in GameManager.Emotes do
                                                                                                    if v.Name == i then
                                                                                                        v:Stop();
                                                                                                        warn("stopped");
                                                                                                    end;
                                                                                                end;
                                                                                            end;

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "Zig Zag Pounce VFX" then
                                                                                            local v711 = u504:GetPivot() * CFrame.Angles(0.7853981633974483, 0, 0) * CFrame.new(0, 0, -2);
                                                                                            local v712 = ReplicatedStorage.Models.SmallMatatabiSlashMesh:Clone();
                                                                                            v712.Parent = workspace.Debris;
                                                                                            v712.CFrame = v711;
                                                                                            TweenService:Create(v712, TweenInfo.new(0.4), {
                                                                                                Transparency = 1,
                                                                                                CFrame = v712.CFrame * CFrame.new(0, 0, -10)
                                                                                            }):Play();
                                                                                            Debris:AddItem(v712, 0.75);

                                                                                            for _, child in ipairs(v712:GetChildren()) do
                                                                                                child:Emit(child:GetAttribute("EmitCount"));
                                                                                            end;

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "TPVFX" then
                                                                                            local v713 = ReplicatedStorage.Effects[p503]:Clone();
                                                                                            v713:PivotTo(CFrame.new(u504.Position) + Vector3.new(0, 0, 0));
                                                                                            v713.Parent = workspace.Debris;
                                                                                            Emit(v713);
                                                                                            Debris:AddItem(v713, 1);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "ZigZagUppercutVFX" then
                                                                                            local v714 = ReplicatedStorage.Effects[p503]:Clone();
                                                                                            v714:PivotTo(u504:GetPivot() * CFrame.new(0, 0, -1));
                                                                                            v714.Parent = workspace.Debris;
                                                                                            Emit(v714);
                                                                                            Debris:AddItem(v714, 1);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "ZigZagHitVFX" then
                                                                                            local v715 = ReplicatedStorage.Effects[p503]:Clone();
                                                                                            v715:PivotTo(u504:GetPivot() * CFrame.new(0, 0, 0));
                                                                                            v715.Anchored = false;
                                                                                            v715.Parent = workspace.Debris;
                                                                                            Emit(v715);
                                                                                            Debris:AddItem(v715, 1);
                                                                                            local WeldConstraint = Instance.new("WeldConstraint");
                                                                                            WeldConstraint.Part0 = u504.PrimaryPart;
                                                                                            WeldConstraint.Part1 = v715;
                                                                                            WeldConstraint.Parent = v715;

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "CrossSlashVFX" then
                                                                                            local v716 = ReplicatedStorage.Effects[p503]:Clone();
                                                                                            v716:PivotTo(CFrame.new(u504.Position) + Vector3.new(0, 0, 0));
                                                                                            v716.Parent = workspace.Debris;
                                                                                            Emit(v716);
                                                                                            Debris:AddItem(v716, 1);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "Matatabi_Bullet_Emit" then
                                                                                            local v717 = ReplicatedStorage.Effects[p503]:Clone();
                                                                                            v717:PivotTo(u504.Head.CFrame * CFrame.new(0, 0, -2.5));
                                                                                            v717.Parent = workspace.Debris;
                                                                                            Emit(v717);
                                                                                            Debris:AddItem(v717, 1);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "FeatherGenjutsu" then
                                                                                            require(ReplicatedStorage.Effects.FeatherGenjutsu.EffectsModule).StartVFX(HumanoidRootPart, u504);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "StopFeatherGenjutsu" then
                                                                                            require(ReplicatedStorage.Effects.FeatherGenjutsu.EffectsModule).StopVFX();

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "CrowIllusion" then
                                                                                            require(ReplicatedStorage.Effects.CrowIllusion.EffectsModule).StartVFX(u504, nil, nil, u505);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "FogIllusion" then
                                                                                            require(ReplicatedStorage.Effects.FogIllusion.EffectsModule).StartVFX(u504, nil, nil, u505, p506);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "StopFogIllusion" then
                                                                                            require(ReplicatedStorage.Effects.FogIllusion.EffectsModule).StopVFX();
                                                                                            updateLocation(u32.currentLocation);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "Izanagi" then
                                                                                            require(ReplicatedStorage.Effects.Izanagi.EffectsModule).StartVFX(u504, u505, p506);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "Genjutsu Release" then
                                                                                            local v718 = ReplicatedStorage.Effects[p503]:Clone();
                                                                                            v718:PivotTo(u504:GetPivot() + Vector3.new(0, -2.5, 0));
                                                                                            v718.Parent = workspace.Debris;
                                                                                            Emit(v718);
                                                                                            Debris:AddItem(v718, 2);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "ShakePart" then
                                                                                            GameManager:ShakePart(u504, u505, p506, p507);

                                                                                            return;
                                                                                        end;

                                                                                        if p503 == "iceShake" then
                                                                                            local v719 = u505 or 18;
                                                                                            local v720 = p506 or 0.05;

                                                                                            if u504:IsA("Model") then
                                                                                                for i = 1, v719 do
                                                                                                    if i == v719 then
                                                                                                        GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceShatter:Clone(), u504.PrimaryPart);
                                                                                                    end;

                                                                                                    if i == 1 then
                                                                                                        for _, child in u504:GetChildren() do
                                                                                                            child:SetAttribute("originalPos", child.Position);
                                                                                                        end;
                                                                                                    end;

                                                                                                    if i == v719 then
                                                                                                        for _, descendant in u504:GetDescendants() do
                                                                                                            if descendant:IsA("Texture") then
                                                                                                                descendant:Destroy();
                                                                                                            elseif descendant:IsA("ParticleEmitter") then
                                                                                                                descendant.Enabled = false;
                                                                                                            elseif descendant:IsA("BasePart") then
                                                                                                                descendant.Transparency = 1;
                                                                                                            end;
                                                                                                        end;

                                                                                                        Emit(u504.PrimaryPart.IceDestroy);
                                                                                                    else
                                                                                                        local v721 = math.random(-1, 1) / 3;
                                                                                                        local v722 = math.random(-1, 1) / 3;
                                                                                                        local v723 = math.random(-1, 1) / 3;

                                                                                                        for _, child in u504:GetChildren() do
                                                                                                            if i / 2 == math.round(i / 2) then
                                                                                                                child.Position = Vector3.new(child.Position.X + v721, child.Position.Y + v722, child.Position.Z + v723);
                                                                                                            else
                                                                                                                child.Position = child:GetAttribute("originalPos");
                                                                                                            end;
                                                                                                        end;
                                                                                                    end;

                                                                                                    task.wait(v720);
                                                                                                end;

                                                                                                return;
                                                                                            end;

                                                                                            if u504:IsA("BasePart") then
                                                                                            end;
                                                                                        else
                                                                                            if p503 == "ScaleParticle" then
                                                                                                GameManager:scaleParticle(u504, u505);

                                                                                                return;
                                                                                            end;

                                                                                            if p503 == "ScaleParticles" then
                                                                                                GameManager:scaleParticles(u504, u505);

                                                                                                return;
                                                                                            end;

                                                                                            if p503 == "startIceSkate" then
                                                                                                local v724;

                                                                                                if u504.Name == u9.Name then
                                                                                                    local v725 = GameManager:getHealthPercentage(Humanoid) < 25 and 40 or 60;
                                                                                                    v724 = GameManager:createBodyVelocity(HumanoidRootPart, HumanoidRootPart.CFrame.LookVector, v725, nil, "CustomForceBV", Vector3.new(800000, 30, 800000), nil, nil, "Update", nil, true);
                                                                                                else
                                                                                                    v724 = nil;
                                                                                                end;

                                                                                                GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceSkateV2:Clone(), u504.PrimaryPart);
                                                                                                GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceSkate2:Clone(), u504.PrimaryPart);

                                                                                                for _, child in u504:GetChildren() do
                                                                                                    if child:IsA("BasePart") and (child.Name:match("Arm") or child.Name:match("Leg")) then
                                                                                                        local Attachment = Instance.new("Attachment");
                                                                                                        Attachment.Name = "IceSkateAttachment";
                                                                                                        Attachment.Position = Vector3.new(0, -child.Size.Y / 2.25, 0);
                                                                                                        Attachment.Parent = child;
                                                                                                        local v726 = ReplicatedStorage.Effects["Ice Skate_Trail"].ParticleEmitter:Clone();
                                                                                                        v726.Name = "Ice Skate Particle";
                                                                                                        v726.Parent = Attachment;
                                                                                                    end;
                                                                                                end;

                                                                                                local v727 = ReplicatedStorage.Effects["Ice Skate_Wind"].ParticleEmitter:Clone();
                                                                                                v727.Name = "Ice Skate Particle";
                                                                                                v727.Parent = u504.Torso;
                                                                                                local v728 = RaycastParams.new();
                                                                                                v728.FilterDescendantsInstances = { workspace.Debris, u504, workspace.Locations };
                                                                                                v728.FilterType = Enum.RaycastFilterType.Exclude;
                                                                                                local v729 = GameManager:getSettings(u504);

                                                                                                while v729.CurrentSkill.Value == "Ice Skate" do
                                                                                                    if u504.Name == u9.Name then
                                                                                                        u504.Humanoid.JumpPower = 30;
                                                                                                    end;

                                                                                                    local Position = (u504.PrimaryPart.CFrame * CFrame.new(0, 4, -3)).Position;
                                                                                                    local v730 = workspace:Raycast(Position, Vector3.new(0, -10, 0), v728);

                                                                                                    if v730 then
                                                                                                        local u731 = ReplicatedStorage.Models.IceFloorSmall:Clone();
                                                                                                        u731.Parent = workspace.Debris;
                                                                                                        local v732 = CFrame.new(v730.Position, v730.Position + v730.Normal);
                                                                                                        local Angles = CFrame.Angles;
                                                                                                        local v733 = math.random(0, 360);
                                                                                                        u731.CFrame = v732 * Angles(1.5707963267948966, math.rad(v733), 0);
                                                                                                        game:GetService("TweenService"):Create(u731, TweenInfo.new(3), {
                                                                                                            Transparency = 1
                                                                                                        }):Play();
                                                                                                        game.Debris:AddItem(u731, 3);
                                                                                                        task.delay(2, function() -- Line: 11885
                                                                                                            -- upvalues: u731 (copy)
                                                                                                            u731.Flare.Enabled = false;
                                                                                                            u731.Smoke.Enabled = false;

                                                                                                            for _, child in ipairs(u731:GetChildren()) do
                                                                                                                if child.Name == "Texture" then
                                                                                                                    game:GetService("TweenService"):Create(child, TweenInfo.new(1), {
                                                                                                                        Transparency = 1
                                                                                                                    }):Play();
                                                                                                                end;
                                                                                                            end;
                                                                                                        end);
                                                                                                    else
                                                                                                        local u734 = ReplicatedStorage.Models.IceFloorSmall:Clone();
                                                                                                        local v735 = u504.PrimaryPart.CFrame * CFrame.new(0, -5.5, 0);
                                                                                                        local Angles = CFrame.Angles;
                                                                                                        local v736 = math.random(0, 360);
                                                                                                        u734.CFrame = v735 * Angles(0, math.rad(v736), 0);
                                                                                                        u734.Parent = workspace.Debris;
                                                                                                        game:GetService("TweenService"):Create(u734, TweenInfo.new(3), {
                                                                                                            Transparency = 1
                                                                                                        }):Play();
                                                                                                        game.Debris:AddItem(u734, 3);
                                                                                                        task.delay(2, function() -- Line: 11905
                                                                                                            -- upvalues: u734 (copy)
                                                                                                            u734.Flare.Enabled = false;
                                                                                                            u734.Smoke.Enabled = false;

                                                                                                            for _, child in ipairs(u734:GetChildren()) do
                                                                                                                if child.Name == "Texture" then
                                                                                                                    game:GetService("TweenService"):Create(child, TweenInfo.new(1), {
                                                                                                                        Transparency = 1
                                                                                                                    }):Play();
                                                                                                                end;
                                                                                                            end;
                                                                                                        end);
                                                                                                    end;

                                                                                                    task.wait(0.05);
                                                                                                end;

                                                                                                if v724 then
                                                                                                    v724:Destroy();
                                                                                                end;

                                                                                                GameManager:stopSound("IceSkateV2", u504.PrimaryPart);
                                                                                                GameManager:stopSound("IceSkate2", u504.PrimaryPart);

                                                                                                for _, descendant in u504:GetDescendants() do
                                                                                                    if descendant.Name == "Ice Skate Particle" then
                                                                                                        descendant.Enabled = false;
                                                                                                    elseif descendant.Name == "IceSkateAttachment" then
                                                                                                        Debris:AddItem(descendant, 1);
                                                                                                    end;
                                                                                                end;

                                                                                                if u504.Name == u9.Name and u504.Humanoid.JumpPower == 30 then
                                                                                                    u504.Humanoid.JumpPower = u32.OriginJump;
                                                                                                end;
                                                                                            else
                                                                                                if p503 == "tweenCameraFOV" then
                                                                                                    local u737 = p506 or 0.5;
                                                                                                    TweenService:Create(CurrentCamera, TweenInfo.new(u737), {
                                                                                                        FieldOfView = u504 or 70
                                                                                                    }):Play();
                                                                                                    task.delay(p507 or (u505 or 1), function() -- Line: 11950
                                                                                                        -- upvalues: TweenService (ref), CurrentCamera (ref), u737 (copy)
                                                                                                        TweenService:Create(CurrentCamera, TweenInfo.new(u737), {
                                                                                                            FieldOfView = 70
                                                                                                        }):Play();
                                                                                                    end);

                                                                                                    return;
                                                                                                end;

                                                                                                if p503 == "Ice Cloud" then
                                                                                                    local u738 = ReplicatedStorage.Models["Ice Rain"]["Ice Cloud"]:Clone();
                                                                                                    u738.Position = u504;
                                                                                                    u738.Size = Vector3.new(u738.Size.X, p507, p507);
                                                                                                    u738.Parent = workspace.Debris;
                                                                                                    task.delay(p506, function() -- Line: 11966
                                                                                                        -- upvalues: u738 (copy), Debris (ref)
                                                                                                        u738.Transparency = 1;

                                                                                                        for _, descendant in u738:GetDescendants() do
                                                                                                            if descendant:IsA("ParticleEmitter") then
                                                                                                                descendant.Enabled = false;
                                                                                                            end;
                                                                                                        end;

                                                                                                        Debris:AddItem(u738, 2);
                                                                                                    end);
                                                                                                    local u739 = ReplicatedStorage.Models.LightningWarning:Clone();
                                                                                                    u739.Position = u505;
                                                                                                    u739.Size = Vector3.new(p507, u739.Size.Y, p507) * 1.3;
                                                                                                    u739.Parent = workspace.Debris;
                                                                                                    Debris:AddItem(u739, 3);
                                                                                                    LocalTween:Tween(u739.Decal, { 0.7 }, {
                                                                                                        Transparency = 0.7
                                                                                                    });
                                                                                                    task.delay(2, function() -- Line: 11990
                                                                                                        -- upvalues: LocalTween (ref), u739 (copy)
                                                                                                        LocalTween:Tween(u739.Decal, { 0.7 }, {
                                                                                                            Transparency = 1
                                                                                                        });
                                                                                                    end);

                                                                                                    return;
                                                                                                end;

                                                                                                if p503 == "Ice Rain" then
                                                                                                    local Magnitude = (u505 - u504).Magnitude;
                                                                                                    local v740 = RaycastParams.new();
                                                                                                    v740.FilterDescendantsInstances = {
                                                                                                        workspace.Debris,
                                                                                                        workspace.Locations,
                                                                                                        Model,
                                                                                                        GameManager:getCharacters()
                                                                                                    };
                                                                                                    v740.FilterType = Enum.RaycastFilterType.Exclude;
                                                                                                    local v741 = tick();

                                                                                                    while tick() - v741 < p506 do
                                                                                                        local v742 = math.random(-p507 / 2, p507 / 2);
                                                                                                        local v743 = math.random(0, 5);
                                                                                                        local v744 = u504 + Vector3.new(v742, v743, math.random(-p507 / 2, p507 / 2));
                                                                                                        local u745 = ReplicatedStorage.Models["Ice Rain"].Spike:Clone();
                                                                                                        u745.CFrame = CFrame.new(v744) * CFrame.Angles(3.141592653589793, 0, 0);
                                                                                                        u745.Parent = workspace.Debris;
                                                                                                        local u746 = v744 + Vector3.new(0, -Magnitude, 0);
                                                                                                        LocalTween:Tween(u745, { 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In }, {
                                                                                                            CFrame = CFrame.new(u746 + Vector3.new(0, u745.Size.Y / 2, 0)) * CFrame.Angles(3.141592653589793, 0, 0)
                                                                                                        });
                                                                                                        task.delay(0.15, function() -- Line: 12039
                                                                                                            -- upvalues: u745 (copy), u746 (ref), Emit (ref), Debris (ref)
                                                                                                            u745.Sound:Play();
                                                                                                            u745.IceDestroy.WorldPosition = u746;
                                                                                                            Emit(u745.IceDestroy);
                                                                                                            u745.Transparency = 1;

                                                                                                            for _, child in u745:GetChildren() do
                                                                                                                if child:IsA("Texture") then
                                                                                                                    child.Transparency = 1;
                                                                                                                end;
                                                                                                            end;

                                                                                                            Debris:AddItem(u745, 1);
                                                                                                        end);
                                                                                                        task.wait(0.016666666666666666);
                                                                                                    end;
                                                                                                else
                                                                                                    if p503 == "FreezeBlock" then
                                                                                                        local v747, v748 = u504:GetBoundingBox();
                                                                                                        local u749 = ReplicatedStorage.Models["Freeze Block"]:Clone();
                                                                                                        u749.Size = v748 + Vector3.new(2, 2, 2);
                                                                                                        u749.CFrame = v747;
                                                                                                        u749.Parent = u504;
                                                                                                        local Motor6D = Instance.new("Motor6D");
                                                                                                        Motor6D.Part0 = u504.PrimaryPart;
                                                                                                        Motor6D.Part1 = u749;
                                                                                                        Motor6D.Parent = u749;
                                                                                                        GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceSpike:Clone(), u504.PrimaryPart);
                                                                                                        task.delay(1, function() -- Line: 12073
                                                                                                            -- upvalues: LocalTween (ref), u749 (copy), Debris (ref), Emit (ref), GameManager (ref), ReplicatedStorage (ref), u504 (copy)
                                                                                                            LocalTween:Tween(u749, { 0.5 }, {
                                                                                                                Transparency = 1
                                                                                                            });

                                                                                                            for _, child in u749:GetChildren() do
                                                                                                                if child:IsA("Texture") then
                                                                                                                    LocalTween:Tween(child, { 0.5 }, {
                                                                                                                        Transparency = 1
                                                                                                                    });
                                                                                                                end;
                                                                                                            end;

                                                                                                            Debris:AddItem(u749, 1);
                                                                                                            task.wait(0.1);
                                                                                                            Emit(u749.IceDestroy);
                                                                                                            GameManager:playTempSound(ReplicatedStorage.LocalSounds.IceSpike:Clone(), u504.PrimaryPart);
                                                                                                        end);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "CloakBombEmit" then
                                                                                                        local v750 = ReplicatedStorage.Models.TBB_Launch.Attachment:Clone();
                                                                                                        v750.Parent = workspace.Terrain;
                                                                                                        v750.WorldCFrame = u504;
                                                                                                        game.Debris:AddItem(v750, 3);
                                                                                                        Emit(v750);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "CloakBombExplosion" then
                                                                                                        local v751 = ReplicatedStorage.Models.TBB_Explosion:Clone();
                                                                                                        v751:PivotTo(u504);
                                                                                                        v751.Parent = workspace.Debris;
                                                                                                        game.Debris:AddItem(v751, 5);
                                                                                                        Emit(v751);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "HirudoraEmit" then
                                                                                                        local v752 = ReplicatedStorage.Effects.Hirudora.Emit:Clone();
                                                                                                        v752:PivotTo(u504);
                                                                                                        v752.Parent = workspace.Debris;
                                                                                                        Emit(v752);
                                                                                                        Debris:AddItem(v752, 0.75);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "HirudoraExplosion" then
                                                                                                        local u753 = ReplicatedStorage.Effects.Hirudora.Explosion:Clone();
                                                                                                        u753:PivotTo(u504);
                                                                                                        u753.Parent = workspace.Debris;
                                                                                                        local v754 = ReplicatedStorage.Effects.Hirudora.Boom:Clone();
                                                                                                        v754:PivotTo(u753:GetPivot());
                                                                                                        v754.Parent = workspace.Debris;
                                                                                                        Debris:AddItem(v754, 3);
                                                                                                        Emit(v754);
                                                                                                        GameManager:playTempSound(ReplicatedStorage.LocalSounds.HirudoraExplode:Clone(), u753.PrimaryPart);
                                                                                                        task.delay(2.5, function() -- Line: 12138
                                                                                                            -- upvalues: u753 (copy), LocalTween (ref), Debris (ref)
                                                                                                            for _, descendant in u753:GetDescendants() do
                                                                                                                if descendant:IsA("BasePart") then
                                                                                                                    LocalTween:Tween(descendant, { 0.25 }, {
                                                                                                                        Size = Vector3.new(0, 0, 0)
                                                                                                                    });
                                                                                                                elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
                                                                                                                    descendant.Enabled = false;
                                                                                                                end;
                                                                                                            end;

                                                                                                            Debris:AddItem(u753, 1);
                                                                                                        end);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "HinataRotationExplosion" then
                                                                                                        local v755 = ReplicatedStorage.Models[u505]:Clone();
                                                                                                        v755:PivotTo(u504);
                                                                                                        v755.Parent = workspace.Debris;
                                                                                                        Emit(v755);
                                                                                                        Debris:AddItem(v755, 3);
                                                                                                        GameManager:playTempSound(ReplicatedStorage.LocalSounds.HinataExplode:Clone(), v755);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "InvincibleEffect" then
                                                                                                        local u756 = ReplicatedStorage.Effects.Attachments.Invincible:Clone();
                                                                                                        u756.Parent = u504.PrimaryPart;
                                                                                                        Debris:AddItem(u756, 1.2);
                                                                                                        task.delay(0.3, function() -- Line: 12171
                                                                                                            -- upvalues: u756 (copy)
                                                                                                            for _, child in u756:GetChildren() do
                                                                                                                if child.Name == "Shards" or child.Name == "Specs" then
                                                                                                                    child.Enabled = false;
                                                                                                                end;
                                                                                                            end;
                                                                                                        end);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "ClearedToPickUpEnded" then
                                                                                                        for _, v in u32.myTrinkets do
                                                                                                            local ID = v:FindFirstChild("ID", true);

                                                                                                            if ID and ID.Value == u504 then
                                                                                                                for _, descendant in v:GetDescendants() do
                                                                                                                    if descendant.Name == "ClearedToPickUp" then
                                                                                                                        descendant:Destroy();
                                                                                                                    end;
                                                                                                                end;
                                                                                                            end;
                                                                                                        end;

                                                                                                        for _, v in u32.myFruits do
                                                                                                            local ID = v:FindFirstChild("ID", true);

                                                                                                            if ID and ID.Value == u504 then
                                                                                                                for _, descendant in v:GetDescendants() do
                                                                                                                    if descendant.Name == "ClearedToPickUp" then
                                                                                                                        descendant:Destroy();
                                                                                                                    end;
                                                                                                                end;
                                                                                                            end;
                                                                                                        end;

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "Shisui Throw Emit" then
                                                                                                        local v757;

                                                                                                        if u505 == "Charming Shisui" then
                                                                                                            v757 = ReplicatedStorage.Effects["LoveShisui Throw"]:Clone();
                                                                                                        else
                                                                                                            v757 = ReplicatedStorage.Effects["Shisui Throw"]:Clone();
                                                                                                        end;

                                                                                                        v757:PivotTo(u504);
                                                                                                        v757.Parent = workspace.Debris;
                                                                                                        Emit(v757);
                                                                                                        Debris:AddItem(v757, 5);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "Shisui Throw Explosion" then
                                                                                                        local v758;

                                                                                                        if u505 == "Charming Shisui" then
                                                                                                            v758 = ReplicatedStorage.Effects["LoveShisui Throw Explosion"]:Clone();
                                                                                                        else
                                                                                                            v758 = ReplicatedStorage.Effects["Shisui Throw Explosion"]:Clone();
                                                                                                        end;

                                                                                                        v758:PivotTo(u504);
                                                                                                        v758.Parent = workspace.Debris;
                                                                                                        Emit(v758);
                                                                                                        Debris:AddItem(v758, 5);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "Shisui Shards" then
                                                                                                        local u759 = ReplicatedStorage.Effects["Shisui Shards"]:Clone();
                                                                                                        u759:PivotTo(u504);
                                                                                                        u759.Parent = workspace.Debris;
                                                                                                        task.delay(u505, function() -- Line: 12239
                                                                                                            -- upvalues: u759 (copy), Debris (ref)
                                                                                                            for _, descendant in u759:GetDescendants() do
                                                                                                                if descendant:IsA("ParticleEmitter") then
                                                                                                                    descendant.Enabled = false;
                                                                                                                end;
                                                                                                            end;

                                                                                                            Debris:AddItem(u759, 3);
                                                                                                        end);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "KotoamatsukamiEyeEmit" then
                                                                                                        local u760 = ReplicatedStorage.Effects.Kotoamatsukami.KotoamatsukamiEyeEmit:Clone();
                                                                                                        u760.Parent = workspace.Debris;
                                                                                                        Emit(u760);
                                                                                                        Debris:AddItem(u760, 3);
                                                                                                        task.spawn(function() -- Line: 12258
                                                                                                            -- upvalues: u504 (copy), u760 (copy)
                                                                                                            local v761 = tick();

                                                                                                            while tick() - v761 < 3 and (u504 and (u504.Parent and u504:FindFirstChild("Head"))) do
                                                                                                                u760.Position = u504.Head.Position + Vector3.new(0, 4.75, 0);
                                                                                                                task.wait();
                                                                                                            end;

                                                                                                            u760:Destroy();
                                                                                                        end);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "KotoamatsukamiIdle" then
                                                                                                        for _, descendant in u505:GetDescendants() do
                                                                                                            if descendant.Name == "KotoamatsukamiBillboardGui" then
                                                                                                                descendant:Destroy();
                                                                                                            end;
                                                                                                        end;

                                                                                                        local v762 = ReplicatedStorage.UI.KotoamatsukamiBillboardGui:Clone();
                                                                                                        v762.Parent = u505.Head;
                                                                                                        Debris:AddItem(v762, p506);

                                                                                                        if u504 == LocalPlayer then
                                                                                                            v762.AlwaysOnTop = true;
                                                                                                        end;

                                                                                                        v762.ImageLabel.ImageTransparency = 1;
                                                                                                        TweenService:Create(v762.ImageLabel, TweenInfo.new(0.5), {
                                                                                                            ImageTransparency = 0
                                                                                                        }):Play();

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "KotoamatsukamiCommand" then
                                                                                                        GameManager:playTempSound(ReplicatedStorage.LocalSounds.SharinganActivation:Clone(), workspace);
                                                                                                        require(ReplicatedStorage.Effects.Kotoamatsukami.Command.EffectsModule).StartVFX(HumanoidRootPart);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "KotoamatsukamiUltimateVFX" then
                                                                                                        GameManager:playTempSound(ReplicatedStorage.LocalSounds.SharinganActivation:Clone(), workspace);
                                                                                                        require(ReplicatedStorage.Effects.Kotoamatsukami.Ultimate.EffectsModule).StartVFX(HumanoidRootPart);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "Shisui Thrust" then
                                                                                                        if p507 == "Charming Shisui" then
                                                                                                            require(ReplicatedStorage.Effects.Kotoamatsukami.LoveThrust.EffectsModule).StartVFX(u504.PrimaryPart, u505, p506);

                                                                                                            return;
                                                                                                        end;

                                                                                                        require(ReplicatedStorage.Effects.Kotoamatsukami.Thrust.EffectsModule).StartVFX(u504.PrimaryPart, u505, p506);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "Piercing Chakra Arrow" then
                                                                                                        require(ReplicatedStorage.Effects.ChakraBowVFX.EffectsModule).StartVFX(LocalPlayer, u504.HumanoidRootPart);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "SpinningHumanBoulderVFX" then
                                                                                                        if u504.Name == LocalPlayer.Name then
                                                                                                            GameManager:TweenObject(workspace.CurrentCamera, {
                                                                                                                FieldOfView = 90
                                                                                                            }, 0.35);
                                                                                                            Humanoid.JumpPower = 90;
                                                                                                            u32.SpinningHumanBoulder = true;
                                                                                                            print("running subcode for start spinning human boulder vfx because its me");
                                                                                                            TweenService:Create(LocalPlayer, TweenInfo.new(0.35), {
                                                                                                                CameraMinZoomDistance = 45
                                                                                                            }):Play();
                                                                                                            TweenService:Create(LocalPlayer, TweenInfo.new(0.35), {
                                                                                                                CameraMaxZoomDistance = 45
                                                                                                            }):Play();
                                                                                                        end;

                                                                                                        local Clothing = u11.Clothing;

                                                                                                        if Clothing:find("Ascended") then
                                                                                                            Clothing = Clothing:sub(10);
                                                                                                        end;

                                                                                                        local v763, v764;

                                                                                                        if ReplicatedStorage.Clothing:FindFirstChild(Clothing) then
                                                                                                            v763 = ReplicatedStorage.Clothing[Clothing].Shirt;
                                                                                                            v764 = ReplicatedStorage.Clothing[Clothing].Pants;
                                                                                                        else
                                                                                                            v763 = nil;
                                                                                                            v764 = nil;
                                                                                                        end;

                                                                                                        require(ReplicatedStorage.Effects.AkimichiBall.EffectsModule).StartVFX(u504.HumanoidRootPart, v763, v764);

                                                                                                        return;
                                                                                                    end;

                                                                                                    if p503 == "StopSpinningHumanBoulderVFX" then
                                                                                                        require(ReplicatedStorage.Effects.AkimichiBall.EffectsModule).StopVFX(u504.HumanoidRootPart);

                                                                                                        if u504.Name == LocalPlayer.Name then
                                                                                                            GameManager:TweenObject(workspace.CurrentCamera, {
                                                                                                                FieldOfView = GameManager.Settings.DefaultFOV
                                                                                                            }, 0.5);
                                                                                                            Humanoid.JumpPower = u32.OriginJump;
                                                                                                            u32.SpinningHumanBoulder = false;
                                                                                                            print("ENDING subcode for start spinning human boulder vfx because its me");
                                                                                                            TweenService:Create(LocalPlayer, TweenInfo.new(0.35), {
                                                                                                                CameraMinZoomDistance = GameManager.Settings.DefaultMinZoom
                                                                                                            }):Play();
                                                                                                            TweenService:Create(LocalPlayer, TweenInfo.new(0.35), {
                                                                                                                CameraMaxZoomDistance = GameManager.Settings.DefaultMaxZoom
                                                                                                            }):Play();

                                                                                                            if u32.ActionAnim then
                                                                                                                u32.ActionAnim:Stop();
                                                                                                                u32.ActionAnim = GameManager:getAnimation("AkimichiLand", Humanoid);
                                                                                                                u32.ActionAnim:Play();
                                                                                                            end;
                                                                                                        end;
                                                                                                    else
                                                                                                        if p503 == "ShisuiFlicker" then
                                                                                                            if p506 == "Charming Shisui" then
                                                                                                                require(ReplicatedStorage.Effects.LoveShisuiFlicker.EffectsModule).StartVFX(u504.PrimaryPart, u505);

                                                                                                                return;
                                                                                                            end;

                                                                                                            require(ReplicatedStorage.Effects.ShisuiFlicker.EffectsModule).StartVFX(u504.PrimaryPart, u505);

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "addMarker" then
                                                                                                            local v765 = ReplicatedStorage.UI.MissionMarker:Clone();
                                                                                                            v765.Adornee = u504;
                                                                                                            v765.Enabled = true;
                                                                                                            v765.TextLabel.TextColor3 = u505 or v765.TextLabel.TextColor3;
                                                                                                            v765.Parent = u504;

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "impactFrames" then
                                                                                                            local v766 = u504 or Color3.fromRGB(255, 255, 255);
                                                                                                            local v767 = u505 or Color3.fromRGB(255, 255, 255);
                                                                                                            local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", game.Lighting);
                                                                                                            ColorCorrectionEffect.Parent = game.Lighting;
                                                                                                            task.delay(5, ColorCorrectionEffect.Destroy, ColorCorrectionEffect);
                                                                                                            ColorCorrectionEffect.Contrast = -100;
                                                                                                            ColorCorrectionEffect.Saturation = -1.2;
                                                                                                            ColorCorrectionEffect.TintColor = v766;
                                                                                                            task.wait(0.05);
                                                                                                            ColorCorrectionEffect.Brightness = 10;
                                                                                                            ColorCorrectionEffect.Contrast = 100;
                                                                                                            ColorCorrectionEffect.Saturation = -1.2;
                                                                                                            ColorCorrectionEffect.TintColor = v767;
                                                                                                            task.wait(0.05);
                                                                                                            ColorCorrectionEffect:Destroy();

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Lariat_Windup" then
                                                                                                            local v768 = game.ReplicatedStorage.Effects.Lariat.Windup:Clone();
                                                                                                            v768.Anchored = false;
                                                                                                            v768.Massless = true;
                                                                                                            v768.Parent = u504;
                                                                                                            local Weld = Instance.new("Weld");
                                                                                                            Weld.Part0 = u504.Torso;
                                                                                                            Weld.Part1 = v768;
                                                                                                            Weld.Parent = v768;
                                                                                                            Emit(v768);
                                                                                                            Debris:AddItem(v768, 3);
                                                                                                            local v769 = game.ReplicatedStorage.Effects.Lariat.Lightning1:Clone();
                                                                                                            v769.Anchored = false;
                                                                                                            v769.Massless = true;
                                                                                                            v769.Parent = u504;
                                                                                                            local Weld2 = Instance.new("Weld");
                                                                                                            Weld2.Part0 = u504.Torso;
                                                                                                            Weld2.Part1 = v769;
                                                                                                            Weld2.Parent = v769;
                                                                                                            Debris:AddItem(v769, 3);
                                                                                                            u4.init();
                                                                                                            u4.emit(v769);

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Lariat_Dash" then
                                                                                                            local v770 = game.ReplicatedStorage.Effects.Lariat.Dust:Clone();
                                                                                                            v770:PivotTo(u504 * CFrame.new(0, -2, 0) * CFrame.Angles(-1.5707963267948966, 0, 0));
                                                                                                            v770.Parent = workspace.Debris;
                                                                                                            Emit(v770);
                                                                                                            Debris:AddItem(v770, 3);
                                                                                                            local v771 = game.ReplicatedStorage.Effects.Lariat.Dash:Clone();
                                                                                                            v771:PivotTo(u504 * CFrame.Angles(-1.5707963267948966, 0, 0));
                                                                                                            v771.Parent = workspace.Debris;
                                                                                                            Emit(v771);
                                                                                                            Debris:AddItem(v771, 3);

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Lariat_Grab" then
                                                                                                            local v772 = game.ReplicatedStorage.Effects.Lariat.Lightning2:Clone();
                                                                                                            v772:PivotTo(u504);
                                                                                                            v772.Parent = workspace.Debris;
                                                                                                            Debris:AddItem(v772, 3);
                                                                                                            u4.init();
                                                                                                            u4.emit(v772);

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Lariat_Explode" then
                                                                                                            local v773 = game.ReplicatedStorage.Effects.Lariat.Explosion:Clone();
                                                                                                            v773:PivotTo(u504);
                                                                                                            v773.Parent = workspace.Debris;
                                                                                                            Emit(v773);
                                                                                                            Debris:AddItem(v773, 5);

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Isobu_Pillar" then
                                                                                                            local v774 = game.ReplicatedStorage.Effects.Isobu[p503]:Clone();
                                                                                                            v774:PivotTo(u504);
                                                                                                            v774.Parent = workspace.Debris;
                                                                                                            Emit(v774);
                                                                                                            Debris:AddItem(v774, 3);
                                                                                                            local v775 = GameManager:playTempSound(ReplicatedStorage.LocalSounds.WaterExplode:Clone(), v774);
                                                                                                            v775.Volume = 1.7;
                                                                                                            v775.RollOffMaxDistance = 800;
                                                                                                            v775.RollOffMinDistance = 30;

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Isobu_Dive_Movement" then
                                                                                                            local HumanoidRootPart2 = u504:WaitForChild("HumanoidRootPart");
                                                                                                            local Position = workspace.TB_Spawns.Isobu.Position;
                                                                                                            local u776 = true;
                                                                                                            local u777 = u504:GetAttribute("OrbitAngle") or 0;
                                                                                                            local u778 = u504:GetAttribute("OrbitSpeed") or 2;
                                                                                                            local u779 = nil;
                                                                                                            local u780 = nil;
                                                                                                            local u781 = 0;
                                                                                                            local u782 = false;
                                                                                                            local u783 = 0;
                                                                                                            local u784 = nil;
                                                                                                            local u785 = false;
                                                                                                            local u786 = nil;
                                                                                                            u786 = game:GetService("RunService").Heartbeat:Connect(function(p787) -- Line: 12523
                                                                                                                -- upvalues: u504 (copy), u786 (ref), u776 (ref), u778 (ref), HumanoidRootPart2 (copy), Position (copy), u779 (ref), u780 (ref), u781 (ref), u785 (ref), u782 (ref), u783 (ref), u784 (ref), u777 (ref)
                                                                                                                if not u504:GetAttribute("Diving") then
                                                                                                                    u786:Disconnect();
                                                                                                                    u786 = nil;

                                                                                                                    return;
                                                                                                                end;

                                                                                                                u776 = u504:GetAttribute("Clockwise") or u776;
                                                                                                                u778 = u504:GetAttribute("OrbitSpeed") or u778;

                                                                                                                if u504:GetAttribute("OnOrbit") then
                                                                                                                    u779 = nil;
                                                                                                                    u780 = nil;
                                                                                                                    u781 = 0;

                                                                                                                    if not u785 then
                                                                                                                        u782 = true;
                                                                                                                        u783 = 0;
                                                                                                                        u784 = HumanoidRootPart2.CFrame;
                                                                                                                        u785 = true;
                                                                                                                    end;

                                                                                                                    u777 = u777 + (u776 and 1 or -1) * u778 * p787;
                                                                                                                    local v788 = u504:GetAttribute("OrbitAngle") or u777;

                                                                                                                    if math.abs(u777 - v788) > 0.1 then
                                                                                                                        u777 = v788;
                                                                                                                    end;

                                                                                                                    local v789 = math.cos(u777);
                                                                                                                    local v790 = math.sin(u777);
                                                                                                                    local v791 = Position + Vector3.new(v789 * 90, 0, v790 * 90);
                                                                                                                    local v792 = Vector3.new(-v790, 0, v789);
                                                                                                                    local v793 = CFrame.lookAt(v791, v791 + v792 * (u776 and 1 or -1));

                                                                                                                    if u782 then
                                                                                                                        u783 = u783 + p787;
                                                                                                                        local v794 = math.clamp(u783 / 0.3, 0, 1);
                                                                                                                        HumanoidRootPart2.CFrame = u784:Lerp(v793, v794);

                                                                                                                        if v794 >= 1 then
                                                                                                                            u782 = false;
                                                                                                                        end;
                                                                                                                    else
                                                                                                                        HumanoidRootPart2.CFrame = v793;
                                                                                                                    end;
                                                                                                                else
                                                                                                                    local v795 = HumanoidRootPart2.Position - Position;
                                                                                                                    local v796 = Vector3.new(v795.X, 0, v795.Z);

                                                                                                                    if v796.Magnitude > 0 then
                                                                                                                        local v797 = math.atan2(v796.Z, v796.X);
                                                                                                                        local v798 = math.cos(v797);
                                                                                                                        local v799 = math.sin(v797);
                                                                                                                        local v800 = Position + Vector3.new(v798, 0, v799) * 90;

                                                                                                                        if u779 == nil then
                                                                                                                            u779 = HumanoidRootPart2.Position;
                                                                                                                            u780 = v800;
                                                                                                                            u781 = 0;
                                                                                                                        end;

                                                                                                                        u781 = u781 + p787;
                                                                                                                        local v801 = u779:Lerp(u780, (math.min(1, u781 * 90 / (u780 - u779).Magnitude)));
                                                                                                                        HumanoidRootPart2.CFrame = CFrame.lookAt(v801, v801 + (u780 - u779).Unit);
                                                                                                                    end;
                                                                                                                end;
                                                                                                            end);

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Isobu_Spit_Explode" then
                                                                                                            local v802 = ReplicatedStorage.Effects.Isobu.Isobu_Pillar:Clone();
                                                                                                            v802:PivotTo(CFrame.new(u504));
                                                                                                            v802:ScaleTo(u505 or v802:GetScale());
                                                                                                            v802.Parent = workspace.Debris;
                                                                                                            Emit(v802);
                                                                                                            Debris:AddItem(v802, 5);

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "Mini_Isobu_Hit" then
                                                                                                            u504:Destroy();

                                                                                                            return;
                                                                                                        end;

                                                                                                        if p503 == "tweenParticleSize" then
                                                                                                            if u504:IsA("Model") or (u504:IsA("BasePart") or u504:IsA("Folder")) then
                                                                                                                for _, descendant in u504:GetDescendants() do
                                                                                                                    if descendant:IsA("ParticleEmitter") then
                                                                                                                        GameManager:tweenParticleSize(descendant, u505, p506, p507, p508);
                                                                                                                    end;
                                                                                                                end;

                                                                                                                return;
                                                                                                            end;

                                                                                                            if u504:IsA("ParticleEmitter") then
                                                                                                                GameManager:tweenParticleSize(u504, u505, p506, p507, p508);
                                                                                                            end;
                                                                                                        else
                                                                                                            if p503 == "Isobu Bash" then
                                                                                                                require(ReplicatedStorage.Effects.Isobu.IsobuBash.EffectsModule).StartVFX(u504, u505, p506);

                                                                                                                return;
                                                                                                            end;

                                                                                                            if p503 == "tweenModelScale" then
                                                                                                                GameManager:tweenModelScale(u504, TweenInfo.new(table.unpack(u505)), p506);

                                                                                                                return;
                                                                                                            end;

                                                                                                            if p503 == "IsobuShockVFX" then
                                                                                                                local v803 = ReplicatedStorage.Effects.Isobu.IsobuShockVFX:Clone();
                                                                                                                v803.Position = u504;
                                                                                                                v803.Parent = workspace.Debris;
                                                                                                                Emit(v803);
                                                                                                                Debris:AddItem(v803, 5);

                                                                                                                return;
                                                                                                            end;

                                                                                                            if p503 == "Coral Emerge" then
                                                                                                                require(game.ReplicatedStorage.Effects.Isobu.CoralEmerge.EffectsModule).StartVFX(u504, u505);
                                                                                                            end;
                                                                                                        end;
                                                                                                    end;
                                                                                                end;
                                                                                            end;
                                                                                        end;
                                                                                    end;
                                                                                end;
                                                                            end;
                                                                        end;
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end);

for _, child in KotoamatsukamiCommands.ScrollingFrame:GetChildren() do
    if child:IsA("ImageButton") then
        child.MouseButton1Down:Connect(function() -- Line: 12654
            -- upvalues: child (copy)
            activateSkill(nil, "Kotoamatsukami " .. child.Name);
        end);
    end;
end;

for _, v in u11.Rifts do
    local v804 = GameManager:getRift(v);

    if v804 then
        v804:Destroy();
    end;
end;

for _, child in workspace.Debris:GetChildren() do
    if child.Name == "MissionLocation" then
        child.BillboardGui.Enabled = false;
    end;
end;

if u11.Blindness ~= 0 then
    local v805 = ReplicatedStorage.UI.BasicOverlay:Clone();
    v805.ImageTransparency = 1 - u11.Blindness / 100;
    v805.ImageColor3 = Color3.new(0, 0, 0);
    v805.Parent = script.Parent;
    v805.Name = "Blindness1";
    local v806 = ReplicatedStorage.UI.FullOverlay:Clone();
    v806.ImageTransparency = 1 - u11.Blindness / 100;
    v806.Parent = script.Parent;
    v806.Name = "Blindness2";
end;

CurrentCamera.CameraSubject = Humanoid;
UserInputService.InputBegan:Connect(onKeyDown);
UserInputService.InputEnded:Connect(onKeyUp);
RiftFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 12691
    -- upvalues: RiftFrame (copy), StarterGui (copy)
    if not RiftFrame.Visible then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true);

        return;
    end;

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
    RiftFrame.TextBox.Text = "";
end);

if u32.moderator ~= false then
    ModPanel.UnderPanelFade.PointsAmount.Text = "Points : " .. u11.ModPoints;
    ModPanel.MoveRight.MouseButton1Down:Connect(function() -- Line: 12708
        -- upvalues: u6 (ref), TweenService (copy), ModPanel (copy)
        u6.ButtonSelect:Play();
        TweenService:Create(ModPanel, TweenInfo.new(0.25), {
            Position = UDim2.new(ModPanel.Position.X.Scale + 0.1, 0, 0.5, 0)
        }):Play();
    end);
    ModPanel.MoveLeft.MouseButton1Down:Connect(function() -- Line: 12712
        -- upvalues: u6 (ref), TweenService (copy), ModPanel (copy)
        u6.ButtonSelect:Play();
        TweenService:Create(ModPanel, TweenInfo.new(0.25), {
            Position = UDim2.new(ModPanel.Position.X.Scale - 0.1, 0, 0.5, 0)
        }):Play();
    end);

    local function modPageSwitch() -- Line: 12717
        -- upvalues: ModPanel (copy), TweenService (copy), u6 (ref)
        ModPanel.PageCover.BackgroundTransparency = 0;
        TweenService:Create(ModPanel.PageCover, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play();
        u6.MainButtonClick:Play();
    end;

    u32.CommandsButton.MouseEnter:Connect(function() -- Line: 12723
        -- upvalues: u6 (ref)
        u6.ButtonHover:Play();
    end);
    u32.CommandsButton.MouseButton1Down:Connect(function() -- Line: 12727
        -- upvalues: u32 (copy), ModPanel (copy), modPageSwitch (copy)
        u32.ModPage = "Commands";
        u32.CommandsButton.TextStrokeTransparency = 0;
        u32.ShopButton.TextStrokeTransparency = 1;
        u32.ScrollCommands.Visible = true;
        u32.ScrollShop.Visible = false;
        ModPanel.SecondaryInput.Visible = true;

        for _, child in ipairs(ModPanel.ScrollCommands:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextStrokeTransparency = 1;
                child.Text = child.Name;
            end;
        end;

        modPageSwitch();
    end);
    u32.ShopButton.MouseEnter:Connect(function() -- Line: 12746
        -- upvalues: u6 (ref)
        u6.ButtonHover:Play();
    end);
    u32.ShopButton.MouseButton1Down:Connect(function() -- Line: 12750
        -- upvalues: u32 (copy), ModPanel (copy), modPageSwitch (copy)
        u32.ModPage = "Shop";
        u32.ShopButton.TextStrokeTransparency = 0;
        u32.CommandsButton.TextStrokeTransparency = 1;
        u32.ScrollShop.Visible = true;
        u32.ScrollCommands.Visible = false;
        ModPanel.SecondaryInput.Visible = false;

        for _, child in ipairs(ModPanel.ScrollShop:GetChildren()) do
            if child:IsA("TextButton") then
                child.RewardName.TextStrokeTransparency = 1;
                child.RewardName.Text = child.Name;
                child.Cost.TextStrokeTransparency = 1;
                child.Text = "";
            end;
        end;

        modPageSwitch();
    end);

    local function checkInteractions(u807) -- Line: 12772
        -- upvalues: u6 (ref), u32 (copy), DataEvent (copy), ModPanel (copy), TweenService (copy)
        u807.MouseEnter:Connect(function() -- Line: 12773
            -- upvalues: u6 (ref)
            u6.ButtonHover:Play();
        end);
        u807.MouseButton1Down:Connect(function() -- Line: 12776
            -- upvalues: u807 (copy), u32 (ref), u6 (ref), DataEvent (ref), ModPanel (ref), TweenService (ref)
            if u807.Parent.Name == "ScrollCommands" and u807.TextStrokeTransparency == 0 then
                local v808;

                if u32.moderator == "Dev" or (u32.moderator == "Admin" or (u32.Name == "maxy1221648" or u32.moderatorCooldown ~= true)) then
                    v808 = true;
                else
                    newNotification("Commands on cooldown.");
                    v808 = false;
                end;

                if v808 == true then
                    u807.TextStrokeTransparency = 1;
                    u807.Text = u807.Name;
                    u6.HighPitchButtonSelect:Play();
                    DataEvent:FireServer("ModCommand", u807.Name, ModPanel.PrimaryInput.Text, ModPanel.SecondaryInput.Text);
                    u807.BackgroundTransparency = 0;
                    TweenService:Create(u807, TweenInfo.new(0.75), {
                        BackgroundTransparency = 1
                    }):Play();
                    u32.moderatorCooldown = true;
                    task.delay(5, function() -- Line: 12801
                        -- upvalues: u32 (ref)
                        u32.moderatorCooldown = false;
                    end);
                end;
            else
                if u807.Parent.Name == "ScrollShop" and u807.RewardName.TextStrokeTransparency == 0 then
                    u807.RewardName.TextStrokeTransparency = 1;
                    u807.RewardName.Text = u807.Name;
                    u807.Cost.TextStrokeTransparency = 1;
                    u6.HighPitchButtonSelect:Play();
                    DataEvent:FireServer("ModCommand", "ExchangingPoints", u807.Name, ModPanel.PrimaryInput.Text);
                    u807.BackgroundTransparency = 0;
                    TweenService:Create(u807, TweenInfo.new(0.75), {
                        BackgroundTransparency = 1
                    }):Play();

                    return;
                end;

                for _, child in ipairs(ModPanel.ScrollCommands:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.TextStrokeTransparency = 1;
                        child.Text = child.Name;
                    end;
                end;

                for _, child in ipairs(ModPanel.ScrollShop:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.RewardName.TextStrokeTransparency = 1;
                        child.RewardName.Text = child.Name;
                        child.Cost.TextStrokeTransparency = 1;
                    end;
                end;

                if u807.Parent.Name == "ScrollShop" then
                    u807.RewardName.TextStrokeTransparency = 0;
                    u807.Cost.TextStrokeTransparency = 0;
                    u807.RewardName.Text = ">> " .. u807.Name .. " <<";
                else
                    u807.TextStrokeTransparency = 0;
                    u807.Text = ">> " .. u807.Name .. " <<";
                end;

                u6.ButtonSelect:Play();
            end;
        end);
    end;

    for _, child in ipairs(ModPanel.ScrollCommands:GetChildren()) do
        if child:IsA("TextButton") then
            if child.Name == "Restore" then
                checkInteractions(child);
            elseif (u32.moderator == "Mod" or (u32.moderator == "SeniorMod" or (u32.moderator == "Admin" or u32.moderator == "Dev"))) and (child.Name == "Ban" or (child.Name == "Unban" or (child.Name == "Exile" or child.Name == "Observe"))) then
                checkInteractions(child);
            elseif (u32.moderator == "SeniorMod" or (u32.moderator == "Admin" or u32.moderator == "Dev")) and child.Name == "Restore Item" then
                checkInteractions(child);
            elseif u32.moderator == "Dev" or u32.moderator == "Admin" then
                checkInteractions(child);
            else
                child:Destroy();
            end;
        end;
    end;

    print("Moderator level : " .. u32.moderator);
    local v809 = DataFunction:InvokeServer("ModShopData");

    for i = 1, 100 do
        if v809[tostring(i)] then
            local v810 = ModPanel.ItemButtonClone:Clone();
            local v811 = ModPanel.CloneLine:Clone();
            v810.RewardName.Text = v809[tostring(i)].Name;
            v810.Cost.Text = v809[tostring(i)].Points;
            v810.LayoutOrder = i;
            v811.LayoutOrder = i;
            v810.Parent = ModPanel.ScrollShop;
            v811.Parent = ModPanel.ScrollShop;
            v810.Visible = true;
            v811.Visible = true;
            v810.Name = v809[tostring(i)].Name;
            v810.Text = "";
        end;
    end;

    for _, child in ipairs(ModPanel.ScrollShop:GetChildren()) do
        if child:IsA("TextButton") and (u32.moderator == "JMod" or (u32.moderator == "Mod" or (u32.moderator == "SeniorMod" or (u32.moderator == "Admin" or u32.moderator == "Dev")))) then
            checkInteractions(child);
        end;
    end;
end;

EmoteFrame:WaitForChild("TitleFrame").MouseButton1Down:Connect(function() -- Line: 12899
    -- upvalues: EmoteFrame (copy), u32 (copy), u6 (ref)
    EmoteFrame.TitleFrame.SwitchButton.Text = ">> View " .. u32.EmoteFramePage .. " <<";

    if u32.EmoteFramePage == "Emotes" then
        u32.EmoteFramePage = "Commands";
        EmoteFrame.ScrollCommands.Visible = true;
        EmoteFrame.ScrollingFrame.Visible = false;
    else
        u32.EmoteFramePage = "Emotes";
        EmoteFrame.ScrollingFrame.Visible = true;
        EmoteFrame.ScrollCommands.Visible = false;
    end;

    EmoteFrame.TitleFrame.PageTitle.Text = u32.EmoteFramePage;
    u6.ButtonSelect:Play();
end);

for _, child in ipairs(EmoteFrame.ScrollCommands:GetChildren()) do
    if child:IsA("ImageButton") then
        child.MouseButton1Down:Connect(function() -- Line: 12916
            -- upvalues: u6 (ref), u32 (copy), child (copy), u11 (ref), MainMenuFrame (copy), u13 (ref), DataEvent (copy)
            u6.ButtonSelect:Play();

            if u32.commandCooldown ~= os.time() then
                u32.commandCooldown = os.time();

                if child.Name == "streamermode" then
                    if u11.StreamerMode == true then
                        MainMenuFrame:WaitForChild("ServerName").Text = "Server Name : " .. u13;
                        u11.StreamerMode = false;
                        u32.streamermode.Value = false;
                    else
                        MainMenuFrame:WaitForChild("ServerName").Text = "Server Name : XXXXXXX";
                        u11.StreamerMode = true;
                        u32.streamermode.Value = true;
                    end;
                end;

                DataEvent:FireServer("ChatCommand", child.Name);
            end;
        end);
    end;
end;

if u11.StreamerMode == true then
    MainMenuFrame:WaitForChild("ServerName").Text = "Server Name : XXXXXXX";
else
    MainMenuFrame:WaitForChild("ServerName").Text = "Server Name : " .. u13;
end;

u32.streamermode.Value = u11.StreamerMode;
UserInputService.InputBegan:Connect(function(p812, p813) -- Line: 12944
    -- upvalues: u32 (copy), EmoteFrame (copy), ModPanel (copy), u6 (ref), RiftFrame (copy)
    if p813 then
        return;
    end;

    if p812.KeyCode == Enum.KeyCode.K or p812.KeyCode == Enum.KeyCode.ButtonL3 then
        u32.emoteFrameVisible = not u32.emoteFrameVisible;
        EmoteFrame.Visible = u32.emoteFrameVisible;
    end;

    if p812.KeyCode == Enum.KeyCode.J and u32.moderator ~= false then
        u32.modPanelVisible = not u32.modPanelVisible;
        ModPanel.Visible = u32.modPanelVisible;
        u6.MenuInteract:Play();

        for _, child in ipairs(ModPanel.ScrollCommands:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextStrokeTransparency = 1;
                child.Text = child.Name;
            end;
        end;

        for _, child in ipairs(ModPanel.ScrollShop:GetChildren()) do
            if child:IsA("TextButton") then
                child.RewardName.TextStrokeTransparency = 1;
                child.RewardName.Text = child.Name;
                child.Cost.TextStrokeTransparency = 1;
            end;
        end;
    end;

    if p812.KeyCode == Enum.KeyCode.Slash and RiftFrame.Visible then
        RiftFrame.TextBox:CaptureFocus();
        task.wait();
        RiftFrame.TextBox.Text = "";
    end;
end);

function updateEmotes()
    -- upvalues: EmoteFrame (copy), GameManager (copy), MarketplaceService (copy), LocalPlayer (copy), u32 (copy), Humanoid (copy), HumanoidRootPart (copy), DataEvent (copy)
    for _, child in EmoteFrame.ScrollingFrame:GetChildren() do
        if child.ClassName == EmoteFrame.Emote.ClassName then
            child:Destroy();
        end;
    end;

    for i, v in GameManager.Emotes do
        local v814 = EmoteFrame.Emote:Clone();
        v814.Name = i;
        v814.ButtonText.Text = i;
        v814.Visible = true;
        v814.LayoutOrder = v.Order;
        v814.Parent = EmoteFrame.ScrollingFrame;

        if v.Free == true or MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, 27702705) then
            v814.MouseButton1Down:Connect(function() -- Line: 12999
                -- upvalues: u32 (ref), EmoteFrame (ref), GameManager (ref), Humanoid (ref), i (copy), HumanoidRootPart (ref), DataEvent (ref)
                if u32.Knocked then
                    return;
                end;

                if u32.InDanger then
                    return;
                end;

                EmoteFrame.Visible = false;

                if u32.CurrentEmote then
                    GameManager:stopAnimation(u32.CurrentEmote, Humanoid);
                end;

                u32.CurrentEmote = i;
                u32.EmotePosition = HumanoidRootPart.Position;
                GameManager:getAnimation(u32.CurrentEmote, Humanoid, Enum.AnimationPriority.Action3):Play();

                if i == "meditate" then
                    DataEvent:FireServer("meditate");
                end;
            end);
        else
            v814.ImageLabel.Visible = true;
            v814.MouseButton1Down:Connect(function() -- Line: 13019
                -- upvalues: EmoteFrame (ref), LocalPlayer (ref)
                EmoteFrame.Visible = false;
                game:GetService("MarketplaceService"):PromptGamePassPurchase(LocalPlayer, 27702705);
            end);
        end;
    end;
end;

task.spawn(function() -- Line: 13027
    updateEmotes();
end);

function updateTraitFrame()
    -- upvalues: TraitFrame (copy), u11 (ref), DataEvent (copy)
    for _, child in TraitFrame.ScrollingFrame:GetChildren() do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    for _, v in u11.Traits do
        local v815 = TraitFrame.Trait:Clone();
        v815.ButtonText.Text = v;
        v815.Visible = true;
        v815.Parent = TraitFrame.ScrollingFrame;
        v815.MouseButton1Down:Connect(function() -- Line: 13044
            -- upvalues: DataEvent (ref), v (copy), TraitFrame (ref)
            DataEvent:FireServer("RollTrait", v);
            TraitFrame.Visible = false;
        end);
    end;
end;

updateTraitFrame();
RiftFrame.TextBox.FocusLost:Connect(function(p816) -- Line: 13053
    -- upvalues: DataEvent (copy), RiftFrame (copy)
    if not p816 then
        return;
    end;

    DataEvent:FireServer("Rift", RiftFrame.TextBox.Text);
    RiftFrame.Visible = false;
end);
game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(function(p817, p818, p819) -- Line: 13061
    if p818 == 27702705 and p819 then
        updateEmotes();
    end;
end);

local function bindToMouse() -- Line: 13067
    -- upvalues: u32 (copy), u1 (copy)
    u32.Dragging.Position = UDim2.new(0, u1.X + u32.diffx, 0, u1.Y + u32.diffy);

    if u32.Dragging.Position ~= u32.originalSlotPosition then
        u32.Dragging.ZIndex = 11;
    end;
end;

for _, child in ipairs(LeftFrame:GetChildren()) do
    if child.ClassName == "TextButton" then
        child.MouseButton1Down:Connect(function() -- Line: 13076
            -- upvalues: child (copy), GameManager (copy), RightFrame (copy)
            if child.Text ~= "" then
                local v820 = child.Text:sub(3);

                if GameManager.Traits[v820] then
                    RightFrame.ItemName.Text = v820;
                    RightFrame.ItemDescription.Text = "<i>" .. GameManager.Traits[v820].Description .. "</i>";

                    return;
                end;

                if GameManager.Flaws[v820] then
                    RightFrame.ItemName.Text = v820;
                    RightFrame.ItemDescription.Text = "<i>" .. GameManager.Flaws[v820].Description .. "</i>";

                    return;
                end;

                if GameManager.Clothing[child.Text] then
                    RightFrame.ItemName.Text = child.Text;
                    RightFrame.ItemDescription.Text = "<i>" .. GameManager.Clothing[child.Text].Description .. "</i>";
                end;
            end;
        end);
    end;
end;

for _, child in ipairs(Loadout:GetChildren()) do
    if string.match(child.Name, "Slot") == "Slot" then
        child.MouseButton1Down:connect(function() -- Line: 13096
            -- upvalues: u32 (copy), child (copy), Inventory (copy), GameManager (copy), u11 (ref), u1 (copy), RunService (copy), bindToMouse (copy)
            if u32.Settings.MeleeCooldown.Value == false then
                u32.Selected = child.SlotText.Text;

                if child.SlotText.Text ~= "" and (Inventory.Visible == true and u32.holding == 0) then
                    u32.oldInfo = child.SlotText.Text;
                    u32.oldQuantity = tonumber(child.ItemNumber.Number.Text:sub(2));
                    u32.oldItemData = u32.Loadout[child.SlotNum.Value].Data;
                    child.Image = "";
                    child.BackgroundTransparency = 1;
                    u32.holding = child.Name;
                    u32.prevHoldingSlot = child;
                    child.SlotText.Visible = false;
                    u32.Dragging.Visible = true;
                    u32.Dragging.SlotText.Text = child.SlotText.Text;

                    if child.ItemNumber.Visible == true then
                        u32.Dragging.ItemNumber.Visible = true;
                        u32.Dragging.ItemNumber.Number.Text = child.ItemNumber.Number.Text;
                        child.ItemNumber.Visible = false;
                        print("Item Number was visible on original icon");
                    else
                        u32.Dragging.ItemNumber.Visible = false;
                    end;

                    local v821 = GameManager:getImageId(u32.oldInfo);

                    if u11.ItemDisplayType == "Icon" and v821 ~= "" then
                        u32.Dragging.Image = "rbxassetid://" .. v821;
                        u32.Dragging.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                        u32.Dragging.SlotText.TextTransparency = 1;
                    else
                        u32.Dragging.Image = "";
                        u32.Dragging.SlotText.TextTransparency = 0;
                    end;

                    local Y = u1.Y;
                    u32.diffx = child.AbsolutePosition.X - u1.X;
                    u32.diffy = child.AbsolutePosition.Y - Y;
                    u32.originalSlotPosition = UDim2.new(0, u1.X + u32.diffx, 0, u1.Y + u32.diffy);
                    RunService:BindToRenderStep("slotdrag", Enum.RenderPriority.Camera.Value, bindToMouse);
                end;
            end;
        end);
        child.MouseButton1Up:connect(function() -- Line: 13142
            -- upvalues: u32 (copy), Loadout (copy), child (copy), GameManager (copy), u11 (ref), UpdateLoadout (copy), UpdateInventory (copy), slotDown (copy), RunService (copy)
            if u32.prevHoldingSlot == 0 or (u32.prevHoldingSlot.Parent ~= Loadout or (child.SlotText.Text ~= u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Item or child.SlotText.Text == "" and u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Item == "")) then
                if child.SlotText.Text == "" or not u32.oldInfo then
                    if u32.oldInfo then
                        u32.Loadout[child.SlotNum.Value].Item = u32.oldInfo;
                        u32.Loadout[child.SlotNum.Value].Quantity = u32.oldQuantity;
                        u32.Loadout[child.SlotNum.Value].Data = u32.oldItemData;

                        if u32.prevHoldingSlot.Parent == Loadout then
                            u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Item = "";
                            u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Quantity = 1;
                            u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Data = {};
                            u32.prevHoldingSlot.SlotBorder.Visible = true;
                            u32.prevHoldingSlot.SlotText.Text = "";
                            u32.prevHoldingSlot.Image = "";
                            u32.prevHoldingSlot.SlotText.Visible = false;
                            u32.prevHoldingSlot.ItemNumber.Visible = false;
                            UpdateLoadout("Inventory");
                        else
                            u32.Inventory[tostring(u32.prevHoldingSlot.SlotNum.Value)].Item = "";
                            u32.Inventory[tostring(u32.prevHoldingSlot.SlotNum.Value)].Quantity = 1;
                            u32.Inventory[tostring(u32.prevHoldingSlot.SlotNum.Value)].Data = {};
                            UpdateInventory();
                        end;

                        child.SlotText.Visible = true;
                        child.SlotText.Text = u32.oldInfo;
                        child.BackgroundTransparency = 0;

                        if u32.Dragging.ItemNumber.Visible == true then
                            child.ItemNumber.Visible = true;
                            child.ItemNumber.Number.Text = u32.Dragging.ItemNumber.Number.Text;
                        else
                            child.ItemNumber.Visible = false;
                        end;

                        local v822 = GameManager:getImageId(u32.oldInfo);

                        if u11.ItemDisplayType == "Icon" and v822 ~= "" then
                            child.Image = "rbxassetid://" .. v822;
                            child.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                            child.SlotText.TextTransparency = 1;
                        else
                            child.Image = "";
                            child.SlotText.TextTransparency = 0;
                        end;
                    end;
                else
                    local Text = child.SlotText.Text;
                    local v823 = tonumber(child.ItemNumber.Number.Text:sub(2));
                    local v824;

                    if child.Parent == Loadout then
                        v824 = u32.Loadout[child.SlotNum.Value].Data;
                    else
                        v824 = u32.Inventory[child.SlotNum.Value].Data;
                    end;

                    child.SlotText.Text = u32.oldInfo;
                    child.SlotText.Visible = true;
                    child.SlotBorder.Visible = true;
                    child.BackgroundTransparency = 0;
                    u32.Loadout[child.SlotNum.Value].Item = u32.oldInfo;
                    u32.Loadout[child.SlotNum.Value].Quantity = u32.oldQuantity;
                    u32.Loadout[child.SlotNum.Value].Data = u32.oldItemData;
                    u32.prevHoldingSlot.SlotText.Text = Text;
                    u32.prevHoldingSlot.BackgroundTransparency = 0;
                    u32.prevHoldingSlot.SlotText.Visible = true;
                    u32.prevHoldingSlot.SlotBorder.Visible = true;

                    if child.ItemNumber.Visible == true then
                        u32.prevHoldingSlot.ItemNumber.Visible = true;
                        u32.prevHoldingSlot.ItemNumber.Number.Text = child.ItemNumber.Number.Text;
                    end;

                    if u32.Dragging.ItemNumber.Visible == true then
                        child.ItemNumber.Visible = true;
                        child.ItemNumber.Number.Text = u32.Dragging.ItemNumber.Number.Text;
                    else
                        child.ItemNumber.Visible = false;
                    end;

                    local v825 = GameManager:getImageId(Text);

                    if u11.ItemDisplayType == "Icon" and v825 ~= "" then
                        u32.prevHoldingSlot.Image = "rbxassetid://" .. v825;
                        u32.prevHoldingSlot.ImageColor3 = GameManager:getImageColor(Text);
                        u32.prevHoldingSlot.SlotText.TextTransparency = 1;
                    else
                        u32.prevHoldingSlot.SlotText.TextTransparency = 0;
                        u32.prevHoldingSlot.Image = "";
                    end;

                    local v826 = GameManager:getImageId(u32.oldInfo);

                    if u11.ItemDisplayType == "Icon" and v826 ~= "" then
                        child.Image = "rbxassetid://" .. v826;
                        child.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                        child.SlotText.TextTransparency = 1;
                    else
                        child.SlotText.TextTransparency = 0;
                        child.Image = "";
                    end;

                    if u32.prevHoldingSlot.Parent == Loadout then
                        u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Item = Text;
                        u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Quantity = v823;
                        u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Data = v824;
                        UpdateLoadout("Inventory");
                    else
                        u32.Inventory[u32.prevHoldingSlot.SlotNum.Value].Item = Text;
                        u32.Inventory[u32.prevHoldingSlot.SlotNum.Value].Quantity = v823;
                        u32.Inventory[u32.prevHoldingSlot.SlotNum.Value].Data = v824;
                        UpdateInventory();
                    end;
                end;
            else
                child.Visible = true;
                child.BackgroundTransparency = 0;
                child.SlotBorder.Visible = true;
                child.SlotText.Text = u32.Dragging.SlotText.Text;
                child.SlotText.Visible = true;

                if u32.Dragging.ItemNumber.Visible == true then
                    child.ItemNumber.Visible = true;
                    child.ItemNumber.Number.Text = u32.Dragging.ItemNumber.Number.Text;
                else
                    child.ItemNumber.Visible = false;
                end;

                local v827 = GameManager:getImageId(u32.oldInfo);

                if u11.ItemDisplayType == "Icon" and v827 ~= "" then
                    child.Image = "rbxassetid://" .. v827;
                    child.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                    u32.Dragging.Image = "rbxassetid://" .. v827;
                    u32.Dragging.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                    u32.Dragging.SlotText.TextTransparency = 1;
                else
                    u32.Dragging.SlotText.TextTransparency = 0;
                    u32.Dragging.Image = "";
                end;
            end;

            if u32.Selected == child.SlotText.Text then
                slotDown(child.Name);
            end;

            u32.Dragging.Visible = false;
            u32.Dragging.ItemNumber.Visible = false;
            u32.Dragging.ZIndex = 9;
            u32.oldInfo = nil;
            u32.oldQuantity = nil;
            u32.oldItemData = nil;
            u32.holding = 0;
            u32.prevHoldingSlot = 0;
            RunService:UnbindFromRenderStep("slotdrag");
        end);
    end;
end;

for _, child in ipairs(InventoryScroll:GetChildren()) do
    if string.match(child.Name, "Slot") == "Slot" then
        child.MouseButton1Down:connect(function() -- Line: 13298
            -- upvalues: u32 (copy), child (copy), Inventory (copy), GameManager (copy), u11 (ref), u1 (copy), RunService (copy), bindToMouse (copy)
            if u32.Settings.MeleeCooldown.Value == false and (child.SlotText.Text ~= "" and (Inventory.Visible == true and u32.holding == 0)) then
                u32.oldInfo = child.SlotText.Text;
                u32.oldQuantity = tonumber(child.ItemNumber.Number.Text:sub(2));
                u32.oldItemData = u32.Inventory[child.SlotNum.Value].Data;
                child.BackgroundTransparency = 1;
                child.Image = "";
                child.SlotText.Visible = false;

                if child.ItemNumber.Visible == true then
                    u32.Dragging.ItemNumber.Visible = true;
                    u32.Dragging.ItemNumber.Number.Text = child.ItemNumber.Number.Text;
                    child.ItemNumber.Visible = false;
                end;

                u32.holding = child.Name;
                u32.prevHoldingSlot = child;
                u32.Dragging.Visible = true;
                u32.Dragging.SlotText.Text = child.SlotText.Text;
                local v828 = GameManager:getImageId(u32.oldInfo);

                if u11.ItemDisplayType == "Icon" and v828 ~= "" then
                    u32.Dragging.Image = "rbxassetid://" .. v828;
                    u32.Dragging.ImageColor3 = GameManager:getImageColor(u32.oldInfo);
                    child.SlotBorder.Visible = false;
                    u32.Dragging.SlotText.TextTransparency = 1;
                else
                    u32.Dragging.Image = "";
                    u32.Dragging.SlotText.TextTransparency = 0;
                end;

                local Y = u1.Y;
                u32.diffx = child.AbsolutePosition.X - u1.X;
                u32.diffy = child.AbsolutePosition.Y - Y;
                u32.originalSlotPosition = UDim2.new(0, u1.X + u32.diffx, 0, u1.Y + u32.diffy);
                RunService:BindToRenderStep("slotdrag", Enum.RenderPriority.Camera.Value, bindToMouse);
            end;
        end);
        child.MouseButton1Up:connect(function() -- Line: 13342
            -- upvalues: u32 (copy), child (copy), GameManager (copy), u11 (ref), Loadout (copy), UpdateInventory (copy), slotDown (copy), RunService (copy)
            if u32.prevHoldingSlot == 0 or (child.SlotText.Text ~= u32.Inventory[u32.prevHoldingSlot.SlotNum.Value].Item or child.SlotText.Text == "" and u32.Inventory[u32.prevHoldingSlot.SlotNum.Value].Item == "") then
                if u32.oldInfo then
                    if u32.prevHoldingSlot.Parent == Loadout then
                        u32.InventorySlotCount = u32.InventorySlotCount + 1;
                        u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Item = "";
                        u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Quantity = 1;
                        u32.Loadout[u32.prevHoldingSlot.SlotNum.Value].Data = {};
                        u32.Inventory[tostring(u32.InventorySlotCount)].Item = u32.oldInfo;
                        u32.Inventory[tostring(u32.InventorySlotCount)].Quantity = u32.oldQuantity;
                        u32.Inventory[tostring(u32.InventorySlotCount)].Data = u32.oldItemData;
                        u32.prevHoldingSlot.SlotBorder.Visible = true;

                        if u32.Dragging.ItemNumber.Visible == true then
                            child.ItemNumber.Visible = true;
                            child.ItemNumber.Number.Text = "x" .. u32.Dragging.ItemNumber.Number.Text;
                        else
                            child.ItemNumber.Visible = false;
                        end;
                    end;

                    if u32.EnlargedSlot ~= 0 then
                        u32.EnlargedSlot:TweenSize(u32.PreviousSlotSize, "Out", "Quad", GameManager.Settings.SlotTweenTime, true);
                        u32.EnlargedSlot.SlotBorder.Image = "rbxassetid://" .. GameManager.UI.StandardBorder;
                        u32.SelectedSlot = "";
                        u32.EnlargedSlot = 0;
                    end;

                    UpdateInventory();
                end;
            else
                child.Visible = true;
                child.BackgroundTransparency = 0;
                child.SlotBorder.Visible = true;
                child.SlotText.Text = u32.Dragging.SlotText.Text;
                child.SlotText.Visible = true;

                if u32.Dragging.ItemNumber.Visible == true then
                    child.ItemNumber.Visible = true;
                    child.ItemNumber.Number.Text = u32.Dragging.ItemNumber.Number.Text;
                else
                    child.ItemNumber.Visible = false;
                end;

                local v829 = GameManager:getImageId(child.SlotText.Text);

                if u11.ItemDisplayType == "Icon" and v829 ~= "" then
                    child.Image = "rbxassetid://" .. v829;
                    child.ImageColor3 = GameManager:getImageColor(child.SlotText.Text);
                    child.SlotText.TextTransparency = 1;
                else
                    child.Image = "";
                    child.SlotText.TextTransparency = 0;
                end;
            end;

            if u32.prevHoldingSlot == child then
                slotDown(child.Name);
            end;

            u32.Dragging.Visible = false;
            u32.Dragging.ItemNumber.Visible = false;
            u32.Dragging.ZIndex = 9;
            u32.oldInfo = nil;
            u32.oldQuantity = nil;
            u32.oldItemData = nil;
            u32.holding = 0;
            u32.prevHoldingSlot = 0;
            RunService:UnbindFromRenderStep("slotdrag");
        end);
    end;
end;

for _, child in ipairs(SkillsFrame:GetChildren()) do
    if child.ClassName == "ImageButton" then
        child.MouseButton1Down:Connect(function() -- Line: 13409
            -- upvalues: child (copy), viewSkill (copy)
            if child.SlotText.Text ~= "" then
                viewSkill(child);
            end;
        end);
    end;
end;

local function checkAwakeningEffect() -- Line: 13417
    -- upvalues: GameManager (copy), u11 (ref), u32 (copy), Awakening (copy)
    if GameManager:hasAnAwakening(u11) and u32.Settings.Awakened.Value ~= "" or u32.Settings.Awakened.Value == "" and u32.Settings.AwakeningCooldown.Value == 0 then
        Awakening["Fire" .. u32.AwakeningImageNumber].Visible = false;

        if u32.AwakeningImageNumber == 5 then
            u32.AwakeningImageNumber = 1;
        else
            u32.AwakeningImageNumber = u32.AwakeningImageNumber + 1;
        end;

        Awakening["Fire" .. u32.AwakeningImageNumber].Visible = true;
    end;
end;

local v845 = coroutine.wrap(function() -- Line: 13429
    -- upvalues: checkAwakeningEffect (copy), UserInputService (copy), u32 (copy), GameManager (copy), u11 (ref), chakra (copy), maxChakra (copy), Humanoid (copy), TweenService (copy), HUD (copy), ReplicatedStorage (copy), LocalPlayer (copy), Mainframe (copy), HumanoidRootPart (copy), SubIndicator (copy), updatePlayerList (copy), Dialog (copy), u60 (copy), DataEvent (copy), u9 (copy), updateHighlights (copy), DataFunction (copy), Cooldowns (copy)
    local u830 = 0;
    local u831 = 0;

    while task.wait(0.1) do
        local success2, result2 = pcall(function() -- Line: 13434
            -- upvalues: u830 (ref), checkAwakeningEffect (ref), UserInputService (ref), u32 (ref), GameManager (ref), u11 (ref), chakra (ref), maxChakra (ref), Humanoid (ref), TweenService (ref), HUD (ref), ReplicatedStorage (ref), LocalPlayer (ref), Mainframe (ref), HumanoidRootPart (ref), SubIndicator (ref), u831 (ref), updatePlayerList (ref), Dialog (ref), u60 (ref), DataEvent (ref), u9 (ref), updateHighlights (ref), DataFunction (ref), Cooldowns (ref)
            u830 = u830 + 0.1;
            checkAwakeningEffect();

            if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
                u32.Shiftlocked = true;
            else
                u32.Shiftlocked = false;
            end;

            if GameManager:searchInList(u11.Traits, "Saturated") == true then
                if chakra.Value == maxChakra.Value and (Humanoid.Health < Humanoid.MaxHealth and (u830 == 0.5 or math.floor(u830) == 1)) then
                    if u830 == 0.5 then
                        TweenService:Create(HUD.RightFade, TweenInfo.new(0.5), {
                            ImageColor3 = Color3.fromRGB(0, 68, 113)
                        }):Play();
                    else
                        TweenService:Create(HUD.RightFade, TweenInfo.new(0.5), {
                            ImageColor3 = Color3.fromRGB(0, 0, 0)
                        }):Play();
                    end;
                elseif chakra.Value < maxChakra.Value and (Humanoid.Health == Humanoid.MaxHealth and HUD.RightFade.ImageColor3 ~= Color3.fromRGB(0, 0, 0)) then
                    TweenService:Create(HUD.RightFade, TweenInfo.new(0.5), {
                        ImageColor3 = Color3.fromRGB(0, 0, 0)
                    }):Play();
                end;
            end;

            if GameManager:searchInList(u11.Traits, "Child of the Flames") == true then
                if ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Fire") and (u830 == 0.5 or math.floor(u830) == 1) and chakra.Value < maxChakra.Value then
                    if u830 == 0.5 then
                        TweenService:Create(HUD.LeftFade, TweenInfo.new(0.5), {
                            ImageColor3 = Color3.fromRGB(154, 0, 36)
                        }):Play();
                    else
                        TweenService:Create(HUD.LeftFade, TweenInfo.new(0.5), {
                            ImageColor3 = Color3.fromRGB(0, 0, 0)
                        }):Play();
                    end;
                elseif not ReplicatedStorage.Ailments[LocalPlayer.Name]:FindFirstChild("Fire") and HUD.LeftFade.ImageColor3 ~= Color3.fromRGB(0, 0, 0) then
                    TweenService:Create(HUD.LeftFade, TweenInfo.new(0.5), {
                        ImageColor3 = Color3.fromRGB(0, 0, 0)
                    }):Play();
                end;
            end;

            if GameManager:searchInList(u11.Traits, "Last Stand") == true then
                if not Mainframe:FindFirstChild("LastStand") then
                    ReplicatedStorage.UI.LastStand:Clone().Parent = Mainframe;
                end;

                if Humanoid.Health < GameManager.Traits["Last Stand"].LowHealthReq * Humanoid.MaxHealth and (u830 == 0.5 or math.floor(u830) == 1) then
                    if u830 == 0.5 then
                        TweenService:Create(Mainframe.LastStand, TweenInfo.new(0.5), {
                            BackgroundTransparency = 0.75
                        }):Play();
                    else
                        TweenService:Create(Mainframe.LastStand, TweenInfo.new(0.5), {
                            BackgroundTransparency = 1
                        }):Play();
                    end;

                    if HumanoidRootPart.Heartbeat.Playing == false then
                        HumanoidRootPart.Heartbeat:Play();
                    end;

                    HumanoidRootPart.Heartbeat.Volume = 0.9 + (GameManager.Traits["Last Stand"].LowHealthReq - Humanoid.Health / Humanoid.MaxHealth) * 5;
                elseif Humanoid.Health >= GameManager.Traits["Last Stand"].LowHealthReq * Humanoid.MaxHealth and Mainframe.LastStand.BackgroundTransparency ~= 1 then
                    TweenService:Create(Mainframe.LastStand, TweenInfo.new(0.5), {
                        BackgroundTransparency = 1
                    }):Play();
                    HumanoidRootPart.Heartbeat:Stop();
                end;
            end;

            local Value = u32.Settings.SubCooldown.Value;
            local v832 = workspace:GetServerTimeNow() - Value;
            local v833 = math.max(0, GameManager.Settings.SubCooldown - v832);
            local v834 = math.ceil(v833);
            SubIndicator.Cooldown.Text = v834;
            SubIndicator.Visible = v834 > 0;

            if u830 >= 1 then
                u831 = u831 + 1;

                if u831 == 10 then
                    u831 = 1;
                    updatePlayerList();
                end;

                u830 = 0;

                if u32.InDialog == true and (u32.dialogPart and ((HumanoidRootPart.Position - u32.dialogPart:GetPivot().Position).magnitude > 40 and u32.scammed == false)) then
                    u32.InDialog = false;
                    Dialog.Visible = false;
                    u32.dialogPart = nil;
                end;

                if u11.HighQRain == "Off" and u60.Transparency ~= 1 then
                    if observingCharacter then
                        u60.Position = observingCharacter:GetPivot().Position;
                    else
                        u60.Position = HumanoidRootPart.Position;
                    end;
                end;

                if Humanoid.WalkSpeed >= 110 then
                    DataEvent:FireServer("BanMe", "Offense 1C");
                end;

                if u9:FindFirstChild("HumanoidRootPart") then
                    u32.expLast_Y = u9.HumanoidRootPart.Position.Y;
                end;

                if u32.Settings and (u32.Settings:FindFirstChild("Awakened") and u32.Settings.Awakened.Value:find("Byakugan")) then
                    updateHighlights();
                end;

                local v835 = DataFunction:InvokeServer("NearbyFruitsPlease");

                if v835 then
                    for i = 1, #u32.myFruits do
                        local v836 = false;

                        for i2 = 1, #v835 do
                            if u32.myFruits[i] and (u32.myFruits[i]:FindFirstChild("ID") and (v835[i2] and (v835[i2]:FindFirstChild("ID") and v835[i2].ID.Value == u32.myFruits[i].ID.Value))) then
                                v836 = true;
                            end;
                        end;

                        if v836 == false then
                            u32.myFruits[i]:Destroy();
                        end;
                    end;

                    for i = 1, #v835 do
                        local v837 = false;

                        for i2 = 1, #u32.myFruits do
                            if u32.myFruits[i2] and (u32.myFruits[i2]:FindFirstChild("ID") and (v835[i] and (v835[i]:FindFirstChild("ID") and u32.myFruits[i2].ID.Value == v835[i].ID.Value))) then
                                v837 = true;
                            end;
                        end;

                        if v837 == false then
                            v835[i].Parent = workspace;
                            v835[i]:SetAttribute("RealName", v835[i].Name);
                            table.insert(u32.myFruits, v835[i]);

                            if not v835[i]:FindFirstChild("Active") then
                                local BoolValue = Instance.new("BoolValue");
                                BoolValue.Parent = v835[i];
                                BoolValue.Name = "Active";
                                BoolValue.Value = true;
                                GameManager:generateValue("StringValue", "Pickupable").Parent = v835[i];
                            end;
                        end;
                    end;
                end;

                local v838 = DataFunction:InvokeServer("NearbyTrinketsPlease");

                if v838 then
                    for i = 1, #u32.myTrinkets do
                        local v839 = false;

                        for i2 = 1, #v838 do
                            if v838[i2] and (v838[i2]:FindFirstChild("ID") and (u32.myTrinkets[i] and (u32.myTrinkets[i]:FindFirstChild("ID") and v838[i2].ID.Value == u32.myTrinkets[i].ID.Value))) then
                                v839 = true;
                            end;
                        end;

                        if v839 == false then
                            u32.myTrinkets[i]:Destroy();
                        end;
                    end;

                    for i = 1, #v838 do
                        local v840 = false;

                        for i2 = 1, #u32.myTrinkets do
                            if u32.myTrinkets[i2] and (u32.myTrinkets[i2]:FindFirstChild("ID") and (v838[i] and (v838[i]:FindFirstChild("ID") and u32.myTrinkets[i2].ID.Value == v838[i].ID.Value))) then
                                v840 = true;
                            end;
                        end;

                        if v840 == false then
                            v838[i].Parent = workspace;
                            table.insert(u32.myTrinkets, v838[i]);

                            if not v838[i]:FindFirstChild("Active", true) then
                                local v841;

                                if v838[i]:IsA("Model") then
                                    v841 = v838[i].PrimaryPart or v838[i]:FindFirstChildWhichIsA("BasePart", true);
                                else
                                    v841 = v838[i];
                                end;

                                local BoolValue = Instance.new("BoolValue");
                                BoolValue.Parent = v841;
                                BoolValue.Name = "Active";
                                BoolValue.Value = true;
                                v841:SetAttribute("RealName", v838[i].Name);
                                GameManager:generateValue("StringValue", "Pickupable").Parent = v841;
                            end;
                        end;
                    end;
                end;
            end;

            local v842 = Mainframe.MessageFrame:GetChildren();

            if #v842 > 1 then
                for _, v in v842 do
                    if v.Name ~= "CooldownClone" then
                        if Cooldowns[LocalPlayer.Name]:FindFirstChild(v.abilityName.Value) then
                            local v843 = GameManager:getCooldown(u9, v.abilityName.Value, u32.Settings);
                            local v844 = Cooldowns[LocalPlayer.Name][v.abilityName.Value]:GetAttribute("CustomUsedAt") or v.UsedAt.Value;
                            v.Amount.Value = v843 - (workspace:GetServerTimeNow() - v844);
                        else
                            local Amount = v.Amount;
                            Amount.Value = Amount.Value - 1;
                        end;

                        v.Amount.Value = math.ceil(v.Amount.Value);

                        if v.Amount.Value <= 0 then
                            v:Destroy();
                        else
                            v.Text = v.Name .. " [" .. v.Amount.Value .. "]";
                        end;
                    end;
                end;
            end;

            if u32.DropCooldown ~= false and u32.DropCooldown + 1 < tick() then
                u32.DropCooldown = false;
            end;
        end);

        if not success2 then
            warn(result2);
        end;
    end;
end);
updatePlayerList();
v845();
task.spawn(function() -- Line: 13748
    -- upvalues: GameManager (copy), Danger (copy), u32 (copy), ReplicatedStorage (copy), LocalPlayer (copy)
    while true do
        if not task.wait(1) then
            return;
        end;

        local v846 = false;

        for _, v in game.Players:GetPlayers() do
            if v.Character then
                local v847 = GameManager:getSettings(v.Character);

                if v847 and (v847:FindFirstChild("Awakened") and v847.Awakened.Value == "Red Gates") then
                    v846 = true;
                    break;
                end;
            end;
        end;

        if v846 then
            Danger.YourLifeIsInDanger.Text = "⚠️ Your Life Is In Extreme Danger! ⚠️";
        else
            Danger.YourLifeIsInDanger.Text = "Your Life Is In Danger!";
        end;

        if u32.InDanger == true then
            u32.InDangerText = "";
            local v848 = 0;

            for _, child in ipairs(ReplicatedStorage.CombatTags[LocalPlayer.Name]:GetChildren()) do
                if v848 > 5 then
                    u32.InDangerText = u32.InDangerText .. "....";
                    break;
                end;

                v848 = v848 + 1;

                if child:GetAttribute("InGameName") then
                    u32.InDangerText = u32.InDangerText .. "" .. child:GetAttribute("InGameName") .. "[" .. child.Value .. "s],";
                elseif child.Name ~= "Unknown" or v848 == 1 then
                    u32.InDangerText = u32.InDangerText .. "" .. child.Name .. "[" .. child.Value .. "s],";
                end;
            end;

            if v848 > 0 then
                u32.InDangerText = u32.InDangerText:sub(1, #u32.InDangerText - 1);
            end;

            if Danger.InCombat.Text ~= "IN COMBAT" then
                Danger.InCombat.Text = u32.InDangerText;
            end;
        end;
    end;
end);
Danger.InCombat.MouseEnter:Connect(function() -- Line: 13802
    -- upvalues: u32 (copy), Danger (copy)
    if u32.InDanger == true then
        Danger.InCombat.Text = u32.InDangerText;
    end;
end);
Danger.InCombat.MouseLeave:Connect(function() -- Line: 13807
    -- upvalues: Danger (copy)
    Danger.InCombat.Text = "IN COMBAT";
end);

local function newArea(u849) -- Line: 13811
    -- upvalues: DataEvent (copy), Mainframe (copy), GameManager (copy), u32 (copy)
    DataEvent:FireServer("newArea", u849);
    local NewArea = Mainframe:WaitForChild("NewArea");
    NewArea.PlaceNameFrame.PlaceName.Text = u849;
    NewArea.PlaceDescriptionFrame.PlaceDescription.Text = GameManager.Locations[u849].Description;
    NewArea.PlaceNameFrame.PlaceName.Position = UDim2.new(0, 0, 1, 0);
    NewArea.PlaceDescriptionFrame.PlaceDescription.Position = UDim2.new(0, 0, -1, 0);
    NewArea.MidLine.Size = UDim2.new(0, 0, 0.01, 0);
    NewArea.Visible = true;
    NewArea.MidLine:TweenSize(UDim2.new(0.6, 0, 0.01, 0), "Out", "Quad", 0.5, true);
    spawn(function() -- Line: 13826
        -- upvalues: NewArea (copy), u32 (ref), u849 (copy)
        wait(0.5);
        NewArea.PlaceNameFrame.PlaceName:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true);
        NewArea.PlaceDescriptionFrame.PlaceDescription:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true);
        wait(3);
        NewArea.PlaceNameFrame.PlaceName:TweenPosition(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.5, true);
        NewArea.PlaceDescriptionFrame.PlaceDescription:TweenPosition(UDim2.new(0, 0, -1, 0), "Out", "Quad", 0.5, true);
        wait(0.5);
        NewArea.MidLine:TweenSize(UDim2.new(0, 0, 0.01, 0), "Out", "Quad", 0.5, true);
        wait(0.5);
        u32.CurrentArea = u849;
        NewArea.Visible = false;
    end);
end;

local function changeSettings(p850, p851) -- Line: 13841
    -- upvalues: u6 (ref), u58 (copy), u11 (ref), UpdateLoadout (copy), GameManager (copy), Mainframe (copy), LocalPlayer (copy)
    u6.ButtonSelect:Play();

    if p850 == "ItemDisplay" then
        local v852 = p851 == "Icon" and "Text" or "Icon";
        u58.ItemDisplayChoice.Text = v852;
        u11.ItemDisplayType = v852;
        UpdateLoadout();

        return;
    end;

    if p850 == "GraphicsLevel" then
        local v853 = p851 == "High" and "Low" or "High";
        u58.GraphicsLevelChoice.Text = v853;
        u11.GraphicsLevel = v853;
        GameManager:updateGraphics(v853);

        return;
    end;

    if p850 == "CinematicMode" then
        local v854 = p851 == "On" and "Off" or "On";
        u58.CinematicModeChoice.Text = v854;
        u58.CinematicMode = v854;

        return;
    end;

    if p850 == "FOV" then
        local v855 = p851 == "On" and "Off" or "On";
        u58.FOVChoice.Text = v855;
        u11.FOV = v855;

        return;
    end;

    if p850 == "VisibleCooldowns" then
        local v856;

        if p851 == "On" then
            Mainframe.MessageFrame.Visible = false;
            v856 = "Off";
        else
            Mainframe.MessageFrame.Visible = true;
            v856 = "On";
        end;

        u58.VisibleCooldownsChoice.Text = v856;
        u11.VisibleCooldowns = v856;

        return;
    end;

    if p850 == "Footsteps" then
        local v857 = p851 == "On" and "Off" or "On";
        u58.FootstepsChoice.Text = v857;
        u11.Footsteps = v857;

        return;
    end;

    if p850 == "InstantCast" then
        local v858 = p851 == "On" and "Off" or "On";
        u58.InstantCastChoice.Text = v858;
        u11.InstantCast = v858;

        return;
    end;

    if p850 ~= "Tilt" then
        if p850 == "HighQRain" then
            local v859 = p851 == "On" and "Off" or "On";
            u58.HighQRainChoice.Text = v859;
            u11.HighQRain = v859;

            if v859 == "On" then
                LocalPlayer.PlayerScripts.Snow.Actor.Snowy:SetAttribute("Rate", 150);

                return;
            end;

            LocalPlayer.PlayerScripts.Snow.Actor.Snowy:SetAttribute("Rate", 50);
        end;

        return;
    end;

    local v860 = p851 == "On" and "Off" or "On";
    u58.TiltChoice.Text = v860;
    u11.Tilt = v860;
end;

if u11.GraphicsLevel == "Low" then
    GameManager:updateGraphics(u11.GraphicsLevel);
end;

if u11.VisibleCooldowns == "Off" then
    Mainframe:WaitForChild("MessageFrame").Visible = false;
end;

u58.ItemDisplayChoice.Text = u11.ItemDisplayType;
u58.GraphicsLevelChoice.Text = u11.GraphicsLevel;
u58.FOVChoice.Text = u11.FOV;
u58.VisibleCooldownsChoice.Text = u11.VisibleCooldowns;
u58.FootstepsChoice.Text = u11.Footsteps;
u58.InstantCastChoice.Text = u11.InstantCast;
u58.TiltChoice.Text = u11.Tilt;
u58.HighQRainChoice.Text = u11.HighQRain;
u58.ItemDisplayRight.MouseButton1Down:Connect(function() -- Line: 13946
    -- upvalues: u11 (ref), u6 (ref), u58 (copy), UpdateLoadout (copy)
    local ItemDisplayType = u11.ItemDisplayType;
    u6.ButtonSelect:Play();
    local v861 = ItemDisplayType == "Icon" and "Text" or "Icon";
    u58.ItemDisplayChoice.Text = v861;
    u11.ItemDisplayType = v861;
    UpdateLoadout();
end);
u58.ItemDisplayLeft.MouseButton1Down:Connect(function() -- Line: 13949
    -- upvalues: u11 (ref), u6 (ref), u58 (copy), UpdateLoadout (copy)
    local ItemDisplayType = u11.ItemDisplayType;
    u6.ButtonSelect:Play();
    local v862 = ItemDisplayType == "Icon" and "Text" or "Icon";
    u58.ItemDisplayChoice.Text = v862;
    u11.ItemDisplayType = v862;
    UpdateLoadout();
end);
u58.GraphicsLevelRight.MouseButton1Down:Connect(function() -- Line: 13953
    -- upvalues: u11 (ref), u6 (ref), u58 (copy), GameManager (copy)
    local GraphicsLevel = u11.GraphicsLevel;
    u6.ButtonSelect:Play();
    local v863 = GraphicsLevel == "High" and "Low" or "High";
    u58.GraphicsLevelChoice.Text = v863;
    u11.GraphicsLevel = v863;
    GameManager:updateGraphics(v863);
end);
u58.GraphicsLevelLeft.MouseButton1Down:Connect(function() -- Line: 13956
    -- upvalues: u11 (ref), u6 (ref), u58 (copy), GameManager (copy)
    local GraphicsLevel = u11.GraphicsLevel;
    u6.ButtonSelect:Play();
    local v864 = GraphicsLevel == "High" and "Low" or "High";
    u58.GraphicsLevelChoice.Text = v864;
    u11.GraphicsLevel = v864;
    GameManager:updateGraphics(v864);
end);
u58.CinematicModeRight.MouseButton1Down:Connect(function() -- Line: 13960
    -- upvalues: u58 (copy), u6 (ref)
    local CinematicMode = u58.CinematicMode;
    u6.ButtonSelect:Play();
    local v865 = CinematicMode == "On" and "Off" or "On";
    u58.CinematicModeChoice.Text = v865;
    u58.CinematicMode = v865;
end);
u58.CinematicModeLeft.MouseButton1Down:Connect(function() -- Line: 13963
    -- upvalues: u58 (copy), u6 (ref)
    local CinematicMode = u58.CinematicMode;
    u6.ButtonSelect:Play();
    local v866 = CinematicMode == "On" and "Off" or "On";
    u58.CinematicModeChoice.Text = v866;
    u58.CinematicMode = v866;
end);
u58.FOVRight.MouseButton1Down:Connect(function() -- Line: 13967
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local FOV = u11.FOV;
    u6.ButtonSelect:Play();
    local v867 = FOV == "On" and "Off" or "On";
    u58.FOVChoice.Text = v867;
    u11.FOV = v867;
end);
u58.FOVLeft.MouseButton1Down:Connect(function() -- Line: 13970
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local FOV = u11.FOV;
    u6.ButtonSelect:Play();
    local v868 = FOV == "On" and "Off" or "On";
    u58.FOVChoice.Text = v868;
    u11.FOV = v868;
end);
u58.VisibleCooldownsRight.MouseButton1Down:Connect(function() -- Line: 13974
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local FOV = u11.FOV;
    u6.ButtonSelect:Play();
    local v869 = FOV == "On" and "Off" or "On";
    u58.FOVChoice.Text = v869;
    u11.FOV = v869;
end);
u58.VisibleCooldownsLeft.MouseButton1Down:Connect(function() -- Line: 13977
    -- upvalues: u11 (ref), u6 (ref), Mainframe (copy), u58 (copy)
    local VisibleCooldowns = u11.VisibleCooldowns;
    u6.ButtonSelect:Play();
    local v870;

    if VisibleCooldowns == "On" then
        Mainframe.MessageFrame.Visible = false;
        v870 = "Off";
    else
        Mainframe.MessageFrame.Visible = true;
        v870 = "On";
    end;

    u58.VisibleCooldownsChoice.Text = v870;
    u11.VisibleCooldowns = v870;
end);
u58.TiltRight.MouseButton1Down:Connect(function() -- Line: 13982
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local Tilt = u11.Tilt;
    u6.ButtonSelect:Play();
    local v871 = Tilt == "On" and "Off" or "On";
    u58.TiltChoice.Text = v871;
    u11.Tilt = v871;
end);
u58.TiltLeft.MouseButton1Down:Connect(function() -- Line: 13985
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local Tilt = u11.Tilt;
    u6.ButtonSelect:Play();
    local v872 = Tilt == "On" and "Off" or "On";
    u58.TiltChoice.Text = v872;
    u11.Tilt = v872;
end);
u58.HighQRainRight.MouseButton1Down:Connect(function() -- Line: 13989
    -- upvalues: u11 (ref), u6 (ref), u58 (copy), LocalPlayer (copy)
    local HighQRain = u11.HighQRain;
    u6.ButtonSelect:Play();
    local v873 = HighQRain == "On" and "Off" or "On";
    u58.HighQRainChoice.Text = v873;
    u11.HighQRain = v873;

    if v873 == "On" then
        LocalPlayer.PlayerScripts.Snow.Actor.Snowy:SetAttribute("Rate", 150);

        return;
    end;

    LocalPlayer.PlayerScripts.Snow.Actor.Snowy:SetAttribute("Rate", 50);
end);
u58.HighQRainLeft.MouseButton1Down:Connect(function() -- Line: 13992
    -- upvalues: u11 (ref), u6 (ref), u58 (copy), LocalPlayer (copy)
    local HighQRain = u11.HighQRain;
    u6.ButtonSelect:Play();
    local v874 = HighQRain == "On" and "Off" or "On";
    u58.HighQRainChoice.Text = v874;
    u11.HighQRain = v874;

    if v874 == "On" then
        LocalPlayer.PlayerScripts.Snow.Actor.Snowy:SetAttribute("Rate", 150);

        return;
    end;

    LocalPlayer.PlayerScripts.Snow.Actor.Snowy:SetAttribute("Rate", 50);
end);
u58.FootstepsRight.MouseButton1Down:Connect(function() -- Line: 13996
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local Footsteps = u11.Footsteps;
    u6.ButtonSelect:Play();
    local v875 = Footsteps == "On" and "Off" or "On";
    u58.FootstepsChoice.Text = v875;
    u11.Footsteps = v875;
end);
u58.FootstepsLeft.MouseButton1Down:Connect(function() -- Line: 13999
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local Footsteps = u11.Footsteps;
    u6.ButtonSelect:Play();
    local v876 = Footsteps == "On" and "Off" or "On";
    u58.FootstepsChoice.Text = v876;
    u11.Footsteps = v876;
end);
u58.InstantCastRight.MouseButton1Down:Connect(function() -- Line: 14003
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local InstantCast = u11.InstantCast;
    u6.ButtonSelect:Play();
    local v877 = InstantCast == "On" and "Off" or "On";
    u58.InstantCastChoice.Text = v877;
    u11.InstantCast = v877;
end);
u58.InstantCastLeft.MouseButton1Down:Connect(function() -- Line: 14006
    -- upvalues: u11 (ref), u6 (ref), u58 (copy)
    local InstantCast = u11.InstantCast;
    u6.ButtonSelect:Play();
    local v878 = InstantCast == "On" and "Off" or "On";
    u58.InstantCastChoice.Text = v878;
    u11.InstantCast = v878;
end);
u58.KeybindsButton.MouseButton1Down:Connect(function() -- Line: 14010
    -- upvalues: SettingsFrame (copy)
    for _, child in ipairs(SettingsFrame:GetChildren()) do
        if child.Name == "SettingsReturn" or child.Name == "KeybindsFrame" then
            child.Visible = true;

            for _, child2 in ipairs(child:GetChildren()) do
                if child2.Name ~= "Warning" then
                    child2.Visible = true;
                end;
            end;
        elseif child.Name ~= "BackDrop" then
            child.Visible = false;
        end;
    end;
end);
u58.SettingsReturn.MouseButton1Down:Connect(function() -- Line: 14025
    -- upvalues: SettingsFrame (copy)
    for _, child in ipairs(SettingsFrame:GetChildren()) do
        if child.Name == "SettingsReturn" or child.Name == "KeybindsFrame" then
            child.Visible = false;

            for _, child2 in ipairs(child:GetChildren()) do
                child2.Visible = false;
            end;
        else
            child.Visible = true;
        end;
    end;
end);
local u879 = false;

local function checkEmptyKeybinds() -- Line: 14038
    -- upvalues: u58 (copy)
    local v880 = false;

    for _, child in ipairs(u58.KeybindsFrame:GetChildren()) do
        if child.Name:find("Textbox") then
            if child.Text == "" and child:IsFocused() == false then
                v880 = true;
            elseif string.len(child.Text) >= 2 then
                child.Text = "";
            end;
        end;
    end;

    if v880 == true then
        u58.KeybindsFrame.WarningNotBinded.Visible = true;
        delay(3, function() -- Line: 14051
            -- upvalues: u58 (ref)
            u58.KeybindsFrame.WarningNotBinded.Visible = false;
        end);
    end;
end;

for _, child in ipairs(u58.KeybindsFrame:GetChildren()) do
    if child.Name:find("Textbox") then
        local u881 = child.Name:sub(8);
        child.Text = u11.LoadoutKeybinds[u881].Keybind;
        child:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 14063
            -- upvalues: u879 (ref), child (copy), GameManager (copy), u58 (copy), LoadoutKeybinds (copy), u881 (copy), checkEmptyKeybinds (copy)
            if u879 == false then
                u879 = true;

                if string.len(child.Text) < 2 then
                    child.Text = child.Text:upper();

                    if GameManager:searchInList(GameManager.AllowedKeybinds, child.Text) then
                        LoadoutKeybinds[u881].Keybind = child.Text:upper();
                    elseif child.Text ~= "" then
                        u58.KeybindsFrame.WarningCannotBind.Visible = true;
                        child.Text = "";
                        delay(3, function() -- Line: 14072
                            -- upvalues: u58 (ref)
                            u58.KeybindsFrame.WarningCannotBind.Visible = false;
                        end);
                    end;
                else
                    child.Text = child.Text:sub(2, 2);
                end;

                checkEmptyKeybinds();
                delay(0.05, function() -- Line: 14084
                    -- upvalues: u879 (ref)
                    u879 = false;
                end);
            end;
        end);
    end;
end;

local C0 = u9.HumanoidRootPart.RootJoint.C0;
Mainframe:WaitForChild("ClanInvitation").Close.MouseButton1Down:Connect(function() -- Line: 14096
    -- upvalues: Mainframe (copy)
    Mainframe.ClanInvitation.Visible = false;
end);
Mainframe:WaitForChild("ClanInvitation").JoinClan.MouseButton1Down:Connect(function() -- Line: 14100
    -- upvalues: DataEvent (copy), Mainframe (copy), u11 (ref)
    DataEvent:FireServer("JoinClan", Mainframe.ClanInvitation.ClanName.Text);
    u11.Clan = Mainframe.ClanInvitation.ClanName.Text;
    Mainframe.ClanInvitation.Visible = false;
end);
Mainframe:WaitForChild("ClanCreation").Close.MouseButton1Down:Connect(function() -- Line: 14106
    -- upvalues: Mainframe (copy)
    Mainframe.ClanCreation.Visible = false;
end);
Mainframe:WaitForChild("ClanCreation").CreateClan.MouseButton1Down:Connect(function() -- Line: 14110
    -- upvalues: Mainframe (copy), GameManager (copy), DataFunction (copy), DataEvent (copy), u11 (ref)
    local u882 = "";

    if string.len(Mainframe.ClanCreation.ClanName.Text) > GameManager.Settings.ClanNameLimit then
        u882 = "Clan name is too long";
    elseif string.len(Mainframe.ClanCreation.ClanName.Text) < 3 then
        u882 = "Clan name is too short";
    elseif string.gsub(Mainframe.ClanCreation.ClanName.Text, "%D", "") == "" then
        print("initial checks passed");

        if DataFunction:InvokeServer("FilterClanName", Mainframe.ClanCreation.ClanName.Text) == true then
            print("accepted by text filter");

            if DataFunction:InvokeServer("CheckClanName", Mainframe.ClanCreation.ClanName.Text) == true then
                print("name not in use");
                DataEvent:FireServer("CreateClan", Mainframe.ClanCreation.ClanName.Text, Mainframe.ClanCreation.ClanImageID.Text);
                u11.Clan = Mainframe.ClanCreation.ClanName.Text;
                print("creating a clan called " .. u11.Clan);

                if u11.Gender == "Male" then
                    u11.ClanLeader = "Chief";
                else
                    u11.ClanLeader = "Chieftess";
                end;
            else
                u882 = "Name is in use";
            end;
        else
            u882 = "Name was not accepted by Text filter";
        end;
    else
        u882 = "Name cannot contain numbers";
    end;

    if u882 == "" then
        Mainframe.ClanCreation.Visible = false;
    else
        Mainframe.ClanCreation.Error.Text = u882;
        delay(2, function() -- Line: 14141
            -- upvalues: Mainframe (ref), u882 (ref)
            if Mainframe.ClanCreation.Error.Text == u882 then
                Mainframe.ClanCreation.Error.Text = "";
            end;
        end);
    end;
end);
local u883 = 10;

for i, v in next, GameManager.Bloodlines do
    if i ~= "Kaguya" and i ~= "Yuki" then
        for _ = 1, v.Rarity do
            u32.totalRarity = u32.totalRarity + 1;
        end;
    end;
end;

local function getRarity(p884) -- Line: 14160
    -- upvalues: GameManager (copy)
    return GameManager.Bloodlines[p884].Rarity;
end;

for i, _ in GameManager.Bloodlines do
    if i ~= "Kaguya" and i ~= "Yuki" then
        local v885 = BloodlinesFrame.BloodlineClone:Clone();
        v885.Visible = true;
        v885.Text = i .. " - " .. getRarity(i) .. "%";
        v885.LayoutOrder = getRarity(i);
        v885.Parent = BloodlinesFrame.ScrollingFrame;
    end;
end;

u32.Settings.AwakeningCooldown.Changed:Connect(function(p886) -- Line: 14175
    -- upvalues: Awakening (copy)
    if p886 == 0 then
        Awakening.Cooldown.Visible = false;

        for _, child in ipairs(Awakening:GetChildren()) do
            if child.ClassName == "ImageLabel" then
                child.ImageColor3 = Color3.fromRGB(237, 94, 255);
            end;
        end;

        return;
    end;

    Awakening.Cooldown.Visible = true;
    Awakening.Cooldown.Text = p886;
end);
u32.Settings.Awakened.Changed:Connect(function(p887) -- Line: 14189
    -- upvalues: Awakening (copy), u32 (copy), u10 (copy)
    if p887 == "" then
        Awakening["Fire" .. u32.AwakeningImageNumber].Visible = true;
        Awakening["Fire" .. u32.AwakeningImageNumber].ImageColor3 = Color3.fromRGB(50, 50, 50);
    else
        Awakening["Fire" .. u32.AwakeningImageNumber].Visible = false;
        Awakening["Fire" .. u32.AwakeningImageNumber].ImageColor3 = Color3.fromRGB(237, 94, 255);
    end;

    if string.match(p887, "Byakugan") then
        while u10.Awakened.Value == p887 do
            local v888 = false;

            for _, child in workspace["Hyuga BossEntrances"]:GetChildren() do
                for _, child2 in child:GetChildren() do
                    if child2:IsA("BasePart") and not child2.CanCollide then
                        v888 = child;
                        break;
                    end;
                end;
            end;

            for _, child in workspace["Hyuga BossEntrances"]:GetChildren() do
                for _, child2 in child:GetChildren() do
                    if child2:IsA("Highlight") then
                        child2:Destroy();
                    end;
                end;
            end;

            if v888 and not v888:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight");
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
                Highlight.FillTransparency = 1;
                Highlight.OutlineTransparency = 0.95;
                Highlight.Parent = v888;
            end;

            task.wait(3);
        end;
    else
        for _, child in workspace["Hyuga BossEntrances"]:GetChildren() do
            for _, child2 in child:GetChildren() do
                if child2:IsA("Highlight") then
                    child2:Destroy();
                end;
            end;
        end;
    end;
end);

for _, child in workspace:WaitForChild("Hyuga BossEntrances"):GetChildren() do
    for _, child2 in child:GetChildren() do
        if child2:IsA("Highlight") then
            child2:Destroy();
        end;
    end;
end;

if GameManager:hasAnAwakening(u11) then
    Awakening.Visible = true;
else
    Awakening.Visible = false;
end;

local function ailmentCooldown() -- Line: 14256
    -- upvalues: u32 (copy)
    u32.AilmentCooldown = true;
    wait(0.5);
    u32.AilmentCooldown = false;
end;

HumanoidRootPart.ChildAdded:Connect(function(p889) -- Line: 14262
    -- upvalues: GameManager (copy), u32 (copy), DataEvent (copy)
    if p889.ClassName == "BodyGyro" or (p889.ClassName == "BodyVelocity" or (p889.ClassName == "BodyPosition" or (p889.ClassName == "Linearvelocity" or p889.ClassName == "Linearposition"))) and not GameManager:searchInList(u32.ABV, p889.Name) then
        DataEvent:FireServer("BanMe", "Offense 1E");
    end;
end);
local u890 = RaycastParams.new();
u890.FilterDescendantsInstances = {
    workspace.Debris,
    u9,
    workspace.Locations,
    Model
};
u890.FilterType = Enum.RaycastFilterType.Exclude;
game:GetService("RunService"):BindToRenderStep("FollowHead", Enum.RenderPriority.Camera.Value + 1, function(p891) -- Line: 14272
    -- upvalues: u32 (copy), u9 (copy), Humanoid (copy), HumanoidRootPart (copy)
    if u32.dynamicCamera == true then
        if not u9 or Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            return;
        end;

        local Head = u9:WaitForChild("Head");
        local v892 = HumanoidRootPart.CFrame:ToObjectSpace(Head.CFrame);
        Humanoid.CameraOffset = Humanoid.CameraOffset:Lerp(v892.Position - Vector3.new(0, 1.5, 0), p891 * 10);
    end;
end);
game:GetService("RunService").Heartbeat:Connect(function(p893) -- Line: 14284
    -- upvalues: u10 (copy), u32 (copy), HumanoidRootPart (copy), u1 (copy), u9 (copy), u48 (copy), u11 (ref), selectNewItem (copy), Mainframe (copy), Part (copy), CurrentCamera (copy), Humanoid (copy), GameManager (copy), ReplicatedStorage (copy), u60 (copy), Model (copy), LocalPlayer (copy), DataEvent (copy), CollectionService (copy), endSlide (copy), visualAilment (copy), u6 (ref), Dialog (copy), newText (copy), Rest (copy), newArea (copy), updateLocation (copy), fallDamage (copy), u3 (copy), DataFunction (copy), u890 (copy), C0 (copy), running (copy), u883 (ref), TweenService (copy)
    if not u10.Parent then
        return;
    end;

    if u32.CharFacing == true then
        if HumanoidRootPart:FindFirstChild("FaceBG") then
            HumanoidRootPart.FaceBG.cframe = CFrame.new(HumanoidRootPart.Position, u1.Hit.p);
        else
            local BodyGyro = Instance.new("BodyGyro");
            BodyGyro.Name = "FaceBG";
            BodyGyro.MaxTorque = Vector3.new(300000, 300000, 300000);
            BodyGyro.P = 15000;
            BodyGyro.cframe = CFrame.new(HumanoidRootPart.Position, u1.Hit.p) * CFrame.Angles(0, 1.5707963267948966, 0);
            BodyGyro.Parent = HumanoidRootPart;
        end;
    elseif HumanoidRootPart:FindFirstChild("FaceBG") then
        HumanoidRootPart.FaceBG:Destroy();
    end;

    if u9:GetAttribute("KotoamatsukamiForceMove") then
        local v894 = u9:GetAttribute("KotoamatsukamiForceMove");
        local Unit = (v894 - HumanoidRootPart.Position).Unit;
        local Magnitude = (v894 - HumanoidRootPart.Position).Magnitude;
        local v895 = u9.PrimaryPart:FindFirstChild("KotoamatsukamiForceMoveBV") or Instance.new("BodyVelocity");
        v895.Name = "KotoamatsukamiForceMoveBV";
        v895.MaxForce = Vector3.new(1000000, 0, 1000000);
        v895.Velocity = Unit * math.max(u32.OriginSpeed, 35);
        v895.Parent = u9.PrimaryPart;
        local v896 = u9.PrimaryPart:FindFirstChild("KotoamatsukamiForceMoveBG") or Instance.new("BodyGyro");
        v896.Name = "KotoamatsukamiForceMoveBG";
        v896.MaxTorque = Vector3.new(0, 1000000000000, 0);
        v896.CFrame = CFrame.lookAlong(HumanoidRootPart.Position, Unit);
        v896.Parent = u9.PrimaryPart;

        if Magnitude <= 5 then
            v895.MaxForce = Vector3.new(0, 0, 0);
        else
            v895.MaxForce = Vector3.new(1000000, 0, 1000000);
        end;

        if not u48.Run.IsPlaying then
            u48.Run:Play();
        end;
    elseif u9.PrimaryPart then
        for _, child in u9.PrimaryPart:GetChildren() do
            if string.match(child.Name, "KotoamatsukamiForceMove") then
                child:Destroy();

                if u48.Run.IsPlaying then
                    u48.Run:Stop();
                end;
            end;
        end;
    end;

    if u9:GetAttribute("KotoamatsukamiAttacking") then
        if hasInventoryItem(u11, u11.CurrentWeapon) and u32.Selected ~= u11.CurrentWeapon then
            selectNewItem(u11, u11.CurrentWeapon);
        end;

        attemptMelee();
    end;

    u32.FPS = workspace:GetRealPhysicsFPS();
    Mainframe:WaitForChild("fpsDisplay").Text = "FPS : " .. u32.FPS;
    u32.AwakeningImageWaitTime = 1 / u32.FPS * 5;
    Part.CFrame = CFrame.new(HumanoidRootPart.Position);
    u32.camerablock.CFrame = CurrentCamera.CFrame;
    local v897 = false;

    for _, v in ipairs(workspace:GetPartsInPart(u32.camerablock)) do
        if v.Name == "WaterBlock" then
            v897 = true;
        end;
    end;

    if CurrentCamera.CameraSubject ~= nil and CurrentCamera.CameraSubject ~= Humanoid then
        GameManager:hasSkill(u11, "Chakra Sense");
    end;

    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
    local v898 = math.clamp(AssemblyLinearVelocity.X, -100, 100);
    local v899 = math.clamp(AssemblyLinearVelocity.Y, -200, 200);
    local v900 = math.clamp(AssemblyLinearVelocity.Z, -100, 100);
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(v898, v899, v900);

    if v897 == true and u32.camInWater == false then
        u32.camInWater = true;
        ReplicatedStorage.UI.WaterBlur:Clone().Parent = game.Lighting;

        if halloween == true then
            ReplicatedStorage.UI.HallowWaterColorCorrection:Clone().Parent = game.Lighting;
            ReplicatedStorage.UI.HallowWaterOverlay:Clone().Parent = Mainframe;
        else
            ReplicatedStorage.UI.WaterColorCorrection:Clone().Parent = game.Lighting;
            ReplicatedStorage.UI.WaterOverlay:Clone().Parent = Mainframe;
        end;
    elseif v897 == false and u32.camInWater == true then
        u32.camInWater = false;
        game.Lighting.WaterBlur:Destroy();

        if halloween == true then
            game.Lighting.HallowWaterColorCorrection:Destroy();
            Mainframe.HallowWaterOverlay:Destroy();
        else
            game.Lighting.WaterColorCorrection:Destroy();
            Mainframe.WaterOverlay:Destroy();
        end;
    end;

    local v901, _ = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)).p, u9);
    local v902, v903 = GameManager:CastRay(HumanoidRootPart.Position, Vector3.new(0, 1000, 0), u9);

    if Humanoid:GetState() == Enum.HumanoidStateType.Climbing or Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        u32.FallingVar = false;
    elseif u32.FallingVar == false then
        u32.FallingVar = tick();
    else
        local v904, _ = GameManager:CastRayParams(HumanoidRootPart.Position, (HumanoidRootPart.Position + Vector3.new(0, -5, 0) - HumanoidRootPart.Position).unit, {
            u9,
            u60,
            workspace.Locations,
            Model
        }, 9);

        if v904 then
            u32.FallingVar = false;
        elseif tick() - u32.FallingVar > 5 and (u32.Settings.BeingCarried.Value == "None" and (not u9:FindFirstChild("Ragdolled") and (u9:FindFirstChild("Torso") and (Humanoid and Humanoid.Health > 0)))) then
            local v905 = GameManager:createRegion3(HumanoidRootPart.Position + Vector3.new(7, -4, 7), HumanoidRootPart.Position + Vector3.new(-7, -8, -7));
            local v906 = false;

            for _, v in pairs(game.Workspace:FindPartsInRegion3(v905, nil, (1 / 0))) do
                if v.Parent.Name ~= LocalPlayer.Name then
                    if v.Parent.Parent and v.Parent.Parent.Name ~= LocalPlayer.Name then
                        v906 = true;
                    elseif not v.Parent.Parent then
                        v906 = true;
                    end;
                end;
            end;

            if v906 == false and HumanoidRootPart.Position.Y > u32.expLast_Y then
                DataEvent:FireServer("BanMe", "Offense 2E");
            end;

            return false;
        end;
    end;

    if v901 then
        if u32.Sliding == true and not (v901:FindFirstChild("Slope") or CollectionService:HasTag(v901, "Slope")) then
            endSlide();
        elseif v901.Name == "Mat" then
            u48.Sleep:Play();
        elseif v901.Name:sub(1, 9) == "StepPlate" and (v901.Active.Value == false and not u9:FindFirstChild("ForceField")) then
            print("Hit stepplate");
            DataEvent:FireServer("ActivateStepPlate", v901);
        elseif v901:FindFirstChild("SecretPlate") then
            DataEvent:FireServer("ActivateSecretStepPlate", v901);
        elseif v901.Name == "PoisonFloor" and (not u9:FindFirstChild("ForceField") and (not u32.AilmentCooldown and (u32.Settings.Blocking.Value == false and u32.Settings.ArmorBroken.Value == false))) then
            DataEvent:FireServer("InflictPoison");
            u32.AilmentCooldown = true;
            wait(0.5);
            u32.AilmentCooldown = false;
        elseif v901.Name:sub(1, 11) == "PoisonGlass" and (v901.Transparency ~= 1 and (v901.Attachment.PoisonSmoke.Enabled == false and not u9:FindFirstChild("ForceField"))) then
            DataEvent:FireServer("ActivatePoisonGlass", v901);
        elseif v901.Name == "BlackFire" and (not u32.AilmentCooldown and (u32.Settings.Blocking.Value == false and u32.Settings.ArmorBroken.Value == false)) then
            DataEvent:FireServer("InflictBlackFire");
            u32.AilmentCooldown = true;
            wait(0.5);
            u32.AilmentCooldown = false;
        elseif v901.Name == "GreenFire" and (not u32.AilmentCooldown and (u32.Settings.Blocking.Value == false and u32.Settings.ArmorBroken.Value == false)) then
            DataEvent:FireServer("InflictGreenFire");
            u32.AilmentCooldown = true;
            wait(0.5);
            u32.AilmentCooldown = false;
        elseif v901.Name == "BlueFire" and (not u32.AilmentCooldown and (u32.Settings.Blocking.Value == false and u32.Settings.ArmorBroken.Value == false)) then
            DataEvent:FireServer("InflictBlueFire");
            u32.AilmentCooldown = true;
            wait(0.5);
            u32.AilmentCooldown = false;
        elseif v901.Name == "PurpleFire" and (not u32.AilmentCooldown and (u32.Settings.Blocking.Value == false and u32.Settings.ArmorBroken.Value == false)) then
            DataEvent:FireServer("InflictPurpleFire");
            u32.AilmentCooldown = true;
            wait(0.5);
            u32.AilmentCooldown = false;
        elseif LocalPlayer and (LocalPlayer.Character and (not u32.AilmentCooldown and (GameManager:getSettings(LocalPlayer.Character) and u32.Settings.BeingCarried.Value == "None"))) and (v901:FindFirstChild("Burning", true) and (u32.Settings.Blocking.Value == false or u32.Settings.Blocking.Value == true and u32.Settings.ArmorBroken.Value == true) or v901.Name == "Main" and (v901.Parent.Name == "NightTorch" or v901.Parent.Name == "Torch") and (v901:FindFirstChild("TorchLight") and (v901.TorchLight.Enabled == true and v901.Anchored == true))) then
            if v901:FindFirstChild("Burning") and v901.Burning.LightEmission == 0.5 or v901.Name == "Main" and v901:FindFirstChild("BlackFire") then
                DataEvent:FireServer("InflictBlackFire");
            else
                DataEvent:FireServer("InflictFire");
            end;

            u32.AilmentCooldown = true;
            wait(0.5);
            u32.AilmentCooldown = false;
        elseif v901.Name:find("voidPath") and (v901.Transparency == 0 and (v903 and math.abs(v903.Y - HumanoidRootPart.Position.Y) < 5)) then
            DataEvent:FireServer("voidPath", v901.Name);
        elseif v901.Name == "LavarossaFloor" and v901.Activated.Value == "" then
            DataEvent:FireServer("activateLavarossa");
        elseif (v901.Name == "Lava" or v901.Name == "LavarossaVoid") and (u32.lavaTick ~= os.time() and not u9:GetAttribute("VoidResistance")) then
            DataEvent:FireServer("InflictFire", "extraLavaDamage");
            u32.lavaTick = os.time();
            visualAilment("superMinorBlood");
            u6.FlameHit:Play();
        elseif u32.Settings.Awakened.Value == "Obito\'s Eternal Mangekyo" and (CollectionService:HasTag(v901, "Void") and (workspace:GetServerTimeNow() - u32.voidTick > 0.1 and not u9:GetAttribute("VoidResistance"))) then
            DataEvent:FireServer("voidDamage");
            u32.voidTick = workspace:GetServerTimeNow();
        elseif v901.Name == "MandaFloor" and v901.Activated.Value == "" then
            DataEvent:FireServer("activateManda");
        elseif v901.Name == "LavaSnakeFloor" and v901.Activated.Value == "" then
            print("Client : Trying to activate lava snake");
            DataEvent:FireServer("activateLavaSnake");
            GameManager:CameraShake(u9, 5, 5);
        elseif v901.Name == "SamuraiFloor" and v901.Activated.Value == "" then
            DataEvent:FireServer("activateSamurai");
            u32.NPCModule = GameManager.NPC["The Ringed Samurai"];
            u32.InDialog = true;
            Dialog.Visible = true;
            Dialog.DialogBack.NPCName.Text = "The Ringed Samurai";
            u32.dialogPart = nil;
            newText("HideBoxes");
            GameManager:CameraShake(u9, 5, 5);
        elseif v901.Name == "BarbaritFloor" and v901.Activated.Value == "" then
            DataEvent:FireServer("activateBarbarit");
            u32.NPCModule = GameManager.NPC["Barbarit The Rose"];
            u32.InDialog = true;
            Dialog.Visible = true;
            Dialog.DialogBack.NPCName.Text = "Barbarit The Rose";
            u32.dialogPart = nil;
            newText("HideBoxes");
            GameManager:CameraShake(u9, 5, 5);
        elseif u32.Jumped == false and (u32.canDoubleJump == false and (u32.canTripleJump == false and u32.ChargingChakra == true)) then
            if v901.Name == "Branch" or (v901.Name:sub(1, 8) == "TreeBush" or (v901.Name == "MainBranch" or (v901.Name == "Water" or (v901:GetAttribute("CanTreeJump") or u11.Bloodline == "Yuki" and v901.Name == "Ice")))) then
                if LocalPlayer.Backpack.chakra.Value >= GameManager.Settings.TreeJumpChakra and (u32.Settings.JumpCounters.Value > 0 and (v901.Name ~= "Water" or v901.Name == "Water" and GameManager:searchInList(u11.Traits, "Tidal Boost") == true)) then
                    u32.canTreeJump = true;
                elseif u32.Settings.Stunned.Value == false and u32.Knocked == false then
                    Humanoid.JumpPower = u32.OriginJump;
                end;
            elseif u32.Settings.Stunned.Value == false and (u32.Knocked == false and not u32.Occupied) then
                Humanoid.JumpPower = u32.OriginJump;
                u32.canTreeJump = false;
            end;
        elseif u32.Settings.Stunned.Value == false and (u32.Knocked == false and not u32.Occupied) then
            Humanoid.JumpPower = u32.OriginJump;
            u32.canTreeJump = false;
        end;

        if v901.Name ~= "Mat" then
            u48.Sleep:Stop();
        end;

        if v901.Name == "Ice" and u11.Bloodline == "Yuki" then
            v901.CustomPhysicalProperties = nil;
        end;
    elseif u32.Sliding == true then
        endSlide();
    elseif u32.ChargingChakra == false then
        u32.canTreeJump = false;

        if not (u32.hasDoubleJumped or u32.hasTripleJumped) then
            Humanoid.JumpPower = u32.OriginJump;
        end;
    end;

    if v902 and v902:FindFirstChild("SecretPlate") then
        DataEvent:FireServer("ActivateSecretStepPlate", v902);
    end;

    local v907 = GameManager:CastRay(HumanoidRootPart.Position, HumanoidRootPart.Position - (HumanoidRootPart.Position + Vector3.new(0, -5000, 0)), u9, "Hit", workspace.Locations:GetChildren());

    if v907 and (v907.Name ~= u32.CurrentArea and (u32.CurrentArea ~= "Switching" and Rest.Visible == false)) then
        u32.CurrentArea = "Switching";
        newArea(v907.Name);
        updateLocation(v907.Name);
    end;

    local function brickCheck(p908) -- Line: 14598
        return p908 and p908.Parent.Name ~= "Thunderstorm" and true or false;
    end;

    if u60.Transparency ~= 1 then
        if observingCharacter then
            u60.Position = observingCharacter:GetPivot().Position;
        else
            u60.Position = HumanoidRootPart.Position;
        end;
    end;

    if u32.Knocked == true and (u32.Last_Y and (u9 and u9:FindFirstChild("Torso"))) then
        local Torso = u9.Torso;
        local v909, _ = GameManager:CastRayParams(Torso.Position, (Torso.Position + Vector3.new(0, -3, 0) - Torso.Position).unit, {
            u9,
            u60,
            workspace.Locations,
            Model
        }, 3, "AvoidHitbox");

        if v909 and v909.Name ~= "InvertedSphere" then
            fallDamage("Landed");
        end;
    end;

    local v910;

    if ReplicatedStorage.Raining.Value == "" then
        v910 = GameManager.Locations[u32.currentLocation] and GameManager.Locations[u32.currentLocation].PermanentRain;
    else
        v910 = true;
    end;

    if v910 and not (GameManager.Locations[u32.currentLocation] and GameManager.Locations[u32.currentLocation].RainingDisabled) or snowing then
        u32.weatherInc = u32.weatherInc + 1;

        if u32.weatherInc == 25 then
            u32.weatherInc = 0;

            if Model:FindFirstChild("RainPart") and u11.HighQRain == "Off" then
                GameManager:weather(u9, "StartRain", Part, "LowQuality", Model, snowing);
            elseif Model:FindFirstChild("OnlyRainPart") and u11.HighQRain == "On" then
                GameManager:weather(u9, "StartRain", Part, nil, Model, snowing);
            end;

            local v911 = false;
            local v912 = false;
            local v913 = false;

            if u32.actualRainAbove then
                u32.actualRainAbove = false;
                u3.RainAboveUpdated:Fire();
            end;

            for _, child in ipairs(Model:GetChildren()) do
                if child.Name == "OnlyRainPart" and (u32.CurrentAreaa ~= "Rose Sanctum" and (u32.CurrentArea ~= "Biyo Bay" and (u32.CurrentArea ~= "Serpent\'s Cove" and (u32.CurrentArea ~= "The Catacombs" and u32.CurrentArea ~= "Arkoromo Time Space")))) then
                    local v914 = GameManager:CastRay(child.Position + Vector3.new(0, -40, 0), (child.Position - (child.Position + Vector3.new(0, -40, 0))) * 200, {
                        u9,
                        workspace.Locations,
                        workspace.Waters,
                        Model
                    }, "Hit");
                    local v915 = GameManager:CastRay(child.Position + Vector3.new(50, -40, 0), (child.Position + Vector3.new(50, 0, 0) - (child.Position + Vector3.new(50, -40, 0))) * 200, {
                        u9,
                        workspace.Locations,
                        workspace.Waters,
                        Model
                    }, "Hit");
                    local v916 = GameManager:CastRay(child.Position + Vector3.new(-50, -40, 0), (child.Position + Vector3.new(-50, 0, 0) - (child.Position + Vector3.new(-50, -40, 0))) * 200, {
                        u9,
                        workspace.Locations,
                        workspace.Waters,
                        Model
                    }, "Hit");
                    local v917 = GameManager:CastRay(child.Position + Vector3.new(0, -40, 50), (child.Position + Vector3.new(0, 0, 50) - (child.Position + Vector3.new(0, -40, 50))) * 200, {
                        u9,
                        workspace.Locations,
                        workspace.Waters,
                        Model
                    }, "Hit");
                    local v918 = GameManager:CastRay(child.Position + Vector3.new(0, -40, -50), (child.Position + Vector3.new(0, 0, -50) - (child.Position + Vector3.new(0, -40, -50))) * 200, {
                        u9,
                        workspace.Locations,
                        workspace.Waters,
                        Model
                    }, "Hit");

                    if (v914 and v914.Parent.Name ~= "Thunderstorm" and true or false) and (v915 and v915.Parent.Name ~= "Thunderstorm" and (v916 and v916.Parent.Name ~= "Thunderstorm" and (v917 and v917.Parent.Name ~= "Thunderstorm" and (v918 and v918.Parent.Name ~= "Thunderstorm")))) then
                        child.PE.Enabled = false;
                        child.SnowPE.Enabled = false;
                    elseif snowing then
                        child.PE.Enabled = false;
                        child.SnowPE.Enabled = true;
                        v913 = true;
                        v911 = true;
                    else
                        child.PE.Enabled = true;
                        child.SnowPE.Enabled = false;
                        v913 = true;
                        v911 = true;
                    end;

                    if (not v914 or v914.Parent.Name == "Thunderstorm") and not u32.actualRainAbove then
                        u32.actualRainAbove = true;
                        u3.RainAboveUpdated:Fire();
                    end;
                elseif child.Name == "RainPart" or (child.Name == "SecondaryRainPart" or child.Name == "MainRainPart") then
                    local v919 = GameManager:CastRay(child.Position + Vector3.new(0, -40, 0), (child.Position - (child.Position + Vector3.new(0, -40, 0))) * 200, {
                        u9,
                        workspace.Locations,
                        workspace.Waters,
                        Model
                    }, "Hit");

                    if v919 and v919.Parent.Name ~= "Thunderstorm" and true or false or (u32.CurrentAreaa == "Rose Sanctum" or (u32.CurrentArea == "Biyo Bay" or (u32.CurrentArea == "Serpent\'s Cove" or (u32.CurrentArea == "The Catacombs" or u32.CurrentArea == "Arkoromo Time Space")))) then
                        child.PE.Enabled = false;
                        child.SnowPE.Enabled = false;
                    else
                        if snowing then
                            child.PE.Enabled = false;
                            child.SnowPE.Enabled = true;
                        else
                            child.SnowPE.Enabled = false;
                            child.PE.Enabled = true;
                        end;

                        if not u32.actualRainAbove then
                            u32.actualRainAbove = true;
                            u3.RainAboveUpdated:Fire();
                        end;

                        if child.Name == "MainRainPart" or child.Name == "OnlyRainPart" then
                            v911 = true;
                        elseif child.Name == "SecondaryRainPart" then
                            v912 = true;
                        end;

                        v913 = true;
                    end;
                end;
            end;

            if v913 == false or u32.CurrentAreaa == "Rose Sanctum" and u32.CurrentArea == "Biyo Bay" or (u32.CurrentArea == "The Catacombs" or (u32.CurrentArea == "Serpent\'s Cove" or u32.CurrentArea == "Arkoromo Time Space")) then
                u6.RainSound.Volume = 0.25;
            elseif v911 == true then
                u6.RainSound.Volume = 1.3;

                if u32.actualRainAbove then
                    if u32.Selected == "Bowl" then
                        selectNewItem(DataFunction:InvokeServer("FreshwaterBowl"), "Freshwater Bowl");
                    elseif u32.Selected == "InnKeeper\'s Letter" then
                        selectNewItem(DataFunction:InvokeServer("WaterLetter"), "Soaked InnKeeper\'s Letter");
                    end;
                end;
            elseif v912 == true then
                u6.RainSound.Volume = 1.1;
            else
                u6.RainSound.Volume = 0.9;
            end;

            if xmas == true then
                u6.RainSound.Volume = 0;
            end;
        end;

        if u32.actualRainAbove and workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 3, 0), Vector3.new(0, 2048, 0), u890) then
            u32.actualRainAbove = false;
            u3.RainAboveUpdated:Fire();
        end;
    elseif u32.actualRainAbove then
        u32.actualRainAbove = false;
        u3.RainAboveUpdated:Fire();
    end;

    Mainframe:WaitForChild("timeDisplay").Text = game.Lighting.TimeOfDay;

    if u32.CurrentEmote ~= "" and ((HumanoidRootPart.Position - u32.EmotePosition).magnitude > 2 and GameManager.Emotes[u32.CurrentEmote].Looped == true or (HumanoidRootPart.Position - u32.EmotePosition).magnitude > 6) then
        GameManager:stopAnimation(u32.CurrentEmote, Humanoid);
        u32.CurrentEmote = "";
    end;

    if u11.Tilt == "On" and ((CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude > 0.5 and (u32.Knocked == false and (u32.Settings.Stunned.Value == false and (u9:FindFirstChild("HumanoidRootPart") and u9.HumanoidRootPart:FindFirstChild("RootJoint"))))) then
        local v920 = tostring(C0);
        local v921 = string.split(v920, ",");

        if u11.Bloodline == "Otsutsuki" and u9:GetAttribute("otsuAnimations") then
            if running.Value == true then
                u883 = 35;
            else
                u883 = 18;
            end;
        else
            u883 = 10;
        end;

        local v922 = 0;

        if u9.Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.RightVector) > 0.2 then
            local v923 = Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.RightVector) * u883;
            v922 = -math.floor(v923);
        elseif Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.RightVector) < -0.2 then
            local v924 = Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.RightVector) * u883;
            v922 = -math.floor(v924);
        end;

        local v925 = 0;

        if u11.Bloodline == "Otsutsuki" and u9:GetAttribute("otsuAnimations") then
            if u9.Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.LookVector) > 0.2 then
                local v926 = Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.LookVector) * u883;
                v925 = -math.floor(v926);
            elseif Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.LookVector) < -0.2 then
                local v927 = Humanoid.MoveDirection:Dot(u9.HumanoidRootPart.CFrame.LookVector) * u883;
                v925 = -math.floor(v927);
            end;
        end;

        local v928 = {};

        if u11.Bloodline == "Otsutsuki" and u9:GetAttribute("otsuAnimations") then
            v928.C0 = CFrame.new(tonumber(v921[1]), tonumber(v921[2]), (tonumber(v921[3]))) * CFrame.fromEulerAnglesXYZ(math.rad(90 + v925), math.rad(180 + v922), 0);
        else
            v928.C0 = CFrame.new(tonumber(v921[1]), tonumber(v921[2]), (tonumber(v921[3]))) * CFrame.fromEulerAnglesXYZ(1.5707963267948966, math.rad(180 + v922), 0);
        end;

        TweenService:Create(u9.HumanoidRootPart.RootJoint, TweenInfo.new(0.3), v928):Play();

        if u11.Bloodline ~= "Otsutsuki" and u9:GetAttribute("otsuAnimations") then
            local v929 = tostring(u9.Torso["Right Hip"].C0);
            local v930 = string.split(v929, ",");
            local v931 = {
                C0 = CFrame.new(tonumber(v930[1]), tonumber(v930[2]), (tonumber(v930[3]))) * CFrame.fromEulerAnglesXYZ(0, 1.5707963267948966, 0) * CFrame.fromEulerAnglesXYZ(math.rad(v922 * 0.85), 0, 0)
            };
            TweenService:Create(u9.Torso["Right Hip"], TweenInfo.new(0.3), v931):Play();
            local v932 = tostring(u9.Torso["Left Hip"].C0);
            local v933 = string.split(v932, ",");
            local v934 = {
                C0 = CFrame.new(tonumber(v933[1]), tonumber(v933[2]), (tonumber(v933[3]))) * CFrame.fromEulerAnglesXYZ(0, -1.5707963267948966, 0) * CFrame.fromEulerAnglesXYZ(math.rad(-v922 * 0.85), 0, 0)
            };
            TweenService:Create(u9.Torso["Left Hip"], TweenInfo.new(0.3), v934):Play();
        end;
    end;

    if u9:GetAttribute("KotoamatsukamiForceMove") or u9:GetAttribute("KotoamatsukamiAttacking") then
        Humanoid.JumpPower = 0;
    elseif u32.SpinningHumanBoulder == true then
        Humanoid.JumpPower = 90;
    end;

    if u9:FindFirstChild("ForceField") or (u10.BeingCarried.Value ~= "None" or (u9:GetAttribute("FallDamageImmunity") or (u10.Awakened.Value == "Matatabi Cloak" or u9:FindFirstChild("NegateFall")))) then
        u32.Last_Y = u9:GetPivot().Position.Y;
    end;

    if u32.Settings.Invincible.Value == false then
        if u32.currentLocation == "Isobu\'s Belly" then
            local WaterColorCorrection = game.Lighting:FindFirstChild("WaterColorCorrection");

            if not WaterColorCorrection then
                workspace.Terrain.WaterTransparency = 0.08;
                workspace.Terrain.WaterColor = Color3.fromRGB(255, 119, 7);

                return;
            end;

            workspace.Terrain.WaterTransparency = 0.1;
            workspace.Terrain.WaterColor = Color3.fromRGB(255, 187, 16);
            WaterColorCorrection.TintColor = Color3.fromRGB(255, 116, 23);
            WaterColorCorrection.Brightness = 0.1;

            return;
        end;

        workspace.Terrain.WaterTransparency = 0.6;
        workspace.Terrain.WaterColor = Color3.fromRGB(30, 92, 167);
    end;
end);
SkillsFrame.InputChanged:Connect(function(p935) -- Line: 14871
    -- upvalues: u319 (ref)
    if p935.UserInputType == Enum.UserInputType.MouseMovement or p935.UserInputType == Enum.UserInputType.Touch then
        u319 = p935;
    end;
end);
UserInputService.InputChanged:Connect(function(p936) -- Line: 14877
    -- upvalues: u319 (ref), u318 (ref), u320 (ref), SkillsFrame (copy), u321 (ref)
    if p936 == u319 and u318 then
        local v937 = p936.Position - u320;
        SkillsFrame.Position = UDim2.new(u321.X.Scale, u321.X.Offset + v937.X, u321.Y.Scale, u321.Y.Offset + v937.Y);
    end;
end);
local BindableEvent = Instance.new("BindableEvent");
BindableEvent.Event:connect(function() -- Line: 14886
    -- upvalues: DataFunction (copy), u32 (copy)
    if DataFunction:InvokeServer("ResetPlayer") then
        u32.Occupied = true;
    end;
end);
game:GetService("StarterGui"):SetCore("ResetButtonCallback", BindableEvent);
workspace:WaitForChild("MandaInvisFloor").CanCollide = false;

function onFreeFall(p938)
    -- upvalues: u9 (copy), u10 (copy), u32 (copy), fallDamage (copy)
    if u9:FindFirstChild("ForceField") or (u10.BeingCarried.Value ~= "None" or (u9:GetAttribute("FallDamageImmunity") or (u10.Awakened.Value == "Matatabi Cloak" or u9:FindFirstChild("NegateFall")))) then
        u32.Last_Y = u9.Torso.Position.Y;

        return;
    end;

    if p938 then
        u32.Last_Y = u9.Torso.Position.Y;

        return;
    end;

    if u32.Last_Y and (not u9:FindFirstChild("NegateFall") and u32.Knocked == false) then
        fallDamage("Landed");
    end;
end;

Humanoid.FreeFalling:connect(onFreeFall);

for _, child in ipairs(game.Lighting:GetChildren()) do
    if child.Name ~= "DepthOfField" and (child.Name ~= "WorldBlur" and child.Name ~= "Sky") then
        child:Destroy();
    end;
end;

GameManager:DisableAllGuis(u9);
workspace.DescendantAdded:Connect(function(p939) -- Line: 14922
    -- upvalues: LocalPlayer (copy)
    if p939.Name == "MissionMarker" and p939:GetAttribute("UserId") == LocalPlayer.UserId then
        p939.Enabled = true;
    end;
end);

function updateWipeShop()
    -- upvalues: LocalPlayer (copy), u11 (ref), GameManager (copy), DataEvent (copy)
    local WipeShop = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("WipeShop");

    for _, child in WipeShop.Background.ScrollingFrame:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    for i, v in u11.WipeShop do
        local v940 = v.Stock > 0;
        local v941 = WipeShop.Background.Templates[v940 and "Stock" or "NoStock"]:Clone();
        v941.LayoutOrder = v.Order;
        v941.Item.Text = i;
        v941.Icon.ImageLabel.Image = "rbxassetid://" .. GameManager:getImageId(i);
        v941.Icon.ImageLabel.ImageColor3 = GameManager:getImageColor(i);

        if v940 then
            v941.Stock.Text = "X" .. v.Stock .. " Stock";
            v941.Price.Embers.Text = v.Price;
            v941.ImageButton.MouseButton1Down:Connect(function() -- Line: 14953
                -- upvalues: DataEvent (ref), i (copy)
                DataEvent:FireServer("buyWipeShopItem", i);
            end);
        end;

        local u942 = GameManager.Items[i] or (GameManager.Clothing[i] or GameManager.WipeShopItems[i]);
        v941.Icon.ImageLabel.MouseEnter:Connect(function() -- Line: 14960
            -- upvalues: WipeShop (copy), u942 (copy)
            WipeShop.Background.Description.Visible = true;
            WipeShop.Background.Description.TextLabel.Text = u942.Description;
        end);
        v941.Icon.ImageLabel.MouseLeave:Connect(function() -- Line: 14964
            -- upvalues: WipeShop (copy)
            WipeShop.Background.Description.Visible = false;
            WipeShop.Background.Description.TextLabel.Text = "";
        end);
        v941.Visible = true;
        v941.Parent = WipeShop.Background.ScrollingFrame;
    end;
end;

updateWipeShop();

function updateHalloweenShop()
    -- upvalues: LocalPlayer (copy), u11 (ref), GameManager (copy), DataEvent (copy)
    local HalloweenShop = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HalloweenShop");

    for _, child in HalloweenShop.Background.ScrollingFrame:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    for i, v in u11.HalloweenShop do
        local v943 = v.Stock > 0;
        local u944;

        if GameManager:hasSkinUnlocked(u11, i) then
            u944 = HalloweenShop.Background.Templates.Owned:Clone();
        elseif v943 then
            u944 = HalloweenShop.Background.Templates.Stock:Clone();
        else
            u944 = HalloweenShop.Background.Templates.NoStock:Clone();
        end;

        u944.LayoutOrder = v.Order;
        u944.Item.Text = i;
        u944.Icon.ImageLabel.Image = "rbxassetid://" .. GameManager:getImageId(i);
        u944.Icon.ImageLabel.ImageColor3 = GameManager:getImageColor(i);

        if u944.Name == "Stock" then
            u944.Stock.Text = "X" .. v.Stock .. " Stock";
            u944.Price.Embers.Text = v.Price;
            u944.ImageButton.MouseButton1Down:Connect(function() -- Line: 15006
                -- upvalues: DataEvent (ref), i (copy)
                DataEvent:FireServer("buyHalloweenShopItem", i);
            end);
        end;

        if GameManager:hasSkinUnlocked(u11, i) then
            u944.ImageButton.TextLabel.Text = GameManager:hasSkin(u11, i) and "Unequip" or "Equip";
            u944.ImageButton.BackgroundColor3 = GameManager:hasSkin(u11, i) and Color3.fromRGB(100, 36, 36) or Color3.fromRGB(63, 100, 38);
            u944.ImageButton.MouseButton1Down:Connect(function() -- Line: 15015
                -- upvalues: u944 (ref), DataEvent (ref), i (copy)
                DataEvent:FireServer(u944.ImageButton.TextLabel.Text == "Equip" and "equipSkin" or "unequipSkin", i);
            end);
        end;

        local u945 = GameManager.Items[i] or (GameManager.Clothing[i] or GameManager.HalloweenShopItems[i]);
        u944.Icon.ImageLabel.MouseEnter:Connect(function() -- Line: 15023
            -- upvalues: HalloweenShop (copy), u945 (copy)
            HalloweenShop.Background.Description.Visible = true;
            HalloweenShop.Background.Description.TextLabel.Text = u945.Description;
        end);
        u944.Icon.ImageLabel.MouseLeave:Connect(function() -- Line: 15027
            -- upvalues: HalloweenShop (copy)
            HalloweenShop.Background.Description.Visible = false;
            HalloweenShop.Background.Description.TextLabel.Text = "";
        end);
        u944.Visible = true;
        u944.Parent = HalloweenShop.Background.ScrollingFrame;
    end;
end;

if halloween then
    updateHalloweenShop();
end;

function updateXmasShop()
    -- upvalues: LocalPlayer (copy), u11 (ref), GameManager (copy), DataEvent (copy)
    local XmasShop = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("XmasShop");

    for _, child in XmasShop.Background.ScrollingFrame:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    for i, v in u11.XmasShop do
        local v946 = v.Stock > 0;
        local u947;

        if GameManager:hasSkinUnlocked(u11, i) then
            u947 = XmasShop.Background.Templates.Owned:Clone();
        elseif v946 then
            u947 = XmasShop.Background.Templates.Stock:Clone();
        else
            u947 = XmasShop.Background.Templates.NoStock:Clone();
        end;

        u947.LayoutOrder = v.Order;
        u947.Item.Text = i;
        u947.Icon.ImageLabel.Image = "rbxassetid://" .. GameManager:getImageId(i);
        u947.Icon.ImageLabel.ImageColor3 = GameManager:getImageColor(i);

        if u947.Name == "Stock" then
            u947.Stock.Text = "X" .. v.Stock .. " Stock";
            u947.Price.Embers.Text = v.Price;
            u947.ImageButton.MouseButton1Down:Connect(function() -- Line: 15072
                -- upvalues: DataEvent (ref), i (copy)
                DataEvent:FireServer("buyXmasShopItem", i);
            end);
        end;

        if GameManager:hasSkinUnlocked(u11, i) then
            u947.ImageButton.TextLabel.Text = GameManager:hasSkin(u11, i) and "Unequip" or "Equip";
            u947.ImageButton.BackgroundColor3 = GameManager:hasSkin(u11, i) and Color3.fromRGB(100, 36, 36) or Color3.fromRGB(63, 100, 38);
            u947.ImageButton.MouseButton1Down:Connect(function() -- Line: 15081
                -- upvalues: u947 (ref), DataEvent (ref), i (copy)
                DataEvent:FireServer(u947.ImageButton.TextLabel.Text == "Equip" and "equipSkin" or "unequipSkin", i);
            end);
        end;

        local u948 = GameManager.Items[i] or (GameManager.Clothing[i] or GameManager.XmasShopItems[i]);
        u947.Icon.ImageLabel.MouseEnter:Connect(function() -- Line: 15089
            -- upvalues: XmasShop (copy), u948 (copy)
            XmasShop.Background.Description.Visible = true;
            XmasShop.Background.Description.TextLabel.Text = u948.Description;
        end);
        u947.Icon.ImageLabel.MouseLeave:Connect(function() -- Line: 15093
            -- upvalues: XmasShop (copy)
            XmasShop.Background.Description.Visible = false;
            XmasShop.Background.Description.TextLabel.Text = "";
        end);
        u947.Visible = true;
        u947.Parent = XmasShop.Background.ScrollingFrame;
    end;
end;

if xmas then
    updateXmasShop();
end;

function updateValentineShop()
    -- upvalues: LocalPlayer (copy), u11 (ref), GameManager (copy), DataEvent (copy)
    local ValentineShop = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ValentineShop");

    for _, child in ValentineShop.Background.ScrollingFrame:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    for i, v in u11.ValentineShop do
        local v949 = v.Stock > 0;
        local u950;

        if GameManager:hasSkinUnlocked(u11, i) then
            u950 = ValentineShop.Background.Templates.Owned:Clone();
        elseif v949 then
            u950 = ValentineShop.Background.Templates.Stock:Clone();
        else
            u950 = ValentineShop.Background.Templates.NoStock:Clone();
        end;

        u950.LayoutOrder = v.Order;
        u950.Item.Text = i;
        u950.Icon.ImageLabel.Image = "rbxassetid://" .. GameManager:getImageId(i);
        u950.Icon.ImageLabel.ImageColor3 = GameManager:getImageColor(i);

        if u950.Name == "Stock" then
            u950.Stock.Text = "X" .. v.Stock .. " Stock";
            u950.Price.Embers.Text = v.Price;
            u950.ImageButton.MouseButton1Down:Connect(function() -- Line: 15138
                -- upvalues: DataEvent (ref), i (copy)
                DataEvent:FireServer("buyValentineShopItem", i);
            end);
        end;

        if GameManager:hasSkinUnlocked(u11, i) then
            u950.ImageButton.TextLabel.Text = GameManager:hasSkin(u11, i) and "Unequip" or "Equip";
            u950.ImageButton.BackgroundColor3 = GameManager:hasSkin(u11, i) and Color3.fromRGB(100, 36, 36) or Color3.fromRGB(63, 100, 38);
            u950.ImageButton.MouseButton1Down:Connect(function() -- Line: 15147
                -- upvalues: u950 (ref), DataEvent (ref), i (copy)
                DataEvent:FireServer(u950.ImageButton.TextLabel.Text == "Equip" and "equipSkin" or "unequipSkin", i);
            end);
        end;

        local u951 = GameManager.Items[i] or (GameManager.Clothing[i] or GameManager.ValentineShopItems[i]);
        u950.Icon.ImageLabel.MouseEnter:Connect(function() -- Line: 15155
            -- upvalues: ValentineShop (copy), u951 (copy)
            ValentineShop.Background.Description.Visible = true;
            ValentineShop.Background.Description.TextLabel.Text = u951.Description;
        end);
        u950.Icon.ImageLabel.MouseLeave:Connect(function() -- Line: 15159
            -- upvalues: ValentineShop (copy)
            ValentineShop.Background.Description.Visible = false;
            ValentineShop.Background.Description.TextLabel.Text = "";
        end);
        u950.Visible = true;
        u950.Parent = ValentineShop.Background.ScrollingFrame;
    end;
end;

if valentine then
    updateValentineShop();
end;

function updateEventCollectionShop()
    -- upvalues: LocalPlayer (copy), u11 (ref), GameManager (copy), DataEvent (copy)
    local EventCollectionShop = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("EventCollectionShop");

    for _, child in EventCollectionShop.Background.ScrollingFrame:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    for i, v in u11.EventCollectionShop do
        local v952 = v.Stock > 0;
        local u953;

        if GameManager:hasSkinUnlocked(u11, i, true) then
            u953 = EventCollectionShop.Background.Templates.Owned:Clone();
        elseif v952 then
            u953 = EventCollectionShop.Background.Templates.Stock:Clone();
        else
            u953 = EventCollectionShop.Background.Templates.NoStock:Clone();
        end;

        u953.LayoutOrder = v.Order;
        u953.Item.Text = i;
        u953.Icon.ImageLabel.Image = "rbxassetid://" .. GameManager:getImageId(i);
        u953.Icon.ImageLabel.ImageColor3 = GameManager:getImageColor(i);

        if u953.Name == "Stock" then
            u953.Stock.Text = "X" .. v.Stock .. " Stock";
            u953.Price.Embers.Text = v.Price;
            u953.Price.Frame.Visible = true;

            if GameManager.EventCollectionShopItems[i].PriceType == "Ryo" then
                u953.Price.Frame.ImageLabel.Image = "rbxassetid://5616027378";
                u953.Price.Frame.ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255);
            elseif GameManager.EventCollectionShopItems[i].PriceType == "Acumen" then
                u953.Price.Frame.ImageLabel.Image = "rbxassetid://9805819947";
                u953.Price.Frame.ImageLabel.ImageColor3 = Color3.fromRGB(255, 128, 190);
            elseif GameManager.EventCollectionShopItems[i].PriceType == "Chakra Fragments" then
                u953.Price.Frame.ImageLabel.Image = "rbxassetid://6635420276";
                u953.Price.Frame.ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255);
            elseif string.match(GameManager.EventCollectionShopItems[i].Price, "Schematics") then
                u953.Price.Frame.Visible = false;
                u953.Price.Embers.Text = "x1 " .. GameManager.EventCollectionShopItems[i].Price;
            elseif GameManager.EventCollectionShopItems[i].Price == "Chakra Bow" then
                u953.Price.Frame.Visible = false;
                u953.Price.Embers.Text = "x1 " .. GameManager.EventCollectionShopItems[i].Price;
            end;

            u953.ImageButton.MouseButton1Down:Connect(function() -- Line: 15223
                -- upvalues: DataEvent (ref), i (copy)
                DataEvent:FireServer("buyEventCollectionShopItem", i);
            end);
        end;

        if GameManager:hasSkinUnlocked(u11, i, true) then
            u953.ImageButton.TextLabel.Text = GameManager:hasSkin(u11, i) and "Unequip" or "Equip";
            u953.ImageButton.BackgroundColor3 = GameManager:hasSkin(u11, i) and Color3.fromRGB(100, 36, 36) or Color3.fromRGB(63, 100, 38);
            u953.ImageButton.MouseButton1Down:Connect(function() -- Line: 15232
                -- upvalues: u953 (ref), DataEvent (ref), i (copy)
                DataEvent:FireServer(u953.ImageButton.TextLabel.Text == "Equip" and "equipSkin" or "unequipSkin", i);
            end);
        end;

        local u954 = GameManager.Items[i] or GameManager.Clothing[i] or (GameManager.HalloweenShopItems[i] or GameManager.XmasShopItems[i] or (GameManager.ValentineShopItems[i] or GameManager.EventCollectionShopItems[i]));
        u953.Icon.ImageLabel.MouseEnter:Connect(function() -- Line: 15240
            -- upvalues: EventCollectionShop (copy), u954 (copy)
            EventCollectionShop.Background.Description.Visible = true;
            EventCollectionShop.Background.Description.TextLabel.Text = u954.Description;
        end);
        u953.Icon.ImageLabel.MouseLeave:Connect(function() -- Line: 15244
            -- upvalues: EventCollectionShop (copy)
            EventCollectionShop.Background.Description.Visible = false;
            EventCollectionShop.Background.Description.TextLabel.Text = "";
        end);
        u953.Visible = true;
        u953.Parent = EventCollectionShop.Background.ScrollingFrame;
    end;
end;

updateEventCollectionShop();

local function updateBarriers() -- Line: 15255
    -- upvalues: u32 (copy), GameManager (copy), u11 (ref)
    for _, v in game:GetService("CollectionService"):GetTagged("Barrier") do
        if u32.InDanger then
            v.CanCollide = true;
        else
            local v955 = v:GetAttribute("Whitelist");

            if v955 then
                local v956 = GameManager:StringToArray(v955);

                if table.find(v956, u11.Village) then
                    v.CanCollide = false;
                else
                    v.CanCollide = true;
                end;
            end;
        end;
    end;
end;

function updateDog()
    -- upvalues: u11 (ref), GameManager (copy)
    if u11.Quests.Dog.Progress ~= "FinishedGood" then
        if u11.Quests.Dog.Progress == "FinishedBad" then
            local Dog = workspace.Dog;
            GameManager:genericTeleportBubble(Dog:GetPivot().Position, Dog:GetPivot().Position);
            Dog:Destroy();
        end;

        return;
    end;

    local Dog = workspace.Dog;

    for _, child in Dog.Tongue:GetChildren() do
        child.Transparency = 1;
    end;

    Dog.Chicken.Transparency = 0;
end;

if u11.Quests.Dog and u11.Quests.Dog.Completed then
    updateDog();
end;

local function updateWiseTree() -- Line: 15293
    -- upvalues: u11 (ref)
    if not u11.Quests["The Wise Tree 2"] then
        return;
    end;

    if not u11.Quests["The Wise Tree 2"].Completed then
        return;
    end;

    for _, child in workspace["The Wise Tree"]:GetChildren() do
        if child.Name == "Eye" then
            child.Color = Color3.fromRGB(212, 0, 255);
        end;
    end;
end;

function updateAvalancheCampfire()
    -- upvalues: u11 (ref)
    if u11.Quests.Avalanche and u11.Quests.Avalanche.Completed then
        local v957 = game:GetService("CollectionService"):GetTagged("Avalanche")[1];

        for _, child in v957:GetChildren() do
            child.Enabled = true;
        end;

        v957.Parent.Parent.CampfireRockPit.CampfireBase.Color = Color3.fromRGB(255, 121, 12);
    end;
end;

updateAvalancheCampfire();

function updateOutKeeperProgress()
    -- upvalues: u11 (ref)
    if u11.Quests.OutKeeper then
        if u11.Quests.OutKeeper.Progress == "FinishedGood" then
            local OutKeeper = workspace:FindFirstChild("OutKeeper");

            if OutKeeper then
                OutKeeper:Destroy();
            end;
        elseif u11.Quests.OutKeeper.InnKeeperID then
            local InnKeeperID = u11.Quests.OutKeeper.InnKeeperID;

            for _, child in workspace:GetChildren() do
                if child.Name == "InnKeeper" and child:GetAttribute("ID") == InnKeeperID then
                    child:Destroy();
                end;
            end;
        end;
    end;
end;

updateOutKeeperProgress();

function updateIceMirrors()
    -- upvalues: u11 (ref)
    for _, child in workspace:GetChildren() do
        if child.Name == "Icy Mirror" and child:GetAttribute("Mirror") then
            local v958 = child:GetAttribute("Mirror");
            child["Cube.003"].Material = Enum.Material.Ice;
            child["Cube.003"].Color = Color3.fromRGB(124, 148, 204);

            if u11.Quests["Ice Release"] and u11.Quests["Ice Release"].Mirrors[v958] then
                child["Cube.003"].Material = Enum.Material.Neon;
                child["Cube.003"].Color = Color3.fromRGB(255, 255, 255);
            elseif child:GetAttribute("Occupied") then
                child["Cube.003"].Color = Color3.fromRGB(0, 0, 0);
            else
                child["Cube.003"].Color = Color3.fromRGB(124, 148, 204);
            end;
        end;
    end;
end;

updateBarriers();
updateWiseTree();
updateIceMirrors();
u3.UpdatedData:Connect(function() -- Line: 15366
    -- upvalues: updateBarriers (copy), updateWiseTree (copy), Embers (copy), u11 (ref)
    updateBarriers();
    updateWiseTree();
    updateTraitFrame();
    updateAvalancheCampfire();
    updateOutKeeperProgress();
    updateIceMirrors();

    if xmas then
        updateXmasShop();
    end;

    if halloween then
        updateHalloweenShop();
    end;

    if valentine then
        updateValentineShop();
    end;

    updateEventCollectionShop();
    Embers.Visible = u11.Embers > 0;
end);
task.spawn(function() -- Line: 15391
    -- upvalues: DataEvent (copy), u32 (copy)
    while task.wait(1) do
        if snowing then
            DataEvent:FireServer("SetSnowAbove", u32.actualRainAbove);
        else
            DataEvent:FireServer("SetRainAbove", u32.actualRainAbove);
        end;
    end;
end);
Danger:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 15401
    -- upvalues: updateBarriers (copy)
    updateBarriers();
end);
u10:WaitForChild("Awakened"):GetPropertyChangedSignal("Value"):Connect(function() -- Line: 15405
    -- upvalues: u10 (copy), u48 (copy), GameManager (copy), Humanoid (copy), u32 (copy)
    if u10.Awakened.Value ~= "Jinchuriki [Stage 3]" then
        if u10.Awakened.Value == "" then
            u48.Run:Stop();
            u48.Run:Destroy();
            u48.Run = GameManager:getAnimation("Run", Humanoid);

            if u32.Running then
                u48.Run:Play();

                return;
            end;

            u48.Run:Stop();
        end;

        return;
    end;

    u48.Run:Stop();
    u48.Run:Destroy();
    u48.Run = GameManager:getAnimation("Jinchuriki Run", Humanoid);
end);
local u959 = nil;
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() -- Line: 15424
    -- upvalues: u959 (ref), u9 (copy), Humanoid (copy)
    if u959 then
        return;
    end;

    if u9:FindFirstChild("Weights") then
        u959 = true;
        local v960 = Humanoid;
        v960.WalkSpeed = v960.WalkSpeed * 0.7;
        u959 = nil;
    end;
end);
local u961 = nil;
Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function() -- Line: 15435
    -- upvalues: u961 (ref), u9 (copy), Humanoid (copy)
    if u961 then
        return;
    end;

    if u9:FindFirstChild("Weights") then
        u961 = true;
        local v962 = Humanoid;
        v962.JumpPower = v962.JumpPower * 0.9;
        u961 = nil;
    end;
end);
u9.ChildAdded:Connect(function(p963) -- Line: 15445
    -- upvalues: u961 (ref), u959 (ref), Humanoid (copy)
    if p963.Name == "Weights" then
        u961 = true;
        u959 = true;
        local v964 = Humanoid;
        v964.WalkSpeed = v964.WalkSpeed * 0.7;
        local v965 = Humanoid;
        v965.JumpPower = v965.JumpPower * 0.9;
        u961 = nil;
        u959 = nil;
    end;
end);
u9.ChildAdded:Connect(function(p966) -- Line: 15457
    -- upvalues: ReplicatedStorage (copy), disableRun (copy), GameManager (copy), Humanoid (copy), TweenService (copy), LocalPlayer (copy), u9 (copy)
    if p966.Name ~= "Sandstorm" or game.Lighting:FindFirstChild("Sandstorm") then
        if p966.Name == "Snowstorm" and not (game.Lighting:FindFirstChild("Snowstorm") or u9:GetAttribute("IceUltimate")) then
            local v967 = ReplicatedStorage.UI.Snowstorm.Snowstorm:Clone();
            v967.Enabled = false;
            v967.Parent = game.Lighting;
            disableRun();
            GameManager:getAnimation("HeadCover", Humanoid, Enum.AnimationPriority.Action2):Play();
            TweenService:Create(LocalPlayer.PlayerGui.EffectsGui.Snowstorm, TweenInfo.new(0.5), {
                ImageTransparency = 0.35
            }):Play();
            TweenService:Create(game.Lighting, TweenInfo.new(1, Enum.EasingStyle.Linear), {
                FogEnd = 200
            }):Play();
        end;

        return;
    end;

    ReplicatedStorage.UI.Sandstorm.Sandstorm:Clone().Parent = game.Lighting;
    disableRun();
    GameManager:getAnimation("HeadCover", Humanoid, Enum.AnimationPriority.Action2):Play();
    TweenService:Create(LocalPlayer.PlayerGui.EffectsGui.Sandstorm, TweenInfo.new(0.5), {
        ImageTransparency = 0.35
    }):Play();
    TweenService:Create(game.Lighting, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        FogEnd = 200
    }):Play();
end);
u9.ChildRemoved:Connect(function(p968) -- Line: 15482
    -- upvalues: u9 (copy), GameManager (copy), Humanoid (copy), TweenService (copy), LocalPlayer (copy), u32 (copy)
    if p968.Name ~= "Sandstorm" or u9:FindFirstChild("Sandstorm") then
        if p968.Name == "Snowstorm" and not (u9:FindFirstChild("Snowstorm") or u9:GetAttribute("IceUltimate")) then
            for _, child in game.Lighting:GetChildren() do
                if child.Name == "Snowstorm" then
                    child:Destroy();
                end;
            end;

            GameManager:stopAnimation("HeadCover", Humanoid);
            TweenService:Create(LocalPlayer.PlayerGui.EffectsGui.Snowstorm, TweenInfo.new(0.5), {
                ImageTransparency = 1
            }):Play();
            TweenService:Create(game.Lighting, TweenInfo.new(1, Enum.EasingStyle.Linear), {
                FogEnd = GameManager.Locations[u32.currentLocation].FogEnd
            }):Play();
        end;

        return;
    end;

    for _, child in game.Lighting:GetChildren() do
        if child.Name == "Sandstorm" then
            child:Destroy();
        end;
    end;

    GameManager:stopAnimation("HeadCover", Humanoid);
    TweenService:Create(LocalPlayer.PlayerGui.EffectsGui.Sandstorm, TweenInfo.new(0.5), {
        ImageTransparency = 1
    }):Play();
    TweenService:Create(game.Lighting, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        FogEnd = GameManager.Locations[u32.currentLocation].FogEnd
    }):Play();
end);
HumanoidRootPart.Jump.Played:Connect(function() -- Line: 15514
    -- upvalues: HumanoidRootPart (copy), GameManager (copy), u11 (ref)
    if not HumanoidRootPart.Jump:GetAttribute("OriginalVolume") then
        HumanoidRootPart.Jump:SetAttribute("OriginalVolume", HumanoidRootPart.Jump.Volume);
    end;

    if GameManager.Clothing[u11.Clothing].Stealth then
        HumanoidRootPart.Jump.Volume = 0.18;

        return;
    end;

    HumanoidRootPart.Jump.Volume = HumanoidRootPart.Jump:GetAttribute("OriginalVolume");
end);
u9.AttributeChanged:Connect(function(p969) -- Line: 15526
    -- upvalues: updateLocation (copy), u32 (copy)
    if p969 == "IceUltimate" then
        updateLocation(u32.currentLocation);
    end;
end);
LocalPlayer.Backpack.ChildAdded:Connect(function(p970) -- Line: 15532
    -- upvalues: DataEvent (copy)
    DataEvent:FireServer("BanMe", "Offense 1J");
end);


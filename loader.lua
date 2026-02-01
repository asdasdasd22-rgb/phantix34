--[[
    phantix.lol - HWID Whitelist System
    
    How to whitelist users:
    1. User runs script, copies HWID
    2. User sends HWID to you
    3. You add HWID to: https://pastebin.com/EyR3ByP8
    4. User runs script again = works!
]]

if getgenv().PhantixLoaded then return end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- HWID Whitelist URL (Your Pastebin)
local WHITELIST_URL = "https://pastebin.com/raw/EyR3ByP8"

-- Get HWID
local function GetHWID()
    local hwid = ""
    pcall(function()
        if gethwid then
            hwid = gethwid()
        elseif getexecutorname then
            hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        else
            hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        end
    end)
    if hwid == "" then
        hwid = LocalPlayer.UserId .. "_" .. game.PlaceId
    end
    return hwid
end

local HWID = GetHWID()

-- Check if HWID is whitelisted
local function IsWhitelisted()
    local success, result = pcall(function()
        local list = game:HttpGet(WHITELIST_URL)
        for line in list:gmatch("[^\r\n]+") do
            local cleanLine = line:gsub("%s+", "")
            if cleanLine == HWID or cleanLine == "*" then
                return true
            end
        end
        return false
    end)
    return success and result
end

-- Create HWID Check UI
local KeyUI = Instance.new("ScreenGui")
KeyUI.Name = "PhantixHWID"
KeyUI.ResetOnSpawn = false
pcall(function() KeyUI.Parent = CoreGui end)
if not KeyUI.Parent then KeyUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Parent = KeyUI
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 380, 0, 200)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(135, 206, 250)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 15)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "phantix.lol"
Title.TextColor3 = Color3.fromRGB(135, 206, 250)
Title.TextSize = 24

local Status = Instance.new("TextLabel", Main)
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 0, 0, 50)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Font = Enum.Font.Gotham
Status.Text = "Checking HWID..."
Status.TextColor3 = Color3.fromRGB(255, 200, 0)
Status.TextSize = 14

local HWIDFrame = Instance.new("Frame", Main)
HWIDFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
HWIDFrame.Position = UDim2.new(0.5, -160, 0, 80)
HWIDFrame.Size = UDim2.new(0, 320, 0, 35)
Instance.new("UICorner", HWIDFrame).CornerRadius = UDim.new(0, 8)

local HWIDText = Instance.new("TextLabel", HWIDFrame)
HWIDText.BackgroundTransparency = 1
HWIDText.Position = UDim2.new(0, 10, 0, 0)
HWIDText.Size = UDim2.new(1, -20, 1, 0)
HWIDText.Font = Enum.Font.Code
HWIDText.Text = string.sub(HWID, 1, 32) .. "..."
HWIDText.TextColor3 = Color3.fromRGB(100, 100, 100)
HWIDText.TextSize = 11
HWIDText.TextTruncate = Enum.TextTruncate.AtEnd

local CopyHWID = Instance.new("TextButton", Main)
CopyHWID.BackgroundColor3 = Color3.fromRGB(135, 206, 250)
CopyHWID.Position = UDim2.new(0.5, -160, 0, 125)
CopyHWID.Size = UDim2.new(0, 320, 0, 40)
CopyHWID.Font = Enum.Font.GothamBold
CopyHWID.Text = "📋 COPY HWID"
CopyHWID.TextColor3 = Color3.fromRGB(20, 20, 30)
CopyHWID.TextSize = 15
CopyHWID.Visible = false
Instance.new("UICorner", CopyHWID).CornerRadius = UDim.new(0, 8)

local Info = Instance.new("TextLabel", Main)
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(0, 0, 1, -25)
Info.Size = UDim2.new(1, 0, 0, 20)
Info.Font = Enum.Font.Gotham
Info.Text = "Send HWID to admin to get whitelisted"
Info.TextColor3 = Color3.fromRGB(70, 70, 70)
Info.TextSize = 11
Info.Visible = false

-- Dragging
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)
Main.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Copy HWID Button
CopyHWID.MouseButton1Click:Connect(function()
    setclipboard(HWID)
    CopyHWID.Text = "✓ COPIED!"
    CopyHWID.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    task.wait(2)
    CopyHWID.Text = "📋 COPY HWID"
    CopyHWID.BackgroundColor3 = Color3.fromRGB(135, 206, 250)
end)

-- Check whitelist and load
task.spawn(function()
    task.wait(0.5)
    
    if IsWhitelisted() then
        Status.Text = "✓ HWID Whitelisted!"
        Status.TextColor3 = Color3.fromRGB(80, 255, 80)
        Stroke.Color = Color3.fromRGB(80, 255, 80)
        HWIDFrame.Visible = false
        
        task.wait(1.5)
        KeyUI:Destroy()
        
        -- Load main script
        LoadPhantix()
    else
        Status.Text = "✗ HWID Not Whitelisted"
        Status.TextColor3 = Color3.fromRGB(255, 80, 80)
        Stroke.Color = Color3.fromRGB(255, 80, 80)
        CopyHWID.Visible = true
        Info.Visible = true
        
        -- Shake effect
        local orig = Main.Position
        for i = 1, 5 do
            Main.Position = orig + UDim2.new(0, math.random(-8, 8), 0, 0)
            task.wait(0.04)
        end
        Main.Position = orig
    end
end)

function LoadPhantix()
    getgenv().PhantixLoaded = true

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local GuiService = game:GetService("GuiService")
    local Lighting = game:GetService("Lighting")
    local StatsService = game:GetService("Stats")
    local TeleportService = game:GetService("TeleportService")
    local VirtualUser = game:GetService("VirtualUser")
    local SoundService = game:GetService("SoundService")
    local HttpService = game:GetService("HttpService")
    local CoreGui = game:GetService("CoreGui")
    local GuiInset = GuiService:GetGuiInset()

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local Camera = Workspace.CurrentCamera

    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/imagoodpersond/puppyware/main/lib"))()
    local NotifyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/imagoodpersond/puppyware/main/notify"))()
    local Notify = NotifyLibrary.Notify

    local Games = {
        [2788229376] = {Name = "Da Hood", Argument = "UpdateMousePosI2", Remote = "MainEvent"},
        [16033173781] = {Name = "Da Hood Macro", Argument = "UpdateMousePosI2", Remote = "MainEvent"},
        [7213786345] = {Name = "Da Hood VC", Argument = "UpdateMousePosI2", Remote = "MainEvent"},
        [9825515356] = {Name = "Hood Customs", Argument = "MousePosUpdate", Remote = "MainEvent"},
        [5602055394] = {Name = "Hood Modded", Argument = "MousePos", Remote = "Bullets"},
    }
    local CurrentGame = Games[game.PlaceId] or {Name = "Unknown", Argument = "UpdateMousePos", Remote = "MainEvent"}
    local MainEvent = ReplicatedStorage:FindFirstChild(CurrentGame.Remote)

    local OriginalLighting = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        GlobalShadows = Lighting.GlobalShadows,
        ClockTime = Lighting.ClockTime,
    }
    local OriginalGravity = Workspace.Gravity

    local Settings = {
        UI = {Keybind = Enum.KeyCode.RightShift, Snowfall = false, Watermark = false},
        SilentAim = {
            Enabled = false, UseFOV = false, ShowFOV = false, KOCheck = false,
            GrabbedCheck = false, ClosestPart = false, AutoPrediction = false, AirShot = false,
            Hitbox = "HumanoidRootPart", Prediction = 0.138, FOVRadius = 170,
            FOVColor = Color3.fromRGB(0, 255, 0), JumpOffset = 2, Distance = 2000,
        },
        Camlock = {
            Enabled = false, Sticky = false, ClosestPart = false, ShowFOV = false,
            AutoPrediction = false, Smoothing = false, Hitbox = "Head", FOVSize = 200,
            FOVColor = Color3.fromRGB(0, 255, 0), GroundSmooth = 0.04, AirSmooth = 0.06,
            Prediction = 0.125, JumpOffset = 2,
        },
        Triggerbot = {Enabled = false, Mode = "Toggle", Delay = 0.01, HeadshotOnly = false},
        HitboxExpander = {Enabled = false, Visualize = false, Size = 15, Part = "HumanoidRootPart"},
        AntiAim = {Enabled = false, Desync = false, Jitter = false, Velocity = -5, DesyncVelocity = 100, JitterAmount = 45},
        Macro = {Enabled = false, Type = "Electron"},
        KillAura = {Enabled = false, Range = 15, Visualize = false},
        AutoStomp = {Enabled = false, Range = 15},
        ESP = {
            Enabled = false, Distance = 3000, Names = false, NamesColor = Color3.fromRGB(255, 255, 255),
            Health = false, Box = false, BoxColor = Color3.fromRGB(255, 0, 0),
            Tracers = false, TracerColor = Color3.fromRGB(255, 0, 0),
        },
        Chams = {Enabled = false, FillColor = Color3.fromRGB(255, 0, 127), OutlineColor = Color3.fromRGB(255, 255, 255), FillTransparency = 0.5},
        Snaplines = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
        Radar = {Enabled = false, Size = 150, Scale = 50, EnemyColor = Color3.fromRGB(255, 0, 0)},
        Crosshair = {Enabled = false, Color = Color3.fromRGB(199, 110, 255), Length = 10, Radius = 11, Spin = false, Resize = false, Outline = false, Dot = false},
        Fullbright = {Enabled = false},
        NoFog = {Enabled = false},
        CustomFog = {Enabled = false, End = 1000, Color = Color3.fromRGB(128, 128, 128)},
        TimeChanger = {Enabled = false, Time = 12},
        NoShadows = {Enabled = false},
        Trail = {Enabled = false, Color1 = Color3.fromRGB(255, 110, 0), Color2 = Color3.fromRGB(255, 0, 0), Lifetime = 1.6},
        WalkSpeed = {Enabled = false, Value = 50},
        JumpPower = {Enabled = false, Value = 75},
        Gravity = {Enabled = false, Value = 196.2},
        Fly = {Enabled = false, Speed = 50},
        Noclip = {Enabled = false},
        InfiniteJump = {Enabled = false},
        BunnyHop = {Enabled = false},
        Spinbot = {Enabled = false, Speed = 15},
        AntiVoid = {Enabled = false, Height = -100},
        AntiSlow = {Enabled = false},
        ClickTP = {Enabled = false},
        HitDetection = {Enabled = false, Sound = false, SoundType = "Skeet", Volume = 1, Logs = false, HitMarker = false},
        AntiAFK = {Enabled = false},
        FOVChanger = {Enabled = false, Value = 90},
        Keybinds = {
            Camlock = Enum.KeyCode.Q, Triggerbot = Enum.KeyCode.T, Fly = Enum.KeyCode.F,
            Noclip = Enum.KeyCode.H, InfiniteJump = Enum.KeyCode.J, WalkSpeed = Enum.KeyCode.Z,
            Spinbot = Enum.KeyCode.N, Macro = Enum.KeyCode.X, AntiAim = Enum.KeyCode.P,
            ClickTP = Enum.KeyCode.Y, Panic = Enum.KeyCode.End,
        },
    }

    local HitSounds = {
        Skeet = "rbxassetid://5633695679", Rust = "rbxassetid://1255040462",
        Minecraft = "rbxassetid://4018616850", Pop = "rbxassetid://198598793",
        Bonk = "rbxassetid://5766898159", Bell = "rbxassetid://6534947240",
    }
    local HitSound = Instance.new("Sound", SoundService)

    local Connections = {}
    local UIVisible = true
    local PhantixWindow = nil
    local Targets = {Camlock = nil}
    local Locks = {Camlock = false}
    local Toggles = {Trigger = false, Fly = false, Noclip = false, InfJump = false, WalkSpeed = false, Spinbot = false, Macro = false, AntiAim = false}
    local FlyBody, FlyGyro = nil, nil
    local LastHealth = {}
    local LastTrigger = 0
    local StartTime = tick()

    local ESPObjects = {}
    local ChamsObjects = {}
    local SnaplineObjects = {}
    local RadarDots = {}
    local Snowflakes = {}
    local CrosshairLines = {}
    local HitMarkers = {}

    local Drawings = {
        SilentFOV = Drawing.new("Circle"),
        CamlockFOV = Drawing.new("Circle"),
        TargetTracer = Drawing.new("Line"),
        TargetDot = Drawing.new("Circle"),
        Watermark = Drawing.new("Text"),
        RadarBG = Drawing.new("Square"),
        RadarBorder = Drawing.new("Square"),
        RadarSelf = Drawing.new("Circle"),
        CrosshairDot = Drawing.new("Circle"),
        KillAuraCircle = Drawing.new("Circle"),
    }

    for _, d in pairs(Drawings) do d.Visible = false end
    Drawings.SilentFOV.NumSides = 64
    Drawings.SilentFOV.Thickness = 1
    Drawings.CamlockFOV.NumSides = 64
    Drawings.CamlockFOV.Thickness = 1
    Drawings.RadarSelf.Filled = true
    Drawings.RadarSelf.Radius = 4
    Drawings.RadarSelf.Color = Color3.fromRGB(0, 255, 0)
    Drawings.Watermark.Size = 16
    Drawings.Watermark.Font = 2
    Drawings.Watermark.Outline = true
    Drawings.Watermark.Position = Vector2.new(10, 10)
    Drawings.KillAuraCircle.NumSides = 64
    Drawings.KillAuraCircle.Filled = false
    Drawings.KillAuraCircle.Thickness = 1

    for i = 1, 8 do CrosshairLines[i] = Drawing.new("Line"); CrosshairLines[i].Visible = false end
    for i = 1, 4 do HitMarkers[i] = Drawing.new("Line"); HitMarkers[i].Thickness = 2; HitMarkers[i].Visible = false end

    local function GetPing()
        local s, p = pcall(function()
            return tonumber(string.split(StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString(), "(")[1]) or 50
        end)
        return s and p or 50
    end

    local function GetFPS() return math.floor(1 / RunService.RenderStepped:Wait()) end

    local function AutoPrediction()
        local ping = GetPing()
        if ping < 30 then return 0.121 elseif ping < 50 then return 0.128 elseif ping < 70 then return 0.136
        elseif ping < 90 then return 0.148 elseif ping < 110 then return 0.156 else return 0.175 end
    end

    local function IsKnocked(c) local be = c and c:FindFirstChild("BodyEffects"); return be and be:FindFirstChild("K.O") and be["K.O"].Value end
    local function IsGrabbed(c) return c and c:FindFirstChild("GRABBING_CONSTRAINT") end
    local function Alive(p) return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 end
    local function IsValid(p)
        if not p or p == LocalPlayer or not Alive(p) then return false end
        if Settings.SilentAim.KOCheck and IsKnocked(p.Character) then return false end
        if Settings.SilentAim.GrabbedCheck and IsGrabbed(p.Character) then return false end
        return true
    end

    local function GetClosest(fov, range)
        local closest, dist = nil, fov or math.huge
        local mouse = UserInputService:GetMouseLocation()
        for _, p in pairs(Players:GetPlayers()) do
            if IsValid(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (not range or (hrp.Position - Camera.CFrame.Position).Magnitude <= range) then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                        if d < dist then closest, dist = p, d end
                    end
                end
            end
        end
        return closest, dist
    end

    local function GetClosestPart(char, parts)
        if not char then return nil end
        local closest, dist = nil, math.huge
        local mouse = UserInputService:GetMouseLocation()
        for _, name in pairs(parts or {"HumanoidRootPart"}) do
            local part = char:FindFirstChild(name)
            if part then
                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if d < dist then closest, dist = part, d end
                end
            end
        end
        return closest
    end

    local function PlayHit()
        if not Settings.HitDetection.Sound then return end
        HitSound.SoundId = HitSounds[Settings.HitDetection.SoundType] or HitSounds.Skeet
        HitSound.Volume = Settings.HitDetection.Volume
        HitSound.TimePosition = 0
        HitSound:Play()
    end

    local function ShowHitMarker()
        if not Settings.HitDetection.HitMarker then return end
        local c = Camera.ViewportSize / 2
        local s = 20
        local positions = {
            {Vector2.new(c.X - s, c.Y - s), Vector2.new(c.X - s/2, c.Y - s/2)},
            {Vector2.new(c.X + s, c.Y - s), Vector2.new(c.X + s/2, c.Y - s/2)},
            {Vector2.new(c.X - s, c.Y + s), Vector2.new(c.X - s/2, c.Y + s/2)},
            {Vector2.new(c.X + s, c.Y + s), Vector2.new(c.X + s/2, c.Y + s/2)},
        }
        for i = 1, 4 do
            HitMarkers[i].From = positions[i][1]
            HitMarkers[i].To = positions[i][2]
            HitMarkers[i].Color = Color3.fromRGB(255, 0, 0)
            HitMarkers[i].Visible = true
        end
        task.delay(0.3, function() for i = 1, 4 do HitMarkers[i].Visible = false end end)
    end

    local function UpdateSnowfall(dt)
        if not Settings.UI.Snowfall then
            for _, f in pairs(Snowflakes) do f.d.Visible = false end
            return
        end
        while #Snowflakes < 80 do
            local s = Drawing.new("Circle")
            s.Radius = math.random(2, 4)
            s.Color = Color3.new(1, 1, 1)
            s.Filled = true
            s.Transparency = math.random(4, 8) / 10
            s.Position = Vector2.new(math.random(0, Camera.ViewportSize.X), -10)
            s.ZIndex = -1000
            table.insert(Snowflakes, {d = s, sp = math.random(40, 120) / 100, sw = math.random(-40, 40) / 100, of = math.random(0, 360)})
        end
        for _, f in ipairs(Snowflakes) do
            local p = f.d.Position
            local ny = p.Y + f.sp * 60 * dt
            local sx = math.sin(tick() + f.of) * f.sw * 30
            f.d.Position = ny > Camera.ViewportSize.Y + 20 and Vector2.new(math.random(0, Camera.ViewportSize.X), -10) or Vector2.new(p.X + sx * dt, ny)
            f.d.Visible = true
        end
    end

    local function UpdateWorld()
        if Settings.Fullbright.Enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        else
            if not Settings.TimeChanger.Enabled then
                Lighting.ClockTime = OriginalLighting.ClockTime
            end
            if not Settings.NoFog.Enabled and not Settings.CustomFog.Enabled then
                Lighting.FogEnd = OriginalLighting.FogEnd
            end
            if not Settings.NoShadows.Enabled then
                Lighting.GlobalShadows = OriginalLighting.GlobalShadows
            end
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.Ambient = OriginalLighting.Ambient
        end
        
        if Settings.NoFog.Enabled then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
        elseif Settings.CustomFog.Enabled then
            Lighting.FogEnd = Settings.CustomFog.End
            Lighting.FogColor = Settings.CustomFog.Color
            Lighting.FogStart = 0
        else
            if not Settings.Fullbright.Enabled then
                Lighting.FogEnd = OriginalLighting.FogEnd
                Lighting.FogStart = OriginalLighting.FogStart
                Lighting.FogColor = OriginalLighting.FogColor
            end
        end
        
        if Settings.TimeChanger.Enabled then
            Lighting.ClockTime = Settings.TimeChanger.Time
        elseif not Settings.Fullbright.Enabled then
            Lighting.ClockTime = OriginalLighting.ClockTime
        end
        
        if Settings.NoShadows.Enabled then
            Lighting.GlobalShadows = false
        elseif not Settings.Fullbright.Enabled then
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        end
        
        if Settings.Gravity.Enabled then
            Workspace.Gravity = Settings.Gravity.Value
        else
            Workspace.Gravity = OriginalGravity
        end
        
        if Settings.FOVChanger.Enabled then
            Camera.FieldOfView = Settings.FOVChanger.Value
        else
            Camera.FieldOfView = 70
        end
    end

    local function CreateChams(p)
        if p == LocalPlayer then return end
        local h = Instance.new("Highlight")
        h.Name = "PhantixChams"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Enabled = false
        ChamsObjects[p] = h
        if p.Character then h.Adornee = p.Character; h.Parent = p.Character end
        p.CharacterAdded:Connect(function(c) if ChamsObjects[p] then ChamsObjects[p].Adornee = c; ChamsObjects[p].Parent = c end end)
    end

    local function UpdateChams()
        for p, h in pairs(ChamsObjects) do
            if h and h.Parent then
                h.Enabled = Settings.Chams.Enabled and IsValid(p)
                h.FillColor = Settings.Chams.FillColor
                h.OutlineColor = Settings.Chams.OutlineColor
                h.FillTransparency = Settings.Chams.FillTransparency
            end
        end
    end

    local function CreateSnapline(p) if p ~= LocalPlayer then SnaplineObjects[p] = Drawing.new("Line"); SnaplineObjects[p].Visible = false end end

    local function UpdateSnaplines()
        if not Settings.Snaplines.Enabled then for _, l in pairs(SnaplineObjects) do l.Visible = false end return end
        local mouse = UserInputService:GetMouseLocation()
        for p, l in pairs(SnaplineObjects) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and IsValid(p) then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then l.From = mouse; l.To = Vector2.new(pos.X, pos.Y); l.Color = Settings.Snaplines.Color; l.Thickness = 1; l.Visible = true
                else l.Visible = false end
            else l.Visible = false end
        end
    end

    local function UpdateRadar()
        if not Settings.Radar.Enabled then
            Drawings.RadarBG.Visible = false; Drawings.RadarBorder.Visible = false; Drawings.RadarSelf.Visible = false
            for _, d in pairs(RadarDots) do d.Visible = false end
            return
        end
        local sz = Settings.Radar.Size
        local pos = Vector2.new(10, 50)
        Drawings.RadarBG.Size = Vector2.new(sz, sz); Drawings.RadarBG.Position = pos; Drawings.RadarBG.Color = Color3.fromRGB(30, 30, 30); Drawings.RadarBG.Transparency = 0.3; Drawings.RadarBG.Filled = true; Drawings.RadarBG.Visible = true
        Drawings.RadarBorder.Size = Vector2.new(sz, sz); Drawings.RadarBorder.Position = pos; Drawings.RadarBorder.Color = Color3.new(1, 1, 1); Drawings.RadarBorder.Visible = true
        Drawings.RadarSelf.Position = pos + Vector2.new(sz/2, sz/2); Drawings.RadarSelf.Visible = true
        local mc = LocalPlayer.Character
        if not mc or not mc:FindFirstChild("HumanoidRootPart") then return end
        local i = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                i = i + 1
                if not RadarDots[i] then RadarDots[i] = Drawing.new("Circle"); RadarDots[i].Filled = true; RadarDots[i].Radius = 3 end
                local rel = mc.HumanoidRootPart.CFrame:PointToObjectSpace(p.Character.HumanoidRootPart.Position)
                RadarDots[i].Position = pos + Vector2.new(math.clamp((rel.X/Settings.Radar.Scale)+sz/2, 5, sz-5), math.clamp((-rel.Z/Settings.Radar.Scale)+sz/2, 5, sz-5))
                RadarDots[i].Color = Settings.Radar.EnemyColor; RadarDots[i].Visible = IsValid(p)
            end
        end
        for j = i+1, #RadarDots do if RadarDots[j] then RadarDots[j].Visible = false end end
    end

    local function UpdateESP()
        if not Settings.ESP.Enabled then for _, o in pairs(ESPObjects) do for _, d in pairs(o) do d.Visible = false end end return end
        local mouse = UserInputService:GetMouseLocation()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and (hrp.Position - Camera.CFrame.Position).Magnitude <= Settings.ESP.Distance then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if not ESPObjects[p] then
                        ESPObjects[p] = {Name = Drawing.new("Text"), Health = Drawing.new("Text"), Box = Drawing.new("Square"), Tracer = Drawing.new("Line")}
                        ESPObjects[p].Name.Size = 13; ESPObjects[p].Name.Center = true; ESPObjects[p].Name.Outline = true; ESPObjects[p].Name.Font = 2
                        ESPObjects[p].Health.Size = 11; ESPObjects[p].Health.Center = true; ESPObjects[p].Health.Outline = true
                    end
                    local o = ESPObjects[p]
                    local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
                    local bs = 3500 / dist
                    o.Name.Text = p.DisplayName; o.Name.Color = Settings.ESP.NamesColor; o.Name.Position = Vector2.new(pos.X, pos.Y - bs - 14); o.Name.Visible = vis and Settings.ESP.Names
                    if hum and Settings.ESP.Health then
                        o.Health.Text = math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                        o.Health.Color = Color3.fromRGB(255-(hum.Health/hum.MaxHealth*255), hum.Health/hum.MaxHealth*255, 0)
                        o.Health.Position = Vector2.new(pos.X, pos.Y - bs); o.Health.Visible = vis
                    else o.Health.Visible = false end
                    o.Box.Size = Vector2.new(bs, bs*2); o.Box.Position = Vector2.new(pos.X-bs/2, pos.Y-bs); o.Box.Color = Settings.ESP.BoxColor; o.Box.Visible = vis and Settings.ESP.Box
                    if Settings.ESP.Tracers then o.Tracer.From = mouse; o.Tracer.To = Vector2.new(pos.X, pos.Y); o.Tracer.Color = Settings.ESP.TracerColor; o.Tracer.Visible = vis
                    else o.Tracer.Visible = false end
                elseif ESPObjects[p] then for _, d in pairs(ESPObjects[p]) do d.Visible = false end end
            elseif ESPObjects[p] then for _, d in pairs(ESPObjects[p]) do d.Visible = false end end
        end
    end

    local function solve(a, r) return Vector2.new(math.sin(math.rad(a)) * r, math.cos(math.rad(a)) * r) end
    local function UpdateCrosshair()
        local c = Settings.Crosshair
        if not c.Enabled then for i = 1, 8 do CrosshairLines[i].Visible = false end; Drawings.CrosshairDot.Visible = false; return end
        local t = tick()
        local pos = UserInputService:GetMouseLocation()
        Drawings.CrosshairDot.Position = pos; Drawings.CrosshairDot.Radius = 3; Drawings.CrosshairDot.Color = c.Color; Drawings.CrosshairDot.Filled = true; Drawings.CrosshairDot.Visible = c.Dot
        for i = 1, 4 do
            local outline = CrosshairLines[i]; local inline = CrosshairLines[i+4]
            local angle = (i-1) * 90; local length = c.Length
            if c.Spin then angle = angle + (t * 150 % 360) end
            if c.Resize then length = 5 + math.sin(t*5) * 8 + 8 end
            inline.From = pos + solve(angle, c.Radius); inline.To = pos + solve(angle, c.Radius + length); inline.Color = c.Color; inline.Thickness = 1.5; inline.Visible = true
            if c.Outline then outline.From = pos + solve(angle, c.Radius-1); outline.To = pos + solve(angle, c.Radius+length+1); outline.Color = Color3.new(0,0,0); outline.Thickness = 3; outline.Visible = true
            else outline.Visible = false end
        end
    end

    local function ApplyTrail(on)
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        if on then
            if not hrp:FindFirstChild("PhantixTrail") then
                local trail = Instance.new("Trail", hrp); trail.Name = "PhantixTrail"
                local a0 = Instance.new("Attachment", hrp); a0.Position = Vector3.new(0, 1, 0); a0.Name = "TA0"
                local a1 = Instance.new("Attachment", hrp); a1.Position = Vector3.new(0, -1, 0); a1.Name = "TA1"
                trail.Attachment0 = a0; trail.Attachment1 = a1
                trail.Color = ColorSequence.new(Settings.Trail.Color1, Settings.Trail.Color2)
                trail.Lifetime = Settings.Trail.Lifetime; trail.Transparency = NumberSequence.new(0, 1); trail.LightEmission = 0.5
            end
        else
            local trail = hrp:FindFirstChild("PhantixTrail"); if trail then trail:Destroy() end
            local a0 = hrp:FindFirstChild("TA0"); if a0 then a0:Destroy() end
            local a1 = hrp:FindFirstChild("TA1"); if a1 then a1:Destroy() end
        end
    end

    local function StartFly()
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); local hum = c:FindFirstChildOfClass("Humanoid"); if not hrp or not hum then return end
        if FlyBody then FlyBody:Destroy() end; if FlyGyro then FlyGyro:Destroy() end
        FlyBody = Instance.new("BodyVelocity"); FlyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge); FlyBody.Velocity = Vector3.zero; FlyBody.Parent = hrp
        FlyGyro = Instance.new("BodyGyro"); FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); FlyGyro.P = 1e6; FlyGyro.Parent = hrp
        hum.PlatformStand = true
    end

    local function StopFly()
        local c = LocalPlayer.Character; if c then local hum = c:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand = false end end
        if FlyBody then FlyBody:Destroy(); FlyBody = nil end; if FlyGyro then FlyGyro:Destroy(); FlyGyro = nil end
    end

    local function UpdateFly()
        if not Toggles.Fly or not Settings.Fly.Enabled then if FlyBody then StopFly() end return end
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        if not FlyBody or not FlyBody.Parent then StartFly() end
        local speed = Settings.Fly.Speed; local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        FlyBody.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
        FlyGyro.CFrame = Camera.CFrame
    end

    local function DoMovement()
        local c = LocalPlayer.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); local hrp = c:FindFirstChild("HumanoidRootPart")
        if Settings.WalkSpeed.Enabled and Toggles.WalkSpeed and hum then hum.WalkSpeed = Settings.WalkSpeed.Value end
        if Settings.JumpPower.Enabled and hum then hum.JumpPower = Settings.JumpPower.Value end
        if Settings.Noclip.Enabled and Toggles.Noclip then for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        if Settings.Spinbot.Enabled and hrp and hum then hum.AutoRotate = false; hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.Spinbot.Speed), 0) end
        if Settings.AntiSlow.Enabled then
            local be = c:FindFirstChild("BodyEffects"); if be then
                local mov = be:FindFirstChild("Movement"); if mov then for _, x in pairs(mov:GetChildren()) do if x.Name:match("No") or x.Name:match("Reduce") then x:Destroy() end end end
            end
        end
        if Settings.AntiVoid.Enabled and hrp and hrp.Position.Y < Settings.AntiVoid.Height then hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z) end
        if Settings.BunnyHop.Enabled and hum and hum.MoveDirection.Magnitude > 0 and hum:GetState() ~= Enum.HumanoidStateType.Freefall then hum:ChangeState("Jumping") end
    end

    local function DoCamlock()
        if not Settings.Camlock.Enabled or not Locks.Camlock or not Targets.Camlock then return end
        if not IsValid(Targets.Camlock) then Locks.Camlock = false; Targets.Camlock = nil; return end
        local parts = {"Head", "UpperTorso", "HumanoidRootPart"}
        local part = Settings.Camlock.ClosestPart and GetClosestPart(Targets.Camlock.Character, parts) or Targets.Camlock.Character:FindFirstChild(Settings.Camlock.Hitbox)
        if not part then return end
        local pred = Settings.Camlock.AutoPrediction and AutoPrediction() or Settings.Camlock.Prediction
        local hum = Targets.Camlock.Character:FindFirstChildOfClass("Humanoid")
        local smooth = Settings.Camlock.Smoothing and (hum and hum:GetState() == Enum.HumanoidStateType.Freefall and Settings.Camlock.AirSmooth or Settings.Camlock.GroundSmooth) or Settings.Camlock.GroundSmooth
        local targetPos = part.Position + (part.Velocity * pred)
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then targetPos = targetPos + Vector3.new(0, Settings.Camlock.JumpOffset, 0) end
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), smooth)
    end

    local function DoTriggerbot()
        if not Settings.Triggerbot.Enabled or not Toggles.Trigger then return end
        local c = LocalPlayer.Character; if not c then return end
        local tool = c:FindFirstChildOfClass("Tool"); if not tool then return end
        local target = Mouse.Target
        if target then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and target:IsDescendantOf(p.Character) and IsValid(p) then
                    if Settings.Triggerbot.HeadshotOnly and target.Name ~= "Head" then return end
                    if tick() - LastTrigger >= Settings.Triggerbot.Delay then
                        LastTrigger = tick()
                        if mouse1click then mouse1click() else tool:Activate() end
                    end
                    return
                end
            end
        end
    end

    local function DoKillAura()
        if not Settings.KillAura.Enabled then Drawings.KillAuraCircle.Visible = false return end
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); local tool = c:FindFirstChildOfClass("Tool")
        if not hrp then return end
        if Settings.KillAura.Visualize then
            local pos = Camera:WorldToViewportPoint(hrp.Position)
            Drawings.KillAuraCircle.Position = Vector2.new(pos.X, pos.Y); Drawings.KillAuraCircle.Radius = Settings.KillAura.Range * 5; Drawings.KillAuraCircle.Color = Color3.fromRGB(255, 0, 0); Drawings.KillAuraCircle.Visible = true
        else Drawings.KillAuraCircle.Visible = false end
        if not tool then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and IsValid(p) then
                local theirHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if theirHRP and (hrp.Position - theirHRP.Position).Magnitude <= Settings.KillAura.Range then tool:Activate(); return end
            end
        end
    end

    local function DoAutoStomp()
        if not Settings.AutoStomp.Enabled then return end
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local theirHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if theirHRP and IsKnocked(p.Character) and (hrp.Position - theirHRP.Position).Magnitude <= Settings.AutoStomp.Range then
                    if keypress then keypress(0x45); task.wait(0.1); keyrelease(0x45) end
                    return
                end
            end
        end
    end

    local function DoHitboxExpander()
        if not Settings.HitboxExpander.Enabled then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local part = p.Character:FindFirstChild(Settings.HitboxExpander.Part)
                if part then
                    part.Size = Vector3.new(Settings.HitboxExpander.Size, Settings.HitboxExpander.Size, Settings.HitboxExpander.Size)
                    part.Transparency = Settings.HitboxExpander.Visualize and 0.5 or 1
                    part.CanCollide = false
                end
            end
        end
    end

    local function DoAntiAim()
        if not Settings.AntiAim.Enabled or not Toggles.AntiAim then return end
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        if Settings.AntiAim.Desync then
            hrp.Velocity = hrp.CFrame.lookVector * Settings.AntiAim.DesyncVelocity
            local angle = Settings.AntiAim.Jitter and math.random(-Settings.AntiAim.JitterAmount, Settings.AntiAim.JitterAmount) or 100
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(angle), 0)
        else hrp.Velocity = Vector3.new(hrp.Velocity.X, Settings.AntiAim.Velocity, hrp.Velocity.Z) end
    end

    local function DoMacro()
        if not Settings.Macro.Enabled or not Toggles.Macro then return end
        pcall(function() if keypress and keyrelease then keypress(0x49); task.wait(); keypress(0x4F); task.wait(); keyrelease(0x49); keyrelease(0x4F) end end)
    end

    local function DoAntiAFK()
        if not Settings.AntiAFK.Enabled then return end
        VirtualUser:Button2Down(Vector2.zero, Camera.CFrame); task.wait(0.5); VirtualUser:Button2Up(Vector2.zero, Camera.CFrame)
    end

    pcall(function()
        local mt = getrawmetatable(game); if not mt then return end
        local oldIndex = mt.__index
        if setreadonly then setreadonly(mt, false) end
        mt.__index = newcclosure(function(self, key)
            if self == Mouse and (key == "Hit" or key == "Target") and Settings.SilentAim.Enabled then
                local target = GetClosest(Settings.SilentAim.UseFOV and Settings.SilentAim.FOVRadius or math.huge, Settings.SilentAim.Distance)
                if target and IsValid(target) then
                    local parts = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"}
                    local part = Settings.SilentAim.ClosestPart and GetClosestPart(target.Character, parts) or target.Character:FindFirstChild(Settings.SilentAim.Hitbox)
                    if part then
                        local pred = Settings.SilentAim.AutoPrediction and AutoPrediction() or Settings.SilentAim.Prediction
                        local pos = part.Position + (part.Velocity * Vector3.new(pred, pred, pred))
                        if Settings.SilentAim.AirShot then
                            local hum = target.Character:FindFirstChildOfClass("Humanoid")
                            if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then pos = pos + Vector3.new(0, Settings.SilentAim.JumpOffset, 0) end
                        end
                        if MainEvent then pcall(function() MainEvent:FireServer(CurrentGame.Argument, pos) end) end
                        if key == "Hit" then return CFrame.new(pos) end
                    end
                end
            end
            return oldIndex(self, key)
        end)
        if setreadonly then setreadonly(mt, true) end
    end)

    table.insert(Connections, UserInputService.InputBegan:Connect(function(i, g)
        if g then return end
        local binds = Settings.Keybinds
        if i.KeyCode == Settings.UI.Keybind then UIVisible = not UIVisible; if PhantixWindow then PhantixWindow:toggle(UIVisible) end return end
        if i.KeyCode == binds.Panic then getgenv().UnloadPhantix(); return end
        if i.KeyCode == binds.Camlock then
            if Locks.Camlock then Locks.Camlock = false; Targets.Camlock = nil
            else Targets.Camlock = GetClosest(Settings.Camlock.FOVSize); if Targets.Camlock then Locks.Camlock = true end end
        end
        if i.KeyCode == binds.Triggerbot then Toggles.Trigger = Settings.Triggerbot.Mode == "Toggle" and not Toggles.Trigger or true end
        if i.KeyCode == binds.Fly then Toggles.Fly = not Toggles.Fly; if Toggles.Fly then StartFly() else StopFly() end end
        if i.KeyCode == binds.Noclip then Toggles.Noclip = not Toggles.Noclip end
        if i.KeyCode == binds.WalkSpeed then Toggles.WalkSpeed = not Toggles.WalkSpeed; if not Toggles.WalkSpeed and LocalPlayer.Character then local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed = 16 end end end
        if i.KeyCode == binds.Spinbot then Settings.Spinbot.Enabled = not Settings.Spinbot.Enabled; if not Settings.Spinbot.Enabled and LocalPlayer.Character then local hum = LocalPlayer.Character:FindFirstChild("Humanoid"); if hum then hum.AutoRotate = true end end end
        if i.KeyCode == binds.Macro then Toggles.Macro = not Toggles.Macro end
        if i.KeyCode == binds.AntiAim then Toggles.AntiAim = not Toggles.AntiAim end
        if i.KeyCode == binds.ClickTP and Settings.ClickTP.Enabled then local c = LocalPlayer.Character; if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end end
        if i.KeyCode == Enum.KeyCode.Space and Settings.InfiniteJump.Enabled and Toggles.InfJump then local c = LocalPlayer.Character; if c then local hum = c:FindFirstChildOfClass("Humanoid"); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end
        if i.KeyCode == binds.InfiniteJump then Toggles.InfJump = not Toggles.InfJump end
    end))

    table.insert(Connections, UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Settings.Keybinds.Triggerbot and Settings.Triggerbot.Mode == "Hold" then Toggles.Trigger = false end
    end))

    table.insert(Connections, RunService.RenderStepped:Connect(function(dt)
        local mouse = UserInputService:GetMouseLocation()
        if Settings.UI.Watermark then
            local mins = math.floor((tick() - StartTime) / 60)
            local secs = math.floor((tick() - StartTime) % 60)
            Drawings.Watermark.Text = string.format("phantix.lol | %s | %d FPS | %d ms | %02d:%02d", CurrentGame.Name, GetFPS(), GetPing(), mins, secs)
            Drawings.Watermark.Color = Color3.fromRGB(135, 206, 250); Drawings.Watermark.Visible = true
        else Drawings.Watermark.Visible = false end
        UpdateSnowfall(dt); UpdateWorld(); UpdateChams(); UpdateSnaplines(); UpdateRadar(); UpdateESP(); UpdateCrosshair(); UpdateFly(); DoMovement(); DoCamlock(); DoTriggerbot(); DoAntiAim(); DoKillAura()
        Drawings.SilentFOV.Position = Vector2.new(Mouse.X, Mouse.Y + GuiInset.Y); Drawings.SilentFOV.Radius = Settings.SilentAim.FOVRadius; Drawings.SilentFOV.Color = Settings.SilentAim.FOVColor; Drawings.SilentFOV.Visible = Settings.SilentAim.Enabled and Settings.SilentAim.ShowFOV
        Drawings.CamlockFOV.Position = mouse; Drawings.CamlockFOV.Radius = Settings.Camlock.FOVSize; Drawings.CamlockFOV.Color = Settings.Camlock.FOVColor; Drawings.CamlockFOV.Visible = Settings.Camlock.Enabled and Settings.Camlock.ShowFOV
        local target = Targets.Camlock
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            Drawings.TargetTracer.From = mouse; Drawings.TargetTracer.To = Vector2.new(pos.X, pos.Y); Drawings.TargetTracer.Color = Color3.fromRGB(255, 0, 0); Drawings.TargetTracer.Visible = vis and Settings.Camlock.Enabled
            Drawings.TargetDot.Position = Vector2.new(pos.X, pos.Y); Drawings.TargetDot.Radius = 5; Drawings.TargetDot.Color = Color3.new(1,1,1); Drawings.TargetDot.Filled = true; Drawings.TargetDot.Visible = vis and Settings.Camlock.Enabled
        else Drawings.TargetTracer.Visible = false; Drawings.TargetDot.Visible = false end
    end))

    table.insert(Connections, RunService.Heartbeat:Connect(function()
        DoHitboxExpander(); DoAutoStomp(); DoAntiAFK()
        local target = Targets.Camlock
        if target and target.Character and Settings.HitDetection.Enabled then
            local hum = target.Character:FindFirstChild("Humanoid")
            if hum then
                local hp = hum.Health; local id = target.UserId
                if not LastHealth[id] then LastHealth[id] = hp end
                if hp < LastHealth[id] then PlayHit(); ShowHitMarker(); if Settings.HitDetection.Logs then Notify({Title = "phantix.lol", Description = "Hit " .. target.DisplayName, Duration = 1}) end end
                LastHealth[id] = hp
            end
        end
    end))

    task.spawn(function() while task.wait() do if Toggles.Macro and Settings.Macro.Enabled then DoMacro() end end end)

    for _, p in pairs(Players:GetPlayers()) do CreateChams(p); CreateSnapline(p) end
    Players.PlayerAdded:Connect(function(p) CreateChams(p); CreateSnapline(p) end)
    Players.PlayerRemoving:Connect(function(p)
        if ESPObjects[p] then for _, d in pairs(ESPObjects[p]) do d:Remove() end ESPObjects[p] = nil end
        if ChamsObjects[p] then ChamsObjects[p]:Destroy(); ChamsObjects[p] = nil end
        if SnaplineObjects[p] then SnaplineObjects[p]:Remove(); SnaplineObjects[p] = nil end
        LastHealth[p.UserId] = nil
        if Targets.Camlock == p then Targets.Camlock = nil; Locks.Camlock = false end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Settings.Trail.Enabled then ApplyTrail(true) end
        if Toggles.Fly then StartFly() end
    end)

    getgenv().UnloadPhantix = function()
        for _, c in pairs(Connections) do if c then c:Disconnect() end end
        for _, d in pairs(Drawings) do if d then pcall(function() d:Remove() end) end end
        for _, o in pairs(ESPObjects) do for _, d in pairs(o) do d:Remove() end end
        for _, l in pairs(SnaplineObjects) do l:Remove() end
        for _, h in pairs(ChamsObjects) do h:Destroy() end
        for _, f in pairs(Snowflakes) do f.d:Remove() end
        for _, d in pairs(RadarDots) do d:Remove() end
        for i = 1, 8 do CrosshairLines[i]:Remove() end
        for i = 1, 4 do HitMarkers[i]:Remove() end
        ApplyTrail(false); StopFly()
        for k, v in pairs(OriginalLighting) do Lighting[k] = v end
        Workspace.Gravity = OriginalGravity
        Camera.FieldOfView = 70
        HitSound:Destroy()
        getgenv().PhantixLoaded = nil
        Notify({Title = "phantix.lol", Description = "Unloaded!", Duration = 2})
    end

    makefolder("phantixlol")
    PhantixWindow = library:new({name = "phantix.lol", accent = Color3.fromRGB(135, 206, 250), textsize = 13})

    local Legit = PhantixWindow:page({name = "Legit"})
    local Rage = PhantixWindow:page({name = "Rage"})
    local Visuals = PhantixWindow:page({name = "Visuals"})
    local World = PhantixWindow:page({name = "World"})
    local Misc = PhantixWindow:page({name = "Misc"})
    local Set = PhantixWindow:page({name = "Settings"})

    local SA = Legit:section({name = "Silent Aim", side = "left", size = 310})
    SA:toggle({name = "Enabled", def = false, callback = function(v) Settings.SilentAim.Enabled = v end})
    SA:toggle({name = "Use FOV", def = false, callback = function(v) Settings.SilentAim.UseFOV = v end})
    SA:toggle({name = "Show FOV", def = false, callback = function(v) Settings.SilentAim.ShowFOV = v end})
    SA:toggle({name = "KO Check", def = false, callback = function(v) Settings.SilentAim.KOCheck = v end})
    SA:toggle({name = "Closest Part", def = false, callback = function(v) Settings.SilentAim.ClosestPart = v end})
    SA:toggle({name = "Auto Prediction", def = false, callback = function(v) Settings.SilentAim.AutoPrediction = v end})
    SA:toggle({name = "Air Shot", def = false, callback = function(v) Settings.SilentAim.AirShot = v end})
    SA:dropdown({name = "Hitbox", def = "HumanoidRootPart", max = 4, options = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"}, callback = function(v) Settings.SilentAim.Hitbox = v end})
    SA:slider({name = "FOV Radius", def = 170, max = 500, min = 10, callback = function(v) Settings.SilentAim.FOVRadius = v end})
    SA:slider({name = "Prediction", def = 138, max = 300, min = 0, callback = function(v) Settings.SilentAim.Prediction = v/1000 end})
    SA:colorpicker({name = "FOV Color", def = Color3.fromRGB(0, 255, 0), callback = function(v) Settings.SilentAim.FOVColor = v end})

    local CL = Legit:section({name = "Camlock", side = "right", size = 290})
    CL:toggle({name = "Enabled", def = false, callback = function(v) Settings.Camlock.Enabled = v end})
    CL:toggle({name = "Sticky", def = false, callback = function(v) Settings.Camlock.Sticky = v end})
    CL:toggle({name = "Show FOV", def = false, callback = function(v) Settings.Camlock.ShowFOV = v end})
    CL:toggle({name = "Closest Part", def = false, callback = function(v) Settings.Camlock.ClosestPart = v end})
    CL:toggle({name = "Auto Prediction", def = false, callback = function(v) Settings.Camlock.AutoPrediction = v end})
    CL:toggle({name = "Smoothing", def = false, callback = function(v) Settings.Camlock.Smoothing = v end})
    CL:dropdown({name = "Hitbox", def = "Head", max = 3, options = {"Head", "UpperTorso", "HumanoidRootPart"}, callback = function(v) Settings.Camlock.Hitbox = v end})
    CL:slider({name = "FOV Size", def = 200, max = 500, min = 10, callback = function(v) Settings.Camlock.FOVSize = v end})
    CL:slider({name = "Ground Smooth", def = 40, max = 500, min = 1, callback = function(v) Settings.Camlock.GroundSmooth = v/1000 end})
    CL:slider({name = "Air Smooth", def = 60, max = 500, min = 1, callback = function(v) Settings.Camlock.AirSmooth = v/1000 end})
    CL:colorpicker({name = "FOV Color", def = Color3.fromRGB(0, 255, 0), callback = function(v) Settings.Camlock.FOVColor = v end})

    local TB = Legit:section({name = "Triggerbot", side = "right", size = 120})
    TB:toggle({name = "Enabled", def = false, callback = function(v) Settings.Triggerbot.Enabled = v end})
    TB:toggle({name = "Headshot Only", def = false, callback = function(v) Settings.Triggerbot.HeadshotOnly = v end})
    TB:dropdown({name = "Mode", def = "Toggle", max = 2, options = {"Toggle", "Hold"}, callback = function(v) Settings.Triggerbot.Mode = v end})
    TB:slider({name = "Delay (ms)", def = 10, max = 500, min = 0, callback = function(v) Settings.Triggerbot.Delay = v/1000 end})

    local HB = Rage:section({name = "Hitbox Expander", side = "left", size = 100})
    HB:toggle({name = "Enabled", def = false, callback = function(v) Settings.HitboxExpander.Enabled = v end})
    HB:toggle({name = "Visualize", def = false, callback = function(v) Settings.HitboxExpander.Visualize = v end})
    HB:slider({name = "Size", def = 15, max = 50, min = 5, callback = function(v) Settings.HitboxExpander.Size = v end})

    local AA = Rage:section({name = "Anti Aim", side = "left", size = 110})
    AA:toggle({name = "Enabled", def = false, callback = function(v) Settings.AntiAim.Enabled = v end})
    AA:toggle({name = "Desync", def = false, callback = function(v) Settings.AntiAim.Desync = v end})
    AA:toggle({name = "Jitter", def = false, callback = function(v) Settings.AntiAim.Jitter = v end})
    AA:slider({name = "Jitter Amount", def = 45, max = 180, min = 0, callback = function(v) Settings.AntiAim.JitterAmount = v end})

    local KA = Rage:section({name = "Kill Aura", side = "left", size = 95})
    KA:toggle({name = "Enabled", def = false, callback = function(v) Settings.KillAura.Enabled = v end})
    KA:toggle({name = "Visualize", def = false, callback = function(v) Settings.KillAura.Visualize = v end})
    KA:slider({name = "Range", def = 15, max = 50, min = 5, callback = function(v) Settings.KillAura.Range = v end})

    local MC = Rage:section({name = "Macro", side = "right", size = 75})
    MC:toggle({name = "Enabled", def = false, callback = function(v) Settings.Macro.Enabled = v end})
    MC:dropdown({name = "Type", def = "Electron", max = 3, options = {"First", "Third", "Electron"}, callback = function(v) Settings.Macro.Type = v end})

    local AS = Rage:section({name = "Auto Stomp", side = "right", size = 75})
    AS:toggle({name = "Enabled", def = false, callback = function(v) Settings.AutoStomp.Enabled = v end})
    AS:slider({name = "Range", def = 15, max = 30, min = 5, callback = function(v) Settings.AutoStomp.Range = v end})

    local ES = Visuals:section({name = "ESP", side = "left", size = 200})
    ES:toggle({name = "Enabled", def = false, callback = function(v) Settings.ESP.Enabled = v end})
    ES:toggle({name = "Names", def = false, callback = function(v) Settings.ESP.Names = v end})
    ES:toggle({name = "Health", def = false, callback = function(v) Settings.ESP.Health = v end})
    ES:toggle({name = "Box", def = false, callback = function(v) Settings.ESP.Box = v end})
    ES:toggle({name = "Tracers", def = false, callback = function(v) Settings.ESP.Tracers = v end})
    ES:slider({name = "Distance", def = 30, max = 50, min = 5, callback = function(v) Settings.ESP.Distance = v * 100 end})
    ES:colorpicker({name = "Box Color", def = Color3.fromRGB(255, 0, 0), callback = function(v) Settings.ESP.BoxColor = v end})
    ES:colorpicker({name = "Tracer Color", def = Color3.fromRGB(255, 0, 0), callback = function(v) Settings.ESP.TracerColor = v end})

    local CH = Visuals:section({name = "Chams", side = "left", size = 115})
    CH:toggle({name = "Enabled", def = false, callback = function(v) Settings.Chams.Enabled = v end})
    CH:slider({name = "Fill Trans", def = 5, max = 10, min = 0, callback = function(v) Settings.Chams.FillTransparency = v/10 end})
    CH:colorpicker({name = "Fill Color", def = Color3.fromRGB(255, 0, 127), callback = function(v) Settings.Chams.FillColor = v end})
    CH:colorpicker({name = "Outline", def = Color3.fromRGB(255, 255, 255), callback = function(v) Settings.Chams.OutlineColor = v end})

    local SN = Visuals:section({name = "Other Visuals", side = "right", size = 130})
    SN:toggle({name = "Snaplines", def = false, callback = function(v) Settings.Snaplines.Enabled = v end})
    SN:toggle({name = "Radar", def = false, callback = function(v) Settings.Radar.Enabled = v end})
    SN:slider({name = "Radar Size", def = 150, max = 300, min = 50, callback = function(v) Settings.Radar.Size = v end})
    SN:colorpicker({name = "Snapline Color", def = Color3.fromRGB(255, 255, 255), callback = function(v) Settings.Snaplines.Color = v end})
    SN:colorpicker({name = "Radar Color", def = Color3.fromRGB(255, 0, 0), callback = function(v) Settings.Radar.EnemyColor = v end})

    local CR = Visuals:section({name = "Crosshair", side = "right", size = 160})
    CR:toggle({name = "Enabled", def = false, callback = function(v) Settings.Crosshair.Enabled = v end})
    CR:toggle({name = "Spin", def = false, callback = function(v) Settings.Crosshair.Spin = v end})
    CR:toggle({name = "Resize", def = false, callback = function(v) Settings.Crosshair.Resize = v end})
    CR:toggle({name = "Outline", def = false, callback = function(v) Settings.Crosshair.Outline = v end})
    CR:toggle({name = "Dot", def = false, callback = function(v) Settings.Crosshair.Dot = v end})
    CR:slider({name = "Length", def = 10, max = 50, min = 5, callback = function(v) Settings.Crosshair.Length = v end})
    CR:colorpicker({name = "Color", def = Color3.fromRGB(199, 110, 255), callback = function(v) Settings.Crosshair.Color = v end})

    local WR = World:section({name = "World", side = "left", size = 290})
    WR:toggle({name = "Fullbright", def = false, callback = function(v) Settings.Fullbright.Enabled = v end})
    WR:toggle({name = "No Fog", def = false, callback = function(v) Settings.NoFog.Enabled = v end})
    WR:toggle({name = "No Shadows", def = false, callback = function(v) Settings.NoShadows.Enabled = v end})
    WR:toggle({name = "Custom Time", def = false, callback = function(v) Settings.TimeChanger.Enabled = v end})
    WR:slider({name = "Time", def = 12, max = 24, min = 0, callback = function(v) Settings.TimeChanger.Time = v end})
    WR:toggle({name = "Custom Gravity", def = false, callback = function(v) Settings.Gravity.Enabled = v end})
    WR:slider({name = "Gravity", def = 196, max = 500, min = 0, callback = function(v) Settings.Gravity.Value = v end})
    WR:toggle({name = "FOV Changer", def = false, callback = function(v) Settings.FOVChanger.Enabled = v end})
    WR:slider({name = "FOV", def = 70, max = 120, min = 30, callback = function(v) Settings.FOVChanger.Value = v end})

    local FG = World:section({name = "Custom Fog", side = "left", size = 200})
    FG:toggle({name = "Enabled", def = false, callback = function(v) Settings.CustomFog.Enabled = v end})
    FG:slider({name = "Distance", def = 1000, max = 5000, min = 100, callback = function(v) Settings.CustomFog.End = v end})
    FG:colorpicker({name = "Fog Color", def = Color3.fromRGB(128, 128, 128), callback = function(v) Settings.CustomFog.Color = v end})

    local SL = World:section({name = "Self", side = "right", size = 120})
    SL:toggle({name = "Trail", def = false, callback = function(v) Settings.Trail.Enabled = v; ApplyTrail(v) end})
    SL:colorpicker({name = "Trail Color 1", def = Color3.fromRGB(255, 110, 0), callback = function(v) Settings.Trail.Color1 = v end})
    SL:colorpicker({name = "Trail Color 2", def = Color3.fromRGB(255, 0, 0), callback = function(v) Settings.Trail.Color2 = v end})
    SL:slider({name = "Trail Life", def = 16, max = 50, min = 5, callback = function(v) Settings.Trail.Lifetime = v/10 end})

    local HT = World:section({name = "Hit Detection", side = "right", size = 160})
    HT:toggle({name = "Enabled", def = false, callback = function(v) Settings.HitDetection.Enabled = v end})
    HT:toggle({name = "Sound", def = false, callback = function(v) Settings.HitDetection.Sound = v end})
    HT:toggle({name = "Hit Marker", def = false, callback = function(v) Settings.HitDetection.HitMarker = v end})
    HT:toggle({name = "Logs", def = false, callback = function(v) Settings.HitDetection.Logs = v end})
    HT:dropdown({name = "Sound Type", def = "Skeet", max = 6, options = {"Skeet", "Rust", "Minecraft", "Pop", "Bonk", "Bell"}, callback = function(v) Settings.HitDetection.SoundType = v end})
    HT:slider({name = "Volume", def = 10, max = 20, min = 1, callback = function(v) Settings.HitDetection.Volume = v/10 end})

    local MV = Misc:section({name = "Movement", side = "left", size = 300})
    MV:toggle({name = "Walk Speed", def = false, callback = function(v) Settings.WalkSpeed.Enabled = v end})
    MV:slider({name = "Speed Value", def = 50, max = 200, min = 16, callback = function(v) Settings.WalkSpeed.Value = v end})
    MV:toggle({name = "Jump Power", def = false, callback = function(v) Settings.JumpPower.Enabled = v end})
    MV:slider({name = "Jump Value", def = 75, max = 200, min = 50, callback = function(v) Settings.JumpPower.Value = v end})
    MV:toggle({name = "Fly", def = false, callback = function(v) Settings.Fly.Enabled = v end})
    MV:slider({name = "Fly Speed", def = 50, max = 200, min = 10, callback = function(v) Settings.Fly.Speed = v end})
    MV:toggle({name = "Noclip", def = false, callback = function(v) Settings.Noclip.Enabled = v end})
    MV:toggle({name = "Infinite Jump", def = false, callback = function(v) Settings.InfiniteJump.Enabled = v end})
    MV:toggle({name = "Bunny Hop", def = false, callback = function(v) Settings.BunnyHop.Enabled = v end})
    MV:toggle({name = "Anti Slow", def = false, callback = function(v) Settings.AntiSlow.Enabled = v end})
    MV:toggle({name = "Spinbot", def = false, callback = function(v) Settings.Spinbot.Enabled = v end})
    MV:slider({name = "Spin Speed", def = 15, max = 50, min = 1, callback = function(v) Settings.Spinbot.Speed = v end})

    local MS = Misc:section({name = "Misc", side = "right", size = 200})
    MS:toggle({name = "Anti AFK", def = false, callback = function(v) Settings.AntiAFK.Enabled = v end})
    MS:toggle({name = "Snowfall", def = false, callback = function(v) Settings.UI.Snowfall = v end})
    MS:toggle({name = "Watermark", def = false, callback = function(v) Settings.UI.Watermark = v end})
    MS:toggle({name = "Click TP", def = false, callback = function(v) Settings.ClickTP.Enabled = v end})
    MS:toggle({name = "Anti Void", def = false, callback = function(v) Settings.AntiVoid.Enabled = v end})
    MS:button({name = "Rejoin Server", callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end})
    MS:button({name = "Server Hop", callback = function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        for _, s in pairs(data.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(servers, s.id) end end
        if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer) end
    end})
    MS:button({name = "Unload Script", callback = function() getgenv().UnloadPhantix() end})

    local KB = Set:section({name = "Keybinds", side = "left", size = 330})
    KB:keybind({name = "UI Toggle", def = Enum.KeyCode.RightShift, callback = function(k) Settings.UI.Keybind = k end})
    KB:keybind({name = "Camlock", def = Enum.KeyCode.Q, callback = function(k) Settings.Keybinds.Camlock = k end})
    KB:keybind({name = "Triggerbot", def = Enum.KeyCode.T, callback = function(k) Settings.Keybinds.Triggerbot = k end})
    KB:keybind({name = "Fly", def = Enum.KeyCode.F, callback = function(k) Settings.Keybinds.Fly = k end})
    KB:keybind({name = "Noclip", def = Enum.KeyCode.H, callback = function(k) Settings.Keybinds.Noclip = k end})
    KB:keybind({name = "Infinite Jump", def = Enum.KeyCode.J, callback = function(k) Settings.Keybinds.InfiniteJump = k end})
    KB:keybind({name = "Walk Speed", def = Enum.KeyCode.Z, callback = function(k) Settings.Keybinds.WalkSpeed = k end})
    KB:keybind({name = "Spinbot", def = Enum.KeyCode.N, callback = function(k) Settings.Keybinds.Spinbot = k end})
    KB:keybind({name = "Macro", def = Enum.KeyCode.X, callback = function(k) Settings.Keybinds.Macro = k end})
    KB:keybind({name = "Anti Aim", def = Enum.KeyCode.P, callback = function(k) Settings.Keybinds.AntiAim = k end})
    KB:keybind({name = "Click TP", def = Enum.KeyCode.Y, callback = function(k) Settings.Keybinds.ClickTP = k end})
    KB:keybind({name = "Panic Key", def = Enum.KeyCode.End, callback = function(k) Settings.Keybinds.Panic = k end})

    local CF = Set:section({name = "Config", side = "right", size = 150})
    CF:configloader({folder = "phantixlol"})

    Legit:openpage()

    Notify({Title = "phantix.lol", Description = "Loaded! Game: " .. CurrentGame.Name, Duration = 3})
    print("==============================")
    print("phantix.lol loaded!")
    print("Game: " .. CurrentGame.Name)
    print("UI Toggle: RightShift")
    print("Panic Key: End")
    print("==============================")
end

print("[phantix.lol] HWID System Loaded")
print("[phantix.lol] Your HWID: " .. HWID)

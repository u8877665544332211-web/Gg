local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Toggles = getgenv().Toggles or Library.Toggles
local Options = getgenv().Options or Library.Options

-- ==========================================
-- Services & Local Player 설정
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local lp = LocalPlayer
local Camera = Workspace.CurrentCamera or Workspace:WaitForChild("Camera")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Global Config & State Table (통합 관리)
getgenv().Config = getgenv().Config or {}
getgenv().State = getgenv().State or {}

local Window = Library:CreateWindow({
    Title = 'Yumu Enchantment - discord.gg/qTV5c5Fn6',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Character = Window:AddTab('Character'),
    Misc = Window:AddTab('Misc'),
    Setting = Window:AddTab('Setting')
}

local _0l1lOIIII0 = true

local function is_teammate(player)
    if not _0l1lOIIII0 then return false end
    local _357_939 = LocalPlayer:GetAttribute("TeamID")
    local L880_33 = player:GetAttribute("TeamID")
    if _357_939 == nil or L880_33 == nil then return false end
    return L880_33 == _357_939
end

local function get_character(playerOrChar)
    local char = playerOrChar
    if typeof(playerOrChar) == "Instance" and playerOrChar:IsA("Player") then
        char = playerOrChar.Character
    end
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    local __BfgstqWnead = char:FindFirstChild("HumanoidRootPart")
    if __BfgstqWnead and __BfgstqWnead:FindFirstChild("Attachment") then return true end
    local _IlO1IIIIOl1I = char:GetAttribute("Immune") or char:GetAttribute("Invincible") or char:GetAttribute("IsImmune")
    if _IlO1IIIIOl1I == true then return true end
    local a87b18c82 = char:FindFirstChildOfClass("Humanoid")
    if a87b18c82 then
        local _7665x159 = a87b18c82:GetAttribute("Immune") or a87b18c82:GetAttribute("Invincible")
        if _7665x159 == true then return true end
    end
    return false
end

local function get_player_from_part(player)
    local char = player and player.Character
    if not char then return false end
    local _8898x144 = {"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying"}
    for _, a in ipairs(_8898x144) do
        local _01O001l00 = char:GetAttribute(a)
        if _01O001l00 == true or _01O001l00 == 1 or _01O001l00 == "true" then return true end
    end
    return false
end

-- ==========================================
-- Desync & Ragebot Main Logic 변수 정의
-- ==========================================
local _2631x704 = true
local flyEnabled = false
local _8080x566 = 50000000
local _lII0ll = false
local _4012x732 = 0.25
local a85b57c99 = 0.1
local L555_61 = false
local __lhiRNgvZ = 3 
local a73b35c96 = nil

-- Desync 위치/속도 버퍼
local L389_46 = nil
local L273_20 = nil
local _10O0lO = nil

task.spawn(function()
    while true do
        if _lII0ll and L555_61 then
            _2631x704 = true
            local _3661x412 = a85b57c99
            if typeof(_3661x412) ~= "number" or _3661x412 < 0.01 then _3661x412 = 0.01 end
            task.wait(_3661x412)
            if _lII0ll and L555_61 then
                _2631x704 = false
                local _0xdee6 = _4012x732
                if typeof(_0xdee6) ~= "number" or _0xdee6 < 0.01 then _0xdee6 = 0.01 end
                task.wait(_0xdee6)
            else
                _2631x704 = true
            end
        else
            _2631x704 = true
            task.wait(0.05)
        end
    end
end)

local function get_character_root(char)
    if not char then return nil end
    return char:FindFirstChild("HitboxHead")
        or char:FindFirstChild("HitboxHeadSmall")
        or char:FindFirstChild("Head")
end

local v71190 = function(on) end

-- Remote Attack Engine
task.spawn(function()
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local a66b43c59, _9817x625 = pcall(require, _3213x326.Controllers.FighterController)
        local _0xd857, v27885     = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
        local __MAwXiJM    = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
        local _IIOl1OI11O00; pcall(function() _IIOl1OI11O00 = v27885:ToEnum("StartShooting") end)

        local function _5460x742()
            if not (a66b43c59 and _9817x625) then return nil end
            local _0x3584 = _9817x625.LocalFighter; if not _0x3584 then return nil end
            local _549_282 = _0x3584.EquippedItem; if not _549_282 then return nil end
            local L704_40, L987_53 = pcall(function() return _549_282:Get("ObjectID") end)
            if L704_40 and L987_53 then return L987_53 end
            L704_40, L987_53 = pcall(function() return _549_282.Data and _549_282.Data.ObjectID end)
            return L704_40 and L987_53 or nil
        end

        local function teleport_character(originPos, _IOI1l0I100)
            local L501_16 = _IOI1l0I100.Position
            local _0xb60d = CFrame.lookAt(originPos, L501_16)
            local _0Il0I11O, _1897x442, _0xefad = _0xb60d:ToOrientation()
            local a49b75c71 = {
                [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                [utf8.char(3)] = _0Il0I11O, [utf8.char(4)] = _1897x442, [utf8.char(5)] = _0xefad,
            }
            local a12b15c22 = _IOI1l0I100.CFrame:ToObjectSpace(CFrame.new(L501_16))
            local _lOl1lI0llll0, _1l00IOl101Il, __CtOClXPOnz = a12b15c22:ToOrientation()
            return {
                [utf8.char(1)] = {
                    [utf8.char(0)] = a49b75c71,
                    [utf8.char(1)] = a49b75c71,
                    [utf8.char(2)] = _IOI1l0I100,
                    [utf8.char(3)] = {
                        [utf8.char(0)] = a12b15c22.X, [utf8.char(1)] = a12b15c22.Y, [utf8.char(2)] = a12b15c22.Z,
                        [utf8.char(3)] = _lOl1lI0llll0, [utf8.char(4)] = _1l00IOl101Il, [utf8.char(5)] = __CtOClXPOnz,
                    },
                },
            }
        end

        v71190 = function(on)
            if _10O0lO then _10O0lO:Disconnect(); _10O0lO = nil end
            if not on then return end

            local _l0OIIO = nil
            _10O0lO = RunService.Heartbeat:Connect(function()
                if not L555_61 or not _2631x704 then return end
                if not a73b35c96 or not a73b35c96.Parent then return end

                local a20b32c46 = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
                local a14b42c70 = Players:GetPlayerFromCharacter(a20b32c46)
                if not a14b42c70 or a14b42c70 == LocalPlayer then return end
                if is_teammate(a14b42c70) or get_character(a14b42c70) or get_player_from_part(a14b42c70) then return end

                local _lO00OO0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not _lO00OO0 then return end

                local _0xf72a = _5460x742()
                if _0xf72a then _l0OIIO = _0xf72a else _0xf72a = _l0OIIO end
                if not _0xf72a then return end

                local L405_52 = a73b35c96
                local _0Ol00I01OO0l = L405_52.Position + Vector3.new(0, 0.1, 0)
                local v84604 = teleport_character(_0Ol00I01OO0l, L405_52)
                pcall(function()
                    if _0xf72a and _IIOl1OI11O00 then
                        __MAwXiJM:FireServer(_0xf72a, _IIOl1OI11O00, v84604, nil)
                    end
                end)
            end)
        end
    end)
end)

local function find_closest_target()
    local v83548 = true
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local _0x9ec3, _0lO010OIIO = pcall(require, _3213x326.Controllers.FighterController)
        if not _0x9ec3 or not _0lO010OIIO or not _0lO010OIIO.LocalFighter then return end
        local _549_282 = _0lO010OIIO.LocalFighter.EquippedItem
        if not _549_282 then v83548 = false; return end
    end)
    return v83548
end

-- Desync 위치 복구 핸들러
local function restore_desync_position()
    local __BfgstqWnead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not __BfgstqWnead or not L389_46 then return end
    __BfgstqWnead.CFrame = L389_46
    if L273_20 then __BfgstqWnead.AssemblyLinearVelocity = L273_20 end
    L389_46 = nil
    L273_20 = nil
end

pcall(function() RunService:UnbindFromRenderStep("RestoreDesyncPerfect") end)
pcall(function() RunService:BindToRenderStep("RestoreDesyncPerfect", 0, restore_desync_position) end)
RunService.RenderStepped:Connect(restore_desync_position)

-- Heartbeat Desync Teleport 루프
RunService.Heartbeat:Connect(function()
    pcall(function()
        local __BfgstqWnead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not __BfgstqWnead then return end

        if L389_46 then restore_desync_position() end

        -- Target Attack Teleport (Ragebot Desync)
        if L555_61 and _2631x704 and a73b35c96 and find_closest_target() then
            local _3921x508 = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
            local _456_638 = Players:GetPlayerFromCharacter(_3921x508)
            if _456_638 and get_player_from_part(_456_638) then return end
            
            L389_46 = __BfgstqWnead.CFrame
            L273_20 = __BfgstqWnead.AssemblyLinearVelocity
            
            local L501_16 = a73b35c96.Position
            local _7279x484 = L501_16 + Vector3.new(0, __lhiRNgvZ, 0)
            __BfgstqWnead.CFrame = CFrame.new(_7279x484, L501_16)
            return
        end

        -- Orbit Fly Desync
        if flyEnabled then
            L389_46 = __BfgstqWnead.CFrame
            L273_20 = __BfgstqWnead.AssemblyLinearVelocity
            local _687_388 = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)).Unit
            local _7279x484 = __BfgstqWnead.Position + _687_388 * _8080x566
            local _OIOO0O1 = L389_46 - L389_46.Position
            __BfgstqWnead.CFrame = CFrame.new(_7279x484) * _OIOO0O1
        end
    end)
end)

-- 타겟 탐색 스레드
task.spawn(function()
    while true do
        task.wait(0.01)
        if L555_61 and _2631x704 then
            local __xxEEAQiVz = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local _338_977 = nil
            local __UHvhQn = math.huge

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not is_teammate(player) then
                    if get_character(player) or get_player_from_part(player) then continue end
                    local __BfgstqWnead = player.Character:FindFirstChild("HumanoidRootPart")
                    local a87b18c82 = player.Character:FindFirstChild("Humanoid")
                    if __BfgstqWnead and a87b18c82 and a87b18c82.Health > 0 then
                        local _100l10O0II = (Vector3.new(__xxEEAQiVz.X, 0, __xxEEAQiVz.Z) - Vector3.new(__BfgstqWnead.Position.X, 0, __BfgstqWnead.Position.Z)).Magnitude
                        if _100l10O0II < __UHvhQn then
                            __UHvhQn = _100l10O0II
                            _338_977 = player
                        end
                    end
                end
            end

            if _338_977 and _338_977.Character then
                a73b35c96 = get_character_root(_338_977.Character)
            else
                a73b35c96 = nil
            end
        else
            a73b35c96 = nil
        end
    end
end)

-- ==========================================
-- Combat 탭 UI 구성 (최상단 반영)
-- ==========================================

-- 1. Aimbot 그룹박스 (Combat 탭 좌측 최상단)
local AimbotGroup = Tabs.Combat:AddLeftGroupbox('Aimbot')

AimbotGroup:AddToggle('AimbotEnable', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value)
        getgenv().elisium = getgenv().elisium or {}
        getgenv().elisium.aimbot = getgenv().elisium.aimbot or {}
        getgenv().elisium.aimbot.enable = Value
    end
})

AimbotGroup:AddToggle('AimbotShowFOV', {
    Text = 'Show FOV',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.show_fov = Value
        end
    end
}):AddColorPicker('AimbotFOVColor', {
    Default = Color3.fromRGB(120, 81, 166),
    Title = 'FOV Color',
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.fov_color = Value
        end
    end
})

AimbotGroup:AddSlider('AimbotFOVRadius', {
    Text = 'FOV Radius',
    Default = 180,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.fov_radius = Value
        end
    end
})

AimbotGroup:AddSlider('AimbotSmoothing', {
    Text = 'Smoothing',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.smoothing = Value
        end
    end
})

AimbotGroup:AddToggle('AimbotClosestPart', {
    Text = 'Target Closest Part',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.closest_part = Value
        end
    end
})


-- 2. Silent Aim 그룹박스 (Combat 탭 우측 최상단)
local SilentAimGroup = Tabs.Combat:AddRightGroupbox('Silent Aim')

SilentAimGroup:AddToggle('SilentAimEnable', {
    Text = 'Enable Silent Aim',
    Default = false,
    Callback = function(Value)
        getgenv().elisium = getgenv().elisium or {}
        getgenv().elisium.silent_aim = getgenv().elisium.silent_aim or {}
        getgenv().elisium.silent_aim.enable = Value
    end
})

SilentAimGroup:AddToggle('SilentAimShowFOV', {
    Text = 'Show FOV',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.show_fov = Value
        end
    end
}):AddColorPicker('SilentAimFOVColor', {
    Default = Color3.fromRGB(120, 81, 166),
    Title = 'FOV Color',
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.fov_color = Value
        end
    end
})

SilentAimGroup:AddSlider('SilentAimFOVRadius', {
    Text = 'FOV Radius',
    Default = 180,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.fov_radius = Value
        end
    end
})

SilentAimGroup:AddSlider('SilentAimHitChance', {
    Text = 'Hit Chance',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.hit_chance = Value
        end
    end
})

SilentAimGroup:AddToggle('SilentAimClosestPart', {
    Text = 'Target Closest Part',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.closest_part = Value
        end
    end
})


-- 3. Ragebot 그룹박스 (Combat 탭 기존 항목)
local RagebotGroup = Tabs.Combat:AddLeftGroupbox('Ragebot')

RagebotGroup:AddToggle('RagebotEnabled', {
    Text = 'Enabled',
    Default = false,
    Callback = function(Value)
        L555_61 = Value
        pcall(function() v71190(Value) end)
    end
})

RagebotGroup:AddToggle('RagebotOrbit', {
    Text = 'Orbit',
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if Value then
            _8080x566 = 5003
        end
    end
})

RagebotGroup:AddToggle('RagebotVoidspam', {
    Text = 'Void Spam',
    Default = false,
    Callback = function(Value)
        _lII0ll = Value
        if not Value then
            _2631x704 = true
        end
    end
})

RagebotGroup:AddSlider('RagebotHide', {
    Text = 'Hide Delay',
    Default = 0.25,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        _4012x732 = Value
    end
})

RagebotGroup:AddSlider('RagebotAttack', {
    Text = 'Attack Delay',
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        a85b57c99 = Value
    end
})

-- ============================================================================
-- VISUALS MODULE & UI INTEGRATION (COMPLETE EXTRACTED ENGINE)
-- ============================================================================

--------------------------------------------------------------------------------
-- [1] Config Defaults Setup
--------------------------------------------------------------------------------
Config.Visuals = false
Config.VisualsPreset = "Neutral"
Config.VisualsPerformanceMode = false
Config.VisualsFullbright = false
Config.VisualsNoFog = false
Config.VisualsHolograms = false
Config.VisualsRainbowMap = false
Config.VisualsRainbowMapSpeed = 0.15
Config.VisualsStretch = 1.0
Config.VisualsStretchMin = 0.5
Config.VisualsStretchMax = 1.2
Config.VisualsCameraSway = false
Config.VisualsCameraSwayAmount = 0.5
Config.VisualsHologramDuration = 3.5
Config.VisualsHologramRange = 300
Config.VisualsHologramVisibility = 1.4
Config.VisualsHologramColor  = Color3.fromRGB(0, 220, 255)
Config.VisualsHologramAccent = Color3.fromRGB(255, 60, 200)
Config.VisualsGrade = "Crisp"
Config.VisualsGradeStrength = 0.6
Config.VisualsBloom = false
Config.VisualsBloomIntensity = 1.0
Config.VisualsVignette = false
Config.VisualsVignetteStrength = 0.6
Config.VisualsLetterbox = false
Config.VisualsLetterboxSize = 0.10
Config.VisualsDOF = false
Config.VisualsDOFDistance = 28
Config.VisualsDOFBlur = 0.5
Config.VisualsHologramStyle = "Orb"
Config.VisualsHologramLethal = true
Config.VisualsHologramLethalColor = Color3.fromRGB(255, 200, 60)

--------------------------------------------------------------------------------
-- [2] Visuals Main Logic (Core Engine)
--------------------------------------------------------------------------------
local Visuals = {}
;(function()
    local _origLighting, _origClones = nil, {}
    local _hologramFolder, _hologramCooldowns = nil, {}
    local _stretchBound, _rainbowConn = false, nil
    local _rainbowParts, _rainbowHue, _rainbowBatchIdx = {}, 0, 1
    local _perfBackup, _origParticleRates = nil, {}
    local _reassertConn, _reassertLastT = nil, 0
    local LIGHTING_PROPS = {
        "Brightness","ExposureCompensation","GlobalShadows","ShadowSoftness",
        "EnvironmentDiffuseScale","EnvironmentSpecularScale","ClockTime",
        "OutdoorAmbient","Ambient","FogEnd","FogStart","FogColor",
        "ColorShift_Top","ColorShift_Bottom",
    }
    local function snapshotLighting()
        if _origLighting then return end
        _origLighting = {}
        for _, p in ipairs(LIGHTING_PROPS) do
            local ok, v = pcall(function() return Lighting[p] end)
            if ok then _origLighting[p] = v end
        end
        for _, c in ipairs(Lighting:GetChildren()) do
            if not c:GetAttribute("VS_Custom") then
                local ok, clone = pcall(function() return c:Clone() end)
                if ok and clone then table.insert(_origClones, clone) end
            end
        end
    end
    local function clearTagged()
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:GetAttribute("VS_Custom") then c:Destroy() end
        end
    end
    local function restore()
        if not _origLighting then return end
        clearTagged()
        for k, v in pairs(_origLighting) do pcall(function() Lighting[k] = v end) end
        local exist = {}
        for _, c in ipairs(Lighting:GetChildren()) do exist[c.Name] = true end
        for _, clone in ipairs(_origClones) do
            if not exist[clone.Name] then clone:Clone().Parent = Lighting end
        end
    end
    local function fx(cls, props)
        local f = Instance.new(cls)
        f:SetAttribute("VS_Custom", true)
        for k, v in pairs(props) do f[k] = v end
        f.Parent = Lighting
        return f
    end
    local Presets = {}
    Presets.Neutral = function()
        clearTagged()
        Lighting.Brightness = 2; Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.2
        Lighting.EnvironmentDiffuseScale = 0.5; Lighting.EnvironmentSpecularScale = 0.5
        Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.fromRGB(70,70,70)
        Lighting.Ambient = Color3.fromRGB(0,0,0); Lighting.FogEnd = 100000
        fx("Atmosphere", { Density=0.3, Offset=0.25, Color=Color3.fromRGB(199,199,199),
            Decay=Color3.fromRGB(106,112,125), Glare=0, Haze=0 })
    end
    Presets.Cyberpunk = function()
        clearTagged()
        Lighting.Brightness = 2.6; Lighting.ExposureCompensation = 0.5
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 1
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(120,80,165)
        Lighting.Ambient = Color3.fromRGB(80,55,120)
        fx("Atmosphere", { Density=0.3, Offset=0.3, Color=Color3.fromRGB(160,70,215),
            Decay=Color3.fromRGB(75,200,240), Glare=2.2, Haze=1 })
        fx("BloomEffect", { Intensity=1.15, Size=24, Threshold=0.72 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.2, Saturation=0.45,
            TintColor=Color3.fromRGB(220,195,255) })
    end
    Presets.Anime = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.2
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 15; Lighting.OutdoorAmbient = Color3.fromRGB(150,140,170)
        Lighting.Ambient = Color3.fromRGB(95,85,120)
        fx("Atmosphere", { Density=0.28, Offset=0.35, Color=Color3.fromRGB(255,200,230),
            Decay=Color3.fromRGB(150,195,255), Glare=1, Haze=0.8 })
        fx("BloomEffect", { Intensity=1.0, Size=26, Threshold=0.8 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.14, Saturation=0.32,
            TintColor=Color3.fromRGB(255,228,242) })
    end
    Presets.Sunset = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.5
        Lighting.EnvironmentDiffuseScale = 0.75; Lighting.EnvironmentSpecularScale = 0.9
        Lighting.ClockTime = 17.75; Lighting.OutdoorAmbient = Color3.fromRGB(185,115,80)
        Lighting.Ambient = Color3.fromRGB(105,60,45)
        fx("Atmosphere", { Density=0.38, Offset=0.55, Color=Color3.fromRGB(255,150,80),
            Decay=Color3.fromRGB(255,105,60), Glare=1.8, Haze=1.6 })
        fx("BloomEffect", { Intensity=0.9, Size=24, Threshold=0.78 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.16, Saturation=0.32,
            TintColor=Color3.fromRGB(255,195,150) })
    end
    Presets.Vaporwave = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.6; Lighting.EnvironmentSpecularScale = 0.9
        Lighting.ClockTime = 18.4; Lighting.OutdoorAmbient = Color3.fromRGB(150,90,165)
        Lighting.Ambient = Color3.fromRGB(95,60,120)
        fx("Atmosphere", { Density=0.34, Offset=0.4, Color=Color3.fromRGB(255,130,205),
            Decay=Color3.fromRGB(110,200,255), Glare=1.8, Haze=1.3 })
        fx("BloomEffect", { Intensity=1.05, Size=26, Threshold=0.74 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.18, Saturation=0.38,
            TintColor=Color3.fromRGB(255,205,240) })
    end
    Presets.Void = function()
        clearTagged()
        Lighting.Brightness = 2.0; Lighting.ExposureCompensation = 0.25
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.9
        Lighting.EnvironmentDiffuseScale = 0.5; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(85,95,135)
        Lighting.Ambient = Color3.fromRGB(55,62,95)
        fx("Atmosphere", { Density=0.35, Offset=0.2, Color=Color3.fromRGB(55,65,110),
            Decay=Color3.fromRGB(95,110,180), Glare=0.3, Haze=0.8 })
        fx("BloomEffect", { Intensity=0.8, Size=22, Threshold=0.76 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.16, Saturation=-0.2,
            TintColor=Color3.fromRGB(190,200,255) })
    end
    Presets.Clarity = function()
        clearTagged()
        Lighting.Brightness = 2.6; Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 1
        Lighting.EnvironmentDiffuseScale = 0.2; Lighting.EnvironmentSpecularScale = 0.1
        Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.fromRGB(150,150,155)
        Lighting.Ambient = Color3.fromRGB(120,120,125); Lighting.FogEnd = 1000000
        fx("ColorCorrectionEffect", { Brightness=0.05, Contrast=0.25, Saturation=-0.2,
            TintColor=Color3.fromRGB(255,255,255) })
    end
    Presets.Toxic = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.35
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.6; Lighting.EnvironmentSpecularScale = 0.8
        Lighting.ClockTime = 1; Lighting.OutdoorAmbient = Color3.fromRGB(80,135,70)
        Lighting.Ambient = Color3.fromRGB(45,85,50)
        fx("Atmosphere", { Density=0.34, Offset=0.35, Color=Color3.fromRGB(95,220,110),
            Decay=Color3.fromRGB(55,180,80), Glare=1.8, Haze=1.4 })
        fx("BloomEffect", { Intensity=1.1, Size=24, Threshold=0.74 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.2, Saturation=0.45,
            TintColor=Color3.fromRGB(210,255,205) })
    end
    Presets.Sakura = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.35
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.8
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 15.5; Lighting.OutdoorAmbient = Color3.fromRGB(200,155,180)
        Lighting.Ambient = Color3.fromRGB(120,85,110)
        fx("Atmosphere", { Density=0.3, Offset=0.4, Color=Color3.fromRGB(255,205,225),
            Decay=Color3.fromRGB(255,175,215), Glare=1.2, Haze=1 })
        fx("BloomEffect", { Intensity=1.1, Size=26, Threshold=0.78 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.15, Saturation=0.28,
            TintColor=Color3.fromRGB(255,225,240) })
    end
    Presets.Nebula = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.9
        Lighting.EnvironmentDiffuseScale = 0.55; Lighting.EnvironmentSpecularScale = 0.85
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(128,94,168)
        Lighting.Ambient = Color3.fromRGB(82,60,120)
        fx("Atmosphere", { Density=0.34, Offset=0.25, Color=Color3.fromRGB(120,70,180),
            Decay=Color3.fromRGB(220,90,190), Glare=1.4, Haze=1.1 })
        fx("BloomEffect", { Intensity=1.15, Size=24, Threshold=0.72 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.2, Saturation=0.4,
            TintColor=Color3.fromRGB(235,205,255) })
    end
    local PresetScalars = {
        Neutral   = { Brightness=2,   ExposureCompensation=0,    ClockTime=14,   OutdoorAmbient=Color3.fromRGB(70,70,70),
                      Ambient=Color3.fromRGB(0,0,0),      FogEnd=100000,
                      EnvironmentDiffuseScale=0.5,  EnvironmentSpecularScale=0.5 },
        Clarity   = { Brightness=2.6, ExposureCompensation=0,    ClockTime=14,   OutdoorAmbient=Color3.fromRGB(150,150,155),
                      Ambient=Color3.fromRGB(120,120,125), FogEnd=1000000,
                      EnvironmentDiffuseScale=0.2,  EnvironmentSpecularScale=0.1 },
        Cyberpunk = { Brightness=2.6, ExposureCompensation=0.5,  ClockTime=0,    OutdoorAmbient=Color3.fromRGB(120,80,165),
                      Ambient=Color3.fromRGB(80,55,120),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=1 },
        Anime     = { Brightness=2.3, ExposureCompensation=0.2,  ClockTime=15,   OutdoorAmbient=Color3.fromRGB(150,140,170),
                      Ambient=Color3.fromRGB(95,85,120),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=0.7 },
        Sunset    = { Brightness=2.3, ExposureCompensation=0.4,  ClockTime=17.75, OutdoorAmbient=Color3.fromRGB(185,115,80),
                      Ambient=Color3.fromRGB(105,60,45),
                      EnvironmentDiffuseScale=0.75, EnvironmentSpecularScale=0.9 },
        Vaporwave = { Brightness=2.3, ExposureCompensation=0.4,  ClockTime=18.4, OutdoorAmbient=Color3.fromRGB(150,90,165),
                      Ambient=Color3.fromRGB(95,60,120),
                      EnvironmentDiffuseScale=0.6,  EnvironmentSpecularScale=0.9 },
        Toxic     = { Brightness=2.2, ExposureCompensation=0.35, ClockTime=1,    OutdoorAmbient=Color3.fromRGB(80,135,70),
                      Ambient=Color3.fromRGB(45,85,50),
                      EnvironmentDiffuseScale=0.6,  EnvironmentSpecularScale=0.8 },
        Void      = { Brightness=2.0, ExposureCompensation=0.25, ClockTime=0,    OutdoorAmbient=Color3.fromRGB(85,95,135),
                      Ambient=Color3.fromRGB(55,62,95),
                      EnvironmentDiffuseScale=0.5,  EnvironmentSpecularScale=0.7 },
        Sakura    = { Brightness=2.2, ExposureCompensation=0.35, ClockTime=15.5, OutdoorAmbient=Color3.fromRGB(200,155,180),
                      Ambient=Color3.fromRGB(120,85,110),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=0.7 },
        Nebula    = { Brightness=2.2, ExposureCompensation=0.4,  ClockTime=0,    OutdoorAmbient=Color3.fromRGB(128,94,168),
                      Ambient=Color3.fromRGB(82,60,120),
                      EnvironmentDiffuseScale=0.55, EnvironmentSpecularScale=0.85 },
    }
    local _WHITE = Color3.new(1, 1, 1)
    local function applyFullbrightOverride()
        if not Config.VisualsFullbright then return end
        pcall(function() if Lighting.Ambient ~= _WHITE then Lighting.Ambient = _WHITE end end)
        pcall(function() if Lighting.OutdoorAmbient ~= _WHITE then Lighting.OutdoorAmbient = _WHITE end end)
        pcall(function() if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end end)
        pcall(function() if Lighting.Brightness < 2 then Lighting.Brightness = 2 end end)
    end
    local function applyFogOverride()
        if not Config.VisualsNoFog then return end
        pcall(function() if Lighting.FogEnd ~= 1e6 then Lighting.FogEnd = 1e6 end end)
        pcall(function() if Lighting.FogStart ~= 1e6 then Lighting.FogStart = 1e6 end end)
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:IsA("Atmosphere") then
                pcall(function() if c.Density ~= 0 then c.Density = 0 end end)
            end
        end
    end
    local function cfg(key, default)
        local v = Config[key]
        if v == nil then return default end
        return v
    end
    local _GRADES = {
        Crisp = { B = 0.03,  C = 0.20, S = 0.18,  tint = _WHITE },
        Cold  = { B = -0.03, C = 0.28, S = -0.22, tint = Color3.fromRGB(196, 220, 255) },
        Warm  = { B = 0.04,  C = 0.22, S = 0.15,  tint = Color3.fromRGB(255, 222, 180) },
        Comp  = { B = -0.01, C = 0.40, S = 0.28,  tint = Color3.fromRGB(255, 248, 236) },
    }
    local _gradeFx = nil
    local function getGradeFx()
        if _gradeFx and _gradeFx.Parent then return _gradeFx end
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "_vs_grade"
        cc:SetAttribute("VS_Grade", true)
        cc.Parent = Lighting
        _gradeFx = cc
        return cc
    end
    local function reassertGrade()
        local g = _GRADES[cfg("VisualsGrade", "None")]
        if not g then
            if _gradeFx and _gradeFx.Parent then
                pcall(function() if _gradeFx.Enabled then _gradeFx.Enabled = false end end)
            end
            return
        end
        local s  = math.clamp(cfg("VisualsGradeStrength", 1), 0, 1)
        local tB, tC, tS = g.B * s, g.C * s, g.S * s
        local tT = g.tint:Lerp(_WHITE, 1 - s)
        local cc = getGradeFx()
        pcall(function()
            if not cc.Enabled then cc.Enabled = true end
            if math.abs(cc.Brightness - tB) > 0.001 then cc.Brightness = tB end
            if math.abs(cc.Contrast   - tC) > 0.001 then cc.Contrast   = tC end
            if math.abs(cc.Saturation - tS) > 0.001 then cc.Saturation = tS end
            if cc.TintColor ~= tT then cc.TintColor = tT end
        end)
    end
    local function clearGrade()
        if _gradeFx then pcall(function() _gradeFx:Destroy() end); _gradeFx = nil end
    end
    local _bloomFx = nil
    local function getBloomFx()
        if _bloomFx and _bloomFx.Parent then return _bloomFx end
        local b = Instance.new("BloomEffect")
        b.Name = "_vs_bloom"; b:SetAttribute("VS_Bloom", true)
        b.Size = 24; b.Threshold = 0.8; b.Intensity = 0
        b.Parent = Lighting
        _bloomFx = b
        return b
    end
    local function reassertBloom()
        if not cfg("VisualsBloom", false) then
            if _bloomFx and _bloomFx.Parent then
                pcall(function() if _bloomFx.Enabled then _bloomFx.Enabled = false end end)
            end
            return
        end
        local tI = math.clamp(cfg("VisualsBloomIntensity", 1), 0, 3)
        local b = getBloomFx()
        pcall(function()
            if not b.Enabled then b.Enabled = true end
            if math.abs(b.Intensity - tI) > 0.01 then b.Intensity = tI end
        end)
    end
    local function clearBloom()
        if _bloomFx then pcall(function() _bloomFx:Destroy() end); _bloomFx = nil end
    end
    local function reassertScalars()
        local sc = PresetScalars[State.VisualsCurrentPreset or Config.VisualsPreset]
        if sc then
            for k, v in pairs(sc) do pcall(function() if Lighting[k] ~= v then Lighting[k] = v end end) end
            pcall(function() if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end end)
        end
        applyFullbrightOverride()
        applyFogOverride()
        reassertGrade()
        reassertBloom()
    end
    local function startReassert()
        if _reassertConn then return end
        _reassertConn = RunService.Heartbeat:Connect(function()
            if not Config.Visuals or Config.VisualsPerformanceMode then return end
            local now = tick()
            if (now - _reassertLastT) < 1.0 then return end
            _reassertLastT = now
            reassertScalars()
        end)
    end
    local function stopReassert()
        if _reassertConn then _reassertConn:Disconnect(); _reassertConn = nil end
    end
    Visuals.PresetOrder = { "Neutral", "Clarity", "Cyberpunk", "Anime", "Sunset", "Vaporwave", "Toxic", "Void", "Sakura", "Nebula" }
    local function applyPreset(name)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        local fn = Presets[name]; if not fn then return end
        pcall(fn); State.VisualsCurrentPreset = name; Config.VisualsPreset = name
        reassertGrade()
        reassertBloom()
    end
    local function getHoloFolder()
        if _hologramFolder and _hologramFolder.Parent then return _hologramFolder end
        local f = Instance.new("Folder"); f.Name = "_vs_holos"; f.Parent = Workspace
        _hologramFolder = f; return f
    end
    local _GOLD = Color3.fromRGB(255, 200, 60)
    local _EDGE    = Color3.fromRGB(155, 232, 255)
    local _VISIBLE = Color3.fromRGB(41, 224, 255)
    local function easeInOut(a) return a * a * (3 - 2 * a) end
    local HOLO_SKEL_R15 = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }
    local HOLO_SKEL_R6 = {
        {"Head","Torso"},
        {"Torso","Left Arm"},{"Torso","Right Arm"},
        {"Torso","Left Leg"},{"Torso","Right Leg"},
    }
    local function fadePop(container, parts, hl, dur, tr0)
        tr0 = tr0 or 0.55
        local startT = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not container.Parent then if conn then conn:Disconnect() end return end
            local a  = math.clamp((tick() - startT) / dur, 0, 1)
            local e  = easeInOut(a)
            local tr = tr0 + (1 - tr0) * e
            for _, b in ipairs(parts) do b.Transparency = tr end
            if hl then hl.OutlineTransparency = e end
            if a >= 1 and conn then conn:Disconnect() end
        end)
        Debris:AddItem(container, dur + 0.2)
    end
    local function popSkeleton(char, dur, color)
        local vis = math.clamp(cfg("VisualsHologramVisibility", 1.4), 0.2, 2)
        local tr0 = math.clamp(1 - 0.45 * vis, 0, 0.91)
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local isR6 = (hum and hum.RigType == Enum.HumanoidRigType.R6) or (char:FindFirstChild("Torso") ~= nil)
        local rig  = isR6 and HOLO_SKEL_R6 or HOLO_SKEL_R15
        local model = Instance.new("Model")
        model.Name = "_hs" .. math.random(10000, 99999)
        local parts, n = {}, 0
        for _, pair in ipairs(rig) do
            local a, b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
            if a and b then
                local ap, bp = a.Position, b.Position
                local len = (bp - ap).Magnitude
                if len > 0.05 and len < 20 then
                    local bone = Instance.new("Part")
                    bone.Shape = Enum.PartType.Cylinder
                    bone.Size = Vector3.new(len, 0.1 + 0.06 * vis, 0.1 + 0.06 * vis)
                    bone.Material = Enum.Material.Neon
                    bone.Color = color
                    bone.Transparency = tr0
                    bone.Anchored = true; bone.CanCollide = false; bone.CanQuery = false
                    bone.CanTouch = false; bone.CastShadow = false; bone.Massless = true
                    bone:SetAttribute("VS_Holo", true)
                    bone.CFrame = CFrame.lookAt((ap + bp) * 0.5, bp) * CFrame.Angles(0, math.rad(90), 0)
                    bone.Parent = model
                    n = n + 1; parts[n] = bone
                end
            end
        end
        if n == 0 then model:Destroy(); return end
        model.Parent = getHoloFolder()
        fadePop(model, parts, nil, dur, tr0)
    end
    local _wraiths = {}
    local function wraithCount()
        local n = 0
        for i = #_wraiths, 1, -1 do
            local m = _wraiths[i]
            if m and m.Parent then n = n + 1 else table.remove(_wraiths, i) end
        end
        return n
    end
    local STRIP_CLASSES = {
        "Humanoid","Sound","ParticleEmitter","Trail","Beam","Fire","Smoke","Sparkles",
        "ForceField","Highlight","BillboardGui","SurfaceGui","BaseScript",
    }
    local function popWraith(char, dur, color)
        if wraithCount() >= 4 then return end
        local vis = math.clamp(cfg("VisualsHologramVisibility", 1.4), 0.2, 2)
        local tr0 = math.clamp(1 - 0.45 * vis, 0, 0.91)
        local clone
        pcall(function()
            local was = char.Archivable
            char.Archivable = true
            clone = char:Clone()
            char.Archivable = was
        end)
        if not clone then return end
        clone.Name = "_hw" .. math.random(10000, 99999)
        local parts, n = {}, 0
        for _, d in ipairs(clone:GetDescendants()) do
            local strip = false
            for _, cls in ipairs(STRIP_CLASSES) do
                if d:IsA(cls) then strip = true break end
            end
            if strip then
                pcall(function() d:Destroy() end)
            elseif d:IsA("BasePart") then
                d.Anchored = true; d.CanCollide = false; d.CanQuery = false
                d.CanTouch = false; d.CastShadow = false; d.Massless = true
                d:SetAttribute("VS_Holo", true)
                if d.Transparency < 0.98 then
                    d.Material = Enum.Material.ForceField
                    d.Color = color
                    d.Transparency = tr0
                    n = n + 1; parts[n] = d
                else
                    d.Transparency = 1
                end
            end
        end
        if n == 0 then clone:Destroy(); return end
        clone:SetAttribute("VS_Holo", true)
        clone.Parent = getHoloFolder()
        local hl
        pcall(function()
            local h = Instance.new("Highlight")
            h.FillTransparency = 1
            h.OutlineColor = _WHITE
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Adornee = clone
            h.Parent = clone
            hl = h
        end)
        table.insert(_wraiths, clone)
        fadePop(clone, parts, hl, dur, tr0)
    end
    local function createHologram(character, lethal)
        if not character or not character.Parent then return end
        local rp = character:FindFirstChild("HitboxHead")
            or character:FindFirstChild("Head")
            or character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("UpperTorso")
        if not rp then return end
        if (rp.Position - Camera.CFrame.Position).Magnitude > Config.VisualsHologramRange then return end
        if #getHoloFolder():GetChildren() >= 16 then return end
        local dur = math.clamp(Config.VisualsHologramDuration or 3.5, 0.25, 10)
        local lethalOn  = lethal and cfg("VisualsHologramLethal", true)
        local mainColor = lethalOn and cfg("VisualsHologramLethalColor", _GOLD) or Config.VisualsHologramColor
        local style = cfg("VisualsHologramStyle", "Orb")
        if Config.VisualsPerformanceMode and style == "Wraith" then style = "Orb" end
        if style == "Skeleton" then popSkeleton(character, dur, mainColor); return end
        if style == "Wraith"   then popWraith(character, dur, mainColor);   return end
        local folder = getHoloFolder()
        local function mkBall(size, transp, color)
            local b = Instance.new("Part")
            b.Shape = Enum.PartType.Ball
            b.Size = Vector3.new(size, size, size)
            b.Material = Enum.Material.Neon
            b.Color = color
            b.Transparency = transp
            b.Anchored = true; b.CanCollide = false; b.CanQuery = false
            b.CanTouch = false; b.CastShadow = false; b.Massless = true
            b:SetAttribute("VS_Holo", true)
            return b
        end
        local vis = math.clamp(cfg("VisualsHologramVisibility", 1.4), 0.2, 2)
        local sc  = 0.75 + 0.25 * vis
        local h0  = math.clamp(0.65 / vis, 0.1, 0.9)
        local core = mkBall(0.7 * sc, 0.05, mainColor)
        local halo = mkBall(1.7 * sc, h0, mainColor)
        local startCF = CFrame.new(rp.Position)
        core.CFrame = startCF; halo.CFrame = startCF
        core.Name = "_h" .. math.random(10000, 99999); halo.Name = core.Name .. "_g"
        core.Parent = folder; halo.Parent = folder
        local shockColor = Config.VisualsHologramAccent or Config.VisualsHologramColor
        local shock = mkBall(0.5, 0.15, shockColor)
        shock.Shape = Enum.PartType.Cylinder
        shock.Size  = Vector3.new(0.1, 0.5, 0.5)
        do
            local cam = workspace.CurrentCamera
            if cam then shock.CFrame = CFrame.lookAt(rp.Position, cam.CFrame.Position) * CFrame.Angles(0, math.rad(90), 0)
            else shock.CFrame = startCF * CFrame.Angles(0, 0, math.rad(90)) end
        end
        shock.Name = core.Name .. "_s"
        shock.Parent = folder
        local startT = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not core.Parent then if conn then conn:Disconnect() end return end
            local alpha = math.clamp((tick() - startT) / dur, 0, 1)
            local rise  = 2.5 * (1 - (1 - alpha) * (1 - alpha))
            local cf    = startCF + Vector3.new(0, rise, 0)
            core.CFrame = cf; halo.CFrame = cf
            core.Transparency = math.clamp(0.05 + 0.95 * alpha, 0, 1)
            halo.Transparency = math.clamp(h0 + (1 - h0) * alpha, 0, 1)
            if shock.Parent then
                local sa = math.clamp((tick() - startT) / 0.3, 0, 1)
                local se = 1 - (1 - sa) * (1 - sa)
                local sd = 0.5 + 3.5 * se
                shock.Size = Vector3.new(0.1, sd, sd)
                shock.Transparency = math.clamp(0.15 + 0.85 * sa, 0, 1)
            end
            if alpha >= 1 and conn then conn:Disconnect() end
        end)
        Debris:AddItem(core, dur + 0.2)
        Debris:AddItem(halo, dur + 0.2)
        Debris:AddItem(shock, 0.5)
    end

    local applyCamFrame, clearCamFrame
    ;(function()
        local TweenService = game:GetService("TweenService")
        local _camGui, _vgFrames, _lbTop, _lbBot, _dof = nil, nil, nil, nil, nil
        local C_BLACK_FRAME = Color3.new(0, 0, 0)
        local function ensureCamGui()
            if _camGui and _camGui.Parent then return _camGui end
            local g = Instance.new("ScreenGui")
            g.Name = "_vs_cam"
            g.IgnoreGuiInset = true; g.ResetOnSpawn = false
            g.DisplayOrder = 990
            local ok = pcall(function() g.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
            if not ok or not g.Parent then
                pcall(function() g.Parent = lp:FindFirstChildOfClass("PlayerGui") end)
            end
            _camGui = g
            return g
        end
        local VG_SIDES = {
            { size = UDim2.new(1, 0, 0.24, 0),  pos = UDim2.new(0, 0, 0, 0),     rot = 90  },
            { size = UDim2.new(1, 0, 0.24, 0),  pos = UDim2.new(0, 0, 0.76, 0),  rot = 270 },
            { size = UDim2.new(0.17, 0, 1, 0),  pos = UDim2.new(0, 0, 0, 0),     rot = 0   },
            { size = UDim2.new(0.17, 0, 1, 0),  pos = UDim2.new(0.83, 0, 0, 0),  rot = 180 },
        }
        local function vgApply()
            local on = Config.Visuals and cfg("VisualsVignette", false)
            if not on then
                if _vgFrames then
                    for i = 1, #_vgFrames do _vgFrames[i].Visible = false end
                end
                return
            end
            if not _vgFrames then
                local g = ensureCamGui()
                _vgFrames = {}
                for i = 1, #VG_SIDES do
                    local s = VG_SIDES[i]
                    local f = Instance.new("Frame")
                    f.Name = "_cv" .. i
                    f.BackgroundColor3 = C_BLACK_FRAME; f.BorderSizePixel = 0
                    f.Size = s.size; f.Position = s.pos; f.Visible = false; f.ZIndex = 1
                    local grad = Instance.new("UIGradient")
                    grad.Rotation = s.rot
                    grad.Transparency = NumberSequence.new(0, 1)
                    grad.Parent = f
                    f.Parent = g
                    _vgFrames[i] = f
                end
            end
            local tr = 1 - 0.85 * math.clamp(cfg("VisualsVignetteStrength", 0.6), 0, 1)
            for i = 1, #_vgFrames do
                local f = _vgFrames[i]
                f.BackgroundTransparency = tr; f.Visible = true
            end
        end
        local LB_TI = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local function lbApply(animate)
            local on = Config.Visuals and cfg("VisualsLetterbox", false)
            if not on and not _lbTop then return end
            if not _lbTop then
                local g = ensureCamGui()
                for i = 1, 2 do
                    local f = Instance.new("Frame")
                    f.Name = "_clb" .. i
                    f.BackgroundColor3 = C_BLACK_FRAME; f.BackgroundTransparency = 0
                    f.BorderSizePixel = 0; f.ZIndex = 2
                    f.Parent = g
                    if i == 1 then _lbTop = f else _lbBot = f end
                end
                _lbTop.Position = UDim2.new(0, 0, -0.2, 0)
                _lbBot.Position = UDim2.new(0, 0, 1, 0)
            end
            local sz = math.clamp(cfg("VisualsLetterboxSize", 0.10), 0.04, 0.18)
            local topP = on and UDim2.new(0, 0, 0, 0)      or UDim2.new(0, 0, -sz - 0.02, 0)
            local botP = on and UDim2.new(0, 0, 1 - sz, 0) or UDim2.new(0, 0, 1.02, 0)
            _lbTop.Size = UDim2.new(1, 0, sz, 0); _lbBot.Size = UDim2.new(1, 0, sz, 0)
            if animate then
                pcall(function()
                    TweenService:Create(_lbTop, LB_TI, { Position = topP }):Play()
                    TweenService:Create(_lbBot, LB_TI, { Position = botP }):Play()
                end)
            else
                _lbTop.Position = topP; _lbBot.Position = botP
            end
        end
        local function dofApply()
            local on = Config.Visuals and not Config.VisualsPerformanceMode and cfg("VisualsDOF", false)
            if not on then
                if _dof then pcall(function() _dof:Destroy() end); _dof = nil end
                return
            end
            if not (_dof and _dof.Parent) then
                local d = Instance.new("DepthOfFieldEffect")
                d.Name = "_vs_dof"; d:SetAttribute("VS_DoF", true)
                d.InFocusRadius = 22
                d.Parent = Lighting
                _dof = d
            end
            local blur = math.clamp(cfg("VisualsDOFBlur", 0.5), 0, 1)
            pcall(function()
                _dof.FocusDistance = math.clamp(cfg("VisualsDOFDistance", 28), 5, 100)
                _dof.FarIntensity  = 0.75 * blur
                _dof.NearIntensity = 0.5  * blur
            end)
        end
        applyCamFrame = function(animate) vgApply(); lbApply(animate); dofApply() end
        clearCamFrame = function()
            if _camGui then pcall(function() _camGui:Destroy() end) end
            _camGui, _vgFrames, _lbTop, _lbBot = nil, nil, nil, nil
            if _dof then pcall(function() _dof:Destroy() end); _dof = nil end
        end
    end)()

    local _fovSaved = nil
    local _tpRP = nil
    local function bindStretch()
        if _stretchBound then return end
        _stretchBound = true
        RunService:BindToRenderStep("VS_Stretch", Enum.RenderPriority.Last.Value, function()
            if not Config.Visuals then return end
            local s = Config.VisualsStretch
            local doStretch = math.abs(s - 1.0) >= 0.001
            local doSway = Config.VisualsCameraSway
            if Config.CameraFovOverride then
                local want = math.clamp(Config.CameraFovAmount or 90, 40, 130)
                if _fovSaved == nil then _fovSaved = Camera.FieldOfView end
                if Camera.FieldOfView ~= want then Camera.FieldOfView = want end
            elseif _fovSaved ~= nil then
                Camera.FieldOfView = _fovSaved; _fovSaved = nil
            end
            if not (doStretch or doSway) then return end
            local c = Camera.CFrame
            if doSway then
                local amt = math.clamp(Config.VisualsCameraSwayAmount or 0.5, 0, 1)
                local t = tick()
                local roll  = (math.sin(t * 0.9) + math.sin(t * 0.37) * 0.6) * amt
                local pitch =  math.sin(t * 1.3) * 0.7 * amt
                local yaw   =  math.sin(t * 0.7) * 0.8 * amt
                c = c * CFrame.Angles(math.rad(pitch), math.rad(yaw), math.rad(roll))
            end
            if doStretch then
                c = CFrame.fromMatrix(c.Position, c.RightVector * s, c.UpVector)
            end
            Camera.CFrame = c
        end)
    end

    local _spooferActive = false
    local _spooferConns = {}
    local _isSpoofing = {}
    local _origText = {}
    local function anySpoofOn()
        return Config.SpooferNameEnabled or Config.SpooferLevelEnabled or Config.SpooferCasualWinsEnabled
            or Config.SpooferRankedWinsEnabled or Config.SpooferRankedEloEnabled
            or Config.SpooferWinPercentEnabled or Config.SpooferWinStreakEnabled
            or Config.SpooferFavoriteMapEnabled
    end
    local function escPat(s) return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")) end
    local function escRep(s) return (s:gsub("%%", "%%%%")) end
    local function belongsToLp(obj)
        local node, depth = obj, 0
        while node ~= nil and node ~= game and depth < 12 do
            if node:IsA("BillboardGui") then
                local anchor = node.Adornee or node.Parent
                while anchor ~= nil and not anchor:IsA("Model") do anchor = anchor.Parent end
                if anchor ~= nil then
                    local plr = Players:GetPlayerFromCharacter(anchor)
                    if plr ~= nil then return plr == lp end
                end
            elseif node:IsA("Model") then
                local plr = Players:GetPlayerFromCharacter(node)
                if plr ~= nil then return plr == lp end
            end
            local asId = tonumber(node.Name)
            if asId ~= nil and Players:GetPlayerByUserId(asId) ~= nil then return asId == lp.UserId end
            node = node.Parent; depth = depth + 1
        end
        return true
    end
    local ALLOWED_TEXT_NAMES = {
        DisplayName = true, Username = true, Name = true, Handle = true, Nametag = true,
        Title = true, TitleText = true, Value = true, Text = true, Label = true,
        Wins = true, WinRate = true, Streak = true, WinStreak = true, ELO = true, Level = true,
    }
    local function applyTextSpoof(obj)
        if not (obj and obj.Parent) then return end
        if _isSpoofing[obj] then return end
        local text = obj.Text
        if not text or #text == 0 then return end
        local newText = text
        local changed = false
        if Config.SpooferNameEnabled then
            local fakeName = Config.SpooferName or "ProPlayer"
            local fakeDisp = Config.SpooferDisplayName or fakeName
            local realName = lp.Name
            local realDisp = lp.DisplayName
            if realDisp and #realDisp > 0 and newText:find(realDisp, 1, true) then
                newText = newText:gsub(escPat(realDisp), escRep(fakeDisp))
                changed = true
            end
            if realName and #realName > 0 and newText:find(realName, 1, true) then
                newText = newText:gsub(escPat(realName), escRep(fakeName))
                changed = true
            end
        end
        local pn = obj.Parent and obj.Parent.Name or ""
        local on = obj.Name
        local isVal = (on == "Value" or on == "Text")
        local is_level = (pn == "Level" or pn == "LevelContainer") and (isVal or on == "Level")
        local is_wins = (on == "Wins" or pn == "Wins" or pn == "WinsContainer") and (isVal or on == "Wins")
        local is_elo = (pn == "ELO" or pn == "RankedElo" or pn == "Rating" or pn == "Rank") and (isVal or on == "ELO")
        local is_winrate = (on == "WinRate" or on == "win rate" or pn == "WinRate") and (isVal or on == "WinRate")
        local is_streak = (pn == "Streak" or pn == "WinStreak" or pn == "StreakContainer" or on == "Streak" or on == "WinStreak")
            and (isVal or on == "Streak" or on == "WinStreak")
        if (is_level or is_wins or is_elo or is_winrate or is_streak) and belongsToLp(obj) then
            local sVal = nil
            if Config.SpooferLevelEnabled and is_level then sVal = tostring(Config.SpooferLevel or 100)
            elseif Config.SpooferCasualWinsEnabled and is_wins then sVal = tostring(Config.SpooferCasualWins or 500)
            elseif Config.SpooferRankedEloEnabled and is_elo then sVal = tostring(Config.SpooferRankedElo or 2400)
            elseif Config.SpooferWinPercentEnabled and is_winrate then sVal = tostring(Config.SpooferWinPercent or 75) .. "%"
            elseif Config.SpooferWinStreakEnabled and is_streak then sVal = tostring(Config.SpooferWinStreak or 25)
            end
            if sVal ~= nil and newText ~= sVal then newText = sVal; changed = true end
        end
        if changed and newText ~= text then
            if _origText[obj] == nil then _origText[obj] = text end
            _isSpoofing[obj] = true
            pcall(function() obj.Text = newText end)
            _isSpoofing[obj] = nil
        end
    end
    local function registerTextObj(obj)
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
        if _spooferConns[obj] ~= nil then return end
        local txt = nil
        pcall(function() txt = obj.Text end)
        local mine = type(txt) == "string" and #txt > 0
            and ((#lp.Name > 0 and txt:find(lp.Name, 1, true) ~= nil)
              or (#lp.DisplayName > 0 and txt:find(lp.DisplayName, 1, true) ~= nil))
        if not ALLOWED_TEXT_NAMES[obj.Name] and not mine then return end
        applyTextSpoof(obj)
        _spooferConns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function() applyTextSpoof(obj) end)
        obj.Destroying:Once(function()
            local c = _spooferConns[obj]
            if c ~= nil then pcall(function() c:Disconnect() end) end
            _spooferConns[obj] = nil; _origText[obj] = nil; _isSpoofing[obj] = nil
        end)
    end
    local function stopGuiNameSpoofer()
        for k, c in pairs(_spooferConns) do
            pcall(function() c:Disconnect() end)
            _spooferConns[k] = nil
        end
        for obj, t in pairs(_origText) do
            pcall(function()
                if obj.Parent ~= nil then
                    _isSpoofing[obj] = true; obj.Text = t; _isSpoofing[obj] = nil
                end
            end)
            _origText[obj] = nil
        end
        _isSpoofing = {}
        _spooferActive = false
    end
    local function startGuiNameSpoofer()
        if _spooferActive or not anySpoofOn() then return end
        _spooferActive = true
        local pGui = lp:FindFirstChildOfClass("PlayerGui")
        if pGui then
            for _, inst in ipairs(pGui:GetDescendants()) do registerTextObj(inst) end
            _spooferConns["pGuiDesc"] = pGui.DescendantAdded:Connect(registerTextObj)
        end
        pcall(function()
            local cGui = (gethui and gethui()) or cloneref(game:GetService("CoreGui"))
            if cGui then
                for _, inst in ipairs(cGui:GetDescendants()) do registerTextObj(inst) end
                _spooferConns["cGuiDesc"] = cGui.DescendantAdded:Connect(registerTextObj)
            end
        end)
    end
    local function refreshGuiNameSpoofer()
        if not anySpoofOn() then stopGuiNameSpoofer(); return end
        if not _spooferActive then startGuiNameSpoofer(); return end
        for obj in pairs(_spooferConns) do
            if typeof(obj) == "Instance" then pcall(applyTextSpoof, obj) end
        end
    end

    local function startRainbow()
        if _rainbowConn then return end
        _rainbowBatchIdx = 1; table.clear(_rainbowParts)
        local charSet = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character then charSet[pl.Character] = true end
        end
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("BasePart") and not d:GetAttribute("VS_Holo")
                and not charSet[d.Parent]
                and d.Name ~= "Terrain" then
                table.insert(_rainbowParts, { part = d, originalColor = d.Color })
            end
        end
        _rainbowConn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Visuals or not Config.VisualsRainbowMap then return end
            _rainbowHue = (_rainbowHue + dt * Config.VisualsRainbowMapSpeed) % 1
            local total = #_rainbowParts; if total == 0 then return end
            local batch = math.min(250, total)
            for i = 1, batch do
                local idx = ((_rainbowBatchIdx - 1 + i - 1) % total) + 1
                local e   = _rainbowParts[idx]
                if e and e.part and e.part.Parent then
                    e.part.Color = Color3.fromHSV((_rainbowHue + (idx / total) * 0.3) % 1, 0.85, 1)
                end
            end
            _rainbowBatchIdx = ((_rainbowBatchIdx + batch - 1) % total) + 1
        end)
    end
    local function stopRainbow()
        if _rainbowConn then _rainbowConn:Disconnect(); _rainbowConn = nil end
        for _, e in ipairs(_rainbowParts) do
            if e.part and e.part.Parent then pcall(function() e.part.Color = e.originalColor end) end
        end
        table.clear(_rainbowParts)
    end
    function Visuals.toggleRainbowMap(on)
        Config.VisualsRainbowMap = on
        if on and Config.Visuals then startRainbow() else stopRainbow() end
    end
    local function applyPerf()
        if not _perfBackup then
            _perfBackup = {
                GlobalShadows = Lighting.GlobalShadows,
                EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
                EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
                Brightness = Lighting.Brightness,
                ShadowSoftness = Lighting.ShadowSoftness,
            }
        end
        clearTagged(); clearGrade(); clearBloom()
        Lighting.GlobalShadows = false; Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0; Lighting.Brightness = 2
        Lighting.ShadowSoftness = 0
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("ParticleEmitter") and not d:GetAttribute("VS_Holo") then
                if not _origParticleRates[d] then _origParticleRates[d] = d.Rate end
                d.Rate = 0
            end
        end
    end
    local function disablePerf()
        if _perfBackup then
            for k, v in pairs(_perfBackup) do pcall(function() Lighting[k] = v end) end
            _perfBackup = nil
        end
        for em, rate in pairs(_origParticleRates) do
            if em and em.Parent then pcall(function() em.Rate = rate end) end
        end
        table.clear(_origParticleRates)
        if State.VisualsCurrentPreset then applyPreset(State.VisualsCurrentPreset) end
    end
    function Visuals.togglePerf(on)
        Config.VisualsPerformanceMode = on
        if on then applyPerf() else disablePerf() end
        applyCamFrame(false)
    end
    function Visuals.setPreset(name)
        if Presets[name] then
            Config.VisualsPreset = name
            applyPreset(name)
        end
    end
    Visuals.PresetOrder = { "Neutral", "Clarity", "Cyberpunk", "Anime", "Sunset", "Vaporwave", "Toxic", "Void", "Sakura", "Nebula" }
    Visuals.GradeOrder = { "None", "Crisp", "Cold", "Warm", "Comp" }
    function Visuals.setGrade(name)
        Config.VisualsGrade = name
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertGrade()
    end
    function Visuals.setGradeStrength(v)
        Config.VisualsGradeStrength = math.clamp(v, 0, 1)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertGrade()
    end
    function Visuals.setBloom(on)
        Config.VisualsBloom = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertBloom()
    end
    function Visuals.setBloomIntensity(v)
        Config.VisualsBloomIntensity = math.clamp(v, 0, 3)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertBloom()
    end
    function Visuals.toggleFullbright(on)
        Config.VisualsFullbright = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        if on then applyFullbrightOverride()
        else applyPreset(State.VisualsCurrentPreset or Config.VisualsPreset or "Neutral") end
    end
    function Visuals.toggleNoFog(on)
        Config.VisualsNoFog = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        if on then applyFogOverride()
        else applyPreset(State.VisualsCurrentPreset or Config.VisualsPreset or "Neutral") end
    end
    Visuals.applyGuiNameSpoof = refreshGuiNameSpoofer

    function Visuals.init()
        snapshotLighting()
        if Config.Visuals then bindStretch() end
        refreshGuiNameSpoofer()
    end
    function Visuals.enable()
        Config.Visuals = true; applyPreset(Config.VisualsPreset or "Neutral")
        if not Config.VisualsPerformanceMode then
            applyFullbrightOverride(); applyFogOverride()
        end
        bindStretch()
        refreshGuiNameSpoofer()
        if Config.VisualsRainbowMap then startRainbow() end
        if Config.VisualsPerformanceMode then applyPerf() end
        startReassert()
        applyCamFrame(false)
    end
    function Visuals.disable()
        Config.Visuals = false; stopRainbow(); stopReassert()
        clearGrade(); clearBloom(); clearCamFrame()
        if Config.VisualsPerformanceMode then disablePerf() end
        if _stretchBound then
            pcall(function() RunService:UnbindFromRenderStep("VS_Stretch") end)
            _stretchBound = false
        end
        restore()
    end
end)()

Visuals.init()

--------------------------------------------------------------------------------
-- [3] LinoriaLib UI Layout Structure for Visuals Tab
--------------------------------------------------------------------------------

-- ESP Section
local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP Elements')
ESPGroup:AddToggle('ESPBox', { Text = 'Box ESP', Default = false })
ESPGroup:AddToggle('ESPName', { Text = 'Name ESP', Default = false })
ESPGroup:AddToggle('ESPHealth', { Text = 'Health ESP', Default = false })
ESPGroup:AddToggle('ESPDistance', { Text = 'Distance ESP', Default = false })
ESPGroup:AddToggle('ESPTracer', { Text = 'Tracer ESP', Default = false })
ESPGroup:AddToggle('ESPSkeleton', { Text = 'Skeleton ESP', Default = false })
ESPGroup:AddToggle('ESPChams', { Text = 'Chams ESP', Default = false })

-- Indicators Section
local _3323x151 = false -- Ragebot Indicator 활성화 여부
local a41b78c88 = false -- Ammo Indicator 활성화 여부

local IndicatorGroup = Tabs.Visuals:AddLeftGroupbox('Indicators')
IndicatorGroup:AddToggle('IndicatorRagebot', {
    Text = 'Ragebot Indicator',
    Default = false,
    Callback = function(Value) _3323x151 = Value end
})
IndicatorGroup:AddToggle('IndicatorAmmo', {
    Text = 'Ammo Indicator',
    Default = false,
    Callback = function(Value) a41b78c88 = Value end
})

-- Visual Master & Environment Group
local MasterGroup = Tabs.Visuals:AddRightGroupbox('Environment & Lighting')

MasterGroup:AddToggle('VisualsMasterToggle', {
    Text = 'Enable Custom Lighting',
    Default = false,
    Callback = function(Value)
        if Value then Visuals.enable() else Visuals.disable() end
    end
})

MasterGroup:AddDropdown('VisualsPresetDropdown', {
    Values = Visuals.PresetOrder,
    Default = 1,
    Text = 'Lighting Preset',
    Callback = function(Value) Visuals.setPreset(Value) end
})

MasterGroup:AddToggle('VisualsFullbrightToggle', {
    Text = 'Fullbright',
    Default = false,
    Callback = function(Value) Visuals.toggleFullbright(Value) end
})

MasterGroup:AddToggle('VisualsNoFogToggle', {
    Text = 'No Fog',
    Default = false,
    Callback = function(Value) Visuals.toggleNoFog(Value) end
})

MasterGroup:AddToggle('VisualsRainbowMapToggle', {
    Text = 'Rainbow Map',
    Default = false,
    Callback = function(Value) Visuals.toggleRainbowMap(Value) end
})

MasterGroup:AddToggle('VisualsPerformanceToggle', {
    Text = 'Performance Mode',
    Default = false,
    Callback = function(Value) Visuals.togglePerf(Value) end
})

-- Shading & Post Processing Group
local PostGroup = Tabs.Visuals:AddRightGroupbox('Post-Processing FX')

PostGroup:AddDropdown('VisualsGradeDropdown', {
    Values = Visuals.GradeOrder,
    Default = 2,
    Text = 'Color Grade Filter',
    Callback = function(Value) Visuals.setGrade(Value) end
})

PostGroup:AddSlider('VisualsGradeStrengthSlider', {
    Text = 'Grade Strength',
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value) Visuals.setGradeStrength(Value) end
})

PostGroup:AddToggle('VisualsBloomToggle', {
    Text = 'Custom Bloom Effect',
    Default = false,
    Callback = function(Value) Visuals.setBloom(Value) end
})

PostGroup:AddSlider('VisualsBloomIntensitySlider', {
    Text = 'Bloom Intensity',
    Default = 1.0,
    Min = 0,
    Max = 3,
    Rounding = 2,
    Callback = function(Value) Visuals.setBloomIntensity(Value) end
})

-- Camera & Stretch FX Group
local CameraGroup = Tabs.Visuals:AddLeftGroupbox('Camera Effects')

CameraGroup:AddSlider('VisualsStretchSlider', {
    Text = 'Resolution Stretch',
    Default = 1.0,
    Min = 0.5,
    Max = 1.2,
    Rounding = 2,
    Callback = function(Value)
        Config.VisualsStretch = Value
    end
})

CameraGroup:AddToggle('VisualsSwayToggle', {
    Text = 'Motion Sway FX',
    Default = false,
    Callback = function(Value) Config.VisualsCameraSway = Value end
})

CameraGroup:AddToggle('CameraFovToggle', {
    Text = 'FOV Override',
    Default = false,
    Callback = function(Value) Config.CameraFovOverride = Value end
})

CameraGroup:AddSlider('CameraFovSlider', {
    Text = 'FOV Value',
    Default = 90,
    Min = 40,
    Max = 130,
    Rounding = 0,
    Callback = function(Value) Config.CameraFovAmount = Value end
})

-- Name & Stat Spoofer Section
local SpooferGroup = Tabs.Visuals:AddRightGroupbox('Profile Spoofer')

SpooferGroup:AddToggle('SpooferNameToggle', {
    Text = 'Spoof Display Name',
    Default = false,
    Callback = function(Value)
        Config.SpooferNameEnabled = Value
        Visuals.applyGuiNameSpoof()
    end
})

SpooferGroup:AddInput('SpooferNameInput', {
    Default = 'ProPlayer',
    Numeric = false,
    Finished = true,
    Text = 'Fake Name',
    Callback = function(Value)
        Config.SpooferName = Value
        Config.SpooferDisplayName = Value
        Visuals.applyGuiNameSpoof()
    end
})

-- Skybox Compatibility Section
local SkyboxGroup = Tabs.Visuals:AddRightGroupbox('Legacy Skybox Presets')

local function GetSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
    end
    return sky
end

local SkyPresets = {
    ["Purple Nebula"] = "rbxassetid://159454299",
    ["Night Sky"] = "rbxassetid://12064107",
    ["Pink Sunset"] = "rbxassetid://271042310",
    ["Vaporwave"] = "rbxassetid://1417494402"
}

local function ApplySky(id)
    local sky = GetSky()
    sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = id, id, id, id, id, id
end

local function RemoveSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
end

SkyboxGroup:AddDropdown('SkyboxPresetDropdown', {
    Values = { 'Disable', 'Purple Nebula', 'Night Sky', 'Pink Sunset', 'Vaporwave' },
    Default = 1,
    Text = 'Presets',
    Callback = function(Value)
        if Value == 'Disable' then RemoveSky() elseif SkyPresets[Value] then ApplySky(SkyPresets[Value]) end
    end
})

-- ==========================================
-- Screen GUI Indicators (화면 중앙 표시)
-- ==========================================
local _9376x428 = Instance.new("ScreenGui")
_9376x428.Name = "HalmuIndicators"
_9376x428.ResetOnSpawn = false
_9376x428.IgnoreGuiInset = true
_9376x428.DisplayOrder = 999
_9376x428.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    _9376x428.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end)
if not _9376x428.Parent then
    _9376x428.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local _993_318 = Instance.new("TextLabel")
_993_318.Name = "RagebotIndicator"
_993_318.BackgroundTransparency = 1
_993_318.Size = UDim2.new(0, 420, 0, 22)
_993_318.AnchorPoint = Vector2.new(0.5, 0)
_993_318.Position = UDim2.new(0.5, 0, 0.5, 36)
_993_318.Font = Enum.Font.Code
_993_318.TextSize = 14
_993_318.TextColor3 = Color3.fromRGB(245, 245, 245)
_993_318.TextStrokeTransparency = 0
_993_318.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_993_318.Text = ""
_993_318.Visible = false
_993_318.Parent = _9376x428

local _0011Il00 = Instance.new("TextLabel")
_0011Il00.Name = "AmmoIndicator"
_0011Il00.BackgroundTransparency = 1
_0011Il00.Size = UDim2.new(0, 420, 0, 18)
_0011Il00.AnchorPoint = Vector2.new(0.5, 0)
_0011Il00.Position = UDim2.new(0.5, 0, 0.5, 52)
_0011Il00.Font = Enum.Font.Code
_0011Il00.TextSize = 11
_0011Il00.TextColor3 = Color3.fromRGB(245, 245, 245)
_0011Il00.TextStrokeTransparency = 0
_0011Il00.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_0011Il00.Text = ""
_0011Il00.Visible = false
_0011Il00.Parent = _9376x428

local function get_local_ammo_status()
    local v43335, _0xfd96, L505_10 = nil, nil, false
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local _0x9ec3, _0lO010OIIO = pcall(require, _3213x326.Controllers.FighterController)
        if not _0x9ec3 or not _0lO010OIIO then return end
        local _0x3584 = _0lO010OIIO.LocalFighter
        if not _0x3584 then return end
        local _549_282 = _0x3584.EquippedItem
        if not _549_282 then return end

        local function get_property(key)
            local L704_40, L619_44 = pcall(function()
                if _549_282.Get then return _549_282:Get(key) end
                return _549_282[key] or (_549_282.Data and _549_282.Data[key]) or (_549_282.Info and _549_282.Info[key])
            end)
            if L704_40 then return L619_44 end
            return nil
        end

        v43335 = get_property("CurrentAmmo") or get_property("Ammo") or get_property("Bullets") or get_property("MagazineAmmo")
        _0xfd96 = get_property("ReserveAmmo") or get_property("StoredAmmo") or get_property("Reserve") or get_property("TotalAmmo") or get_property("MaxAmmo") or get_property("MaxBullets")
        local L616_26 = get_property("Reloading") or get_property("IsReloading") or get_property("Reload")
        L505_10 = L616_26 == true

        if _549_282.Info and type(_549_282.Info) == "table" then
            if v43335 == nil then v43335 = _549_282.Info.CurrentAmmo or _549_282.Info.Ammo end
            if _0xfd96 == nil then _0xfd96 = _549_282.Info.ReserveAmmo or _549_282.Info.StoredAmmo or _549_282.Info.MaxAmmo end
            if _549_282.Info.Reloading == true or _549_282.Info.IsReloading == true then
                L505_10 = true
            end
        end
    end)
    return v43335, _0xfd96, L505_10
end

RunService.RenderStepped:Connect(function()
    if _3323x151 and L555_61 then
        local _00IO01 = "idk"
        if a73b35c96 and a73b35c96.Parent then
            local _0xb7aa = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
            local __bdUacYjXOqr = Players:GetPlayerFromCharacter(_0xb7aa)
            if __bdUacYjXOqr then
                _00IO01 = __bdUacYjXOqr.DisplayName or __bdUacYjXOqr.Name
            elseif typeof(_0xb7aa) == "Instance" then
                _00IO01 = _0xb7aa.Name
            end
        end
        _993_318.Text = "ragebot : " .. tostring(_00IO01) .. "..."
        _993_318.Position = UDim2.new(0.5, 0, 0.5, 36)
        _993_318.Visible = true
    else
        _993_318.Visible = false
    end

    if a41b78c88 then
        local v43335, _0xfd96, L505_10 = get_local_ammo_status()
        local __UGHeELfMSX
        if L505_10 or (typeof(v43335) == "number" and v43335 <= 0 and (_0xfd96 == nil or (typeof(_0xfd96) == "number" and _0xfd96 >= 0))) then
            if L505_10 then
                __UGHeELfMSX = "reloading"
            elseif typeof(v43335) == "number" and typeof(_0xfd96) == "number" then
                __UGHeELfMSX = string.format("%d/%d", _0xfd96, v43335)
            else
                __UGHeELfMSX = "reloading"
            end
        end
        
        if not __UGHeELfMSX then
            if typeof(v43335) == "number" and typeof(_0xfd96) == "number" then
                __UGHeELfMSX = string.format("%d/%d", _0xfd96, v43335)
            elseif typeof(v43335) == "number" then
                __UGHeELfMSX = tostring(v43335)
            else
                __UGHeELfMSX = nil
            end
        end

        if L505_10 then
            __UGHeELfMSX = "reloading"
        end

        if __UGHeELfMSX then
            _0011Il00.Text = __UGHeELfMSX
            local v75310 = 52
            if _3323x151 and L555_61 then
                v75310 = 52
            end
            _0011Il00.Position = UDim2.new(0.5, 0, 0.5, v75310)
            _0011Il00.Visible = true
        else
            _0011Il00.Visible = false
        end
    else
        _0011Il00.Visible = false
    end
end)

-- ==========================================
-- Character 탭 (Emote)
-- ==========================================
local EmoteGroup = Tabs.Character:AddLeftGroupbox('Emote')

local EmoteEnabled = false
local emoteTrack = nil
local EMOTESPEED = 1

local EMOTES = {
    "rbxassetid://507771019",
    "rbxassetid://507776043",
    "rbxassetid://507777623",
    "rbxassetid://3698339488",
    "rbxassetid://92281817840531",
}

local function stopEmote()
    EmoteEnabled = false
    if emoteTrack then
        pcall(function() emoteTrack:Stop() end)
        emoteTrack = nil
    end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                t:Stop()
            end
        end)
    end
end

local function playEmote(char)
    if not EmoteEnabled then return end
    char = char or LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end

    for _, id in ipairs(EMOTES) do
        local ok, track = pcall(function()
            local a = Instance.new("Animation")
            a.AnimationId = id
            local t = animator:LoadAnimation(a)
            t.Priority = Enum.AnimationPriority.Action4
            t.Looped = true
            t:Play(0.1, 1, EMOTESPEED)
            return t
        end)
        if ok and track then
            emoteTrack = track
            track.Stopped:Connect(function()
                if EmoteEnabled then
                    task.defer(function() playEmote(char) end)
                end
            end)
            return
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if EmoteEnabled then
        task.delay(0.5, function()
            if EmoteEnabled then playEmote(char) end
        end)
    end
end)

EmoteGroup:AddToggle('EnableEmoteSpeed', {
    Text = 'Enable Fast Emote',
    Default = false,
    Tooltip = 'emote',
    Callback = function(Value)
        if Value then
            EmoteEnabled = true
            playEmote(LocalPlayer.Character)
        else
            stopEmote()
        end
    end
})

EmoteGroup:AddSlider('EmoteSpeedSlider', {
    Text = 'Emote',
    Default = 1,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        EMOTESPEED = Value
        if emoteTrack and EmoteEnabled then
            pcall(function() emoteTrack:AdjustSpeed(EMOTESPEED) end)
        end
    end
})

-- ==========================================
-- Misc 탭 (Device Spoof, Skin Changer & Hit Sound)
-- ==========================================
local Group = Tabs.Misc:AddLeftGroupbox('Device Spoofing')
local SetControlsRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls")

Group:AddDropdown('DeviceDropdown', {
    Values = { 'PC (Mouse & Keyboard)', 'Mobile (Touch)', 'Controller (Gamepad)', 'VR' },
    Default = 1,
    Text = 'Device Spoof',
    Callback = function(Value)
        local TargetDevice = "MouseKeyboard"
        if Value:find("PC") then TargetDevice = "MouseKeyboard"
        elseif Value:find("Mobile") then TargetDevice = "Touch"
        elseif Value:find("Controller") then TargetDevice = "Gamepad"
        elseif Value:find("VR") then TargetDevice = "VR" end

        SetControlsRemote:FireServer("MouseKeyboard")
        task.wait(0.1)
        SetControlsRemote:FireServer(TargetDevice)
    end
})

Group:AddButton({
    Text = 'Apply Selected Device',
    Func = function()
        if Options and Options.DeviceDropdown then
            Options.DeviceDropdown:OnChanged(Options.DeviceDropdown.Value)
        end
    end
})

local SkinBox = Tabs.Misc:AddRightGroupbox('Skin Changer')
SkinBox:AddButton('Unlock All', function()
    task.spawn(function()
        pcall(function()
            if getgenv().SkinChangerLoaded then 
                Library:Notify("The skin changer is already running!", 2)
                return 
            end

            Library:Notify("Loading Skin Changer...", 2)

            local playerScripts = LocalPlayer:WaitForChild("PlayerScripts")
            local controllers = playerScripts:WaitForChild("Controllers")

            local EnumLibrary, CosmeticLibrary, ItemLibrary, DataController
            pcall(function() EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10)) end)
            if EnumLibrary and EnumLibrary.WaitForEnumBuilder then pcall(function() EnumLibrary:WaitForEnumBuilder() end) end
            pcall(function() CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10)) end)
            pcall(function() ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10)) end)
            pcall(function() DataController = require(controllers:WaitForChild("PlayerDataController", 10)) end)

            if not (CosmeticLibrary and ItemLibrary and DataController) then return end

            getgenv().SkinChangerLoaded = true

            local equipped, favorites = {}, {}
            local constructingWeapon, viewingProfile = nil, nil
            local lastUsedWeapon = nil

            local remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local dataRemotes = remotes and remotes:WaitForChild("Data", 5)
            local equipRemote = dataRemotes and dataRemotes:WaitForChild("EquipCosmetic", 5)
            local favoriteRemote = dataRemotes and dataRemotes:WaitForChild("FavoriteCosmetic", 5)
            local replicationRemotes = remotes and remotes:WaitForChild("Replication", 5)
            local fighterRemotes = replicationRemotes and replicationRemotes:WaitForChild("Fighter", 5)
            local useItemRemote = fighterRemotes and fighterRemotes:WaitForChild("UseItem", 5)

            local function cloneCosmetic(name, cosmeticType, options)
                local base = CosmeticLibrary.Cosmetics[name]
                if not base then return nil end
                local data = {}
                for key, value in pairs(base) do data[key] = value end
                data.Name = name
                data.Type = data.Type or cosmeticType
                data.Seed = data.Seed or math.random(1, 1000000)
                if EnumLibrary then
                    local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
                    if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
                end
                if options then
                    if options.inverted ~= nil then data.Inverted = options.inverted end
                    if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
                end
                return data
            end

            CosmeticLibrary.OwnsCosmeticNormally = function() return true end
            CosmeticLibrary.OwnsCosmeticUniversally = function() return true end
            CosmeticLibrary.OwnsCosmeticForWeapon = function() return true end
            local originalOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
            CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
                if name and typeof(name) == "string" and name:find("MISSING_") then return originalOwnsCosmetic(self, inventory, name, weapon) end
                return true
            end

            local originalGet = DataController.Get
            DataController.Get = function(self, key)
                local data = originalGet(self, key)
                if key == "CosmeticInventory" then
                    local proxy = {}
                    if data then for k, v in pairs(data) do proxy[k] = v end end
                    return setmetatable(proxy, {__index = function() return true end})
                end
                if key == "FavoritedCosmetics" then
                    local result = data and table.clone(data) or {}
                    for weapon, favs in pairs(favorites) do
                        result[weapon] = result[weapon] or {}
                        for name, isFav in pairs(favs) do result[weapon][name] = isFav end
                    end
                    return result
                end
                return data
            end

            local originalGetWeaponData = DataController.GetWeaponData
            DataController.GetWeaponData = function(self, weaponName)
                local data = originalGetWeaponData(self, weaponName)
                if not data then return nil end
                local merged = {}
                for key, value in pairs(data) do merged[key] = value end
                merged.Name = weaponName
                if equipped[weaponName] then
                    for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do merged[cosmeticType] = cosmeticData end
                end
                return merged
            end

            local FighterController
            pcall(function() FighterController = require(controllers:WaitForChild("FighterController", 10)) end)

            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method ~= "FireServer" or checkcaller() then return oldNamecall(self, ...) end
                local args = {...}
                
                if useItemRemote and self == useItemRemote then
                    local objectID = args[1]
                    if FighterController then
                        pcall(function()
                            local fighter = FighterController:GetFighter(LocalPlayer)
                            if fighter and typeof(fighter) == "table" and fighter.Items then
                                for _, item in pairs(fighter.Items) do
                                    if type(item) == "table" and item.Get then
                                        if item:Get("ObjectID") == objectID then
                                            lastUsedWeapon = item.Name
                                            break
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end            
                
                if equipRemote and self == equipRemote then
                    local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}                
                    if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                        local inventory = DataController:Get("CosmeticInventory")
                        if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
                    end                
                    equipped[weaponName] = equipped[weaponName] or {}                
                    if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                        equipped[weaponName][cosmeticType] = nil
                        if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                    else
                        local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                        if cloned then equipped[weaponName][cosmeticType] = cloned end
                    end                
                    task.defer(function()
                        pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                    end)
                    return
                end            
                
                if favoriteRemote and self == favoriteRemote then
                    favorites[args[1]] = favorites[args[1]] or {}
                    favorites[args[1]][args[2]] = args[3] or nil
                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                    return
                end            
                return oldNamecall(self, ...)
            end)

            Library:Notify("Skin unlock complete!", 3)
        end)
    end)
end)

-- ==========================================
-- Hit Sound 로직 및 LinoriaLib 그룹박스 통합
-- ==========================================
local HitSoundConfig = {
    Enable = false,
    RemoveDefaultSound = false,
    Volume = 3,
    Pitch = 1,
    Selected = "rust",
    NotifyEnable = false,
    NotifyDuration = 3,
    NotifyMsg = "Hit {target} for {damage}",
}

local SoundLibrary = {
    ["windows xp"]                  = "rbxassetid://108009100115241",
    ["minecraft bow"]               = "rbxassetid://3442683707",
    ["neverlose"]                   = "rbxassetid://97643101798871",
    ["steve"]                       = "rbxassetid://132883456216684",
    ["among us"]                    = "rbxassetid://93866204681438",
    ["bonk"]                        = "rbxassetid://5766898159",
    ["rust"]                        = "rbxassetid://1255040462",
    ["fatality"]                    = "rbxassetid://6534947869",
    ["hitmarker"]                   = "rbxassetid://133749572213659",
    ["csgo"]                        = "rbxassetid://5764885315",
    ["minecraft success bow hit"]   = "rbxassetid://131197435969853",
    ["sparkle"]                     = "rbxassetid://110241936966089",
    ["rust hs"]                     = "rbxassetid://4764109000",
    ["windows 10 error"]            = "rbxassetid://5914602124",
    ["Mambo"]                       = "rbxassetid://119974879573475",
    ["no sound"]                    = "rbxassetid://139836625302855",
}

local SoundKeys = {}
for k in pairs(SoundLibrary) do
    SoundKeys[#SoundKeys + 1] = k
end
table.sort(SoundKeys)

local fighter_controller, client_viewmodel

pcall(function()
    fighter_controller = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
end)

pcall(function()
    client_viewmodel = require(
        LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel
    )
end)

if client_viewmodel and client_viewmodel.PlayHitmarkerSound then
    local _originalPlayHitmarker = client_viewmodel.PlayHitmarkerSound
    client_viewmodel.PlayHitmarkerSound = function(self, critical, pitch)
        if not HitSoundConfig.Enable then
            return _originalPlayHitmarker(self, critical, pitch)
        end

        if HitSoundConfig.Selected and SoundLibrary[HitSoundConfig.Selected] then
            local ok = pcall(function()
                self:_CreateHitmarkerSound(
                    SoundLibrary[HitSoundConfig.Selected],
                    HitSoundConfig.Volume,
                    HitSoundConfig.Pitch,
                    LocalPlayer.PlayerGui,
                    true,
                    1
                )
            end)
            if not ok then
                return _originalPlayHitmarker(self, critical, pitch)
            end
            if HitSoundConfig.RemoveDefaultSound then
                return
            end
        end

        return _originalPlayHitmarker(self, critical, pitch)
    end
end

if fighter_controller and fighter_controller.LocalFighter then
    local _localFighter = fighter_controller.LocalFighter
    if _localFighter.ReplicateFromServer then
        local _originalReplicate = _localFighter.ReplicateFromServer
        _localFighter.ReplicateFromServer = function(self, eventType, ...)
            if eventType == "DamageNumberEffect" and HitSoundConfig.NotifyEnable then
                local args     = { ... }
                local hit_root = args[1]
                local damage   = args[2]
                local headshot = args[3]

                if hit_root and damage then
                    local hitChar = hit_root.Parent
                    if hitChar and hitChar:FindFirstChildOfClass("Humanoid") then
                        local part = headshot and "Head" or "Body"
                        local msg  = HitSoundConfig.NotifyMsg
                        msg = msg:gsub("{target}", hitChar.Name)
                        msg = msg:gsub("{damage}", tostring(math.floor(damage + 0.5)))
                        msg = msg:gsub("{hitpart}", part)

                        print("[HitNotify] " .. msg)
                    end
                end
                return
            end

            return _originalReplicate(self, eventType, ...)
        end
    end
end

-- Misc 탭 내에 Hit Sound 그룹박스 추가
local HitSoundGroup = Tabs.Misc:AddRightGroupbox('Hit Sound')

HitSoundGroup:AddToggle('HitSoundEnable', {
    Text = 'Enable Hit Sound',
    Default = HitSoundConfig.Enable,
    Callback = function(Value)
        HitSoundConfig.Enable = Value
    end
})

HitSoundGroup:AddDropdown('HitSoundDropdown', {
    Values = SoundKeys,
    Default = 7, -- 'rust' 기본 선택
    Text = 'Sound Effect',
    Callback = function(Value)
        HitSoundConfig.Selected = Value
    end
})

HitSoundGroup:AddSlider('HitSoundVolume', {
    Text = 'Volume',
    Default = HitSoundConfig.Volume,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        HitSoundConfig.Volume = Value
    end
})

HitSoundGroup:AddSlider('HitSoundPitch', {
    Text = 'Pitch',
    Default = HitSoundConfig.Pitch,
    Min = 0.5,
    Max = 2,
    Rounding = 2,
    Callback = function(Value)
        HitSoundConfig.Pitch = Value
    end
})

HitSoundGroup:AddToggle('HitSoundRemoveDefault', {
    Text = 'Remove Default Sound',
    Default = HitSoundConfig.RemoveDefaultSound,
    Callback = function(Value)
        HitSoundConfig.RemoveDefaultSound = Value
    end
})

HitSoundGroup:AddToggle('HitSoundNotifyEnable', {
    Text = 'Hit Notify',
    Default = HitSoundConfig.NotifyEnable,
    Callback = function(Value)
        HitSoundConfig.NotifyEnable = Value
    end
})

HitSoundGroup:AddSlider('HitSoundNotifyDuration', {
    Text = 'Notify Duration',
    Default = HitSoundConfig.NotifyDuration,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        HitSoundConfig.NotifyDuration = Value
    end
})

-- ==========================================
-- ESP Render Loop
-- ==========================================
local espData = {}

local function addESP(p)
    if p == LocalPlayer then return end
    task.spawn(function()
        local box, hpBg, hpBar, hpText, nameText, distText, tracer
        pcall(function()
            if Drawing then
                box = Drawing.new("Square"); box.Visible = false; box.Color = Color3.new(1, 1, 1); box.Thickness = 1; box.Filled = false
                hpBg = Drawing.new("Square"); hpBg.Visible = false; hpBg.Color = Color3.new(0, 0, 0); hpBg.Thickness = 1; hpBg.Filled = true
                hpBar = Drawing.new("Square"); hpBar.Visible = false; hpBar.Color = Color3.new(0, 1, 0); hpBar.Thickness = 1; hpBar.Filled = true
                hpText = Drawing.new("Text"); hpText.Visible = false; hpText.Center = true; hpText.Outline = true; hpText.Color = Color3.new(1, 1, 1); hpText.Size = 13
                nameText = Drawing.new("Text"); nameText.Visible = false; nameText.Center = true; nameText.Outline = true; nameText.Color = Color3.new(1, 1, 1); nameText.Size = 13
                distText = Drawing.new("Text"); distText.Visible = false; distText.Center = true; distText.Outline = true; distText.Color = Color3.new(1, 1, 1); distText.Size = 13
                tracer = Drawing.new("Line"); tracer.Visible = false; tracer.Color = Color3.new(1, 1, 1); tracer.Thickness = 1
            end
        end)
        
        if box then
            espData[p] = { Box = box, HpBg = hpBg, HealthBar = hpBar, HealthText = hpText, NameText = nameText, DistText = distText, Tracer = tracer, Skeleton = {} }
            local bones = {{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}}
            for _, b in pairs(bones) do 
                pcall(function() 
                    if Drawing then table.insert(espData[p].Skeleton, {b[1], b[2], Drawing.new("Line")}) end
                end) 
            end
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        pcall(function()
            espData[p].Box:Remove(); espData[p].HpBg:Remove(); espData[p].HealthBar:Remove(); espData[p].HealthText:Remove()
            espData[p].NameText:Remove(); espData[p].DistText:Remove(); espData[p].Tracer:Remove()
            for _, s in pairs(espData[p].Skeleton) do s[3]:Remove() end
        end)
        espData[p] = nil
    end
end)

local function IsToggleActive(toggleName)
    return Toggles and Toggles[toggleName] and Toggles[toggleName].Value == true
end

local function UpdateChams(c, enable)
    if not c then return end
    local highlight = c:FindFirstChild("AntiHubChams")
    if enable then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "AntiHubChams"
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.Parent = c
        end
    else
        if highlight then highlight:Destroy() end
    end
end

RunService.RenderStepped:Connect(function()
    local CurrentCam = Workspace.CurrentCamera
    if not CurrentCam then return end

    local isChamsActive = IsToggleActive("ESPChams")

    for p, d in pairs(espData) do
        local isAlive = false
        local c = p.Character
        local root, head, rootPos, boxSize, boxPos, top, bottom, height, width
        
        if c and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
            root = c:FindFirstChild("HumanoidRootPart")
            head = c:FindFirstChild("Head") or c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
            
            if root and head then
                local rPos, onScreen = CurrentCam:WorldToViewportPoint(root.Position)
                if onScreen then
                    isAlive = true
                    rootPos = rPos
                    local headPos = CurrentCam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = CurrentCam:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                    height = math.abs(headPos.Y - legPos.Y)
                    width = height * 0.6 
                    boxSize = Vector2.new(width, height)
                    boxPos = Vector2.new(rootPos.X - width / 2, headPos.Y)
                    top = {Y = headPos.Y}
                    bottom = {Y = legPos.Y}
                end
            end
        end
        
        if isAlive then
            if IsToggleActive("ESPBox") then d.Box.Size = boxSize; d.Box.Position = boxPos; d.Box.Visible = true else d.Box.Visible = false end
            
            if IsToggleActive("ESPHealth") then
                local maxH = math.max(c.Humanoid.MaxHealth, 1)
                local h = math.clamp(c.Humanoid.Health / maxH, 0, 1)
                d.HpBg.Size = Vector2.new(4, height); d.HpBg.Position = Vector2.new(boxPos.X - 6, boxPos.Y); d.HpBg.Visible = true
                local barHeight = height * h
                d.HealthBar.Size = Vector2.new(2, barHeight); d.HealthBar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (height - barHeight))
                d.HealthBar.Color = Color3.fromHSV(h * 0.33, 1, 1); d.HealthBar.Visible = true
                d.HealthText.Text = tostring(math.floor(c.Humanoid.Health)); d.HealthText.Position = Vector2.new(boxPos.X - 25, boxPos.Y + (height - barHeight) - 6); d.HealthText.Visible = true
            else 
                d.HpBg.Visible = false; d.HealthBar.Visible = false; d.HealthText.Visible = false 
            end
            
            if IsToggleActive("ESPName") then d.NameText.Text = p.Name; d.NameText.Position = Vector2.new(boxPos.X + width/2, top.Y - 15); d.NameText.Visible = true else d.NameText.Visible = false end
            if IsToggleActive("ESPDistance") then local dist = math.floor((CurrentCam.CFrame.Position - root.Position).Magnitude); d.DistText.Text = tostring(dist) .. "m"; d.DistText.Position = Vector2.new(boxPos.X + width/2, bottom.Y + 2); d.DistText.Visible = true else d.DistText.Visible = false end
            if IsToggleActive("ESPTracer") then d.Tracer.From = Vector2.new(CurrentCam.ViewportSize.X / 2, CurrentCam.ViewportSize.Y); d.Tracer.To = Vector2.new(rootPos.X, bottom.Y); d.Tracer.Visible = true else d.Tracer.Visible = false end
            
            if IsToggleActive("ESPSkeleton") then
                for _, s in pairs(d.Skeleton) do
                    local p1, p2 = c:FindFirstChild(s[1]), c:FindFirstChild(s[2])
                    if p1 and p2 then
                        local v1, o1 = CurrentCam:WorldToViewportPoint(p1.Position)
                        local v2, o2 = CurrentCam:WorldToViewportPoint(p2.Position)
                        if o1 and o2 then s[3].From = Vector2.new(v1.X, v1.Y); s[3].To = Vector2.new(v2.X, v2.Y); s[3].Visible = true; s[3].Color = Color3.new(1, 1, 1) else s[3].Visible = false end
                    else s[3].Visible = false end
                end
            else 
                for _, s in pairs(d.Skeleton) do s[3].Visible = false end 
            end
            
            UpdateChams(c, isChamsActive)
        else
            d.Box.Visible = false; d.HpBg.Visible = false; d.HealthBar.Visible = false; d.HealthText.Visible = false
            d.NameText.Visible = false; d.DistText.Visible = false; d.Tracer.Visible = false
            for _, s in pairs(d.Skeleton) do s[3].Visible = false end
            
            if c then UpdateChams(c, false) end
        end
    end
end)

-- ==========================================
-- Setting 탭 (Config Manager & Theme Manager)
-- ==========================================
local SettingsMenu = Tabs.Setting:AddLeftGroupbox('Menu Settings')

SettingsMenu:AddButton('Unload UI', function()
    pcall(function() Visuals.unload() end)
    Library:Unload()
end)

SettingsMenu:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu Keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('YumuEnchantment')
SaveManager:SetFolder('YumuEnchantment/configs')

SaveManager:BuildConfigSection(Tabs.Setting)
ThemeManager:ApplyToTab(Tabs.Setting)

SaveManager:LoadAutoloadConfig()

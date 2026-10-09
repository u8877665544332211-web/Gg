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
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
-- Combat 탭 UI 구성
-- ==========================================
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

-- ==========================================
-- Visuals 탭 (ESP, Skybox & Indicators)
-- ==========================================
local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP')

ESPGroup:AddToggle('ESPBox', { Text = 'Box ESP', Default = false })
ESPGroup:AddToggle('ESPName', { Text = 'Name ESP', Default = false })
ESPGroup:AddToggle('ESPHealth', { Text = 'Health ESP', Default = false })
ESPGroup:AddToggle('ESPDistance', { Text = 'Distance ESP', Default = false })
ESPGroup:AddToggle('ESPTracer', { Text = 'Tracer ESP', Default = false })
ESPGroup:AddToggle('ESPSkeleton', { Text = 'Skeleton ESP', Default = false })
ESPGroup:AddToggle('ESPChams', { Text = 'Chams ESP', Default = false })

-- Indicators 전용 변수
local _3323x151 = false -- Ragebot Indicator 활성화 여부
local a41b78c88 = false -- Ammo Indicator 활성화 여부

local IndicatorGroup = Tabs.Visuals:AddLeftGroupbox('Indicators')

IndicatorGroup:AddToggle('IndicatorRagebot', {
    Text = 'Ragebot Indicator',
    Default = false,
    Callback = function(Value)
        _3323x151 = Value
    end
})

IndicatorGroup:AddToggle('IndicatorAmmo', {
    Text = 'Ammo Indicator',
    Default = false,
    Callback = function(Value)
        a41b78c88 = Value
    end
})

local SkyboxGroup = Tabs.Visuals:AddRightGroupbox('Skybox')

local function GetSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
    end
    return sky
end

local Presets = {
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
        if Value == 'Disable' then RemoveSky() elseif Presets[Value] then ApplySky(Presets[Value]) end
    end
})

-- ==========================================
-- Screen GUI Indicators 생성 (화면 중앙 표시)
-- ==========================================
local _9376x428 = Instance.new("ScreenGui")
_9376x428.Name = "HalmuIndicators"
_9376x428.ResetOnSpawn = false
_9376x428.IgnoreGuiInset = true
_9376x428.DisplayOrder = 999
_9376x428.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    _9376x428.Parent = game:GetService("CoreGui")
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

-- RenderStepped 루프 내 Indicator Text 갱신
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
-- Misc 탭 (Device Spoof & Skin Changer)
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
-- ESP Render Loop (Chams 최적화 적용)
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
    local Camera = Workspace.CurrentCamera
    if not Camera then return end

    local isChamsActive = IsToggleActive("ESPChams")

    for p, d in pairs(espData) do
        local isAlive = false
        local c = p.Character
        local root, head, rootPos, boxSize, boxPos, top, bottom, height, width
        
        if c and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
            root = c:FindFirstChild("HumanoidRootPart")
            head = c:FindFirstChild("Head") or c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
            
            if root and head then
                local rPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    isAlive = true
                    rootPos = rPos
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
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
            if IsToggleActive("ESPDistance") then local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude); d.DistText.Text = tostring(dist) .. "m"; d.DistText.Position = Vector2.new(boxPos.X + width/2, bottom.Y + 2); d.DistText.Visible = true else d.DistText.Visible = false end
            if IsToggleActive("ESPTracer") then d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); d.Tracer.To = Vector2.new(rootPos.X, bottom.Y); d.Tracer.Visible = true else d.Tracer.Visible = false end
            
            if IsToggleActive("ESPSkeleton") then
                for _, s in pairs(d.Skeleton) do
                    local p1, p2 = c:FindFirstChild(s[1]), c:FindFirstChild(s[2])
                    if p1 and p2 then
                        local v1, o1 = Camera:WorldToViewportPoint(p1.Position)
                        local v2, o2 = Camera:WorldToViewportPoint(p2.Position)
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

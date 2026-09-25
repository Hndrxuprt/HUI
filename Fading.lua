local AddonName, Addon = ...

local fadeBars = {
    "MultiActionBar",
	"StanceBar",
	"PetActionBar",
	"PossessActionBar",
	"BonusBar",
	"VehicleBar",
	"TempShapeshiftBar",
	"OverrideBar",
    "MainMenuBar",
    "MainActionBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "BagsBar",
    "MicroMenu",
    "EssentialCooldownViewer",
    "UtilityCooldownViewer",
    "BuffIconCooldownViewer",
    "BuffBarCooldownViewer",
    "ExtraActionBarFrame",
    "ZoneAbilityFrame",
}
local fadeConfigAliases = {
    ExtraActionBarFrame = "ExtraZoneAbility",
    ZoneAbilityFrame = "ExtraZoneAbility",
}
local function GetFadeConfigName(frameName)
    return fadeConfigAliases[frameName] or frameName
end
local function SetFadeBars()
    local profileTable = Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()
    if profileTable and profileTable["CDMCustomFrames"] then
        for index, data in ipairs(profileTable["CDMCustomFrames"]) do
            if data then
                local frameName = data.label
                if not tContains(fadeBars, frameName) then
                    table.insert(fadeBars, frameName)
                end
            end
        end
    end
end

Addon.externalFadeBars = {}
-----------------------------------------
-- forked from ElvUI
-----------------------------------------

local Fader = CreateFrame('Frame')
Fader.Frames = {}
Fader.interval = 0.025

local function Fading(_, elapsed)
    Fader.timer = (Fader.timer or 0) + elapsed
    if Fader.timer > Fader.interval then
        Fader.timer = 0

        for frame, data in next, Fader.Frames do
            if frame:IsVisible() then
                data.fadeTimer = (data.fadeTimer or 0) + (elapsed + Fader.interval)
            else
                data.fadeTimer = (data.fadeTimer or 0) + 1
            end

            if data.fadeTimer < data.duration then
                if data.mode == "IN" then
                    frame:SetAlpha((data.fadeTimer / data.duration) * data.diffAlpha + data.fromAlpha)
                else
                    frame:SetAlpha(((data.duration - data.fadeTimer) / data.duration) * data.diffAlpha + data.toAlpha)
                end
            else
                frame:SetAlpha(data.toAlpha)
                if frame and Fader.Frames[frame] then
                    if frame.fade then
                        frame.fade.fadeTimer = nil
                    end
                    Fader.Frames[frame] = nil
                end
            end
        end
        if not next(Fader.Frames) then
            Fader:SetScript("OnUpdate", nil)
        end
    end
end

local function FrameFade(frame)
    local fade = frame.fade
    frame:SetAlpha(fade.fromAlpha)

    if not Fader.Frames[frame] then
        Fader.Frames[frame] = fade
        Fader:SetScript("OnUpdate", Fading)
    else
        Fader.Frames[frame] = fade
    end
end

local function FrameFadeIn(frame, duration, fromAlpha, toAlpha)
    if frame.fade then
        frame.fade.fadeTimer = nil
    else
        frame.fade = {}
    end

    frame.fade.mode = "IN"
    frame.fade.duration = duration
    frame.fade.fromAlpha = fromAlpha
    frame.fade.toAlpha = toAlpha
    frame.fade.diffAlpha = toAlpha - fromAlpha

    FrameFade(frame)
end

local function FrameFadeOut(frame, duration, fromAlpha, toAlpha)
    if frame.fade then
        frame.fade.fadeTimer = nil
    else
        frame.fade = {}
    end

    frame.fade.mode = "OUT"
    frame.fade.duration = duration
    frame.fade.fromAlpha = fromAlpha
    frame.fade.toAlpha = toAlpha
    frame.fade.diffAlpha = fromAlpha - toAlpha

    FrameFade(frame)
end

local function IsFrameFocused(frame)
    if not frame or not frame.IsMouseOver then return false end
    if frame:IsMouseOver() then
        return true
    end

    local focusedFrames = GetMouseFoci()
    if not focusedFrames then return false end
    
    for _, focusedFrame in ipairs(focusedFrames) do
        if focusedFrame == frame then
            return true
        end
        local parent = focusedFrame:GetParent()
        while parent do
            if parent == frame then
                return true
            end
            parent = parent:GetParent()
        end
    end
    return false
end

local function ShouldFadeIn(frame, isHover)

    if not frame then return false end

    local configName = GetFadeConfigName(frame:GetName())

    return (Addon:GetValue("FadeInOnCombat", nil, configName) and UnitAffectingCombat("player"))
    or (Addon:GetValue("FadeInOnTarget", nil, configName) and UnitExists("target"))
    or (Addon:GetValue("FadeInOnCasting", nil, configName) and UnitCastingInfo("player"))
    or (Addon:GetValue("FadeInOnHover", nil, configName) and isHover)
    or GetCursorInfo()
end

local function ShouldFadeInExternal(frame, options, isHover)

    if not frame or not options then return false end

    return ( options.inCombat and UnitAffectingCombat("player") )
    or ( options.onTarget and UnitExists("target") )
    or ( options.onCasting and UnitCastingInfo("player") )
    or ( options.onHover and isHover )
end

local function HoverHookExternal(frame, isHover)
    if not frame then return end

    local frameName = frame:GetName()

    if frame.fade and frameName then
        Addon:ExternalBarsFadeAnim(frame, Addon.externalFadeBars[frameName], isHover)
        return
    else
        frame = frame:GetParent()
        frameName = frame:GetName()
        if frame.fade and frameName then
            Addon:ExternalBarsFadeAnim(frame, Addon.externalFadeBars[frameName], isHover)
            return
        end
    end
end

function Addon:SetFrameAlpha(frame, toAlpha)
    local frameName = frame:GetName()
    if not toAlpha then
        local configName = GetFadeConfigName(frameName)
        if Addon.externalFadeBars[frameName] then
            toAlpha = Addon.externalFadeBars[frameName].alpha
        elseif Addon:GetValue("FadeBars", nil, configName) then
            toAlpha = Addon:GetValue("FadeBarsAlpha", nil, configName)
        else
            toAlpha = 1
        end
    end

    local currentAlpha = frame:GetAlpha()
    
    --if toAlpha == currentAlpha then return end

    if toAlpha > currentAlpha then
        FrameFadeIn(frame, 0.25, currentAlpha, toAlpha)
    else
        FrameFadeOut(frame, 0.25, currentAlpha, toAlpha)
    end    
end

function Addon:Fade(frame, isHover)
    local frameName = frame:GetName()
    if not tContains(fadeBars, frameName) then return end
    if not Addon:GetValue("FadeBars", nil, GetFadeConfigName(frameName)) then
        if frame:GetAlpha() < 1 then
            Addon:SetFrameAlpha(frame, 1)
        end
        return
    end

    if ShouldFadeIn(frame, isHover) then
        
        Addon:SetFrameAlpha(frame, 1)
    else
        
        Addon:SetFrameAlpha(frame)
    end
end

function Addon:BarsFadeAnim(frame)
    --if not Addon:GetValue("FadeBars") then return end
    if not frame then
        SetFadeBars()
        for _, barName in ipairs(fadeBars) do
            frame = _G[barName]
            if frame then
                if Addon:GetValue("FadeBars", nil, GetFadeConfigName(barName)) then
                    if ShouldFadeIn(frame)  then
                        Addon:SetFrameAlpha(frame, 1)
                    else
                        Addon:SetFrameAlpha(frame)
                    end
                elseif frame:GetAlpha() < 1 then
                    Addon:SetFrameAlpha(frame, 1)
                end
            end
        end
        Addon:ExternalBarsFadeAnim()
    else
        local frameName = frame:GetName()
        if not tContains(fadeBars, frameName) then return end
        if Addon:GetValue("FadeBars", nil, GetFadeConfigName(frameName)) then
            if ShouldFadeIn(frame) then
                Addon:SetFrameAlpha(frame, 1)
            else
                Addon:SetFrameAlpha(frame)
            end
        elseif frame:GetAlpha() < 1 then
            Addon:SetFrameAlpha(frame, 1)
        end
    end
end

function Addon:ExternalBarsFadeAnim(frame, options, isHover)
    if not frame then
        for barName, options in pairs(Addon.externalFadeBars) do
            frame = _G[barName]
            if frame and ShouldFadeInExternal(frame, options, isHover) then
                Addon:SetFrameAlpha(frame, 1)
            else
                Addon:SetFrameAlpha(frame, options.alpha)
            end
        end
    else
        if ShouldFadeInExternal(frame, options, isHover) then
            Addon:SetFrameAlpha(frame, 1)
        else
            Addon:SetFrameAlpha(frame, options.alpha)
        end
    end
end

--/run HUI_RegisterFrameForFading("Minimap", { alpha = 0 })
--/run HUI_RegisterFrameForFading("PlayerFrame", { alpha = 0 })
--/run HUI_RegisterFrameForFading("EssentialCooldownViewer", { alpha = 0, inCombat = true, onTarget = true, onCasting = true, onHover = true })

function HUI_RegisterFrameForFading(frame, options)
    if not frame then return end
    local frameName
    if type(frame) == "string" then
        frameName = frame
        frame = _G[frame]
    else
        frameName = frame:GetName()
    end

    if not frameName then return end

    options = options or {}

    Addon.externalFadeBars[frameName] = {
            alpha = options.alpha or 1,
            onDragonRiding = options.onDragonRiding or false,
            inCombat = options.inCombat or false,
            onTarget = options.onTarget or false,
            onCasting = options.onCasting or false,
            onHover = options.onHover or true,
        }

    if frame and Addon.externalFadeBars[frameName].onHover then
        Addon:HookExternalFrameForHover(frame)
    end
    Addon:ExternalBarsFadeAnim(frame, Addon.externalFadeBars[frameName])
end

function Addon:HookExternalFrameForHover(frame)
    if not frame or frame.__hookedFade then return end

    if frame.OnEnter and frame.OnLeave then
        frame:HookScript("OnEnter", function(self)
            HoverHookExternal(self, true)
        end)
        frame:HookScript("OnLeave", function(self)
            HoverHookExternal(self, false)
        end)
    else
        local numChildren = frame:GetNumChildren()
        local children = {frame:GetChildren()}
        if numChildren then
            for i=1, numChildren do
                local child = children[i]
                if child and (child.OnEnter and child.OnLeave) and not child.__hookedFade then
                    frame:HookScript("OnEnter", function(self)
                        HoverHookExternal(self, true)
                    end)
                    frame:HookScript("OnLeave", function(self)
                        HoverHookExternal(self, false)
                    end)
                    child.__hookedFade = true
                end
            end
        end
    end
    frame.__hookedFade = true
end


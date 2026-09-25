local Addon = _G.HUI

local T = Addon.Templates

local ACTION_BARS = {
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
}

local ActionBarButtonPrefixes = {
    "ActionButton",
    "MultiBarBottomLeftButton",
    "MultiBarBottomRightButton",
    "MultiBarLeftButton",
    "MultiBarRightButton",
    "MultiBar5Button",
    "MultiBar6Button",
    "MultiBar7Button",
}

local CachedButtons = {}
local pendingPassThrough = {}

local function CacheButtons()
    for _, prefix in ipairs(ActionBarButtonPrefixes) do
        local bar = {}
        for i = 1, NUM_ACTIONBAR_BUTTONS do
            bar[i] = _G[prefix..i]
        end
        CachedButtons[prefix] = bar
    end
end

function Addon:ProcessButtons(actionBar, updateFunc, value)
    local function UpdateSingleButton(button, isStanceBar, value)
        if button and button:IsVisible() then
            updateFunc(button, isStanceBar, value)
        end
    end

    if actionBar then
        local bar = CachedButtons[actionBar == "MainActionBar" and "ActionButton" or actionBar.."Button"]
        if bar then
            for i = 1, NUM_ACTIONBAR_BUTTONS do
                UpdateSingleButton(bar[i], false, value)
            end
        end
    else
        for _, prefix in ipairs(ActionBarButtonPrefixes) do
            local bar = CachedButtons[prefix]
            for i = 1, NUM_ACTIONBAR_BUTTONS do
                UpdateSingleButton(bar[i], false, value)
            end
        end
    end

    for i = 1, NUM_SPECIAL_BUTTONS do
        UpdateSingleButton(PetActionBar.actionButtons[i], true, value)
        UpdateSingleButton(StanceBar.actionButtons[i], true, value)
    end
end

function Addon:PreviewButtons(previewType, value)
    local selectedBar = HUI_BarsListMixin:GetFrameLebel()
    local actionBar = selectedBar ~= "GlobalSettings" and selectedBar or nil
    
    local updateFunc
    if previewType == "LoopGlow" then
        updateFunc = function(button, isStanceBar, value)
            Addon:UpdateFlipbook(button, value)
        end
    elseif previewType == "NormalTexture" then
        updateFunc = function(button, isStanceBar, value)
            Addon:UpdateNormalTexture(button, isStanceBar, value)
        end
    elseif previewType == "BackdropTexture" then
        updateFunc = function(button, isStanceBar, value)
            Addon:UpdateBackdropTexture(button, isStanceBar, value)
        end
    elseif previewType == "PushedTexture" then
        updateFunc = function(button, isStanceBar, value)
            button.NormalTexture:Hide()
            button.PushedTexture:Show()
            Addon:UpdatePushedTexture(button, isStanceBar, value)
        end
    elseif previewType == "HighlightTexture" then
        updateFunc = function(button, isStanceBar, value)
            Addon:UpdateHighlightTexture(button, isStanceBar, value)
            button:LockHighlight()
        end
    elseif previewType == "CheckedTexture" then
        updateFunc = function(button, isStanceBar, value)
            button.CheckedTexture:Show()
            Addon:UpdateCheckedTexture(button, isStanceBar, value)
        end
    elseif previewType == "IconMaskTexture" then
        updateFunc = function(button, isStanceBar, value)
            Addon:UpdateIconMask(button, isStanceBar, value)
        end
    elseif previewType == "Cooldown" then
        updateFunc = function(button, isStanceBar, value)
            Addon:UpdateCooldown(button, isStanceBar, value)
        end
    elseif previewType == "Font" then
        updateFunc = function(button, isStanceBar, value)
            Addon:UpdateButtonFont(button, isStanceBar, value)
        end
    end
    
    if not updateFunc then return end
    
    Addon:ProcessButtons(actionBar, updateFunc, value)
end

function Addon:UpdateButtonsPassThrough(button)
    if not button then return end

    if InCombatLockdown() then
        pendingPassThrough[button] = true
        return
    end

    local _, configName = Addon:GetConfig(button)
    local passThrough = Addon:GetValue("RightClickPassThrough", nil, configName)

    local frame = button
    while frame and frame ~= UIParent do
        if passThrough then
            frame:SetPassThroughButtons("RightButton")
        else
            frame:SetPassThroughButtons()
        end
        frame = frame:GetParent()
    end
end

local function UpdateAllButtonVisuals(button, isStanceBar)
    Addon:UpdateButtonsPassThrough(button)
    Addon:UpdateNormalTexture(button, isStanceBar)
    Addon:UpdateBackdropTexture(button, isStanceBar)
    Addon:UpdatePushedTexture(button, isStanceBar)
    Addon:UpdateHighlightTexture(button, isStanceBar)
    Addon:UpdateCheckedTexture(button, isStanceBar)
    if button.IconMask then
        Addon:UpdateIconMask(button, isStanceBar)
    end
    if button.icon then
        Addon:UpdateIcon(button, isStanceBar)
    end
    if button.cooldown then
        Addon:UpdateCooldown(button, isStanceBar)
    end
    Addon:UpdateButtonFont(button, isStanceBar)
end

function Addon:RefreshButtons(button)
    local selectedBar = HUI_BarsListMixin:GetFrameLebel()
    local actionBar = selectedBar ~= "GlobalSettings" and selectedBar or nil
    
    if button then
        UpdateAllButtonVisuals(button)
    else
        Addon:ProcessButtons(actionBar, UpdateAllButtonVisuals)
    end
end

function Addon:RefreshAllButtons()
    local function UpdateAll(button, isStanceBar)
        UpdateAllButtonVisuals(button, isStanceBar)
        Addon:RefreshCooldown(button, isStanceBar)
    end
    Addon:ProcessButtons(nil, UpdateAll)
    Addon:UpdateExtraActionButton()
    Addon:UpdateZoneAbilityButtons()
end

function Addon:UpdateActionBarGrid(frame, padding, equal)

    if not frame then return end

    local frameName = frame:GetName()

    if frameName == "StanceBar" then return end

    padding = padding or Addon:GetValue("CurrentBarPadding", nil, frameName)

    if equal then
        local scale = frame.shownButtonContainers[1]:GetScale()
        if scale < 1 then
            padding = padding / scale
        end
    end

    padding = Addon.PP.Scale(padding)

    --[[ if Addon:GetValue("UseButtonsNumber", nil, frameName) then
        if not InCombatLockdown() then
            frame.numButtonsShowable = Addon:GetValue("ButtonsNumber", nil, frameName)
            frame:UpdateShownButtons()
        end
    end ]]

    frame.addButtonsToTop = Addon:GetValue("CurrentBarGrow", nil, frameName) == 1


    --frame.numRows = Addon:GetValue("UseRowsNumber", nil, frameName) and Addon:GetValue("RowsNumber", nil, frameName) or frame.numRows
    
    -- Stride is the number of buttons per row (or column if we are vertical)
    -- Set stride so that if we can have the same number of icons per row we do

    local stride = math.ceil(#frame.shownButtonContainers / frame.numRows)

    --local stride = Addon:GetValue("UseColumnsNumber", nil, frameName) and Addon:GetValue("ColumnsNumber", nil, frameName) or math.ceil(#frame.shownButtonContainers / frame.numRows)

    if Addon:GetValue("GridCentered", nil, frameName) then
        Addon:ApplyActionBarsCenteredGrid(frame, frame.shownButtonContainers, stride, padding)
        frame:Layout()
        -- This function tainted when Ellesmere enabled
        --frame:UpdateSpellFlyoutDirection()
        frame:CacheGridSettings()
        frame:MarkClean()
        return
    end

    -- Multipliers determine the direction the bar grows for grid layouts 
    -- Positive means right/up
    -- Negative means left/down
    local xMultiplier = frame.addButtonsToRight and 1 or -1;
    local yMultiplier = frame.addButtonsToTop and 1 or -1;

    local anchorPoint;
	if frame.addButtonsToLeft then 
		  anchorPoint = "LEFT"
    elseif frame.addButtonsToTop then
        if frame.addButtonsToRight then
            anchorPoint = "BOTTOMLEFT"
        else
            anchorPoint = "BOTTOMRIGHT"
        end
    else
        if frame.addButtonsToRight then
            anchorPoint = "TOPLEFT"
        else
            anchorPoint = "TOPRIGHT"
        end
    end
    
    -- Create the grid layout according to whether we are horizontal or vertical
    local layout
    if frame.isHorizontal then
        layout = GridLayoutUtil.CreateStandardGridLayout(stride, padding, padding, xMultiplier, yMultiplier)
    else
        layout = GridLayoutUtil.CreateVerticalGridLayout(stride, padding, padding, xMultiplier, yMultiplier)
    end

    GridLayoutUtil.ApplyGridLayout(frame.shownButtonContainers, AnchorUtil.CreateAnchor(anchorPoint, frame, anchorPoint), layout)
    frame:Layout()
    -- This function tainted when Ellesmere enabled
    --frame:UpdateSpellFlyoutDirection()
    frame:CacheGridSettings()
end

function Addon:HookActionBarGrid()
    for _, frameName in ipairs(ACTION_BARS) do
        local frame = _G[frameName]
        if frame then
            if frame.UpdateGridLayout and not frame.__gridHooked then
                hooksecurefunc(frame, "UpdateGridLayout", function(self) Addon:UpdateActionBarGrid(self) end)
                frame.__gridHooked = true
            end
            Addon:UpdateActionBarGrid(frame)
        end
    end
end

function Addon:UpdateAllActionBarGrid()
    for _, frameName in ipairs(ACTION_BARS) do
        local frame = _G[frameName]
        if frame then
            Addon:UpdateActionBarGrid(frame)
        end
    end
end

function Addon:UpdateAssistFlipbook(region)

    local button = region:GetParent()

    local config, configName = Addon:GetConfig(button)

    local loopAnim = T.LoopGlow[Addon:GetValue("CurrentAssistType", nil, configName)] or nil

    local flipAnim = Addon:GetFlipBook(region.Anim:GetAnimations())

    if loopAnim.atlas then
        region:SetAtlas(loopAnim.atlas)  
    elseif loopAnim.texture then
        region:SetTexture(loopAnim.texture)
    end

   if loopAnim then
        region:ClearAllPoints()
        region:SetSize(region:GetSize())
        region:SetPoint("CENTER", region:GetParent(), "CENTER", -1.5, 1)
        flipAnim:SetFlipBookRows(loopAnim.rows or 6)
        flipAnim:SetFlipBookColumns(loopAnim.columns or 5)
        flipAnim:SetFlipBookFrames(loopAnim.frames or 30)
        flipAnim:SetDuration(loopAnim.duration or 1.0)
        flipAnim:SetFlipBookFrameWidth(loopAnim.frameW or 0.0)
        flipAnim:SetFlipBookFrameHeight(loopAnim.frameH or 0.0)
        region:SetScale(loopAnim.scale or 1)
    end
    --region.ProcLoopFlipbook:SetTexCoords(333, 400, 0.412598, 0.575195, 0.393555, 0.78418, false, false)
    region:SetDesaturated(Addon:GetValue("DesaturateAssist", nil, configName))
    if Addon:GetValue("UseAssistGlowColor", nil, configName) then
        region:SetVertexColor(Addon:GetRGB("AssistGlowColor", nil, configName))
    else
        region:SetVertexColor(1.0, 1.0, 1.0)
    end
	region.Anim:Stop()
    region.Anim:Play()
end

local BUTTON_REF_SIZES = {
    ["EssentialCooldownViewer"] = 50,
    ["UtilityCooldownViewer"] = 30,
    ["BuffIconCooldownViewer"] = 40,
    ["StanceBar"] = 30,
    ["PetActionBar"] = 38,
}

local function GetButtonScaleForBar(barName)
    local actionButtonSize = 42
    local refButtonSize = BUTTON_REF_SIZES[barName] or actionButtonSize
    local scaleMult = refButtonSize / actionButtonSize
    return scaleMult
end

local function FixKeyBindText(text)
    if not text or text == "" then return end
    
    local function escapePattern(text)
        return text:gsub("([%-%.%+%*%?%^%$%(%)%[%]%%])", "%%%1")
    end
    if text and text ~= _G.RANGE_INDICATOR then
        text = gsub(text, "(s%-)", "s")
		text = gsub(text, "(a%-)", "a")
		text = gsub(text, "(а%-)", "a")
		text = gsub(text, "(c%-)", "c")
		text = gsub(text, "Capslock", "CL")
		text = gsub(text, KEY_LEFT, "LT")
		text = gsub(text, KEY_RIGHT, "RT")
		text = gsub(text, KEY_UP, "UP")
		text = gsub(text, KEY_DOWN, "DN")
		text = gsub(text, KEY_BUTTON4, "M4")
		text = gsub(text, KEY_BUTTON5, "M5")
		text = gsub(text, KEY_BUTTON3, "MMB")
        text = gsub(text, KEY_MOUSEWHEELUP, "MU")
	    text = gsub(text, KEY_MOUSEWHEELDOWN, "MD")
		text = gsub(text, KEY_NUMLOCK, "NL")
		text = gsub(text, KEY_PAGEUP, "PU")
		text = gsub(text, KEY_PAGEDOWN, "PD")
		text = gsub(text, KEY_SPACE, "SpB")
		text = gsub(text, KEY_INSERT, "Ins")
		text = gsub(text, KEY_HOME, "Hm")
		text = gsub(text, KEY_DELETE, "Del")
		text = gsub(text, KEY_DELETE, "Del")
		text = gsub(text, escapePattern(KEY_NUMPAD0), "N0")
		text = gsub(text, escapePattern(KEY_NUMPAD1), "N1")
		text = gsub(text, escapePattern(KEY_NUMPAD2), "N2")
		text = gsub(text, escapePattern(KEY_NUMPAD3), "N3")
		text = gsub(text, escapePattern(KEY_NUMPAD4), "N4")
		text = gsub(text, escapePattern(KEY_NUMPAD5), "N5")
		text = gsub(text, escapePattern(KEY_NUMPAD6), "N6")
		text = gsub(text, escapePattern(KEY_NUMPAD7), "N7")
		text = gsub(text, escapePattern(KEY_NUMPAD8), "N8")
		text = gsub(text, escapePattern(KEY_NUMPAD9), "N9")
		text = gsub(text, escapePattern(KEY_NUMPADDIVIDE), "N/")
		text = gsub(text, escapePattern(KEY_NUMPADMULTIPLY), "N*")
		text = gsub(text, escapePattern(KEY_NUMPADMINUS), "N-")
		text = gsub(text, escapePattern(KEY_NUMPADPLUS), "N+")
		text = gsub(text, escapePattern(KEY_NUMPADDECIMAL), "N.")
    end
    return text or ""
end

function Addon:UpdateButtonFont(button, isStanceBar)
    local hotKey = button.TextOverlayContainer and button.TextOverlayContainer.HotKey or button.HotKey
    local count = button.TextOverlayContainer and button.TextOverlayContainer.Count or button.Count
    if not hotKey or not count then return end

    local config, configName = Addon:GetConfig(button)
    
    local mult = math.min(button:GetParent():GetScale(), 1.0)

    local anchor = button.TextOverlayContainer or button

    local hotKeyText = hotKey:GetText()
    if hotKeyText and hotKeyText ~= _G.RANGE_INDICATOR then
        hotKeyText = FixKeyBindText(hotKeyText)
        hotKey:SetText(hotKeyText)
        local hotkeyFont = Addon:GetValue("CurrentHotkeyFont", nil, configName)
        if hotkeyFont == "Default" then
            hotKey:SetFontObject(NumberFontNormalSmallGray)
        else
            local font = LibStub("LibSharedMedia-3.0"):Fetch("font", hotkeyFont)
            C_Timer.After(0, function()
                hotKey:SetFont(
                    font,
                    (Addon:GetValue("UseHotkeyFontSize", nil, configName) and Addon:GetValue("HotkeyFontSize", nil, configName) or 11),
                    Addon:GetValue("CurrentHotkeyOutline", nil, configName) > 1 and Addon.FontOutlines[Addon:GetValue("CurrentHotkeyOutline", nil, configName)] or ""
                )
            end)
        end
        hotKey:ClearAllPoints()
        local fontSize = Addon:GetValue("UseHotkeyFontSize", nil, configName) and Addon:GetValue("HotkeyFontSize", nil, configName) or 11
        hotKey:SetFontHeight(fontSize)
        hotKey:SetWidth(0)
        hotKey:SetPoint(
            Addon.AttachPoints[Addon:GetValue("CurrentHotkeyPoint", nil, configName)],
            anchor,
            Addon.AttachPoints[Addon:GetValue("CurrentHotkeyRelativePoint", nil, configName)],
            Addon:GetValue("UseHotkeyOffset", nil, configName) and Addon:GetValue("HotkeyOffsetX", nil, configName) or -5,
            Addon:GetValue("UseHotkeyOffset", nil, configName) and Addon:GetValue("HotkeyOffsetY", nil, configName) or -5
        )
        if Addon:GetValue("UseHotkeyShadow", nil, configName) then
            hotKey:SetShadowColor(Addon:GetRGBA("HotkeyShadow", nil, configName))
        else
            hotKey:SetShadowColor(0,0,0,0)
        end
        if Addon:GetValue("UseHotkeyShadowOffset", nil, configName) then
            hotKey:SetShadowOffset(Addon:GetValue("HotkeyShadowOffsetX", nil, configName)*mult, Addon:GetValue("HotkeyShadowOffsetY", nil, configName)*mult)
        else
            hotKey:SetShadowOffset(0,0)
        end
        hotKey:SetVertexColor(Addon:GetColor("HotkeyColor", "UseHotkeyColor", nil, configName))
    end

    local stacksFont = Addon:GetValue("CurrentStacksFont", nil, configName)
    if stacksFont == "Default" then
        count:SetFontObject(NumberFontNormal)
    else
        count:SetFont(
            LibStub("LibSharedMedia-3.0"):Fetch("font", stacksFont),
            (Addon:GetValue("UseStacksFontSize", nil, configName) and Addon:GetValue("StacksFontSize", nil, configName) or 16),
            Addon:GetValue("CurrentStacksOutline", nil, configName) > 1 and Addon.FontOutlines[Addon:GetValue("CurrentStacksOutline", nil, configName)] or ""
        )
    end
    count:ClearAllPoints()
    local fontSize = Addon:GetValue("UseStacksFontSize", nil, configName) and Addon:GetValue("StacksFontSize", nil, configName) or 16
    count:SetFontHeight(fontSize)
    count:SetPoint(
        Addon.AttachPoints[Addon:GetValue("CurrentStacksPoint", nil, configName)],
        anchor,
        Addon.AttachPoints[Addon:GetValue("CurrentStacksRelativePoint", nil, configName)],
        Addon:GetValue("UseStacksOffset", nil, configName) and Addon:GetValue("StacksOffsetX", nil, configName) or -5,
        Addon:GetValue("UseStacksOffset", nil, configName) and Addon:GetValue("StacksOffsetY", nil, configName) or 5
    )
    if Addon:GetValue("UseStacksShadow", nil, configName) then
        count:SetShadowColor(Addon:GetRGBA("StacksShadow", nil, configName))
    else
        count:SetShadowColor(0,0,0,0)
    end
    if Addon:GetValue("UseStacksShadowOffset", nil, configName) then
        count:SetShadowOffset(Addon:GetValue("StacksShadowOffsetX", nil, configName)*mult, Addon:GetValue("StacksShadowOffsetY", nil, configName)*mult)
    else
        count:SetShadowOffset(0,0)
    end
    count:SetVertexColor(Addon:GetColor("StacksColor", "UseStacksColor", nil, configName))

    if mult < 1 then
        hotKey:SetScale((Addon:GetValue("FontHotKey", nil, configName) and not isStanceBar) and Addon:GetValue("FontHotKeyScale", nil, configName) or 1.0)
        count:SetScale((Addon:GetValue("FontStacks", nil, configName) and not isStanceBar) and Addon:GetValue("FontStacksScale", nil, configName) or 1.0)
        if button.Name then
            button.Name:SetScale(Addon:GetValue("FontName", nil, configName) and Addon:GetValue("FontNameScale", nil, configName) or 1.0)
        end
    end
end

local function Hook_UpdateHotkeys(self, actionButtonType)
    local button = self:GetParent()
    local hotKey = self.HotKey
	local text = hotKey:GetText()
    hotKey:SetText(FixKeyBindText(text))
    Addon:UpdateButtonFont(self)    
end

function Addon:UpdateExtraZoneArt(previewValue)
    local index = previewValue or Addon:GetValue("ExtraZoneAbilityArt", nil, "ExtraZoneAbility")
    local entry = T.ExtraZoneAbilityArts and T.ExtraZoneAbilityArts[index]
    if not entry then return end

    local styles = {}
    if ExtraActionButton1 and ExtraActionButton1.style then
        table.insert(styles, ExtraActionButton1.style)
    end
    if ZoneAbilityFrame and ZoneAbilityFrame.SpellButtonContainer then
        for button in ZoneAbilityFrame.SpellButtonContainer:EnumerateActive() do
            if button.__huiArt then
                table.insert(styles, button.__huiArt)
            end
        end
    end

    for _, style in ipairs(styles) do
        if not style.__huiOrigLayer then
            style.__huiOrigLayer, style.__huiOrigSubLevel = style:GetDrawLayer()
        end
    end

    if entry.hide then
        for _, style in ipairs(styles) do
            if style.__huiOrigLayer then
                style:SetDrawLayer(style.__huiOrigLayer, style.__huiOrigSubLevel)
            end
            style:ClearAllPoints()
            style:SetPoint("CENTER", style:GetParent(), "CENTER", 0, 0)
            style:Hide()
        end
        if ZoneAbilityFrame and ZoneAbilityFrame.Style then
            ZoneAbilityFrame.Style:Hide()
        end
    elseif entry.default then
        for _, style in ipairs(styles) do
            if style.__huiOrigLayer then
                style:SetDrawLayer(style.__huiOrigLayer, style.__huiOrigSubLevel)
            end
            style:ClearAllPoints()
            style:SetPoint("CENTER", style:GetParent(), "CENTER", 0, 0)
        end
    else
        for _, style in ipairs(styles) do
            if entry.belowIcon then
                style:SetDrawLayer("BACKGROUND", -7)
            elseif style.__huiOrigLayer then
                style:SetDrawLayer(style.__huiOrigLayer, style.__huiOrigSubLevel)
            end
            style:ClearAllPoints()
            style:SetPoint("CENTER", style:GetParent(), "CENTER", entry.offsetX or 0, entry.offsetY or 0)
            style:Show()
            pcall(function()
                style:SetAtlas(entry.atlas, true)
                if entry.size then
                    style:SetSize(entry.size[1], entry.size[2])
                end
            end)
        end
        if ZoneAbilityFrame and ZoneAbilityFrame.Style then
            ZoneAbilityFrame.Style:Hide()
        end
    end
end

function Addon:UpdateExtraActionButton()
    if not Addon:GetValue("ExtraZoneAbilityEnable", nil, "ExtraZoneAbility") then return end

    local button = ExtraActionButton1
    if not button then return end

    button.parentName = "ExtraZoneAbility"

    if button.PushedTexture then
        Addon:UpdatePushedTexture(button, false)
    end
    if button.HighlightTexture then
        Addon:UpdateHighlightTexture(button, false)
    end
    if not button.NormalTexture then
        button.NormalTexture = button:CreateTexture(nil, "OVERLAY")
    end
    Addon:UpdateNormalTexture(button, false)
    if button.IconMask then
        Addon:UpdateIconMask(button, false)
    end
    if button.icon then
        Addon:UpdateIcon(button, false)
    end
    if button.cooldown then
        Addon:UpdateCooldown(button, false)
        Addon:RefreshCooldown(button, false)
    end
    Addon:UpdateButtonFont(button, false)
    Addon:UpdateExtraZoneArt()
    if not button.__hookedExtraZoneFade and ExtraActionBarFrame then
        button:HookScript("OnEnter", function() Addon:Fade(ExtraActionBarFrame, true) end)
        button:HookScript("OnLeave", function() Addon:Fade(ExtraActionBarFrame, false) end)
        button.__hookedExtraZoneFade = true
    end
    if button.UpdateHotkeys and not button.__hookedUpdateHotkeys then
        hooksecurefunc(button, "UpdateHotkeys", Hook_UpdateHotkeys)
        button.__hookedUpdateHotkeys = true
    end
end

function Addon:UpdateZoneAbilityButtons()
    if not Addon:GetValue("ExtraZoneAbilityEnable", nil, "ExtraZoneAbility") then return end

    local frame = ZoneAbilityFrame
    if not frame or not frame.SpellButtonContainer then return end

    for button in frame.SpellButtonContainer:EnumerateActive() do
        button.parentName = "ExtraZoneAbility"
        if not button.__huiZoneAbility then
            button.icon = button.Icon
            button.cooldown = button.Cooldown
            button.chargeCooldown = button.ChargeCooldown
            button.HighlightTexture = button:GetHighlightTexture()
            button.IconMask = button:CreateMaskTexture()
            button.Icon:AddMaskTexture(button.IconMask)
            button:HookScript("OnEnter", function() Addon:Fade(frame, true) end)
            button:HookScript("OnLeave", function() Addon:Fade(frame, false) end)
            button.__huiZoneAbility = true
        end
        if not button.NormalTexture then
            button.NormalTexture = button:CreateTexture(nil, "OVERLAY")
        end
        if not button.__huiArt then
            button.__huiArt = button:CreateTexture(nil, "OVERLAY", nil, 1)
            button.__huiArt.__huiOrigLayer = "OVERLAY"
            button.__huiArt.__huiOrigSubLevel = 1
        end

        Addon:UpdateNormalTexture(button, false)
        Addon:UpdateHighlightTexture(button, false)
        Addon:UpdateIconMask(button, false)
        Addon:UpdateIcon(button, false)
        Addon:UpdateCooldown(button, false)
        Addon:RefreshCooldown(button, false)
    end

    Addon:UpdateExtraZoneArt()
end

local function RefreshDesaturated(icon, desaturated)
    local button = icon:GetParent()
    icon:SetDesaturated(desaturated)
end
function Addon:RefreshHotkeyColor(button)
    if not button.TextOverlayContainer or not button.TextOverlayContainer.HotKey then return end

    local config, configName = Addon:GetConfig(button)

    button.TextOverlayContainer.HotKey:SetVertexColor(Addon:GetColor("HotkeyColor", "UseHotkeyColor", nil, configName))
end
function Addon:RefreshIconColor(button)

    local config, configName = Addon:GetConfig(button)

    local icon = button.icon
    local action = button.action
    if not action then return end

    local type, spellID = GetActionInfo(action)
    local desaturated = false

    local isUsable, notEnoughMana = IsUsableAction(action)
    button.needsRangeCheck = spellID and C_Spell.SpellHasRange(spellID)
    button.spellOutOfRange = button.needsRangeCheck and C_Spell.IsSpellInRange(spellID) == false
    if button.__isOnActualCooldown and Addon:GetValue("UseCDColor", nil, configName) then
        icon:SetVertexColor(Addon:GetRGBA("CDColor", nil, configName))
        desaturated = Addon:GetValue("CDColorDesaturate", nil, configName)
    elseif (button.spellOutOfRange and Addon:GetValue("UseOORColor", nil, configName)) then
        desaturated = Addon:GetValue("OORDesaturate", nil, configName)
        icon:SetVertexColor(Addon:GetRGBA("OORColor", nil, configName))       
    elseif isUsable then
        desaturated = false
        icon:SetVertexColor(1.0, 1.0, 1.0)
    elseif (notEnoughMana and Addon:GetValue("UseOOMColor", nil, configName)) then
        desaturated = Addon:GetValue("OOMDesaturate", nil, configName)
        icon:SetVertexColor(Addon:GetRGBA("OOMColor", nil, configName))
    elseif Addon:GetValue("UseNoUseColor", nil, configName) then
        desaturated = Addon:GetValue("NoUseDesaturate", nil, configName)
        icon:SetVertexColor(Addon:GetRGBA("NoUseColor", nil, configName))
    end
    if not button.spellOutOfRange then
        Addon:RefreshHotkeyColor(button)
    end

    RefreshDesaturated(icon, desaturated)
end

local function HoverHook(button, isHover)
    local frame = button.bar
    if not frame then
        frame = button:GetParent()
    end
    
    if frame.fade then
        Addon:Fade(frame, isHover)
    end
end

local function Hook_Update(self)
    Addon:RefreshIconColor(self)
    --Addon:RefreshHotkeyColor(self)
end
local function Hook_UpdateUsable(self, action, usable, noMana)
    Addon:RefreshIconColor(self)
end

function Addon:UpdateNormalTexture(button, isStanceBar, previewValue)
    local config, configName = Addon:GetConfig(button, true)
    local normalAtlas
    if previewValue then
        normalAtlas = T.NormalTextures[previewValue]
    else
        normalAtlas = T.NormalTextures[Addon:GetValue("CurrentNormalTexture", nil, configName)] or nil
    end

    if button.NormalTexture then
        if normalAtlas then
            Addon:SetTexture(button.NormalTexture, normalAtlas.texture)
            if normalAtlas.point then
                button.NormalTexture:ClearAllPoints()
                button.NormalTexture:SetPoint(normalAtlas.point, button, normalAtlas.point)
            end
            if normalAtlas.padding then
                button.NormalTexture:SetPointsOffset(normalAtlas.padding[1], normalAtlas.padding[2])
            end
            if normalAtlas.size then
                button.NormalTexture:SetSize(normalAtlas.size[1], normalAtlas.size[2])
            end
            if normalAtlas.coords then
                button.NormalTexture:SetTexCoord(normalAtlas.coords[1], normalAtlas.coords[2], normalAtlas.coords[3], normalAtlas.coords[4])
            end
            button.NormalTexture:SetDrawLayer("OVERLAY")
            button.NormalTexture:SetScale(isStanceBar and 0.69 or 1.0)
        end
        button.NormalTexture:SetDesaturated(Addon:GetValue("DesaturateNormal", nil, configName))
        button.NormalTexture:SetVertexColor(Addon:GetColor("NormalTextureColor", "UseNormalTextureColor", nil, configName))
    end
end
function Addon:UpdateBackdropTexture(button, isStanceBar, previewValue)
    local config, configName = Addon:GetConfig(button)
    local backdropAtlas
    if previewValue then
        backdropAtlas = T.BackdropTextures[previewValue]
    else
        backdropAtlas = T.BackdropTextures[Addon:GetValue("CurrentBackdropTexture", nil, configName)] or nil
    end

    if button.SlotBackground then
        if backdropAtlas then
            if backdropAtlas.atlas then
                button.SlotBackground:SetAtlas(backdropAtlas.atlas)
            end
            if backdropAtlas.texture then
                button.SlotBackground:SetTexture(backdropAtlas.texture)
            end
            if backdropAtlas.point then
                button.SlotBackground:ClearAllPoints()
                button.SlotBackground:SetPoint(backdropAtlas.point, button, backdropAtlas.point)
            end
            if backdropAtlas.padding then
                button.SlotBackground:SetPointsOffset(backdropAtlas.padding[1], backdropAtlas.padding[2])
            end
            if backdropAtlas.size then
                button.SlotBackground:SetSize(backdropAtlas.size[1], backdropAtlas.size[2])
            end
            if backdropAtlas.coords then
                button.SlotBackground:SetTexCoord(backdropAtlas.coords[1], backdropAtlas.coords[2], backdropAtlas.coords[3], backdropAtlas.coords[4])
            end
            button.SlotBackground:SetScale(isStanceBar and 0.69 or 1.0)
        end
        button.SlotBackground:SetDesaturated(Addon:GetValue("DesaturateBackdrop", nil, configName))
        button.SlotBackground:SetVertexColor(Addon:GetColor("BackdropColor", "UseBackdropColor", nil, configName))
    end
end
function Addon:UpdatePushedTexture(button, isStanceBar, previewValue)
    local config, configName = Addon:GetConfig(button)
    local pushedAtlas
    if previewValue then
        pushedAtlas = T.PushedTextures[previewValue]
    else
        pushedAtlas = T.PushedTextures[Addon:GetValue("CurrentPushedTexture", nil, configName)] or nil
    end

    if button.PushedTexture then
        if pushedAtlas then
            if pushedAtlas.atlas then
                button:SetPushedAtlas(pushedAtlas.atlas)
            elseif pushedAtlas.texture then
                button.PushedTexture:SetTexture(pushedAtlas.texture)
            end
            if pushedAtlas.point then
                button.PushedTexture:ClearAllPoints()
                button.PushedTexture:SetPoint(pushedAtlas.point, button, pushedAtlas.point)
            end
            if pushedAtlas.size then
                button.PushedTexture:SetSize(pushedAtlas.size[1], pushedAtlas.size[2])
            end
            if pushedAtlas.coords then
                button.PushedTexture:SetTexCoord(pushedAtlas.coords[1], pushedAtlas.coords[2], pushedAtlas.coords[3], pushedAtlas.coords[4])
            end
            button.PushedTexture:SetDrawLayer("OVERLAY")
            button.PushedTexture:SetScale(isStanceBar and 0.69 or 1.0)
        end

        button.PushedTexture:SetDesaturated(Addon:GetValue("DesaturatePushed", nil, configName))
        button.PushedTexture:SetVertexColor(Addon:GetColor("PushedColor", "UsePushedColor", nil, configName))
    end
end
function Addon:UpdateHighlightTexture(button, isStanceBar, previewValue)
    local config, configName = Addon:GetConfig(button)
    local highlightAtlas
    if previewValue then
        highlightAtlas = T.HighlightTextures[previewValue]
    else
        highlightAtlas = T.HighlightTextures[Addon:GetValue("CurrentHighlightTexture", nil, configName)] or nil
    end

    if highlightAtlas and highlightAtlas.hide then
        button.HighlightTexture:Hide()
    else
        if highlightAtlas and Addon:GetValue("CurrentHighlightTexture", nil, configName) > 1 then
            if highlightAtlas.atlas then
                button.HighlightTexture:SetAtlas(highlightAtlas.atlas)
            elseif highlightAtlas.texture then
                button.HighlightTexture:SetTexture(highlightAtlas.texture)
            end
            if highlightAtlas.point then
                button.HighlightTexture:ClearAllPoints()
                button.HighlightTexture:SetPoint(highlightAtlas.point, button, highlightAtlas.point)
            end
            if highlightAtlas.padding then
                button.HighlightTexture:SetPointsOffset(highlightAtlas.padding[1], highlightAtlas.padding[2])
            end
            if highlightAtlas.size then
                button.HighlightTexture:SetSize(highlightAtlas.size[1], highlightAtlas.size[2])
            elseif button == ExtraActionButton1 or button.__huiZoneAbility then
                button.HighlightTexture:SetSize(46, 45)
            end
            if highlightAtlas.coords then
                button.HighlightTexture:SetTexCoord(highlightAtlas.coords[1], highlightAtlas.coords[2], highlightAtlas.coords[3], highlightAtlas.coords[4])
            end
            if highlightAtlas and Addon:GetValue("CurrentHighlightTexture", nil, configName) > 2 then
                button.HighlightTexture:SetScale(isStanceBar and 0.69 or 1.0)
            end
        end

        button.HighlightTexture:SetDesaturated(Addon:GetValue("DesaturateHighlight", nil, configName))
        button.HighlightTexture:SetVertexColor(Addon:GetColor("HighlightColor", "UseHighlightColor", nil, configName))
    end
end
function Addon:UpdateCheckedTexture(button, isStanceBar, previewValue)
    local config, configName = Addon:GetConfig(button)
    if button.CheckedTexture then
        local checkedAtlas
        if previewValue then
            checkedAtlas = T.HighlightTextures[previewValue]
        else
            checkedAtlas = T.HighlightTextures[Addon:GetValue("CurrentCheckedTexture", nil, configName)] or nil
        end

        if checkedAtlas then
            if Addon:GetValue("CurrentCheckedTexture", nil, configName) > 1 then
                if checkedAtlas.atlas then
                    button.CheckedTexture:SetAtlas(checkedAtlas.atlas)
                elseif checkedAtlas.texture then
                    button.CheckedTexture:SetTexture(checkedAtlas.texture)
                end
                if checkedAtlas.point then
                    button.CheckedTexture:ClearAllPoints()
                    button.CheckedTexture:SetPoint(checkedAtlas.point, button, checkedAtlas.point)
                end
                if checkedAtlas.size then
                    button.CheckedTexture:SetSize(checkedAtlas.size[1], checkedAtlas.size[2])
                end
                if checkedAtlas.coords then
                    button.CheckedTexture:SetTexCoord(checkedAtlas.coords[1], checkedAtlas.coords[2], checkedAtlas.coords[3], checkedAtlas.coords[4])
                end
                if Addon:GetValue("CurrentCheckedTexture", nil, configName) > 2 then
                    button.CheckedTexture:SetScale(isStanceBar and 0.69 or 1.0)
                end
            end

            button.CheckedTexture:SetDesaturated(Addon:GetValue("DesaturateChecked", nil, configName))
            button.CheckedTexture:SetVertexColor(Addon:GetColor("CheckedColor", "UseCheckedColor", nil, configName))
        end
    end
end
function Addon:UpdateIconMask(button, isStanceBar, previewValue)
    local config, configName = Addon:GetConfig(button)
    local iconMaskAtlas
    if previewValue then
        iconMaskAtlas = T.IconMaskTextures[previewValue]
    else
        iconMaskAtlas = T.IconMaskTextures[Addon:GetValue("CurrentIconMaskTexture", nil, configName)] or nil
    end

    if iconMaskAtlas then
        button.IconMask:SetHorizTile(false)
        button.IconMask:SetVertTile(false)

        Addon:SetTexture(button.IconMask, iconMaskAtlas.texture)

        if iconMaskAtlas.point then
            button.IconMask:ClearAllPoints()
            button.IconMask:SetPoint(iconMaskAtlas.point, button.icon, iconMaskAtlas.point)
        end
        if iconMaskAtlas.size then
            button.IconMask:SetSize(iconMaskAtlas.size[1], iconMaskAtlas.size[2])
        end
        if iconMaskAtlas.coords then
            button.IconMask:SetTexCoord(iconMaskAtlas.coords[1], iconMaskAtlas.coords[2], iconMaskAtlas.coords[3], iconMaskAtlas.coords[4])
        else
            button.IconMask:SetTexCoord(0, 1, 0, 1)
        end
        if isStanceBar then
            button.IconMask:SetScale(Addon:GetValue("UseIconMaskScale", nil, configName) and Addon:GetValue("IconMaskScale", nil, configName) * 0.69 or 1.0)
        else
            button.IconMask:SetScale(Addon:GetValue("UseIconMaskScale", nil, configName) and Addon:GetValue("IconMaskScale", nil, configName) or 1.0)
        end
    end
end
function Addon:UpdateIcon(button, isStanceBar, previewValue)
    local scale = previewValue or ((Addon:GetValue("UseIconScale", nil, configName) and Addon:GetValue("IconScale", nil, configName) or 1.0))
    button.icon:ClearAllPoints()
    button.icon:SetPoint("CENTER", button, "CENTER", -0.5, 0.5)
    if isStanceBar then
        button.icon:SetSize(31,31)
    else
        button.icon:SetSize(45,45)
    end
    button.icon:SetScale(scale)
end

function Addon:UpdateCooldown(button, isStanceBar, previewValue)

    local config, configName = Addon:GetConfig(button)

    if Addon:GetValue("UseSwipeSize", nil, configName) then
        button.cooldown:ClearAllPoints()
        local size = isStanceBar and Addon:GetValue("SwipeSize", nil, configName)*0.69 or Addon:GetValue("SwipeSize", nil, configName)
        button.cooldown:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
        button.cooldown:SetSize(size, size)

        if button.lossOfControlCooldown then
            button.lossOfControlCooldown:ClearAllPoints()
            local size = isStanceBar and Addon:GetValue("SwipeSize", nil, configName)*0.69 or Addon:GetValue("SwipeSize", nil, configName)
            button.lossOfControlCooldown:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
            button.lossOfControlCooldown:SetSize(size, size)
        end
    end

    local color = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    local bar = button.bar

    local fontSize = Addon:GetValue("UseCooldownFontSize", nil, configName) and Addon:GetValue("CooldownFontSize", nil, configName) or 17
    local _, fontName = Addon:GetFontObject(
        Addon:GetValue("CurrentCooldownFont", nil, configName),
        "OUTLINE, SLUG",
        color,
        fontSize,
        isStanceBar
    )

    local fontString = button.cooldown:GetCountdownFontString()
    local fontStringCharges = button.chargeCooldown:GetCountdownFontString()
    if Addon:GetValue("UseCooldownFontOffset", nil, configName) then
        local offsetX = Addon:GetValue("CooldownFontOffsetX", nil, configName)
        local offsetY = Addon:GetValue("CooldownFontOffsetY", nil, configName)

        fontString:SetPointsOffset(offsetX, offsetY)
        if fontStringCharges then
            fontStringCharges:SetPointsOffset(offsetX, offsetY)
        end
        
    else
        fontString:SetPointsOffset(0, 0)
        if fontStringCharges then
            fontStringCharges:SetPointsOffset(0, 0)
        end
    end

    button.cooldown:SetCountdownFont(fontName)
    if button.chargeCooldown then
        button.chargeCooldown:SetCountdownFont(fontName)
    end

    if button.cooldown:IsUsingParentLevel() then
        button.cooldown:SetUsingParentLevel(false)
    end
    if button.chargeCooldown and button.chargeCooldown:IsUsingParentLevel() then
        button.chargeCooldown:SetUsingParentLevel(false)
    end

    button.cooldown:SetFrameLevel(510)
    button.chargeCooldown:SetFrameLevel(510)

    if bar then
        local needUpdateFormatter = false
        if not bar.__cooldownColor then
            bar.__cooldownColor = { r=1, g=1, b=1, a=1 }
        end
        local formatType = Addon:GetValue("CooldownFormatType", nil, configName)
        if not bar.__formatType or (bar.__formatType ~= formatType) then
            needUpdateFormatter = true
            bar.__formatType = formatType
        end
        local color = { r=1, g=1, b=1, a=1 }
        if Addon:GetValue("UseCooldownFontColor", nil, configName) then
            color.r,color.g,color.b,color.a = Addon:GetRGBA("CooldownFontColor", nil, configName)
        end
        if not tCompare(color, bar.__cooldownColor) then
            needUpdateFormatter = true
            bar.__cooldownColor = color
        end
        local formatOptions = Addon:GetCooldownFormatOptions(configName)
        if not bar.__formatOptions or not tCompare(formatOptions, bar.__formatOptions) then
            needUpdateFormatter = true
            bar.__formatOptions = formatOptions
        end
        if Addon:GetValue("ColorizedCooldownFont", nil, configName) then
            if not bar.__numberFormatterColored or needUpdateFormatter then
                bar.__numberFormatterColored = Addon:GetNumberFormatter(bar.__cooldownColor,nil,nil, formatType, formatOptions)
            end
            button.cooldown:SetCountdownFormatter(bar.__numberFormatterColored)
            button.chargeCooldown:SetCountdownFormatter(bar.__numberFormatterColored)
        else
            if not bar.__numberFormater or needUpdateFormatter then
                bar.__numberFormater = Addon:GetNumberFormatter(bar.__cooldownColor, bar.__cooldownColor, bar.__cooldownColor, formatType, formatOptions)
            end
            button.cooldown:SetCountdownFormatter(bar.__numberFormater)
            button.chargeCooldown:SetCountdownFormatter(bar.__numberFormater)
        end
    end

end

local function Hook_ButtonOnUpdate(button)
    local action = button.action
    if not action or not C_ActionBar.HasAction(action) then return end

    local actionType, actionID = GetActionInfo(button.action)

    if not actionID then return end

    local cooldownFrame = button.cooldown

    if not cooldownFrame:IsVisible() then return end

    local fontString = cooldownFrame:GetCountdownFontString()

    if not fontString or not fontString:IsVisible() then return end

    local bar = button.bar

    if not bar then return end

end

local function Hook_UpdateButton(button, isStanceBar)
    if button == ExtraActionButton1 then return end

    Addon:UpdateButtonsPassThrough(button)

    local config, configName = Addon:GetConfig(button)

    if not button.__hookedFade then
        button:HookScript("OnEnter", function(self) 
            HoverHook(self, true)
        end)
        button:HookScript("OnLeave", function(self)
            HoverHook(self, false)
        end)
        button.__hookedFade = true
    end

    local frame = button:GetParent():GetName()
    if frame == "MicroMenu" or frame == "BagsBar" then
        return
    end

    if button.NormalTexture then
        Addon:UpdateNormalTexture(button, isStanceBar)
    end
    if button.SlotBackground then
        Addon:UpdateBackdropTexture(button, isStanceBar)
    end
    if button.PushedTexture then
        Addon:UpdatePushedTexture(button, isStanceBar)
    end
    if button.HighlightTexture then
        Addon:UpdateHighlightTexture(button, isStanceBar)
    end
    if button.CheckedTexture then
        Addon:UpdateCheckedTexture(button, isStanceBar)
    end

    if Addon:GetValue("UseButtonSize", nil, configName) then
        Addon.PP.Size(button, Addon:GetValue("ButtonSizeX", nil, configName), Addon:GetValue("ButtonSizeY", nil, configName))
    else
        Addon.PP.Size(button, 42, 42)
    end

    if button.IconMask then
        Addon:UpdateIconMask(button, isStanceBar)
    end

    if button.icon then
        Addon:UpdateIcon(button, isStanceBar)
    end

    if button.cooldown then
        Addon:UpdateCooldown(button, isStanceBar)
    end

    if button.Flash then
        button.Flash:ClearAllPoints()
        button.Flash:SetPoint("CENTER", button, "CENTER")
    end

    if button.Name then
        if Addon:GetValue("FontHideName", nil, configName) then
            button.Name:Hide()
        else
            button.Name:Show()
        end
    end
    if button.Border then
        button.Border:SetTexture("")
        button.Border:Hide()
    end
    Addon:UpdateButtonFont(button, isStanceBar)

    local eventFrame = ActionBarActionEventsFrame
    if eventFrame and Addon:GetValue("HideInterrupt", nil, configName) then
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    end
    if eventFrame and Addon:GetValue("HideCasting", nil, configName) then
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_START")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_STOP")
    end
    if eventFrame and Addon:GetValue("HideReticle", nil, configName) then
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_FAILED")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_RETICLE_CLEAR")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_RETICLE_TARGET")
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_SENT")
    end
    if button.Update and not button.__hookedUpdate then
        hooksecurefunc(button, "Update", Hook_Update)
        button.__hookedUpdate = true
    end
    if button.UpdateUsable and not button.__hookedUpdateUsable then
        hooksecurefunc(button, "UpdateUsable", Hook_UpdateUsable)
        button.__hookedUpdateUsable = true
    end
    if button.UpdateHotkeys and not button.__hookedUpdateHotkeys then
        hooksecurefunc(button, "UpdateHotkeys", Hook_UpdateHotkeys)
        button.__hookedUpdateHotkeys = true
    end

    --[[ if Addon:GetValue("ColorizedCooldownFont", nil, configName) and not button.__hookedOnUpdate then
        if button.OnUpdate then
            button:HookScript("OnUpdate", Hook_ButtonOnUpdate)
        end
        button.__hookedOnUpdate = true
    end ]]
end

local function Hook_RangeCheckButton(slot, inRange, checksRange)
    
    local buttons = ActionBarButtonRangeCheckFrame.actions[slot]
    if buttons then
        for _, button in pairs(buttons) do
            Addon:RefreshIconColor(button)
            --Addon:RefreshHotkeyColor(button)
        end
    end
end
function Addon:RefreshCooldown(button, isStanceBar, barName)
    local config, configName = Addon:GetConfig(button)
    local function RefreshEdgeTexture(cooldown, isStanceBar)
        cooldown:SetEdgeTexture(T.EdgeTextures[Addon:GetValue("CurrentEdgeTexture", nil, configName)].texture)
        if Addon:GetValue("UseEdgeSize", nil, configName) then
            local size = Addon:GetValue("EdgeSize", nil, configName)
            if size > 2 then
                Addon:SaveSetting("EdgeSize", 1, configName)
            end
            size = isStanceBar and size * 0.69 or size
            cooldown:SetEdgeScale(size)
        end
        if Addon:GetValue("UseEdgeColor", nil, configName) then
            cooldown:SetEdgeColor(Addon:GetRGBA("EdgeColor", nil, configName))
        else
            cooldown:SetEdgeColor(1, 1, 1, 1)
        end
    end
    local function RefreshSwipeTexture(button, cooldown, isStanceBar)
        cooldown:SetSwipeTexture(T.SwipeTextures[Addon:GetValue("CurrentSwipeTexture", nil, configName)].texture)
        if button.lossOfControlCooldown then
            button.lossOfControlCooldown:SetSwipeTexture(T.SwipeTextures[Addon:GetValue("CurrentSwipeTexture", nil, configName)].texture)
        end
        cooldown:SetSwipeColor(Addon:GetColor("CooldownColor", "UseCooldownColor", nil, configName))
        if button.lossOfControlCooldown then
            button.lossOfControlCooldown:SetSwipeColor(Addon:GetColor("CooldownColor", "UseCooldownColor", nil, configName))
        end
    end
    if button.cooldown then
        RefreshSwipeTexture(button, button.cooldown, isStanceBar)

        local drawEdge = Addon:GetValue("EdgeAlwaysShow", nil, configName)
        button.cooldown:SetDrawEdge(drawEdge)
        if drawEdge then
            RefreshEdgeTexture(button.cooldown, isStanceBar)
        end
    end
    if button.chargeCooldown then
        RefreshEdgeTexture(button.chargeCooldown, isStanceBar)
        RefreshSwipeTexture(button, button.chargeCooldown, isStanceBar)
        local showCountdonwNumbers = Addon:GetValue("ShowCountdownNumbersForCharges", nil, configName)
        button.chargeCooldown:SetHideCountdownNumbers(not showCountdonwNumbers)

        if button.action and showCountdonwNumbers then
            local _, spellID = GetActionInfo(button.action)
            if not issecretvalue(spellID) and spellID then
                local dur = C_Spell.GetSpellChargeDuration(spellID)
                if Addon.CombatResIDs[spellID] and dur then
                    button.cooldown:SetAlpha(dur:EvaluateRemainingDuration(Addon.invertAlphaCurve))
                else
                    button.cooldown:SetAlpha(1)
                end
            else
                button.cooldown:SetAlpha(1)
            end
        else
            button.cooldown:SetAlpha(1)
        end
    end
    Addon:RefreshIconColor(button)
end

local function Hook_OnCooldownDone(self)
    local button = self:GetParent()

    if not button.__cooldownSet then return end

    button.__cooldownSet = nil
    button.__isOnActualCooldown = false
    C_Timer.After(0, function()
        Addon:RefreshIconColor(button)
    end)
end

local function Hook_OnChargeDone(self)
    local button = self:GetParent()
    
    if not button.__cooldownSet then return end


    button.__isOnChargeCooldown = false

    C_Timer.After(0, function()
        Addon:RefreshIconColor(button)
    end)
end

local function Hook_Assist(self, actionButton, shown)
    local highlightFrame = actionButton.AssistedCombatHighlightFrame
    if highlightFrame and highlightFrame:IsVisible() then
        if shown then
            Addon:UpdateAssistFlipbook(highlightFrame.Flipbook)
        end
    end
end

-- todo rewrite this for better hook because it used only for stance bar
--[[ local function Hook_CooldownFrame_Set(self)
    if not self then return end
    if not self.GetParent then return end

    local button = self:GetParent()
    if not button then return end

    local bar = button.bar
    if not bar then
        bar = button:GetParent()
    end

    local barName = bar and bar:GetName() or ""
    
    if barName == "" or not tContains(ACTION_BARS, barName) then
        return
    end

    local isStanceBar = (barName == "PetActionBar" or barName == "StanceBar")

    if isStanceBar then
        Addon:RefreshCooldown(button, isStanceBar, barName)
    end
end ]]
local function Hook_StanceBarOnCooldownSet(self)
    local button = self:GetParent()
    local bar = button.bar
    if not bar then
        bar = button:GetParent()
    end
    local barName = bar and bar:GetName() or false
    if not barName then return end
    
    local isStanceBar = true

    Addon:RefreshCooldown(button, isStanceBar, barName)
end

local function Hook_ActionButton_ApplyCooldown(cooldownFrame, cdInfo, chargeCooldown, crgInfo, losCooldown, losInfo)
    if not cooldownFrame then return end
    if not cooldownFrame.GetParent then return end

    local button = cooldownFrame:GetParent()
    if not button then return end

    local bar = button.bar
    if not bar then
        bar = button:GetParent()
    end

    local barName = bar and bar:GetName() or ""
    
    if barName == "" or not tContains(ACTION_BARS, barName) then
        return
    end

    local isStanceBar = (barName == "PetActionBar" or barName == "StanceBar")

    local cooldownTimerString = cooldownFrame:GetCountdownFontString()

    C_Timer.After(0, function()
        --[[ if cooldownTimerString:IsVisible() then
            button.__isOnActualCooldown = true
            button.__cooldownSet = true
        else
            button.__isOnActualCooldown = false
        end ]]
        
        -- for future workaround when IsVisible() wouldn't work
        --[[ if cooldownTimerString:GetWidth() > 1.1 then
            button.__isOnActualCooldown = true
            button.__cooldownSet = true
        else
            button.__isOnActualCooldown = false
        end ]]
        Addon:RefreshCooldown(button, isStanceBar, barName)

    end)

    --[[ local actionType, actionID = GetActionInfo(button.action)
    if not actionID then return end

    button.__spellID = actionID

    chargeInfo = C_Spell.GetSpellCharges(actionID)
    cooldownInfo = C_Spell.GetSpellCooldown(actionID)
    button.__isOnGCD = cooldownInfo.isOnGCD

    if chargeInfo and chargeInfo.cooldownStartTime and chargeInfo.cooldownDuration then

        if cooldownInfo.isOnGCD == false then
            button.__isOnActualCooldown = true
            button.__cooldownSet = true
        else
            button.__isOnActualCooldown = false
        end

        if chargeCooldown:IsVisible() then
            button.isOnChargeCooldown = true
        end

    elseif cooldownInfo and cooldownInfo.startTime and cooldownInfo.duration then
        if not button.__isOnChargeCooldown then
            
            if cooldownInfo.isOnGCD == false then
                button.__isOnActualCooldown = true
                button.__cooldownSet = true
            end
        end
    end ]]

    if not cooldownFrame.__cooldownDoneHooked then
        if cooldownFrame.Clear then
            hooksecurefunc(cooldownFrame, "Clear", Hook_OnCooldownDone)
        end
        cooldownFrame:HookScript("OnCooldownDone", Hook_OnCooldownDone)
        cooldownFrame.__cooldownDoneHooked = true
    end
    if not chargeCooldown.__cooldownDoneHooked then
        if chargeCooldown.Clear then
            hooksecurefunc(chargeCooldown, "Clear", Hook_OnChargeDone)
        end
        chargeCooldown:SetScript("OnCooldownDone", Hook_OnChargeDone)
        
        chargeCooldown.__cooldownDoneHooked = true
    end
    --[[ if not losCooldown.__cooldownDoneHooked then
        --losCooldown:HookScript("OnCooldownDone", Hook_OnLosCooldownDone)
        losCooldown.__cooldownDoneHooked = true
    end ]]
    
end

local currentProfile

local function flyoutButtonOnEnter(self, isHover)
    local parent = self:GetParent()

    local frame = parent.flyoutButton.bar
    if not frame then
        return
    end
    
    if frame.fade then
        Addon:Fade(frame, isHover)
    end
end
local function OnSpellFlyoutSizeChanged(...)
    for i, button in ipairs(SpellFlyout:GetLayoutChildren()) do
        if (button.OnEnter and button.OnLeave) and not button.__OnEnterHooked then
            button:HookScript("OnEnter", function(self)
                flyoutButtonOnEnter(self, true)
            end)
            button:HookScript("OnLeave", function(self)
                flyoutButtonOnEnter(self, false)
            end)
            button.__OnEnterHooked = true
        end
    end
end

local function UpdateStanceAndPetBars()
    if StanceBar then
        for i, button in pairs(StanceBar.actionButtons) do
            Hook_UpdateButton(button, true)
            local cdFrame = button.cooldown or button.Cooldown
            if cdFrame and cdFrame.SetCooldown then
                hooksecurefunc(cdFrame, "SetCooldown", Hook_StanceBarOnCooldownSet)
            end
        end
    end
    if PetActionBar then
        for i, button in pairs(PetActionBar.actionButtons) do
            Hook_UpdateButton(button, true)
            local cdFrame = button.cooldown or button.Cooldown
            if cdFrame and cdFrame.SetCooldown then
                hooksecurefunc(cdFrame, "SetCooldown", Hook_StanceBarOnCooldownSet)
            end
        end
    end
    if MicroMenu then
        for i, button in ipairs(MicroMenu:GetLayoutChildren()) do
            Hook_UpdateButton(button, true)
        end
    end
    if BagsBar then
        for i, button in MainMenuBarBagManager:EnumerateBagButtons() do
            Hook_UpdateButton(button, true)
        end
    end
    if SpellFlyout and not SpellFlyout.__hooked then
        SpellFlyout:HookScript("OnSizeChanged", OnSpellFlyoutSizeChanged)
    end
    -- todo find better place
    if MainMenuBarVehicleLeaveButton then
        MainMenuBarVehicleLeaveButton:SetIgnoreParentAlpha(true)
    end
end

local function DisableTalkingHeadFrame()
    TalkingHeadFrame:Hide()
end

local function SetAprilDay()
    Addon.AprilDayEnabled = Addon:GetValue("AprilDayEnabled", nil, "GlobalSettings")
    Addon.AprilDayTicker = nil
    HUI_AprilDay()
end

function HUI_AprilDay(checked)
    
    if checked ~= nil then
        Addon.AprilDayEnabled = checked
        Addon:SaveSetting("AprilDayEnabled", checked, true)

        if checked then
            HUIOptionsFramePortrait:SetTexture("interface/AddOns/HUI/assets/icon_april.png")
        else
            HUIOptionsFramePortrait:SetTexture("interface/AddOns/HUI/assets/icon2.tga")
        end
    end

    if Addon.AprilDayEnabled then
        if not Addon.AprilDayTicker then
            local inAir = false 

            Addon.AprilDayTicker = C_Timer.NewTicker(0.1, function()
                if UnitIsDeadOrGhost("player") or UnitOnTaxi("player") then 
                    return 
                end

                local falling = IsFalling()
                local flying = IsFlying()
                local mounted = IsMounted()
                local swimming = IsSwimming()
                local inVehicle = UnitInVehicle("player") or UnitControllingVehicle("player")

                if falling then
                    inAir = true
                    
                elseif inAir and not falling and not flying and not mounted and not swimming and not inVehicle then
                    local rnd = math.random(1, 100)
                    if rnd > 10 then
                        PlaySound(227942, "SFX")
                    end
                    inAir = false
                end
            end)
        end
    else
        if Addon.AprilDayTicker then
            Addon.AprilDayTicker:Cancel()
            Addon.AprilDayTicker = nil
        end
    end
end

local function OnPlayerLogin()
    CacheButtons()

    Addon:UpdateExtraActionButton()

    hooksecurefunc("ExtraActionBar_Update", function()
        Addon:UpdateExtraActionButton()
    end)

    local function HookZoneAbilityFrame()
        if not ZoneAbilityFrame or ZoneAbilityFrame.__huiHookedZoneAbility then return end
        hooksecurefunc(ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function()
            Addon:UpdateZoneAbilityButtons()
        end)
        ZoneAbilityFrame.__huiHookedZoneAbility = true
        Addon:UpdateZoneAbilityButtons()
    end

    Addon:RegisterEvent("ADDON_LOADED", function(addonName)
        if addonName == "Blizzard_ZoneAbility" or addonName == "Blizzard_ZoneAbility_Mainline" then
            Addon:UpdateZoneAbilityButtons()
            HookZoneAbilityFrame()
        end
    end, "ActionBars")

    Addon:UpdateZoneAbilityButtons()
    HookZoneAbilityFrame()

    if ActionButton_ApplyCooldown then
        hooksecurefunc("ActionButton_ApplyCooldown", Hook_ActionButton_ApplyCooldown)
    end

    hooksecurefunc(AssistedCombatManager, "SetAssistedHighlightFrameShown", Hook_Assist)

    currentProfile = HUIProfilesMixin:GetPlayerProfile()

    Addon:HookActionBarGrid()

    Addon.ClassColor = {PlayerUtil.GetClassColor():GetRGB()}

    for _, prefix in ipairs(ActionBarButtonPrefixes) do
        local bar = CachedButtons[prefix]
        for i = 1, NUM_ACTIONBAR_BUTTONS do
            Hook_UpdateButton(bar[i])
        end
    end
    for i = 1, 6 do
        Hook_UpdateButton(_G["OverrideActionBarButton"..i])
    end

    hooksecurefunc(ActionBarActionButtonMixin, "OnLoad", Hook_UpdateButton)
    UpdateStanceAndPetBars()

    Addon:SetTalkingHeadEnabled(Addon:GetValue("HideTalkingHead"))

    Addon:BarsFadeAnim()
end

function Addon:SetTalkingHeadEnabled(enabled)
    Addon:UnregisterEvent("TALKINGHEAD_REQUESTED", "ActionBars")
    if enabled then
        Addon:RegisterEvent("TALKINGHEAD_REQUESTED", DisableTalkingHeadFrame, "ActionBars")
    end
end

local function OnFadeTrigger()
    C_Timer.After(0, function()
        Addon:BarsFadeAnim()

        if not InCombatLockdown() then
            for button in pairs(pendingPassThrough) do
                pendingPassThrough[button] = nil
                Addon:UpdateButtonsPassThrough(button)
            end
        end
    end)
end

Addon:RegisterEvent("PLAYER_LOGIN", OnPlayerLogin, "ActionBars")

Addon:RegisterEvent("ACTION_RANGE_CHECK_UPDATE", function(slot, inRange, checksRange)
    Hook_RangeCheckButton(slot, inRange, checksRange)
end, "ActionBars")

Addon:RegisterEvent("PLAYER_REGEN_DISABLED", OnFadeTrigger, "ActionBars")
Addon:RegisterEvent("PLAYER_REGEN_ENABLED", OnFadeTrigger, "ActionBars")
Addon:RegisterEvent("PLAYER_TARGET_CHANGED", OnFadeTrigger, "ActionBars")
Addon:RegisterUnitEvent("UNIT_SPELLCAST_START", "player", OnFadeTrigger, "ActionBars")
Addon:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player", OnFadeTrigger, "ActionBars")
Addon:RegisterEvent("ACTIONBAR_SHOWGRID", OnFadeTrigger, "ActionBars")
Addon:RegisterEvent("ACTIONBAR_HIDEGRID", OnFadeTrigger, "ActionBars")

Addon:RegisterEvent("PLAYER_IN_COMBAT_CHANGED", function(locked)
    Addon:UpdateSettingsLock(locked)
end, "ActionBars")

Addon:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", function()
    HUIProfilesMixin:OnSpecChanged(currentProfile)
    currentProfile = HUIProfilesMixin:GetPlayerProfile()
end, "ActionBars")

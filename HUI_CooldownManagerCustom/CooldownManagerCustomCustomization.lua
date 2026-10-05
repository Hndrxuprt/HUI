local Addon = _G.HUI

local L = Addon.L
local T = Addon.Templates

HUI_CDMCustomFrameCustomized = {}

function HUI_CDMCustomFrameCustomized:ApplyFrameStrataAndLevel(frame, frameName)
    frameName = frameName or frame.frameName

    frame:SetFrameStrata(Addon.FrameStratas[Addon:GetValue("CDMCustomFrameStrata", nil, frameName)] or "MEDIUM")
    local frameLevel = 2
    if Addon:GetValue("UseCDMCustomFrameLevel", nil, frameName) then
        frameLevel = Addon:GetValue("CDMCustomFrameLevel", nil, frameName) or 2
    end
    frame:SetFrameLevel(frameLevel)
end

function HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
    frameName = frameName or frame.frameName

    self:ApplyFrameStrataAndLevel(frame, frameName)

    if frame.RefreshSettings then
        frame:RefreshSettings()
        return
    end

    self:RefreshItemSize(frame, frameName)
    self:RefreshIconMask(frame, frameName)
    self:RefreshCooldownFrame(frame, frameName)
    self:RefreshBackdrop(frame, frameName)
    --self:RefreshLoopGlow(frame, frameName)
    self:RefreshCooldownFont(frame, frameName)
    self:RefreshStacksFont(frame, frameName)
    if frame:IsBarFrame() then
        self:RefreshBarSize(frame, frameName)
        self:RefreshPipTexture(frame, frameName)
        self:RefreshName(frame, frameName)
        self:RefreshStacks(frame, frameName)
        self:RefreshDuration(frame, frameName)
    end

end


function HUI_CDMCustomFrameCustomized:RefreshIconMask(frame, frameName)
    
    frameName = frameName or frame.frameName

    local iconMaskIndex = Addon:GetValue("CurrentIconMaskTexture", nil, frameName)
    local iconMaskAtlas = T.IconMaskTextures[iconMaskIndex]

    for itemFrame in frame.itemPool:EnumerateActive() do

        local mask = itemFrame.Icon.IconMask or itemFrame.IconMask
        local icon = itemFrame.Icon.Icon or itemFrame.Icon
        local iconOverlay = itemFrame.Icon.IconOverlay or itemFrame.IconOverlay

        Addon:SetTexture(mask, iconMaskAtlas.texture)
                
        if iconMaskAtlas.point then
            mask:ClearAllPoints()
            mask:SetPoint(iconMaskAtlas.point, mask:GetParent(), iconMaskAtlas.point)
        end

        if Addon:GetValue("UseIconMaskScale", nil, frameName) then
            mask:SetSize(mask:GetParent():GetSize())
            mask:SetScale(Addon:GetValue("IconMaskScale", nil, frameName))
        else
            mask:ClearAllPoints()
            mask:SetAllPoints()
        end

        if Addon:GetValue("UseIconScale", nil, frameName) then
            icon:ClearAllPoints()
            icon:SetPoint("CENTER", icon:GetParent(), "CENTER")
            icon:SetSize(icon:GetParent():GetSize())
            icon:SetScale(Addon:GetValue("IconScale", nil, frameName))
        else
            icon:ClearAllPoints()
            icon:SetAllPoints()
        end

        if iconOverlay and iconMaskIndex > 1 then
            iconOverlay:Hide()
        elseif iconOverlay then
            iconOverlay:Show()
        end
    end
end

function HUI_CDMCustomFrameCustomized:ApplyIconMask(icon, frameName, size)
    local parent = icon:GetParent()

    if not icon.__iconMask then
        icon.__iconMask = parent:CreateMaskTexture(nil, "OVERLAY")
        icon.__iconMask:SetHorizTile(false)
        icon.__iconMask:SetVertTile(false)
        icon:AddMaskTexture(icon.__iconMask)
    end
    local mask = icon.__iconMask

    local iconMaskAtlas = T.IconMaskTextures[Addon:GetValue("CurrentIconMaskTexture", nil, frameName)]
    if not iconMaskAtlas then
        return
    end

    size = size or parent:GetSize()

    Addon:SetTexture(mask, iconMaskAtlas.texture)

    if iconMaskAtlas.point then
        mask:ClearAllPoints()
        mask:SetPoint(iconMaskAtlas.point, parent, iconMaskAtlas.point)
    end

    if Addon:GetValue("UseIconMaskScale", nil, frameName) then
        mask:SetSize(size, size)
        mask:SetScale(Addon:GetValue("IconMaskScale", nil, frameName))
    else
        mask:ClearAllPoints()
        mask:SetAllPoints()
    end

    if Addon:GetValue("UseIconScale", nil, frameName) then
        icon:ClearAllPoints()
        icon:SetPoint("CENTER", parent, "CENTER")
        icon:SetSize(size, size)
        icon:SetScale(Addon:GetValue("IconScale", nil, frameName))
    else
        icon:ClearAllPoints()
        icon:SetAllPoints()
    end
end

function HUI_CDMCustomFrameCustomized:ApplyBarIconMask(icon, frameName)
    if not icon.__iconMask then
        icon.__iconMask = icon:GetParent():CreateMaskTexture(nil, "OVERLAY")
        icon.__iconMask:SetHorizTile(false)
        icon.__iconMask:SetVertTile(false)
        icon:AddMaskTexture(icon.__iconMask)
    end
    local mask = icon.__iconMask

    local iconMaskAtlas = T.IconMaskTextures[Addon:GetValue("CurrentIconMaskTexture", nil, frameName)]
    if not iconMaskAtlas then
        return
    end

    Addon:SetTexture(mask, iconMaskAtlas.texture)

    if Addon:GetValue("UseIconMaskScale", nil, frameName) then
        local size = self:GetBarIconSize(frameName)
        mask:ClearAllPoints()
        mask:SetPoint("CENTER", icon, "CENTER")
        mask:SetSize(size, size)
        mask:SetScale(Addon:GetValue("IconMaskScale", nil, frameName))
    else
        local size = self:GetBarIconSize(frameName)
        mask:ClearAllPoints()
        mask:SetPoint("CENTER", icon, "CENTER")
        mask:SetSize(size, size)
    end

    icon:SetScale(Addon:GetValue("UseIconScale", nil, frameName) and Addon:GetValue("IconScale", nil, frameName) or 1)
end

function HUI_CDMCustomFrameCustomized:ApplyIconBorder(border, icon, size)
    border:ClearAllPoints()
    border:SetPoint("CENTER", icon, "CENTER")
    border:SetSize(size, size)
end

function HUI_CDMCustomFrameCustomized:RefreshItemSize(frame, frameName)
    frameName = frameName or frame.frameName

    if Addon:GetValue("UseCDMCustomItemSize", nil, frameName) then
        for itemFrame in frame.itemPool:EnumerateActive() do
            if not itemFrame.Bar then
                local size = Addon:GetValue("CDMCustomItemSize", nil, frameName)
                itemFrame.frameSize = size
                itemFrame:SetSize(size, size)                
            end
        end
    end
end

function HUI_CDMCustomFrameCustomized:GetBarIconSize(frameName)
    local size = Addon:GetValue("UseCDMCustomFrameBarIconSize", nil, frameName) and Addon:GetValue("CDMCustomFrameBarIconSize", nil, frameName)
    if not size then
        size = Addon:GetValue("UseCDMCustomFrameBarHeight", nil, frameName) and Addon:GetValue("CDMCustomFrameBarHeight", nil, frameName) or 10
    end
    return size
end

function HUI_CDMCustomFrameCustomized:ApplyBarIconSize(itemFrame, frameName, ownScale)
    local iconPos = Addon:GetValue("CurrentCDMCustomFrametBarIconPosition", nil, frameName)
    local size = self:GetBarIconSize(frameName)
    local useOffset = Addon:GetValue("UseCDMCustomFrameBarIconOffset", nil, frameName)
    local offsetX = useOffset and Addon:GetValue("CDMCustomFrameBarIconOffsetX", nil, frameName) or 0
    local offsetY = useOffset and Addon:GetValue("CDMCustomFrameBarIconOffsetY", nil, frameName) or 0
    ownScale = ownScale or 1

    local icon = itemFrame.Icon
    local iconRight = itemFrame.IconRight

    if iconPos == 4 and iconRight then
        Addon.PP.Size(icon, size)
        icon:SetAlpha(1)
        icon:ClearAllPoints()
        Addon.PP.Point(icon, "CENTER", itemFrame, "LEFT", (offsetX - size / 2) / ownScale, offsetY / ownScale)

        Addon.PP.Size(iconRight, size)
        iconRight:SetAlpha(1)
        iconRight:Show()
        iconRight:ClearAllPoints()
        Addon.PP.Point(iconRight, "CENTER", itemFrame, "RIGHT", (size / 2 - offsetX) / ownScale, offsetY / ownScale)
    else
        Addon.PP.Size(icon, size)
        icon:SetAlpha(1)

        local relPoint = iconPos ~= 3 and "LEFT" or "RIGHT"
        local centerOffset = iconPos ~= 3 and offsetX - size / 2 or size / 2 - offsetX
        icon:ClearAllPoints()
        Addon.PP.Point(icon, "CENTER", itemFrame, relPoint, centerOffset / ownScale, offsetY / ownScale)

        if iconRight then
            iconRight:Hide()
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshBarIconSize(frame, frameName)
    frameName = frameName or frame.frameName
    local iconPos = Addon:GetValue("CurrentCDMCustomFrametBarIconPosition", nil, frameName)
    if iconPos > 1 then
        for itemFrame in frame.itemPool:EnumerateActive() do
            self:ApplyBarIconSize(itemFrame, frameName)    
        end
    else
        for itemFrame in frame.itemPool:EnumerateActive() do
            itemFrame.Icon:Hide()
            if itemFrame.IconRight then
                itemFrame.IconRight:Hide()
            end
        end
    end
end

function HUI_CDMCustomFrameCustomized:ApplyBarSize(itemFrame, frameName)
    local width = Addon:GetValue("UseCDMCustomFrameBarWidth", nil, frameName) and Addon:GetValue("CDMCustomFrameBarWidth", nil, frameName) or 100
    local height = Addon:GetValue("UseCDMCustomFrameBarHeight", nil, frameName) and Addon:GetValue("CDMCustomFrameBarHeight", nil, frameName) or 10
    local statusbar = itemFrame:GetStatusbar()
    Addon.PP.Size(statusbar, width, height)
end

function HUI_CDMCustomFrameCustomized:RefreshBarSize(frame, frameName)
    frameName = frameName or frame.frameName
    for itemFrame in frame.itemPool:EnumerateActive() do
        if itemFrame.Bar then
            self:ApplyBarSize(itemFrame, frameName)
        end
    end
end

function HUI_CDMCustomFrameCustomized:ApplyBarTexture(itemFrame, frameName, spellID)
    local foreground = Addon:GetStatusBarTextureByName(Addon:GetValue("CurrentCDMCustomFrameStatusbarTexture", nil, frameName))
    local background = Addon:GetStatusBarTextureByName(Addon:GetValue("CurrentCDMCustomFrameBackgroundTexture", nil, frameName))
    local color = itemFrame:GetCustomColor(spellID) or { r=1, g=1, b=1, a=1 }
    local statusbar = itemFrame:GetStatusbar()
    statusbar:SetStatusBarTexture(foreground)
    statusbar:SetStatusBarColor(color.r, color.g, color.b, color.a)
    statusbar.BarBG:SetVertexColor(Addon:GetColor("CDMCustomFrameBackgroundColor", "UseCDMCustomFrameBackgroundColor", nil, frameName))
    Addon:SetTexture(statusbar.BarBG, background)
    Addon.PP.DisablePixelSnap(statusbar)
    Addon.PP.DisablePixelSnap(statusbar:GetStatusBarTexture())
end

function HUI_CDMCustomFrameCustomized:RefreshBarTextures(frame, frameName)
    frameName = frameName or frame.frameName
    for itemFrame in frame.itemPool:EnumerateActive() do
        if itemFrame.Bar then
            self:ApplyBarTexture(itemFrame, frameName)
        end
    end
end

function HUI_CDMCustomFrameCustomized:ApplyPipTexture(itemFrame, frameName)
    local pipTexture = T.PipTextures[Addon:GetValue("CurrentCDMCustomFramePipTexture", nil, frameName)].texture
    local pipWidth = Addon:GetValue("UseCDMCustomFramePipSize", nil, frameName) and Addon:GetValue("CDMCustomFramePipSizeX", nil, frameName) or 8
    local pipHeight = Addon:GetValue("UseCDMCustomFramePipSize", nil, frameName) and Addon:GetValue("CDMCustomFramePipSizeY", nil, frameName) or 20

    local statusbar = itemFrame:GetStatusbar()
    statusbar.Pip:SetSize(pipWidth, pipHeight)
    Addon:SetTexture(statusbar.Pip, pipTexture)

    statusbar.Pip:SetPoint("CENTER", statusbar:GetStatusBarTexture(), "RIGHT", 0, 0)
end

function HUI_CDMCustomFrameCustomized:RefreshPipTexture(frame, frameName)
    frameName = frameName or frame.frameName
    for itemFrame in frame.itemPool:EnumerateActive() do
        if itemFrame.Bar then
            self:ApplyPipTexture(itemFrame, frameName)
        end
    end
end

function HUI_CDMCustomFrameCustomized:CustomizeCooldownFrame(cooldownFrame, frameName, cdParent, isAura)
    if not cooldownFrame then return end

    local swipeTextureIndex = Addon:GetValue("CurrentSwipeTexture", nil, frameName)

    local swipeTexture = T.SwipeTextures[swipeTextureIndex]
    if swipeTexture then
        cooldownFrame:SetSwipeTexture(swipeTexture.texture)
    end

    cdParent = cdParent or cooldownFrame:GetParent()

    if Addon:GetValue("UseSwipeSize", nil, frameName) then
        cooldownFrame:ClearAllPoints()
        cooldownFrame:SetPoint("CENTER", cdParent, "CENTER")
        local size = Addon:GetValue("SwipeSize", nil, frameName)
        cooldownFrame:SetSize(size, size)
    else
        cooldownFrame:SetAllPoints(cdParent)
    end

    if not cooldownFrame:GetDrawEdge() then
        cooldownFrame:SetDrawEdge(Addon:GetValue("EdgeAlwaysShow", nil, frameName))
    end

    if cooldownFrame:GetDrawEdge() then
        cooldownFrame:SetEdgeTexture(T.EdgeTextures[Addon:GetValue("CurrentEdgeTexture", nil, frameName)].texture)
        if Addon:GetValue("UseEdgeSize", nil, frameName) then
            local size = Addon:GetValue("EdgeSize", nil, frameName)
            cooldownFrame:SetEdgeScale(size)
        end
        cooldownFrame:SetEdgeColor(Addon:GetColor("EdgeColor", "UseEdgeColor", nil, frameName))
    end

    local reverseSetting = isAura and "CDMAuraReverseSwipe" or "CDMReverseSwipe"

    cooldownFrame:SetReverse(Addon:GetValue(reverseSetting, nil, frameName))

    cooldownFrame.isReversed = Addon:GetValue(reverseSetting, nil, frameName)

    cooldownFrame.showGCDSwipe = not (Addon:GetValue("CDMRemoveGCDSwipe", nil, frameName))

    local parentFrame = _G[frameName]
    local isAuraFrame = parentFrame and parentFrame.RefreshSettings ~= nil
    local isBar = parentFrame and parentFrame.IsBarFrame and parentFrame:IsBarFrame()

    if not isBar and (isAuraFrame or isAura) then
        cooldownFrame:SetDrawSwipe(Addon:GetValue("CDMAuraShowSwipe", nil, frameName))
        cooldownFrame:SetDrawEdge(Addon:GetValue("CDMAuraShowEdge", nil, frameName))
    end
end

function HUI_CDMCustomFrameCustomized:RefreshCooldownColor(cooldownFrame, frameName)
    cooldownFrame:SetSwipeColor(Addon:GetColor("CooldownColor", "UseCooldownColor", nil, frameName))
end

function HUI_CDMCustomFrameCustomized:RefreshAuraColor(cooldownFrame, frameName)
    cooldownFrame:SetSwipeColor(Addon:GetColor("CooldownAuraColor", "UseCooldownAuraColor", nil, frameName))
end

function HUI_CDMCustomFrameCustomized:RefreshAuraTimer(cooldownFrame, frameName, forceUpdate)
    local timerString = cooldownFrame:GetCountdownFontString()

    local color = { r=1, g=1, b=1, a=1 }
    if Addon:GetValue("UseCDMAuraTimerColor", nil, frameName) then
        color.r,color.g,color.b,color.a = Addon:GetRGBA("CDMAuraTimerColor", nil, frameName)
    end
    timerString:SetVertexColor(color.r, color.g, color.b, color.a)

    local formatType = Addon:GetValue("CDMCooldownFormatType", nil, frameName)
    local formatOptions = Addon:GetCooldownFormatOptions(frameName)
    local needUpdate = cooldownFrame.__auraFormatType ~= formatType or forceUpdate or not tCompare(color, cooldownFrame.__auraColor) or not cooldownFrame.__auraFormatOptions or not tCompare(formatOptions, cooldownFrame.__auraFormatOptions)

    if Addon:GetValue("ColorizedAuraFont", nil, frameName) then
        if not cooldownFrame.__auraFormatterColored or needUpdate then
            cooldownFrame.__auraColor = color
            cooldownFrame.__auraFormatType = formatType
            cooldownFrame.__auraFormatOptions = formatOptions
            cooldownFrame.__auraFormatterColored = Addon:GetNumberFormatter(color, nil, nil, formatType, formatOptions)
        end
        cooldownFrame:SetCountdownFormatter(cooldownFrame.__auraFormatterColored)
    else
        if not cooldownFrame.__auraFormatter or needUpdate then
            cooldownFrame.__auraColor = color
            cooldownFrame.__auraFormatType = formatType
            cooldownFrame.__auraFormatOptions = formatOptions
            cooldownFrame.__auraFormatter = Addon:GetNumberFormatter(color, color, color, formatType, formatOptions)
        end
        cooldownFrame:SetCountdownFormatter(cooldownFrame.__auraFormatter)
    end
end

function HUI_CDMCustomFrameCustomized:ColorizeCooldownFont(cooldownFrame, color, frame, frameName, forceUpdate)
    local fontString = cooldownFrame:GetCountdownFontString()

    if not frame.__cooldownColor then
        frame.__cooldownColor = { r=1, g=1, b=1, a=1 }
    end

    color = color or { r=1, g=1, b=1, a=1 }

    if not tCompare(color, frame.__cooldownColor) then
        frame.__cooldownColor = color
        forceUpdate = true
    end

    local formatOptions = Addon:GetCooldownFormatOptions(frameName)
    if not frame.__formatOptions or not tCompare(formatOptions, frame.__formatOptions) then
        frame.__formatOptions = formatOptions
        forceUpdate = true
    end

    if Addon:GetValue("ColorizedCooldownFont", nil, frameName) then
        if not frame.__numberFormatterColored or forceUpdate then
            local formatType = Addon:GetValue("CDMCooldownFormatType", nil, frameName)
            frame.__numberFormatterColored = Addon:GetNumberFormatter(color,nil,nil,formatType, formatOptions)
        end
        cooldownFrame:SetCountdownFormatter(frame.__numberFormatterColored)
    else
        if not frame.__numberFormater or forceUpdate then
            local formatType = Addon:GetValue("CDMCooldownFormatType", nil, frameName)
            frame.__numberFormater = Addon:GetNumberFormatter(color, color, color,formatType, formatOptions)
        end
        cooldownFrame:SetCountdownFormatter(frame.__numberFormater)
    end
end

function HUI_CDMCustomFrameCustomized:RefreshCooldownFrame(frame, frameName, forceUpdate)
    frameName = frameName or frame.frameName

    for itemFrame in frame.itemPool:EnumerateActive() do
        local cooldownFrame = itemFrame.Icon.Cooldown or itemFrame.Cooldown
        local auraFrame = itemFrame.Icon.AuraCooldown or itemFrame.AuraCooldown

        local cdColor = {r=1,g=1,b=1,a=1}
        if Addon:GetValue("UseCooldownFontColor", nil, frameName) then
            cdColor.r,cdColor.g,cdColor.b,cdColor.a = Addon:GetRGBA("CooldownFontColor", nil, frameName)
        end

        self:CustomizeCooldownFrame(cooldownFrame, frameName)
        self:RefreshCooldownColor(cooldownFrame, frameName)
        self:ColorizeCooldownFont(cooldownFrame, cdColor, frame, frameName, forceUpdate)

        self:CustomizeCooldownFrame(auraFrame, frameName, nil, true)
        self:RefreshAuraColor(auraFrame, frameName)
        self:RefreshAuraTimer(auraFrame, frameName, forceUpdate)

        if forceUpdate and auraFrame and itemFrame.isOnAuraTimer and itemFrame.auraDurationObj then
            auraFrame:SetCooldown(GetTime(), itemFrame.auraDurationObj:GetRemainingDuration())
        end

        if itemFrame.realAuraCooldownFrame and itemFrame.realAuraCooldownFrame:CanBeAccessedInContext() then
            self:RefreshAuraTimer(itemFrame.realAuraCooldownFrame, frameName, forceUpdate)
        end
    end

end

function HUI_CDMCustomFrameCustomized:CustomizeCooldownFont(cooldownFrame, frameName, isAura)
    cooldownFrame:SetCountdownAbbrevThreshold(920)

    local color = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    if Addon:GetValue("UseCooldownFontColor", nil, frameName) then
        color.r,color.g,color.b,color.a = Addon:GetRGBA("CooldownFontColor", nil, frameName)
    end

    local fontSize = Addon:GetValue("UseCooldownFontSize", nil, frameName) and Addon:GetValue("CooldownFontSize", nil, frameName) or 17
        
    local _, fontName = Addon:GetFontObject(
        Addon:GetValue("CurrentCooldownFont", nil, frameName),
        "OUTLINE, SLUG",
        color,
        fontSize,
        false,
        frameName
    )
    cooldownFrame:SetCountdownFont(fontName)

    local fontString = cooldownFrame:GetCountdownFontString()

    if Addon:GetValue("UseCooldownFontOffset", nil, frameName) then
        local offsetX = Addon:GetValue("CooldownFontOffsetX", nil, frameName)
        local offsetY = Addon:GetValue("CooldownFontOffsetY", nil, frameName)

        fontString:SetPointsOffset(Addon.PP.Scale(offsetX), Addon.PP.Scale(offsetY))
    else
        fontString:SetPointsOffset(0, 0)
    end

    local parentFrame = _G[frameName]
    local isAuraFrame = parentFrame and parentFrame.RefreshSettings ~= nil
    local isBar = parentFrame and parentFrame.IsBarFrame and parentFrame:IsBarFrame()

    if not isBar and (isAuraFrame or isAura) then
        cooldownFrame:SetHideCountdownNumbers(not Addon:GetValue("CDMAuraShowTimer", nil, frameName))
    end
end

function HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
    frameName = frameName or frame.frameName
    for itemFrame in frame.itemPool:EnumerateActive() do

        local cooldownFrame = itemFrame.Icon.Cooldown or itemFrame.Cooldown
        local auraCooldown  = itemFrame.Icon.AuraCooldown or itemFrame.AuraCooldown

        self:CustomizeCooldownFont(cooldownFrame, frameName)
        self:CustomizeCooldownFont(auraCooldown, frameName, true)

    end
end

function HUI_CDMCustomFrameCustomized:CustomizeStacksFont(fontString, frameName, parent)
    if not fontString then return end

    local stacksFont = Addon:GetValue("CurrentStacksFont", nil, frameName)
    fontString:SetFont(
        stacksFont ~= "Default" and LibStub("LibSharedMedia-3.0"):Fetch("font", stacksFont) or "Fonts\\ARIALN.TTF",
        (Addon:GetValue("UseStacksFontSize", nil, frameName) and Addon:GetValue("StacksFontSize", nil, frameName) or 16),
        "OUTLINE, SLUG"
    )
    fontString:SetVertexColor(Addon:GetColor("StacksColor", "UseStacksColor", nil, frameName))

    local point = Addon.AttachPoints[Addon:GetValue("CurrentStacksPoint", nil, frameName)]
    local relativePoint = Addon.AttachPoints[Addon:GetValue("CurrentStacksRelativePoint", nil, frameName)]
    fontString:SetWidth(0)
    fontString:ClearAllPoints()
    parent = parent or fontString:GetParent()
    fontString:SetPoint(point, parent, relativePoint)

    if Addon:GetValue("UseStacksOffset", nil, frameName) then
        fontString:SetPointsOffset(Addon:GetValue("StacksOffsetX", nil, frameName), Addon:GetValue("StacksOffsetY", nil, frameName))
    end
end

function HUI_CDMCustomFrameCustomized:RefreshStacksFont(frame, frameName)
    frameName = frameName or frame.frameName
    for itemFrame in frame.itemPool:EnumerateActive() do
        local stacksFrame = itemFrame.Icon.Applications or itemFrame.Applications
        local stacksString = stacksFrame.Applications
        if stacksString then
            self:CustomizeStacksFont(stacksString, frameName)
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshAuraSwipe(frame, frameName)
    frameName = frameName or frame.frameName

    if frame.RefreshSettings then
        frame:RefreshSettings()
        return
    end

    local showSwipe = Addon:GetValue("CDMAuraShowSwipe", nil, frameName)
    for itemFrame in frame.itemPool:EnumerateActive() do
        local auraFrame = itemFrame.Icon.AuraCooldown or itemFrame.AuraCooldown
        if auraFrame then
            auraFrame:SetDrawSwipe(showSwipe)
        end
        if itemFrame.realAuraCooldownFrame and itemFrame.realAuraCooldownFrame:CanBeAccessedInContext() then
            itemFrame.realAuraCooldownFrame:SetDrawSwipe(showSwipe)
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshAuraEdge(frame, frameName)
    frameName = frameName or frame.frameName

    if frame.RefreshSettings then
        frame:RefreshSettings()
        return
    end

    local showEdge = Addon:GetValue("CDMAuraShowEdge", nil, frameName)
    for itemFrame in frame.itemPool:EnumerateActive() do
        local auraFrame = itemFrame.Icon.AuraCooldown or itemFrame.AuraCooldown
        if auraFrame then
            auraFrame:SetDrawEdge(showEdge)
        end
        if itemFrame.realAuraCooldownFrame and itemFrame.realAuraCooldownFrame:CanBeAccessedInContext() then
            itemFrame.realAuraCooldownFrame:SetDrawEdge(showEdge)
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshAuraTimerVisibility(frame, frameName)
    frameName = frameName or frame.frameName

    if frame.RefreshSettings then
        frame:RefreshSettings()
        return
    end

    local hideNumbers = not Addon:GetValue("CDMAuraShowTimer", nil, frameName)
    for itemFrame in frame.itemPool:EnumerateActive() do
        local auraFrame = itemFrame.Icon.AuraCooldown or itemFrame.AuraCooldown
        if auraFrame then
            auraFrame:SetHideCountdownNumbers(hideNumbers)
        end
        if itemFrame.realAuraCooldownFrame and itemFrame.realAuraCooldownFrame:CanBeAccessedInContext() then
            itemFrame.realAuraCooldownFrame:SetHideCountdownNumbers(hideNumbers)
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshAuraStacks(frame, frameName)
    frameName = frameName or frame.frameName

    if frame.RefreshSettings then
        frame:RefreshSettings()
        return
    end

    local showStacks = Addon:GetValue("CDMAuraShowStacks", nil, frameName)
    local countFormatter = Addon:GetValue("AlwaysShowStacks", nil, frameName) and { formatter = Addon.defaultCountFormatter } or {}

    for itemFrame in frame.itemPool:EnumerateActive() do
        itemFrame:RefreshCount()

        local auraButton = itemFrame.aura
        if auraButton and auraButton.SetApplicationCount and auraButton:CanBeAccessedInContext() and itemFrame.realAuraFrame then
            if showStacks then
                auraButton:SetApplicationCount(itemFrame.realAuraFrame.overlayFrame.count, countFormatter)
            else
                auraButton:ClearApplicationCount()
                itemFrame.realAuraFrame.overlayFrame.count:Hide()
            end
        end
    end
end

function HUI_CDMCustomFrameCustomized:SetupBackdrop(backdrop, frameName, color)

    if not color then
        color = {r=1, g=1, b=1, a=1}
        color.r, color.g, color.b, color.a = Addon:GetRGBA("CDMBackdropColor", nil, frameName)
    end
    --[[ auraColor.r, auraColor.g, auraColor.b, auraColor.a = Addon:GetRGBA("CDMBackdropAuraColor", nil, frameName)
    pandemicColor.r, pandemicColor.g, pandemicColor.b, pandemicColor.a = Addon:GetRGBA("CDMBackdropPandemicColor", nil, frameName) ]]

    pcall(function()
        local info = backdrop:GetBackdrop()
        if info then
            local edgeSize = Addon:GetValue("CDMBackdropSize", nil, frameName)
            local parent = backdrop:GetParent()
            if Addon.PP and parent then
                edgeSize = Addon.PP.SnapForES(edgeSize, parent:GetEffectiveScale())
            end
            local newInfo = {}
            for k, v in pairs(info) do
                newInfo[k] = v
            end
            newInfo.edgeSize = edgeSize
            backdrop:SetBackdrop(newInfo)
        end
    end)
    backdrop:SetBackdropBorderColor(color.r, color.g, color.b, color.a)

end

local function UnregisterPandemicRegions(auraButton, regions)
    local entries = {}
    for _, region in ipairs(regions) do
        if region and region.pandemicRegionIndex then
            tinsert(entries, { region = region, index = region.pandemicRegionIndex })
        end
    end
    table.sort(entries, function(a, b)
        if type(a.index) == "number" and type(b.index) == "number" then
            return a.index > b.index
        end
        return false
    end)
    for _, entry in ipairs(entries) do
        if type(entry.index) == "number" then
            auraButton:RemovePandemicRegion(entry.index)
        else
            auraButton:RemovePandemicRegion(entry.region)
        end
        entry.region.pandemicRegionIndex = nil
    end
end

function HUI_CDMCustomFrameCustomized:RefreshPandemicRegions(auraButton, allRegions, desiredRegions, frameName)
    if not auraButton or not allRegions then return end
    desiredRegions = desiredRegions or allRegions

    if Addon:GetValue("CDMRemovePandemic", nil, frameName) then
        UnregisterPandemicRegions(auraButton, allRegions)
        for _, region in ipairs(allRegions) do
            if region then
                region:SetAlpha(0)
            end
        end
        return
    end

    local desiredLookup = {}
    for _, region in ipairs(desiredRegions) do
        if region then
            desiredLookup[region] = true
        end
    end

    local toRemove = {}
    for _, region in ipairs(allRegions) do
        if region and not desiredLookup[region] then
            tinsert(toRemove, region)
        end
    end
    UnregisterPandemicRegions(auraButton, toRemove)
    for _, region in ipairs(toRemove) do
        if region then
            region:SetAlpha(0)
        end
    end

    for _, region in ipairs(desiredRegions) do
        if region then
            if not region.pandemicRegionIndex then
                region.pandemicRegionIndex = auraButton:AddPandemicRegion(region) or true
            end
            region:SetAlpha(1)
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshBackdrop(frame, frameName)
    frameName = frameName or frame.frameName
    local color = {r=0,g=0,b=0,a=1}
    local auraColor = {r=0,g=0,b=0,a=1}
    local pandemicColor = {r=0,g=0,b=0,a=1}

    if Addon:GetValue("UseCDMBackdrop", nil, frameName) then
        for itemFrame in frame.itemPool:EnumerateActive() do
            if not itemFrame:HasAnyForbiddenAspects() then

                if not itemFrame.iconBorder then
                    itemFrame.iconBorder = Addon.CreateBorder(itemFrame.Icon, frameName)
                    itemFrame.iconBorder:SetShown(itemFrame.Icon:IsShown())
                else
                    self:SetupBackdrop(itemFrame.iconBorder, frameName)
                    itemFrame:RefreshBackdrop()
                    itemFrame.iconBorder:SetShown(itemFrame.Icon:IsShown())
                end
                if itemFrame.Bar and not itemFrame.BarBorder then
                    itemFrame.BarBorder = Addon.CreateBorder(itemFrame.Bar, frameName)
                    itemFrame.BarBorder:Show()
                elseif itemFrame.BarBorder then
                    self:SetupBackdrop(itemFrame.BarBorder, frameName)
                    itemFrame:RefreshBackdrop()
                    itemFrame.BarBorder:Show()
                end
                if itemFrame.realAuraFrame and itemFrame.realAuraFrame:CanBeAccessedInContext() and itemFrame.realAuraFrame.iconBorder then
                    auraColor.r, auraColor.g, auraColor.b, auraColor.a = Addon:GetRGBA("CDMBackdropAuraColor", nil, frameName)
                    self:SetupBackdrop(itemFrame.realAuraFrame.iconBorder, frameName, auraColor)
                end
                if itemFrame.realAuraFrame and itemFrame.realAuraFrame:CanBeAccessedInContext() and itemFrame.realAuraFrame.pandemicBorder then
                    pandemicColor.r, pandemicColor.g, pandemicColor.b, pandemicColor.a = Addon:GetRGBA("CDMBackdropPandemicColor", nil, frameName)
                    self:SetupBackdrop(itemFrame.realAuraFrame.pandemicBorder, frameName, pandemicColor)
                end
            end
        end
    end

    for itemFrame in frame.itemPool:EnumerateActive() do
        local realAuraFrame = itemFrame.realAuraFrame
        if realAuraFrame and realAuraFrame:CanBeAccessedInContext() then
            local auraButton = realAuraFrame:GetParent()
            if auraButton and auraButton.AddPandemicRegion then
                itemFrame:CreatePandemicElements(auraButton)
                if realAuraFrame.pandemicBorder then
                    self:RefreshPandemicRegions(auraButton, {
                        realAuraFrame.pandemicBorder,
                        realAuraFrame.pandemicGlow,
                    }, nil, frameName)
                end
            end
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshLoopGlow(frame, frameName)
    frameName = frameName or frame.frameName
    local loopAnim = T.LoopGlow[Addon:GetValue("CurrentLoopGlow", nil, frameName)]
    local procAnim = T.ProcGlow[Addon:GetValue("CurrentProcGlow", nil, frameName)]
    
    for itemFrame in frame.itemPool:EnumerateActive() do

        local actionButtonSize = 31
        local size = itemFrame.ProcGlow:GetHeight()
        local scaleMult = math.min(size / actionButtonSize, 1.4)
        
        local region = itemFrame.ProcGlow
        if loopAnim.atlas then
            region.ProcLoopFlipbook:SetAtlas(loopAnim.atlas)    
        elseif loopAnim.texture then
            region.ProcLoopFlipbook:SetTexture(loopAnim.texture)
        end
        if loopAnim then
            region.ProcLoopFlipbook:ClearAllPoints()
            region.ProcLoopFlipbook:SetSize(size, size)
            region.ProcLoopFlipbook:SetPoint("CENTER", region, "CENTER")
            region.ProcLoopFlipbook:SetScale((loopAnim.scale or 1) * scaleMult)
            
            region.ProcLoop.FlipAnim:SetFlipBookRows(loopAnim.rows or 6)
            region.ProcLoop.FlipAnim:SetFlipBookColumns(loopAnim.columns or 5)
            region.ProcLoop.FlipAnim:SetFlipBookFrames(loopAnim.frames or 30)
            region.ProcLoop.FlipAnim:SetDuration(loopAnim.duration or 1.0)
            region.ProcLoop.FlipAnim:SetFlipBookFrameWidth(loopAnim.frameW or 0.0)
            region.ProcLoop.FlipAnim:SetFlipBookFrameHeight(loopAnim.frameH or 0.0)
        end

        region.ProcLoopFlipbook:SetDesaturated(Addon:GetValue("DesaturateGlow", nil, frameName))
        if Addon:GetValue("UseLoopGlowColor", nil, frameName) then
            region.ProcLoopFlipbook:SetVertexColor(Addon:GetRGB("LoopGlowColor", nil, frameName))
        else
            region.ProcLoopFlipbook:SetVertexColor(1.0, 1.0, 1.0)
        end

        local startProc = region.ProcStartAnim.FlipAnim or Addon:GetFlipBook(region.ProcStartAnim:GetAnimations())

        if startProc and region.ProcStartFlipbook:IsVisible() then
            if Addon:GetValue("HideProc", nil, frameName) then
                startProc:SetDuration(0)
                region.ProcStartFlipbook:Hide()
            else
                region.ProcStartFlipbook:Show()
                if procAnim.atlas then
                    region.ProcStartFlipbook:SetAtlas(procAnim.atlas)
                elseif procAnim.texture then
                    region.ProcStartFlipbook:SetTexture(procAnim.texture)
                end
                if procAnim then
                    region.ProcStartFlipbook:ClearAllPoints()
                    local size = region:GetHeight()
                    region.ProcStartFlipbook:SetSize(size, size)
                    region.ProcStartFlipbook:SetPoint("CENTER", region, "CENTER")
                    startProc:SetFlipBookRows(procAnim.rows or 6)
                    startProc:SetFlipBookColumns(procAnim.columns or 5)
                    startProc:SetFlipBookFrames(procAnim.frames or 30)
                    startProc:SetDuration(procAnim.duration or 0.702)
                    startProc:SetFlipBookFrameWidth(procAnim.frameW or 0.0)
                    startProc:SetFlipBookFrameHeight(procAnim.frameH or 0.0)
                    region.ProcStartFlipbook:SetScale((procAnim.scale or 1) * scaleMult)
                end
                region.ProcStartFlipbook:SetDesaturated(Addon:GetValue("DesaturateProc", nil, frameName))

                if Addon:GetValue("UseProcColor", nil, frameName) then
                    region.ProcStartFlipbook:SetVertexColor(Addon:GetRGB("ProcColor", nil, frameName))
                else
                    region.ProcStartFlipbook:SetVertexColor(1.0, 1.0, 1.0)
                end
            end
        end
    end
end

function HUI_CDMCustomFrameCustomized:RefreshAnchors(frame, frameName)
    frameName = frameName or frame.frameName
    if Addon:GetValue("CDMEnableAttach", nil, frameName) then
        local relativeKeyName = Addon:GetValue("CurrentAttachFrame", nil, frameName)
        if relativeKeyName ~= "" and relativeKeyName ~= "UIParent" and relativeKeyName ~= frameName then
            local relativeKey = _G[relativeKeyName]
            if relativeKey then
                frame.HUISelection:SetMouseClickEnabled(false)

                local point = Addon.AttachPoints[Addon:GetValue("CurrentAttachPoint", nil, frameName)]
                local relPoint = Addon.AttachPoints[Addon:GetValue("CurrentAttachRelativePoint", nil, frameName)]
                local offsetX = Addon:GetValue("UseAttachOffset", nil, frameName) and Addon:GetValue("AttachOffsetX", nil, frameName) or 0
                local offsetY = Addon:GetValue("UseAttachOffset", nil, frameName) and Addon:GetValue("AttachOffsetY", nil, frameName) or 0
                frame:ClearAllPoints()
                Addon.PP.Point(frame, point, relativeKey, relPoint, offsetX, offsetY)
            end
        end
    else
        frame.HUISelection:SetMouseClickEnabled(true)
    end
end

function HUI_CDMCustomFrameCustomized:ApplyBarName(itemFrame, frameName)
    local nameString = itemFrame.nameText or itemFrame.Name

    if Addon:GetValue("CustomFrameBarNameEnable", nil, frameName) then
        nameString:Show()

        local color = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}

        if Addon:GetValue("UsCustomFrameBarNameColor", nil, frameName) then
            color.r,color.g,color.b,color.a = Addon:GetRGBA("CustomFrameBarNameColor", nil, frameName)
        end
        local fontSize = Addon:GetValue("UseCustomFrameBarNameSize", nil, frameName) and Addon:GetValue("CustomFrameBarNameSize", nil, frameName) or 14
        local barNameFont = Addon:GetValue("CurrentCustomFrameBarNameFont", nil, frameName)
        nameString:SetFont(
            barNameFont ~= "Default" and LibStub("LibSharedMedia-3.0"):Fetch("font", barNameFont) or "Fonts\\ARIALN.TTF",
            fontSize,
            "OUTLINE, SLUG"
        )
        nameString:SetTextColor(color.r,color.g,color.b,color.a)

        local point = Addon.AttachPoints[Addon:GetValue("CustomFrameBarNamePoint", nil, frameName)]
        local relativePoint = Addon.AttachPoints[Addon:GetValue("CustomFrameBarNameRelativePoint", nil, frameName)]
        nameString:SetWidth(0)
        nameString:ClearAllPoints()
        nameString:SetPoint(point, nameString:GetParent(), relativePoint)

        if Addon:GetValue("UseCustomFrameBarNameOffset", nil, frameName) then
            nameString:SetPointsOffset(Addon:GetValue("CustomFrameBarNameOffsetX", nil, frameName), Addon:GetValue("CustomFrameBarNameOffsetY", nil, frameName))
        end

        --nameString:SetJustifyH(Addon.BarTextJustifyH[Addon:GetValue("CurrentCustomFrameBarNameJustifyH", nil, frameName)])
    else
        nameString:Hide()
    end
end


function HUI_CDMCustomFrameCustomized:RefreshName(frame, frameName)
    frameName = frameName or frame.frameName
   
    for itemFrame in frame.itemPool:EnumerateActive() do
        self:ApplyBarName(itemFrame, frameName)
    end
end

function HUI_CDMCustomFrameCustomized:ApplyStacks(itemFrame, frameName)
    local stacksString = itemFrame.countText or itemFrame.Bar.Count

    if Addon:GetValue("CustomFrameBarStacksEnable", nil, frameName) then
        stacksString:Show()

        local color = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}

        if Addon:GetValue("UsCustomFrameBarStacksColor", nil, frameName) then
            color.r,color.g,color.b,color.a = Addon:GetRGBA("CustomFrameBarStacksColor", nil, frameName)
        end
        local fontSize = Addon:GetValue("UseCustomFrameBarStacksSize", nil, frameName) and Addon:GetValue("CustomFrameBarStacksSize", nil, frameName) or 14
        local barStacksFont = Addon:GetValue("CurrentCustomFrameBarStacksFont", nil, frameName)
        stacksString:SetFont(
            barStacksFont ~= "Default" and LibStub("LibSharedMedia-3.0"):Fetch("font", barStacksFont) or "Fonts\\ARIALN.TTF",
            fontSize,
            "OUTLINE, SLUG"
        )
        stacksString:SetTextColor(color.r,color.g,color.b,color.a)

        local point = Addon.AttachPoints[Addon:GetValue("CustomFrameBarStacksPoint", nil, frameName)]
        local relativePoint = Addon.AttachPoints[Addon:GetValue("CustomFrameBarStacksRelativePoint", nil, frameName)]
        stacksString:SetWidth(0)
        stacksString:ClearAllPoints()
        stacksString:SetPoint(point, itemFrame.countFrame or itemFrame.Bar, relativePoint)

        if Addon:GetValue("UseCustomFrameBarStacksOffset", nil, frameName) then
            stacksString:SetPointsOffset(Addon:GetValue("CustomFrameBarStacksOffsetX", nil, frameName), Addon:GetValue("CustomFrameBarStacksOffsetY", nil, frameName))
        end

        --nameString:SetJustifyH(Addon.BarTextJustifyH[Addon:GetValue("CurrentCustomFrameBarStacksJustifyH", nil, frameName)])
    else
        stacksString:Hide()
    end
end

function HUI_CDMCustomFrameCustomized:RefreshStacks(frame, frameName)
    frameName = frameName or frame.frameName
    for itemFrame in frame.itemPool:EnumerateActive() do
        self:ApplyStacks(itemFrame, frameName)
    end
end

function HUI_CDMCustomFrameCustomized:ApplyBarDuration(itemFrame, frameName, parent)
    local durationString = itemFrame.durationText or itemFrame.Bar.Duration
    local color = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}

    if not parent then return end
    
    if Addon:GetValue("CustomFrameBarTimeEnable", nil, frameName) then
        durationString:Show()

        parent.__configName = frameName
        parent.timerFormat = Addon:GetValue("CurrentCustomFrameBarTimeFormat", nil, frameName)

        if Addon:GetValue("UseCustomFrameBarTimeColor", nil, frameName) then
            color.r,color.g,color.b,color.a = Addon:GetRGBA("CustomFrameBarTimeColor", nil, frameName)
        end
        local fontSize = Addon:GetValue("UseCustomFrameBarTimeSize", nil, frameName) and Addon:GetValue("CustomFrameBarTimeSize", nil, frameName) or 14
        local barTimeFont = Addon:GetValue("CurrentCustomFrameBarTimeFont", nil, frameName)
        durationString:SetFont(
            barTimeFont ~= "Default" and LibStub("LibSharedMedia-3.0"):Fetch("font", barTimeFont) or "Fonts\\ARIALN.TTF",
            fontSize,
            "OUTLINE, SLUG"
        )
        durationString:SetTextColor(color.r,color.g,color.b,color.a)

        local point = Addon.AttachPoints[Addon:GetValue("CurrentCustomFrameBarTimePoint", nil, frameName)]
        local relativePoint = Addon.AttachPoints[Addon:GetValue("CurrentCustomFrameBarTimeRelativePoint", nil, frameName)]
        durationString:SetWidth(0)
        durationString:ClearAllPoints()
        durationString:SetPoint(point, itemFrame.durationFrame or itemFrame.Bar, relativePoint)

        if Addon:GetValue("UseCustomFrameBarTimeOffset", nil, frameName) then
            durationString:SetPointsOffset(Addon:GetValue("CustomFrameBarTimeOffsetX", nil, frameName), Addon:GetValue("CustomFrameBarTimeOffsetY", nil, frameName))
        end
        --nameString:SetJustifyH(Addon.BarTextJustifyH[Addon:GetValue("CurrentCustomFrameBarTimeJustifyH", nil, frameName)])
    else
        durationString:Hide()
        parent.timerFormat = nil
    end
end

function HUI_CDMCustomFrameCustomized:RefreshDuration(frame, frameName)
    frameName = frameName or frame.frameName

    for itemFrame in frame.itemPool:EnumerateActive() do
        self:ApplyBarDuration(itemFrame, frameName, frame)
    end
    frame.bindingTextFormatter = Addon:GetNumberFormatter(color, color, color)
end

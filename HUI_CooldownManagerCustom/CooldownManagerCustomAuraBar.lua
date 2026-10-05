local Addon = _G.HUI

local function CreatePandemicElements(auraButton, frameName)
    if auraButton.pandemicBorder then return end
    if Addon:GetValue("CDMRemovePandemic", nil, frameName) then return end

    local pColor = {}
    pColor.r, pColor.g, pColor.b, pColor.a = Addon:GetRGBA("CDMBackdropPandemicColor", nil, frameName)
    auraButton.pColor = pColor

    auraButton.pandemicBorder = Addon.CreateBorder(auraButton.Statusbar, frameName)
    auraButton.pandemicBorder:SetFrameLevel(auraButton.Statusbar:GetFrameLevel() + 101)
    HUI_CDMCustomFrameCustomized:SetupBackdrop(auraButton.pandemicBorder, frameName, pColor)
    auraButton.pandemicBorder:Show()

    auraButton.pandemicGlow = CreateFrame("Frame", nil, auraButton.Statusbar, "HUI_CDMCustomBarPandemicGlow")
    auraButton.pandemicGlow:SetPoint("TOPLEFT", auraButton.Statusbar, "TOPLEFT", -9, 10)
    auraButton.pandemicGlow:SetPoint("BOTTOMRIGHT", auraButton.Statusbar, "BOTTOMRIGHT", 9, -10)
    auraButton.pandemicGlow:SetFrameLevel(auraButton.Statusbar:GetFrameLevel() + 102)
    auraButton.pandemicGlow:Show()
    auraButton.pandemicGlow.Texture.Anim:Play()

    auraButton.Icon.pandemicBorder = Addon.CreateBorder(auraButton.Icon, frameName)
    local iconBorder = auraButton.Icon.pandemicBorder
    iconBorder:SetFrameLevel(auraButton:GetFrameLevel() + 101)
    iconBorder:ClearAllPoints()
    iconBorder:SetPoint("TOPLEFT", auraButton.Icon, "TOPLEFT", 0, 0)
    iconBorder:SetPoint("BOTTOMRIGHT", auraButton.Icon, "BOTTOMRIGHT", 0, 0)
    HUI_CDMCustomFrameCustomized:SetupBackdrop(iconBorder, frameName, pColor)
    iconBorder:Show()

    auraButton.Icon.pandemicGlow = CreateFrame("Frame", nil, auraButton, "HUI_CDMCustomItemPandemicGlow")
    local iconGlow = auraButton.Icon.pandemicGlow
    iconGlow:SetPoint("TOPLEFT", auraButton.Icon, "TOPLEFT", -6, 6)
    iconGlow:SetPoint("BOTTOMRIGHT", auraButton.Icon, "BOTTOMRIGHT", 6, -6)
    iconGlow:SetFrameLevel(auraButton:GetFrameLevel() + 102)
    iconGlow:Show()
    iconGlow.FX.Anim:Play()

    auraButton.IconRight.pandemicBorder = Addon.CreateBorder(auraButton.IconRight, frameName)
    local iconRightBorder = auraButton.IconRight.pandemicBorder
    iconRightBorder:SetFrameLevel(auraButton:GetFrameLevel() + 101)
    iconRightBorder:ClearAllPoints()
    iconRightBorder:SetPoint("TOPLEFT", auraButton.IconRight, "TOPLEFT", 0, 0)
    iconRightBorder:SetPoint("BOTTOMRIGHT", auraButton.IconRight, "BOTTOMRIGHT", 0, 0)
    HUI_CDMCustomFrameCustomized:SetupBackdrop(iconRightBorder, frameName, pColor)
    iconRightBorder:Show()

    auraButton.IconRight.pandemicGlow = CreateFrame("Frame", nil, auraButton, "HUI_CDMCustomItemPandemicGlow")
    local iconRightGlow = auraButton.IconRight.pandemicGlow
    iconRightGlow:SetPoint("TOPLEFT", auraButton.IconRight, "TOPLEFT", -6, 6)
    iconRightGlow:SetPoint("BOTTOMRIGHT", auraButton.IconRight, "BOTTOMRIGHT", 6, -6)
    iconRightGlow:SetFrameLevel(auraButton:GetFrameLevel() + 102)
    iconRightGlow:Show()
    iconRightGlow.FX.Anim:Play()

    auraButton.pandemicBorder.pandemicRegionIndex = auraButton:AddPandemicRegion(auraButton.pandemicBorder) or true
    auraButton.pandemicGlow.pandemicRegionIndex = auraButton:AddPandemicRegion(auraButton.pandemicGlow) or true
end

HUI_CDMCustomAuraBarMixin = CreateFromMixins(HUI_CDMCustomAuraMixin)

function HUI_CDMCustomAuraBarMixin:OnLoad()
    HUI_CDMCustomAuraMixin.OnLoad(self)

    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.StagesAdded", self.OnStagesAdded)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.UpdateFrame", self.OnFrameUpdate)
end

function HUI_CDMCustomAuraBarMixin:OnFrameUpdate(frameName)
    if self:GetName() ~= frameName then return end
    self:RefreshAuraButtons()
end

function HUI_CDMCustomAuraBarMixin:OnStagesAdded(spellID, newStages)
    self:RefreshAuraButtons()
end

function HUI_CDMCustomAuraBarMixin:GetCustomColor(spellID)
    if not spellID then return end

    local frameName = self.frameName
    local frameIndex = self:GetFrameIndexByName(frameName)
    local profileTable = Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()
    local color

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.color then
            color = frameTbl.color[spellID]
        end
    end
    return color or {r=1,g=1,b=1,a=1}
end

function HUI_CDMCustomAuraBarMixin:GetCustomAuraColor(spellID)
    if not spellID then return end

    local frameName = self.frameName
    local frameIndex = self:GetFrameIndexByName(frameName)
    local profileTable = Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()
    local color

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.auraColor then
            color = frameTbl.auraColor[spellID]
        end
    end
    return color or {r=1,g=1,b=1,a=1}
end

function HUI_CDMCustomAuraBarMixin:GetStages(spellID)
    if not spellID then return end

    local frameIndex = self:GetFrameIndexByName(self.frameName)
    local profileTable = self:GetProfileTable()
    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.stages then
            return frameTbl.stages[spellID]
        end
    end
end

function HUI_CDMCustomAuraBarMixin:GetStageThreshold(spellID)
    if not spellID then return nil end

    local frameIndex = self:GetFrameIndexByName(self.frameName)
    local profileTable = self:GetProfileTable()
    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.stageThresholds then
            return frameTbl.stageThresholds[spellID]
        end
    end
end

function HUI_CDMCustomAuraBarMixin:SetupStageThresholdOverlays(auraButton, spellID, maxStages)
    local thresholds = HUI_CDMThresholdMixin:NormalizeRecord(self:GetStageThreshold(spellID))
    if maxStages then
        thresholds = HUI_CDMThresholdMixin:ValidateList(thresholds, maxStages)
    end

    local overlays = auraButton.ThresholdOverlays
    if not overlays then
        overlays = {}
        auraButton.ThresholdOverlays = overlays
    end

    local count = #(thresholds or {})
    for i = #overlays, count + 1, -1 do
        local extra = overlays[i]
        if extra then
            extra:Hide()
            overlays[i] = nil
        end
    end

    local statusbar = auraButton.Statusbar
    local foreground = Addon:GetStatusBarTextureByName(Addon:GetValue("CurrentCDMCustomFrameStatusbarTexture", nil, self.frameName))

    for i, entry in ipairs(thresholds or {}) do
        local overlay = overlays[i]
        if not overlay then
            local parent = i == 1 and statusbar or overlays[i - 1]
            overlay = CreateFrame("StatusBar", nil, parent)
            overlay:SetFrameLevel(statusbar:GetFrameLevel() + 1)
            overlay:SetStatusBarTexture(foreground)
            overlays[i] = overlay
        else
            overlay:SetStatusBarTexture(foreground)
        end

        overlay:ClearAllPoints()
        overlay:SetAllPoints(statusbar:GetStatusBarTexture())
        local tex = overlay:GetStatusBarTexture()
        if tex then
            tex:SetDrawLayer("ARTWORK", i)
        end
        Addon.PP.DisablePixelSnap(overlay)
        overlay:SetMinMaxValues(entry.value - 1, entry.value)
        overlay:SetValue(0)
        overlay:SetStatusBarColor(entry.r, entry.g, entry.b, entry.a)

        overlay:Show()
    end
end

function HUI_CDMCustomAuraBarMixin:AddStages(numStages, parent)

    local barWidth, barHeight = self:GetBarSize()
    if not parent.StagePipPool then
        parent.StagePipPool = {}
    else
        for _, pip in pairs(parent.StagePipPool) do
            pip:Hide()
        end
    end

    if not numStages or numStages < 2 then return end

    for i=1, numStages-1, 1 do
        local frac = i / numStages
        local off = barWidth * frac
        local stagePipName = "StagePip"..i
        local stagePip = parent.StagePipPool[stagePipName]
        if not stagePip then
            stagePip = parent:CreateTexture(nil, "OVERLAY", nil, 7)
            stagePip:SetSnapToPixelGrid(false)
            stagePip:SetTexelSnappingBias(0)
            parent.StagePipPool[stagePipName] = stagePip
        end

        stagePip:SetColorTexture(0, 0, 0, 1)
        stagePip:ClearAllPoints()
        stagePip:SetSize(1, barHeight)
        stagePip:SetPoint("TOPLEFT", parent, "TOPLEFT", off, 0)
        stagePip:Show()
    end
end

function HUI_CDMCustomAuraBarMixin:SetupAppearance()
    HUI_CDMCustomAuraMixin.SetupAppearance(self)

end

function HUI_CDMCustomAuraBarMixin:GetStatusbar()
    return self.auraStatusbar
end

function HUI_CDMCustomAuraBarMixin:GetBarSize()
    local frameName = self.frameName
    self.barWidth = Addon:GetValue("UseCDMCustomFrameBarWidth", nil, frameName) and Addon:GetValue("CDMCustomFrameBarWidth", nil, frameName) or 100
    self.barHeight = Addon:GetValue("UseCDMCustomFrameBarHeight", nil, frameName) and Addon:GetValue("CDMCustomFrameBarHeight", nil, frameName) or 10

    return self.barWidth, self.barHeight
end

function HUI_CDMCustomAuraBarMixin:GetElementSize()
    return self:GetBarSize()
end

function HUI_CDMCustomAuraBarMixin:GetDurationFormatter()
    local secondsFormatter = Addon.numbersDurationFormatter
    if self.__configName then
        local formatOptions = Addon:GetCooldownFormatOptions(self.__configName)
        secondsFormatter = Addon:GetDurationNumbersFormatter(formatOptions.secondsOnly, formatOptions.minutesFormat, formatOptions.msThreshold)
    end

    local properties = {}
    if self.timerFormat == 4 then
        tinsert(properties, "ElapsedDuration")
    elseif self.timerFormat == 3 then
        tinsert(properties, "RemainingDuration")
        tinsert(properties, "TotalDuration")
    elseif self.timerFormat == 2 then
        tinsert(properties, "TotalDuration")
    else
        tinsert(properties, "RemainingDuration")
    end
    local formatter = #properties > 1 and "{} / {}" or "{}"
    local components = {}
    do
        for i=1, #properties do
            tinsert(components, {
                property = Enum.DurationTextBindingProperty[properties[i] or "ElapsedDuration"],
                formatter = secondsFormatter,
            })
        end
    end

    return {formatString = formatter, components = components}
end

function HUI_CDMCustomAuraBarMixin:ConfigureAuraButton(auraButton, spellID)
	if not auraButton:CanBeAccessedInContext() then
		return
	end

    local frameName = self.frameName

	if not auraButton.Statusbar then
        auraButton.Statusbar = CreateFrame("StatusBar", nil, auraButton)
        auraButton.Statusbar:SetAllPoints(auraButton)
		auraButton.Statusbar:SetFrameLevel(self:GetFrameLevel() + 5)

		auraButton.Statusbar.BarBG = auraButton.Statusbar:CreateTexture(nil, "BACKGROUND")
        auraButton.Statusbar.BarBG:SetAllPoints(auraButton.Statusbar)

        auraButton.Statusbar.Pip = auraButton.Statusbar:CreateTexture(nil, "OVERLAY")

        auraButton.Statusbar.border = Addon.CreateBorder(auraButton.Statusbar, frameName)
        auraButton.Statusbar.border:SetFrameLevel(auraButton.Statusbar:GetFrameLevel() + 100)

		auraButton.Icon = auraButton:CreateTexture(nil, "OVERLAY")
		auraButton.Icon:SetPoint("RIGHT", auraButton.Statusbar, "LEFT", -2, 0)
        
		auraButton.Icon.iconBorder = Addon.CreateBorder(auraButton.Icon, frameName)
		auraButton.Icon.iconBorder:SetFrameLevel(auraButton:GetFrameLevel() + 100)
        local iconBorder = auraButton.Icon.iconBorder
        iconBorder:ClearAllPoints()
        iconBorder:SetPoint("TOPLEFT", auraButton.Icon, "TOPLEFT", 0, 0)
        iconBorder:SetPoint("BOTTOMRIGHT", auraButton.Icon, "BOTTOMRIGHT", 0, 0)

        auraButton.IconRight = auraButton:CreateTexture(nil, "OVERLAY")
        auraButton.IconRight:SetPoint("LEFT", auraButton.Statusbar, "RIGHT", 2, 0)
        auraButton.IconRight:Hide()

        auraButton.IconRight.iconBorder = Addon.CreateBorder(auraButton.IconRight, frameName)
        auraButton.IconRight.iconBorder:SetFrameLevel(auraButton:GetFrameLevel() + 100)
        local iconRightBorder = auraButton.IconRight.iconBorder
        iconRightBorder:ClearAllPoints()
        iconRightBorder:SetPoint("TOPLEFT", auraButton.IconRight, "TOPLEFT", 0, 0)
        iconRightBorder:SetPoint("BOTTOMRIGHT", auraButton.IconRight, "BOTTOMRIGHT", 0, 0)
        iconRightBorder:Hide()

		auraButton.countFrame = CreateFrame("Frame", nil, auraButton)
		auraButton.countFrame:SetAllPoints(auraButton.Statusbar)
        auraButton.countFrame:SetFrameLevel(auraButton.Statusbar:GetFrameLevel() + 2)
		auraButton.countText = auraButton.countFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        auraButton.countText:SetPoint("CENTER", auraButton.Icon, "CENTER", 0, 0)

        auraButton.durationFrame = CreateFrame("Frame", nil, auraButton)
        auraButton.durationFrame:SetAllPoints(auraButton.Statusbar)
        auraButton.durationFrame:SetFrameLevel(auraButton.Statusbar:GetFrameLevel() + 2)
        auraButton.durationText = auraButton.durationFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        auraButton.durationText:SetPoint("RIGHT", auraButton.durationFrame, "RIGHT", -2, 0)

        auraButton.nameFrame = CreateFrame("Frame", nil, auraButton)
        auraButton.nameFrame:SetAllPoints(auraButton.Statusbar)
        auraButton.nameFrame:SetFrameLevel(auraButton.Statusbar:GetFrameLevel() + 2)
        auraButton.nameText = auraButton.nameFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        auraButton.nameText:SetPoint("LEFT", auraButton.nameFrame, "LEFT", 2, 0)
	end

	CreatePandemicElements(auraButton, frameName)
	if auraButton.pandemicBorder then
		local allRegions = {
			auraButton.pandemicBorder,
			auraButton.pandemicGlow,
			auraButton.Icon.pandemicBorder,
			auraButton.Icon.pandemicGlow,
			auraButton.IconRight.pandemicBorder,
			auraButton.IconRight.pandemicGlow,
		}
		local desiredRegions = {
			auraButton.pandemicBorder,
			auraButton.pandemicGlow,
		}
		local iconPos = Addon:GetValue("CurrentCDMCustomFrametBarIconPosition", nil, frameName)
		if iconPos > 1 then
			tinsert(desiredRegions, auraButton.Icon.pandemicBorder)
			tinsert(desiredRegions, auraButton.Icon.pandemicGlow)
		end
		if iconPos == 4 then
			tinsert(desiredRegions, auraButton.IconRight.pandemicBorder)
			tinsert(desiredRegions, auraButton.IconRight.pandemicGlow)
		end
		HUI_CDMCustomFrameCustomized:RefreshPandemicRegions(auraButton, allRegions, desiredRegions, frameName)
	end

	self:CustomizeAuraButton(auraButton, spellID)

	local countFormatter = Addon:GetValue("AlwaysShowStacks", nil, frameName) and { formatter = Addon.defaultCountFormatter } or {}
	auraButton:SetApplicationCount(auraButton.countText, countFormatter)
	auraButton:SetSpellName(auraButton.nameText)

	auraButton:SetMouseMotionEnabled(false)
end

function HUI_CDMCustomAuraBarMixin:CustomizeAuraButton(auraButton, spellID)
	local frameName = self.frameName

    self.auraStatusbar = auraButton.Statusbar

    HUI_CDMCustomFrameCustomized:ApplyBarSize(self, frameName)
    HUI_CDMCustomFrameCustomized:ApplyBarTexture(self, frameName, spellID)
    HUI_CDMCustomFrameCustomized:ApplyPipTexture(self, frameName)

	if auraButton:CanBeAccessedInContext() then
        local iconScale = Addon:GetValue("UseIconScale", nil, frameName) and Addon:GetValue("IconScale", nil, frameName) or 1
        HUI_CDMCustomFrameCustomized:ApplyBarIconSize(auraButton, frameName, iconScale)
        HUI_CDMCustomFrameCustomized:ApplyBarIconMask(auraButton.Icon, frameName)
        if auraButton.IconRight then
            HUI_CDMCustomFrameCustomized:ApplyBarIconMask(auraButton.IconRight, frameName)
        end
        local borderSize = HUI_CDMCustomFrameCustomized:GetBarIconSize(frameName)
        HUI_CDMCustomFrameCustomized:ApplyIconBorder(auraButton.Icon.iconBorder, auraButton.Icon, borderSize)
        if auraButton.IconRight then
            HUI_CDMCustomFrameCustomized:ApplyIconBorder(auraButton.IconRight.iconBorder, auraButton.IconRight, borderSize)
        end
        HUI_CDMCustomFrameCustomized:ApplyBarName(auraButton, frameName)
        HUI_CDMCustomFrameCustomized:ApplyBarDuration(auraButton, frameName, self)
        HUI_CDMCustomFrameCustomized:ApplyStacks(auraButton, frameName)

		if Addon:GetValue("UseCDMBackdrop", nil, frameName) then
			self:RefreshBackdrop(auraButton.Statusbar.border)
			auraButton.Statusbar.border:Show()
		else
			auraButton.Statusbar.border:Hide()
		end

        self:RefreshBackdrop(auraButton.Icon.iconBorder)
        if auraButton.IconRight then
            self:RefreshBackdrop(auraButton.IconRight.iconBorder)
        end

        if not Addon:GetValue("CDMRemovePandemic", nil, frameName) then
            if auraButton.pandemicBorder then
                self:RefreshBackdrop(auraButton.pandemicBorder, auraButton.pColor)
            end
            if auraButton.Icon.pandemicBorder then
                self:RefreshBackdrop(auraButton.Icon.pandemicBorder, auraButton.pColor)
            end
            if auraButton.IconRight.pandemicBorder then
                self:RefreshBackdrop(auraButton.IconRight.pandemicBorder, auraButton.pColor)
            end
        end

        local w, h = self:GetBarSize()
        Addon.PP.Size(auraButton, w, h)

        local iconPos = Addon:GetValue("CurrentCDMCustomFrametBarIconPosition", nil, frameName)
        local useBackdrop = Addon:GetValue("UseCDMBackdrop", nil, frameName)

        if iconPos == 4 then
            auraButton:SetIcon(auraButton.Icon)
            auraButton.Icon:Show()
            auraButton.Icon.iconBorder:SetShown(useBackdrop)
            auraButton.IconRight:Show()
            auraButton.IconRight.iconBorder:SetShown(useBackdrop)
            auraButton.IconRight:SetTexture(spellID and C_Spell.GetSpellTexture(spellID))
        elseif iconPos > 1 then
            auraButton:SetIcon(auraButton.Icon)
            auraButton.Icon:Show()
            auraButton.Icon.iconBorder:SetShown(useBackdrop)
            auraButton.IconRight:Hide()
            auraButton.IconRight.iconBorder:Hide()
        else
            auraButton.Icon.iconBorder:Hide()
            pcall(auraButton.Icon.SetShown, auraButton.Icon, false)
            auraButton.IconRight:Hide()
            auraButton.IconRight.iconBorder:Hide()
            auraButton:ClearIcon()
        end

        local stages = spellID and self:GetStages(spellID)
        if stages and type(stages) == "number" then
            self:AddStages(stages, auraButton.Statusbar)
            auraButton:ClearDurationBar()
            auraButton:SetDurationText(auraButton.durationText, {textFormat = self:GetDurationFormatter()})
            auraButton:SetApplicationBar(auraButton.Statusbar, {maxApplications = stages})
            auraButton.Statusbar.Pip:Hide()
            self:SetupStageThresholdOverlays(auraButton, spellID, stages)
        else
            self:AddStages(nil, auraButton.Statusbar)
            self:SetupStageThresholdOverlays(auraButton, spellID, nil)
            auraButton:ClearApplicationBar()
            auraButton:SetDurationBar(auraButton.Statusbar, {direction = Enum.StatusBarTimerDirection.RemainingTime})
            auraButton:SetDurationText(auraButton.durationText, {textFormat = self:GetDurationFormatter()})
            auraButton.Statusbar.Pip:Show()
        end

	end
end

function HUI_CDMCustomAuraBarMixin:GetPlaceholder(index)
    local frameName = self.frameName
	local placeholder = self.placeholders[index]
	if not placeholder then
		placeholder = CreateFrame("Frame", nil, self)
		placeholder:SetFrameLevel(self.AuraContainer:GetFrameLevel() - 1)
        
		Addon.PP.Size(placeholder, self:GetBarSize())

        placeholder.BarBG = placeholder:CreateTexture(nil, "BACKGROUND")
        placeholder.BarBG:SetAllPoints(placeholder)
        placeholder.BarBG:SetVertexColor(Addon:GetColor("CDMCustomFrameBackgroundColor", "UseCDMCustomFrameBackgroundColor", nil, frameName))
        local background = Addon:GetStatusBarTextureByName(Addon:GetValue("CurrentCDMCustomFrameBackgroundTexture", nil, frameName))
        Addon:SetTexture(placeholder.BarBG, background)

		placeholder.Icon = placeholder:CreateTexture(nil, "BACKGROUND")
        local iconScale = Addon:GetValue("UseIconScale", nil, frameName) and Addon:GetValue("IconScale", nil, frameName) or 1
        HUI_CDMCustomFrameCustomized:ApplyBarIconSize(placeholder, frameName, iconScale)

        placeholder.borderFrame = CreateFrame("Frame", nil, placeholder)
        placeholder.borderFrame:SetAllPoints(placeholder)
        placeholder.borderFrame:SetFrameLevel(self.AuraContainer:GetFrameLevel() + 100)

        placeholder.borderIcon = CreateFrame("Frame", nil, placeholder)
        placeholder.borderIcon:SetAllPoints(placeholder.Icon)
        placeholder.borderIcon:SetFrameLevel(self.AuraContainer:GetFrameLevel() + 100)

        placeholder.border = Addon.CreateBorder(placeholder, frameName)
        placeholder.border:SetFrameLevel(self.AuraContainer:GetFrameLevel() + 100)
        HUI_CDMCustomFrameCustomized:SetupBackdrop(placeholder.border, frameName)

		placeholder.iconBorder = Addon.CreateBorder(placeholder.Icon, frameName)
        placeholder.iconBorder:SetFrameLevel(self.AuraContainer:GetFrameLevel() + 100)
		HUI_CDMCustomFrameCustomized:SetupBackdrop(placeholder.iconBorder, frameName)
        local iconBorder = placeholder.iconBorder
        iconBorder:ClearAllPoints()
        iconBorder:SetPoint("TOPLEFT", placeholder.Icon, "TOPLEFT", 0, 0)
        iconBorder:SetPoint("BOTTOMRIGHT", placeholder.Icon, "BOTTOMRIGHT", 0, 0)

        placeholder.IconRight = placeholder:CreateTexture(nil, "BACKGROUND")
        placeholder.iconRightBorder = Addon.CreateBorder(placeholder.IconRight, frameName)
        placeholder.iconRightBorder:SetFrameLevel(self.AuraContainer:GetFrameLevel() + 100)
		HUI_CDMCustomFrameCustomized:SetupBackdrop(placeholder.iconRightBorder, frameName)
        local iconRightBorder = placeholder.iconRightBorder
        iconRightBorder:ClearAllPoints()
        iconRightBorder:SetPoint("TOPLEFT", placeholder.IconRight, "TOPLEFT", 0, 0)
        iconRightBorder:SetPoint("BOTTOMRIGHT", placeholder.IconRight, "BOTTOMRIGHT", 0, 0)
        HUI_CDMCustomFrameCustomized:ApplyBarIconSize(placeholder, frameName, iconScale)

        self.placeholders[index] = placeholder
	end
	return placeholder
end

function HUI_CDMCustomAuraBarMixin:UpdatePlaceholder(placeholder, spellID)
    local frameName = self.frameName
	Addon.PP.Size(placeholder, self:GetBarSize())
	placeholder.Icon:SetTexture(C_Spell.GetSpellTexture(spellID))
    if placeholder.IconRight then
        placeholder.IconRight:SetTexture(C_Spell.GetSpellTexture(spellID))
    end
    local iconScale = Addon:GetValue("UseIconScale", nil, frameName) and Addon:GetValue("IconScale", nil, frameName) or 1
    HUI_CDMCustomFrameCustomized:ApplyBarIconSize(placeholder, frameName, iconScale)
    HUI_CDMCustomFrameCustomized:ApplyBarIconMask(placeholder.Icon, frameName)
    if placeholder.IconRight then
        HUI_CDMCustomFrameCustomized:ApplyBarIconMask(placeholder.IconRight, frameName)
    end
    local borderSize = HUI_CDMCustomFrameCustomized:GetBarIconSize(frameName)
    HUI_CDMCustomFrameCustomized:ApplyIconBorder(placeholder.iconBorder, placeholder.Icon, borderSize)
    if placeholder.iconRightBorder then
        HUI_CDMCustomFrameCustomized:ApplyIconBorder(placeholder.iconRightBorder, placeholder.IconRight, borderSize)
    end

    placeholder.BarBG:SetVertexColor(Addon:GetColor("CDMCustomFrameBackgroundColor", "UseCDMCustomFrameBackgroundColor", nil, frameName))
    local background = Addon:GetStatusBarTextureByName(Addon:GetValue("CurrentCDMCustomFrameBackgroundTexture", nil, frameName))
    Addon:SetTexture(placeholder.BarBG, background)

    self:RefreshBackdrop(placeholder.border)
    self:RefreshBackdrop(placeholder.iconBorder)
    if placeholder.iconRightBorder then
        self:RefreshBackdrop(placeholder.iconRightBorder)
    end

    if Addon:GetValue("UseCDMBackdrop", nil, frameName) then
        placeholder.border:Show()
        placeholder.iconBorder:Show()
        if placeholder.iconRightBorder then
            placeholder.iconRightBorder:Show()
        end
    else
        placeholder.border:Hide()
        placeholder.iconBorder:Hide()
        if placeholder.iconRightBorder then
            placeholder.iconRightBorder:Hide()
        end
    end

    local iconPos = Addon:GetValue("CurrentCDMCustomFrametBarIconPosition", nil, frameName)
    if iconPos == 4 then
        placeholder.Icon:Show()
        if placeholder.IconRight then
            placeholder.IconRight:Show()
        end
    elseif iconPos > 1 then
        placeholder.Icon:Show()
        if placeholder.IconRight then
            placeholder.IconRight:Hide()
            if placeholder.iconRightBorder then
                placeholder.iconRightBorder:Hide()
            end
        end
    else
        placeholder.Icon:Hide()
        placeholder.iconBorder:Hide()
        if placeholder.IconRight then
            placeholder.IconRight:Hide()
            if placeholder.iconRightBorder then
                placeholder.iconRightBorder:Hide()
            end
        end
    end
end

function HUI_CDMCustomAuraBarMixin:ResizeFrame(auraCount)
	auraCount = auraCount or 0

    local barWidth, barHeight = self:GetBarSize()

	if auraCount == 0 then
		Addon.PP.Size(self, barWidth, barHeight)
		return
	end

	local stride = math.min(self.stride, auraCount)
	local numRows = math.ceil(auraCount / stride)

	local spacing = Addon.PP.Scale(self.spacing or 0)

	local lineSize = (stride * barWidth) + ((stride - 1) * spacing)
	local wrapSize = (numRows * barHeight) + ((numRows - 1) * spacing)

	local width, height
	if self.isHorizontal then
		width, height = lineSize, wrapSize
	else
        lineSize = (numRows * barWidth) + ((numRows - 1) * spacing)
	    wrapSize = (stride * barHeight) + ((stride - 1) * spacing)
		width, height = lineSize, wrapSize
	end

	Addon.PP.Size(self, width, height)
end

function HUI_CDMCustomAuraBarMixin:RefreshAllAuraBars()
    local profileTable = self:GetProfileTable()
    local frames = profileTable and profileTable["CDMCustomFrames"]
    if not frames then return end

    for _, data in ipairs(frames) do
        if data and data.label then
            local frame = _G[data.label]
            if frame and frame.RefreshAuraButtons then
                frame:RefreshAuraButtons()
            end
        end
    end
end

local scaleRefreshScheduled = false

local function ScheduleAuraBarsRefresh()
    if scaleRefreshScheduled then return end
    scaleRefreshScheduled = true
    C_Timer.After(0, function()
        scaleRefreshScheduled = false
        HUI_CDMCustomAuraBarMixin:RefreshAllAuraBars()
    end)
end

Addon:RegisterEvent("UI_SCALE_CHANGED", ScheduleAuraBarsRefresh, "CooldownManagerCustomAuraBar")
Addon:RegisterEvent("DISPLAY_SIZE_CHANGED", ScheduleAuraBarsRefresh, "CooldownManagerCustomAuraBar")
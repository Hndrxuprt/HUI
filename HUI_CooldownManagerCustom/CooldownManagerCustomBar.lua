local Addon = _G.HUI

HUI_CDMCustomBarMixin = CreateFromMixins(HUI_CDMCustomItemMixin)

HUI_CDMCustomBarFrameMixin = CreateFromMixins(HUI_CDMCustomFrameMixin)

function HUI_CDMCustomBarMixin:OnLoad()

    local cooldownFrame = self:GetCooldownFrame()
    local auraCooldown = self:GetAuraFrame()

    cooldownFrame:SetScript("OnCooldownDone", GenerateClosure(self.OnCooldownDone, self))
    auraCooldown:SetScript("OnCooldownDone", GenerateClosure(self.OnAuraDone, self))
    self:SetMouseClickEnabled(false)

    self:SetMouseClickEnabled(false)
    self.Bar.Pip:ClearAllPoints()
    self.Bar.Pip:SetPoint("CENTER", self.Bar:GetStatusBarTexture(), "RIGHT", 0, 0)
    self.spark = self.Bar.Pip
    self.spark:Hide()
    self.Bar:SetMinMaxValues(0, 0)
    self.Bar:SetValue(self.value or 0)

    self.color = self:GetCustomColor()
    self.auraColor = self:GetCustomAuraColor()
end

function HUI_CDMCustomBarFrameMixin:RefreshLayout()
    HUI_CDMCustomFrameMixin.RefreshLayout(self)

    HUI_CDMCustomFrameCustomized:RefreshItemSize(self, self.frameName)
    HUI_CDMCustomFrameCustomized:RefreshBarTextures(self, self.frameName)
    HUI_CDMCustomFrameCustomized:RefreshBarIconSize(self, self.frameName)
end

function HUI_CDMCustomBarMixin:RefreshData()
    self:RefreshSpellCooldownInfo()
    if self.type == "item" and IsHealthstoneItem(self.itemID) then
        C_Timer.After(0.5, function()
            self:RefreshCount()
            self:RefreshVisibility()
        end)
    else
        self:RefreshCount()
        self:RefreshVisibility()
    end
    self:RefreshBackdrop()
    self:RefreshIconColor()
end

function HUI_CDMCustomBarMixin:GetStages()
    if not self.spellID then return end

    local spellID = self.itemID or self.baseSpellID or self.spellID
    local frameName = self.parentName
    if frameName then
        local frameIndex = _G[frameName]:GetFrameIndexByName(frameName)
        local profileTable = Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()
        if profileTable["CDMCustomFrames"] then
            local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
            if frameTbl and frameTbl.stages then
                return frameTbl.stages[spellID]
            end
        end
    end
end

function HUI_CDMCustomBarMixin:GetCustomColor()
    if not self.spellID then return end

    local spellID = self.itemID or self.baseSpellID or self.spellID
    local frameName = self.parentName
    local frameIndex = _G[frameName]:GetFrameIndexByName(frameName)
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

function HUI_CDMCustomBarMixin:GetCustomAuraColor()
    if not self.spellID then return end
    
    local spellID = self.itemID or self.baseSpellID or self.spellID
    local frameName = self.parentName
    local frameIndex = _G[frameName]:GetFrameIndexByName(frameName)
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

function HUI_CDMCustomBarMixin:GetBarDisplayType()
    if not self.spellID then return end

    local spellID = self.itemID or self.baseSpellID or self.spellID
    local frameName = self.parentName
    local frameIndex = _G[frameName]:GetFrameIndexByName(frameName)
    local profileTable = Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()

    local displayType

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.displayTypes then
            displayType = frameTbl.displayTypes[spellID]
        end
    end

    return displayType or 3
end

function HUI_CDMCustomBarMixin:RefreshBackdrop()
    HUI_CDMCustomItemMixin.RefreshBackdrop(self)

    if not self.BarBorder then return end

    if self.isOnAuraTimer then
        if Addon:GetValue("UseCDMBackdropAuraColor", nil, self.parentName) then
            self.BarBorder:SetBackdropBorderColor(Addon:GetRGBA("CDMBackdropAuraColor", nil, self.parentName))
        end
    else
        if Addon:GetValue("UseCDMBackdropColor", nil, self.parentName) then
            self.BarBorder:SetBackdropBorderColor(Addon:GetRGBA("CDMBackdropColor", nil, self.parentName))
        end
    end
end

function HUI_CDMCustomBarMixin:RefreshVisibility()
    local showAura = self:ShouldShowAura()
    local showCooldown = self:ShouldShowCooldown()

    if not showCooldown then
        self.isOnActualCooldown = false
    end
    if not showAura then
        self.isOnAuraTimer = false
    end
    HUI_CDMCustomItemMixin.RefreshVisibility(self)
end

function HUI_CDMCustomBarMixin:RefreshCount()
    HUI_CDMCustomItemMixin.RefreshCount(self)
end

function HUI_CDMCustomBarMixin:RefreshSpellTexture()
    local spellTexture = self:GetSpellTexture()

    local icon = self.Icon.Icon or self.Icon
    icon:SetTexture(spellTexture)

    self:RefreshSpellName()
end

function HUI_CDMCustomBarMixin:OnCooldownDone()
    if not self.isOnAuraTimer or not self:ShouldShowAura() then

        self.Bar.Duration:Hide()
        self.Bar:SetMinMaxValues(0, 0)
        self.Bar:SetValue(self.value or 0)

        self.casting = false
        self.spark:Hide()
    end

    HUI_CDMCustomItemMixin.OnCooldownDone(self)
    
end

function HUI_CDMCustomBarMixin:OnAuraDone()

    HUI_CDMCustomItemMixin.OnAuraDone(self)
    --[[ if not self.isOnActualCooldown then
        self:OnCooldownDone()
    end ]]
end

function HUI_CDMCustomBarMixin:ShouldShowAura()
    return self.barDisplayType and self.barDisplayType > 1
end

function HUI_CDMCustomBarMixin:ShouldShowCooldown()
    return self.barDisplayType and (self.barDisplayType == 1 or self.barDisplayType == 3)
end

function HUI_CDMCustomBarMixin:RefreshSpellCooldownInfo()
    HUI_CDMCustomItemMixin.RefreshSpellCooldownInfo(self)

    self.stages = self:GetStages()

    local showAura = self:ShouldShowAura()
    local showCooldown = self:ShouldShowCooldown()

    local statusbar = self.Bar
    self.auraColor = self.auraColor or self:GetCustomAuraColor()
    self.color = self.color or self:GetCustomColor()

    if not self.stages then

        local isReverseFill = false
        local timerInterpolation = Enum.StatusBarInterpolation.Immediate
        local timerFillDirection = Enum.StatusBarTimerDirection.RemainingTime

        statusbar:SetReverseFill(isReverseFill)

        if not self.DurationTextBinding then
            self.DurationTextBinding = C_DurationUtil.CreateDurationTextBinding()
        else
            self.DurationTextBinding:SetToDefaults()
        end
        self.DurationTextBinding:SetFontString(statusbar.Duration)
        self.DurationTextBinding:SetZeroDurationText("zero")
        self.DurationTextBinding:SetExpiredText("expired")

        if showAura and self.isOnAuraTimer then
            self.barType = "aura"

            local fakeAuraDurObj = self.auraDurationObj

            if fakeAuraDurObj then
                statusbar:SetTimerDuration(fakeAuraDurObj,timerInterpolation,timerFillDirection)
                self.DurationTextBinding:SetDuration(fakeAuraDurObj)
            end
            statusbar:SetStatusBarColor(self.auraColor.r, self.auraColor.g, self.auraColor.b, self.auraColor.a)

        elseif showCooldown and (self.isOnActualCooldown or self.isOnChargeCooldown) then
            self.barType = "cooldown"

            if self.type == "spell" then
                local durationObject = self:GetCooldownDurationObj()
                statusbar:SetTimerDuration(durationObject,timerInterpolation,timerFillDirection)
                self.DurationTextBinding:SetDuration(durationObject)
            else
                local cooldownInfo = self:GetCooldownInfo()

                local durationObject = C_DurationUtil.CreateDuration()
                if cooldownInfo then
                    durationObject:SetTimeFromStart(cooldownInfo.startTime or 0, cooldownInfo.duration or 0)
                end

                statusbar:SetTimerDuration(durationObject,timerInterpolation,timerFillDirection)
                self.DurationTextBinding:SetDuration(durationObject)
            end
            statusbar:SetStatusBarColor(self.color.r, self.color.g, self.color.b, self.color.a)

        end
        statusbar.Duration:Show()
        
        local parentFrame = _G[self.parentName]
        local secondsFormatter = parentFrame.bindingTextFormatter or Addon.defaultDurationFormatter

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
        self.DurationTextBinding:SetTextFormat(formatter, components)
        self.DurationTextBinding:SetUpdateInterval(0)
        --self.DurationTextBinding:SetFormatter(self.secondsFormatter)
        self.DurationTextBinding:SetEnabled(true)
        self.DurationTextBinding:Enable()

        local cooldownFrame = self:GetCooldownFrame()
        local auraCooldown = self:GetAuraFrame()

        --cooldownFrame:Hide()
        cooldownFrame:SetAlpha(0)
        --auraCooldown:Hide()
        auraCooldown:SetAlpha(0)
        --self.DurationTextBinding:Enable()
    end
end

function HUI_CDMCustomBarMixin:RefreshSpellName()
    self.Bar.Name:SetText(self:GetSpellName())
end

function HUI_CDMCustomBarMixin:AddStages(numStages)

    local barWidth = self.Bar:GetWidth()
    if not self.StagePipPool then
        self.StagePipPool = {}
    else
        for _, pip in pairs(self.StagePipPool) do
            pip:Hide()
        end
    end

    if not numStages or numStages < 2 then return end

    for i=1, numStages-1, 1 do
        local offset = (barWidth / numStages) * i
        local stagePipName = "StagePip"..i
        local stagePip = self.StagePipPool[stagePipName]
        if not stagePip then
            stagePip = CreateFrame("FRAME", nil, self.Bar, "HUI_CDMCustomBarStagePipTemplate")
            self.StagePipPool[stagePipName] = stagePip
        end
        
        if stagePip then
            stagePip:ClearAllPoints()
            stagePip:SetPoint("CENTER", self.Bar, "LEFT", offset, 0)
            stagePip:SetSize(2, self:GetHeight())
            stagePip.BasePip:SetVertexColor(0, 0, 0, 1)
            stagePip:Show()
        end
    end
end

function HUI_CDMCustomBarMixin:GetSpellName()
    if self:ShouldShowAura() and self.auraData then
        return self.auraData.name
    end

    if self.type ~= "spell" and self.itemID then
        return C_Item.GetItemNameByID(self.itemID)
    elseif self.type == "spell" then
        return C_Spell.GetSpellName(self.spellID)
    end

    return ""
end

function HUI_CDMCustomBarMixin:GetStatusbar()
    return self.Bar
end

function HUI_CDMCustomBarMixin:RefreshIconDesaturation(desaturated)
    
end

--[[ function HUI_CDMCustomBarMixin:ConfigureAuraContainer(auraButton)
    
    local container = self:GetAuraContainer()

    local width = Addon:GetValue("UseCDMCustomFrameBarWidth", nil, self.parentName) and Addon:GetValue("CDMCustomFrameBarWidth", nil, self.parentName) or 100
    local height = Addon:GetValue("UseCDMCustomFrameBarHeight", nil, self.parentName) and Addon:GetValue("CDMCustomFrameBarHeight", nil, self.parentName) or 10

    if not self.realAuraFrame then
        self.realAuraFrame = CreateFrame("Frame", nil, auraButton)
        self.realAuraFrame:SetAllPoints(self.Bar)
        self.realAuraFrame:SetFrameLevel(self:GetFrameLevel() + 6)

        self.realAuraStatusbar = CreateFrame("StatusBar", nil, auraButton)
        self.realAuraStatusbar:SetFrameLevel(self:GetFrameLevel() + 5)
        self.realAuraStatusbar:SetPoint("CENTER",self.Bar,"CENTER" )
        self.realAuraStatusbar:SetSize(width, height)

        local foreground = Addon:GetStatusBarTextureByName(Addon:GetValue("CurrentCDMCustomFrameStatusbarTexture", nil, self.parentName))
        local color = self:GetCustomColor() or { r=1, g=1, b=1, a=1 }
        self.realAuraStatusbar:SetStatusBarTexture(foreground)
        self.realAuraStatusbar:SetStatusBarColor(color.r, color.g, color.b, color.a)
    end

    auraButton:SetDurationBar(self.realAuraStatusbar, {direction = Enum.StatusBarTimerDirection.RemainingTime})
    auraButton:SetSize(width, height)

    local auraUnit = self:GetAuraUnit()
    container:SetUnit(auraUnit)

    self:AnchorAuraContainer()

    return auraButton
end ]]

function HUI_CDMCustomBarFrameMixin:OnLoad()
    self:SetMovable(true)

    self.frameName = self:GetName()

    local profileTable = Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()

    local frameIndex = self:GetFrameIndexByName(self.frameName)
    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        self.itemList = frameTbl.trackedIDs or {}
        self.displayName = frameTbl.name
    end

    self.hideInactive = false

    local itemResetCallback = function(pool, itemFrame)
		Pool_HideAndClearAnchors(pool, itemFrame)
		itemFrame.layoutIndex = nil
        itemFrame.fakeAura = nil
        itemFrame.slotID = nil
        itemFrame.itemID = nil
        itemFrame.spellID = nil
        itemFrame.baseSpellID = nil
        itemFrame.count = nil
        itemFrame.isOnAuraTimer = nil
        itemFrame.isOnActualCooldown = nil
        itemFrame.isOnChargeCooldown = nil
        itemFrame.stages = nil
        itemFrame.barType = nil
        itemFrame.barDisplayType = nil
        itemFrame.color = nil
        itemFrame.auraColor = nil
        itemFrame.timerFormat = nil
        if itemFrame.DurationTextBinding then
            itemFrame.DurationTextBinding:SetEnabled(false)
            itemFrame.DurationTextBinding = nil
        end
        local cooldownFrame = itemFrame:GetCooldownFrame()
        local auraCooldown = itemFrame:GetAuraFrame()
        CooldownFrame_Clear(cooldownFrame)
        CooldownFrame_Clear(auraCooldown)
        itemFrame.Bar:SetMinMaxValues(0, 0)
        itemFrame.Bar:SetValue(0)
        itemFrame.Bar.Duration:Hide()
        if itemFrame.spark then
            itemFrame.spark:Hide()
        end
        itemFrame:UnregisterAllEvents()
        itemFrame.registeredEvents = nil
        itemFrame.auraUnit = nil
	end

    self.itemPool = CreateFramePool("Frame", self.Container, self.itemTemplate, itemResetCallback)

    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.EndOrderChange", self.OnCustomItemListReorderEnded)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.ItemAdded", self.OnCustomItemListItemUpdate)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.ItemRemoved", self.OnCustomItemListItemUpdate)
    self:AddDynamicEventMethod(EventRegistry, "EditMode.Enter", self.OnEditModeEnter)
    self:AddDynamicEventMethod(EventRegistry, "EditMode.Exit", self.OnEditModeExit)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.FakeAuraAdded", self.OnFakeAuraAdded)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.FakeAuraTypeChanged", self.OnFakeAuraTypeChanged)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.UpdateFrame", self.OnFrameUpdate)

    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.StagesAdded", self.OnStagesAdded)

    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AuraUnitChanged", self.OnAuraOverrideChanged)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AuraTypeChanged", self.OnAuraOverrideChanged)

    C_Timer.After(0.5, function()
        self:RefreshLayout()
    end)

    self:SetMouseClickEnabled(false)

    Addon:BarsFadeAnim(self)

    self.lastRunTime = 0
end

function HUI_CDMCustomBarFrameMixin:OnAcquireItemFrame(itemFrame)
    HUI_CDMCustomFrameMixin.OnAcquireItemFrame(self, itemFrame)

    itemFrame.barDisplayType = itemFrame:GetBarDisplayType()

    --print("OnAcquireItemFrame", itemFrame.barDisplayType)
end

function HUI_CDMCustomBarFrameMixin:OnStagesAdded(spellID, newStages)
    for itemFrame in self.itemPool:EnumerateActive() do
        if itemFrame.itemID == spellID or itemFrame.spellID == spellID then
            itemFrame.stages = newStages
            itemFrame:RefreshData()
        end
    end
end

function HUI_CDMCustomBarFrameMixin:OnAuraOverrideChanged(spellID)
    for itemFrame in self.itemPool:EnumerateActive() do
        if itemFrame.itemID == spellID or itemFrame.spellID == spellID or itemFrame.baseSpellID == spellID then
            itemFrame:InvalidateAura()
            itemFrame:AddAuraSlot()
            local container = itemFrame:GetAuraContainer()
            if container then
                container:SetUnit(itemFrame:GetAuraUnit())
                container:UpdateAllAuras()
            end
        end
    end
end

function HUI_CDMCustomBarFrameMixin:OnCustomItemListReorderEnded(itemList, frameName)
    if self:GetName() ~= frameName then return end
    self.itemList = CopyTable(itemList)
    self:RefreshLayout()
end

function HUI_CDMCustomBarFrameMixin:OnCustomItemListItemUpdate(itemList, frameName)
    if self:GetName() ~= frameName then return end
    self.itemList = CopyTable(itemList)
    self:RefreshLayout()
end
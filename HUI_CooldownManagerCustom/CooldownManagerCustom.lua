local Addon = _G.HUI

local profileTable

local pinnedFrameLabel

Addon.SPELLID_TO_AURASPELLID = {
    
}

local function BuildSpellIDToAuraSpellID()
    for cdID, data in pairs(CooldownViewerSettings:GetDataProvider():GetDisplayData().cooldownInfoByID) do
        local spellID = data.overrideTooltipSpellID or data.overrideSpellID or data.spellID
        if spellID and not issecretvalue(spellID) then
            if not Addon.SPELLID_TO_AURASPELLID[spellID] then
                Addon.SPELLID_TO_AURASPELLID[spellID] = {}
            end
            if data.hasAura then
                Addon.SPELLID_TO_AURASPELLID[spellID].linkedSpellIDs = #data.linkedSpellIDs > 0 and data.linkedSpellIDs or {[1] = spellID}
            elseif data.selfAura then
                Addon.SPELLID_TO_AURASPELLID[spellID].linkedSpellIDs = {[1] = spellID}
            end
            Addon.SPELLID_TO_AURASPELLID[spellID].auraUnit = C_Spell.IsSpellHelpful(spellID) and "player" or "target"
        end
    end
end

local CooldownManagerFrames = {
    "BuffIconCooldownViewer",
    "BuffBarCooldownViewer",
    "EssentialCooldownViewer",
    "UtilityCooldownViewer",
}

local isBeta = Addon.IsBeta

local function IsOnGCD()
    local gcdInfo = C_Spell.GetSpellCooldown(61304)

    local isOnGCD = false
    if gcdInfo and gcdInfo.duration ~= 0 then
        isOnGCD = true
    end

    return isOnGCD
end

HUI_CDMCustomItemMixin = {}

function HUI_CDMCustomItemMixin:GetAuraFrame()
    return self.Icon.AuraCooldown or self.AuraCooldown
end
function HUI_CDMCustomItemMixin:GetCooldownFrame()
    return self.Icon.Cooldown or self.Cooldown
end
function HUI_CDMCustomItemMixin:OnLoad()
    local cooldownFrame = self:GetCooldownFrame()
    local auraCooldown = self:GetAuraFrame()
    cooldownFrame:SetScript("OnCooldownDone", GenerateClosure(self.OnCooldownDone, self))
    auraCooldown:SetScript("OnCooldownDone", GenerateClosure(self.OnAuraDone, self))
    self:SetMouseClickEnabled(false)
    if self.SetupPingable then
        self:SetupPingable()
    end
end

function HUI_CDMCustomItemMixin:OnShow()
    --[[ if self:GetSpellID() then
        C_Timer.After(0, function()
            Addon:DebugPrint("OnShow", self.spellID)
            self:RefreshData()
        end)
    end ]]
end

local function IsHealthstoneCreateCast(spellID)
    if issecretvalue(spellID) then
        return false
    end
    if spellID == 6201 then
        return true
    end
    return false
end

local function IsHealthstoneItem(spellID)
    local healthstoneIDs = {
        [1] = 224464,
        [2] = 5512,
    }
    for i, id in ipairs(healthstoneIDs) do
        if spellID == id then
            return true, healthstoneIDs
        end
    end

    return false
end

function HUI_CDMCustomItemMixin:OnEvent(event, ...)
end

function HUI_CDMCustomItemMixin:OnEnter()
    local showTooltip = false
    if showTooltip then
        local tooltip = GetAppropriateTooltip()
        GameTooltip_SetDefaultAnchor(tooltip, self)
        if self.itemID then
            tooltip:SetItemByID(self.itemID)
        else
            tooltip:SetSpellByID(self.spellID, false)
        end
        tooltip:Show()
    end

    local frame = _G[self.parentName]

    if frame.fade then
        Addon:Fade(frame, true)
    end
end

function HUI_CDMCustomItemMixin:OnLeave()
    GetAppropriateTooltip():Hide()

    local frame = _G[self.parentName]

    if frame.fade then
        Addon:Fade(frame, false)
    end
end

function HUI_CDMCustomItemMixin:SetSlotID(slotID, fallbackItemID)
    local itemInfo = C_TooltipInfo.GetInventoryItem("player", slotID)
    local itemID = itemInfo and itemInfo.id or GetInventoryItemID("player", slotID) or fallbackItemID
    local spellName, spellID
    if itemID then
        spellName, spellID = C_Item.GetItemSpell(itemID)
    end

    self.count = 0
    self.slotID = slotID
    self.itemID = itemID
    self.spellID = spellID
    self.baseSpellID = nil
    self.overrideID = nil
    self:InvalidateAura()
end

function HUI_CDMCustomItemMixin:SetSpellID(spellID, baseSpellID)
    self.slotID = nil
    self.itemID = nil
    self.spellID = spellID
    self.baseSpellID = baseSpellID
    self.count = 0
    self.overrideID = C_Spell.GetOverrideSpell(spellID)
    --self:FindAuraForCurrentSpellID()

    self.rangeCheckSpellID = spellID
    self.spellOutOfRange = nil
    if C_Spell.SpellHasRange(spellID) then
        C_Spell.EnableSpellRangeCheck(spellID, true)
    end
    self:InvalidateAura()
end

function HUI_CDMCustomItemMixin:SetItemID(itemID)
    local spellName, spellID = C_Item.GetItemSpell(itemID)

    self.slotID = nil
    self.itemID = itemID
    self.spellID = spellID
    self.baseSpellID = nil
    self.overrideID = nil
    self:InvalidateAura()
end

function HUI_CDMCustomItemMixin:SetPotionType(potType)
    self.slotID = nil
    self.itemID = nil
    self.spellID = nil
    self.baseSpellID = nil
    self.overrideID = nil
    self.count = 0
    self.potType = potType
    self:UpdatePotionItem()
    self:InvalidateAura()
end

function HUI_CDMCustomItemMixin:GetLastUsedPotion()
    if self.type ~= "potion" or not self.potType then return nil end
    local parentFrame = self.parentName and _G[self.parentName]
    if not parentFrame or not parentFrame.lastUsedPotions then return nil end
    return parentFrame.lastUsedPotions[self.potType]
end

function HUI_CDMCustomItemMixin:FindAvailablePotion(items, kindFilter)
    for _, id in ipairs(items) do
        if not kindFilter or (Addon.Potions.byItemID[id] and Addon.Potions.byItemID[id].kind == kindFilter) then
            local count = C_Item.GetItemCount(id, nil, true) or 0
            if count > 0 then
                return id
            end
        end
    end
    return nil
end

function HUI_CDMCustomItemMixin:FindAvailablePotionWithinRank(items, kindKey)
    local index = 1
    while index <= #items do
        local segInfo = Addon.Potions.byItemID[items[index]]
        local segSource = segInfo and segInfo.source
        local segQuality = segInfo and segInfo.quality
        local segEnd = index
        while segEnd < #items do
            local nextInfo = Addon.Potions.byItemID[items[segEnd + 1]]
            if not nextInfo or nextInfo.source ~= segSource or nextInfo.quality ~= segQuality then
                break
            end
            segEnd = segEnd + 1
        end
        for i = index, segEnd do
            if Addon.Potions.byItemID[items[i]].kind == kindKey then
                local count = C_Item.GetItemCount(items[i], nil, true) or 0
                if count > 0 then
                    return items[i]
                end
            end
        end
        for i = index, segEnd do
            local count = C_Item.GetItemCount(items[i], nil, true) or 0
            if count > 0 then
                return items[i]
            end
        end
        index = segEnd + 1
    end
    return nil
end

function HUI_CDMCustomItemMixin:UpdatePotionItem()
    if self.type ~= "potion" then return end
    local potInfo = Addon.Potions.byType[self.potType]
    if not potInfo then return end

    local kindKey = Addon:GetValue("CDMCustomPotionKind_"..self.potType, nil, self.parentName)
    local priorityType = Addon:GetValue("CDMCustomPotionPriorityType", nil, self.parentName) or 1

    local itemID
    if kindKey then
        if priorityType == 3 then
            itemID = self:FindAvailablePotion(potInfo.items, kindKey)
        elseif priorityType == 2 then
            itemID = self:FindAvailablePotion(potInfo.items, kindKey) or self:FindAvailablePotion(potInfo.items)
        else
            itemID = self:FindAvailablePotionWithinRank(potInfo.items, kindKey)
        end
    else
        itemID = self:FindAvailablePotion(potInfo.items)
    end
    if not itemID then
        if kindKey and priorityType == 3 then
            for _, id in ipairs(potInfo.items) do
                if Addon.Potions.byItemID[id] and Addon.Potions.byItemID[id].kind == kindKey then
                    itemID = id
                    break
                end
            end
        end
        if not itemID then
            itemID = potInfo.items[1]
        end
    end

    self.itemID = itemID
    if itemID then
        local spellName, spellID = C_Item.GetItemSpell(itemID)
        self.spellID = spellID
    else
        self.spellID = nil
    end
end

function HUI_CDMCustomItemMixin:OnPotionUsed(category, usedItemID, usedSpellID)
    if self.type ~= "potion" then return end
    local potInfo = Addon.Potions.byType[self.potType]
    if not potInfo or potInfo.spellCategory ~= category then return end

    if usedItemID then
        local usedPotInfo = Addon.Potions.byItemID[usedItemID]
        if usedPotInfo and usedPotInfo.potType == self.potType then
            local parentFrame = self.parentName and _G[self.parentName]
            if parentFrame and parentFrame.lastUsedPotions then
                local lastUsed = parentFrame.lastUsedPotions[self.potType] or {}
                if lastUsed.spellID ~= usedSpellID then
                    self.__auraFilterDirty = true
                end
                lastUsed.itemID = usedItemID
                lastUsed.spellID = usedSpellID
                parentFrame.lastUsedPotions[self.potType] = lastUsed
            end
        end
    end

    self:UpdatePotionItem()
    self:RefreshData()
end

function HUI_CDMCustomItemMixin:OnPotionCountChanged()
    if self.type ~= "potion" then return end
    self:UpdatePotionItem()
    self:RefreshData()
end

function HUI_CDMCustomItemMixin:SchedulePotionUpdate()
    if self.type ~= "potion" or self.__potionUpdatePending then return end
    self.__potionUpdatePending = true
    RunNextFrame(function()
        self.__potionUpdatePending = nil
        self:UpdatePotionItem()
        self:RefreshData()
    end)
end

function HUI_CDMCustomItemMixin:GetSpellID()
    if self.baseSpellID then
        return self.baseSpellID
    end

    return self.spellID
end

function HUI_CDMCustomItemMixin:GetCooldownInfo()
    if self.type == "item" or self.type == "potion" then
        if not self.itemID then
            self.cooldownInfo = nil
            return self.cooldownInfo
        end
        local start, duration, enable = C_Item.GetItemCooldown(self.itemID)
        local cooldownInfo = self.__cooldownInfoBuf
        if not cooldownInfo then
            cooldownInfo = {}
            self.__cooldownInfoBuf = cooldownInfo
        end
        cooldownInfo.startTime = start
        cooldownInfo.duration = duration
        cooldownInfo.enable = enable
        self.cooldownInfo = cooldownInfo
    elseif self.type == "spell" then
        self.overrideID = C_Spell.GetOverrideSpell(self.spellID)
        local spellID = self.overrideID or self.spellID
        self.cooldownInfo = C_Spell.GetSpellCooldown(spellID)
    elseif self.type == "slot" then
        --self.cooldownInfo = C_Spell.GetSpellCooldown(self:GetSpellID())
        local start, duration, enable = GetInventoryItemCooldown("player", self.slotID)
        local cooldownInfo = self.__cooldownInfoBuf
        if not cooldownInfo then
            cooldownInfo = {}
            self.__cooldownInfoBuf = cooldownInfo
        end
        cooldownInfo.startTime = start
        cooldownInfo.duration = duration
        cooldownInfo.enable = enable
        self.cooldownInfo = cooldownInfo
    end
    return self.cooldownInfo
end

function HUI_CDMCustomItemMixin:GetCooldownDurationObj()
    if self.type == "spell" then
        local cooldownFrame = self:GetCooldownFrame()
        local ignoreGCD = not cooldownFrame.showGCDSwipe or self.barType ~= nil
        local forceSpellCD = false

        local chargeCooldownInfo = self:GetChargesCooldownInfo()

        local spellID = self.overrideID or self.baseSpellID or self.spellID

        if chargeCooldownInfo then
            if chargeCooldownInfo.maxCharges == 1 then
                forceSpellCD = true
            end
        end
        if not chargeCooldownInfo or forceSpellCD then
            self.durationObj = C_Spell.GetSpellCooldownDuration(spellID, ignoreGCD)
        else
            self.durationObj = C_Spell.GetSpellChargeDuration(spellID, ignoreGCD)
        end
    end
    return self.durationObj or nil
end


function HUI_CDMCustomItemMixin:GetSpellTexture()
    local spellID = self:GetSpellID()
    local texture = 136243
    if self.type ~= "spell" and self.itemID then
        texture = C_Item.GetItemIconByID(self.itemID)
    elseif self.type == "spell" and spellID then
        texture = C_Spell.GetSpellTexture(spellID)
    end

	return texture
end

function HUI_CDMCustomItemMixin:IsBarFrame()
    return self.barType ~= nil
end

function HUI_CDMCustomItemMixin:GetIndexKeys()
    if self.type == "spell" then
        return self.spellID, self.baseSpellID, self.overrideID, self.rangeCheckSpellID
    elseif self.type == "item" then
        return nil, nil, nil, nil, self.itemID
    elseif self.type == "slot" then
        return nil, nil, nil, nil, nil, self.slotID
    end
end

function HUI_CDMCustomItemMixin:RefreshSpellTexture()
    local spellTexture = self:GetSpellTexture()

    local icon = self.Icon.Icon or self.Icon
    icon:SetTexture(spellTexture)
end

function HUI_CDMCustomItemMixin:RefreshIconDesaturation(desaturated)
    local icon = self.Icon.Icon or self.Icon
    if self.type == "item" or self.type == "potion" then
        if self.count == 0 or self.count == "" then
            desaturated = true
        else
            desaturated = false
        end
    end
    if desaturated == nil then return end
    icon:SetDesaturated(desaturated)
end

function HUI_CDMCustomItemMixin:RefreshIconColor()
    local isBar = self:IsBarFrame()
    local frameName = self.parentName
    local desaturated = false
    local isUsable, notEnoughMana
    if self.spellID then
        isUsable, notEnoughMana = C_Spell.IsSpellUsable(self.spellID)
    end

    local r, g, b, a = 1, 1, 1, 1
    if (not self.isOnAuraTimer or isBar) and self.isOnActualCooldown and Addon:GetValue("UseCDColor", nil, frameName) then
        r, g, b, a = Addon:GetRGBA("CDColor", nil, frameName)
        desaturated = Addon:GetValue("CDColorDesaturate", nil, frameName)
    elseif Addon:GetValue("UseAuraColor", nil, frameName) and self.isOnAuraTimer then
        r, g, b, a = Addon:GetRGBA("AuraColor", nil, frameName)
        desaturated = Addon:GetValue("AuraColorDesaturate", nil, frameName)
    elseif self.spellOutOfRange and Addon:GetValue("UseOORColor", nil, frameName) then
        r, g, b, a = Addon:GetRGBA("OORColor", nil, frameName)
        desaturated = Addon:GetValue("OORDesaturate", nil, frameName)
    elseif notEnoughMana and Addon:GetValue("UseOOMColor", nil, frameName) then
        r, g, b, a = Addon:GetRGBA("OOMColor", nil, frameName)
        desaturated = Addon:GetValue("OOMDesaturate", nil, frameName)
    elseif not isUsable and Addon:GetValue("UseNoUseColor", nil, frameName) then
        r, g, b, a = Addon:GetRGBA("NoUseColor", nil, frameName)
        desaturated = Addon:GetValue("NoUseDesaturate", nil, frameName)
    elseif Addon:GetValue("UseNormalColor", nil, frameName) then
        r, g, b, a = Addon:GetRGBA("NormalColor", nil, frameName)
        desaturated = Addon:GetValue("NormalColorDesaturate", nil, frameName)
    end
    local icon = self.Icon.Icon or self.Icon
    icon:SetVertexColor(r, g, b, a)
    self:RefreshIconDesaturation(desaturated)
end

function HUI_CDMCustomItemMixin:RefreshCount()
    local applications = self.Icon.Applications or self.Applications
    local count = 0
    if (self.type == "item" or self.type == "potion") and self.itemID then
        count = C_Item.GetItemCount(self.itemID, nil, true) or 0
    elseif self.type == "spell" then
        if not self.spellID then return end

        local charges = C_Spell.GetSpellCharges(self.spellID) or {}

        count = charges and charges.currentCharges or ""

        count = charges.currentCharges or 0

        if charges.maxCharges == 1 then
            count = 0
        end

        --self.Applications:SetAlphaFromBoolean(((charges.maxCharges > 1) and (charges.currentCharges ~= nil)), tonumber(charges.currentCharges), 0 )
        --applications:SetAlpha(charges.currentCharges ~= nil and tonumber(charges.currentCharges) or 1)
    end
    self.count = count

    if not self:IsBarFrame() and not Addon:GetValue("CDMAuraShowStacks", nil, self.parentName) then
        applications.Applications:SetText("")
        applications:SetAlpha(0)
    else
        applications.Applications:SetText(count)
        applications:SetAlpha(count)
    end

    if self.Bar and self.Bar.Count then
        self.Bar.Count:SetText(count)
        self.Bar.Count:SetAlpha(count)
    end

    self:RefreshIconDesaturation()
    self:RefreshSpellTexture()
    --self.ProcGlow:SetAlpha(count ~= "" and count or 1)
end

function HUI_CDMCustomItemMixin:GetChargesCooldownInfo()
    local cooldownFrame = self:GetCooldownFrame()
    local auraCooldown = self:GetAuraFrame()

    if not self.spellID then return false end

    local charges = C_Spell.GetSpellCharges(self.spellID)

    if charges and charges.cooldownStartTime and charges.cooldownDuration then
        local chargeInfo = self.__chargeInfoBuf
        if not chargeInfo then
            chargeInfo = {}
            self.__chargeInfoBuf = chargeInfo
        end
        chargeInfo.startTime = charges.cooldownStartTime
        chargeInfo.duration = charges.cooldownDuration
        chargeInfo.currentCharges = charges.currentCharges
        chargeInfo.maxCharges = charges.maxCharges
        return chargeInfo
    end

    return false
end

local function IsFakeAuraExpired(spellID)
    if not HUI_FAKE_AURAS[spellID] then
        return true
    else
        local startTime = HUI_FAKE_AURAS[spellID].startTime
        local duration = HUI_FAKE_AURAS[spellID].duration
        local savedTime = HUI_FAKE_AURAS[spellID].savedTime
        local currentTime = time()
        local time = GetTime()
        if not savedTime or not duration or ((currentTime - savedTime) >= duration) then
            HUI_FAKE_AURAS[spellID] = nil
            return true
        end
        if (time - startTime) < duration then
            return false
        elseif (time - startTime) >= duration then
            HUI_FAKE_AURAS[spellID] = nil
        end
    end
    
    return true
end

function HUI_CDMCustomItemMixin:RefreshFakeAuraInfo(reset)
    if not self.fakeAura or not self.fakeAura.duration then return false end

    if not self:IsBarFrame() and Addon:GetValue("CDMAuraRemoveSwipe", nil, self.parentName) then
        return false
    end

    local auraCooldown = self:GetAuraFrame()

    local startTime = GetTime()
    local duration = self.fakeAura.duration
    local isExpired = IsFakeAuraExpired(self.spellID)

    local cooldownFrame = self:GetCooldownFrame()
    cooldownFrame:SetAlpha(0)
    if not self.Bar then
        cooldownFrame:Show()
    end

    if HUI_FAKE_AURAS[self.spellID] then
        startTime = HUI_FAKE_AURAS[self.spellID].startTime
        duration = HUI_FAKE_AURAS[self.spellID].duration
    end

    if not self.auraDurationObj then
        self.auraDurationObj = C_DurationUtil.CreateDuration()
    end
    if not self.isOnAuraTimer then
        self.isOnAuraTimer = true
        self.auraDurationObj:SetTimeFromStart(startTime, duration)
        auraCooldown:SetCooldown(startTime, duration)
        HUI_FAKE_AURAS[self.spellID] = { startTime = startTime, duration = duration, savedTime = time() }
    elseif reset and self.fakeAura.type > 1 then
        if self.fakeAura.type == 2 then
            local curDur = self.auraDurationObj:GetRemainingDuration()
            local newDuration = curDur + self.fakeAura.duration
            self.auraDurationObj:SetTimeFromStart(GetTime(), newDuration)
            auraCooldown:SetCooldown(GetTime(), newDuration)
            HUI_FAKE_AURAS[self.spellID] = { startTime = GetTime(), duration = newDuration, savedTime = time() }
        elseif self.fakeAura.type == 3 then
            self.auraDurationObj:SetTimeFromStart(GetTime(), duration)
            auraCooldown:SetCooldown(GetTime(), duration)
            HUI_FAKE_AURAS[self.spellID] = { startTime = GetTime(), duration = duration, savedTime = time() }
        end
    end
end

function HUI_CDMCustomItemMixin:ClearFakeAuraSavedInfo()
    if HUI_FAKE_AURAS[self.spellID] then
        local auraCooldown = self:GetAuraFrame()
        CooldownFrame_Clear(auraCooldown)
        HUI_FAKE_AURAS[self.spellID] = nil
    end
    self:RefreshData()
end

function HUI_CDMCustomItemMixin:RefreshBackdrop()
    if not self.iconBorder then return end

    --self.iconBorder:SetFrameLevel(self:GetFrameLevel() + 10)

    if self.isOnAuraTimer then
        if Addon:GetValue("UseCDMBackdropAuraColor", nil, self.parentName) then
            self.iconBorder:SetBackdropBorderColor(Addon:GetRGBA("CDMBackdropAuraColor", nil, self.parentName))
        end
    else
        if Addon:GetValue("UseCDMBackdropColor", nil, self.parentName) then
            self.iconBorder:SetBackdropBorderColor(Addon:GetRGBA("CDMBackdropColor", nil, self.parentName))
        end
    end
end

function HUI_CDMCustomItemMixin:RefreshSpellCooldownInfo()
    if not self.spellID then return end

    --Addon:DebugPrint("RefreshSpellCooldownInfo", self.spellID)
    local cooldownFrame = self:GetCooldownFrame()
    local auraCooldown = self:GetAuraFrame()

    if self.fakeAura and not IsFakeAuraExpired(self.spellID) then
        --Addon:DebugPrint("RefreshSpellCooldownInfo check RefreshFakeAuraInfo", self.spellID, self.layoutIndex)
        self:RefreshFakeAuraInfo()
    end

    cooldownFrame.showGCDSwipe = not (Addon:GetValue("CDMRemoveGCDSwipe", nil, self.parentName))

    cooldownFrame:SetAlpha(0)

    local showDrawEdge = true
    --self.isOnActualCooldown = false
    cooldownFrame:SetReverse(cooldownFrame.isReversed)
    auraCooldown:SetReverse(auraCooldown.isReversed)

    local chargeCooldownInfo = self:GetChargesCooldownInfo()
    local cooldownInfo = self:GetCooldownInfo()

    local durationObj

    if self.type == "spell" then
        durationObj = self:GetCooldownDurationObj()
    else
        if not self.durationObj then
            self.durationObj = C_DurationUtil.CreateDuration()
        end
        durationObj = self.durationObj
        if cooldownInfo then
            durationObj:SetTimeFromStart(cooldownInfo.startTime or 0, cooldownInfo.duration or 0)
        end
    end

    if chargeCooldownInfo and chargeCooldownInfo.startTime and chargeCooldownInfo.duration then
        if chargeCooldownInfo.maxCharges > 1 then
            cooldownFrame:SetDrawSwipe(false)
        else
            cooldownFrame:SetDrawSwipe(true)
        end

        if cooldownInfo.isOnGCD == false then
            self.isOnActualCooldown = true
        else
            self.isOnActualCooldown = false
        end
        
        if self.type == "spell" then
            if durationObj then
                cooldownFrame:SetCooldownFromDurationObject(durationObj, true)
            end
        else
            cooldownFrame:SetCooldown(chargeCooldownInfo.startTime, chargeCooldownInfo.duration)
        end
        
        -- Action/Spell cooldown APIs now return a new non-secret isActive boolean, which is set to true if the UI should render a cooldown display.
        -- For regular cooldowns, it's true if isEnabled and startTime > 0 and duration > 0.
        -- For charge cooldowns, it's true if maxCharges > 1 and currentCharges < maxCharges and startTime > 0 and duration > 0.

        -- 12.0.5 We are adding a new ignoreGCD parameter to APIs that construct and return duration objects for cooldowns.

        if cooldownInfo.isActive or cooldownFrame:IsVisible() then
            self.isOnChargeCooldown = true
        else
            self.isOnChargeCooldown = false
        end

        --cooldownFrame:SetAlphaFromBoolean((self.isOnAuraTimer == true) or (cooldownFrame.showGCDSwipe == false and (cooldownInfo.isOnGCD == true)), 0,1)
        if not self.isOnAuraTimer then
            if durationObj then
                cooldownFrame:SetAlpha(durationObj:EvaluateRemainingDuration(Addon.alphaCurve, 0))
            else
                cooldownFrame:SetAlpha(1)
            end
        end
    elseif cooldownInfo and cooldownInfo.startTime and cooldownInfo.duration then
        if not self.isOnChargeCooldown then
            if self.type == "spell" and (cooldownInfo.isActive and cooldownInfo.isOnGCD ~= true) then
                self.isOnActualCooldown = true
            elseif self.type == "spell" and cooldownInfo.isOnGCD then
                self.isOnActualCooldown = false
            elseif self.type ~="spell" and cooldownInfo.duration > 0 then
                self.isOnActualCooldown = true
            end
            cooldownFrame:SetDrawSwipe(true)
            if self.type == "spell" and durationObj then
                cooldownFrame:SetCooldownFromDurationObject(durationObj, true)
            else
                cooldownFrame:SetCooldown(cooldownInfo.startTime, cooldownInfo.duration)
            end
            if not self.Bar then
                cooldownFrame:Show()
            end

            if cooldownInfo.enable == false then
                cooldownFrame:Pause()
            else
                cooldownFrame:Resume()
            end
            if not self.isOnAuraTimer then
                if durationObj then
                    cooldownFrame:SetAlpha(durationObj:EvaluateRemainingDuration(Addon.alphaCurve, 0))
                else
                    cooldownFrame:SetAlpha(1)
                end
            end
            --[[ cooldownFrame:SetAlphaFromBoolean(self.isOnActualCooldown or cooldownInfo.isOnGCD == true,1,0)
            if self.spellID == 322101 then
                print(self.isOnActualCooldown, cooldownInfo.isOnGCD, cooldownInfo.isActive)
                print(cooldownFrame:GetAlpha())
            end ]]
        end
    else
        CooldownFrame_Clear(cooldownFrame)
        self.isOnActualCooldown = false
        self.isOnAuraTimer = false
    end
end

function HUI_CDMCustomItemMixin:RefreshData()
    --if not self:IsVisible() then return end
    self:RefreshSpellCooldownInfo()
    --self:RefreshAuraInstance()
    --self:RefreshSpellTexture()
    self:AddAuraSlot()
    if self.type == "item" and IsHealthstoneItem(self.itemID) then
        if not self.__hsTimerPending then
            self.__hsTimerPending = true
            C_Timer.After(0.5, function()
                self.__hsTimerPending = nil
                self:RefreshCount()
                self:RefreshVisibility()
            end)
        end
    else
        self:RefreshCount()
        self:RefreshVisibility()
    end
    self:RefreshBackdrop()
    self:RefreshIconColor()

    --self:RefreshProcAnim()
end

function HUI_CDMCustomItemMixin:RefreshVisibility()
    if not self.spellID and not self.itemID then return end
    if not self.parentName then return end
    local parentFrame = _G[self.parentName]

    if not parentFrame then return end
    
    self.Icon:Show()
    if self.iconBorder then
        self.iconBorder:Show()
    end
    local cooldownFrame = self:GetCooldownFrame()
    if cooldownFrame then cooldownFrame:Show() end

    local hideType = parentFrame.Container.hideInactiveType

    local newIsActive
    if hideType == 5 then
        newIsActive = self.isOnActualCooldown and true or false
    elseif hideType == 4 then
        newIsActive = (not self.isOnActualCooldown or self.isOnAuraTimer) and true or false
    elseif hideType == 3 then
        newIsActive = (self.isOnActualCooldown or self.isOnAuraTimer or self.isOnChargeCooldown) and true or false
    elseif hideType == 2 then
        if self.isOnAuraTimer or self.AuraSet then
            newIsActive = true
            if self.AuraSet then
                self.Icon:Hide()
                if self.iconBorder then
                    self.iconBorder:Hide()
                end
            end
            if cooldownFrame then cooldownFrame:Hide() end
        else
            newIsActive = false
        end
    elseif hideType == 1 then
        newIsActive = nil
    end

    local newShouldBeVisible
    if Addon:GetValue("CDMCustomHideEmpty", nil, self.parentName) and (self.type == "item" or self.type == "potion") then
        if not self.isOnAuraTimer and not self.AuraSet and self.count == 0 then
            newIsActive = false
            newShouldBeVisible = false
        else
            newShouldBeVisible = true
        end
    end
    self.__shouldBeVisible = newShouldBeVisible

    if newIsActive ~= self.__prevIsActive or newShouldBeVisible ~= self.__prevShouldBeVisible then
        self.__isActive = newIsActive
        self.__prevIsActive = newIsActive
        self.__prevShouldBeVisible = newShouldBeVisible
        parentFrame:RefreshVisibileOnCD()
    else
        self.__isActive = newIsActive
    end
end

function HUI_CDMCustomItemMixin:OnSpellUpdateCooldownEvent()
    self.isOnChargeCooldown = false
    self.isOnActualCooldown = false
    
    self:RefreshData()
end

function HUI_CDMCustomItemMixin:OnSpellUpdateUsesEvent()
    --self.count = C_Spell.GetSpellCharges(self:GetSpellID())
    self:ScheduleCountRefresh()
end

function HUI_CDMCustomItemMixin:ScheduleCountRefresh()
    if self.__countRefreshPending then return end
    self.__countRefreshPending = true
    RunNextFrame(function()
        self.__countRefreshPending = nil
        self:RefreshCount()
    end)
end

function HUI_CDMCustomItemMixin:ScheduleRefreshData()
    if self.__refreshDataPending then return end
    self.__refreshDataPending = true
    RunNextFrame(function()
        self.__refreshDataPending = nil
        self:RefreshData()
    end)
end

function HUI_CDMCustomItemMixin:OnAuraDone()
    self.isOnAuraTimer = false
    self:ScheduleRefreshData()
end

function HUI_CDMCustomItemMixin:OnCooldownDone()
    self.isOnActualCooldown = false
    self.isOnChargeCooldown = false
    --self.isOnAuraTimer = false
    self:ScheduleRefreshData()
end

--[[ function HUI_CDMCustomItemMixin:ShowProcGlow()
    self.ProcGlow:Show()
    self.ProcGlow.ProcStartAnim:Play()
end
function HUI_CDMCustomItemMixin:HideProcGlow()
    self.ProcGlow.ProcLoop:Stop()
    self.ProcGlow:Hide()
end ]]


function HUI_CDMCustomItemMixin:RefreshProcAnim(inCombat)
    if not self:IsVisible() then return end
    local inCombat = inCombat or InCombatLockdown()
    local count
    if self.item then
        count = self.count
    end
    if self.isOnAuraTimer or self.isOnActualCooldown or not inCombat or (count == 0) then
        ActionButtonSpellAlertManager:HideAlert(self)
    elseif not self.isOnAuraTimer and not self.isOnActualCooldown and inCombat then
        --Addon:DebugPrint("RefreshProcAnim Playing", self.ProcGlow.ProcLoop:IsPlaying() )
        ActionButtonSpellAlertManager:ShowAlert(self)
    end
end

function HUI_CDMCustomItemMixin:GetFakeAura()
    if not self.spellID then return end
    local frameName = self.parentName
    local parentFrame = _G[frameName]
    if not parentFrame then return end
    local frameIndex = parentFrame:GetFrameIndexByName(frameName)
    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.fakeAuras and frameTbl.fakeAuras[self.itemID or self.spellID] then
            return frameTbl.fakeAuras[self.itemID or self.spellID]
        end
    end
end

function HUI_CDMCustomItemMixin:SaveRealAuraInit(spellIDs)

    if not self.spellID and not self.itemID then return end

    local frameName = self.parentName
    local parentFrame = _G[frameName]
    if not parentFrame then return end
    local frameIndex = parentFrame:GetFrameIndexByName(frameName)
    local spellID = self.itemID or self.spellID

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl then
            if not frameTbl.realAuras then
                frameTbl.realAuras = {}
            end
            if not frameTbl.realAuras[spellID] then
                frameTbl.realAuras[spellID] = spellIDs
            end
        end
    end

    self:InvalidateAura()

end

function HUI_CDMCustomItemMixin:InvalidateAura()
    self.__hasAuraLink = nil
    self.__auraFilterDirty = true
    self.auraSpellID = nil
    self.auraUnit = nil
    self.elemShamHack = nil
end

function HUI_CDMCustomItemMixin:GetRealAura()
    if self.type == "potion" then
        local lastUsed = self:GetLastUsedPotion()
        if not lastUsed or not lastUsed.spellID then return nil end
        self.__potionAuraBuf = self.__potionAuraBuf or {}
        if self.__potionAuraBuf[1] ~= lastUsed.spellID then
            self.__potionAuraBuf[1] = lastUsed.spellID
            self.__auraFilterDirty = true
        end
        return self.__potionAuraBuf
    end
    if not self.spellID then return end

    if self.__hasAuraLink == nil then
        local frameName = self.parentName
        local parentFrame = _G[frameName]
        if not parentFrame then return end
        local frameIndex = parentFrame:GetFrameIndexByName(frameName)
        local spellID = self.itemID or self.baseSpellID or self.spellID

        if profileTable["CDMCustomFrames"] then
            local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
            if frameTbl and frameTbl.realAuras and frameTbl.realAuras[spellID] then
                self.__realAuraList = frameTbl.realAuras[spellID]
                self.__hasAuraLink = next(self.__realAuraList) ~= nil
                return self.__realAuraList
            end
        end
        self.__realAuraList = nil
        self.__hasAuraLink = false
    end

    if self.__hasAuraLink then
        return self.__realAuraList
    end
end

function HUI_CDMCustomItemMixin:GetAuraContainer()
    return self.AuraContainer
end

function HUI_CDMCustomItemMixin:CreateAuraContainer()
    if not self.AuraContainer then
        self.AuraContainer = CreateFrame("AuraContainer", nil, self, "HUI_CDMAuraContainer")
    end
    return self.AuraContainer
end

function HUI_CDMCustomItemMixin:AnchorAuraContainer()
    local container = self:GetAuraContainer()

    container:ClearAllPoints()
    container:SetPoint("CENTER", self, "CENTER")

end

function HUI_CDMCustomItemMixin:CreatePandemicElements(auraButton)
    local realAuraFrame = self.realAuraFrame
    if not realAuraFrame or realAuraFrame.pandemicBorder then return end
    if Addon:GetValue("CDMRemovePandemic", nil, self.parentName) then return end

    realAuraFrame.pandemicBorder = Addon.CreateBorder(realAuraFrame, self.parentName)
    local pColor = {}
    pColor.r, pColor.g, pColor.b, pColor.a = Addon:GetRGBA("CDMBackdropPandemicColor", nil, self.parentName)
    realAuraFrame.pColor = pColor
    realAuraFrame.pandemicBorder:Show()
    realAuraFrame.pandemicBorder:SetFrameLevel(realAuraFrame:GetFrameLevel() + 2)

    realAuraFrame.pandemicGlow = CreateFrame("Frame", nil,  realAuraFrame, "HUI_CDMCustomItemPandemicGlow")
    realAuraFrame.pandemicGlow:SetPoint("TOPLEFT", realAuraFrame, "TOPLEFT", -6, 6)
    realAuraFrame.pandemicGlow:SetPoint("BOTTOMRIGHT", realAuraFrame, "BOTTOMRIGHT", 6, -6)
    realAuraFrame.pandemicGlow:SetFrameLevel(realAuraFrame:GetFrameLevel() + 3)
    realAuraFrame.pandemicGlow:Show()
    realAuraFrame.pandemicGlow.FX.Anim:Play()

    realAuraFrame.pandemicBorder.pandemicRegionIndex = auraButton:AddPandemicRegion(realAuraFrame.pandemicBorder)
    realAuraFrame.pandemicGlow.pandemicRegionIndex = auraButton:AddPandemicRegion(realAuraFrame.pandemicGlow)
end

function HUI_CDMCustomItemMixin:ConfigureAuraContainer(auraButton)
    if not auraButton:CanBeAccessedInContext() then
        return
    end

    local container = self:GetAuraContainer()
    local auraCooldown = self:GetAuraFrame()
    
    if not self.realAuraFrame then
        self.realAuraFrame = CreateFrame("Frame", nil, auraButton)
        self.realAuraFrame:SetAllPoints(self)
        self.realAuraFrame:SetFrameLevel(self:GetFrameLevel() + 6)

        self.realAuraFrame.iconBorder = Addon.CreateBorder(self.realAuraFrame, self.parentName)
        local color = {r=1,g=0,b=0,a=1}
        color.r, color.g, color.b, color.a = Addon:GetRGBA("CDMBackdropAuraColor", nil, self.parentName)
        self.realAuraFrame.color = color
        --self.realAuraFrame.iconBorder:Show()
        self.realAuraFrame.iconBorder:SetFrameLevel(self.realAuraFrame:GetFrameLevel() + 1)

        self:CreatePandemicElements(auraButton)

        self.realAuraCooldownFrame = CreateFrame("Cooldown", nil, auraButton, "CooldownFrameTemplate")
        self.realAuraCooldownFrame:SetFrameLevel(self:GetFrameLevel() + 5)

        self.realAuraFrame.dispelBorder = auraButton:CreateTexture(nil, "OVERLAY")
        self.realAuraFrame.dispelBorder:SetAllPoints(auraButton)

        self.realAuraFrame.icon = auraButton:CreateTexture(nil, "OVERLAY")
        self.realAuraFrame.icon:SetAllPoints(self.Icon)
        local mask = self.Icon:GetMaskTexture(1)
        if mask then
            self.realAuraFrame.icon:AddMaskTexture(mask)
        end
        

        self.realAuraFrame.overlayFrame = CreateFrame("Frame", nil, self.realAuraFrame)
        self.realAuraFrame.overlayFrame:SetAllPoints(self.realAuraFrame)
        self.realAuraFrame.overlayFrame:SetFrameLevel(self.realAuraFrame:GetFrameLevel() + 4)

        self.realAuraFrame.overlayFrame.count = self.realAuraFrame.overlayFrame:CreateFontString(nil, "OVERLAY")
    end

    if auraButton.SetAuraBorder then
        auraButton:SetAuraBorder(self.realAuraFrame.dispelBorder, {
            showIcon = true,
            showWhenHarmful = true,
            showWhenHelpful = false,
        })
    end
    
    HUI_CDMCustomFrameCustomized:CustomizeCooldownFrame(self.realAuraCooldownFrame, self.parentName, self.Icon, true)
    HUI_CDMCustomFrameCustomized:RefreshAuraColor(self.realAuraCooldownFrame, self.parentName)
    HUI_CDMCustomFrameCustomized:RefreshAuraTimer(self.realAuraCooldownFrame, self.parentName)
    HUI_CDMCustomFrameCustomized:CustomizeCooldownFont(self.realAuraCooldownFrame, self.parentName, true)
    HUI_CDMCustomFrameCustomized:CustomizeStacksFont(self.realAuraFrame.overlayFrame.count, self.parentName, self.realAuraFrame)
    HUI_CDMCustomFrameCustomized:SetupBackdrop(self.realAuraFrame.iconBorder, self.parentName, self.realAuraFrame.color)
    if self.realAuraFrame.pandemicBorder then
        HUI_CDMCustomFrameCustomized:SetupBackdrop(self.realAuraFrame.pandemicBorder, self.parentName, self.realAuraFrame.pColor)
    end

    if Addon:GetValue("UseCDMBackdrop", nil, self.parentName) and Addon:GetValue("UseCDMBackdropAuraColor", nil, self.parentName) then
        self.realAuraFrame.iconBorder:Show()
    else
        self.realAuraFrame.iconBorder:Hide()
    end

    local countFormatter = Addon:GetValue("AlwaysShowStacks", nil, self.parentName) and { formatter = Addon.defaultCountFormatter } or {}
    auraButton:SetIcon(self.realAuraFrame.icon)
    if Addon:GetValue("CDMAuraShowStacks", nil, self.parentName) then
        auraButton:SetApplicationCount(self.realAuraFrame.overlayFrame.count, countFormatter)
    else
        auraButton:ClearApplicationCount()
        self.realAuraFrame.overlayFrame.count:Hide()
    end
    auraButton:SetDurationCooldown(self.realAuraCooldownFrame)
    auraButton:SetSize(auraCooldown:GetSize())

    local auraUnit = self:GetAuraUnit()
    container:SetUnit(auraUnit)

    self:AnchorAuraContainer()

    return auraButton
end

local elemEB = {
    [173184] = true,
    [118522] = true,
    [173183] = true,
}

function HUI_CDMCustomItemMixin:ClearAuraSlots()
    local container = self:GetAuraContainer()
    if not container then return end

    container:SetEnabled(false)
    container:Hide()
    self.realAuraFrame = nil
    self.realAuraCooldownFrame = nil
    self.aura = nil
    self.AuraContainer = nil
    self.__auraFilterDirty = true
    self.AuraSet = nil
end

function HUI_CDMCustomItemMixin:AddAuraSlot()

    if self.fakeAura and self.fakeAura.duration then return end

    if not self:IsBarFrame() and Addon:GetValue("CDMAuraRemoveSwipe", nil, self.parentName) then
        return
    end

    local spellIDsRaw = self:GetRealAura()
    if not spellIDsRaw then return end

    local spellIDs = self.__spellIDs or {}
    wipe(spellIDs)
    local hasValid = false
    for _, spellID in ipairs(spellIDsRaw) do
        local id = tonumber(spellID)
        if id then
            spellIDs[id] = true
            hasValid = true
        end
    end
    if not hasValid then return end
    self.__spellIDs = spellIDs

    local container = self:CreateAuraContainer()

    local auraUnit = self:GetAuraUnit()
    local filterString = auraUnit == "player" and "HELPFUL|PLAYER" or "HARMFUL|PLAYER"
    local IsElemHackNeeded = self:IsElemHackNeeded() == true

    if not self.AuraSet then
        self.aura = container:AddAuraSlot("1", filterString, {
            maxFrameCount = 1,
            sortMethod = AuraContainerSortMethod.ExpirationOnly,
            sortDirection = AuraContainerSortDirection.Reverse,
            showIcon = true,

            initializeFrame = function(button) self:ConfigureAuraContainer(button) end,

            layout = {
                elementWidth = 20,
                elementHeight = 20,
                elementSpacingX = 0,
                elementSpacingY = 0,
            },
            candidateFilters = {
                includeSpellIDs = IsElemHackNeeded and elemEB or spellIDs
            }
        })
        self.AuraSet = true
    end

    if self.__auraFilterDirty then
        local candidateFilters = self.__candidateFilters or {}
        wipe(candidateFilters)
        candidateFilters.includeSpellIDs = IsElemHackNeeded and elemEB or spellIDs
        self.__candidateFilters = candidateFilters
        container:SetAuraSlotFilterString("1", filterString)
        container:SetAuraSlotCandidateFilters("1", candidateFilters)
        container:SetAuraSlotSortMethod("1", AuraContainerSortMethod.ExpirationOnly, AuraContainerSortDirection.Reverse)
        self.__auraFilterDirty = nil
    end
    container:SetEnabled(true)
    container:Show()
end

function HUI_CDMCustomItemMixin:GetAuraUnit()

    if self.auraUnit then return self.auraUnit end

    local auraTbl = self:GetRealAura()
    self.auraSpellID = auraTbl and tonumber(auraTbl[1]) or self.auraSpellID or self.spellID

    local tbl = self.auraSpellID and Addon.SPELLID_TO_AURASPELLID[self.auraSpellID]
    local auraUnit
    if tbl then
        auraUnit = tbl.auraUnit
    end
    auraUnit = auraUnit or (C_Spell.IsSpellHelpful(self.auraSpellID) and "player" or "target")
    self.auraUnit = auraUnit

    return auraUnit
end

function HUI_CDMCustomItemMixin:IsElemHackNeeded()
    if self.elemShamHack ~= nil then
        return self.elemShamHack
    end
    local auraSpellIDs = self:GetRealAura()
    if not self.elemShamHack then
        for i, auraSpellID in ipairs(auraSpellIDs or {}) do
            if elemEB[auraSpellID] then
                self.elemShamHack = true
            end
        end
    end
    return self.elemShamHack
end

function HUI_CDMCustomItemMixin:FindAuraSpellID()
    if self.type ~= "spell" then return end

    local spellID = self.baseSpellID or self.spellID

    local tbl = Addon.SPELLID_TO_AURASPELLID[spellID]
    if tbl then
        self:SaveRealAuraInit(tbl.linkedSpellIDs)
    end
end
-----------------------------
HUI_CDMCustomItemProcGlow = {}

function HUI_CDMCustomItemProcGlow:OnLoad()
    self.ProcStartAnim:SetScript("OnFinished", function()
        self.ProcLoop:Play()
    end)
end

function HUI_CDMCustomItemProcGlow:OnHide()
    if self.ProcLoop:IsPlaying() then
        self.ProcLoop:Stop()
    end
end
------------------------------

-----------------------------
HUI_CDMCustomFrameMixin = {}

function HUI_CDMCustomFrameMixin:OnLoad()

    self:SetMovable(true)

    self.frameName = self:GetName()

    local frameIndex = self:GetFrameIndexByName(self.frameName)
    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        self.itemList = frameTbl.trackedIDs or {}
        self.displayName = frameTbl.name
    end

    self.hideInactive = false

    local itemResetCallback = function(pool, itemFrame)
		Pool_HideAndClearAnchors(pool, itemFrame)
        if itemFrame.rangeCheckSpellID then
            C_Spell.EnableSpellRangeCheck(itemFrame.rangeCheckSpellID, false)
            itemFrame.rangeCheckSpellID = nil
        end
		itemFrame.layoutIndex = nil
        itemFrame.fakeAura = nil
        itemFrame.slotID = nil
        itemFrame.itemID = nil
        itemFrame.spellID = nil
        itemFrame.baseSpellID = nil
        itemFrame.potType = nil
        itemFrame.count = nil
        itemFrame.isOnAuraTimer = nil
        itemFrame.isOnActualCooldown = nil
        itemFrame.isOnChargeCooldown = nil
        local cooldownFrame = itemFrame:GetCooldownFrame()
        local auraCooldown = itemFrame:GetAuraFrame()
        CooldownFrame_Clear(cooldownFrame)
        CooldownFrame_Clear(auraCooldown)
        itemFrame:UnregisterAllEvents()
        itemFrame.registeredEvents = nil
        itemFrame.auraUnit = nil
        itemFrame.elemShamHack = nil
        itemFrame.AuraFrameCreated = nil
        itemFrame.spellOutOfRange = nil
        itemFrame.__realAuraList = nil
        itemFrame.__hasAuraLink = nil
        itemFrame.__auraFilterDirty = nil
        itemFrame.__prevIsActive = nil
        itemFrame.__prevShouldBeVisible = nil
        itemFrame.__refreshDataPending = nil
        itemFrame.__countRefreshPending = nil
        itemFrame.__hsTimerPending = nil
        itemFrame:ClearAuraSlots()
	end

    self.itemPool = CreateFramePool("Frame", self.Container, self.itemTemplate, itemResetCallback)

    self:ResetIndexes()
    self.__pendingItemLoads = {}
    self.lastUsedPotions = {}
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.EndOrderChange", self.OnCustomItemListReorderEnded)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.ItemAdded", self.OnCustomItemListItemUpdate)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.ItemRemoved", self.OnCustomItemListItemUpdate)
    self:AddDynamicEventMethod(EventRegistry, "EditMode.Enter", self.OnEditModeEnter)
    self:AddDynamicEventMethod(EventRegistry, "EditMode.Exit", self.OnEditModeExit)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.FakeAuraAdded", self.OnFakeAuraAdded)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.FakeAuraTypeChanged", self.OnFakeAuraTypeChanged)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.UpdateFrame", self.OnFrameUpdate)

    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.RealAuraAdded", self.OnRealAuraAdded)

    for _, data in ipairs(self.itemList) do
        if data.type == "item" and not C_Item.IsItemDataCachedByID(tonumber(data.id)) then
            C_Item.RequestLoadItemDataByID(tonumber(data.id))
        end
    end
    self:RefreshLayout()

    self:SetMouseClickEnabled(false)

    Addon:BarsFadeAnim(self)

    self.lastRunTime = 0
end

function HUI_CDMCustomFrameMixin:OnFrameUpdate(frameName)
    if self:GetName() ~= frameName then return end
    self:RefreshLayout()
end

function HUI_CDMCustomFrameMixin:OnFakeAuraTypeChanged(spellID, newType)
    for itemFrame in self.itemPool:EnumerateActive() do
        if itemFrame.itemID == spellID or itemFrame.spellID == spellID then
            if itemFrame.fakeAura then
                itemFrame.fakeAura.type = newType
            else
                itemFrame.fakeAura = {
                    duration = 0,
                    type = newType,
                }
            end
        end
    end
end

function HUI_CDMCustomFrameMixin:OnFakeAuraAdded(spellID, newDuration)
    for itemFrame in self.itemPool:EnumerateActive() do
        if itemFrame.itemID == spellID or itemFrame.spellID == spellID then
            if itemFrame.fakeAura then
                itemFrame.fakeAura.duration = newDuration
            else
                itemFrame.fakeAura = {
                    duration = newDuration,
                    type = 1
                }
            end
            local auraContainer = itemFrame:GetAuraContainer()
            if auraContainer then
                auraContainer:SetEnabled(false)
            end
        end
    end
end

function HUI_CDMCustomFrameMixin:OnRealAuraAdded(spellID, auraSpellIDs)
    for itemFrame in self.itemPool:EnumerateActive() do
        if itemFrame.itemID == spellID or itemFrame.spellID == spellID then
            itemFrame:InvalidateAura()
            itemFrame:AddAuraSlot()
        end
    end
end

function HUI_CDMCustomFrameMixin:IndexItemFrame(itemFrame)
    if not itemFrame.type then return end
    if not self.__spellIndex then self:ResetIndexes() end
    if itemFrame.type == "spell" then
        if itemFrame.spellID then self:AddToIndex(self.__spellIndex, itemFrame.spellID, itemFrame) end
        if itemFrame.baseSpellID then self:AddToIndex(self.__spellIndex, itemFrame.baseSpellID, itemFrame) end
        if itemFrame.overrideID then self:AddToIndex(self.__spellIndex, itemFrame.overrideID, itemFrame) end
        if itemFrame.rangeCheckSpellID then self:AddToIndex(self.__rangeIndex, itemFrame.rangeCheckSpellID, itemFrame) end
        table.insert(self.__allSpellItems, itemFrame)
    elseif itemFrame.type == "item" then
        if itemFrame.itemID then self:AddToIndex(self.__itemIndex, itemFrame.itemID, itemFrame) end
        if itemFrame.spellID then self:AddToIndex(self.__spellIndex, itemFrame.spellID, itemFrame) end
        table.insert(self.__allItemItems, itemFrame)
    elseif itemFrame.type == "slot" then
        if itemFrame.slotID then self:AddToIndex(self.__slotIndex, itemFrame.slotID, itemFrame) end
        if itemFrame.spellID then self:AddToIndex(self.__spellIndex, itemFrame.spellID, itemFrame) end
        if itemFrame.overrideID then self:AddToIndex(self.__spellIndex, itemFrame.overrideID, itemFrame) end
        table.insert(self.__allItemItems, itemFrame)
    elseif itemFrame.type == "potion" then
        table.insert(self.__allPotionItems, itemFrame)
    end
end

function HUI_CDMCustomFrameMixin:AddToIndex(index, key, itemFrame)
    local list = index[key]
    if not list then
        list = {}
        index[key] = list
    end
    for _, f in ipairs(list) do
        if f == itemFrame then return end
    end
    table.insert(list, itemFrame)
end

function HUI_CDMCustomFrameMixin:ResetIndexes()
    self.__spellIndex = {}
    self.__itemIndex = {}
    self.__slotIndex = {}
    self.__rangeIndex = {}
    self.__allSpellItems = {}
    self.__allItemItems = {}
    self.__allPotionItems = {}
    self.__dispatchSeen = self.__dispatchSeen or {}
end

function HUI_CDMCustomFrameMixin:GetSpellIndexed(spellID)
    if not self.__spellIndex then self:ResetIndexes() end
    return self.__spellIndex[spellID]
end

function HUI_CDMCustomFrameMixin:GetItemIndexed(itemID)
    if not self.__spellIndex then self:ResetIndexes() end
    return self.__itemIndex[itemID]
end

function HUI_CDMCustomFrameMixin:GetRangeIndexed(spellID)
    if not self.__spellIndex then self:ResetIndexes() end
    return self.__rangeIndex[spellID]
end

function HUI_CDMCustomFrameMixin:GetDisplayName()
    return self.displayName
end

function HUI_CDMCustomFrameMixin:SetDisplayName(name)
    self.displayName = name
end

function HUI_CDMCustomFrameMixin:GetFrameIndexByName(frameName)
    if profileTable["CDMCustomFrames"] then
        for index, data in ipairs(profileTable["CDMCustomFrames"]) do
            if data.label == frameName then
                return index
            end
        end
    end

    return false
end

function HUI_CDMCustomFrameMixin:SaveDisplayName(name)
    local frameName = self.frameName
    local frameIndex = self:GetFrameIndexByName(frameName)
    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        frameTbl.name = name
    end
end

function HUI_CDMCustomFrameMixin:UpdateSlotBaseID(data, itemID)
    data.baseID = itemID
    local frameIndex = self:GetFrameIndexByName(self.frameName)
    if not frameIndex then return end
    local frameTbl = profileTable["CDMCustomFrames"] and profileTable["CDMCustomFrames"][frameIndex]
    if frameTbl and frameTbl.trackedIDs and frameTbl.trackedIDs ~= self.itemList then
        for _, dbData in ipairs(frameTbl.trackedIDs) do
            if dbData.type == "slot" and dbData.id == data.id then
                dbData.baseID = itemID
                break
            end
        end
    end
end

function HUI_CDMCustomFrameMixin:RequestResolveRetry(id)
    if self.__resolveRetryPending then return end
    if not self.__resolveRetryAttempts then self.__resolveRetryAttempts = {} end
    local attempts = (self.__resolveRetryAttempts[id] or 0) + 1
    if attempts > 12 then return end
    self.__resolveRetryAttempts[id] = attempts
    self.__resolveRetryPending = true
    C_Timer.After(math.min(0.5 * 2 ^ (attempts - 1), 4), function()
        self.__resolveRetryPending = nil
        self:RefreshLayout()
    end)
end

function HUI_CDMCustomFrameMixin:OnEditModeEnter()
    self.HUISelection:Show()
end

function HUI_CDMCustomFrameMixin:OnEditModeExit()
    self.HUISelection:Hide()
    self.HUISelection:SetSelected(false)
end

function HUI_CDMCustomFrameMixin:OnCustomItemListReorderEnded(itemList, frameName)
    if self:GetName() ~= frameName then return end
    self.itemList = CopyTable(itemList)
    self:RefreshLayout()
end
function HUI_CDMCustomFrameMixin:OnCustomItemListItemUpdate(itemList, frameName)
    if self:GetName() ~= frameName then return end
    self.itemList = CopyTable(itemList)
    self:RefreshLayout()
end
function HUI_CDMCustomFrameMixin:RegisterUnitAura()
    if self.hasSpellElement then
        --self:RegisterUnitEvent("UNIT_AURA", "player")
        self:RegisterUnitEvent("UNIT_AURA", "player", "target")
    else
        self:UnregisterEvent("UNIT_AURA")
    end
end


function HUI_CDMCustomFrameMixin:OnShow()
    --self:RegisterEvent("PLAYER_IN_COMBAT_CHANGED")
	self:RegisterEvent("PLAYER_LEVEL_CHANGED")
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    self:RegisterEvent("PLAYER_TALENT_UPDATE")
    self:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
    self:RegisterEvent("TRAIT_CONFIG_UPDATED")
    self:RegisterEvent("CHALLENGE_MODE_START")
    self:RegisterEvent("FIRST_FRAME_RENDERED")
    self:RegisterEvent("UNIT_DIED")
    --self:RegisterUnitAura()
    self:RegisterUnitEvent("UNIT_PET", "player")
    --self:RegisterEvent("PLAYER_TOTEM_UPDATE")
    self:RegisterUnitEvent("PLAYER_TARGET_CHANGED")

    self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
    self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
    self:RegisterEvent("SPELL_UPDATE_ICON")
    self:RegisterEvent("SPELL_UPDATE_CHARGES")
    self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    self:RegisterEvent("SPELL_UPDATE_USES")
    self:RegisterEvent("SPELL_UPDATE_USABLE")
    self:RegisterEvent("ITEM_COUNT_CHANGED")
    self:RegisterEvent("BAG_UPDATE_DELAYED")
    self:RegisterEvent("BAG_UPDATE_COOLDOWN")
    self:RegisterEvent("ENCOUNTER_END")
    self:RegisterEvent("SPELL_RANGE_CHECK_UPDATE")
    self:RegisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player", "pet")
    self:RegisterUnitEvent("UNIT_AURA", "player")
end

function HUI_CDMCustomFrameMixin:OnHide()
    --[[ self:UnregisterEvent("PLAYER_IN_COMBAT_CHANGED")
	self:UnregisterEvent("PLAYER_LEVEL_CHANGED")
    self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
    self:UnregisterEvent("BAG_UPDATE_COOLDOWN")
    self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
    self:UnregisterEvent("PLAYER_TALENT_UPDATE")
    self:UnregisterEvent("ITEM_COUNT_CHANGED")
    self:UnregisterEvent("SPELL_UPDATE_USES")
    self:UnregisterEvent("BAG_UPDATE_DELAYED")
    self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    self:UnregisterEvent("TRAIT_CONFIG_UPDATED")
    self:UnregisterEvent("UNIT_AURA")
    self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED") ]]
end

function HUI_CDMCustomFrameMixin:UpdateAllTrinkets(usedSlot)
    for itemFrame in self.itemPool:EnumerateActive() do
        if itemFrame.slotID and itemFrame.slotID ~= usedSlot and itemFrame.slotID < 16 then
            itemFrame:RefreshSpellCooldownInfo()
            itemFrame:RefreshVisibility()
        end
    end
end

function HUI_CDMCustomFrameMixin:DispatchCooldown(list, seen)
    if not list then return end
    for i = 1, #list do
        local itemFrame = list[i]
        if not seen[itemFrame] then
            seen[itemFrame] = true
            if itemFrame.slotID == 13 or itemFrame.slotID == 14 then
                self:UpdateAllTrinkets(itemFrame.slotID)
            end
            itemFrame:OnSpellUpdateCooldownEvent()
        end
    end
end

function HUI_CDMCustomFrameMixin:DispatchUsesItems(list, seen)
    if not list then return end
    for i = 1, #list do
        local itemFrame = list[i]
        if not seen[itemFrame] then
            seen[itemFrame] = true
            itemFrame:OnSpellUpdateUsesEvent()
        end
    end
end

function HUI_CDMCustomFrameMixin:DispatchOverlay(list, seen, isSpellOverlayed)
    if not list then return end
    for i = 1, #list do
        local itemFrame = list[i]
        if not seen[itemFrame] and itemFrame.type == "spell" and not itemFrame:IsBarFrame() then
            seen[itemFrame] = true
            local parent = itemFrame.realAuraFrame or itemFrame
            if isSpellOverlayed then
                ActionButtonSpellAlertManager:ShowAlert(itemFrame)
                if itemFrame.SpellActivationAlert then
                    itemFrame.SpellActivationAlert:SetFrameLevel(itemFrame:GetFrameLevel() + 10)
                end
            else
                ActionButtonSpellAlertManager:HideAlert(itemFrame)
            end
        end
    end
end

function HUI_CDMCustomFrameMixin:DispatchCast(list, seen)
    if not list then return end
    for i = 1, #list do
        local itemFrame = list[i]
        if not seen[itemFrame] then
            seen[itemFrame] = true
            if itemFrame.fakeAura then
                itemFrame:RefreshFakeAuraInfo(true)
                itemFrame:RefreshData()
            end
            itemFrame.isOnActualCooldown = true
        end
    end
end

function HUI_CDMCustomFrameMixin:OnEvent(event, ...)
    if not self.__spellIndex then self:ResetIndexes() end
    if event == "PLAYER_IN_COMBAT_CHANGED" or event == "PLAYER_LEVEL_CHANGED" then
		--self:UpdateShownState()
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        local slot, isEmpty = ...
        if slot == 13 or slot == 14 or slot == 16 or slot == 17 then
            self:RefreshLayout()
        end
    elseif event == "PLAYER_TOTEM_UPDATE" then
        local slot = ...
		local _haveTotem, name, startTime, duration, _icon, modRate, spellID = GetTotemInfo(slot)

        --[[ for _, frameName in ipairs(CooldownManagerFrames) do
            local frame = _G[frameName]
            if frame then
                for _, itemFrame in ipairs(frame:GetItemFrames()) do
                    local totemData = itemFrame:GetTotemData()
                    if totemData then
                        print(issecretvalue(totemData.slot), totemData.slot)
                    end
                end
            end
        end ]]
    elseif event == "PLAYER_TARGET_CHANGED" then
        local unit = ...
        for itemFrame in self.itemPool:EnumerateActive() do
            if itemFrame.auraUnit == "target" then
                local container = itemFrame:GetAuraContainer()
                if container then
                    container:UpdateAllAuras()
                end
            end
        end
    elseif event == "UNIT_DIED" then
        local guid = ...
        if not issecretvalue(guid) and (guid == UnitGUID("player") and not UnitIsFeignDeath("player")) then
            for itemFrame in self.itemPool:EnumerateActive() do
                if itemFrame.isOnAuraTimer then
                    itemFrame.isOnAuraTimer = false
                    itemFrame:ClearFakeAuraSavedInfo()
                end
            end
        end
    elseif event == "COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED" then
        local baseSpellID, overrideSpellID = ...
        if baseSpellID ~= nil and not issecretvalue(baseSpellID) then
            for itemFrame in self.itemPool:EnumerateActive() do
                if (itemFrame.type == "spell" or itemFrame.type == "slot")
                and (itemFrame.spellID == baseSpellID or itemFrame.baseSpellID == baseSpellID) then
                    itemFrame.overrideID = overrideSpellID
                    if overrideSpellID ~= nil and not issecretvalue(overrideSpellID) then
                        self:AddToIndex(self.__spellIndex, overrideSpellID, itemFrame)
                    end
                    itemFrame:RefreshData()
                end
            end
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        for itemFrame in self.itemPool:EnumerateActive() do
            itemFrame:RefreshData()
        end
    elseif event == "SPELL_UPDATE_COOLDOWN" then
        local spellID, baseSpellID, category, startRecoveryCategory, potionItemID = ...
        local seen = self.__dispatchSeen
        wipe(seen)
        local matched = false
        if spellID ~= nil and not issecretvalue(spellID) then
            local list = self:GetSpellIndexed(spellID)
            if list then matched = true end
            self:DispatchCooldown(list, seen)
        end
        if baseSpellID ~= nil and not issecretvalue(baseSpellID) then
            local list = self:GetSpellIndexed(baseSpellID)
            if list then matched = true end
            self:DispatchCooldown(list, seen)
        end
        if not matched and (spellID == nil or issecretvalue(spellID)) then
            for _, itemFrame in ipairs(self.__allSpellItems) do
                if not seen[itemFrame] then
                    seen[itemFrame] = true
                    itemFrame:OnSpellUpdateCooldownEvent()
                end
            end
            for _, itemFrame in ipairs(self.__allItemItems) do
                if not seen[itemFrame] then
                    seen[itemFrame] = true
                    itemFrame:OnSpellUpdateCooldownEvent()
                end
            end
            for _, itemFrame in ipairs(self.__allPotionItems) do
                if not seen[itemFrame] then
                    seen[itemFrame] = true
                    itemFrame:OnSpellUpdateCooldownEvent()
                end
            end
        end
        if category and not issecretvalue(category) and Addon.Potions.byCategory[category] and #self.__allPotionItems > 0 then
            local usedItemID
            if potionItemID ~= nil and not issecretvalue(potionItemID) then
                usedItemID = potionItemID
            end
            local usedSpellID
            if spellID ~= nil and not issecretvalue(spellID) then
                usedSpellID = spellID
            end
            if not usedItemID then
                local lastSpellID, lastItemID = C_Spell.GetLastCategoryCooldownSource(category)
                if lastItemID ~= nil and not issecretvalue(lastItemID) then
                    usedItemID = lastItemID
                    if not usedSpellID then
                        usedSpellID = lastSpellID
                    end
                end
            end
            for _, itemFrame in ipairs(self.__allPotionItems) do
                itemFrame:OnPotionUsed(category, usedItemID, usedSpellID)
            end
        end
        if startRecoveryCategory == 133 then
            for _, itemFrame in ipairs(self.__allSpellItems) do
                if not seen[itemFrame] then
                    local cooldownFrame = itemFrame:GetCooldownFrame()
                    if cooldownFrame.showGCDSwipe then
                        itemFrame.isOnChargeCooldown = false
                        itemFrame.isOnActualCooldown = false
                        itemFrame:RefreshSpellCooldownInfo()
                        itemFrame:RefreshVisibility()
                    end
                end
            end
            for _, itemFrame in ipairs(self.__allItemItems) do
                if (itemFrame.type == "slot" or itemFrame.type == "item") and not seen[itemFrame] then
                    local cooldownFrame = itemFrame:GetCooldownFrame()
                    if cooldownFrame.showGCDSwipe then
                        itemFrame.isOnChargeCooldown = false
                        itemFrame.isOnActualCooldown = false
                        itemFrame:RefreshSpellCooldownInfo()
                        itemFrame:RefreshVisibility()
                    end
                end
            end
        end
    elseif event == "SPELL_UPDATE_CHARGES" then
        for _, itemFrame in ipairs(self.__allSpellItems) do
            itemFrame:RefreshSpellCooldownInfo()
            itemFrame:RefreshCount()
            itemFrame:RefreshVisibility()
        end
    elseif event == "SPELL_UPDATE_USES" then
        local spellID, baseSpellID = ...
        local seen = self.__dispatchSeen
        wipe(seen)
        self:DispatchUsesItems(self:GetSpellIndexed(spellID), seen)
        self:DispatchUsesItems(self:GetSpellIndexed(baseSpellID), seen)
    elseif event == "SPELL_UPDATE_USABLE" then
        for _, itemFrame in ipairs(self.__allSpellItems) do
            itemFrame:RefreshIconColor()
        end
    elseif event == "SPELL_UPDATE_ICON" then
        local spellID = ...
        local list = self:GetSpellIndexed(spellID)
        if list then
            for i = 1, #list do
                list[i]:RefreshSpellTexture()
            end
        end
    elseif event == "ITEM_COUNT_CHANGED" then
        local itemID = ...
        local list
        if itemID ~= nil and not issecretvalue(itemID) then
            list = self:GetItemIndexed(itemID)
        end
        if list then
            for i = 1, #list do
                list[i]:RefreshCount()
            end
        else
            for _, itemFrame in ipairs(self.__allItemItems) do
                if itemFrame.type == "item" then
                    itemFrame:RefreshCount()
                    itemFrame:RefreshVisibility()
                end
            end
        end
        if #self.__allPotionItems > 0 then
            local isPotionItem = (itemID ~= nil and not issecretvalue(itemID)) and Addon.Potions.byItemID[itemID] ~= nil
            if isPotionItem or itemID == nil or issecretvalue(itemID) then
                for _, itemFrame in ipairs(self.__allPotionItems) do
                    itemFrame:OnPotionCountChanged()
                end
            end
        end
    elseif event == "BAG_UPDATE_DELAYED" then
        for _, itemFrame in ipairs(self.__allItemItems) do
            if itemFrame.type == "item" then
                itemFrame:RefreshSpellCooldownInfo()
                itemFrame:RefreshCount()
                itemFrame:RefreshVisibility()
            end
        end
        for _, itemFrame in ipairs(self.__allPotionItems) do
            itemFrame:OnPotionCountChanged()
        end
    elseif event == "BAG_UPDATE_COOLDOWN" then
        for _, itemFrame in ipairs(self.__allItemItems) do
            if itemFrame.type == "item" then
                itemFrame:RefreshSpellCooldownInfo()
                itemFrame:RefreshCount()
                itemFrame:RefreshVisibility()
            end
        end
        for _, itemFrame in ipairs(self.__allPotionItems) do
            itemFrame:RefreshSpellCooldownInfo()
            itemFrame:RefreshCount()
            itemFrame:RefreshVisibility()
        end
    elseif event == "UNIT_AURA" then
        local unitTarget = ...
        if unitTarget == "player" and #self.__allPotionItems > 0 then
            for _, itemFrame in ipairs(self.__allPotionItems) do
                itemFrame:SchedulePotionUpdate()
            end
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        local spellID = ...
        local baseSpellID = C_Spell.GetBaseSpell(spellID)
        local seen = self.__dispatchSeen
        wipe(seen)
        self:DispatchOverlay(self:GetSpellIndexed(spellID), seen, true)
        self:DispatchOverlay(self:GetSpellIndexed(baseSpellID), seen, true)
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        local spellID = ...
        local baseSpellID = C_Spell.GetBaseSpell(spellID)
        local seen = self.__dispatchSeen
        wipe(seen)
        self:DispatchOverlay(self:GetSpellIndexed(spellID), seen, false)
        self:DispatchOverlay(self:GetSpellIndexed(baseSpellID), seen, false)
    elseif event == "ENCOUNTER_END" then
        local encounterID, encounterName, difficultyID, groupSize, success = ...
        if difficultyID > 13 and difficultyID < 18 then
            local function clearEncounterFlags(itemFrame)
                itemFrame.isOnActualCooldown = false
                itemFrame.isOnChargeCooldown = false
                itemFrame:ScheduleRefreshData()
            end
            for _, itemFrame in ipairs(self.__allSpellItems) do
                clearEncounterFlags(itemFrame)
            end
            for _, itemFrame in ipairs(self.__allItemItems) do
                clearEncounterFlags(itemFrame)
            end
            for _, itemFrame in ipairs(self.__allPotionItems) do
                clearEncounterFlags(itemFrame)
            end
        end
    elseif event == "SPELL_RANGE_CHECK_UPDATE" then
        local spellID, inRange, checksRange = ...
        local list = self:GetRangeIndexed(spellID)
        if list then
            for i = 1, #list do
                local itemFrame = list[i]
                if not checksRange or inRange then
                    itemFrame.spellOutOfRange = false
                else
                    itemFrame.spellOutOfRange = true
                end
                itemFrame:RefreshIconColor()
            end
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unitTarget, castGUID, spellID = ...
        local seen = self.__dispatchSeen
        wipe(seen)
        self:DispatchCast(self:GetSpellIndexed(spellID), seen)
        if IsHealthstoneCreateCast(spellID) then
            for _, itemFrame in ipairs(self.__allItemItems) do
                if itemFrame.type == "item" then
                    itemFrame:ScheduleCountRefresh()
                end
            end
        end
    end
    
    if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" 
    or event == "CHALLENGE_MODE_START"
    or event == "UNIT_PET" then
        local currentTime = GetTime()
        if self.lastRunTime and currentTime - self.lastRunTime > 0.1 then
            self.lastRunTime = currentTime
            self:RefreshLayout()
        end
    end
    if event == "FIRST_FRAME_RENDERED" then
        HUI_CDMCustomFrameCustomized:RefreshAnchors(self, self.frameName)
    end
end

function HUI_CDMCustomFrameMixin:OnUpdate()

end

function HUI_CDMCustomFrameMixin:SetGridPadding(padding)
    padding = padding or (Addon:GetValue("CDMCustomIconPadding", nil, self.frameName) or 2)
    self.Container.childXPadding = padding
    self.Container.childYPadding = padding
end

function HUI_CDMCustomFrameMixin:SetGridDirection()
    local isHorizontal = Addon:GetValue("CDMCustomGridDirection", nil, self.frameName) == 1
    self.Container.isHorizontal = isHorizontal
end

function HUI_CDMCustomFrameMixin:SetGridStride()
    local stride = Addon:GetValue("CDMCustomStride", nil, self.frameName) or 7
    self.Container.stride = stride
end
    -- true - grows UP, false - grows DOWN
function HUI_CDMCustomFrameMixin:SetGridVerticalGrowth()

    local goingUp = Addon:GetValue("CDMVerticalGrowth", nil, self.frameName)
    self.Container.__layoutFramesGoingUp = goingUp
end
    -- true - grows LEFT, false - grows RIGHT
function HUI_CDMCustomFrameMixin:SetGridHorizontalGrowth()
    local goingRight = Addon:GetValue("CDMHorizontalGrowth", nil, self.frameName) == 1
    self.Container.layoutFramesGoingRight = goingRight
end

function HUI_CDMCustomFrameMixin:SetGridCentered(isCentered)
    self.Container.isCentered = isCentered
end

function HUI_CDMCustomFrameMixin:SetupGridLayoutParams()
    local padding = 2

    if Addon:GetValue("UseCDMCustomIconPadding", nil, self.frameName) then
        padding = (Addon:GetValue("CDMCustomIconPadding", nil, self.frameName) or 2)
    end

    local goingUp = Addon:GetValue("CDMVerticalGrowth", nil, self.frameName) == 1

    local goingRight = Addon:GetValue("CDMHorizontalGrowth", nil, self.frameName) == 1

    local isHorizontal = Addon:GetValue("CDMCustomGridDirection", nil, self.frameName) == 1

    local stride = 7

    if Addon:GetValue("UseCDMCustomStride", nil, self.frameName) then
        stride = (Addon:GetValue("CDMCustomStride", nil, self.frameName) or 7)
    end

    local container = self.Container
    container.childXPadding = padding
	container.childYPadding = padding
	container.isHorizontal = isHorizontal
	container.stride = stride
	container.layoutFramesGoingRight = goingRight
	container.layoutFramesGoingUp = goingUp
    container.alwaysUpdateLayout = true
    container.gridLayoutType = Addon:GetValue("CDMGridLayoutType", nil, self.frameName)
    container.hideInactiveType = Addon:GetValue("CurrentHideWhenInactive", nil, self.frameName)
    container.isCentered = tonumber(container.gridLayoutType) == 1
    container.keepEmpty = tonumber(container.gridLayoutType) == 3
    container.childrenSize = 30
end

function HUI_CDMCustomFrameMixin:OnAcquireItemFrame(itemFrame)
    itemFrame.wasAuraShown = itemFrame.wasAuraShown or false
    itemFrame.isOnActualCooldown = itemFrame.isOnActualCooldown or false
    local applications = itemFrame.Icon.Applications or itemFrame.Applications
    applications.Applications:SetText("")
    itemFrame.fakeAura = itemFrame:GetFakeAura()
    itemFrame.stages = nil
    itemFrame:FindAuraSpellID()
    --itemFrame:RefreshVisibility()
    --itemFrame:RefreshCount()
    itemFrame:RefreshData()
	--itemFrame:SetHideWhenInactive(self.hideWhenInactive);
end

function HUI_CDMCustomFrameMixin:FindKnownInCDM(spellID)
    for cdID, data in pairs(CooldownViewerSettings:GetDataProvider():GetDisplayData().cooldownInfoByID) do
        local itemSpellID = data.spellID
        if not issecretvalue(itemSpellID) and itemSpellID == spellID and data.isKnown then
            return true
        end
    end
    return false
end

function HUI_CDMCustomFrameMixin:GetVisibleChildren()

    self.visibleChildren = {}
    self.hasSpellElement = false
    if not self.__pendingItemLoads then self.__pendingItemLoads = {} end

    for index, data in ipairs(self.itemList) do
        local isKnown = false
        local isRacial = false
        if data.type == "spell" and (data.baseID or data.id) then
            if Addon:IsRacialSpell(data.id) then
                Addon:LoadRacialTable()
                isRacial = true
                data.id = Addon:GetRacialSpell() or data.id
            end
            
            isKnown = self:FindKnownInCDM(data.baseID or data.id)

            if not isKnown then
                for i=1, 0, -1 do
                    if not isKnown then
                        isKnown = C_SpellBook.IsSpellKnownOrInSpellBook(data.baseID or data.id, i)
                    end
                end
            end

            if isRacial then
                local currentProfile = Addon:GetCurrentProfile()
                local trackedTable = HUIDB.Profiles.profilesList[currentProfile]["GlobalSettings"].RacialSpellsTracked
                local raceID = select(3, UnitRace("player"))
                
                if raceID == 25 or raceID == 26 then
                    raceID = 24
                elseif raceID == 70 then
                    raceID = 52
                elseif raceID == 85 then
                    raceID = 84
                elseif raceID == 91 then
                    raceID = 86
                end

                if trackedTable and not trackedTable[raceID] then
                    isKnown = false
                end
            end
        end
        local slotItemID
        if data.type == "slot" then
            local itemInfo = C_TooltipInfo.GetInventoryItem("player", data.id)
            local itemID = itemInfo and itemInfo.id or GetInventoryItemID("player", data.id)
            slotItemID = itemID
            if not itemID then
                self:RequestResolveRetry(data.id)
            else
                if self.__resolveRetryAttempts then self.__resolveRetryAttempts[data.id] = nil end
                if data.baseID ~= itemID then
                    self:UpdateSlotBaseID(data, itemID)
                end
                if not C_Item.IsItemDataCachedByID(itemID) and C_Item.DoesItemExistByID(itemID) then
                    C_Item.RequestLoadItemDataByID(itemID)
                    if not self.__pendingItemLoads[itemID] then
                        self.__pendingItemLoads[itemID] = true
                        Item:CreateFromItemID(itemID):ContinueOnItemLoad(function()
                            self.__pendingItemLoads[itemID] = nil
                            self:RefreshLayout()
                        end)
                    end
                    return
                end
                local spellName, spellID = C_Item.GetItemSpell(itemID)

                isKnown = spellID and true or false
            end
        end
        if data.type == "item" then
            isKnown = true

            local isHealthstone = IsHealthstoneItem(data.id)

            if isHealthstone then
                local isDemonicHs = C_SpellBook.IsSpellKnown(386689)
                if isDemonicHs then
                    data.id = 224464
                else
                    data.id = 5512
                end
            end

            if not C_Item.IsItemDataCachedByID(data.id) then
                if not self.__pendingItemLoads[data.id] then
                    self.__pendingItemLoads[data.id] = true
                    local itemData = Item:CreateFromItemID(tonumber(data.id))
                    itemData:ContinueOnItemLoad(function()
                        self.__pendingItemLoads[data.id] = nil
                        self:RefreshLayout()
                    end)
                end
                return                
            end
            local spellName, spellID = C_Item.GetItemSpell(data.id)
            local count = C_Item.GetItemCount(data.id, nil, true) or 0
            local isUsable = C_Item.IsUsableItem(data.id)
            if spellID then
                if self.__resolveRetryAttempts then self.__resolveRetryAttempts[data.id] = nil end
            else
                self:RequestResolveRetry(data.id)
            end
            --[[ local hideEmpty = Addon:GetValue("CDMCustomHideEmpty", nil, self.frameName)
            if not spellID or ( count == 0 and hideEmpty ) then
                isKnown = false
            end ]]
        end
        if data.type == "potion" then
            local potInfo = Addon.Potions.byType[data.potType]
            isKnown = potInfo ~= nil
            if potInfo then
                for _, potItemID in ipairs(potInfo.items) do
                    if not C_Item.IsItemDataCachedByID(potItemID) then
                        C_Item.RequestLoadItemDataByID(potItemID)
                        if not self.__pendingItemLoads[potItemID] then
                            self.__pendingItemLoads[potItemID] = true
                            Item:CreateFromItemID(potItemID):ContinueOnItemLoad(function()
                                self.__pendingItemLoads[potItemID] = nil
                                self:RefreshLayout()
                            end)
                        end
                    end
                end
            end
        end
        if isKnown then
            local item = self.itemPool:Acquire()
            item.layoutIndex = index
            if data.type == "spell" then
                item:SetSpellID(data.id, data.baseID)
                self.hasSpellElement = true
            elseif data.type == "item" then
                item:SetItemID(data.id)
            elseif data.type == "potion" then
                item:SetPotionType(data.potType)
            elseif data.type == "slot" then
                item:SetSlotID(data.id, slotItemID)
            end
            
            item.type = data.type

            item:Show()
            table.insert(self.visibleChildren, item)
            item.parentName = self.frameName
            self:IndexItemFrame(item)
            self:OnAcquireItemFrame(item)
        end
	end
    --self:RegisterUnitAura()
    return self.visibleChildren

end

function HUI_CDMCustomFrameMixin:RefreshLayout()
    if not self.itemList then return end

    self:SetupGridLayoutParams()

    if self.itemPool then
	    self.itemPool:ReleaseAll()
    end
	local dataProvider = CreateDataProvider(self.itemList)

    self:ResetIndexes()
    local visibleChildren = self:GetVisibleChildren()

    if not visibleChildren then
        return
    end

    if self.itemPool:GetNumActive() == 0 then
        --show empty
    end

    HUI_CDMCustomFrameCustomized:RefreshSkin(self, self.frameName)

    self.Container.__wasVisibleChildren = nil

    if self.Container.isCentered then
        --self.Container:SetCollapsesLayout(true)
        Addon:ApplyCenteredGridLayout(self.Container, visibleChildren, self.Container.stride, self.Container.childXPadding)
    else
        Addon:ApplyStandardGridLayout(self.Container, visibleChildren, self.Container.stride, self.Container.childXPadding)
    end
	--self.Container:Layout()
    self:ResizeFrame(self, visibleChildren)
end

function HUI_CDMCustomFrameMixin:RefreshVisibileOnCD()
    if not self.visibleChildren then return end

    self.__layoutDirty = true
    if not self.__relayoutScheduled then
        self.__relayoutScheduled = true
        RunNextFrame(function()
            self.__relayoutScheduled = nil
            if not self.__layoutDirty then return end
            self.__layoutDirty = nil

            for _, frame in ipairs(self.visibleChildren) do
                frame.__isEditing = self.isEditing
            end

            if self.Container.isCentered then
                Addon:ApplyCenteredGridLayout(self.Container, self.visibleChildren, self.Container.stride, self.Container.childXPadding)
            else
                Addon:ApplyStandardGridLayout(self.Container, self.visibleChildren, self.Container.stride, self.Container.childXPadding)
            end

            self:ResizeFrame(self, self.visibleChildren)
        end)
    end
end

function HUI_CDMCustomFrameMixin:ResizeFrame(frame, visibleChildren)
    local layoutChildren = visibleChildren or self.Container:GetLayoutChildren()

    if #layoutChildren == 0 then
        Addon.PP.Size(frame, 1)
        local container = self.Container
        if container:GetWidth() ~= 38 or container:GetHeight() ~= 38 then
            Addon.PP.Size(container, 38)
            self:UpdateContainerAnchor()
        end
        self.__lastSize = nil
        self.__lastSize2 = nil
        return 
    end

    local width = layoutChildren[1]:GetWidth()
    local height = layoutChildren[1]:GetHeight()

    if width == 0 or height == 0 then
        width, height = 40, 40
    end

    local numActive = self.itemPool:GetNumActive()
    local isHorizontal = self.Container.isHorizontal
    local padding = Addon.PP.Scale(self.Container.childXPadding or 0)
    local stride = self.Container.stride

    stride = math.min(stride, #layoutChildren)

    local numRows = math.ceil(numActive / stride)
    local totalWidth
    local totalHeight
    if isHorizontal then
        totalWidth = (stride * width) + ((stride - 1) * padding)
        totalHeight = (numRows * height) + ((numRows - 1) * padding)
    else
        totalWidth = (numRows * width) + ((numRows - 1) * padding)
        totalHeight = (stride * height) + ((stride - 1) * padding)
    end
    if self.Container.isCentered then
        --frame:SetSize(totalWidth, totalHeight)
    end

    if self.__lastSize == totalWidth and self.__lastSize2 == totalHeight then
        return
    end
    self.__lastSize = totalWidth
    self.__lastSize2 = totalHeight

    Addon.PP.Size(frame, 1)
    Addon.PP.Size(frame, width, height)
    Addon.PP.Size(self.Container, totalWidth, totalHeight)
    self:UpdateContainerAnchor()
end

function HUI_CDMCustomFrameMixin:UpdateContainerAnchor()
    local container = self.Container
    local goingRight = container.layoutFramesGoingRight
    local goingUp = container.layoutFramesGoingUp
    local isCentered = container.isCentered

    local point, relativePoint
    if isCentered then
        point = "CENTER"
    elseif goingUp then
        point = goingRight and "BOTTOMLEFT" or "BOTTOMRIGHT"
    else
        point = goingRight and "TOPLEFT" or "TOPRIGHT"
    end

    if self.__lastAnchorPoint == point then
        return
    end
    self.__lastAnchorPoint = point

    container:ClearAllPoints()
    container:SetPoint(point, self, point)
end

function HUI_CDMCustomFrameMixin:CreateFrame(name, parent, point, relativePoint, offsetX, offsetY, template)
    parent = parent or _G["UIParent"]
    point = point or "CENTER"
    relativePoint = relativePoint or "CENTER"
    template = template or "HUI_CDMCustomFrame"

    local frame = CreateFrame("Frame", name, UIParent, template)
    frame:Show()
    frame:SetPoint(point, UIParent, relativePoint, Addon.PP.Snap(offsetX) or 0, Addon.PP.Snap(offsetY) or 0)
    frame:SetFrameLevel(2)
    frame.template = template
    
    self.template = template

    return frame, { x = offsetX, y = offsetY }
end

function HUI_CDMCustomFrameMixin:DeleteFrame()
    
end

function HUI_CDMCustomFrameMixin:IsBarFrame()
    return self.template == "HUI_CDMCustomBarFrame"
end

function HUI_CDMCustomFrameMixin:GetTemplate()
    return self.template
end
--------------------------------

local HUI_CDMCustomFrameSelectionLayout =
{
	["TopRightCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, x=8, y=8 },
	["TopLeftCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, x=-8, y=8 },
	["BottomLeftCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, x=-8, y=-8 },
	["BottomRightCorner"] = { atlas = "%s-NineSlice-Corner",  mirrorLayout = true, x=8, y=-8 },
	["TopEdge"] = { atlas = "_%s-NineSlice-EdgeTop" },
	["BottomEdge"] = { atlas = "_%s-NineSlice-EdgeBottom" },
	["LeftEdge"] = { atlas = "!%s-NineSlice-EdgeLeft" },
	["RightEdge"] = { atlas = "!%s-NineSlice-EdgeRight" },
	["Center"] = { atlas = "%s-NineSlice-Center", x = -8, y = 8, x1 = 8, y1 = -8, },
}


HUI_CDMCustomFrameSelectionMixin = {}

HUI_CDMCustomFrameSelectionManager = {}

function HUI_CDMCustomFrameSelectionMixin:OnLoad()
    self:SetSelected(false)
    NineSliceUtil.ApplyLayout(self.MouseOverHighlight, HUI_CDMCustomFrameSelectionLayout, self.highlightTextureKit)
    self.MouseOverHighlight:SetBlendMode("ADD")
end

function HUI_CDMCustomFrameSelectionMixin:OnShow()
    local parent = self:GetParent()
    parent.PulseAnim:Play()

    parent.isEditing = true
    if parent.RefreshVisibileOnCD then
        parent:RefreshVisibileOnCD()
    end
    if parent.UpdatePlaceholders then
        parent:UpdatePlaceholders(true)
    end
end
function HUI_CDMCustomFrameSelectionMixin:OnHide()
    local parent = self:GetParent()
    parent.PulseAnim:Stop()

    parent.isEditing = false
    if parent.RefreshVisibileOnCD then
        parent:RefreshVisibileOnCD()
    end
    if parent.UpdatePlaceholders then
        parent:UpdatePlaceholders()
    end
end

function HUI_CDMCustomFrameSelectionMixin:OnDragStart()
    self:GetParent().moving = true
    self:GetParent():StartMoving()
end

function HUI_CDMCustomFrameSelectionMixin:OnDragStop()
    local frame = self:GetParent()
    frame.moving = nil
    frame:StopMovingOrSizing()

    local frameName = frame:GetName()
    local centerX, centerY = frame:GetCenter()
    local uiCenterX, uiCenterY = UIParent:GetCenter()
    local offsetX = Addon.PP.SnapCenterForDim(centerX - uiCenterX, frame:GetWidth())
    local offsetY = Addon.PP.SnapCenterForDim(centerY - uiCenterY, frame:GetHeight())

    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", offsetX, offsetY)

    if profileTable["CDMCustomFrames"] then
        for index, data in ipairs(profileTable["CDMCustomFrames"]) do
            if data.label == frameName then
                data.point.x = offsetX
                data.point.y = offsetY
            end
        end
    end
end

local movementKeys = {
	UP = true,
	DOWN = true,
	LEFT = true,
	RIGHT = true,
}

function HUI_CDMCustomFrameSelectionMixin:OnKeyDown(key)
    if not self.isSelected then return end

	if movementKeys[key] then
		self:ProcessMovementKey(key)
    elseif key == "ESCAPE" then
        self:SetSelected(false)
    end
end

function HUI_CDMCustomFrameSelectionMixin:OnMouseDown(button)
    if not self.isSelected then
        self:SetSelected(true)
    end
end

function HUI_CDMCustomFrameSelectionMixin:ProcessMovementKey(key)
    local frame = self:GetParent()

	if not self.isSelected then
		return
	end

	local onePixel = Addon.PP.perfect / (UIParent and UIParent:GetEffectiveScale() or 1)
	local deltaAmount = onePixel
    if IsShiftKeyDown() then
        deltaAmount = onePixel * 10
    elseif IsAltKeyDown() then
        deltaAmount = onePixel * 100
    end

	local xDelta, yDelta = 0, 0
	if key == "UP" then
		yDelta = deltaAmount
	elseif key == "DOWN" then
		yDelta = -deltaAmount
	elseif key == "LEFT" then
		xDelta = -deltaAmount
	elseif key == "RIGHT" then
		xDelta = deltaAmount
	end

	frame:StopMovingOrSizing()
	self:OnPositionChange(xDelta, yDelta)
end

function HUI_CDMCustomFrameSelectionMixin:OnPositionChange(deltaX, deltaY)
   
    local frame = self:GetParent()
    local frameName = frame:GetName()

    local centerX, centerY = frame:GetCenter()
    local uiCenterX, uiCenterY = UIParent:GetCenter()
    local offsetX = Addon.PP.SnapCenterForDim((centerX - uiCenterX) + deltaX, frame:GetWidth())
    local offsetY = Addon.PP.SnapCenterForDim((centerY - uiCenterY) + deltaY, frame:GetHeight())

    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", offsetX, offsetY)

    if profileTable["CDMCustomFrames"] then
        for index, data in ipairs(profileTable["CDMCustomFrames"]) do
            if data.label == frameName then
                data.point.x = offsetX
                data.point.y = offsetY
            end
        end
    end
end

function HUI_CDMCustomFrameSelectionMixin:OnEnter()
    self.MouseOverHighlight:SetShown(true)
    self.Label:SetFontObjectsToTry("GameFontHighlightLarge", "GameFontHighlightMedium", "GameFontHighlightSmall", "GameFontWhiteTiny2")
    self.Label:SetText(self:GetParent():GetDisplayName())
    self.Label:Show()
    self.Label:SetIgnoreParentAlpha(true)
end

function HUI_CDMCustomFrameSelectionMixin:OnLeave()
    self.MouseOverHighlight:SetShown(false)
    self.Label:Hide()
end

function HUI_CDMCustomFrameSelectionMixin:SetSelected(selected)
    local selectionManager = HUI_CDMCustomFrameSelectionManager
    self.isSelected = selected
    if self.isSelected then
        if selectionManager.currentlySelected and selectionManager.currentlySelected ~= self then
            selectionManager.currentlySelected:SetSelected(false)
        end
        selectionManager.currentlySelected = self
        
        self:EnableKeyboard(true)
		NineSliceUtil.ApplyLayout(self, HUI_CDMCustomFrameSelectionLayout, self.selectedTextureKit)

        self.FrameGrid:Show()
	else
        if selectionManager.currentlySelected == self then
            selectionManager.currentlySelected = nil
        end

        self:EnableKeyboard(false)
        NineSliceUtil.ApplyLayout(self, HUI_CDMCustomFrameSelectionLayout, self.highlightTextureKit)

        self.FrameGrid:Hide()
    end
end

-----------------------------------------------


local function OnCreateNewMenuFrame(self, frameLabel, displayName, template)
    local frame = HUI_CDMCustomFrameMixin:CreateFrame(frameLabel, nil, nil, nil, 0, 0, template)
    frame:SetDisplayName(displayName)
end

local function OnDeleteMenuFrame(self, frameLabel)
    local frame = _G[frameLabel]
    if frame then
        if frame.itemPool then
            frame.itemPool:ReleaseAll()
        end
        frame:UnregisterAllEvents()
        frame:Hide()
        _G[frameLabel] = nil
    end

    if pinnedFrameLabel == frameLabel then
        pinnedFrameLabel = nil
    end

    local frameIndex = HUI_CDMCustomFrameMixin:GetFrameIndexByName(frameLabel)
    if profileTable["CDMCustomFrames"] then
        if frameLabel == profileTable["CDMCustomFrames"][frameIndex].label then
            table.remove(profileTable["CDMCustomFrames"], frameIndex)
        end
    end
    if profileTable[frameLabel] then
        wipe(profileTable[frameLabel])
        profileTable[frameLabel] = nil
    end
end

local function CreateFrameForData(data)
    local frame = HUI_CDMCustomFrameMixin:CreateFrame(data.label, nil, nil, nil, data.point and data.point.x or 0, data.point and data.point.y or 0, data.template)
    frame:SetDisplayName(data.name)
    return frame
end

local function DestroyFrameByLabel(label)
    local frame = _G[label]
    if frame then
        if HUI_CDMCustomFrameSelectionManager.currentlySelected == frame then
            HUI_CDMCustomFrameSelectionManager.currentlySelected = nil
        end
        if frame.itemPool then
            frame.itemPool:ReleaseAll()
        end
        frame:UnregisterAllEvents()
        frame.itemList = nil
        frame:Hide()
        _G[label] = nil
    end
end

function Addon:CDMPinCustomFrame(label)
    if not label then return end
    if pinnedFrameLabel ~= label and pinnedFrameLabel then
        self:CDMUnpinCustomFrame(pinnedFrameLabel)
    end
    pinnedFrameLabel = label
    if _G[label] then return end

    local frameIndex = HUI_CDMCustomFrameMixin:GetFrameIndexByName(label)
    local data = profileTable["CDMCustomFrames"] and profileTable["CDMCustomFrames"][frameIndex]
    if data then
        CreateFrameForData(data)
    end
end

function Addon:CDMUnpinCustomFrame(label)
    if pinnedFrameLabel ~= label then return end
    pinnedFrameLabel = nil

    local _, specID = Addon:CDMGetPlayerClassSpec()
    local frameIndex = HUI_CDMCustomFrameMixin:GetFrameIndexByName(label)
    local data = profileTable["CDMCustomFrames"] and profileTable["CDMCustomFrames"][frameIndex]
    if data and not Addon:CDMSpecMatches(data, _, specID) then
        DestroyFrameByLabel(label)
    end
end

local function CreateProfileCustomFrames()
    if not profileTable or not profileTable["CDMCustomFrames"] then return end

    local _, specID = Addon:CDMGetPlayerClassSpec()
    for _, data in ipairs(profileTable["CDMCustomFrames"]) do
        if data and Addon:CDMSpecMatches(data, _, specID) then
            CreateFrameForData(data)
        end
    end
end

local function DestroyProfileCustomFrames()
    HUI_CDMCustomFrameSelectionManager.currentlySelected = nil
    pinnedFrameLabel = nil

    if not profileTable or not profileTable["CDMCustomFrames"] then return end

    for _, data in ipairs(profileTable["CDMCustomFrames"]) do
        if data and data.label then
            DestroyFrameByLabel(data.label)
        end
    end
end

local function OnProfileChanged(self)
    DestroyProfileCustomFrames()
    profileTable = Addon:GetCurrentProfileTable()
    CreateProfileCustomFrames()
end

local eventHandlerFrame = CreateFrame('Frame')

local function OnPlayerSpecChanged()
    if not profileTable or not profileTable["CDMCustomFrames"] then return end

    local _, specID = Addon:CDMGetPlayerClassSpec()

    for _, data in ipairs(profileTable["CDMCustomFrames"]) do
        local label = data and data.label
        if label then
            local matches = Addon:CDMSpecMatches(data, _, specID)
            local exists = _G[label] ~= nil
            if matches and not exists then
                CreateFrameForData(data)
            elseif not matches and exists and label ~= pinnedFrameLabel then
                DestroyFrameByLabel(label)
            end
        end
    end
end

local function OnFramePickerEnter()
    if not profileTable or not profileTable["CDMCustomFrames"] then return end
    for _, data in ipairs(profileTable["CDMCustomFrames"]) do
        local frame = data and data.label and _G[data.label]
        if frame and not frame.__pickerMode then
            frame.__pickerMode = {
                shown = frame:IsShown(),
                alpha = frame:GetAlpha(),
                mouseClicks = frame:IsMouseClickEnabled(),
                mouseMotion = frame:IsMouseMotionEnabled(),
            }
            if not frame:IsShown() then frame:Show() end
            frame:SetAlpha(1)
            frame:SetMouseClickEnabled(true)
            frame:SetMouseMotionEnabled(true)
        end
    end
end

local function OnFramePickerExit()
    if not profileTable or not profileTable["CDMCustomFrames"] then return end
    for _, data in ipairs(profileTable["CDMCustomFrames"]) do
        local frame = data and data.label and _G[data.label]
        if frame and frame.__pickerMode then
            local state = frame.__pickerMode
            frame.__pickerMode = nil
            frame:SetAlpha(state.alpha)
            frame:SetMouseClickEnabled(state.mouseClicks)
            frame:SetMouseMotionEnabled(state.mouseMotion)
            if not state.shown then frame:Hide() end
        end
    end
end

Addon:RegisterEvent("PLAYER_LOGIN", function()
    BuildSpellIDToAuraSpellID()

    if not HUI_FAKE_AURAS then
        HUI_FAKE_AURAS = {}
    end

    profileTable = Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()

    EventRegistry:RegisterCallback("CDMCustomItemList.CreateNewFrame", OnCreateNewMenuFrame, eventHandlerFrame)
    EventRegistry:RegisterCallback("CDMCustomItemList.DeleteFrame", OnDeleteMenuFrame, eventHandlerFrame)
    EventRegistry:RegisterCallback("CDMCustomItemList.ProfileChanged", OnProfileChanged, eventHandlerFrame)
    EventRegistry:RegisterCallback("HUI.FramePicker.Enter", OnFramePickerEnter, eventHandlerFrame)
    EventRegistry:RegisterCallback("HUI.FramePicker.Exit", OnFramePickerExit, eventHandlerFrame)

    eventHandlerFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    eventHandlerFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
    eventHandlerFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
            OnPlayerSpecChanged()
        end
    end)

    CreateProfileCustomFrames()
end, "CooldownManagerCustom")
local Addon = _G.HUI

HUI_CDMCustomAuraMixin = {}

local ElemBlastSpellIDs = {
	[173184] = true,
	[118522] = true,
	[173183] = true,
}

local auraUnitByOverrideID = {
	[1] = "player",
	[2] = "target",
}
local auraTypeByOverrideID = {
	[1] = "HELPFUL",
	[2] = "HARMFUL",
}

function HUI_CDMCustomAuraMixin:GetAuraUnitOverride(spellID)
	local frameIndex = self:GetFrameIndexByName(self.frameName)
	local profileTable = self:GetProfileTable()
	if profileTable["CDMCustomFrames"] then
		local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
		if frameTbl then
			Addon.MigrateAuraOverrides(frameTbl)
			if frameTbl.auraUnits then
				return auraUnitByOverrideID[frameTbl.auraUnits[spellID]]
			end
		end
	end
end

function HUI_CDMCustomAuraMixin:GetAuraTypeOverride(spellID)
	local frameIndex = self:GetFrameIndexByName(self.frameName)
	local profileTable = self:GetProfileTable()
	if profileTable["CDMCustomFrames"] then
		local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
		if frameTbl then
			Addon.MigrateAuraOverrides(frameTbl)
			if frameTbl.auraTypes then
				return auraTypeByOverrideID[frameTbl.auraTypes[spellID]]
			end
		end
	end
end

function HUI_CDMCustomAuraMixin:GetProfileTable()
	return Addon.CurrentProfileTbl or Addon:GetCurrentProfileTable()
end

function HUI_CDMCustomAuraMixin:OnLoad()
	self.frameName = self:GetName()
	HUI_CDMCustomFrameCustomized:ApplyFrameStrataAndLevel(self)

	--[[
	self.auraSoundIDs = {}
	--]]

	self:SetMovable(true)

	local profileTable = self:GetProfileTable()
	local frameTbl
	if profileTable["CDMCustomFrames"] then
		frameTbl = profileTable["CDMCustomFrames"][self:GetFrameIndexByName(self.frameName)]
	end
	if frameTbl then
		self.itemList = frameTbl.trackedIDs or {}
		self.displayName = frameTbl.name
	end

	self.hideInactive = false

	self:SetMouseClickEnabled(false)

	self:SetupAppearance()
	self:CreateAuraContainer()
	self:RefreshAuraList()

	self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.EndOrderChange", self.OnCustomItemListReorderEnded)
	self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.ItemAdded", self.OnCustomItemListItemUpdate)
	self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.ItemRemoved", self.OnCustomItemListItemUpdate)
	self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AuraUnitChanged", self.OnAuraOverrideChanged)
	self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AuraTypeChanged", self.OnAuraOverrideChanged)
	--[[
	self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AuraSoundChanged", self.OnAuraSoundChanged)
	--]]
	self:AddDynamicEventMethod(EventRegistry, "EditMode.Enter", self.OnEditModeEnter)
	self:AddDynamicEventMethod(EventRegistry, "EditMode.Exit", self.OnEditModeExit)

	Addon:BarsFadeAnim(self)

	C_Timer.After(0.5, function()
		self:RefreshAuraList()
	end)
	self:SetCollapsesLayout(true)
end

function HUI_CDMCustomAuraMixin:GetDisplayName()
	return self.displayName
end

function HUI_CDMCustomAuraMixin:SetDisplayName(name)
	self.displayName = name
end

function HUI_CDMCustomAuraMixin:GetFrameIndexByName(frameName)
	local profileTable = self:GetProfileTable()
	if profileTable["CDMCustomFrames"] then
		for index, data in ipairs(profileTable["CDMCustomFrames"]) do
			if data.label == frameName then
				return index
			end
		end
	end

	return false
end

function HUI_CDMCustomAuraMixin:SaveDisplayName(name)
	local profileTable = self:GetProfileTable()
	local frameTbl = profileTable["CDMCustomFrames"] and profileTable["CDMCustomFrames"][self:GetFrameIndexByName(self.frameName)]
	if frameTbl then
		frameTbl.name = name
	end
end

function HUI_CDMCustomAuraMixin:OnEditModeEnter()
	self.HUISelection:Show()

	self.isEditing = true
end

function HUI_CDMCustomAuraMixin:OnEditModeExit()
	self.HUISelection:Hide()
	self.HUISelection:SetSelected(false)

	self.isEditing = false
end

function HUI_CDMCustomAuraMixin:OnCustomItemListReorderEnded(itemList, frameName)
	if self:GetName() ~= frameName then return end
	self.itemList = CopyTable(itemList)
	self:RefreshAuraList()
    self:RefreshAuraButtons()
end

function HUI_CDMCustomAuraMixin:OnCustomItemListItemUpdate(itemList, frameName)
	if self:GetName() ~= frameName then return end
	self.itemList = CopyTable(itemList)
	self:RefreshAuraList()
    self:RefreshAuraButtons()
end

function HUI_CDMCustomAuraMixin:SetupAppearance()
	local frameName = self.frameName

	self.iconSize = 38
	if Addon:GetValue("UseCDMCustomItemSize", nil, frameName) then
		self.iconSize = Addon:GetValue("CDMCustomItemSize", nil, frameName) or 38
	end

	self.spacing = 2
	if Addon:GetValue("UseCDMCustomIconPadding", nil, frameName) then
		self.spacing = Addon:GetValue("CDMCustomIconPadding", nil, frameName) or 2
	end

	self.stride = 7
	if Addon:GetValue("UseCDMCustomStride", nil, frameName) then
		self.stride = Addon:GetValue("CDMCustomStride", nil, frameName) or 7
	end

	self.gridLayoutType = tonumber(Addon:GetValue("CDMGridLayoutType", nil, frameName)) or 2
	if self.gridLayoutType == 1 then
		self.gridLayoutType = 2
	end

	self.goingRight = Addon:GetValue("CDMHorizontalGrowth", nil, frameName) == 1
	self.goingUp = Addon:GetValue("CDMVerticalGrowth", nil, frameName) == 1

	self.hideInactiveType = tonumber(Addon:GetValue("CurrentHideWhenInactive", nil, frameName)) or 1
	self.isHorizontal = Addon:GetValue("CDMCustomGridDirection", nil, frameName) == 1
	self.useFixedSlots = self.hideInactiveType == 1 or self.gridLayoutType == 3
end

function HUI_CDMCustomAuraMixin:GetElementSize()
	return self.iconSize, self.iconSize
end

function HUI_CDMCustomAuraMixin:GetFlowLayoutGrowthDirection()
	if self.isHorizontal then
		return self.goingRight and AnchorUtil.FlowDirection.Right or AnchorUtil.FlowDirection.Left,
			self.goingUp and AnchorUtil.FlowDirection.Up or AnchorUtil.FlowDirection.Down
	else
		return self.goingUp and AnchorUtil.FlowDirection.Up or AnchorUtil.FlowDirection.Down,
			self.goingRight and AnchorUtil.FlowDirection.Right or AnchorUtil.FlowDirection.Left
	end
end

function HUI_CDMCustomAuraMixin:GetFlowAnchorPoint()
	if self.goingUp then
		return self.goingRight and "BOTTOMLEFT" or "BOTTOMRIGHT"
	else
		return self.goingRight and "TOPLEFT" or "TOPRIGHT"
	end
end

function HUI_CDMCustomAuraMixin:UpdateAuraContainerUnit()
	local container = self.AuraContainer
	if not container then return end

	local spellID = self.trackedSpellIDs and self.trackedSpellIDs[1]
	local auraUnit = "player"
	if spellID then
		auraUnit = self:GetAuraUnitForSpell(spellID)
	end

	container:SetUnit(auraUnit)

	if auraUnit == "target" then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	else
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	end
end

function HUI_CDMCustomAuraMixin:GetAuraFilterString(spellID)
	if not spellID then
		return "HELPFUL"
	end

	local auraType = self:GetAuraTypeOverride(spellID)
	if auraType then
		return auraType == "HELPFUL" and "HELPFUL" or "HARMFUL|PLAYER"
	end

	local auraUnit = self:GetAuraUnitForSpell(spellID)

	return auraUnit == "player" and "HELPFUL" or "HARMFUL|PLAYER"
end

function HUI_CDMCustomAuraMixin:GetAuraUnitForSpell(spellID)
	local override = self:GetAuraUnitOverride(spellID)
	if override then
		return override
	end

	local tbl = Addon.SPELLID_TO_AURASPELLID[spellID]
	return (tbl and tbl.auraUnit) or (C_Spell.IsSpellHelpful(spellID) and "player" or "target")
end

function HUI_CDMCustomAuraMixin:GetAllAuraSounds(spellID)
	local frameIndex = self:GetFrameIndexByName(self.frameName)
	local profileTable = self:GetProfileTable()
	if profileTable["CDMCustomFrames"] then
		local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
		if frameTbl and frameTbl.sounds and frameTbl.sounds[spellID] then
			return frameTbl.sounds[spellID]
		end
	end
	return {}
end

function HUI_CDMCustomAuraMixin:IsTrackingSpell(spellID)
	for _, id in ipairs(self.trackedSpellIDs or {}) do
		if id == spellID then
			return true
		end
	end
	return false
end

function HUI_CDMCustomAuraMixin:RegisterAuraSound(spellID, triggerID, soundName)
	if not C_UnitAuras or not C_UnitAuras.AddAuraSound then return end
	if type(soundName) ~= "string" then return end

	local lsm = LibStub("LibSharedMedia-3.0", true)
	if not lsm then return end

	local soundFileName = lsm:Fetch("sound", soundName, true)
	if not soundFileName then return end

	local unitToken = self:GetAuraUnitForSpell(spellID)
	local ok, auraSoundID = pcall(C_UnitAuras.AddAuraSound, triggerID, {
		unitToken = unitToken,
		spellID = spellID,
		soundFileName = soundFileName,
		outputChannel = "master",
	})
	if ok and auraSoundID then
		if not self.auraSoundIDs[spellID] then
			self.auraSoundIDs[spellID] = {}
		end
		self.auraSoundIDs[spellID][triggerID] = auraSoundID
	end
end

function HUI_CDMCustomAuraMixin:RegisterAuraSounds()
	for _, spellID in ipairs(self.trackedSpellIDs or {}) do
		local sounds = self:GetAllAuraSounds(spellID)
		for triggerID, soundName in pairs(sounds) do
			self:RegisterAuraSound(spellID, triggerID, soundName)
		end
	end
end

function HUI_CDMCustomAuraMixin:UnregisterAuraSoundTrigger(spellID, triggerID)
	local soundIDs = self.auraSoundIDs[spellID]
	if not soundIDs then return end

	local auraSoundID = soundIDs[triggerID]
	if auraSoundID and C_UnitAuras.RemoveAuraSound then
		pcall(C_UnitAuras.RemoveAuraSound, auraSoundID)
	end
	soundIDs[triggerID] = nil
	if not next(soundIDs) then
		self.auraSoundIDs[spellID] = nil
	end
end

function HUI_CDMCustomAuraMixin:UnregisterAuraSounds(spellID)
	local soundIDs = self.auraSoundIDs[spellID]
	if not soundIDs then return end

	for triggerID in pairs(soundIDs) do
		local auraSoundID = soundIDs[triggerID]
		if auraSoundID and C_UnitAuras.RemoveAuraSound then
			pcall(C_UnitAuras.RemoveAuraSound, auraSoundID)
		end
	end
	self.auraSoundIDs[spellID] = nil
end

function HUI_CDMCustomAuraMixin:UnregisterAllAuraSounds()
	for spellID in pairs(self.auraSoundIDs or {}) do
		self:UnregisterAuraSounds(spellID)
	end
end

function HUI_CDMCustomAuraMixin:OnAuraOverrideChanged(spellID)
	if not self.AuraContainer then return end

	local isTracked = false
	for _, trackedSpellID in ipairs(self.trackedSpellIDs or {}) do
		if trackedSpellID == spellID then
			isTracked = true
			break
		end
	end
	if not isTracked then return end

	self:UpdateAuraContainerUnit()

	if self.useFixedSlots then
		for slotIndex = 1, self.auraSlotCount or 0 do
			self.AuraContainer:SetAuraSlotFilterString("aura" .. slotIndex,
				self:GetAuraFilterString(self.trackedSpellIDs[slotIndex]))
		end
	else
		for groupIndex = 1, self.auraGroupCount or 0 do
			self.AuraContainer:SetAuraGroupFilterString("aura" .. groupIndex,
				self:GetAuraFilterString(self.trackedSpellIDs[groupIndex]))
		end
	end

	self.AuraContainer:UpdateAllAuras()
end

function HUI_CDMCustomAuraMixin:OnAuraSoundChanged(itemID, triggerID, soundName, frameName)
	if self.frameName ~= frameName then return end
	if not self:IsTrackingSpell(itemID) then return end

	self:UnregisterAuraSoundTrigger(itemID, triggerID)
	if soundName ~= nil then
		self:RegisterAuraSound(itemID, triggerID, soundName)
	end
end

function HUI_CDMCustomAuraMixin:CreateAuraContainer()
	self.AuraContainer = CreateFrame("AuraContainer", nil, self, "HUI_CDMAuraContainer")

	self.AuraContainer:SetUnit("player")
	self.AuraContainer:SetEnabled(true)

	self.anchorPoint = self:GetFlowAnchorPoint()

	local elementWidth, elementHeight = self:GetElementSize()

	local maxLineSize = (self.stride * elementWidth) + ((self.stride - 1) * self.spacing)
	self.AuraContainer:SetFlowLayoutMaximumLineSize(maxLineSize)
	self.AuraContainer:SetFlowLayoutAnchorPoint(self.anchorPoint)
	local primaryDirection, secondaryDirection = self:GetFlowLayoutGrowthDirection()
	self.AuraContainer:SetFlowLayoutGrowthDirection(primaryDirection, secondaryDirection)

	self.AuraContainer:SetPoint(self.anchorPoint, self, self.anchorPoint, 0, 0)
	self.AuraContainer:Show()

	self.auraGroupCount = 0
	self.auraSlotCount = 0
	self.placeholders = {}
	self.auraSlotFrames = {}
end

function HUI_CDMCustomAuraMixin:EnsureAuraGroups(count)
	local elementWidth, elementHeight = self:GetElementSize()

	while self.auraGroupCount < count do
		self.auraGroupCount = self.auraGroupCount + 1
		local groupIndex = self.auraGroupCount
		local filterString = self:GetAuraFilterString(self.trackedSpellIDs[groupIndex])
		self.AuraContainer:AddAuraGroup("aura" .. groupIndex, filterString, {
			maxFrameCount = 1,
			sortMethod = AuraContainerSortMethod.ExpirationOnly,
			sortDirection = AuraContainerSortDirection.Reverse,
			candidateFilters = { includeSpellIDs = {} },
			initializeFrame = function(auraButton)
				self:ConfigureAuraButton(auraButton, self.trackedSpellIDs[groupIndex])
			end,
			layout = {
				elementWidth = elementWidth,
				elementHeight = elementHeight,
				elementSpacing = self.spacing,
				lineSpacing = self.spacing,
				layoutIndex = groupIndex,
			},
		})
	end
end

function HUI_CDMCustomAuraMixin:EnsureAuraSlots(count)
	local elementWidth, elementHeight = self:GetElementSize()
	local stepX = elementWidth + self.spacing
	local stepY = elementHeight + self.spacing
	local xDirection = self.goingRight and 1 or -1
	local yDirection = self.goingUp and 1 or -1

	while self.auraSlotCount < count do
		self.auraSlotCount = self.auraSlotCount + 1
		local slotIndex = self.auraSlotCount
		local col, row
		if self.isHorizontal then
			col = (slotIndex - 1) % self.stride
			row = math.floor((slotIndex - 1) / self.stride)
		else
			col = math.floor((slotIndex - 1) / self.stride)
			row = (slotIndex - 1) % self.stride
		end
		local filterString = self:GetAuraFilterString(self.trackedSpellIDs[slotIndex])
		local slotFrame = self.AuraContainer:AddAuraSlot("aura" .. slotIndex, filterString, {
			sortMethod = AuraContainerSortMethod.ExpirationOnly,
			sortDirection = AuraContainerSortDirection.Reverse,
			candidateFilters = { includeSpellIDs = {} },
			initializeFrame = function(auraButton)
				self:ConfigureAuraButton(auraButton, self.trackedSpellIDs[slotIndex])
				if auraButton:CanBeAccessedInContext() then
					auraButton:ClearAllPoints()
					auraButton:SetPoint(self.anchorPoint, self.AuraContainer, self.anchorPoint, col * stepX * xDirection, row * stepY * yDirection)
				end
			end,
		})
		self.auraSlotFrames[slotIndex] = slotFrame
	end
end

function HUI_CDMCustomAuraMixin:RefreshSettings()
	local prevUseFixedSlots = self.useFixedSlots

	self:SetupAppearance()

	if self.useFixedSlots ~= prevUseFixedSlots then
		self:RebuildAuraContainer()
		return
	end

	self:ApplyAuraLayout()
	self:RefreshAuraButtons()
	self:ResizeFrame(self.visibleCount or 0)
	self:UpdatePlaceholders(self.isEditing)
end

function HUI_CDMCustomAuraMixin:ApplyAuraLayout()
	local container = self.AuraContainer
	if not container then return end

	self.anchorPoint = self:GetFlowAnchorPoint()

	local elementWidth, elementHeight = self:GetElementSize()

	local maxLineSize = (self.stride * elementWidth) + ((self.stride - 1) * self.spacing)
	container:SetFlowLayoutMaximumLineSize(maxLineSize)
	container:SetFlowLayoutAnchorPoint(self.anchorPoint)
	local primaryDirection, secondaryDirection = self:GetFlowLayoutGrowthDirection()
	container:SetFlowLayoutGrowthDirection(primaryDirection, secondaryDirection)

	container:ClearAllPoints()
	container:SetPoint(self.anchorPoint, self, self.anchorPoint, 0, 0)

	if self.useFixedSlots then
		local stepX = elementWidth + self.spacing
		local stepY = elementHeight + self.spacing
		local xDirection = self.goingRight and 1 or -1
		local yDirection = self.goingUp and 1 or -1

		for slotIndex, slotFrame in ipairs(self.auraSlotFrames) do
			if slotFrame then
				local col, row
				if self.isHorizontal then
					col = (slotIndex - 1) % self.stride
					row = math.floor((slotIndex - 1) / self.stride)
				else
					col = math.floor((slotIndex - 1) / self.stride)
					row = (slotIndex - 1) % self.stride
				end
                if slotFrame:CanBeAccessedInContext() then
                    slotFrame:ClearAllPoints()
                    slotFrame:SetPoint(self.anchorPoint, container, self.anchorPoint, col * stepX * xDirection, row * stepY * yDirection)
                end
			end
		end
	end
end

function HUI_CDMCustomAuraMixin:RefreshAuraButtons()
	local container = self.AuraContainer
	if not container then return end

	if self.useFixedSlots then
		for slotIndex, button in ipairs(self.auraSlotFrames) do
			if button then
				self:ConfigureAuraButton(button, self.trackedSpellIDs[slotIndex])
			end
		end
	else
		for groupIndex = 1, self.auraGroupCount do
			local frameCount = container:GetAuraGroupFrameCount("aura" .. groupIndex)
			for frameIndex = 1, frameCount do
				local button = container:GetAuraGroupFrame("aura" .. groupIndex, frameIndex)
				if button then
					self:ConfigureAuraButton(button, self.trackedSpellIDs[groupIndex])
				end
			end
		end
	end
end

function HUI_CDMCustomAuraMixin:RefreshBackdrop(backdrop, color)
	if not backdrop then return end

	HUI_CDMCustomFrameCustomized:SetupBackdrop(backdrop, self.frameName, color)
end

function HUI_CDMCustomAuraMixin:RebuildAuraContainer()
	if self.AuraContainer then
		self.AuraContainer:Hide()
		self.AuraContainer:SetEnabled(false)
	end

	for _, placeholder in ipairs(self.placeholders or {}) do
		placeholder:Hide()
	end

	self.auraGroupCount = 0
	self.auraSlotCount = 0

	self:CreateAuraContainer()
	self:RefreshAuraList()
end

function HUI_CDMCustomAuraMixin:RefreshAuraList()
	if not self.AuraContainer then return end

	local trackedSpellIDs = {}
	local auraCount = 0

	for index, data in ipairs(self.itemList or {}) do
		if data.type == "spell" then
			local auraSpellID = tonumber(data.id)
			if auraSpellID then
				trackedSpellIDs[#trackedSpellIDs + 1] = auraSpellID
				auraCount = auraCount + 1
			end
		end
	end

	self.trackedSpellIDs = trackedSpellIDs
	self.visibleCount = auraCount

	--[[
	self:UnregisterAllAuraSounds()
	self:RegisterAuraSounds()
	--]]

	self:UpdateAuraContainerUnit()

	if self.useFixedSlots then
		self:EnsureAuraSlots(auraCount)

		for slotIndex = 1, self.auraSlotCount do
			local includeSpellIDs = {}
			if trackedSpellIDs[slotIndex] then
				if ElemBlastSpellIDs[trackedSpellIDs[slotIndex]] then
					includeSpellIDs = ElemBlastSpellIDs
				else
					includeSpellIDs[trackedSpellIDs[slotIndex]] = true
				end
			end
			self.AuraContainer:SetAuraSlotCandidateFilters("aura" .. slotIndex, { includeSpellIDs = includeSpellIDs })
		end
	else
		self:EnsureAuraGroups(auraCount)

		for groupIndex = 1, self.auraGroupCount do
			local includeSpellIDs = {}
			if trackedSpellIDs[groupIndex] then
				if ElemBlastSpellIDs[trackedSpellIDs[groupIndex]] then
					includeSpellIDs = ElemBlastSpellIDs
				else
					includeSpellIDs[trackedSpellIDs[groupIndex]] = true
				end
			end
			self.AuraContainer:SetAuraGroupCandidateFilters("aura" .. groupIndex, { includeSpellIDs = includeSpellIDs })
		end
	end

	self:ResizeFrame(self.visibleCount)
	self:UpdatePlaceholders(self.isEditing)
end

function HUI_CDMCustomAuraMixin:UpdatePlaceholders(showAll)
	if not self.placeholders then return end

	local elementWidth, elementHeight = self:GetElementSize()
	local stepX = elementWidth + self.spacing
	local stepY = elementHeight + self.spacing
	local xDirection = self.goingRight and 1 or -1
	local yDirection = self.goingUp and 1 or -1

	local placeholderIndex = 0
	for index, spellID in ipairs(self.trackedSpellIDs or {}) do
		local shouldShow = showAll or self.hideInactiveType == 1
		if shouldShow then
			placeholderIndex = placeholderIndex + 1
			local slot = index - 1
			local col, row
			if self.isHorizontal then
				col = slot % self.stride
				row = math.floor(slot / self.stride)
			else
				col = math.floor(slot / self.stride)
				row = slot % self.stride
			end
			local placeholder = self:GetPlaceholder(placeholderIndex)
			self:UpdatePlaceholder(placeholder, spellID)
			placeholder:ClearAllPoints()
			placeholder:SetPoint(self.anchorPoint, self, self.anchorPoint, col * stepX * xDirection, row * stepY * yDirection)
			placeholder:Show()
		end
	end

	for index = placeholderIndex + 1, #self.placeholders do
		self.placeholders[index]:Hide()
	end

	if showAll or placeholderIndex > 0 then
		self:ResizeFrame(placeholderIndex)
	else
		self:ResizeFrame(#(self.trackedSpellIDs or {}))
	end
end

function HUI_CDMCustomAuraMixin:ResizeFrame(auraCount)
	auraCount = auraCount or 0

	local elementWidth, elementHeight = self:GetElementSize()

	if auraCount == 0 then
		Addon.PP.Size(self, elementWidth, elementHeight)
		return
	end

	local stride = math.min(self.stride, auraCount)
	local numRows = math.ceil(auraCount / stride)

	local spacing = Addon.PP.Scale(self.spacing or 0)

	local lineSize = (stride * elementWidth) + ((stride - 1) * spacing)
	local wrapSize = (numRows * elementHeight) + ((numRows - 1) * spacing)

	local width, height
	if self.isHorizontal then
		width, height = lineSize, wrapSize
	else
		width, height = wrapSize, lineSize
	end

	Addon.PP.Size(self, width, height)
end

function HUI_CDMCustomAuraMixin:OnShow()
	self:RegisterEvent("FIRST_FRAME_RENDERED")
end

function HUI_CDMCustomAuraMixin:OnHide()

end

function HUI_CDMCustomAuraMixin:OnEvent(event, ...)
	if event == "FIRST_FRAME_RENDERED" then
		HUI_CDMCustomFrameCustomized:RefreshAnchors(self, self.frameName)
	elseif event == "PLAYER_TARGET_CHANGED" then
		if self.AuraContainer and self.AuraContainer:GetUnit() == "target" then
			self.AuraContainer:UpdateAllAuras()
		end
	end
end

function HUI_CDMCustomAuraMixin:OnUpdate()

end

local Addon = _G.HUI

local L = Addon.L

local REORDER_MARKER_BEFORE_TARGET = false
local REORDER_MARKER_AFTER_TARGET = true

HUI_CDMThresholdMixin = {}

function HUI_CDMThresholdMixin:NormalizeRecord(record)
	if not record or type(record) ~= "table" then return nil end

	local list
	if type(record[1]) == "table" then
		list = record
	elseif record.enabled == true and type(record.value) == "number" and record.value >= 1 then
		list = { record }
	end
	if not list then return nil end

	local result = {}
	local seen = {}
	for _, entry in ipairs(list) do
		if type(entry) == "table" and type(entry.value) == "number" and entry.value >= 1 and not seen[entry.value] then
			seen[entry.value] = true
			tinsert(result, {
				value = entry.value,
				r = entry.r or 0.8,
				g = entry.g or 0.1,
				b = entry.b or 0.1,
				a = entry.a or 1,
			})
		end
	end
	if #result == 0 then return nil end

	table.sort(result, function(a, b) return a.value < b.value end)
	return result
end

function HUI_CDMThresholdMixin:ValidateList(list, stages)
	if not list then return nil end

	local result = {}
	local seen = {}
	for _, entry in ipairs(list) do
		if type(entry) == "table" then
			local value = entry.value
			if type(value) == "number" and value >= 1 and value % 1 == 0 and not seen[value]
			and (not stages or value < stages) then
				seen[value] = true
				tinsert(result, {
					value = value,
					r = entry.r or 0.8,
					g = entry.g or 0.1,
					b = entry.b or 0.1,
					a = entry.a or 1,
				})
			end
		end
	end
	if #result == 0 then return nil end

	table.sort(result, function(a, b) return a.value < b.value end)
	return result
end

local function tblContains(tbl, item)
    for index, data in ipairs(tbl) do
        if item.type == data.type and item.id ~= nil and item.id == data.id then
            return index
        end
        if item.type == data.type and (Addon:IsRacialSpell(item.id) and Addon:IsRacialSpell(data.id)) then
            return index
        end
        if item.type == "potion" and data.type == "potion" and item.potType == data.potType then
            return index
        end
    end
    return false
end

CDMCustomDraggedItemMixin = {}
function CDMCustomDraggedItemMixin:SetToCursor(cooldownItem)
	self.Icon:SetTexture(cooldownItem:GetIconTexture());
	self:Show();
end

function CDMCustomDraggedItemMixin:OnUpdate()
	local topLevel = GetAppropriateTopLevelParent();
	local x, y = InputUtil.GetCursorPosition(topLevel);
	self:SetPoint("TOPLEFT", topLevel, "BOTTOMLEFT", x, y);
end

local cooldownItemDragCursor;
local function PickupCooldownItemCursor(cooldownItem)
	if not cooldownItemDragCursor then
		cooldownItemDragCursor = CreateFrame("Frame", nil, GetAppropriateTopLevelParent(), "CDMCustomDraggedItemTemplate");
	end

	cooldownItemDragCursor:SetToCursor(cooldownItem);
end

local function ClearCooldownItemCursor()
	if cooldownItemDragCursor then
		cooldownItemDragCursor:StopMovingOrSizing();
		cooldownItemDragCursor:Hide();
	end
end

OptionsCDMCustomItemListMixin = {}

function OptionsCDMCustomItemListMixin:OnLoad()
    self.frameName = HUI_BarsListMixin:GetFrameLebel()
    local index = HUI_BarsListMixin:GetFrameIndex()

    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    if profileTable["CDMCustomFrames"] and profileTable["CDMCustomFrames"][index] then
        self.profileTable = profileTable
        self.frameTbl = profileTable["CDMCustomFrames"][index]
        self.itemList = self.frameTbl.trackedIDs or {}
    end
    self.itemPool = CreateFramePool("Frame", self.ItemListScroll.GridContainer, "OptionsCDMCustomItemTemplate")
    self.ItemListScroll.GridContainer:EnableMouse(true)

    self.ItemListScroll.GridContainer.DropText:SetText(L.DragNDropContainer)

    self.SettingsButton:SetScript("OnClick", function()
        HUISpecVisibilityDialogMixin.Open(self)
    end)
    self.SettingsButton:Show()

    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AddItemByID", self.OnAddItemByID)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AddSpellByID", self.OnAddSpellByID)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AddItemBySlot", self.OnAddItemBySlot)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AddRacial", self.OnAddRacials)
    self:AddDynamicEventMethod(EventRegistry, "CDMCustomItemList.AddPotion", self.OnAddPotion)
    self:AddDynamicEventMethod(EventRegistry, "CooldownViewerSettings.BeginOrderChange", self.CDM_BeginOrderChange)
    

    self.FakeAuraFrame.Label:SetText(L.SetFakeAura)
    self.FakeAuraFrame.Desc:SetText(L.SetFakeAuraDesc)
end

function OptionsCDMCustomItemListMixin:CDM_BeginOrderChange(item)
    local spellID = item:GetSpellID()
    local cooldownID = item:GetCooldownID()
    local equipSlot = item:GetEquipSlot()
    local category = item:GetCategory()

end

function OptionsCDMCustomItemListMixin:OnAddRacials(frameName, track)
    if self.frameName ~= frameName then return end
    
    local racialSpell = Addon:GetRacialSpell()

    if not racialSpell then return end

    local newItem = {
        type = "spell",
        id = racialSpell
    }

    if track then
        if not tblContains(self.itemList, newItem) then
            table.insert(self.itemList, newItem)
            self:OnShow()
            EventRegistry:TriggerEvent("CDMCustomItemList.ItemAdded", self.itemList, self.frameName)
        end
    else
        local index = tblContains(self.itemList, newItem)
        if index then
            table.remove(self.itemList, index)
            self:OnShow()
            EventRegistry:TriggerEvent("CDMCustomItemList.ItemRemoved", self.itemList, self.frameName)
        end
    end
end
function OptionsCDMCustomItemListMixin:OnAddPotion(frameName, potType, track)
    if self.frameName ~= frameName then return end
    if not Addon.Potions.byType[potType] then return end

    local newItem = {
        type = "potion",
        potType = potType,
    }

    if track then
        if not tblContains(self.itemList, newItem) then
            table.insert(self.itemList, newItem)
            self:OnShow()
            EventRegistry:TriggerEvent("CDMCustomItemList.ItemAdded", self.itemList, self.frameName)
        end
    else
        local index = tblContains(self.itemList, newItem)
        if index then
            table.remove(self.itemList, index)
            self:OnShow()
            EventRegistry:TriggerEvent("CDMCustomItemList.ItemRemoved", self.itemList, self.frameName)
        end
    end
end
function OptionsCDMCustomItemListMixin:OnAddItemBySlot(slotID, frameName, track)
    if self.frameName ~= frameName then return end
    if not slotID then return end

    slotID = tonumber(slotID)

    

    local item = C_TooltipInfo.GetInventoryItem("player", slotID)

    if not item then return end

    local newItem = {
        type = "slot",
        id = slotID,
        baseID = item.id
    }

    if track then
        if not tblContains(self.itemList, newItem) then
            table.insert(self.itemList, newItem)
            self:OnShow()
            EventRegistry:TriggerEvent("CDMCustomItemList.ItemAdded", self.itemList, self.frameName)
        end
    else
        local index = tblContains(self.itemList, newItem)
        if index then
            table.remove(self.itemList, index)
            self:OnShow()
            EventRegistry:TriggerEvent("CDMCustomItemList.ItemRemoved", self.itemList, self.frameName)
        end
    end
end

function OptionsCDMCustomItemListMixin:OnAddItemByID(id, frameName)
    if self.frameName ~= frameName then return end

    if not id then return end
    
    id = tonumber(id)

    if not C_Item.DoesItemExistByID(id) then 
        Addon.Print("Item with this ID doesn't exist.")
        return
    end

    local newItem = {
        type = "item",
        id = id,
    }

    if not tblContains(self.itemList, newItem) then
        table.insert(self.itemList, newItem)
        self:OnShow()
        EventRegistry:TriggerEvent("CDMCustomItemList.ItemAdded", self.itemList, self.frameName)
    end
end
local function ResolveAuraUnitTypeIDs(spellID)
    local tbl = Addon.SPELLID_TO_AURASPELLID[spellID]
    local auraSpellID = (tbl and tbl.linkedSpellIDs and tbl.linkedSpellIDs[1]) or spellID
    local auraTbl = Addon.SPELLID_TO_AURASPELLID[auraSpellID]
    local auraUnit = (auraTbl and auraTbl.auraUnit) or (C_Spell.IsSpellHelpful(auraSpellID) and "player" or "target")
    return auraUnit == "player" and 1 or 2, auraUnit == "player" and 1 or 2
end

function OptionsCDMCustomItemListMixin:ResolveAuraDefaultsForSpell(id, baseID)
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    if not profileTable["CDMCustomFrames"] then return end
    local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
    if not frameTbl then return end

    local frameName = HUI_BarsListMixin:GetFrameLebel()
    local frame = frameName and _G[frameName]
    local isAuraFrame = frame and (frame.template == "HUI_CDMCustomAuraFrame" or frame.template == "HUI_CDMCustomAuraBar")
    local overrideKey = isAuraFrame and id or (baseID or id)

    Addon.MigrateAuraOverrides(frameTbl)

    if not frameTbl.auraUnits then
        frameTbl.auraUnits = {}
    end
    if not frameTbl.auraTypes then
        frameTbl.auraTypes = {}
    end
    if not frameTbl.auraUnits[overrideKey] or not frameTbl.auraTypes[overrideKey] then
        local unitID, typeID = ResolveAuraUnitTypeIDs(overrideKey)
        frameTbl.auraUnits[overrideKey] = frameTbl.auraUnits[overrideKey] or unitID
        frameTbl.auraTypes[overrideKey] = frameTbl.auraTypes[overrideKey] or typeID
    end
end

function OptionsCDMCustomItemListMixin:OnAddSpellByID(id, frameName)
    if self.frameName ~= frameName then return end

    if not id then return end

    id = tonumber(id)

    if not C_Spell.DoesSpellExist(id) then
        Addon.Print("Spell with this ID doesn't exist.")
        return
    end
    local baseID = C_Spell.GetBaseSpell(id)

    baseID = baseID ~= id and baseID or nil

    local newItem = {
        type = "spell",
        id = id,
        baseID = baseID,
    }

    if not tblContains(self.itemList, newItem) then
        table.insert(self.itemList, newItem)
        self:ResolveAuraDefaultsForSpell(id, baseID)
        self:OnShow()
        EventRegistry:TriggerEvent("CDMCustomItemList.ItemAdded", self.itemList, self.frameName)
    end
end

function OptionsCDMCustomItemListMixin:OnShow()
    if not self.itemList then return end

    local gridFrame = self.ItemListScroll.GridContainer

    self.itemPool:ReleaseAll()

    for index, data in ipairs(self.itemList) do
        local item = self.itemPool:Acquire()
        item.layoutIndex = index
        item.type = data.type

        if data.type == "item" then
            item.itemID = data.id
            item.spellID = nil
            item.baseSpellID = data.baseID
        elseif data.type == "potion" then
            local potInfo = Addon.Potions.byType[data.potType]
            item.itemID = potInfo and potInfo.items[1] or nil
            item.spellID = nil
            item.baseSpellID = nil
            item.potType = data.potType
            if item.itemID and not C_Item.IsItemDataCachedByID(item.itemID) then
                self.__pendingItemLoads = self.__pendingItemLoads or {}
                if not self.__pendingItemLoads[item.itemID] then
                    self.__pendingItemLoads[item.itemID] = true
                    C_Item.RequestLoadItemDataByID(item.itemID)
                    Item:CreateFromItemID(item.itemID):ContinueOnItemLoad(function()
                        self.__pendingItemLoads[item.itemID] = nil
                        self:OnShow()
                    end)
                end
            end
        elseif data.type == "slot" then
            local inventoryItem = C_TooltipInfo.GetInventoryItem("player", data.id)
            if not inventoryItem then break end
            item.itemID = inventoryItem.id
            item.spellID = nil
            item.baseSpellID = data.baseID
        else
            item.spellID = data.id
            item.baseSpellID = data.baseID
            item.itemID = nil
        end
        
        item.fakeAura = item:GetFakeAura()
        item.realAura = item:GetRealAura()
        item.stages = item:GetStages()
        item.color = item:GetCustomColor()
        item.auraColor = item:GetCustomAuraColor()
        item.barDisplayType = item:GetBarDisplayType()

        item:SetParent(gridFrame)
        item:Show()

        item.parentFrame = self
    end

    gridFrame:Layout()

    local scrollChild = self.ItemListScroll
    scrollChild:SetSize(gridFrame:GetSize())
    gridFrame.parentListFrame = self

    gridFrame:SetAllPoints()

    Addon:UpdateSettingsLock()
end

function OptionsCDMCustomItemListMixin:SetupItemList()
    --[[ self.itemList = CopyTable(trackedIDs)
    
    local gridFrame = self.ItemListScroll.GridContainer

    self.itemPool:ReleaseAll()

    for index, data in ipairs(self.itemList) do
        local item = self.itemPool:Acquire()
        item:SetParent(gridFrame)
        item:Show()
    end

    gridFrame:Layout()

    local scrollChild = self.ItemListScroll
    scrollChild:SetSize(gridFrame:GetSize()) ]]
end

function OptionsCDMCustomItemListMixin:IsReordering()
	return self:GetReorderSourceItem() ~= nil
end

function OptionsCDMCustomItemListMixin:GetReorderSourceItem()
    return self.reorderSourceItem
end

function OptionsCDMCustomItemListMixin:SetReorderSourceItem(item)
	self.reorderSourceItem = item
end

function OptionsCDMCustomItemListMixin:GetReorderTarget()
	return self.reorderTarget
end

function OptionsCDMCustomItemListMixin:SetReorderTarget(element)
	if self:IsReordering() then
		self.reorderTarget = element
	end
end

function OptionsCDMCustomItemListMixin:SetReorderTargetItem(item)
	if self:IsReordering() then
		self.reorderTargetItem = item
	end
end

function OptionsCDMCustomItemListMixin:GetReorderTargetItem()
	return self.reorderTargetItem
end

function OptionsCDMCustomItemListMixin:ClearReorderTargets()
	self.reorderTarget = nil
	self.reorderTargetItem = nil
	self.reorderSourceItem = nil
end

function OptionsCDMCustomItemListMixin:OnUpdate(_elapsed)
	assertsafe(self:IsReordering())
	self:UpdateReorderMarker()
end

function OptionsCDMCustomItemListMixin:UpdateReorderMarker()
	local target = self:GetReorderTarget()
	self.ReorderMarker:SetShown(target ~= nil)
    
	if not target then
		return
	end

	local cursorX, cursorY = GetCursorPosition()
	local scale = GetAppropriateTopLevelParent():GetScale()
	cursorX, cursorY = cursorX / scale, cursorY / scale;

	-- TODO: This needs to handle dragging over collapsed headers where there are no item targets, but there's still enough info to know to change categories.
	-- For now just leaving the marker alone...
	local nearestItemTarget = self:GetNearestItemToCursorWeighted(cursorX, cursorY)
	self:SetReorderTargetItem(nearestItemTarget)
	if nearestItemTarget then
		self.ReorderMarker:ClearAllPoints()
		local isMarkerAfterTarget = nearestItemTarget:UpdateReorderMarkerPosition(self.ReorderMarker, cursorX, cursorY);
		if isMarkerAfterTarget then
			self.reorderOffset = 1;
		else
			self.reorderOffset = 0;
		end
	end
end

function OptionsCDMCustomItemListMixin:GetInsertIndexAtCursor(cursorX, cursorY)
    local nearestItem = self:GetNearestItemToCursorWeighted(cursorX, cursorY)
    if not nearestItem then
        return #self.itemList + 1
    end

    local centerX = nearestItem:GetCenter()
    local isAfter = (cursorX >= centerX)
    local targetIndex = nearestItem.layoutIndex
    return isAfter and (targetIndex + 1) or targetIndex
end

function OptionsCDMCustomItemListMixin:GetNearestItemToCursorWeighted(cursorX, cursorY)
	local nearestItem = nil
	local nearestVertical = math.huge
	local nearestHorizontal = math.huge

	for item in self.itemPool:EnumerateActive() do
		local itemLeft, itemRight, itemBottom, itemTop = RegionUtil.GetSides(item)
		local itemCenterX = (itemLeft + itemRight) / 2
		local itemCenterY = (itemBottom + itemTop) / 2
		local horizontalDistance = math.abs(itemCenterX - cursorX)
		local verticalDistance = math.abs(itemCenterY - cursorY)
		if cursorY > itemBottom and cursorY < itemTop then
			verticalDistance = 0
		end

		if verticalDistance < nearestVertical or (nearestVertical == verticalDistance and horizontalDistance < nearestHorizontal) then
			nearestItem = item
			nearestVertical = verticalDistance
			nearestHorizontal = horizontalDistance
		end
	end

	return nearestItem
end

function OptionsCDMCustomItemListMixin:BeginOrderChange(element, eatNextGlobalMouseUp)
    if self:GetReorderSourceItem() then
        return
    end

    self:SetReorderSourceItem(element)
    self:SetReorderTarget(element)
    self.reorderOffset = 0
    self.eatNextGlobalMouseUp = eatNextGlobalMouseUp

    element:SetReorderLocked(true)
    PickupCooldownItemCursor(element)

    self:SetScript("OnUpdate", self.OnUpdate)

    self:RegisterEvent("GLOBAL_MOUSE_UP")
end

function OptionsCDMCustomItemListMixin:EndOrderChange()
    local sourceItem = self:GetReorderSourceItem()
    local targetItem = self:GetReorderTargetItem()
    if not sourceItem or not targetItem or sourceItem == targetItem then
        self:CancelOrderChange()
        return
    end

    local sourceIndex = sourceItem.layoutIndex
    local targetIndex = targetItem.layoutIndex
    local itemCount = #self.itemList

    local newIndex = targetIndex + self.reorderOffset
    newIndex = math.max(1, math.min(newIndex, itemCount + 1))

    if (newIndex == sourceIndex) or 
       (self.reorderOffset == 1 and newIndex - 1 == sourceIndex) then
        self:CancelOrderChange()
        return
    end

    local movedData = table.remove(self.itemList, sourceIndex)

    if newIndex > sourceIndex then
        newIndex = newIndex - 1
    end

    table.insert(self.itemList, newIndex, movedData)

    self:CancelOrderChange()
    self:OnShow()

    EventRegistry:TriggerEvent("CDMCustomItemList.EndOrderChange", self.itemList, self.frameName)
end

function OptionsCDMCustomItemListMixin:CancelOrderChange(element, ...)
	self:GetReorderSourceItem():SetReorderLocked(false)
	self.ReorderMarker:Hide()
	self:ClearReorderTargets()

	ClearCooldownItemCursor()

	self:SetScript("OnUpdate", nil)

	self:UnregisterEvent("GLOBAL_MOUSE_UP")
end



function OptionsCDMCustomItemListMixin:OnEvent(event, ...)
    if event == "GLOBAL_MOUSE_UP" then
		local button = ...
		self:OnGlobalMouseUp(button)
	end
end

function OptionsCDMCustomItemListMixin:OnGlobalMouseUp(button)
	if self.eatNextGlobalMouseUp == button then
		self.eatNextGlobalMouseUp = nil
	else
		PlaySound(SOUNDKIT.UI_CURSOR_DROP_OBJECT)

		if button == "LeftButton" then
			self:EndOrderChange()
		elseif button == "RightButton" then
			self:CancelOrderChange()
		end
	end
end

local function SetupDropdown(dropdown, itemID)
    local function IsSelected(id)
        local profileName = HUIProfilesMixin:GetPlayerProfile()
        local profileTable = Addon.P.profilesList[profileName]
        local index = HUI_BarsListMixin:GetFrameIndex()
        if profileTable["CDMCustomFrames"] then
            frameTbl = profileTable["CDMCustomFrames"][index]
            if frameTbl.fakeAuras and frameTbl.fakeAuras[itemID] then
                return frameTbl.fakeAuras[itemID].type == id
            end
        end
        return id == 1
    end
    local function OnSelect(id)
        local profileName = HUIProfilesMixin:GetPlayerProfile()
        local profileTable = Addon.P.profilesList[profileName]
        local index = HUI_BarsListMixin:GetFrameIndex()
        if profileTable["CDMCustomFrames"] then
            local frameTbl = profileTable["CDMCustomFrames"][index]
            if not frameTbl.fakeAuras then
                frameTbl.fakeAuras = {}
            end
            if not frameTbl.fakeAuras[itemID] then
                frameTbl.fakeAuras[itemID] = {
                    duration = 0,
                    type = id
                }
            else
                frameTbl.fakeAuras[itemID].type = id
            end
            EventRegistry:TriggerEvent("CDMCustomItemList.FakeAuraTypeChanged", itemID, id)
        end
    end
    local menuGenerator = function(_, rootDescription)
        rootDescription:CreateTitle(L.FakeAuraTypesTitle)
        local auraTypes = Addon.FakeAuraType
        for i=1, #auraTypes do
            local categoryName = auraTypes[i]
            local categoryID = i
            local radio = rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
        end
    end
    dropdown.Dropdown:SetupMenu(menuGenerator)
    dropdown.IncrementButton:Hide()
    dropdown.DecrementButton:Hide()
end

local function SetupUnitDropdown(dropdown, item)
    local function IsSelected(id)
        local override = item:GetAuraUnitOverride()
        if not override then
            override = ResolveAuraUnitTypeIDs(item:GetAuraOverrideKey())
        end
        return override == id
    end
    local function OnSelect(id)
        item:SaveAuraUnitOverride(id)
        EventRegistry:TriggerEvent("CDMCustomItemList.AuraUnitChanged", item:GetAuraOverrideKey(), id)
    end
    local menuGenerator = function(_, rootDescription)
        rootDescription:CreateTitle(L.AuraUnitTitle)
        local options = Addon.AuraUnitOptions
        for i=1, #options do
            local categoryName = options[i]
            local categoryID = i
            local radio = rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
        end
    end
    dropdown.Dropdown:SetupMenu(menuGenerator)
    dropdown.IncrementButton:Hide()
    dropdown.DecrementButton:Hide()
end

local function SetupAuraTypeDropdown(dropdown, item)
    local function IsSelected(id)
        local override = item:GetAuraTypeOverride()
        if not override then
            local _, typeID = ResolveAuraUnitTypeIDs(item:GetAuraOverrideKey())
            override = typeID
        end
        return override == id
    end
    local function OnSelect(id)
        item:SaveAuraTypeOverride(id)
        EventRegistry:TriggerEvent("CDMCustomItemList.AuraTypeChanged", item:GetAuraOverrideKey(), id)
    end
    local menuGenerator = function(_, rootDescription)
        rootDescription:CreateTitle(L.AuraTypeTitle)
        local options = Addon.AuraTypeOptions
        for i=1, #options do
            local categoryName = options[i]
            local categoryID = i
            local radio = rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
        end
    end
    dropdown.Dropdown:SetupMenu(menuGenerator)
    dropdown.IncrementButton:Hide()
    dropdown.DecrementButton:Hide()
end

function OptionsCDMCustomItemListMixin:OpenAuraSettings(item)
    local itemID = item:GetSpellID()
    local auraSettings = self.AuraSettings
    auraSettings.Label:SetText(L.ConfigureAura)

    local isAuraFrame = item:IsAuraFrame()

    local unitFrame = auraSettings.UnitContainer
    unitFrame.Name:SetText(L.AuraUnitTitle)
    unitFrame:ClearAllPoints()
    if isAuraFrame then
        unitFrame:SetPoint("TOPLEFT", auraSettings, "TOPLEFT", 0, -80)
    else
        unitFrame:SetPoint("TOPLEFT", auraSettings.AuraContainer, "BOTTOMLEFT", 0, 0)
    end
    SetupUnitDropdown(unitFrame.Dropdown, item)

    local auraTypeFrame = auraSettings.AuraTypeContainer
    auraTypeFrame.Name:SetText(L.AuraTypeTitle)
    SetupAuraTypeDropdown(auraTypeFrame.Dropdown, item)

    if isAuraFrame then
        auraSettings.FakeAuraContainer:Hide()
        auraSettings.AuraContainer:Hide()
        auraSettings.Button:Show()
        auraSettings.Button:SetScript("OnClick", function()
            auraSettings:Hide()
            self:OnShow()
        end)
        auraSettings:SetHeight(200)
        auraSettings:Show()
        return
    end

    auraSettings.FakeAuraContainer:Show()
    auraSettings.AuraContainer:Show()
    auraSettings.Button:Show()
        auraSettings:SetHeight(240)

    local fakeAuraFrame = self.AuraSettings.FakeAuraContainer
    fakeAuraFrame.Name:SetText(L.FakeAuraTimer)

    local fakeAuraEditBox = fakeAuraFrame.EditBox
    fakeAuraEditBox:SetText((item.fakeAura and item.fakeAura > 0) and item.fakeAura or "")
    fakeAuraEditBox:Show()
    local fakeAuraDropDown = fakeAuraFrame.Dropdown
    SetupDropdown(fakeAuraDropDown, itemID)

    local realAuraFrame = self.AuraSettings.AuraContainer
    realAuraFrame.Name:SetText(L.RealAuraID)

    local realAuraEditBox = realAuraFrame.EditBox

    local realAuraIDs = item:GetRealAura()
    
    local realAuraText = table.concat(realAuraIDs, ",")

    realAuraEditBox:SetText(realAuraText)

    local realAuraBlocked = realAuraFrame.InactiveAuraFrame:IsVisible()
    realAuraFrame.InactiveAuraFrame.Name:SetText(L.RealAuraDisabled)

    if not realAuraBlocked then
        
    end

    local confirmButton = self.AuraSettings.Button
    confirmButton:SetScript("OnClick", function()
        local newDuration = tonumber(fakeAuraEditBox:GetText())
        newDuration = (newDuration and newDuration > 0) and newDuration or nil
        
        item:SaveFakeAura(newDuration)

        local newRealAuraIDs = realAuraEditBox:GetText()
        if newRealAuraIDs then
            local tbl = {}
            if not newRealAuraIDs ~= "" then
                local parts = { string.split(",", newRealAuraIDs) }
                for _, spellID in ipairs(parts) do
                    spellID = tonumber(spellID:match("^%s*(.-)%s*$"))
                    if spellID and spellID > 0 and spellID % 1 == 0 then
                        table.insert(tbl, spellID)
                    end
                end
            end

            item:SaveRealAura(tbl)
        end

        self.AuraSettings:Hide()
        self:OnShow()
    end)


    self.AuraSettings:Show()
    
end

function OptionsCDMCustomItemListMixin:OpenStagesSettings(item)
    local itemID = item:GetSpellID()
    local fakeAuraFrame = self.FakeAuraFrame
    if fakeAuraFrame.PotionControls then
        fakeAuraFrame.PotionControls:Hide()
    end
    fakeAuraFrame.Label:SetText(L.SetStages)
    fakeAuraFrame.Desc:SetText(L.SetStagesDesc)
    fakeAuraFrame.Desc:Show()
    fakeAuraFrame.Dropdown:Hide()

    fakeAuraFrame.EditBox:SetText((item.stages and item.stages > 0) and item.stages or "")
    fakeAuraFrame.EditBox:Show()

    fakeAuraFrame:Show()
    fakeAuraFrame.Button:SetScript("OnClick", function()
        local newStages = tonumber(fakeAuraFrame.EditBox:GetText())
        newStages = (newStages and newStages > 0) and newStages or nil

        local profileName = HUIProfilesMixin:GetPlayerProfile()
        local profileTable = Addon.P.profilesList[profileName]
        local index = HUI_BarsListMixin:GetFrameIndex()
        if profileTable["CDMCustomFrames"] then
            local frameTbl = profileTable["CDMCustomFrames"][index]
            if not frameTbl.stages then
                frameTbl.stages = {}
            end
            frameTbl.stages[itemID] = newStages

            EventRegistry:TriggerEvent("CDMCustomItemList.StagesAdded", itemID, newStages)
        end
        fakeAuraFrame:Hide()
        self:OnShow()
    end)
end

local function SetupGridLayout(parent, itemList, columns)
    local padding = 2
    local itemWidth = 105
    local itemHeight = 20
    
    for _, item in ipairs(itemList) do
        item:ClearAllPoints()
        item:SetParent(parent)
        item:SetSize(itemWidth, itemHeight)
    end

    local totalRows = math.ceil(#itemList / columns)
    
    for i, item in ipairs(itemList) do
        local colIndex = (i - 1) % columns
        local rowIndex = math.floor((i - 1) / columns)

        local xOffset = padding + (colIndex * (itemWidth))
        local yOffset = -(padding + (rowIndex * (itemHeight)))

        item:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, yOffset)
    end
end

function OptionsCDMCustomItemListMixin:OpenRacialSettings(item)
    if self.FakeAuraFrame.PotionControls then
        self.FakeAuraFrame.PotionControls:Hide()
    end
    self.FakeAuraFrame.Label:SetText("Configure Racials")
    self.FakeAuraFrame.Label:SetPointsOffset(0, 75)
    self.FakeAuraFrame.Desc:Hide()
    self.FakeAuraFrame.EditBox:Hide()
    self.FakeAuraFrame.Dropdown:Hide()

    if not self.FakeAuraFrame.Racials then
        local racialFramesList = {}

        self.FakeAuraFrame.Racials = CreateFramePool("FRAME", self.FakeAuraFrame)
        local racialsPool = self.FakeAuraFrame.Racials

        self.FakeAuraFrame.RacialContainer = CreateFrame("Frame", nil, self.FakeAuraFrame)
        local racialContainer = self.FakeAuraFrame.RacialContainer
        racialContainer:SetPoint("TOPLEFT", self.FakeAuraFrame, "TOPLEFT", 10, -60)
        racialContainer:SetPoint("BOTTOMRIGHT", self.FakeAuraFrame, "BOTTOMRIGHT", -10, 10)
        
        local currentProfile = Addon:GetCurrentProfile()
        local trackedTable = HUIDB.Profiles.profilesList[currentProfile]["GlobalSettings"].RacialSpellsTracked

        for i, raceID in ipairs(Addon.RacialsSort) do
            local raceInfo = C_CreatureInfo.GetRaceInfo(raceID)
            raceInfo.texture = Addon:GetRaceIcon(raceInfo.clientFileString, "Male")
            local racialFrame = racialsPool:Acquire()
            racialFrame:SetSize(100, 20)
            racialFrame:SetPoint("TOPLEFT", self.FakeAuraFrame, "TOPLEFT", 10, -20)

            racialFrame.chekbox = CreateFrame("CheckButton", nil, racialFrame, "UICheckButtonTemplate")
            racialFrame.chekbox:SetSize(30,30)
            racialFrame.chekbox:SetPoint("LEFT", racialFrame, "LEFT")
            racialFrame.chekbox:SetAlpha(1)

            if trackedTable then
                if trackedTable[raceID] then
                    racialFrame.chekbox:SetChecked(true)
                else
                    racialFrame.chekbox:SetChecked(false)
                end
            end

            racialFrame.chekbox:SetScript("OnClick",function(button)
                if not trackedTable then
                    return
                end

                if raceID == 25 or raceID == 26 or raceID == 24 then
                    trackedTable[24] = button:GetChecked()
                    trackedTable[25] = button:GetChecked()
                    trackedTable[26] = button:GetChecked()
                elseif raceID == 70 or raceID == 52 then
                    trackedTable[52] = button:GetChecked()
                    trackedTable[70] = button:GetChecked()
                elseif raceID == 85 or raceID == 84 then
                    trackedTable[84] = button:GetChecked()
                    trackedTable[85] = button:GetChecked()
                elseif raceID == 91 or raceID == 86 then
                    trackedTable[86] = button:GetChecked()
                    trackedTable[91] = button:GetChecked()
                else
                    trackedTable[raceID] = button:GetChecked()
                end
            end)

            racialFrame.icon = racialFrame:CreateTexture(nil, "BACKGROUND")
            racialFrame.icon:SetSize(20,20)
            racialFrame.icon:SetPoint("CENTER", racialFrame.chekbox, "CENTER", 0, 0)
            racialFrame.icon:SetAtlas(raceInfo.texture)
            
            racialFrame.name = racialFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            racialFrame.name:SetSize(80,20)
            racialFrame.name:SetPoint("LEFT", racialFrame.icon, "RIGHT", 4, 0)
            racialFrame.name:SetText(raceInfo.raceName)
            racialFrame.name:SetJustifyH("LEFT")

            racialFrame:Show()

            table.insert(racialFramesList, racialFrame)
        end

        SetupGridLayout(self.FakeAuraFrame.RacialContainer, racialFramesList, 5)
    end
    self.FakeAuraFrame:Show()

    self.FakeAuraFrame.Button:SetPointsOffset(0, -80)

    self.FakeAuraFrame.Button:SetScript("OnClick", function()
        if self.FakeAuraFrame.Racials then
            self.FakeAuraFrame.Racials:ReleaseAll()
            self.FakeAuraFrame.Racials = nil
            self.FakeAuraFrame.RacialContainer = nil
        end

        self.FakeAuraFrame.Button:SetPointsOffset(0, -60)
        self.FakeAuraFrame.Label:SetPointsOffset(0, 60)

        EventRegistry:TriggerEvent("CDMCustomItemList.UpdateFrame", self.frameName)

        self.FakeAuraFrame:Hide()
        self:OnShow()
    end)
end

local function GetRegularPotionRep(kindKey)
    local data = Addon.PotionsData.DPS
    for _, quality in ipairs({"t2", "t1"}) do
        for _, itemID in ipairs(data.regular[quality]) do
            if Addon.PotionKindMap[itemID] == kindKey then
                return itemID
            end
        end
    end
    return nil
end

local function GetPotionKindList()
    local kinds = {}
    kinds[1] = { key = nil, name = L.PotionKindDefault }
    for i, kindKey in ipairs(Addon.PotionKindOrder.DPS) do
        local entry
        local rep = GetRegularPotionRep(kindKey) or Addon.PotionKindReps[kindKey]
        if rep then
            local name, _, quality = C_Item.GetItemInfo(rep)
            local icon = C_Item.GetItemIconByID(rep)
            if name and name ~= "" and icon then
                local hex = quality and ITEM_QUALITY_COLORS[quality] and ITEM_QUALITY_COLORS[quality].hex or "|cffffffff"
                local text = format("|T%d:16:16:0:0:64:64:4:60:4:60|t %s%s|r", icon, hex, name)
                entry = { key = kindKey, name = text, itemID = rep }
            end
        end
        if not entry then
            entry = { key = kindKey, name = L["PotionKind"..kindKey] }
        end
        kinds[i + 1] = entry
    end
    return kinds
end

local function SetupPotionDropdown(dropdown, titleText, entries, isSelected, onSelect)
    local menuGenerator = function(_, rootDescription)
        rootDescription:CreateTitle(titleText)
        for i = 1, #entries do
            local entry = entries[i]
            local radio = rootDescription:CreateRadio(entry.name, isSelected, onSelect, i)
            if entry.itemID then
                radio:SetTooltip(function(tooltip)
                    tooltip:SetItemByID(entry.itemID)
                end)
            end
        end
    end
    dropdown.Dropdown:SetupMenu(menuGenerator)
    dropdown.IncrementButton:Hide()
    dropdown.DecrementButton:Hide()
end

local function CreatePotionDropdown(parent, offsetY)
    local name = parent:CreateFontString(nil, "ARTWORK", "ObjectiveTrackerFont14")
    name:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, offsetY - 7)
    name:SetWidth(160)
    name:SetJustifyH("LEFT")
    name:SetTextColor(0.792, 0.776, 0.741)

    local dropdown = CreateFrame("Frame", nil, parent, "Metal2DropdownWithSteppersAndLabelTemplate")
    dropdown:SetSize(300, 26)
    dropdown:SetPoint("LEFT", name, "RIGHT", 6, 0)

    return dropdown, name
end

function OptionsCDMCustomItemListMixin:OpenPotionSettings(item)
    local fakeAuraFrame = self.FakeAuraFrame
    fakeAuraFrame.Label:SetText(L.PotionSettings)
    fakeAuraFrame.Label:SetPointsOffset(0, 75)
    fakeAuraFrame.Desc:Hide()
    fakeAuraFrame.EditBox:Hide()
    fakeAuraFrame.Dropdown:Hide()

    local frameName = self.frameName
    local potType = item.potType

    for _, rep in pairs(Addon.PotionKindReps) do
        if not C_Item.IsItemDataCachedByID(rep) then
            C_Item.RequestLoadItemDataByID(rep)
        end
    end
    for _, quality in ipairs({"t2", "t1"}) do
        for _, rep in ipairs(Addon.PotionsData.DPS.regular[quality]) do
            if not C_Item.IsItemDataCachedByID(rep) then
                C_Item.RequestLoadItemDataByID(rep)
            end
        end
    end

    if not fakeAuraFrame.PotionControls then
        local controls = CreateFrame("Frame", nil, fakeAuraFrame)
        controls:SetPoint("TOPLEFT", fakeAuraFrame, "TOPLEFT", 60, -60)
        controls:SetSize(480, 130)
        fakeAuraFrame.PotionControls = controls

        local kindDropdown, kindName = CreatePotionDropdown(controls, -6)
        kindName:SetText(L.CDMCustomPotionDpsKindTitle)
        controls.KindDropdown = kindDropdown

        local typeDropdown, typeName = CreatePotionDropdown(controls, -50)
        typeName:SetText(L.CDMCustomPotionPriorityTypeTitle)
        controls.TypeDropdown = typeDropdown
    end

    local controls = fakeAuraFrame.PotionControls
    controls:Show()

    local kinds = GetPotionKindList()
    SetupPotionDropdown(controls.KindDropdown, L.CDMCustomPotionDpsKindTitle, kinds,
        function(id)
            local entry = kinds[id]
            return (Addon:GetValue("CDMCustomPotionKind_"..potType, nil, frameName) or false) == (entry and entry.key or false)
        end,
        function(id)
            local entry = kinds[id]
            Addon:SaveSetting("CDMCustomPotionKind_"..potType, entry and entry.key or nil, frameName)
            EventRegistry:TriggerEvent("CDMCustomItemList.UpdateFrame", frameName)
        end
    )

    local priorityTypes = {
        { id = 1, name = L.PotionPriorityWithinRank },
        { id = 2, name = L.PotionPriorityAcrossRanks },
        { id = 3, name = L.PotionPriorityStrict },
    }
    SetupPotionDropdown(controls.TypeDropdown, L.CDMCustomPotionPriorityTypeTitle, priorityTypes,
        function(id)
            return id == (Addon:GetValue("CDMCustomPotionPriorityType", nil, frameName) or 1)
        end,
        function(id)
            Addon:SaveSetting("CDMCustomPotionPriorityType", id, frameName)
            EventRegistry:TriggerEvent("CDMCustomItemList.UpdateFrame", frameName)
        end
    )

    fakeAuraFrame.Button:SetPointsOffset(0, -80)
    fakeAuraFrame.Button:SetScript("OnClick", function()
        controls:Hide()

        fakeAuraFrame.Button:SetPointsOffset(0, -60)
        fakeAuraFrame.Label:SetPointsOffset(0, 60)

        EventRegistry:TriggerEvent("CDMCustomItemList.UpdateFrame", frameName)

        fakeAuraFrame:Hide()
        self:OnShow()
    end)

    fakeAuraFrame:Show()
end



OptionsCDMCustomItemListContentMixin = {}

function OptionsCDMCustomItemListContentMixin:OnReceiveDrag()
    local cursorInfo = { GetCursorInfo() }
    local cursorType = cursorInfo[1]
    if not cursorType then
        ClearCursor()
        return
    end

    local newItem = self:CreateNewItemFromCursor(cursorType, unpack(cursorInfo, 2))
    if not newItem then
        ClearCursor()
        return
    end

    local parentList = self.parentListFrame
    
    local cursorX, cursorY = GetCursorPosition()
    local scale = GetAppropriateTopLevelParent():GetScale()
    cursorX, cursorY = cursorX / scale, cursorY / scale

    local insertIndex = parentList:GetInsertIndexAtCursor(cursorX, cursorY)
    insertIndex = math.min(insertIndex, #parentList.itemList + 1)

    if not tblContains(parentList.itemList, newItem) then
        table.insert(parentList.itemList, insertIndex, newItem)
        --parentList.itemList = CopyTable(Addon.trackedIDs)
        parentList:OnShow()
        EventRegistry:TriggerEvent("CDMCustomItemList.ItemAdded", parentList.itemList, parentList.frameName)
    end

    if self.parentListFrame then
        self.parentListFrame.ReorderMarker:Hide()
    end

    PlaySound(SOUNDKIT.UI_CURSOR_DROP_OBJECT)
    ClearCursor()
end

function OptionsCDMCustomItemListContentMixin:OnMouseEnter()
    if not GetCursorInfo() then return end
    if not self.parentListFrame then return end

    local cursorX, cursorY = GetCursorPosition()
    local scale = GetAppropriateTopLevelParent():GetScale()
    cursorX, cursorY = cursorX / scale, cursorY / scale

    local parentList = self.parentListFrame
    local nearestItem = parentList:GetNearestItemToCursorWeighted(cursorX, cursorY)

    if nearestItem then
        local centerX = nearestItem:GetCenter()
        local isAfter = (cursorX >= centerX)

        parentList.ReorderMarker:ClearAllPoints()
        if isAfter then
            parentList.ReorderMarker:SetPoint("CENTER", nearestItem, "RIGHT", 4, 0)
        else
            parentList.ReorderMarker:SetPoint("CENTER", nearestItem, "LEFT", -4, 0)
        end
        parentList.ReorderMarker:Show()
    else
        parentList.ReorderMarker:Hide()
    end
end

function OptionsCDMCustomItemListContentMixin:CreateNewItemFromCursor(cursorType, ...)
    if cursorType == "spell" then
        local spellID = select(3, ...)
        local baseSpellID = select(4, ...)
        return { type = "spell", id = spellID, baseID = baseSpellID}
    elseif cursorType == "item" then
        local itemID = select(1, ...)
        if itemID then
            local spellName, spellID = C_Item.GetItemSpell(itemID)
            if spellID then
                return { type = "item", id = itemID }
            else
                Addon.Print("This is unusable item.")
            end
        end
    end
    return nil
end

--[[ function OptionsCDMCustomItemListContentMixin:OnMouseEnter()
end ]]
function OptionsCDMCustomItemListContentMixin:OnMouseLeave()
    if self.parentListFrame then
        self.parentListFrame.ReorderMarker:Hide()
    end
end

OptionsCDMCustomItemListReorderMarkerMixin = {}

OptionsCDMCustomItemMixin = {}

function OptionsCDMCustomItemMixin:OnShow()
    self.Icon:SetTexture(self:GetIconTexture())
    self.Icon:SetDesaturated(not self.isKnown)

    if self.fakeAura then
        self.HasAura:Show()
        self.HasAura:SetVertexColor(1,0.6,1,1)
    elseif self.realAura and next(self.realAura) and not self:IsBarFrame() then
        self.HasAura:Show()
        self.HasAura:SetVertexColor(0.6,1,0.6,1)
    else
        self.HasAura:Hide()
    end


    local frameName = HUI_BarsListMixin:GetFrameLebel()
    local frame = _G[frameName]
    if frame then
        self.frameTemplate = frame.template

        if self:IsBarFrame() then
            if self.stages then
                self.HasCharges:Show()
            else
                self.HasCharges:Hide()
            end
            if self.color then
                self.HasColor:Show()
                self.HasColor:SetVertexColor(self.color.r, self.color.g, self.color.b, 1)
            else
                self.HasColor:Hide()
            end
            --[[ if self.auraColor then
                self.HasAuraColor:Show()
                self.HasAuraColor:SetVertexColor(self.auraColor.r, self.auraColor.g, self.auraColor.b, 1)
            else
                self.HasAuraColor:Hide()
            end ]]
        end
    end
end

function OptionsCDMCustomItemMixin:IsBarFrame()
    return self.frameTemplate == "HUI_CDMCustomBarFrame" or self.frameTemplate == "HUI_CDMCustomAuraBar"
end

function OptionsCDMCustomItemMixin:IsAuraFrame()
    return self.frameTemplate == "HUI_CDMCustomAuraFrame" or self.frameTemplate == "HUI_CDMCustomAuraBar"
end

function OptionsCDMCustomItemMixin:GetIconTexture()
    local texture = 136243
    local isKnown = false
    local spellID = self:GetSpellID()
    if self.type ~= "spell" and spellID then
        isKnown = true
        texture = C_Item.GetItemIconByID(spellID)
    elseif spellID then
        texture = C_Spell.GetSpellTexture(spellID)
        if self:IsAuraFrame() then
            isKnown = true
        else
            isKnown = HUI_CDMCustomFrameMixin:FindKnownInCDM(spellID)
            if not isKnown then
                for i=1, 0, -1 do
                    if not isKnown then
                        isKnown = C_SpellBook.IsSpellKnown(spellID, i)
                    end
                end
            end
        end
    end
    self.isKnown = isKnown

	return texture
end

function OptionsCDMCustomItemMixin:OnEnter()
    --CooldownViewerBaseReorderTargetMixin.OnEnter(self)
    local tooltip = GetAppropriateTooltip()
    tooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
    if self.itemID then
        tooltip:SetItemByID(self.itemID)
    elseif self.spellID then
        tooltip:SetSpellByID(self.spellID, false)
    else
        return
    end
    tooltip:Show()
end
function OptionsCDMCustomItemMixin:OnLeave()
    GetAppropriateTooltip():Hide()
end

function OptionsCDMCustomItemMixin:GetSpellID()
    if self.itemID then
        return self.itemID
    end
    if self.baseSpellID then
        return self.baseSpellID
    end
    return self.spellID
end

function OptionsCDMCustomItemMixin:GetAuraOverrideKey()
    if self:IsAuraFrame() then
        return self.spellID
    end
    return self:GetSpellID()
end

function OptionsCDMCustomItemMixin:RemoveItem()
    local parentFrame = self.parentFrame
    local itemList = parentFrame.itemList
    local index = self.layoutIndex

    local spellID = self:GetSpellID()
    local overrideKey = self:GetAuraOverrideKey()
    if spellID or overrideKey then
        local frameIndex = HUI_BarsListMixin:GetFrameIndex()
        local profileName = HUIProfilesMixin:GetPlayerProfile()
        local profileTable = Addon.P.profilesList[profileName]
        if profileTable["CDMCustomFrames"] then
            local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
            if frameTbl then
                if overrideKey then
                    if frameTbl.auraUnits then frameTbl.auraUnits[overrideKey] = nil end
                    if frameTbl.auraTypes then frameTbl.auraTypes[overrideKey] = nil end
                    if frameTbl.color then frameTbl.color[overrideKey] = nil end
                    if frameTbl.auraColor then frameTbl.auraColor[overrideKey] = nil end
                    if frameTbl.sounds then frameTbl.sounds[overrideKey] = nil end
                end
                if spellID then
                    if frameTbl.realAuras then frameTbl.realAuras[spellID] = nil end
                    if frameTbl.fakeAuras then frameTbl.fakeAuras[spellID] = nil end
                    if frameTbl.displayTypes then frameTbl.displayTypes[spellID] = nil end
                    if frameTbl.stages then frameTbl.stages[spellID] = nil end
                    if frameTbl.stageThresholds then frameTbl.stageThresholds[spellID] = nil end
                end
            end
        end
    end

    tremove(itemList, index)
    --tremove(Addon.trackedIDs, index)
    parentFrame:OnShow()
    EventRegistry:TriggerEvent("CDMCustomItemList.ItemRemoved", itemList, parentFrame.frameName)
end

function OptionsCDMCustomItemMixin:OnDragStart()
    PlaySound(SOUNDKIT.UI_CURSOR_PICKUP_OBJECT)
    self:BeginOrderChange()
end
function OptionsCDMCustomItemMixin:SaveCustomColor(newColor)
    local itemID = self:GetAuraOverrideKey()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    newColor.r = newColor.r or 1
    newColor.g = newColor.g or 1
    newColor.b = newColor.b or 1
    newColor.a = newColor.a or 1

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if not frameTbl.color then
            frameTbl.color = {}
        end
        frameTbl.color[itemID] = newColor
    end
    EventRegistry:TriggerEvent("CDMCustomItemList.UpdateFrame", self.parentFrame.frameName)
end

function OptionsCDMCustomItemMixin:GetCustomColor()
    local itemID = self:GetAuraOverrideKey()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    local color

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.color then
            color = frameTbl.color[itemID]
        end
    end
    if color then
        color.r = color.r or 1
        color.g = color.g or 1
        color.b = color.b or 1
        color.a = color.a or 1
    end
    return color or { r=1, g=1, b=1, a=1 }
end

---
function OptionsCDMCustomItemMixin:SaveCustomAuraColor(newColor)
    local itemID = self:GetAuraOverrideKey()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    newColor.r = newColor.r or 1
    newColor.g = newColor.g or 1
    newColor.b = newColor.b or 1
    newColor.a = newColor.a or 1

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if not frameTbl.auraColor then
            frameTbl.auraColor = {}
        end
        frameTbl.auraColor[itemID] = newColor
    end
    EventRegistry:TriggerEvent("CDMCustomItemList.UpdateFrame", self.parentFrame.frameName)
end

function OptionsCDMCustomItemMixin:GetCustomAuraColor()
    local itemID = self:GetAuraOverrideKey()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    local color

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.auraColor then
            color = frameTbl.auraColor[itemID]
        end
    end
    if color then
        color.r = color.r or 1
        color.g = color.g or 1
        color.b = color.b or 1
        color.a = color.a or 1
    end
    return color or { r=1, g=1, b=1, a=1 }
end
function OptionsCDMCustomItemMixin:SaveAuraSound(triggerID, soundName)
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if not frameTbl.sounds then
            frameTbl.sounds = {}
        end
        if not frameTbl.sounds[itemID] then
            frameTbl.sounds[itemID] = {}
        end
        frameTbl.sounds[itemID][triggerID] = soundName
        EventRegistry:TriggerEvent("CDMCustomItemList.AuraSoundChanged", itemID, triggerID, soundName, self.parentFrame.frameName)
    end
end

function OptionsCDMCustomItemMixin:GetAuraSound(triggerID)
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.sounds and frameTbl.sounds[itemID] then
            return frameTbl.sounds[itemID][triggerID]
        end
    end
end

function OptionsCDMCustomItemMixin:RemoveAuraSoundSetting(triggerID)
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.sounds and frameTbl.sounds[itemID] then
            frameTbl.sounds[itemID][triggerID] = nil
            if not next(frameTbl.sounds[itemID]) then
                frameTbl.sounds[itemID] = nil
            end
        end
        EventRegistry:TriggerEvent("CDMCustomItemList.AuraSoundChanged", itemID, triggerID, nil, self.parentFrame.frameName)
    end
end

function OptionsCDMCustomItemMixin:GetAllAuraSounds()
    local itemID = self:GetSpellID()
    if not itemID then return {} end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.sounds and frameTbl.sounds[itemID] then
            return frameTbl.sounds[itemID]
        end
    end
    return {}
end

function OptionsCDMCustomItemMixin:AddSoundPreviewButton(radio, soundName)
    radio:AddInitializer(function(button, _description, _menu)
        local playSampleButton = MenuTemplates.AttachUtilityButton(button, MenuVariants.GearButtonTexture)
        MenuTemplates.SetUtilityButtonAnchor(playSampleButton, MenuVariants.GearButtonAnchor, button, 0, 0)
        MenuTemplates.SetUtilityButtonTooltipText(playSampleButton, L.AuraSoundPlaySample)
        MenuTemplates.SetUtilityButtonClickHandler(playSampleButton, function()
            local lsm = LibStub("LibSharedMedia-3.0", true)
            local path = lsm and lsm:Fetch("sound", soundName, true)
            if path and PlaySoundFile then
                PlaySoundFile(path, "Master")
            end
        end)
        if button.Layout then
            button:Layout()
        end
    end)
end
---

function OptionsCDMCustomItemMixin:GetBarDisplayType()
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    local displayType

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.displayTypes then
            displayType = frameTbl.displayTypes[itemID]
        end
    end
    return displayType or 3
end

function OptionsCDMCustomItemMixin:IsRacialSpell()
    if not self.spellID then return false end

    return Addon:IsRacialSpell(self.spellID)
end

--[[ function OptionsCDMCustomItemMixin:IsStagesEnabled()
    return self.isStagesEnabled == true
end

function OptionsCDMCustomItemMixin:EnableStages()
    local itemID = self:GetSpellID()
    if not itemID then return end
    local isChecked = self:IsStagesEnabled()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    local index = HUI_BarsListMixin:GetFrameIndex()
    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][index]
        if not frameTbl.stages then
            frameTbl.stages = {}
        end
        frameTbl.stages[itemID] = not isChecked
        EventRegistry:TriggerEvent("CDMCustomItemList.StagesAdded", itemID, not isChecked)
        self.isStagesEnabled = not isChecked
    end
end ]]

function OptionsCDMCustomItemMixin:DisplayContextMenu()
    MenuUtil.CreateContextMenu(self, function(owner, rootDescription)
        rootDescription:SetTag("CDMCustom ContextMenu")

        rootDescription:CreateButton(L.ConfigureAura, function()
            self.parentFrame:OpenAuraSettings(self)
        end)
        if self:IsBarFrame() then
            rootDescription:CreateButton(L.Stages, function()
                self.parentFrame:OpenStagesSettings(self)
            end)
            --rootDescription:CreateCheckbox(L.Stages, self:IsStagesEnabled(), self:EnableStages())
            do
                local color = self.color
                local colorInfo = {
                    r=color.r, g=color.g, b=color.b, opacity=color.a,
                    swatchFunc = function()
                        local r,g,b = ColorPickerFrame:GetColorRGB()
                        local a = ColorPickerFrame:GetColorAlpha()
                        self:SaveCustomColor({r=r, g=g, b=b, a=a})
                        self.color = {r=r, g=g, b=b, a=a}
                        self.HasColor:SetVertexColor(r, g, b, 1)
                    end,
                    cancelFunc = function()
                        local r,g,b = ColorPickerFrame:GetColorRGB()
                        local a = ColorPickerFrame:GetColorAlpha()
                        self:SaveCustomColor({r=r, g=g, b=b, a=a})
                        self.color = {r=r, g=g, b=b, a=a}
                        self.HasColor:SetVertexColor(r, g, b, 1)
                    end,
                    hasOpacity = 1,
                }
                rootDescription:CreateColorSwatch(L.UseCustomColor, function()
                    ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
                end,
                colorInfo)
            end
        end
        if self:IsRacialSpell() then
            rootDescription:CreateButton("Racial Settings", function()
                self.parentFrame:OpenRacialSettings(self)
            end)
        end
        if self.type == "potion" and self.potType == "DPS" then
            rootDescription:CreateButton(L.PotionSettings, function()
                self.parentFrame:OpenPotionSettings(self)
            end)
        end
        --[[
        if C_UnitAuras and C_UnitAuras.AddAuraSound then
            local soundSubmenu = rootDescription:CreateButton(L.AuraSound)
            local lsm = LibStub("LibSharedMedia-3.0", true)
            local soundList = lsm and lsm:List("sound") or {}
            for triggerID, triggerName in pairs(Addon.AuraSoundTriggers) do
                local triggerSubmenu = soundSubmenu:CreateButton(triggerName)
                triggerSubmenu:CreateRadio(L.AuraSoundNone,
                    function() return self:GetAuraSound(triggerID) == nil end,
                    function() self:RemoveAuraSoundSetting(triggerID) end)
                for _, soundName in ipairs(soundList) do
                    if soundName ~= "None" then
                        local radio = triggerSubmenu:CreateRadio(soundName,
                            function() return self:GetAuraSound(triggerID) == soundName end,
                            function() self:SaveAuraSound(triggerID, soundName) end)
                        self:AddSoundPreviewButton(radio, soundName)
                    end
                end
            end
        end
]]
        rootDescription:CreateDivider()
        rootDescription:CreateButton(L.Delete, function()
            self:RemoveItem()
        end)
    end)
end

function OptionsCDMCustomItemMixin:OnMouseUp(button, upInside)
    if upInside then
        if button == "LeftButton" then
            local eatNextGlobalMouseUp = button
            PlaySound(SOUNDKIT.UI_CURSOR_PICKUP_OBJECT)
            self:BeginOrderChange(eatNextGlobalMouseUp)
        elseif button == "RightButton" then
            if IsLeftShiftKeyDown() and not self:GetReorderLocked() then
                self:RemoveItem()
            elseif not self:GetReorderLocked() then
                self:DisplayContextMenu()
            end
        end
    end
end

function OptionsCDMCustomItemMixin:BeginOrderChange(eatNextGlobalMouseUp)
    if self.parentFrame then
        self.parentFrame:BeginOrderChange(self, eatNextGlobalMouseUp)
    end
end

function OptionsCDMCustomItemMixin:UpdateReorderMarkerPosition(marker, cursorX, _cursorY)
	local centerX = self:GetCenter()
	if cursorX < centerX then
		marker:SetPoint("CENTER", self, "LEFT", -4, 0)
		return REORDER_MARKER_BEFORE_TARGET
	else
		marker:SetPoint("CENTER", self, "RIGHT", 4, 0);
		return REORDER_MARKER_AFTER_TARGET
	end
end

function OptionsCDMCustomItemMixin:GetReorderLocked()
	return self.reorderLocked
end

function OptionsCDMCustomItemMixin:SetReorderLocked(locked)

	self.reorderLocked = locked
	--self:RefreshData()
end
function OptionsCDMCustomItemMixin:SaveFakeAura(newDuration)
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if not frameTbl.fakeAuras then
            frameTbl.fakeAuras = {}
        end
        if not frameTbl.fakeAuras[itemID] then
            frameTbl.fakeAuras[itemID] = {
                duration = newDuration,
                type = 1,
            }
            EventRegistry:TriggerEvent("CDMCustomItemList.FakeAuraTypeChanged", itemID, 1)
        else
            frameTbl.fakeAuras[itemID].duration = newDuration
        end
        EventRegistry:TriggerEvent("CDMCustomItemList.FakeAuraAdded", itemID, newDuration)
    end
end

function OptionsCDMCustomItemMixin:GetFakeAura()
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.fakeAuras and frameTbl.fakeAuras[itemID] then
            return frameTbl.fakeAuras[itemID].duration
        end
    end
end

function OptionsCDMCustomItemMixin:SaveRealAura(auraSpellIDs)
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if not frameTbl.realAuras then
            frameTbl.realAuras = {}
        end
        frameTbl.realAuras[itemID] = auraSpellIDs
        EventRegistry:TriggerEvent("CDMCustomItemList.RealAuraAdded", itemID, auraSpellIDs)
    end
end

function OptionsCDMCustomItemMixin:GetRealAura()
    local itemID = self:GetSpellID()
    if not itemID or self:IsAuraFrame() then return {} end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.realAuras and frameTbl.realAuras[itemID] then
            return frameTbl.realAuras[itemID]
        end
    end
    return Addon.SPELLID_TO_AURASPELLID[itemID] and Addon.SPELLID_TO_AURASPELLID[itemID].linkedSpellIDs or {}
end

function OptionsCDMCustomItemMixin:SaveAuraUnitOverride(unitID)
    local itemID = self:GetAuraOverrideKey()
    if not itemID or not unitID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if not frameTbl then return end
        Addon.MigrateAuraOverrides(frameTbl)
        if not frameTbl.auraUnits then
            frameTbl.auraUnits = {}
        end
        frameTbl.auraUnits[itemID] = unitID
    end
end

function OptionsCDMCustomItemMixin:GetAuraUnitOverride()
    local itemID = self:GetAuraOverrideKey()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl then
            Addon.MigrateAuraOverrides(frameTbl)
            if frameTbl.auraUnits then
                return frameTbl.auraUnits[itemID]
            end
        end
    end
end

function OptionsCDMCustomItemMixin:SaveAuraTypeOverride(typeID)
    local itemID = self:GetAuraOverrideKey()
    if not itemID or not typeID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if not frameTbl then return end
        Addon.MigrateAuraOverrides(frameTbl)
        if not frameTbl.auraTypes then
            frameTbl.auraTypes = {}
        end
        frameTbl.auraTypes[itemID] = typeID
    end
end

function OptionsCDMCustomItemMixin:GetAuraTypeOverride()
    local itemID = self:GetAuraOverrideKey()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl then
            Addon.MigrateAuraOverrides(frameTbl)
            if frameTbl.auraTypes then
                return frameTbl.auraTypes[itemID]
            end
        end
    end
end

function OptionsCDMCustomItemMixin:GetStages()
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.stages then
            return frameTbl.stages[itemID]
        end
    end
end

function OptionsCDMCustomItemMixin:GetStageThreshold()
    local itemID = self:GetSpellID()
    if not itemID then return end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    local threshold

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.stageThresholds then
            threshold = frameTbl.stageThresholds[itemID]
        end
    end

    local result = { enabled = false, r = 0.8, g = 0.1, b = 0.1, a = 1 }
    if threshold then
        result.enabled = threshold.enabled and true or false
        result.value = threshold.value
        result.r = threshold.r or 0.8
        result.g = threshold.g or 0.1
        result.b = threshold.b or 0.1
        result.a = threshold.a or 1
    end
    return result
end

function OptionsCDMCustomItemMixin:GetStageThresholds()
    local itemID = self:GetSpellID()
    if not itemID then return nil end
    local frameIndex = HUI_BarsListMixin:GetFrameIndex()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if profileTable["CDMCustomFrames"] then
        local frameTbl = profileTable["CDMCustomFrames"][frameIndex]
        if frameTbl and frameTbl.stageThresholds then
            return HUI_CDMThresholdMixin:NormalizeRecord(frameTbl.stageThresholds[itemID])
        end
    end
    return nil
end

----------------------------------------
HUI_FakeAuraEditBoxMixin = {}

function HUI_FakeAuraEditBoxMixin:OnShow()
        
end

function HUI_FakeAuraEditBoxMixin:OnEnterPressed()
        
end
function HUI_FakeAuraEditBoxMixin:OnEditFocusLost()
    
end
function HUI_FakeAuraEditBoxMixin:OnEditFocusGained()
    
end
function HUI_FakeAuraEditBoxMixin:OnTextChanged()
    local auraSettingsFrame = self:GetParent():GetParent()
    if auraSettingsFrame.AuraContainer then
        local realAuraCover = auraSettingsFrame.AuraContainer.InactiveAuraFrame

        local duration = tonumber(self:GetText())
        if duration and duration > 0 then
            realAuraCover:Show()
        else
            self:SetText("")
            realAuraCover:Hide()
        end
    end
end

HUI_RealAuraEditBoxMixin = {}
function HUI_RealAuraEditBoxMixin:OnShow()
        
end

function HUI_RealAuraEditBoxMixin:OnEnterPressed()
        
end
function HUI_RealAuraEditBoxMixin:OnEditFocusLost()
    local text = self:GetText()
    
    local cleanText = text:match("^,?(.-),?$") or ""
    
    if text ~= cleanText then
        self:SetText(cleanText)
    end
end
function HUI_RealAuraEditBoxMixin:OnEditFocusGained()
    
end
function HUI_RealAuraEditBoxMixin:OnTextChanged()
    local text = self:GetText()
    local cleanText = text:gsub("[^%d,]", ""):gsub(",+", ",")

    if text ~= cleanText then
        local cursorPos = self:GetCursorPosition()
        
        local beforeCursor = text:sub(1, cursorPos)
        local cleanBefore = beforeCursor:gsub("[^%d,]", ""):gsub(",+", ",")
        local diff = beforeCursor:len() - cleanBefore:len()
        
        self:SetText(cleanText)
        self:SetCursorPosition(math.max(0, cursorPos - diff))
    end
end

HUI_FakeAuraConfirmButtonMixin = {}

function HUI_FakeAuraConfirmButtonMixin:OnLoad()
    self:SetText(L.Confirm)
end
function HUI_FakeAuraConfirmButtonMixin:OnShow()
    
end

function HUI_FakeAuraConfirmButtonMixin:OnHide()

end

function HUI_FakeAuraConfirmButtonMixin:OnClick()
    local fakeAuraFrame = self:GetParent()
    local editBox = fakeAuraFrame.EditBox
    local newDuration = tonumber(editBox:GetText())
    self:GetParent():Hide()
end
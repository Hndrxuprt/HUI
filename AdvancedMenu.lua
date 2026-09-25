local AddonName, Addon = ...

local L = Addon.L

local RightClickAtlasMarkup = CreateAtlasMarkup('NPE_RightClick', 18, 18);
local LeftClickAtlasMarkup = CreateAtlasMarkup('NPE_LeftClick', 18, 18);

local ActionBarNames = Addon.ActionBarNames
local miniBars = {
    "PetActionBar",
    "StanceBar",
}
local microBars = {
    "BagsBar",
    "MicroMenu",
}
local CDMFrames = Addon.CDMFrames

local function GetNextCustomFrameID()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    local maxID = 0
    local frames = profileTable["CDMCustomFrames"]
    if frames then
        for index, frameData in ipairs(frames) do
            if frameData.index then
                maxID = frameData.index > maxID and frameData.index or maxID
            end
        end
    end
    return maxID + 1
end

local function BuildMenuList()
    local menuList = {
        {
            name = "Quick Presets",
            buttons = {
                {
                    name = "Presets",
                    layout = "layoutPresets",
                },
            },
        },
        {
            name = "Modules",
            buttons = {
                {
                    label = "Modules",
                    name = "Modules",
                    layout = "layoutModules",
                },
            },
        },
        {
            name = "Action Bars",
            module = "ActionBars",
            buttons = {},
        },
        {
            name = "Cooldown Manager",
            module = "CooldownManagerView",
            buttons = {},
        },
        {
            name = "Custom Frames",
            module = "CooldownManagerCustom",
            buttons = {},
        },
        {
            name = "Cast Bars",
            module = "CastingBar",
            buttons = {},
        },
    }

    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    for _, element in ipairs(menuList) do
        if element.name == "Action Bars" then
            for index, bar in ipairs(ActionBarNames) do
                table.insert(element.buttons, {
                    label = bar,
                    name = L[bar] or bar,
                    category = 2,
                    index = index,
                    layout = (tContains(miniBars, bar) and "layoutMini")
                            or (tContains(microBars, bar) and "layoutMicro")
                            or "layout"
                })
            end
            table.insert(element.buttons, {
                label = "ExtraZoneAbility",
                name = L.ExtraZoneAbility,
                category = 2,
                index = #ActionBarNames + 1,
                layout = "layoutExtraZone"
            })
        elseif element.name == "Cooldown Manager" then
            for index, frame in ipairs(CDMFrames) do
                table.insert(element.buttons, {
                    label = frame,
                    name = L[frame] or frame,
                    category = 1,
                    layout = frame ~= "UtilityCooldownViewer" and frame or "EssentialCooldownViewer",
                    index = index,
                })
            end
        elseif element.name == "Custom Frames" then
            if profileTable["CDMCustomFrames"] then
                for index, data in ipairs(profileTable["CDMCustomFrames"]) do
                    if data then
                        local displayName = data.name ~= "" and data.name or ("Custom Frame "..index)
                        table.insert(element.buttons, {
                            label = data.label,
                            name = displayName,
                            layout = data.layout,
                            index = index,
                            point = data.point,
                        })
                    end
                end
            end
            table.insert(element.buttons, {
                label = "AddCustomFrame",
                name = "",
                index = 99999,
            })
        elseif element.name == "Cast Bars" then
            for index, frame in ipairs(Addon.CASTBARS or {}) do
                table.insert(element.buttons, {
                    label = frame,
                    name = L[frame] or frame,
                    category = 1,
                    layout = frame ~= "PlayerCastingBarFrame" and "TargetFrameSpellBar" or "PlayerCastingBarFrame",
                    index = index,
                })
            end
        end
    end

    return menuList
end


HUI_BarsFrameMixin = {}

function HUI_BarsFrameMixin:OnClick()
    self:Toggle()
end

function HUI_BarsFrameMixin:OnLoad()
    self:Collapse()
    if not HUI_BarsFrameMixin.selection then
        HUI_BarsFrameMixin.selection = CreateFrame("Frame", nil, UIParent, "HUI_BarsHighlightTemplate")
    end
end

function HUI_BarsFrameMixin:Toggle()
    if HUI_BarsFrameMixin.collapsed then
        self:Expand()
    else
        self:Collapse()
    end
end

function HUI_BarsFrameMixin:Expand()
    HUI_BarsFrameMixin.collapsed = false
    HUIOptionsAdvancedFrame:SetPoint("LEFT", HUIOptionsFrame, "RIGHT", -5, 0)
end

function HUI_BarsFrameMixin:Collapse()
    HUI_BarsFrameMixin.collapsed = true
    HUIOptionsAdvancedFrame:SetPoint("LEFT", HUIOptionsFrame, "RIGHT", -205, 0)
end

function HUI_BarsFrameMixin:Init()
    local optionsFrame = HUIOptionsFrame
    optionsFrame.advanced = CreateFrame("Frame", "HUIOptionsAdvancedFrame", optionsFrame, "HUI_BarsFrameTemplate")
    optionsFrame.advanced:ClearAllPoints()
    optionsFrame.advanced:SetParent(HUIOptionsFrame)
    optionsFrame.advanced:SetPoint("LEFT", optionsFrame, "RIGHT", -205, 0)
    optionsFrame.advanced.NineSlice.Title:SetRotation(1.5708)

    local listFrame = CreateFrame("Frame", "HUI_ListFrame", optionsFrame.advanced, "HUI_BarsListTemplate")
    listFrame:SetParent(optionsFrame.advanced)
    listFrame:SetPoint("TOPLEFT", 5, -5)
    listFrame:SetPoint("BOTTOMRIGHT", -5, 5)

    HUI_BarsListMixin:Init()
end

HUI_BarsListMixin = {}

local function OnDeleteMenuFrame(self, frameLabel)
    if HUI_BarsListMixin.label == frameLabel then
        HUI_BarsListMixin.label = nil
        HUI_BarsListMixin.bar = nil
        HUI_BarsListMixin.selected = nil
        if HUI_BarsListMixin.pinnedLabel == frameLabel then
            HUI_BarsListMixin.pinnedLabel = nil
        end
        HUIMixin:InitData(nil)
    end

    HUI_BarsListMixin:RefreshMenu()
end

function HUI_BarsListMixin:GetDataProvider()
    return self.dataProvider
end

function HUI_BarsListMixin:OnLoad()
    EventRegistry:RegisterCallback("CDMCustomItemList.DeleteFrame", OnDeleteMenuFrame, self)
end

function HUI_BarsFrameMixin:OnHide()
    if HUI_BarsFrameMixin.selection then
        HUI_BarsFrameMixin.selection:Hide()
        if HUI_BarsListMixin.bar then
            if HUI_BarsListMixin.bar.HUISelection then
                HUI_BarsListMixin.bar.HUISelection:Hide()
                HUI_BarsListMixin.bar.HUISelection:SetSelected(false)
            end
            Addon:SetFrameAlpha(HUI_BarsListMixin.bar)
            if HUI_BarsListMixin.bar.ShouldHide then
                HUI_BarsListMixin.bar:Hide()
            end
        end
    end

    if HUI_BarsListMixin.pinnedLabel and Addon.CDMUnpinCustomFrame then
        Addon:CDMUnpinCustomFrame(HUI_BarsListMixin.pinnedLabel)
        HUI_BarsListMixin.pinnedLabel = nil
    end
end

local function FindButtonByLabel(label)
    if not label then return nil end

    local scrollBox = HUI_BarsListMixin.scrollBox
    if not scrollBox then return nil end

    for _, frame in scrollBox:EnumerateFrames() do
        for _, child in ipairs({ frame:GetChildren() }) do
            if child.frameLabel == label then
                return child
            end
        end
    end
    return nil
end

local function FindButtonByLayout(layout)
    if not layout then return nil end

    local scrollBox = HUI_BarsListMixin.scrollBox
    if not scrollBox then return nil end

    for _, frame in scrollBox:EnumerateFrames() do
        for _, child in ipairs({ frame:GetChildren() }) do
            if child.frameLabel == nil and child.layout == layout then
                return child
            end
        end
    end
    return nil
end

local function ApplySelection(button, buttonData)
    if HUI_BarsListMixin.selected then
        HUI_BarsListMixin.selected:SetSelected(false)
        HUI_BarsListMixin.selected = nil
    end

    if HUI_BarsListMixin.pinnedLabel and HUI_BarsListMixin.pinnedLabel ~= buttonData.label and Addon.CDMUnpinCustomFrame then
        Addon:CDMUnpinCustomFrame(HUI_BarsListMixin.pinnedLabel)
        HUI_BarsListMixin.pinnedLabel = nil
    end

    HUI_BarsListMixin.label = buttonData.label
    HUI_BarsListMixin.index = buttonData.index

    local isCustomFrame = buttonData.category == nil and buttonData.label ~= "GlobalSettings" and not tContains(CDMFrames, buttonData.label)
    if isCustomFrame and Addon.CDMPinCustomFrame then
        Addon:CDMPinCustomFrame(buttonData.label)
        HUI_BarsListMixin.pinnedLabel = buttonData.label
    end

    if HUI_BarsListMixin.bar then
        if HUI_BarsListMixin.bar.ShouldHide then
            if not InCombatLockdown() then
                HUI_BarsListMixin.bar:Hide()
            end
        end
        Addon:SetFrameAlpha(HUI_BarsListMixin.bar)
    end

    HUI_BarsListMixin.bar = (buttonData.label ~= "GlobalSettings" and not tContains(CDMFrames, buttonData.label)) and _G[buttonData.label] or nil
    if HUI_BarsListMixin.bar then
        HUI_BarsListMixin.bar.ShouldHide = not HUI_BarsListMixin.bar:IsVisible()
        if not InCombatLockdown() then
            HUI_BarsListMixin.bar:Show()
        end
        Addon:SetFrameAlpha(HUI_BarsListMixin.bar, 1)
    end

    HUI_BarsListMixin.selected = button
    HUI_BarsListMixin.selected.label = buttonData.label
    HUI_BarsListMixin.selected.layout = buttonData.layout
    button:SetSelected(true)
    HUIMixin:InitData(Addon[buttonData.layout])
end

function HUI_BarsListMixin:OnShow()
    local selected = HUI_BarsListMixin.selected
    if not selected then
        return
    end

    local label = selected.label
    local isNonFrame = label == nil or label == "GlobalSettings" or label == "Modules" or label == "ExtraZoneAbility"
    if not isNonFrame and not _G[label] then
        return
    end

    local button = FindButtonByLabel(label) or FindButtonByLayout(selected.layout)
    if button then
        HUI_BarsListMixin.selected = button
    end
    ApplySelection(HUI_BarsListMixin.selected, {
        label = label,
        layout = selected.layout,
        index = HUI_BarsListMixin.index,
    })
end

function HUI_BarsListMixin:OnHide()

end


HUI_BarsButtonMixin = {}

function HUI_BarsButtonMixin:OnShow()

end

function HUI_BarsButtonMixin:OnHide()
    self.active = false
    if self.Texture then
        self.Texture:Hide()
    end
end

function HUI_BarsButtonMixin:SetButtonName(name)
    self.Label:SetText(name)
end

local function OnCreateNewMenuFrame(self, frameLabel, frameName)
    if self.frameLabel ~= frameLabel then return end
    self:SetButtonName(frameName)
end

function HUI_BarsButtonMixin:OnRenameFrame(frameLabel, frameName)
    if self.frameLabel ~= frameLabel then return end
    self:SetButtonName(frameName)
end

function HUI_BarsButtonMixin:OnLoad()
    EventRegistry:RegisterCallback("CDMCustomItemList.CreateNewFrame", OnCreateNewMenuFrame, self)
    EventRegistry:RegisterCallback("CDMCustomItemList.RenameFrame", self.OnRenameFrame, self)
end

function HUI_BarsButtonMixin:SetSelected(selected)
    local bar = HUI_BarsListMixin.label ~= "GlobalSettings" and _G[HUI_BarsListMixin.label] or nil
    if not bar then return end

    local isCastBar = bar == PlayerCastingBarFrame or bar == TargetFrameSpellBar or bar == FocusFrameSpellBar

    if bar.HUISelection then
        if selected then
            self.active = true
            self.Texture:Show()
            bar.HUISelection:Show()
        else
            self.active = false
            bar.HUISelection:Hide()
            bar.HUISelection:SetSelected(false)
            self.Texture:Hide()
        end
        return
    end

    if selected then
        self.Texture:Show()
        self.active = true

        if not bar:HasAnyForbiddenAspects() then
            HUI_BarsFrameMixin.selection:ClearAllPoints()
            HUI_BarsFrameMixin.selection:SetPoint("TOPLEFT", bar, "TOPLEFT", -4, 4)
            HUI_BarsFrameMixin.selection:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 4, -4)
            HUI_BarsFrameMixin.selection:SetFrameLevel(bar:GetFrameLevel() - 1)
            HUI_BarsFrameMixin.selection:Show()
            HUI_BarsFrameMixin.selection.PulseAnim:Play()
        end

        if isCastBar and HUI_CastingBarMixin then
            HUI_CastingBarMixin.OnOptionsSelected(bar, true)
        end
    else
        HUI_BarsFrameMixin.selection:Hide()
        HUI_BarsFrameMixin.selection.PulseAnim:Stop()

        if isCastBar and HUI_CastingBarMixin then
            HUI_CastingBarMixin.OnOptionsSelected(bar, false)
        end

        self.Texture:Hide()
        self.active = false
    end
end

function HUI_BarsListMixin:ResetBarSettings(barName)
    HUIProfilesMixin:ResetCatOptions(barName)
end

function HUI_BarsListMixin:GetFrame()
    return self
end

function HUI_BarsListMixin:InitButtons(buttons, frame)
    local currentProfile = Addon:GetCurrentProfile()
    local profileTable = Addon.P.profilesList[currentProfile]

    local frames = {}
    for i, buttonData in ipairs(buttons) do
        local template = "HUI_BarsListButtonTemplate"

        if buttonData.label == "AddNewGroup" or buttonData.label == "AddCustomFrame" then
            template = "HUI_BarsListCreateGroupFrameTemplate"
        end

        local button = CreateFrame("Button", nil, frame, template)
        table.insert(frames, button)
        if i == 1 then
            button:SetPoint("TOP", frame.Background, "BOTTOM", 0, -1)
        else
            button:SetPoint("TOP", frames[i-1], "BOTTOM", 0, -1)
        end
        if button.Label then
            button.Label:SetText(buttonData.name or "Button")
        end
        button.frameLabel = buttonData.label
        button.layout = buttonData.layout

        local hasConfig = profileTable and profileTable[buttonData.label] and next(profileTable[buttonData.label])

        button:SetScript("OnEnter", function(self)
            if buttonData.label == "AddNewGroup" or buttonData.label == "AddCustomFrame" then
                return
            end

            if HUI_BarsListMixin.hoveredButton and HUI_BarsListMixin.hoveredButton ~= self then
                local prev = HUI_BarsListMixin.hoveredButton
                prev.Copy:Hide()
                prev.Paste:Hide()
            end

            HUI_BarsListMixin.hoveredButton = self

            local inCopypasteMode = HUI_BarsListMixin.copypaste

            if hasConfig and buttonData.label ~= "GlobalSettings" and buttonData.label ~= "BuffBarCooldownViewer" then
                if not inCopypasteMode then
                    self.Copy:Show()
                    self.Paste:Hide()
                elseif inCopypasteMode ~= buttonData.label and HUI_BarsListMixin.layout == buttonData.layout then
                    self.Copy:Hide()
                    self.Paste:Show()
                end
            elseif buttonData.label ~= "BuffBarCooldownViewer" then
                self.Copy:Hide()
                if inCopypasteMode and inCopypasteMode ~= buttonData.label and HUI_BarsListMixin.layout == buttonData.layout then
                    self.Paste:Show()
                else
                    self.Paste:Hide()
                end
            end
        end)

        button:SetScript("OnLeave", function(self)
            if buttonData.label == "AddNewGroup" or buttonData.label == "AddCustomFrame" then
                return
            end

            local focusedFrames = GetMouseFoci()
            if focusedFrames and focusedFrames[1] then
                local focus = focusedFrames[1]
                if focus == self or focus == self.Copy or focus == self.Paste then
                    return
                end
            end
            button.Copy:Hide()
            button.Paste:Hide()
        end)

        button:SetScript("OnClick", function(self)
            if buttonData.label == "AddNewGroup" then
                Addon.Print("New feature soon.")
                return
            end

            ApplySelection(self, buttonData)
        end)

        if button.Copy and button.Paste and button.Reset then
            if buttonData.label ~= "Presets" and hasConfig then
                button.Reset:Show()
            else
                button.Reset:Hide()
            end

            if buttonData.label ~= "Presets" then
                button.Reset:SetScript("OnClick", function(self)
                    local barName = buttonData.label
                    if not StaticPopup_Visible("HUI_RESET_CAT") then
                        StaticPopup_Show("HUI_RESET_CAT", nil, nil, barName)
                    end
                end)
            end

            button.Copy:SetScript("OnClick", function(self)
                if hasConfig then
                    HUI_BarsListMixin.copypaste = buttonData.label
                    HUI_BarsListMixin.layout = buttonData.layout
                    local panelName = HUI_BarsListMixin.copypaste
                    Addon.Print(string.format(L["Copied: %s"], L[panelName] or panelName))
                    self:Hide()
                end
            end)
            button.Copy:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip_AddColoredLine(GameTooltip, LeftClickAtlasMarkup .. L.CopyText, LIGHTYELLOW_FONT_COLOR)
                GameTooltip:SetScale(0.82)
                GameTooltip:Show()
            end)
            button.Copy:SetScript("OnLeave", function(self)
                GameTooltip:SetScale(1)
                GameTooltip:Hide()
            end)

            button.Paste:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            button.Paste:SetScript("OnClick", function(self, pressed)
                if pressed == "RightButton" then
                    HUI_BarsListMixin.copypaste = nil
                    self:Hide()
                    return
                elseif pressed == "LeftButton" then
                    local fromCat = HUI_BarsListMixin.copypaste
                    local toCat = buttonData.label
                    Addon.Print(string.format(L["Pasted: %s → %s"], L[fromCat] or fromCat, L[toCat] or toCat))
                    HUIProfilesMixin:CopyProfileCategory(fromCat, toCat, true)
                    self:Hide()
                end
            end)
            button.Paste:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip_AddColoredLine(GameTooltip, LeftClickAtlasMarkup .. L.PasteText, NECROLORD_GREEN_COLOR)
                GameTooltip_AddColoredLine(GameTooltip, RightClickAtlasMarkup .. L.CancelText, WARNING_FONT_COLOR)
                GameTooltip:SetScale(0.82)
                GameTooltip:Show()
            end)
            button.Paste:SetScript("OnLeave", function(self)
                GameTooltip:SetScale(1)
                GameTooltip:Hide()
            end)
        end

        if HUI_BarsListMixin.label and buttonData.label == HUI_BarsListMixin.label then
            HUI_BarsListMixin.selected = button
            button.label = buttonData.label
            button.layout = buttonData.layout
            button:SetSelected(true)
        end
    end
end

function HUI_BarsListMixin:GetFrameLebel()
    return self.label
end

function HUI_BarsListMixin:GetFrameIndex()
    return self.index
end

function HUI_BarsListMixin:RefreshMenu()
    if not self.dataProvider then return end

    local scrollPercentage = self.scrollBox:GetScrollPercentage()
    local selectedLabel = self.label

    self.dataProvider:Flush()

    local menu = BuildMenuList()
    for _, element in ipairs(menu) do
        if not element.module or (Addon:IsModuleEnabled(element.module) and Addon:IsModuleLoaded(element.module)) then
            self.dataProvider:Insert({
                name = element.name,
                buttons = element.buttons,
            })
        end
    end

    self.scrollBox:SetScrollPercentage(scrollPercentage, true)

    local selected = self.selected
    if selected and selected.label == selectedLabel then
        local button = FindButtonByLabel(selectedLabel) or FindButtonByLayout(selected.layout)
        if button then
            self.selected = button
            button.label = selectedLabel
            button.layout = selected.layout
            button:SetSelected(true)
        end
    end
end

function HUI_BarsListMixin:OnProfileChanged()
    if not self.dataProvider then return end

    self.label = nil
    self.bar = nil
    self.selected = nil
    if self.pinnedLabel and Addon.CDMUnpinCustomFrame then
        Addon:CDMUnpinCustomFrame(self.pinnedLabel)
        self.pinnedLabel = nil
    end

    self:RefreshMenu()
    HUIMixin:InitData(Addon.layoutPresets)
end

function HUI_BarsListMixin:Init()
    if not self.dataProvider then
        self.dataProvider = CreateDataProvider()

        self.scrollBox = HUI_ListFrame.ScrollBox
        self.scrollBar = HUI_ListFrame.ScrollBar

        function self:ElementInitializer(frame, elementData)
            local containerName = elementData.name
            local buttons = elementData.buttons

            frame.Label:SetText(containerName)
            frame:Show()

            HUI_BarsListMixin:InitButtons(buttons, frame)
        end
    end

    if not self.view then
        self.view = CreateScrollBoxListLinearView()
        self.view:SetPadding(0, 0, 0, 0, 10)
        self.view:SetElementExtentCalculator(function(dataIndex, elementData)
            local height = #elementData.buttons * 21
            return height + 31
        end)

        self.view:SetElementResetter(function(frame, elementData)
            local existing = { frame:GetChildren() }
            for _, child in ipairs(existing) do
                if child ~= frame.Label then
                    child:Hide()
                end
            end
        end)

        self.view:SetElementInitializer("HUI_BarsListHeaderTemplate", function(frame, elementData)
            self:ElementInitializer(frame, elementData)
        end)
        ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.scrollBar, self.view)
        self.scrollBox:Init(self.view)
        self.scrollBox:SetInterpolateScroll(true)
        self.scrollBox:SetDataProvider(self.dataProvider)
        self.scrollBox:SetPanExtent(40)
        self.scrollBar:Hide()
    end
    self:RefreshMenu()
end

HUI_BarsListHeaderMixin = {}

HUI_BarsGroupButtonMixin = {}

HUI_BarsGroupButtonIconMixin = {}

local function CreateCustomFrame(layout, template)
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]

    if not profileTable["CDMCustomFrames"] then
        profileTable["CDMCustomFrames"] = {}
    end

    local index = GetNextCustomFrameID()
    local frameLabel = "CDMCustomFrame_" .. index

    table.insert(profileTable["CDMCustomFrames"], {
        label = frameLabel,
        name = "",
        layout = layout,
        template = template,
        point = {},
        trackedIDs = {},
        visibleSpecs = {},
        index = index,
    })

    EventRegistry:TriggerEvent("CDMCustomItemList.CreateNewFrame", frameLabel, "Custom Frame "..index, template)

    local listFrame = HUI_BarsListMixin:GetFrame()
    listFrame:RefreshMenu()
end

function HUI_BarsGroupButtonIconMixin:OnClick()
    self:DisplayContextMenu()
end

function HUI_BarsGroupButtonIconMixin:DisplayContextMenu()
    MenuUtil.CreateContextMenu(self, function(owner, rootDescription)
        rootDescription:SetTag("CDMCustom CreateMenu")

        rootDescription:CreateButton(L.CreateIconsFrame, function()
            CreateCustomFrame("CustomFrameCooldownViewer", "HUI_CDMCustomFrame")
        end)
        rootDescription:CreateButton(L.CreateAuraFrame, function()
            CreateCustomFrame("CustomFrameAuraViewer", "HUI_CDMCustomAuraFrame")
        end)

        rootDescription:CreateDivider()

        rootDescription:CreateButton(L.CreateBarsFrame, function()
            CreateCustomFrame("CustomFrameBarsAuraViewer", "HUI_CDMCustomAuraBar")
        end)
    end)
end

local AddonName, Addon = ...

local PTM = {}
Addon.PushedTextureMirror = PTM

local icons = setmetatable({}, { __mode = "k" })
local pressedFamilies = {}
local hooksInstalled = false

local BASE_ICON_SIZE = 46

local function IsSecret(value)
    return issecretvalue and issecretvalue(value)
end

local function AddSpell(family, spellID)
    if not spellID or spellID == 0 or IsSecret(spellID) then
        return
    end

    family.spells[spellID] = true

    local base = C_Spell.GetBaseSpell(spellID)
    if base and base ~= 0 and not IsSecret(base) then
        family.spells[base] = true
    end

    local override = C_Spell.GetOverrideSpell(spellID)
    if override and override ~= 0 and not IsSecret(override) then
        family.spells[override] = true
    end
end

local function AddItem(family, itemID)
    if not itemID or itemID == 0 or IsSecret(itemID) then
        return
    end

    family.items[itemID] = true

    local ok, _, spellID = pcall(C_Item.GetItemSpell, itemID)
    if ok then
        AddSpell(family, spellID)
    end
end

local function BuildFamily(slot)
    if not slot or IsSecret(slot) then
        return nil
    end

    local actionType, actionID, subType = GetActionInfo(slot)
    if not actionType or not actionID or IsSecret(actionType) or IsSecret(actionID) then
        return nil
    end

    local family = { spells = {}, items = {} }

    if actionType == "spell" then
        AddSpell(family, actionID)
    elseif actionType == "item" then
        AddItem(family, actionID)
    elseif actionType == "macro" then
        if subType == "item" then
            AddItem(family, actionID)
        else
            AddSpell(family, actionID)
        end
    end

    if not next(family.spells) and not next(family.items) then
        return nil
    end

    return family
end

local function IconMatches(icon, family)
    if icon.spellID then
        local spellID = icon.spellID()
        if spellID and not IsSecret(spellID) and family.spells[spellID] then
            return true
        end
    end

    if icon.itemID then
        local itemID = icon.itemID()
        if itemID and not IsSecret(itemID) and family.items[itemID] then
            return true
        end
    end

    if icon.slot then
        local slotID = icon.slot()
        if slotID and not IsSecret(slotID) then
            local equippedItemID = GetInventoryItemID("player", slotID)
            if equippedItemID and not IsSecret(equippedItemID) and family.items[equippedItemID] then
                return true
            end
        end
    end

    return false
end

local function GetIconSize(frame)
    local ok, width = pcall(frame.GetWidth, frame)
    if not ok or not width or IsSecret(width) or width <= 0 then
        return BASE_ICON_SIZE
    end
    return width
end

local function ApplyOverlay(frame, icon)
    local layer = icon.pushed
    if not layer then
        return false
    end

    if not Addon:GetValue("CDMPushedTextureEnable", nil, icon.frameName) then
        layer.frame:Hide()
        return false
    end

    local styles = Addon.Templates.PushedTextures
    local style = styles[Addon:GetValue("CDMPushedTexture", nil, icon.frameName)] or styles[1]
    local texture = layer.texture

    if Addon.PP then
        Addon.PP.DisablePixelSnap(texture)
    end

    texture:ClearAllPoints()

    if style.atlas then
        texture:SetAtlas(style.atlas)
    elseif style.texture then
        texture:SetTexture(style.texture)
    end

    local scale = 1
    if style.size then
        local point = style.point or "CENTER"
        texture:SetPoint(point, layer.frame, point)
        texture:SetSize(style.size[1], style.size[2])
        scale = GetIconSize(frame) / BASE_ICON_SIZE
    else
        texture:SetAllPoints(layer.frame)
    end

    if style.coords then
        texture:SetTexCoord(style.coords[1], style.coords[2], style.coords[3], style.coords[4])
    else
        texture:SetTexCoord(0, 1, 0, 1)
    end

    texture:SetScale(scale)
    texture:SetDesaturated(Addon:GetValue("DesaturateCDMPushed", nil, icon.frameName))
    texture:SetVertexColor(Addon:GetColor("CDMPushedColor", "UseCDMPushedColor", nil, icon.frameName))

    return true
end

local function EnsureOverlay(frame, icon)
    local layer = icon.pushed
    if layer then
        return layer
    end

    local overlay = CreateFrame("Frame", nil, frame)
    overlay:SetAllPoints(frame)

    local ok, level = pcall(frame.GetFrameLevel, frame)
    if not ok or not level or IsSecret(level) then
        level = 0
    end
    overlay:SetFrameLevel(level + 30)

    overlay:EnableMouse(false)
    overlay.ignoreInLayout = true

    local texture = overlay:CreateTexture(nil, "OVERLAY")
    texture:SetDrawLayer("OVERLAY", 7)

    layer = { frame = overlay, texture = texture }
    icon.pushed = layer

    overlay:Hide()

    return layer
end

local function ShowIcon(frame, icon)
    local layer = EnsureOverlay(frame, icon)
    if ApplyOverlay(frame, icon) then
        layer.frame:Show()
    end
end

local function AnyFamilyMatches(icon)
    for _, family in pairs(pressedFamilies) do
        if IconMatches(icon, family) then
            return true
        end
    end
    return false
end

local function HandlePress(slot, down)
    if not slot then
        return
    end

    if down then
        local family = BuildFamily(slot)
        if not family then
            return
        end

        pressedFamilies[slot] = family

        for frame, icon in pairs(icons) do
            if IconMatches(icon, family) then
                ShowIcon(frame, icon)
            end
        end
    else
        if not pressedFamilies[slot] then
            return
        end
        pressedFamilies[slot] = nil

        for _, icon in pairs(icons) do
            if icon.pushed and icon.pushed.frame:IsShown() and not AnyFamilyMatches(icon) then
                icon.pushed.frame:Hide()
            end
        end
    end
end

local function GetActionButton(id)
    if GetActionButtonForID then
        return GetActionButtonForID(id)
    end
    return _G["ActionButton"..id]
end

local function OnActionButtonDown(id)
    local button = GetActionButton(id)
    if button then
        HandlePress(button.action, true)
    end
end

local function OnActionButtonUp(id)
    local button = GetActionButton(id)
    if button then
        HandlePress(button.action, false)
    end
end

local function OnMultiActionButtonDown(barName, id)
    local bar = _G[barName]
    local button = bar and bar.actionButtons and bar.actionButtons[id]
    if button then
        HandlePress(button.action, true)
    end
end

local function OnMultiActionButtonUp(barName, id)
    local bar = _G[barName]
    local button = bar and bar.actionButtons and bar.actionButtons[id]
    if button then
        HandlePress(button.action, false)
    end
end

function PTM:InstallHooks()
    if hooksInstalled then
        return
    end

    if type(ActionButtonDown) ~= "function" or type(ActionButtonUp) ~= "function"
        or type(MultiActionButtonDown) ~= "function" or type(MultiActionButtonUp) ~= "function" then
        return
    end

    hooksInstalled = true

    hooksecurefunc("ActionButtonDown", OnActionButtonDown)
    hooksecurefunc("ActionButtonUp", OnActionButtonUp)
    hooksecurefunc("MultiActionButtonDown", OnMultiActionButtonDown)
    hooksecurefunc("MultiActionButtonUp", OnMultiActionButtonUp)
end

function PTM:RegisterIcon(frame, desc)
    if not frame or not desc then
        return
    end

    local icon = icons[frame]
    if not icon then
        icon = {}
        icons[frame] = icon
    end

    icon.frameName = desc.frameName
    icon.spellID = desc.spellID
    icon.itemID = desc.itemID
    icon.slot = desc.slot

    self:InstallHooks()
end

function PTM:HideOverlays(frame)
    local icon = frame and icons[frame]
    if not icon then
        return
    end

    if icon.pushed then
        icon.pushed.frame:Hide()
    end
end

function PTM:RegisterFrameIcons(layoutFrame)
    if not layoutFrame or not layoutFrame.GetLayoutChildren then
        return
    end

    local frameName = layoutFrame:GetName()
    if frameName ~= "EssentialCooldownViewer" and frameName ~= "UtilityCooldownViewer" then
        return
    end

    local children = layoutFrame:GetLayoutChildren()
    for _, child in ipairs(children) do
        if child.GetSpellID then
            local iconFrame = child
            self:RegisterIcon(iconFrame, {
                frameName = frameName,
                spellID = function()
                    return iconFrame:GetSpellID()
                end,
            })
        end
    end
end

function PTM:RefreshAll()
    for frame, icon in pairs(icons) do
        if icon.pushed then
            icon.pushed.frame:Hide()
            ApplyOverlay(frame, icon)
        end
    end
end

local function HookViewer(frameName)
    local frame = _G[frameName]
    if not frame or not frame.Layout or frame.__ptmLayoutHooked then
        return
    end

    frame.__ptmLayoutHooked = true

    hooksecurefunc(frame, "Layout", function(self)
        PTM:RegisterFrameIcons(self)
    end)

    PTM:RegisterFrameIcons(frame)
end

local function HookViewers()
    HookViewer("EssentialCooldownViewer")
    HookViewer("UtilityCooldownViewer")
end

PTM:InstallHooks()
HookViewers()

Addon:RegisterEvent("PLAYER_LOGIN", function()
    PTM:InstallHooks()
    HookViewers()
end, "PushedTextureMirror")

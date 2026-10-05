local Addon = _G.HUI

local function CreatePandemicElements(auraButton, frameName)
    if auraButton.pandemicBorder then return end
    if Addon:GetValue("CDMRemovePandemic", nil, frameName) then return end

    auraButton.pandemicBorder = Addon.CreateBorder(auraButton.iconTexture, frameName)
    auraButton.pandemicBorder:SetFrameLevel(auraButton:GetFrameLevel() + 101)
    local pColor = {}
    pColor.r, pColor.g, pColor.b, pColor.a = Addon:GetRGBA("CDMBackdropPandemicColor", nil, frameName)
    auraButton.pColor = pColor
    HUI_CDMCustomFrameCustomized:SetupBackdrop(auraButton.pandemicBorder, frameName, pColor)
    auraButton.pandemicBorder:Show()

    auraButton.pandemicGlow = CreateFrame("Frame", nil, auraButton, "HUI_CDMCustomItemPandemicGlow")
    auraButton.pandemicGlow:SetPoint("TOPLEFT", auraButton, "TOPLEFT", -6, 6)
    auraButton.pandemicGlow:SetPoint("BOTTOMRIGHT", auraButton, "BOTTOMRIGHT", 6, -6)
    auraButton.pandemicGlow:SetFrameLevel(auraButton:GetFrameLevel() + 102)
    auraButton.pandemicGlow:Show()
    auraButton.pandemicGlow.FX.Anim:Play()

    auraButton.pandemicBorder.pandemicRegionIndex = auraButton:AddPandemicRegion(auraButton.pandemicBorder) or true
    auraButton.pandemicGlow.pandemicRegionIndex = auraButton:AddPandemicRegion(auraButton.pandemicGlow) or true
end

HUI_CDMCustomAuraFrameMixin = CreateFromMixins(HUI_CDMCustomAuraMixin)

function HUI_CDMCustomAuraFrameMixin:ConfigureAuraButton(auraButton, spellID)
	if not auraButton:CanBeAccessedInContext() then
		return
	end

	local frameName = self.frameName

	if not auraButton.iconTexture then
		auraButton.iconTexture = auraButton:CreateTexture(nil, "OVERLAY")
		auraButton.iconTexture:SetAllPoints(auraButton)

		local color = {}
		color.r, color.g, color.b, color.a = Addon:GetRGBA("CDMBackdropAuraColor", nil, frameName)
		auraButton.color = color
		auraButton.iconTexture.iconBorder = Addon.CreateBorder(auraButton.iconTexture, frameName)
		auraButton.iconTexture.iconBorder:SetFrameLevel(auraButton:GetFrameLevel() + 100)
		HUI_CDMCustomFrameCustomized:SetupBackdrop(auraButton.iconTexture.iconBorder, frameName, color)

		auraButton.cooldownFrame = CreateFrame("Cooldown", nil, auraButton, "CooldownFrameTemplate")
		auraButton.cooldownFrame:SetFrameLevel(auraButton:GetFrameLevel() + 1)

		auraButton.countFrame = CreateFrame("Frame", nil, auraButton)
		auraButton.countFrame:SetAllPoints(auraButton)
		auraButton.countFrame:SetFrameLevel(auraButton:GetFrameLevel() + 2)
		auraButton.countText = auraButton.countFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	end

	self:CustomizeAuraButton(auraButton)

	local countFormatter = Addon:GetValue("AlwaysShowStacks", nil, frameName) and { formatter = Addon.defaultCountFormatter } or {}
	auraButton:SetIcon(auraButton.iconTexture)
	if Addon:GetValue("CDMAuraShowStacks", nil, frameName) then
		auraButton:SetApplicationCount(auraButton.countText, countFormatter)
	else
		auraButton:ClearApplicationCount()
		auraButton.countText:Hide()
	end
	auraButton:SetDurationCooldown(auraButton.cooldownFrame)

	auraButton:SetMouseMotionEnabled(false)
	if not auraButton.ApplyPingable then
		Mixin(auraButton, HUI_CDMCustomPingAuraMixin)
	end
	auraButton:ApplyPingable(spellID, frameName)

	CreatePandemicElements(auraButton, frameName)
	if auraButton.pandemicBorder then
		local regions = {
			auraButton.pandemicBorder,
			auraButton.pandemicGlow,
		}
		HUI_CDMCustomFrameCustomized:RefreshPandemicRegions(auraButton, regions, nil, frameName)
	end
end

function HUI_CDMCustomAuraFrameMixin:CustomizeAuraButton(auraButton)
	local frameName = self.frameName

	if auraButton:CanBeAccessedInContext() then
		HUI_CDMCustomFrameCustomized:CustomizeCooldownFrame(auraButton.cooldownFrame, frameName)
		HUI_CDMCustomFrameCustomized:RefreshAuraColor(auraButton.cooldownFrame, frameName)
		HUI_CDMCustomFrameCustomized:RefreshAuraTimer(auraButton.cooldownFrame, frameName)
		HUI_CDMCustomFrameCustomized:CustomizeCooldownFont(auraButton.cooldownFrame, frameName)
		HUI_CDMCustomFrameCustomized:CustomizeStacksFont(auraButton.countText, frameName, auraButton)

		local auraDuration = auraButton.GetAuraDuration and auraButton:GetAuraDuration()
		if auraDuration then
			auraButton.cooldownFrame:SetCooldownFromDurationObject(auraDuration, false)
		end
		if Addon:GetValue("UseCDMBackdrop", nil, frameName) then
			self:RefreshBackdrop(auraButton.iconTexture.iconBorder, auraButton.color)
			if Addon:GetValue("UseCDMBackdropAuraColor", nil, frameName) then
				auraButton.iconTexture.iconBorder:Show()
			else
				auraButton.iconTexture.iconBorder:Hide()
			end
		else
			auraButton.iconTexture.iconBorder:Hide()
		end

		if auraButton.pandemicBorder and not Addon:GetValue("CDMRemovePandemic", nil, frameName) then
			self:RefreshBackdrop(auraButton.pandemicBorder, auraButton.pColor)
		end
        auraButton:SetSize(self.iconSize, self.iconSize)
		HUI_CDMCustomFrameCustomized:ApplyIconMask(auraButton.iconTexture, frameName, self.iconSize)
		HUI_CDMCustomFrameCustomized:ApplyIconBorder(auraButton.iconTexture.iconBorder, auraButton.iconTexture, self.iconSize)
	end
end

function HUI_CDMCustomAuraFrameMixin:GetPlaceholder(index)
	local placeholder = self.placeholders[index]
	if not placeholder then
		placeholder = CreateFrame("Frame", nil, self)
		placeholder:SetFrameLevel(self.AuraContainer:GetFrameLevel() - 1)
		placeholder:SetSize(self.iconSize, self.iconSize)
		placeholder.icon = placeholder:CreateTexture(nil, "BACKGROUND")
		placeholder.icon:SetAllPoints(placeholder)
		--placeholder.icon:SetDesaturated(true)
		--placeholder.icon:SetVertexColor(0.6, 0.6, 0.6, 0.5)
		self.placeholders[index] = placeholder

		placeholder.icon.iconBorder = Addon.CreateBorder(placeholder.icon, self:GetName())
        placeholder.icon.iconBorder:SetFrameLevel(placeholder:GetFrameLevel() + 10)
		HUI_CDMCustomFrameCustomized:SetupBackdrop(placeholder.icon.iconBorder, self:GetName())
	end
	return placeholder
end

function HUI_CDMCustomAuraFrameMixin:UpdatePlaceholder(placeholder, spellID)
	placeholder:SetSize(self.iconSize, self.iconSize)
	placeholder.icon:SetTexture(C_Spell.GetSpellTexture(spellID))
	HUI_CDMCustomFrameCustomized:ApplyIconMask(placeholder.icon, self:GetName(), self.iconSize)
	HUI_CDMCustomFrameCustomized:ApplyIconBorder(placeholder.icon.iconBorder, placeholder.icon, self.iconSize)
	self:RefreshBackdrop(placeholder.icon.iconBorder)
    if Addon:GetValue("UseCDMBackdrop", nil, self:GetName()) and Addon:GetValue("UseCDMBackdropColor", nil, self:GetName()) then
        placeholder.icon.iconBorder:Show()
    else
        placeholder.icon.iconBorder:Hide()
    end
end

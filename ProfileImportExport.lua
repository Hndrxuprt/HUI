local AddonName, Addon = ...

local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")

local L = Addon.L
Addon.P = {}

HUIProfilesMixin = {}
HUIImportDialogMixin = {}
HUIExportDialogMixin = {}

local function IsChrSpecs()
    local getter = GetSpecializationSystem
    if not getter and C_SpecializationInfo then
        getter = C_SpecializationInfo.GetSpecializationSystem
    end
    if not getter or not Enum or not Enum.SpecializationSystem then
        return false
    end
    return getter() == Enum.SpecializationSystem.ChrSpecialization
end

local function GetNumSpecs()
    if not IsChrSpecs() then
        return 0
    end
    if GetNumSpecializations then
        return GetNumSpecializations() or 0
    end
    local getter = C_SpecializationInfo and C_SpecializationInfo.GetNumSpecializationsForClassID
    if getter then
        return getter(select(3, UnitClass("player"))) or 0
    end
    return 0
end

local function GetActiveSpec()
    if not IsChrSpecs() then
        return 0
    end
    local getter = GetSpecialization or (C_SpecializationInfo and C_SpecializationInfo.GetSpecialization)
    return getter and getter() or 0
end

local function GetSpecInfo(index)
    local getter = GetSpecializationInfo or (C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo)
    if getter then
        return getter(index)
    end
end

local DefaultProfiles = {
    ["ElvUI Style"] = "fIv3pXX1vCwpEJlqDbwZcgd2G)G2sBDSJ)inon0nSGHjTH4nGDm8qLUZU7fMrSSZvZmRPBEPvwQs0h6l8MLCLI4H(E8B5Ti(l4O1(XKA6MQkv1Mi1Tp1xA65(1mZDbR6x8o35Ep3Z5353535mK5pXYTOFLgHlg4SnDvgTwTIob7EE25MVrqaTE08oHr4k8)7dWDSOF9OdkvZP5vxHUzJAobhO2Wd9Qg5EY(yJ8GqAQZCFp0QEFmLWU8XBWvO1CI8EeTKVx9ObyJREDyrNkBvnWNnVFn)GInVFtgAJZMyCZnqyJ0LDV3gBesJwllB00EJtWM0O7w3PCnQ7XfIC3LhI7jcXI(1QIE0X63k)nV5BFVk(1l5hEQy3H7LBg43OEvHFUyoNswx)1FZCLZKBZm5cY8k871Z099AGtd1sTQn1Bt3OPzNPlRWH8XydMaxYnsWnAyvvuKJ)OTxv69P)6OI(bvPiIo9Xapc8ZWvY2DgxF94DDmzlc7cMMD1iNOgHLDc4xDJa6kR6xZRANKJkiweJiutQYRHbzgLWM4v5YcA7knk7T1vxMw1RX2Sjn3AsEs5hW4SZ)QSMiW7NL)brE18IAoVpYt83P(h5r3HgS7fydn)clVcDB)hrxA(fwDhpK62cJZkBfQzL7XjkRwXPg1UqNH)4x(TF7)LnmpMxy55Ae4WdWajXUL26A(JDHV6p(77b)xmh6a8GIBHJjU4TlDB5nYJCykCrLz4MpLP8ETppTPqyw6bRqFenqz2KkfPjnY)9Ygs63cQVt1QE13KWgvUMoRhFPksrYBKR2j1k8GWAV445HSXnprjN6vPB7vrEY2M38e90I)0YoHBjqxlKARdiE(qgp7HRPPmdQbgoqXVWXnsvRNvKnxkWR67700VrexiYkvgw7oez(RBuM0ojnWT(Lfh1mhJzclrgWUW)8l(srQnWUWZYLBk8NTnJEcgqPZfQCGUSweFkgCVS8CvmQG4IydsHfI87EnysWc((2f(x)JFhEfNao)4W3Ha9MfUuwz2ujo4jsgy2rvQ(HpmTi2T5E5HLkr4o8Myeyx4G927t6PNmSH7spijmdSeB1sIwjIMs0MaJ2pCwcmbbUiwaE2Ju5PvhHt0swnR6cbN8k5GSe41gGDUUAaL6CUWPisToJBDTj6rsynvyue2rpQ8M4nUqFUWfoIEM(0)IgiOVrt7tbNEGJBpC7O3Jf0pmfmyMoPCnoYpRbqg7tgajCMXGBBH9HCKk4Vx9iAqqdw0C1922nDhZe0qkp)Qq31YiT2roY4Wy8tz2aXJPOBxeohmUic(WgEv2ArV6EHUUWWei3mDmzuRFhyern)8ia4VTGvg2hlFXgBSb)wn1tNc(zKhRE1TK1k2f(6zNvY7Sl83gzKPe1mwjD3WcMLseYheFgXHuu6deLuQUIZOT(n1wV9kROT(F9fV4qP17OReJBMEUKRt2gRyCBm8whnwJquUJ6gQoRWRNQpCk1hKd8JaP2YhrdI8qbSLc83jY1cUgbUEsPpUb9SyGnCZy05n0()F)Z(SdvvLyn6F5t)uUipCll9gVXrcuXg)6V8pZvF0762YDzjGHOOFRsyQTOiVNwsSO4sDPji6Kuod8wZaVTvB5MuW(ANgPQDevqlSSwr8IijpoSstN(PeOagZiQ31jiMwD970EPA(LDQTknIRZfUBrH42tEYVbBRcZq2xK4uYX4VT9J2I2u(8JVB1nf9zSl8FEYt4X1Zs9AtjR4z9CPv2IQhuyuCD(ErBunD20TZh4Jx2c0qKze4erDHB8aOmMKNR3NHV4E3BzvZpE77uTCipw)kDw6RE(Zpurhp86x)Dv5Hx(s(IzGFOOtE7YnK8uf(Vp3hWq5xsBQA62vFos7fD4Yf3dNSy7YorUhiobkHWHBHxjrcLxHJ7Gzc)GTDQPICfcYpM4iXtEWZnY(XVdQSQw0gRzQXRBuNESwPn)64o10BEkrTPt3wUjTtpzlJbhmghcHKNoXei6i6K(jdoOqvOC8pHPZ(yEiJExOl8U9AC)RH3VMhAeKdjNIo9qyKNjtxhLIWNelEYocCNSSChfXKNqLMew3yKfIOfS5udKoIFjwtn14)(M3KhQInhdTkoohaNR2oondx11Fhx8BmKbM(E0diGYntjCaZPXAP0k1dZnsCAvUlnY0rTEPa)kyf4oYp44999z8NuK7eAOPJRpSE7xlM9KKXXPuUTDHVzJn4AuWv7TLHTJrECSPN(0pxLS)cXpv4Ib3HGssX54sncDJlHNPLUuWgvRXo7ZEXwynyQsxEbRwPG0sZIMRgZ1riylCOK9JJvw0pmu9ThI2B7ojCcmEMeR)fZPGJIWh667Dk(Cx9dFx(0eNppoSaotbmq83jglNoyg4KNSpi30yd)0dPPOVei)qTnxAgy0SQHPWoZyVByOb4TJhrmCfCP(zJWf65KIU64om2Xn98HhVcthr)TKptGa(eoJc7uH9KGBLbf7H9D564VDwwEzHq3av7yrfjFbL85frjZpJnlbhsGcInfKptkao5pDXXIZkq(s9Zrye0))GW8Kq(b4jejgoMedNqGEigo0qcmSpx2O3nme5tE8aWaeVcheFhboQ(cpuZbMXf5X825icHatexKa7tcL3xopl)p5a2GaUcj5t24e4u9derFGLkReR(PdJFab(XgFBx8B(jU60ZByPspVPl8wtd7tGFUezJ)SJ0FmcEumjmDwy2ld)brt5H7QFIkvDJF1)l",
    ["CooldownManager Style"] = "1zvtSnXXx8y26MgCd4yNpO4ayknLpkq5JeoujKbNVCRWHeIdKOasZAVtSxLnEhn7AcohQqi9VkNHdiUH4yovfHQ6fuRYTEBuOQhqQQTMGQuP)lQMEV9nZo7xMqUK1Z8M37373738MxKVI03Oww4Q26QgdBAAOzUC1RQJxgt)jsxdps(RGxY8M4jvRQHxsVufs3ZyHDT7I1OQdBAysrnal)8sMvNuvttVA5iBY)rEvRfNUKQbw5UW2JwvTObg54GrYZpBb9LWuhhiIv41glHQscAUm)y3DNUT2AlrzLefZL5RJhN)lW(wbbyFUmp)yR99CJPrsuosIIri94LdJGTuTbJT1nRI2aqX0lRtWtRVcUcPlhqfifq31B75fGBCQU2LuRBwZUqDcwH0B2AlSa)aHzTVHTJkS3jclQc)ucG5fyCf27IAka0nXujaqK(8GOGaaVN1KQHPi27JijHnZzs1xXSQTQX4uZLTReLTROpsGyH)RqsmMzPAwJrvxcpnbByKvLU6(j7D4Aukuzhw1YgwH)Vjalgd8ej(yGltpvnvnaxQPluG0)BADbvAzSn3(nUif0hPNqLcaG0lp2bmdkzCEcro02hXRGnawhurM6vT3nKsV5ztrsixLtPxEHfSW2Z2FBq5lKhffitR2j77THwrmIUD5opu8CH1hjv4DdHVUADx3SqI(9V97(f1SS1xOEoLnKBCnDn7kBfJ0Blg6KBZfX5IqR5mAt5s5W6LRypqiYIFChYkU)zDmKlucHljA3tlLkbh5uSg4TrHHOJyTwTDbbQP)6ICf1k1mTni7TkQslGVfO)XK4zn0xzfvQwA(DhWcq63AWDAtubk8BhQt5spUDteQMC6AyEmKxBElu(SrBgGU5EBOgJBywu1yASTnCL3A1ZSjG5slAjpGYDfwYBHLlZF)Y)h04zhqeDsshlfCuhnLRnj1Se4YLpeRBudGEYzAViUUSd3EdDWqKChpActrF1aT9A081TjA7LlZlMzge)tO93VF)7)qE7V4bAd74)7mQwzrHrHk7l46P)86x)2sp5(zrVp5nc9Ys06bqSZXve9Dv8ViwbxArSMSKEayDUTqy1CHd)owLMIekyNVoVMa0HEyajA86qi8J5im7vgQSWYAutImwjB6zR8UYDU8LZhktF(R)hxoZ9ZIEF6FdjaqF0O3IqXwwlRwpuTFofs3Uf1Awv8s42xhaHltJ8Szct6sQgU24Pr4gkxStsYaLm)KTRqQcr)P8cwXPs4z4Mo)wQmpUF2iEergKyBWTNFDGl7rUYYlzAs4YYo8IMVZz5B4rRocjw0Cz(RVDQFfOmwCXT8GHgrI3AsmGxfZT46seBgsIkEGUXmxnDOhO7ZfsqBmdERm5H3xOmEUJ3wJW6KdUju9diWAeMWoalgA9aPvlQzzdOWVDVAF3rU(GEMNlZZE2Z(x4pUs6NVXnUDiL0i5ZoUeVStbmZi5b6I39vNiQABWTWTh9jA6mLHFtBwce78jfJxCvm1wVK7l8kUa50Us7xm0qxqkTF58Z7CjwX)zUrY70TnRx3w2PGzqCDZ5cL(WuiEkx4KayLNrPHd8KWF2KWGgHxAUB46YHcqrBn4GxqEz7))KNiuofpSRHNXnf26Xp(79hKtMqWmoSplPRTNnGtFvMmUD9AS(68ts6zgBDdD76TmOkFKlfKZuxqUXAhXEpHJ8NxKhu)zjzDeAyXIcTincBNi2Uu4iQZ5zXQqskhak8CvSEz9X(OTIX2lILA3SbrS91FBSHIYoDf2bIY2F7SpC3SdPWoyu2aryFmID4byhjf7Si2XIXobID8ySZKIDse7tHsu)PyFcIDueBpSpGDUHyPHPt6zsd16yXRxWRsqmfay10ob(Xj8dC)P8Mp4sWDGQLQ7Fr7v7CThkPVF4bp474k4Y(FsvGqLNnuNSZD(TBKg(WsEJ04mESCUcPY2jj9EQL3RUm1SwvnFe8B9uafIEL0Xrzh5G8k1zrK90YedtDn3zfs6nRaVjAwtBBZLADgvzo7k4)so7EY3WPbK3CkVz4ez2U4SpubBz95MQPpO8ZP)yT1(vjR(0N(0FrWQop9CV7XP7)l",
}

function NewProfile_OnTextChanged(self)
    if not self:HasFocus() and self:GetText() == "" then
        self.AcceptButton:Hide()
    else
        self.AcceptButton:Show()
    end
end
function NewProfile_OnEditFocusLost(self)
    if self:GetText() == "" then
        self.AcceptButton:Hide()
    end
end
function NewProfile_OnAcceptClick(self)
    local editBox = self:GetParent()
    local profileName = editBox:GetText()

    if Addon.P.profilesList == nil then
        Addon.P.profilesList = {}
    end
    if not Addon.P.profilesList[profileName] then
        HUIProfilesMixin:CreateProfile(profileName)
        HUIProfilesMixin:SetProfile(profileName, true)
        Addon:RefreshPresetsPreview()
        editBox:SetText("")
        editBox:ClearFocus()
    else
        Addon.Print("Profile name already exists")
    end
end
function HUIProfilesMixin:Init()
    if not HUIProfilesFrame then
        local profilesFrame = CreateFrame("Frame", "HUIProfilesFrame", UIParent, "HUIProfilesTemplate")
        profilesFrame:SetParent(UIParent)
        profilesFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        profilesFrame:SetMovable(true)
        profilesFrame:EnableMouse(true)
        profilesFrame:EnableMouseWheel(true)
        profilesFrame:RegisterForDrag("LeftButton")
        profilesFrame:SetScript("OnDragStart", function(self, button)
            self:StartMoving()
        end)
        profilesFrame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
        end)
        profilesFrame:SetUserPlaced(true)

        profilesFrame.Content.Header.HeaderText:SetText(L.ProfilesHeaderText)
        profilesFrame.Content.CopyProfileFrame.CopyText:SetText(L.ProfilesCopyText)
        profilesFrame.Content.DeleteProfileFrame.DeleteText:SetText(L.ProfilesDeleteText)
        profilesFrame.Content.ImportExportFrame.ImportExportText:SetText(L.ProfilesImportText)

        profilesFrame.Content.Header.CurrentProfile:SetText(self:GetPlayerProfile())
        

        local function SelectProfileSetup()
            local frame = profilesFrame.Content.NewProfileFrame.ProfileSelect
            local IsSelected = function(id)
                return id == HUIProfilesMixin:GetPlayerProfile()
            end

            local OnSelect = function(id)
                HUIProfilesMixin:SetProfile(id, true)
                profilesFrame.Content.Header.CurrentProfile:SetText(id)
            end

            local menuGenerator = function(_, rootDescription)
                rootDescription:CreateTitle("Select Profile")
                for index, profileName in ipairs(Addon.P.profilesOrder) do
                    local categoryID = profileName
                    local categoryName = profileName
                    rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
                end
            end
            frame.Dropdown:SetupMenu(menuGenerator)
        end

        local function CopyProfileSetup()
            local frame = profilesFrame.Content.CopyProfileFrame

            local menuGenerator = function(_, rootDescription)
                rootDescription:CreateTitle("Copy Profile")
                local currProfile = HUIProfilesMixin:GetPlayerProfile()

                for index, profileName in ipairs(Addon.P.profilesOrder) do
                    if profileName ~= currProfile then
                        rootDescription:CreateButton(profileName, function()
                            HUIProfilesMixin:CopyProfile(profileName, currProfile)
                            HUIProfilesMixin:SetProfile(currProfile, true)
                        end)
                    end
                end
            end
            frame.Dropdown:SetupMenu(menuGenerator)
        end
        local function DeleteProfileSetup()
            local frame = profilesFrame.Content.DeleteProfileFrame

            local menuGenerator = function(_, rootDescription)
                rootDescription:CreateTitle("Delete Profile")
                local currProfile = HUIProfilesMixin:GetPlayerProfile()

                for index, profileName in ipairs(Addon.P.profilesOrder) do
                    if profileName ~= currProfile and profileName ~= "Default" and not DefaultProfiles[profileName]  then
                        rootDescription:CreateButton(profileName, function()
                            HUIProfilesMixin:DeleteProfile(profileName)
                            Addon:RefreshPresetsPreview()
                        end)
                    end
                end
            end
            frame.Dropdown:SetupMenu(menuGenerator)
        end
        local function SetupSpecProfiles()
            local playerID = Addon:GetPlayerID()
            local frame = profilesFrame.Content.SpecProfilesFrame
            local checkBox = frame.EnableSpecProfiles

            local numSpec = GetNumSpecs()

            if numSpec == 0 then
                frame:Hide()
                local copyFrame = profilesFrame.Content.CopyProfileFrame
                copyFrame:ClearAllPoints()
                copyFrame:SetPoint("TOPLEFT", profilesFrame.Content.NewProfileFrame, "BOTTOMLEFT", 0, -10)
                return
            end

            if Addon.P.mapping[playerID].specEnabled then
                checkBox:SetChecked(true)
            else
                checkBox:SetChecked(false)
            end

            checkBox:SetScript("OnClick", function(self)
                for i=1, numSpec do
                    if self:GetChecked() then
                        frame["SpecDropdown"..i]:Enable()
                    else
                        frame["SpecDropdown"..i]:Disable()
                    end
                end
                Addon.P.mapping[playerID].specEnabled = self:GetChecked()
            end)

            checkBox.Text:SetText("Enable Spec Profiles")
            checkBox.Text:SetFontObject("GameFontNormal")

            for i=1, numSpec do
                local dropDown = frame["SpecDropdown"..i]
                dropDown:Show()
                local specID, specName, _, specIcon = GetSpecInfo(i)
                local currentSpec = GetActiveSpec()

                if specName then
                    if currentSpec == i then
                        dropDown.Label:SetText(specName .. " - |cff0bbe76Active|r")
                    else
                        dropDown.Label:SetText(specName)
                    end
                end
                if not checkBox:GetChecked() then
                    dropDown:Disable()
                end
                
                local IsSelected = function(id)
                    return id == Addon.P.mapping[playerID].specProfiles[i]
                end

                local OnSelect = function(id)                    
                    if currentSpec == i then
                        HUIProfilesMixin:SetProfile(id, true)
                        profilesFrame.Content.Header.CurrentProfile:SetText(id)
                    else
                        local playerID = Addon:GetPlayerID()
                        Addon.P.mapping[playerID].specProfiles[i] = id
                    end
                end

                local menuGenerator = function(_, rootDescription)
                    rootDescription:CreateTitle("Select Spec Profile")
                    local currProfile = HUIProfilesMixin:GetPlayerProfile()

                    for index, profileName in ipairs(Addon.P.profilesOrder) do
                        local categoryID = profileName
                        local categoryName = profileName
                        rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
                    end

                end

                dropDown:SetupMenu(menuGenerator)
            end
        end

        SelectProfileSetup()
        CopyProfileSetup()
        DeleteProfileSetup()
        SetupSpecProfiles()
    else
        HUIProfilesFrame:Show()
    end
    
end

function Addon:GetPlayerID()
    local name, server = UnitFullName("player")
    server = server or GetRealmName()
    if not server or server == "" then
        return name
    end
    return name.."-"..server
end

function HUIProfilesMixin:SetProfile(profileName, reload, config)
    local playerID = Addon:GetPlayerID()

    local currentProfile = profileName
    local profileData = Addon.P.profilesList[currentProfile]
    if not profileData then
        return
    end

    HUIProfilesMixin:CheckProfile2420(currentProfile)
    
    if profileData.FontHotKeyScale and profileData.FontHotKeyScale < 1.0 then
        profileData.FontHotKeyScale = 1.0
    end
    if profileData.FontStacksScale and profileData.FontStacksScale < 1.0 then
        profileData.FontStacksScale = 1.0
    end

    wipe(Addon.C)

    Addon.C["GlobalSettings"] = {}
    for key, defaultValue in pairs(Addon.Defaults) do
        if profileData["GlobalSettings"] and profileData["GlobalSettings"][key] ~= nil then
            if key == "EdgeSize" then

                --todo remove this workaround after some time
                if profileData["GlobalSettings"][key] > 2 then
                    Addon.Print("EdgeSize in GlobalSettings set to 2" )
                    profileData["GlobalSettings"][key] = 2
                end
            end
            Addon.C["GlobalSettings"][key] = profileData["GlobalSettings"][key]
        else
            Addon.C["GlobalSettings"][key] = type(defaultValue) == "table" and CopyTable(defaultValue) or defaultValue
        end
    end

    for catName, catData in pairs(profileData) do
        if catName ~= "GlobalSettings" then
            Addon.C[catName] = Addon.C[catName] or {}
            
            local targetCat = Addon.C[catName]

            for key, value in pairs(catData) do
                if key == "EdgeSize" then
                    if value > 2 then
                        Addon.Print("EdgeSize in", catName, value, " set to 2" )
                        profileData[catName][key] = 2
                    end
                end
                Addon.C[catName][key] = value
            end
        end
    end

    local activeSpec = GetActiveSpec()

    Addon.P.mapping[playerID].globalProfile = currentProfile
    if activeSpec > 0 then
        Addon.P.mapping[playerID].specProfiles[activeSpec] = currentProfile
    end

    if reload then
        EventRegistry:TriggerEvent("CDMCustomItemList.ProfileChanged")
        Addon:RefreshAll()
        Addon:RefreshProfileUI(currentProfile)
        if HUI_BarsListMixin then
            HUI_BarsListMixin:OnProfileChanged()
        end
    end
end

function Addon:RefreshProfileUI(profileName)
    if HUIDropdownMixin and HUIDropdownMixin.RefreshPresetButtons then
        HUIDropdownMixin:RefreshPresetButtons(profileName)
    end

    if not HUIProfilesFrame then
        return
    end

    local content = HUIProfilesFrame.Content
    content.Header.CurrentProfile:SetText(profileName)

    if not HUIProfilesFrame:IsVisible() then
        return
    end

    local selectDropdown = content.NewProfileFrame.ProfileSelect.Dropdown
    if selectDropdown then
        selectDropdown:Update()
    end

    for i = 1, GetNumSpecs() do
        local dropDown = content.SpecProfilesFrame["SpecDropdown"..i]
        if dropDown then
            dropDown:Update()
        end
    end
end

function HUIProfilesMixin:InstallDefaultPresets()
    for profileName, profileString in pairs(DefaultProfiles) do
        if not Addon.P.profilesList[profileName] then
            HUIImportDialogMixin:AcceptImport(_, DefaultProfiles[profileName], profileName)
        end
    end
end

function HUIProfilesMixin:ResetProfile()
    local profileName = self:GetPlayerProfile()
    if DefaultProfiles[profileName] then
        self:DeleteProfile(profileName)
        HUIImportDialogMixin:AcceptImport(_, DefaultProfiles[profileName], profileName, true)
    else
        wipe(Addon.P.profilesList[profileName])
        self:SetProfile(profileName, true)
    end
end

function HUIProfilesMixin:CreateProfile(profileName)
    Addon.P.profilesList[profileName] = { ["GlobalSettings"] = {} }

    self:AddProfileOrder(profileName)
end

function HUIProfilesMixin:ResetCatOptions(catName)
    local profileName = self:GetPlayerProfile()
    if Addon.P.profilesList[profileName][catName] then
        Addon.P.profilesList[profileName][catName] = nil
        self:SetProfile(profileName, true)
    end
end

function HUIProfilesMixin:DeleteProfile(profileName)
    if Addon.P.profilesList[profileName] ~= nil then
        Addon.P.profilesList[profileName] = nil
        self:RemoveProfileOrder(profileName)
        return true
    end
    return false
end

function HUIProfilesMixin:CopyProfileCategory(fromCatName, toCatName, reload)
    local profileName = self:GetPlayerProfile()
    if Addon.P.profilesList[profileName][toCatName] == nil then
        Addon.P.profilesList[profileName][toCatName] = {}
    end
    wipe(Addon.P.profilesList[profileName][toCatName])
    Addon.P.profilesList[profileName][toCatName] = CopyTable(Addon.P.profilesList[profileName][fromCatName])
    if reload then
        self:SetProfile(profileName, true)
    end
end
function HUIProfilesMixin:CopyProfile(fromProfileName, toProfileName)
    if Addon.P.profilesList[fromProfileName] ~= nil then
        wipe(Addon.P.profilesList[toProfileName])
        for key, value in pairs(Addon.P.profilesList[fromProfileName]) do
            Addon.P.profilesList[toProfileName][key] = type(value) == "table" and CopyTable(value) or value
        end
    end
end

function HUIProfilesMixin:NeedMigrateProfile()
    local playerID = Addon:GetPlayerID()

    local migrate = false
    local tmp = {}
    for key, defaulValue in pairs(Addon.Defaults) do
        if HUIDB[key] ~= nil then
            migrate = true
            tmp[key] = type(HUIDB[key]) == "table" and CopyTable(HUIDB[key]) or HUIDB[key]
            HUIDB[key] = nil
        end
    end
    if migrate then
        return true, tmp
    end
    return false
end

function HUIProfilesMixin:CheckProfiles15()
    local anyMigrated = false
    for profileName, profileData in pairs(Addon.P.profilesList) do
        local needMigrate = self:NeedMigrateProfile15(profileName)
        if needMigrate then
            anyMigrated = true
            Addon.Print("Profile "..profileName.." need migrate to v2.0")
            self:MigrateProfile15(profileName)
        else
            --Addon.Print(profileName.." profile ready for v2.0")
        end
        self:CheckProfilesOrer(profileName)
    end
    if anyMigrated then
        table.sort(Addon.P.profilesOrder)
    end
end

function HUIProfilesMixin:CheckProfiles247()
    local playerID = Addon:GetPlayerID()
    local numSpec = GetNumSpecs()
    local mapping = Addon.P.mapping
    if mapping and type(mapping[playerID]) == "string" then
        Addon.Print("Character "..playerID.." need migrate to v2.4.7")
        local currentProfile = mapping[playerID]
        mapping[playerID] = {
            globalProfile = currentProfile,
            specEnabled = false,
            specProfiles = {},
        }
        for i=1, numSpec do
            mapping[playerID].specProfiles[i] = currentProfile
        end
        Addon.Print("Character "..playerID.." migrated to v2.4.7")
    end
end
function HUIProfilesMixin:CheckProfile2420(profileName) -- convert fakeAuras[id] = duration to fakeAuras[id] = {duration, type}
    if Addon.P.profilesList[profileName] and Addon.P.profilesList[profileName]["CDMCustomFrames"] then
        local customFrames = Addon.P.profilesList[profileName]["CDMCustomFrames"]
        for i, customFrame in ipairs(customFrames) do
            local fakeAuras = customFrame["fakeAuras"]
            local numFakeAuras = 0
            if fakeAuras then
                for id, duration in pairs(fakeAuras) do
                    if type(duration) == "number" then
                        fakeAuras[id] = {
                            duration = duration,
                            type = 1,
                        }
                        numFakeAuras = numFakeAuras + 1
                    end
                end
            end
        end
    end
end

function HUIProfilesMixin:NeedMigrateProfile15(profileName)
    return not Addon.P.profilesList[profileName]["GlobalSettings"]
end

function HUIProfilesMixin:MigrateProfile15(profileName)
    Addon.Print("Start migrating profie "..profileName.." to v2.0")
    if not Addon.P.profilesList[profileName]["GlobalSettings"] then
        Addon.P.profilesList[profileName]["GlobalSettings"] = {}
    end

    for key, value in pairs(Addon.P.profilesList[profileName]) do
        if key ~= "GlobalSettings" then
            Addon.P.profilesList[profileName]["GlobalSettings"][key] = value
            Addon.P.profilesList[profileName][key] = nil
        end
    end
    Addon.Print(profileName.." migrated to v2.0")
end

function HUIProfilesMixin:CheckProfilesOrer(profileName)
    if Addon.P.profilesOrder == nil then
        Addon.P.profilesOrder = {}
    end

    if Addon.P.profilesList[profileName] then
        tInsertUnique(Addon.P.profilesOrder, profileName)
    else
        tDeleteItem(Addon.P.profilesOrder, profileName)
    end
end

function HUIProfilesMixin:AddProfileOrder(profileName)
    table.insert(Addon.P.profilesOrder, profileName)
end
function HUIProfilesMixin:RemoveProfileOrder(profileName)
    tDeleteItem(Addon.P.profilesOrder, profileName)
end
function HUIProfilesMixin:GetProfileOrder(profileName)
    return tIndexOf(Addon.P.profilesOrder, profileName)
end

function HUIProfilesMixin:GetPlayerProfile()
    local playerID = Addon:GetPlayerID()
    if Addon.P.mapping == nil then
        Addon.P.mapping = {}
    end
    if Addon.P.profilesOrder == nil then
        Addon.P.profilesOrder = {}
    end
    if Addon.P.mapping[playerID] == nil then
        Addon.P.mapping[playerID] = {
            globalProfile = "Default",
            specEnabled = false,
            specProfiles = {},
        }
        local numSpec = GetNumSpecs()
        for i=1, numSpec do
            Addon.P.mapping[playerID].specProfiles[i] = "Default"
        end
        --Addon.P.mapping[playerID] = "Default"
    end
    if Addon.P.profilesList == nil then
        Addon.P.profilesList = {}
    end
    if Addon.P.profilesList["Default"] == nil then
        Addon.P.profilesList["Default"] = { ["GlobalSettings"] = {} }
        self:AddProfileOrder("Default")
    end

    local specProfileEnabled = Addon.P.mapping[playerID].specEnabled
    local activeSpec = GetActiveSpec()
    if GetNumSpecs() == 0 then
        specProfileEnabled = false
    end
    local mappedProfile = specProfileEnabled and activeSpec > 0 and Addon.P.mapping[playerID].specProfiles[activeSpec] or Addon.P.mapping[playerID].globalProfile
    if mappedProfile ~= "Default" then
        if Addon.P.profilesList[mappedProfile] == nil then
            Addon.P.mapping[playerID].globalProfile = "Default"
            if activeSpec > 0 then
                Addon.P.mapping[playerID].specProfiles[activeSpec] = "Default"
            end
        end
    end
    
    if specProfileEnabled and activeSpec > 0 then
        return Addon.P.mapping[playerID].specProfiles[activeSpec] or Addon.P.mapping[playerID].globalProfile
    end
    return Addon.P.mapping[playerID].globalProfile
end

function Addon.CompressData(data)
    local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForPrint(compressed)
    return encoded
end

function Addon.DecompressData(data)
    local decoded = LibDeflate:DecodeForPrint(data)
    if not decoded then
        Addon.Print("Cant decode string")
    end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then
        Addon.Print("Cant decompress string")
    end
    local success, deserialized = LibSerialize:Deserialize(decompressed)

    if success then
        return deserialized
    end
    return Addon.Print("Cant deserialize string")
end

function HUIProfilesMixin:SelfTest()
    local profileName = self:GetPlayerProfile()
    local profile = Addon.P.profilesList[profileName]
    local exportTbl = CopyTable(profile)
    local encoded = Addon.CompressData(exportTbl)
    local decoded = Addon.DecompressData(encoded)
    
    if decoded then
        Addon.Print("SELF TEST GOOD")
    else
        Addon.Print("SELF TEST BAD")
    end
end

function HUIProfilesMixin:ExportProfile()
    local profileName = self:GetPlayerProfile()
    if Addon.P.profilesList[profileName] then
        local exportTbl = CopyTable(Addon.P.profilesList[profileName])
        local payload = exportTbl
        local exportString = Addon.CompressData(payload)

        if not HUIExportProfile then
            local ExportProfile = CreateFrame("Frame", "HUIExportProfile", HUIProfilesFrame, "HUIExportDialog")
            ExportProfile:SetParent(HUIProfilesFrame)
            ExportProfile:SetPoint("CENTER", HUIProfilesFrame, "CENTER", 0, 0)
            ExportProfile.ExportControl.ExportContainer.EditBox:SetText(exportString)
            ExportProfile.ExportControl.ExportContainer.EditBox:HighlightText()
            ExportProfile.ExportControl.ExportContainer.EditBox:SetAutoFocus(true)
            ExportProfile:Show()
        else
            HUIExportProfile.ExportControl.ExportContainer.EditBox:SetText(exportString)
            HUIExportProfile.ExportControl.ExportContainer.EditBox:HighlightText()
            HUIExportProfile.ExportControl.ExportContainer.EditBox:SetAutoFocus(true)
            HUIExportProfile:Show()
        end
    end
end

function HUIImportDialogMixin:HasDefaultProfiles()
    if not Addon.P.profilesList then return false end
    
    local i = 0
    for profileName, data in pairs(DefaultProfiles) do
        i = i + 1
        if Addon.P.profilesList[profileName] then
            i = i - 1
        end
    end
    return i == 0
end

function HUIImportDialogMixin:AcceptImport(_, profileString, profileName, shouldSet, rewrite)
    if not profileString then
        profileString = HUIImportProfile.ImportControl.InputContainer.EditBox:GetText()
    end
    if not profileName then
        profileName = HUIImportProfile.NameControl.EditBox:GetText()
    end
    if profileString ~= "" and profileName ~= "" then
        if Addon.P.profilesList[profileName] ~= nil then
            if not rewrite then
                Addon.Print("Profile with this name already exists")
                return false
            else
                HUIProfilesMixin:DeleteProfile(profileName)
            end
        end
        if Addon.P.profilesList[profileName] == nil then            
            local profileTable = Addon.DecompressData(profileString)
            if profileTable then
                if type(profileTable.data) == "table" then
                    profileTable = profileTable.data
                end
                Addon.RemapMedia(profileTable)
                Addon.P.profilesList[profileName] = CopyTable(profileTable)
                if HUIImportProfile and HUIImportProfile:IsVisible() then
                    HUIImportProfile:Hide()
                end

                HUIProfilesMixin:AddProfileOrder(profileName)

                if shouldSet then
                    HUIProfilesMixin:SetProfile(profileName, true)
                end
                Addon:RefreshPresetsPreview()
                return true
            end
        end
    end
end

function HUIProfilesMixin:ImportProfile()
    if not HUIImportProfile then
        local ImportProfile = CreateFrame("Frame", "HUIImportProfile", HUIProfilesFrame, "HUIImportDialog")
        ImportProfile:SetParent(HUIProfilesFrame)
        ImportProfile:SetPoint("CENTER", HUIProfilesFrame, "CENTER", 0, 0)
    else
        HUIImportProfile:Show()
    end
end

function HUIProfilesMixin:GetProfiles()
    local profileTbl = {}
    for index, profileName in ipairs(Addon.P.profilesOrder) do
        if Addon.P.profilesList[profileName] then
            table.insert(profileTbl, profileName)
        end
    end

    return profileTbl
end

function HUI_ImportProfile(profileName, profileString, shouldSet, rewrite)
    return HUIImportDialogMixin:AcceptImport(_, profileString, profileName, shouldSet, rewrite)
end

function HUI_GetProfiles()
    return HUIProfilesMixin:GetProfiles()
end

function ABE_ImportProfile(profileName, profileString, shouldSet, rewrite)
    return HUI_ImportProfile(profileName, profileString, shouldSet, rewrite)
end

function ABE_GetProfiles()
    return HUI_GetProfiles()
end

function Addon:GetCurrentProfileTable()
    local profileName = HUIProfilesMixin:GetPlayerProfile()
    local profileTable = Addon.P.profilesList[profileName]
    return profileTable
end

function HUIProfilesMixin:OnSpecChanged(profile)
    local playerID = Addon:GetPlayerID()
    local currentSpec = GetActiveSpec()
    local isSpecEnabled = Addon.P.mapping[playerID].specEnabled
    
    if not isSpecEnabled or currentSpec == 0 then return end

    local specProfile = Addon.P.mapping[playerID].specProfiles[currentSpec]

    if specProfile ~= profile then
        HUIProfilesMixin:SetProfile(specProfile, false)
        Addon:RefreshProfileUI(specProfile)
        EventRegistry:TriggerEvent("CDMCustomItemList.ProfileChanged")
        if HUI_BarsListMixin then
            HUI_BarsListMixin:OnProfileChanged()
        end
        C_Timer.After(1.0, function()
            if Addon.RefreshButtons then
                Addon:RefreshButtons()
            end
            if HUI_CastingBarMixin then
                HUI_CastingBarMixin.SetLook(PlayerCastingBarFrame)
            end
        end)
    end

end
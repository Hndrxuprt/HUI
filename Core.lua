local AddonName, Addon = ...

_G.HUI = Addon

Addon.Name = AddonName

function Addon:GetGameFamily()
    local ok, _, _, _, interface = pcall(GetBuildInfo)
    if not ok or type(interface) ~= "number" or (issecretvalue and issecretvalue(interface)) then
        return nil
    end
    return (interface >= 16000 and interface < 20000) and "forever" or "retail"
end

Addon.Modules = {}
Addon.ModuleList = {
    "ActionBars",
    "CooldownManagerView",
    "CooldownManagerCustom",
    "CastingBar",
}

function Addon:RegisterModule(name, module)
    if self.Modules[name] then
        return self.Modules[name]
    end

    module.Name = name
    module.enabled = self:IsModuleEnabled(name)

    module.RegisterEvent = self.ModuleRegisterEvent
    module.RegisterUnitEvent = self.ModuleRegisterUnitEvent
    module.UnregisterEvent = self.ModuleUnregisterEvent
    module.UnregisterAllEvents = self.ModuleUnregisterAllEvents

    self.Modules[name] = module

    if module.OnInitialize then
        module:OnInitialize()
    end

    return module
end

function Addon:GetModule(name)
    return self.Modules[name]
end

function Addon:IsModuleEnabled(name)
    local addonName = "HUI_" .. name
    if C_AddOns.DoesAddOnExist(addonName) then
        return C_AddOns.GetAddOnEnableState(addonName) > Enum.AddOnEnableState.None
    end

    local db = self.db
    if db and db.EnabledModules and db.EnabledModules[name] ~= nil then
        return db.EnabledModules[name]
    end
    return true
end

function Addon:IsModuleLoaded(name)
    return C_AddOns.IsAddOnLoaded("HUI_" .. name)
end

function Addon:SetModuleEnabled(name, enabled)
    local db = self.db
    if not db then return end

    db.EnabledModules = db.EnabledModules or {}
    db.EnabledModules[name] = enabled and true or false

    local addonName = "HUI_" .. name
    if enabled then
        C_AddOns.EnableAddOn(addonName)
    else
        C_AddOns.DisableAddOn(addonName)
    end

    if not enabled then
        self:UnregisterAllEvents(name)
    end

    local module = self.Modules[name]
    if module then
        module.enabled = enabled and true or false
        if module.enabled then
            if module.OnEnable then module:OnEnable() end
        else
            if module.OnDisable then module:OnDisable() end
        end
    end
end

function Addon:LoadModule(name)
    local addonName = "HUI_" .. name
    return C_AddOns.LoadAddOn(addonName)
end

function Addon:LoadModules()
    for _, name in ipairs(self.ModuleList) do
        if self:IsModuleEnabled(name) then
            self:LoadModule(name)
        end
    end
end

function Addon.ModuleRegisterEvent(self, event, func)
    if self.enabled then
        Addon:RegisterEvent(event, func, self.Name)
    end
end

function Addon.ModuleRegisterUnitEvent(self, event, unit, func)
    if self.enabled then
        Addon:RegisterUnitEvent(event, unit, func, self.Name)
    end
end

function Addon.ModuleUnregisterEvent(self, event)
    Addon:UnregisterEvent(event, self.Name)
end

function Addon.ModuleUnregisterAllEvents(self)
    Addon:UnregisterAllEvents(self.Name)
end

function Addon:ApplyProfile()
    HUIDB = HUIDB or {}
    HUIDB.Profiles = HUIDB.Profiles or {}
    self.P = HUIDB.Profiles

    if next(HUIDB) then
        local migrate, data = HUIProfilesMixin:NeedMigrateProfile()
        if migrate then
            local playerID = self:GetPlayerID()
            HUIDB.Profiles.mapping = HUIDB.Profiles.mapping or {}
            HUIDB.Profiles.mapping[playerID] = "Default"
            HUIDB.Profiles.profilesList = HUIDB.Profiles.profilesList or {}
            HUIDB.Profiles.profilesList["Default"] = CopyTable(data)
        end
    end

    HUIProfilesMixin:CheckProfiles247()

    local currentProfile = HUIProfilesMixin:GetPlayerProfile()

    if not HUIImportDialogMixin:HasDefaultProfiles() then
        HUIProfilesMixin:InstallDefaultPresets()
    end

    HUIProfilesMixin:CheckProfiles15()

    HUIProfilesMixin:SetProfile(currentProfile)
end

function Addon:OnAddonLoaded()
    self:InitDB()
    self:InitPP()
    self:InitMinimapButton()
    self:LoadModules()
end

function Addon:OnLogin()
    self:TryImport()
    self:ApplyProfile()

    self.Fonts = self:GetFontsList()
    if not next(self.Templates.StatusBarTextures) then
        self.Templates.StatusBarTextures = self:GetStatusBarTextures()
    end

    self.PP.SetEnabled(self:GetValue("UsePixelPerfect"))

    self:ApplyProfiler()

    self:Welcome()
end

local bootstrap = CreateFrame("Frame")
bootstrap:RegisterEvent("ADDON_LOADED")
bootstrap:RegisterEvent("PLAYER_LOGIN")
bootstrap:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        if ... == AddonName then
            Addon:OnAddonLoaded()
        end
    elseif event == "PLAYER_LOGIN" then
        Addon:OnLogin()
    end
end)

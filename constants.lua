local AddonName, Addon = ...

local L = Addon.L

Addon.command = "HUI"
Addon.shortCommand = "hui"

Addon.BarsToHide = {
    --"BagsBar",
    --"MicroMenu",
    --"StanceBar",
}

Addon.C = {
    ["GlobalSettings"] = {}
}

--Shamelessly stolen from Platynator
Addon.InterruptMap = {
    ["DEATHKNIGHT"] = {47528, 47476},
    ["WARRIOR"] = {6552},
    ["WARLOCK"] = {19647},
    ["SHAMAN"] = {57994},
    ["ROGUE"] = {1766},
    ["PRIEST"] = {15487},
    ["PALADIN"] = {96231, 31935},
    ["MONK"] = {116705},
    ["MAGE"] = {2139},
    ["HUNTER"] = {187707, 147362},
    ["EVOKER"] = {351338},
    ["DRUID"] = {38675, 78675, 106839},
    ["DEMONHUNTER"] = {183752},
}
Addon.CombatResIDs = {
    [20707] = true,

}
Addon.RacialSpellsMap = {
    [1] = {59752}, --Human
    [2] = {20572, 33697, 33702}, --Orc
    [3] = {20594}, --Dwarf
    [4] = {58984}, --Elf
    [5] = {7744}, --Undead
    [6] = {20549}, --Tauren
    [7] = {20589}, --Gnome
    [8] = {26297}, --Troll
    [9] = {69070, 69041}, --Goblin
    [10] = {50613, 202719, 80483, 28730, 129597, 155145, 232633, 25046, 69179}, --Blood Elf
    [11] = {28880, 59545, 59543, 59548, 121093, 416250, 59542, 59544, 370626, 59547}, --Draenei
    [22] = {68992}, --Worgen
    [24] = {107079}, --Pandaren
    [25] = {107079}, --Pandaren
    [26] = {107079}, --Pandaren
    [27] = {260364}, --Nightborne
    [28] = {255654}, --H. Tauren
    [29] = {256948}, --Void Elf
    [30] = {255647}, --Lightforged Draenei
    [31] = {291944}, --Zandalari Troll
    [32] = {287712}, --Kul Tiran
    [34] = {265221}, --Dark Iron Dwarf
    [35] = {312411}, --Vulpera
    [36] = {274738}, --Mag'har Orc
    [37] = {312924}, --Mechagnome
    [52] = {357214}, --Dracthyr
    [70] = {357214}, --Dracthyr
    [84] = {436344}, --Earthen
    [85] = {436344}, --Earthen
    [86] = {1237885}, --Haranir
    [91] = {1237885}, --Haranir
}
Addon.RacialsSort = {1,2,3,4,5,6,7,8,9,10,11,22,24,27,28,29,30,31,32,34,35,36,37,52,84,86}
Addon.AttachPoints = {
    [1] = "TOPLEFT",
    [2] = "TOP",
    [3] = "TOPRIGHT",
    [4] = "BOTTOMLEFT",
    [5] = "BOTTOM",
    [6] = "BOTTOMRIGHT",
    [7] = "LEFT",
    [8] = "RIGHT",
    [9] = "CENTER",
}
Addon.FontOutlines = {
    [1] = "NONE",
    [2] = "OUTLINE",
    [3] = "OUTLINE, SLUG",
}
Addon.BarsVerticalGrow = {
    [1] = L.VerticalGrowthUP,
    [2] = L.VerticalGrowthDOWN,
}
Addon.BarsHorizontalGrow = {
    [1] = L.HorizontalGrowthRIGHT,
    [2] = L.HorizontalGrowthLEFT,
}
Addon.GridDirection = {
    [1] = L.DirectionHORIZONTAL,
    [2] = L.DirectionVERTICAL,
}
Addon.GridLayoutType = {
    [1] = L.GridCentered,
    [2] = L.GridCompact,
    [3] = L.GridFixed,
}
Addon.CastingBarIconPosition = {
    [1] = L.None,
    [2] = L.Left,
    [3] = L.Right,
    [4] = L.LeftAndRight,
}
Addon.CastingBarCastTimeFormat = {
    [1] = L.CastTimeCurrent,
    [2] = L.CastTimeMax,
    [3] = L.CastTimeCurrentAndMax,
    [4] = L.CastTimeRemaining,
}
Addon.GridLayoutHideActive = {
    [1] = L.AlwaysShow,
    [2] = L.ShowOnAura,
    [3] = L.ShowOnAuraAndCD,
    --[4] = "Show when NOT on CD",
    --[5] = "Show Only CD",
}
Addon.BarTextJustifyH = {
    [1] = "LEFT",
    [2] = "CENTER",
    [3] = "RIGHT",
}
Addon.BarTextJustifyV = {
    [1] = "TOP",
    [2] = "MIDDLE",
    [3] = "BOTTOM",
}
Addon.FrameStratas = {
    [1] = "BACKGROUND",
    [2] = "LOW",
    [3] = "MEDIUM",
    [4] = "HIGH",
    [5] = "DIALOG",
    [6] = "FULLSCREEN",
    [7] = "FULLSCREEN_DIALOG",
    [8] = "TOOLTIP",
}
Addon.CustomBarType = {
    [1] = "CD Only",
    [2] = "Aura Only",
    [3] = "Aura than CD",
}
Addon.FakeAuraType = {
    [1] = L.FakeAuraTypeNone,
    [2] = L.FakeAuraTypeAdd,
    [3] = L.FakeAuraTypeReset,
}
Addon.CooldownFormatType = {
    [1] = L.CDFormatFloor,
    [2] = L.CDFormatCeil,
}
Addon.CooldownTimerFormat = {
    [1] = L.CDFormatAuto,
    [2] = L.CDFormatMmSs,
    [3] = L.CDFormatMinutesSeconds,
    [4] = L.CDFormatSecondsOnly,
}
Addon.CustomBarDisplayTypes = {
    [1] = L.BarDisplayOnCD,
    [2] = L.BarDisplayOnAura,
    [3] = L.BarDisplayOnAuraAndCD,
}
Addon.AuraTimeFormat = {
    [1] = L.CastTimeRemaining,
    [2] = L.CastTimeMax,
    [3] = L.CastTimeRemainingAndMax,
}
Addon.AuraSoundTriggers = {
    [Enum.UnitAuraSoundTrigger.Added] = L.AuraSoundTriggerAdded,
    [Enum.UnitAuraSoundTrigger.ApplicationsIncreased] = L.AuraSoundTriggerApplicationsIncreased,
    [Enum.UnitAuraSoundTrigger.Removed] = L.AuraSoundTriggerRemoved,
}

do
    local cooldownColorCurve = C_CurveUtil.CreateColorCurve()
    cooldownColorCurve:SetType(Enum.LuaCurveType.Linear)
    cooldownColorCurve:AddPoint(0, CreateColor(1, 1, 1, 1))
    cooldownColorCurve:AddPoint(0.01, CreateColor(1, 0, 0, 1))
    cooldownColorCurve:AddPoint(5, CreateColor(1, 0, 0, 1))
    cooldownColorCurve:AddPoint(5.2, CreateColor(1, 1, 0, 1))
    cooldownColorCurve:AddPoint(10, CreateColor(1, 1, 0, 1))
    cooldownColorCurve:AddPoint(10.2, CreateColor(1, 1, 1, 1))

    local alphaCurve = C_CurveUtil.CreateCurve()
    alphaCurve:SetType(Enum.LuaCurveType.Step)
    alphaCurve:AddPoint(0, 0.0)
    alphaCurve:AddPoint(0.001, 1.0)

    local invertAlphaCurve = C_CurveUtil.CreateCurve()
    invertAlphaCurve:SetType(Enum.LuaCurveType.Step)
    invertAlphaCurve:AddPoint(0, 1.0)
    invertAlphaCurve:AddPoint(0.001, 0.0)

    local pandemicCurve = C_CurveUtil.CreateCurve()
    pandemicCurve:SetType(Enum.LuaCurveType.Step)
    pandemicCurve:AddPoint(0.0, 0.0)
    pandemicCurve:AddPoint(0.69, 0.0)
    pandemicCurve:AddPoint(0.7, 1.0)
    pandemicCurve:AddPoint(1.0, 1.0)

    local chargesColorCurve = C_CurveUtil.CreateColorCurve()
    chargesColorCurve:SetType(Enum.LuaCurveType.Step)
    chargesColorCurve:AddPoint(0, CreateColor(1, 1, 1, 1))
    chargesColorCurve:AddPoint(99, CreateColor(1, 1, 1, 1))
    chargesColorCurve:AddPoint(100, CreateColor(1, 0, 0, 1))

    Addon.chargesColorCurve = chargesColorCurve
    Addon.cooldownColorCurve = cooldownColorCurve
    Addon.alphaCurve = alphaCurve
    Addon.invertAlphaCurve = invertAlphaCurve
    Addon.pandemicCurve = pandemicCurve

    local defaultDurationFormatter = C_StringUtil.CreateSecondsFormatter()
    Addon.defaultDurationFormatter = defaultDurationFormatter

    defaultDurationFormatter:SetDefaultAbbreviation(Enum.SecondsFormatterAbbreviation.OneLetter)
    defaultDurationFormatter:SetStripIntervalWhitespace(Enum.SecondsFormatterIntervalWhitespace.Strip)
    defaultDurationFormatter:SetMillisecondsThreshold(5)

    local defaultCountFormatter = C_StringUtil.CreateNumericRuleFormatter()
    defaultCountFormatter:SetBreakpoints({
        {
            threshold = 0,
            min = 1,
            format = "%d"
        },
    })
    Addon.defaultCountFormatter = defaultCountFormatter

    local numbersDurationFormatter = C_StringUtil.CreateNumericRuleFormatter()
    numbersDurationFormatter:SetBreakpoints({
        {
            threshold = 0,
            format = "%.1f",
        },
        {
            threshold = 5,
            format = "%d",
            step = 1,
            rounding = 1,
        },
        {
            threshold = 60,
            format = "%d:%02d",
            components = {
                { div = 60 },
                { mod = 60 },
            },
            step = 1,
            rounding = 1,
        },
        {
            threshold = 3600,
            format = "%d:%02d:%02d",
            components = {
                { div = 3600 },
                { div = 60, mod = 60 },
                { mod = 60 },
            },
            step = 1,
            rounding = 1,
        },
    })
    Addon.numbersDurationFormatter = numbersDurationFormatter
end

Addon.Defaults = {
    UsePixelPerfect = false,

    CurrentLoopGlow = 1,
    DesaturateGlow = false,
    UseLoopGlowColor = false,
    LoopGlowColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    HideProc = false,
    CurrentProcGlow = 1,
    DesaturateProc = false,
    UseProcColor = false,
    ProcColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentAssistType = 3,
    DesaturateAssist = false,
    UseAssistGlowColor = false,
    AssistGlowColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    CurrentAssistAltType = 5,
    DesaturateAssistAlt = false,
    UseAssistAltColor = false,
    AssistAltColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    FadeBars = false,
    FadeBarsAlpha = 1,
    FadeInOnCombat = false,
    FadeInOnTarget = false,
    FadeInOnCasting = false,
    FadeInOnHover = false,
    RightClickPassThrough = false,

    ExtraZoneAbilityEnable = true,
    ExtraZoneAbilityArt = 2,

    CurrentNormalTexture = 1,
    DesaturateNormal = false,
    UseNormalTextureColor = false,
    NormalTextureColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentBackdropTexture = 1,
    DesaturateBackdrop = false,
    UseBackdropColor = false,
    BackdropColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    UseIconMaskScale = false,
    IconMaskScale = 1.0,
    CurrentIconMaskTexture = 1,
    UseIconScale = false,
    IconScale = 1.0,

    CurrentPushedTexture = 2,
    DesaturatePushed = true,
    UsePushedColor = true,
    PushedColor = "CLASS_COLOR",

    CurrentHighlightTexture = 2,
    DesaturateHighlight = true,
    UseHighlightColor = true,
    HighlightColor = "CLASS_COLOR",

    CurrentCheckedTexture = 2,
    DesaturateChecked = true,
    UseCheckedColor = true,
    CheckedColor = "CLASS_COLOR",

    UseOORColor = true,
    OORDesaturate = true,
    OORColor = { r=0.64, g=0.15, b=0.15, a=1.0 },

    UseOOMColor = true,
    OOMDesaturate = true,
    OOMColor = { r=0.5, g=0.5, b=0.5, a=1.0 },

    UseNoUseColor = true,
    NoUseDesaturate = true,
    NoUseColor = { r=0.6, g=0.6, b=0.6, a=1.0 },

    UseGCDColor = false,
    GCDColorDesaturate = false,
    GCDColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    UseCDColor = false,
    CDColorDesaturate = false,
    CDColor = { r=0.7, g=0.7, b=0.7, a=1.0 },

    UseNormalColor = false,
    NormalColorDesaturate = false,
    NormalColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    UseAuraColor = false,
    AuraColorDesaturate = false,
    AuraColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    HideBagsBar = false,
    HideMicroMenu = false,
    HideStanceBar = false,
    HideTalkingHead = false,
    HideInterrupt = true,
    HideCasting = true,
    HideReticle = true,

    FontHotKey = true,
    FontHotKeyScale = 1.0,
    FontStacks = true,
    FontStacksScale = 1.0,
    FontHideName = false,
    FontName = true,
    FontNameScale = 1.0,

    CurrentHotkeyFont = "Default",
    CurrentHotkeyOutline = 3,
    UseHotkeyShadow = false,
    HotkeyShadow = { r=0.0, g=0.0, b=0.0, a=1.0 },
    UseHotkeyShadowOffset = false,
    HotkeyShadowOffsetX = 0,
    HotkeyShadowOffsetY = 0,
    UseHotkeyFontSize = false,
    HotkeyFontSize = 11,
    UseHotkeyOffset = false,
    HotkeyOffsetX = -5,
    HotkeyOffsetY = -5,
    UseHotkeyColor = false,
    HotkeyColor = { r=0.6, g=0.6, b=0.6, a=1.0 },
    CurrentHotkeyPoint = 3,
    CurrentHotkeyRelativePoint = 3,

    CurrentStacksFont = "Default",
    CurrentStacksOutline = 3,
    UseStacksShadow = false,
    StacksShadow = { r=0.0, g=0.0, b=0.0, a=1.0 },
    UseStacksShadowOffset = false,
    StacksShadowOffsetX = 0,
    StacksShadowOffsetY = 0,
    UseStacksFontSize = false,
    StacksFontSize = 16,
    UseStacksOffset = false,
    StacksOffsetX = -5,
    StacksOffsetY = 5,
    UseStacksColor = false,
    StacksColor = { r=0.6, g=0.6, b=0.6, a=1.0 },
    CurrentStacksPoint = 6,
    CurrentStacksRelativePoint = 6,

    CurrentSwipeTexture = 1,
    UseSwipeSize = false,
    SwipeSize = 42,
    UseCooldownColor = false,
    CooldownColor = { r=0.0, g=0.0, b=0.0, a=0.65 },

    CurrentEdgeTexture = 1,
    UseEdgeSize = false,
    EdgeSize = 1,
    UseEdgeColor = false,
    EdgeColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    EdgeAlwaysShow = false,

    CurrentCooldownFont = "Default",
    UseCooldownFontSize = false,
    CooldownFontSize = 17,
    UseCooldownFontColor = false,
    CooldownFontColor = { r=1.0, g=1.0, b=1.0, a=1.0 },


    ModifyWAGlow = false,
    CurrentWAProcGlow = 8,
    WAProcColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    UseWAProcColor = false,
    DesaturateWAProc = false,

    CurrentWALoopGlow = 3,
    WALoopColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    UseWALoopColor = false,
    DesaturateWALoop = false,

    AddWAMask = false,

    UseBarPadding = false,
    CurrentBarPadding = 4,

    UseButtonSize = false,
    ButtonSizeX = 42,
    ButtonSizeY = 42,

    BarOrientation = 1,
    UseRowsNumber = false,
    RowsNumber = 1,

    UseColumnsNumber = false,
    ColumnsNumber = 12,

    UseButtonsNumber = false,
    ButtonsNumber = 12,

    CDMEnable = false,
    UseCDMIconPadding = false,
    CDMIconPadding = 2,

    CDMReverseSwipe = false,
    CDMAuraReverseSwipe = false,

    UseCDMBackdrop = false,
    CDMBackdropSize = 1,

    GridCentered = false,
    CDMRemoveIconMask = false,
    CDMRemovePandemic = false,

    UseCDMSwipeColor = false,
    CDMSwipeColor = { r=0.0, g=0.0, b=0.0, a=0.5 },

    UseCDMAuraSwipeColor = false,
    CDMAuraSwipeColor = { r=0.0, g=0.0, b=0.0, a=0.5 },

    UseCDMBackdropColor = false,
    CDMBackdropColor = { r=0.0, g=0.0, b=0.0, a=1.0 },
    UseCDMBackdropAuraColor = false,
    CDMBackdropAuraColor = { r=0.3, g=0.8, b=0.0, a=1.0 },
    UseCDMBackdropPandemicColor = false,
    CDMBackdropPandemicColor = { r=0.8, g=0.3, b=0.0, a=1.0 },

    CurrentCDMSwipeTexture = 1,
    
    UseCDMSwipeSize = false,
    CDMSwipeSize = 36,

    CurrentCDMCooldownFont = "Default",
    UseCooldownCDMFontSize = false,
    CooldownCDMFontSize = 17,
    UseCooldownCDMFontColor = false,
    CooldownCDMFontColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentCDMStacksFont = "Default",
    UseCDMStacksFontSize = false,
    CDMStacksFontSize = 17,
    UseCDMStacksFontColor = false,
    CDMStacksFontColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentCDMStatusBarTexture = "Blizzard BuffBar",
    UseCDMBarColor = false,
    CDMBarColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentCDMNameFont = "Default",
    UseNameCDMFontSize = false,
    NameCDMFontSize = 17,
    UseNameCDMFontColor = false,
    NameCDMFontColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentCDMBGTexture = "Blizzard BuffBar",
    UseCDMBarBGColor = true,
    CDMBarBGColor = { r=0.0, g=0.0, b=0.0, a=0.5 },

    CurrentBarGrow = 1,

    UseCDMBarIconSize = false,
    CDMBarIconSize = 30,

    UseCDMBarHeight = false,
    CDMBarHeight = 19,

    UseCDMStacksOffset = false,
    CDMStacksOffsetX = 0,
    CDMStacksOffsetY = 0,
    CDMCurrentStacksPoint = 6,
    CDMCurrentStacksRelativePoint = 6,

    CurrentCDMEdgeTexture = 1,
    UseCDMEdgeSize = false,
    CDMEdgeSize = 1,
    UseCDMEdgeColor = false,
    CDMEdgeColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    CDMEdgeAlwaysShow = false,

    CDMRemoveOORColor = false,
    CDMRemoveOOMColor = false,
    CDMRemoveNUColor = false,
    CDMRemoveDesaturation = false,

    CDMUseBarPipSize = false,
    CDMBarPipSizeX = 10,
    CDMBarPipSizeY = 40,

    CurrentCDMPipTexture = 1,

    UseCDMBarOffset = false,
    CDMBarOffset = 0,

    CDMUseItemSize = false,
    CDMItemSize = 40,

    CDMRemoveGCDSwipe = false,

    CDMRemoveAuraTypeBorder = false,

    CDMCustomPingEnabled = true,

    CDMCustomTrackTrink1 = false,
    CDMCustomTrackTrink2 = false,

    UseCDMCustomIconPadding = false,
    CDMCustomIconPadding = 2,

    CDMCustomCenteredLayout = false,

    CDMVerticalGrowth = 2,

    CDMHorizontalGrowth = 1,

    CDMCustomGridDirection = 1,

    UseCDMCustomStride = false,
    CDMCustomStride = 7,

    CDMCustomHideEmpty = false,

    UseCDMCustomItemSize = false,
    CDMCustomItemSize = 38,

    UseCDMCustomAlphaNoCD = false,
    CDMCustomAlphaNoCD = 1,

    CDMGridLayoutType = 3,

    CurrentHideWhenInactive = 1,

    CDMCustomFrameStrata = 3,

    UseCDMCustomFrameLevel = false,
    CDMCustomFrameLevel = 2,

    AlwaysShowStacks = false,

    ColorizedCooldownFont = false,

    ColorizedAuraFont = false,

    CastBarEnable = false,

    CurrentCastBarStatusBarTexture = "Blizzard BuffBar",
    CurrentCastBarBackgroundTexture = "Blizzard BuffBar",

    CurrentCastBarPipTexture = 1,

    UseCastBarPipSize = false,
    CastBarPipSizeX = 8,
    CastBarPipSizeY = 22,

    UseCastBarStandardColor = true,
    CastBarStandardColor = "CLASS_COLOR",
    
    UseCastBarImportantColor = true,
    CastBarImportantColor = { r=0.95, g=0.55, b=0.2, a=1.0 },

    UseCastBarChannelColor = true,
    CastBarChannelColor = "CLASS_COLOR",

    UseCastBarUninterruptableColor = true,
    CastBarUninterruptableColor = { r=0.5, g=0.5, b=0.5, a=1.0 },
    
    UseCastBarInterruptedColor = true,
    CastBarInterruptedColor = { r=1.0, g=0.2, b=0.2, a=1.0 },

    UseCastBarReadyColor = true,
    CastBarReadyColor = { r=0.2, g=0.98, b=0.2, a=1.0 },

    UseCastBarBackgroundColor = true,
    CastBarBackgroundColor = { r=0, g=0, b=0, a=0.6 },

    UseCastBarIconSize = true,
    CastBarIconSize = 20,

    CurrentCastBarIconPos = 2,

    CurrentCastBarIconPoint = 8,
    CurrentCastBarIconRelativePoint = 7,

    UseCastBarIconOffset = false,
    CastBarIconOffsetX = -2,
    CastBarIconOffsetY = 0,

    CastBarShowLatency = true,
    CurrentCastBarLatencyTexture = "Solid",
    UseCastBarLatencyColor = true,
    CastBarLatencyColor = { r=1.0, g=0.2, b=0.2, a=0.5 },

    CastBarShowSQW = true,
    CurrentCastBarSQWTexture = "Solid",
    UseCastBarSQWColor = true,
    CastBarSQWColor = { r=1.0, g=1.0, b=0.2, a=0.5 },

    CurrentCastBarCastNameFont = "Default",
    UseCastBarCastNameSize = false,
    CastBarCastNameSize = 16,

    UseCastBarCastNameColor = false,
    CastBarCastNameColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentCastBarCastNamePoint = 2,
    CurrentCastBarCastNameRelativePoint = 5,
    UseCastBarCastNameOffset = true,
    CastBarCastNameOffsetX = 0,
    CastBarCastNameOffsetY = 2,

    CurrentCastBarCastTimeFormat = 3,
    CurrentCastBarCastTimeFont = "Default",

    UseCastBarCastTimeSize = false,
    CastBarCastTimeSize = 16,

    UseCastBarCastTimeColor = false,
    CastBarCastTimeColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentCastBarCastTimePoint = 8,
    CurrentCastBarCastTimeRelativePoint = 8,

    UseCastBarCastTimeOffset = false,
    CastBarCastTimeOffsetX = 0,
    CastBarCastTimeOffsetY = 0,

    CastHideTextBorder = false,

    CastHideInterruptAnim = false,
    CastQuickFinish = false,

    UseCastBarsBackdrop = false,
    CastBarsBackdropSize = 1,

    UseCastBarsBackdropColor = false,
    CastBarsBackdropColor = { r=0.0, g=0.0, b=0.0, a=1.0 },

    CastBarsBackdropColorByType = false,

    CurrentCastBarPoint = 2,
    CurrentCastBarRelativePoint = 5,

    UseCastBarOffsetX = false,
    CastBarOffsetX = 0,
    UseCastBarOffsetY = false,
    CastBarOffsetY = 0,

    UseCastBarWidth = false,
    CastBarWidth = 208,
    UseCastBarHeight = false,
    CastBarHeight = 11,

    CastBarCastTargetEnable = false,
    CurrentCastBarCastTargetFont = "Default",
    UseCastBarCastTargetSize = false,
    CastBarCastTargetSize = 12,
    UseCastBarCastTargetColor = false,
    CastBarCastTargetColor = { r=1.0, g=1.0, b=1.0, a=1.0 },

    CurrentCastBarCastTargetPoint = 9,
    CurrentCastBarCastTargetRelativePoint = 9,
    UseCastBarCastTargetOffset = false,
    CastBarCastTargetOffsetX = 0,
    CastBarCastTargetOffsetY = 0,

    CurrentCastBarShieldIconTexture = 1,
    UseCastBarShieldIconSize = false,
    CastBarShieldIconSize = 10,
    CurrentCastBarShieldIconPoint = 8,
    CurrentCastBarShieldIconRelativePoint = 9,
    UseCastBarShieldIconOffset = false,
    CastBarShieldIconOffsetX = 0,
    CastBarShieldIconOffsetY = 0,

    CDMAuraRemoveSwipe = false,
    CDMAuraShowSwipe = true,
    CDMAuraShowTimer = true,
    CDMAuraShowStacks = true,
    CDMAuraShowEdge = true,

    CurrentCastBarCastNameJustifyH = 2,
    CurrentCastBarCastTimeJustifyH = 3,
    CurrentCastBarCastTargetJustifyH = 2,

    UseCooldownFontOffset = false,
    CooldownFontOffsetX = 0,
    CooldownFontOffsetY = 0,

    UseCooldownAuraColor = true,
    CooldownAuraColor = { r=1.0, g=0.95, b=0.57, a=0.7 },
    UseCDMAuraTimerColor = false,
    CDMAuraTimerColor = { r=1.0, g=0.95, b=0.57, a=1.0 },

    CurrentAttachPoint = 2,
    CurrentAttachRelativePoint = 2,
    UseAttachOffset = false,
    AttachOffsetX = 0,
    AttachOffsetY = 0,
    CDMEnableAttach = false,
    CurrentAttachFrame = "",
    ShowCountdownNumbersForCharges = true,

    UseCDMCustomFrameBarWidth = true,
    CDMCustomFrameBarWidth = 100,
    UseCDMCustomFrameBarHeight = true,
    CDMCustomFrameBarHeight = 20,

    CurrentCDMCustomFrameStatusbarTexture = "Blizzard BuffBar",
    CurrentCDMCustomFrameBackgroundTexture = "Blizzard BuffBar",
    UseCDMCustomFrameBackgroundColor = true,
    CDMCustomFrameBackgroundColor = { r=0.0, g=0.0, b=0.0, a=0.5 },
    CurrentCDMCustomFramePipTexture = 1,
    UseCDMCustomFramePipSize = true,
    CDMCustomFramePipSizeX = 8,
    CDMCustomFramePipSizeY = 30,

    UseCDMCustomFrameBarIconSize = false,
    CDMCustomFrameBarIconSize = 20,
    CurrentCDMCustomFrametBarIconPosition = 1,
    UseCDMCustomFrameBarIconOffset = false,
    CDMCustomFrameBarIconOffsetX = 0,
    CDMCustomFrameBarIconOffsetY = 0,
    
    AprilDayEnabled = true,

    CooldownFormatType = 2,
    CDMCooldownFormatType = 2,
    CooldownTimerFormat = 1,
    UseCooldownMilliseconds = false,
    CooldownMillisecondsThreshold = 5,

    CustomFrameBarNameEnable = true,
    CurrentCustomFrameBarNameFont = "Default",
    UseCustomFrameBarNameSize = false,
    CustomFrameBarNameSize = 14,
    UsCustomFrameBarNameColor = false,
    CustomFrameBarNameColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    CustomFrameBarNamePoint = 7,
    CustomFrameBarNameRelativePoint = 7,
    UseCustomFrameBarNameOffset = true,
    CustomFrameBarNameOffsetX = 2,
    CustomFrameBarNameOffsetY = 0,
    CurrentCustomFrameBarNameJustifyH = 1,

    CustomFrameBarStacksEnable = true,
    CurrentCustomFrameBarStacksFont = "Default",
    UseCustomFrameBarStacksSize = false,
    CustomFrameBarStacksSize = 14,
    UsCustomFrameBarStacksColor = false,
    CustomFrameBarStacksColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    CustomFrameBarStacksPoint = 8,
    CustomFrameBarStacksRelativePoint = 7,
    UseCustomFrameBarStacksOffset = true,
    CustomFrameBarStacksOffsetX = -4,
    CustomFrameBarStacksOffsetY = 0,
    CurrentCustomFrameBarStacksJustifyH = 2,

    CustomFrameBarTimeEnable = true,
    CurrentCustomFrameBarTimeFormat = 1,
    CurrentCustomFrameBarTimeFont = "Default",
    UseCustomFrameBarTimeSize = false,
    CustomFrameBarTimeSize = 11,
    UseCustomFrameBarTimeColor = false,
    CustomFrameBarTimeColor = { r=1.0, g=1.0, b=1.0, a=1.0 },
    CurrentCustomFrameBarTimePoint = 8,
    CurrentCustomFrameBarTimeRelativePoint = 8,
    UseCustomFrameBarTimeOffset = false,
    CustomFrameBarTimeOffsetX = 0,
    CustomFrameBarTimeOffsetY = 0,
    CurrentCustomFrameBarTimeJustifyH = 2,
}

Addon.Templates = {
    LoopGlow = {
        {
            name = "Modern Blizzard Glow",
            atlas = "UI-HUD-ActionBar-Proc-Loop-Flipbook",
        },
        {
            name = "Modern Blizzard Assist Blue Glow",
            atlas = "RotationHelper-ProcLoopBlue-Flipbook",
        },
        {
            name = "Modern Blizzard Assist Ants Glow",
            atlas = "RotationHelper_Ants_Flipbook",
        },
        {
            name = "Modern Blizzard Assist White Glow",
            texture = "Interface/AddOns/HUI/assets/flipbook2.tga",
        },
        {
            name = "Modern Blizzard Assist Rainbow Glow",
            texture = "Interface/AddOns/HUI/assets/HUI_flipbook_rainbow.png",
            rows = 6,
            columns = 10,
            frames = 60,
            duration = 0.9,
            frameW = 80,
            frameH = 80,
            scale = 1.05,
        },
        {
            name = "Classic Blizzard Glow",
            texture = "Interface\\SpellActivationOverlay\\IconAlertAnts",
            rows = 5,
            columns = 5,
            frames = 25,
            duration = 0.3,
            frameW = 48,
            frameH = 48,
            scale = 0.85,
        },
        {
            name = "HUI Classic-like Blizzard Glow",
            texture = "Interface/AddOns/HUI/assets/AB_ClassicLike_Glow.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.5,
            frameW = 100,
            frameH = 100,
            scale = 1,
        },
        {
            name = "HUI Star 1",
            texture = "Interface/AddOns/HUI/assets/stars_new2.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.5,
            frameW = 100,
            frameH = 100,
            scale = 0.9,
        },
        {
            name = "HUI Star 2",
            texture = "Interface/AddOns/HUI/assets/stars_new.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.5,
            frameW = 100,
            frameH = 100,
            scale = 0.9,
        },
        {
            name = "HUI Star 2 Rainbow",
            texture = "Interface/AddOns/HUI/assets/stars_rainbow_new.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.5,
            frameW = 100,
            frameH = 100,
            scale = 0.9,
        },
        {
            name = "HUI Lines",
            texture = "Interface/AddOns/HUI/assets/AB_Lines.tga",
            rows = 6,
            columns = 4,
            frames = 24,
            duration = 1.0,
            frameW = 50,
            frameH = 50,
            scale = 0.85,
        },
        {
            name = "HUI Lines Pixel-like",
            texture = "Interface/AddOns/HUI/assets/AB_Lines_Pixel.tga",
            rows = 6,
            columns = 2,
            frames = 12,
            duration = 0.35,
            frameW = 50,
            frameH = 50,
            scale = 0.85,
        },
        {
            name = "HUI Leaves",
            texture = "Interface/AddOns/HUI/assets/AB_Leaves.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.0,
            frameW = 50,
            frameH = 50,
            scale = 0.85,
        },
        {
            name = "HUI Void",
            texture = "Interface/AddOns/HUI/assets/AB_Void.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.0,
            frameW = 50,
            frameH = 50,
            scale = 0.85,
        },
        {
            name = "HUI Garg",
            texture = "Interface/AddOns/HUI/assets/AB_Garg.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.0,
            frameW = 100,
            frameH = 100,
            scale = 0.85,
        },
        {
            name = "HUI Energy",
            texture = "Interface/AddOns/HUI/assets/HUI_Energy.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.5,
            frameW = 72,
            frameH = 72,
            scale = 0.85,
        },
        {
            name = "HUI Fire",
            texture = "Interface/AddOns/HUI/assets/HUI_Fire.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.0,
            frameW = 72,
            frameH = 72,
            scale = 0.9,
        },
        {
            name = "HUI Fire2",
            texture = "Interface/AddOns/HUI/assets/HUI_Fire2.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.0,
            frameW = 80,
            frameH = 80,
            scale = 0.9,
        },
        {
            name = "HUI Antorus",
            texture = "Interface/AddOns/HUI/assets/HUI_Antorus.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.9,
            frameW = 100,
            frameH = 100,
            scale = 0.85,
        },
        {
            name = "HUI Lightning",
            texture = "Interface/AddOns/HUI/assets/HUI_Lightning.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.2,
            frameW = 100,
            frameH = 100,
            scale = 0.85,
        },
        {
            name = "HUI Zereth Square",
            texture = "Interface/AddOns/HUI/assets/proc_4.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.2,
            frameW = 100,
            frameH = 100,
            scale = 1.01,
        },
        {
            name = "HUI Pulse",
            texture = "Interface/AddOns/HUI/assets/pulse_01.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 1.0,
            frameW = 100,
            frameH = 100,
            scale = 0.95,
        },
        {
            name = "HUI Square Pixel-like",
            texture = "Interface/AddOns/HUI/assets/HUI_Square_PixelLike.png",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.35,
            frameW = 100,
            frameH = 100,
            scale = 0.82,
        },
        {
            name = "HUI Arc Raiders |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_ArcRaiders.png",
            rows = 10,
            columns = 6,
            frames = 60,
            duration = 1,
            frameW = 100,
            frameH = 100,
            scale = 1,
        },
        {
            name = "GCD",
            atlas = "UI-CooldownManager-Alert-Flipbook",
            rows = 11,
            columns = 2,
            frames = 22,
            duration = 1.0,
            scale = 0.7,
        }, 
        {
            name = "GCD 2",
            texture = "Interface/AddOns/HUI/assets/GCD_2.tga",
            rows = 6,
            columns = 2,
            frames = 12,
            duration = 0.5,
            frameW = 47,
            frameH = 47,
            scale = 0.7,
        },
        {
            name = "Rogue CP Blue",
            atlas = "UF-RogueCP-Slash-Blue",
            rows = 3,
            columns = 6,
            frames = 18,
            duration = 0.7,
            scale = 1.3,
        },
        {
            name = "Rogue CP Red",
            atlas = "UF-RogueCP-Slash-Red",
            rows = 3,
            columns = 6,
            frames = 18,
            duration = 0.7,
            scale = 1.3,
        },
        {
            name = "Druid CP Red",
            atlas = "UF-DruidCP-Slash",
            rows = 3,
            columns = 8,
            frames = 24,
            duration = 0.7,
            scale = 1.3,
        },
        {
            name = "Chi Wind",
            atlas = "UF-Chi-WindFX",
            rows = 3,
            columns = 6,
            frames = 18,
            duration = 0.7,
            scale = 1.3,
        },
        {
            name = "Essence",
            atlas = "UF-Essence-Flipbook-FX-Circ",
            rows = 3,
            columns = 10,
            frames = 30,
            duration = 1.0,
            scale = 1.2,
        },
        {
            name = "Vigor",
            atlas = "dragonriding_sgvigor_burst_flipbook",
            rows = 4,
            columns = 4,
            frames = 16,
            duration = 1.0,
            scale = 1.2,
        },
        {
            name = "Vigor 2",
            atlas = "dragonriding_sgvigor_decor_flipbook_left",
            rows = 2,
            columns = 4,
            frames = 8,
            duration = 0.7,
            scale = 0.8,
        },
        {
            name = "FX",
            atlas = "groupfinder-eye-flipbook-foundfx",
            rows = 5,
            columns = 15,
            frames = 75,
            duration = 1.0,
            scale = 1.0,
        },
        {
            name = "Arrow",
            atlas = "Ping_Marker_FlipBook_OnMyWay",
            rows = 4,
            columns = 6,
            frames = 24,
            duration = 1.0,
            scale = 0.7,
        },
        {
            name = "Soul",
            atlas = "UF-SoulShards-Flipbook-Soul",
            rows = 3,
            columns = 7,
            frames = 21,
            duration = 1.2,
            scale = 0.9,
        },
        {
            name = "Frost",
            atlas = "perks-frost-FX",
            rows = 3,
            columns = 5,
            frames = 15,
            duration = 0.7,
            scale = 0.9,
        },

    },
    ProcGlow = {
        {
            name = "Modern Blizzard Proc",
            atlas = "UI-HUD-ActionBar-Proc-Start-Flipbook",
        },
        {
            name = "Modern Blizzard Proc Short",
            texture = "Interface/AddOns/HUI/assets/ProcStartYellow.tga",
            rows = 3,
            columns = 6,
            frames = 18,
            duration = 0.5,
            scale = 1.0,
        },
        {
            name = "Modern Blizzard Proc Shorter",
            texture = "Interface/AddOns/HUI/assets/ProcStartYellow_Shorter.tga",
            rows = 2,
            columns = 5,
            frames = 10,
            duration = 0.35,
            scale = 1.0,
        },
        {
            name = "Modern Blizzard Blue Proc",
            atlas = "RotationHelper-ProcStartBlue-Flipbook-2x",
        },
        {
            name = "Modern Blizzard Blue Proc Short",
            texture = "Interface/AddOns/HUI/assets/ProcStartBlue.tga",
            rows = 3,
            columns = 6,
            frames = 18,
            duration = 0.5,
            scale = 1.0,
        },
        {
            name = "Modern Blizzard Blue Proc Shorter",
            texture = "Interface/AddOns/HUI/assets/ProcStartBlue_Shorter.tga",
            rows = 2,
            columns = 5,
            frames = 10,
            duration = 0.35,
            scale = 1.0,
        },
        {
            name = "Modern Blizzard White Proc Short",
            texture = "Interface/AddOns/HUI/assets/ProcStartWhite.tga",
            rows = 3,
            columns = 6,
            frames = 18,
            duration = 0.5,
            scale = 1.0,
        },
        {
            name = "Modern Blizzard White Proc Shorter",
            texture = "Interface/AddOns/HUI/assets/ProcStartWhite_Shorter.tga",
            rows = 2,
            columns = 5,
            frames = 10,
            duration = 0.35,
            scale = 1.0,
        },
        {
            name = "Modern Blizzard Rainbow Proc Short",
            texture = "Interface/AddOns/HUI/assets/HUI_ProcRainbow_Short.png",
            rows = 3,
            columns = 6,
            frames = 18,
            duration = 0.5,
            scale = 1.0,
        },
        {
            name = "Modern Blizzard Rainbow Proc Shorter",
            texture = "Interface/AddOns/HUI/assets/HUI_ProcRainbow_Shorter.png",
            rows = 2,
            columns = 5,
            frames = 10,
            duration = 0.35,
            scale = 1.0,
        },
        {
            name = "Classic-like Blizzard Proc",
            texture = "Interface/AddOns/HUI/assets/ClassicLike_Flipbook.tga",
            rows = 4,
            columns = 3,
            frames = 12,
            duration = 0.25,
            frameW = 80,
            frameH = 80,
            scale = 0.9,
        },
        {
            name = "HUI Burst Square",
            texture = "Interface/AddOns/HUI/assets/burst_square.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.33,
            frameW = 100,
            frameH = 100,
            scale = 0.38,
        },
        {
            name = "HUI Burst Rune Square",
            texture = "Interface/AddOns/HUI/assets/burst_2.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.33,
            frameW = 100,
            frameH = 100,
            scale = 0.38,
        },
        {
            name = "HUI Burst Rune Square 2",
            texture = "Interface/AddOns/HUI/assets/burst_3.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.33,
            frameW = 100,
            frameH = 100,
            scale = 0.38,
        },
        {
            name = "HUI Burst Zereth Square",
            texture = "Interface/AddOns/HUI/assets/burst_4.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.33,
            frameW = 100,
            frameH = 100,
            scale = 0.42,
        },
        {
            name = "HUI Burst Ring",
            texture = "Interface/AddOns/HUI/assets/burst_5.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.7,
            frameW = 100,
            frameH = 100,
            scale = 0.38,
        },
        {
            name = "HUI Burst Ring 2",
            texture = "Interface/AddOns/HUI/assets/burst_6.tga",
            rows = 6,
            columns = 5,
            frames = 30,
            duration = 0.4,
            frameW = 100,
            frameH = 100,
            scale = 0.38,
        },
    },
    PushedTextures = {
        {
            name = "Default Blizzard",
            index = 1,
            atlas = "UI-HUD-ActionBar-IconFrame-Down",
            point = "CENTER",
            size = {46,45},
        }, --1
        {
            name = "WowLabs 1",
            atlas = "wowlabs-spell-icon-frame-highlight",
            point = "CENTER",
            size = {52,52},
        }, --2
        {
            name = "WowLabs 2",
            atlas = "plunderstorm-actionbar-slot-border-swappable",
            point = "CENTER",
            size = {60,60},
        }, --3
        {
            name = "WowLabs 3",
            atlas = "wowlabs-ability-icon-frame",
            size = {47,47},
            coords = {0.94, 0, 0.94, 0},
            point = "TOPLEFT",
        }, --4
        {
            name = "Proc Alert",
            atlas = "UI-HUD-RotationHelper-ProcAltGlow",
            size = {48,48},
            point = "CENTER",
        }, --5
        {
            name = "Talents Border",
            atlas = "talents-node-choiceflyout-square-yellow",
            point = "CENTER",
            size = {43,43},
        }, --6
        {
            name = "Talents Border 2",
            atlas = "talents-node-choiceflyout-square-ghost",
            point = "CENTER",
            size = {48,48},
        }, --7
        {
            name = "Talents Border 3",
            atlas = "talents-node-square-ghost",
            point = "TOPLEFT",
            coords = {0.91, 0, 0.91, 0},
            size = {49,49},
        }, --8
        {
            name = "Transmog",
            atlas = "transmog-frame-pink",
            point = "CENTER",
            size = {48,48},
        }, --9
        {
            name = "Click cast",
            atlas = "ClickCast-Highlight-Binding",
            point = "CENTER",
            size = {45,45},
        }, --10
        {
            name = "Kyrian",
            atlas = "CovenantSanctum-Upgrade-Icon-Border-Kyrian",
            point = "TOPLEFT",
            coords = {0.96, 0, 0.96, 0},
            size = {46,46},
        }, --11
        {
            name = "Professions grey",
            atlas = "Professions-ChoiceReagent-Frame",
            point = "TOPLEFT",
            coords = {0.94, 0, 0.94, 0},
            size = {48,48},
        }, --12
        {
            name = "Professions gold",
            atlas = "Professions-Recrafting-Frame-Item",
            point = "TOPLEFT",
            coords = {0.94, 0, 0.94, 0},
            size = {48,48},
        }, --13
        {
            name = "Professions slot white",
            atlas = "professions-slot-frame-white",
            point = "CENTER",
            size = {45,45},
        }, --14
        {
            name = "Professions Gear Enchant",
            atlas = "GearEnchant_IconBorder",
            point = "CENTER",
            size = {48,48},
        }, --15
        {
            name = "Runecarving",
            atlas = "runecarving-icon-center-selected",
            point = "TOPLEFT",
            coords = {0.88, 0.10, 0.88, 0.10},
            size = {45,45},
        }, --16
        {
            name = "Runecarving 2",
            atlas = "runecarving-icon-reagent-border",
            point = "CENTER",
            size = {57,57},
        }, --17
        {
            name = "Spellbook",
            atlas = "spellbook-item-unassigned-glow",
            point = "TOPLEFT",
            coords = {0.92, 0.08, 0.92, 0.08},
            size = {45,45},
        }, --18
        {
            name = "HUI Border Square 2 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_2.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 3 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_3.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 4 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_4.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 6 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_6.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 8 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_8.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
    },
    HighlightTextures = {
        {
            name = "Hide",
            hide = true,
        },
        {
            name = "Default Blizzard Highlight",
            atlas = "UI-HUD-ActionBar-IconFrame-Mouseover",
            point = "CENTER",
        },
        {
            name = "Bags Glow",
            atlas = "bags-glow-white",
            point = "CENTER",
            size = {41,41},
        },
        {
            name = "Item Upgrade",
            atlas = "ItemUpgrade_FX_SlotInnerGlow",
            point = "CENTER",
            size = {39,39},
        },
        {
            name = "Professions",
            atlas = "UI_bg_npcreward",
            size = {45,45},
        },
        {
            name = "Spellbook",
            atlas = "spellbook-item-petautocast-corners",
            size = {44,44},
        },
        {
            name = "Conduit",
            atlas = "Soulbinds_Tree_Conduit_Arrows",
            point = "TOPLEFT",
            size = {45,44},
        },
        {
            name = "Transmog",
            atlas = "transmog-frame-pink",
            point = "CENTER",
            size = {46,46},
        },
        {
            name = "Azerite",
            atlas = "AzeriteIconFrame",
            size = {44,44},
        },
        {
            name = "Mount Equipment",
            atlas = "mountequipment-slot-corners-open",
            point = "CENTER",
            size = {45,45},
        },
        {
            name = "HUI Highlight Square 1 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Highlight_Square.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Highlight Square 2 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Highlight_Square1.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Highlight Square 3 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Highlight_Square2.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Highlight CooldownManager |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Highlight_CooldownManager.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Highlight CooldownManager 2 |cff1df2a8*new*",
            texture = "Interface/AddOns/HUI/assets/HUI_Checked_CooldownManager.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
    },
    --Border:
    NormalTextures = {
        {
            name = "Default Blizzard Border",
            texture = "UI-HUD-ActionBar-IconFrame",
            point = "CENTER",
            size = {46, 45},
        },
        {
            name = "Default Blizzard Border Thick",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Default_Thick.png",
            point = "CENTER",
            size = {46, 45},
        },
        {
            name = "Cooldown Manager",
            texture = "UI-HUD-CoolDownManager-IconOverlay",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {60, 60},
        },
        {
            name = "Wowlabs Ability",
            texture = "wowlabs-ability-icon-frame",
            point = "CENTER",
            size = {50,50},
        },
        {
            name = "Wowlabs Item Border",
            texture = "wowlabs-in-world-item-common",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {55,55},
        },
        {
            name = "Plunderstorm",
            texture = "plunderstorm-actionbar-slot-border",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {58,58},
        },
        --[[ {
            name = "Renown",
            texture = "covenantsanctum-renown-icon-border-standard",
            point = "TOP",
            padding = {0, 11},
            size = {58,65},
        }, ]]
        {
            name = "HUI Border Thin",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Thin",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 2",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_2.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 3",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_3.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 4",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_4.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 6",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_6.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "HUI Border Square 8",
            texture = "Interface/AddOns/HUI/assets/HUI_Border_Square_8.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {43,43},
        },
        {
            name = "Talents Gray",
            texture = "talents-node-choiceflyout-square-gray",
            point = "CENTER",
            size = {45,45},
        },
        {
            name = "Cypher",
            texture = "cyphersetupgrade-leftitem-border-empty",
            point = "CENTER",
            padding = {-0.5, 1},
            size = {54,62},
        },
        {
            name = "Professions",
            texture = "Professions-ChoiceReagent-Frame",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {50,50},
        },
        {
            name = "Relicforge",
            texture = "Relicforge-Slot-frame",
            point = "CENTER",
            size = {62,62},
        },
        {
            name = "Runecarving",
            texture = "runecarving-icon-reagent-selected",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {55,55},
        },
        {
            name = "Soulbinds",
            texture = "Soulbinds_Collection_SpecBorder_Primary",
            point = "CENTER",
            size = {68,68},
        },
    },
    BackdropTextures = {
        {
            name = "Default Blizzard Backdrop",
            atlas = "UI-HUD-ActionBar-IconFrame-Background",
            point = "CENTER",
            size = {46,45},
        },
        {
            name = "Default Blizzard Slot Art",
            atlas = "UI-HUD-ActionBar-IconFrame-Slot",
            point = "CENTER",
            size = {46,45},
        },
        {
            name = "Cooldown Manager Shadow",
            atlas = "UI-CooldownManager-OORshadow",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {42,41},
        },
        {
            name = "HUI Classic Light",
            texture = "Interface/AddOns/HUI/assets/HUI_Backdrop_Light.tga",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {42,42},
        },
        {
            name = "HUI Gradient",
            texture = "Interface/AddOns/HUI/assets/HUI_Backdrop_Gradient.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {42,42},
        },
        {
            name = "HUI Gradient 2",
            texture = "Interface/AddOns/HUI/assets/HUI_Backdrop_GradientUp.png",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {42,42},
        },
        {
            name = "Blank Color",
            atlas = "UI-Frame-IconMask",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {44,44},
        },
        {
            name = "Blank Color Square",
            atlas = "SquareMask",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {42,42},
        },
        {
            name = "Plunderstorm",
            atlas = "plunderstorm-actionbar-slot-background",
            point = "CENTER",
            size = {60,60},
        },
        {
            name = "Forge",
            atlas = "Forge-ColorSwatchBackground",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {46,45},
        },
        {
            name = "Reward",
            atlas = "UI_bg_npcreward",
            point = "CENTER",
            padding = {-0.7, 0.5},
            size = {47,47},
        },
        {
            name = "Relicforge",
            atlas = "Relicforge-Slot-background",
            point = "CENTER",
            padding = {-0.6, 0.5},
            size = {41,41},
        },
        {
            name = "Metal Style",
            atlas = "FontStyle_Metal",
            point = "CENTER",
            padding = {-0.7, 0.5},
            size = {39,40},
        },
        {
            name = "Parchment Style",
            atlas = "FontStyle_Parchment",
            point = "CENTER",
            padding = {-0.7, 0.5},
            size = {39,40},
        },
        {
            name = "Legion Style",
            atlas = "FontStyle_Legion",
            point = "CENTER",
            padding = {-0.7, 0.5},
            size = {39,40},
        },
        {
            name = "IronHorde Style",
            atlas = "FontStyle_IronHordeMetal",
            point = "CENTER",
            padding = {-0.7, 0.5},
            size = {39,40},
        },
        {
            name = "Blue Gradient Style",
            atlas = "FontStyle_BlueGradient",
            point = "CENTER",
            padding = {-0.7, 0.5},
            size = {39,40},
        },
        {
            name = "Ship Follower",
            atlas = "ShipMission_ShipFollower-EquipmentBG",
            point = "CENTER",
            padding = {-0.5, 0.5},
            size = {54,53},
        },
    },
    IconMaskTextures = {
        {
            name = "Default Blizzard Icon Mask",
            texture = "Interface/Common/common-iconmask",
            point = "CENTER",
            padding = {0, 0},
            size = {45,45},
        },
        {
            name = "Cooldown Manager Mask",
            texture = "UI-HUD-CoolDownManager-Mask",
            point = "CENTER",
            padding = {0, 0},
            size = {45,45},
        },
        {
            name = "HUI Cooldown Manager Mask",
            texture = "Interface/AddOns/HUI/assets/HUI_Mask_CooldownTracker.png",
            point = "CENTER",
            padding = {0, 0},
            size = {45,45},
        },
        {
            name = "Square Mask",
            texture = "Interface/AddOns/HUI/assets/HUI_Mask_Square.png",
            point = "CENTER",
            padding = {0, 0},
            size = {45,45},
        },
        {
            name = "Circle Mask",
            texture = "CircleMaskScalable",
            point = "CENTER",
            padding = {0, 0},
            size = {45,45},
        },
        {
            name = "Hexagon Mask",
            texture = "CovenantSanctum-Renown-Hexagon-Mask",
            point = "CENTER",
            padding = {0, 0},
            size = {60,60},
        },
        {
            name = "Talent Node Mask",
            texture = "talents-node-choiceflyout-mask",
            point = "CENTER",
            padding = {0, 0},
            size = {45,45},
        },
        {
            name = "HUI Circle Mask",
            texture = "Interface/AddOns/HUI/assets/HUI_Mask_Circle.png",
            point = "CENTER",
            padding = {0, 0},
            size = {45,45},
        },
    },
    SwipeTextures = {
        {
            name = "Default Blizzard Swipe",
            texture = "Interface\\Cooldown\\ui-hud-cooldown-swipe",
        },
        {
            name = "HUI Button",
            texture = "Interface\\AddOns\\HUI\\assets\\HUI_CooldownSwipe_Button.png",
        },
        {
            name = "HUI Button Blured",
            texture = "Interface\\AddOns\\HUI\\assets\\HUI_CooldownSwipe_Blured.png",
        },
        {
            name = "HUI Square",
            texture = "Interface\\AddOns\\HUI\\assets\\HUI_Mask_Square.png",
        },
        {
            name = "HUI Cooldown Tracker",
            texture = "Interface\\AddOns\\HUI\\assets\\HUI_Mask_CooldownTracker3.png",
        },
    },
    EdgeTextures = {
        {
            name = "Default Blizzard Edge",
            texture = "Interface\\Cooldown\\UI-HUD-ActionBar-SecondaryCooldown",
        },
        {
            name = "HUI Edge White",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_White.png",
        },
        {
            name = "HUI Edge Black and White",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_BW.png",
        },
        {
            name = "HUI Edge Line",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_Line.png",
        },
        {
            name = "HUI Edge Line Black and White",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_LineBW.png",
        },
        {
            name = "HUI Edge Blade",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_Blade2.png",
        },
        {
            name = "HUI Edge Blade 2",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_Blade.png",
        },
        {
            name = "HUI Edge Blade 3",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_Blade3.png",
        },
        {
            name = "HUI Edge Blade RGB",
            texture = "Interface/AddOns/HUI/assets/HUI_CooldownEdge_BladeRGB.png",
        },
    },
    StatusBarTextures = {},
    PipTextures = {
        {
            name = "Default Blizzard Spark",
            texture = "UI-HUD-CoolDownManager-Bar-Pip",
        },
        {
            name = "Solid",
            texture = "_perks-dropdown-mouseover-middle",
        },
        {
            name = "Professions Spark",
            texture = "Professions-QualityBar-Flare",
        },
        {
            name = "Professions Spark 2",
            texture = "Professions-QualityBar-DividerGlow",
        },
        {
            name = "Professions Spark 3",
            texture = "Skillbar_Flare_Blacksmithing",
        },
        {
            name = "Plunderstorm",
            texture = "plunderstorm-stormbar-spark",
        },
        {
            name = "Dial",
            texture = "SpecDial_Divider",
        },
        {
            name = "Empower",
            texture = "ui-castingbar-empower-cursor-2x",
        },
        {
            name = "DemonHunter",
            texture = "Unit_DemonHunter_Fury_EndCap",
        },
        {
            name = "AstralPower",
            texture = "Unit_Druid_AstralPower_EndCap",
        },
        {
            name = "Ebon",
            texture = "Unit_Evoker_EbonMight_EndCap",
        },
        {
            name = "Maelstorm",
            texture = "Unit_Shaman_Maelstrom_EndCap",
        },
        {
            name = "Combat Timeline",
            texture = "combattimeline-pip",
        },
        {
            name = "Obelisk",
            texture = "FlightMaster_ProgenitorObelisk-TaxiNode_Neutral",
        },
        {
            name = "Paw",
            texture = "WildBattlePet",
        },
        {
            name = "Activities",
            texture = "activities-bar-end",
        },
        {
            name = "Gem",
            texture = "plunderstorm-new-dot-lg",
        },
        {
            name = "Pointer",
            texture = "glues-characterSelect-icon-restoreCharacter-pointer",
        },
        {
            name = "Arrow",
            texture = "cyphersetupgrade-arrow-full",
        },
        {
            name = "Arrow2",
            texture = "friendslist-categorybutton-arrow-right",
        },
        {
            name = "Arrow3",
            texture = "perks-forwardarrow",
        },
        {
            name = "Arrow4",
            texture = "uitools-icon-chevron-right",
        },
    },
    CastBarShieldIcons = {
        {
            name = "None",
            hide = true,
        },
        {
            name = "Default Blizzard Shield",
            texture = "UI-CastingBar-Shield",
        },
        {
            name = "Small Shield",
            texture = "GM-icon-role-tank",
        },
        {
            name = "Conduit Shield",
            texture = "Soulbinds_Tree_Conduit_Icon_Protect",
        },
        {
            name = "Conduit Cross",
            texture = "Soulbinds_Tree_Conduit_Icon_Attack",
        },
        {
            name = "Lock",
            texture = "Soulbinds_Portrait_Lock",
        },
        {
            name = "Red Marker",
            texture = "GM-raidMarker-remove",
        },

    },
    ExtraZoneAbilityArts = {
        {
            name = "None",
            hide = true,
        },
        {
            name = "Default",
            default = true,
        },
        {
            name = "Air",
            atlas = "air-extrabutton",
        },
        {
            name = "Cypher",
            atlas = "cypher-zone-ability",
            belowIcon = true,
        },
        {
            name = "Progenitor",
            atlas = "progenitor-extrabutton",
        },
        {
            name = "Fire",
            atlas = "fire-extrabutton",
        },
        {
            name = "Generic",
            atlas = "generic-extrabutton",
        },
        {
            name = "Nerubian",
            atlas = "nerubian-extrabutton",
        },
        {
            name = "Storm White",
            atlas = "stormwhite-extrabutton",
        },
        {
            name = "Storm Blue",
            atlas = "stormblue-extrabutton",
        },
        {
            name = "Storm Purple",
            atlas = "stormpurple-extrabutton",
        },
        {
            name = "Storm Yellow",
            atlas = "stormyellow-extrabutton",
        },
        {
            name = "Torghast",
            atlas = "Torghast-Empowered",
        },
        {
            name = "Water",
            atlas = "water-extrabutton",
        },
        {
            name = "Garrison Armory",
            atlas = "GarrZoneAbility-Armory",
        },
        {
            name = "Garrison Barracks (Alliance)",
            atlas = "GarrZoneAbility-BarracksAlliance",
        },
        {
            name = "Garrison Barracks (Horde)",
            atlas = "GarrZoneAbility-BarracksHorde",
        },
        {
            name = "Garrison Inn",
            atlas = "GarrZoneAbility-Inn",
        },
        {
            name = "Garrison Lumber Mill",
            atlas = "GarrZoneAbility-LumberMill",
        },
        {
            name = "Garrison Mage Tower",
            atlas = "GarrZoneAbility-MageTower",
        },
        {
            name = "Garrison Stables",
            atlas = "GarrZoneAbility-Stables",
        },
        {
            name = "Garrison Trading Post",
            atlas = "GarrZoneAbility-TradingPost",
        },
        {
            name = "Garrison Training Pit",
            atlas = "GarrZoneAbility-TrainingPit",
        },
        {
            name = "Garrison Workshop",
            atlas = "GarrZoneAbility-Workshop",
        },
        {
            name = "Ardenweald",
            atlas = "ardenweald-zone-ability",
            belowIcon = true,
        },
        {
            name = "Maldraxxus",
            atlas = "maldraxxus-zone-ability",
            belowIcon = true,
        },
        {
            name = "Bastion",
            atlas = "bastion-zone-ability",
            belowIcon = true,
        },
        {
            name = "Revendreth",
            atlas = "revendreth-zone-ability",
            belowIcon = true,
        },
        {
            name = "World Quest Follower",
            atlas = "worldquest-followerabilityframe",
            offsetY = -5,
        },
        {
            name = "Housing Wood Frame",
            atlas = "housing-item-wood-frame_64",
            size = {52, 52},
            offsetX = -1,
            offsetY = 1,
        },
        {
            name = "Blacksmithing Border",
            atlas = "Capacitance-Blacksmithing-IconBorder",
        },
        {
            name = "Shop Gold Rim",
            atlas = "shop-gold-rim",
            size = {60, 56},
        },
        {
            name = "Item Upgrade Slot",
            atlas = "ItemUpgrade_SlotBorder",
            size = {56, 56},
            offsetX = -1,
            offsetY = 1,
        },
        {
            name = "Legion Mission Ability",
            atlas = "legionmission-EncounterAbilityBorder-Lg",
        },
        {
            name = "Runecarving",
            atlas = "runecarving-icon-center-empty",
            belowIcon = true,
            size = {62, 62},
            offsetX = -1,
            offsetY = 1,
        },
        {
            name = "Spellbook Icon Frame",
            atlas = "spellbook-item-iconframe",
            size = {60, 58},
            offsetX = -4,
            offsetY = -4,
        },
        {
            name = "Cooldown Alert Glow",
            atlas = "UI-CooldownManager-VisualAlert-Glow",
        },
        {
            name = "Transmog Gear Slot",
            atlas = "transmog-gearSlot-transmogrified",
        },
    }
}
local AddonName, Addon = ...

local L = {}

Addon.L = L

-- ==========================================
-- Welcome Messages
-- ==========================================
L.welcomeMessage1 = "Thank you for using |cff1df2a8HUI|r"
L.welcomeMessage2 = "You may access options by using |cff1df2a8/"

-- ==========================================
-- General Settings
-- ==========================================
L.Enable = "Enable"
L.GlobalSettings = "Global Settings"

-- ==========================================
-- Action Bars
-- ==========================================
L.MainActionBar = "Action Bar 1"
L.MultiBarBottomLeft = "Action Bar 2"
L.MultiBarBottomRight = "Action Bar 3"
L.MultiBarRight = "Action Bar 4"
L.MultiBarLeft = "Action Bar 5"
L.MultiBar5 = "Action Bar 6"
L.MultiBar6 = "Action Bar 7"
L.MultiBar7 = "Action Bar 8"
L.PetActionBar = "Pet Bar"
L.StanceBar = "Stance Bar"
L.BagsBar = "Bags Bar"
L.MicroMenu = "Micro Menu"

-- ==========================================
-- Action Bars Settings
-- ==========================================
L.ActionBarSettingTitle = "Action Bar Extra Settings"
L.ActionBarSettingDesc = "Choose the growth direction, button padding, and layout style (centered or default) for action bar."

-- ==========================================
-- Proc Glow Effects
-- ==========================================
L.GlowTypeTitle = "Proc Loop Glow"
L.GlowTypeDesc = "Choose the proc loop animation"
L.GlowType = "Proc Loop Glow Type"

L.ProcStartTitle = "Proc Start Glow"
L.ProcStartDesc = "Choose or hide the start of proc animation"
L.HideProcAnim = "Hide Start Proc Animation"
L.StartProcType = "Start Proc Animation Type"

L.AssistTitle = "Assisted Highlight Glow"
L.AssistDesc = "Choose the Combat Assisted Highlight animation"
L.AssistType = "Assisted Highlight type"
L.AssistAltType = "Assisted secondary Highlight type"

L.UseCustomColor = "Use custom color"
L.Desaturate = "Desaturate"

-- ==========================================
-- Fade Bars
-- ==========================================
L.FadeTitle = "Fade Bars"
L.FadeDesc = "Enable fade out for bars and configure when they fade in."
L.FadeOutBars = "Enable FadeIn/FadeOut for bars"
L.FadeInOnCombat = "Fade In during combat"
L.FadeInOnTarget = "Fade In when target exists"
L.FadeInOnCasting = "Fade In when casting"
L.FadeInOnHover = "Fade In on mouse hover"

-- ==========================================
-- Button Textures
-- ==========================================
L.NormalTitle = "Border Texture Style"
L.NormalDesc = "Border texture for button."
L.NormalTextureType = "Border Texture Type"

L.BackdropTitle = "Backdrop Texture Style"
L.BackdropDesc = "Backdrop texture for button."
L.BackdropTextureType = "Backdrop Texture Type"

L.IconTitle = "Icon Mask Style"
L.IconDesc = "Choose mask texture and adjust mask and icon scale"
L.IconMaskTextureType = "Icon Mask Texture Type"
L.IconMaskScale = "Modify Icon Mask Scale"
L.IconScale = "Modify Icon Scale"

L.PushedTitle = "Pushed Texture Style"
L.PushedDesc = "Texture that appears when you press a button."
L.PushedTextureType = "Pushed Texture Type"

L.HighlightTitle = "Highlight Texture Style"
L.HighlightDesc = "Texture that appears when you hover over a button."
L.HighliteTextureType = "Highlight Texture Type (mouseover)"

L.CheckedTitle = "Checked Texture Style"
L.CheckedDesc = "Texture that appears when you successfully use a skill or it's in the spell queue."
L.CheckedTextureType = "Checked Texture Type"

-- ==========================================
-- Cooldown Settings
-- ==========================================
L.CooldownTitle = "Cooldown Customization"
L.CooldownDesc = "Adjust cooldown Font, Swipe and Edge"
L.SwipeTextureType = "Cooldown Swipe Texture Type"
L.SwipeSize = "Cooldown Swipe texture Size"
L.CustomSwipeColor = "Use custom color for Cooldown Swipe"

L.EdgeTextureType = "Cooldown Edge Texture Type"
L.EdgeSize = "Cooldown Edge texture Size"
L.CustomEdgeColor = "Use custom color for Cooldown Edge"
L.EdgeAlwaysShow = "Always show Cooldown Edge"

L.CooldownFont = "Choose Font for Cooldown"
L.CooldownFontSize = "Cooldown font Size"
L.FontColor = "Font Color"

-- ==========================================
-- Color Override
-- ==========================================
L.ColorOverrideTitle = "Button Status Color Override"
L.ColorOverrideDesc = "Customize colors for different button states."
L.CustomColorOOR = "Custom color for Out Of Range"
L.CustomColorOOM = "Custom color for Out Of Mana"
L.CustomColorNoUse = "Custom color for Not Usable spells"

L.CustomColorGCD = "Custom color for icon On GCD"
L.CustomColorCD = "Custom color for icon On CD"
L.CustomColorNormal = "Custom color for Normal state"
L.CustomColorAura = "Custom color for icon with Aura"

L.RemoveOORColor = "Remove OOR Color"
L.RemoveOOMColor = "Remove OOM Color" 
L.RemoveNUColor = "Remove NU Color"
L.RemoveDesaturation = "Remove Desaturation"

-- ==========================================
-- Hide Frames and Animations
-- ==========================================
L.HideFrameTitle = "Hide Frames and Animations"
L.HideFrameDesc = "Hide various frames and annoying animations on the Action Bar."
L.HideBagsBar = "Hide Bags Bar"
L.HideMicroMenuBar = "Hide MicroMenu Bar"
L.HideStanceBar = "Hide Stance Bar"
L.HideTalkingHead = "Hide Talking Head"
L.HideInterrupt = "Hide Interrupt Animation on buttons"
L.HideCasting = "Hide Casting Animation on buttons"
L.HideReticle = "Hide AoE Targeting Animation on buttons"

-- ==========================================
-- Font Options
-- ==========================================
L.FontTitle = "Font Options"
L.FontDesc = "Customize the Font for Hotkey and Stack text."
L.FontHotKeyScale = "Modify Hotkey scale (for small buttons)"
L.FontStacksScale = "Modify Stacks scale (for small buttons)"
L.FontHideName = "Hide button (macro) Name"
L.FontNameScale = "Modify Name scale (for small buttons)"

L.HotKeyFont = "Choose Font for Hotkey"
L.HotkeyOutline = "Outline type for Hotkey"
L.HotkeyShadowColor = "Hotkey Font Shadow"
L.HotkeyShadowOffset = "Hotkey Font Shadow Offset"
L.FontHotkeySize = "Choose Hotkey font Size"
L.HotkeyAttachPoint = "Choose Attach Point for Hotkey"
L.HotkeyOffset = "Choose Hotkey Offset"
L.HotkeyCustomColor = "Custom color for Hotkey"

L.StacksFont = "Choose Font for Stacks"
L.StacksOutline = "Outline type for Stacks"
L.StacksShadowColor = "Stacks Font Shadow"
L.StacksShadowOffset = "Stacks Font Shadow Offset"
L.FontStacksSize = "Choose Stacks font Size"
L.StacksAttachPoint = "Choose Attach Point for Stacks"
L.StacksOffset = "Choose Stacks Offset"
L.StacksCustomColor = "Custom color for Stacks"

-- ==========================================
-- Profiles
-- ==========================================
L.ProfilesHeaderText = "You can change the active database profile, so you can have different settings for every character.\nReset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."
L.ProfilesCopyText = "Copy the settings from one existing profile into the currently active profile."
L.ProfilesDeleteText = "Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."
L.ProfilesImportText = "Share your profile or import someone else's with a simple string."

-- ==========================================
-- WeakAuras Integration
-- ==========================================
L.WAIntTitle = "WeakAuras Integration"
L.WAIntDesc = "Choose the Proc and Loop override for WA's Glow effect.\nThis will affect the aura glow effect with type 'Proc Glow'"
L.ModifyWAGlow = "Modify WA Glow"
L.WAProcType = "WA Proc Type"
L.WALoopType = "WA Loop Type"
L.AddWAMask = "Add mask to WA icons"

-- ==========================================
-- Quick Presets
-- ==========================================
L.PresetActive = "Active"
L.PresetSelect = "Select"

-- ==========================================
-- Copy/Paste Functions
-- ==========================================
L["Copied: %s"] = "Copied: %s"
L["Pasted: %s → %s"] = "Pasted: %s → %s"
L.CopyText = "Click to Copy"
L.PasteText = "Click to Paste"
L.CancelText = "Click to Cancel"

-- ==========================================
-- Cooldown Manager Viewer Types
-- ==========================================
L.EssentialCooldownViewer   = "Essential Frame"
L.UtilityCooldownViewer     = "Utility Frame"
L.BuffIconCooldownViewer    = "Buff Icons"
L.BuffBarCooldownViewer     = "Buff Bars"

-- ==========================================
-- Cooldown Manager Basic Settings
-- ==========================================
L.IconPadding = "Icon Padding"
L.CDMBackdrop = "Add Border"
L.CDMCenteredGrid = "Center Icons"
L.MinimapButton = "Show minimap button"
L.UsePixelPerfect = "Use PixelPerfect"
L.CDMRemoveIconMask = "Remove Icon Mask"
L.CDMRemovePandemic = "Remove Pandemic Animation"
L.CDMSwipeColor = "Cooldown Swipe Color"
L.CDMAuraSwipeColor = "Aura Swipe Color"
L.CDMBackdropColor = "Border Color"
L.CDMBackdropAuraColor = "Aura Border Color"
L.CDMBackdropPandemicColor = "Pandemic Border Color"
L.CDMReverseSwipe = "Reverse Cooldown Fill"
L.CDMRemoveAuraTypeBorder = "Remove Aura type border"

-- ==========================================
-- Status Bar Settings
-- ==========================================
L.CDMBarContainerTitle = "Status Bar Settings"
L.CDMBarContainerDesc = "Customize the appearance and layout of status bars."
L.StatusBarTextures = "Status Bar Texture"
L.FontNameSize = "Name Font Size"
L.StatusBarBGTextures = "Background Texture"

-- ==========================================
-- Bar Layout Settings
-- ==========================================
L.BarGrow = "Growth Direction"
L.RightClickPassThrough = "Right click passes through buttons"
L.NameFont = "Name Font"
L.IconSize = "Icon Size"
L.BarHeight = "Bar Height"
L.BarPipSize = "Spark Size"
L.BarPipTexture = "Spark Texture"
L.BarOffset = "Bar Attach Offset"

-- ==========================================
-- CDM Additional Settings
-- ==========================================
L.CDMItemSize = "Item Size"
L.CDMRemoveGCDSwipe = "Remove GCD Swipe Animation"
L.CDMAuraReverseSwipe = "Reverse Aura Fill"

L.CDMCooldownTitle = "Cooldown Customization"
L.CDMCooldownDesc = "Modify cooldown appearance for CDM"

L.IconBorderTitle = "Border Settings"
L.IconBorderDesc = "Create and configure a pixel border."

L.CDMOptionsTitle = "Additional CDM Options"
L.CDMOptionsDesc = "Global enable additional settings that override standard CDM parameters"


-- ========================================
-- Unsorted
-- ========================================
L.CDMAuraTimerColor = "Aura Timer Color"

L.CDMCustomFrameTitle = "Custom CDM Frame"
L.CDMCustomFrameDesc = "Configure a custom frame to track Spells or Items. You can set an aura timer via the context menu."

L.CDMCustomPingTitle = "Pingable Frames"
L.CDMCustomPingDesc = "Allow the Blizzard ping system to ping spell or item state from custom frames (hold the ping key and click the frame)."

L.CDMCustomFrameName = "Frame Name"

L.CDMCustomFrameDelete = "Delete Custom Frame"
L.Delete = "DELETE"

L.CDMCustomFrameAddSpellByID = "Add Spell by ID"
L.CDMCustomFrameAddItemByID = "Add Item by ID"

L.CDMCustomFrameTrackSlot13 = "Add Trinket #1 (Slot 13)"
L.CDMCustomFrameTrackSlot14 = "Add Trinket #2 (Slot 14)"
L.CDMCustomFrameTrackSlot16 = "Add Weapon #1 (Slot 16)"
L.CDMCustomFrameTrackSlot17 = "Add Weapon #2 (Slot 17)"
L.CDMCustomFrameTrackRacial = "Add Racial spell"

L.CDMCustomFrameHideWhen0 = "Hide when count is 0"

L.CDMCustomFrameAlphaOnCD = "Opacity when NOT on Cooldown"

L.CDMCustomFrameGridLayoutTitle = "Frame Grid Layout"
L.CDMCustomFrameGridLayoutDesc = "Set item size, spacing, max columns, and growth direction."

L.CDMCustomFrameElementSize = "Icon Size"

L.Stride = "Max Columns"

L.CenteredLayout = "Centered"

L.VerticalGrowth = "Vertical Growth"
L.HorizontalGrowth = "Horizontal Growth"

L.GridDirection = "Layout Direction"

L.FrameStrata = "Frame Strata"
L.FrameLevel = "Frame Level"
L.Level = "Level"

L.DragNDropContainer = "Drag and drop a Spell or Item here.\n(LMB - reorder, RMB - menu, sRMB - quick remove)"

L.FakeAura = "Custom Aura"

L.Confirm = "CONFIRM"

L.SetFakeAura = "Set Aura Timer"
L.SetFakeAuraDesc = "Set a timer in |cff0bbe76SECONDS|r that appears when the item/spell is used (enter 0 or leave blank to remove the timer)."

L.QuickPresets = "Quick Presets"
L.QuickPresetsDesc = "Quickly apply preset templates. For detailed customization use the Advanced menu."

L.GridCentered = "Center, no gaps"
L.GridCompact = "Left/Right, no gaps"
L.GridFixed = "Left/Right, with gaps"

L.GridLayoutType = "Grid Style"
L.HideWhenInactive = "Visibility"

L.Alpha = "Fade Alpha"

L.Scale = "Scale"

L.Size = "Size"

L.OffsetX = "Offset X"
L.OffsetY = "Offset Y"

L.Rows = "Rows"
L.Columns = "Columns"

L.Buttons = "Buttons"

L.Padding = "Padding"

L.Offset = "Offset"

L.SizeX = "Size X"
L.SizeY = "Size Y"

L.AttachPointTOPLEFT = "Top Left"
L.AttachPointTOP = "Top"
L.AttachPointTOPRIGHT = "Top Right"
L.AttachPointBOTTOMLEFT = "Bottom Left"
L.AttachPointBOTTOM = "Bottom"
L.AttachPointBOTTOMRIGHT = "Bottom Right"
L.AttachPointLEFT = "Left"
L.AttachPointRIGHT = "Right"
L.AttachPointCENTER = "Center"

L.FontOutlineNONE = "None"
L.FontOutlineOUTLINE = "Outline"
L.FontOutlineTHICKOUTLINE = "Thick Outline"

L.VerticalGrowthUP = "Up"
L.VerticalGrowthDOWN = "Down"

L.HorizontalGrowthRIGHT = "Right"
L.HorizontalGrowthLEFT = "Left"

L.DirectionHORIZONTAL = "Horizontal"
L.DirectionVERTICAL = "Vertical"

L.ColorizedCooldownFont = "Colorize cooldown text by time"
L.ColorizedAuraFont = "Colorize aura text by time"

L.AuraSound = "Aura Sound"
L.AuraSoundTriggerAdded = "On Applied"
L.AuraSoundTriggerApplicationsIncreased = "On Stack Gained"
L.AuraSoundTriggerRemoved = "On Removed"
L.AuraSoundNone = "None"
L.AuraSoundPlaySample = "Play Sample"

-- ========================================
-- Cast Bars
-- ========================================

L.CastBarsOptionsTitle = "Cast Bar Options"
L.CastBarsOptionsDesc = "Customize size, texture, color and extra options of Cast Bar."

L.None = "None"
L.Left = "On Left"
L.Right = "On Right"
L.LeftAndRight = "On Left and Right"

L.CastBarsIconOptionsTitle = "Cast Bar Icon Options"
L.CastBarsIconOptionsDesc = "Customize spell Icon appearance."

L.BarIconOptionsTitle = "Bar Icon Options"
L.BarIconOptionsDesc = "Customize bar icon appearance."

L.CastBarIconPos = "Show Icon"

L.AttachPoint = "Attach Point"

L.CastBarsSQWLatencyOptionsTitle = "Latency and Spell Queue Window"
L.CastBarsSQWLatencyOptionsDesc = "Show current |cffe35522Latency|r and |cff0bbe76Spell Queue Window|r.\nThe |cff0bbe76Spell Queue Window|r is a mechanic that allows to queue up next ability before the current one has finished casting. By default it is set to 400 ms.\nFor more info Google |cff0bbe76\"SpellQueueWindow\""

L.CastBarStandartColor = "Color of Regular cast"
L.CastBarImportantColor = "Color of Important cast"
L.CastBarChannelColor = "Color of Channeled cast"
L.CastBarUninterruptableColor = "Color of Uninterruptible cast"
L.CastBarInterruptedColor = "Color of Interrupted cast"
L.CastBarReadyColor = "Color when interrupt not on CD"

L.CastTimeCurrent = "Current"
L.CastTimeMax = "Total"
L.CastTimeCurrentAndMax = "Current / Total"
L.CastTimeRemaining = "Remaining"
L.CastTimeRemainingAndMax = "Remaining / Total"

L.CastTimeFormat = "Timer Format"

L.CastHideTextBorder = "Hide Font Border"

L.CastHideInterruptAnim = "Hide Interruption Animation"

L.CastQuickFinish = "Hide Cast bar without animation"

L.ColorByCastbarType = "Border color by cast bar type"

L.Width = "Width"
L.Height = "Height"

L.PlayerCastingBarFrame = "Player Castbar"
L.TargetFrameSpellBar = "Target Castbar"
L.FocusFrameSpellBar = "Focus Castbar"
L.BossTargetFrames = "Boss Castbar"

L.ShieldIconTexture = "Uninteraptable Icon"

L.EnableSpellTargetName = "Show Spell Target"

L.SpellTargetFont = "Spell Target Font"
L.SpellTargetSize = "Spell Target Font Size"

L.CastBarsFontDesc = "Customize font of a cast Name, Timer and Target."

L.TimerFont = "Timer Font"

L.FontTimerSize = "Timer font Size"

L.UseCustomBGColor = "Custom background color"

L.CDMAuraRemoveSwipe = "Don't show Aura"

L.CDMAuraShowSwipe = "Show Swipe Animation"
L.CDMAuraShowTimer = "Show Timer"
L.CDMAuraShowStacks = "Show Stacks"
L.CDMAuraShowEdge = "Show Edge"

L.JustifyH = "Horizontal text Justification"

L.AlwaysShow = "Always Show"
L.ShowOnAura = "Show only with Aura"
L.ShowOnAuraAndCD = "Show with Fake Aura or CD"

L.AttachTitle = "Frame Attach Options"
L.AttachDesc = "Select the frame and anchor point to attach to"

L.EnableAttach = "Enable frame Attachment"
L.CDMCustomFrameAttachFrameName = "Attach to frame:"
L.FramePickerSelect = "Select"
L.CDMCutomFrameAttachPoint = "Attach Point"
L.CDMCutomFrameAttachOffset = "Attach point Offset"

L.ShowCountdownNumbersForCharges = "Show charge countdown numbers"

L.AnchorPosOK = "Anchor is |cff0bbe76ОК"
L.AnchorPosUNSAVED = "|cffff0000UNSAVED!|r\nEXIT Edit Mode to save Anchor"
L.AnchorPosAttached = "Attached to frame:|cff0bbe76"

L.CreateIconsFrame = "Create Icons frame"
L.CreateAuraFrame = "Create Aura frame"
L.CreateBarsFrame = "Create Bars frame"
L.CreateChargeBarsFrame = "Create Charge Bars frame"

L.SetStages = "Max Charges"
L.SetStagesDesc = "Maximum number of Charges for this Aura."
L.Stages = "Custom Charges"
L.EnableStackThreshold = "Enable Stack Threshold"
L.StackThresholdValue = "Stacks"
L.StackThresholdsTitle = "Stack Thresholds"
L.AddStackThreshold = "Add Threshold"
L.RemoveStackThreshold = "Remove"
L.StackThresholdsTooltip = "If multiple thresholds are crossed, the highest one takes precedence."

L.ConfigureRacials = "Configure Racials"

L.FakeAuraTypesTitle = "Aura refresh behavior"
L.FakeAuraTypeNone = "None (Do nothing)"
L.FakeAuraTypeAdd = "Add (Adds full timer to remaining duration)"
L.FakeAuraTypeReset = "Reset (Reset to full duration)"

L.CooldownFormatType = "Timer Rounding"
L.CDFormatFloor = "Round down"
L.CDFormatCeil = "Round up"
L.CooldownTimerFormat = "Timer Format"
L.CDFormatAuto = "Auto (12m / 09:14 / 10 / 3.2)"
L.CDFormatMmSs = "mm:ss (12:14 / 09:14 / 10 / 3.2)"
L.CDFormatMinutesSeconds = "Xm Xs (9m 14s / 10s / 3.2)"
L.CDFormatSecondsOnly = "Seconds only (554 / 10 / 3.2)"
L.CooldownMilliseconds = "Show milliseconds"
L.CooldownMillisecondsBelow = "Below (sec)"

L.BarDisplayTitle = "Bar Display Type"
L.BarDisplayDesc = "This bar will display:"
L.BarDisplayOnCD = "Only Cooldown"
L.BarDisplayOnAura = "Only Aura"
L.BarDisplayOnAuraAndCD = "Aura, then Cooldown"

L.EnableName = "Enable Name"
L.EnableStacks = "Enable Stacks"
L.AlwaysShowStacks = "Always show Stacks"
L.EnableTimer = "Enable Timer"

L.RealAuraDisabled = "Real Aura disabled because FakeAura was set"

L.ConfigureAura = "Configure Aura"

L.FakeAuraTimer = "Fake Aura Timer:"
L.RealAuraID = "Aura SpellID"

L.LockedInCombat = "Settings are locked in combat"

-- ==========================================
-- Custom Frame Spec Visibility
-- ==========================================
L.SpecVisibilityDialogTitle = "Show on Specializations"
L.SpecVisibilitySave = "Save"
L.SpecVisibilityCancel = "Cancel"

L.ExtraZoneAbility = "Extra/Zone Buttons"
L.ExtraZoneAbilityTitle = "Extra Action Button & Zone Ability"
L.ExtraZoneAbilityDesc = "Enable skinning and choose the artwork for Extra Action Button and Zone Ability buttons"
L.ExtraZoneAbilityEnable = "Enable Extra/Zone buttons skin"
L.ExtraZoneAbilityArt = "Button Art"

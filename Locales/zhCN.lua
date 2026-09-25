if (GAME_LOCALE or GetLocale()) ~= "zhCN" then return end

local AddonName, Addon = ...

local L = {}

Addon.L = L

-- ==========================================
-- 欢迎信息
-- ==========================================
L.welcomeMessage1 = "感谢使用 |cff1df2a8HUI|r"
L.welcomeMessage2 = "你可以使用 |cff1df2a8/"

-- ==========================================
-- 通用设置
-- ==========================================
L.Enable = "启用"
L.GlobalSettings = "全局设置"

-- ==========================================
-- 动作条
-- ==========================================
L.MainActionBar = "动作条 1"
L.MultiBarBottomLeft = "动作条 2"
L.MultiBarBottomRight = "动作条 3"
L.MultiBarRight = "动作条 4"
L.MultiBarLeft = "动作条 5"
L.MultiBar5 = "动作条 6"
L.MultiBar6 = "动作条 7"
L.MultiBar7 = "动作条 8"
L.PetActionBar = "宠物条"
L.StanceBar = "姿态栏"
L.BagsBar = "背包栏"
L.MicroMenu = "微型菜单"

-- ==========================================
-- 动作条设置
-- ==========================================
L.ActionBarSettingTitle = "动作条额外设置"
L.ActionBarSettingDesc = "为动作条选择扩展方向、按钮间距以及布局样式（居中或默认）。"

-- ==========================================
-- 触发发光效果
-- ==========================================
L.GlowTypeTitle = "触发循环发光"
L.GlowTypeDesc = "选择触发循环动画"
L.GlowType = "触发循环发光类型"

L.ProcStartTitle = "触发开始发光"
L.ProcStartDesc = "选择或隐藏触发开始动画"
L.HideProcAnim = "隐藏触发开始动画"
L.StartProcType = "开始触发动画类型"

L.AssistTitle = "战斗辅助高亮发光"
L.AssistDesc = "选择战斗辅助高亮动画"
L.AssistType = "辅助高亮类型"
L.AssistAltType = "辅助次要高亮类型"

L.UseCustomColor = "使用自定义颜色"
L.Desaturate = "去饱和度"

-- ==========================================
-- 淡出条
-- ==========================================
L.FadeTitle = "淡出条"
L.FadeDesc = "启用条的淡出效果并配置其淡入时机。"
L.FadeOutBars = "启用条的淡入/淡出"
L.FadeInOnCombat = "战斗中淡入"
L.FadeInOnTarget = "有目标时淡入"
L.FadeInOnCasting = "施法时淡入"
L.FadeInOnHover = "鼠标悬停时淡入"

-- ==========================================
-- 按钮材质
-- ==========================================
L.NormalTitle = "边框材质样式"
L.NormalDesc = "按钮的边框材质。"
L.NormalTextureType = "边框材质类型"

L.BackdropTitle = "背景材质样式"
L.BackdropDesc = "按钮的背景材质。"
L.BackdropTextureType = "背景材质类型"

L.IconTitle = "图标遮罩样式"
L.IconDesc = "选择遮罩材质并调整遮罩和图标缩放"
L.IconMaskTextureType = "图标遮罩材质类型"
L.IconMaskScale = "修改图标遮罩缩放"
L.IconScale = "修改图标缩放"

L.PushedTitle = "按下时材质样式"
L.PushedDesc = "按下按钮时显示的材质。"
L.PushedTextureType = "按下材质类型"

L.HighlightTitle = "高亮材质样式"
L.HighlightDesc = "鼠标悬停在按钮上时显示的材质。"
L.HighliteTextureType = "高亮材质类型（鼠标悬停）"

L.CheckedTitle = "选中材质样式"
L.CheckedDesc = "成功使用技能或技能在队列中时显示的材质。"
L.CheckedTextureType = "选中材质类型"

-- ==========================================
-- 冷却设置
-- ==========================================
L.CooldownTitle = "冷却自定义"
L.CooldownDesc = "调整冷却字体、旋转扫掠和边缘效果。"
L.SwipeTextureType = "冷却扫掠材质类型"
L.SwipeSize = "冷却扫掠材质尺寸"
L.CustomSwipeColor = "冷却扫掠使用自定义颜色"

L.EdgeTextureType = "冷却边缘材质类型"
L.EdgeSize = "冷却边缘材质尺寸"
L.CustomEdgeColor = "冷却边缘使用自定义颜色"
L.EdgeAlwaysShow = "始终显示冷却边缘"

L.CooldownFont = "选择冷却字体"
L.CooldownFontSize = "冷却字体大小"
L.FontColor = "字体颜色"

-- ==========================================
-- 颜色覆盖
-- ==========================================
L.ColorOverrideTitle = "按钮状态颜色覆盖"
L.ColorOverrideDesc = "自定义不同按钮状态的颜色。"
L.CustomColorOOR = "距离过远的自定义颜色"
L.CustomColorOOM = "法力不足的自定义颜色"
L.CustomColorNoUse = "无法使用法术的自定义颜色"

L.CustomColorGCD = "处于公共冷却的自定义颜色"
L.CustomColorCD = "处于冷却的自定义颜色"
L.CustomColorNormal = "正常状态的自定义颜色"
L.CustomColorAura = "带有光环的自定义颜色"

L.RemoveOORColor = "移除距离过远颜色"
L.RemoveOOMColor = "移除法力不足颜色"
L.RemoveNUColor = "移除无法使用颜色"
L.RemoveDesaturation = "移除去饱和度"

-- ==========================================
-- 隐藏框架与动画
-- ==========================================
L.HideFrameTitle = "隐藏框架与动画"
L.HideFrameDesc = "隐藏动作条上的各种框架和烦人动画。"
L.HideBagsBar = "隐藏背包栏"
L.HideMicroMenuBar = "隐藏微型菜单栏"
L.HideStanceBar = "隐藏姿态栏"
L.HideTalkingHead = "隐藏剧情对话头像"
L.HideInterrupt = "隐藏按钮上的打断动画"
L.HideCasting = "隐藏按钮上的施法动画"
L.HideReticle = "隐藏按钮上的范围性法术指示动画"

-- ==========================================
-- 字体选项
-- ==========================================
L.FontTitle = "字体选项"
L.FontDesc = "自定义快捷键和堆叠数量的字体。"
L.FontHotKeyScale = "修改快捷键缩放（适用于小按钮）"
L.FontStacksScale = "修改堆叠数量缩放（适用于小按钮）"
L.FontHideName = "隐藏按钮（宏）名称"
L.FontNameScale = "修改名称缩放（适用于小按钮）"

L.HotKeyFont = "选择快捷键字体"
L.HotkeyOutline = "快捷键描边类型"
L.HotkeyShadowColor = "快捷键字体阴影"
L.HotkeyShadowOffset = "快捷键字体阴影偏移"
L.FontHotkeySize = "选择快捷键字体大小"
L.HotkeyAttachPoint = "选择快捷键附着点"
L.HotkeyOffset = "选择快捷键偏移"
L.HotkeyCustomColor = "快捷键自定义颜色"

L.StacksFont = "选择堆叠数量字体"
L.StacksOutline = "堆叠数量描边类型"
L.StacksShadowColor = "堆叠数量字体阴影"
L.StacksShadowOffset = "堆叠数量字体阴影偏移"
L.FontStacksSize = "选择堆叠数量字体大小"
L.StacksAttachPoint = "选择堆叠数量附着点"
L.StacksOffset = "选择堆叠数量偏移"
L.StacksCustomColor = "堆叠数量自定义颜色"

-- ==========================================
-- 配置文件
-- ==========================================
L.ProfilesHeaderText = "你可以更改当前使用的数据库配置文件，以便为每个角色保存不同的设置。\n如果配置损坏或你想重新开始，可以将当前配置文件重置为默认值。"
L.ProfilesCopyText = "将现有配置文件中的设置复制到当前使用的配置文件中。"
L.ProfilesDeleteText = "从数据库中删除现有且未使用的配置文件以节省空间，并清理 SavedVariables 文件。"
L.ProfilesImportText = "通过简单的字符串分享你的配置文件或导入他人的配置文件。"

-- ==========================================
-- WeakAuras 整合
-- ==========================================
L.WAIntTitle = "WeakAuras 整合"
L.WAIntDesc = "为 WeakAuras 的发光效果选择触发和循环覆盖。\n这将影响类型为'触发发光'的光环发光效果"
L.ModifyWAGlow = "修改 WA 发光"
L.WAProcType = "WA 触发类型"
L.WALoopType = "WA 循环类型"
L.AddWAMask = "为 WA 图标添加遮罩"

-- ==========================================
-- 快速预设
-- ==========================================
L.PresetActive = "已激活"
L.PresetSelect = "选择"

-- ==========================================
-- 复制/粘贴功能
-- ==========================================
L["Copied: %s"] = "已复制: %s"
L["Pasted: %s → %s"] = "已粘贴: %s → %s"
L.CopyText = "点击复制"
L.PasteText = "点击粘贴"
L.CancelText = "点击取消"

-- ==========================================
-- 冷却监视器视图类型
-- ==========================================
L.EssentialCooldownViewer   = "核心框架"
L.UtilityCooldownViewer     = "功能框架"
L.BuffIconCooldownViewer    = "增益图标"
L.BuffBarCooldownViewer     = "增益条"

-- ==========================================
-- 冷却监视器基本设置
-- ==========================================
L.IconPadding = "图标间距"
L.CDMBackdrop = "添加边框"
L.CDMCenteredGrid = "图标居中"
L.MinimapButton = "显示小地图按钮"
L.UsePixelPerfect = "使用 PixelPerfect"
L.CDMRemoveIconMask = "移除图标遮罩"
L.CDMRemovePandemic = "移除流行病动画"
L.CDMSwipeColor = "冷却扫掠颜色"
L.CDMAuraSwipeColor = "光环扫掠颜色"
L.CDMBackdropColor = "边框颜色"
L.CDMBackdropAuraColor = "光环边框颜色"
L.CDMBackdropPandemicColor = "流行病边框颜色"
L.CDMReverseSwipe = "反转冷却填充方向"
L.CDMRemoveAuraTypeBorder = "移除光环类型边框"

-- ==========================================
-- 状态条设置
-- ==========================================
L.CDMBarContainerTitle = "状态条设置"
L.CDMBarContainerDesc = "自定义状态条的外观和布局。"
L.StatusBarTextures = "状态条材质"
L.FontNameSize = "名称字体大小"
L.StatusBarBGTextures = "背景材质"

-- ==========================================
-- 状态条布局设置
-- ==========================================
L.BarGrow = "扩展方向"
L.RightClickPassThrough = "右键点击穿透按钮"
L.NameFont = "名称字体"
L.IconSize = "图标大小"
L.BarHeight = "状态条高度"
L.BarPipSize = "火花大小"
L.BarPipTexture = "火花材质"
L.BarOffset = "状态条附着偏移"

-- ==========================================
-- CDM 额外设置
-- ==========================================
L.CDMItemSize = "物品大小"
L.CDMRemoveGCDSwipe = "移除公共冷却扫掠动画"
L.CDMAuraReverseSwipe = "反转光环填充方向"

L.CDMCooldownTitle = "冷却自定义"
L.CDMCooldownDesc = "修改 CDM 的冷却外观"

L.IconBorderTitle = "边框设置"
L.IconBorderDesc = "创建并配置像素边框。"

L.CDMOptionsTitle = "CDM 额外选项"
L.CDMOptionsDesc = "全局启用覆盖标准 CDM 参数的额外设置"

-- ========================================
-- 未分类项
-- ========================================
L.CDMAuraTimerColor = "光环计时器颜色"

L.CDMCustomFrameTitle = "自定义 CDM 框架"
L.CDMCustomFrameDesc = "配置一个自定义框架来追踪法术或物品。你可以通过右键菜单设置光环计时器。"

L.CDMCustomPingTitle = "框架 Ping 标记"
L.CDMCustomPingDesc = "允许暴雪 Ping 系统从自定义框架 Ping 法术或物品状态（按住 Ping 键并点击框架）。"

L.CDMCustomFrameName = "框架名称"

L.CDMCustomFrameDelete = "删除自定义框架"
L.Delete = "删除"

L.CDMCustomFrameAddSpellByID = "通过 ID 添加法术"
L.CDMCustomFrameAddItemByID = "通过 ID 添加物品"

L.CDMCustomFrameTrackSlot13 = "添加饰品 #1（栏位 13）"
L.CDMCustomFrameTrackSlot14 = "添加饰品 #2（栏位 14）"
L.CDMCustomFrameTrackSlot16 = "添加武器 #1（栏位 16）"
L.CDMCustomFrameTrackSlot17 = "添加武器 #2（栏位 17）"
L.CDMCustomFrameTrackRacial = "添加种族技能"

L.CDMCustomFrameHideWhen0 = "数量为 0 时隐藏"

L.CDMCustomFrameAlphaOnCD = "不在冷却时的透明度"

L.CDMCustomFrameGridLayoutTitle = "框架网格布局"
L.CDMCustomFrameGridLayoutDesc = "设置物品大小、间距、最大列数和扩展方向。"

L.CDMCustomFrameElementSize = "图标大小"

L.Stride = "最大列数"

L.CenteredLayout = "居中"

L.VerticalGrowth = "垂直扩展"
L.HorizontalGrowth = "水平扩展"

L.GridDirection = "布局方向"

L.FrameStrata = "框架层级"
L.FrameLevel = "框架级别"
L.Level = "级别"

L.DragNDropContainer = "拖拽一个法术或物品到此。\n（左键 - 重新排序，右键 - 菜单，Shift+右键 - 快速移除）"

L.FakeAura = "自定义光环"

L.Confirm = "确认"

L.SetFakeAura = "设置光环计时器"
L.SetFakeAuraDesc = "设置一个 |cff0bbe76秒数|r 计时器，在使用物品/法术时显示（输入 0 或留空以移除计时器）。"

L.QuickPresets = "快速预设"
L.QuickPresetsDesc = "快速应用预设模板。如需详细自定义，请使用高级菜单。"

L.GridCentered = "居中，无间隙"
L.GridCompact = "左/右，无间隙"
L.GridFixed = "左/右，有间隙"

L.GridLayoutType = "网格样式"
L.HideWhenInactive = "可见性"

L.Alpha = "淡出透明度"

L.Scale = "缩放"

L.Size = "大小"

L.OffsetX = "X 轴偏移"
L.OffsetY = "Y 轴偏移"

L.Rows = "行数"
L.Columns = "列数"

L.Buttons = "按钮数"

L.Padding = "间距"

L.Offset = "偏移"

L.SizeX = "X 轴大小"
L.SizeY = "Y 轴大小"

L.AttachPointTOPLEFT = "左上"
L.AttachPointTOP = "顶部"
L.AttachPointTOPRIGHT = "右上"
L.AttachPointBOTTOMLEFT = "左下"
L.AttachPointBOTTOM = "底部"
L.AttachPointBOTTOMRIGHT = "右下"
L.AttachPointLEFT = "左"
L.AttachPointRIGHT = "右"
L.AttachPointCENTER = "中心"

L.FontOutlineNONE = "无"
L.FontOutlineOUTLINE = "描边"
L.FontOutlineTHICKOUTLINE = "粗描边"

L.VerticalGrowthUP = "向上"
L.VerticalGrowthDOWN = "向下"

L.HorizontalGrowthRIGHT = "向右"
L.HorizontalGrowthLEFT = "向左"

L.DirectionHORIZONTAL = "水平"
L.DirectionVERTICAL = "垂直"

L.ColorizedCooldownFont = "按时间着色冷却文本"
L.ColorizedAuraFont = "按时间着色光环文本"

L.AuraSound = "光环声音"
L.AuraSoundTriggerAdded = "施加时"
L.AuraSoundTriggerApplicationsIncreased = "获得层数时"
L.AuraSoundTriggerRemoved = "移除时"
L.AuraSoundNone = "无"
L.AuraSoundPlaySample = "试听"

-- ========================================
-- 施法条
-- ========================================

L.CastBarsOptionsTitle = "施法条选项"
L.CastBarsOptionsDesc = "自定义施法条的大小、材质、颜色和额外选项。"

L.None = "无"
L.Left = "在左侧"
L.Right = "在右侧"
L.LeftAndRight = "在左右两侧"

L.CastBarsIconOptionsTitle = "施法条图标选项"
L.CastBarsIconOptionsDesc = "自定义法术图标外观。"

L.BarIconOptionsTitle = "条图标选项"
L.BarIconOptionsDesc = "自定义条图标外观。"

L.CastBarIconPos = "显示图标"

L.AttachPoint = "附着点"

L.CastBarsSQWLatencyOptionsTitle = "延迟与法术队列窗口"
L.CastBarsSQWLatencyOptionsDesc = "显示当前 |cffe35522延迟|r 与 |cff0bbe76法术队列窗口|r。\n|cff0bbe76法术队列窗口|r 是一种机制，允许在当前法术施放结束前排队下一个技能。默认设置为 400 毫秒。\n更多信息请搜索 |cff0bbe76\"SpellQueueWindow\"|r。"

L.CastBarStandartColor = "常规施法颜色"
L.CastBarImportantColor = "重要施法颜色"
L.CastBarChannelColor = "引导法术颜色"
L.CastBarUninterruptableColor = "不可打断施法颜色"
L.CastBarInterruptedColor = "被打断施法颜色"
L.CastBarReadyColor = "打断技能可用时颜色"

L.CastTimeCurrent = "当前"
L.CastTimeMax = "总计"
L.CastTimeCurrentAndMax = "当前 / 总计"
L.CastTimeRemaining = "剩余"

L.CastTimeFormat = "计时器格式"

L.CastHideTextBorder = "隐藏字体边框"

L.CastHideInterruptAnim = "隐藏打断动画"

L.CastQuickFinish = "无动画快速结束施法条"

L.ColorByCastbarType = "根据施法条类型着色边框"

L.Width = "宽度"
L.Height = "高度"

L.PlayerCastingBarFrame = "玩家施法条"
L.TargetFrameSpellBar = "目标施法条"
L.FocusFrameSpellBar = "焦点施法条"
L.BossTargetFrames = "首领施法条"

L.ShieldIconTexture = "不可打断图标"

L.EnableSpellTargetName = "显示法术目标"

L.SpellTargetFont = "法术目标字体"
L.SpellTargetSize = "法术目标字体大小"

L.CastBarsFontDesc = "自定义施法名称、计时器和目标的字体。"

L.TimerFont = "计时器字体"

L.FontTimerSize = "计时器字体大小"

L.UseCustomBGColor = "自定义背景颜色"

L.CDMAuraRemoveSwipe = "不显示光环"

L.CDMAuraShowSwipe = "显示扫掠动画"
L.CDMAuraShowTimer = "显示计时器"
L.CDMAuraShowStacks = "显示堆叠数量"
L.CDMAuraShowEdge = "显示边缘"

L.JustifyH = "水平文本对齐"

L.AlwaysShow = "始终显示"
L.ShowOnAura = "仅在有光环时显示"
L.ShowOnAuraAndCD = "有光环或冷却时显示"

L.AttachTitle = "框架附着选项"
L.AttachDesc = "选择要附着的框架和锚点"

L.EnableAttach = "启用框架附着"
L.CDMCustomFrameAttachFrameName = "附着到框架："
L.FramePickerSelect = "选择"
L.CDMCutomFrameAttachPoint = "附着点"
L.CDMCutomFrameAttachOffset = "附着点偏移"

L.ShowCountdownNumbersForCharges = "显示充能倒计时数字"

L.AnchorPosOK = "锚点位置 |cff0bbe76正常"
L.AnchorPosUNSAVED = "|cffff0000未保存！|r\n退出编辑模式以保存锚点"
L.AnchorPosAttached = "已附着到框架：|cff0bbe76"

L.CreateIconsFrame = "创建图标框架"
L.CreateBarsFrame = "创建状态条框架"
L.CreateChargeBarsFrame = "创建充能条框架"

L.SetStages = "最大充能数"
L.SetStagesDesc = "此光环的最大充能数量。"
L.Stages = "自定义充能"
L.EnableStackThreshold = "启用堆叠阈值"
L.StackThresholdValue = "层数"
L.StackThresholdsTitle = "堆叠阈值"
L.AddStackThreshold = "添加阈值"
L.RemoveStackThreshold = "移除"
L.StackThresholdsTooltip = "如果跨过了多个阈值，以最高的阈值为准。"

L.AlwaysShowStacks = "始终显示堆叠数量"

L.ConfigureRacials = "配置种族技能"

L.FakeAuraTypesTitle = "光环刷新行为"
L.FakeAuraTypeNone = "无（不执行任何操作）"
L.FakeAuraTypeAdd = "累加（将完整计时器添加到剩余持续时间）"
L.FakeAuraTypeReset = "重置（重置为完整持续时间）"

L.CooldownFormatType = "计时器取整"
L.CDFormatFloor = "向下取整"
L.CDFormatCeil = "向上取整"
L.CooldownTimerFormat = "计时器格式"
L.CDFormatAuto = "自动 (12m / 09:14 / 10 / 3.2)"
L.CDFormatMmSs = "mm:ss (12:14 / 09:14 / 10 / 3.2)"
L.CDFormatMinutesSeconds = "Xm Xs (9m 14s / 10s / 3.2)"
L.CDFormatSecondsOnly = "仅秒数 (554 / 10 / 3.2)"
L.CooldownMilliseconds = "显示毫秒"
L.CooldownMillisecondsBelow = "低于（秒）"
-- ==========================================
-- Custom Frame Spec Visibility
-- ==========================================
L.SpecVisibilityDialogTitle = "显示于专精"
L.SpecVisibilitySave = "保存"
L.SpecVisibilityCancel = "取消"

L.ExtraZoneAbility = "Extra/Zone 按钮"
L.ExtraZoneAbilityTitle = "Extra Action Button 与 Zone Ability"
L.ExtraZoneAbilityDesc = "启用皮肤并选择 Extra Action Button 和 Zone Ability 按钮的美术样式"
L.ExtraZoneAbilityEnable = "启用 Extra/Zone 按钮皮肤"
L.ExtraZoneAbilityArt = "按钮美术样式"

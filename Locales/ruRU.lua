if (GAME_LOCALE or GetLocale()) ~= "ruRU" then return end

local AddonName, Addon = ...

local L = {}

Addon.L = L

-- ==========================================
-- Welcome Messages
-- ==========================================
L.welcomeMessage1 = "Спасибо за использование |cff1df2a8HUI|r"
L.welcomeMessage2 = "Вы можете открыть настройки командой |cff1df2a8/"

-- ==========================================
-- General Settings
-- ==========================================
L.Enable = "Использовать"
L.GlobalSettings = "Общие настройки"

-- ==========================================
-- Action Bars
-- ==========================================
L.MainActionBar = "Панель команд 1"
L.MultiBarBottomLeft = "Панель команд 2"
L.MultiBarBottomRight = "Панель команд 3"
L.MultiBarRight = "Панель команд 4"
L.MultiBarLeft = "Панель команд 5"
L.MultiBar5 = "Панель команд 6"
L.MultiBar6 = "Панель команд 7"
L.MultiBar7 = "Панель команд 8"
L.PetActionBar = "Панель пета"
L.StanceBar = "Панель стоек"
L.BagsBar = "Панель сумок"
L.MicroMenu = "Микроменю"

-- ==========================================
-- Action Bars Settings
-- ==========================================
L.ActionBarSettingTitle = "Дополнительне настройки панелей"
L.ActionBarSettingDesc = "Выберите направление роста, отступ между кнопками и стиль компоновки (по центру или по умолчанию) для панели команд."

-- ==========================================
-- Proc Glow Effects
-- ==========================================
L.GlowTypeTitle = "Анимации прока"
L.GlowTypeDesc = "Настройка анимации прока"
L.GlowType = "Тип цикличного свечения"

L.ProcStartTitle = "Стартовое свечение прока"
L.ProcStartDesc = "Отключить или изменить тип и цвет стартовой анимации прока"
L.HideProcAnim = "Скрыть начальную анимацию прока"
L.StartProcType = "Тип начальной анимации прока"

L.AssistTitle = "Свечение Боевого Помощника"
L.AssistDesc = "Выбрать тип и цвет основного и дополнительного свечения"
L.AssistType = "Тип основного свечения"
L.AssistAltType = "Тип второстепенного свечения"

L.UseCustomColor = "Свой цвет"
L.Desaturate = "Обесцветить"

-- ==========================================
-- Fade Bars
-- ==========================================
L.FadeTitle = "Скрытие панелей"
L.FadeDesc = "Активировать скрытие панелей и настроить условия отображения."
L.FadeOutBars = "Использовать прозрачность панелей"
L.FadeInOnCombat = "Показывать в бою"
L.FadeInOnTarget = "Показывать при наличии цели"
L.FadeInOnCasting = "Показывать во время каста"
L.FadeInOnHover = "Показывать при наведении мыши"

-- ==========================================
-- Button Textures
-- ==========================================
L.NormalTitle = "Рамка кнопок"
L.NormalDesc = "Выбрать тип, цвет и прозрачность рамки кнопок."
L.NormalTextureType = "Тип рамки кнопок"

L.BackdropTitle = "Фон кнопок"
L.BackdropDesc = "Выбрать тип, цвет и прозрачность фона кнопок."
L.BackdropTextureType = "Тип фона кнопок"

L.IconTitle = "Маска иконок"
L.IconDesc = "Выбрать тип маски, настроить масштаб маски и иконок."
L.IconMaskTextureType = "Тип маски"
L.IconMaskScale = "Масштаб маски"
L.IconScale = "Масштаб иконок"

L.PushedTitle = "Стиль текстуры нажатой кнопки"
L.PushedDesc = "Эта текстура отображается в момент нажатия кнопки."
L.PushedTextureType = "Текстура нажатой кнопки"

L.HighlightTitle = "Стиль текстуры подсветки"
L.HighlightDesc = "Эта текстура отображается в момент наведения курсора на кнопку."
L.HighliteTextureType = "Текстура при наведении мыши"

L.CheckedTitle = "Стиль текстуры активной кнопки"
L.CheckedDesc = "Текстура примененного заклинания или если оно находится в очереди заклинаний."
L.CheckedTextureType = "Текстура активной кнопки"

-- ==========================================
-- Cooldown Settings
-- ==========================================
L.CooldownTitle = "Кастомизация Кулдауна"
L.CooldownDesc = "Изменить внешний вид кулдауна."
L.SwipeTextureType = "Текстура Swipe"
L.SwipeSize = "Размер текстуры Swipe"
L.CustomSwipeColor = "Свой цвет Swipe"

L.EdgeTextureType = "Текстура Edge"
L.EdgeSize = "Размер текстуры Edge"
L.CustomEdgeColor = "Свой цвет Edge"
L.EdgeAlwaysShow = "Всегда показывать Edge"

L.CooldownFont = "Шрифт Кулдауна/Ауры/Таймера"
L.CooldownFontSize = "Размер шрифта"
L.FontColor = "Цвет шрифта"

-- ==========================================
-- Color Override
-- ==========================================
L.ColorOverrideTitle = "Цвет статуса кнопки"
L.ColorOverrideDesc = "Выбрать цвет для некоторых статусов кнопки."
L.CustomColorCooldownSwipe = "Использовать свой цвет для кудлауна"
L.CustomColorOOR = "Свой цвет Out Of Range"
L.CustomColorOOM = "Свой цвет Out Of Mana"
L.CustomColorNoUse = "Свой цвет если кнопка недоступна"
L.CustomColorGCD = "Свой цвет если спелл на ГКД"
L.CustomColorCD = "Свой цвет если спелл на КД"
L.CustomColorNormal = "Свой цвет для обычного состояния"
L.CustomColorAura = "Свой цвет если активна Аура"

L.RemoveOORColor = "Убрать цвет OOR"
L.RemoveOOMColor = "Убрать цвет OOM"
L.RemoveNUColor = "Убрать цвет NU"
L.RemoveDesaturation = "Убрать обесцвечивание"

-- ==========================================
-- Hide Frames and Animations
-- ==========================================
L.HideFrameTitle = "Скрытие панелей и анимаций"
L.HideFrameDesc = "Отключить отображение панелей и раздражающих анимаций на панели способностей."
L.HideBagsBar = "Скрывать панель сумок"
L.HideMicroMenuBar = "Скрывать микроменю"
L.HideStanceBar = "Скрывать панель стоек"
L.HideTalkingHead = "Скрывать Говорящую Голову"
L.HideInterrupt = "Скрывать анимацию прерывания"
L.HideCasting = "Скрывать анимацию каста на кнопке"
L.HideReticle = "Скрывать анимацию АОЕ на кнопке"

-- ==========================================
-- Font Options
-- ==========================================
L.FontTitle = "Настройки шрифтов"
L.FontDesc = "Кастомизация шрифтов кнопок/иконок."
L.FontHotKeyScale = "Масштаб текста Хоткея (мелкие кнопки)"
L.FontStacksScale = "Масштаб текста Стаков (мелкие кнопки)"
L.FontHideName = "Скрыть Название кнопки (макроса)"
L.FontNameScale = "Масштаб Названия (мелкие кнопки)"

L.HotKeyFont = "Шрифт Хоткея"
L.HotkeyOutline = "Обводка текста Хоткея"
L.HotkeyShadowColor = "Тень текста Хоткея"
L.HotkeyShadowOffset = "Смещение Тени текста Хоткея"
L.FontHotkeySize = "Размер Шрифта Хоткея"
L.HotkeyAttachPoint = "Точка крепления текста Хоткея"
L.HotkeyOffset = "Смещение крепления текста Хоткея"
L.HotkeyCustomColor = "Свой цвет текста Хоткея"

L.StacksFont = "Шрифт Стаков"
L.StacksOutline = "Обводка текста Стаков"
L.StacksShadowColor = "Тень текста Стаков"
L.StacksShadowOffset = "Смещение Тени текста Стаков"
L.FontStacksSize = "Размер Шрифта Стаков"
L.StacksAttachPoint = "Точка крепления текста Стаков"
L.StacksOffset = "Смещение крепления текста Стаков"
L.StacksCustomColor = "Свой цвет текста Стаков"

-- ==========================================
-- Profiles
-- ==========================================
L.ProfilesHeaderText = "Вы можете изменить активный профиль, чтобы иметь разные настройки для каждого персонажа.\nСбросьте текущий профиль к значениям по умолчанию на случай, если ваша конфигурация повреждена или вы просто хотите начать заново."
L.ProfilesCopyText = "Скопируйте настройки из одного существующего профиля в текущий активный профиль."
L.ProfilesDeleteText = "Удалите существующие и неиспользуемые профили из базы данных для экономии места и очистки файла SavedVariables."
L.ProfilesImportText = "Поделитесь своим профилем или импортируйте чужой с помощью простой строки."

-- ==========================================
-- WeakAuras Integration
-- ==========================================
L.WAIntTitle = "WeakAuras Интеграция"
L.WAIntDesc = "Изменить тип начальной и цикличной анимации свечения WA.\nИзменит только те ауры, которые имеют свечение 'Свечение при активации'"
L.ModifyWAGlow = "Включить модификацию свечения WA"
L.WAProcType = "Тип начальной анимации свечения WA"
L.WALoopType = "Тип цикличной анимации свечения WA"
L.AddWAMask = "Добавить маску для иконок WA"

-- ==========================================
-- Quick Presets
-- ==========================================
L.PresetActive = "Активно"
L.PresetSelect = "Выбрать"

-- ==========================================
-- Copy/Paste Functions
-- ==========================================
L["Copied: %s"] = "Скопировано: %s"
L["Pasted: %s → %s"] = "Вставлено: %s → %s"
L.CopyText = "Копировать"
L.PasteText = "Вставить"
L.CancelText = "Отменить"

-- ==========================================
-- Cooldown Manager Viewer Types
-- ==========================================
L.EssentialCooldownViewer   = "Основные"
L.UtilityCooldownViewer     = "Утилити"
L.BuffIconCooldownViewer    = "Баффы"
L.BuffBarCooldownViewer     = "Полоски"

-- ==========================================
-- Cooldown Manager Basic Settings
-- ==========================================
L.IconPadding = "Расстояние между иконками"
L.CDMBackdrop = "Добавить границу"
L.CDMCenteredGrid = "Центрировать иконки"
L.MinimapButton = "Отображать кнопку на миникарте"
L.UsePixelPerfect = "Использовать PixelPerfect"
L.CDMRemoveIconMask = "Убрать маску иконки"
L.CDMRemovePandemic = "Убрать анимацию пандемика"
L.CDMSwipeColor = "Цвет Swipe анимации кулдауна"
L.CDMAuraSwipeColor = "Цвет Swipe анимации ауры"
L.CDMBackdropColor = "Цвет границы"
L.CDMBackdropAuraColor = "Цвет границы для ауры"
L.CDMBackdropPandemicColor = "Цвет границы для пандемика"
L.CDMReverseSwipe = "Обратное заполнение кулдауна"
L.CDMRemoveAuraTypeBorder = "Убрать рамку типа Ауры"

-- ==========================================
-- Status Bar Settings
-- ==========================================
L.CDMBarContainerTitle = "Настройки полосок"
L.CDMBarContainerDesc = "Настройте внешний вид и расположение полосок."
L.StatusBarTextures = "Текстура полоски"
L.FontNameSize = "Размер шрифта названия"
L.StatusBarBGTextures = "Текстура фона"

-- ==========================================
-- Bar Layout Settings
-- ==========================================
L.BarGrow = "Направление роста"
L.RightClickPassThrough = "Правый клик проходит сквозь кнопки"
L.NameFont = "Шрифт названия"
L.IconSize = "Размер иконки"
L.BarHeight = "Высота полоски"
L.BarPipSize = "Размер искры"
L.BarPipTexture = "Текстура искры"
L.BarOffset = "Смещение крепления полоски"

-- ==========================================
-- CDM Additional Settings
-- ==========================================
L.CDMItemSize = "Размер иконки"
L.CDMRemoveGCDSwipe = "Убрать Swipe анимацию на ГКД"
L.CDMAuraReverseSwipe = "Обратное заполнение ауры"

L.CDMCooldownTitle = "Кастомизация кулдауна"
L.CDMCooldownDesc = "Изменить внешний вид кулдауна для CDM."

L.IconBorderTitle = "Настройка границ"
L.IconBorderDesc = "Создание и настройка нового фрейма для отрисовки границы."

L.CDMOptionsTitle = "Дополнительные настройки CDM"
L.CDMOptionsDesc = "Глобальное включение дополнительных настроек, перезаписывающих стандартные параметры CDM."





-- ========================================
-- Unsorted
-- ========================================
L.CDMAuraTimerColor = "Цвет таймера ауры"

L.CDMCustomFrameTitle = "Кастомный фрейм CDM"
L.CDMCustomFrameDesc = "Настройка кастомного фрейма для отслеживания способностей или предметов. В контекстном меню можно задать таймер ауры."

L.CDMCustomPingTitle = "Пинг по кастомным фреймам"
L.CDMCustomPingDesc = "Разрешает системе пинга Blizzard пинговать состояние способности или предмета с кастомных фреймов (зажмите клавишу пинга и кликните по фрейму)."

L.CDMCustomFrameName = "Название фрейма"

L.CDMCustomFrameDelete = "Удалить кастомный фрейм"
L.Delete = "УДАЛИТЬ"

L.CDMCustomFrameAddSpellByID = "Добавить Заклинание по ID"
L.CDMCustomFrameAddItemByID = "Добавить Предмет по ID"

L.CDMCustomFrameTrackSlot13 = "Добавить Тринкет #1 (13 слот)"
L.CDMCustomFrameTrackSlot14 = "Добавить Тринкет #2 (14 слот)"
L.CDMCustomFrameTrackSlot16 = "Добавить Оружие #1 (16 слот)"
L.CDMCustomFrameTrackSlot17 = "Добавить Оружие #2 (17 слот)"
L.CDMCustomFrameTrackRacial = "Добавить Расовую способность"

L.CDMCustomFrameHideWhen0 = "Скрывать если количество 0"

L.CDMCustomFrameAlphaOnCD = "Прозрачность если НЕ на КД"

L.CDMCustomFrameGridLayoutTitle = "Настройка сетки фрейма"
L.CDMCustomFrameGridLayoutDesc = "Выбрать размер элемента, расстояние между элементами, количество столбцов и направление роста."

L.CDMCustomFrameElementSize = "Размер одного элемента"

L.Stride = "Макс. количество столбцов"

L.CenteredLayout = "Центрировать"

L.VerticalGrowth = "Вертикальный рост"

L.HorizontalGrowth = "Горизонтальный рост"

L.GridDirection = "Расположение"

L.FrameStrata = "Слой фрейма"
L.FrameLevel = "Уровень фрейма"
L.Level = "Уровень"

L.DragNDropContainer = "Перетащить Предмет или Заклинание.\n(ЛКМ - перестановка, ПКМ - меню, шифт-ПКМ - быстрое удаление)"

L.FakeAura = "Таймер ауры"

L.Confirm = "ПОДТВЕРДИТЬ"

L.SetFakeAura = "Свой таймер ауры"
L.SetFakeAuraDesc = "Назначить таймер в |cff0bbe76СЕКУНДАХ|r, отображаемый при использовании предмета/заклинания (0 или пустая строка для удаления таймера)"

L.QuickPresets = "Профили"
L.QuickPresetsDesc = "Быстрый выбор Профиля. Детальная настройка профиля в меню Advanced."

L.GridCentered = "По центру, скрывать пустые"
L.GridCompact = "По краю, скрывать пустые"
L.GridFixed = "По краю, показывать пустые"

L.GridLayoutType = "Расположение иконок"

L.HideWhenInactive = "Видимость"

L.Alpha = "Прозрачность"

L.Scale = "Масштаб"

L.Size = "Размер"

L.OffsetX = "Смещение по X"
L.OffsetY = "Смещение по Y"

L.Rows = "Строки"
L.Columns = "Столбцы"

L.Buttons = "Кнопки"

L.Padding = "Отступ"

L.Offset = "Смещение"

L.SizeX = "Размер X"
L.SizeY = "Размер Y"

L.AttachPointTOPLEFT = "Сверху Слева"
L.AttachPointTOP = "Сверху"
L.AttachPointTOPRIGHT = "Сверху Справа"
L.AttachPointBOTTOMLEFT = "Снизу Слева"
L.AttachPointBOTTOM = "Снизу"
L.AttachPointBOTTOMRIGHT = "Снизу Справа"
L.AttachPointLEFT = "Слева"
L.AttachPointRIGHT = "Справа"
L.AttachPointCENTER = "Центр"

L.FontOutlineNONE = "Нет"
L.FontOutlineOUTLINE = "Обводка"
L.FontOutlineTHICKOUTLINE = "Жирная обводка"

L.VerticalGrowthUP = "Вверх"
L.VerticalGrowthDOWN = "Вниз"

L.HorizontalGrowthRIGHT = "Справа"
L.HorizontalGrowthLEFT = "Слева"

L.DirectionHORIZONTAL = "Горизонтально"
L.DirectionVERTICAL = "Вертикально"
L.ColorizedCooldownFont = "Красить текст КД по времени"
L.ColorizedAuraFont = "Красить текст Ауры по времени"

L.AuraSound = "Звук ауры"
L.AuraSoundTriggerAdded = "При наложении"
L.AuraSoundTriggerApplicationsIncreased = "При получении стака"
L.AuraSoundTriggerRemoved = "При снятии"
L.AuraSoundNone = "Нет"
L.AuraSoundPlaySample = "Прослушать"

-- ========================================
-- Cast Bars
-- ========================================

L.CastBarsOptionsTitle = "Настройки кастбара"
L.CastBarsOptionsDesc = "Кастомизация кастбара"

L.None = "Нет"
L.Left = "Слева"
L.Right = "Справа"
L.LeftAndRight = "Слева и справа"

L.CastBarsIconOptionsTitle = "Иконка кастбара"
L.CastBarsIconOptionsDesc = "Кастомизация иконки кастбара"

L.BarIconOptionsTitle = "Иконка баров"
L.BarIconOptionsDesc = "Кастомизация иконки бара"

L.CastBarIconPos = "Отображать иконку каста"

L.AttachPoint = "Точка крепления"

L.CastBarsSQWLatencyOptionsTitle = "Задержка и Очередь заклинаний"
L.CastBarsSQWLatencyOptionsDesc = "Отображает текущую задержку и окно очереди заклинаний. |cff0bbe76Spell Queue Window|r позволяет поставить в очередь следующую способность до того, как закончится чтение предыдущего. По умолчанию это окно установлено на 400 мс. За доп. инфо выйди с этим вопросом в интернет."

L.CastBarStandartColor = "Цвет обычного заклинания"
L.CastBarImportantColor = "Цвет важного заклинания"
L.CastBarChannelColor = "Цвет потокового заклинания"
L.CastBarUninterruptableColor = "Цвет непрерываемого заклинания"
L.CastBarInterruptedColor = "Цвет прерванного заклинания"
L.CastBarReadyColor = "Цвет заклинания если кик не в кд"


L.CastTimeCurrent = "Текущее"
L.CastTimeMax = "Общее"
L.CastTimeCurrentAndMax = "Текущее / Общее"
L.CastTimeRemaining = "Оставшееся"
L.CastTimeRemainingAndMax = "Оставшееся / Общее"

L.CastTimeFormat = "Формат таймера"

L.CastHideTextBorder = "Скрыть рамку текста"

L.CastHideInterruptAnim = "Скрыть анимацию прерывания"

L.CastQuickFinish = "Скрывать кастбар без анимации"

L.ColorByCastbarType = "Цвет рамки по типу кастбара"

L.Width = "Ширина"
L.Height = "Высота"

L.PlayerCastingBarFrame = "Кастбар игрока"
L.TargetFrameSpellBar = "Кастбар цели"
L.FocusFrameSpellBar = "Кастбар фокуса"
L.BossTargetFrames = "Кастбар босса"

L.ShieldIconTexture = "Иконка непрерываемого заклинания"

L.EnableSpellTargetName = "Отображать цель заклинания"

L.SpellTargetFont = "Шрифт цели заклинания"
L.SpellTargetSize = "Размер шрифта цели заклинания"

L.CastBarsFontDesc = "Настройка шрифтов для названия заклинания, таймера и цели заклинания."

L.AlwaysShow = "Всегда отображать"
L.ShowOnAura = "Только во время ауры"
L.ShowOnAuraAndCD = "Во время Фейк ауры и кд"

L.TimerFont = "Шрифт Таймера"

L.FontTimerSize = "Размер шрифта Таймера"

L.UseCustomBGColor = "Свой цвет фона"

L.CDMAuraRemoveSwipe = "Не показывать ауру"

L.CDMAuraShowSwipe = "Показывать Swipe анимацию"
L.CDMAuraShowTimer = "Показывать таймер"
L.CDMAuraShowStacks = "Показывать стаки"
L.CDMAuraShowEdge = "Показывать эдж"

L.JustifyH = "Горизонтальное выравнивание"

L.EnableAttach = "Использовать привязку к фрейму"
L.CDMCustomFrameAttachFrameName = "Привязать к фрейму:"
L.FramePickerSelect = "Выбрать"
L.CDMCutomFrameAttachPoint = "Точка крепления"
L.CDMCutomFrameAttachOffset = "Смещение точки крепления"

L.ShowCountdownNumbersForCharges = "Показывать время заряда"

L.AnchorPosOK = "Привязка фрейма |cff0bbe76ОК"
L.AnchorPosUNSAVED = "|cffff0000НЕ СОХРАНЕНО!|r\nЗАКРОЙ Редактирование, чтобы сохранить привязку фрейма"
L.AnchorPosAttached = "Привязан к фрейму:\n|cff0bbe76"

L.AttachTitle = "Настройка привязки фрейма"
L.AttachDesc = "Выбор фрейма и точки для крепления."

L.CreateIconsFrame = "Создать фрейм Иконок"
L.CreateAuraFrame = "Создать фрейм Аур"
L.CreateBarsFrame = "Создать фрейм Полосок"
L.CreateChargeBarsFrame = "Создать фрейм Полосок стаков"

L.SetStages = "Максимум стаков"
L.SetStagesDesc = "Максимальное количество стаков, которое будет использоваться для ауры."
L.Stages = "Использовать заряды"
L.EnableStackThreshold = "Включить порог стаков"
L.StackThresholdValue = "Стаков"
L.StackThresholdsTitle = "Пороги стаков"
L.AddStackThreshold = "Добавить порог"
L.RemoveStackThreshold = "Удалить"
L.StackThresholdsTooltip = "Если пересечено несколько порогов, приоритет у старшего."

L.ConfigureRacials = "Отслеживание Расовых"

L.FakeAuraTypesTitle = "Поведение при повторной активации"
L.FakeAuraTypeNone = "Ничего (Ничего не делать)"
L.FakeAuraTypeAdd = "Добавление (Добавить полный таймер к текущему)"
L.FakeAuraTypeReset = "Сброс (Заускает таймер заново)"

L.CooldownFormatType = "Округление таймера"
L.CDFormatFloor = "Округлять вниз"
L.CDFormatCeil = "Округлять вверх"
L.CooldownTimerFormat = "Формат таймера"
L.CDFormatAuto = "Авто (12m / 09:14 / 10 / 3.2)"
L.CDFormatMmSs = "mm:ss (12:14 / 09:14 / 10 / 3.2)"
L.CDFormatMinutesSeconds = "Xm Xs (9m 14s / 10s / 3.2)"
L.CDFormatSecondsOnly = "Только секунды (554 / 10 / 3.2)"
L.CooldownMilliseconds = "Показывать миллисекунды"
L.CooldownMillisecondsBelow = "Ниже (сек)"

L.BarDisplayTitle = "Тип отображения"
L.BarDisplayDesc = "Эта полоска будет отображать:"
L.BarDisplayOnCD = "Только КД"
L.BarDisplayOnAura = "Только Ауру"
L.BarDisplayOnAuraAndCD = "Ауру, затем КД"

L.EnableName = "Показывать Название"
L.EnableStacks = "Показывать Стаки"
L.AlwaysShowStacks = "Всегда показывать стаки"
L.EnableTimer = "Показывать Таймер"

L.RealAuraDisabled = "Аура отключена так как установлена Фейк-аура"

L.ConfigureAura = "Настройка Ауры"

L.FakeAuraTimer = "Таймер Фейк ауры:"
L.RealAuraID = "SpellID Ауры"

L.LockedInCombat = "Настройки заблокированы во время боя"
-- ==========================================
-- Custom Frame Spec Visibility
-- ==========================================
L.SpecVisibilityDialogTitle = "Отображать на специализациях"
L.SpecVisibilitySave = "Сохранить"
L.SpecVisibilityCancel = "Отмена"

L.ExtraZoneAbility = "Extra/Zone кнопки"
L.ExtraZoneAbilityTitle = "Extra Action Button и Zone Ability"
L.ExtraZoneAbilityDesc = "Включить скинование и выбрать оформление для кнопок Extra Action Button и Zone Ability"
L.ExtraZoneAbilityEnable = "Включить скин кнопок Extra/Zone"
L.ExtraZoneAbilityArt = "Оформление кнопки"

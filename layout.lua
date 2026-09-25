local AddonName, Addon = ...

Addon.layouts = {
    "layout",
    "layoutPresets",
    "CDVSettings"
}
Addon.layoutMicro = {
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
}
Addon.layoutMini = {
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "NormalOptionsContainer",
        childs = {
            {name = "NormalTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorNormal", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewNormal", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "BackdropOptionsContainer",
        childs = {
            {name = "BackdropTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorBackdrop", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewBackdrop", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "IconOptionsContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "PushedOptionsContainer",
        childs = {
            {name = "PushedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorPushed", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewPushed", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "HighlightOptionsContainer",
        childs = {
            {name = "HighlightTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorHighlight", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewHighlight", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CheckedOptionsContainer",
        childs = {
            {name = "CheckedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorChecked", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewChecked", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CooldownOptionsContainer",
        childs = {
            {name = "SwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "SwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "SwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "ShowCountdownNumbersForCharges", template = "OptionsCheckboxTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "EdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "EdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "EdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "EdgeAlwaysShow", template = "OptionsCheckboxTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CooldownFontOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CooldownFontColor", template = "OptionsColorOverrideTemplate"},
            --{name = "ColorizedCooldownFont", template = "OptionsCheckboxTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -90}, scale="1.8"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -170}, scale="1.8"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOnActualCD", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "FontOptionsContainer",
        childs = {
            {name = "HotkeyFont", template = "OptionsDropdownTemplate"},
            {name = "HotkeyOutline", template = "OptionsDropdownTemplate"},
            {name = "HotkeySize", template = "OptionsCheckboxSliderTemplate"},
            {name = "HotkeyColor", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "HotkeyOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyShadow", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "StacksFont", template = "OptionsDropdownTemplate"},
            {name = "StacksOutline", template = "OptionsDropdownTemplate"},
            {name = "StacksSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "StacksColor", template = "OptionsColorOverrideTemplate"},
            {name = "StacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "StacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksShadow", template = "OptionsColorOverrideTemplate"},
            {name = "StacksShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "NameHide", template = "OptionsCheckboxTemplate"},
            {name = "NameScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewFont2", template = "OptionsButtonTextPreviewTemplate", point = {"RIGHT", "container", "RIGHT", 20, 80}, scale="2.0"},
            {name = "PreviewFont15", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont2", "BOTTOM", 0, -5}, scale="1.5"},
            {name = "PreviewFont1", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont15", "BOTTOM", 0, -5}, scale="1.0"},
            {name = "PreviewFont075", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont1", "BOTTOM", 0, -5}, scale="0.75"},
            {name = "PreviewFont05", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont075", "BOTTOM", 0, -5}, scale="0.5"},
        }
    },
    {
        name = "BarsOptionsContainer",
        childs = {
            --{name = "BarOrientation", template = "OptionsDropdownTemplate"},
            {name = "BarGrow", template = "OptionsDropdownTemplate"},
            {name = "CenteredGrid", template = "OptionsCheckboxTemplate"},
            --{name = "RowsNumber", template = "OptionsCheckboxSliderTemplate"},
            --{name = "ColumnsNumber", template = "OptionsCheckboxSliderTemplate"},
            --{name = "ButtonsNumber", template = "OptionsCheckboxSliderTemplate"},
            --{name = "ButtonSize", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "BarsPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "RightClickPassThrough", template = "OptionsCheckboxTemplate"},
        }
    },
}

Addon.layoutExtraZone = {
    {
        name = "ExtraZoneAbilityOptionsContainer",
        childs = {
            {name = "ExtraZoneAbilityEnable", template = "OptionsCheckboxTemplate"},
            {name = "ExtraZoneAbilityArt", template = "OptionsDropdownTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "NormalOptionsContainer",
        childs = {
            {name = "NormalTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorNormal", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewNormal", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "BackdropOptionsContainer",
        childs = {
            {name = "BackdropTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorBackdrop", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewBackdrop", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "IconOptionsContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "PushedOptionsContainer",
        childs = {
            {name = "PushedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorPushed", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewPushed", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "HighlightOptionsContainer",
        childs = {
            {name = "HighlightTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorHighlight", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewHighlight", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CheckedOptionsContainer",
        childs = {
            {name = "CheckedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorChecked", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewChecked", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CooldownOptionsContainer",
        childs = {
            {name = "SwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "SwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "SwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "ShowCountdownNumbersForCharges", template = "OptionsCheckboxTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "EdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "EdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "EdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "EdgeAlwaysShow", template = "OptionsCheckboxTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CooldownFontOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CooldownFontColor", template = "OptionsColorOverrideTemplate"},
            --{name = "ColorizedCooldownFont", template = "OptionsCheckboxTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -90}, scale="1.8"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -170}, scale="1.8"},
        }
    },
    {
        name = "FontOptionsContainer",
        childs = {
            {name = "HotkeyFont", template = "OptionsDropdownTemplate"},
            {name = "HotkeyOutline", template = "OptionsDropdownTemplate"},
            {name = "HotkeySize", template = "OptionsCheckboxSliderTemplate"},
            {name = "HotkeyColor", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "HotkeyOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyShadow", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "StacksFont", template = "OptionsDropdownTemplate"},
            {name = "StacksOutline", template = "OptionsDropdownTemplate"},
            {name = "StacksSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "StacksColor", template = "OptionsColorOverrideTemplate"},
            {name = "StacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "StacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksShadow", template = "OptionsColorOverrideTemplate"},
            {name = "StacksShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewFont2", template = "OptionsButtonTextPreviewTemplate", point = {"RIGHT", "container", "RIGHT", 20, 80}, scale="2.0"},
            {name = "PreviewFont15", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont2", "BOTTOM", 0, -5}, scale="1.5"},
            {name = "PreviewFont1", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont15", "BOTTOM", 0, -5}, scale="1.0"},
            {name = "PreviewFont075", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont1", "BOTTOM", 0, -5}, scale="0.75"},
            {name = "PreviewFont05", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont075", "BOTTOM", 0, -5}, scale="0.5"},
        }
    },
}

Addon.layoutModules = {
    {
        name = "ModulesOptionsContainer",
        childs = {
            {name = "ModulePixelPerfect", template = "OptionsCheckboxTemplate"},
            {name = "ModuleActionBars", template = "OptionsCheckboxTemplate"},
            {name = "ModuleCooldownManagerView", template = "OptionsCheckboxTemplate"},
            {name = "ModuleCooldownManagerCustom", template = "OptionsCheckboxTemplate"},
            {name = "ModuleCastingBar", template = "OptionsCheckboxTemplate"},
            {name = "ModuleMinimapButton", template = "OptionsCheckboxTemplate"},
        }
    },
}

Addon.layout = {
    {
        name = "GlowOptionsContainer",
        childs = {
            {name = "GlowOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorGlow", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "HideProc", template = "OptionsCheckboxTemplate",},
            {name = "ProcOptions", template = "OptionsDropdownTemplate",},
            {name = "CustomColorProc", template = "OptionsColorOverrideTemplate",},
            {name = "ProcLoopPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, 4}, scale="1.8"},
            {name = "ProcStartPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "Divider", "BOTTOM", 180, -10}, scale="1.8"},
        
        }
    },
    {
        name = "AssistLoopOptionsContainer",
        childs = {
            {name = "AssistLoopType", template = "OptionsDropdownTemplate"},
            {name = "CustomColorAssistLoop", template = "OptionsColorOverrideTemplate"},
            {name = "AssistAltGlowType", template = "OptionsDropdownTemplate"},
            {name = "CustomColorAltGlow", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "NormalOptionsContainer",
        childs = {
            {name = "NormalTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorNormal", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewNormal", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "BackdropOptionsContainer",
        childs = {
            {name = "BackdropTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorBackdrop", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewBackdrop", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "IconOptionsContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "PushedOptionsContainer",
        childs = {
            {name = "PushedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorPushed", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewPushed", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "HighlightOptionsContainer",
        childs = {
            {name = "HighlightTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorHighlight", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewHighlight", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CheckedOptionsContainer",
        childs = {
            {name = "CheckedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorChecked", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewChecked", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CooldownOptionsContainer",
        childs = {
            {name = "SwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "SwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "SwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "ShowCountdownNumbersForCharges", template = "OptionsCheckboxTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "EdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "EdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "EdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "EdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "CooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CooldownFontOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "ColorizedCooldownFont", template = "OptionsCheckboxTemplate"},
            {name = "CooldownFormatType", template = "OptionsDropdownTemplate"},
            {name = "CooldownTimerFormat", template = "OptionsDropdownTemplate"},
            {name = "CooldownMilliseconds", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -90}, scale="1.8"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -170}, scale="1.8"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOnActualCD", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "HideFramesOptionsContainer",
        childs = {
            {name = "HideTalkingHead", template = "OptionsCheckboxTemplate"},
            {name = "HideInterrupt", template = "OptionsCheckboxTemplate"},
            {name = "HideCasting", template = "OptionsCheckboxTemplate"},
            {name = "HideReticle", template = "OptionsCheckboxTemplate"},
            {name = "PreviewInterrupt", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 60, -50}, scale="1.5"},
            {name = "PreviewCasting", template = "OptionsButtonPreviewTemplate", point = {"LEFT", "PreviewInterrupt", "RIGHT", 5, 0}, scale="1.5"},
            {name = "PreviewReticle", template = "OptionsButtonPreviewTemplate", point = {"LEFT", "PreviewCasting", "RIGHT", 5, 0}, scale="1.5"},
        }
    },
    {
        name = "FontOptionsContainer",
        childs = {
            {name = "HotkeyFont", template = "OptionsDropdownTemplate"},
            {name = "HotkeyOutline", template = "OptionsDropdownTemplate"},
            {name = "HotkeySize", template = "OptionsCheckboxSliderTemplate"},
            {name = "HotkeyColor", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "HotkeyOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyShadow", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "StacksFont", template = "OptionsDropdownTemplate"},
            {name = "StacksOutline", template = "OptionsDropdownTemplate"},
            {name = "StacksSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "StacksColor", template = "OptionsColorOverrideTemplate"},
            {name = "StacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "StacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksShadow", template = "OptionsColorOverrideTemplate"},
            {name = "StacksShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "NameHide", template = "OptionsCheckboxTemplate"},
            {name = "NameScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewFont2", template = "OptionsButtonTextPreviewTemplate", point = {"RIGHT", "container", "RIGHT", 20, 80}, scale="2.0"},
            {name = "PreviewFont15", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont2", "BOTTOM", 0, -5}, scale="1.5"},
            {name = "PreviewFont1", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont15", "BOTTOM", 0, -5}, scale="1.0"},
            {name = "PreviewFont075", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont1", "BOTTOM", 0, -5}, scale="0.75"},
            {name = "PreviewFont05", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont075", "BOTTOM", 0, -5}, scale="0.5"},
        }
    },
    {
        name = "BarsOptionsContainer",
        childs = {
            --{name = "BarOrientation", template = "OptionsDropdownTemplate"},
            {name = "BarGrow", template = "OptionsDropdownTemplate"},
            {name = "CenteredGrid", template = "OptionsCheckboxTemplate"},
            --{name = "RowsNumber", template = "OptionsCheckboxSliderTemplate"},
            --{name = "ColumnsNumber", template = "OptionsCheckboxSliderTemplate"},
            --{name = "ButtonsNumber", template = "OptionsCheckboxSliderTemplate"},
            --{name = "ButtonSize", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "BarsPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "RightClickPassThrough", template = "OptionsCheckboxTemplate"},
        }
    },
    --[[ {
        name = "BarsPagingContainer",
        childs = {
            {name = "BarGrow", template = "OptionsDropdownTemplate"},
        }
    }, ]]
}


Addon.layoutPresets = {
    {
        name = "PresetsOptionsContainer",
        --template = "OptionsPresetsTemplate",
        childs = {}
    },
}

Addon.EssentialCooldownViewer = {
    {
        name = "CooldownViewerContainer",
        childs = {
            {name = "CDMEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMBarVerticalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMBarHorizontalGrowth", template = "OptionsDropdownTemplate"},
            --{name = "IconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "GridLayoutType", template = "OptionsDropdownTemplate"},
            {name = "HideWhenInactive", template = "OptionsDropdownTemplate"},
            {name = "RemovePandemicAnims", template = "OptionsCheckboxTemplate"},
            {name = "RemoveDesaturation", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "GlowOptionsContainer",
        childs = {
            {name = "GlowOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorGlow", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "HideProc", template = "OptionsCheckboxTemplate",},
            {name = "ProcOptions", template = "OptionsDropdownTemplate",},
            {name = "CustomColorProc", template = "OptionsColorOverrideTemplate",},
            {name = "ProcLoopPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, 4}, scale="1.8"},
            {name = "ProcStartPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "Divider", "BOTTOM", 180, -10}, scale="1.8"},
        
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CooldownViewerIconContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CooldownViewerCDContainer",
        childs = {
            {name = "CDMItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMSwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "ShowCountdownNumbersForCharges", template = "OptionsCheckboxTemplate"},
            {name = "CDMReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMRemoveGCDSwipe", template = "OptionsCheckboxTemplate"},
            
            {name = "Divider1", template = "OptionsDividerTemplate"},

            {name = "CDMAuraRemoveSwipe", template = "OptionsCheckboxTemplate"},

            {name = "CDMAuraSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraTimerColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraReverseSwipe", template = "OptionsCheckboxTemplate"},
            

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CDMEdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMEdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMEdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMEdgeAlwaysShow", template = "OptionsCheckboxTemplate"},

            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -50}, scale="1.8"},
            {name = "PreviewAuraSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -150}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -250}, scale="1.8"},
        }
    },
    {
        name = "CooldownViewerFontContainer",
        childs = {
            {name = "CDMCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCooldownFontOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMColorizedCooldownFont", template = "OptionsCheckboxTemplate"},
            {name = "CDMColorizedAuraFont", template = "OptionsCheckboxTemplate"},
            {name = "CDMCooldownFormatType", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownTimerFormat", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownMilliseconds", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMStacksFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewFont", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -110}, scale="1.8"},
        }
    },
    {
        name = "CooldownViewerBackdropContainer",
        childs = {
            {name = "BackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOnNormal", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
            --{name = "CustomColorOnGCD", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOnActualCD", template = "OptionsColorOverrideTemplate"},
        }
    },
}
Addon.BuffIconCooldownViewer = {
    {
        name = "CooldownViewerContainer",
        childs = {
            {name = "CDMEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMBarVerticalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMBarHorizontalGrowth", template = "OptionsDropdownTemplate"},
            --{name = "IconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "GridLayoutType", template = "OptionsDropdownTemplate"},
            {name = "RemovePandemicAnims", template = "OptionsCheckboxTemplate"},
            {name = "RemoveAuraTypeBorder", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CooldownViewerIconContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CooldownViewerCDContainer",
        childs = {
            {name = "CDMItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMSwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMEdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMEdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMEdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMEdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -150}, scale="1.8"},
        }
    },
    {
        name = "CooldownViewerFontContainer",
        childs = {
            {name = "CDMCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCooldownFontOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMColorizedCooldownFont", template = "OptionsCheckboxTemplate"},
            {name = "CDMColorizedAuraFont", template = "OptionsCheckboxTemplate"},
            {name = "CDMCooldownFormatType", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownTimerFormat", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownMilliseconds", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMStacksFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewFont", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -90}, scale="1.8"},
        }
    },
    {
        name = "CooldownViewerBackdropContainer",
        childs = {
            {name = "BackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOnNormal", template = "OptionsColorOverrideTemplate"},
            --{name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            --{name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            --{name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
            --{name = "CustomColorOnGCD", template = "OptionsColorOverrideTemplate"},
            --{name = "CustomColorOnActualCD", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOnAura", template = "OptionsColorOverrideTemplate"},
        }
    },
}
Addon.BuffBarCooldownViewer = {
    {
        name = "CooldownViewerContainer",
        childs = {
            {name = "CDMEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMBarVerticalGrowth", template = "OptionsDropdownTemplate"},
            --{name = "IconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "GridLayoutType", template = "OptionsDropdownTemplate"},
            {name = "RemovePandemicAnims", template = "OptionsCheckboxTemplate"},
            {name = "RemoveAuraTypeBorder", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CooldownViewerIconContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CooldownViewerBarContainer",
        childs = {
            {name = "IconSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BarHeight", template = "OptionsCheckboxSliderTemplate"},
            {name = "BarOffset", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMBarTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMPipTexture", template = "OptionsDropdownTemplate"},
            {name = "PipSize", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMBarBGTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMBarBGColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CooldownViewerFontContainer",
        childs = {
            {name = "CDMCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            --{name = "CDMColorizedCooldownFont", template = "OptionsCheckboxTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMStacksFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "CDMNameFont", template = "OptionsDropdownTemplate"},
            {name = "CDMNameFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMNameFontColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CooldownViewerBackdropContainer",
        childs = {
            {name = "BackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
}

Addon.CustomFrameCooldownViewer = {
    {
        name = "CDMCustomFrameContainer",
        childs = {
            {name = "CDMCustomPing", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameEditBox", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomItemListFrame", template = "OptionsCDMCustomItemListTemplate", height = 250},
            {name = "CDMCustomTrackTrink1", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomTrackTrink2", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomTrackWeapon1", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomTrackWeapon2", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomTrackRacial", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAddSpellByID", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomFrameAddItemByID", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomHideWhenEmpty", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameDeleteButton", template = "OptionsNamedButtonTemplate"}
        }
    },
    {
        name = "CDMCustomFrameGridContainer",
        childs = {
            {name = "CDMCustomFrameItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameIconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameStride", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameGridLayoutType", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHideWhenInactive", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameVerticalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHorizontalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameGridDirection", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameStrata", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameLevel", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CDMCustomFrameAttachContainer",
        childs = {
            {name = "CDMEnableAttach", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAttachTo", template = "OptionsEditBoxWithPickerButtonTemplate"},
            {name = "CDMCustomFrameAttachPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameAttachOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CDMCustomFrameGlowContainer",
        childs = {
            {name = "GlowOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorGlow", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "HideProc", template = "OptionsCheckboxTemplate",},
            {name = "ProcOptions", template = "OptionsDropdownTemplate",},
            {name = "CustomColorProc", template = "OptionsColorOverrideTemplate",},
            {name = "ProcLoopPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, 4}, scale="1.8"},
            {name = "ProcStartPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "Divider", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CDMCustomFrameIconContainer",
        childs = {
            {name = "CDMCustomFrameIconMaskTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameMaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameIconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CDMCustomFrameCDContainer",
        childs = {
            {name = "CDMCustomFrameShowSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameSwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameSwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "ShowCountdownNumbersForCharges", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameRemoveGCDSwipe", template = "OptionsCheckboxTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameRemoveAuraSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAuraSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameAuraTimerColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameAuraReverseSwipe", template = "OptionsCheckboxTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameShowEdge", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameEdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameEdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameEdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameEdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewAuraSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -120}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -230}, scale="1.8"},
        }
    },
    {
        name = "CDMCustomFrameFontContainer",
        childs = {
            {name = "CDMCustomFrameShowTimer", template = "OptionsCheckboxTemplate"},
            {name = "CDMCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCooldownFontOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMColorizedCooldownFont", template = "OptionsCheckboxTemplate"},
            {name = "CDMColorizedAuraFont", template = "OptionsCheckboxTemplate"},
            {name = "CDMCooldownFormatType", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomCooldownTimerFormat", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomCooldownMilliseconds", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMCustomFrameShowStacks", template = "OptionsCheckboxTemplate"},
            {name = "CDMAlwaysShowStacks", template = "OptionsCheckboxTemplate"},
            {name = "CDMStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMStacksFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewFont", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -110}, scale="1.8"},
        }
    },
    {
        name = "CDMCustomFrameBackdropContainer",
        childs = {
            {name = "CDMCustomFrameBackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameRemovePandemic", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOnNormal", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
            --{name = "CustomColorOnGCD", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOnActualCD", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOnAura", template = "OptionsColorOverrideTemplate"},
        }
    },
}
Addon.CustomFrameBarsCooldownViewer = {
    {
        name = "CDMCustomFrameBarContainer",
        childs = {
            {name = "CDMCustomFrameEditBox", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomItemListFrame", template = "OptionsCDMCustomItemListTemplate", height = 250},
            {name = "CDMCustomTrackTrink1", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomTrackTrink2", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomTrackWeapon1", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomTrackWeapon2", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAddSpellByID", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomFrameAddItemByID", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomHideWhenEmpty", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameDeleteButton", template = "OptionsNamedButtonTemplate"}
        }
    },

    {
        name = "CDMCustomFrameGridContainer",
        childs = {
            --{name = "CDMCustomFrameItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameIconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameStride", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameGridLayoutType", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHideWhenInactive", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameVerticalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHorizontalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameGridDirection", template = "OptionsDropdownTemplate"},

            {name = "Divider1", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameBarWidth", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarHeight", template = "OptionsCheckboxSliderTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameStatusbarTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBackgroundTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBackgroundColor", template = "OptionsColorOverrideTemplate"},

            {name = "Divider3", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFramePipTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFramePipSize", template = "OptionsDoubleCheckboxSliderTemplate"},

        }
    },
    {
        name = "CDMCustomFrameAttachContainer",
        childs = {
            {name = "CDMEnableAttach", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAttachTo", template = "OptionsEditBoxWithPickerButtonTemplate"},
            {name = "CDMCustomFrameAttachPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameAttachOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CDMCustomFrameBarIconOptionsContainer",
        childs = {
            {name = "CDMCustomFrametBarIconPosition", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarIconSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarIconOffset", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    --[[ {
        name = "CDMCustomFrameCDContainer",
        childs = {
            {name = "CDMCustomFrameSwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameSwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "ShowCountdownNumbersForCharges", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameRemoveGCDSwipe", template = "OptionsCheckboxTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameRemoveAuraSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAuraSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameAuraTimerColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameAuraReverseSwipe", template = "OptionsCheckboxTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameEdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameEdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameEdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameEdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewAuraSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -120}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -230}, scale="1.8"},
        }
    }, ]]
    {
        name = "CDMCustomFrameBarFontContainer",
        childs = {
            {name = "CDMCustomFrameBarNameEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameBarNameFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarNameSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarNameColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBarNamePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameBarNameOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CDMCustomFrameBarNameJustifyH", template = "OptionsDropdownTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameBarStacksEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameBarStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarStacksSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarStacksColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBarStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameBarStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CDMCustomFrameBarStacksJustifyH", template = "OptionsDropdownTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameBarTimeEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameBarTimeFormat", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarTimeFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarTimeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarTimeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBarTimePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameBarTimeOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CDMCustomFrameBarTimeJustifyH", template = "OptionsDropdownTemplate"},

        }
    },
    {
        name = "CDMCustomFrameBackdropContainer",
        childs = {
            {name = "CDMCustomFrameBackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
}

Addon.PlayerCastingBarFrame = {
    {
        name = "CastBarsOptionsContainer",
        childs = {
            {name = "CastBarEnable", template = "OptionsCheckboxTemplate"},

            {name = "Divider1", template = "OptionsDividerTemplate"},

            {name = "CastBarWidth", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarHeight", template = "OptionsCheckboxSliderTemplate"},
            --{name = "CastBarSize", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CastBarPoint", template = "OptionsDoubleDropdownTemplate"},
            --{name = "CastBarOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CastBarOffsetX", template = "OptionsCheckboxSliderTemplate"},
            --{name = "CastBarOffsetY", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CastBarStatusbarTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarBackgroundTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarBackgroundColor", template = "OptionsColorOverrideTemplate"},

            {name = "Divider3", template = "OptionsDividerTemplate"},

            {name = "CastBarPipTexture", template = "OptionsDropdownTemplate"},
            {name = "PipSize", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "Divider4", template = "OptionsDividerTemplate"},

            {name = "CastHideTextBorder", template = "OptionsCheckboxTemplate"},
            {name = "CastHideInterruptAnim", template = "OptionsCheckboxTemplate"},
            {name = "CastQuickFinish", template = "OptionsCheckboxTemplate"},

            {name = "Divider5", template = "OptionsDividerTemplate"},

            {name = "CastBarStandardColor", template = "OptionsColorOverrideTemplate"},
            --{name = "CastBarImportantColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarChannelColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarUninterruptableColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarInterruptedColor", template = "OptionsColorOverrideTemplate"},
            --{name = "CastBarReadyColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CastBarsIconOptionsContainer",
        childs = {
            {name = "CastBarIconPosition", template = "OptionsDropdownTemplate"},
            {name = "CastBarIconSize", template = "OptionsCheckboxSliderTemplate"},
            --{name = "CastBarIconPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarIconOffset", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    
    {
        name = "CastBarsSQWLatencyOptionsContainer",
        childs = {
            {name = "CastBarShowLatency", template = "OptionsCheckboxTemplate"},
            {name = "CastBarLatencyTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarLatencyColor", template = "OptionsColorOverrideTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CastBarShowSQW", template = "OptionsCheckboxTemplate"},
            {name = "CastBarSQWTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarSQWColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CastBarsFontContainer",
        childs = {
            {name = "CastBarCastNameFont", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastNameSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarCastNameColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarCastNamePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarCastNameOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarCastNameJustifyH", template = "OptionsDropdownTemplate"},


            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CastBarCastTimeFormat", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastTimeFont", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastTimeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarCastTimeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarCastTimePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarCastTimeOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarCastTimeJustifyH", template = "OptionsDropdownTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CastBarCastTargetEnable", template = "OptionsCheckboxTemplate"},
            {name = "CastBarCastTargetFont", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastTargetSize", template = "OptionsCheckboxSliderTemplate"},
            --{name = "CastBarCastTargetColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarCastTargetPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarCastTargetOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarCastTargetJustifyH", template = "OptionsDropdownTemplate"},

        }
    },
    {
        name = "CastBarsBackdropContainer",
        childs = {
            {name = "CastBarsBackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarsBackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarsBackdropColorByType", template = "OptionsCheckboxTemplate"},
        }
    },

}
Addon.TargetFrameSpellBar = {
    {
        name = "CastBarsOptionsContainer",
        childs = {
            {name = "CastBarEnable", template = "OptionsCheckboxTemplate"},
            
            {name = "Divider1", template = "OptionsDividerTemplate"},

            {name = "CastBarWidth", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarHeight", template = "OptionsCheckboxSliderTemplate"},
            --{name = "CastBarSize", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarPoint", template = "OptionsDoubleDropdownTemplate"},
            --{name = "CastBarOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarOffsetX", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarOffsetY", template = "OptionsCheckboxSliderTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CastBarStatusbarTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarBackgroundTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarBackgroundColor", template = "OptionsColorOverrideTemplate"},

            {name = "Divider3", template = "OptionsDividerTemplate"},

            {name = "CastBarPipTexture", template = "OptionsDropdownTemplate"},
            {name = "PipSize", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "Divider4", template = "OptionsDividerTemplate"},

            {name = "CastHideTextBorder", template = "OptionsCheckboxTemplate"},
            --{name = "CastHideInterruptAnim", template = "OptionsCheckboxTemplate"},
            --{name = "CastQuickFinish", template = "OptionsCheckboxTemplate"},
            {name = "CastBarShieldIconTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarShieldIconSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarShieldIconPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarShieldIconOffset", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "Divider5", template = "OptionsDividerTemplate"},

            {name = "CastBarStandardColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarImportantColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarChannelColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarUninterruptableColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarInterruptedColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarReadyColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CastBarsIconOptionsContainer",
        childs = {
            {name = "CastBarIconSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarIconPosition", template = "OptionsDropdownTemplate"},
            --{name = "CastBarIconPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarIconOffset", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    
    --[[ {
        name = "CastBarsSQWLatencyOptionsContainer",
        childs = {
            {name = "CastBarShowLatency", template = "OptionsCheckboxTemplate"},
            {name = "CastBarLatencyTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarLatencyColor", template = "OptionsColorOverrideTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CastBarShowSQW", template = "OptionsCheckboxTemplate"},
            {name = "CastBarSQWTexture", template = "OptionsDropdownTemplate"},
            {name = "CastBarSQWColor", template = "OptionsColorOverrideTemplate"},
        }
    }, ]]
    {
        name = "CastBarsFontContainer",
        childs = {
            {name = "CastBarCastNameFont", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastNameSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarCastNameColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarCastNamePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarCastNameOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarCastNameJustifyH", template = "OptionsDropdownTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CastBarCastTimeFormat", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastTimeFont", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastTimeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarCastTimeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarCastTimePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarCastTimeOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarCastTimeJustifyH", template = "OptionsDropdownTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CastBarCastTargetEnable", template = "OptionsCheckboxTemplate"},
            {name = "CastBarCastTargetFont", template = "OptionsDropdownTemplate"},
            {name = "CastBarCastTargetSize", template = "OptionsCheckboxSliderTemplate"},
            --{name = "CastBarCastTargetColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarCastTargetPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CastBarCastTargetOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CastBarCastTargetJustifyH", template = "OptionsDropdownTemplate"},

        }
    },
    {
        name = "CastBarsBackdropContainer",
        childs = {
            {name = "CastBarsBackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CastBarsBackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "CastBarsBackdropColorByType", template = "OptionsCheckboxTemplate"},
        }
    },

}
Addon.CustomFrameAuraViewer = {
    {
        name = "CDMAuraFrameContainer",
        childs = {
            {name = "CDMCustomPing", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameEditBox", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomItemListFrame", template = "OptionsCDMCustomItemListTemplate", height = 250},
            {name = "CDMCustomFrameAddSpellByID", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomFrameDeleteButton", template = "OptionsNamedButtonTemplate"},
        }
    },
    {
        name = "CDMAuraFrameGridContainer",
        childs = {
            {name = "CDMCustomFrameItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameIconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameStride", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameGridLayoutType", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHideWhenInactive", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameVerticalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHorizontalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameGridDirection", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameStrata", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameLevel", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CDMAuraFrameAttachContainer",
        childs = {
            {name = "CDMEnableAttach", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAttachTo", template = "OptionsEditBoxWithPickerButtonTemplate"},
            {name = "CDMCustomFrameAttachPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameAttachOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CDMAuraFrameIconContainer",
        childs = {
            {name = "CDMCustomFrameIconMaskTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameMaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameIconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CDMAuraFrameCDContainer",
        childs = {
            {name = "CDMAuraFrameShowSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraFrameSwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMAuraFrameSwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMAuraFrameAuraSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraFrameAuraTimerColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraFrameReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMAuraFrameShowEdge", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraFrameEdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMAuraFrameEdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMAuraFrameEdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraFrameEdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraFrameRemovePandemic", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CDMAuraFrameFontContainer",
        childs = {
            {name = "CDMAuraFrameShowTimer", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraFrameCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMAuraFrameCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMAuraFrameCooldownFontOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMAuraFrameCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraFrameColorizedAuraFont", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraFrameCooldownTimerFormat", template = "OptionsDropdownTemplate"},
            {name = "CDMAuraFrameCooldownMilliseconds", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMAuraFrameShowStacks", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraFrameAlwaysShowStacks", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraFrameStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMAuraFrameStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMAuraFrameStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMAuraFrameStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMAuraFrameStacksFontColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CDMCustomFrameBackdropContainer",
        childs = {
            {name = "CDMCustomFrameBackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    
}
Addon.CustomFrameBarsAuraViewer = {
    {
        name = "CDMCustomFrameBarContainer",
        childs = {
            {name = "CDMCustomFrameEditBox", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomItemListFrame", template = "OptionsCDMCustomItemListTemplate", height = 250},
            {name = "CDMCustomFrameAddSpellByID", template = "OptionsEditBoxTemplate"},
            {name = "CDMCustomFrameDeleteButton", template = "OptionsNamedButtonTemplate"}
        }
    },

    {
        name = "CDMAuraBarGridContainer",
        childs = {
            --{name = "CDMCustomFrameItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameIconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameStride", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameGridLayoutType", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHideWhenInactive", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameVerticalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameHorizontalGrowth", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameGridDirection", template = "OptionsDropdownTemplate"},

            {name = "Divider1", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameBarWidth", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarHeight", template = "OptionsCheckboxSliderTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameStatusbarTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBackgroundTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBackgroundColor", template = "OptionsColorOverrideTemplate"},

            {name = "Divider3", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFramePipTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFramePipSize", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "CDMCustomFrameStrata", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameLevel", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CDMCustomFrameAttachContainer",
        childs = {
            {name = "CDMEnableAttach", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameAttachTo", template = "OptionsEditBoxWithPickerButtonTemplate"},
            {name = "CDMCustomFrameAttachPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameAttachOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CDMAuraBarIconOptionsContainer",
        childs = {
            {name = "CDMCustomFrametBarIconPosition", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarIconSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarIconOffset", template = "OptionsDoubleCheckboxSliderTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CDMAuraBarFontContainer",
        childs = {
            {name = "CDMCustomFrameBarNameEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameBarNameFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarNameSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarNameColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBarNamePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameBarNameOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CDMCustomFrameBarNameJustifyH", template = "OptionsDropdownTemplate"},

            {name = "Divider", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameBarStacksEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraBarAlwaysShowStacks", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameBarStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarStacksSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarStacksColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBarStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameBarStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CDMCustomFrameBarStacksJustifyH", template = "OptionsDropdownTemplate"},

            {name = "Divider2", template = "OptionsDividerTemplate"},

            {name = "CDMCustomFrameBarTimeEnable", template = "OptionsCheckboxTemplate"},
            {name = "CDMCustomFrameBarTimeFormat", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarTimerFormat", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarTimeMilliseconds", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarTimeFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCustomFrameBarTimeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBarTimeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBarTimePoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMCustomFrameBarTimeOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            --{name = "CDMCustomFrameBarTimeJustifyH", template = "OptionsDropdownTemplate"},
        }
    },
    {
        name = "CDMCustomFrameBackdropContainer",
        childs = {
            {name = "CDMCustomFrameBackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCustomFrameBackdropColor", template = "OptionsColorOverrideTemplate"},
            --{name = "CDMCustomFrameBackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameBackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMCustomFrameRemovePandemic", template = "OptionsCheckboxTemplate"},
        }
    },
}
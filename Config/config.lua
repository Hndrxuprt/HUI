local AddonName, Addon = ...

local L = Addon.L
local T = Addon.Templates

Addon.Fonts = {}

Addon.config = {}

Addon.config.containers = {
    ModulesOptionsContainer = {
        title = "Modules",
        desc = "Enable or disable modules (requires /reload)",
        childs = {
            ["ModulePixelPerfect"] = {
                type     = "checkbox",
                name     = L.UsePixelPerfect,
                value    = "UsePixelPerfect",
                callback = function(checked)
                    if Addon.PP and Addon.PP.SetEnabled then
                        Addon.PP.SetEnabled(checked)
                    end
                end,
            },
            ["ModuleActionBars"] = { type = "moduleCheckbox", name = "Action Bars", moduleName = "ActionBars" },
            ["ModuleCooldownManagerView"] = { type = "moduleCheckbox", name = "Cooldown Manager", moduleName = "CooldownManagerView" },
            ["ModuleCooldownManagerCustom"] = { type = "moduleCheckbox", name = "Custom Cooldown Frames", moduleName = "CooldownManagerCustom" },
            ["ModuleCastingBar"] = { type = "moduleCheckbox", name = "Casting Bars", moduleName = "CastingBar" },
            ["ModuleMinimapButton"] = { type = "minimapCheckbox", name = L.MinimapButton },
        },
    },
    GlowOptionsContainer = {
        title = L.GlowTypeTitle,
        desc = L.GlowTypeDesc,
        childs = {
            ["GlowOptions"] = {
                type        = "dropdown",
                setting     = T.LoopGlow,
                name        = L.GlowType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentLoopGlow", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentLoopGlow", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshProcLoop(frames.ProcLoopPreview, id) end,
                OnClose     = function() HUIDropdownMixin:RefreshAllPreview() end,
            },
            ["CustomColorGlow"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "LoopGlowColor",
                checkboxValues  = {"UseLoopGlowColor", "DesaturateGlow"},
                alpha           = false,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                end,
            },
            ["ProcLoopPreview"] = {
                type = "preview",
                sub = "LoopGlow",
            },
            ["HideProc"] = {
                type        = "checkbox",
                name        = L.HideProcAnim,
                value       = "HideProc",
                callback    = false,
            },
            ["ProcOptions"] = {
                type        = "dropdown",
                setting     = T.ProcGlow,
                name        = L.StartProcType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentProcGlow", nil, true) end,
                OnSelect    = function(id, frames)
                    Addon:SaveSetting("CurrentProcGlow", id, true)
                end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshProcStart(frames.ProcStartPreview, id) end,
                OnClose     = function() HUIDropdownMixin:RefreshAllPreview() end,
            },
            ["CustomColorProc"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "ProcColor",
                checkboxValues  = {"UseProcColor", "DesaturateProc"},
                alpha           = false,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                end,
            },
            ["ProcStartPreview"] = {
                type = "preview",
                sub = "ProcGlow",
            }
        }
    },
    AssistLoopOptionsContainer = {
        title = L.AssistTitle,
        desc = L.AssistDesc,
        childs = {
            ["AssistLoopType"] = {
                type        = "dropdown",
                setting     = T.LoopGlow,
                name        = L.AssistType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentAssistType", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentAssistType", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = false,
            },
            ["CustomColorAssistLoop"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "AssistGlowColor",
                checkboxValues  = {"UseAssistGlowColor", "DesaturateAssist"},
                alpha           = false,
                
            },
            ["AssistAltGlowType"] = {
                type        = "dropdown",
                setting     = T.PushedTextures,
                name        = L.AssistAltType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentAssistAltType", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentAssistAltType", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = false,
            },
            ["CustomColorAltGlow"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "AssistAltColor",
                checkboxValues  = {"UseAssistAltColor", "DesaturateAssistAlt"},
                alpha           = true,
            },
        }
    },
    FadeOptionsContainer = {
        title = L.FadeTitle,
        desc = L.FadeDesc,
        childs = {
            ["FadeOutBars"] = {
                type            = "checkboxSlider",
                name            = L.FadeOutBars,
                checkboxValue   = "FadeBars",
                sliderValue     = "FadeBarsAlpha",
                min             = 0,
                max             = 1,
                step            = 0.1,
                sliderName      = {top = L.Alpha},
                callback        = false,
            },
            ["FadeInOnCombat"] = {
                type            = "checkbox",
                name            = L.FadeInOnCombat,
                value           = "FadeInOnCombat",
                callback        = false,
            },
            ["FadeInOnTarget"] = {
                type            = "checkbox",
                name            = L.FadeInOnTarget,
                value           = "FadeInOnTarget",
                callback        = false,
            },
            ["FadeInOnCasting"] = {
                type            = "checkbox",
                name            = L.FadeInOnCasting,
                value           = "FadeInOnCasting",
                callback        = false,
            },
            ["FadeInOnHover"] = {
                type            = "checkbox",
                name            = L.FadeInOnHover,
                value           = "FadeInOnHover",
                callback        = false,
            },
        }
    },
    ExtraZoneAbilityOptionsContainer = {
        title = L.ExtraZoneAbilityTitle,
        desc = L.ExtraZoneAbilityDesc,
        childs = {
            ["ExtraZoneAbilityEnable"] = {
                type            = "checkbox",
                name            = L.ExtraZoneAbilityEnable,
                value           = "ExtraZoneAbilityEnable",
                callback        = false,
            },
            ["ExtraZoneAbilityArt"] = {
                type        = "dropdown",
                setting     = T.ExtraZoneAbilityArts,
                name        = L.ExtraZoneAbilityArt,
                IsSelected  = function(id) return id == Addon:GetValue("ExtraZoneAbilityArt", nil, true) end,
                OnSelect    = function(id)
                    Addon:SaveSetting("ExtraZoneAbilityArt", id, true)
                    if Addon.UpdateExtraZoneArt then
                        Addon:UpdateExtraZoneArt()
                    end
                end,
                showNew     = false,
                OnEnter     = function(id)
                    if Addon.UpdateExtraZoneArt then
                        Addon:UpdateExtraZoneArt(id)
                    end
                end,
                OnClose     = function()
                    if Addon.UpdateExtraZoneArt then
                        Addon:UpdateExtraZoneArt()
                    end
                    HUIDropdownMixin:RefreshAllPreview()
                end,
            },
        }
    },
    NormalOptionsContainer = {
        title = L.NormalTitle,
        desc = L.NormalDesc,
        childs = {
            ["NormalTextureOptions"] = {
                type        = "dropdown",
                setting     = T.NormalTextures,
                name        = L.NormalTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentNormalTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentNormalTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshNormalTexture(frames.PreviewNormal, id) end,
                OnClose     = function() 
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CustomColorNormal"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "NormalTextureColor",
                checkboxValues  = {"UseNormalTextureColor", "DesaturateNormal"},
                alpha           = true,
                callback        = function() 
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewNormal"] = {
                type = "preview",
            },
        }
    },
    BackdropOptionsContainer = {
        title = L.BackdropTitle,
        desc = L.BackdropDesc,
        childs = {
            ["BackdropTextureOptions"] = {
                type        = "dropdown",
                setting     = T.BackdropTextures,
                name        = L.BackdropTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentBackdropTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentBackdropTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshBackdropTexture(frames.PreviewBackdrop, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CustomColorBackdrop"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "BackdropColor",
                checkboxValues  = {"UseBackdropColor", "DesaturateBackdrop"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewBackdrop"] = {
                type = "preview",
                sub = "Backdrop",
            },
        }
    },
    IconOptionsContainer = {
        title = L.IconTitle,
        desc = L.IconDesc,
        childs = {
            ["IconMaskTextureOptions"] = {
                type        = "dropdown",
                setting     = T.IconMaskTextures,
                name        = L.IconMaskTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentIconMaskTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentIconMaskTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshIconMaskTexture(frames.PreviewIcon, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["MaskScale"] = {
                type            = "checkboxSlider",
                name            = L.IconMaskScale,
                checkboxValue   = "UseIconMaskScale",
                sliderValue     = "IconMaskScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function(_, frames)
                    HUIDropdownMixin:RefreshPreview(frames.PreviewIcon)
                    Addon:RefreshButtons()
                end,
            },
            ["IconScale"] = {
                type            = "checkboxSlider",
                name            = L.IconScale,
                checkboxValue   = "UseIconScale",
                sliderValue     = "IconScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function(_, frames)
                    HUIDropdownMixin:RefreshPreview(frames.PreviewIcon)
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewIcon"] = {
                type = "preview",
            },
        }
    },
    PushedOptionsContainer = {
        title = L.PushedTitle,
        desc = L.PushedDesc,
        childs = {
            ["PushedTextureOptions"] = {
                type        = "dropdown",
                setting     = T.PushedTextures,
                name        = L.PushedTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentPushedTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentPushedTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshPushedTexture(frames.PreviewPushed, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CustomColorPushed"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "PushedColor",
                checkboxValues  = {"UsePushedColor", "DesaturatePushed"},
                alpha           = false,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewPushed"] = {
                type = "preview",
                func = function(frame)
                    frame:SetButtonState("PUSHED", true)
                end,
            },
        }
    },
    HighlightOptionsContainer = {
        title = L.HighlightTitle,
        desc = L.HighlightDesc,
        childs = {
            ["HighlightTextureOptions"] = {
                type        = "dropdown",
                setting     = T.HighlightTextures,
                name        = L.HighliteTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentHighlightTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentHighlightTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshHighlightTexture(frames.PreviewHighlight, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CustomColorHighlight"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "HighlightColor",
                checkboxValues  = {"UseHighlightColor", "DesaturateHighlight"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewHighlight"] = {
                type = "preview",
                func = function(frame)
                    frame:LockHighlight()
                end,
            },
        }
    },
    CheckedOptionsContainer = {
        title = L.CheckedTitle,
        desc = L.CheckedDesc,
        childs = {
            ["CheckedTextureOptions"] = {
                type        = "dropdown",
                setting     = T.HighlightTextures,
                name        = L.CheckedTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCheckedTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCheckedTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshCheckedTexture(frames.PreviewChecked, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CustomColorChecked"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "CheckedColor",
                checkboxValues  = {"UseCheckedColor","DesaturateChecked"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewChecked"] = {
                type = "preview",
                func = function(frame)
                    frame:SetChecked(true)
                    frame:Disable(true)
                end,
            },
        }
    },
    CooldownOptionsContainer = {
        title = L.CooldownTitle,
        desc = L.CooldownDesc,
        childs = {
            ["SwipeTexture"] = {
                type        = "dropdown",
                setting     = T.SwipeTextures,
                name        = L.SwipeTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentSwipeTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentSwipeTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    HUIDropdownMixin:RefreshSwipeTexture(frames.PreviewSwipe, id)
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
            },
            ["SwipeSize"] = {
                type            = "checkboxSlider",
                name            = L.SwipeSize,
                checkboxValue   = "UseSwipeSize",
                sliderValue     = "SwipeSize",
                min             = 10,
                max             = 50,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
            },
            ["SwipeColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "CooldownColor",
                checkboxValues  = {"UseCooldownColor"},
                alpha           = true,
                callback        = function() HUIDropdownMixin:RefreshCooldownPreview() end,
            },
            ["ShowCountdownNumbersForCharges"] = {
                type            = "checkbox",
                name            = L.ShowCountdownNumbersForCharges,
                value           = "ShowCountdownNumbersForCharges",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
            },
            ["EdgeTexture"] = {
                type        = "dropdown",
                setting     = T.EdgeTextures,
                name        = L.EdgeTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentEdgeTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentEdgeTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    HUIDropdownMixin:RefreshEdgeTexture(frames.PreviewEdge, id)
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
            },
            ["EdgeSize"] = {
                type            = "checkboxSlider",
                name            = L.EdgeSize,
                checkboxValue   = "UseEdgeSize",
                sliderValue     = "EdgeSize",
                min             = 0.5,
                max             = 2,
                step            = 0.1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
            },
            ["EdgeColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "EdgeColor",
                checkboxValues  = {"UseEdgeColor"},
                alpha           = true,
                callback        = function() HUIDropdownMixin:RefreshCooldownPreview() end,
            },
            ["EdgeAlwaysShow"] = {
                type            = "checkbox",
                name            = L.EdgeAlwaysShow,
                value           = "EdgeAlwaysShow",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CooldownFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.CooldownFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCooldownFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCooldownFont", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    HUIDropdownMixin:RefreshCooldownFont(frames.PreviewCooldownFont, id)
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CooldownFontSize"] = {
                type            = "checkboxSlider",
                name            = L.CooldownFontSize,
                checkboxValue   = "UseCooldownFontSize",
                sliderValue     = "CooldownFontSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CooldownFontColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "CooldownFontColor",
                checkboxValues  = {"UseCooldownFontColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["ColorizedCooldownFont"] = {
                type            = "checkbox",
                name            = L.ColorizedCooldownFont,
                value           = "ColorizedCooldownFont",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CooldownFormatType"] = {
                type            = "dropdown",
                name            = L.CooldownFormatType,
                setting         = Addon.CooldownFormatType,
                IsSelected  = function(id) return id == Addon:GetValue("CooldownFormatType", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CooldownFormatType", id, true) end,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CooldownTimerFormat"] = {
                type            = "dropdown",
                name            = L.CooldownTimerFormat,
                setting         = Addon.CooldownTimerFormat,
                showNew         = true,
                IsSelected  = function(id) return id == Addon:GetValue("CooldownTimerFormat", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CooldownTimerFormat", id, true) end,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CooldownMilliseconds"] = {
                type            = "checkboxSlider",
                name            = L.CooldownMilliseconds,
                showNew         = true,
                checkboxValue   = "UseCooldownMilliseconds",
                sliderValue     = "CooldownMillisecondsThreshold",
                min             = 1,
                max             = 60,
                step            = 1,
                sliderName      = {top = L.CooldownMillisecondsBelow},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["CooldownFontOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCooldownFontOffset",
                sliderValue     = {"CooldownFontOffsetX", "CooldownFontOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewCooldownFont"] = {
                type = "preview",
                sub    = "CooldownFont",
            },
            ["PreviewSwipe"] = {
                type = "preview",
                sub = "CooldownSwipe",
            },
            ["PreviewEdge"] = {
                type = "preview",
                sub    = "CooldownEdge",
            },

        }
    },
    ColorOverrideOptionsContainer = {
        title = L.ColorOverrideTitle,
        desc = L.ColorOverrideDesc,
        childs = {
            ["CustomColorOOR"] = {
                type            = "colorSwatch",
                name            = L.CustomColorOOR,
                value           = "OORColor",
                checkboxValues  = {"UseOORColor", "OORDesaturate"},
                alpha           = true,
            },
            ["CustomColorOOM"] = {
                type            = "colorSwatch",
                name            = L.CustomColorOOM,
                value           = "OOMColor",
                checkboxValues  = {"UseOOMColor", "OOMDesaturate"},
                alpha           = true,
            },
            ["CustomColorNotUsable"] = {
                type            = "colorSwatch",
                name            = L.CustomColorNoUse,
                value           = "NoUseColor",
                checkboxValues  = {"UseNoUseColor", "NoUseDesaturate"},
                alpha           = true,
            },
            ["CustomColorOnGCD"] = {
                type            = "colorSwatch",
                name            = L.CustomColorGCD,
                value           = "GCDColor",
                checkboxValues  = {"UseGCDColor", "GCDColorDesaturate"},
                alpha           = true,
            },
            ["CustomColorOnActualCD"] = {
                type            = "colorSwatch",
                name            = L.CustomColorCD,
                value           = "CDColor",
                checkboxValues  = {"UseCDColor", "CDColorDesaturate"},
                alpha           = true,
            },
            ["CustomColorOnNormal"] = {
                type            = "colorSwatch",
                name            = L.CustomColorNormal,
                value           = "NormalColor",
                checkboxValues  = {"UseNormalColor", "NormalColorDesaturate"},
                alpha           = true,
            },
            ["CustomColorOnAura"] = {
                type            = "colorSwatch",
                name            = L.CustomColorAura,
                value           = "AuraColor",
                checkboxValues  = {"UseAuraColor", "AuraColorDesaturate"},
                alpha           = true,
            },
        }
    },
    HideFramesOptionsContainer = {
        title = L.HideFrameTitle,
        desc = L.HideFrameDesc,
        childs = {
            ["HideTalkingHead"] = {
                type            = "checkbox",
                name            = L.HideTalkingHead,
                value           = "HideTalkingHead",
                callback        = function(checked)
                    Addon:SetTalkingHeadEnabled(checked)
                end,
            },
            ["HideInterrupt"] = {
                type            = "checkbox",
                name            = L.HideInterrupt,
                value           = "HideInterrupt",
                callback        = false,
            },
            ["HideCasting"] = {
                type            = "checkbox",
                name            = L.HideCasting,
                value           = "HideCasting",
                callback        = false,
            },
            ["HideReticle"] = {
                type            = "checkbox",
                name            = L.HideReticle,
                value           = "HideReticle",
                callback        = false,
            },
            ["PreviewInterrupt"] = {
                type = "preview",
                sub    = "AnimInterrupt",
            },
            ["PreviewCasting"] = {
                type = "preview",
                sub    = "AnimCasting",
            },
            ["PreviewReticle"] = {
                type = "preview",
                sub    = "AnimReticle",
            },
        }
    },
    FontOptionsContainer = {
        title = L.FontTitle,
        desc = L.FontDesc,
        childs = {
            ["HotkeyFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.HotKeyFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentHotkeyFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentHotkeyFont", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    Addon:PreviewButtons("HotkeyFont", id)
                    HUIDropdownMixin:RefreshHotkeyFont(frames.PreviewFont05, id)
                    HUIDropdownMixin:RefreshHotkeyFont(frames.PreviewFont075, id)
                    HUIDropdownMixin:RefreshHotkeyFont(frames.PreviewFont1, id)
                    HUIDropdownMixin:RefreshHotkeyFont(frames.PreviewFont15, id)
                    HUIDropdownMixin:RefreshHotkeyFont(frames.PreviewFont2, id)
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["HotkeyOutline"] = {
                type        = "dropdown",
                setting     = Addon.FontOutlines,
                name        = L.HotkeyOutline,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentHotkeyOutline", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentHotkeyOutline", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    HUIDropdownMixin:RefreshFontPreview()
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["HotkeySize"] = {
                type            = "checkboxSlider",
                name            = L.FontHotkeySize,
                checkboxValue   = "UseHotkeyFontSize",
                sliderValue     = "HotkeyFontSize",
                min             = 1,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["HotkeyColor"] = {
                type            = "colorSwatch",
                name            = L.HotkeyCustomColor,
                value           = "HotkeyColor",
                checkboxValues  = {"UseHotkeyColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["HotkeyPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.HotkeyAttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentHotkeyPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentHotkeyRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentHotkeyPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentHotkeyRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                },
                OnClose     = {
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        Addon:RefreshButtons()
                    end,
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        Addon:RefreshButtons()
                    end,
                },
            },
            ["HotkeyOffset"] = {
                type            = "checkboxSlider",
                name            = L.HotkeyOffset,
                checkboxValue   = "UseHotkeyOffset",
                sliderValue     = {"HotkeyOffsetX", "HotkeyOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["HotkeyShadow"] = {
                type            = "colorSwatch",
                name            = L.HotkeyShadowColor,
                value           = "HotkeyShadow",
                checkboxValues  = {"UseHotkeyShadow"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["HotkeyShadowOffset"] = {
                type            = "checkboxSlider",
                name            = L.HotkeyShadowOffset,
                checkboxValue   = "UseHotkeyShadowOffset",
                sliderValue     = {"HotkeyShadowOffsetX", "HotkeyShadowOffsetY"},
                min             = -6,
                max             = 6,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["HotkeyScale"] = {
                type            = "checkboxSlider",
                name            = L.FontHotKeyScale,
                checkboxValue   = "FontHotKey",
                sliderValue     = "FontHotKeyScale",
                min             = 1,
                max             = 2,
                step            = 0.1,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.StacksFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentStacksFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentStacksFont", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    HUIDropdownMixin:RefreshStacksFont(frames.PreviewFont05, id)
                    HUIDropdownMixin:RefreshStacksFont(frames.PreviewFont075, id)
                    HUIDropdownMixin:RefreshStacksFont(frames.PreviewFont1, id)
                    HUIDropdownMixin:RefreshStacksFont(frames.PreviewFont15, id)
                    HUIDropdownMixin:RefreshStacksFont(frames.PreviewFont2, id)
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksOutline"] = {
                type        = "dropdown",
                setting     = Addon.FontOutlines,
                name        = L.StacksOutline,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentStacksOutline", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentStacksOutline", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    HUIDropdownMixin:RefreshFontPreview()
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksSize"] = {
                type            = "checkboxSlider",
                name            = L.FontStacksSize,
                checkboxValue   = "UseStacksFontSize",
                sliderValue     = "StacksFontSize",
                min             = 1,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksColor"] = {
                type            = "colorSwatch",
                name            = L.StacksCustomColor,
                value           = "StacksColor",
                checkboxValues  = {"UseStacksColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.StacksAttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentStacksPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentStacksRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentStacksPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentStacksRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                },
                OnClose     = {
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        Addon:RefreshButtons()
                    end,
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        Addon:RefreshButtons()
                    end,
                },
            },
            ["StacksOffset"] = {
                type            = "checkboxSlider",
                name            = L.StacksOffset,
                checkboxValue   = "UseStacksOffset",
                sliderValue     = {"StacksOffsetX", "StacksOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksShadow"] = {
                type            = "colorSwatch",
                name            = L.StacksShadowColor,
                value           = "StacksShadow",
                checkboxValues  = {"UseStacksShadow"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksShadowOffset"] = {
                type            = "checkboxSlider",
                name            = L.StacksShadowOffset,
                checkboxValue   = "UseStacksShadowOffset",
                sliderValue     = {"StacksShadowOffsetX", "StacksShadowOffsetY"},
                min             = -6,
                max             = 6,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["StacksScale"] = {
                type            = "checkboxSlider",
                name            = L.FontStacksScale,
                checkboxValue   = "FontStacks",
                sliderValue     = "FontStacksScale",
                min             = 1,
                max             = 2,
                step            = 0.1,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["NameHide"] = {
                type            = "checkbox",
                name            = L.FontHideName,
                value           = "FontHideName",
                callback        = function(_, frames) 
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["NameScale"] = {
                type            = "checkboxSlider",
                name            = L.FontNameScale,
                checkboxValue   = "FontName",
                sliderValue     = "FontNameScale",
                min             = 1,
                max             = 2,
                step            = 0.1,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    Addon:RefreshButtons()
                end,
            },
            ["PreviewFont05"] = {
                type = "preview",
                sub    = "Font",
            },
            ["PreviewFont075"] = {
                type = "preview",
                sub    = "Font",
            },
            ["PreviewFont1"] = {
                type = "preview",
                sub    = "Font",
            },
            ["PreviewFont15"] = {
                type = "preview",
                sub    = "Font",
            },
            ["PreviewFont2"] = {
                type = "preview",
                sub    = "Font",
            },
        }
    },
    BarsOptionsContainer = {
        title = L.ActionBarSettingTitle,
        desc = L.ActionBarSettingDesc,
        new = true,
        childs = {
            ["BarOrientation"] = {
                type        = "dropdown",
                setting     = Addon.FontOutlines,
                name        = "Orientation",
                IsSelected  = function(id) return id == Addon:GetValue("BarOrientation", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("BarOrientation", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames)
                    Addon:RefreshButtons()
                end,
                OnClose     = function()
                    Addon:RefreshButtons()
                end,
            },
            ["RowsNumber"] = {
                type            = "checkboxSlider",
                name            = "Rows Number",
                checkboxValue   = "UseRowsNumber",
                sliderValue     = "RowsNumber",
                min             = 1,
                max             = 12,
                step            = 1,
                sliderName      = {top = L.Rows},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    if frameName == "GlobalSettings" then
                        Addon:UpdateAllActionBarGrid()
                    else
                        local frame = _G[frameName]
                        Addon:UpdateActionBarGrid(frame)
                    end
                end,
            },
            ["ColumnsNumber"] = {
                type            = "checkboxSlider",
                name            = "Columns Number",
                checkboxValue   = "UseColumnsNumber",
                sliderValue     = "ColumnsNumber",
                min             = 1,
                max             = 12,
                step            = 1,
                sliderName      = {top = L.Columns},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    if frameName == "GlobalSettings" then
                        Addon:UpdateAllActionBarGrid()
                    else
                        local frame = _G[frameName]
                        Addon:UpdateActionBarGrid(frame)
                    end
                end,
            },
            ["ButtonsNumber"] = {
                type            = "checkboxSlider",
                name            = "Buttons Number",
                checkboxValue   = "UseButtonsNumber",
                sliderValue     = "ButtonsNumber",
                min             = 1,
                max             = 12,
                step            = 1,
                sliderName      = {top = L.Buttons},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    if frameName == "GlobalSettings" then
                        Addon:UpdateAllActionBarGrid()
                    else
                        local frame = _G[frameName]
                        Addon:UpdateActionBarGrid(frame)
                    end
                end,
            },
            ["BarsPadding"] = {
                type            = "checkboxSlider",
                name            = L.Padding,
                checkboxValue   = "UseBarPadding",
                sliderValue     = "CurrentBarPadding",
                min             = -5,
                max             = 50,
                step            = 1,
                sliderName      = {top = L.Padding},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    if frameName == "GlobalSettings" then
                        Addon:UpdateAllActionBarGrid()
                    else
                        local frame = _G[frameName]
                        Addon:UpdateActionBarGrid(frame)
                    end
                end,
            },
            ["ButtonSize"] = {
                type            = "checkboxSlider",
                name            = "Button Size",
                checkboxValue   = "UseButtonSize",
                sliderValue     = {"ButtonSizeX", "ButtonSizeY"},
                min             = 10,
                max             = 50,
                step            = 1,
                sliderName      = {{top = "size X"}, {top = "size Y"}},
                callback        = function() Addon:RefreshButtons() end,
            },
            ["CenteredGrid"] = {
                type            = "checkbox",
                name            = L.CDMCenteredGrid,
                value           = "GridCentered",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    if frameName == "GlobalSettings" then
                        Addon:UpdateAllActionBarGrid()
                    else
                        local frame = _G[frameName]
                        Addon:UpdateActionBarGrid(frame)
                    end
                end,
            },
            ["BarGrow"] = {
                type        = "dropdown",
                setting     = Addon.BarsVerticalGrow,
                name        = L.BarGrow,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentBarGrow", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentBarGrow", id, true) end,
                showNew     = false,
                OnEnter     = false,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    if frameName == "GlobalSettings" then
                        Addon:UpdateAllActionBarGrid()
                    else
                        local frame = _G[frameName]
                        Addon:UpdateActionBarGrid(frame)
                    end
                end,
            },
            ["RightClickPassThrough"] = {
                type            = "checkbox",
                name            = L.RightClickPassThrough,
                value           = "RightClickPassThrough",
                callback        = false,
            },
        }
    },

    ---------------------------------
    -------------PRESETS-------------
    ---------------------------------
    PresetsOptionsContainer = {
        title = L.QuickPresets,
        desc = L.QuickPresetsDesc,
        new = true,
        childs = {}
    },

    ---------------------------------
    ---------COOLDOWN VIEWER---------
    ---------------------------------
    CooldownViewerCDContainer = {
        title = L.CDMCooldownTitle,
        desc = L.CDMCooldownDesc,
        childs = {
            ["CDMItemSize"] = {
                type            = "checkboxSlider",
                name            = L.CDMItemSize,
                checkboxValue   = "CDMUseItemSize",
                sliderValue     = "CDMItemSize",
                min             = 10,
                max             = 80,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMSwipeTexture"] = {
                type        = "dropdown",
                setting     = T.SwipeTextures,
                name        = L.SwipeTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentSwipeTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentSwipeTexture", id, true) end,
                showNew     = false,
                OnEnter     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMSwipeSize"] = {
                type            = "checkboxSlider",
                name            = L.SwipeSize,
                checkboxValue   = "UseSwipeSize",
                sliderValue     = "SwipeSize",
                min             = 20,
                max             = 60,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMSwipeColor"] = {
                type            = "colorSwatch",
                name            = L.CDMSwipeColor,
                value           = "CooldownColor",
                checkboxValues  = {"UseCooldownColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },

            ["ShowCountdownNumbersForCharges"] = {
                type            = "checkbox",
                name            = L.ShowCountdownNumbersForCharges,
                value           = "ShowCountdownNumbersForCharges",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
            },

            ["CDMAuraRemoveSwipe"] = {
                type            = "checkbox",
                name            = L.CDMAuraRemoveSwipe,
                value           = "CDMAuraRemoveSwipe",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMAuraSwipeColor"] = {
                type            = "colorSwatch",
                name            = L.CDMAuraSwipeColor,
                value           = "CooldownAuraColor",
                checkboxValues  = {"UseCooldownAuraColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMAuraTimerColor"] = {
                type            = "colorSwatch",
                name            = L.CDMAuraTimerColor,
                value           = "CDMAuraTimerColor",
                checkboxValues  = {"UseCDMAuraTimerColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMReverseSwipe"] = {
                type            = "checkbox",
                name            = L.CDMReverseSwipe,
                value           = "CDMReverseSwipe",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMAuraReverseSwipe"] = {
                type            = "checkbox",
                name            = L.CDMAuraReverseSwipe,
                value           = "CDMAuraReverseSwipe",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMRemoveGCDSwipe"] = {
                type            = "checkbox",
                name            = L.CDMRemoveGCDSwipe,
                value           = "CDMRemoveGCDSwipe",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMEdgeTexture"] = {
                type        = "dropdown",
                setting     = T.EdgeTextures,
                name        = L.EdgeTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentEdgeTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentEdgeTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMEdgeSize"] = {
                type            = "checkboxSlider",
                name            = L.EdgeSize,
                checkboxValue   = "UseEdgeSize",
                sliderValue     = "EdgeSize",
                min             = 0.5,
                max             = 2,
                step            = 0.1,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMEdgeColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "EdgeColor",
                checkboxValues  = {"UseEdgeColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMEdgeAlwaysShow"] = {
                type            = "checkbox",
                name            = L.EdgeAlwaysShow,
                value           = "EdgeAlwaysShow",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["PreviewSwipe"] = {
                type = "preview",
                sub = "CooldownSwipe",
            },
            ["PreviewAuraSwipe"] = {
                type = "preview",
                aura = true,
                sub = "CooldownSwipe",
            },
            ["PreviewEdge"] = {
                type = "preview",
                sub    = "CooldownEdge",
            },
        }
    },
    CooldownViewerFontContainer = {
        title = L.FontTitle,
        desc = L.FontDesc,
        childs = {
            ["CDMCooldownFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.CooldownFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCooldownFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCooldownFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMCooldownFontSize"] = {
                type            = "checkboxSlider",
                name            = L.CooldownFontSize,
                checkboxValue   = "UseCooldownFontSize",
                sliderValue     = "CooldownFontSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMCooldownFontOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCooldownFontOffset",
                sliderValue     = {"CooldownFontOffsetX", "CooldownFontOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMCooldownFontColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "CooldownFontColor",
                checkboxValues  = {"UseCooldownFontColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMStacksFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.StacksFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentStacksFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentStacksFont", id, true) end,
                showNew     = false,
                OnEnter     = function()
                    HUIDropdownMixin:RefreshFontPreview()
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMStacksPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.StacksAttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentStacksPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentStacksRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentStacksPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentStacksRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                },
                OnClose     = {
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        CooldownManagerEnhanced:ForceUpdate(frameName)
                    end,
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        CooldownManagerEnhanced:ForceUpdate(frameName)
                    end,
                },
            },
            ["CDMStacksOffset"] = {
                type            = "checkboxSlider",
                name            = L.StacksOffset,
                checkboxValue   = "UseStacksOffset",
                sliderValue     = {"StacksOffsetX", "StacksOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMStacksFontSize"] = {
                type            = "checkboxSlider",
                name            = L.FontStacksSize,
                checkboxValue   = "UseStacksFontSize",
                sliderValue     = "StacksFontSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMStacksFontColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "StacksColor",
                checkboxValues  = {"UseStacksColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMNameFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.NameFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMNameFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMNameFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMNameFontSize"] = {
                type            = "checkboxSlider",
                name            = L.FontNameSize,
                checkboxValue   = "UseNameCDMFontSize",
                sliderValue     = "NameCDMFontSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMNameFontColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "NameCCDMFontColor",
                checkboxValues  = {"UseNameCDMFontColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMColorizedCooldownFont"] = {
                type            = "checkbox",
                name            = L.ColorizedCooldownFont,
                value           = "ColorizedCooldownFont",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                    CooldownManagerEnhanced:RefreshFormatters(frameName)
                end,
            },
            ["CDMColorizedAuraFont"] = {
                type            = "checkbox",
                name            = L.ColorizedAuraFont,
                value           = "ColorizedAuraFont",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                    CooldownManagerEnhanced:RefreshFormatters(frameName)
                end,
            },
            ["CDMCooldownFormatType"] = {
                type            = "dropdown",
                name            = L.CooldownFormatType,
                setting         = Addon.CooldownFormatType,
                IsSelected  = function(id) return id == Addon:GetValue("CDMCooldownFormatType", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMCooldownFormatType", id, true) end,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                    CooldownManagerEnhanced:RefreshFormatters(frameName)
                end,
            },
            ["CDMCooldownTimerFormat"] = {
                type            = "dropdown",
                name            = L.CooldownTimerFormat,
                setting         = Addon.CooldownTimerFormat,
                showNew         = true,
                IsSelected  = function(id) return id == Addon:GetValue("CooldownTimerFormat", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CooldownTimerFormat", id, true) end,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                    CooldownManagerEnhanced:RefreshFormatters(frameName)
                end,
            },
            ["CDMCooldownMilliseconds"] = {
                type            = "checkboxSlider",
                name            = L.CooldownMilliseconds,
                showNew         = true,
                checkboxValue   = "UseCooldownMilliseconds",
                sliderValue     = "CooldownMillisecondsThreshold",
                min             = 1,
                max             = 60,
                step            = 1,
                sliderName      = {top = L.CooldownMillisecondsBelow},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                    CooldownManagerEnhanced:RefreshFormatters(frameName)
                end,
            },
            ["PreviewCooldownFont"] = {
                type = "preview",
                sub    = "CooldownFont",
            },
            ["PreviewFont"] = {
                type = "preview",
                sub    = "Font",
            },
        }
    },
    CooldownViewerBackdropContainer = {
        title = L.IconBorderTitle,
        desc = L.IconBorderDesc,
        childs = {
            ["BackdropSize"] = {
                type            = "checkboxSlider",
                name            = L.CDMBackdrop,
                checkboxValue   = "UseCDMBackdrop",
                sliderValue     = "CDMBackdropSize",
                min             = 1,
                max             = 10,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["BackdropColor"] = {
                type            = "colorSwatch",
                name            = L.CDMBackdropColor,
                value           = "CDMBackdropColor",
                checkboxValues  = {"UseCDMBackdropColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["BackdropAuraColor"] = {
                type            = "colorSwatch",
                name            = L.CDMBackdropAuraColor,
                value           = "CDMBackdropAuraColor",
                checkboxValues  = {"UseCDMBackdropAuraColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["BackdropPandemicColor"] = {
                type            = "colorSwatch",
                name            = L.CDMBackdropPandemicColor,
                value           = "CDMBackdropPandemicColor",
                checkboxValues  = {"UseCDMBackdropPandemicColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
        }
            
    },
    CooldownViewerBarContainer = {
        title = L.CDMBarContainerTitle,
        desc = L.CDMBarContainerDesc,
        childs = {
            ["IconSize"] = {
                type            = "checkboxSlider",
                name            = L.IconSize,
                checkboxValue   = "UseCDMBarIconSize",
                sliderValue     = "CDMBarIconSize",
                min             = 10,
                max             = 60,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["BarHeight"] = {
                type            = "checkboxSlider",
                name            = L.BarHeight,
                checkboxValue   = "UseCDMBarHeight",
                sliderValue     = "CDMBarHeight",
                min             = 10,
                max             = 60,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["BarOffset"] = {
                type            = "checkboxSlider",
                name            = L.BarOffset,
                checkboxValue   = "UseCDMBarOffset",
                sliderValue     = "CDMBarOffset",
                min             = 0,
                max             = 200,
                step            = 1,
                sliderName      = {top = L.Offset},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMBarTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StatusBarTextures,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMStatusBarTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMStatusBarTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMBarColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "CDMBarColor",
                checkboxValues  = {"UseCDMBarColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMBarBGTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StatusBarBGTextures,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMBGTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMBGTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMBarBGColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "CDMBarBGColor",
                checkboxValues  = {"UseCDMBarBGColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMBarGrow"] = {
                type        = "dropdown",
                setting     = Addon.BarsVerticalGrow,
                name        = L.BarGrow,
                IsSelected  = function(id) return id == Addon:GetValue("CDMVerticalGrowth", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMVerticalGrowth", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMPipTexture"] = {
                type        = "dropdown",
                setting     = function() return T.PipTextures end,
                name        = L.BarPipTexture,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMPipTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMPipTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["PipSize"] = {
                type            = "checkboxSlider",
                name            = L.BarPipSize,
                checkboxValue   = "CDMUseBarPipSize",
                sliderValue     = {"CDMBarPipSizeX", "CDMBarPipSizeY"},
                min             = 1,
                max             = 60,
                step            = 1,
                sliderName      = {{top = L.SizeX}, {top = L.SizeY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
        }
    },
    CooldownViewerContainer = {
        title = L.CDMOptionsTitle,
        desc = L.CDMOptionsDesc,
        childs = {
            ["CDMEnable"] = {
                type            = "checkbox",
                name            = L.Enable,
                value           = "CDMEnable",
                callback        = function()
                    Addon:CDM_SetHooks()
                end,
            },
            ["CDMBarVerticalGrowth"] = {
                type        = "dropdown",
                setting     = Addon.BarsVerticalGrow,
                name        = L.VerticalGrowth,
                IsSelected  = function(id) return id == Addon:GetValue("CDMVerticalGrowth", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMVerticalGrowth", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["CDMBarHorizontalGrowth"] = {
                type        = "dropdown",
                setting     = Addon.BarsHorizontalGrow,
                name        = L.HorizontalGrowth,
                IsSelected  = function(id) return id == Addon:GetValue("CDMHorizontalGrowth", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMHorizontalGrowth", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["IconPadding"] = {
                type            = "checkboxSlider",
                name            = L.IconPadding,
                checkboxValue   = "UseCDMIconPadding",
                sliderValue     = "CDMIconPadding",
                min             = -10,
                max             = 50,
                step            = 1,
                sliderName      = {top = L.Padding},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["GridLayoutType"] = {
                type        = "dropdown",
                setting     = Addon.GridLayoutType,
                name        = L.GridLayoutType,
                IsSelected  = function(id) return id == Addon:GetValue("CDMGridLayoutType", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMGridLayoutType", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["HideWhenInactive"] = {
                type        = "dropdown",
                setting     = Addon.GridLayoutHideActive,
                name        = L.HideWhenInactive,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentHideWhenInactive", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentHideWhenInactive", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["RemoveIconMask"] = {
                type            = "checkbox",
                name            = L.CDMRemoveIconMask,
                value           = "CDMRemoveIconMask",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["RemovePandemicAnims"] = {
                type            = "checkbox",
                name            = L.CDMRemovePandemic,
                value           = "CDMRemovePandemic",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["RemoveAuraTypeBorder"] = {
                type            = "checkbox",
                name            = L.CDMRemoveAuraTypeBorder,
                value           = "CDMRemoveAuraTypeBorder",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            
            
            
            ["RemoveDesaturation"] = {
                type            = "checkbox",
                name            = L.RemoveDesaturation,
                value           = "CDMRemoveDesaturation",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
        }
    },
    CooldownViewerIconContainer = {
        title = L.IconTitle,
        desc = L.IconDesc,
        childs = {
            ["IconMaskTextureOptions"] = {
                type        = "dropdown",
                setting     = T.IconMaskTextures,
                name        = L.IconMaskTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentIconMaskTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentIconMaskTexture", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshIconMaskTexture(frames.PreviewIcon, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["MaskScale"] = {
                type            = "checkboxSlider",
                name            = L.IconMaskScale,
                checkboxValue   = "UseIconMaskScale",
                sliderValue     = "IconMaskScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["IconScale"] = {
                type            = "checkboxSlider",
                name            = L.IconScale,
                checkboxValue   = "UseIconScale",
                sliderValue     = "IconScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    CooldownManagerEnhanced:ForceUpdate(frameName)
                end,
            },
            ["PreviewIcon"] = {
                type = "preview",
            },
        }
    },

    CDMCustomFrameContainer = {
        title = L.CDMCustomFrameTitle,
        desc = L.CDMCustomFrameDesc,
        childs = {
            ["CDMEnable"] = {
                type            = "checkbox",
                name            = L.Enable,
                value           = "CDMEnable",
            },
            ["CDMCustomPing"] = {
                type            = "checkbox",
                name            = L.CDMCustomPingTitle,
                value           = "CDMCustomPingEnabled",
            },
            ["CDMCustomItemListFrame"] = {
                type        = "itemList",
                name        = "Item List",
            },
            ["CDMCustomFrameEditBox"] = {
                type            = "editbox",
                name            = L.CDMCustomFrameName,
                defaultText     = function()
                    local frame = _G[HUI_BarsListMixin:GetFrameLebel()]
                    if frame then
                        local frameName = frame:GetDisplayName()
                        return frameName
                    end
                end,
                OnEnterPressed  = function(self)
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    local name = self:GetText()
                    self.currentName = name
                    if frame then
                        frame:SetDisplayName(name)
                        frame:SaveDisplayName(name)
                        EventRegistry:TriggerEvent("CDMCustomItemList.RenameFrame", frameName, name)
                    end
                    self:ClearFocus()
                end,
                OnEditFocusLost = function(self)
                    self:SetText(self.currentName)
                end,
                OnEditFocusGained = function(self)
                    self.currentName = self:GetText()
                end,
            },
            ["CDMCustomFrameDeleteButton"] = {
                type            = "button",
                name            = L.CDMCustomFrameDelete,
                buttonName      = L.Delete,
                OnClick         = function(self)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    EventRegistry:TriggerEvent("CDMCustomItemList.DeleteFrame", frameLabel)
                end
            },
            ["CDMCustomFrameAddSpellByID"] = {
                type            = "editbox",
                name            = L.CDMCustomFrameAddSpellByID,
                defaultText     = "",
                numeric         = true,
                OnEnterPressed  = function(self)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local id = self:GetText()
                    EventRegistry:TriggerEvent("CDMCustomItemList.AddSpellByID", id, frameLabel)
                    self:ClearFocus()
                    self:SetText("")
                end,
            },
            ["CDMCustomFrameAddItemByID"] = {
                type            = "editbox",
                name            = L.CDMCustomFrameAddItemByID,
                defaultText     = "",
                numeric         = true,
                OnEnterPressed  = function(self)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local id = self:GetText()
                    EventRegistry:TriggerEvent("CDMCustomItemList.AddItemByID", id, frameLabel)
                    self:ClearFocus()
                    self:SetText("")
                end,
            },
            ["CDMCustomTrackTrink1"] = {
                type            = "checkbox",
                name            = L.CDMCustomFrameTrackSlot13,
                value           = "CDMCustomTrackTrink1",
                callback        = function(checked)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    EventRegistry:TriggerEvent("CDMCustomItemList.AddItemBySlot", 13, frameLabel, checked)
                end
            },
            ["CDMCustomTrackTrink2"] = {
                type            = "checkbox",
                name            = L.CDMCustomFrameTrackSlot14,
                value           = "CDMCustomTrackTrink2",
                callback        = function(checked)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    EventRegistry:TriggerEvent("CDMCustomItemList.AddItemBySlot", 14, frameLabel, checked)
                end
            },
            ["CDMCustomTrackWeapon1"] = {
                type            = "checkbox",
                name            = L.CDMCustomFrameTrackSlot16,
                value           = "CDMCustomTrackWeapon1",
                callback        = function(checked)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    EventRegistry:TriggerEvent("CDMCustomItemList.AddItemBySlot", 16, frameLabel, checked)
                end
            },
            ["CDMCustomTrackWeapon2"] = {
                type            = "checkbox",
                name            = L.CDMCustomFrameTrackSlot17,
                value           = "CDMCustomTrackWeapon2",
                callback        = function(checked)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    EventRegistry:TriggerEvent("CDMCustomItemList.AddItemBySlot", 17, frameLabel, checked)
                end
            },
            ["CDMCustomTrackRacial"] = {
                type            = "checkbox",
                name            = L.CDMCustomFrameTrackRacial,
                value           = "CDMCustomTrackRacial",
                callback        = function(checked)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    EventRegistry:TriggerEvent("CDMCustomItemList.AddRacial", frameLabel, checked)
                end
            },
            ["CDMCustomHideWhenEmpty"] = {
                type            = "checkbox",
                name            = L.CDMCustomFrameHideWhen0,
                value           = "CDMCustomHideEmpty",
                callback        = function(checked)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:RefreshLayout()
                end
            },
            ["CDMCustomAlphaWhenNotCD"] = {
                type            = "checkboxSlider",
                name            = L.CDMCustomFrameAlphaOnCD,
                checkboxValue   = "UseCDMCustomAlphaNoCD",
                sliderValue     = "CDMCustomAlphaNoCD",
                min             = 0,
                max             = 1,
                step            = 0.1,
                sliderName      = {top = L.Alpha},
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:RefreshLayout()
                end,
            },
        }
    },
    CDMCustomFrameGridContainer = {
        title = L.CDMCustomFrameGridLayoutTitle,
        desc = L.CDMCustomFrameGridLayoutDesc,
        childs = {
            ["CDMCustomFrameBarSize"] = {
                type            = "checkboxSlider",
                name            = L.CDMCustomFrameBarWidth,
                checkboxValue   = "UseCDMCustomFrameBarWidth",
                sliderValue     = "CDMCustomFrameBarWidth",
                min             = 10,
                max             = 500,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshBarWidth(frame, frameName)
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameItemSize"] = {
                type            = "checkboxSlider",
                name            = L.CDMCustomFrameElementSize,
                checkboxValue   = "UseCDMCustomItemSize",
                sliderValue     = "CDMCustomItemSize",
                min             = 20,
                max             = 80,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshItemSize(frame, frameName)
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameIconPadding"] = {
                type            = "checkboxSlider",
                name            = L.IconPadding,
                checkboxValue   = "UseCDMCustomIconPadding",
                sliderValue     = "CDMCustomIconPadding",
                min             = -10,
                max             = 50,
                step            = 1,
                sliderName      = {top = L.Padding},
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetGridPadding()
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameStride"] = {
                type            = "checkboxSlider",
                name            = L.Stride,
                checkboxValue   = "UseCDMCustomStride",
                sliderValue     = "CDMCustomStride",
                min             = 1,
                max             = 20,
                step            = 1,
                sliderName      = {top = L.Columns},
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetGridStride()
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameCenteredGrid"] = {
                type            = "checkbox",
                name            = L.CenteredLayout,
                value           = "CDMCustomCenteredLayout",
                callback        = function(checked)
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetGridCentered(checked)
                    frame:RefreshLayout()
                end
            },
            ["CDMCustomFrameGridLayoutType"] = {
                type        = "dropdown",
                setting     = Addon.GridLayoutType,
                name        = L.GridLayoutType,
                IsSelected  = function(id) return id == Addon:GetValue("CDMGridLayoutType", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMGridLayoutType", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetupGridLayoutParams()
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameHideWhenInactive"] = {
                type        = "dropdown",
                setting     = Addon.GridLayoutHideActive,
                name        = L.HideWhenInactive,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentHideWhenInactive", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentHideWhenInactive", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetupGridLayoutParams()
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameVerticalGrowth"] = {
                type        = "dropdown",
                setting     = Addon.BarsVerticalGrow,
                name        = L.VerticalGrowth,
                IsSelected  = function(id) return id == Addon:GetValue("CDMVerticalGrowth", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMVerticalGrowth", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetGridVerticalGrowth()
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameHorizontalGrowth"] = {
                type        = "dropdown",
                setting     = Addon.BarsHorizontalGrow,
                name        = L.HorizontalGrowth,
                IsSelected  = function(id) return id == Addon:GetValue("CDMHorizontalGrowth", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMHorizontalGrowth", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetGridHorizontalGrowth()
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameGridDirection"] = {
                type        = "dropdown",
                setting     = Addon.GridDirection,
                name        = L.GridDirection,
                IsSelected  = function(id) return id == Addon:GetValue("CDMCustomGridDirection", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMCustomGridDirection", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    frame:SetGridDirection()
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameStrata"] = {
                type        = "dropdown",
                setting     = Addon.FrameStratas,
                name        = L.FrameStrata,
                IsSelected  = function(id) return id == Addon:GetValue("CDMCustomFrameStrata", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMCustomFrameStrata", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameLabel)
                end,
            },
            ["CDMCustomFrameLevel"] = {
                type            = "checkboxSlider",
                name            = L.FrameLevel,
                checkboxValue   = "UseCDMCustomFrameLevel",
                sliderValue     = "CDMCustomFrameLevel",
                min             = 0,
                max             = 100,
                step            = 1,
                sliderName      = {top = L.Level},
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameLabel)
                end,
            },

            ["CDMCustomFrameBarWidth"] = {
                type            = "checkboxSlider",
                name            = L.Width,
                checkboxValue   = "UseCDMCustomFrameBarWidth",
                sliderValue     = "CDMCustomFrameBarWidth",
                min             = 10,
                max             = 800,
                step            = 1,
                sliderName      = {top = L.Width},
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshBarSize(frame, frameLabel)
                    frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameBarHeight"] = {
                type            = "checkboxSlider",
                name            = L.Height,
                checkboxValue   = "UseCDMCustomFrameBarHeight",
                sliderValue     = "CDMCustomFrameBarHeight",
                min             = 10,
                max             = 100,
                step            = 1,
                sliderName      = {top = L.Height},
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshBarSize(frame, frameLabel)
                    frame:RefreshLayout()
                end,
            },

            ["CDMCustomFrameStatusbarTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StatusBarTextures,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMCustomFrameStatusbarTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMCustomFrameStatusbarTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshBarTextures(frame, frameLabel)
                    --frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameBackgroundTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StatusBarBGTextures,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMCustomFrameBackgroundTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMCustomFrameBackgroundTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshBarTextures(frame, frameLabel)
                    --frame:RefreshLayout()
                end,
            },
            ["CDMCustomFrameBackgroundColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomBGColor,
                value           = "CDMCustomFrameBackgroundColor",
                checkboxValues  = {"UseCDMCustomFrameBackgroundColor"},
                alpha           = true,
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshBarTextures(frame, frameLabel)
                    --frame:RefreshLayout()
                end,
            },
            ["CDMCustomFramePipTexture"] = {
                type        = "dropdown",
                setting     = function() return T.PipTextures end,
                name        = L.BarPipTexture,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMCustomFramePipTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMCustomFramePipTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshPipTexture(frame, frameName)
                end,
            },
            ["CDMCustomFramePipSize"] = {
                type            = "checkboxSlider",
                name            = L.BarPipSize,
                checkboxValue   = "UseCDMCustomFramePipSize",
                sliderValue     = {"CDMCustomFramePipSizeX", "CDMCustomFramePipSizeY"},
                min             = 1,
                max             = 60,
                step            = 1,
                sliderName      = {{top = L.SizeX}, {top = L.SizeY}},
                callback        = function()
                    local frameLabel = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameLabel]
                    HUI_CDMCustomFrameCustomized:RefreshPipTexture(frame, frameName)
                end,
            },
        }
    },
    CDMCustomFrameAttachContainer = {
        title = L.AttachTitle,
        desc = L.AttachDesc,
        childs = {
            ["CDMEnableAttach"] = {
                type            = "checkbox",
                name            = L.EnableAttach,
                value           = "CDMEnableAttach",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshAnchors(frame, frameName)
                end,
            },
            ["CDMCustomFrameAttachTo"] = {
                type            = "editboxPicker",
                name            = L.CDMCustomFrameAttachFrameName,
                numLetters      = 100,
                pickerButtonName = L.FramePickerSelect,
                pickerOnClick   = function(self)
                    Addon.FramePicker:Start(function(frameName)
                        local editBox = self:GetParent().EditBox
                        editBox:SetText(frameName)
                        editBox.currentName = frameName
                        Addon:SaveSetting("CurrentAttachFrame", frameName, true)
                        local customFrameName = HUI_BarsListMixin:GetFrameLebel()
                        local customFrame = _G[customFrameName]
                        HUI_CDMCustomFrameCustomized:RefreshAnchors(customFrame, customFrameName)
                    end)
                end,
                defaultText     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local name = Addon:GetValue("CurrentAttachFrame", nil, frameName)
                    return name or ""
                end,
                OnEnterPressed  = function(self)
                    local frameName = self:GetText():match("^%s*(.-)%s*$")
                    if frameName == "" then
                        self.currentName = ""
                        Addon:SaveSetting("CurrentAttachFrame", "", true)
                        local customFrameName = HUI_BarsListMixin:GetFrameLebel()
                        local customFrame = _G[customFrameName]
                        HUI_CDMCustomFrameCustomized:RefreshAnchors(customFrame, customFrameName)
                    else
                        local frame = _G[frameName]
                        if frame then
                            self.currentName = frameName

                            Addon:SaveSetting("CurrentAttachFrame", frameName, true)
                            local customFrameName = HUI_BarsListMixin:GetFrameLebel()
                            local customFrame = _G[customFrameName]
                            HUI_CDMCustomFrameCustomized:RefreshAnchors(customFrame, customFrameName)
                        else
                            Addon.Print("Cant find frame with name: |cffff0000", frameName)
                        end
                    end
                    self:ClearFocus()
                end,
                OnEditFocusLost = function(self)
                    self:SetText(self.currentName)
                end,
                OnEditFocusGained = function(self)
                    self.currentName = self:GetText()
                end,
            },
            ["CDMCustomFrameAttachPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.CDMCutomFrameAttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentAttachPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentAttachRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentAttachPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentAttachRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    false,
                    false,
                },
                OnClose     = {
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CDMCustomFrameCustomized:RefreshAnchors(frame, frameName)
                    end,
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CDMCustomFrameCustomized:RefreshAnchors(frame, frameName)
                    end,
                },
            },
            ["CDMCustomFrameAttachOffset"] = {
                type            = "checkboxSlider",
                name            = L.CDMCutomFrameAttachOffset,
                checkboxValue   = "UseAttachOffset",
                sliderValue     = {"AttachOffsetX", "AttachOffsetY"},
                min             = -100,
                max             = 100,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshAnchors(frame, frameName)
                end,
            },
        }
    },
    CDMCustomFrameIconContainer = {
        title = L.IconTitle,
        desc = L.IconDesc,
        childs = {
            ["CDMCustomFrameIconMaskTexture"] = {
                type        = "dropdown",
                setting     = T.IconMaskTextures,
                name        = L.IconMaskTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentIconMaskTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentIconMaskTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameMaskScale"] = {
                type            = "checkboxSlider",
                name            = L.IconMaskScale,
                checkboxValue   = "UseIconMaskScale",
                sliderValue     = "IconMaskScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameIconScale"] = {
                type            = "checkboxSlider",
                name            = L.IconScale,
                checkboxValue   = "UseIconScale",
                sliderValue     = "IconScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["PreviewIcon"] = {
                type = "preview",
            },
        }
    },
    CDMCustomFrameCDContainer = {
        title = L.CDMCooldownTitle,
        desc = L.CDMCooldownDesc,
        childs = {
            ["CDMCustomFrameShowSwipe"] = {
                type            = "checkbox",
                name            = L.CDMAuraShowSwipe,
                value           = "CDMAuraShowSwipe",
                showNew         = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshAuraSwipe(frame, frameName)
                end,
            },
            ["CDMCustomFrameSwipeTexture"] = {
                type        = "dropdown",
                setting     = T.SwipeTextures,
                name        = L.SwipeTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentSwipeTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentSwipeTexture", id, true) end,
                showNew     = false,
                OnEnter     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameSwipeSize"] = {
                type            = "checkboxSlider",
                name            = L.SwipeSize,
                checkboxValue   = "UseSwipeSize",
                sliderValue     = "SwipeSize",
                min             = 20,
                max             = 60,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameSwipeColor"] = {
                type            = "colorSwatch",
                name            = L.CDMSwipeColor,
                value           = "CooldownColor",
                checkboxValues  = {"UseCooldownColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["ShowCountdownNumbersForCharges"] = {
                type            = "checkbox",
                name            = L.ShowCountdownNumbersForCharges,
                value           = "ShowCountdownNumbersForCharges",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                end,
            },

            ["CDMCustomFrameRemoveAuraSwipe"] = {
                type            = "checkbox",
                name            = L.CDMAuraRemoveSwipe,
                value           = "CDMAuraRemoveSwipe",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    if frame and frame.RefreshLayout then
                        frame:RefreshLayout()
                    end
                end,
            },
            ["CDMCustomFrameAuraSwipeColor"] = {
                type            = "colorSwatch",
                name            = L.CDMAuraSwipeColor,
                value           = "CooldownAuraColor",
                checkboxValues  = {"UseCooldownAuraColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameAuraTimerColor"] = {
                type            = "colorSwatch",
                name            = L.CDMAuraTimerColor,
                value           = "CDMAuraTimerColor",
                checkboxValues  = {"UseCDMAuraTimerColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameReverseSwipe"] = {
                type            = "checkbox",
                name            = L.CDMReverseSwipe,
                value           = "CDMReverseSwipe",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameAuraReverseSwipe"] = {
                type            = "checkbox",
                name            = L.CDMAuraReverseSwipe,
                value           = "CDMAuraReverseSwipe",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameRemoveGCDSwipe"] = {
                type            = "checkbox",
                name            = L.CDMRemoveGCDSwipe,
                value           = "CDMRemoveGCDSwipe",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameShowEdge"] = {
                type            = "checkbox",
                name            = L.CDMAuraShowEdge,
                value           = "CDMAuraShowEdge",
                showNew         = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshAuraEdge(frame, frameName)
                end,
            },
            ["CDMCustomFrameEdgeTexture"] = {
                type        = "dropdown",
                setting     = T.EdgeTextures,
                name        = L.EdgeTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentEdgeTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentEdgeTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameEdgeSize"] = {
                type            = "checkboxSlider",
                name            = L.EdgeSize,
                checkboxValue   = "UseEdgeSize",
                sliderValue     = "EdgeSize",
                min             = 0.5,
                max             = 2,
                step            = 0.1,
                sliderName      = {top = L.Scale},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameEdgeColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "EdgeColor",
                checkboxValues  = {"UseEdgeColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameEdgeAlwaysShow"] = {
                type            = "checkbox",
                name            = L.EdgeAlwaysShow,
                value           = "EdgeAlwaysShow",
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["PreviewSwipe"] = {
                type = "preview",
                sub = "CooldownSwipe",
            },
            ["PreviewAuraSwipe"] = {
                type = "preview",
                aura = true,
                sub = "CooldownSwipe",
            },
            ["PreviewEdge"] = {
                type = "preview",
                sub    = "CooldownEdge",
            },
        }
    },
    CDMCustomFrameBackdropContainer = {
        title = L.IconBorderTitle,
        desc = L.IconBorderDesc,
        childs = {
            ["CDMCustomFrameBackdropSize"] = {
                type            = "checkboxSlider",
                name            = L.CDMBackdrop,
                checkboxValue   = "UseCDMBackdrop",
                sliderValue     = "CDMBackdropSize",
                min             = 1,
                max             = 10,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameBackdropColor"] = {
                type            = "colorSwatch",
                name            = L.CDMBackdropColor,
                value           = "CDMBackdropColor",
                checkboxValues  = {"UseCDMBackdropColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameBackdropAuraColor"] = {
                type            = "colorSwatch",
                name            = L.CDMBackdropAuraColor,
                value           = "CDMBackdropAuraColor",
                checkboxValues  = {"UseCDMBackdropAuraColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameBackdropPandemicColor"] = {
                type            = "colorSwatch",
                name            = L.CDMBackdropPandemicColor,
                value           = "CDMBackdropPandemicColor",
                checkboxValues  = {"UseCDMBackdropPandemicColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
            ["CDMCustomFrameRemovePandemic"] = {
                type            = "checkbox",
                name            = L.CDMRemovePandemic,
                value           = "CDMRemovePandemic",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshSkin(frame, frameName)
                end,
            },
        }
            
    },
    CDMCustomFrameGlowContainer = {
        title = L.GlowTypeTitle,
        desc = L.GlowTypeDesc,
        childs = {
            ["GlowOptions"] = {
                type        = "dropdown",
                setting     = T.LoopGlow,
                name        = L.GlowType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentLoopGlow", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentLoopGlow", id, true) end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshProcLoop(frames.ProcLoopPreview, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshLoopGlow(frame, frameName)
                end,
            },
            ["CustomColorGlow"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "LoopGlowColor",
                checkboxValues  = {"UseLoopGlowColor", "DesaturateGlow"},
                alpha           = false,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshLoopGlow(frame, frameName)
                end,
            },
            ["ProcLoopPreview"] = {
                type = "preview",
                sub = "LoopGlow",
            },
            ["HideProc"] = {
                type        = "checkbox",
                name        = L.HideProcAnim,
                value       = "HideProc",
                callback    = false,
            },
            ["ProcOptions"] = {
                type        = "dropdown",
                setting     = T.ProcGlow,
                name        = L.StartProcType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentProcGlow", nil, true) end,
                OnSelect    = function(id, frames)
                    Addon:SaveSetting("CurrentProcGlow", id, true)
                end,
                showNew     = false,
                OnEnter     = function(id, frames) HUIDropdownMixin:RefreshProcStart(frames.ProcStartPreview, id) end,
                OnClose     = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshLoopGlow(frame, frameName)
                end,
            },
            ["CustomColorProc"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "ProcColor",
                checkboxValues  = {"UseProcColor", "DesaturateProc"},
                alpha           = false,
                callback        = function()
                    HUIDropdownMixin:RefreshAllPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshLoopGlow(frame, frameName)
                end,
            },
            ["ProcStartPreview"] = {
                type = "preview",
                sub = "ProcGlow",
            }
        }
    },
    CDMCustomFrameFontContainer = {
        title = L.FontTitle,
        desc = L.FontDesc,
        childs = {
            ["CDMCustomFrameShowTimer"] = {
                type            = "checkbox",
                name            = L.CDMAuraShowTimer,
                value           = "CDMAuraShowTimer",
                showNew         = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshAuraTimerVisibility(frame, frameName)
                end,
            },
            ["CDMCooldownFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.CooldownFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCooldownFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCooldownFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMCooldownFontSize"] = {
                type            = "checkboxSlider",
                name            = L.CooldownFontSize,
                checkboxValue   = "UseCooldownFontSize",
                sliderValue     = "CooldownFontSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMCooldownFontOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCooldownFontOffset",
                sliderValue     = {"CooldownFontOffsetX", "CooldownFontOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshCooldownPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMCooldownFontColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "CooldownFontColor",
                checkboxValues  = {"UseCooldownFontColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFrame(frame, frameName, true)
                end,
            },
            ["CDMColorizedCooldownFont"] = {
                type            = "checkbox",
                name            = L.ColorizedCooldownFont,
                value           = "ColorizedCooldownFont",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFrame(frame, frameName, true)
                end,
            },
            ["CDMColorizedAuraFont"] = {
                type            = "checkbox",
                name            = L.ColorizedAuraFont,
                value           = "ColorizedAuraFont",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFrame(frame, frameName, true)
                end,
            },
            ["CDMCooldownFormatType"] = {
                type            = "dropdown",
                name            = L.CooldownFormatType,
                setting         = Addon.CooldownFormatType,
                IsSelected  = function(id) return id == Addon:GetValue("CDMCooldownFormatType", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CDMCooldownFormatType", id, true) end,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFrame(frame, frameName, true)
                end,
            },
            ["CDMCustomCooldownTimerFormat"] = {
                type            = "dropdown",
                name            = L.CooldownTimerFormat,
                setting         = Addon.CooldownTimerFormat,
                showNew         = true,
                IsSelected  = function(id) return id == Addon:GetValue("CooldownTimerFormat", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CooldownTimerFormat", id, true) end,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFrame(frame, frameName, true)
                end,
            },
            ["CDMCustomCooldownMilliseconds"] = {
                type            = "checkboxSlider",
                name            = L.CooldownMilliseconds,
                showNew         = true,
                checkboxValue   = "UseCooldownMilliseconds",
                sliderValue     = "CooldownMillisecondsThreshold",
                min             = 1,
                max             = 60,
                step            = 1,
                sliderName      = {top = L.CooldownMillisecondsBelow},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFrame(frame, frameName, true)
                end,
            },

            ["CDMCustomFrameShowStacks"] = {
                type            = "checkbox",
                name            = L.CDMAuraShowStacks,
                value           = "CDMAuraShowStacks",
                showNew         = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = frameName and _G[frameName]
                    if frame then
                        HUI_CDMCustomFrameCustomized:RefreshAuraStacks(frame, frameName)
                    end
                end,
            },
            ["CDMAlwaysShowStacks"] = {
                type            = "checkbox",
                name            = L.AlwaysShowStacks,
                value           = "AlwaysShowStacks",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    if frame and frame.RefreshLayout then
                        frame:RefreshLayout()
                    end
                end,
            },
            ["CDMStacksFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.StacksFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentStacksFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentStacksFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMStacksPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.StacksAttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentStacksPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentStacksRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentStacksPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentStacksRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                    function() HUIDropdownMixin:RefreshFontPreview() end,
                },
                OnClose     = {
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                    end,
                    function()
                        HUIDropdownMixin:RefreshFontPreview()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                    end,
                },
            },
            ["CDMStacksOffset"] = {
                type            = "checkboxSlider",
                name            = L.StacksOffset,
                checkboxValue   = "UseStacksOffset",
                sliderValue     = {"StacksOffsetX", "StacksOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMStacksFontSize"] = {
                type            = "checkboxSlider",
                name            = L.FontStacksSize,
                checkboxValue   = "UseStacksFontSize",
                sliderValue     = "StacksFontSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMStacksFontColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "StacksColor",
                checkboxValues  = {"UseStacksColor"},
                alpha           = true,
                callback        = function()
                    HUIDropdownMixin:RefreshFontPreview()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMNameFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.NameFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCDMNameFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCDMNameFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMNameFontSize"] = {
                type            = "checkboxSlider",
                name            = L.FontNameSize,
                checkboxValue   = "UseNameCDMFontSize",
                sliderValue     = "NameCDMFontSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["CDMNameFontColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "NameCCDMFontColor",
                checkboxValues  = {"UseNameCDMFontColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CDMCustomFrameCustomized:RefreshCooldownFont(frame, frameName)
                end,
            },
            ["PreviewCooldownFont"] = {
                type = "preview",
                sub    = "CooldownFont",
            },
            ["PreviewFont"] = {
                type = "preview",
                sub    = "Font",
            },
        }
    },
    CastBarsOptionsContainer = {
        title = L.CastBarsOptionsTitle,
        desc = L.CastBarsOptionsDesc,
        childs = {
            ["CastBarEnable"] = {
                type            = "checkbox",
                name            = L.Enable,
                value           = "CastBarEnable",
                callback        = function()

                end,
            },
            ["CastBarWidth"] = {
                type            = "checkboxSlider",
                name            = L.Width,
                checkboxValue   = "UseCastBarWidth",
                sliderValue     = "CastBarWidth",
                min             = 10,
                max             = 800,
                step            = 1,
                sliderName      = {top = L.Width},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarHeight"] = {
                type            = "checkboxSlider",
                name            = L.Height,
                checkboxValue   = "UseCastBarHeight",
                sliderValue     = "CastBarHeight",
                min             = 10,
                max             = 100,
                step            = 1,
                sliderName      = {top = L.Height},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },

            ["CastBarPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.AttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentCastBarPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentCastBarRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentCastBarPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentCastBarRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    false,
                    false,
                },
                OnClose     = {
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        --HUI_CastingBarMixin.SetLook(frame)
                        HUI_CastingBarMixin.AdjustPosition(frame)
                    end,
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        --HUI_CastingBarMixin.SetLook(frame)
                        HUI_CastingBarMixin.AdjustPosition(frame)
                    end,
                },
            },
            ["CastBarOffsetX"] = {
                type            = "checkboxSlider",
                name            = L.OffsetX,
                checkboxValue   = "UseCastBarOffsetX",
                sliderValue     = "CastBarOffsetX",
                min             = -1000,
                max             = 1000,
                step            = 1,
                sliderName      = {top = L.Offset},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    --HUI_CastingBarMixin.SetLook(frame)
                    HUI_CastingBarMixin.AdjustPosition(frame)
                end,
            },
            ["CastBarOffsetY"] = {
                type            = "checkboxSlider",
                name            = L.OffsetY,
                checkboxValue   = "UseCastBarOffsetY",
                sliderValue     = "CastBarOffsetY",
                min             = -1000,
                max             = 1000,
                step            = 1,
                sliderName      = {top = L.Offset},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    --HUI_CastingBarMixin.SetLook(frame)
                    HUI_CastingBarMixin.AdjustPosition(frame)
                end,
            },
            ["CastBarStatusbarTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StatusBarTextures,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarStatusbarTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarStatusbarTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetStatusBarTexture(frame)
                end,
            },
            ["CastBarBackgroundTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StatusBarBGTextures,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarBackgroundTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarBackgroundTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetStatusBarTexture(frame)
                end,
            },
            ["CastBarBackgroundColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomBGColor,
                value           = "CastBarBackgroundColor",
                checkboxValues  = {"UseCastBarBackgroundColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetStatusBarTexture(frame)
                end,
            },
            ["CastBarPipTexture"] = {
                type        = "dropdown",
                setting     = function() return T.PipTextures end,
                name        = L.BarPipTexture,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarPipTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarPipTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.ShowSpark(frame)
                end,
            },
            ["PipSize"] = {
                type            = "checkboxSlider",
                name            = L.BarPipSize,
                checkboxValue   = "UseCastBarPipSize",
                sliderValue     = {"CastBarPipSizeX", "CastBarPipSizeY"},
                min             = 1,
                max             = 60,
                step            = 1,
                sliderName      = {{top = L.SizeX}, {top = L.SizeY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.ShowSpark(frame)
                end,
            },
            ["CastHideTextBorder"] = {
                type            = "checkbox",
                name            = L.CastHideTextBorder,
                value           = "CastHideTextBorder",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastHideInterruptAnim"] = {
                type            = "checkbox",
                name            = L.CastHideInterruptAnim,
                value           = "CastHideInterruptAnim",
            },
            ["CastQuickFinish"] = {
                type            = "checkbox",
                name            = L.CastQuickFinish,
                value           = "CastQuickFinish",
            },
            ["CastBarShieldIconTexture"] = {
                type        = "dropdown",
                setting     = function() return T.CastBarShieldIcons end,
                name        = L.ShieldIconTexture,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarShieldIconTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarShieldIconTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetStatusBarTexture(frame)
                end,
            },
            ["CastBarShieldIconSize"] = {
                type            = "checkboxSlider",
                name            = L.Size,
                checkboxValue   = "UseCastBarShieldIconSize",
                sliderValue     = "CastBarShieldIconSize",
                min             = 5,
                max             = 100,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarShieldIconPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.AttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentCastBarShieldIconPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentCastBarShieldIconRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentCastBarShieldIconPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentCastBarShieldIconRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    false,
                    false,
                },
                OnClose     = {
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                },
            },
            ["CastBarShieldIconOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCastBarShieldIconOffset",
                sliderValue     = {"CastBarShieldIconOffsetX", "CastBarShieldIconOffsetY"},
                min             = -100,
                max             = 100,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },

            ["CastBarStandardColor"] = {
                type            = "colorSwatch",
                name            = L.CastBarStandartColor,
                value           = "CastBarStandardColor",
                checkboxValues  = {"UseCastBarStandardColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    frame.__forceUpdate = true
                end,
            },
            ["CastBarImportantColor"] = {
                type            = "colorSwatch",
                name            = L.CastBarImportantColor,
                value           = "CastBarImportantColor",
                checkboxValues  = {"UseCastBarImportantColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    frame.__forceUpdate = true
                end,
            },
            ["CastBarChannelColor"] = {
                type            = "colorSwatch",
                name            = L.CastBarChannelColor,
                value           = "CastBarChannelColor",
                checkboxValues  = {"UseCastBarChannelColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    frame.__forceUpdate = true
                end,
            },
            ["CastBarUninterruptableColor"] = {
                type            = "colorSwatch",
                name            = L.CastBarUninterruptableColor,
                value           = "CastBarUninterruptableColor",
                checkboxValues  = {"UseCastBarUninterruptableColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    frame.__forceUpdate = true
                end,
            },
            ["CastBarInterruptedColor"] = {
                type            = "colorSwatch",
                name            = L.CastBarInterruptedColor,
                value           = "CastBarInterruptedColor",
                checkboxValues  = {"UseCastBarInterruptedColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    frame.__forceUpdate = true
                end,
            },
            ["CastBarReadyColor"] = {
                type            = "colorSwatch",
                name            = L.CastBarReadyColor,
                value           = "CastBarReadyColor",
                checkboxValues  = {"UseCastBarReadyColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    frame.__forceUpdate = true
                end,
            },
        }
        
    },
    CastBarsIconOptionsContainer = {
        title = L.CastBarsIconOptionsTitle,
        desc = L.CastBarsIconOptionsDesc,
        childs = {
            ["CastBarIconSize"] = {
                type            = "checkboxSlider",
                name            = L.IconSize,
                checkboxValue   = "UseCastBarIconSize",
                sliderValue     = "CastBarIconSize",
                min             = 10,
                max             = 80,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["CastBarIconPosition"] = {
                type        = "dropdown",
                setting     = Addon.CastingBarIconPosition,
                name        = L.CastBarIconPos,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarIconPos", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarIconPos", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["CastBarIconPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.AttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentCastBarIconPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentCastBarIconRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentCastBarIconPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentCastBarIconRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    false,
                    false,
                },
                OnClose     = {
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.UpdateIconShown(frame)
                    end,
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.UpdateIconShown(frame)
                    end,
                },
            },
            ["CastBarIconOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCastBarIconOffset",
                sliderValue     = {"CastBarIconOffsetX", "CastBarIconOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["IconMaskTextureOptions"] = {
                type        = "dropdown",
                setting     = T.IconMaskTextures,
                name        = L.IconMaskTextureType,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentIconMaskTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentIconMaskTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["MaskScale"] = {
                type            = "checkboxSlider",
                name            = L.IconMaskScale,
                checkboxValue   = "UseIconMaskScale",
                sliderValue     = "IconMaskScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["IconScale"] = {
                type            = "checkboxSlider",
                name            = L.IconScale,
                checkboxValue   = "UseIconScale",
                sliderValue     = "IconScale",
                min             = 0.5,
                max             = 1.5,
                step            = 0.01,
                sliderName      = {top = L.Scale},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
        }
    },
    CastBarsSQWLatencyOptionsContainer = {
        title = L.CastBarsSQWLatencyOptionsTitle,
        desc = L.CastBarsSQWLatencyOptionsDesc,
        childs = {
            ["CastBarShowLatency"] = {
                type            = "checkbox",
                name            = L.Enable,
                value           = "CastBarShowLatency",
                callback        = function()

                end,
            },
            ["CastBarLatencyTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StacksFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarLatencyTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarLatencyTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarLatencyColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "CastBarLatencyColor",
                checkboxValues  = {"UseCastBarLatencyColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },

            ["CastBarShowSQW"] = {
                type            = "checkbox",
                name            = L.Enable,
                value           = "CastBarShowSQW",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarSQWTexture"] = {
                type        = "dropdown",
                statusBar   = true,
                setting     = function() return T.StatusBarTextures end,
                name        = L.StacksFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarSQWTexture", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarSQWTexture", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarSQWColor"] = {
                type            = "colorSwatch",
                name            = L.UseCustomColor,
                value           = "CastBarSQWColor",
                checkboxValues  = {"UseCastBarSQWColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
        }
    },
    CastBarsFontContainer = {
        title = L.FontTitle,
        desc = L.CastBarsFontDesc,
        childs = {
            ["CastBarCastNameFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.NameFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarCastNameFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarCastNameFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastNameSize"] = {
                type            = "checkboxSlider",
                name            = L.FontNameSize,
                checkboxValue   = "UseCastBarCastNameSize",
                sliderValue     = "CastBarCastNameSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastNameColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "CastBarCastNameColor",
                checkboxValues  = {"UseCastBarCastNameColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastNamePoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.AttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentCastBarCastNamePoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentCastBarCastNameRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentCastBarCastNamePoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentCastBarCastNameRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    false,
                    false,
                },
                OnClose     = {
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                },
            },
            ["CastBarCastNameOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCastBarCastNameOffset",
                sliderValue     = {"CastBarCastNameOffsetX", "CastBarCastNameOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastNameJustifyH"] = {
                type        = "dropdown",
                setting     = Addon.BarTextJustifyH,
                name        = L.JustifyH,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarCastNameJustifyH", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarCastNameJustifyH", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },

            ["CastBarCastTimeFormat"] = {
                type        = "dropdown",
                setting     = Addon.CastingBarCastTimeFormat,
                name        = L.CastTimeFormat,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarCastTimeFormat", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarCastTimeFormat", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastTimeFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.TimerFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarCastTimeFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarCastTimeFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["CastBarCastTimeSize"] = {
                type            = "checkboxSlider",
                name            = L.FontTimerSize,
                checkboxValue   = "UseCastBarCastTimeSize",
                sliderValue     = "CastBarCastTimeSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["CastBarCastTimeColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "CastBarCastTimeColor",
                checkboxValues  = {"UseCastBarCastTimeColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.UpdateIconShown(frame)
                end,
            },
            ["CastBarCastTimePoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.AttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentCastBarCastTimePoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentCastBarCastTimeRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentCastBarCastTimePoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentCastBarCastTimeRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    false,
                    false,
                },
                OnClose     = {
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                },
            },
            ["CastBarCastTimeOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCastBarCastTimeOffset",
                sliderValue     = {"CastBarCastTimeOffsetX", "CastBarCastTimeOffsetY"},
                min             = -40,
                max             = 40,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastTimeJustifyH"] = {
                type        = "dropdown",
                setting     = Addon.BarTextJustifyH,
                name        = L.JustifyH,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarCastTimeJustifyH", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarCastTimeJustifyH", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },

            ["CastBarCastTargetEnable"] = {
                type            = "checkbox",
                name            = L.EnableSpellTargetName,
                value           = "CastBarCastTargetEnable",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastTargetFont"] = {
                type        = "dropdown",
                fontOption  = true,
                setting     = function() return Addon.Fonts end,
                name        = L.SpellTargetFont,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarCastTargetFont", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarCastTargetFont", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastTargetSize"] = {
                type            = "checkboxSlider",
                name            = L.SpellTargetSize,
                checkboxValue   = "UseCastBarCastTargetSize",
                sliderValue     = "CastBarCastTargetSize",
                min             = 5,
                max             = 40,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastTargetColor"] = {
                type            = "colorSwatch",
                name            = L.FontColor,
                value           = "CastBarCastTargetColor",
                checkboxValues  = {"UseCastBarCastTargetColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastTargetPoint"] = {
                type        = "dropdown",
                setting     = {Addon.AttachPoints, Addon.AttachPoints},
                name        = L.AttachPoint,
                IsSelected  = {
                    function(id) return id == Addon:GetValue("CurrentCastBarCastTargetPoint", nil, true) end,
                    function(id) return id == Addon:GetValue("CurrentCastBarCastTargetRelativePoint", nil, true) end,
                },
                OnSelect    = {
                    function(id) Addon:SaveSetting("CurrentCastBarCastTargetPoint", id, true) end,
                    function(id) Addon:SaveSetting("CurrentCastBarCastTargetRelativePoint", id, true) end,
                },
                showNew     = false,
                OnEnter     = {
                    false,
                    false,
                },
                OnClose     = {
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                    function()
                        local frameName = HUI_BarsListMixin:GetFrameLebel()
                        local frame = _G[frameName]
                        HUI_CastingBarMixin.SetLook(frame)
                    end,
                },
            },
            ["CastBarCastTargetOffset"] = {
                type            = "checkboxSlider",
                name            = L.Offset,
                checkboxValue   = "UseCastBarCastTargetOffset",
                sliderValue     = {"CastBarCastTargetOffsetX", "CastBarCastTargetOffsetY"},
                min             = -100,
                max             = 100,
                step            = 1,
                sliderName      = {{top = L.OffsetX}, {top = L.OffsetY}},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarCastTargetJustifyH"] = {
                type        = "dropdown",
                setting     = Addon.BarTextJustifyH,
                name        = L.JustifyH,
                IsSelected  = function(id) return id == Addon:GetValue("CurrentCastBarCastTargetJustifyH", nil, true) end,
                OnSelect    = function(id) Addon:SaveSetting("CurrentCastBarCastTargetJustifyH", id, true) end,
                showNew     = false,
                OnEnter     = false,
                OnClose     = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
        }
    },
    CastBarsBackdropContainer = {
        title = L.IconBorderTitle,
        desc = L.IconBorderDesc,
        childs = {
            ["CastBarsBackdropSize"] = {
                type            = "checkboxSlider",
                name            = L.CDMBackdrop,
                checkboxValue   = "UseCastBarsBackdrop",
                sliderValue     = "CastBarsBackdropSize",
                min             = 1,
                max             = 10,
                step            = 1,
                sliderName      = {top = L.Size},
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarsBackdropColor"] = {
                type            = "colorSwatch",
                name            = L.CDMBackdropColor,
                value           = "CastBarsBackdropColor",
                checkboxValues  = {"UseCastBarsBackdropColor"},
                alpha           = true,
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
            ["CastBarsBackdropColorByType"] = {
                type            = "checkbox",
                name            = L.ColorByCastbarType,
                value           = "CastBarsBackdropColorByType",
                callback        = function()
                    local frameName = HUI_BarsListMixin:GetFrameLebel()
                    local frame = _G[frameName]
                    HUI_CastingBarMixin.SetLook(frame)
                end,
            },
        }
    },
}

function Addon:BuildPresetsPreview()
    local containerLayout
    for _, layout in ipairs(Addon.layoutPresets) do
        if layout.name == "PresetsOptionsContainer" then
            containerLayout = layout
            break
        end
    end
    if not containerLayout then return end

    local containerCfg = Addon.config.containers.PresetsOptionsContainer
    wipe(containerLayout.childs)
    wipe(containerCfg.childs)

    for i, profileName in ipairs(HUIProfilesMixin:GetProfiles()) do
        local presetName = "Preset_"..i
        table.insert(containerLayout.childs, { name = presetName, template = "OptionsPresetsTemplate", scale = "1.8" })
        containerCfg.childs[presetName] = {
            type = "previewPreset",
            sub = "Font",
            text = profileName,
            preset = profileName,
        }
    end
end

function Addon:RefreshPresetsPreview()
    Addon:BuildPresetsPreview()
    if HUIDropdownMixin and HUIDropdownMixin.presetButtons then
        wipe(HUIDropdownMixin.presetButtons)
    end
    if HUIOptionsFrame and HUIMixin.currentLayout == Addon.layoutPresets then
        HUIMixin:InitData(Addon.layoutPresets)
    end
end

function Addon:BuildContainerChildren(container, containerDef, containerConfig, childList)
    

    local frames = {}
    frames[containerDef.name] = container

    for k, childDef in ipairs(containerDef.childs) do
        local childType = childDef.template:find("Button") and "CheckButton" or "Frame"

        local child = CreateFrame(childType, nil, container, childDef.template)

        if childDef.point then
            local parentName = childDef.point[2]
            local parent
            if parentName == "container" then
                parent = container
            elseif parentName == "desc" then
                parent = container.Desc
            elseif parentName == "title" then
                parent = container.Title
            else
                parent = frames[parentName]
            end 
            child:SetPoint(childDef.point[1], parent, childDef.point[3], childDef.point[4], childDef.point[5])
        else
            if k == 1 then
                child:SetPoint("TOP", container.Desc, "BOTTOM", 0, -10)
            else
                local prev = containerDef.childs[k-1]
                child:SetPoint("TOP", frames[prev.name], "BOTTOM", 0, -10)
            end
        end

        if childDef.scale then
            child:SetScale(childDef.scale)
        end

        frames[childDef.name] = child

        if containerConfig and containerConfig.childs then
            local childConfig = containerConfig.childs[childDef.name]
            if childConfig then
                Addon:InitChildElement(child, childConfig, frames)
            end
        end

        table.insert(childList, child)
    end
end

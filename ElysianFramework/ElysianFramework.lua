local _, Elysian = ...

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("MERCHANT_SHOW")
events:RegisterEvent("PLAYER_LOGOUT")

local savedReady = false

local function ApplySavedSettings()
  if Elysian.Features and Elysian.Features.CursorRing and Elysian.state then
    Elysian.Features.CursorRing:SetEnabled(Elysian.state.cursorRingEnabled)
    if Elysian.state.cursorRingEnabled then
      Elysian.Features.CursorRing:ApplyShape()
      Elysian.Features.CursorRing:ApplyColors()
      Elysian.Features.CursorRing:UpdateVisibility()
      Elysian.Features.CursorRing:UpdateTrail(0, 0, 0)
    end
  end
  if Elysian.Features and Elysian.Features.InfoBar then
    Elysian.Features.InfoBar:Initialize()
  end
  if Elysian.Features and Elysian.Features.RepairReminder then
    Elysian.Features.RepairReminder:Initialize()
  end
  if Elysian.Features and Elysian.Features.DungeonReminder then
    Elysian.Features.DungeonReminder:Initialize()
  end
  if Elysian.Features and Elysian.Features.DeathSound then
    Elysian.Features.DeathSound:Initialize()
  end
  if Elysian.Features and Elysian.Features.BuffWatch then
    Elysian.Features.BuffWatch:Initialize()
  end
  if Elysian.Features and Elysian.Features.DungeonConsumables then
    Elysian.Features.DungeonConsumables:Initialize()
  end
  if Elysian.Features and Elysian.Features.KeystoneReminder then
    Elysian.Features.KeystoneReminder:Initialize()
  end
  if Elysian.Features and Elysian.Features.ClassBuffReminders then
    Elysian.Features.ClassBuffReminders:Initialize()
  end
  if Elysian.Features and Elysian.Features.WarlockReminders then
    Elysian.Features.WarlockReminders:Initialize()
  end
  if Elysian.Features and Elysian.Features.HunterReminders then
    Elysian.Features.HunterReminders:Initialize()
  end
  if Elysian.Features and Elysian.Features.AutoKeystone then
    Elysian.Features.AutoKeystone:Initialize()
  end
end

events:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" then
    if arg1 == Elysian.name then
      if Elysian.InitSavedVariables then
        Elysian.InitSavedVariables()
      end
      savedReady = true
    end
  elseif event == "PLAYER_LOGIN" then
    if not savedReady and Elysian.InitSavedVariables then
      Elysian.InitSavedVariables()
    end
    if Elysian.UI then
      Elysian.UI:CreateMainFrame()
    end
    if Elysian.MinimapButton then
      Elysian.MinimapButton:Create()
    end
    if C_Timer and Elysian.MinimapButton then
      C_Timer.After(1.0, function()
        if Elysian.MinimapButton then
          Elysian.MinimapButton:Create()
        end
      end)
      C_Timer.After(3.0, function()
        if Elysian.MinimapButton then
          Elysian.MinimapButton:Create()
        end
      end)
    end
    if MinimapCluster and MinimapCluster.HookScript and Elysian.MinimapButton then
      MinimapCluster:HookScript("OnShow", function()
        Elysian.MinimapButton:Create()
      end)
    end
    if Minimap and Minimap.HookScript and Elysian.MinimapButton then
      Minimap:HookScript("OnShow", function()
        Elysian.MinimapButton:Create()
      end)
    end
    if Elysian.Features and Elysian.Features.CursorRing then
      Elysian.Features.CursorRing:Initialize()
    end
    if Elysian.ApplyGameMenuTheme then
      Elysian.ApplyGameMenuTheme()
    end
    if GameMenuFrame and GameMenuFrame.HookScript and Elysian.ApplyGameMenuTheme then
      GameMenuFrame:HookScript("OnShow", Elysian.ApplyGameMenuTheme)
    end

    if Elysian.UI then
      local show = true
      if ElysianDB and ElysianDB.showOnStart == false then
        show = false
      elseif Elysian.state and Elysian.state.showOnStart == false then
        show = false
      end
      if show then
        Elysian.UI:Show()
      else
        Elysian.UI:Hide()
      end
      if show and C_Timer then
        C_Timer.After(0.2, function()
          if Elysian.UI then
            local frame = Elysian.UI.mainFrame or Elysian.UI:CreateMainFrame()
            frame:Show()
          end
        end)
      end
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    ApplySavedSettings()
  elseif event == "MERCHANT_SHOW" then
    if Elysian.Features and Elysian.Features.ScrapSeller then
      Elysian.Features.ScrapSeller:OnMerchantShow()
    end
    if Elysian.Features and Elysian.Features.AutoRepair then
      Elysian.Features.AutoRepair:OnMerchantShow()
    end
  elseif event == "PLAYER_LOGOUT" then
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end
end)

SLASH_ELYSIANFRAME1 = "/elysianframe"
SLASH_ELYSIANFRAME2 = "/elysiumframe"
SLASH_ELYSIANFRAME3 = "/elysian"
SlashCmdList["ELYSIANFRAME"] = function()
  if Elysian.UI then
    Elysian.UI:Toggle()
  end
end

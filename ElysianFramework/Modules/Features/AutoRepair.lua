local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local AutoRepair = {}
Elysian.Features.AutoRepair = AutoRepair

local DURABILITY_SLOTS = { 1, 3, 5, 6, 7, 8, 9, 10, 16, 17 }

local function GetLowestDurability()
  local lowest = nil
  for _, slot in ipairs(DURABILITY_SLOTS) do
    local cur, max = GetInventoryItemDurability(slot)
    if cur and max and max > 0 then
      local pct = (cur / max) * 100
      if not lowest or pct < lowest then
        lowest = pct
      end
    end
  end
  return lowest
end

function AutoRepair:IsEnabled()
  return Elysian.state.autoRepairEnabled and true or false
end

function AutoRepair:SetEnabled(enabled)
  Elysian.state.autoRepairEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function AutoRepair:OnMerchantShow()
  if not self:IsEnabled() then
    return
  end
  if not CanMerchantRepair or not RepairAllItems then
    return
  end
  if not CanMerchantRepair() then
    return
  end

  local threshold = tonumber(Elysian.state.autoRepairThreshold or 0) or 0
  if threshold > 0 then
    local pct = GetLowestDurability()
    if pct and pct > threshold then
      return
    end
  end

  local cost, canRepair = GetRepairAllCost()
  if not canRepair or cost <= 0 then
    return
  end
  local useGuild = Elysian.state.autoRepairUseGuild and CanGuildBankRepair and CanGuildBankRepair()
  if useGuild then
    RepairAllItems(true)
  else
    RepairAllItems()
  end
  Elysian.state.autoRepairLastCost = cost
  Elysian.state.autoRepairLastUsedGuild = useGuild and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  if self.summaryText then
    self.summaryText:SetText("")
  end
end

function AutoRepair:CreatePanel(parent)
  local panel = CreateFrame("Frame", nil, parent)
  panel:SetAllPoints()

  local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 8, -8)
  title:SetText("Auto Repair")
  Elysian.ApplyFont(title, 13, "OUTLINE")
  Elysian.ApplyTextColor(title)

  local toggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  toggle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -4, -6)
  toggle.text = toggle.text or _G[toggle:GetName() .. "Text"]
  toggle.text:SetText("Enable auto repair")
  Elysian.ApplyFont(toggle.text, 14)
  Elysian.ApplyTextColor(toggle.text)
  Elysian.StyleCheckbox(toggle)
  toggle:SetChecked(self:IsEnabled())
  toggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    AutoRepair:SetEnabled(selfButton:GetChecked())
  end)
  self.toggle = toggle

  local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  hint:SetPoint("TOPLEFT", toggle, "BOTTOMLEFT", 4, -4)
  hint:SetText("Repairs all gear when you open a repair-capable vendor.")
  Elysian.ApplyFont(hint, 10)
  Elysian.ApplyTextColor(hint)

  local guildToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  guildToggle:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", -4, -10)
  guildToggle.text = guildToggle.text or _G[guildToggle:GetName() .. "Text"]
  guildToggle.text:SetText("Use guild bank funds when available")
  Elysian.ApplyFont(guildToggle.text, 12)
  Elysian.ApplyTextColor(guildToggle.text)
  Elysian.StyleCheckbox(guildToggle)
  guildToggle:SetChecked(Elysian.state.autoRepairUseGuild)
  guildToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.autoRepairUseGuild = selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)
  self.guildToggle = guildToggle

  local thresholdLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  thresholdLabel:SetPoint("TOPLEFT", guildToggle, "BOTTOMLEFT", -4, -12)
  thresholdLabel:SetText("Repair threshold (%)")
  Elysian.ApplyFont(thresholdLabel, 11, "OUTLINE")
  Elysian.ApplyAccentColor(thresholdLabel)

  local slider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", thresholdLabel, "BOTTOMLEFT", 4, -18)
  slider:SetMinMaxValues(0, 100)
  slider:SetValueStep(1)
  slider:SetObeyStepOnDrag(true)
  slider:SetWidth(220)
  slider:SetValue(Elysian.state.autoRepairThreshold or 70)
  slider.Low:SetText("0")
  slider.High:SetText("100")
  slider.Text:SetText(string.format("%d%%", slider:GetValue()))
  slider:SetScript("OnValueChanged", function(selfSlider, value)
    value = math.floor(value + 0.5)
    selfSlider:SetValue(value)
    selfSlider.Text:SetText(string.format("%d%%", value))
    Elysian.state.autoRepairThreshold = value
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)
  self.thresholdSlider = slider

  panel:Hide()
  return panel
end

function AutoRepair:Refresh()
  if self.toggle then
    self.toggle:SetChecked(self:IsEnabled())
  end
  if self.guildToggle then
    self.guildToggle:SetChecked(Elysian.state.autoRepairUseGuild)
  end
  if self.thresholdSlider then
    local value = Elysian.state.autoRepairThreshold or 70
    self.thresholdSlider:SetValue(value)
    self.thresholdSlider.Text:SetText(string.format("%d%%", value))
  end
  if self.summaryText then
    self.summaryText:SetText("")
  end
end

local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local AutoRepair = {}
Elysian.Features.AutoRepair = AutoRepair

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

  local cost, canRepair = GetRepairAllCost()
  if not canRepair or cost <= 0 then
    return
  end

  RepairAllItems()
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

  panel:Hide()
  return panel
end

function AutoRepair:Refresh()
  if self.toggle then
    self.toggle:SetChecked(self:IsEnabled())
  end
end

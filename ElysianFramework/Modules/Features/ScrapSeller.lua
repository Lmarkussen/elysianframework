local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local ScrapSeller = {}
Elysian.Features.ScrapSeller = ScrapSeller

function ScrapSeller:IsEnabled()
  return Elysian.state.scrapSellerEnabled and true or false
end

function ScrapSeller:SetEnabled(enabled)
  Elysian.state.scrapSellerEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function ScrapSeller:SellScrap()
  for bag = 0, 4 do
    local slots = C_Container.GetContainerNumSlots(bag)
    for slot = 1, slots do
      local info = C_Container.GetContainerItemInfo(bag, slot)
      if info and info.quality == 0 and not info.isLocked then
        C_Container.UseContainerItem(bag, slot)
      end
    end
  end
end

function ScrapSeller:OnMerchantShow()
  if self:IsEnabled() then
    self:SellScrap()
  end
end

function ScrapSeller:CreatePanel(parent)
  local panel = CreateFrame("Frame", nil, parent)
  panel:SetAllPoints()

  local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 8, -8)
  title:SetText("Scrap Seller")
  Elysian.ApplyFont(title, 13, "OUTLINE")
  Elysian.ApplyTextColor(title)

  local toggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  toggle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -4, -6)
  toggle.text = toggle.text or _G[toggle:GetName() .. "Text"]
  toggle.text:SetText("Enable auto sell")
  Elysian.ApplyFont(toggle.text, 14)
  Elysian.ApplyTextColor(toggle.text)
  Elysian.StyleCheckbox(toggle)
  toggle:SetChecked(self:IsEnabled())
  toggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    ScrapSeller:SetEnabled(selfButton:GetChecked())
  end)
  self.toggle = toggle
  self.toggle = toggle

  local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  hint:SetPoint("TOPLEFT", toggle, "BOTTOMLEFT", 4, -4)
  hint:SetText("Sells gray-quality scrap when a vendor is opened.")
  Elysian.ApplyFont(hint, 10)
  Elysian.ApplyTextColor(hint)

  local infoButton = CreateFrame("Button", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
  infoButton:SetPoint("LEFT", toggle.text, "RIGHT", 8, 0)
  infoButton:SetSize(18, 18)
  Elysian.SetBackdrop(infoButton)
  Elysian.SetBackdropColors(infoButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local infoText = infoButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  infoText:SetPoint("CENTER")
  infoText:SetText("?")
  Elysian.ApplyFont(infoText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(infoText)
  if Elysian.UI and Elysian.UI.HookButtonPressFeedback then
    Elysian.UI.HookButtonPressFeedback(infoButton)
  end

  local function EnsureInfoFrame()
    if infoButton.infoFrame then
      return
    end
    local infoFrame = CreateFrame("Frame", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
    infoFrame:SetSize(220, 48)
    infoFrame:SetPoint("TOPLEFT", infoButton, "BOTTOMLEFT", -6, -6)
    Elysian.SetBackdrop(infoFrame)
    Elysian.SetBackdropColors(infoFrame, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)
    local label = infoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("CENTER")
    label:SetText("Vendors gray trash")
    Elysian.ApplyFont(label, 11, "OUTLINE")
    label:SetTextColor(1, 1, 1)
    infoFrame:Hide()
    infoButton.infoFrame = infoFrame
  end

  infoButton:SetScript("OnMouseDown", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    EnsureInfoFrame()
    infoButton.infoFrame:Show()
  end)
  infoButton:SetScript("OnMouseUp", function()
    if infoButton.infoFrame then
      infoButton.infoFrame:Hide()
    end
  end)
  infoButton:SetScript("OnLeave", function()
    if infoButton.infoFrame then
      infoButton.infoFrame:Hide()
    end
  end)

  panel:Hide()
  return panel
end

function ScrapSeller:Refresh()
  if self.toggle then
    self.toggle:SetChecked(self:IsEnabled())
  end
end

function ScrapSeller:Refresh()
  if self.toggle then
    self.toggle:SetChecked(self:IsEnabled())
  end
end

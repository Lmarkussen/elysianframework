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
  local total = 0
  local count = 0
  for bag = 0, 4 do
    local slots = C_Container.GetContainerNumSlots(bag)
    for slot = 1, slots do
      local info = C_Container.GetContainerItemInfo(bag, slot)
      if info and info.quality == 0 and not info.isLocked then
        local itemCount = info.stackCount or 1
        local itemPrice = info.sellPrice or 0
        C_Container.UseContainerItem(bag, slot)
        total = total + (itemPrice * itemCount)
        count = count + itemCount
      end
    end
  end
  if count > 0 then
    local gold = floor(total / (100 * 100))
    local silver = floor((total % (100 * 100)) / 100)
    local copper = total % 100
    print(string.format("Elysian: Sold %d items for %dg %ds %dc", count, gold, silver, copper))
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

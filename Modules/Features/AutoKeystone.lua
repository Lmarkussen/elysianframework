local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local AutoKeystone = {}
Elysian.Features.AutoKeystone = AutoKeystone

local ITEM_CLASS_REAGENT = Enum.ItemClass.Reagent
local ITEM_SUBCLASS_KEYSTONE = Enum.ItemReagentSubclass.Keystone
local BagItemId = C_Container.GetContainerItemID
local BagSlots = C_Container.GetContainerNumSlots
local ItemInfo = C_Item.GetItemInfo
local select = select
local BAG_MAX = NUM_BAG_FRAMES or 4

function AutoKeystone:IsEnabled()
  return Elysian.state.autoKeystoneEnabled and true or false
end

function AutoKeystone:SetEnabled(enabled)
  Elysian.state.autoKeystoneEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

local function TryInsertKeystone()
  if not AutoKeystone:IsEnabled() then
    return false
  end
  for bagIndex = 0, BAG_MAX do
    for slotIndex = 1, BagSlots(bagIndex) do
      local itemId = BagItemId(bagIndex, slotIndex)

      if itemId then
        local classId, subClassId = select(12, ItemInfo(itemId))

        if classId == ITEM_CLASS_REAGENT and subClassId == ITEM_SUBCLASS_KEYSTONE then
          C_Container.PickupContainerItem(bagIndex, slotIndex)

          if C_Cursor.GetCursorItem() then
            C_ChallengeMode.SlotKeystone()
            return true
          end
        end
      end
    end
  end

  return false
end

function AutoKeystone:EnsureEvents()
  if self.eventFrame then
    return
  end
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("ADDON_LOADED")
  frame:SetScript("OnEvent", function(selfFrame, _, addon)
    if addon ~= "Blizzard_ChallengesUI" then
      return
    end

    local receptacle = ChallengesKeystoneFrame
    if not receptacle then
      return
    end

    receptacle:HookScript("OnShow", function()
      if not TryInsertKeystone() then
        -- no keystone found
      end
    end)

    if not receptacle:IsMovable() then
      receptacle:SetMovable(true)
      receptacle:SetClampedToScreen(true)
      receptacle:RegisterForDrag("LeftButton")
      receptacle:SetScript("OnDragStart", receptacle.StartMoving)
      receptacle:SetScript("OnDragStop", receptacle.StopMovingOrSizing)
    end

    selfFrame:UnregisterEvent("ADDON_LOADED")
  end)
  self.eventFrame = frame
end

function AutoKeystone:CreatePanel(parent)
  local panel = CreateFrame("Frame", nil, parent)
  panel:SetAllPoints()

  local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 8, -8)
  title:SetText("Dungeons")
  Elysian.ApplyFont(title, 13, "OUTLINE")
  Elysian.ApplyTextColor(title)

  local enable = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  enable:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
  enable.text = enable.text or _G[enable:GetName() .. "Text"]
  enable.text:SetText("Auto-insert keystone")
  Elysian.ApplyFont(enable.text, 12)
  Elysian.ApplyTextColor(enable.text)
  Elysian.StyleCheckbox(enable)
  enable:SetChecked(self:IsEnabled())
  enable:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    AutoKeystone:SetEnabled(selfButton:GetChecked())
  end)
  self.enable = enable

  panel:Hide()
  return panel
end

function AutoKeystone:Refresh()
  if self.enable then
    self.enable:SetChecked(self:IsEnabled())
  end
end

function AutoKeystone:Initialize()
  self:EnsureEvents()
end

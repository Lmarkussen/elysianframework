local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local RepairReminder = {}
Elysian.Features.RepairReminder = RepairReminder

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

function RepairReminder:IsEnabled()
  return Elysian.state.repairReminderEnabled and true or false
end

function RepairReminder:SetEnabled(enabled)
  Elysian.state.repairReminderEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility()
end

function RepairReminder:SetUnlocked(unlocked)
  Elysian.state.repairReminderUnlocked = unlocked and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateMouse()
end

function RepairReminder:SetTestEnabled(enabled)
  Elysian.state.repairReminderTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateMouse()
  self:UpdateVisibility(true)
end

function RepairReminder:EnsureFrame()
  if self.frame then
    return
  end

  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianRepairReminder", UIParent, template)
  local w = (Elysian.state.repairReminderWidth and Elysian.state.repairReminderWidth > 0) and Elysian.state.repairReminderWidth or 360
  local h = (Elysian.state.repairReminderHeight and Elysian.state.repairReminderHeight > 0) and Elysian.state.repairReminderHeight or 46
  frame:SetSize(w, h)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, Elysian.GetBannerOffsetY())
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:EnableMouse(false)
  frame:RegisterForDrag()
  frame:SetScript("OnDragStart", function(selfFrame)
    if Elysian.state.repairReminderUnlocked or Elysian.state.repairReminderTest then
      selfFrame:StartMoving()
    end
  end)
  frame:SetScript("OnDragStop", function(selfFrame)
    selfFrame:StopMovingOrSizing()
    if Elysian.SaveState then
      local px, py = UIParent:GetCenter()
      local fx, fy = selfFrame:GetCenter()
      if px and py and fx and fy then
        Elysian.state.repairReminderPos = { "CENTER", "CENTER", fx - px, fy - py }
      end
      Elysian.SaveState()
    end
  end)

  Elysian.SetBackdrop(frame)
  self.frame = frame

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  text:SetPoint("CENTER")
  text:SetText("REPAIR GEAR")
  Elysian.ApplyFont(text, 16, "OUTLINE")
  self.text = text

  self:ApplySize()
  self:ApplyColors()
  self:ApplyPosition()
  self:UpdateMouse()
  self:UpdateVisibility(true)

  frame:SetScript("OnUpdate", function(_, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 1 then
      self.elapsed = 0
      self:UpdateVisibility()
    end
  end)
end

function RepairReminder:ApplySize()
  if not self.frame then
    return
  end
  local w = (Elysian.state.repairReminderWidth and Elysian.state.repairReminderWidth > 0) and Elysian.state.repairReminderWidth or 360
  local h = (Elysian.state.repairReminderHeight and Elysian.state.repairReminderHeight > 0) and Elysian.state.repairReminderHeight or 46
  self.frame:SetSize(w, h)
  if self.text then
    self.text:SetWidth(w - 40)
  end
end

function RepairReminder:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
  events:RegisterEvent("MERCHANT_SHOW")
  events:SetScript("OnEvent", function()
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events
end

function RepairReminder:ApplyPosition()
  if not self.frame then
    return
  end
  local pos = Elysian.state.repairReminderPos
  if type(pos) == "table" and #pos >= 4 then
    self.frame:ClearAllPoints()
    self.frame:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
  end
end

function RepairReminder:ApplyColors()
  if not self.frame then
    self:EnsureFrame()
    if not self.frame then
      return
    end
  end
  local textColor = Elysian.state.repairReminderTextColor or { 1, 1, 1 }
  if self.text then
    local override = Elysian.state.repairReminderTextOverride
    if type(override) == "string" and override:match("%S") then
      self.text:SetText(override)
    else
      self.text:SetText("REPAIR GEAR")
    end
    self.text:SetTextColor(textColor[1], textColor[2], textColor[3])
  end
  local bg = Elysian.state.repairReminderBgColor or Elysian.state.contentBg or { Elysian.HexToRGB(Elysian.theme.bg) }
  local alpha = tonumber(Elysian.state.repairReminderAlpha or 0.95) or 0.95
  Elysian.SetBackdropColors(self.frame, bg, Elysian.GetThemeBorder(), alpha)
end

function RepairReminder:UpdateMouse()
  if not self.frame then
    return
  end
  local canMove = Elysian.state.repairReminderUnlocked or Elysian.state.repairReminderTest
  self.frame:SetMovable(canMove)
  self.frame:EnableMouse(canMove)
  if canMove then
    self.frame:RegisterForDrag("LeftButton")
  else
    self.frame:RegisterForDrag()
  end
end

function RepairReminder:UpdateVisibility(force)
  if not self.frame then
    return
  end
  if not self:IsEnabled() then
    self.frame:Hide()
    self.wasShown = false
    return
  end
  if Elysian.state.repairReminderTest then
    self.frame:Show()
    if not self.wasShown then
      self.wasShown = true
      if Elysian.PlayFlagCaptureSound then
        Elysian.PlayFlagCaptureSound()
      end
    end
    return
  end
  if not force and not self.frame:IsShown() and not self:IsEnabled() then
    return
  end
  local pct = GetLowestDurability()
  if pct and pct <= 70 then
    self.frame:Show()
    if not self.wasShown then
      self.wasShown = true
      if Elysian.PlayFlagCaptureSound then
        Elysian.PlayFlagCaptureSound()
      end
    end
  else
    self.frame:Hide()
    self.wasShown = false
  end
end

function RepairReminder:Initialize()
  self:EnsureFrame()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function RepairReminder:Refresh()
  if self.frame then
    self:ApplySize()
    self:ApplyColors()
    self:UpdateVisibility(true)
  end
end

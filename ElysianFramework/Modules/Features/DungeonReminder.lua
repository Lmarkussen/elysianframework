local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local DungeonReminder = {}
Elysian.Features.DungeonReminder = DungeonReminder

function DungeonReminder:IsEnabled()
  return Elysian.state.dungeonReminderEnabled and true or false
end

function DungeonReminder:SetEnabled(enabled)
  Elysian.state.dungeonReminderEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility()
end

function DungeonReminder:SetUnlocked(unlocked)
  Elysian.state.dungeonReminderUnlocked = unlocked and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateMouse()
end

function DungeonReminder:SetTestEnabled(enabled)
  Elysian.state.dungeonReminderTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateMouse()
  self:UpdateVisibility(true)
end

function DungeonReminder:EnsureFrame()
  if self.frame then
    return
  end

  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianDungeonReminder", UIParent, template)
  frame:SetSize(360, 46)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, Elysian.GetBannerOffsetY())
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:EnableMouse(false)
  frame:RegisterForDrag()
  frame:SetScript("OnDragStart", function(selfFrame)
    if Elysian.state.dungeonReminderUnlocked or Elysian.state.dungeonReminderTest then
      selfFrame:StartMoving()
    end
  end)
  frame:SetScript("OnDragStop", function(selfFrame)
    selfFrame:StopMovingOrSizing()
    if Elysian.SaveState then
      local px, py = UIParent:GetCenter()
      local fx, fy = selfFrame:GetCenter()
      if px and py and fx and fy then
        Elysian.state.dungeonReminderPos = { "CENTER", "CENTER", fx - px, fy - py }
      end
      Elysian.SaveState()
    end
  end)

  Elysian.SetBackdrop(frame)
  self.frame = frame

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  text:SetPoint("CENTER")
  text:SetText("DONT RELEASE")
  Elysian.ApplyFont(text, 16, "OUTLINE")
  self.text = text

  self:ApplyColors()
  self:ApplyPosition()
  self:UpdateMouse()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function DungeonReminder:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  events:RegisterEvent("PLAYER_DEAD")
  events:RegisterEvent("PLAYER_ALIVE")
  events:RegisterEvent("PLAYER_UNGHOST")
  events:SetScript("OnEvent", function()
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events
end

function DungeonReminder:ApplyPosition()
  if not self.frame then
    return
  end
  local pos = Elysian.state.dungeonReminderPos
  if type(pos) == "table" and #pos >= 4 then
    self.frame:ClearAllPoints()
    self.frame:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
  end
end

function DungeonReminder:ApplyColors()
  if not self.frame then
    self:EnsureFrame()
    if not self.frame then
      return
    end
  end
  local textColor = Elysian.state.dungeonReminderTextColor or { 1, 1, 1 }
  if self.text then
    self.text:SetTextColor(textColor[1], textColor[2], textColor[3])
  end
  local bg = Elysian.state.contentBg or { Elysian.HexToRGB(Elysian.theme.bg) }
  Elysian.SetBackdropColors(self.frame, bg, Elysian.GetThemeBorder(), 0.95)
end

function DungeonReminder:UpdateMouse()
  if not self.frame then
    return
  end
  local canMove = Elysian.state.dungeonReminderUnlocked or Elysian.state.dungeonReminderTest
  self.frame:SetMovable(canMove)
  self.frame:EnableMouse(canMove)
  if canMove then
    self.frame:RegisterForDrag("LeftButton")
  else
    self.frame:RegisterForDrag()
  end
end

function DungeonReminder:UpdateVisibility(force)
  if not self.frame then
    return
  end
  if not self:IsEnabled() then
    self.frame:Hide()
    self.wasShown = false
    return
  end
  if Elysian.state.dungeonReminderTest then
    self.frame:Show()
    if not self.wasShown then
      self.wasShown = true
      if Elysian.PlayFlagCaptureSound then
        Elysian.PlayFlagCaptureSound()
      end
    end
    return
  end
  local inInstance, instanceType = IsInInstance()
  local validInstance = inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario")
  if validInstance and UnitIsDeadOrGhost("player") then
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

function DungeonReminder:Initialize()
  self:EnsureFrame()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function DungeonReminder:Refresh()
  if self.frame then
    self:ApplyColors()
    self:UpdateVisibility(true)
  end
end

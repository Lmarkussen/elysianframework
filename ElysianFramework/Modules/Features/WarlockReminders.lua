local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local WarlockReminders = {}
Elysian.Features.WarlockReminders = WarlockReminders

local function IsWarlock()
  local _, class = UnitClass("player")
  return class == "WARLOCK"
end

local function GetClassColor()
  local _, class = UnitClass("player")
  local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
  local color = colors and colors[class]
  if color then
    return { color.r, color.g, color.b }
  end
  return { 0.58, 0.51, 0.79 }
end

local function HasHealthstone()
  return GetItemCount(5512, true) > 0 or GetItemCount(224464, true) > 0
end

local function HasPet()
  if IsFlying and IsFlying() then
    return true
  end
  if IsMounted and IsMounted() then
    return true
  end
  return UnitExists("pet") and not UnitIsDeadOrGhost("pet")
end

local function ApplyCenterSave(frame, key)
  if not frame then
    return
  end
  local px, py = UIParent:GetCenter()
  local fx, fy = frame:GetCenter()
  if px and py and fx and fy then
    Elysian.state[key] = { "CENTER", "CENTER", fx - px, fy - py }
  end
end

local function ApplyPosition(frame, key)
  local pos = Elysian.state[key]
  if type(pos) == "table" and #pos >= 4 then
    frame:ClearAllPoints()
    frame:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
  end
end

local function EnsureFrame(name, label)
  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", name, UIParent, template)
  frame:SetSize(360, 46)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(selfFrame)
    selfFrame:StartMoving()
  end)
  frame:SetScript("OnDragStop", function(selfFrame)
    selfFrame:StopMovingOrSizing()
  end)

  Elysian.SetBackdrop(frame)

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  text:SetPoint("CENTER")
  text:SetText(label)
  Elysian.ApplyFont(text, 16, "OUTLINE")

  return frame, text
end

function WarlockReminders:EnsureFrames()
  if not self.petFrame then
    self.petFrame, self.petText = EnsureFrame("ElysianWarlockPetReminder", "PET MISSING")
  end
  if not self.stoneFrame then
    self.stoneFrame, self.stoneText = EnsureFrame("ElysianWarlockStoneReminder", "MISSING HEALTHSTONE")
  end
  ApplyPosition(self.petFrame, "warlockPetReminderPos")
  ApplyPosition(self.stoneFrame, "warlockStoneReminderPos")

  if self.petFrame and not self.petFrame.hooked then
    self.petFrame:HookScript("OnDragStop", function()
      self:SavePositions()
    end)
    self.petFrame.hooked = true
  end
  if self.stoneFrame and not self.stoneFrame.hooked then
    self.stoneFrame:HookScript("OnDragStop", function()
      self:SavePositions()
    end)
    self.stoneFrame.hooked = true
  end
end

function WarlockReminders:ApplyColors()
  local classColor = GetClassColor()
  local petColor = classColor
  local stoneColor = classColor
  local bg = Elysian.state.contentBg or { Elysian.HexToRGB(Elysian.theme.bg) }

  if self.petText then
    self.petText:SetTextColor(petColor[1], petColor[2], petColor[3])
  end
  if self.stoneText then
    self.stoneText:SetTextColor(stoneColor[1], stoneColor[2], stoneColor[3])
  end

  if self.petFrame then
    Elysian.SetBackdropColors(self.petFrame, bg, Elysian.GetThemeBorder(), 0.95)
  end
  if self.stoneFrame then
    Elysian.SetBackdropColors(self.stoneFrame, bg, Elysian.GetThemeBorder(), 0.95)
  end
end

function WarlockReminders:UpdateVisibility(force)
  if not IsWarlock() then
    if self.petFrame then
      self.petFrame:Hide()
    end
    if self.stoneFrame then
      self.stoneFrame:Hide()
    end
    return
  end

  if self.petFrame then
    local enabled = Elysian.state.warlockPetReminderEnabled
    if enabled and (Elysian.state.warlockPetReminderTest or not HasPet()) then
      self.petFrame:Show()
      if not self.petShown then
        self.petShown = true
        if Elysian.PlayFlagCaptureSound then
          Elysian.PlayFlagCaptureSound()
        end
      end
    else
      self.petFrame:Hide()
      self.petShown = false
    end
  end

  if self.stoneFrame then
    local enabled = Elysian.state.warlockStoneReminderEnabled
    if enabled and (Elysian.state.warlockStoneReminderTest or not HasHealthstone()) then
      self.stoneFrame:Show()
      if not self.stoneShown then
        self.stoneShown = true
        if Elysian.PlayFlagCaptureSound then
          Elysian.PlayFlagCaptureSound()
        end
      end
    else
      self.stoneFrame:Hide()
      self.stoneShown = false
    end
  end
end

function WarlockReminders:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("UNIT_PET")
  events:RegisterEvent("UNIT_INVENTORY_CHANGED")
  events:RegisterEvent("BAG_UPDATE_DELAYED")
  events:RegisterEvent("PLAYER_REGEN_ENABLED")
  events:SetScript("OnEvent", function()
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events
end

function WarlockReminders:Initialize()
  self:EnsureFrames()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function WarlockReminders:Refresh()
  self:EnsureFrames()
  self:ApplyColors()
  self:UpdateVisibility(true)
end

function WarlockReminders:SetPetEnabled(enabled)
  Elysian.state.warlockPetReminderEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility(true)
end

function WarlockReminders:SetStoneEnabled(enabled)
  Elysian.state.warlockStoneReminderEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility(true)
end

function WarlockReminders:SetPetTest(enabled)
  Elysian.state.warlockPetReminderTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility(true)
end

function WarlockReminders:SetStoneTest(enabled)
  Elysian.state.warlockStoneReminderTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility(true)
end

function WarlockReminders:SavePositions()
  ApplyCenterSave(self.petFrame, "warlockPetReminderPos")
  ApplyCenterSave(self.stoneFrame, "warlockStoneReminderPos")
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

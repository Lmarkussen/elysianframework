local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local HunterReminders = {}
Elysian.Features.HunterReminders = HunterReminders

local BM_SPEC_ID = 253
local MM_SPEC_ID = 254
local SV_SPEC_ID = 255

local function IsHunter()
  local _, class = UnitClass("player")
  return class == "HUNTER"
end

local function IsPetSpec()
  if not GetSpecialization then
    return false
  end
  local specIndex = GetSpecialization()
  if not specIndex then
    return true
  end
  local specID = GetSpecializationInfo(specIndex)
  if not specID then
    return true
  end
  return specID == BM_SPEC_ID or specID == SV_SPEC_ID
end

local function GetClassColor()
  local _, class = UnitClass("player")
  local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
  local color = colors and colors[class]
  if color then
    return { color.r, color.g, color.b }
  end
  return { 0.67, 0.83, 0.45 }
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
  local w, h = Elysian.GetBannerSize(360, 46)
  frame:SetSize(w, h)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, Elysian.GetBannerOffsetY())
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
  text:SetWidth(w - 40)

  return frame, text
end

function HunterReminders:EnsureFrames()
  if not self.petFrame then
    self.petFrame, self.petText = EnsureFrame("ElysianHunterPetReminder", "PET MISSING")
  end
  ApplyPosition(self.petFrame, "hunterPetReminderPos")

  if self.petFrame and not self.petFrame.hooked then
    self.petFrame:HookScript("OnDragStop", function()
      self:SavePositions()
    end)
    self.petFrame.hooked = true
  end
end

function HunterReminders:ApplyColors()
  local classColor = GetClassColor()
  local petColor = Elysian.state.hunterPetReminderTextColor or classColor
  local bg = Elysian.state.hunterPetReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  local alpha = Elysian.state.hunterPetReminderAlpha or 0.95
  local override = Elysian.GetBannerOverride()

  if self.petText then
    if override then
      self.petText:SetText(override)
    else
      self.petText:SetText("PET MISSING")
    end
    self.petText:SetTextColor(petColor[1], petColor[2], petColor[3])
  end

  if self.petFrame then
    Elysian.SetBackdropColors(self.petFrame, bg, Elysian.GetThemeBorder(), alpha)
  end
end

function HunterReminders:ApplySize()
  local w = (Elysian.state.hunterPetReminderWidth and Elysian.state.hunterPetReminderWidth > 0) and Elysian.state.hunterPetReminderWidth or 360
  local h = (Elysian.state.hunterPetReminderHeight and Elysian.state.hunterPetReminderHeight > 0) and Elysian.state.hunterPetReminderHeight or 46
  if self.petFrame then
    self.petFrame:SetSize(w, h)
  end
  if self.petText then
    self.petText:SetWidth(w - 40)
  end
end

function HunterReminders:UpdateVisibility(force)
  if not IsHunter() then
    if self.petFrame then
      self.petFrame:Hide()
    end
    return
  end
  if not Elysian.state.hunterPetReminderTest then
    if not IsPetSpec() then
      if self.petFrame then
        self.petFrame:Hide()
      end
      return
    end
  end

  if self.petFrame then
    local enabled = Elysian.state.hunterPetReminderEnabled
    if not enabled and Elysian.GetActiveProfile and Elysian.GetActiveProfile() == "HUNTER" then
      enabled = true
      Elysian.state.hunterPetReminderEnabled = true
      if Elysian.SaveState then
        Elysian.SaveState()
      end
    end
    if Elysian.state.hunterPetReminderTest or (enabled and not HasPet()) then
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
end

function HunterReminders:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("PLAYER_TALENT_UPDATE")
  events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
  events:RegisterEvent("TRAIT_CONFIG_UPDATED")
  events:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  events:RegisterEvent("UNIT_PET")
  events:RegisterEvent("PLAYER_ALIVE")
  events:RegisterEvent("PLAYER_UNGHOST")
  events:RegisterEvent("PLAYER_REGEN_DISABLED")
  events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  events:RegisterEvent("PLAYER_REGEN_ENABLED")
  events:SetScript("OnEvent", function()
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events

  if C_Timer and C_Timer.NewTicker then
    self.ticker = C_Timer.NewTicker(1.0, function()
      self:UpdateVisibility()
    end)
  end
end

function HunterReminders:Initialize()
  if Elysian.GetActiveProfile and Elysian.GetActiveProfile() == "HUNTER" then
    Elysian.state.hunterPetReminderEnabled = true
  end
  self:EnsureFrames()
  self:ApplySize()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
  if C_Timer and C_Timer.After then
    C_Timer.After(0.5, function()
      self:UpdateVisibility(true)
    end)
  end
end

function HunterReminders:Refresh()
  self:EnsureFrames()
  self:ApplySize()
  self:ApplyColors()
  self:UpdateVisibility(true)
end

function HunterReminders:SetPetEnabled(enabled)
  Elysian.state.hunterPetReminderEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility(true)
end

function HunterReminders:SetPetTest(enabled)
  Elysian.state.hunterPetReminderTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrames()
  self:ApplyColors()
  self:UpdateVisibility(true)
end

function HunterReminders:SavePositions()
  ApplyCenterSave(self.petFrame, "hunterPetReminderPos")
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

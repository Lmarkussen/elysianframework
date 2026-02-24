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

function WarlockReminders:EnsureFrames()
  if not self.petFrame then
    self.petFrame, self.petText = EnsureFrame("ElysianWarlockPetReminder", "PET MISSING")
  end
  if not self.stoneFrame then
    self.stoneFrame, self.stoneText = EnsureFrame("ElysianWarlockStoneReminder", "MISSING HEALTHSTONE")
  end
  if not self.rushFrame then
    self.rushFrame, self.rushText = EnsureFrame("ElysianWarlockRushReminder", "BURNING RUSH")
  end
  ApplyPosition(self.petFrame, "warlockPetReminderPos")
  ApplyPosition(self.stoneFrame, "warlockStoneReminderPos")
  ApplyPosition(self.rushFrame, "warlockRushReminderPos")

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
  if self.rushFrame and not self.rushFrame.hooked then
    self.rushFrame:HookScript("OnDragStop", function()
      self:SavePositions()
    end)
    self.rushFrame.hooked = true
  end
end

function WarlockReminders:ApplyColors()
  local classColor = GetClassColor()
  local petColor = Elysian.state.warlockPetReminderTextColor or classColor
  local stoneColor = Elysian.state.warlockStoneReminderTextColor or classColor
  local rushColor = Elysian.state.warlockRushReminderTextColor or classColor
  local petBg = Elysian.state.warlockPetReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  local stoneBg = Elysian.state.warlockStoneReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  local rushBg = Elysian.state.warlockRushReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  local petAlpha = Elysian.state.warlockPetReminderAlpha or 0.95
  local stoneAlpha = Elysian.state.warlockStoneReminderAlpha or 0.95
  local rushAlpha = Elysian.state.warlockRushReminderAlpha or 0.95
  local override = Elysian.GetBannerOverride()

  if self.petText then
    if override then
      self.petText:SetText(override)
    else
      self.petText:SetText("PET MISSING")
    end
    self.petText:SetTextColor(petColor[1], petColor[2], petColor[3])
  end
  if self.stoneText then
    if override then
      self.stoneText:SetText(override)
    else
      self.stoneText:SetText("MISSING HEALTHSTONE")
    end
    self.stoneText:SetTextColor(stoneColor[1], stoneColor[2], stoneColor[3])
  end
  if self.rushText then
    local rushOverride = Elysian.state.warlockRushReminderTextOverride
    if type(rushOverride) == "string" and rushOverride:match("%S") then
      self.rushText:SetText(rushOverride)
    elseif override then
      self.rushText:SetText(override)
    else
      self.rushText:SetText("BURNING RUSH")
    end
    self.rushText:SetTextColor(rushColor[1], rushColor[2], rushColor[3])
  end

  if self.petFrame then
    Elysian.SetBackdropColors(self.petFrame, petBg, Elysian.GetThemeBorder(), petAlpha)
  end
  if self.stoneFrame then
    Elysian.SetBackdropColors(self.stoneFrame, stoneBg, Elysian.GetThemeBorder(), stoneAlpha)
  end
  if self.rushFrame then
    if Elysian.state.warlockRushReminderShowBg then
      Elysian.SetBackdrop(self.rushFrame)
      Elysian.SetBackdropColors(self.rushFrame, rushBg, Elysian.GetThemeBorder(), rushAlpha)
    else
      Elysian.SetBackdropColors(self.rushFrame, { 0, 0, 0 }, { 0, 0, 0 }, 0)
      if self.rushFrame.SetBackdropBorderColor then
        self.rushFrame:SetBackdropBorderColor(0, 0, 0, 0)
      end
    end
  end
end

function WarlockReminders:ApplySize()
  local w = (Elysian.state.warlockPetReminderWidth and Elysian.state.warlockPetReminderWidth > 0) and Elysian.state.warlockPetReminderWidth or 360
  local h = (Elysian.state.warlockPetReminderHeight and Elysian.state.warlockPetReminderHeight > 0) and Elysian.state.warlockPetReminderHeight or 46
  local stoneW = (Elysian.state.warlockStoneReminderWidth and Elysian.state.warlockStoneReminderWidth > 0) and Elysian.state.warlockStoneReminderWidth or 360
  local stoneH = (Elysian.state.warlockStoneReminderHeight and Elysian.state.warlockStoneReminderHeight > 0) and Elysian.state.warlockStoneReminderHeight or 46
  local rushW = (Elysian.state.warlockRushReminderWidth and Elysian.state.warlockRushReminderWidth > 0) and Elysian.state.warlockRushReminderWidth or 360
  local rushH = (Elysian.state.warlockRushReminderHeight and Elysian.state.warlockRushReminderHeight > 0) and Elysian.state.warlockRushReminderHeight or 46
  if self.petFrame then
    self.petFrame:SetSize(w, h)
  end
  if self.stoneFrame then
    self.stoneFrame:SetSize(stoneW, stoneH)
  end
  if self.rushFrame then
    self.rushFrame:SetSize(rushW, rushH)
  end
  if self.petText then
    self.petText:SetWidth(w - 40)
  end
  if self.stoneText then
    self.stoneText:SetWidth(stoneW - 40)
  end
  if self.rushText then
    self.rushText:SetWidth(rushW - 40)
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

  if self.rushFrame then
    local enabled = Elysian.state.warlockRushReminderEnabled
    local active = false
    if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
      active = C_UnitAuras.GetPlayerAuraBySpellID(111400) ~= nil
    elseif AuraUtil and AuraUtil.FindAuraBySpellId then
      active = AuraUtil.FindAuraBySpellId(111400, "player") ~= nil
    end
    if enabled and (Elysian.state.warlockRushReminderTest or active) then
      self.rushFrame:Show()
      if Elysian.state.warlockRushReminderFlash then
        self:StartRushFlash()
      else
        self:ApplyColors()
      end
    else
      self.rushFrame:Hide()
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
  events:RegisterEvent("UNIT_AURA")
  events:SetScript("OnEvent", function()
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events
end

function WarlockReminders:StartRushFlash()
  if self.rushFlashFrame then
    return
  end
  local ticker = CreateFrame("Frame")
  ticker.elapsed = 0
  ticker:SetScript("OnUpdate", function(_, dt)
    if not self.rushFrame or not self.rushFrame:IsShown() or not Elysian.state.warlockRushReminderEnabled then
      return
    end
    if not Elysian.state.warlockRushReminderFlash then
      return
    end
    ticker.elapsed = ticker.elapsed + dt
    if ticker.elapsed >= 0.2 then
      ticker.elapsed = 0
      local r = math.random(80, 255) / 255
      local g = math.random(80, 255) / 255
      local b = math.random(80, 255) / 255
      if self.rushText then
        self.rushText:SetTextColor(r, g, b)
      end
    end
  end)
  self.rushFlashFrame = ticker
end

function WarlockReminders:Initialize()
  self:EnsureFrames()
  self:ApplySize()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function WarlockReminders:Refresh()
  self:EnsureFrames()
  self:ApplySize()
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

function WarlockReminders:SetRushEnabled(enabled)
  Elysian.state.warlockRushReminderEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility(true)
end

function WarlockReminders:SetRushTest(enabled)
  Elysian.state.warlockRushReminderTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility(true)
end

function WarlockReminders:SavePositions()
  ApplyCenterSave(self.petFrame, "warlockPetReminderPos")
  ApplyCenterSave(self.stoneFrame, "warlockStoneReminderPos")
  ApplyCenterSave(self.rushFrame, "warlockRushReminderPos")
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

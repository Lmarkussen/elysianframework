local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local KeystoneReminder = {}
Elysian.Features.KeystoneReminder = KeystoneReminder

local function HasKeystone()
  if C_MythicPlus and C_MythicPlus.GetOwnedKeystoneChallengeMapID then
    local mapId = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
    if mapId and mapId > 0 then
      return true
    end
  end
  return false
end

local function IsKeystoneForCurrentInstance()
  if not C_MythicPlus or not C_MythicPlus.GetOwnedKeystoneChallengeMapID then
    return false
  end
  local mapId = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
  if not mapId or mapId <= 0 then
    return false
  end
  if C_ChallengeMode and C_ChallengeMode.GetActiveChallengeMapID then
    local activeId = C_ChallengeMode.GetActiveChallengeMapID()
    if activeId and activeId > 0 then
      return activeId == mapId
    end
  end
  local keystoneName = nil
  if C_ChallengeMode and C_ChallengeMode.GetMapUIInfo then
    keystoneName = C_ChallengeMode.GetMapUIInfo(mapId)
  end
  local instanceName = GetInstanceInfo()
  local instanceMapId = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player") or nil

  if instanceMapId then
    local current = instanceMapId
    local visited = 0
    while current and current > 0 and visited < 10 do
      if current == mapId then
        return true
      end
      local info = C_Map.GetMapInfo(current)
      if not info or not info.parentMapID or info.parentMapID == current then
        break
      end
      current = info.parentMapID
      visited = visited + 1
    end
  end

  local function NormalizeName(name)
    if not name then
      return nil
    end
    local s = string.lower(name)
    s = s:gsub("'", "")
    s = s:gsub("[^%w%s]", " ")
    s = s:gsub("%s+", " ")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    s = s:gsub(" the ", " ")
    s = s:gsub(" of ", " ")
    s = s:gsub(" an ", " ")
    s = s:gsub(" a ", " ")
    s = s:gsub("%s+", " ")
    return s
  end

  if keystoneName and instanceName then
    local ks = NormalizeName(keystoneName)
    local inst = NormalizeName(instanceName)
    if ks and inst then
      if ks == inst then
        return true
      end
      if inst:find(ks, 1, true) or ks:find(inst, 1, true) then
        return true
      end
      if ks:find("streets") or ks:find("gambit") then
        if inst:find("tazavesh", 1, true) then
          return true
        end
      end
    end
  end

  return false
end

function KeystoneReminder:IsEnabled()
  return Elysian.state.keystoneReminderEnabled and true or false
end

function KeystoneReminder:SetEnabled(enabled)
  Elysian.state.keystoneReminderEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility(true)
end

function KeystoneReminder:SetTestEnabled(enabled)
  Elysian.state.keystoneReminderTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility(true)
end

function KeystoneReminder:EnsureFrame()
  if self.frame then
    return
  end

  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianKeystoneReminder", UIParent, template)
  local w = (Elysian.state.keystoneReminderWidth and Elysian.state.keystoneReminderWidth > 0) and Elysian.state.keystoneReminderWidth or 360
  local h = (Elysian.state.keystoneReminderHeight and Elysian.state.keystoneReminderHeight > 0) and Elysian.state.keystoneReminderHeight or 46
  frame:SetSize(w, h)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, Elysian.GetBannerOffsetY() - 170)
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", function(selfFrame)
    selfFrame:StopMovingOrSizing()
    if Elysian.SaveState then
      local px, py = UIParent:GetCenter()
      local fx, fy = selfFrame:GetCenter()
      if px and py and fx and fy then
        Elysian.state.keystoneReminderPos = { "CENTER", "CENTER", fx - px, fy - py }
      end
      Elysian.SaveState()
    end
  end)

  Elysian.SetBackdrop(frame)
  self.frame = frame

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  text:SetPoint("CENTER")
  text:SetJustifyH("CENTER")
  text:SetJustifyV("MIDDLE")
  text:SetWidth(w - 40)
  text:SetWordWrap(true)
  text:SetText("YOUR KEYSTONE")
  Elysian.ApplyFont(text, 14, "OUTLINE")
  self.text = text

  self:ApplySize()
  self:ApplyColors()
  self:ApplyPosition()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function KeystoneReminder:ApplySize()
  if not self.frame then
    return
  end
  local w = (Elysian.state.keystoneReminderWidth and Elysian.state.keystoneReminderWidth > 0) and Elysian.state.keystoneReminderWidth or 360
  local h = (Elysian.state.keystoneReminderHeight and Elysian.state.keystoneReminderHeight > 0) and Elysian.state.keystoneReminderHeight or 46
  self.frame:SetSize(w, h)
  if self.text then
    self.text:SetWidth(w - 40)
  end
end

function KeystoneReminder:ApplyPosition()
  if not self.frame then
    return
  end
  local pos = Elysian.state.keystoneReminderPos
  if type(pos) == "table" and #pos >= 4 then
    self.frame:ClearAllPoints()
    self.frame:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
  end
end

function KeystoneReminder:ApplyColors()
  if not self.frame then
    return
  end
  local textColor = Elysian.state.keystoneReminderTextColor or { 1, 1, 1 }
  if self.text then
    self.text:SetTextColor(textColor[1], textColor[2], textColor[3])
  end
  local bg = Elysian.state.keystoneReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  local alpha = Elysian.state.keystoneReminderAlpha or 0.95
  Elysian.SetBackdropColors(self.frame, bg, Elysian.GetThemeBorder(), alpha)
end

function KeystoneReminder:UpdateVisibility(force)
  if not self.frame then
    return
  end
  if not self:IsEnabled() then
    self.frame:Hide()
    return
  end
  local active = false
  if C_ChallengeMode and C_ChallengeMode.IsChallengeModeActive and C_ChallengeMode.IsChallengeModeActive() then
    active = true
  elseif C_ChallengeMode and C_ChallengeMode.GetActiveChallengeMapID then
    local activeMap = C_ChallengeMode.GetActiveChallengeMapID()
    if activeMap and activeMap > 0 then
      active = true
    end
  elseif C_ChallengeMode and C_ChallengeMode.GetActiveKeystoneInfo then
    local activeMap = C_ChallengeMode.GetActiveKeystoneInfo()
    if activeMap and type(activeMap) == "number" and activeMap > 0 then
      active = true
    end
  end
  if active then
    self.frame:Hide()
    self.wasShown = false
    return
  end
  local inInstance, instanceType = IsInInstance()
  local validInstance = inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario")
  if not validInstance and not Elysian.state.keystoneReminderTest then
    self.frame:Hide()
    return
  end

  local show = HasKeystone() and IsKeystoneForCurrentInstance()
  if Elysian.state.keystoneReminderTest then
    show = true
  end

  if show then
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

function KeystoneReminder:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  events:RegisterEvent("BAG_UPDATE_DELAYED")
  events:RegisterEvent("CHALLENGE_MODE_START")
  events:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
  events:SetScript("OnEvent", function()
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events
end

function KeystoneReminder:Initialize()
  self:EnsureFrame()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function KeystoneReminder:Refresh()
  if self.frame then
    self:ApplySize()
    self:ApplyColors()
    self:UpdateVisibility(true)
  end
end

local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local BuffWatch = {}
Elysian.Features.BuffWatch = BuffWatch

local CLASS_BUFFS = {
  WARRIOR = { "Battle Shout" },
  MAGE = { "Arcane Intellect" },
  PRIEST = { "Power Word: Fortitude" },
  DRUID = { "Mark of the Wild" },
  EVOKER = { "Blessing of the Bronze" },
  SHAMAN = { "Skyfury" },
}

local BUFF_SPELLS = {
  ["Battle Shout"] = 6673,
  ["Arcane Intellect"] = 1459,
  ["Power Word: Fortitude"] = 21562,
  ["Mark of the Wild"] = 1126,
  ["Blessing of the Bronze"] = 381748,
  ["Skyfury"] = 462854,
}

local BUFF_ALIASES = {
  ["Skyfury"] = { 462854 },
  ["Blessing of the Bronze"] = { 381748 },
}

local function HasBuff(name)
  if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex and C_Spell and C_Spell.GetSpellInfo) then
    return false
  end
  local index = 1
  while true do
    local aura = C_UnitAuras.GetAuraDataByIndex("player", index, "HELPFUL")
    if not aura then
      break
    end
    local spellId = aura.spellId
    if spellId then
      local info = C_Spell.GetSpellInfo(spellId)
      local auraName = info and info.name or nil
      if auraName == name then
        return true
      end
    end
    index = index + 1
  end
  return false
end

local function GetGroupClasses()
  local classes = {}
  local n = GetNumGroupMembers()
  if n and n > 0 then
    local prefix = IsInRaid() and "raid" or "party"
    for i = 1, n do
      local unit = prefix .. i
      if UnitExists(unit) then
        local _, class = UnitClass(unit)
        if class then
          classes[class] = true
        end
      end
    end
  else
    local _, class = UnitClass("player")
    if class then
      classes[class] = true
    end
  end
  return classes
end

function BuffWatch:IsEnabled()
  return Elysian.state.buffWatchEnabled and true or false
end

function BuffWatch:SetEnabled(enabled)
  Elysian.state.buffWatchEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility(true)
end

function BuffWatch:SetTestEnabled(enabled)
  Elysian.state.buffWatchTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility(true)
end

function BuffWatch:EnsureFrame()
  if self.frame then
    return
  end

  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianBuffWatchReminder", UIParent, template)
  local w = (Elysian.state.buffWatchWidth and Elysian.state.buffWatchWidth > 0) and Elysian.state.buffWatchWidth or 420
  local h = (Elysian.state.buffWatchHeight and Elysian.state.buffWatchHeight > 0) and Elysian.state.buffWatchHeight or 52
  frame:SetSize(w, h)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, Elysian.GetBannerOffsetY() - 60)
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
        Elysian.state.buffWatchPos = { "CENTER", "CENTER", fx - px, fy - py }
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
  local w = (Elysian.state.buffWatchWidth and Elysian.state.buffWatchWidth > 0) and Elysian.state.buffWatchWidth or 420
  text:SetWidth(w - 40)
  text:SetWordWrap(true)
  Elysian.ApplyFont(text, 14, "OUTLINE")
  self.text = text

  self:ApplySize()
  self:ApplyColors()
  self:ApplyPosition()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function BuffWatch:ApplySize()
  if not self.frame then
    return
  end
  local w = (Elysian.state.buffWatchWidth and Elysian.state.buffWatchWidth > 0) and Elysian.state.buffWatchWidth or 420
  local h = (Elysian.state.buffWatchHeight and Elysian.state.buffWatchHeight > 0) and Elysian.state.buffWatchHeight or 52
  self.frame:SetSize(w, h)
  if self.text then
    self.text:SetWidth(w - 40)
  end
end

function BuffWatch:ApplyPosition()
  if not self.frame then
    return
  end
  local pos = Elysian.state.buffWatchPos
  if type(pos) == "table" and #pos >= 4 then
    self.frame:ClearAllPoints()
    self.frame:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
  end
end

function BuffWatch:ApplyColors()
  if not self.frame then
    return
  end
  local textColor = Elysian.state.buffWatchTextColor or { 1, 1, 1 }
  if self.text then
    self.text:SetTextColor(textColor[1], textColor[2], textColor[3])
  end
  local bg = Elysian.state.buffWatchBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  local alpha = Elysian.state.buffWatchAlpha or 0.95
  Elysian.SetBackdropColors(self.frame, bg, Elysian.GetThemeBorder(), alpha)
end

function BuffWatch:BuildMissingList()
  local classes = GetGroupClasses()
  local missing = {}
  for class, buffs in pairs(CLASS_BUFFS) do
    if classes[class] then
      for _, buff in ipairs(buffs) do
        if not HasBuff(buff) then
          table.insert(missing, buff)
        end
      end
    end
  end
  return missing
end

function BuffWatch:UpdateText(missing)
  if not self.text or not self.frame then
    return
  end
  local message = "Missing buffs"
  local override = Elysian.GetBannerOverride()
  if missing and #missing > 0 then
    if override then
      message = override .. ": " .. table.concat(missing, ", ")
    else
      message = "Missing buffs: " .. table.concat(missing, ", ")
    end
  elseif override then
    message = override
  end
  self.text:SetText(message)
  local baseHeight = (Elysian.state.buffWatchHeight and Elysian.state.buffWatchHeight > 0) and Elysian.state.buffWatchHeight or 52
  if baseHeight > 0 then
    self.frame:SetHeight(baseHeight)
  else
    local height = math.max(52, (self.text:GetStringHeight() or 32) + 20)
    self.frame:SetHeight(height)
  end
end

function BuffWatch:UpdateVisibility(force)
  if not self.frame then
    return
  end
  if not self:IsEnabled() then
    self.frame:Hide()
    return
  end
  self.runActive = C_ChallengeMode and C_ChallengeMode.IsChallengeModeActive and C_ChallengeMode.IsChallengeModeActive() or false
  if self.runActive then
    self.frame:Hide()
    return
  end
  local inInstance, instanceType = IsInInstance()
  local validInstance = inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario")
  if not validInstance and not Elysian.state.buffWatchTest then
    self.frame:Hide()
    return
  end

  local missing = self:BuildMissingList()
  if Elysian.state.buffWatchTest then
    missing = { "Battle Shout", "Arcane Intellect", "Skyfury" }
  end

  if missing and #missing > 0 then
    self:UpdateText(missing)
    self.frame:Show()
  else
    self.frame:Hide()
  end
end

function BuffWatch:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("GROUP_ROSTER_UPDATE")
  events:RegisterEvent("UNIT_AURA")
  events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  events:RegisterEvent("PLAYER_REGEN_ENABLED")
  events:RegisterEvent("CHALLENGE_MODE_START")
  events:RegisterEvent("CHALLENGE_MODE_RESET")
  events:SetScript("OnEvent", function(_, event, unit)
    if event == "CHALLENGE_MODE_START" then
      self.runActive = true
    elseif event == "CHALLENGE_MODE_RESET" or event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
      self.runActive = false
    end
    if event == "UNIT_AURA" and unit ~= "player" then
      return
    end
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events
end

function BuffWatch:Initialize()
  self:EnsureFrame()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function BuffWatch:Refresh()
  if self.frame then
    self:ApplySize()
    self:ApplyColors()
    self:UpdateVisibility(true)
  end
end

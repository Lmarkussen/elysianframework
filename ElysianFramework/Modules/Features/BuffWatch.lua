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

local function HasBuff(name)
  if AuraUtil and AuraUtil.FindAuraByName then
    return AuraUtil.FindAuraByName(name, "player") ~= nil
  end
  local i = 1
  while true do
    local auraName = UnitAura("player", i)
    if not auraName then
      break
    end
    if auraName == name then
      return true
    end
    i = i + 1
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
  frame:SetSize(420, 52)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, -60)
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
  text:SetWidth(380)
  text:SetWordWrap(true)
  Elysian.ApplyFont(text, 14, "OUTLINE")
  self.text = text

  self:ApplyColors()
  self:ApplyPosition()
  self:UpdateVisibility(true)
  self:EnsureEvents()
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
  local bg = Elysian.state.contentBg or { Elysian.HexToRGB(Elysian.theme.bg) }
  Elysian.SetBackdropColors(self.frame, bg, Elysian.GetThemeBorder(), 0.95)
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
  if missing and #missing > 0 then
    message = "Missing buffs: " .. table.concat(missing, ", ")
  end
  self.text:SetText(message)
  local height = math.max(52, (self.text:GetStringHeight() or 32) + 20)
  self.frame:SetHeight(height)
end

function BuffWatch:UpdateVisibility(force)
  if not self.frame then
    return
  end
  if not self:IsEnabled() then
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
  events:SetScript("OnEvent", function(_, event, unit)
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
    self:ApplyColors()
    self:UpdateVisibility(true)
  end
end


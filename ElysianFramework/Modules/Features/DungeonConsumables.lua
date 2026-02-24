local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local DungeonConsumables = {}
Elysian.Features.DungeonConsumables = DungeonConsumables

local FLASK_BUFFS = {
  "Flask of Alchemical Chaos",
  "Flask of Saving Graces",
  "Flask of Tempered Aggression",
  "Flask of Tempered Mastery",
  "Flask of Tempered Swiftness",
  "Flask of Tempered Versatility",
  "Vicious Flask of Honor",
  "Vicious Flask of Classical Spirits",
  "Vicious Flask of the Wrecking Ball",
}

local FLASK_SPELL_IDS = {}
do
  if C_Spell and C_Spell.GetSpellInfo then
    for _, name in ipairs(FLASK_BUFFS) do
      local info = C_Spell.GetSpellInfo(name)
      local id = info and info.spellID or nil
      if id then
        FLASK_SPELL_IDS[id] = true
      end
    end
  end
end


local function HasAuraByNameList(names)
  if AuraUtil and AuraUtil.FindAuraByName then
    for _, name in ipairs(names) do
      local ok, result = pcall(AuraUtil.FindAuraByName, name, "player", "HELPFUL")
      if ok and result then
        return true
      end
    end
  end
  if C_Spell and C_Spell.GetSpellInfo and C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
    for _, name in ipairs(names) do
      local info = C_Spell.GetSpellInfo(name)
      local spellId = info and info.spellID or nil
      if spellId and C_UnitAuras.GetPlayerAuraBySpellID(spellId) then
        return true
      end
    end
  end
  return false
end

local function HasFlask()
  if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
    for spellId in pairs(FLASK_SPELL_IDS) do
      if C_UnitAuras.GetPlayerAuraBySpellID(spellId) then
        return true
      end
    end
  end
  return HasAuraByNameList(FLASK_BUFFS)
end

function DungeonConsumables:IsEnabled()
  return Elysian.state.dungeonConsumablesEnabled and true or false
end

function DungeonConsumables:SetEnabled(enabled)
  Elysian.state.dungeonConsumablesEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility(true)
end

function DungeonConsumables:SetTestEnabled(enabled)
  Elysian.state.dungeonConsumablesTest = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:EnsureFrame()
  self:UpdateVisibility(true)
end

function DungeonConsumables:EnsureFrame()
  if self.frame then
    return
  end

  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianDungeonConsumables", UIParent, template)
  local w = (Elysian.state.dungeonConsumablesWidth and Elysian.state.dungeonConsumablesWidth > 0) and Elysian.state.dungeonConsumablesWidth or 420
  local h = (Elysian.state.dungeonConsumablesHeight and Elysian.state.dungeonConsumablesHeight > 0) and Elysian.state.dungeonConsumablesHeight or 52
  frame:SetSize(w, h)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, Elysian.GetBannerOffsetY() - 120)
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
        Elysian.state.dungeonConsumablesPos = { "CENTER", "CENTER", fx - px, fy - py }
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
  Elysian.ApplyFont(text, 14, "OUTLINE")
  self.text = text

  self:ApplySize()
  self:ApplyColors()
  self:ApplyPosition()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function DungeonConsumables:ApplySize()
  if not self.frame then
    return
  end
  local w = (Elysian.state.dungeonConsumablesWidth and Elysian.state.dungeonConsumablesWidth > 0) and Elysian.state.dungeonConsumablesWidth or 420
  local h = (Elysian.state.dungeonConsumablesHeight and Elysian.state.dungeonConsumablesHeight > 0) and Elysian.state.dungeonConsumablesHeight or 52
  self.frame:SetSize(w, h)
  if self.text then
    self.text:SetWidth(w - 40)
  end
end

function DungeonConsumables:ApplyPosition()
  if not self.frame then
    return
  end
  local pos = Elysian.state.dungeonConsumablesPos
  if type(pos) == "table" and #pos >= 4 then
    self.frame:ClearAllPoints()
    self.frame:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
  end
end

function DungeonConsumables:ApplyColors()
  if not self.frame then
    return
  end
  local textColor = Elysian.state.dungeonConsumablesTextColor or { 1, 1, 1 }
  if self.text then
    self.text:SetTextColor(textColor[1], textColor[2], textColor[3])
  end
  local bg = Elysian.state.dungeonConsumablesBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  local alpha = Elysian.state.dungeonConsumablesAlpha or 0.95
  Elysian.SetBackdropColors(self.frame, bg, Elysian.GetThemeBorder(), alpha)
end

function DungeonConsumables:BuildMissingList(hasFlask)
  local missing = {}
  if hasFlask == nil then
    hasFlask = HasFlask()
  end
  if not hasFlask then
    table.insert(missing, "Flask")
  end
  return missing
end

function DungeonConsumables:UpdateText(missing)
  if not self.text or not self.frame then
    return
  end
  local message = "Missing consumables"
  local override = Elysian.GetBannerOverride()
  if missing and #missing > 0 then
    if override then
      message = override .. ": " .. table.concat(missing, ", ")
    else
      message = "Missing consumables: " .. table.concat(missing, ", ")
    end
  elseif override then
    message = override
  end
  self.text:SetText(message)
  local baseHeight = (Elysian.state.dungeonConsumablesHeight and Elysian.state.dungeonConsumablesHeight > 0) and Elysian.state.dungeonConsumablesHeight or 52
  if baseHeight > 0 then
    self.frame:SetHeight(baseHeight)
  else
    local height = math.max(52, (self.text:GetStringHeight() or 32) + 20)
    self.frame:SetHeight(height)
  end
end

function DungeonConsumables:UpdateVisibility(force)
  if not self.frame then
    return
  end
  if not self:IsEnabled() then
    self.frame:Hide()
    return
  end
  if self.runActive and C_ChallengeMode and C_ChallengeMode.IsChallengeModeActive and not C_ChallengeMode.IsChallengeModeActive() then
    self.runActive = false
  end
  if self.runActive then
    self.frame:Hide()
    return
  end
  local inInstance, instanceType = IsInInstance()
  local validInstance = inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario")
  if not validInstance and not Elysian.state.dungeonConsumablesTest then
    self.frame:Hide()
    return
  end

  local inCombat = UnitAffectingCombat and UnitAffectingCombat("player")
  if inCombat and not Elysian.state.dungeonConsumablesTest then
    self.frame:Hide()
    return
  end

  local hasFlask = HasFlask()
  self.lastHasFlask = hasFlask
  local missing = self:BuildMissingList(hasFlask)
  if Elysian.state.dungeonConsumablesTest then
    missing = { "Flask", "Well Fed" }
  end

  if missing and #missing > 0 then
    self:UpdateText(missing)
    self.frame:Show()
  else
    self.frame:Hide()
  end
end

function DungeonConsumables:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("UNIT_AURA")
  events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
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

function DungeonConsumables:Initialize()
  self.runActive = C_ChallengeMode and C_ChallengeMode.IsChallengeModeActive and C_ChallengeMode.IsChallengeModeActive() or false
  self:EnsureFrame()
  self:ApplyColors()
  self:UpdateVisibility(true)
  self:EnsureEvents()
end

function DungeonConsumables:Refresh()
  if self.frame then
    self:ApplySize()
    self:ApplyColors()
    self:UpdateVisibility(true)
  end
end

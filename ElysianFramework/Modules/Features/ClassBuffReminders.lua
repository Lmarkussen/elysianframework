local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local ClassBuffReminders = {}
Elysian.Features.ClassBuffReminders = ClassBuffReminders

local BUFFS = {
  WARRIOR = { key = "warrior", buff = "Battle Shout", spellId = 6673, label = "MISSING BATTLE SHOUT" },
  MAGE = { key = "mage", buff = "Arcane Intellect", spellId = 1459, label = "MISSING ARCANE INTELLECT" },
  PRIEST = { key = "priest", buff = "Power Word: Fortitude", spellId = 21562, label = "MISSING FORTITUDE" },
  DRUID = { key = "druid", buff = "Mark of the Wild", spellId = 1126, label = "MISSING MARK OF THE WILD" },
  SHAMAN = { key = "shaman", buff = "Skyfury", spellId = 462854, label = "MISSING SKYFURY" },
  EVOKER = { key = "evoker", buff = "Blessing of the Bronze", spellId = 381748, label = "MISSING BRONZE" },
}

local function HasBuff(name, spellId)
  if spellId and C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
    if C_UnitAuras.GetPlayerAuraBySpellID(spellId) then
      return true
    end
  end
  if spellId and AuraUtil and AuraUtil.FindAuraBySpellId then
    if AuraUtil.FindAuraBySpellId(spellId, "player") then
      return true
    end
  end
  if name == "Skyfury" then
    local alias = 462854
    if AuraUtil and AuraUtil.FindAuraBySpellId and AuraUtil.FindAuraBySpellId(alias, "player") then
      return true
    end
    if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID and C_UnitAuras.GetPlayerAuraBySpellID(alias) then
      return true
    end
  end
  return false
end

local function HasAnyPoisonAura()
  local poisons = {
    "Deadly Poison",
    "Instant Poison",
    "Wound Poison",
    "Crippling Poison",
    "Numbing Poison",
    "Atrophic Poison",
  }
  for _, name in ipairs(poisons) do
    if HasBuff(name) then
      return true
    end
  end
  return false
end

local function GetPlayerClass()
  local _, class = UnitClass("player")
  return class
end

local function GetStateKey(prefix, suffix)
  return string.format("%s%s", prefix, suffix)
end

local function GetColor(key)
  local value = Elysian.state[key]
  if type(value) == "table" then
    return value
  end
  return { 1, 1, 1 }
end

function ClassBuffReminders:GetKeys(prefix)
  return {
    enabled = GetStateKey(prefix, "BuffEnabled"),
    text = GetStateKey(prefix, "BuffTextColor"),
    bg = GetStateKey(prefix, "BuffBgColor"),
    alpha = GetStateKey(prefix, "BuffAlpha"),
    width = GetStateKey(prefix, "BuffWidth"),
    height = GetStateKey(prefix, "BuffHeight"),
    test = GetStateKey(prefix, "BuffTest"),
    pos = GetStateKey(prefix, "BuffPos"),
  }
end

function ClassBuffReminders:GetPoisonKeys()
  return {
    enabled = "roguePoisonEnabled",
    text = "roguePoisonTextColor",
    bg = "roguePoisonBgColor",
    alpha = "roguePoisonAlpha",
    width = "roguePoisonWidth",
    height = "roguePoisonHeight",
    test = "roguePoisonTest",
    pos = "roguePoisonPos",
  }
end

function ClassBuffReminders:EnsureFrame(prefix, label)
  self.frames = self.frames or {}
  if self.frames[prefix] then
    return self.frames[prefix]
  end
  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianClassBuff" .. prefix, UIParent, template)
  local w, h = Elysian.GetBannerSize(420, 52)
  frame:SetSize(w, h)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, Elysian.GetBannerOffsetY() - 120)
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", function(selfFrame)
    selfFrame:StopMovingOrSizing()
    local keys = self.keys[prefix]
    if keys and Elysian.SaveState then
      local px, py = UIParent:GetCenter()
      local fx, fy = selfFrame:GetCenter()
      if px and py and fx and fy then
        Elysian.state[keys.pos] = { "CENTER", "CENTER", fx - px, fy - py }
      end
      Elysian.SaveState()
    end
  end)

  Elysian.SetBackdrop(frame)
  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  text:SetPoint("CENTER")
  text:SetJustifyH("CENTER")
  text:SetJustifyV("MIDDLE")
  text:SetWidth(w - 40)
  text:SetWordWrap(true)
  Elysian.ApplyFont(text, 14, "OUTLINE")
  text:SetText(label or "")
  frame.text = text
  self.frames[prefix] = frame
  return frame
end

function ClassBuffReminders:ApplyColors(prefix)
  local frame = self.frames and self.frames[prefix]
  if not frame then
    return
  end
  local keys = self.keys[prefix]
  if not keys then
    return
  end
  local color = GetColor(keys.text)
  frame.text:SetTextColor(color[1], color[2], color[3])
  local bg = Elysian.state[keys.bg] or { Elysian.HexToRGB(Elysian.theme.bg) }
  local alpha = Elysian.state[keys.alpha] or 0.95
  Elysian.SetBackdropColors(frame, bg, Elysian.GetThemeBorder(), alpha)
end

function ClassBuffReminders:ApplyPosition(prefix)
  local frame = self.frames and self.frames[prefix]
  if not frame then
    return
  end
  local keys = self.keys[prefix]
  local pos = keys and Elysian.state[keys.pos]
  if type(pos) == "table" and #pos >= 4 then
    frame:ClearAllPoints()
    frame:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
  end
end

function ClassBuffReminders:ApplySize(prefix)
  local frame = self.frames and self.frames[prefix]
  if not frame then
    return
  end
  local keys = self.keys[prefix]
  local w = (keys and Elysian.state[keys.width] and Elysian.state[keys.width] > 0) and Elysian.state[keys.width] or 420
  local h = (keys and Elysian.state[keys.height] and Elysian.state[keys.height] > 0) and Elysian.state[keys.height] or 52
  frame:SetSize(w, h)
  if frame.text then
    frame.text:SetWidth(w - 40)
  end
end

function ClassBuffReminders:UpdateFrameText(prefix, message)
  local frame = self.frames and self.frames[prefix]
  if not frame then
    return
  end
  local override = Elysian.GetBannerOverride()
  if override then
    frame.text:SetText(override)
  else
    frame.text:SetText(message)
  end
end

function ClassBuffReminders:UpdateBuff(prefix)
  local keys = self.keys[prefix]
  if not keys then
    return
  end
  local enabled = Elysian.state[keys.enabled]
  local test = Elysian.state[keys.test]
  local frame = self.frames[prefix]
  if not enabled then
    frame:Hide()
    return
  end
  local buff = self.buffLookup[prefix]
  if test then
    self:UpdateFrameText(prefix, "MISSING " .. (buff.label or "BUFF"))
    frame:Show()
    return
  end
  if buff and not HasBuff(buff.buff, buff.spellId) then
    self:UpdateFrameText(prefix, buff.label)
    frame:Show()
  else
    frame:Hide()
  end
end

function ClassBuffReminders:UpdatePoison()
  local keys = self.keys.rogue
  local frame = self.frames.rogue
  if not keys or not frame then
    return
  end
  if not Elysian.state[keys.enabled] then
    frame:Hide()
    return
  end
  if Elysian.state[keys.test] then
    self:UpdateFrameText("rogue", "MISSING POISONS: MH, OH")
    frame:Show()
    return
  end
  local hasMain, _, _, hasOff = GetWeaponEnchantInfo()
  local hasAura = HasAnyPoisonAura()
  local missing = {}
  if not hasMain then
    table.insert(missing, "MH")
  end
  if not hasOff then
    table.insert(missing, "OH")
  end
  if #missing == 2 and hasAura then
    frame:Hide()
    return
  end
  if #missing > 0 then
    self:UpdateFrameText("rogue", "MISSING POISONS: " .. table.concat(missing, ", "))
    frame:Show()
  else
    frame:Hide()
  end
end

function ClassBuffReminders:UpdateVisibility()
  if self.runActive then
    for _, frame in pairs(self.frames or {}) do
      frame:Hide()
    end
    return
  end
  local class = GetPlayerClass()
  if class == "ROGUE" then
    self:UpdatePoison()
    return
  end
  local entry = BUFFS[class]
  if entry then
    self:UpdateBuff(entry.key)
  end
end

function ClassBuffReminders:EnsureFrames()
  self.frames = self.frames or {}
  self.keys = self.keys or {}
  self.buffLookup = self.buffLookup or {}

  for class, entry in pairs(BUFFS) do
    self.keys[entry.key] = self:GetKeys(entry.key)
    self.buffLookup[entry.key] = entry
    local frame = self:EnsureFrame(entry.key, entry.label)
    self:ApplyColors(entry.key)
    self:ApplySize(entry.key)
    self:ApplyPosition(entry.key)
    frame:Hide()
  end

  self.keys.rogue = self:GetPoisonKeys()
  local rogueFrame = self:EnsureFrame("rogue", "MISSING POISONS")
  self:ApplyColors("rogue")
  self:ApplySize("rogue")
  self:ApplyPosition("rogue")
  rogueFrame:Hide()
end

function ClassBuffReminders:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("UNIT_AURA")
  events:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
  events:RegisterEvent("PLAYER_REGEN_ENABLED")
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
    self:UpdateVisibility()
  end)
  self.eventFrame = events
end

function ClassBuffReminders:Initialize()
  self.runActive = false
  self:EnsureFrames()
  self:EnsureEvents()
  self:UpdateVisibility()
end

function ClassBuffReminders:Refresh()
  self:EnsureFrames()
  for key in pairs(self.keys) do
    self:ApplyColors(key)
    self:ApplySize(key)
  end
  self:UpdateVisibility()
end

function ClassBuffReminders:SetEnabled(prefix, enabled)
  local keys = self.keys[prefix]
  if not keys then
    return
  end
  Elysian.state[keys.enabled] = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility()
end

function ClassBuffReminders:SetTestEnabled(prefix, enabled)
  local keys = self.keys[prefix]
  if not keys then
    return
  end
  Elysian.state[keys.test] = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:UpdateVisibility()
end

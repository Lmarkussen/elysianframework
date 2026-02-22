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

local function ForEachPlayerAura(callback)
  if AuraUtil and AuraUtil.ForEachAura then
    AuraUtil.ForEachAura("player", "HELPFUL", nil, callback)
    return
  end
  local i = 1
  while true do
    local name = UnitAura("player", i)
    if not name then
      break
    end
    callback(name)
    i = i + 1
  end
end

local function HasWellFed()
  local found = false
  ForEachPlayerAura(function(name)
    if name and name:lower():find("well fed", 1, true) then
      found = true
      return true
    end
  end)
  return found
end

local function HasFlask()
  local found = false
  ForEachPlayerAura(function(name)
    if not name then
      return
    end
    for _, buff in ipairs(FLASK_BUFFS) do
      if name == buff then
        found = true
        return true
      end
    end
    local lower = name:lower()
    if lower:find("flask", 1, true) or lower:find("phial", 1, true) then
      found = true
      return true
    end
  end)
  return found
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

function DungeonConsumables:BuildMissingList()
  local missing = {}
  if not HasFlask() then
    table.insert(missing, "Flask")
  end
  if not HasWellFed() then
    table.insert(missing, "Well Fed")
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
  local inInstance, instanceType = IsInInstance()
  local validInstance = inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario")
  if not validInstance and not Elysian.state.dungeonConsumablesTest then
    self.frame:Hide()
    return
  end

  local missing = self:BuildMissingList()
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
  events:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_AURA" and unit ~= "player" then
      return
    end
    self:UpdateVisibility(true)
  end)
  self.eventFrame = events
end

function DungeonConsumables:Initialize()
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

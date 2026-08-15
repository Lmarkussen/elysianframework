local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local InfoBar = {}
Elysian.Features.InfoBar = InfoBar

local MAGE_TELEPORTS = {
  "Teleport: Stormwind",
  "Teleport: Ironforge",
  "Teleport: Darnassus",
  "Teleport: Exodar",
  "Teleport: Orgrimmar",
  "Teleport: Undercity",
  "Teleport: Thunder Bluff",
  "Teleport: Silvermoon",
  "Teleport: Shattrath",
  "Teleport: Dalaran - Northrend",
  "Ancient Teleport: Dalaran",
  "Teleport: Tol Barad",
  "Teleport: Vale of Eternal Blossoms",
  "Teleport: Stormshield",
  "Teleport: Warspear",
  "Teleport: Hall of the Guardian",
  "Teleport: Dalaran - Broken Isles",
  "Teleport: Dazar'alor",
  "Teleport: Boralus",
  "Teleport: Oribos",
  "Teleport: Valdrakken",
  "Teleport: Dornogal",
}

local MAGE_PORTALS = {
  "Portal: Stormwind",
  "Portal: Ironforge",
  "Portal: Darnassus",
  "Portal: Exodar",
  "Portal: Orgrimmar",
  "Portal: Undercity",
  "Portal: Thunder Bluff",
  "Portal: Silvermoon",
  "Portal: Shattrath",
  "Portal: Dalaran - Northrend",
  "Portal: Tol Barad",
  "Portal: Vale of Eternal Blossoms",
  "Portal: Stormshield",
  "Portal: Warspear",
  "Portal: Hall of the Guardian",
  "Portal: Dalaran - Broken Isles",
  "Portal: Dazar'alor",
  "Portal: Boralus",
  "Portal: Oribos",
  "Portal: Valdrakken",
  "Portal: Dornogal",
}

local function IsMage()
  local _, class = UnitClass("player")
  return class == "MAGE"
end

local function GetMageColor()
  if C_ClassColor and C_ClassColor.GetClassColor then
    local color = C_ClassColor.GetClassColor("MAGE")
    if color then
      return color.r, color.g, color.b
    end
  end
  return 0.41, 0.8, 0.94
end

local function GetClassColor()
  local _, class = UnitClass("player")
  local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
  local color = colors and colors[class]
  if color then
    return { color.r, color.g, color.b }
  end
  return { Elysian.HexToRGB(Elysian.theme.fg) }
end

local function FormatGold(value)
  local gold = math.floor(value / 10000)
  local silver = math.floor((value % 10000) / 100)
  local copper = value % 100
  return string.format("%dg %ds %dc", gold, silver, copper)
end

local DURABILITY_SLOTS = { 1, 3, 5, 6, 7, 8, 9, 10, 16, 17 }

local function GetDamagePercent()
  local lowest = nil
  for _, slot in ipairs(DURABILITY_SLOTS) do
    local cur, max = GetInventoryItemDurability(slot)
    if cur and max and max > 0 then
      local pct = (cur / max) * 100
      if not lowest or pct < lowest then
        lowest = pct
      end
    end
  end
  return lowest
end

local function ResolveSpellKey(spellKey)
  if not spellKey then
    return nil
  end
  if type(spellKey) == "number" then
    return spellKey
  end
  if type(spellKey) == "string" and C_Spell and C_Spell.GetSpellInfo then
    local info = C_Spell.GetSpellInfo(spellKey)
    return info and info.spellID or nil
  end
  return nil
end

local function IsKnownSpellKey(spellKey)
  local spellID = ResolveSpellKey(spellKey)
  if not spellID then
    return false, nil
  end
  -- Retail's modern spellbook API is authoritative for challenge-mode
  -- dungeon teleports.  IsSpellKnown no longer reliably reports these spells.
  if C_SpellBook then
    if C_SpellBook.IsSpellInSpellBook then
      return C_SpellBook.IsSpellInSpellBook(spellID) and true or false, spellID
    end
    if C_SpellBook.IsSpellKnownOrInSpellBook then
      return C_SpellBook.IsSpellKnownOrInSpellBook(spellID) and true or false, spellID
    end
  end
  if IsPlayerSpell and IsPlayerSpell(spellID) then
    return true, spellID
  end
  return (IsSpellKnown and IsSpellKnown(spellID)) and true or false, spellID
end

local function FormatLargeNumber(value)
  if not value or value <= 0 then
    return "0"
  end
  if value >= 1000000 then
    return string.format("%.1fm", value / 1000000)
  end
  if value >= 1000 then
    return string.format("%.1fk", value / 1000)
  end
  return string.format("%d", math.floor(value + 0.5))
end

local function FormatTTL(seconds)
  if not seconds or seconds <= 0 or seconds == math.huge then
    return "--"
  end
  local total = math.floor(seconds + 0.5)
  local hours = math.floor(total / 3600)
  local minutes = math.floor((total % 3600) / 60)
  if hours > 0 then
    return string.format("%dh %dm", hours, minutes)
  end
  if minutes > 0 then
    return string.format("%dm", minutes)
  end
  return string.format("%ds", total)
end

function InfoBar:ResetXPTracking()
  self.xpSessionStart = GetTime and GetTime() or 0
  self.xpGained = 0
  self.lastXP = UnitXP and UnitXP("player") or 0
  self.lastXPMax = UnitXPMax and UnitXPMax("player") or 0
  self.lastLevel = UnitLevel and UnitLevel("player") or 0
end

function InfoBar:EnsureXPTracking()
  if self.xpSessionStart == nil then
    self:ResetXPTracking()
  end
end

function InfoBar:UpdateXPTracking()
  self:EnsureXPTracking()
  local currentXP = UnitXP and UnitXP("player") or 0
  local currentXPMax = UnitXPMax and UnitXPMax("player") or 0
  local currentLevel = UnitLevel and UnitLevel("player") or 0

  if currentLevel ~= self.lastLevel then
    if currentLevel > (self.lastLevel or 0) then
      local rollover = math.max(0, (self.lastXPMax or 0) - (self.lastXP or 0))
      self.xpGained = (self.xpGained or 0) + rollover + currentXP
    else
      self.xpGained = 0
    end
    self.xpSessionStart = GetTime and GetTime() or 0
  elseif currentXP >= (self.lastXP or 0) then
    self.xpGained = (self.xpGained or 0) + (currentXP - (self.lastXP or 0))
  elseif (self.lastXPMax or 0) > 0 then
    local rollover = math.max(0, (self.lastXPMax or 0) - (self.lastXP or 0))
    self.xpGained = (self.xpGained or 0) + rollover + currentXP
  end

  self.lastXP = currentXP
  self.lastXPMax = currentXPMax
  self.lastLevel = currentLevel
end

function InfoBar:GetXPStats()
  self:EnsureXPTracking()
  local currentXP = UnitXP and UnitXP("player") or 0
  local currentXPMax = UnitXPMax and UnitXPMax("player") or 0
  if currentXPMax <= 0 then
    return nil
  end

  local elapsed = math.max(1, (GetTime and GetTime() or 0) - (self.xpSessionStart or 0))
  local gained = math.max(0, self.xpGained or 0)
  if gained <= 0 then
    return {
      xpPerHour = 0,
      timeToLevel = nil,
    }
  end

  local xpPerHour = (gained / elapsed) * 3600
  if xpPerHour <= 0 then
    return {
      xpPerHour = 0,
      timeToLevel = nil,
    }
  end

  return {
    xpPerHour = xpPerHour,
    timeToLevel = (currentXPMax - currentXP) / (xpPerHour / 3600),
  }
end

function InfoBar:IsEnabled()
  return Elysian.state.infoBarEnabled and true or false
end

function InfoBar:SetEnabled(enabled)
  Elysian.state.infoBarEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.QueueSaveState()
  end
  if enabled then
    self:EnsureFrame()
    self:ApplyColors()
    self:UpdateText()
  end
  self:UpdateVisibility()
end

function InfoBar:EnsureFrame()
  if self.frame then
    return
  end

  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianInfoBar", UIParent, template)
  frame:SetSize(520, 24)
  frame:SetPoint("TOP", UIParent, "TOP", 0, -12)
  frame:SetFrameStrata("LOW")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(selfFrame)
    if Elysian.state.infoBarUnlocked then
      selfFrame:StartMoving()
    end
  end)
  frame:SetScript("OnDragStop", function(selfFrame)
    selfFrame:StopMovingOrSizing()
  end)

  Elysian.SetBackdrop(frame)
  self.frame = frame

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  text:SetPoint("CENTER")
  Elysian.ApplyFont(text, 12, "OUTLINE")
  Elysian.ApplyTextColor(text)
  self.text = text

  local readyButton = CreateFrame("Button", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  readyButton:SetSize(90, 22)
  readyButton:SetPoint("RIGHT", frame, "LEFT", -8, 0)
  Elysian.SetBackdrop(readyButton)

  local readyText = readyButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  readyText:SetPoint("CENTER")
  readyText:SetText("Ready?")
  Elysian.ApplyFont(readyText, 11, "OUTLINE")

  readyButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if DoReadyCheck then
      DoReadyCheck()
    elseif SlashCmdList and SlashCmdList.READYCHECK then
      SlashCmdList.READYCHECK("")
    end
  end)

  local pullButton = CreateFrame("Button", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  pullButton:SetSize(90, 22)
  pullButton:SetPoint("TOP", readyButton, "BOTTOM", 0, -6)
  Elysian.SetBackdrop(pullButton)

  local pullText = pullButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  pullText:SetPoint("CENTER")
  pullText:SetText("Pull")
  Elysian.ApplyFont(pullText, 11, "OUTLINE")

  pullButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local seconds = tonumber(Elysian.state.infoBarPullSeconds) or 10
    seconds = math.max(3, math.min(20, seconds))
    if C_PartyInfo and C_PartyInfo.DoCountdown then
      C_PartyInfo.DoCountdown(seconds)
    elseif DoCountdown then
      DoCountdown(seconds)
    elseif SlashCmdList and SlashCmdList.COUNTDOWN then
      SlashCmdList.COUNTDOWN(tostring(seconds))
    end
  end)

  local portalButton = CreateFrame("Button", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  portalButton:SetSize(140, 22)
  portalButton:SetPoint("TOP", frame, "BOTTOM", 0, -8)
  Elysian.SetBackdrop(portalButton)
  portalButton:Hide()

  local portalText = portalButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  portalText:SetPoint("CENTER")
  portalText:SetText("Portals")
  Elysian.ApplyFont(portalText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(portalText)

  portalButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    InfoBar:TogglePortalWindow()
  end)
  local function HookInfoBarButtonFeedback(button)
    if not button or not button.SetBackdropColor then
      return
    end
    local function SetActive(active)
      if active then
        Elysian.SetBackdropColors(button, { 0.92, 0.92, 0.92 }, Elysian.GetThemeBorder(), 0.95)
      else
        local bg = Elysian.state.infoBarBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
        local opacity = Elysian.state.infoBarOpacity or 0.35
        Elysian.SetBackdropColors(button, bg, Elysian.GetThemeBorder(), opacity)
      end
    end
    button:HookScript("OnMouseDown", function() SetActive(true) end)
    button:HookScript("OnMouseUp", function() SetActive(false) end)
    button:HookScript("OnHide", function() SetActive(false) end)
    button:HookScript("OnLeave", function() SetActive(false) end)
  end
  HookInfoBarButtonFeedback(portalButton)

  HookInfoBarButtonFeedback(readyButton)
  HookInfoBarButtonFeedback(pullButton)

  self.portalButton = portalButton
  self.portalText = portalText
  self.readyButton = readyButton
  self.readyText = readyText
  self.pullButton = pullButton
  self.pullText = pullText

  local mageTeleportButton = CreateFrame("Button", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  mageTeleportButton:SetSize(140, 22)
  mageTeleportButton:SetPoint("RIGHT", portalButton, "LEFT", -8, 0)
  Elysian.SetBackdrop(mageTeleportButton)
  mageTeleportButton:Hide()

  local mageTeleportText = mageTeleportButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  mageTeleportText:SetPoint("CENTER")
  mageTeleportText:SetText("Teleports")
  Elysian.ApplyFont(mageTeleportText, 11, "OUTLINE")
  local mr, mg, mb = GetMageColor()
  mageTeleportText:SetTextColor(mr, mg, mb)

  mageTeleportButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    InfoBar:ToggleMageTeleportsWindow()
  end)
  HookInfoBarButtonFeedback(mageTeleportButton)

  local magePortalButton = CreateFrame("Button", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  magePortalButton:SetSize(140, 22)
  magePortalButton:SetPoint("LEFT", portalButton, "RIGHT", 8, 0)
  Elysian.SetBackdrop(magePortalButton)
  magePortalButton:Hide()

  local magePortalText = magePortalButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  magePortalText:SetPoint("CENTER")
  magePortalText:SetText("Mage Portals")
  Elysian.ApplyFont(magePortalText, 11, "OUTLINE")
  magePortalText:SetTextColor(mr, mg, mb)

  magePortalButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    InfoBar:ToggleMagePortalsWindow()
  end)
  HookInfoBarButtonFeedback(magePortalButton)

  local function EnsurePortalCastFeedback(self)
    if self.portalCastEvents then
      return
    end
    local evt = CreateFrame("Frame")
    local function SetActive(button, active)
      if not button or not button.SetBackdrop then
        return
      end
      if active then
        Elysian.SetBackdropColors(button, { 0.92, 0.92, 0.92 }, Elysian.GetThemeBorder(), 0.95)
      else
        Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)
      end
    end
    local function GetCastingSpellID()
      local spellId = select(9, UnitCastingInfo("player"))
      if not spellId then
        spellId = select(9, UnitChannelInfo("player"))
      end
      return spellId
    end
    local function Refresh()
      local now = GetTime()
      local castingSpell = GetCastingSpellID()
      if not self.portalSpellButtons then
        return
      end
      for _, entry in ipairs(self.portalSpellButtons) do
        local active = (castingSpell and entry.spellID == castingSpell) or (entry.flashUntil and entry.flashUntil > now)
        SetActive(entry.button, active)
      end
    end
    evt:RegisterEvent("UNIT_SPELLCAST_START")
    evt:RegisterEvent("UNIT_SPELLCAST_STOP")
    evt:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    evt:RegisterEvent("UNIT_SPELLCAST_FAILED")
    evt:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
    evt:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    evt:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    evt:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    evt:SetScript("OnEvent", function(_, event, unit)
      if unit and unit ~= "player" then
        return
      end
      Refresh()
    end)
    self.portalCastEvents = evt
    self.RefreshPortalButtonCasts = Refresh
  end

  self.EnsurePortalCastFeedback = EnsurePortalCastFeedback
  self.AddPortalSpellButton = function(selfObj, button, spellID)
    if not button or not spellID then
      return
    end
    selfObj.portalSpellButtons = selfObj.portalSpellButtons or {}
    local entry = { button = button, spellID = spellID, flashUntil = 0 }
    table.insert(selfObj.portalSpellButtons, entry)
    button:HookScript("PostClick", function()
      entry.flashUntil = GetTime() + 0.6
      if selfObj.RefreshPortalButtonCasts then
        selfObj:RefreshPortalButtonCasts()
      end
      if C_Timer and selfObj.RefreshPortalButtonCasts then
        C_Timer.After(0.65, function()
          if selfObj.RefreshPortalButtonCasts then
            selfObj:RefreshPortalButtonCasts()
          end
        end)
      end
    end)
    selfObj:EnsurePortalCastFeedback()
  end

  self.mageTeleportButton = mageTeleportButton
  self.mageTeleportText = mageTeleportText
  self.magePortalButton = magePortalButton
  self.magePortalText = magePortalText

  local function HookPortalListButtonFeedback(button)
    if not button or not button.SetBackdrop then
      return
    end
    button:HookScript("OnMouseDown", function()
      Elysian.SetBackdropColors(button, { 0.92, 0.92, 0.92 }, Elysian.GetThemeBorder(), 0.95)
    end)
    button:HookScript("OnMouseUp", function()
      Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)
    end)
    button:HookScript("OnLeave", function()
      Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)
    end)
  end
  self.HookPortalListButtonFeedback = HookPortalListButtonFeedback

  self:ApplyColors()
  self:UpdateVisibility()

  frame:SetScript("OnUpdate", function(_, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 1 then
      self.elapsed = 0
      InfoBar:UpdateText()
    end
  end)
end

function InfoBar:ApplyColors()
  if not self.frame then
    return
  end

  local textColor = Elysian.state.infoBarTextColor or GetClassColor()
  local bgColor = Elysian.state.infoBarBgColor or { textColor[1], textColor[2], textColor[3] }
  local opacity = Elysian.state.infoBarOpacity or 0.35

  if self.text then
    self.text:SetTextColor(textColor[1], textColor[2], textColor[3])
  end
  if self.readyText then
    self.readyText:SetTextColor(textColor[1], textColor[2], textColor[3])
  end
  if self.pullText then
    self.pullText:SetTextColor(textColor[1], textColor[2], textColor[3])
  end

  Elysian.SetBackdropColors(self.frame, bgColor, Elysian.GetThemeBorder(), opacity)
  if self.portalButton then
    Elysian.SetBackdropColors(self.portalButton, bgColor, Elysian.GetThemeBorder(), opacity)
  end
  if self.readyButton then
    Elysian.SetBackdropColors(self.readyButton, bgColor, Elysian.GetThemeBorder(), opacity)
  end
  if self.pullButton then
    Elysian.SetBackdropColors(self.pullButton, bgColor, Elysian.GetThemeBorder(), opacity)
  end
  if self.mageTeleportButton then
    Elysian.SetBackdropColors(self.mageTeleportButton, bgColor, Elysian.GetThemeBorder(), opacity)
  end
  if self.magePortalButton then
    Elysian.SetBackdropColors(self.magePortalButton, bgColor, Elysian.GetThemeBorder(), opacity)
  end
end

function InfoBar:UpdateText()
  if not self.text then
    return
  end

  self:UpdateXPTracking()

  local parts = {}

  if Elysian.state.infoBarShowTime then
    table.insert(parts, date("%H:%M"))
  end

  if Elysian.state.infoBarShowGold then
    table.insert(parts, FormatGold(GetMoney()))
  end

  if Elysian.state.infoBarShowDurability then
    local pct = GetDamagePercent()
    if pct then
      table.insert(parts, string.format("Durability: %d%%", math.floor(pct + 0.5)))
    end
  end

  if Elysian.state.infoBarShowFPS then
    table.insert(parts, string.format("FPS: %d", math.floor(GetFramerate() + 0.5)))
  end

  if Elysian.state.infoBarShowMS then
    local _, _, home = GetNetStats()
    table.insert(parts, string.format("MS: %d", home or 0))
  end

  if Elysian.state.infoBarShowMemory then
    local memKb = collectgarbage and collectgarbage("count") or 0
    local memMb = memKb / 1024
    table.insert(parts, string.format("Addon Mem: %.1f MB", memMb))
  end

  local xpStats = self:GetXPStats()
  if Elysian.state.infoBarShowXPPerHour and xpStats then
    table.insert(parts, string.format("XP/hr: %s", FormatLargeNumber(xpStats.xpPerHour)))
  end

  if Elysian.state.infoBarShowTimeToLevel and xpStats then
    table.insert(parts, string.format("TTL: %s", FormatTTL(xpStats.timeToLevel)))
  end

  if Elysian.state.infoBarShowItemLevel then
    local avg = GetAverageItemLevel and select(2, GetAverageItemLevel()) or nil
    if avg then
      table.insert(parts, string.format("iLvl: %.1f", avg))
    end
  end

  if Elysian.state.infoBarShowHearthstone then
    local start, duration = GetItemCooldown(6948)
    if start and duration and duration > 0 then
      local remaining = math.max(0, (start + duration) - GetTime())
      if remaining <= 0 then
        table.insert(parts, "HS: Ready")
      else
        local mins = math.floor(remaining / 60)
        local secs = math.floor(remaining % 60)
        if mins >= 1 then
          table.insert(parts, string.format("HS: %dm", mins))
        else
          table.insert(parts, string.format("HS: %ds", secs))
        end
      end
    else
      table.insert(parts, "HS: Ready")
    end
  end

  self.text:SetText(table.concat(parts, "  |  "))
  if self.frame then
    self.text:Show()
    local width = self.text:GetStringWidth() or 0
    local padding = 28
    local minWidth = 220
    local finalWidth = math.max(minWidth, width + padding)
    self.frame:SetWidth(finalWidth)
  end
end

function InfoBar:UpdateVisibility()
  if not self.frame then
    return
  end
  if self:IsEnabled() then
    self.frame:Show()
    if self.readyButton then
      if Elysian.state.infoBarShowPullButtons ~= false then
        self.readyButton:Show()
      else
        self.readyButton:Hide()
      end
    end
    if self.pullButton then
      if Elysian.state.infoBarShowPullButtons ~= false then
        self.pullButton:Show()
      else
        self.pullButton:Hide()
      end
    end
    if self.portalButton then
      if Elysian.state.infoBarShowPortalButton then
        self.portalButton:Show()
        if IsMage() then
          if self.mageTeleportButton then
            self.mageTeleportButton:Show()
          end
          if self.magePortalButton then
            self.magePortalButton:Show()
          end
        else
          if self.mageTeleportButton then
            self.mageTeleportButton:Hide()
          end
          if self.magePortalButton then
            self.magePortalButton:Hide()
          end
        end
      else
        self.portalButton:Hide()
        if self.mageTeleportButton then
          self.mageTeleportButton:Hide()
        end
        if self.magePortalButton then
          self.magePortalButton:Hide()
        end
      end
    end
  else
    self.frame:Hide()
    if self.portalButton then
      self.portalButton:Hide()
    end
    if self.readyButton then
      self.readyButton:Hide()
    end
    if self.pullButton then
      self.pullButton:Hide()
    end
    if self.mageTeleportButton then
      self.mageTeleportButton:Hide()
    end
    if self.magePortalButton then
      self.magePortalButton:Hide()
    end
  end
end

local function CreateCheckbox(parent, label, x, y)
  local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  box:SetPoint("TOPLEFT", x, y)
  box.text = box.text or _G[box:GetName() .. "Text"]
  box.text:SetText(label)
  box.text:ClearAllPoints()
  box.text:SetPoint("LEFT", box, "RIGHT", 6, 0)
  box.text:SetWidth(220)
  box.text:SetWordWrap(false)
  box:SetSize(20, 20)
  box.text:SetJustifyH("LEFT")
  Elysian.ApplyFont(box.text, 14)
  Elysian.ApplyTextColor(box.text)
  Elysian.StyleCheckbox(box)
  return box
end

local function CreateColorButton(parent, label, x, y, getColor, setColor)
  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local button = CreateFrame("Button", nil, parent, template)
  button:SetPoint("TOPLEFT", x, y)
  button:SetSize(150, 22)
  button:EnableMouse(true)
  button:RegisterForClicks("LeftButtonUp")
  button:SetFrameStrata("HIGH")
  button:SetFrameLevel(30)
  Elysian.SetBackdrop(button)
  Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  text:SetPoint("CENTER")
  text:SetText(label)
  Elysian.ApplyFont(text, 11, "OUTLINE")
  Elysian.ApplyAccentColor(text)

  local swatch = button:CreateTexture(nil, "OVERLAY")
  swatch:SetSize(12, 12)
  swatch:SetPoint("RIGHT", -8, 0)
  local initial = getColor()
  swatch:SetColorTexture(initial[1], initial[2], initial[3], 1)

  button:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = getColor()
    local function apply(r, g, b)
      setColor({ r, g, b })
      swatch:SetColorTexture(r, g, b, 1)
      if Elysian.SaveState then
        Elysian.QueueSaveState()
      end
    end

    if Elysian.OpenColorPicker then
      Elysian.OpenColorPicker({
        r = color[1],
        g = color[2],
        b = color[3],
        opacity = 1,
        hasOpacity = false,
        swatchFunc = function()
          local r, g, b = ColorPickerFrame:GetColorRGB()
          apply(r, g, b)
        end,
        cancelFunc = function(prev)
          local pr = prev.r or prev[1] or color[1]
          local pg = prev.g or prev[2] or color[2]
          local pb = prev.b or prev[3] or color[3]
          apply(pr, pg, pb)
        end,
      })
    end
  end)

  return button
end

function InfoBar:CreatePanel(parent)
  local panel = CreateFrame("Frame", nil, parent)
  panel:SetAllPoints()

  local leftX = 16
  local rightX = 330
  local leftStartY = -36
  local rowGap = 24
  local rightStartY = -36
  local rightGap = 34

  local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 8, -8)
  title:SetText("Info Bar")
  Elysian.ApplyFont(title, 13, "OUTLINE")
  Elysian.ApplyTextColor(title)

  local enable = CreateCheckbox(panel, "Enable info bar", leftX, leftStartY)
  enable:SetChecked(self:IsEnabled())
  enable:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    InfoBar:SetEnabled(selfButton:GetChecked())
  end)

  local showTime = CreateCheckbox(panel, "Show time", leftX, leftStartY - rowGap)
  showTime:SetChecked(Elysian.state.infoBarShowTime)
  showTime:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowTime = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showGold = CreateCheckbox(panel, "Show gold", leftX, leftStartY - (rowGap * 2))
  showGold:SetChecked(Elysian.state.infoBarShowGold)
  showGold:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowGold = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showDurability = CreateCheckbox(panel, "Show durability", leftX, leftStartY - (rowGap * 3))
  showDurability:SetChecked(Elysian.state.infoBarShowDurability)
  showDurability:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowDurability = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showFPS = CreateCheckbox(panel, "Show FPS", leftX, leftStartY - (rowGap * 4))
  showFPS:SetChecked(Elysian.state.infoBarShowFPS)
  showFPS:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowFPS = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showMS = CreateCheckbox(panel, "Show MS", leftX, leftStartY - (rowGap * 5))
  showMS:SetChecked(Elysian.state.infoBarShowMS)
  showMS:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowMS = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showMemory = CreateCheckbox(panel, "Show memory", leftX, leftStartY - (rowGap * 6))
  showMemory:SetChecked(Elysian.state.infoBarShowMemory)
  showMemory:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowMemory = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showXPPerHour = CreateCheckbox(panel, "Show XP/hr", leftX, leftStartY - (rowGap * 14))
  showXPPerHour:SetChecked(Elysian.state.infoBarShowXPPerHour ~= false)
  showXPPerHour:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowXPPerHour = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showTimeToLevel = CreateCheckbox(panel, "Show time to level", leftX, leftStartY - (rowGap * 15))
  showTimeToLevel:SetChecked(Elysian.state.infoBarShowTimeToLevel ~= false)
  showTimeToLevel:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowTimeToLevel = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showItemLevel = CreateCheckbox(panel, "Show item level", leftX, leftStartY - (rowGap * 11))
  showItemLevel:SetChecked(Elysian.state.infoBarShowItemLevel)
  showItemLevel:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowItemLevel = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showHearth = CreateCheckbox(panel, "Show hearthstone", leftX, leftStartY - (rowGap * 12))
  showHearth:SetChecked(Elysian.state.infoBarShowHearthstone)
  showHearth:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowHearthstone = selfButton:GetChecked()
    InfoBar:UpdateText()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local unlock = CreateCheckbox(panel, "Unlock and move", leftX, leftStartY - (rowGap * 16) - 155)
  unlock:SetChecked(Elysian.state.infoBarUnlocked)
  unlock:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarUnlocked = selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local showPortal = CreateCheckbox(panel, "Show portal button", leftX, leftStartY - (rowGap * 9))
  showPortal:SetChecked(Elysian.state.infoBarShowPortalButton)
  showPortal:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowPortalButton = selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
    InfoBar:UpdateVisibility()
  end)

  local showPull = CreateCheckbox(panel, "Show ready/pull", leftX, leftStartY - (rowGap * 10))
  showPull:SetChecked(Elysian.state.infoBarShowPullButtons ~= false)
  showPull:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.infoBarShowPullButtons = selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
    InfoBar:UpdateVisibility()
  end)

  local textColorButton = CreateColorButton(
    panel,
    "Text Color",
    rightX,
    rightStartY,
    function()
      return Elysian.state.infoBarTextColor or GetClassColor()
    end,
    function(color)
      Elysian.state.infoBarTextColor = color
      InfoBar:ApplyColors()
    end
  )

  local bgColorButton = CreateColorButton(
    panel,
    "Background Color",
    rightX,
    rightStartY + rightGap,
    function()
      return Elysian.state.infoBarBgColor or GetClassColor()
    end,
    function(color)
      Elysian.state.infoBarBgColor = color
      InfoBar:ApplyColors()
    end
  )

  local opacityLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  opacityLabel:SetPoint("TOPLEFT", bgColorButton, "BOTTOMLEFT", 0, -46)
  opacityLabel:SetText("Transparency")
  Elysian.ApplyFont(opacityLabel, 11)
  Elysian.ApplyTextColor(opacityLabel)

  local opacitySlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  opacitySlider:SetPoint("TOPLEFT", opacityLabel, "BOTTOMLEFT", 0, -16)
  opacitySlider:SetWidth(180)
  opacitySlider:SetMinMaxValues(0.1, 1.0)
  opacitySlider:SetValueStep(0.05)
  opacitySlider:SetObeyStepOnDrag(true)
  opacitySlider:EnableMouse(true)
  opacitySlider:SetHitRectInsets(-10, -10, -6, -6)
  opacitySlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
  if opacitySlider:GetThumbTexture() then
    opacitySlider:GetThumbTexture():SetSize(16, 16)
  end
  opacitySlider:SetValue(Elysian.state.infoBarOpacity or 0.35)
  if opacitySlider.Low then
    opacitySlider.Low:SetText("")
  end
  if opacitySlider.High then
    opacitySlider.High:SetText("")
  end

  opacitySlider:SetScript("OnValueChanged", function(selfSlider, value)
    local rounded = math.floor(value * 100 + 0.5) / 100
    Elysian.state.infoBarOpacity = rounded
    InfoBar:ApplyColors()
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  local pullLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  pullLabel:SetPoint("TOPLEFT", opacitySlider, "BOTTOMLEFT", 0, -22)
  pullLabel:SetText("Pull Timer")
  Elysian.ApplyFont(pullLabel, 11)
  Elysian.ApplyTextColor(pullLabel)

  local pullSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  pullSlider:SetPoint("TOPLEFT", pullLabel, "BOTTOMLEFT", 0, -16)
  pullSlider:SetWidth(180)
  pullSlider:SetMinMaxValues(3, 20)
  pullSlider:SetValueStep(1)
  pullSlider:SetObeyStepOnDrag(true)
  pullSlider:EnableMouse(true)
  pullSlider:SetHitRectInsets(-10, -10, -6, -6)
  pullSlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
  if pullSlider:GetThumbTexture() then
    pullSlider:GetThumbTexture():SetSize(16, 16)
  end
  local pullValue = tonumber(Elysian.state.infoBarPullSeconds) or 10
  pullSlider:SetValue(pullValue)
  if pullSlider.Low then
    pullSlider.Low:SetText("")
  end
  if pullSlider.High then
    pullSlider.High:SetText("")
  end
  if pullSlider.Text then
    pullSlider.Text:SetText(string.format("%ds", pullValue))
  end
  pullSlider:SetScript("OnValueChanged", function(selfSlider, value)
    local rounded = math.max(3, math.min(20, math.floor(value + 0.5)))
    Elysian.state.infoBarPullSeconds = rounded
    if selfSlider.Text then
      selfSlider.Text:SetText(string.format("%ds", rounded))
    end
    if Elysian.SaveState then
      Elysian.QueueSaveState()
    end
  end)

  unlock:ClearAllPoints()
  unlock:SetPoint("TOPLEFT", leftX, leftStartY - (rowGap * 6) - 20)

  self.enable = enable
  panel:Hide()
  return panel
end

function InfoBar:Refresh()
  if self.enable then
    self.enable:SetChecked(self:IsEnabled())
  end
end

function InfoBar:Initialize()
  self:EnsureFrame()
  self:EnsureXPTracking()
  self:UpdateText()
  self:ApplyColors()
  self:UpdateVisibility()
end

function InfoBar:EnsurePortalWindow()
  if self.portalWindow then
    return
  end
  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianPortalsFrame", UIParent, template)
  frame:SetSize(520, 420)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  frame:SetFrameStrata("DIALOG")
  frame:SetFrameLevel(200)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:EnableMouseWheel(true)
  frame:SetClampedToScreen(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  Elysian.SetBackdrop(frame)
  Elysian.SetBackdropColors(frame, Elysian.GetContentBg(), Elysian.GetThemeBorder(), 0.95)

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -12)
  title:SetText("Portals")
  Elysian.ApplyFont(title, 13, "OUTLINE")
  Elysian.ApplyAccentColor(title)

  local close = CreateFrame("Button", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
  close:SetSize(18, 18)
  close:SetPoint("TOPRIGHT", -8, -8)
  close:SetFrameLevel(frame:GetFrameLevel() + 5)
  Elysian.SetBackdrop(close)
  Elysian.SetBackdropColors(close, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local closeText = close:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  closeText:SetPoint("CENTER")
  closeText:SetText("X")
  Elysian.ApplyFont(closeText, 10, "OUTLINE")
  Elysian.ApplyAccentColor(closeText)
  close:SetScript("OnClick", function()
    frame:Hide()
  end)

  local content = CreateFrame("Frame", nil, frame)
  content:SetPoint("TOPLEFT", 12, -44)
  content:SetPoint("BOTTOMRIGHT", -12, 12)

  local backButton = CreateFrame("Button", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
  backButton:SetSize(70, 20)
  backButton:SetPoint("TOPLEFT", 12, -12)
  Elysian.SetBackdrop(backButton)
  Elysian.SetBackdropColors(backButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local backText = backButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  backText:SetPoint("CENTER")
  backText:SetText("Back")
  Elysian.ApplyFont(backText, 10, "OUTLINE")
  Elysian.ApplyAccentColor(backText)
  backButton:Hide()

  self.portalButtons = {}
  self.portalCooldowns = {}

  local function ClearButtons()
    for _, obj in ipairs(self.portalButtons) do
      obj:Hide()
      obj:SetParent(nil)
    end
    wipe(self.portalButtons)
    for _, cd in ipairs(self.portalCooldowns) do
      cd.frame:Hide()
    end
    wipe(self.portalCooldowns)
  end

  local function GetMapName(mapID)
    if C_Map and C_Map.GetMapInfo then
      local info = C_Map.GetMapInfo(mapID)
      if info and info.name then
        return info.name
      end
    end
    return "Unknown"
  end

  local RenderExpansion

  local function RegisterPortalSpellButton(self, button, spellID)
    if self.AddPortalSpellButton then
      self:AddPortalSpellButton(button, spellID)
    end
  end

  local function RenderRoot()
    ClearButtons()
    self.portalSpellButtons = {}
    backButton:Hide()
    local data = Elysian.PortalData
    if not data then
      return
    end
    local y = -10
    for _, expansion in ipairs(data.expansionOrder or {}) do
      local label = expansion
      if expansion == "The War Within" then
        label = "Hero's Path: The War Within"
      end
      local button = CreateFrame("Button", nil, content, BackdropTemplateMixin and "BackdropTemplate" or nil)
      button:SetPoint("TOP", 0, y)
      button:SetSize(300, 22)
      button:SetFrameLevel(frame:GetFrameLevel() + 1)
      Elysian.SetBackdrop(button)
      Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      text:SetPoint("CENTER")
      text:SetText(label)
      Elysian.ApplyFont(text, 10, "OUTLINE")
      Elysian.ApplyAccentColor(text)

      button:SetScript("OnClick", function()
        RenderExpansion(expansion)
      end)
      table.insert(self.portalButtons, button)
      y = y - 26
    end
  end

  RenderExpansion = function(expansion)
    ClearButtons()
    backButton:Show()
    local data = Elysian.PortalData
    if not data then
      return
    end
    local entries = {}
    if data.expansionEntries and data.expansionEntries[expansion] then
      for _, configured in ipairs(data.expansionEntries[expansion]) do
        table.insert(entries, configured)
      end
    else
      local mapIDs = data.expansionToMapIDs and data.expansionToMapIDs[expansion] or {}
      for _, mapID in ipairs(mapIDs) do
        local label = (data.mapIDToName and data.mapIDToName[mapID]) or GetMapName(mapID)
        table.insert(entries, { mapID = mapID, label = label })
      end
      table.sort(entries, function(a, b)
        return string.lower(a.label) < string.lower(b.label)
      end)
    end
    local y = -10
    for _, entry in ipairs(entries) do
      local mapID = entry.mapID
      local spellKey = entry.spellID or entry.spellKey
      if not spellKey and mapID then
        spellKey = data.mapIDToSpellNameOverride and data.mapIDToSpellNameOverride[mapID]
        if not spellKey then
          spellKey = data.mapIDToSpellID and data.mapIDToSpellID[mapID]
        end
      end
      local button = CreateFrame("Button", nil, content, "SecureActionButtonTemplate,BackdropTemplate")
      button:SetPoint("TOP", 0, y)
      button:SetSize(340, 22)
      button:SetFrameLevel(frame:GetFrameLevel() + 1)
      Elysian.SetBackdrop(button)
      Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      text:SetPoint("CENTER")
      text:SetText(entry.label)
      Elysian.ApplyFont(text, 10, "OUTLINE")
      if entry.placeholder then
        text:SetTextColor(0.65, 0.65, 0.65)
      else
        Elysian.ApplyAccentColor(text)
      end

      local known, resolvedSpellID = false, nil
      if spellKey and spellKey ~= 0 then
        known, resolvedSpellID = IsKnownSpellKey(spellKey)
      end
      if known then
        button:SetAttribute("type", "spell")
        button:SetAttribute("spell", resolvedSpellID)
        button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
        button:EnableMouse(true)
      else
        button:SetAttribute("type", nil)
        button:EnableMouse(false)
      end

      local unknownText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      unknownText:SetPoint("CENTER")
      unknownText:SetText("X")
      unknownText:SetTextColor(1, 0.2, 0.2)
      Elysian.ApplyFont(unknownText, 16, "OUTLINE")
      button.unknownText = unknownText
      button.unknownText:SetShown(not known)

      RegisterPortalSpellButton(self, button, resolvedSpellID or spellKey)
      if self.HookPortalListButtonFeedback then
        self:HookPortalListButtonFeedback(button)
      end

      local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
      cooldown:SetAllPoints()
      cooldown:SetDrawBling(false)
      cooldown:SetDrawEdge(false)
      cooldown:SetDrawSwipe(false)
      cooldown:SetSwipeColor(0, 0, 0, 0)
      cooldown:Hide()
      table.insert(self.portalCooldowns, { frame = cooldown, spellID = resolvedSpellID or spellKey })

      table.insert(self.portalButtons, button)
      y = y - 24
    end

    InfoBar:UpdatePortalCooldowns()
  end

  backButton:SetScript("OnClick", function()
    RenderRoot()
  end)

  RenderRoot()

  self.portalWindow = frame
  tinsert(UISpecialFrames, frame:GetName())

  if not self.portalCooldownFrame then
    local evt = CreateFrame("Frame")
    evt:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    evt:RegisterEvent("PLAYER_ENTERING_WORLD")
    evt:RegisterEvent("SPELLS_CHANGED")
    evt:SetScript("OnEvent", function()
      if self.portalWindow and self.portalWindow:IsShown() then
        self:UpdatePortalCooldowns()
      end
    end)
    self.portalCooldownFrame = evt
  end
end

local function BuildMageWindow(titleText, spellList, windowName)
  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", windowName, UIParent, template)
  frame:SetSize(360, 420)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  frame:SetFrameStrata("DIALOG")
  frame:SetFrameLevel(200)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:SetClampedToScreen(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  Elysian.SetBackdrop(frame)
  Elysian.SetBackdropColors(frame, Elysian.GetContentBg(), Elysian.GetThemeBorder(), 0.95)

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -12)
  title:SetText(titleText)
  Elysian.ApplyFont(title, 13, "OUTLINE")
  local r, g, b = GetMageColor()
  title:SetTextColor(r, g, b)

  local close = CreateFrame("Button", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
  close:SetSize(18, 18)
  close:SetPoint("TOPRIGHT", -8, -8)
  close:SetFrameLevel(frame:GetFrameLevel() + 5)
  Elysian.SetBackdrop(close)
  Elysian.SetBackdropColors(close, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local closeText = close:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  closeText:SetPoint("CENTER")
  closeText:SetText("X")
  Elysian.ApplyFont(closeText, 10, "OUTLINE")
  closeText:SetTextColor(r, g, b)
  close:SetScript("OnClick", function()
    frame:Hide()
  end)

  local content = CreateFrame("Frame", nil, frame)
  content:SetPoint("TOPLEFT", 12, -44)
  content:SetPoint("BOTTOMRIGHT", -12, 12)

  local buttons = {}
  local cooldowns = {}
  local y = -6
  for _, name in ipairs(spellList) do
    local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(name) or nil
    local spellID = info and info.spellID or nil
    if spellID then
      local button = CreateFrame("Button", nil, content, "SecureActionButtonTemplate,BackdropTemplate")
      button:SetPoint("TOP", content, "TOP", 0, y)
      button:SetSize(300, 22)
      button:SetFrameLevel(frame:GetFrameLevel() + 1)
      Elysian.SetBackdrop(button)
      Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      text:SetPoint("CENTER")
      local label = name
      label = label:gsub("^Portal:%s*", "")
      label = label:gsub("^Teleport:%s*", "")
      label = label:gsub("^Ancient Teleport:%s*", "")
      text:SetText(label)
      Elysian.ApplyFont(text, 10, "OUTLINE")
      text:SetTextColor(r, g, b)

      local known = IsSpellKnown and IsSpellKnown(spellID)
      if known then
        button:SetAttribute("type", "spell")
        button:SetAttribute("spell", spellID)
        button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
        button:EnableMouse(true)
      else
        button:SetAttribute("type", nil)
        button:EnableMouse(false)
      end

      if not button.unknownText then
        local unknownText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        unknownText:SetPoint("CENTER")
        unknownText:SetText("X")
        unknownText:SetTextColor(1, 0.2, 0.2)
        Elysian.ApplyFont(unknownText, 16, "OUTLINE")
        button.unknownText = unknownText
      end
      button.unknownText:SetShown(not known)
      button.spellID = spellID
      if InfoBar and InfoBar.HookPortalListButtonFeedback then
        InfoBar:HookPortalListButtonFeedback(button)
      end

      local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
      cooldown:SetAllPoints()
      cooldown:SetDrawBling(false)
      cooldown:SetDrawEdge(false)
      cooldown:SetDrawSwipe(false)
      cooldown:SetSwipeColor(0, 0, 0, 0)
      cooldown:Hide()

      table.insert(buttons, button)
      table.insert(cooldowns, { frame = cooldown, spellID = spellID })
      y = y - 24
    end
  end

  return frame, buttons, cooldowns
end

function InfoBar:EnsureMageTeleportsWindow()
  if self.mageTeleportsWindow then
    return
  end
  local frame, buttons, cooldowns = BuildMageWindow("Mage Teleports", MAGE_TELEPORTS, "ElysianMageTeleportsFrame")
  self.mageTeleportsWindow = frame
  self.mageTeleportButtons = buttons
  self.mageTeleportCooldowns = cooldowns
  if self.AddPortalSpellButton then
    for _, button in ipairs(buttons) do
      if button.spellID then
        self:AddPortalSpellButton(button, button.spellID)
      end
    end
  end
  tinsert(UISpecialFrames, frame:GetName())
end

function InfoBar:EnsureMagePortalsWindow()
  if self.magePortalsWindow then
    return
  end
  local frame, buttons, cooldowns = BuildMageWindow("Mage Portals", MAGE_PORTALS, "ElysianMagePortalsFrame")
  self.magePortalsWindow = frame
  self.magePortalButtons = buttons
  self.magePortalCooldowns = cooldowns
  if self.AddPortalSpellButton then
    for _, button in ipairs(buttons) do
      if button.spellID then
        self:AddPortalSpellButton(button, button.spellID)
      end
    end
  end
  tinsert(UISpecialFrames, frame:GetName())
end

function InfoBar:UpdatePortalCooldowns()
  local function UpdateList(list)
    if not list then
      return
    end
    for _, entry in ipairs(list) do
      local spellID = ResolveSpellKey(entry.spellID)
      local info = spellID and C_Spell and C_Spell.GetSpellCooldown and C_Spell.GetSpellCooldown(spellID) or nil
      local start = info and info.startTime or 0
      local duration = info and info.duration or 0
      if start > 0 and duration > 0 then
        entry.frame:SetCooldown(start, duration)
        entry.frame:Show()
      else
        entry.frame:Hide()
      end
    end
  end
  UpdateList(self.portalCooldowns)
  UpdateList(self.mageTeleportCooldowns)
  UpdateList(self.magePortalCooldowns)
end

function InfoBar:TogglePortalWindow()
  local wasCreated = not self.portalWindow
  self:EnsurePortalWindow()
  if wasCreated then
    if self.mageTeleportsWindow then
      self.mageTeleportsWindow:Hide()
    end
    if self.magePortalsWindow then
      self.magePortalsWindow:Hide()
    end
    self.portalWindow:Show()
    self:UpdatePortalCooldowns()
    return
  end
  if self.portalWindow:IsShown() then
    self.portalWindow:Hide()
  else
    if self.mageTeleportsWindow then
      self.mageTeleportsWindow:Hide()
    end
    if self.magePortalsWindow then
      self.magePortalsWindow:Hide()
    end
    self.portalWindow:Show()
    self:UpdatePortalCooldowns()
  end
end

function InfoBar:ToggleMageTeleportsWindow()
  local wasCreated = not self.mageTeleportsWindow
  self:EnsureMageTeleportsWindow()
  if wasCreated then
    if self.portalWindow then
      self.portalWindow:Hide()
    end
    if self.magePortalsWindow then
      self.magePortalsWindow:Hide()
    end
    self.mageTeleportsWindow:Show()
    self:UpdatePortalCooldowns()
    return
  end
  if self.mageTeleportsWindow:IsShown() then
    self.mageTeleportsWindow:Hide()
  else
    if self.portalWindow then
      self.portalWindow:Hide()
    end
    if self.magePortalsWindow then
      self.magePortalsWindow:Hide()
    end
    self.mageTeleportsWindow:Show()
    self:UpdatePortalCooldowns()
  end
end

function InfoBar:ToggleMagePortalsWindow()
  local wasCreated = not self.magePortalsWindow
  self:EnsureMagePortalsWindow()
  if wasCreated then
    if self.portalWindow then
      self.portalWindow:Hide()
    end
    if self.mageTeleportsWindow then
      self.mageTeleportsWindow:Hide()
    end
    self.magePortalsWindow:Show()
    self:UpdatePortalCooldowns()
    return
  end
  if self.magePortalsWindow:IsShown() then
    self.magePortalsWindow:Hide()
  else
    if self.portalWindow then
      self.portalWindow:Hide()
    end
    if self.mageTeleportsWindow then
      self.mageTeleportsWindow:Hide()
    end
    self.magePortalsWindow:Show()
    self:UpdatePortalCooldowns()
  end
end

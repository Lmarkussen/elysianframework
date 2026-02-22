local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local CursorRing = {}
Elysian.Features.CursorRing = CursorRing

local SHAPES = {
  RING = "Interface\\AddOns\\ElysianFramework\\Assets\\cursor_ring.tga",
  THIN = "Interface\\AddOns\\ElysianFramework\\Assets\\cursor_ring_thin.tga",
  STAR = "Interface\\AddOns\\ElysianFramework\\Assets\\cursor_star.tga",
  SQUARE = "Interface\\AddOns\\ElysianFramework\\Assets\\cursor_square.tga",
  CROSSHAIR = "Interface\\AddOns\\ElysianFramework\\Assets\\cursor_crosshair.tga",
}

local TRAIL_SHAPES = {
  SPARK = "Interface\\AddOns\\ElysianFramework\\Assets\\cursor_spark.tga",
  RING = SHAPES.RING,
  THIN = SHAPES.THIN,
  STAR = SHAPES.STAR,
  SQUARE = SHAPES.SQUARE,
  CROSSHAIR = SHAPES.CROSSHAIR,
}

local function GetClassColor()
  local _, class = UnitClass("player")
  local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
  local color = colors and colors[class]
  if color then
    return { color.r, color.g, color.b }
  end
  return nil
end

local function Clamp(value, min, max)
  if value < min then
    return min
  end
  if value > max then
    return max
  end
  return value
end

function CursorRing:IsEnabled()
  return Elysian.state.cursorRingEnabled and true or false
end

function CursorRing:SetEnabled(enabled)
  Elysian.state.cursorRingEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  if enabled then
    self:EnsureFrame()
    self:ApplyShape()
    self:ApplyColors()
    self:UpdateVisibility()
    if C_Timer and C_Timer.After then
      C_Timer.After(0.2, function()
        CursorRing:UpdateVisibility()
      end)
    end
  end
  self:UpdateVisibility()
end

function CursorRing:SetSize(size)
  Elysian.state.cursorRingSize = size
  if self.frame then
    self.frame:SetSize(size, size)
  end
  if self.trailTextures then
    local trailSize = Clamp(size * 0.5, 6, 24)
    for _, tex in ipairs(self.trailTextures) do
      tex:SetSize(trailSize, trailSize)
    end
  end
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function CursorRing:SetColor(color)
  Elysian.state.cursorRingColor = color
  if self.texture and color then
    self.texture:SetVertexColor(color[1], color[2], color[3], 1)
  end
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function CursorRing:SetCastColor(color)
  Elysian.state.cursorRingCastColor = color
  if self.cooldown and color then
    self.cooldown:SetSwipeColor(color[1], color[2], color[3], 0.6)
  end
  self:UpdateCastProgress()
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function CursorRing:SetTrailColor(color)
  Elysian.state.cursorRingTrailColor = color
  if Elysian.state.cursorRingTrailRandom then
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    return
  end
  if self.trailTextures then
    for i, tex in ipairs(self.trailTextures) do
      local alpha = self:GetTrailAlpha(i)
      tex:SetVertexColor(color[1], color[2], color[3], alpha)
    end
  end
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function CursorRing:GetTrailTexture()
  local shape = Elysian.state.cursorRingTrailShape or "SPARK"
  return TRAIL_SHAPES[shape] or TRAIL_SHAPES.SPARK
end

function CursorRing:SetTrailShape(shape)
  Elysian.state.cursorRingTrailShape = shape
  if self.trailTextures then
    local texture = self:GetTrailTexture()
    for _, tex in ipairs(self.trailTextures) do
      tex:SetTexture(texture)
    end
  end
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function CursorRing:GetRingColor()
  if Elysian.state.cursorRingClassColor then
    return GetClassColor() or Elysian.state.cursorRingColor
  end
  return Elysian.state.cursorRingColor
end

function CursorRing:GetTrailAlpha(index)
  local count = Elysian.state.cursorRingTrailLength or 12
  local fade = Elysian.state.cursorRingTrailFade or 0.6
  if count <= 1 then
    return fade
  end
  return fade * (1 - ((index - 1) / count))
end

function CursorRing:ApplyShape()
  if not self.texture then
    return
  end
  local shape = Elysian.state.cursorRingShape or "RING"
  local texture = SHAPES[shape] or SHAPES.RING
  self.texture:SetTexture(texture)
  if self.cooldown and self.cooldown.SetSwipeTexture then
    self.cooldown:SetSwipeTexture(texture)
  end
end

function CursorRing:ApplyColors()
  local color = self:GetRingColor() or { Elysian.HexToRGB(Elysian.theme.accent) }
  self.texture:SetVertexColor(color[1], color[2], color[3], 1)

  local castColor = Elysian.state.cursorRingCastColor or { Elysian.HexToRGB(Elysian.theme.accent) }
  if self.cooldown then
    self.cooldown:SetSwipeColor(castColor[1], castColor[2], castColor[3], 0.6)
  end

  local trailColor = Elysian.state.cursorRingTrailColor or { Elysian.HexToRGB(Elysian.theme.accent) }
  if self.trailTextures then
    for i, tex in ipairs(self.trailTextures) do
      if Elysian.state.cursorRingTrailRandom then
        local rc = tex.randomColor
        if rc then
          tex:SetVertexColor(rc[1], rc[2], rc[3], self:GetTrailAlpha(i))
        else
          tex:SetVertexColor(trailColor[1], trailColor[2], trailColor[3], self:GetTrailAlpha(i))
        end
      else
        tex:SetVertexColor(trailColor[1], trailColor[2], trailColor[3], self:GetTrailAlpha(i))
      end
    end
  end

  -- sparkles removed
end

function CursorRing:ApplyCastColor(active)
  if not self.texture then
    return
  end
  if active then
    local castColor = Elysian.state.cursorRingCastColor or { Elysian.HexToRGB(Elysian.theme.accent) }
    self.texture:SetVertexColor(castColor[1], castColor[2], castColor[3], 1)
  else
    self:ApplyColors()
  end
end

function CursorRing:IsVisibleNow()
  if not self:IsEnabled() then
    return false
  end

  local inInstance = select(1, IsInInstance())
  local inCombat = InCombatLockdown()

  local allowLocation = false
  if inInstance and Elysian.state.cursorRingShowInInstances then
    allowLocation = true
  elseif not inInstance and Elysian.state.cursorRingShowInWorld then
    allowLocation = true
  end

  local allowCombat = false
  if inCombat and Elysian.state.cursorRingShowInCombat then
    allowCombat = true
  elseif (not inCombat) and Elysian.state.cursorRingShowOutCombat then
    allowCombat = true
  end

  return allowLocation and allowCombat
end

function CursorRing:UpdateVisibility()
  if not self.frame then
    return
  end
  if self:IsVisibleNow() then
    self.frame:Show()
    if self.trailFrame then
      self.trailFrame:Show()
    end
  else
    self.frame:Hide()
    if self.trailFrame then
      self.trailFrame:Hide()
    end
  end
end

function CursorRing:UpdateCastProgress()
  if not Elysian.state.cursorRingCastProgress then
    self.castActive = false
    if self.cooldown then
      self.cooldown:Hide()
    end
    self:ApplyCastColor(false)
    return
  end

  local name, _, _, startTime, endTime = UnitCastingInfo("player")
  local isChannel = false
  if not name then
    name, _, _, startTime, endTime = UnitChannelInfo("player")
    isChannel = name ~= nil
  end

  if not name or not startTime or not endTime then
    self.castActive = false
    if self.cooldown then
      self.cooldown:Hide()
    end
    self:ApplyCastColor(false)
    return
  end

  self.castActive = true
  local duration = (endTime - startTime) / 1000
  if self.cooldown then
    local castColor = Elysian.state.cursorRingCastColor or { Elysian.HexToRGB(Elysian.theme.accent) }
    if self.cooldown.SetSwipeColor then
      self.cooldown:SetSwipeColor(castColor[1], castColor[2], castColor[3], 1)
    end
    self.cooldown:SetCooldown(startTime / 1000, duration)
    if self.cooldown.SetReverse then
      self.cooldown:SetReverse(isChannel)
    end
    self.cooldown:Show()
  end
  self:ApplyCastColor(true)
end

function CursorRing:EnsureTrail()
  if self.trailTextures then
    return
  end

  local trailFrame = CreateFrame("Frame", nil, UIParent)
  trailFrame:SetFrameStrata("FULLSCREEN_DIALOG")
  trailFrame:SetFrameLevel(9998)
  trailFrame:EnableMouse(false)
  trailFrame:Hide()
  self.trailFrame = trailFrame

  local count = Elysian.state.cursorRingTrailLength or 12
  local trailSize = Clamp((Elysian.state.cursorRingSize or 18) * 0.5, 6, 24)
  local texture = self:GetTrailTexture()
  local textures = {}
  for i = 1, count do
    local tex = trailFrame:CreateTexture(nil, "OVERLAY")
    tex:SetTexture(texture)
    tex:SetSize(trailSize, trailSize)
    tex:Hide()
    textures[i] = tex
  end
  self.trailTextures = textures
  self.trailPositions = {}
  self.trailElapsed = 0
end

function CursorRing:UpdateTrail(elapsed, x, y)
  if not Elysian.state.cursorRingTrailEnabled then
    if self.trailTextures then
      for _, tex in ipairs(self.trailTextures) do
        tex:Hide()
      end
    end
    if self.trailFrame then
      self.trailFrame:Hide()
    end
    return
  end

  if not self.trailTextures then
    self:EnsureTrail()
    self:ApplyColors()
  end
  if self.trailFrame then
    self.trailFrame:Show()
  end

  self.trailElapsed = (self.trailElapsed or 0) + elapsed
  self.trailIdle = self.trailIdle or 0
  local fadeTime = Elysian.state.cursorRingTrailFadeTime or 0.25
  local spacing = Elysian.state.cursorRingTrailSpacing or 0.02
  local ringSize = Elysian.state.cursorRingSize or 18
  local minRadius = ringSize * 0.55
  local lastX = self.lastTrailX
  local lastY = self.lastTrailY
  local moved = (not lastX) or (not lastY) or (math.abs(x - lastX) > 0.5) or (math.abs(y - lastY) > 0.5)
  if moved then
    if self.trailIdle > 0 then
      self.trailIdle = 0
    end
    self.lastTrailX = x
    self.lastTrailY = y
    if self.trailElapsed >= spacing or #self.trailPositions == 0 then
      self.trailElapsed = 0
      local dx = x - (lastX or x)
      local dy = y - (lastY or y)
      local dist = math.sqrt(dx * dx + dy * dy)
      local nx, ny = 0, 0
      if dist > 0 then
        nx = dx / dist
        ny = dy / dist
      end
      local px = x - nx * minRadius
      local py = y - ny * minRadius
      table.insert(self.trailPositions, 1, { x = px, y = py, t = GetTime() })
      local maxCount = Elysian.state.cursorRingTrailLength or 12
      while #self.trailPositions > maxCount do
        table.remove(self.trailPositions)
      end
    end
  else
    self.trailElapsed = 0
    if fadeTime <= 0 then
      self.trailPositions = {}
      self.trailIdle = 0
    else
      self.trailIdle = self.trailIdle + elapsed
      if self.trailIdle >= fadeTime then
        self.trailPositions = {}
        self.trailIdle = 0
      end
    end
  end

  local idleScale = 1
  if not moved and fadeTime > 0 then
    idleScale = math.max(0, 1 - (self.trailIdle / fadeTime))
  end

  if moved then
    self.trailCollapse = 0
  elseif #self.trailPositions > 0 then
    local maxCount = Elysian.state.cursorRingTrailLength or 12
    local collapseRate = maxCount / math.max(fadeTime, 0.1)
    self.trailCollapse = (self.trailCollapse or 0) + elapsed * collapseRate
    local removeCount = math.floor(self.trailCollapse)
    if removeCount > 0 then
      self.trailCollapse = self.trailCollapse - removeCount
      for _ = 1, removeCount do
        if #self.trailPositions > 0 then
          table.remove(self.trailPositions)
        else
          break
        end
      end
    end
  end

  if #self.trailPositions > 0 then
    for _, pos in ipairs(self.trailPositions) do
      local dx = pos.x - x
      local dy = pos.y - y
      local dist = math.sqrt(dx * dx + dy * dy)
      if dist < minRadius then
        if dist == 0 then
          pos.x = x - minRadius
          pos.y = y
        else
          local nx = dx / dist
          local ny = dy / dist
          pos.x = x + nx * minRadius
          pos.y = y + ny * minRadius
        end
      end
    end
  end

  for i, tex in ipairs(self.trailTextures) do
    local pos = self.trailPositions[i]
    if pos then
      tex:ClearAllPoints()
      tex:SetPoint("CENTER", UIParent, "BOTTOMLEFT", pos.x, pos.y)
      local baseAlpha = self:GetTrailAlpha(i)
      local alpha = baseAlpha * idleScale
      local color = Elysian.state.cursorRingTrailColor or { Elysian.HexToRGB(Elysian.theme.accent) }
      if Elysian.state.cursorRingTrailRandom then
        if not tex.randomColor then
          tex.randomColor = { math.random(), math.random(), math.random() }
        end
        tex:SetVertexColor(tex.randomColor[1], tex.randomColor[2], tex.randomColor[3], alpha)
      else
        tex.randomColor = nil
        tex:SetVertexColor(color[1], color[2], color[3], alpha)
      end
      if alpha > 0 then
        tex:Show()
      else
        tex:Hide()
      end
    else
      tex:Hide()
    end
  end

  if #self.trailPositions == 0 and not moved then
    if self.trailFrame then
      self.trailFrame:Hide()
    end
  end
end

function CursorRing:EnsureFrame()
  if self.frame then
    return
  end

  local frame = CreateFrame("Frame", "ElysianCursorRing", UIParent)
  frame:SetFrameStrata("FULLSCREEN_DIALOG")
  frame:SetFrameLevel(9999)
  frame:SetSize(Elysian.state.cursorRingSize or 18, Elysian.state.cursorRingSize or 18)
  frame:SetAlpha(1)
  frame:EnableMouse(false)

  local texture = frame:CreateTexture(nil, "OVERLAY")
  texture:SetAllPoints()
  texture:SetDrawLayer("BACKGROUND")
  texture:SetBlendMode("ADD")
  self.texture = texture

  local cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
  cooldown:SetAllPoints()
  cooldown:SetDrawEdge(false)
  cooldown:SetDrawSwipe(true)
  cooldown:SetHideCountdownNumbers(true)
  cooldown:SetReverse(false)
  if cooldown.SetBlingTexture then
    cooldown:SetBlingTexture("", 0, 0, 0, 0)
  end
  if cooldown.SetSwipeTexture then
    cooldown:SetSwipeTexture(SHAPES.RING)
  end
  cooldown:SetFrameLevel(frame:GetFrameLevel() + 2)
  self.cooldown = cooldown

  frame:SetScript("OnUpdate", function(selfFrame, elapsed)
    local scale = UIParent:GetEffectiveScale()
    local x, y = GetCursorPosition()
    x = x / scale
    y = y / scale
    selfFrame:ClearAllPoints()
    selfFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)

    if CursorRing:IsVisibleNow() then
      CursorRing:UpdateTrail(elapsed, x, y)
    end
  end)

  self.frame = frame
  self:ApplyShape()
  self:ApplyColors()
  self:UpdateCastProgress()
  self:UpdateVisibility()
end

function CursorRing:Show()
  self:EnsureFrame()
  self:UpdateVisibility()
end

function CursorRing:Initialize()
  if self.eventFrame then
    return
  end

  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("PLAYER_REGEN_ENABLED")
  events:RegisterEvent("PLAYER_REGEN_DISABLED")
  events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  events:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
  events:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
  events:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
  events:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
  events:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")
  events:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "player")
  events:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
  events:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
  events:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" or event == "ZONE_CHANGED_NEW_AREA" then
      if CursorRing:IsEnabled() then
        CursorRing:EnsureFrame()
        CursorRing:ApplyShape()
        CursorRing:ApplyColors()
      end
      CursorRing:UpdateVisibility()
    else
      CursorRing:UpdateCastProgress()
    end
  end)

  self.eventFrame = events
end

local function CreateCheckbox(parent, label, x, y, width)
  local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  box:SetPoint("TOPLEFT", x, y)
  box.text = box.text or _G[box:GetName() .. "Text"]
  box.text:SetText(label)
  box.text:ClearAllPoints()
  box.text:SetPoint("LEFT", box, "RIGHT", 6, 0)
  box.text:SetWidth(width or 220)
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
  button:SetSize(140, 20)
  button:EnableMouse(true)
  button:RegisterForClicks("LeftButtonUp")
  if parent and parent.GetFrameStrata then
    button:SetFrameStrata(parent:GetFrameStrata())
  end
  if parent and parent.GetFrameLevel then
    button:SetFrameLevel(parent:GetFrameLevel() + 5)
  end
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
        Elysian.SaveState()
      end
    end

    if ColorPickerFrame then
      ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
      ColorPickerFrame:SetFrameLevel(2000)
      ColorPickerFrame:ClearAllPoints()
      ColorPickerFrame:SetPoint("CENTER")
    end

    if ColorPickerFrame and ColorPickerFrame.SetupColorPickerAndShow then
      ColorPickerFrame:SetupColorPickerAndShow({
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

    if ColorPickerFrame then
      ColorPickerFrame.hasOpacity = false
      ColorPickerFrame.previousValues = { color[1], color[2], color[3] }
      ColorPickerFrame.func = function()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        apply(r, g, b)
      end
      ColorPickerFrame.cancelFunc = function(prev)
        local pr = prev.r or prev[1] or color[1]
        local pg = prev.g or prev[2] or color[2]
        local pb = prev.b or prev[3] or color[3]
        apply(pr, pg, pb)
      end
      if ColorPickerFrame.SetColorRGB then
        ColorPickerFrame:SetColorRGB(color[1], color[2], color[3])
      elseif ColorPickerFrame.Content and ColorPickerFrame.Content.ColorPicker and ColorPickerFrame.Content.ColorPicker.SetColorRGB then
        ColorPickerFrame.Content.ColorPicker:SetColorRGB(color[1], color[2], color[3])
      end
      ColorPickerFrame:Show()
      ColorPickerFrame:Raise()
    end
  end)

  return button
end

local function CreateSlider(parent, label, x, y, min, max, step, getValue, setValue)
  local text = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  text:SetPoint("TOPLEFT", x, y)
  text:SetText(label)
  Elysian.ApplyFont(text, 11)
  Elysian.ApplyTextColor(text)

  local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -6)
  slider:SetWidth(180)
  slider:SetMinMaxValues(min, max)
  slider:SetValueStep(step)
  slider:SetObeyStepOnDrag(true)
  slider:SetValue(getValue())
  slider:SetScript("OnValueChanged", function(selfSlider, value)
    setValue(math.floor(value + 0.5))
  end)

  return slider
end

local function CreateFloatSlider(parent, label, x, y, min, max, step, getValue, setValue, formatter)
  local text = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  text:SetPoint("TOPLEFT", x, y)
  Elysian.ApplyFont(text, 11)
  Elysian.ApplyTextColor(text)

  local valueText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  valueText:SetPoint("LEFT", text, "RIGHT", 6, 0)
  Elysian.ApplyFont(valueText, 11)
  Elysian.ApplyAccentColor(valueText)

  local function UpdateLabel(value)
    local display = value
    if formatter then
      display = formatter(value)
    end
    text:SetText(label)
    valueText:SetText(display)
  end

  local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -6)
  slider:SetWidth(180)
  slider:SetMinMaxValues(min, max)
  slider:SetValueStep(step)
  slider:SetObeyStepOnDrag(true)
  slider:SetValue(getValue())
  UpdateLabel(getValue())
  slider:SetScript("OnValueChanged", function(selfSlider, value)
    local rounded = tonumber(string.format("%.2f", value))
    setValue(rounded)
    UpdateLabel(rounded)
  end)

  return slider
end

function CursorRing:CreatePanel(parent)
  local rootPanel = CreateFrame("Frame", nil, parent)
  rootPanel:SetAllPoints()
  rootPanel:SetClipsChildren(true)

  local scrollFrame = CreateFrame("ScrollFrame", nil, rootPanel)
  scrollFrame:SetPoint("TOPLEFT", 4, -4)
  scrollFrame:SetPoint("BOTTOMRIGHT", -4, 4)
  scrollFrame:SetClipsChildren(true)
  scrollFrame:EnableMouseWheel(true)

  local panel = CreateFrame("Frame", nil, scrollFrame)
  panel:SetPoint("TOPLEFT", 0, 0)
  panel:SetPoint("TOPRIGHT", 0, 0)
  panel:SetHeight(1200)
  scrollFrame:SetScrollChild(panel)

  local customBar = CreateFrame("Frame", nil, scrollFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
  customBar:SetPoint("TOPRIGHT", -2, -2)
  customBar:SetPoint("BOTTOMRIGHT", -2, 2)
  customBar:SetWidth(10)
  Elysian.SetBackdrop(customBar)
  Elysian.SetBackdropColors(customBar, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local thumb = customBar:CreateTexture(nil, "OVERLAY")
  thumb:SetTexture("Interface/Buttons/WHITE8x8")
  local accent = { Elysian.HexToRGB(Elysian.theme.accent) }
  thumb:SetVertexColor(accent[1], accent[2], accent[3], 1)
  thumb:SetPoint("TOPLEFT", 1, -1)
  thumb:SetPoint("TOPRIGHT", -1, -1)
  thumb:SetHeight(12)
  customBar.thumb = thumb

  local function Clamp(value, minValue, maxValue)
    if value < minValue then
      return minValue
    end
    if value > maxValue then
      return maxValue
    end
    return value
  end

  local function UpdateThumbPosition(value)
    local max = scrollFrame:GetVerticalScrollRange() or 0
    if max <= 0 then
      return
    end
    local available = (customBar:GetHeight() or 1) - (customBar.thumb:GetHeight() or 1) - 2
    if available < 0 then
      available = 0
    end
    local ratio = value / max
    local offset = -ratio * available
    offset = Clamp(offset, -available, 0)
    customBar.thumb:ClearAllPoints()
    customBar.thumb:SetPoint("TOPLEFT", 1, -1 + offset)
    customBar.thumb:SetPoint("TOPRIGHT", -1, -1 + offset)
  end

  local function SyncScrollSize()
    local width = scrollFrame:GetWidth() or 0
    if width <= 0 then
      width = (rootPanel.GetWidth and rootPanel:GetWidth()) or 1
    end
    panel:SetWidth(width)
    scrollFrame:UpdateScrollChildRect()
    local max = scrollFrame:GetVerticalScrollRange() or 0
    if max <= 0 then
      customBar:Hide()
    else
      customBar:Show()
      local view = scrollFrame:GetHeight() or 1
      local ratio = view / (view + max)
      local minHeight = 12
      local barHeight = (customBar:GetHeight() or 1) * ratio * 0.125
      if barHeight < minHeight then
        barHeight = minHeight
      end
      local maxHeight = (customBar:GetHeight() or 1) - 2
      if barHeight > maxHeight then
        barHeight = maxHeight
      end
      customBar.thumb:SetHeight(barHeight)
    end
  end

  scrollFrame:SetScript("OnSizeChanged", function()
    SyncScrollSize()
  end)
  scrollFrame:SetScript("OnShow", function()
    SyncScrollSize()
  end)

  scrollFrame:SetScript("OnMouseWheel", function(_, delta)
    local step = 30
    local value = scrollFrame:GetVerticalScroll() or 0
    local max = scrollFrame:GetVerticalScrollRange() or 0
    local nextValue = Clamp(value - delta * step, 0, max)
    scrollFrame:SetVerticalScroll(nextValue)
    UpdateThumbPosition(nextValue)
  end)

  scrollFrame:SetScript("OnVerticalScroll", function(_, value)
    UpdateThumbPosition(value)
  end)

  local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 8, -8)
  title:SetText("Cursor Ring")
  Elysian.ApplyFont(title, 13, "OUTLINE")
  Elysian.ApplyTextColor(title)

  local leftX = 16
  local rightX = 330
  local leftStartY = -50
  local rowGap = 24
  local toggle = CreateCheckbox(panel, "Enable cursor ring", leftX, leftStartY)
  toggle:SetChecked(self:IsEnabled())
  toggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    CursorRing:SetEnabled(selfButton:GetChecked())
  end)

  local classColor = CreateCheckbox(panel, "Use class color", leftX, leftStartY - rowGap)
  classColor:SetChecked(Elysian.state.cursorRingClassColor)
  classColor:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingClassColor = selfButton:GetChecked()
    CursorRing:ApplyColors()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  local ringColorButton = CreateColorButton(
    panel,
    "Ring Color",
    rightX,
    leftStartY,
    function()
      return Elysian.state.cursorRingColor or { Elysian.HexToRGB(Elysian.theme.accent) }
    end,
    function(color)
      CursorRing:SetColor(color)
    end
  )

  local castColorButton = CreateColorButton(
    panel,
    "Cast Color",
    rightX,
    leftStartY - 34,
    function()
      return Elysian.state.cursorRingCastColor or { Elysian.HexToRGB(Elysian.theme.accent) }
    end,
    function(color)
      CursorRing:SetCastColor(color)
    end
  )

  local castToggle = CreateCheckbox(panel, "Cast/channel progress", leftX, leftStartY - (rowGap * 2), 260)
  castToggle:SetChecked(Elysian.state.cursorRingCastProgress)
  castToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingCastProgress = selfButton:GetChecked()
    CursorRing:UpdateCastProgress()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  -- cast color button removed (use ring color + cast progress)
  local shapeLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  shapeLabel:SetPoint("TOPLEFT", rightX, leftStartY + 50)
  shapeLabel:SetText("Shape")
  Elysian.ApplyFont(shapeLabel, 11)
  Elysian.ApplyTextColor(shapeLabel)

  local shapeDropButton = CreateFrame("Button", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
  shapeDropButton:SetPoint("TOPLEFT", rightX, leftStartY + 26)
  shapeDropButton:SetSize(140, 22)
  Elysian.SetBackdrop(shapeDropButton)
  Elysian.SetBackdropColors(shapeDropButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local shapeText = shapeDropButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  shapeText:SetPoint("CENTER")
  shapeText:SetText(Elysian.state.cursorRingShape or "RING")
  Elysian.ApplyFont(shapeText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(shapeText)

  local shapeDrop = CreateFrame("Frame", "ElysianCursorRingShapeDropDown", panel, "UIDropDownMenuTemplate")
  UIDropDownMenu_SetWidth(shapeDrop, 140)

  local function SetShape(value)
    Elysian.state.cursorRingShape = value
    CursorRing:ApplyShape()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    UIDropDownMenu_SetText(shapeDrop, value)
    shapeText:SetText(value)
  end

  UIDropDownMenu_Initialize(shapeDrop, function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.func = function(item)
      SetShape(item.value)
    end
    info.text, info.value = "RING", "RING"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "THIN", "THIN"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "STAR", "STAR"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "SQUARE", "SQUARE"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "CROSSHAIR", "CROSSHAIR"
    UIDropDownMenu_AddButton(info)
  end)

  UIDropDownMenu_SetText(shapeDrop, Elysian.state.cursorRingShape or "RING")
  if Elysian.UI and Elysian.UI.SkinDropDown then
    Elysian.UI.SkinDropDown(shapeDrop)
  end

  shapeDropButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    ToggleDropDownMenu(1, nil, shapeDrop, shapeDropButton, 0, 0)
  end)

  CreateSlider(
    panel,
    "Ring size",
    rightX,
    leftStartY - 40,
    8,
    64,
    1,
    function()
      return Elysian.state.cursorRingSize or 18
    end,
    function(value)
      CursorRing:SetSize(value)
    end
  )

  local trailShapeLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  trailShapeLabel:SetPoint("TOPLEFT", rightX, leftStartY - 90)
  trailShapeLabel:SetText("Trail Shape")
  Elysian.ApplyFont(trailShapeLabel, 11)
  Elysian.ApplyTextColor(trailShapeLabel)

  local trailShapeButton = CreateFrame("Button", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
  trailShapeButton:SetPoint("TOPLEFT", rightX, leftStartY - 114)
  trailShapeButton:SetSize(140, 22)
  Elysian.SetBackdrop(trailShapeButton)
  Elysian.SetBackdropColors(trailShapeButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local trailShapeText = trailShapeButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  trailShapeText:SetPoint("CENTER")
  trailShapeText:SetText(Elysian.state.cursorRingTrailShape or "SPARK")
  Elysian.ApplyFont(trailShapeText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(trailShapeText)

  local trailShapeDrop = CreateFrame("Frame", "ElysianCursorRingTrailShapeDropDown", panel, "UIDropDownMenuTemplate")
  UIDropDownMenu_SetWidth(trailShapeDrop, 140)

  local function SetTrailShape(value)
    CursorRing:SetTrailShape(value)
    UIDropDownMenu_SetText(trailShapeDrop, value)
    trailShapeText:SetText(value)
  end

  UIDropDownMenu_Initialize(trailShapeDrop, function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.func = function(item)
      SetTrailShape(item.value)
    end
    info.text, info.value = "SPARK", "SPARK"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "RING", "RING"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "THIN", "THIN"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "STAR", "STAR"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "SQUARE", "SQUARE"
    UIDropDownMenu_AddButton(info)
    info.text, info.value = "CROSSHAIR", "CROSSHAIR"
    UIDropDownMenu_AddButton(info)
  end)

  UIDropDownMenu_SetText(trailShapeDrop, Elysian.state.cursorRingTrailShape or "SPARK")
  if Elysian.UI and Elysian.UI.SkinDropDown then
    Elysian.UI.SkinDropDown(trailShapeDrop)
  end

  trailShapeButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    ToggleDropDownMenu(1, nil, trailShapeDrop, trailShapeButton, 0, 0)
  end)

  local showCombat = CreateCheckbox(panel, "Show in combat", leftX, -132)
  showCombat:SetChecked(Elysian.state.cursorRingShowInCombat)
  showCombat:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingShowInCombat = selfButton:GetChecked()
    CursorRing:UpdateVisibility()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  local showOutCombat = CreateCheckbox(panel, "Show out of combat", leftX, -156)
  showOutCombat:SetChecked(Elysian.state.cursorRingShowOutCombat)
  showOutCombat:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingShowOutCombat = selfButton:GetChecked()
    CursorRing:UpdateVisibility()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  local showInstances = CreateCheckbox(panel, "Show in instances", leftX, -232)
  showInstances:SetChecked(Elysian.state.cursorRingShowInInstances)
  showInstances:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingShowInInstances = selfButton:GetChecked()
    CursorRing:UpdateVisibility()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  local showWorld = CreateCheckbox(panel, "Show in world", leftX, -256)
  showWorld:SetChecked(Elysian.state.cursorRingShowInWorld)
  showWorld:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingShowInWorld = selfButton:GetChecked()
    CursorRing:UpdateVisibility()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  local trailToggle = CreateCheckbox(panel, "Mouse trail", leftX, -180)
  trailToggle:SetChecked(Elysian.state.cursorRingTrailEnabled)
  trailToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingTrailEnabled = selfButton:GetChecked()
    CursorRing:UpdateTrail(0, 0, 0)
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  CreateSlider(
    panel,
    "Trail length",
    rightX,
    leftStartY - 160,
    4,
    30,
    1,
    function()
      return Elysian.state.cursorRingTrailLength or 12
    end,
    function(value)
      Elysian.state.cursorRingTrailLength = value
      CursorRing.trailTextures = nil
      CursorRing.trailPositions = nil
      CursorRing:EnsureTrail()
      CursorRing:ApplyColors()
      if Elysian.SaveState then
        Elysian.SaveState()
      end
    end
  )

  CreateFloatSlider(
    panel,
    "Trail fade",
    rightX,
    leftStartY - 226,
    0,
    1,
    0.05,
    function()
      return Elysian.state.cursorRingTrailFadeTime or 0.25
    end,
    function(value)
      Elysian.state.cursorRingTrailFadeTime = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
    end,
    function(value)
      return string.format("%.2fs", value)
    end
  )

  local trailColorButton = CreateColorButton(
    panel,
    "Trail Color",
    rightX,
    leftStartY - 300,
    function()
      return Elysian.state.cursorRingTrailColor or { Elysian.HexToRGB(Elysian.theme.accent) }
    end,
    function(color)
      CursorRing:SetTrailColor(color)
    end
  )

  local randomTrail = CreateCheckbox(panel, "Randomize trail colors", leftX, -204)
  randomTrail:SetChecked(Elysian.state.cursorRingTrailRandom)
  randomTrail:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.cursorRingTrailRandom = selfButton:GetChecked()
    if CursorRing.trailTextures then
      for _, tex in ipairs(CursorRing.trailTextures) do
        tex.randomColor = nil
      end
    end
    CursorRing:ApplyColors()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)

  self.toggle = toggle
  self.classColor = classColor
  self.castToggle = castToggle
  self.trailToggle = trailToggle
  self.randomTrail = randomTrail
  self.showCombat = showCombat
  self.showOutCombat = showOutCombat
  self.showInstances = showInstances
  self.showWorld = showWorld

  rootPanel:Hide()
  return rootPanel
end

function CursorRing:Refresh()
  if self.toggle then
    self.toggle:SetChecked(self:IsEnabled())
  end
  if self.classColor then
    self.classColor:SetChecked(Elysian.state.cursorRingClassColor)
  end
  if self.castToggle then
    self.castToggle:SetChecked(Elysian.state.cursorRingCastProgress)
  end
  if self.trailToggle then
    self.trailToggle:SetChecked(Elysian.state.cursorRingTrailEnabled)
  end
  if self.randomTrail then
    self.randomTrail:SetChecked(Elysian.state.cursorRingTrailRandom)
  end
  if self.showCombat then
    self.showCombat:SetChecked(Elysian.state.cursorRingShowInCombat)
  end
  if self.showOutCombat then
    self.showOutCombat:SetChecked(Elysian.state.cursorRingShowOutCombat)
  end
  if self.showInstances then
    self.showInstances:SetChecked(Elysian.state.cursorRingShowInInstances)
  end
  if self.showWorld then
    self.showWorld:SetChecked(Elysian.state.cursorRingShowInWorld)
  end
end

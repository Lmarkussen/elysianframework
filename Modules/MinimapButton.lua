local _, Elysian = ...

Elysian.MinimapButton = Elysian.MinimapButton or {}

local minimapShapes = {
  ROUND = { true, true, true, true },
  SQUARE = { false, false, false, false },
  ["CORNER-TOPLEFT"] = { false, false, false, true },
  ["CORNER-TOPRIGHT"] = { false, false, true, false },
  ["CORNER-BOTTOMLEFT"] = { false, true, false, false },
  ["CORNER-BOTTOMRIGHT"] = { true, false, false, false },
  ["SIDE-LEFT"] = { false, true, false, true },
  ["SIDE-RIGHT"] = { true, false, true, false },
  ["SIDE-TOP"] = { false, false, true, true },
  ["SIDE-BOTTOM"] = { true, true, false, false },
  ["TRICORNER-TOPLEFT"] = { false, true, true, true },
  ["TRICORNER-TOPRIGHT"] = { true, false, true, true },
  ["TRICORNER-BOTTOMLEFT"] = { true, true, false, true },
  ["TRICORNER-BOTTOMRIGHT"] = { true, true, true, false },
}

local function GetMinimapShapeSafe()
  if Minimap and Minimap.GetShape then
    return Minimap:GetShape()
  end
  if _G.GetMinimapShape then
    return _G.GetMinimapShape()
  end
  return "ROUND"
end

local function PositionButton(button, angle, minimap)
  if not minimap then
    return
  end
  local radians = math.rad(angle or 225)
  local x, y = math.cos(radians), math.sin(radians)
  local quadrant = 1
  if x < 0 then
    quadrant = quadrant + 1
  end
  if y > 0 then
    quadrant = quadrant + 2
  end
  local shape = GetMinimapShapeSafe()
  local quad = minimapShapes[shape] or minimapShapes.ROUND
  local w = (minimap:GetWidth() / 2)
  local h = (minimap:GetHeight() / 2)
  if quad[quadrant] then
    x, y = x * w, y * h
  else
    local diagW = math.sqrt(2 * (w ^ 2)) - 10
    local diagH = math.sqrt(2 * (h ^ 2)) - 10
    x = math.max(-w, math.min(x * diagW, w))
    y = math.max(-h, math.min(y * diagH, h))
  end
  button:SetPoint("CENTER", minimap, "CENTER", x, y)
end

function Elysian.MinimapButton:Create()
  if self.button then
    self:ApplyVisibility()
    return self.button
  end
  local minimap = Minimap or (MinimapCluster and MinimapCluster.Minimap) or nil
  local parent = minimap or MinimapCluster or UIParent
  if not parent then
    return nil
  end

  local button = CreateFrame("Button", "ElysianMinimapButton", parent)
  button:SetSize(31, 31)
  button:SetFrameStrata("HIGH")
  if minimap and minimap.GetFrameLevel then
    button:SetFrameLevel(minimap:GetFrameLevel() + 10)
  end
  button:SetMovable(true)
  button:EnableMouse(true)
  button:RegisterForDrag("LeftButton")
  button:SetClampedToScreen(true)
  button:SetToplevel(true)
  button:SetScale(1)
  button:SetAlpha(1)

  local overlay = button:CreateTexture(nil, "OVERLAY")
  overlay:SetSize(50, 50)
  overlay:SetTexture(136430) -- MiniMap-TrackingBorder
  overlay:SetPoint("TOPLEFT", button, "TOPLEFT")
  button.border = overlay

  local background = button:CreateTexture(nil, "BACKGROUND")
  background:SetSize(24, 24)
  background:SetTexture(136467) -- UI-Minimap-Background
  background:SetPoint("CENTER", button, "CENTER")
  button.bg = background

  local icon = button:CreateTexture(nil, "ARTWORK")
  icon:SetSize(18, 18)
  icon:SetTexture("Interface\\AddOns\\ElysianFramework\\Assets\\eframe.png")
  icon:SetPoint("CENTER", button, "CENTER")
  icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  button.icon = icon

  button:SetScript("OnClick", function()
    if Elysian.UI then
      Elysian.UI:Toggle()
    end
  end)

  button:SetScript("OnDragStart", function(selfButton)
    selfButton.isDragging = true
    selfButton:SetScript("OnUpdate", function(selfUpdate)
      if not minimap or not minimap.GetCenter then
        return
      end
      local mx, my = minimap:GetCenter()
      local px, py = GetCursorPosition()
      local scale = minimap:GetEffectiveScale()
      px, py = px / scale, py / scale
      local angle = math.deg(math.atan2(py - my, px - mx)) % 360
      Elysian.state.minimapButtonAngle = angle
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      PositionButton(selfUpdate, angle, minimap)
    end)
  end)

  button:SetScript("OnDragStop", function(selfButton)
    selfButton.isDragging = false
    selfButton:SetScript("OnUpdate", nil)
  end)

  if minimap then
    local angle = Elysian.state.minimapButtonAngle or 225
    PositionButton(button, angle, minimap)
  else
    button:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -120, -120)
  end

  self.button = button
  self:ApplyVisibility()
  return button
end

function Elysian.MinimapButton:ApplyVisibility()
  if not self.button then
    return
  end
  if Elysian.state and Elysian.state.minimapButtonHidden then
    self.button:Hide()
  else
    self.button:Show()
  end
end

function Elysian.MinimapButton:SetHidden(hidden)
  Elysian.state.minimapButtonHidden = hidden and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  self:ApplyVisibility()
end

local _, Elysian = ...

Elysian.MinimapButton = Elysian.MinimapButton or {}

local function ClampAngle(angle)
  if angle < 0 then
    angle = angle + 360
  end
  if angle > 360 then
    angle = angle - 360
  end
  return angle
end

local function PositionButton(button, angle, minimap)
  if not minimap then
    return
  end
  local radius = (minimap:GetWidth() / 2) + 2
  local radians = math.rad(angle)
  local x = math.cos(radians) * radius
  local y = math.sin(radians) * radius
  button:SetPoint("CENTER", minimap, "CENTER", x, y)
end

function Elysian.MinimapButton:Create()
  if self.button then
    return self.button
  end
  local minimap = Minimap or (MinimapCluster and MinimapCluster.Minimap) or nil
  local parent = minimap or MinimapCluster or UIParent
  if not parent then
    return nil
  end

  local button = CreateFrame("Button", "ElysianMinimapButton", parent)
  button:SetSize(32, 32)
  button:SetFrameStrata("HIGH")
  if minimap and minimap.GetFrameLevel then
    button:SetFrameLevel(minimap:GetFrameLevel() + 10)
  end
  button:SetMovable(true)
  button:EnableMouse(true)
  button:RegisterForDrag("LeftButton")
  button:SetClampedToScreen(true)
  button:SetToplevel(true)
  button:SetScale(0.95)
  button:SetAlpha(1)

  local icon = button:CreateTexture(nil, "BACKGROUND")
  icon:SetAllPoints()
  icon:SetTexture("Interface\\AddOns\\ElysianFramework\\Assets\\eframe.png")
  icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  button.icon = icon

  local border = button:CreateTexture(nil, "BORDER")
  border:SetTexture("Interface\\Minimap\\UI-Minimap-Border")
  border:SetAllPoints()
  button.border = border

  button:SetScript("OnClick", function()
    if Elysian.UI then
      Elysian.UI:Toggle()
    end
  end)

  button:SetScript("OnDragStart", function()
    button.isDragging = true
  end)

  button:SetScript("OnDragStop", function()
    button.isDragging = false
  end)

  button:SetScript("OnUpdate", function(selfButton)
    if not selfButton.isDragging then
      return
    end

    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    x = x / scale
    y = y / scale

    if not minimap or not minimap.GetCenter then
      return
    end
    local mx, my = minimap:GetCenter()
    local angle = math.deg(math.atan2(y - my, x - mx))
    angle = ClampAngle(angle)

    Elysian.state.minimapButtonAngle = angle
    if Elysian.SaveState then
      Elysian.SaveState()
    end

    PositionButton(selfButton, angle, minimap)
  end)

  if minimap then
    local angle = Elysian.state.minimapButtonAngle or 225
    PositionButton(button, angle, minimap)
  else
    button:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -120, -120)
  end

  self.button = button
  button:Show()
  return button
end

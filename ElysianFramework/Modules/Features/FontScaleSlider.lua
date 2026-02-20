local _, Elysian = ...

Elysian.UI = Elysian.UI or {}

function Elysian.UI.CreateFontScaleSlider(parent, startScale, onChange)
  local slider = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  slider:SetSize(220, 18)
  Elysian.SetBackdrop(slider)
  Elysian.SetBackdropColors(slider, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.6)

  local bar = slider:CreateTexture(nil, "BACKGROUND")
  bar:SetPoint("LEFT", 2, 0)
  bar:SetPoint("RIGHT", -2, 0)
  bar:SetHeight(6)
  bar:SetColorTexture(1, 1, 1, 0.15)

  local thumb = slider:CreateTexture(nil, "OVERLAY")
  thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
  thumb:SetSize(24, 24)
  thumb:SetPoint("CENTER", slider, "LEFT", 0, 0)

  local min, max = 0.8, 1.4
  local value = startScale or 1.1

  local function clamp(v)
    if v < min then
      return min
    end
    if v > max then
      return max
    end
    return v
  end

  local function updateThumb(v)
    v = clamp(v)
    local pct = (v - min) / (max - min)
    local width = slider:GetWidth() - 4
    local x = 2 + (width * pct)
    thumb:SetPoint("CENTER", slider, "LEFT", x, 0)
  end

  local function setValueFromCursor()
    if not slider:IsShown() then
      slider.dragging = false
      return
    end
    local scale = UIParent:GetEffectiveScale()
    local x = (GetCursorPosition() or 0) / scale
    local left = slider:GetLeft() or 0
    if left == 0 and not slider:GetRight() then
      return
    end
    local width = slider:GetWidth() - 4
    local pct = (x - (left + 2)) / width
    pct = math.min(1, math.max(0, pct))
    local v = min + (max - min) * pct
    v = math.floor(v * 100 + 0.5) / 100
    updateThumb(v)
    if onChange then
      onChange(v)
    end
  end

  slider:EnableMouse(true)
  slider:RegisterForDrag("LeftButton")
  slider:SetScript("OnMouseDown", function(_, button)
    if button == "LeftButton" then
      slider.dragging = true
      setValueFromCursor()
    end
  end)
  slider:SetScript("OnMouseUp", function()
    slider.dragging = false
  end)
  slider:SetScript("OnUpdate", function()
    if slider.dragging and not IsMouseButtonDown("LeftButton") then
      slider.dragging = false
      return
    end
    if slider.dragging then
      setValueFromCursor()
    end
  end)

  slider:SetScript("OnHide", function()
    slider.dragging = false
  end)

  slider:SetScript("OnMouseUp", function()
    slider.dragging = false
  end)

  updateThumb(value)

  return slider
end

local _, Elysian = ...

Elysian.UI = Elysian.UI or {}
Elysian.UI.SkinDropDown = nil

local function CreateTabButton(parent, label, width, height)
  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local button = CreateFrame("Button", nil, parent, template)
  button:SetSize(width or 90, height or 20)
  Elysian.SetBackdrop(button)

  local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  text:SetPoint("CENTER")
  text:SetText(label)
  Elysian.ApplyFont(text, 11, "OUTLINE")
  Elysian.ApplyTextColor(text)
  button.text = text
  return button
end

local function HookButtonPressFeedback(button)
  if not button or not button.SetBackdropColor then
    return
  end
  local function SetActive(active)
    local bg = active and Elysian.GetNavBg() or Elysian.GetNavBg()
    local shade = active and 1.18 or 1
    local r, g, b = bg[1], bg[2], bg[3]
    button:SetBackdropColor(r * shade, g * shade, b * shade, 0.95)
  end
  button:HookScript("OnMouseDown", function() SetActive(true) end)
  button:HookScript("OnMouseUp", function() SetActive(false) end)
  button:HookScript("OnHide", function() SetActive(false) end)
end

Elysian.UI.HookButtonPressFeedback = HookButtonPressFeedback

local function SkinDropDown(dropdown)
  if not dropdown then
    return
  end
  local bg = Elysian.GetNavBg()
  local border = Elysian.GetThemeBorder()

  if dropdown.SetBackdrop then
    Elysian.SetBackdrop(dropdown)
    Elysian.SetBackdropColors(dropdown, bg, border, 0.9)
  end

  if not dropdown.efFrame then
    local frame = CreateFrame("Frame", nil, dropdown, BackdropTemplateMixin and "BackdropTemplate" or nil)
    frame:SetPoint("TOPLEFT", 6, -4)
    frame:SetPoint("BOTTOMRIGHT", -6, 4)
    Elysian.SetBackdrop(frame)
    Elysian.SetBackdropColors(frame, bg, border, 0.95)
    frame:EnableMouse(false)
    frame:SetFrameStrata(dropdown:GetFrameStrata() or "MEDIUM")
    local level = (dropdown.GetFrameLevel and dropdown:GetFrameLevel() or 1) - 1
    if level < 0 then
      level = 0
    end
    frame:SetFrameLevel(level)
    dropdown.efFrame = frame
  else
    Elysian.SetBackdropColors(dropdown.efFrame, bg, border, 0.95)
  end

  local name = dropdown.GetName and dropdown:GetName() or nil
  if name then
    local left = _G[name .. "Left"]
    local middle = _G[name .. "Middle"]
    local right = _G[name .. "Right"]
    local button = _G[name .. "Button"]
    if left then left:Hide() end
    if middle then middle:Hide() end
    if right then right:Hide() end
    if left then
      left:SetTexture("")
      left:SetAlpha(0)
      left.Show = function() end
    end
    if middle then
      middle:SetTexture("")
      middle:SetAlpha(0)
      middle.Show = function() end
    end
    if right then
      right:SetTexture("")
      right:SetAlpha(0)
      right.Show = function() end
    end
    if button then
      button:ClearAllPoints()
      button:SetPoint("RIGHT", -2, 0)
      button:SetSize(20, 20)
      if button.SetNormalTexture then
        button:SetNormalTexture("")
      end
      if button.SetPushedTexture then
        button:SetPushedTexture("")
      end
      if button.SetDisabledTexture then
        button:SetDisabledTexture("")
      end
      if button.SetHighlightTexture then
        button:SetHighlightTexture("")
      end
    end
    local normal = _G[name .. "ButtonNormalTexture"]
    local pushed = _G[name .. "ButtonPressedTexture"]
    local disabled = _G[name .. "ButtonDisabledTexture"]
    local highlight = _G[name .. "ButtonHighlightTexture"]
    if normal then normal:Hide() end
    if pushed then pushed:Hide() end
    if disabled then disabled:Hide() end
    if highlight then highlight:Hide() end
    if normal then
      normal:SetTexture("")
      normal:SetAlpha(0)
      normal.Show = function() end
    end
    if pushed then
      pushed:SetTexture("")
      pushed:SetAlpha(0)
      pushed.Show = function() end
    end
    if disabled then
      disabled:SetTexture("")
      disabled:SetAlpha(0)
      disabled.Show = function() end
    end
    if highlight then
      highlight:SetTexture("")
      highlight:SetAlpha(0)
      highlight.Show = function() end
    end
  end

  if not dropdown.efArrow then
    local arrow = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    arrow:SetPoint("RIGHT", -8, 0)
    arrow:SetText("▼")
    Elysian.ApplyFont(arrow, 10, "OUTLINE")
    Elysian.ApplyAccentColor(arrow)
    dropdown.efArrow = arrow
  else
    Elysian.ApplyAccentColor(dropdown.efArrow)
  end

  if dropdown.Text then
    Elysian.ApplyFont(dropdown.Text, 11, "OUTLINE")
    Elysian.ApplyAccentColor(dropdown.Text)
  elseif dropdown.GetName and name and _G[name .. "Text"] then
    local text = _G[name .. "Text"]
    Elysian.ApplyFont(text, 11, "OUTLINE")
    Elysian.ApplyAccentColor(text)
  end

  local function SkinList(listFrame)
    if not listFrame then
      return
    end
    if listFrame.Backdrop then
      Elysian.SetBackdropColors(listFrame.Backdrop, bg, border, 0.95)
    end
    if listFrame.MenuBackdrop then
      Elysian.SetBackdropColors(listFrame.MenuBackdrop, bg, border, 0.95)
    end
  end

  SkinList(_G.DropDownList1)
  SkinList(_G.DropDownList2)
end

Elysian.UI.SkinDropDown = SkinDropDown

local function StyleTopTab(button, selected)
  local border = Elysian.GetThemeBorder()
  local bg = Elysian.GetNavBg()
  local accent = { Elysian.HexToRGB(Elysian.theme.accent) }

  if selected then
    Elysian.SetBackdropColors(button, bg, accent, 0.98)
    Elysian.ApplyAccentColor(button.text)
  else
    Elysian.SetBackdropColors(button, bg, border, 0.92)
    Elysian.ApplyTextColor(button.text)
  end
end

local function StyleSubTab(button, selected)
  local border = Elysian.GetThemeBorder()
  local bg = Elysian.GetNavBg()
  local accent = { Elysian.HexToRGB(Elysian.theme.accent) }

  if selected then
    Elysian.SetBackdropColors(button, bg, accent, 0.98)
    Elysian.ApplyAccentColor(button.text)
  else
    Elysian.SetBackdropColors(button, bg, border, 0.88)
    Elysian.ApplyTextColor(button.text)
  end
end

  local function ShowPanel(activePanel, panels)
    for _, panel in ipairs(panels) do
      if panel == activePanel then
        panel:Show()
      else
        panel:Hide()
      end
    end
  end

function Elysian.UI:CreateMainFrame()
  if self.mainFrame then
    return self.mainFrame
  end

  local template = BackdropTemplateMixin and "BackdropTemplate" or nil
  local frame = CreateFrame("Frame", "ElysianFrameworkMainFrame", UIParent, template)
  frame:SetSize(860, 690)
  if self.mainFrame then
    frame:SetPoint("CENTER", self.mainFrame, "CENTER", 0, 0)
  else
    frame:SetPoint("CENTER")
  end
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  Elysian.SetBackdrop(frame)
  Elysian.SetBackdropColors(frame, { Elysian.HexToRGB(Elysian.theme.bg) }, Elysian.GetThemeBorder(), 0.95)

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOP", 0, -10)
  title:SetText("Elysian Framework")
  Elysian.ApplyFont(title, 14, "OUTLINE")
  local titleR, titleG, titleB = Elysian.HexToRGB("#ffb86c")
  title:SetTextColor(titleR, titleG, titleB)

  local closeButton = CreateFrame("Button", nil, frame, template)
  closeButton:SetPoint("TOPRIGHT", -8, -8)
  closeButton:SetSize(22, 22)
  Elysian.SetBackdrop(closeButton)
  Elysian.SetBackdropColors(closeButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)

  local closeText = closeButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  closeText:SetPoint("CENTER", 0, 0)
  closeText:SetText("×")
  Elysian.ApplyFont(closeText, 14, "OUTLINE")
  Elysian.ApplyAccentColor(closeText)

  closeButton:SetScript("OnClick", function()
    frame:Hide()
  end)
  HookButtonPressFeedback(closeButton)

  -- logo moved to General tab

  local header = CreateFrame("Frame", nil, frame, template)
  header:SetPoint("TOPLEFT", 10, -34)
  header:SetPoint("TOPRIGHT", -10, -34)
  header:SetHeight(34)
  Elysian.SetBackdrop(header)
  Elysian.SetBackdropColors(header, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.98)

  local topTabs = {}
  local generalTab = CreateTabButton(header, "GENERAL", 100, 22)
  generalTab:SetPoint("LEFT", 10, 0)
  local qolTab = CreateTabButton(header, "QOL TOOLS", 110, 22)
  qolTab:SetPoint("LEFT", generalTab, "RIGHT", 8, 0)
  local alertsTab = CreateTabButton(header, "ALERTS", 90, 22)
  alertsTab:SetPoint("LEFT", qolTab, "RIGHT", 8, 0)
  local classAlertsTab = CreateTabButton(header, "CLASS ALERTS", 120, 22)
  classAlertsTab:SetPoint("LEFT", alertsTab, "RIGHT", 8, 0)
  table.insert(topTabs, generalTab)
  table.insert(topTabs, qolTab)
  table.insert(topTabs, alertsTab)
  table.insert(topTabs, classAlertsTab)

  local subHeader = CreateFrame("Frame", nil, frame, template)
  subHeader:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -6)
  subHeader:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -6)
  subHeader:SetHeight(62)
  Elysian.SetBackdrop(subHeader)
  Elysian.SetBackdropColors(subHeader, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.96)
  local function SetSubHeaderBackground(visible)
    if visible then
      Elysian.SetBackdrop(subHeader)
      Elysian.SetBackdropColors(subHeader, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.96)
    else
      if subHeader.SetBackdropColor then
        subHeader:SetBackdropColor(0, 0, 0, 0)
      end
      if subHeader.SetBackdropBorderColor then
        subHeader:SetBackdropBorderColor(0, 0, 0, 0)
      end
    end
  end

  local content = CreateFrame("Frame", nil, frame, template)
  content:SetPoint("TOPLEFT", subHeader, "BOTTOMLEFT", 0, -8)
  content:SetPoint("BOTTOMRIGHT", -10, 10)
  Elysian.SetBackdrop(content)
  Elysian.SetBackdropColors(content, Elysian.GetContentBg(), Elysian.GetThemeBorder(), 0.96)

  local sectionTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  sectionTitle:SetPoint("TOPLEFT", 14, -12)
  sectionTitle:SetText("QOL TOOLS")
  Elysian.ApplyFont(sectionTitle, 12, "OUTLINE")
  Elysian.ApplyAccentColor(sectionTitle)

  local sectionLine = content:CreateTexture(nil, "BACKGROUND")
  sectionLine:SetPoint("LEFT", sectionTitle, "RIGHT", 12, 0)
  sectionLine:SetPoint("RIGHT", -28, 0)
  sectionLine:SetHeight(1)
  sectionLine:SetColorTexture(0.27, 0.28, 0.35, 1)

  local contentBody = CreateFrame("Frame", nil, content)
  contentBody:SetPoint("TOPLEFT", 0, -34)
  contentBody:SetPoint("BOTTOMRIGHT", 0, 0)

  local panels = {}
  local scrapPanel = Elysian.Features and Elysian.Features.ScrapSeller and Elysian.Features.ScrapSeller:CreatePanel(contentBody)
  if scrapPanel then
    scrapPanel:SetPoint("TOPLEFT", 12, -12)
    scrapPanel:SetPoint("TOPRIGHT", -12, -12)
    scrapPanel:SetHeight(880)
    table.insert(panels, scrapPanel)
  end

  local cursorPanel = Elysian.Features and Elysian.Features.CursorRing and Elysian.Features.CursorRing:CreatePanel(contentBody)
  if cursorPanel then
    cursorPanel:SetPoint("TOPLEFT", 12, -12)
    cursorPanel:SetPoint("TOPRIGHT", -12, -12)
    cursorPanel:SetHeight(880)
    table.insert(panels, cursorPanel)
  end

  local repairPanel = Elysian.Features and Elysian.Features.AutoRepair and Elysian.Features.AutoRepair:CreatePanel(contentBody)
  if repairPanel then
    repairPanel:SetPoint("TOPLEFT", 12, -12)
    repairPanel:SetPoint("TOPRIGHT", -12, -12)
    repairPanel:SetHeight(880)
    table.insert(panels, repairPanel)
  end

  local infoPanel = Elysian.Features and Elysian.Features.InfoBar and Elysian.Features.InfoBar:CreatePanel(contentBody)
  if infoPanel then
    infoPanel:SetPoint("TOPLEFT", 12, -12)
    infoPanel:SetPoint("TOPRIGHT", -12, -12)
    infoPanel:SetHeight(880)
    table.insert(panels, infoPanel)
  end

  local generalPanel = CreateFrame("Frame", nil, content)
  generalPanel:SetPoint("TOPLEFT", 12, -46)
  generalPanel:SetPoint("BOTTOMRIGHT", -12, 12)
  generalPanel:Hide()
  local generalTitle = generalPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  generalTitle:SetPoint("TOPLEFT", 64, -12)
  generalTitle:SetText("Settings")
  Elysian.ApplyFont(generalTitle, 13, "OUTLINE")
  Elysian.ApplyTextColor(generalTitle)
  local generalText = generalPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  generalText:SetPoint("TOPLEFT", generalTitle, "BOTTOMLEFT", 0, -6)
  generalText:SetText("")

  local logo = generalPanel:CreateTexture(nil, "OVERLAY")
  logo:SetTexture("Interface\\AddOns\\ElysianFramework\\Assets\\eframe.png")
  logo:SetSize(144, 144)
  logo:SetPoint("BOTTOMRIGHT", -60, 80)
  logo:SetTexCoord(0.1, 0.9, 0.1, 0.9)

  local signatureTitle = generalPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  signatureTitle:SetPoint("TOP", logo, "BOTTOM", 0, -4)
  signatureTitle:SetText("Elysian Framework")
  Elysian.ApplyFont(signatureTitle, 11, "OUTLINE")
  signatureTitle:SetTextColor(1, 1, 1)

  local signatureHandle = generalPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  signatureHandle:SetPoint("TOP", signatureTitle, "BOTTOM", 0, -2)
  signatureHandle:SetText("@EvilHaxxor")
  Elysian.ApplyFont(signatureHandle, 10)
  signatureHandle:SetTextColor(1, 1, 1)

  local versionText = generalPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  versionText:SetPoint("TOP", signatureHandle, "BOTTOM", 0, -2)
  versionText:SetText("v0.00.21 BETA")
  Elysian.ApplyFont(versionText, 10)
  versionText:SetTextColor(1, 1, 1)

  local reloadButton = CreateFrame("Button", nil, generalPanel, template)
  reloadButton:SetPoint("BOTTOMLEFT", 8, 44)
  reloadButton:SetSize(160, 22)
  Elysian.SetBackdrop(reloadButton)
  Elysian.SetBackdropColors(reloadButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local reloadText = reloadButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  reloadText:SetPoint("CENTER")
  reloadText:SetText("Reload UI")
  Elysian.ApplyFont(reloadText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(reloadText)

  reloadButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    ReloadUI()
  end)
  HookButtonPressFeedback(reloadButton)

  local resetButton = CreateFrame("Button", nil, generalPanel, template)
  resetButton:SetPoint("BOTTOMLEFT", 8, 16)
  resetButton:SetSize(160, 22)
  Elysian.SetBackdrop(resetButton)
  Elysian.SetBackdropColors(resetButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local resetText = resetButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  resetText:SetPoint("CENTER")
  resetText:SetText("Reset Settings")
  Elysian.ApplyFont(resetText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(resetText)

  resetButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.ResetSettings then
      Elysian.ResetSettings()
    end
    if Elysian.Features and Elysian.Features.CursorRing then
      Elysian.Features.CursorRing:SetEnabled(false)
      Elysian.Features.CursorRing:ApplyShape()
      Elysian.Features.CursorRing:ApplyColors()
      Elysian.Features.CursorRing:UpdateVisibility()
      if Elysian.Features.CursorRing.Refresh then
        Elysian.Features.CursorRing:Refresh()
      end
    end
    if Elysian.Features and Elysian.Features.ScrapSeller then
      Elysian.Features.ScrapSeller:SetEnabled(false)
      if Elysian.Features.ScrapSeller.Refresh then
        Elysian.Features.ScrapSeller:Refresh()
      end
    end
    if Elysian.Features and Elysian.Features.AutoRepair then
      Elysian.Features.AutoRepair:SetEnabled(false)
      if Elysian.Features.AutoRepair.Refresh then
        Elysian.Features.AutoRepair:Refresh()
      end
    end
    if Elysian.UI and Elysian.UI.mainFrame and Elysian.UI.mainFrame:IsShown() then
      if Elysian.UI.showOnStartCheck then
        Elysian.UI.showOnStartCheck:SetChecked(not Elysian.state.showOnStart)
      end
    end
  end)
  HookButtonPressFeedback(resetButton)

  local fontLabel = generalPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fontLabel:SetPoint("TOPLEFT", generalText, "BOTTOMLEFT", 0, -18)
  fontLabel:SetText("UI Font Size")
  Elysian.ApplyFont(fontLabel, 11)
  Elysian.ApplyTextColor(fontLabel)

  local function SetFontScale(scale)
    Elysian.state.uiFontScale = scale
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.UI and Elysian.UI.Rebuild then
      Elysian.UI:Rebuild()
      Elysian.UI:Show()
    end
  end

  local fontButtonDefault = CreateFrame("Button", nil, generalPanel, template)
  fontButtonDefault:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", 0, -10)
  fontButtonDefault:SetSize(110, 22)
  Elysian.SetBackdrop(fontButtonDefault)
  Elysian.SetBackdropColors(fontButtonDefault, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local fontButtonDefaultText = fontButtonDefault:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fontButtonDefaultText:SetPoint("CENTER")
  fontButtonDefaultText:SetText("Default")
  Elysian.ApplyFont(fontButtonDefaultText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(fontButtonDefaultText)

  fontButtonDefault:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    SetFontScale(1.1)
  end)
  HookButtonPressFeedback(fontButtonDefault)

  local fontButtonMedium = CreateFrame("Button", nil, generalPanel, template)
  fontButtonMedium:SetPoint("LEFT", fontButtonDefault, "RIGHT", 8, 0)
  fontButtonMedium:SetSize(110, 22)
  Elysian.SetBackdrop(fontButtonMedium)
  Elysian.SetBackdropColors(fontButtonMedium, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local fontButtonMediumText = fontButtonMedium:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fontButtonMediumText:SetPoint("CENTER")
  fontButtonMediumText:SetText("Medium")
  Elysian.ApplyFont(fontButtonMediumText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(fontButtonMediumText)

  fontButtonMedium:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    SetFontScale(1.2)
  end)
  HookButtonPressFeedback(fontButtonMedium)

  local fontButtonLarge = CreateFrame("Button", nil, generalPanel, template)
  fontButtonLarge:SetPoint("LEFT", fontButtonMedium, "RIGHT", 8, 0)
  fontButtonLarge:SetSize(110, 22)
  Elysian.SetBackdrop(fontButtonLarge)
  Elysian.SetBackdropColors(fontButtonLarge, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local fontButtonLargeText = fontButtonLarge:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fontButtonLargeText:SetPoint("CENTER")
  fontButtonLargeText:SetText("Large")
  Elysian.ApplyFont(fontButtonLargeText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(fontButtonLargeText)

  fontButtonLarge:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    SetFontScale(1.35)
  end)
  HookButtonPressFeedback(fontButtonLarge)

  local textColorToggle = CreateFrame("CheckButton", nil, generalPanel, "UICheckButtonTemplate")
  textColorToggle:SetPoint("TOPLEFT", fontButtonDefault, "BOTTOMLEFT", 0, -12)
  textColorToggle.text = textColorToggle.text or _G[textColorToggle:GetName() .. "Text"]
  textColorToggle.text:SetText("Use class color for text")
  Elysian.ApplyFont(textColorToggle.text, 12)
  Elysian.ApplyTextColor(textColorToggle.text)
  Elysian.StyleCheckbox(textColorToggle)
  textColorToggle:SetChecked(Elysian.state.uiTextUseClassColor)
  textColorToggle:SetScript("OnClick", function(selfButton)
    Elysian.state.uiTextUseClassColor = selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.UI and Elysian.UI.Rebuild then
      Elysian.UI:Rebuild()
      Elysian.UI:Show()
    end
  end)

  local textColorButton = CreateFrame("Button", nil, generalPanel, BackdropTemplateMixin and "BackdropTemplate" or nil)
  textColorButton:SetPoint("TOPLEFT", textColorToggle, "BOTTOMLEFT", 0, -10)
  textColorButton:SetSize(160, 22)
  Elysian.SetBackdrop(textColorButton)
  Elysian.SetBackdropColors(textColorButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local textColorLabel = textColorButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  textColorLabel:SetPoint("CENTER")
  textColorLabel:SetText("Text Color")
  Elysian.ApplyFont(textColorLabel, 11, "OUTLINE")
  Elysian.ApplyAccentColor(textColorLabel)

  local textSwatch = textColorButton:CreateTexture(nil, "OVERLAY")
  textSwatch:SetSize(12, 12)
  textSwatch:SetPoint("RIGHT", -8, 0)
  local initial = Elysian.state.uiTextColor or { Elysian.HexToRGB(Elysian.theme.fg) }
  textSwatch:SetColorTexture(initial[1], initial[2], initial[3], 1)

  textColorButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = Elysian.state.uiTextColor or { Elysian.HexToRGB(Elysian.theme.fg) }
    local function apply(r, g, b)
      Elysian.state.uiTextColor = { r, g, b }
      textSwatch:SetColorTexture(r, g, b, 1)
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.UI and Elysian.UI.Rebuild then
        Elysian.UI:Rebuild()
        Elysian.UI:Show()
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
  HookButtonPressFeedback(textColorButton)

  local profileLabel = generalPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  profileLabel:SetPoint("TOPLEFT", textColorButton, "BOTTOMLEFT", 0, -18)
  profileLabel:SetText("Profiles")
  Elysian.ApplyFont(profileLabel, 12, "OUTLINE")
  Elysian.ApplyAccentColor(profileLabel)

  local profileDrop = CreateFrame("Frame", "ElysianProfileDropDown", generalPanel, "UIDropDownMenuTemplate")
  profileDrop:SetPoint("TOPLEFT", profileLabel, "BOTTOMLEFT", -12, -6)
  UIDropDownMenu_SetWidth(profileDrop, 180)

  local selectedProfile = Elysian.GetActiveProfile and Elysian.GetActiveProfile() or "Default"

  local function RefreshProfileDropdown()
    local names = Elysian.GetProfileNames and Elysian.GetProfileNames() or { "Default" }
    selectedProfile = Elysian.GetActiveProfile and Elysian.GetActiveProfile() or selectedProfile or "Default"
    UIDropDownMenu_Initialize(profileDrop, function(self, level)
      local info = UIDropDownMenu_CreateInfo()
      info.func = function(selfButton)
        selectedProfile = selfButton.value
        UIDropDownMenu_SetText(profileDrop, string.upper(selectedProfile))
        UIDropDownMenu_SetSelectedValue(profileDrop, selectedProfile)
        if Elysian.LoadProfile then
          Elysian.LoadProfile(selectedProfile)
        end
      end
      for _, name in ipairs(names) do
        info.text = string.upper(name)
        info.value = name
        info.checked = (name == selectedProfile)
        UIDropDownMenu_AddButton(info, level)
      end
    end)
    UIDropDownMenu_SetText(profileDrop, string.upper(selectedProfile))
    UIDropDownMenu_SetSelectedValue(profileDrop, selectedProfile)
  end

  RefreshProfileDropdown()

  local saveProfileButton = CreateFrame("Button", nil, generalPanel, template)
  saveProfileButton:SetPoint("TOPLEFT", profileDrop, "BOTTOMLEFT", 12, -8)
  saveProfileButton:SetSize(90, 22)
  Elysian.SetBackdrop(saveProfileButton)
  Elysian.SetBackdropColors(saveProfileButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local saveText = saveProfileButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  saveText:SetPoint("CENTER")
  saveText:SetText("Save")
  Elysian.ApplyFont(saveText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(saveText)

  local profileNameBox = CreateFrame("EditBox", nil, generalPanel, BackdropTemplateMixin and "BackdropTemplate" or nil)
  profileNameBox:SetPoint("TOPLEFT", saveProfileButton, "BOTTOMLEFT", 0, -8)
  profileNameBox:SetSize(180, 22)
  profileNameBox:SetAutoFocus(false)
  Elysian.SetBackdrop(profileNameBox)
  Elysian.SetBackdropColors(profileNameBox, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  profileNameBox:SetTextInsets(6, 6, 2, 2)
  profileNameBox:SetText("")
  Elysian.ApplyFont(profileNameBox, 11, "OUTLINE")
  Elysian.ApplyTextColor(profileNameBox)
  profileNameBox:Hide()

  saveProfileButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local name = ""
    if profileNameBox:IsShown() then
      name = profileNameBox:GetText() or ""
      name = name:gsub("^%s+", ""):gsub("%s+$", "")
    end
    local target = name
    if target == "" then
      target = selectedProfile or (Elysian.GetActiveProfile and Elysian.GetActiveProfile()) or "Default"
    end
    if target ~= "" and Elysian.SaveProfile then
      Elysian.SaveProfile(target)
      selectedProfile = target
      RefreshProfileDropdown()
      profileNameBox:SetText("")
      profileNameBox:Hide()
    end
  end)
  HookButtonPressFeedback(saveProfileButton)

  local newProfileButton = CreateFrame("Button", nil, generalPanel, template)
  newProfileButton:SetPoint("LEFT", saveProfileButton, "RIGHT", 8, 0)
  newProfileButton:SetSize(90, 22)
  Elysian.SetBackdrop(newProfileButton)
  Elysian.SetBackdropColors(newProfileButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local newText = newProfileButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  newText:SetPoint("CENTER")
  newText:SetText("New")
  Elysian.ApplyFont(newText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(newText)

  newProfileButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if profileNameBox:IsShown() then
      saveProfileButton:Click()
    else
      profileNameBox:Show()
      profileNameBox:SetText("")
      profileNameBox:SetFocus()
    end
  end)
  HookButtonPressFeedback(newProfileButton)

  local deleteProfileButton = CreateFrame("Button", nil, generalPanel, template)
  deleteProfileButton:SetPoint("LEFT", newProfileButton, "RIGHT", 8, 0)
  deleteProfileButton:SetSize(90, 22)
  Elysian.SetBackdrop(deleteProfileButton)
  Elysian.SetBackdropColors(deleteProfileButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local deleteText = deleteProfileButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  deleteText:SetPoint("CENTER")
  deleteText:SetText("Delete")
  Elysian.ApplyFont(deleteText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(deleteText)

  deleteProfileButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if selectedProfile and Elysian.DeleteProfile then
      Elysian.DeleteProfile(selectedProfile)
      selectedProfile = Elysian.GetActiveProfile and Elysian.GetActiveProfile() or "Default"
      RefreshProfileDropdown()
    end
  end)
  HookButtonPressFeedback(deleteProfileButton)


  local generalQolToggle = CreateFrame("CheckButton", nil, generalPanel, "UICheckButtonTemplate")
  generalQolToggle:SetPoint("TOPLEFT", saveProfileButton, "BOTTOMLEFT", -12, -44)
  generalQolToggle.text = generalQolToggle.text or _G[generalQolToggle:GetName() .. "Text"]
  generalQolToggle.text:SetText("Toggle ON all QOL Features")
  Elysian.ApplyFont(generalQolToggle.text, 12)
  Elysian.ApplyTextColor(generalQolToggle.text)
  Elysian.StyleCheckbox(generalQolToggle)
  generalQolToggle:SetChecked(false)
  generalQolToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.UI and Elysian.UI.SetAllQolEnabled then
      Elysian.UI.SetAllQolEnabled(selfButton:GetChecked())
    end
  end)

  local minimapToggle = CreateFrame("CheckButton", nil, generalPanel, "UICheckButtonTemplate")
  minimapToggle:SetPoint("TOPLEFT", generalQolToggle, "BOTTOMLEFT", 0, -12)
  minimapToggle.text = minimapToggle.text or _G[minimapToggle:GetName() .. "Text"]
  minimapToggle.text:SetText("Show minimap button")
  Elysian.ApplyFont(minimapToggle.text, 12)
  Elysian.ApplyTextColor(minimapToggle.text)
  Elysian.StyleCheckbox(minimapToggle)
  minimapToggle:SetChecked(not Elysian.state.minimapButtonHidden)
  minimapToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.minimapButtonHidden = not selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.MinimapButton then
      Elysian.MinimapButton:Create()
      Elysian.MinimapButton:ApplyVisibility()
    end
  end)


  table.insert(panels, generalPanel)

  local subTabs = {}
  local scrapTab = CreateTabButton(subHeader, "SCRAP SELLER", 120, 20)
  scrapTab:SetPoint("LEFT", 10, 0)
  table.insert(subTabs, scrapTab)

  local cursorTab = CreateTabButton(subHeader, "CURSOR SETTINGS", 150, 20)
  cursorTab:SetPoint("LEFT", scrapTab, "RIGHT", 8, 0)
  table.insert(subTabs, cursorTab)

  local repairTab = CreateTabButton(subHeader, "AUTO REPAIR", 110, 20)
  repairTab:SetPoint("LEFT", cursorTab, "RIGHT", 8, 0)
  table.insert(subTabs, repairTab)

  local infoTab = CreateTabButton(subHeader, "INFO BAR", 100, 20)
  infoTab:SetPoint("LEFT", repairTab, "RIGHT", 8, 0)
  table.insert(subTabs, infoTab)

  local dungeonTab = CreateTabButton(subHeader, "DUNGEONS", 100, 20)
  dungeonTab:SetPoint("LEFT", infoTab, "RIGHT", 8, 0)
  table.insert(subTabs, dungeonTab)

  local autoKeystonePanel = Elysian.Features and Elysian.Features.AutoKeystone and Elysian.Features.AutoKeystone:CreatePanel(contentBody)
  if autoKeystonePanel then
    autoKeystonePanel:SetPoint("TOPLEFT", 12, -12)
    autoKeystonePanel:SetPoint("TOPRIGHT", -12, -12)
    autoKeystonePanel:SetHeight(880)
    table.insert(panels, autoKeystonePanel)
  end

  local alertClasses = {
    "GENERAL",
    "DUNGEONS",
  }

  local alertTabs = {}
  local alertPanels = {}
  for i, className in ipairs(alertClasses) do
    local tab = CreateTabButton(subHeader, className, 110, 20)
    if i == 1 then
      tab:SetPoint("LEFT", 10, 0)
    else
      tab:SetPoint("LEFT", alertTabs[i - 1], "RIGHT", 8, 0)
    end
    table.insert(alertTabs, tab)

    local panel = CreateFrame("Frame", nil, contentBody)
    panel:SetPoint("TOPLEFT", 12, -12)
    panel:SetPoint("TOPRIGHT", -12, -12)
    panel:SetHeight(880)

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 8, -8)
    if className == "GENERAL" then
      title:SetText("General Alerts")
    else
      title:SetText(className .. " Alerts")
    end

    Elysian.ApplyFont(title, 13, "OUTLINE")
    Elysian.ApplyTextColor(title)

    local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    if className == "GENERAL" then
      hint:SetText("Configure general alert settings here.")
    elseif className == "DUNGEONS" then
      hint:SetText("")
    else
      hint:SetText("Configure class-specific alert settings here.")
    end
    Elysian.ApplyFont(hint, 10)
    Elysian.ApplyTextColor(hint)

    if className == "GENERAL" then
      local repairToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
      repairToggle:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", 0, -16)
      repairToggle.text = repairToggle.text or _G[repairToggle:GetName() .. "Text"]
      repairToggle.text:SetText("Enable repair reminder")
      Elysian.ApplyFont(repairToggle.text, 12)
      Elysian.ApplyTextColor(repairToggle.text)
      Elysian.StyleCheckbox(repairToggle)
      repairToggle:SetChecked(Elysian.state.repairReminderEnabled)
      repairToggle:SetScript("OnClick", function(selfButton)
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.RepairReminder then
          Elysian.Features.RepairReminder:SetEnabled(selfButton:GetChecked())
          Elysian.Features.RepairReminder:UpdateVisibility(true)
        end
      end)

      local colorButton = CreateFrame("Button", nil, panel, template)
      colorButton:SetPoint("TOPLEFT", repairToggle, "BOTTOMLEFT", 0, -12)
      colorButton:SetSize(180, 22)
      Elysian.SetBackdrop(colorButton)
      Elysian.SetBackdropColors(colorButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local colorText = colorButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      colorText:SetPoint("CENTER")
      colorText:SetText("Text Color")
      Elysian.ApplyFont(colorText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(colorText)

      local colorSwatch = colorButton:CreateTexture(nil, "OVERLAY")
      colorSwatch:SetSize(12, 12)
      colorSwatch:SetPoint("RIGHT", -8, 0)
      local startColor = Elysian.state.repairReminderTextColor or { 1, 0.2, 0.2 }
      colorSwatch:SetColorTexture(startColor[1], startColor[2], startColor[3], 1)

      colorButton:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.repairReminderTextColor or { 1, 0.2, 0.2 }
        local function apply(r, g, b)
          Elysian.state.repairReminderTextColor = { r, g, b }
          colorSwatch:SetColorTexture(r, g, b, 1)
          if Elysian.Features and Elysian.Features.RepairReminder then
            Elysian.Features.RepairReminder:ApplyColors()
          end
          if Elysian.SaveState then
            Elysian.SaveState()
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
      HookButtonPressFeedback(colorButton)

      local testBanner = CreateFrame("Button", nil, panel, template)
      testBanner:SetPoint("LEFT", colorButton, "RIGHT", 10, 0)
      testBanner:SetSize(120, 22)
      Elysian.SetBackdrop(testBanner)
      Elysian.SetBackdropColors(testBanner, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local testBannerText = testBanner:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      testBannerText:SetPoint("CENTER")
      testBannerText:SetText("Test Banner")
      Elysian.ApplyFont(testBannerText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(testBannerText)

      local function UpdateTestButtonStyle(active)
        local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
        Elysian.SetBackdropColors(testBanner, bg, Elysian.GetThemeBorder(), 0.9)
      end
      UpdateTestButtonStyle(Elysian.state.repairReminderTest)

      testBanner:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.RepairReminder then
          local enabled = not Elysian.state.repairReminderTest
          Elysian.Features.RepairReminder:SetTestEnabled(enabled)
          UpdateTestButtonStyle(enabled)
        end
      end)
      HookButtonPressFeedback(testBanner)
    end

    if className == "DUNGEONS" then
      local dungeonToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
      dungeonToggle:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", 0, -16)
      dungeonToggle.text = dungeonToggle.text or _G[dungeonToggle:GetName() .. "Text"]
      dungeonToggle.text:SetText("Enable don't release reminder")
      Elysian.ApplyFont(dungeonToggle.text, 12)
      Elysian.ApplyTextColor(dungeonToggle.text)
      Elysian.StyleCheckbox(dungeonToggle)
      dungeonToggle:SetChecked(Elysian.state.dungeonReminderEnabled)
      dungeonToggle:SetScript("OnClick", function(selfButton)
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.DungeonReminder then
          Elysian.Features.DungeonReminder:SetEnabled(selfButton:GetChecked())
          Elysian.Features.DungeonReminder:UpdateVisibility(true)
        end
      end)

      local dungeonColor = CreateFrame("Button", nil, panel, template)
      dungeonColor:SetPoint("TOPLEFT", dungeonToggle, "BOTTOMLEFT", 0, -12)
      dungeonColor:SetSize(180, 22)
      Elysian.SetBackdrop(dungeonColor)
      Elysian.SetBackdropColors(dungeonColor, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local dungeonColorText = dungeonColor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      dungeonColorText:SetPoint("CENTER")
      dungeonColorText:SetText("Text Color")
      Elysian.ApplyFont(dungeonColorText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(dungeonColorText)

      local dungeonSwatch = dungeonColor:CreateTexture(nil, "OVERLAY")
      dungeonSwatch:SetSize(12, 12)
      dungeonSwatch:SetPoint("RIGHT", -8, 0)
      local dungeonStart = Elysian.state.dungeonReminderTextColor or { 1, 1, 1 }
      dungeonSwatch:SetColorTexture(dungeonStart[1], dungeonStart[2], dungeonStart[3], 1)

      dungeonColor:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.dungeonReminderTextColor or { 1, 1, 1 }
        local function apply(r, g, b)
          Elysian.state.dungeonReminderTextColor = { r, g, b }
          dungeonSwatch:SetColorTexture(r, g, b, 1)
          if Elysian.Features and Elysian.Features.DungeonReminder then
            Elysian.Features.DungeonReminder:ApplyColors()
          end
          if Elysian.SaveState then
            Elysian.SaveState()
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
      HookButtonPressFeedback(dungeonColor)

      local dungeonTest = CreateFrame("Button", nil, panel, template)
      dungeonTest:SetPoint("LEFT", dungeonColor, "RIGHT", 10, 0)
      dungeonTest:SetSize(120, 22)
      Elysian.SetBackdrop(dungeonTest)
      Elysian.SetBackdropColors(dungeonTest, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local dungeonTestText = dungeonTest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      dungeonTestText:SetPoint("CENTER")
      dungeonTestText:SetText("Test Banner")
      Elysian.ApplyFont(dungeonTestText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(dungeonTestText)

      local function UpdateDungeonTestStyle(active)
        local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
        Elysian.SetBackdropColors(dungeonTest, bg, Elysian.GetThemeBorder(), 0.9)
      end
      UpdateDungeonTestStyle(Elysian.state.dungeonReminderTest)

      dungeonTest:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.DungeonReminder then
          local enabled = not Elysian.state.dungeonReminderTest
          Elysian.Features.DungeonReminder:SetTestEnabled(enabled)
          UpdateDungeonTestStyle(enabled)
        end
      end)
      HookButtonPressFeedback(dungeonTest)

      local buffToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
      buffToggle:SetPoint("TOPLEFT", dungeonColor, "BOTTOMLEFT", 0, -18)
      buffToggle.text = buffToggle.text or _G[buffToggle:GetName() .. "Text"]
      buffToggle.text:SetText("Enable Buffwatch")
      Elysian.ApplyFont(buffToggle.text, 12)
      Elysian.ApplyTextColor(buffToggle.text)
      Elysian.StyleCheckbox(buffToggle)
      buffToggle:SetChecked(Elysian.state.buffWatchEnabled)
      buffToggle:SetScript("OnClick", function(selfButton)
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.BuffWatch then
          Elysian.Features.BuffWatch:SetEnabled(selfButton:GetChecked())
          Elysian.Features.BuffWatch:UpdateVisibility(true)
        end
      end)

      local buffColor = CreateFrame("Button", nil, panel, template)
      buffColor:SetPoint("TOPLEFT", buffToggle, "BOTTOMLEFT", 0, -12)
      buffColor:SetSize(180, 22)
      Elysian.SetBackdrop(buffColor)
      Elysian.SetBackdropColors(buffColor, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local buffColorText = buffColor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      buffColorText:SetPoint("CENTER")
      buffColorText:SetText("Text Color")
      Elysian.ApplyFont(buffColorText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(buffColorText)

      local buffSwatch = buffColor:CreateTexture(nil, "OVERLAY")
      buffSwatch:SetSize(12, 12)
      buffSwatch:SetPoint("RIGHT", -8, 0)
      local buffStart = Elysian.state.buffWatchTextColor or { 1, 1, 1 }
      buffSwatch:SetColorTexture(buffStart[1], buffStart[2], buffStart[3], 1)

      buffColor:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.buffWatchTextColor or { 1, 1, 1 }
        local function apply(r, g, b)
          Elysian.state.buffWatchTextColor = { r, g, b }
          buffSwatch:SetColorTexture(r, g, b, 1)
          if Elysian.Features and Elysian.Features.BuffWatch then
            Elysian.Features.BuffWatch:ApplyColors()
          end
          if Elysian.SaveState then
            Elysian.SaveState()
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
      HookButtonPressFeedback(buffColor)

      local buffTest = CreateFrame("Button", nil, panel, template)
      buffTest:SetPoint("LEFT", buffColor, "RIGHT", 10, 0)
      buffTest:SetSize(120, 22)
      Elysian.SetBackdrop(buffTest)
      Elysian.SetBackdropColors(buffTest, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local buffTestText = buffTest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      buffTestText:SetPoint("CENTER")
      buffTestText:SetText("Test Banner")
      Elysian.ApplyFont(buffTestText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(buffTestText)

      local function UpdateBuffTestStyle(active)
        local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
        Elysian.SetBackdropColors(buffTest, bg, Elysian.GetThemeBorder(), 0.9)
      end
      UpdateBuffTestStyle(Elysian.state.buffWatchTest)

      buffTest:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.BuffWatch then
          local enabled = not Elysian.state.buffWatchTest
          Elysian.Features.BuffWatch:SetTestEnabled(enabled)
          UpdateBuffTestStyle(enabled)
        end
      end)
      HookButtonPressFeedback(buffTest)

      local consumableToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
      consumableToggle:SetPoint("TOPLEFT", buffColor, "BOTTOMLEFT", 0, -18)
      consumableToggle.text = consumableToggle.text or _G[consumableToggle:GetName() .. "Text"]
      consumableToggle.text:SetText("Enable consumable reminders")
      Elysian.ApplyFont(consumableToggle.text, 12)
      Elysian.ApplyTextColor(consumableToggle.text)
      Elysian.StyleCheckbox(consumableToggle)
      consumableToggle:SetChecked(Elysian.state.dungeonConsumablesEnabled)
      consumableToggle:SetScript("OnClick", function(selfButton)
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.DungeonConsumables then
          Elysian.Features.DungeonConsumables:SetEnabled(selfButton:GetChecked())
          Elysian.Features.DungeonConsumables:UpdateVisibility(true)
        end
      end)

      local consumableColor = CreateFrame("Button", nil, panel, template)
      consumableColor:SetPoint("TOPLEFT", consumableToggle, "BOTTOMLEFT", 0, -12)
      consumableColor:SetSize(180, 22)
      Elysian.SetBackdrop(consumableColor)
      Elysian.SetBackdropColors(consumableColor, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local consumableColorText = consumableColor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      consumableColorText:SetPoint("CENTER")
      consumableColorText:SetText("Text Color")
      Elysian.ApplyFont(consumableColorText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(consumableColorText)

      local consumableSwatch = consumableColor:CreateTexture(nil, "OVERLAY")
      consumableSwatch:SetSize(12, 12)
      consumableSwatch:SetPoint("RIGHT", -8, 0)
      local consumableStart = Elysian.state.dungeonConsumablesTextColor or { 1, 1, 1 }
      consumableSwatch:SetColorTexture(consumableStart[1], consumableStart[2], consumableStart[3], 1)

      consumableColor:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.dungeonConsumablesTextColor or { 1, 1, 1 }
        local function apply(r, g, b)
          Elysian.state.dungeonConsumablesTextColor = { r, g, b }
          consumableSwatch:SetColorTexture(r, g, b, 1)
          if Elysian.Features and Elysian.Features.DungeonConsumables then
            Elysian.Features.DungeonConsumables:ApplyColors()
          end
          if Elysian.SaveState then
            Elysian.SaveState()
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
      HookButtonPressFeedback(consumableColor)

      local consumableTest = CreateFrame("Button", nil, panel, template)
      consumableTest:SetPoint("LEFT", consumableColor, "RIGHT", 10, 0)
      consumableTest:SetSize(120, 22)
      Elysian.SetBackdrop(consumableTest)
      Elysian.SetBackdropColors(consumableTest, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local consumableTestText = consumableTest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      consumableTestText:SetPoint("CENTER")
      consumableTestText:SetText("Test Banner")
      Elysian.ApplyFont(consumableTestText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(consumableTestText)

      local function UpdateConsumableTestStyle(active)
        local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
        Elysian.SetBackdropColors(consumableTest, bg, Elysian.GetThemeBorder(), 0.9)
      end
      UpdateConsumableTestStyle(Elysian.state.dungeonConsumablesTest)

      consumableTest:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        if Elysian.Features and Elysian.Features.DungeonConsumables then
          local enabled = not Elysian.state.dungeonConsumablesTest
          Elysian.Features.DungeonConsumables:SetTestEnabled(enabled)
          UpdateConsumableTestStyle(enabled)
        end
      end)
      HookButtonPressFeedback(consumableTest)

    end

    table.insert(alertPanels, panel)
  end
  for _, t in ipairs(alertTabs) do
    t:Hide()
  end

  local classAlertTabs = {}
  local classAlertPanels = {}

  local classTabOrder = {
    "WARLOCK",
    "WARRIOR",
    "PALADIN",
    "HUNTER",
    "ROGUE",
    "PRIEST",
    "DEATHKNIGHT",
    "SHAMAN",
    "MAGE",
    "DRUID",
    "MONK",
    "DEMONHUNTER",
    "EVOKER",
  }

  local row1Count = 6
  local tabWidth = 110
  local tabHeight = 20
  local tabSpacing = 8
  local rowYOffset = -24

  local function CreateClassTab(name, index)
    local tab = CreateTabButton(subHeader, name, tabWidth, tabHeight)
    local row = index <= row1Count and 1 or 2
    local col = row == 1 and index or (index - row1Count)
    local x = 10 + (col - 1) * (tabWidth + tabSpacing)
    local y = (row == 1) and 8 or rowYOffset
    tab:SetPoint("LEFT", x, y)
    table.insert(classAlertTabs, tab)
    return tab
  end

  local function CreateClassPanel()
    local panel = CreateFrame("Frame", nil, contentBody)
    panel:SetPoint("TOPLEFT", 12, -12)
    panel:SetPoint("TOPRIGHT", -12, -12)
    panel:SetHeight(880)
    table.insert(classAlertPanels, panel)
    return panel
  end

  local warlockTab = CreateClassTab("WARLOCK", 1)
  local warlockPanel = CreateClassPanel()

  local classAlertsTitle = warlockPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  classAlertsTitle:SetPoint("TOPLEFT", 8, -8)
  classAlertsTitle:SetText("Class Alerts")
  Elysian.ApplyFont(classAlertsTitle, 13, "OUTLINE")
  Elysian.ApplyTextColor(classAlertsTitle)

  local classAlertsHint = warlockPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  classAlertsHint:SetPoint("TOPLEFT", classAlertsTitle, "BOTTOMLEFT", 0, -6)
  classAlertsHint:SetText("")
  Elysian.ApplyFont(classAlertsHint, 10)
  Elysian.ApplyTextColor(classAlertsHint)

  local petToggle = CreateFrame("CheckButton", nil, warlockPanel, "UICheckButtonTemplate")
  petToggle:SetPoint("TOPLEFT", classAlertsHint, "BOTTOMLEFT", 0, -16)
  petToggle.text = petToggle.text or _G[petToggle:GetName() .. "Text"]
  petToggle.text:SetText("Enable pet missing reminder")
  Elysian.ApplyFont(petToggle.text, 12)
  Elysian.ApplyTextColor(petToggle.text)
  Elysian.StyleCheckbox(petToggle)
  petToggle:SetChecked(Elysian.state.warlockPetReminderEnabled)
  petToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:SetPetEnabled(selfButton:GetChecked())
    end
  end)

  local petColorButton = CreateFrame("Button", nil, warlockPanel, template)
  petColorButton:SetPoint("TOPLEFT", petToggle, "BOTTOMLEFT", 0, -12)
  petColorButton:SetSize(180, 22)
  Elysian.SetBackdrop(petColorButton)
  Elysian.SetBackdropColors(petColorButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local petColorText = petColorButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  petColorText:SetPoint("CENTER")
  petColorText:SetText("Text Color")
  Elysian.ApplyFont(petColorText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(petColorText)

  local petSwatch = petColorButton:CreateTexture(nil, "OVERLAY")
  petSwatch:SetSize(12, 12)
  petSwatch:SetPoint("RIGHT", -8, 0)
  local petStart = Elysian.state.warlockPetReminderTextColor or { 0.58, 0.51, 0.79 }
  petSwatch:SetColorTexture(petStart[1], petStart[2], petStart[3], 1)

  petColorButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = Elysian.state.warlockPetReminderTextColor or { 0.58, 0.51, 0.79 }
    local function apply(r, g, b)
      Elysian.state.warlockPetReminderTextColor = { r, g, b }
      petSwatch:SetColorTexture(r, g, b, 1)
      if Elysian.Features and Elysian.Features.WarlockReminders then
        Elysian.Features.WarlockReminders:ApplyColors()
      end
      if Elysian.SaveState then
        Elysian.SaveState()
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
  HookButtonPressFeedback(petColorButton)

  local petTest = CreateFrame("Button", nil, warlockPanel, template)
  petTest:SetPoint("LEFT", petColorButton, "RIGHT", 10, 0)
  petTest:SetSize(120, 22)
  Elysian.SetBackdrop(petTest)
  Elysian.SetBackdropColors(petTest, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local petTestText = petTest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  petTestText:SetPoint("CENTER")
  petTestText:SetText("Test Banner")
  Elysian.ApplyFont(petTestText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(petTestText)

  local function UpdatePetTestStyle(active)
    local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
    Elysian.SetBackdropColors(petTest, bg, Elysian.GetThemeBorder(), 0.9)
  end
  UpdatePetTestStyle(Elysian.state.warlockPetReminderTest)

  petTest:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      local enabled = not Elysian.state.warlockPetReminderTest
      Elysian.Features.WarlockReminders:SetPetTest(enabled)
      UpdatePetTestStyle(enabled)
    end
  end)
  HookButtonPressFeedback(petTest)

  local stoneToggle = CreateFrame("CheckButton", nil, warlockPanel, "UICheckButtonTemplate")
  stoneToggle:SetPoint("TOPLEFT", petToggle, "BOTTOMLEFT", 0, -70)
  stoneToggle.text = stoneToggle.text or _G[stoneToggle:GetName() .. "Text"]
  stoneToggle.text:SetText("Enable missing healthstone reminder")
  Elysian.ApplyFont(stoneToggle.text, 12)
  Elysian.ApplyTextColor(stoneToggle.text)
  Elysian.StyleCheckbox(stoneToggle)
  stoneToggle:SetChecked(Elysian.state.warlockStoneReminderEnabled)
  stoneToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:SetStoneEnabled(selfButton:GetChecked())
    end
  end)

  local stoneColorButton = CreateFrame("Button", nil, warlockPanel, template)
  stoneColorButton:SetPoint("TOPLEFT", stoneToggle, "BOTTOMLEFT", 0, -12)
  stoneColorButton:SetSize(180, 22)
  Elysian.SetBackdrop(stoneColorButton)
  Elysian.SetBackdropColors(stoneColorButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local stoneColorText = stoneColorButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stoneColorText:SetPoint("CENTER")
  stoneColorText:SetText("Text Color")
  Elysian.ApplyFont(stoneColorText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(stoneColorText)

  local stoneSwatch = stoneColorButton:CreateTexture(nil, "OVERLAY")
  stoneSwatch:SetSize(12, 12)
  stoneSwatch:SetPoint("RIGHT", -8, 0)
  local stoneStart = Elysian.state.warlockStoneReminderTextColor or { 0.58, 0.51, 0.79 }
  stoneSwatch:SetColorTexture(stoneStart[1], stoneStart[2], stoneStart[3], 1)

  stoneColorButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = Elysian.state.warlockStoneReminderTextColor or { 0.58, 0.51, 0.79 }
    local function apply(r, g, b)
      Elysian.state.warlockStoneReminderTextColor = { r, g, b }
      stoneSwatch:SetColorTexture(r, g, b, 1)
      if Elysian.Features and Elysian.Features.WarlockReminders then
        Elysian.Features.WarlockReminders:ApplyColors()
      end
      if Elysian.SaveState then
        Elysian.SaveState()
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
  HookButtonPressFeedback(stoneColorButton)

  local stoneTest = CreateFrame("Button", nil, warlockPanel, template)
  stoneTest:SetPoint("LEFT", stoneColorButton, "RIGHT", 10, 0)
  stoneTest:SetSize(120, 22)
  Elysian.SetBackdrop(stoneTest)
  Elysian.SetBackdropColors(stoneTest, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local stoneTestText = stoneTest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stoneTestText:SetPoint("CENTER")
  stoneTestText:SetText("Test Banner")
  Elysian.ApplyFont(stoneTestText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(stoneTestText)

  local function UpdateStoneTestStyle(active)
    local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
    Elysian.SetBackdropColors(stoneTest, bg, Elysian.GetThemeBorder(), 0.9)
  end
  UpdateStoneTestStyle(Elysian.state.warlockStoneReminderTest)

  stoneTest:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      local enabled = not Elysian.state.warlockStoneReminderTest
      Elysian.Features.WarlockReminders:SetStoneTest(enabled)
      UpdateStoneTestStyle(enabled)
    end
  end)
  HookButtonPressFeedback(stoneTest)

  local function BuildSimpleBuffPanel(panel, className, prefix, labelText)
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 8, -8)
    title:SetText(className .. " Alerts")
    Elysian.ApplyFont(title, 13, "OUTLINE")
    Elysian.ApplyTextColor(title)

    local toggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    toggle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
    toggle.text = toggle.text or _G[toggle:GetName() .. "Text"]
    toggle.text:SetText(labelText)
    Elysian.ApplyFont(toggle.text, 12)
    Elysian.ApplyTextColor(toggle.text)
    Elysian.StyleCheckbox(toggle)
    toggle:SetChecked(Elysian.state[prefix .. "BuffEnabled"])
    toggle:SetScript("OnClick", function(selfButton)
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:SetEnabled(prefix, selfButton:GetChecked())
      end
    end)

    local colorButton = CreateFrame("Button", nil, panel, template)
    colorButton:SetPoint("TOPLEFT", toggle, "BOTTOMLEFT", 0, -12)
    colorButton:SetSize(180, 22)
    Elysian.SetBackdrop(colorButton)
    Elysian.SetBackdropColors(colorButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

    local colorText = colorButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorText:SetPoint("CENTER")
    colorText:SetText("Text Color")
    Elysian.ApplyFont(colorText, 11, "OUTLINE")
    Elysian.ApplyAccentColor(colorText)

    local swatch = colorButton:CreateTexture(nil, "OVERLAY")
    swatch:SetSize(12, 12)
    swatch:SetPoint("RIGHT", -8, 0)
    local start = Elysian.state[prefix .. "BuffTextColor"] or { 1, 1, 1 }
    swatch:SetColorTexture(start[1], start[2], start[3], 1)

    colorButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      local color = Elysian.state[prefix .. "BuffTextColor"] or { 1, 1, 1 }
      local function apply(r, g, b)
        Elysian.state[prefix .. "BuffTextColor"] = { r, g, b }
        swatch:SetColorTexture(r, g, b, 1)
        if Elysian.Features and Elysian.Features.ClassBuffReminders then
          Elysian.Features.ClassBuffReminders:ApplyColors(prefix)
        end
        if Elysian.SaveState then
          Elysian.SaveState()
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
    HookButtonPressFeedback(colorButton)

    local testButton = CreateFrame("Button", nil, panel, template)
    testButton:SetPoint("LEFT", colorButton, "RIGHT", 10, 0)
    testButton:SetSize(120, 22)
    Elysian.SetBackdrop(testButton)
    Elysian.SetBackdropColors(testButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

    local testText = testButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    testText:SetPoint("CENTER")
    testText:SetText("Test Banner")
    Elysian.ApplyFont(testText, 11, "OUTLINE")
    Elysian.ApplyAccentColor(testText)

    local function UpdateTestStyle(active)
      local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
      Elysian.SetBackdropColors(testButton, bg, Elysian.GetThemeBorder(), 0.9)
    end
    UpdateTestStyle(Elysian.state[prefix .. "BuffTest"])

    testButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        local enabled = not Elysian.state[prefix .. "BuffTest"]
        Elysian.Features.ClassBuffReminders:SetTestEnabled(prefix, enabled)
        UpdateTestStyle(enabled)
      end
    end)
    HookButtonPressFeedback(testButton)
  end

  local function BuildRoguePanel(panel)
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 8, -8)
    title:SetText("Rogue Alerts")
    Elysian.ApplyFont(title, 13, "OUTLINE")
    Elysian.ApplyTextColor(title)

    local toggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    toggle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
    toggle.text = toggle.text or _G[toggle:GetName() .. "Text"]
    toggle.text:SetText("Enable poison reminder")
    Elysian.ApplyFont(toggle.text, 12)
    Elysian.ApplyTextColor(toggle.text)
    Elysian.StyleCheckbox(toggle)
    toggle:SetChecked(Elysian.state.roguePoisonEnabled)
    toggle:SetScript("OnClick", function(selfButton)
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:SetEnabled("rogue", selfButton:GetChecked())
      end
    end)

    local colorButton = CreateFrame("Button", nil, panel, template)
    colorButton:SetPoint("TOPLEFT", toggle, "BOTTOMLEFT", 0, -12)
    colorButton:SetSize(180, 22)
    Elysian.SetBackdrop(colorButton)
    Elysian.SetBackdropColors(colorButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

    local colorText = colorButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorText:SetPoint("CENTER")
    colorText:SetText("Text Color")
    Elysian.ApplyFont(colorText, 11, "OUTLINE")
    Elysian.ApplyAccentColor(colorText)

    local swatch = colorButton:CreateTexture(nil, "OVERLAY")
    swatch:SetSize(12, 12)
    swatch:SetPoint("RIGHT", -8, 0)
    local start = Elysian.state.roguePoisonTextColor or { 1, 1, 1 }
    swatch:SetColorTexture(start[1], start[2], start[3], 1)

    colorButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      local color = Elysian.state.roguePoisonTextColor or { 1, 1, 1 }
      local function apply(r, g, b)
        Elysian.state.roguePoisonTextColor = { r, g, b }
        swatch:SetColorTexture(r, g, b, 1)
        if Elysian.Features and Elysian.Features.ClassBuffReminders then
          Elysian.Features.ClassBuffReminders:ApplyColors("rogue")
        end
        if Elysian.SaveState then
          Elysian.SaveState()
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
    HookButtonPressFeedback(colorButton)

    local testButton = CreateFrame("Button", nil, panel, template)
    testButton:SetPoint("LEFT", colorButton, "RIGHT", 10, 0)
    testButton:SetSize(120, 22)
    Elysian.SetBackdrop(testButton)
    Elysian.SetBackdropColors(testButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

    local testText = testButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    testText:SetPoint("CENTER")
    testText:SetText("Test Banner")
    Elysian.ApplyFont(testText, 11, "OUTLINE")
    Elysian.ApplyAccentColor(testText)

    local function UpdateTestStyle(active)
      local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
      Elysian.SetBackdropColors(testButton, bg, Elysian.GetThemeBorder(), 0.9)
    end
    UpdateTestStyle(Elysian.state.roguePoisonTest)

    testButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        local enabled = not Elysian.state.roguePoisonTest
        Elysian.Features.ClassBuffReminders:SetTestEnabled("rogue", enabled)
        UpdateTestStyle(enabled)
      end
    end)
    HookButtonPressFeedback(testButton)
  end

  for i = 2, #classTabOrder do
    local className = classTabOrder[i]
    CreateClassTab(className, i)
    local panel = CreateClassPanel()
    if className == "WARRIOR" then
      BuildSimpleBuffPanel(panel, "Warrior", "warrior", "Enable Battle Shout reminder")
    elseif className == "MAGE" then
      BuildSimpleBuffPanel(panel, "Mage", "mage", "Enable Arcane Intellect reminder")
    elseif className == "PRIEST" then
      BuildSimpleBuffPanel(panel, "Priest", "priest", "Enable Fortitude reminder")
    elseif className == "DRUID" then
      BuildSimpleBuffPanel(panel, "Druid", "druid", "Enable Mark of the Wild reminder")
    elseif className == "SHAMAN" then
      BuildSimpleBuffPanel(panel, "Shaman", "shaman", "Enable Skyfury reminder")
    elseif className == "EVOKER" then
      BuildSimpleBuffPanel(panel, "Evoker", "evoker", "Enable Blessing of the Bronze reminder")
    elseif className == "ROGUE" then
      BuildRoguePanel(panel)
    else
      local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      title:SetPoint("TOPLEFT", 8, -8)
      title:SetText(className .. " Alerts")
      Elysian.ApplyFont(title, 13, "OUTLINE")
      Elysian.ApplyTextColor(title)

      local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
      hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
      hint:SetText("Coming soon.")
      Elysian.ApplyFont(hint, 10)
      Elysian.ApplyTextColor(hint)
    end
  end

  local function SelectTopTab(active)
    for _, tab in ipairs(topTabs) do
      StyleTopTab(tab, tab == active)
    end
  end

  local function SelectSubTab(active)
    for _, tab in ipairs(subTabs) do
      StyleSubTab(tab, tab == active)
    end
  end

  local function SetSubHeaderMode(mode)
    if mode == "qol" then
      subHeader:Show()
      SetSubHeaderBackground(true)
      for _, t in ipairs(subTabs) do
        t:Show()
      end
      for _, t in ipairs(alertTabs) do
        t:Hide()
      end
      for _, t in ipairs(classAlertTabs) do
        t:Hide()
      end
    elseif mode == "alerts" then
      subHeader:Show()
      SetSubHeaderBackground(true)
      for _, t in ipairs(subTabs) do
        t:Hide()
      end
      for _, t in ipairs(alertTabs) do
        t:Show()
      end
      for _, t in ipairs(classAlertTabs) do
        t:Hide()
      end
    elseif mode == "classalerts" then
      subHeader:Show()
      SetSubHeaderBackground(false)
      for _, t in ipairs(subTabs) do
        t:Hide()
      end
      for _, t in ipairs(alertTabs) do
        t:Hide()
      end
      for _, t in ipairs(classAlertTabs) do
        t:Show()
      end
    else
      subHeader:Hide()
      for _, t in ipairs(subTabs) do
        t:Hide()
      end
      for _, t in ipairs(alertTabs) do
        t:Hide()
      end
      for _, t in ipairs(classAlertTabs) do
        t:Hide()
      end
    end
  end

  local function HideAlertPanels()
    for _, panel in ipairs(alertPanels) do
      panel:Hide()
    end
  end

  local function ShowAlertPanel(activePanel)
    for _, panel in ipairs(alertPanels) do
      if panel == activePanel then
        panel:Show()
      else
        panel:Hide()
      end
    end
  end

  local function ShowGeneral()
    SetSubHeaderMode("none")
    sectionTitle:SetText("GENERAL")
    contentBody:Show()
    ShowPanel(generalPanel, panels)
    HideAlertPanels()
    for _, panel in ipairs(classAlertPanels) do
      panel:Hide()
    end
  end

  local function ShowQol(panel, tab)
    SetSubHeaderMode("qol")
    sectionTitle:SetText("QOL TOOLS")
    contentBody:Show()
    ShowPanel(panel, panels)
    SelectSubTab(tab)
    for _, t in ipairs(alertTabs) do
      t:Hide()
    end
    HideAlertPanels()
    for _, panel in ipairs(classAlertPanels) do
      panel:Hide()
    end
  end

  local function ShowAlerts(panel, tab)
    SetSubHeaderMode("alerts")
    sectionTitle:SetText("ALERTS")
    contentBody:Show()
    for _, p in ipairs(panels) do
      p:Hide()
    end
    ShowAlertPanel(panel)
    for _, t in ipairs(subTabs) do
      StyleSubTab(t, false)
      t:Hide()
    end
    for _, t in ipairs(alertTabs) do
      StyleSubTab(t, t == tab)
      t:Show()
    end
    for _, panel in ipairs(classAlertPanels) do
      panel:Hide()
    end
  end

  local function ShowClassAlerts(panel, tab)
    SetSubHeaderMode("classalerts")
    sectionTitle:SetText("CLASS ALERTS")
    contentBody:Show()
    ShowPanel(nil, panels)
    HideAlertPanels()
    for _, p in ipairs(classAlertPanels) do
      if p == panel then
        p:Show()
      else
        p:Hide()
      end
    end
    for _, t in ipairs(classAlertTabs) do
      StyleSubTab(t, t == tab)
    end
  end

  generalTab:SetScript("OnClick", function()
    SelectTopTab(generalTab)
    ShowGeneral()
  end)

  qolTab:SetScript("OnClick", function()
    SelectTopTab(qolTab)
    ShowQol(scrapPanel or generalPanel, scrapTab)
  end)

  alertsTab:SetScript("OnClick", function()
    SelectTopTab(alertsTab)
    if alertPanels[1] then
      ShowAlerts(alertPanels[1], alertTabs[1])
    end
  end)

  classAlertsTab:SetScript("OnClick", function()
    SelectTopTab(classAlertsTab)
    if classAlertPanels[1] then
      ShowClassAlerts(classAlertPanels[1], classAlertTabs[1])
    end
  end)

  scrapTab:SetScript("OnClick", function()
    if scrapPanel then
      ShowQol(scrapPanel, scrapTab)
    end
  end)

  cursorTab:SetScript("OnClick", function()
    if cursorPanel then
      ShowQol(cursorPanel, cursorTab)
    end
  end)

  repairTab:SetScript("OnClick", function()
    if repairPanel then
      ShowQol(repairPanel, repairTab)
    end
  end)

  infoTab:SetScript("OnClick", function()
    if infoPanel then
      ShowQol(infoPanel, infoTab)
    end
  end)

  dungeonTab:SetScript("OnClick", function()
    if autoKeystonePanel then
      ShowQol(autoKeystonePanel, dungeonTab)
    end
  end)

  for i, tab in ipairs(alertTabs) do
    tab:SetScript("OnClick", function()
      ShowAlerts(alertPanels[i], tab)
    end)
  end

  for i, tab in ipairs(classAlertTabs) do
    tab:SetScript("OnClick", function()
      ShowClassAlerts(classAlertPanels[i], tab)
    end)
  end

  function self.SetAllQolEnabled(enabled)
    if enabled then
      Elysian.state.cursorRingClassColor = true
      Elysian.state.cursorRingCastProgress = true
      Elysian.state.cursorRingShowInCombat = true
      Elysian.state.cursorRingShowOutCombat = true
      Elysian.state.cursorRingShowInInstances = true
      Elysian.state.cursorRingShowInWorld = true
      Elysian.state.cursorRingTrailEnabled = true
    end

    Elysian.state.infoBarEnabled = enabled and true or false
    Elysian.state.infoBarShowTime = enabled and true or Elysian.state.infoBarShowTime
    Elysian.state.infoBarShowGold = enabled and true or Elysian.state.infoBarShowGold
    Elysian.state.infoBarShowDurability = enabled and true or Elysian.state.infoBarShowDurability
    Elysian.state.infoBarShowFPS = enabled and true or Elysian.state.infoBarShowFPS
    Elysian.state.infoBarShowMS = enabled and true or Elysian.state.infoBarShowMS
    Elysian.state.infoBarShowPortalButton = enabled and true or Elysian.state.infoBarShowPortalButton
    Elysian.state.infoBarUnlocked = false
    Elysian.SaveState()

    if Elysian.Features and Elysian.Features.ScrapSeller then
      Elysian.Features.ScrapSeller:SetEnabled(enabled)
      if Elysian.Features.ScrapSeller.Refresh then
        Elysian.Features.ScrapSeller:Refresh()
      end
    end
    if Elysian.Features and Elysian.Features.CursorRing then
      Elysian.Features.CursorRing:SetEnabled(enabled)
      if Elysian.Features.CursorRing.Refresh then
        Elysian.Features.CursorRing:Refresh()
      end
    end
    if Elysian.Features and Elysian.Features.AutoRepair then
      Elysian.Features.AutoRepair:SetEnabled(enabled)
      if Elysian.Features.AutoRepair.Refresh then
        Elysian.Features.AutoRepair:Refresh()
      end
    end
    if Elysian.Features and Elysian.Features.InfoBar then
      Elysian.Features.InfoBar:SetEnabled(enabled)
      if Elysian.Features.InfoBar.Refresh then
        Elysian.Features.InfoBar:Refresh()
      end
    end
    if Elysian.Features and Elysian.Features.AutoKeystone then
      Elysian.Features.AutoKeystone:SetEnabled(enabled)
      if Elysian.Features.AutoKeystone.Refresh then
        Elysian.Features.AutoKeystone:Refresh()
      end
    end
    if Elysian.Features and Elysian.Features.DungeonRoleMarkers then
      Elysian.Features.DungeonRoleMarkers:SetEnabled(enabled)
      Elysian.Features.DungeonRoleMarkers:UpdateMarks(true)
    end
  end

  SelectTopTab(generalTab)
  SelectSubTab(scrapTab)
  ShowGeneral()

  local showOnStart = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
  showOnStart:SetPoint("BOTTOMLEFT", 10, 10)
  showOnStart.text = showOnStart.text or _G[showOnStart:GetName() .. "Text"]
  showOnStart.text:SetText("Do not show at start")
  Elysian.ApplyFont(showOnStart.text, 13)
  Elysian.ApplyTextColor(showOnStart.text)
  Elysian.StyleCheckbox(showOnStart)
  local dbShow = (ElysianDB and ElysianDB.showOnStart)
  local shouldShowOnStart = (dbShow ~= false) and (Elysian.state.showOnStart ~= false)
  showOnStart:SetChecked(not shouldShowOnStart)
  showOnStart:SetScript("OnClick", function(selfButton)
    local showAtStart = not selfButton:GetChecked()
    Elysian.state.showOnStart = showAtStart
    if ElysianDB then
      ElysianDB.showOnStart = showAtStart
    end
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)
  self.showOnStartCheck = showOnStart

  self.mainFrame = frame
  tinsert(UISpecialFrames, frame:GetName())
  local hideOnStart = (ElysianDB and ElysianDB.showOnStart == false) or (Elysian.state and Elysian.state.showOnStart == false)
  if hideOnStart then
    frame:Hide()
  end
  return frame
end

function Elysian.UI:Rebuild()
  if self.mainFrame then
    self.mainFrame:Hide()
    self.mainFrame = nil
  end
  self:CreateMainFrame()
end

function Elysian.UI:Toggle()
  local frame = self.mainFrame or self:CreateMainFrame()
  if frame:IsShown() then
    frame:Hide()
  else
    frame:Show()
  end
end

function Elysian.UI:Show()
  local frame = self.mainFrame or self:CreateMainFrame()
  frame:Show()
end

function Elysian.UI:ShowConfirm(titleText, bodyText, onYes)
  if self.confirmFrame and self.confirmFrame:IsShown() then
    self.confirmFrame:Hide()
  end

  local frame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  frame:SetSize(300, 140)
  frame:SetPoint("CENTER")
  frame:SetFrameStrata("DIALOG")
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  Elysian.SetBackdrop(frame)
  Elysian.SetBackdropColors(frame, Elysian.GetContentBg(), Elysian.GetThemeBorder(), 0.95)

  local titleTextValue = titleText or ""
  local title
  if titleTextValue ~= "" then
    title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -12)
    title:SetText(titleTextValue)
    Elysian.ApplyFont(title, 13, "OUTLINE")
    Elysian.ApplyAccentColor(title)
  end

  local bodyTextValue = bodyText or ""
  local body
  if bodyTextValue ~= "" then
    body = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    if title then
      body:SetPoint("TOP", title, "BOTTOM", 0, -8)
    else
      body:SetPoint("TOP", 0, -12)
    end
    body:SetText(bodyTextValue)
    Elysian.ApplyFont(body, 11)
    Elysian.ApplyTextColor(body)
  end

  local actionFrame = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
  actionFrame:SetPoint("BOTTOM", 0, 42)
  actionFrame:SetSize(220, 66)
  Elysian.SetBackdrop(actionFrame)
  Elysian.SetBackdropColors(actionFrame, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.8)

  local actionTitle = actionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  actionTitle:SetPoint("TOP", 0, -6)
  actionTitle:SetText("Reload UI")
  Elysian.ApplyFont(actionTitle, 11, "OUTLINE")
  Elysian.ApplyAccentColor(actionTitle)

  local yesButton = CreateFrame("Button", nil, actionFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
  yesButton:SetSize(90, 22)
  yesButton:SetPoint("LEFT", 14, -18)
  Elysian.SetBackdrop(yesButton)
  Elysian.SetBackdropColors(yesButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local yesText = yesButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  yesText:SetPoint("CENTER")
  yesText:SetText("Yes")
  Elysian.ApplyFont(yesText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(yesText)

  local noButton = CreateFrame("Button", nil, actionFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
  noButton:SetSize(90, 22)
  noButton:SetPoint("RIGHT", -14, -18)
  Elysian.SetBackdrop(noButton)
  Elysian.SetBackdropColors(noButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local noText = noButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  noText:SetPoint("CENTER")
  noText:SetText("No")
  Elysian.ApplyFont(noText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(noText)

  yesButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    frame:Hide()
    if onYes then
      onYes()
    end
  end)
  HookButtonPressFeedback(yesButton)

  noButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    frame:Hide()
  end)
  HookButtonPressFeedback(noButton)

  self.confirmFrame = frame
  frame:Show()
end

function Elysian.UI:Hide()
  local frame = self.mainFrame or self:CreateMainFrame()
  frame:Hide()
end

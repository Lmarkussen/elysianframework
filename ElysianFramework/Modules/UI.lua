local _, Elysian = ...

Elysian.UI = Elysian.UI or {}

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
  frame:SetSize(780, 600)
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
  Elysian.ApplyTextColor(title)

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
  subHeader:SetHeight(30)
  Elysian.SetBackdrop(subHeader)
  Elysian.SetBackdropColors(subHeader, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.96)

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

  local qolToggle = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
  qolToggle:SetPoint("TOPRIGHT", -36, -8)
  qolToggle.text = qolToggle.text or _G[qolToggle:GetName() .. "Text"]
  qolToggle.text:SetText("Toggle ON all QOL Features")
  Elysian.ApplyFont(qolToggle.text, 12)
  Elysian.ApplyTextColor(qolToggle.text)
  Elysian.StyleCheckbox(qolToggle)

  local sectionLine = content:CreateTexture(nil, "BACKGROUND")
  sectionLine:SetPoint("LEFT", sectionTitle, "RIGHT", 12, 0)
  sectionLine:SetPoint("RIGHT", -28, 0)
  sectionLine:SetHeight(1)
  sectionLine:SetColorTexture(0.27, 0.28, 0.35, 1)

  local scrollFrame = CreateFrame("ScrollFrame", nil, content, "UIPanelScrollFrameTemplate")
  scrollFrame:SetPoint("TOPLEFT", 0, -34)
  scrollFrame:SetPoint("BOTTOMRIGHT", -26, 0)

  local contentBody = CreateFrame("Frame", nil, scrollFrame)
  contentBody:SetSize(1, 900)
  scrollFrame:SetScrollChild(contentBody)

  scrollFrame:SetScript("OnSizeChanged", function()
    contentBody:SetWidth(scrollFrame:GetWidth() or 1)
  end)

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
  versionText:SetText("v0.00.8")
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

  local generalQolToggle = CreateFrame("CheckButton", nil, generalPanel, "UICheckButtonTemplate")
  generalQolToggle:SetPoint("TOPLEFT", textColorButton, "BOTTOMLEFT", 0, -14)
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


  table.insert(panels, generalPanel)

  local subTabs = {}
  local scrapTab = CreateTabButton(subHeader, "SCRAP SELLER", 120, 20)
  scrapTab:SetPoint("LEFT", 10, 0)
  table.insert(subTabs, scrapTab)

  local cursorTab = CreateTabButton(subHeader, "CURSOR RING", 110, 20)
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
    end

    table.insert(alertPanels, panel)
  end
  for _, t in ipairs(alertTabs) do
    t:Hide()
  end

  local classAlertTabs = {}
  local classAlertPanels = {}

  local warlockTab = CreateTabButton(subHeader, "WARLOCK", 110, 20)
  warlockTab:SetPoint("LEFT", 10, 0)
  table.insert(classAlertTabs, warlockTab)

  local warlockPanel = CreateFrame("Frame", nil, contentBody)
  warlockPanel:SetPoint("TOPLEFT", 12, -12)
  warlockPanel:SetPoint("TOPRIGHT", -12, -12)
  warlockPanel:SetHeight(880)
  table.insert(classAlertPanels, warlockPanel)

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

  local petTest = CreateFrame("Button", nil, warlockPanel, template)
  petTest:SetPoint("TOPLEFT", petToggle, "BOTTOMLEFT", 0, -12)
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

  local stoneToggle = CreateFrame("CheckButton", nil, warlockPanel, "UICheckButtonTemplate")
  stoneToggle:SetPoint("TOPLEFT", petTest, "BOTTOMLEFT", 0, -18)
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

  local stoneTest = CreateFrame("Button", nil, warlockPanel, template)
  stoneTest:SetPoint("TOPLEFT", stoneToggle, "BOTTOMLEFT", 0, -12)
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
    scrollFrame:Hide()
    qolToggle:Hide()
    ShowPanel(generalPanel, panels)
    HideAlertPanels()
    for _, panel in ipairs(classAlertPanels) do
      panel:Hide()
    end
  end

  local function ShowQol(panel, tab)
    SetSubHeaderMode("qol")
    sectionTitle:SetText("QOL TOOLS")
    scrollFrame:Show()
    qolToggle:Show()
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
    scrollFrame:Show()
    qolToggle:Hide()
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
    scrollFrame:Show()
    qolToggle:Hide()
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
  end

  qolToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    self.SetAllQolEnabled(selfButton:GetChecked())
  end)

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
  showOnStart:SetChecked(not Elysian.state.showOnStart)
  showOnStart:SetScript("OnClick", function(selfButton)
    Elysian.state.showOnStart = not selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
  end)
  self.showOnStartCheck = showOnStart

  self.mainFrame = frame
  tinsert(UISpecialFrames, frame:GetName())
  if Elysian.state and not Elysian.state.showOnStart then
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

  noButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    frame:Hide()
  end)

  self.confirmFrame = frame
  frame:Show()
end

function Elysian.UI:Hide()
  local frame = self.mainFrame or self:CreateMainFrame()
  frame:Hide()
end

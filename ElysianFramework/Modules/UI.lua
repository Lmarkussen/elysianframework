local _, Elysian = ...

Elysian.UI = Elysian.UI or {}
Elysian.UI.SkinDropDown = nil

local function HookButtonPressFeedback(button)
  if not button or not button.SetBackdropColor then
    return
  end
  local function SetActive(active)
    if active then
      Elysian.SetBackdropColors(button, { 0.92, 0.92, 0.92 }, Elysian.GetThemeBorder(), 0.95)
    else
      Elysian.SetBackdropColors(button, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)
    end
  end
  button:HookScript("OnMouseDown", function() SetActive(true) end)
  button:HookScript("OnMouseUp", function() SetActive(false) end)
  button:HookScript("OnHide", function() SetActive(false) end)
  button:HookScript("OnLeave", function() SetActive(false) end)
end

Elysian.UI.HookButtonPressFeedback = HookButtonPressFeedback

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
  HookButtonPressFeedback(button)
  return button
end

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

  if button.classColor then
    local c = button.classColor
    if button.text then
      button.text:SetTextColor(c[1], c[2], c[3])
    end
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
  contentBody:SetClipsChildren(true)

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
  versionText:SetText("v1.00.22 BETA")
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
    if Elysian.RefreshFeatures then
      Elysian.RefreshFeatures()
    end
    if Elysian.UI and Elysian.UI.Rebuild then
      Elysian.UI:Rebuild()
      Elysian.UI:Show()
    end
    if Elysian.UI and Elysian.UI.mainFrame and Elysian.UI.mainFrame:IsShown() then
      if Elysian.UI.showOnStartCheck then
        Elysian.UI.showOnStartCheck:SetChecked(not Elysian.state.showOnStart)
      end
    end
  end)
  HookButtonPressFeedback(resetButton)

  local testBarsButton = CreateFrame("Button", nil, generalPanel, template)
  testBarsButton:SetPoint("BOTTOMLEFT", 176, 16)
  testBarsButton:SetSize(160, 22)
  Elysian.SetBackdrop(testBarsButton)
  Elysian.SetBackdropColors(testBarsButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local testBarsText = testBarsButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  testBarsText:SetPoint("CENTER")
  testBarsText:SetText("Test Bars")
  Elysian.ApplyFont(testBarsText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(testBarsText)

  local function UpdateTestBarsStyle(active)
    local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
    Elysian.SetBackdropColors(testBarsButton, bg, Elysian.GetThemeBorder(), 0.9)
  end
  UpdateTestBarsStyle(Elysian.state.bannerTestAll)

  local function SetAllBannerTests(enabled)
    Elysian.state.bannerTestAll = enabled and true or false
    Elysian.state.repairReminderTest = enabled and true or false
    Elysian.state.dungeonReminderTest = enabled and true or false
    Elysian.state.buffWatchTest = enabled and true or false
    Elysian.state.dungeonConsumablesTest = enabled and true or false
    Elysian.state.warlockPetReminderTest = enabled and true or false
    Elysian.state.warlockStoneReminderTest = enabled and true or false
    Elysian.state.warriorBuffTest = enabled and true or false
    Elysian.state.mageBuffTest = enabled and true or false
    Elysian.state.priestBuffTest = enabled and true or false
    Elysian.state.druidBuffTest = enabled and true or false
    Elysian.state.shamanBuffTest = enabled and true or false
    Elysian.state.evokerBuffTest = enabled and true or false
    Elysian.state.roguePoisonTest = enabled and true or false
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.RepairReminder then
      Elysian.Features.RepairReminder:SetTestEnabled(enabled)
    end
    if Elysian.Features and Elysian.Features.DungeonReminder then
      Elysian.Features.DungeonReminder:SetTestEnabled(enabled)
    end
    if Elysian.Features and Elysian.Features.BuffWatch then
      Elysian.Features.BuffWatch:SetTestEnabled(enabled)
    end
    if Elysian.Features and Elysian.Features.DungeonConsumables then
      Elysian.Features.DungeonConsumables:SetTestEnabled(enabled)
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:SetPetTest(enabled)
      Elysian.Features.WarlockReminders:SetStoneTest(enabled)
    end
    if Elysian.Features and Elysian.Features.ClassBuffReminders then
      Elysian.Features.ClassBuffReminders:SetTestEnabled("warrior", enabled)
      Elysian.Features.ClassBuffReminders:SetTestEnabled("mage", enabled)
      Elysian.Features.ClassBuffReminders:SetTestEnabled("priest", enabled)
      Elysian.Features.ClassBuffReminders:SetTestEnabled("druid", enabled)
      Elysian.Features.ClassBuffReminders:SetTestEnabled("shaman", enabled)
      Elysian.Features.ClassBuffReminders:SetTestEnabled("evoker", enabled)
      Elysian.Features.ClassBuffReminders:SetTestEnabled("rogue", enabled)
    end
  end

  testBarsButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local enabled = not Elysian.state.bannerTestAll
    SetAllBannerTests(enabled)
    UpdateTestBarsStyle(enabled)
  end)
  HookButtonPressFeedback(testBarsButton)

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

  local textColorButton = CreateFrame("Button", nil, generalPanel, BackdropTemplateMixin and "BackdropTemplate" or nil)
  textColorButton:SetPoint("TOPLEFT", fontButtonDefault, "BOTTOMLEFT", 0, -16)
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
      Elysian.state.uiTextUseClassColor = false
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
  profileNameBox:SetScript("OnEnterPressed", function()
    saveProfileButton:Click()
  end)

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


  local minimapToggle = CreateFrame("CheckButton", nil, generalPanel, "UICheckButtonTemplate")
  minimapToggle:SetPoint("TOPLEFT", saveProfileButton, "BOTTOMLEFT", -12, -34)
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

  local minimapInfoButton = CreateFrame("Button", nil, generalPanel, template)
  minimapInfoButton:SetPoint("LEFT", minimapToggle.text, "RIGHT", 8, 0)
  minimapInfoButton:SetSize(18, 18)
  Elysian.SetBackdrop(minimapInfoButton)
  Elysian.SetBackdropColors(minimapInfoButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local infoText = minimapInfoButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  infoText:SetPoint("CENTER")
  infoText:SetText("?")
  Elysian.ApplyFont(infoText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(infoText)
  HookButtonPressFeedback(minimapInfoButton)

  local function EnsureMinimapInfoFrame()
    if minimapInfoButton.infoFrame then
      return
    end
    local infoFrame = CreateFrame("Frame", nil, generalPanel, template)
    infoFrame:SetSize(260, 52)
    infoFrame:SetPoint("TOPLEFT", minimapInfoButton, "BOTTOMLEFT", -6, -6)
    Elysian.SetBackdrop(infoFrame)
    Elysian.SetBackdropColors(infoFrame, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)
    local infoLabel = infoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    infoLabel:SetPoint("CENTER")
    infoLabel:SetText("Show or hide minimap button")
    Elysian.ApplyFont(infoLabel, 11, "OUTLINE")
    infoLabel:SetTextColor(1, 1, 1)
    infoFrame:Hide()
    minimapInfoButton.infoFrame = infoFrame
  end

  minimapInfoButton:SetScript("OnMouseDown", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    EnsureMinimapInfoFrame()
    minimapInfoButton.infoFrame:Show()
  end)

  minimapInfoButton:SetScript("OnMouseUp", function()
    if minimapInfoButton.infoFrame then
      minimapInfoButton.infoFrame:Hide()
    end
  end)

  minimapInfoButton:SetScript("OnLeave", function()
    if minimapInfoButton.infoFrame then
      minimapInfoButton.infoFrame:Hide()
    end
  end)

  local showAllClasses = CreateFrame("CheckButton", nil, generalPanel, "UICheckButtonTemplate")
  showAllClasses:SetPoint("TOPLEFT", minimapToggle, "BOTTOMLEFT", 0, -10)
  showAllClasses.text = showAllClasses.text or _G[showAllClasses:GetName() .. "Text"]
  showAllClasses.text:SetText("Show all classes in class alerts")
  Elysian.ApplyFont(showAllClasses.text, 12)
  Elysian.ApplyTextColor(showAllClasses.text)
  Elysian.StyleCheckbox(showAllClasses)
  showAllClasses:SetChecked(Elysian.state.showAllClassAlerts)
  showAllClasses:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.showAllClassAlerts = selfButton:GetChecked()
    if ElysianDB then
      ElysianDB.showAllClassAlerts = Elysian.state.showAllClassAlerts
    end
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.UI and Elysian.UI.Rebuild then
      Elysian.UI:Rebuild()
      Elysian.UI:Show()
    end
  end)

  local showOnStart = CreateFrame("CheckButton", nil, generalPanel, "UICheckButtonTemplate")
  showOnStart:SetPoint("BOTTOMLEFT", 0, -15)
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

  local showOnStartInfo = CreateFrame("Button", nil, generalPanel, template)
  showOnStartInfo:SetPoint("LEFT", showOnStart.text, "RIGHT", 8, 0)
  showOnStartInfo:SetSize(18, 18)
  Elysian.SetBackdrop(showOnStartInfo)
  Elysian.SetBackdropColors(showOnStartInfo, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  local showOnStartInfoText = showOnStartInfo:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  showOnStartInfoText:SetPoint("CENTER")
  showOnStartInfoText:SetText("?")
  Elysian.ApplyFont(showOnStartInfoText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(showOnStartInfoText)
  HookButtonPressFeedback(showOnStartInfo)

  local function EnsureShowOnStartInfoFrame()
    if showOnStartInfo.infoFrame then
      return
    end
    local infoFrame = CreateFrame("Frame", nil, generalPanel, template)
    infoFrame:SetSize(220, 48)
    infoFrame:SetPoint("TOPLEFT", showOnStartInfo, "BOTTOMLEFT", -6, -6)
    Elysian.SetBackdrop(infoFrame)
    Elysian.SetBackdropColors(infoFrame, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.95)
    local infoLabel = infoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    infoLabel:SetPoint("CENTER")
    infoLabel:SetText("Do not show ??")
    Elysian.ApplyFont(infoLabel, 11, "OUTLINE")
    infoLabel:SetTextColor(1, 1, 1)
    infoFrame:Hide()
    showOnStartInfo.infoFrame = infoFrame
  end

  showOnStartInfo:SetScript("OnMouseDown", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    EnsureShowOnStartInfoFrame()
    showOnStartInfo.infoFrame:Show()
  end)

  showOnStartInfo:SetScript("OnMouseUp", function()
    if showOnStartInfo.infoFrame then
      showOnStartInfo.infoFrame:Hide()
    end
  end)

  showOnStartInfo:SetScript("OnLeave", function()
    if showOnStartInfo.infoFrame then
      showOnStartInfo.infoFrame:Hide()
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

    local rootPanel = CreateFrame("Frame", nil, contentBody)
    rootPanel:SetPoint("TOPLEFT", 12, -12)
    rootPanel:SetPoint("TOPRIGHT", -12, -12)
    rootPanel:SetHeight(880)

    local panel = rootPanel
    if className == "DUNGEONS" then
      rootPanel:SetClipsChildren(true)
      local scrollFrame = CreateFrame("ScrollFrame", "ElysianDungeonScrollFrame", rootPanel, "UIPanelScrollFrameTemplate")
      scrollFrame:SetPoint("TOPLEFT", 4, -4)
      scrollFrame:SetPoint("BOTTOMRIGHT", -28, 4)
      scrollFrame:SetClipsChildren(true)
      scrollFrame:EnableMouseWheel(true)

      local scrollChild = CreateFrame("Frame", nil, scrollFrame)
      scrollChild:SetPoint("TOPLEFT", 0, 0)
      scrollChild:SetPoint("TOPRIGHT", 0, 0)
      scrollChild:SetHeight(1800)
      scrollFrame:SetScrollChild(scrollChild)

      local scrollBar = _G["ElysianDungeonScrollFrameScrollBar"]
      if scrollBar then
        scrollBar:Show()
        scrollBar:SetAlpha(0)
      end

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

      local function SyncScrollSize()
        local width = scrollFrame:GetWidth() or 0
        if width <= 0 then
          width = (rootPanel.GetWidth and rootPanel:GetWidth()) or 1
        end
        scrollChild:SetWidth(width)
        scrollFrame:UpdateScrollChildRect()
        if scrollBar then
          scrollBar:SetAlpha(0)
        end
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

      rootPanel.scrollFrame = scrollFrame
      rootPanel.scrollChild = scrollChild
      rootPanel._syncDungeonScroll = SyncScrollSize
      panel = scrollChild
    end

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 8, -8)
    if className == "GENERAL" then
      title:SetText("General Alerts")
    else
      title:SetText(className .. " Alerts")
    end

    Elysian.ApplyFont(title, 13, "OUTLINE")
    Elysian.ApplyTextColor(title)

    if className == "DUNGEONS" and rootPanel.scrollChild then
      local lastWidget = rootPanel._dungeonLastWidget
      if lastWidget and rootPanel.scrollChild then
        local function FinalizeDungeonScroll()
          local child = rootPanel.scrollChild
          local top = child:GetTop()
          local bottom = lastWidget:GetBottom()
          local view = rootPanel.scrollFrame and rootPanel.scrollFrame:GetHeight()
          if top and bottom then
            local height = (top - bottom) + 40
            if view and height < view then
              height = view
            end
            if height < 1800 then
              height = 1800
            end
            child:SetHeight(height)
            if rootPanel._syncDungeonScroll then
              rootPanel._syncDungeonScroll()
            end
          end
        end
        rootPanel:HookScript("OnShow", FinalizeDungeonScroll)
        if C_Timer and C_Timer.After then
          C_Timer.After(0, FinalizeDungeonScroll)
        else
          FinalizeDungeonScroll()
        end
      end
    end

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

      local textOverrideLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      textOverrideLabel:SetPoint("BOTTOMLEFT", colorButton, "TOPRIGHT", 10, 2)
      textOverrideLabel:SetText("Custom Text:")
      Elysian.ApplyFont(textOverrideLabel, 10)
      Elysian.ApplyTextColor(textOverrideLabel)

      local textOverrideBox = CreateFrame("EditBox", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
      textOverrideBox:SetPoint("LEFT", colorButton, "RIGHT", 10, 0)
      textOverrideBox:SetSize(180, 22)
      textOverrideBox:SetAutoFocus(false)
      Elysian.SetBackdrop(textOverrideBox)
      Elysian.SetBackdropColors(textOverrideBox, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
      textOverrideBox:SetTextInsets(6, 6, 2, 2)
      textOverrideBox:SetText(Elysian.state.repairReminderTextOverride or "")
      Elysian.ApplyFont(textOverrideBox, 11, "OUTLINE")
      Elysian.ApplyTextColor(textOverrideBox)
      textOverrideBox:SetScript("OnEnterPressed", function(selfBox)
        selfBox:ClearFocus()
      end)
      textOverrideBox:SetScript("OnEditFocusLost", function(selfBox)
        Elysian.state.repairReminderTextOverride = selfBox:GetText() or ""
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.RepairReminder then
          Elysian.Features.RepairReminder:ApplyColors()
        end
      end)

      local bgButton = CreateFrame("Button", nil, panel, template)
      bgButton:SetPoint("TOPLEFT", colorButton, "BOTTOMLEFT", 0, -10)
      bgButton:SetSize(180, 22)
      Elysian.SetBackdrop(bgButton)
      Elysian.SetBackdropColors(bgButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local bgText = bgButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      bgText:SetPoint("CENTER")
      bgText:SetText("Background Color")
      Elysian.ApplyFont(bgText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(bgText)

      local bgSwatch = bgButton:CreateTexture(nil, "OVERLAY")
      bgSwatch:SetSize(12, 12)
      bgSwatch:SetPoint("RIGHT", -8, 0)
      local startBg = Elysian.state.repairReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
      bgSwatch:SetColorTexture(startBg[1], startBg[2], startBg[3], 1)

      bgButton:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.repairReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
        local function apply(r, g, b)
          Elysian.state.repairReminderBgColor = { r, g, b }
          bgSwatch:SetColorTexture(r, g, b, 1)
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
      HookButtonPressFeedback(bgButton)

      local alphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      alphaLabel:SetPoint("TOPLEFT", bgButton, "BOTTOMLEFT", 0, -12)
      alphaLabel:SetText("Transparency")
      Elysian.ApplyFont(alphaLabel, 11)
      Elysian.ApplyTextColor(alphaLabel)

      local alphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      alphaSlider:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 4, -26)
      alphaSlider:SetMinMaxValues(0.1, 1.0)
      alphaSlider:SetValueStep(0.05)
      alphaSlider:SetObeyStepOnDrag(true)
      alphaSlider:SetWidth(220)
      local alphaValue = Elysian.state.repairReminderAlpha or 0.95
      alphaSlider:SetValue(alphaValue)
      alphaSlider.Low:SetText("10%")
      alphaSlider.High:SetText("100%")
      alphaSlider.Text:SetText(string.format("%d%%", math.floor(alphaValue * 100 + 0.5)))
      alphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.max(0.1, math.min(1, value))
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
        Elysian.state.repairReminderAlpha = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.RepairReminder then
          Elysian.Features.RepairReminder:ApplyColors()
        end
      end)

      local widthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      widthLabel:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", -4, -20)
      widthLabel:SetText("Banner Width")
      Elysian.ApplyFont(widthLabel, 11)
      Elysian.ApplyTextColor(widthLabel)

      local widthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      widthSlider:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 4, -26)
      widthSlider:SetMinMaxValues(200, 600)
      widthSlider:SetValueStep(1)
      widthSlider:SetObeyStepOnDrag(true)
      widthSlider:SetWidth(220)
      local widthValue = Elysian.state.repairReminderWidth
      if not widthValue or widthValue <= 0 then
        widthValue = 360
      end
      widthSlider:SetValue(widthValue)
      widthSlider.Low:SetText("200")
      widthSlider.High:SetText("600")
      widthSlider.Text:SetText(string.format("%d", widthValue))
      widthSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.repairReminderWidth = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.RepairReminder then
          Elysian.Features.RepairReminder:ApplySize()
        end
      end)

      local heightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      heightLabel:SetPoint("TOPLEFT", widthSlider, "BOTTOMLEFT", -4, -20)
      heightLabel:SetText("Banner Height")
      Elysian.ApplyFont(heightLabel, 11)
      Elysian.ApplyTextColor(heightLabel)

      local heightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      heightSlider:SetPoint("TOPLEFT", heightLabel, "BOTTOMLEFT", 4, -26)
      heightSlider:SetMinMaxValues(30, 120)
      heightSlider:SetValueStep(1)
      heightSlider:SetObeyStepOnDrag(true)
      heightSlider:SetWidth(220)
      local heightValue = Elysian.state.repairReminderHeight
      if not heightValue or heightValue <= 0 then
        heightValue = 46
      end
      heightSlider:SetValue(heightValue)
      heightSlider.Low:SetText("30")
      heightSlider.High:SetText("120")
      heightSlider.Text:SetText(string.format("%d", heightValue))
      heightSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.repairReminderHeight = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.RepairReminder then
          Elysian.Features.RepairReminder:ApplySize()
        end
      end)

      local testBanner = CreateFrame("Button", nil, panel, template)
      testBanner:SetPoint("LEFT", bgButton, "RIGHT", 10, 0)
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

      local textOverrideLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      textOverrideLabel:SetPoint("BOTTOMLEFT", dungeonColor, "TOPRIGHT", 10, 2)
      textOverrideLabel:SetText("Custom Text:")
      Elysian.ApplyFont(textOverrideLabel, 10)
      Elysian.ApplyTextColor(textOverrideLabel)

      local textOverrideBox = CreateFrame("EditBox", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
      textOverrideBox:SetPoint("LEFT", dungeonColor, "RIGHT", 10, 0)
      textOverrideBox:SetSize(180, 22)
      textOverrideBox:SetAutoFocus(false)
      Elysian.SetBackdrop(textOverrideBox)
      Elysian.SetBackdropColors(textOverrideBox, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
      textOverrideBox:SetTextInsets(6, 6, 2, 2)
      textOverrideBox:SetText(Elysian.state.dungeonReminderTextOverride or "")
      Elysian.ApplyFont(textOverrideBox, 11, "OUTLINE")
      Elysian.ApplyTextColor(textOverrideBox)
      textOverrideBox:SetScript("OnEnterPressed", function(selfBox)
        selfBox:ClearFocus()
      end)
      textOverrideBox:SetScript("OnEditFocusLost", function(selfBox)
        Elysian.state.dungeonReminderTextOverride = selfBox:GetText() or ""
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.DungeonReminder then
          Elysian.Features.DungeonReminder:ApplyColors()
        end
      end)

      local dungeonBg = CreateFrame("Button", nil, panel, template)
      dungeonBg:SetPoint("TOPLEFT", dungeonColor, "BOTTOMLEFT", 0, -10)
      dungeonBg:SetSize(180, 22)
      Elysian.SetBackdrop(dungeonBg)
      Elysian.SetBackdropColors(dungeonBg, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local dungeonBgText = dungeonBg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      dungeonBgText:SetPoint("CENTER")
      dungeonBgText:SetText("Background Color")
      Elysian.ApplyFont(dungeonBgText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(dungeonBgText)

      local dungeonBgSwatch = dungeonBg:CreateTexture(nil, "OVERLAY")
      dungeonBgSwatch:SetSize(12, 12)
      dungeonBgSwatch:SetPoint("RIGHT", -8, 0)
      local dungeonBgStart = Elysian.state.dungeonReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
      dungeonBgSwatch:SetColorTexture(dungeonBgStart[1], dungeonBgStart[2], dungeonBgStart[3], 1)

      dungeonBg:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.dungeonReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
        local function apply(r, g, b)
          Elysian.state.dungeonReminderBgColor = { r, g, b }
          dungeonBgSwatch:SetColorTexture(r, g, b, 1)
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
      HookButtonPressFeedback(dungeonBg)

      local dungeonAlphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      dungeonAlphaLabel:SetPoint("TOPLEFT", dungeonBg, "BOTTOMLEFT", 0, -12)
      dungeonAlphaLabel:SetText("Transparency")
      Elysian.ApplyFont(dungeonAlphaLabel, 11)
      Elysian.ApplyTextColor(dungeonAlphaLabel)

      local dungeonAlphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      dungeonAlphaSlider:SetPoint("TOPLEFT", dungeonAlphaLabel, "BOTTOMLEFT", 4, -26)
      dungeonAlphaSlider:SetMinMaxValues(0.1, 1.0)
      dungeonAlphaSlider:SetValueStep(0.05)
      dungeonAlphaSlider:SetObeyStepOnDrag(true)
      dungeonAlphaSlider:SetWidth(220)
      local dungeonAlphaValue = Elysian.state.dungeonReminderAlpha or 0.95
      dungeonAlphaSlider:SetValue(dungeonAlphaValue)
      dungeonAlphaSlider.Low:SetText("10%")
      dungeonAlphaSlider.High:SetText("100%")
      dungeonAlphaSlider.Text:SetText(string.format("%d%%", math.floor(dungeonAlphaValue * 100 + 0.5)))
      dungeonAlphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.max(0.1, math.min(1, value))
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
        Elysian.state.dungeonReminderAlpha = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.DungeonReminder then
          Elysian.Features.DungeonReminder:ApplyColors()
        end
      end)

      local dungeonWidthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      dungeonWidthLabel:SetPoint("TOPLEFT", dungeonAlphaSlider, "BOTTOMLEFT", -4, -20)
      dungeonWidthLabel:SetText("Banner Width")
      Elysian.ApplyFont(dungeonWidthLabel, 11)
      Elysian.ApplyTextColor(dungeonWidthLabel)

      local dungeonWidthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      dungeonWidthSlider:SetPoint("TOPLEFT", dungeonWidthLabel, "BOTTOMLEFT", 4, -26)
      dungeonWidthSlider:SetMinMaxValues(200, 600)
      dungeonWidthSlider:SetValueStep(1)
      dungeonWidthSlider:SetObeyStepOnDrag(true)
      dungeonWidthSlider:SetWidth(220)
      local dungeonWidthValue = Elysian.state.dungeonReminderWidth
      if not dungeonWidthValue or dungeonWidthValue <= 0 then
        dungeonWidthValue = 360
      end
      dungeonWidthSlider:SetValue(dungeonWidthValue)
      dungeonWidthSlider.Low:SetText("200")
      dungeonWidthSlider.High:SetText("600")
      dungeonWidthSlider.Text:SetText(string.format("%d", dungeonWidthValue))
      dungeonWidthSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.dungeonReminderWidth = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.DungeonReminder then
          Elysian.Features.DungeonReminder:ApplySize()
        end
      end)

      local dungeonHeightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      dungeonHeightLabel:SetPoint("TOPLEFT", dungeonWidthSlider, "BOTTOMLEFT", -4, -20)
      dungeonHeightLabel:SetText("Banner Height")
      Elysian.ApplyFont(dungeonHeightLabel, 11)
      Elysian.ApplyTextColor(dungeonHeightLabel)

      local dungeonHeightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      dungeonHeightSlider:SetPoint("TOPLEFT", dungeonHeightLabel, "BOTTOMLEFT", 4, -26)
      dungeonHeightSlider:SetMinMaxValues(30, 120)
      dungeonHeightSlider:SetValueStep(1)
      dungeonHeightSlider:SetObeyStepOnDrag(true)
      dungeonHeightSlider:SetWidth(220)
      local dungeonHeightValue = Elysian.state.dungeonReminderHeight
      if not dungeonHeightValue or dungeonHeightValue <= 0 then
        dungeonHeightValue = 46
      end
      dungeonHeightSlider:SetValue(dungeonHeightValue)
      dungeonHeightSlider.Low:SetText("30")
      dungeonHeightSlider.High:SetText("120")
      dungeonHeightSlider.Text:SetText(string.format("%d", dungeonHeightValue))
      dungeonHeightSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.dungeonReminderHeight = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.DungeonReminder then
          Elysian.Features.DungeonReminder:ApplySize()
        end
      end)

      local dungeonTest = CreateFrame("Button", nil, panel, template)
      dungeonTest:SetPoint("LEFT", dungeonBg, "RIGHT", 10, 0)
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
      buffToggle:SetPoint("TOPLEFT", dungeonHeightSlider, "BOTTOMLEFT", -4, -20)
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

      local buffBg = CreateFrame("Button", nil, panel, template)
      buffBg:SetPoint("TOPLEFT", buffColor, "BOTTOMLEFT", 0, -10)
      buffBg:SetSize(180, 22)
      Elysian.SetBackdrop(buffBg)
      Elysian.SetBackdropColors(buffBg, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local buffBgText = buffBg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      buffBgText:SetPoint("CENTER")
      buffBgText:SetText("Background Color")
      Elysian.ApplyFont(buffBgText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(buffBgText)

      local buffBgSwatch = buffBg:CreateTexture(nil, "OVERLAY")
      buffBgSwatch:SetSize(12, 12)
      buffBgSwatch:SetPoint("RIGHT", -8, 0)
      local buffBgStart = Elysian.state.buffWatchBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
      buffBgSwatch:SetColorTexture(buffBgStart[1], buffBgStart[2], buffBgStart[3], 1)

      buffBg:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.buffWatchBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
        local function apply(r, g, b)
          Elysian.state.buffWatchBgColor = { r, g, b }
          buffBgSwatch:SetColorTexture(r, g, b, 1)
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
      HookButtonPressFeedback(buffBg)

      local buffAlphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      buffAlphaLabel:SetPoint("TOPLEFT", buffBg, "BOTTOMLEFT", 0, -12)
      buffAlphaLabel:SetText("Transparency")
      Elysian.ApplyFont(buffAlphaLabel, 11)
      Elysian.ApplyTextColor(buffAlphaLabel)

      local buffAlphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      buffAlphaSlider:SetPoint("TOPLEFT", buffAlphaLabel, "BOTTOMLEFT", 4, -26)
      buffAlphaSlider:SetMinMaxValues(0.1, 1.0)
      buffAlphaSlider:SetValueStep(0.05)
      buffAlphaSlider:SetObeyStepOnDrag(true)
      buffAlphaSlider:SetWidth(220)
      local buffAlphaValue = Elysian.state.buffWatchAlpha or 0.95
      buffAlphaSlider:SetValue(buffAlphaValue)
      buffAlphaSlider.Low:SetText("10%")
      buffAlphaSlider.High:SetText("100%")
      buffAlphaSlider.Text:SetText(string.format("%d%%", math.floor(buffAlphaValue * 100 + 0.5)))
      buffAlphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.max(0.1, math.min(1, value))
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
        Elysian.state.buffWatchAlpha = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.BuffWatch then
          Elysian.Features.BuffWatch:ApplyColors()
        end
      end)

      local buffWidthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      buffWidthLabel:SetPoint("TOPLEFT", buffAlphaSlider, "BOTTOMLEFT", -4, -20)
      buffWidthLabel:SetText("Banner Width")
      Elysian.ApplyFont(buffWidthLabel, 11)
      Elysian.ApplyTextColor(buffWidthLabel)

      local buffWidthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      buffWidthSlider:SetPoint("TOPLEFT", buffWidthLabel, "BOTTOMLEFT", 4, -26)
      buffWidthSlider:SetMinMaxValues(200, 600)
      buffWidthSlider:SetValueStep(1)
      buffWidthSlider:SetObeyStepOnDrag(true)
      buffWidthSlider:SetWidth(220)
      local buffWidthValue = Elysian.state.buffWatchWidth
      if not buffWidthValue or buffWidthValue <= 0 then
        buffWidthValue = 420
      end
      buffWidthSlider:SetValue(buffWidthValue)
      buffWidthSlider.Low:SetText("200")
      buffWidthSlider.High:SetText("600")
      buffWidthSlider.Text:SetText(string.format("%d", buffWidthValue))
      buffWidthSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.buffWatchWidth = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.BuffWatch then
          Elysian.Features.BuffWatch:ApplySize()
        end
      end)

      local buffHeightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      buffHeightLabel:SetPoint("TOPLEFT", buffWidthSlider, "BOTTOMLEFT", -4, -20)
      buffHeightLabel:SetText("Banner Height")
      Elysian.ApplyFont(buffHeightLabel, 11)
      Elysian.ApplyTextColor(buffHeightLabel)

      local buffHeightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      buffHeightSlider:SetPoint("TOPLEFT", buffHeightLabel, "BOTTOMLEFT", 4, -26)
      buffHeightSlider:SetMinMaxValues(30, 120)
      buffHeightSlider:SetValueStep(1)
      buffHeightSlider:SetObeyStepOnDrag(true)
      buffHeightSlider:SetWidth(220)
      local buffHeightValue = Elysian.state.buffWatchHeight
      if not buffHeightValue or buffHeightValue <= 0 then
        buffHeightValue = 52
      end
      buffHeightSlider:SetValue(buffHeightValue)
      buffHeightSlider.Low:SetText("30")
      buffHeightSlider.High:SetText("120")
      buffHeightSlider.Text:SetText(string.format("%d", buffHeightValue))
      buffHeightSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.buffWatchHeight = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.BuffWatch then
          Elysian.Features.BuffWatch:ApplySize()
        end
      end)

      local buffTest = CreateFrame("Button", nil, panel, template)
      buffTest:SetPoint("LEFT", buffBg, "RIGHT", 10, 0)
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
      consumableToggle:SetPoint("TOPLEFT", buffHeightSlider, "BOTTOMLEFT", -4, -20)
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

      local consumableBg = CreateFrame("Button", nil, panel, template)
      consumableBg:SetPoint("TOPLEFT", consumableColor, "BOTTOMLEFT", 0, -10)
      consumableBg:SetSize(180, 22)
      Elysian.SetBackdrop(consumableBg)
      Elysian.SetBackdropColors(consumableBg, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local consumableBgText = consumableBg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      consumableBgText:SetPoint("CENTER")
      consumableBgText:SetText("Background Color")
      Elysian.ApplyFont(consumableBgText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(consumableBgText)

      local consumableBgSwatch = consumableBg:CreateTexture(nil, "OVERLAY")
      consumableBgSwatch:SetSize(12, 12)
      consumableBgSwatch:SetPoint("RIGHT", -8, 0)
      local consumableBgStart = Elysian.state.dungeonConsumablesBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
      consumableBgSwatch:SetColorTexture(consumableBgStart[1], consumableBgStart[2], consumableBgStart[3], 1)

      consumableBg:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.dungeonConsumablesBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
        local function apply(r, g, b)
          Elysian.state.dungeonConsumablesBgColor = { r, g, b }
          consumableBgSwatch:SetColorTexture(r, g, b, 1)
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
      HookButtonPressFeedback(consumableBg)

      local consumableAlphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      consumableAlphaLabel:SetPoint("TOPLEFT", consumableBg, "BOTTOMLEFT", 0, -12)
      consumableAlphaLabel:SetText("Transparency")
      Elysian.ApplyFont(consumableAlphaLabel, 11)
      Elysian.ApplyTextColor(consumableAlphaLabel)

      local consumableAlphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      consumableAlphaSlider:SetPoint("TOPLEFT", consumableAlphaLabel, "BOTTOMLEFT", 4, -26)
      consumableAlphaSlider:SetMinMaxValues(0.1, 1.0)
      consumableAlphaSlider:SetValueStep(0.05)
      consumableAlphaSlider:SetObeyStepOnDrag(true)
      consumableAlphaSlider:SetWidth(220)
      local consumableAlphaValue = Elysian.state.dungeonConsumablesAlpha or 0.95
      consumableAlphaSlider:SetValue(consumableAlphaValue)
      consumableAlphaSlider.Low:SetText("10%")
      consumableAlphaSlider.High:SetText("100%")
      consumableAlphaSlider.Text:SetText(string.format("%d%%", math.floor(consumableAlphaValue * 100 + 0.5)))
      consumableAlphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.max(0.1, math.min(1, value))
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
        Elysian.state.dungeonConsumablesAlpha = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.DungeonConsumables then
          Elysian.Features.DungeonConsumables:ApplyColors()
        end
      end)

      local consumableWidthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      consumableWidthLabel:SetPoint("TOPLEFT", consumableAlphaSlider, "BOTTOMLEFT", -4, -20)
      consumableWidthLabel:SetText("Banner Width")
      Elysian.ApplyFont(consumableWidthLabel, 11)
      Elysian.ApplyTextColor(consumableWidthLabel)

      local consumableWidthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      consumableWidthSlider:SetPoint("TOPLEFT", consumableWidthLabel, "BOTTOMLEFT", 4, -26)
      consumableWidthSlider:SetMinMaxValues(200, 600)
      consumableWidthSlider:SetValueStep(1)
      consumableWidthSlider:SetObeyStepOnDrag(true)
      consumableWidthSlider:SetWidth(220)
      local consumableWidthValue = Elysian.state.dungeonConsumablesWidth
      if not consumableWidthValue or consumableWidthValue <= 0 then
        consumableWidthValue = 420
      end
      consumableWidthSlider:SetValue(consumableWidthValue)
      consumableWidthSlider.Low:SetText("200")
      consumableWidthSlider.High:SetText("600")
      consumableWidthSlider.Text:SetText(string.format("%d", consumableWidthValue))
      consumableWidthSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.dungeonConsumablesWidth = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.DungeonConsumables then
          Elysian.Features.DungeonConsumables:ApplySize()
        end
      end)

      local consumableHeightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      consumableHeightLabel:SetPoint("TOPLEFT", consumableWidthSlider, "BOTTOMLEFT", -4, -20)
      consumableHeightLabel:SetText("Banner Height")
      Elysian.ApplyFont(consumableHeightLabel, 11)
      Elysian.ApplyTextColor(consumableHeightLabel)

      local consumableHeightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      consumableHeightSlider:SetPoint("TOPLEFT", consumableHeightLabel, "BOTTOMLEFT", 4, -26)
      consumableHeightSlider:SetMinMaxValues(30, 120)
      consumableHeightSlider:SetValueStep(1)
      consumableHeightSlider:SetObeyStepOnDrag(true)
      consumableHeightSlider:SetWidth(220)
      local consumableHeightValue = Elysian.state.dungeonConsumablesHeight
      if not consumableHeightValue or consumableHeightValue <= 0 then
        consumableHeightValue = 52
      end
      consumableHeightSlider:SetValue(consumableHeightValue)
      consumableHeightSlider.Low:SetText("30")
      consumableHeightSlider.High:SetText("120")
      consumableHeightSlider.Text:SetText(string.format("%d", consumableHeightValue))
      consumableHeightSlider:SetScript("OnValueChanged", function(selfSlider, value)
        value = math.floor(value + 0.5)
        selfSlider:SetValue(value)
        selfSlider.Text:SetText(string.format("%d", value))
        Elysian.state.dungeonConsumablesHeight = value
        if Elysian.SaveState then
          Elysian.SaveState()
        end
        if Elysian.Features and Elysian.Features.DungeonConsumables then
          Elysian.Features.DungeonConsumables:ApplySize()
        end
      end)

      local consumableTest = CreateFrame("Button", nil, panel, template)
      consumableTest:SetPoint("LEFT", consumableBg, "RIGHT", 10, 0)
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

      local keystoneToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
      keystoneToggle:SetPoint("TOPLEFT", consumableHeightSlider, "BOTTOMLEFT", -4, -20)
      keystoneToggle.text = keystoneToggle.text or _G[keystoneToggle:GetName() .. "Text"]
      keystoneToggle.text:SetText("Enable keystone reminder")
      Elysian.ApplyFont(keystoneToggle.text, 12)
      Elysian.ApplyTextColor(keystoneToggle.text)
      Elysian.StyleCheckbox(keystoneToggle)
      keystoneToggle:SetChecked(Elysian.state.keystoneReminderEnabled)
      keystoneToggle:SetScript("OnClick", function(selfButton)
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        Elysian.state.keystoneReminderEnabled = selfButton:GetChecked()
        if Elysian.Features and Elysian.Features.KeystoneReminder then
          Elysian.Features.KeystoneReminder:SetEnabled(selfButton:GetChecked())
        end
        if Elysian.SaveState then
          Elysian.SaveState()
        end
      end)

      local keystoneColor = CreateFrame("Button", nil, panel, template)
      keystoneColor:SetPoint("TOPLEFT", keystoneToggle, "BOTTOMLEFT", 0, -12)
      keystoneColor:SetSize(180, 22)
      Elysian.SetBackdrop(keystoneColor)
      Elysian.SetBackdropColors(keystoneColor, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local keystoneColorText = keystoneColor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      keystoneColorText:SetPoint("CENTER")
      keystoneColorText:SetText("Text Color")
      Elysian.ApplyFont(keystoneColorText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(keystoneColorText)

      local keystoneSwatch = keystoneColor:CreateTexture(nil, "OVERLAY")
      keystoneSwatch:SetSize(12, 12)
      keystoneSwatch:SetPoint("RIGHT", -8, 0)
      local keystoneStart = Elysian.state.keystoneReminderTextColor or { 1, 1, 1 }
      keystoneSwatch:SetColorTexture(keystoneStart[1], keystoneStart[2], keystoneStart[3], 1)

      keystoneColor:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.keystoneReminderTextColor or { 1, 1, 1 }
        Elysian.OpenColorPicker(color, function(r, g, b)
          Elysian.state.keystoneReminderTextColor = { r, g, b }
          keystoneSwatch:SetColorTexture(r, g, b, 1)
          if Elysian.Features and Elysian.Features.KeystoneReminder then
            Elysian.Features.KeystoneReminder:ApplyColors()
          end
          if Elysian.SaveState then
            Elysian.SaveState()
          end
        end)
      end)
      HookButtonPressFeedback(keystoneColor)

      local keystoneBg = CreateFrame("Button", nil, panel, template)
      keystoneBg:SetPoint("TOPLEFT", keystoneColor, "BOTTOMLEFT", 0, -10)
      keystoneBg:SetSize(180, 22)
      Elysian.SetBackdrop(keystoneBg)
      Elysian.SetBackdropColors(keystoneBg, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local keystoneBgText = keystoneBg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      keystoneBgText:SetPoint("CENTER")
      keystoneBgText:SetText("Background Color")
      Elysian.ApplyFont(keystoneBgText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(keystoneBgText)

      local keystoneBgSwatch = keystoneBg:CreateTexture(nil, "OVERLAY")
      keystoneBgSwatch:SetSize(12, 12)
      keystoneBgSwatch:SetPoint("RIGHT", -8, 0)
      local keystoneBgStart = Elysian.state.keystoneReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
      keystoneBgSwatch:SetColorTexture(keystoneBgStart[1], keystoneBgStart[2], keystoneBgStart[3], 1)

      keystoneBg:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local color = Elysian.state.keystoneReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
        Elysian.OpenColorPicker(color, function(r, g, b)
          Elysian.state.keystoneReminderBgColor = { r, g, b }
          keystoneBgSwatch:SetColorTexture(r, g, b, 1)
          if Elysian.Features and Elysian.Features.KeystoneReminder then
            Elysian.Features.KeystoneReminder:ApplyColors()
          end
          if Elysian.SaveState then
            Elysian.SaveState()
          end
        end)
      end)
      HookButtonPressFeedback(keystoneBg)

      local keystoneAlphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      keystoneAlphaLabel:SetPoint("TOPLEFT", keystoneBg, "BOTTOMLEFT", 0, -12)
      keystoneAlphaLabel:SetText("Transparency")
      Elysian.ApplyFont(keystoneAlphaLabel, 11)
      Elysian.ApplyTextColor(keystoneAlphaLabel)

      local keystoneAlphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      keystoneAlphaSlider:SetPoint("TOPLEFT", keystoneAlphaLabel, "BOTTOMLEFT", 4, -26)
      keystoneAlphaSlider:SetMinMaxValues(0.1, 1.0)
      keystoneAlphaSlider:SetValueStep(0.05)
      keystoneAlphaSlider:SetObeyStepOnDrag(true)
      keystoneAlphaSlider:SetWidth(220)
      local keystoneAlphaValue = Elysian.state.keystoneReminderAlpha or 0.95
      keystoneAlphaSlider:SetValue(keystoneAlphaValue)
      keystoneAlphaSlider.Low:SetText("10%")
      keystoneAlphaSlider.High:SetText("100%")
      keystoneAlphaSlider.Text:SetText(string.format("%d%%", math.floor(keystoneAlphaValue * 100 + 0.5)))
      keystoneAlphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
        if not Elysian.state then
          return
        end
        Elysian.state.keystoneReminderAlpha = value
        selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
        if Elysian.Features and Elysian.Features.KeystoneReminder then
          Elysian.Features.KeystoneReminder:ApplyColors()
        end
        if Elysian.SaveState then
          Elysian.SaveState()
        end
      end)

      local keystoneWidthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      keystoneWidthLabel:SetPoint("TOPLEFT", keystoneAlphaSlider, "BOTTOMLEFT", -4, -20)
      keystoneWidthLabel:SetText("Banner Width")
      Elysian.ApplyFont(keystoneWidthLabel, 11)
      Elysian.ApplyTextColor(keystoneWidthLabel)

      local keystoneWidthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      keystoneWidthSlider:SetPoint("TOPLEFT", keystoneWidthLabel, "BOTTOMLEFT", 4, -26)
      keystoneWidthSlider:SetMinMaxValues(200, 600)
      keystoneWidthSlider:SetValueStep(1)
      keystoneWidthSlider:SetObeyStepOnDrag(true)
      keystoneWidthSlider:SetWidth(220)
      local keystoneWidthValue = Elysian.state.keystoneReminderWidth
      if not keystoneWidthValue or keystoneWidthValue <= 0 then
        keystoneWidthValue = 360
      end
      keystoneWidthSlider:SetValue(keystoneWidthValue)
      keystoneWidthSlider.Low:SetText("200")
      keystoneWidthSlider.High:SetText("600")
      keystoneWidthSlider.Text:SetText(string.format("%d", keystoneWidthValue))
      keystoneWidthSlider:SetScript("OnValueChanged", function(selfSlider, value)
        if not Elysian.state then
          return
        end
        Elysian.state.keystoneReminderWidth = value
        selfSlider.Text:SetText(string.format("%d", value))
        if Elysian.Features and Elysian.Features.KeystoneReminder then
          Elysian.Features.KeystoneReminder:ApplySize()
        end
        if Elysian.SaveState then
          Elysian.SaveState()
        end
      end)

      local keystoneHeightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      keystoneHeightLabel:SetPoint("TOPLEFT", keystoneWidthSlider, "BOTTOMLEFT", -4, -20)
      keystoneHeightLabel:SetText("Banner Height")
      Elysian.ApplyFont(keystoneHeightLabel, 11)
      Elysian.ApplyTextColor(keystoneHeightLabel)

      local keystoneHeightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
      keystoneHeightSlider:SetPoint("TOPLEFT", keystoneHeightLabel, "BOTTOMLEFT", 4, -26)
      keystoneHeightSlider:SetMinMaxValues(30, 120)
      keystoneHeightSlider:SetValueStep(1)
      keystoneHeightSlider:SetObeyStepOnDrag(true)
      keystoneHeightSlider:SetWidth(220)
      local keystoneHeightValue = Elysian.state.keystoneReminderHeight
      if not keystoneHeightValue or keystoneHeightValue <= 0 then
        keystoneHeightValue = 46
      end
      keystoneHeightSlider:SetValue(keystoneHeightValue)
      keystoneHeightSlider.Low:SetText("30")
      keystoneHeightSlider.High:SetText("120")
      keystoneHeightSlider.Text:SetText(string.format("%d", keystoneHeightValue))
      keystoneHeightSlider:SetScript("OnValueChanged", function(selfSlider, value)
        if not Elysian.state then
          return
        end
        Elysian.state.keystoneReminderHeight = value
        selfSlider.Text:SetText(string.format("%d", value))
        if Elysian.Features and Elysian.Features.KeystoneReminder then
          Elysian.Features.KeystoneReminder:ApplySize()
        end
        if Elysian.SaveState then
          Elysian.SaveState()
        end
      end)

      local keystoneTest = CreateFrame("Button", nil, panel, template)
      keystoneTest:SetPoint("LEFT", keystoneBg, "RIGHT", 10, 0)
      keystoneTest:SetSize(120, 22)
      Elysian.SetBackdrop(keystoneTest)
      Elysian.SetBackdropColors(keystoneTest, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

      local keystoneTestText = keystoneTest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      keystoneTestText:SetPoint("CENTER")
      keystoneTestText:SetText("Test Banner")
      Elysian.ApplyFont(keystoneTestText, 11, "OUTLINE")
      Elysian.ApplyAccentColor(keystoneTestText)

      local function UpdateKeystoneTestStyle(active)
        local bg = active and { Elysian.HexToRGB("#e6e6e6") } or Elysian.GetNavBg()
        Elysian.SetBackdropColors(keystoneTest, bg, Elysian.GetThemeBorder(), 0.9)
      end
      UpdateKeystoneTestStyle(Elysian.state.keystoneReminderTest)
      keystoneTest:SetScript("OnClick", function()
        if Elysian.ClickFeedback then
          Elysian.ClickFeedback()
        end
        local enabled = not Elysian.state.keystoneReminderTest
        Elysian.state.keystoneReminderTest = enabled
        UpdateKeystoneTestStyle(enabled)
        if Elysian.Features and Elysian.Features.KeystoneReminder then
          Elysian.Features.KeystoneReminder:SetTestEnabled(enabled)
        end
        if Elysian.SaveState then
          Elysian.SaveState()
        end
      end)
      HookButtonPressFeedback(keystoneTest)

      rootPanel._dungeonLastWidget = keystoneHeightSlider

    end

    table.insert(alertPanels, rootPanel)
  end
  for _, t in ipairs(alertTabs) do
    t:Hide()
  end

  local classAlertTabs = {}
  local classAlertPanels = {}

  local classTabOrder = {
    "DRUID",
    "EVOKER",
    "HUNTER",
    "MAGE",
    "PRIEST",
    "ROGUE",
    "SHAMAN",
    "WARLOCK",
    "WARRIOR",
  }
  if not (Elysian.state and Elysian.state.showAllClassAlerts) then
    local _, playerClass = UnitClass("player")
    if playerClass then
      classTabOrder = { playerClass }
    end
  end

  local row1Count = 6
  local tabWidth = 110
  local tabHeight = 20
  local tabSpacing = 8
  local rowYOffset = -24

  local function CreateClassTab(name, index)
    local tab = CreateTabButton(subHeader, name, tabWidth, tabHeight)
    if RAID_CLASS_COLORS and RAID_CLASS_COLORS[name] and tab.text then
      local c = RAID_CLASS_COLORS[name]
      tab.text:SetTextColor(c.r, c.g, c.b)
      tab.classColor = { c.r, c.g, c.b }
    end
    local row = index <= row1Count and 1 or 2
    local col = row == 1 and index or (index - row1Count)
    local x = 10 + (col - 1) * (tabWidth + tabSpacing)
    local y = (row == 1) and 8 or rowYOffset
    tab:SetPoint("LEFT", x, y)
    table.insert(classAlertTabs, tab)
    return tab
  end

  local function CreateClassPanel()
    local rootPanel = CreateFrame("Frame", nil, contentBody)
    rootPanel:SetPoint("TOPLEFT", 12, -12)
    rootPanel:SetPoint("TOPRIGHT", -12, -12)
    rootPanel:SetHeight(880)
    rootPanel:SetClipsChildren(true)

    local scrollFrame = CreateFrame("ScrollFrame", nil, rootPanel)
    scrollFrame:SetPoint("TOPLEFT", 4, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -4, 4)
    scrollFrame:SetClipsChildren(true)
    scrollFrame:EnableMouseWheel(true)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetPoint("TOPLEFT", 0, 0)
    scrollChild:SetPoint("TOPRIGHT", 0, 0)
    scrollChild:SetHeight(1400)
    scrollFrame:SetScrollChild(scrollChild)

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
      scrollChild:SetWidth(width)
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

    rootPanel.scrollFrame = scrollFrame
    rootPanel.scrollChild = scrollChild
    table.insert(classAlertPanels, rootPanel)
    return scrollChild
  end

  local function BuildWarlockPanel(panel)
  local classAlertsTitle = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  classAlertsTitle:SetPoint("TOPLEFT", 8, -8)
  classAlertsTitle:SetText("Warlock Alerts")
  Elysian.ApplyFont(classAlertsTitle, 13, "OUTLINE")
  Elysian.ApplyTextColor(classAlertsTitle)

  local classAlertsHint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  classAlertsHint:SetPoint("TOPLEFT", classAlertsTitle, "BOTTOMLEFT", 0, -6)
  classAlertsHint:SetText("")
  Elysian.ApplyFont(classAlertsHint, 10)
  Elysian.ApplyTextColor(classAlertsHint)

  local petToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
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

  local petColorButton = CreateFrame("Button", nil, panel, template)
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

  local petBgButton = CreateFrame("Button", nil, panel, template)
  petBgButton:SetPoint("TOPLEFT", petColorButton, "BOTTOMLEFT", 0, -10)
  petBgButton:SetSize(180, 22)
  Elysian.SetBackdrop(petBgButton)
  Elysian.SetBackdropColors(petBgButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local petBgText = petBgButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  petBgText:SetPoint("CENTER")
  petBgText:SetText("Background Color")
  Elysian.ApplyFont(petBgText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(petBgText)

  local petBgSwatch = petBgButton:CreateTexture(nil, "OVERLAY")
  petBgSwatch:SetSize(12, 12)
  petBgSwatch:SetPoint("RIGHT", -8, 0)
  local petBgStart = Elysian.state.warlockPetReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  petBgSwatch:SetColorTexture(petBgStart[1], petBgStart[2], petBgStart[3], 1)

  petBgButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = Elysian.state.warlockPetReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
    local function apply(r, g, b)
      Elysian.state.warlockPetReminderBgColor = { r, g, b }
      petBgSwatch:SetColorTexture(r, g, b, 1)
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
  HookButtonPressFeedback(petBgButton)

  local petAlphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  petAlphaLabel:SetPoint("TOPLEFT", petBgButton, "BOTTOMLEFT", 0, -12)
  petAlphaLabel:SetText("Transparency")
  Elysian.ApplyFont(petAlphaLabel, 11)
  Elysian.ApplyTextColor(petAlphaLabel)

  local petAlphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  petAlphaSlider:SetPoint("TOPLEFT", petAlphaLabel, "BOTTOMLEFT", 4, -26)
  petAlphaSlider:SetMinMaxValues(0.1, 1.0)
  petAlphaSlider:SetValueStep(0.05)
  petAlphaSlider:SetObeyStepOnDrag(true)
  petAlphaSlider:SetWidth(220)
  local petAlphaValue = Elysian.state.warlockPetReminderAlpha or 0.95
  petAlphaSlider:SetValue(petAlphaValue)
  petAlphaSlider.Low:SetText("10%")
  petAlphaSlider.High:SetText("100%")
  petAlphaSlider.Text:SetText(string.format("%d%%", math.floor(petAlphaValue * 100 + 0.5)))
  petAlphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
    value = math.max(0.1, math.min(1, value))
    selfSlider:SetValue(value)
    selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
    Elysian.state.warlockPetReminderAlpha = value
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplyColors()
    end
  end)

  local petWidthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  petWidthLabel:SetPoint("TOPLEFT", petAlphaSlider, "BOTTOMLEFT", -4, -20)
  petWidthLabel:SetText("Banner Width")
  Elysian.ApplyFont(petWidthLabel, 11)
  Elysian.ApplyTextColor(petWidthLabel)

  local petWidthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  petWidthSlider:SetPoint("TOPLEFT", petWidthLabel, "BOTTOMLEFT", 4, -26)
  petWidthSlider:SetMinMaxValues(200, 600)
  petWidthSlider:SetValueStep(1)
  petWidthSlider:SetObeyStepOnDrag(true)
  petWidthSlider:SetWidth(220)
  local petWidthValue = Elysian.state.warlockPetReminderWidth
  if not petWidthValue or petWidthValue <= 0 then
    petWidthValue = 360
  end
  petWidthSlider:SetValue(petWidthValue)
  petWidthSlider.Low:SetText("200")
  petWidthSlider.High:SetText("600")
  petWidthSlider.Text:SetText(string.format("%d", petWidthValue))
  petWidthSlider:SetScript("OnValueChanged", function(selfSlider, value)
    value = math.floor(value + 0.5)
    selfSlider:SetValue(value)
    selfSlider.Text:SetText(string.format("%d", value))
    Elysian.state.warlockPetReminderWidth = value
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplySize()
    end
  end)

  local petHeightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  petHeightLabel:SetPoint("TOPLEFT", petWidthSlider, "BOTTOMLEFT", -4, -20)
  petHeightLabel:SetText("Banner Height")
  Elysian.ApplyFont(petHeightLabel, 11)
  Elysian.ApplyTextColor(petHeightLabel)

  local petHeightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  petHeightSlider:SetPoint("TOPLEFT", petHeightLabel, "BOTTOMLEFT", 4, -26)
  petHeightSlider:SetMinMaxValues(30, 120)
  petHeightSlider:SetValueStep(1)
  petHeightSlider:SetObeyStepOnDrag(true)
  petHeightSlider:SetWidth(220)
  local petHeightValue = Elysian.state.warlockPetReminderHeight
  if not petHeightValue or petHeightValue <= 0 then
    petHeightValue = 46
  end
  petHeightSlider:SetValue(petHeightValue)
  petHeightSlider.Low:SetText("30")
  petHeightSlider.High:SetText("120")
  petHeightSlider.Text:SetText(string.format("%d", petHeightValue))
  petHeightSlider:SetScript("OnValueChanged", function(selfSlider, value)
    value = math.floor(value + 0.5)
    selfSlider:SetValue(value)
    selfSlider.Text:SetText(string.format("%d", value))
    Elysian.state.warlockPetReminderHeight = value
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplySize()
    end
  end)

  local petTest = CreateFrame("Button", nil, panel, template)
  petTest:SetPoint("LEFT", petBgButton, "RIGHT", 10, 0)
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

  local stoneToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  stoneToggle:SetPoint("TOPLEFT", petHeightSlider, "BOTTOMLEFT", -4, -20)
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

  local stoneColorButton = CreateFrame("Button", nil, panel, template)
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

  local stoneBgButton = CreateFrame("Button", nil, panel, template)
  stoneBgButton:SetPoint("TOPLEFT", stoneColorButton, "BOTTOMLEFT", 0, -10)
  stoneBgButton:SetSize(180, 22)
  Elysian.SetBackdrop(stoneBgButton)
  Elysian.SetBackdropColors(stoneBgButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local stoneBgText = stoneBgButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stoneBgText:SetPoint("CENTER")
  stoneBgText:SetText("Background Color")
  Elysian.ApplyFont(stoneBgText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(stoneBgText)

  local stoneBgSwatch = stoneBgButton:CreateTexture(nil, "OVERLAY")
  stoneBgSwatch:SetSize(12, 12)
  stoneBgSwatch:SetPoint("RIGHT", -8, 0)
  local stoneBgStart = Elysian.state.warlockStoneReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  stoneBgSwatch:SetColorTexture(stoneBgStart[1], stoneBgStart[2], stoneBgStart[3], 1)

  stoneBgButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = Elysian.state.warlockStoneReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
    local function apply(r, g, b)
      Elysian.state.warlockStoneReminderBgColor = { r, g, b }
      stoneBgSwatch:SetColorTexture(r, g, b, 1)
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
  HookButtonPressFeedback(stoneBgButton)

  local stoneAlphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stoneAlphaLabel:SetPoint("TOPLEFT", stoneBgButton, "BOTTOMLEFT", 0, -12)
  stoneAlphaLabel:SetText("Transparency")
  Elysian.ApplyFont(stoneAlphaLabel, 11)
  Elysian.ApplyTextColor(stoneAlphaLabel)

  local stoneAlphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  stoneAlphaSlider:SetPoint("TOPLEFT", stoneAlphaLabel, "BOTTOMLEFT", 4, -26)
  stoneAlphaSlider:SetMinMaxValues(0.1, 1.0)
  stoneAlphaSlider:SetValueStep(0.05)
  stoneAlphaSlider:SetObeyStepOnDrag(true)
  stoneAlphaSlider:SetWidth(220)
  local stoneAlphaValue = Elysian.state.warlockStoneReminderAlpha or 0.95
  stoneAlphaSlider:SetValue(stoneAlphaValue)
  stoneAlphaSlider.Low:SetText("10%")
  stoneAlphaSlider.High:SetText("100%")
  stoneAlphaSlider.Text:SetText(string.format("%d%%", math.floor(stoneAlphaValue * 100 + 0.5)))
  stoneAlphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
    value = math.max(0.1, math.min(1, value))
    selfSlider:SetValue(value)
    selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
    Elysian.state.warlockStoneReminderAlpha = value
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplyColors()
    end
  end)

  local stoneWidthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stoneWidthLabel:SetPoint("TOPLEFT", stoneAlphaSlider, "BOTTOMLEFT", -4, -20)
  stoneWidthLabel:SetText("Banner Width")
  Elysian.ApplyFont(stoneWidthLabel, 11)
  Elysian.ApplyTextColor(stoneWidthLabel)

  local stoneWidthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  stoneWidthSlider:SetPoint("TOPLEFT", stoneWidthLabel, "BOTTOMLEFT", 4, -26)
  stoneWidthSlider:SetMinMaxValues(200, 600)
  stoneWidthSlider:SetValueStep(1)
  stoneWidthSlider:SetObeyStepOnDrag(true)
  stoneWidthSlider:SetWidth(220)
  local stoneWidthValue = Elysian.state.warlockStoneReminderWidth
  if not stoneWidthValue or stoneWidthValue <= 0 then
    stoneWidthValue = 360
  end
  stoneWidthSlider:SetValue(stoneWidthValue)
  stoneWidthSlider.Low:SetText("200")
  stoneWidthSlider.High:SetText("600")
  stoneWidthSlider.Text:SetText(string.format("%d", stoneWidthValue))
  stoneWidthSlider:SetScript("OnValueChanged", function(selfSlider, value)
    value = math.floor(value + 0.5)
    selfSlider:SetValue(value)
    selfSlider.Text:SetText(string.format("%d", value))
    Elysian.state.warlockStoneReminderWidth = value
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplySize()
    end
  end)

  local stoneHeightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stoneHeightLabel:SetPoint("TOPLEFT", stoneWidthSlider, "BOTTOMLEFT", -4, -20)
  stoneHeightLabel:SetText("Banner Height")
  Elysian.ApplyFont(stoneHeightLabel, 11)
  Elysian.ApplyTextColor(stoneHeightLabel)

  local stoneHeightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  stoneHeightSlider:SetPoint("TOPLEFT", stoneHeightLabel, "BOTTOMLEFT", 4, -26)
  stoneHeightSlider:SetMinMaxValues(30, 120)
  stoneHeightSlider:SetValueStep(1)
  stoneHeightSlider:SetObeyStepOnDrag(true)
  stoneHeightSlider:SetWidth(220)
  local stoneHeightValue = Elysian.state.warlockStoneReminderHeight
  if not stoneHeightValue or stoneHeightValue <= 0 then
    stoneHeightValue = 46
  end
  stoneHeightSlider:SetValue(stoneHeightValue)
  stoneHeightSlider.Low:SetText("30")
  stoneHeightSlider.High:SetText("120")
  stoneHeightSlider.Text:SetText(string.format("%d", stoneHeightValue))
  stoneHeightSlider:SetScript("OnValueChanged", function(selfSlider, value)
    value = math.floor(value + 0.5)
    selfSlider:SetValue(value)
    selfSlider.Text:SetText(string.format("%d", value))
    Elysian.state.warlockStoneReminderHeight = value
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplySize()
    end
  end)

  local stoneTest = CreateFrame("Button", nil, panel, template)
  stoneTest:SetPoint("LEFT", stoneBgButton, "RIGHT", 10, 0)
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

  local rushToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  rushToggle:SetPoint("TOPLEFT", stoneHeightSlider, "BOTTOMLEFT", -4, -24)
  rushToggle.text = rushToggle.text or _G[rushToggle:GetName() .. "Text"]
  rushToggle.text:SetText("Enable Burning Rush warning")
  Elysian.ApplyFont(rushToggle.text, 12)
  Elysian.ApplyTextColor(rushToggle.text)
  Elysian.StyleCheckbox(rushToggle)
  rushToggle:SetChecked(Elysian.state.warlockRushReminderEnabled)
  rushToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:SetRushEnabled(selfButton:GetChecked())
    end
  end)

  local rushBgToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  rushBgToggle:SetPoint("TOPLEFT", rushToggle, "BOTTOMLEFT", 0, -12)
  rushBgToggle.text = rushBgToggle.text or _G[rushBgToggle:GetName() .. "Text"]
  rushBgToggle.text:SetText("Show background")
  Elysian.ApplyFont(rushBgToggle.text, 12)
  Elysian.ApplyTextColor(rushBgToggle.text)
  Elysian.StyleCheckbox(rushBgToggle)
  rushBgToggle:SetChecked(Elysian.state.warlockRushReminderShowBg)
  rushBgToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.warlockRushReminderShowBg = selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplyColors()
    end
  end)

  local rushFlashToggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  rushFlashToggle:SetPoint("TOPLEFT", rushBgToggle, "BOTTOMLEFT", 0, -12)
  rushFlashToggle.text = rushFlashToggle.text or _G[rushFlashToggle:GetName() .. "Text"]
  rushFlashToggle.text:SetText("Flash colors")
  Elysian.ApplyFont(rushFlashToggle.text, 12)
  Elysian.ApplyTextColor(rushFlashToggle.text)
  Elysian.StyleCheckbox(rushFlashToggle)
  rushFlashToggle:SetChecked(Elysian.state.warlockRushReminderFlash ~= false)
  rushFlashToggle:SetScript("OnClick", function(selfButton)
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    Elysian.state.warlockRushReminderFlash = selfButton:GetChecked()
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplyColors()
      Elysian.Features.WarlockReminders:UpdateVisibility(true)
      if Elysian.state.warlockRushReminderFlash then
        Elysian.Features.WarlockReminders:StartRushFlash()
      end
    end
  end)

  local rushColorButton = CreateFrame("Button", nil, panel, template)
  rushColorButton:SetPoint("TOPLEFT", rushFlashToggle, "BOTTOMLEFT", 0, -12)
  rushColorButton:SetSize(180, 22)
  Elysian.SetBackdrop(rushColorButton)
  Elysian.SetBackdropColors(rushColorButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local rushColorText = rushColorButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  rushColorText:SetPoint("CENTER")
  rushColorText:SetText("Text Color")
  Elysian.ApplyFont(rushColorText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(rushColorText)

  local rushSwatch = rushColorButton:CreateTexture(nil, "OVERLAY")
  rushSwatch:SetSize(12, 12)
  rushSwatch:SetPoint("RIGHT", -8, 0)
  local rushStart = Elysian.state.warlockRushReminderTextColor or { 0.58, 0.51, 0.79 }
  rushSwatch:SetColorTexture(rushStart[1], rushStart[2], rushStart[3], 1)

  rushColorButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = Elysian.state.warlockRushReminderTextColor or { 0.58, 0.51, 0.79 }
    local function apply(r, g, b)
      Elysian.state.warlockRushReminderTextColor = { r, g, b }
      rushSwatch:SetColorTexture(r, g, b, 1)
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
  HookButtonPressFeedback(rushColorButton)

  local rushBgButton = CreateFrame("Button", nil, panel, template)
  rushBgButton:SetPoint("TOPLEFT", rushColorButton, "BOTTOMLEFT", 0, -10)
  rushBgButton:SetSize(180, 22)
  Elysian.SetBackdrop(rushBgButton)
  Elysian.SetBackdropColors(rushBgButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local rushBgText = rushBgButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  rushBgText:SetPoint("CENTER")
  rushBgText:SetText("Background Color")
  Elysian.ApplyFont(rushBgText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(rushBgText)

  local rushBgSwatch = rushBgButton:CreateTexture(nil, "OVERLAY")
  rushBgSwatch:SetSize(12, 12)
  rushBgSwatch:SetPoint("RIGHT", -8, 0)
  local rushBgStart = Elysian.state.warlockRushReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
  rushBgSwatch:SetColorTexture(rushBgStart[1], rushBgStart[2], rushBgStart[3], 1)

  rushBgButton:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    local color = Elysian.state.warlockRushReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
    local function apply(r, g, b)
      Elysian.state.warlockRushReminderBgColor = { r, g, b }
      rushBgSwatch:SetColorTexture(r, g, b, 1)
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
  HookButtonPressFeedback(rushBgButton)

  local rushTextLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  rushTextLabel:SetPoint("TOPLEFT", rushBgButton, "BOTTOMLEFT", 0, -12)
  rushTextLabel:SetText("Custom Text:")
  Elysian.ApplyFont(rushTextLabel, 11, "OUTLINE")
  Elysian.ApplyTextColor(rushTextLabel)

  local rushTextBox = CreateFrame("EditBox", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
  rushTextBox:SetPoint("TOPLEFT", rushTextLabel, "BOTTOMLEFT", 0, -6)
  rushTextBox:SetSize(180, 22)
  rushTextBox:SetAutoFocus(false)
  Elysian.SetBackdrop(rushTextBox)
  Elysian.SetBackdropColors(rushTextBox, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)
  rushTextBox:SetTextInsets(6, 6, 2, 2)
  rushTextBox:SetText(Elysian.state.warlockRushReminderTextOverride or "")
  Elysian.ApplyFont(rushTextBox, 11, "OUTLINE")
  Elysian.ApplyTextColor(rushTextBox)
  rushTextBox:SetScript("OnEnterPressed", function(selfBox)
    local text = selfBox:GetText() or ""
    Elysian.state.warlockRushReminderTextOverride = text
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      Elysian.Features.WarlockReminders:ApplyColors()
    end
    selfBox:ClearFocus()
  end)

  local rushTest = CreateFrame("Button", nil, panel, template)
  rushTest:SetPoint("LEFT", rushTextBox, "RIGHT", 10, 0)
  rushTest:SetSize(120, 22)
  Elysian.SetBackdrop(rushTest)
  Elysian.SetBackdropColors(rushTest, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

  local rushTestText = rushTest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  rushTestText:SetPoint("CENTER")
  rushTestText:SetText("Test Banner")
  Elysian.ApplyFont(rushTestText, 11, "OUTLINE")
  Elysian.ApplyAccentColor(rushTestText)

  local function UpdateRushTestStyle(active)
    local bg = active and { 0.75, 0.75, 0.75 } or Elysian.GetNavBg()
    Elysian.SetBackdropColors(rushTest, bg, Elysian.GetThemeBorder(), 0.9)
  end
  UpdateRushTestStyle(Elysian.state.warlockRushReminderTest)

  rushTest:SetScript("OnClick", function()
    if Elysian.ClickFeedback then
      Elysian.ClickFeedback()
    end
    if Elysian.Features and Elysian.Features.WarlockReminders then
      local enabled = not Elysian.state.warlockRushReminderTest
      Elysian.Features.WarlockReminders:SetRushTest(enabled)
      UpdateRushTestStyle(enabled)
    end
  end)
  HookButtonPressFeedback(rushTest)
  end

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

    local bgButton = CreateFrame("Button", nil, panel, template)
    bgButton:SetPoint("TOPLEFT", colorButton, "BOTTOMLEFT", 0, -10)
    bgButton:SetSize(180, 22)
    Elysian.SetBackdrop(bgButton)
    Elysian.SetBackdropColors(bgButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

    local bgText = bgButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bgText:SetPoint("CENTER")
    bgText:SetText("Background Color")
    Elysian.ApplyFont(bgText, 11, "OUTLINE")
    Elysian.ApplyAccentColor(bgText)

    local bgSwatch = bgButton:CreateTexture(nil, "OVERLAY")
    bgSwatch:SetSize(12, 12)
    bgSwatch:SetPoint("RIGHT", -8, 0)
    local bgStart = Elysian.state[prefix .. "BuffBgColor"] or { Elysian.HexToRGB(Elysian.theme.bg) }
    bgSwatch:SetColorTexture(bgStart[1], bgStart[2], bgStart[3], 1)

    bgButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      local color = Elysian.state[prefix .. "BuffBgColor"] or { Elysian.HexToRGB(Elysian.theme.bg) }
      local function apply(r, g, b)
        Elysian.state[prefix .. "BuffBgColor"] = { r, g, b }
        bgSwatch:SetColorTexture(r, g, b, 1)
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
    HookButtonPressFeedback(bgButton)

    local alphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    alphaLabel:SetPoint("TOPLEFT", bgButton, "BOTTOMLEFT", 0, -12)
    alphaLabel:SetText("Transparency")
    Elysian.ApplyFont(alphaLabel, 11)
    Elysian.ApplyTextColor(alphaLabel)

    local alphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 4, -26)
    alphaSlider:SetMinMaxValues(0.1, 1.0)
    alphaSlider:SetValueStep(0.05)
    alphaSlider:SetObeyStepOnDrag(true)
    alphaSlider:SetWidth(220)
    local alphaValue = Elysian.state[prefix .. "BuffAlpha"] or 0.95
    alphaSlider:SetValue(alphaValue)
    alphaSlider.Low:SetText("10%")
    alphaSlider.High:SetText("100%")
    alphaSlider.Text:SetText(string.format("%d%%", math.floor(alphaValue * 100 + 0.5)))
    alphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.max(0.1, math.min(1, value))
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
      Elysian.state[prefix .. "BuffAlpha"] = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:ApplyColors(prefix)
      end
    end)

    local widthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", -4, -20)
    widthLabel:SetText("Banner Width")
    Elysian.ApplyFont(widthLabel, 11)
    Elysian.ApplyTextColor(widthLabel)

    local widthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    widthSlider:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 4, -26)
    widthSlider:SetMinMaxValues(200, 600)
    widthSlider:SetValueStep(1)
    widthSlider:SetObeyStepOnDrag(true)
    widthSlider:SetWidth(220)
    local widthValue = Elysian.state[prefix .. "BuffWidth"]
    if not widthValue or widthValue <= 0 then
      widthValue = 420
    end
    widthSlider:SetValue(widthValue)
    widthSlider.Low:SetText("200")
    widthSlider.High:SetText("600")
    widthSlider.Text:SetText(string.format("%d", widthValue))
    widthSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.floor(value + 0.5)
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d", value))
      Elysian.state[prefix .. "BuffWidth"] = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:ApplySize(prefix)
      end
    end)

    local heightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", widthSlider, "BOTTOMLEFT", -4, -20)
    heightLabel:SetText("Banner Height")
    Elysian.ApplyFont(heightLabel, 11)
    Elysian.ApplyTextColor(heightLabel)

    local heightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    heightSlider:SetPoint("TOPLEFT", heightLabel, "BOTTOMLEFT", 4, -26)
    heightSlider:SetMinMaxValues(30, 120)
    heightSlider:SetValueStep(1)
    heightSlider:SetObeyStepOnDrag(true)
    heightSlider:SetWidth(220)
    local heightValue = Elysian.state[prefix .. "BuffHeight"]
    if not heightValue or heightValue <= 0 then
      heightValue = 52
    end
    heightSlider:SetValue(heightValue)
    heightSlider.Low:SetText("30")
    heightSlider.High:SetText("120")
    heightSlider.Text:SetText(string.format("%d", heightValue))
    heightSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.floor(value + 0.5)
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d", value))
      Elysian.state[prefix .. "BuffHeight"] = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:ApplySize(prefix)
      end
    end)

    local testButton = CreateFrame("Button", nil, panel, template)
    testButton:SetPoint("LEFT", bgButton, "RIGHT", 10, 0)
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

    local bgButton = CreateFrame("Button", nil, panel, template)
    bgButton:SetPoint("TOPLEFT", colorButton, "BOTTOMLEFT", 0, -10)
    bgButton:SetSize(180, 22)
    Elysian.SetBackdrop(bgButton)
    Elysian.SetBackdropColors(bgButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

    local bgText = bgButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bgText:SetPoint("CENTER")
    bgText:SetText("Background Color")
    Elysian.ApplyFont(bgText, 11, "OUTLINE")
    Elysian.ApplyAccentColor(bgText)

    local bgSwatch = bgButton:CreateTexture(nil, "OVERLAY")
    bgSwatch:SetSize(12, 12)
    bgSwatch:SetPoint("RIGHT", -8, 0)
    local bgStart = Elysian.state.roguePoisonBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
    bgSwatch:SetColorTexture(bgStart[1], bgStart[2], bgStart[3], 1)

    bgButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      local color = Elysian.state.roguePoisonBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
      local function apply(r, g, b)
        Elysian.state.roguePoisonBgColor = { r, g, b }
        bgSwatch:SetColorTexture(r, g, b, 1)
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
    HookButtonPressFeedback(bgButton)

    local alphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    alphaLabel:SetPoint("TOPLEFT", bgButton, "BOTTOMLEFT", 0, -12)
    alphaLabel:SetText("Transparency")
    Elysian.ApplyFont(alphaLabel, 11)
    Elysian.ApplyTextColor(alphaLabel)

    local alphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 4, -26)
    alphaSlider:SetMinMaxValues(0.1, 1.0)
    alphaSlider:SetValueStep(0.05)
    alphaSlider:SetObeyStepOnDrag(true)
    alphaSlider:SetWidth(220)
    local alphaValue = Elysian.state.roguePoisonAlpha or 0.95
    alphaSlider:SetValue(alphaValue)
    alphaSlider.Low:SetText("10%")
    alphaSlider.High:SetText("100%")
    alphaSlider.Text:SetText(string.format("%d%%", math.floor(alphaValue * 100 + 0.5)))
    alphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.max(0.1, math.min(1, value))
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
      Elysian.state.roguePoisonAlpha = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:ApplyColors("rogue")
      end
    end)

    local widthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", -4, -20)
    widthLabel:SetText("Banner Width")
    Elysian.ApplyFont(widthLabel, 11)
    Elysian.ApplyTextColor(widthLabel)

    local widthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    widthSlider:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 4, -26)
    widthSlider:SetMinMaxValues(200, 600)
    widthSlider:SetValueStep(1)
    widthSlider:SetObeyStepOnDrag(true)
    widthSlider:SetWidth(220)
    local widthValue = Elysian.state.roguePoisonWidth
    if not widthValue or widthValue <= 0 then
      widthValue = 420
    end
    widthSlider:SetValue(widthValue)
    widthSlider.Low:SetText("200")
    widthSlider.High:SetText("600")
    widthSlider.Text:SetText(string.format("%d", widthValue))
    widthSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.floor(value + 0.5)
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d", value))
      Elysian.state.roguePoisonWidth = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:ApplySize("rogue")
      end
    end)

    local heightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", widthSlider, "BOTTOMLEFT", -4, -20)
    heightLabel:SetText("Banner Height")
    Elysian.ApplyFont(heightLabel, 11)
    Elysian.ApplyTextColor(heightLabel)

    local heightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    heightSlider:SetPoint("TOPLEFT", heightLabel, "BOTTOMLEFT", 4, -26)
    heightSlider:SetMinMaxValues(30, 120)
    heightSlider:SetValueStep(1)
    heightSlider:SetObeyStepOnDrag(true)
    heightSlider:SetWidth(220)
    local heightValue = Elysian.state.roguePoisonHeight
    if not heightValue or heightValue <= 0 then
      heightValue = 52
    end
    heightSlider:SetValue(heightValue)
    heightSlider.Low:SetText("30")
    heightSlider.High:SetText("120")
    heightSlider.Text:SetText(string.format("%d", heightValue))
    heightSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.floor(value + 0.5)
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d", value))
      Elysian.state.roguePoisonHeight = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.ClassBuffReminders then
        Elysian.Features.ClassBuffReminders:ApplySize("rogue")
      end
    end)

    local testButton = CreateFrame("Button", nil, panel, template)
    testButton:SetPoint("LEFT", bgButton, "RIGHT", 10, 0)
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

  local function BuildHunterPanel(panel)
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 8, -8)
    title:SetText("Hunter Alerts")
    Elysian.ApplyFont(title, 13, "OUTLINE")
    Elysian.ApplyTextColor(title)

    local toggle = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    toggle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
    toggle.text = toggle.text or _G[toggle:GetName() .. "Text"]
    toggle.text:SetText("Enable pet missing reminder")
    Elysian.ApplyFont(toggle.text, 12)
    Elysian.ApplyTextColor(toggle.text)
    Elysian.StyleCheckbox(toggle)
    toggle:SetChecked(Elysian.state.hunterPetReminderEnabled)
    toggle:SetScript("OnClick", function(selfButton)
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      if Elysian.Features and Elysian.Features.HunterReminders then
        Elysian.Features.HunterReminders:SetPetEnabled(selfButton:GetChecked())
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
    local start = Elysian.state.hunterPetReminderTextColor or { 0.67, 0.83, 0.45 }
    swatch:SetColorTexture(start[1], start[2], start[3], 1)

    colorButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      local color = Elysian.state.hunterPetReminderTextColor or { 0.67, 0.83, 0.45 }
      local function apply(r, g, b)
        Elysian.state.hunterPetReminderTextColor = { r, g, b }
        swatch:SetColorTexture(r, g, b, 1)
        if Elysian.Features and Elysian.Features.HunterReminders then
          Elysian.Features.HunterReminders:ApplyColors()
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

    local bgButton = CreateFrame("Button", nil, panel, template)
    bgButton:SetPoint("TOPLEFT", colorButton, "BOTTOMLEFT", 0, -10)
    bgButton:SetSize(180, 22)
    Elysian.SetBackdrop(bgButton)
    Elysian.SetBackdropColors(bgButton, Elysian.GetNavBg(), Elysian.GetThemeBorder(), 0.9)

    local bgText = bgButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bgText:SetPoint("CENTER")
    bgText:SetText("Background Color")
    Elysian.ApplyFont(bgText, 11, "OUTLINE")
    Elysian.ApplyAccentColor(bgText)

    local bgSwatch = bgButton:CreateTexture(nil, "OVERLAY")
    bgSwatch:SetSize(12, 12)
    bgSwatch:SetPoint("RIGHT", -8, 0)
    local bgStart = Elysian.state.hunterPetReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
    bgSwatch:SetColorTexture(bgStart[1], bgStart[2], bgStart[3], 1)

    bgButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      local color = Elysian.state.hunterPetReminderBgColor or { Elysian.HexToRGB(Elysian.theme.bg) }
      local function apply(r, g, b)
        Elysian.state.hunterPetReminderBgColor = { r, g, b }
        bgSwatch:SetColorTexture(r, g, b, 1)
        if Elysian.Features and Elysian.Features.HunterReminders then
          Elysian.Features.HunterReminders:ApplyColors()
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
    HookButtonPressFeedback(bgButton)

    local alphaLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    alphaLabel:SetPoint("TOPLEFT", bgButton, "BOTTOMLEFT", 0, -12)
    alphaLabel:SetText("Transparency")
    Elysian.ApplyFont(alphaLabel, 11)
    Elysian.ApplyTextColor(alphaLabel)

    local alphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 4, -26)
    alphaSlider:SetMinMaxValues(0.1, 1.0)
    alphaSlider:SetValueStep(0.05)
    alphaSlider:SetObeyStepOnDrag(true)
    alphaSlider:SetWidth(220)
    local alphaValue = Elysian.state.hunterPetReminderAlpha or 0.95
    alphaSlider:SetValue(alphaValue)
    alphaSlider.Low:SetText("10%")
    alphaSlider.High:SetText("100%")
    alphaSlider.Text:SetText(string.format("%d%%", math.floor(alphaValue * 100 + 0.5)))
    alphaSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.max(0.1, math.min(1, value))
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
      Elysian.state.hunterPetReminderAlpha = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.HunterReminders then
        Elysian.Features.HunterReminders:ApplyColors()
      end
    end)

    local widthLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", -4, -20)
    widthLabel:SetText("Banner Width")
    Elysian.ApplyFont(widthLabel, 11)
    Elysian.ApplyTextColor(widthLabel)

    local widthSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    widthSlider:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 4, -26)
    widthSlider:SetMinMaxValues(200, 600)
    widthSlider:SetValueStep(1)
    widthSlider:SetObeyStepOnDrag(true)
    widthSlider:SetWidth(220)
    local widthValue = Elysian.state.hunterPetReminderWidth
    if not widthValue or widthValue <= 0 then
      widthValue = 360
    end
    widthSlider:SetValue(widthValue)
    widthSlider.Low:SetText("200")
    widthSlider.High:SetText("600")
    widthSlider.Text:SetText(string.format("%d", widthValue))
    widthSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.floor(value + 0.5)
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d", value))
      Elysian.state.hunterPetReminderWidth = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.HunterReminders then
        Elysian.Features.HunterReminders:ApplySize()
      end
    end)

    local heightLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", widthSlider, "BOTTOMLEFT", -4, -20)
    heightLabel:SetText("Banner Height")
    Elysian.ApplyFont(heightLabel, 11)
    Elysian.ApplyTextColor(heightLabel)

    local heightSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    heightSlider:SetPoint("TOPLEFT", heightLabel, "BOTTOMLEFT", 4, -26)
    heightSlider:SetMinMaxValues(30, 120)
    heightSlider:SetValueStep(1)
    heightSlider:SetObeyStepOnDrag(true)
    heightSlider:SetWidth(220)
    local heightValue = Elysian.state.hunterPetReminderHeight
    if not heightValue or heightValue <= 0 then
      heightValue = 46
    end
    heightSlider:SetValue(heightValue)
    heightSlider.Low:SetText("30")
    heightSlider.High:SetText("120")
    heightSlider.Text:SetText(string.format("%d", heightValue))
    heightSlider:SetScript("OnValueChanged", function(selfSlider, value)
      value = math.floor(value + 0.5)
      selfSlider:SetValue(value)
      selfSlider.Text:SetText(string.format("%d", value))
      Elysian.state.hunterPetReminderHeight = value
      if Elysian.SaveState then
        Elysian.SaveState()
      end
      if Elysian.Features and Elysian.Features.HunterReminders then
        Elysian.Features.HunterReminders:ApplySize()
      end
    end)

    local testButton = CreateFrame("Button", nil, panel, template)
    testButton:SetPoint("LEFT", bgButton, "RIGHT", 10, 0)
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
    UpdateTestStyle(Elysian.state.hunterPetReminderTest)

    testButton:SetScript("OnClick", function()
      if Elysian.ClickFeedback then
        Elysian.ClickFeedback()
      end
      if Elysian.Features and Elysian.Features.HunterReminders then
        local enabled = not Elysian.state.hunterPetReminderTest
        Elysian.Features.HunterReminders:SetPetTest(enabled)
        UpdateTestStyle(enabled)
      end
    end)
    HookButtonPressFeedback(testButton)
  end

  for i = 1, #classTabOrder do
    local className = classTabOrder[i]
    CreateClassTab(className, i)
    local panel = CreateClassPanel()
    if className == "WARLOCK" then
      BuildWarlockPanel(panel)
    elseif className == "WARRIOR" then
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
    elseif className == "HUNTER" then
      BuildHunterPanel(panel)
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

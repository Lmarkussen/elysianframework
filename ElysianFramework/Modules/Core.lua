local ADDON_NAME, Elysian = ...

Elysian.name = ADDON_NAME

Elysian.theme = {
  bg = "#282a36",
  fg = "#f8f8f2",
  border = "#44475a",
  accent = "#bd93f9",
}

Elysian.fonts = {
  regular = "Interface\\AddOns\\ElysianFramework\\Fonts\\HackNerdFont-Regular.ttf",
}

Elysian.state = Elysian.state or {
  scrapSellerEnabled = false,
  showOnStart = true,
  navBg = nil,
  contentBg = nil,
  cursorRingEnabled = false,
  cursorRingSize = 18,
  cursorRingColor = nil,
  cursorRingClassColor = false,
  cursorRingShape = "RING",
  cursorRingCastProgress = true,
  cursorRingCastColor = nil,
  cursorRingShowInCombat = true,
  cursorRingShowOutCombat = true,
  cursorRingShowInInstances = true,
  cursorRingShowInWorld = true,
  cursorRingTrailEnabled = false,
  cursorRingTrailLength = 12,
  cursorRingTrailSpacing = 0.02,
  cursorRingTrailFade = 0.6,
  cursorRingTrailColor = nil,
  autoRepairEnabled = false,
  minimapButtonAngle = nil,
  uiFontScale = 1.1,
  uiTextUseClassColor = true,
  uiTextColor = nil,
  infoBarEnabled = false,
  infoBarShowTime = true,
  infoBarShowGold = true,
  infoBarShowDurability = true,
  infoBarShowFPS = true,
  infoBarShowMS = true,
  infoBarUnlocked = false,
  infoBarOpacity = 0.35,
  infoBarTextColor = nil,
  infoBarBgColor = nil,
  infoBarShowPortalButton = false,
  repairReminderEnabled = false,
  repairReminderUnlocked = false,
  repairReminderTextColor = nil,
  repairReminderTest = false,
  repairReminderPos = nil,
  dungeonReminderEnabled = false,
  dungeonReminderUnlocked = false,
  dungeonReminderTextColor = nil,
  dungeonReminderTest = false,
  dungeonReminderPos = nil,
  warlockPetReminderEnabled = false,
  warlockPetReminderTextColor = nil,
  warlockPetReminderTest = false,
  warlockPetReminderPos = nil,
  warlockStoneReminderEnabled = false,
  warlockStoneReminderTextColor = nil,
  warlockStoneReminderTest = false,
  warlockStoneReminderPos = nil,
  autoKeystoneEnabled = false,
}

local function EnsureColorTable(value, fallback)
  if type(value) == "table" and #value >= 3 then
    return { value[1], value[2], value[3] }
  end
  if type(fallback) == "table" then
    return { fallback[1], fallback[2], fallback[3] }
  end
  return { Elysian.HexToRGB(Elysian.theme.bg) }
end

function Elysian.GetDefaultState()
  return {
    scrapSellerEnabled = false,
    showOnStart = true,
    navBg = { Elysian.HexToRGB("#21222c") },
    contentBg = { Elysian.HexToRGB(Elysian.theme.bg) },
    cursorRingEnabled = false,
    cursorRingSize = 18,
    cursorRingColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    cursorRingClassColor = false,
    cursorRingShape = "RING",
    cursorRingCastProgress = true,
    cursorRingCastColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    cursorRingShowInCombat = true,
    cursorRingShowOutCombat = true,
    cursorRingShowInInstances = true,
    cursorRingShowInWorld = true,
    cursorRingTrailEnabled = false,
    cursorRingTrailLength = 12,
    cursorRingTrailSpacing = 0.02,
    cursorRingTrailFade = 0.6,
    cursorRingTrailColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    autoRepairEnabled = false,
    minimapButtonAngle = 225,
    uiFontScale = 1.1,
    uiTextUseClassColor = true,
    uiTextColor = { Elysian.HexToRGB(Elysian.theme.fg) },
    infoBarEnabled = false,
    infoBarShowTime = true,
    infoBarShowGold = true,
    infoBarShowDurability = true,
    infoBarShowFPS = true,
    infoBarShowMS = true,
    infoBarUnlocked = false,
    infoBarOpacity = 0.35,
    infoBarTextColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    infoBarBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    infoBarShowPortalButton = false,
    repairReminderEnabled = false,
    repairReminderUnlocked = false,
    repairReminderTextColor = { 1, 1, 1 },
    repairReminderTest = false,
    repairReminderPos = nil,
    dungeonReminderEnabled = false,
    dungeonReminderUnlocked = false,
    dungeonReminderTextColor = { 1, 1, 1 },
    dungeonReminderTest = false,
    dungeonReminderPos = nil,
    warlockPetReminderEnabled = false,
    warlockPetReminderTextColor = { 1, 1, 1 },
    warlockPetReminderTest = false,
    warlockPetReminderPos = nil,
    warlockStoneReminderEnabled = false,
    warlockStoneReminderTextColor = { 1, 1, 1 },
    warlockStoneReminderTest = false,
    warlockStoneReminderPos = nil,
    autoKeystoneEnabled = false,
  }
end

function Elysian.ResetSettings()
  local defaults = Elysian.GetDefaultState()
  for key, value in pairs(defaults) do
    Elysian.state[key] = value
  end
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function Elysian.InitSavedVariables()
  if type(ElysianDB) ~= "table" then
    ElysianDB = {}
  end

  if ElysianDB.version == nil then
    ElysianDB.version = 1
  end
  if ElysianDB.scrapSellerEnabled == nil then
    ElysianDB.scrapSellerEnabled = false
  end
  if ElysianDB.showOnStart == nil then
    ElysianDB.showOnStart = true
  end
  local defaultNav = { Elysian.HexToRGB("#21222c") }
  local defaultContent = { Elysian.HexToRGB(Elysian.theme.bg) }
  if ElysianDB.navBg == nil then
    ElysianDB.navBg = defaultNav
  end
  if ElysianDB.contentBg == nil then
    ElysianDB.contentBg = defaultContent
  end
  if ElysianDB.cursorRingEnabled == nil then
    ElysianDB.cursorRingEnabled = false
  end
  if ElysianDB.cursorRingSize == nil then
    ElysianDB.cursorRingSize = 18
  end
  if ElysianDB.cursorRingColor == nil then
    ElysianDB.cursorRingColor = { Elysian.HexToRGB(Elysian.theme.accent) }
  end
  if ElysianDB.cursorRingClassColor == nil then
    ElysianDB.cursorRingClassColor = false
  end
  if ElysianDB.cursorRingShape == nil then
    ElysianDB.cursorRingShape = "RING"
  end
  if ElysianDB.cursorRingCastProgress == nil then
    ElysianDB.cursorRingCastProgress = true
  end
  if ElysianDB.cursorRingCastColor == nil then
    ElysianDB.cursorRingCastColor = { Elysian.HexToRGB(Elysian.theme.accent) }
  end
  if ElysianDB.cursorRingShowInCombat == nil then
    ElysianDB.cursorRingShowInCombat = true
  end
  if ElysianDB.cursorRingShowOutCombat == nil then
    ElysianDB.cursorRingShowOutCombat = true
  end
  if ElysianDB.cursorRingShowInInstances == nil then
    ElysianDB.cursorRingShowInInstances = true
  end
  if ElysianDB.cursorRingShowInWorld == nil then
    ElysianDB.cursorRingShowInWorld = true
  end
  if ElysianDB.cursorRingTrailEnabled == nil then
    ElysianDB.cursorRingTrailEnabled = false
  end
  if ElysianDB.cursorRingTrailLength == nil then
    ElysianDB.cursorRingTrailLength = 12
  end
  if ElysianDB.cursorRingTrailSpacing == nil then
    ElysianDB.cursorRingTrailSpacing = 0.02
  end
  if ElysianDB.cursorRingTrailFade == nil then
    ElysianDB.cursorRingTrailFade = 0.6
  end
  if ElysianDB.cursorRingTrailColor == nil then
    ElysianDB.cursorRingTrailColor = { Elysian.HexToRGB(Elysian.theme.accent) }
  end
  if ElysianDB.autoRepairEnabled == nil then
    ElysianDB.autoRepairEnabled = false
  end
  if ElysianDB.uiFontScale == nil then
    ElysianDB.uiFontScale = 1.1
  end
  if ElysianDB.infoBarEnabled == nil then
    ElysianDB.infoBarEnabled = false
  end
  if ElysianDB.infoBarShowTime == nil then
    ElysianDB.infoBarShowTime = true
  end
  if ElysianDB.infoBarShowGold == nil then
    ElysianDB.infoBarShowGold = true
  end
  if ElysianDB.infoBarShowDurability == nil then
    ElysianDB.infoBarShowDurability = true
  end
  if ElysianDB.infoBarShowFPS == nil then
    ElysianDB.infoBarShowFPS = true
  end
  if ElysianDB.infoBarShowMS == nil then
    ElysianDB.infoBarShowMS = true
  end
  if ElysianDB.infoBarUnlocked == nil then
    ElysianDB.infoBarUnlocked = false
  end
  if ElysianDB.infoBarOpacity == nil then
    ElysianDB.infoBarOpacity = 0.35
  end
  if ElysianDB.infoBarTextColor == nil then
    ElysianDB.infoBarTextColor = { Elysian.HexToRGB(Elysian.theme.accent) }
  end
  if ElysianDB.infoBarBgColor == nil then
    ElysianDB.infoBarBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.infoBarShowPortalButton == nil then
    ElysianDB.infoBarShowPortalButton = false
  end
  if ElysianDB.repairReminderEnabled == nil then
    ElysianDB.repairReminderEnabled = false
  end
  if ElysianDB.repairReminderUnlocked == nil then
    ElysianDB.repairReminderUnlocked = false
  end
  if ElysianDB.repairReminderTextColor == nil then
    ElysianDB.repairReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.repairReminderTest == nil then
    ElysianDB.repairReminderTest = false
  end
  if ElysianDB.repairReminderPos == nil then
    ElysianDB.repairReminderPos = nil
  end
  if ElysianDB.dungeonReminderEnabled == nil then
    ElysianDB.dungeonReminderEnabled = false
  end
  if ElysianDB.dungeonReminderUnlocked == nil then
    ElysianDB.dungeonReminderUnlocked = false
  end
  if ElysianDB.dungeonReminderTextColor == nil then
    ElysianDB.dungeonReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.dungeonReminderTest == nil then
    ElysianDB.dungeonReminderTest = false
  end
  if ElysianDB.dungeonReminderPos == nil then
    ElysianDB.dungeonReminderPos = nil
  end
  if ElysianDB.warlockPetReminderEnabled == nil then
    ElysianDB.warlockPetReminderEnabled = false
  end
  if ElysianDB.warlockPetReminderTextColor == nil then
    ElysianDB.warlockPetReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.warlockPetReminderTest == nil then
    ElysianDB.warlockPetReminderTest = false
  end
  if ElysianDB.warlockPetReminderPos == nil then
    ElysianDB.warlockPetReminderPos = nil
  end
  if ElysianDB.warlockStoneReminderEnabled == nil then
    ElysianDB.warlockStoneReminderEnabled = false
  end
  if ElysianDB.warlockStoneReminderTextColor == nil then
    ElysianDB.warlockStoneReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.warlockStoneReminderTest == nil then
    ElysianDB.warlockStoneReminderTest = false
  end
  if ElysianDB.warlockStoneReminderPos == nil then
    ElysianDB.warlockStoneReminderPos = nil
  end
  if ElysianDB.autoKeystoneEnabled == nil then
    ElysianDB.autoKeystoneEnabled = false
  end
  if ElysianDB.minimapButtonAngle == nil then
    ElysianDB.minimapButtonAngle = 225
  end

  if ElysianDB.version < 2 then
    ElysianDB.scrapSellerEnabled = false
    ElysianDB.cursorRingEnabled = false
    ElysianDB.version = 2
  end

  if ElysianDB.version < 3 then
    ElysianDB.cursorRingShowInCombat = true
    ElysianDB.cursorRingShowOutCombat = true
    ElysianDB.cursorRingShowInInstances = true
    ElysianDB.cursorRingShowInWorld = true
    ElysianDB.version = 3
  end

  Elysian.state.scrapSellerEnabled = ElysianDB.scrapSellerEnabled
  Elysian.state.showOnStart = ElysianDB.showOnStart
  Elysian.state.navBg = EnsureColorTable(ElysianDB.navBg, defaultNav)
  Elysian.state.contentBg = EnsureColorTable(ElysianDB.contentBg, defaultContent)
  Elysian.state.cursorRingEnabled = ElysianDB.cursorRingEnabled
  Elysian.state.cursorRingSize = ElysianDB.cursorRingSize
  Elysian.state.cursorRingColor = EnsureColorTable(
    ElysianDB.cursorRingColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  Elysian.state.cursorRingClassColor = ElysianDB.cursorRingClassColor
  Elysian.state.cursorRingShape = ElysianDB.cursorRingShape
  Elysian.state.cursorRingCastProgress = ElysianDB.cursorRingCastProgress
  Elysian.state.cursorRingCastColor = EnsureColorTable(
    ElysianDB.cursorRingCastColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  Elysian.state.cursorRingShowInCombat = ElysianDB.cursorRingShowInCombat
  Elysian.state.cursorRingShowOutCombat = ElysianDB.cursorRingShowOutCombat
  Elysian.state.cursorRingShowInInstances = ElysianDB.cursorRingShowInInstances
  Elysian.state.cursorRingShowInWorld = ElysianDB.cursorRingShowInWorld
  Elysian.state.cursorRingTrailEnabled = ElysianDB.cursorRingTrailEnabled
  Elysian.state.cursorRingTrailLength = ElysianDB.cursorRingTrailLength
  Elysian.state.cursorRingTrailSpacing = ElysianDB.cursorRingTrailSpacing
  Elysian.state.cursorRingTrailFade = ElysianDB.cursorRingTrailFade
  Elysian.state.cursorRingTrailColor = EnsureColorTable(
    ElysianDB.cursorRingTrailColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  Elysian.state.autoRepairEnabled = ElysianDB.autoRepairEnabled
  Elysian.state.minimapButtonAngle = ElysianDB.minimapButtonAngle
  Elysian.state.uiFontScale = ElysianDB.uiFontScale
  Elysian.state.uiTextUseClassColor = ElysianDB.uiTextUseClassColor
  Elysian.state.uiTextColor = EnsureColorTable(
    ElysianDB.uiTextColor,
    { Elysian.HexToRGB(Elysian.theme.fg) }
  )
  Elysian.state.infoBarEnabled = ElysianDB.infoBarEnabled
  Elysian.state.infoBarShowTime = ElysianDB.infoBarShowTime
  Elysian.state.infoBarShowGold = ElysianDB.infoBarShowGold
  Elysian.state.infoBarShowDurability = ElysianDB.infoBarShowDurability
  Elysian.state.infoBarShowFPS = ElysianDB.infoBarShowFPS
  Elysian.state.infoBarShowMS = ElysianDB.infoBarShowMS
  Elysian.state.infoBarUnlocked = ElysianDB.infoBarUnlocked
  Elysian.state.infoBarOpacity = ElysianDB.infoBarOpacity
  Elysian.state.infoBarTextColor = EnsureColorTable(
    ElysianDB.infoBarTextColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  Elysian.state.infoBarBgColor = EnsureColorTable(
    ElysianDB.infoBarBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.infoBarShowPortalButton = ElysianDB.infoBarShowPortalButton
  Elysian.state.repairReminderEnabled = ElysianDB.repairReminderEnabled
  Elysian.state.repairReminderUnlocked = ElysianDB.repairReminderUnlocked
  Elysian.state.repairReminderTextColor = EnsureColorTable(
    ElysianDB.repairReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.repairReminderTest = ElysianDB.repairReminderTest
  Elysian.state.repairReminderPos = ElysianDB.repairReminderPos
  Elysian.state.dungeonReminderEnabled = ElysianDB.dungeonReminderEnabled
  Elysian.state.dungeonReminderUnlocked = ElysianDB.dungeonReminderUnlocked
  Elysian.state.dungeonReminderTextColor = EnsureColorTable(
    ElysianDB.dungeonReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.dungeonReminderTest = ElysianDB.dungeonReminderTest
  Elysian.state.dungeonReminderPos = ElysianDB.dungeonReminderPos
  Elysian.state.warlockPetReminderEnabled = ElysianDB.warlockPetReminderEnabled
  Elysian.state.warlockPetReminderTextColor = EnsureColorTable(
    ElysianDB.warlockPetReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.warlockPetReminderTest = ElysianDB.warlockPetReminderTest
  Elysian.state.warlockPetReminderPos = ElysianDB.warlockPetReminderPos
  Elysian.state.warlockStoneReminderEnabled = ElysianDB.warlockStoneReminderEnabled
  Elysian.state.warlockStoneReminderTextColor = EnsureColorTable(
    ElysianDB.warlockStoneReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.warlockStoneReminderTest = ElysianDB.warlockStoneReminderTest
  Elysian.state.warlockStoneReminderPos = ElysianDB.warlockStoneReminderPos
  Elysian.state.autoKeystoneEnabled = ElysianDB.autoKeystoneEnabled

  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function Elysian.SaveState()
  if type(ElysianDB) ~= "table" then
    ElysianDB = {}
  end
  ElysianDB.scrapSellerEnabled = Elysian.state.scrapSellerEnabled
  ElysianDB.showOnStart = Elysian.state.showOnStart
  ElysianDB.navBg = EnsureColorTable(Elysian.state.navBg, { Elysian.HexToRGB("#21222c") })
  ElysianDB.contentBg = EnsureColorTable(Elysian.state.contentBg, { Elysian.HexToRGB(Elysian.theme.bg) })
  ElysianDB.cursorRingEnabled = Elysian.state.cursorRingEnabled
  ElysianDB.cursorRingSize = Elysian.state.cursorRingSize
  ElysianDB.cursorRingColor = EnsureColorTable(
    Elysian.state.cursorRingColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  ElysianDB.cursorRingClassColor = Elysian.state.cursorRingClassColor
  ElysianDB.cursorRingShape = Elysian.state.cursorRingShape
  ElysianDB.cursorRingCastProgress = Elysian.state.cursorRingCastProgress
  ElysianDB.cursorRingCastColor = EnsureColorTable(
    Elysian.state.cursorRingCastColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  ElysianDB.cursorRingShowInCombat = Elysian.state.cursorRingShowInCombat
  ElysianDB.cursorRingShowOutCombat = Elysian.state.cursorRingShowOutCombat
  ElysianDB.cursorRingShowInInstances = Elysian.state.cursorRingShowInInstances
  ElysianDB.cursorRingShowInWorld = Elysian.state.cursorRingShowInWorld
  ElysianDB.cursorRingTrailEnabled = Elysian.state.cursorRingTrailEnabled
  ElysianDB.cursorRingTrailLength = Elysian.state.cursorRingTrailLength
  ElysianDB.cursorRingTrailSpacing = Elysian.state.cursorRingTrailSpacing
  ElysianDB.cursorRingTrailFade = Elysian.state.cursorRingTrailFade
  ElysianDB.cursorRingTrailColor = EnsureColorTable(
    Elysian.state.cursorRingTrailColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  ElysianDB.autoRepairEnabled = Elysian.state.autoRepairEnabled
  ElysianDB.minimapButtonAngle = Elysian.state.minimapButtonAngle
  ElysianDB.uiFontScale = Elysian.state.uiFontScale
  ElysianDB.uiTextUseClassColor = Elysian.state.uiTextUseClassColor
  ElysianDB.uiTextColor = EnsureColorTable(
    Elysian.state.uiTextColor,
    { Elysian.HexToRGB(Elysian.theme.fg) }
  )
  ElysianDB.infoBarEnabled = Elysian.state.infoBarEnabled
  ElysianDB.infoBarShowTime = Elysian.state.infoBarShowTime
  ElysianDB.infoBarShowGold = Elysian.state.infoBarShowGold
  ElysianDB.infoBarShowDurability = Elysian.state.infoBarShowDurability
  ElysianDB.infoBarShowFPS = Elysian.state.infoBarShowFPS
  ElysianDB.infoBarShowMS = Elysian.state.infoBarShowMS
  ElysianDB.infoBarUnlocked = Elysian.state.infoBarUnlocked
  ElysianDB.infoBarOpacity = Elysian.state.infoBarOpacity
  ElysianDB.infoBarTextColor = EnsureColorTable(
    Elysian.state.infoBarTextColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  ElysianDB.infoBarBgColor = EnsureColorTable(
    Elysian.state.infoBarBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  ElysianDB.infoBarShowPortalButton = Elysian.state.infoBarShowPortalButton
  ElysianDB.repairReminderEnabled = Elysian.state.repairReminderEnabled
  ElysianDB.repairReminderUnlocked = Elysian.state.repairReminderUnlocked
  ElysianDB.repairReminderTextColor = EnsureColorTable(
    Elysian.state.repairReminderTextColor,
    { 1, 1, 1 }
  )
  ElysianDB.repairReminderTest = Elysian.state.repairReminderTest
  ElysianDB.repairReminderPos = Elysian.state.repairReminderPos
  ElysianDB.dungeonReminderEnabled = Elysian.state.dungeonReminderEnabled
  ElysianDB.dungeonReminderUnlocked = Elysian.state.dungeonReminderUnlocked
  ElysianDB.dungeonReminderTextColor = EnsureColorTable(
    Elysian.state.dungeonReminderTextColor,
    { 1, 1, 1 }
  )
  ElysianDB.dungeonReminderTest = Elysian.state.dungeonReminderTest
  ElysianDB.dungeonReminderPos = Elysian.state.dungeonReminderPos
  ElysianDB.warlockPetReminderEnabled = Elysian.state.warlockPetReminderEnabled
  ElysianDB.warlockPetReminderTextColor = EnsureColorTable(
    Elysian.state.warlockPetReminderTextColor,
    { 1, 1, 1 }
  )
  ElysianDB.warlockPetReminderTest = Elysian.state.warlockPetReminderTest
  ElysianDB.warlockPetReminderPos = Elysian.state.warlockPetReminderPos
  ElysianDB.warlockStoneReminderEnabled = Elysian.state.warlockStoneReminderEnabled
  ElysianDB.warlockStoneReminderTextColor = EnsureColorTable(
    Elysian.state.warlockStoneReminderTextColor,
    { 1, 1, 1 }
  )
  ElysianDB.warlockStoneReminderTest = Elysian.state.warlockStoneReminderTest
  ElysianDB.warlockStoneReminderPos = Elysian.state.warlockStoneReminderPos
  ElysianDB.autoKeystoneEnabled = Elysian.state.autoKeystoneEnabled
end

function Elysian.HexToRGB(hex)
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16) / 255
  local g = tonumber(hex:sub(3, 4), 16) / 255
  local b = tonumber(hex:sub(5, 6), 16) / 255
  return r, g, b
end

function Elysian.SetBackdrop(frame)
  if not frame or not frame.SetBackdrop then
    return
  end

  frame:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8x8",
    edgeFile = "Interface/Buttons/WHITE8x8",
    edgeSize = 1,
  })
end

function Elysian.SetBackdropColors(frame, bgColor, borderColor, alpha)
  if not frame or not frame.SetBackdropColor then
    return
  end
  if type(bgColor) ~= "table" then
    bgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if type(borderColor) ~= "table" then
    borderColor = { Elysian.HexToRGB(Elysian.theme.border) }
  end
  local bgR, bgG, bgB = unpack(bgColor)
  local borderR, borderG, borderB = unpack(borderColor)
  frame:SetBackdropColor(bgR, bgG, bgB, alpha or 0.95)
  if frame.SetBackdropBorderColor then
    frame:SetBackdropBorderColor(borderR, borderG, borderB, 1)
  end
end

function Elysian.GetThemeBorder()
  return { Elysian.HexToRGB(Elysian.theme.border) }
end

function Elysian.GetContentBg()
  return EnsureColorTable(Elysian.state.contentBg, { Elysian.HexToRGB(Elysian.theme.bg) })
end

function Elysian.GetNavBg()
  return EnsureColorTable(Elysian.state.navBg, { Elysian.HexToRGB("#21222c") })
end

function Elysian.ApplyTextColor(fontString)
  if not fontString then
    return
  end
  local fgR, fgG, fgB = Elysian.HexToRGB(Elysian.theme.fg)
  local classColor = nil
  if UnitClass then
    local _, class = UnitClass("player")
    local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
    local color = colors and colors[class]
    if color then
      classColor = { color.r, color.g, color.b }
    end
  end
  if Elysian.state and not Elysian.state.uiTextUseClassColor then
    local custom = Elysian.state.uiTextColor
    if custom then
      fgR, fgG, fgB = custom[1], custom[2], custom[3]
    end
  elseif classColor then
    fgR, fgG, fgB = classColor[1], classColor[2], classColor[3]
  end
  fontString:SetTextColor(fgR, fgG, fgB)
end

function Elysian.ApplyAccentColor(fontString)
  if not fontString then
    return
  end
  local accentR, accentG, accentB = Elysian.HexToRGB(Elysian.theme.accent)
  if UnitClass then
    local _, class = UnitClass("player")
    local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
    local color = colors and colors[class]
    if color then
      accentR, accentG, accentB = color.r, color.g, color.b
    end
  end
  if Elysian.state and not Elysian.state.uiTextUseClassColor then
    local custom = Elysian.state.uiTextColor
    if custom then
      accentR, accentG, accentB = custom[1], custom[2], custom[3]
    end
  end
  fontString:SetTextColor(accentR, accentG, accentB)
end

function Elysian.ApplyFont(fontString, size, flags)
  if not fontString then
    return
  end

  local fontPath = Elysian.fonts.regular
  local scale = Elysian.state and Elysian.state.uiFontScale or 1.0
  local finalSize = (size or 12) * scale
  local applied = fontString:SetFont(fontPath, finalSize, flags)
  if not applied then
    fontString:SetFont(STANDARD_TEXT_FONT, finalSize, flags)
  end
end

function Elysian.PlayFlagCaptureSound()
  if not SOUNDKIT then
    return false
  end
  local candidates = {}
  for name, id in pairs(SOUNDKIT) do
    if type(name) == "string" and type(id) == "number" then
      local upper = name:upper()
      if upper:find("FLAG") and (upper:find("CAPTURE") or upper:find("CAPTURED")) then
        table.insert(candidates, { name = name, id = id })
      end
    end
  end
  table.sort(candidates, function(a, b)
    return a.name < b.name
  end)
  for _, entry in ipairs(candidates) do
    local willPlay = PlaySound(entry.id, "Master")
    if willPlay then
      return true
    end
  end
  return false
end

function Elysian.StyleCheckbox(checkbox)
  if not checkbox then
    return
  end

  checkbox:SetScale(0.7)
  if checkbox.text then
    checkbox.text:SetTextColor(1, 1, 1)
  end

  local markR, markG, markB = Elysian.HexToRGB("#ffb86c")
  if checkbox.GetCheckedTexture and checkbox:GetCheckedTexture() then
    checkbox:GetCheckedTexture():SetVertexColor(markR, markG, markB, 1)
  end
  if checkbox.GetHighlightTexture and checkbox:GetHighlightTexture() then
    checkbox:GetHighlightTexture():SetVertexColor(markR, markG, markB, 0.35)
  end
end

function Elysian.ClickFeedback()
  if PlaySound and SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON then
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
  end
end

function Elysian.OpenColorPicker(options)
  if not options then
    return
  end
  if LoadAddOn then
    pcall(LoadAddOn, "Blizzard_ColorPicker")
  end
  if ColorPickerFrame and ColorPickerFrame.SetupColorPickerAndShow then
    ColorPickerFrame:SetupColorPickerAndShow(options)
  elseif ColorPickerFrame then
    if options.r and options.g and options.b then
      ColorPickerFrame:SetColorRGB(options.r, options.g, options.b)
    end
    ColorPickerFrame.hasOpacity = options.hasOpacity or false
    ColorPickerFrame.opacity = options.opacity or 1
    ColorPickerFrame.func = options.swatchFunc
    ColorPickerFrame.opacityFunc = options.opacityFunc
    ColorPickerFrame.cancelFunc = options.cancelFunc
    ColorPickerFrame:Show()
  end
end

function Elysian.ApplyGameMenuTheme()
  if not GameMenuFrame then
    return
  end

  local bgR, bgG, bgB = Elysian.HexToRGB(Elysian.theme.bg)
  local borderR, borderG, borderB = Elysian.HexToRGB(Elysian.theme.border)
  local accentR, accentG, accentB = Elysian.HexToRGB(Elysian.theme.accent)
  local fgR, fgG, fgB = Elysian.HexToRGB(Elysian.theme.fg)

  if GameMenuFrame.SetBackdropColor then
    GameMenuFrame:SetBackdropColor(bgR, bgG, bgB, 0.95)
  end
  if GameMenuFrame.SetBackdropBorderColor then
    GameMenuFrame:SetBackdropBorderColor(borderR, borderG, borderB, 1)
  end

  if GameMenuFrame.Header and GameMenuFrame.Header.SetVertexColor then
    GameMenuFrame.Header:SetVertexColor(accentR, accentG, accentB)
  end
  if GameMenuFrame.Header and GameMenuFrame.Header.Text and GameMenuFrame.Header.Text.SetTextColor then
    GameMenuFrame.Header.Text:SetTextColor(fgR, fgG, fgB)
  end
  if GameMenuFrame.HeaderText and GameMenuFrame.HeaderText.SetTextColor then
    GameMenuFrame.HeaderText:SetTextColor(fgR, fgG, fgB)
  end
end

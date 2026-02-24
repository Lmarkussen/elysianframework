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
  scrapSellerEnabled = true,
  showOnStart = true,
  navBg = nil,
  contentBg = nil,
  cursorRingEnabled = true,
  cursorRingSize = 52,
  cursorRingColor = nil,
  cursorRingClassColor = true,
  cursorRingShape = "RING",
  cursorRingCastProgress = true,
  cursorRingCastColor = nil,
  cursorRingShowInCombat = true,
  cursorRingShowOutCombat = true,
  cursorRingShowInInstances = true,
  cursorRingShowInWorld = true,
  cursorRingTrailEnabled = true,
  cursorRingTrailLength = 12,
  cursorRingTrailSpacing = 0.02,
  cursorRingTrailFade = 0.6,
  cursorRingTrailColor = nil,
  cursorRingTrailRandom = false,
  cursorRingTrailFadeTime = 0.25,
  cursorRingTrailShape = "SPARK",
  autoRepairEnabled = true,
  autoRepairThreshold = 70,
  autoRepairUseGuild = true,
  autoRepairLastCost = 0,
  autoRepairLastUsedGuild = false,
  minimapButtonAngle = nil,
  minimapButtonHidden = false,
  showAllClassAlerts = false,
  uiFontScale = 1.1,
  uiTextUseClassColor = true,
  uiTextColor = nil,
  bannerWidth = 0,
  bannerHeight = 0,
  bannerTextOverride = "",
  bannerTestAll = false,
  infoBarEnabled = true,
  infoBarShowTime = true,
  infoBarShowGold = true,
  infoBarShowDurability = true,
  infoBarShowFPS = true,
  infoBarShowMS = true,
  infoBarShowMemory = false,
  infoBarShowItemLevel = false,
  infoBarShowHearthstone = false,
  infoBarUnlocked = false,
  infoBarOpacity = 0.35,
  infoBarTextColor = nil,
  infoBarBgColor = nil,
  infoBarShowPortalButton = true,
  deathSoundEnabled = true,
  repairReminderEnabled = false,
  repairReminderUnlocked = true,
  repairReminderTextColor = nil,
  repairReminderBgColor = nil,
  repairReminderWidth = 0,
  repairReminderHeight = 0,
  repairReminderTest = false,
  repairReminderPos = nil,
  repairReminderAlpha = 0.95,
  repairReminderTextOverride = "",
  dungeonReminderEnabled = false,
  dungeonReminderUnlocked = true,
  dungeonReminderTextColor = nil,
  dungeonReminderBgColor = nil,
  dungeonReminderAlpha = 0.95,
  dungeonReminderWidth = 0,
  dungeonReminderHeight = 0,
  dungeonReminderTextOverride = "",
  dungeonReminderTest = false,
  dungeonReminderPos = nil,
  buffWatchEnabled = false,
  buffWatchTextColor = nil,
  buffWatchBgColor = nil,
  buffWatchAlpha = 0.95,
  buffWatchWidth = 0,
  buffWatchHeight = 0,
  buffWatchTest = false,
  buffWatchPos = nil,
  dungeonConsumablesEnabled = false,
  dungeonConsumablesTextColor = nil,
  dungeonConsumablesBgColor = nil,
  dungeonConsumablesAlpha = 0.95,
  dungeonConsumablesWidth = 0,
  dungeonConsumablesHeight = 0,
  dungeonConsumablesTest = false,
  dungeonConsumablesPos = nil,
  keystoneReminderEnabled = true,
  keystoneReminderTextColor = nil,
  keystoneReminderBgColor = nil,
  keystoneReminderAlpha = 0.95,
  keystoneReminderWidth = 0,
  keystoneReminderHeight = 0,
  keystoneReminderTest = false,
  keystoneReminderPos = nil,
  dungeonRoleMarksEnabled = true,
  dungeonTankMark = 6,
  dungeonHealerMark = 2,
  warlockPetReminderEnabled = false,
  warlockPetReminderTextColor = nil,
  warlockPetReminderTest = false,
  warlockPetReminderPos = nil,
  warlockStoneReminderEnabled = false,
  warlockStoneReminderTextColor = nil,
  warlockStoneReminderTest = false,
  warlockStoneReminderPos = nil,
  warlockRushReminderEnabled = false,
  warlockRushReminderTextColor = nil,
  warlockRushReminderBgColor = nil,
  warlockRushReminderAlpha = 0.95,
  warlockRushReminderShowBg = false,
  warlockRushReminderFlash = true,
  warlockRushReminderSoundEnabled = true,
  warlockRushReminderTextOverride = "",
  warlockRushReminderWidth = 0,
  warlockRushReminderHeight = 0,
  warlockRushReminderTest = false,
  warlockRushReminderPos = nil,
  autoKeystoneEnabled = true,
  warriorBuffEnabled = false,
  warriorBuffTextColor = nil,
  warriorBuffTest = false,
  warriorBuffPos = nil,
  mageBuffEnabled = false,
  mageBuffTextColor = nil,
  mageBuffTest = false,
  mageBuffPos = nil,
  priestBuffEnabled = false,
  priestBuffTextColor = nil,
  priestBuffTest = false,
  priestBuffPos = nil,
  druidBuffEnabled = false,
  druidBuffTextColor = nil,
  druidBuffTest = false,
  druidBuffPos = nil,
  shamanBuffEnabled = false,
  shamanBuffTextColor = nil,
  shamanBuffTest = false,
  shamanBuffPos = nil,
  evokerBuffEnabled = false,
  evokerBuffTextColor = nil,
  evokerBuffTest = false,
  evokerBuffPos = nil,
  roguePoisonEnabled = false,
  roguePoisonTextColor = nil,
  roguePoisonTest = false,
  roguePoisonPos = nil,
}

local function CopyTable(value)
  if type(value) ~= "table" then
    return value
  end
  local out = {}
  for k, v in pairs(value) do
    if type(v) == "table" then
      out[k] = CopyTable(v)
    else
      out[k] = v
    end
  end
  return out
end

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
    scrapSellerEnabled = true,
    showOnStart = true,
    navBg = { Elysian.HexToRGB("#21222c") },
    contentBg = { Elysian.HexToRGB(Elysian.theme.bg) },
    cursorRingEnabled = true,
    cursorRingSize = 52,
    cursorRingColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    cursorRingClassColor = true,
    cursorRingShape = "RING",
    cursorRingCastProgress = true,
    cursorRingCastColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    cursorRingShowInCombat = true,
    cursorRingShowOutCombat = true,
    cursorRingShowInInstances = true,
    cursorRingShowInWorld = true,
    cursorRingTrailEnabled = true,
    cursorRingTrailLength = 12,
    cursorRingTrailSpacing = 0.02,
    cursorRingTrailFade = 0.6,
    cursorRingTrailColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    cursorRingTrailRandom = false,
    cursorRingTrailFadeTime = 0.25,
    cursorRingTrailShape = "SPARK",
    autoRepairEnabled = true,
    autoRepairThreshold = 70,
    autoRepairUseGuild = true,
    autoRepairLastCost = 0,
    autoRepairLastUsedGuild = false,
    minimapButtonAngle = 225,
    minimapButtonHidden = false,
    showAllClassAlerts = false,
    uiFontScale = 1.1,
    uiTextUseClassColor = true,
    uiTextColor = { Elysian.HexToRGB(Elysian.theme.fg) },
    bannerWidth = 0,
    bannerHeight = 0,
    bannerTextOverride = "",
    bannerTestAll = false,
    infoBarEnabled = true,
    infoBarShowTime = true,
    infoBarShowGold = true,
    infoBarShowDurability = true,
    infoBarShowFPS = true,
    infoBarShowMS = true,
    infoBarShowMemory = false,
    infoBarShowItemLevel = false,
    infoBarShowHearthstone = false,
    infoBarUnlocked = false,
    infoBarOpacity = 0.35,
    infoBarTextColor = { Elysian.HexToRGB(Elysian.theme.accent) },
    infoBarBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    infoBarShowPortalButton = true,
    deathSoundEnabled = true,
    repairReminderEnabled = true,
    repairReminderUnlocked = false,
    repairReminderTextColor = { 1, 1, 1 },
    repairReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    repairReminderWidth = 0,
    repairReminderHeight = 0,
    repairReminderTest = false,
    repairReminderPos = nil,
    repairReminderAlpha = 0.95,
    repairReminderTextOverride = "",
    dungeonReminderEnabled = true,
    dungeonReminderUnlocked = true,
    dungeonReminderTextColor = { 1, 1, 1 },
    dungeonReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    dungeonReminderAlpha = 0.95,
    dungeonReminderWidth = 0,
    dungeonReminderHeight = 0,
    dungeonReminderTextOverride = "",
    dungeonReminderTest = false,
    dungeonReminderPos = nil,
    buffWatchEnabled = true,
    buffWatchTextColor = { 1, 1, 1 },
    buffWatchBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    buffWatchAlpha = 0.95,
    buffWatchWidth = 0,
    buffWatchHeight = 0,
    buffWatchTest = false,
    buffWatchPos = nil,
    dungeonConsumablesEnabled = true,
    dungeonConsumablesTextColor = { 1, 1, 1 },
    dungeonConsumablesBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    dungeonConsumablesAlpha = 0.95,
    dungeonConsumablesWidth = 0,
    dungeonConsumablesHeight = 0,
    dungeonConsumablesTest = false,
    dungeonConsumablesPos = nil,
    keystoneReminderEnabled = true,
    keystoneReminderTextColor = { 1, 1, 1 },
    keystoneReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    keystoneReminderAlpha = 0.95,
    keystoneReminderWidth = 0,
    keystoneReminderHeight = 0,
    keystoneReminderTest = false,
    keystoneReminderPos = nil,
    dungeonRoleMarksEnabled = true,
    dungeonTankMark = 6,
    dungeonHealerMark = 2,
    warlockPetReminderEnabled = false,
    warlockPetReminderTextColor = { 1, 1, 1 },
    warlockPetReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    warlockPetReminderAlpha = 0.95,
    warlockPetReminderWidth = 0,
    warlockPetReminderHeight = 0,
    warlockPetReminderTest = false,
    warlockPetReminderPos = nil,
    warlockStoneReminderEnabled = false,
    warlockStoneReminderTextColor = { 1, 1, 1 },
    warlockStoneReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    warlockStoneReminderAlpha = 0.95,
    warlockStoneReminderWidth = 0,
    warlockStoneReminderHeight = 0,
    warlockStoneReminderTest = false,
    warlockStoneReminderPos = nil,
    warlockRushReminderEnabled = false,
    warlockRushReminderTextColor = { 1, 1, 1 },
    warlockRushReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    warlockRushReminderAlpha = 0.95,
    warlockRushReminderShowBg = false,
    warlockRushReminderFlash = true,
    warlockRushReminderSoundEnabled = true,
    warlockRushReminderTextOverride = "",
    warlockRushReminderWidth = 0,
    warlockRushReminderHeight = 0,
    warlockRushReminderTest = false,
    warlockRushReminderPos = nil,
    hunterPetReminderEnabled = false,
    hunterPetReminderTextColor = { 1, 1, 1 },
    hunterPetReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    hunterPetReminderAlpha = 0.95,
    hunterPetReminderWidth = 0,
    hunterPetReminderHeight = 0,
    hunterPetReminderTest = false,
    hunterPetReminderPos = nil,
    autoKeystoneEnabled = true,
    warriorBuffEnabled = false,
    warriorBuffTextColor = { 1, 1, 1 },
    warriorBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    warriorBuffAlpha = 0.95,
    warriorBuffWidth = 0,
    warriorBuffHeight = 0,
    warriorBuffTest = false,
    warriorBuffPos = nil,
    mageBuffEnabled = false,
    mageBuffTextColor = { 1, 1, 1 },
    mageBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    mageBuffAlpha = 0.95,
    mageBuffWidth = 0,
    mageBuffHeight = 0,
    mageBuffTest = false,
    mageBuffPos = nil,
    priestBuffEnabled = false,
    priestBuffTextColor = { 1, 1, 1 },
    priestBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    priestBuffAlpha = 0.95,
    priestBuffWidth = 0,
    priestBuffHeight = 0,
    priestBuffTest = false,
    priestBuffPos = nil,
    druidBuffEnabled = false,
    druidBuffTextColor = { 1, 1, 1 },
    druidBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    druidBuffAlpha = 0.95,
    druidBuffWidth = 0,
    druidBuffHeight = 0,
    druidBuffTest = false,
    druidBuffPos = nil,
    shamanBuffEnabled = false,
    shamanBuffTextColor = { 1, 1, 1 },
    shamanBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    shamanBuffAlpha = 0.95,
    shamanBuffWidth = 0,
    shamanBuffHeight = 0,
    shamanBuffTest = false,
    shamanBuffPos = nil,
    evokerBuffEnabled = false,
    evokerBuffTextColor = { 1, 1, 1 },
    evokerBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    evokerBuffAlpha = 0.95,
    evokerBuffWidth = 0,
    evokerBuffHeight = 0,
    evokerBuffTest = false,
    evokerBuffPos = nil,
    roguePoisonEnabled = false,
    roguePoisonTextColor = { 1, 1, 1 },
    roguePoisonBgColor = { Elysian.HexToRGB(Elysian.theme.bg) },
    roguePoisonAlpha = 0.95,
    roguePoisonWidth = 0,
    roguePoisonHeight = 0,
    roguePoisonTest = false,
    roguePoisonPos = nil,
  }
end

local function BuildClassProfile(class)
  local state = Elysian.GetDefaultState()
  -- Turn on all QOL features by default
  state.scrapSellerEnabled = true
  state.cursorRingEnabled = true
  state.autoRepairEnabled = true
  state.infoBarEnabled = true
  state.autoKeystoneEnabled = true

  -- Alerts defaults
  state.repairReminderEnabled = true
  state.dungeonReminderEnabled = true
  state.buffWatchEnabled = true
  state.dungeonConsumablesEnabled = true
  state.dungeonRoleMarksEnabled = true
  state.deathSoundEnabled = true

  -- Class-specific alerts
  if class == "WARLOCK" then
    state.warlockPetReminderEnabled = true
    state.warlockStoneReminderEnabled = true
    state.warlockRushReminderEnabled = true
  elseif class == "HUNTER" then
    state.hunterPetReminderEnabled = true
  elseif class == "WARRIOR" then
    state.warriorBuffEnabled = true
  elseif class == "MAGE" then
    state.mageBuffEnabled = true
  elseif class == "PRIEST" then
    state.priestBuffEnabled = true
  elseif class == "DRUID" then
    state.druidBuffEnabled = true
  elseif class == "SHAMAN" then
    state.shamanBuffEnabled = true
  elseif class == "EVOKER" then
    state.evokerBuffEnabled = true
  elseif class == "ROGUE" then
    state.roguePoisonEnabled = true
  end

  return state
end

local function EnsureClassProfiles()
  if not ElysianDB then
    return
  end
  ElysianDB.profiles = ElysianDB.profiles or {}
  local classes = {
    "WARRIOR",
    "PALADIN",
    "HUNTER",
    "ROGUE",
    "PRIEST",
    "DEATHKNIGHT",
    "SHAMAN",
    "MAGE",
    "WARLOCK",
    "DRUID",
    "MONK",
    "DEMONHUNTER",
    "EVOKER",
  }
  for _, class in ipairs(classes) do
    if not ElysianDB.profiles[class] then
      ElysianDB.profiles[class] = BuildClassProfile(class)
    end
  end
end

function Elysian.GetCharacterKey()
  local name = UnitName and UnitName("player") or "Unknown"
  local realm = GetRealmName and GetRealmName() or ""
  if realm == "" then
    realm = "Unknown"
  end
  return string.format("%s-%s", name or "Unknown", realm)
end

function Elysian.GetProfileNames()
  local names = {}
  if ElysianDB and ElysianDB.profiles then
    for name in pairs(ElysianDB.profiles) do
      table.insert(names, name)
    end
  end
  table.sort(names)
  return names
end

function Elysian.GetActiveProfile()
  if not ElysianDB or not ElysianDB.charProfiles then
    return "Default"
  end
  local key = Elysian.GetCharacterKey()
  return ElysianDB.charProfiles[key] or "Default"
end

function Elysian.SetActiveProfile(name)
  if not ElysianDB then
    return
  end
  ElysianDB.charProfiles = ElysianDB.charProfiles or {}
  local key = Elysian.GetCharacterKey()
  ElysianDB.charProfiles[key] = name
end

local function MergeProfile(profile)
  local state = Elysian.GetDefaultState()
  if type(profile) == "table" then
    for k, v in pairs(profile) do
      if type(v) == "table" then
        state[k] = CopyTable(v)
      else
        state[k] = v
      end
    end
  end
  return state
end

function Elysian.RefreshFeatures()
  if Elysian.Features and Elysian.Features.CursorRing then
    Elysian.Features.CursorRing:Initialize()
    Elysian.Features.CursorRing:Refresh()
  end
  if Elysian.Features and Elysian.Features.InfoBar then
    Elysian.Features.InfoBar:Initialize()
    Elysian.Features.InfoBar:Refresh()
  end
  if Elysian.Features and Elysian.Features.RepairReminder then
    Elysian.Features.RepairReminder:Initialize()
    Elysian.Features.RepairReminder:Refresh()
  end
  if Elysian.Features and Elysian.Features.DungeonReminder then
    Elysian.Features.DungeonReminder:Initialize()
    Elysian.Features.DungeonReminder:Refresh()
  end
  if Elysian.Features and Elysian.Features.DeathSound then
    Elysian.Features.DeathSound:Initialize()
    Elysian.Features.DeathSound:Refresh()
  end
  if Elysian.Features and Elysian.Features.BuffWatch then
    Elysian.Features.BuffWatch:Initialize()
    Elysian.Features.BuffWatch:Refresh()
  end
  if Elysian.Features and Elysian.Features.DungeonConsumables then
    Elysian.Features.DungeonConsumables:Initialize()
    Elysian.Features.DungeonConsumables:Refresh()
  end
  if Elysian.Features and Elysian.Features.ClassBuffReminders then
    Elysian.Features.ClassBuffReminders:Initialize()
    Elysian.Features.ClassBuffReminders:Refresh()
  end
  if Elysian.Features and Elysian.Features.WarlockReminders then
    Elysian.Features.WarlockReminders:Initialize()
    Elysian.Features.WarlockReminders:Refresh()
  end
  if Elysian.Features and Elysian.Features.HunterReminders then
    Elysian.Features.HunterReminders:Initialize()
    Elysian.Features.HunterReminders:Refresh()
  end
  if Elysian.Features and Elysian.Features.AutoKeystone then
    Elysian.Features.AutoKeystone:Initialize()
    if Elysian.Features.AutoKeystone.Refresh then
      Elysian.Features.AutoKeystone:Refresh()
    end
  end
  if Elysian.Features and Elysian.Features.AutoRepair then
    if Elysian.Features.AutoRepair.Refresh then
      Elysian.Features.AutoRepair:Refresh()
    end
  end
  if Elysian.Features and Elysian.Features.ScrapSeller then
    if Elysian.Features.ScrapSeller.Refresh then
      Elysian.Features.ScrapSeller:Refresh()
    end
  end
end

function Elysian.SaveProfile(name)
  if not ElysianDB or not name or name == "" then
    return
  end
  ElysianDB.profiles = ElysianDB.profiles or {}
  ElysianDB.profiles[name] = CopyTable(Elysian.state or {})
  Elysian.SetActiveProfile(name)
  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function Elysian.DeleteProfile(name)
  if not ElysianDB or not ElysianDB.profiles or not name or name == "" then
    return
  end
  if name == "Default" then
    return
  end
  ElysianDB.profiles[name] = nil
  if Elysian.GetActiveProfile and Elysian.GetActiveProfile() == name then
    Elysian.SetActiveProfile("Default")
    Elysian.state = MergeProfile(ElysianDB.profiles.Default or Elysian.GetDefaultState())
    if Elysian.SaveState then
      Elysian.SaveState()
    end
    if Elysian.UI and Elysian.UI.Rebuild then
      Elysian.UI:Rebuild()
      Elysian.UI:Show()
    end
    Elysian.RefreshFeatures()
  end
end
function Elysian.LoadProfile(name)
  if not ElysianDB or not ElysianDB.profiles or not ElysianDB.profiles[name] then
    return
  end
  local profile = ElysianDB.profiles[name]
  if type(name) == "string" then
    local class = string.upper(name)
    if class == "WARLOCK" then
      profile.warlockPetReminderEnabled = true
      profile.warlockStoneReminderEnabled = true
    elseif class == "HUNTER" then
      profile.hunterPetReminderEnabled = true
    elseif class == "WARRIOR" then
      profile.warriorBuffEnabled = true
    elseif class == "MAGE" then
      profile.mageBuffEnabled = true
    elseif class == "PRIEST" then
      profile.priestBuffEnabled = true
    elseif class == "DRUID" then
      profile.druidBuffEnabled = true
    elseif class == "SHAMAN" then
      profile.shamanBuffEnabled = true
    elseif class == "EVOKER" then
      profile.evokerBuffEnabled = true
    elseif class == "ROGUE" then
      profile.roguePoisonEnabled = true
    end
  end
  Elysian.state = MergeProfile(profile)
  Elysian.SetActiveProfile(name)
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  if Elysian.UI and Elysian.UI.Rebuild then
    Elysian.UI:Rebuild()
    Elysian.UI:Show()
  end
  Elysian.RefreshFeatures()
end

function Elysian.ResetSettings()
  local defaults = Elysian.GetDefaultState()
  for key, value in pairs(defaults) do
    Elysian.state[key] = value
  end
  Elysian.state.uiTextUseClassColor = true
  Elysian.state.uiTextColor = { Elysian.HexToRGB(Elysian.theme.fg) }
  local active = Elysian.GetActiveProfile and Elysian.GetActiveProfile() or "Default"
  if type(active) == "string" then
    local class = string.upper(active)
    if class == "WARLOCK" then
      Elysian.state.warlockPetReminderEnabled = true
      Elysian.state.warlockStoneReminderEnabled = true
      Elysian.state.warlockRushReminderEnabled = true
      Elysian.state.warlockRushReminderShowBg = false
      Elysian.state.warlockRushReminderFlash = true
      Elysian.state.warlockRushReminderSoundEnabled = true
    elseif class == "HUNTER" then
      Elysian.state.hunterPetReminderEnabled = true
    elseif class == "WARRIOR" then
      Elysian.state.warriorBuffEnabled = true
    elseif class == "MAGE" then
      Elysian.state.mageBuffEnabled = true
    elseif class == "PRIEST" then
      Elysian.state.priestBuffEnabled = true
    elseif class == "DRUID" then
      Elysian.state.druidBuffEnabled = true
    elseif class == "SHAMAN" then
      Elysian.state.shamanBuffEnabled = true
    elseif class == "EVOKER" then
      Elysian.state.evokerBuffEnabled = true
    elseif class == "ROGUE" then
      Elysian.state.roguePoisonEnabled = true
    end
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
    ElysianDB.scrapSellerEnabled = true
  end
  if ElysianDB.profiles == nil then
    ElysianDB.profiles = {}
  end
  if ElysianDB.charProfiles == nil then
    ElysianDB.charProfiles = {}
  end
  if not ElysianDB.profiles.Default then
    ElysianDB.profiles.Default = CopyTable(Elysian.GetDefaultState())
  end
  EnsureClassProfiles()
  for _, profile in pairs(ElysianDB.profiles) do
    if profile.cursorRingTrailRandom == nil then
      profile.cursorRingTrailRandom = false
    end
    if profile.infoBarShowPortalButton == nil then
      profile.infoBarShowPortalButton = true
    end
    if profile.warlockRushReminderFlash == nil then
      profile.warlockRushReminderFlash = true
    end
    if profile.warlockRushReminderSoundEnabled == nil then
      profile.warlockRushReminderSoundEnabled = true
    end
  end
  if ElysianDB.profiles.WARLOCK then
    if ElysianDB.profiles.WARLOCK.warlockRushReminderEnabled == nil then
      ElysianDB.profiles.WARLOCK.warlockRushReminderEnabled = true
    end
    if ElysianDB.profiles.WARLOCK.warlockRushReminderShowBg == nil then
      ElysianDB.profiles.WARLOCK.warlockRushReminderShowBg = false
    end
    if ElysianDB.profiles.WARLOCK.warlockRushReminderFlash == nil then
      ElysianDB.profiles.WARLOCK.warlockRushReminderFlash = true
    end
    if ElysianDB.profiles.WARLOCK.warlockRushReminderSoundEnabled == nil then
      ElysianDB.profiles.WARLOCK.warlockRushReminderSoundEnabled = true
    end
  end
  local charKey = Elysian.GetCharacterKey()
  if not ElysianDB.charProfiles[charKey] or ElysianDB.charProfiles[charKey] == "Default" then
    local _, class = UnitClass("player")
    if class and ElysianDB.profiles[class] then
      ElysianDB.charProfiles[charKey] = class
    else
      ElysianDB.charProfiles[charKey] = "Default"
    end
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
    ElysianDB.cursorRingEnabled = true
  end
  if ElysianDB.cursorRingSize == nil then
    ElysianDB.cursorRingSize = 52
  end
  if ElysianDB.cursorRingColor == nil then
    ElysianDB.cursorRingColor = { Elysian.HexToRGB(Elysian.theme.accent) }
  end
  if ElysianDB.cursorRingClassColor == nil then
    ElysianDB.cursorRingClassColor = true
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
    ElysianDB.cursorRingTrailEnabled = true
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
  if ElysianDB.cursorRingTrailRandom == nil then
    ElysianDB.cursorRingTrailRandom = false
  end
  if ElysianDB.cursorRingTrailFadeTime == nil then
    ElysianDB.cursorRingTrailFadeTime = 0.25
  end
  if ElysianDB.cursorRingTrailColor == nil then
    ElysianDB.cursorRingTrailColor = { Elysian.HexToRGB(Elysian.theme.accent) }
  end
  if ElysianDB.cursorRingTrailShape == nil then
    ElysianDB.cursorRingTrailShape = "SPARK"
  end
  if ElysianDB.autoRepairEnabled == nil then
    ElysianDB.autoRepairEnabled = true
  end
  if ElysianDB.autoRepairThreshold == nil then
    ElysianDB.autoRepairThreshold = 70
  end
  if ElysianDB.autoRepairUseGuild == nil then
    ElysianDB.autoRepairUseGuild = true
  end
  if ElysianDB.autoRepairLastCost == nil then
    ElysianDB.autoRepairLastCost = 0
  end
  if ElysianDB.autoRepairLastUsedGuild == nil then
    ElysianDB.autoRepairLastUsedGuild = false
  end
  if ElysianDB.uiFontScale == nil then
    ElysianDB.uiFontScale = 1.1
  end
  if ElysianDB.bannerWidth == nil then
    ElysianDB.bannerWidth = 0
  end
  if ElysianDB.bannerHeight == nil then
    ElysianDB.bannerHeight = 0
  end
  if ElysianDB.bannerTextOverride == nil then
    ElysianDB.bannerTextOverride = ""
  end
  if ElysianDB.bannerTestAll == nil then
    ElysianDB.bannerTestAll = false
  end
  if ElysianDB.infoBarEnabled == nil then
    ElysianDB.infoBarEnabled = true
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
  if ElysianDB.infoBarShowMemory == nil then
    ElysianDB.infoBarShowMemory = false
  end
  if ElysianDB.infoBarShowItemLevel == nil then
    ElysianDB.infoBarShowItemLevel = false
  end
  if ElysianDB.infoBarShowHearthstone == nil then
    ElysianDB.infoBarShowHearthstone = false
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
    ElysianDB.infoBarShowPortalButton = true
  end
  if ElysianDB.repairReminderEnabled == nil then
    ElysianDB.repairReminderEnabled = true
  end
  if ElysianDB.deathSoundEnabled == nil then
    ElysianDB.deathSoundEnabled = true
  end
  if ElysianDB.repairReminderUnlocked == nil then
    ElysianDB.repairReminderUnlocked = false
  end
  if ElysianDB.repairReminderTextColor == nil then
    ElysianDB.repairReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.repairReminderBgColor == nil then
    ElysianDB.repairReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.repairReminderAlpha == nil then
    ElysianDB.repairReminderAlpha = 0.95
  end
  if ElysianDB.repairReminderWidth == nil then
    ElysianDB.repairReminderWidth = 0
  end
  if ElysianDB.repairReminderHeight == nil then
    ElysianDB.repairReminderHeight = 0
  end
  if ElysianDB.repairReminderTextOverride == nil then
    ElysianDB.repairReminderTextOverride = ""
  end
  if ElysianDB.repairReminderTest == nil then
    ElysianDB.repairReminderTest = false
  end
  if ElysianDB.repairReminderPos == nil then
    ElysianDB.repairReminderPos = nil
  end
  if ElysianDB.dungeonReminderEnabled == nil then
    ElysianDB.dungeonReminderEnabled = true
  end
  if ElysianDB.dungeonReminderUnlocked == nil then
    ElysianDB.dungeonReminderUnlocked = true
  end
  if ElysianDB.dungeonReminderTextColor == nil then
    ElysianDB.dungeonReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.dungeonReminderBgColor == nil then
    ElysianDB.dungeonReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.dungeonReminderAlpha == nil then
    ElysianDB.dungeonReminderAlpha = 0.95
  end
  if ElysianDB.dungeonReminderWidth == nil then
    ElysianDB.dungeonReminderWidth = 0
  end
  if ElysianDB.dungeonReminderHeight == nil then
    ElysianDB.dungeonReminderHeight = 0
  end
  if ElysianDB.dungeonReminderTextOverride == nil then
    ElysianDB.dungeonReminderTextOverride = ""
  end
  if ElysianDB.dungeonReminderTest == nil then
    ElysianDB.dungeonReminderTest = false
  end
  if ElysianDB.dungeonReminderPos == nil then
    ElysianDB.dungeonReminderPos = nil
  end
  if ElysianDB.buffWatchEnabled == nil then
    ElysianDB.buffWatchEnabled = true
  end
  if ElysianDB.buffWatchTextColor == nil then
    ElysianDB.buffWatchTextColor = { 1, 1, 1 }
  end
  if ElysianDB.buffWatchBgColor == nil then
    ElysianDB.buffWatchBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.buffWatchAlpha == nil then
    ElysianDB.buffWatchAlpha = 0.95
  end
  if ElysianDB.buffWatchWidth == nil then
    ElysianDB.buffWatchWidth = 0
  end
  if ElysianDB.buffWatchHeight == nil then
    ElysianDB.buffWatchHeight = 0
  end
  if ElysianDB.buffWatchTest == nil then
    ElysianDB.buffWatchTest = false
  end
  if ElysianDB.buffWatchPos == nil then
    ElysianDB.buffWatchPos = nil
  end
  if ElysianDB.dungeonConsumablesEnabled == nil then
    ElysianDB.dungeonConsumablesEnabled = true
  end
  if ElysianDB.dungeonConsumablesTextColor == nil then
    ElysianDB.dungeonConsumablesTextColor = { 1, 1, 1 }
  end
  if ElysianDB.dungeonConsumablesBgColor == nil then
    ElysianDB.dungeonConsumablesBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.dungeonConsumablesAlpha == nil then
    ElysianDB.dungeonConsumablesAlpha = 0.95
  end
  if ElysianDB.keystoneReminderEnabled == nil then
    ElysianDB.keystoneReminderEnabled = true
  end
  if ElysianDB.keystoneReminderTextColor == nil then
    ElysianDB.keystoneReminderTextColor = nil
  end
  if ElysianDB.keystoneReminderBgColor == nil then
    ElysianDB.keystoneReminderBgColor = nil
  end
  if ElysianDB.keystoneReminderAlpha == nil then
    ElysianDB.keystoneReminderAlpha = 0.95
  end
  if ElysianDB.keystoneReminderWidth == nil then
    ElysianDB.keystoneReminderWidth = 0
  end
  if ElysianDB.keystoneReminderHeight == nil then
    ElysianDB.keystoneReminderHeight = 0
  end
  if ElysianDB.keystoneReminderTest == nil then
    ElysianDB.keystoneReminderTest = false
  end
  if ElysianDB.keystoneReminderPos == nil then
    ElysianDB.keystoneReminderPos = nil
  end
  if ElysianDB.dungeonConsumablesWidth == nil then
    ElysianDB.dungeonConsumablesWidth = 0
  end
  if ElysianDB.dungeonConsumablesHeight == nil then
    ElysianDB.dungeonConsumablesHeight = 0
  end
  if ElysianDB.dungeonConsumablesTest == nil then
    ElysianDB.dungeonConsumablesTest = false
  end
  if ElysianDB.dungeonConsumablesPos == nil then
    ElysianDB.dungeonConsumablesPos = nil
  end
  if ElysianDB.dungeonRoleMarksEnabled == nil then
    ElysianDB.dungeonRoleMarksEnabled = true
  end
  if ElysianDB.dungeonTankMark == nil then
    ElysianDB.dungeonTankMark = 6
  end
  if ElysianDB.dungeonHealerMark == nil then
    ElysianDB.dungeonHealerMark = 2
  end
  if ElysianDB.warlockPetReminderEnabled == nil then
    ElysianDB.warlockPetReminderEnabled = false
  end
  if ElysianDB.warlockPetReminderTextColor == nil then
    ElysianDB.warlockPetReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.warlockPetReminderBgColor == nil then
    ElysianDB.warlockPetReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.warlockPetReminderAlpha == nil then
    ElysianDB.warlockPetReminderAlpha = 0.95
  end
  if ElysianDB.warlockPetReminderWidth == nil then
    ElysianDB.warlockPetReminderWidth = 0
  end
  if ElysianDB.warlockPetReminderHeight == nil then
    ElysianDB.warlockPetReminderHeight = 0
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
  if ElysianDB.warlockStoneReminderBgColor == nil then
    ElysianDB.warlockStoneReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.warlockStoneReminderAlpha == nil then
    ElysianDB.warlockStoneReminderAlpha = 0.95
  end
  if ElysianDB.warlockStoneReminderWidth == nil then
    ElysianDB.warlockStoneReminderWidth = 0
  end
  if ElysianDB.warlockStoneReminderHeight == nil then
    ElysianDB.warlockStoneReminderHeight = 0
  end
  if ElysianDB.warlockStoneReminderTest == nil then
    ElysianDB.warlockStoneReminderTest = false
  end
  if ElysianDB.warlockStoneReminderPos == nil then
    ElysianDB.warlockStoneReminderPos = nil
  end
  if ElysianDB.warlockRushReminderEnabled == nil then
    ElysianDB.warlockRushReminderEnabled = false
  end
  if ElysianDB.warlockRushReminderTextColor == nil then
    ElysianDB.warlockRushReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.warlockRushReminderBgColor == nil then
    ElysianDB.warlockRushReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.warlockRushReminderAlpha == nil then
    ElysianDB.warlockRushReminderAlpha = 0.95
  end
  if ElysianDB.warlockRushReminderShowBg == nil then
    ElysianDB.warlockRushReminderShowBg = false
  end
  if ElysianDB.warlockRushReminderFlash == nil then
    ElysianDB.warlockRushReminderFlash = true
  end
  if ElysianDB.warlockRushReminderSoundEnabled == nil then
    ElysianDB.warlockRushReminderSoundEnabled = true
  end
  if ElysianDB.warlockRushReminderTextOverride == nil then
    ElysianDB.warlockRushReminderTextOverride = ""
  end
  if ElysianDB.warlockRushReminderWidth == nil then
    ElysianDB.warlockRushReminderWidth = 0
  end
  if ElysianDB.warlockRushReminderHeight == nil then
    ElysianDB.warlockRushReminderHeight = 0
  end
  if ElysianDB.warlockRushReminderTest == nil then
    ElysianDB.warlockRushReminderTest = false
  end
  if ElysianDB.warlockRushReminderPos == nil then
    ElysianDB.warlockRushReminderPos = nil
  end
  if ElysianDB.hunterPetReminderEnabled == nil then
    ElysianDB.hunterPetReminderEnabled = false
  end
  if ElysianDB.hunterPetReminderTextColor == nil then
    ElysianDB.hunterPetReminderTextColor = { 1, 1, 1 }
  end
  if ElysianDB.hunterPetReminderBgColor == nil then
    ElysianDB.hunterPetReminderBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.hunterPetReminderAlpha == nil then
    ElysianDB.hunterPetReminderAlpha = 0.95
  end
  if ElysianDB.hunterPetReminderWidth == nil then
    ElysianDB.hunterPetReminderWidth = 0
  end
  if ElysianDB.hunterPetReminderHeight == nil then
    ElysianDB.hunterPetReminderHeight = 0
  end
  if ElysianDB.hunterPetReminderTest == nil then
    ElysianDB.hunterPetReminderTest = false
  end
  if ElysianDB.hunterPetReminderPos == nil then
    ElysianDB.hunterPetReminderPos = nil
  end
  if ElysianDB.warriorBuffTextColor == nil then
    ElysianDB.warriorBuffTextColor = { 1, 1, 1 }
  end
  if ElysianDB.warriorBuffBgColor == nil then
    ElysianDB.warriorBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.warriorBuffAlpha == nil then
    ElysianDB.warriorBuffAlpha = 0.95
  end
  if ElysianDB.warriorBuffWidth == nil then
    ElysianDB.warriorBuffWidth = 0
  end
  if ElysianDB.warriorBuffHeight == nil then
    ElysianDB.warriorBuffHeight = 0
  end
  if ElysianDB.warriorBuffTest == nil then
    ElysianDB.warriorBuffTest = false
  end
  if ElysianDB.warriorBuffPos == nil then
    ElysianDB.warriorBuffPos = nil
  end
  if ElysianDB.mageBuffTextColor == nil then
    ElysianDB.mageBuffTextColor = { 1, 1, 1 }
  end
  if ElysianDB.mageBuffBgColor == nil then
    ElysianDB.mageBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.mageBuffAlpha == nil then
    ElysianDB.mageBuffAlpha = 0.95
  end
  if ElysianDB.mageBuffWidth == nil then
    ElysianDB.mageBuffWidth = 0
  end
  if ElysianDB.mageBuffHeight == nil then
    ElysianDB.mageBuffHeight = 0
  end
  if ElysianDB.mageBuffTest == nil then
    ElysianDB.mageBuffTest = false
  end
  if ElysianDB.mageBuffPos == nil then
    ElysianDB.mageBuffPos = nil
  end
  if ElysianDB.priestBuffTextColor == nil then
    ElysianDB.priestBuffTextColor = { 1, 1, 1 }
  end
  if ElysianDB.priestBuffBgColor == nil then
    ElysianDB.priestBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.priestBuffAlpha == nil then
    ElysianDB.priestBuffAlpha = 0.95
  end
  if ElysianDB.priestBuffWidth == nil then
    ElysianDB.priestBuffWidth = 0
  end
  if ElysianDB.priestBuffHeight == nil then
    ElysianDB.priestBuffHeight = 0
  end
  if ElysianDB.priestBuffTest == nil then
    ElysianDB.priestBuffTest = false
  end
  if ElysianDB.priestBuffPos == nil then
    ElysianDB.priestBuffPos = nil
  end
  if ElysianDB.druidBuffTextColor == nil then
    ElysianDB.druidBuffTextColor = { 1, 1, 1 }
  end
  if ElysianDB.druidBuffBgColor == nil then
    ElysianDB.druidBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.druidBuffAlpha == nil then
    ElysianDB.druidBuffAlpha = 0.95
  end
  if ElysianDB.druidBuffWidth == nil then
    ElysianDB.druidBuffWidth = 0
  end
  if ElysianDB.druidBuffHeight == nil then
    ElysianDB.druidBuffHeight = 0
  end
  if ElysianDB.druidBuffTest == nil then
    ElysianDB.druidBuffTest = false
  end
  if ElysianDB.druidBuffPos == nil then
    ElysianDB.druidBuffPos = nil
  end
  if ElysianDB.shamanBuffTextColor == nil then
    ElysianDB.shamanBuffTextColor = { 1, 1, 1 }
  end
  if ElysianDB.shamanBuffBgColor == nil then
    ElysianDB.shamanBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.shamanBuffAlpha == nil then
    ElysianDB.shamanBuffAlpha = 0.95
  end
  if ElysianDB.shamanBuffWidth == nil then
    ElysianDB.shamanBuffWidth = 0
  end
  if ElysianDB.shamanBuffHeight == nil then
    ElysianDB.shamanBuffHeight = 0
  end
  if ElysianDB.shamanBuffTest == nil then
    ElysianDB.shamanBuffTest = false
  end
  if ElysianDB.shamanBuffPos == nil then
    ElysianDB.shamanBuffPos = nil
  end
  if ElysianDB.evokerBuffTextColor == nil then
    ElysianDB.evokerBuffTextColor = { 1, 1, 1 }
  end
  if ElysianDB.evokerBuffBgColor == nil then
    ElysianDB.evokerBuffBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.evokerBuffAlpha == nil then
    ElysianDB.evokerBuffAlpha = 0.95
  end
  if ElysianDB.evokerBuffWidth == nil then
    ElysianDB.evokerBuffWidth = 0
  end
  if ElysianDB.evokerBuffHeight == nil then
    ElysianDB.evokerBuffHeight = 0
  end
  if ElysianDB.evokerBuffTest == nil then
    ElysianDB.evokerBuffTest = false
  end
  if ElysianDB.evokerBuffPos == nil then
    ElysianDB.evokerBuffPos = nil
  end
  if ElysianDB.roguePoisonTextColor == nil then
    ElysianDB.roguePoisonTextColor = { 1, 1, 1 }
  end
  if ElysianDB.roguePoisonBgColor == nil then
    ElysianDB.roguePoisonBgColor = { Elysian.HexToRGB(Elysian.theme.bg) }
  end
  if ElysianDB.roguePoisonAlpha == nil then
    ElysianDB.roguePoisonAlpha = 0.95
  end
  if ElysianDB.roguePoisonWidth == nil then
    ElysianDB.roguePoisonWidth = 0
  end
  if ElysianDB.roguePoisonHeight == nil then
    ElysianDB.roguePoisonHeight = 0
  end
  if ElysianDB.roguePoisonTest == nil then
    ElysianDB.roguePoisonTest = false
  end
  if ElysianDB.roguePoisonPos == nil then
    ElysianDB.roguePoisonPos = nil
  end
  if ElysianDB.autoKeystoneEnabled == nil then
    ElysianDB.autoKeystoneEnabled = true
  end
  if ElysianDB.minimapButtonAngle == nil then
    ElysianDB.minimapButtonAngle = 225
  end
  if ElysianDB.minimapButtonHidden == nil then
    ElysianDB.minimapButtonHidden = false
  end
  if ElysianDB.showAllClassAlerts == nil then
    ElysianDB.showAllClassAlerts = false
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

  local profileName = Elysian.GetActiveProfile()
  local profile = ElysianDB.profiles[profileName] or ElysianDB.profiles.Default or Elysian.GetDefaultState()
  Elysian.state = MergeProfile(profile)
  if profileName == "HUNTER" then
    Elysian.state.hunterPetReminderEnabled = true
  end
  if profileName == "ROGUE" then
    Elysian.state.roguePoisonEnabled = true
  end
  if profileName == "WARLOCK" and Elysian.state.warlockRushReminderEnabled == nil then
    Elysian.state.warlockRushReminderEnabled = true
  end
  if profileName == "WARLOCK" and Elysian.state.warlockRushReminderShowBg == nil then
    Elysian.state.warlockRushReminderShowBg = false
  end
  if profileName == "WARLOCK" and Elysian.state.warlockRushReminderFlash == nil then
    Elysian.state.warlockRushReminderFlash = true
  end
  if ElysianDB.minimapButtonAngle ~= nil then
    Elysian.state.minimapButtonAngle = ElysianDB.minimapButtonAngle
  elseif Elysian.state.minimapButtonAngle == nil then
    Elysian.state.minimapButtonAngle = 225
  end
  if ElysianDB.showAllClassAlerts ~= nil then
    Elysian.state.showAllClassAlerts = ElysianDB.showAllClassAlerts
  end
  if ElysianDB.showAllClassAlerts == nil then
    ElysianDB.showAllClassAlerts = false
    Elysian.state.showAllClassAlerts = false
  end
  Elysian.state.scrapSellerEnabled = Elysian.state.scrapSellerEnabled or false
  Elysian.state.showOnStart = Elysian.state.showOnStart ~= false
  Elysian.state.navBg = EnsureColorTable(Elysian.state.navBg, defaultNav)
  Elysian.state.contentBg = EnsureColorTable(Elysian.state.contentBg, defaultContent)
  Elysian.state.cursorRingColor = EnsureColorTable(
    Elysian.state.cursorRingColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  Elysian.state.cursorRingCastColor = EnsureColorTable(
    Elysian.state.cursorRingCastColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  Elysian.state.cursorRingTrailColor = EnsureColorTable(
    Elysian.state.cursorRingTrailColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  if Elysian.state.infoBarShowPortalButton == nil then
    Elysian.state.infoBarShowPortalButton = true
  end
  Elysian.state.uiTextColor = EnsureColorTable(
    Elysian.state.uiTextColor,
    { Elysian.HexToRGB(Elysian.theme.fg) }
  )
  if type(Elysian.state.bannerWidth) ~= "number" then
    Elysian.state.bannerWidth = 0
  end
  if type(Elysian.state.bannerHeight) ~= "number" then
    Elysian.state.bannerHeight = 0
  end
  if type(Elysian.state.bannerTextOverride) ~= "string" then
    Elysian.state.bannerTextOverride = ""
  end
  Elysian.state.infoBarTextColor = EnsureColorTable(
    Elysian.state.infoBarTextColor,
    { Elysian.HexToRGB(Elysian.theme.accent) }
  )
  Elysian.state.infoBarBgColor = EnsureColorTable(
    Elysian.state.infoBarBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.repairReminderTextColor = EnsureColorTable(
    Elysian.state.repairReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.repairReminderBgColor = EnsureColorTable(
    Elysian.state.repairReminderBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.dungeonReminderTextColor = EnsureColorTable(
    Elysian.state.dungeonReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.dungeonReminderBgColor = EnsureColorTable(
    Elysian.state.dungeonReminderBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.buffWatchTextColor = EnsureColorTable(
    Elysian.state.buffWatchTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.buffWatchBgColor = EnsureColorTable(
    Elysian.state.buffWatchBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.dungeonConsumablesTextColor = EnsureColorTable(
    Elysian.state.dungeonConsumablesTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.dungeonConsumablesBgColor = EnsureColorTable(
    Elysian.state.dungeonConsumablesBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.keystoneReminderTextColor = EnsureColorTable(
    Elysian.state.keystoneReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.keystoneReminderBgColor = EnsureColorTable(
    Elysian.state.keystoneReminderBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.warlockPetReminderTextColor = EnsureColorTable(
    Elysian.state.warlockPetReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.warlockPetReminderBgColor = EnsureColorTable(
    Elysian.state.warlockPetReminderBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.warlockStoneReminderTextColor = EnsureColorTable(
    Elysian.state.warlockStoneReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.warlockStoneReminderBgColor = EnsureColorTable(
    Elysian.state.warlockStoneReminderBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.hunterPetReminderTextColor = EnsureColorTable(
    Elysian.state.hunterPetReminderTextColor,
    { 1, 1, 1 }
  )
  Elysian.state.hunterPetReminderBgColor = EnsureColorTable(
    Elysian.state.hunterPetReminderBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.warriorBuffBgColor = EnsureColorTable(
    Elysian.state.warriorBuffBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.mageBuffBgColor = EnsureColorTable(
    Elysian.state.mageBuffBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.priestBuffBgColor = EnsureColorTable(
    Elysian.state.priestBuffBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.druidBuffBgColor = EnsureColorTable(
    Elysian.state.druidBuffBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.shamanBuffBgColor = EnsureColorTable(
    Elysian.state.shamanBuffBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.evokerBuffBgColor = EnsureColorTable(
    Elysian.state.evokerBuffBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.roguePoisonBgColor = EnsureColorTable(
    Elysian.state.roguePoisonBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )
  Elysian.state.warlockRushReminderBgColor = EnsureColorTable(
    Elysian.state.warlockRushReminderBgColor,
    { Elysian.HexToRGB(Elysian.theme.bg) }
  )

  if Elysian.SaveState then
    Elysian.SaveState()
  end
end

function Elysian.SaveState()
  if type(ElysianDB) ~= "table" then
    ElysianDB = {}
  end
  ElysianDB.profiles = ElysianDB.profiles or {}
  ElysianDB.charProfiles = ElysianDB.charProfiles or {}
  local active = Elysian.GetActiveProfile()
  ElysianDB.profiles[active] = CopyTable(Elysian.state or {})
  if Elysian.state and Elysian.state.minimapButtonAngle ~= nil then
    ElysianDB.minimapButtonAngle = Elysian.state.minimapButtonAngle
  end
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

function Elysian.GetBannerOffsetY()
  if UIParent and UIParent.GetHeight then
    return (UIParent:GetHeight() or 0) * 0.25
  end
  return 0
end

function Elysian.GetBannerSize(defaultWidth, defaultHeight)
  local width = tonumber(Elysian.state.bannerWidth or 0) or 0
  local height = tonumber(Elysian.state.bannerHeight or 0) or 0
  if width <= 0 then
    width = defaultWidth
  end
  if height <= 0 then
    height = defaultHeight
  end
  return width, height
end

function Elysian.GetBannerOverride()
  local text = Elysian.state.bannerTextOverride
  if type(text) == "string" and text:match("%S") then
    return text
  end
  return nil
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

  checkbox:SetScale(0.84)
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

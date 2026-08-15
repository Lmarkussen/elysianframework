-- Regression coverage for profile serialization of boolean preferences.
-- Run with: lua tests/test_settings_persistence.lua

local function assertEqual(actual, expected, message)
  if actual ~= expected then
    error(string.format("%s (expected %s, got %s)", message, tostring(expected), tostring(actual)))
  end
end

-- Minimal WoW API surface needed by Core.lua's profile initialization.
function UnitName()
  return "SettingsTest"
end

function GetRealmName()
  return "TestRealm"
end

function UnitClass()
  return "Mage", "MAGE"
end

local Elysian = {}
assert(loadfile("Modules/Core.lua"))("ElysianFramework", Elysian)

local profileName = "SettingsRegression"
ElysianDB = {
  version = 3,
  profiles = {
    Default = Elysian.GetDefaultState(),
    [profileName] = Elysian.GetDefaultState(),
  },
  charProfiles = {
    [Elysian.GetCharacterKey()] = profileName,
  },
}

-- Equivalent to disabling several Info Bar checkboxes before clicking Save.
Elysian.state = Elysian.GetDefaultState()
Elysian.state.infoBarShowTime = false
Elysian.state.infoBarShowGold = false
Elysian.state.infoBarShowFPS = false
Elysian.state.infoBarShowMS = false
Elysian.state.cursorRingEnabled = false
Elysian.SaveState()

local saved = ElysianDB.profiles[profileName]
assertEqual(saved.infoBarShowTime, false, "disabled time must be serialized as false")
assertEqual(saved.infoBarShowGold, false, "disabled gold must be serialized as false")
assertEqual(saved.infoBarShowFPS, false, "disabled FPS must be serialized as false")
assertEqual(saved.infoBarShowMS, false, "disabled latency must be serialized as false")
assertEqual(saved.infoBarShowDurability, true, "enabled durability must remain true")
assertEqual(saved.cursorRingEnabled, false, "neighboring QoL checkbox must also serialize false")

-- Profile load represents navigating away/reopening settings after Save.
Elysian.state = Elysian.GetDefaultState()
Elysian.LoadProfile(profileName)
assertEqual(Elysian.state.infoBarShowTime, false, "profile load must preserve disabled time")
assertEqual(Elysian.state.infoBarShowGold, false, "profile load must preserve disabled gold")
assertEqual(Elysian.state.infoBarShowFPS, false, "profile load must preserve disabled FPS")
assertEqual(Elysian.state.infoBarShowMS, false, "profile load must preserve disabled latency")
assertEqual(Elysian.state.cursorRingEnabled, false, "profile load must preserve neighboring QoL false values")

-- Initialization represents the SavedVariables path used after /reload.
Elysian.state = {}
Elysian.InitSavedVariables()
assertEqual(Elysian.state.infoBarShowTime, false, "initialization must not replace saved false with default true")
assertEqual(Elysian.state.infoBarShowGold, false, "initialization must preserve multiple saved false values")
assertEqual(Elysian.state.infoBarShowFPS, false, "runtime Info Bar state must receive saved FPS value")
assertEqual(Elysian.state.infoBarShowMS, false, "runtime Info Bar state must receive saved latency value")
assertEqual(Elysian.state.cursorRingEnabled, false, "initialization must preserve neighboring QoL false values")

-- Re-enabling must also round-trip correctly.
Elysian.state.infoBarShowGold = true
Elysian.state.infoBarShowFPS = true
Elysian.SaveState()
Elysian.LoadProfile(profileName)
assertEqual(Elysian.state.infoBarShowGold, true, "re-enabled gold must be saved")
assertEqual(Elysian.state.infoBarShowFPS, true, "re-enabled FPS must be saved")

print("settings persistence regression tests passed")

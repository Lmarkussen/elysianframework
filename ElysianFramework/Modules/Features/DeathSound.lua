local _, Elysian = ...

Elysian.Features = Elysian.Features or {}
local DeathSound = {}
Elysian.Features.DeathSound = DeathSound

function DeathSound:IsEnabled()
  return Elysian.state.deathSoundEnabled and true or false
end

function DeathSound:SetEnabled(enabled)
  Elysian.state.deathSoundEnabled = enabled and true or false
  if Elysian.SaveState then
    Elysian.SaveState()
  end
  if not enabled then
    self:StopSound()
  end
end

function DeathSound:PlaySound()
  if not self:IsEnabled() then
    return
  end
  if self.played then
    return
  end
  if PlaySoundFile then
    local path = "Interface\\AddOns\\ElysianFramework\\Sounds\\error.ogg"
    local willPlay, handle = PlaySoundFile(path, "Master")
    if willPlay then
      self.handle = handle
    end
  end
  self.played = true
end

function DeathSound:StopSound()
  if self.handle and StopSound then
    StopSound(self.handle)
  end
  self.handle = nil
  self.played = false
end

function DeathSound:EnsureEvents()
  if self.eventFrame then
    return
  end
  local events = CreateFrame("Frame")
  events:RegisterEvent("PLAYER_DEAD")
  events:RegisterEvent("PLAYER_UNGHOST")
  events:RegisterEvent("PLAYER_ALIVE")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_DEAD" then
      self:PlaySound()
    else
      self:StopSound()
    end
  end)
  self.eventFrame = events
end

function DeathSound:Initialize()
  self:EnsureEvents()
end

function DeathSound:Refresh()
  self:EnsureEvents()
end


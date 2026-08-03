-- Lets you pick who you play as. Choose a character in the mod menu
-- and your overworld sprite (walking and biking) changes to match.
-- Pick "Red" to leave the default character untouched.
return function(mod)
  local characters = {
    { "Red (Default)", "default" },
    { "Youngster",  "youngster" },
    { "Scientist",  "scientist" },
    { "Rocket",     "rocket" },
    { "Giovanni",   "giovanni" },
    { "Gentleman",  "gentleman" },
    { "Clefairy",   "fairy" },
    { "Daisy",      "daisy" },
    { "Cook",       "cook" },
    { "Channeler",  "channeler" },
    { "Bruno",      "bruno" },
    { "Pidgey",     "bird" },
  }

  mod.options:define({
    { key = "character", label = "PLAYER CHARACTER", type = "choice",
      default = "default", choices = characters },
  })

  local pick = mod.options:get("character")
  if pick ~= "default" then
    local sheet = mod.path .. "/assets/sprites/" .. pick .. ".png"
    mod.content.sprites:override("SPRITE_RED", {
      image = sheet, frames = 6, walker = true, trueColor = true,
    })
    mod.content.sprites:override("SPRITE_RED_BIKE", {
      image = sheet, frames = 6, walker = true, trueColor = true,
    })
  end

  -- Changing the option just updates a stored value -- nothing rebuilds
  -- until a restart. Restarting on every single pick would mean one full
  -- restart per click while browsing choices, so instead: remember that
  -- something changed, and only actually restart once, when the F10 mod
  -- menu closes (screen.popped fires for that specific screen).
  local dirty = false
  mod.events:on("mod.options_changed", function(e)
    if e.mod == mod.id and e.key == "character" then
      dirty = true
    end
  end)

  local ManagerState = require("src.mods.ManagerState")
  mod.events:on("screen.popped", function(e)
    if dirty and getmetatable(e.state) == ManagerState then
      dirty = false
      require("src.core.HostShell").restart()
    end
  end)
end

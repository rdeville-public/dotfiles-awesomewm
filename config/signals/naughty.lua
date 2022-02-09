local naughty = require("naughty")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error",
  function(message, startup)
    naughty.notification {
      urgency = "critical",
      title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
      message = message
    }
  end
)

-- Store notifications to the file
naughty.connect_signal("added", function(n)
    local file = io.open(os.getenv("HOME") .. "/.cache/awesome/naughty_history", "a")
    file:write(n.title .. ": " .. n.message .. "\n")
    file:close()
end)


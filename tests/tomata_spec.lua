local tomata = require("tomata")

---@diagnostic disable: undefined-field
local eq = assert.are.same

local find_message = function(message)
  local messages = vim.api.nvim_exec(":messages", true)
  return messages:find(message)
end

describe("Tomata", function()
  it("can start a pomodoro timer", function()
    tomata.setup({ duration = 1 })
    tomata.start()

    local timer = tomata.pomodoro_timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), true)
    assert(find_message("Starting pomodoro timer for 1 minute"), "Expected start message not found")
  end)
end)

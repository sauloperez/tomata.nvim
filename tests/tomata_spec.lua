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

  it("pluralizes the output message", function()
    tomata.setup({ duration = 2 })
    tomata.start()

    local timer = tomata.pomodoro_timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), true)
    assert(find_message("Starting pomodoro timer for 2 minutes"), "Expected start message not found")
  end)

  it("can stop a pomodoro timer", function()
    tomata.setup({ duration = 1 })
    tomata.start()
    tomata.stop()

    local timer = tomata.pomodoro_timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), false)
    eq(timer:is_closing(), true)
    assert(find_message("Timer stopped"), "Expected stop message not found")
  end)
end)

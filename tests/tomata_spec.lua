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

    local timer = tomata.pomodoro.timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), true)
    eq(timer:get_due_in(), 60 * 1000)
    assert(find_message("Starting pomodoro timer for 1 minute"), "Expected start message not found")
  end)

  -- it("stops the timer when the time is up", function()
  --   tomata.setup({ duration = 1 })
  --   tomata.start()
  --
  --   local timer = tomata.pomodoro.timer
  --   if not timer then
  --     error("Timer is nil")
  --   end
  --
  --   eq(timer:is_active(), false)
  --   eq(timer:is_closing(), true)
  --   assert(find_message("Time is up!"), "Expected time is up message not found")
  -- end)

  it("it handles 0 duration", function()
    tomata.setup({ duration = 0 })
    tomata.start()

    local timer = tomata.pomodoro.timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), true)
    eq(timer:get_due_in(), 0)
    assert(find_message("Starting pomodoro timer for 0 minute"), "Expected start message not found")
  end)

  it("it handles negative duration", function()
    tomata.setup({ duration = -1 })
    tomata.start()

    local timer = tomata.pomodoro.timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), true)
    assert(timer:get_due_in() < 0)
    assert(find_message("Starting pomodoro timer for -1 minute"), "Expected start message not found")
  end)

  it("can restart a pomodoro timer after stopping", function()
    tomata.setup({ duration = 1 })
    tomata.start()
    tomata.stop()

    local timer = tomata.pomodoro.timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), false)
    eq(timer:is_closing(), true)
    assert(find_message("Timer stopped"), "Expected stop message not found")

    tomata.start()

    timer = tomata.pomodoro.timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), true)
    eq(timer:get_due_in(), 60 * 1000)
    assert(find_message("Starting pomodoro timer for 1 minute"), "Expected restart message not found")
  end)

  it("pluralizes the output message", function()
    tomata.setup({ duration = 2 })
    tomata.start()

    local timer = tomata.pomodoro.timer
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

    local timer = tomata.pomodoro.timer
    if not timer then
      error("Timer is nil")
    end

    eq(timer:is_active(), false)
    eq(timer:is_closing(), true)
    assert(find_message("Timer stopped"), "Expected stop message not found")
  end)

  it("defines a user command", function()
    tomata.setup()

    local cmds = vim.api.nvim_get_commands({ builtin = false })
    eq(cmds.Tomata.bang, true)
    eq(cmds.Tomata.name, "Tomata")
    eq(cmds.Tomata.nargs, "0")
  end)

  it("starts a break timer", function()
    tomata.setup({ break_duration = 1 })
    tomata.start_break()

    local break_timer = tomata._break.timer
    if not break_timer then
      error("Timer is nil")
    end

    eq(break_timer:is_active(), true)
    eq(break_timer:get_due_in(), 60 * 1000)
    assert(find_message("Starting break timer for 1 minute"), "Expected start message not found")
  end)
end)

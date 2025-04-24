local notify = function(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "🍅 Tomata" })
end

local min_to_milis = function(min)
  return min * 60 * 1000
end

local unit = function(time)
  if time == 1 then
    return "minute"
  end
  return "minutes"
end

local stop_timer = function(tomata_timer)
  local timer = tomata_timer.timer
  if timer then
    timer:stop()
    if not timer:is_closing() then
      timer:close()
    end
    timer = nil
  end
end

--@param timer tomata.Timer the timer to start
local start_timer = function(timer)
  if timer.timer then
    stop_timer(timer.timer)
  end

  timer.timer = vim.uv.new_timer()

  if not timer.timer then
    notify("Failed to create timer", vim.log.levels.ERROR)
    return
  end

  notify(timer.begin_msg)

  timer.timer:start(min_to_milis(timer.duration), 0, function()
    stop_timer(timer.timer)
    notify(timer.end_msg)

    if timer.callback then
      timer.callback()
    end
  end)
end

--@class tomata.Timer
--@field timer uv.Timer
--@field duration number
--@field begin_msg string
--@field end_msg string
--@field callback function|nil

local M = {
  pomodoro = {},
  _break = {},
}

local config = {
  duration = 25, -- in minutes
  break_duration = 5, -- in minutes
}

--@param opts table|nil Module options
function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend("force", config, opts)

  M._break = {
    timer = nil,
    duration = config.break_duration,
    begin_msg = "Starting break for " .. config.break_duration .. " " .. unit(config.break_duration),
    end_msg = "Back to work!",
  }
  M.pomodoro = {
    timer = nil,
    duration = config.duration,
    begin_msg = "Starting pomodoro timer for " .. config.duration .. " " .. unit(config.duration),
    end_msg = "Time is up!",
    callback = function()
      start_timer(M._break)
    end,
  }

  M.create_user_command()
end

function M.start()
  start_timer(M.pomodoro)
end

function M.start_break()
  start_timer(M._break)
end

function M.stop()
  notify("Timer stopped")
  stop_timer(M.pomodoro)
end

function M.create_user_command()
  vim.api.nvim_create_user_command("Tomata", function(opts)
    if opts.bang then
      M.stop()
      return
    end
    M.start()
  end, { bang = true })
end

return M

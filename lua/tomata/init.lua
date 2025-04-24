local notify = function(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "🍅 Tomata" })
end

local stop_timer = function(timer)
  if timer then
    timer:stop()
    if not timer:is_closing() then
      timer:close()
    end
    timer = nil
  end
end

local unit = function(time)
  if time == 1 then
    return "minute"
  end
  return "minutes"
end

local min_to_milis = function(min)
  return min * 60 * 1000
end

--@class tomata.Timer
--@field timer uv.Timer
--@field duration number
--@field begin_msg string
--@field end_msg string

local M = {
  pomodoro = {
    timer = nil,
  },
}

local config = {
  duration = 25, -- in minutes
}

--@param opts table|nil Module options
function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend("force", config, opts)

  M.create_user_command()
end

function M.start()
  if M.pomodoro.timer then
    stop_timer(M.pomodoro.timer)
  end

  M.pomodoro = {
    timer = vim.uv.new_timer(),
    duration = config.duration,
    begin_msg = "Starting pomodoro timer for " .. config.duration .. " " .. unit(config.duration),
    end_msg = "Time is up!",
  }

  if not M.pomodoro then
    notify("Failed to create timer", vim.log.levels.ERROR)
    return
  end

  notify(M.pomodoro.begin_msg)

  M.pomodoro.timer:start(min_to_milis(M.pomodoro.duration), 0, function()
    stop_timer(M.pomodoro.timer)
    notify(M.pomodoro.end_msg)
  end)
end

function M.stop()
  notify("Timer stopped")
  stop_timer(M.pomodoro.timer)
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

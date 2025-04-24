local notify = function(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "🍅 Tomata" })
end

local stop_timer = function(timer)
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local M = {}

local config = {
  duration = 25, -- in minutes
}

local pomodoro_timer = nil

--@param opts table|nil Module options
function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend("force", config, opts)

  M.create_user_command()
end

function M.start()
  if pomodoro_timer then
    M.stop()
  end

  pomodoro_timer = vim.uv.new_timer()

  if not pomodoro_timer then
    notify("Failed to create timer", vim.log.levels.ERROR)
    return
  end

  local unit = "minutes"
  if config.duration == 1 then
    unit = "minute"
  end

  notify("Starting pomodoro timer for " .. config.duration .. " " .. unit)

  pomodoro_timer:start(config.duration * 60 * 1000, 0, function()
    M.stop()
    notify("Time is up!")
  end)
end

function M.stop()
  stop_timer(pomodoro_timer)
end

function M.create_user_command()
  vim.api.nvim_create_user_command("Tomata", function(opts)
    if opts.bang then
      M.stop()
      notify("Timer stopped")
      return
    end
    M.start()
  end, { bang = true })
end

return M

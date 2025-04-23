local notify = function(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "🍅 Tomata" })
end

local M = {}

local config = {
	duration = 25, -- in minutes
}

local timer = nil

--@param opts table|nil Module options
function M.setup(opts)
	opts = opts or {}
	config = vim.tbl_deep_extend("force", config, opts)
end

function M.start()
	if timer then
		M.stop()
	end

	timer = vim.uv.new_timer()

	if not timer then
		notify("Failed to create timer", vim.log.levels.ERROR)
		return
	end

	local unit = "minutes"
	if config.duration == 1 then
		unit = "minute"
	end

	notify("Starting pomodoro timer for " .. config.duration .. " " .. unit)

	timer:start(config.duration * 60 * 1000, 0, function()
		M.stop()
		notify("Time is up!")
	end)
end

function M.stop()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
end

vim.api.nvim_create_user_command("Tomata", function(opts)
	if opts.bang then
		M.stop()
		notify("Timer stopped")
		return
	end
	M.start()
end, { bang = true })

return M

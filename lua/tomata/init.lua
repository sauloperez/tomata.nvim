local notify = function(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "🍅 Tomata" })
end

local config = {
	duration = 25, -- in minutes
}

local M = {
	timer = nil,
}

--@param opts table|nil Module options
function M.setup(opts)
	opts = opts or {}
	print("opts", opts)
	vim.tbl_deep_extend("force", config, opts)
end

function M.start()
	if M.timer then
		M.stop()
	end

	M.timer = vim.uv.new_timer()

	if not M.timer then
		notify("Failed to create timer", vim.log.levels.ERROR)
		return
	end

	notify("Starting pomodoro timer for " .. duration .. " minutes")

	M.timer:start(config.duration * 1000, 0, function()
		M.stop()
		notify("Time is up!")
	end)
end

function M.stop()
	if M.timer then
		M.timer:stop()
		M.timer:close()
		M.timer = nil
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

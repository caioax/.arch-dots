-- Command: Delete current file
vim.api.nvim_create_user_command("Delete", function()
	local file = vim.fn.expand("%:p")

	-- Safety check (Yes/No)
	local choice = vim.fn.confirm("Are you sure you want to delete the current file?\n" .. file, "&Yes\n&No", 2)

	if choice == 1 then
		-- Deletes file from disk
		local success, err = os.remove(file)
		if success then
			-- Force close buffer
			vim.cmd("bd!")
			vim.notify("File deleted: " .. file, vim.log.levels.WARN)
		else
			vim.notify("Error deleting file: " .. err, vim.log.levels.ERROR)
		end
	else
		vim.notify("Operation canceled.", vim.log.levels.INFO)
	end
end, { desc = "Delete current file from disk" })

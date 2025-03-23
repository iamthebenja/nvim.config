return {
	{
		"echasnovski/mini.nvim",
		enabled = true,
		config = function()
			local statusLine = require("mini.statusline")
			require("mini.ai").setup()
			require("mini.surround").setup()
			statusLine.setup({ use_icons = true })
		end,
	},
}

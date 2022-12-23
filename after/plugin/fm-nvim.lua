require('fm-nvim').setup{
	edit_cmd = "edit",
	ui = {
		default = "float",
		float = {
			-- Floating window border (see ':h nvim_open_win')
			border    = "rounded",
			float_hl  = "Normal",
			border_hl = "FloatBorder",
			blend     = 0,
			height    = 0.95,
			width     = 0.95,
			x         = 0.5,
			y         = 0.5
		},
		split = {
			direction = "topleft",
			size      = 24
		}
	},
	cmds = {
		lf_cmd      = "lf", -- eg: lf_cmd = "lf -command 'set hidden'"
		fzf_cmd     = "fzf", -- eg: fzf_cmd = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
		lazygit_cmd = "lazygit",
	},
	mappings = {
		vert_split = "<C-v>",
		horz_split = "<C-h>",
		tabedit    = "<C-t>",
		edit       = "<C-e>",
		ESC        = "<ESC>"
	},
}

local function lfInBufDir()
  local bufdir = vim.api.nvim_exec2([[echo expand("%:p:h")]], {output=true}).output
  vim.cmd('Lf '..bufdir)
end

vim.keymap.set('n', '<leader>lf', lfInBufDir)
vim.keymap.set('n', '<leader>lg', '<cmd>Lazygit<CR>')

local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

local function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

-- tests the functions above
local config_path = vim.fn.stdpath("config")
local file = config_path .. '/telerepos'
local extra_repos = lines_from(file)
local repos = {"~/.config/nvim", "~/repoja", "~/repos"}

if extra_repos then
  for _,v in ipairs(extra_repos) do
    table.insert(repos, v)
  end
end

return {{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable "make" == 1 end
    },
    "cljoly/telescope-repo.nvim",
  },
  keys = {
    {"<leader>fj", function() require'telescope'.extensions.repo.list({search_dirs = repos}) end, mode = "n"},
    {"<leader>ps", "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input(\"Grep For > \")})<CR>", mode = "n"},
    {"<leader>pa", "<cmd>lua require('telescope.builtin').live_grep()<CR>", mode = "n"},
    {"<C-p>", "<cmd>lua require('telescope.builtin').git_files({show_untracked=true})<CR>", mode = "n"},
    {"<Leader>pf", "<cmd>lua require'telescope.builtin'.find_files()<CR>", mode = "n"},
    {"<leader>pw", "<cmd>lua require'telescope.builtin'.grep_string()<CR>", mode = "n"},
    {"<leader>pb", "<cmd>lua require'telescope.builtin'.buffers()<CR>", mode = "n"},
    {"<leader>fh", "<cmd>lua require'telescope.builtin'.help_tags()<CR>", mode = "n"},
    {"<leader>gb", "<cmd>lua require'telescope.builtin'.git_bcommits()<CR>", mode = "n"},
    {"<leader>gc", "<cmd>lua require'telescope.builtin'.git_commits()<CR>", mode = "n"},
    {"<leader>gs", "<cmd>lua require'telescope.builtin'.git_status()<CR>", mode = "n"},
    {"<leader>gh", "<cmd>lua require'telescope.builtin'.git_branches()<CR>", mode = "n"},
  },
  cmd = "Telescope",
  config = function ()
    require'telescope'.load_extension'repo'

    local actions = require("telescope.actions")
    local action_state = require('telescope.actions.state')

    require'telescope'.setup({
      defaults = {
        layout_strategy='vertical',
        layout_config={width=0.95, height=0.95},
        mappings = {
          i = {
            ["<esc>"] = actions.close
            ,["<C-q>"] = actions.smart_send_to_qflist
            ,["<C-h>"] = "which_key"
            ,["<C-space>"] = actions.toggle_selection + actions.move_selection_previous
            ,["<C-w>"] = actions.delete_buffer
          }
        }
      },
      pickers = {
        git_commits = {
          mappings = {
            i = {
              ["<C-e>"] = function()
                -- Open in diffview
                local selected_entry = action_state.get_selected_entry()
                local value = selected_entry.value
                -- close Telescope window properly prior to switching windows
                vim.api.nvim_win_close(0, true)
                vim.cmd("stopinsert")
                vim.schedule(function()
                  vim.cmd(("DiffviewOpen %s^!"):format(value))
                end)
              end,
            }
          }
        }
      }
    })

  end
}}

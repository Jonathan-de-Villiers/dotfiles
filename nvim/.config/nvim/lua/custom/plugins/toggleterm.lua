return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      direction = 'horizontal',
      start_in_insert = true,
      persist_size = true,
      close_on_exit = true,
      shade_terminals = true,
    }

    local Terminal = require('toggleterm.terminal').Terminal

    local function set_terminal_keymaps()
      local opts = { buffer = 0 }

      -- Esc in terminal mode closes the terminal window
      vim.keymap.set('t', '<Esc>', [[<C-\><C-n><cmd>close<CR>]], opts)

      -- q in normal mode also closes it
      vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', opts)

      -- Move focus from terminal to code window
      vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = 'Terminal focus up' })

      -- Move focus from code window back to terminal window
      vim.keymap.set('n', '<C-j>', [[<C-w>j]], { desc = 'Focus terminal below' })
    end

    local function get_git_root()
      -- Directory of the current file
      local current_file_dir = vim.fn.expand '%:p:h'

      -- If current buffer has no file, use Neovim's current working directory
      if current_file_dir == '' then current_file_dir = vim.fn.getcwd() end

      -- Ask git for the repo root
      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(current_file_dir) .. ' rev-parse --show-toplevel')[1]

      -- If inside a git repo, use the git root
      if vim.v.shell_error == 0 and git_root ~= nil and git_root ~= '' then return git_root end

      -- Fallback if not inside a git repo
      return current_file_dir
    end

    local git_float = Terminal:new {
      direction = 'float',
      hidden = true,
      float_opts = {
        border = 'rounded',
        width = 100,
        height = 25,
      },
      on_open = function() set_terminal_keymaps() end,
      close_on_exit = true
    }

    local bottom_term = Terminal:new {
      direction = 'horizontal',
      size = function() return math.floor(vim.o.lines * 0.15) end,
      hidden = true,
      on_open = function() set_terminal_keymaps() end,
      close_on_exit = true
    }

    vim.keymap.set('n', '<leader>gg', function()
      git_float.dir = get_git_root()
      git_float:toggle()
    end, { desc = 'Git terminal float' })

    vim.keymap.set('n', '<leader>tt', function()
      bottom_term.dir = get_git_root()
      bottom_term:toggle()
    end, { desc = 'Bottom terminal' })
  end,
}

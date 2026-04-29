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
      vim.keymap.set('n', 'q', '<cmd>close<CR>', opts)
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
    }

    local bottom_term = Terminal:new {
      direction = 'horizontal',
      size = function() return math.floor(vim.o.lines * 0.25) end,
      hidden = true,
      on_open = function() set_terminal_keymaps() end,
    }

    vim.keymap.set('n', '<leader>gg', function() git_float:toggle() end, { desc = 'Git terminal float' })

    vim.keymap.set('n', '<leader>tt', function() bottom_term:toggle() end, { desc = 'Bottom terminal' })
  end,
}

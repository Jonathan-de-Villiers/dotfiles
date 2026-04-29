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

    -- Floating Git terminal
    local git_float = Terminal:new {
      direction = 'float',
      hidden = true,
      float_opts = {
        border = 'rounded',
        width = 100,
        height = 25,
      },
    }

    -- Bottom terminal (25% height)
    local bottom_term = Terminal:new {
      direction = 'horizontal',
      size = function() return math.floor(vim.o.lines * 0.25) end,
      hidden = true,
    }

    -- Keymaps to open terminals
    vim.keymap.set('n', '<leader>gg', function() git_float:toggle() end, { desc = 'Git terminal (float)' })

    vim.keymap.set('n', '<leader>tt', function() bottom_term:toggle() end, { desc = 'Bottom terminal' })

    -- Terminal mode mappings
    vim.keymap.set('t', '<Esc>', function()
      -- first Esc → exit insert mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', true)
    end, { desc = 'Exit terminal mode' })

    -- Normal mode inside terminal → Esc closes it
    vim.keymap.set('n', '<Esc>', function()
      if vim.bo.buftype == 'terminal' then vim.cmd 'close' end
    end, { desc = 'Close terminal if focused' })
  end,
}

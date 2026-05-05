return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = '[A]dd Harpoon file' })

    vim.keymap.set('n', '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon menu' })

    vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file [1]' })

    vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file [2]' })

    vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file [3]' })

    vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file [4]' })

    vim.keymap.set('n', '<leader>5', function() harpoon:list():select(5) end, { desc = 'Harpoon file [5]' })

    vim.keymap.set('n', '<leader>hr', function() list:remove() end, { desc = '[H]arpoon [R]emove current file' })

    vim.keymap.set('n', '<leader>hc', function() list:clear() end, { desc = '[H]arpoon [C]lear list' })

    vim.keymap.set('n', '<leader>hp', function() list:prev() end, { desc = '[H]arpoon [P]revious file' })

    vim.keymap.set('n', '<leader>hn', function() list:next() end, { desc = '[H]arpoon [N]ext file' })
  end,
}

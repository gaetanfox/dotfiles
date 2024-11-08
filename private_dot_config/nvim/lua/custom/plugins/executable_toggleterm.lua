return {
  {
    {
      'akinsho/toggleterm.nvim',
      version = '*',
      opts = {--[[ things you want to change go here]]
      },
      config = function()
        require('toggleterm').setup {
          size = 20,
          open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
          hide_numbers = true, -- hide the number column in toggleterm buffers
          auto_scroll = true, -- automatically scroll to the bottom on terminal output
          close_on_exit = true, -- close the terminal window when the process exits
          start_in_insert = true,
          insert_mappings = true, -- whether or not the open mapping applies in insert mode
          terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
          persist_size = true,
          persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
          direction = 'float',
          -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
        }
      end,
    },
  },
}

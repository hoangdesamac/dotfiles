return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Make lualine background transparent
      for _, section in pairs(opts.sections) do
        for _, component in ipairs(section) do
          if type(component) == "table" and component.color == nil then
            component.color = { bg = "none" }
          end
        end
      end
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        winblend = 20, -- make Telescope slightly transparent
      },
    },
  },

  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        groups = {
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLine",
          "CursorLineNr",
          "StatusLine",
          "StatusLineNC",
          "EndOfBuffer",
        },
        extra_groups = {
          "NormalFloat",
          "FloatBorder",
          "WinBar",
          "WinBarNC",
          "MsgArea",
        },
        exclude_groups = {},
      })
      -- enable transparency immediately
      vim.cmd("TransparentEnable")
    end,
  },
}

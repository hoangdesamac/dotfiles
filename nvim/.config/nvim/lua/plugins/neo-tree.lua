return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  -- Phím tắt bật/tắt nhanh: Space + e
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
  },
  config = function()
    -- Màu đường kẻ
    vim.cmd([[ highlight NeoTreeIndentMarker guifg=#3b4261 ]])

    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      -- Giao diện
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          default = "󰈙",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },

      -- Cấu hình hệ thống file
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,

        -- [QUAN TRỌNG] Gán phím tắt riêng cho chế độ Filesystem
        window = {
          mappings = {
            -- 1. Thoát & Đóng (Quan trọng cho Float)
            -- ["<Esc>"] = "close_window", -- Bấm Esc để tắt bảng
            --
            -- -- 2. Điều hướng & Mở file
            -- ["<cr>"] = "open", -- Enter: Mở file
            -- ["l"] = "open", -- l: Mở folder/file
            -- ["h"] = "close_node", -- h: Đóng folder
            -- ["<bs>"] = "navigate_up", -- Backspace: Lên thư mục cha

            -- 3. Chia cửa sổ (Splits)
            -- Lưu ý: Khi ở chế độ float, nó sẽ mở file chia đôi ở background
            -- ["S"] = "open_vsplit", -- Mở dọc (Vertical)
            -- ["s"] = "open_split", -- Mở ngang (Horizontal) - Đè lên phím Flash của LazyVim cục bộ

            -- 4. Thao tác File (CRUD)
            -- ["y"] = "copy_to_clipboard", -- Copy file (tương tự Ctrl+C)
            -- ["x"] = "cut_to_clipboard", -- Cut file (tương tự Ctrl+X)
            -- ["p"] = "paste_from_clipboard", -- Paste file (tương tự Ctrl+V)
            -- ["D"] = "copy", -- Duplicate (Nhân bản file tại chỗ)
          },
        },
      },

      -- Cấu hình chung cho cửa sổ Neo-tree
      window = {
        position = "left",
        width = 30,
        mapping_options = { noremap = true, nowait = true },
      },
    })
  end,
}

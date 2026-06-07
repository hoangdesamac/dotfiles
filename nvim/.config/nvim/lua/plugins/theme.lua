return {
  {
    "scottmckendry/cyberdream.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      -- Định nghĩa lại bảng màu dựa theo theme Box (Hack The Box)
      colors = {
        bg = "#141d2b", -- Màu nền tối của HTB
        fg = "#9fef00", -- Màu chữ chính (Xanh lá HTB rất rực)

        -- Các màu cơ bản (16 colors)
        black = "#000000",
        grey = "#767676", -- Thường dùng cho Comment
        red = "#cc0403",
        green = "#19cb00",
        yellow = "#cecb00",
        blue = "#0d73cc",
        magenta = "#cb1ed1",
        cyan = "#0dcdcd",
        white = "#dddddd",

        -- Biến thể màu sáng (Bright colors)
        orange = "#ff5a00", -- Lấy từ màu bell_border
        pink = "#fd28ff",
        purple = "#fd28ff",
      },
      -- Ghi đè thêm một số highlight group để tăng độ tương phản trên nền trong suốt
      overrides = function(c)
        return {
          -- Giữ cho Comment sáng vừa phải, dễ đọc (màu xám thay vì xanh lá rực)
          Comment = { fg = "#a4b1cd", italic = true },

          -- Làm nổi bật các ký tự đặc biệt hoặc từ khóa nếu cần
          Todo = { fg = "#2ee7b6", bold = true },

          -- Đồng bộ viền của Telescope hoặc các cửa sổ pop-up theo màu xanh HTB
          TelescopeBorder = { fg = "#9fef00" },
          TelescopePromptBorder = { fg = "#2ee7b6" },
          FloatBorder = { fg = "#9fef00" },
        }
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}

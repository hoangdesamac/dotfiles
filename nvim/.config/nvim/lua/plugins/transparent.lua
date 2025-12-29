return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- Bắt buộc: để nó chạy ngay lập tức
  priority = 1000, -- Ưu tiên cao nhất để xóa nền trước khi vẽ giao diện
  config = function()
    -- 1. Cấu hình các nhóm
    require("transparent").setup({
      extra_groups = {
        "NormalFloat", -- Cửa sổ nổi
        "FloatBorder",
        "NvimTreeNormal",
        "NeoTreeNormal",
        "TelescopeNormal",
        "TelescopeBorder",
      },
    })

    -- 2. Xóa nền nâng cao theo Prefix (cho icon, statusline đẹp hơn)
    local transparent = require("transparent")
    transparent.clear_prefix("NeoTree")
    -- transparent.clear_prefix("lualine")
    -- transparent.clear_prefix("BufferLine")

    -- 3. CÂU LỆNH QUAN TRỌNG: Ép buộc bật chế độ trong suốt
    vim.cmd("TransparentEnable")
  end,
}

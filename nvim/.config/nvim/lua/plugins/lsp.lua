return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Danh sách server Mason quản lý
      servers = {
        -- Bạn có thể để trống hoặc thêm server khác (như pyright, lua_ls...)
      },
      
      -- QUAN TRỌNG: Setup Handler trả về true để CHẶN Mason start clangd thường
      setup = {
        clangd = function()
          return true -- "True" nghĩa là: Tôi tự lo rồi, Mason đừng chạy nữa.
        end,
      },
    },
  },
}

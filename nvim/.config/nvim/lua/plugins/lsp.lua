return {
  {
    "neovim/nvim-lspconfig",

    -- 1. Phần Logic khởi chạy (Đặt trong init function)
    init = function()
      -- =================================================================
      -- [START] LOGIC KHỞI CHẠY ESP-CLANGD
      -- =================================================================

      -- QUAN TRỌNG: Hãy thay dòng dưới bằng đường dẫn TUYỆT ĐỐI tới file esp-clangd trên máy bạn
      -- Ví dụ: "/home/user/.espressif/tools/esp-clang/.../bin/clangd"
      local esp_clang_path = "esp-clangd"

      local esp_clangd_cmd = {
        esp_clang_path,
        "--background-index",
        "--query-driver=**",
        "--header-insertion=iwyu",
        "--clang-tidy",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      }

      -- Hàm tìm thư mục gốc
      local function get_esp_root_dir()
        local current_buf = vim.api.nvim_buf_get_name(0)
        -- Tránh lỗi khi buffer chưa có tên
        if current_buf == "" then
          return nil
        end

        local root_file = vim.fs.find({ "compile_commands.json", "platformio.ini", ".git" }, {
          upward = true,
          path = vim.fs.dirname(current_buf),
        })[1]

        if root_file then
          return vim.fs.dirname(root_file)
        end
        return nil
      end

      -- Tạo Autocommand
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          local root = get_esp_root_dir()

          -- Kiểm tra file thực thi có tồn tại không trước khi chạy
          if root and (vim.fn.executable(esp_clang_path) == 1 or esp_clang_path == "esp-clangd") then
            vim.lsp.start({
              name = "esp-clangd",
              cmd = esp_clangd_cmd,
              root_dir = root,
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
              },
              on_attach = function(client, _)
                client.server_capabilities.semanticTokensProvider = nil
              end,
            })
          end
        end,
      })
      -- =================================================================
      -- [END] LOGIC ESP-CLANGD
      -- =================================================================
    end,

    -- 2. Phần Cấu hình LazyVim (Chặn clangd mặc định)
    opts = {
      setup = {
        clangd = function()
          -- Trả về true để báo cho LazyVim: "Đừng bật clangd thường, tôi tự lo rồi"
          return true
        end,
      },
    },
  },
}

return {
  {
    "neovim/nvim-lspconfig",

    -- 1. Giữ nguyên logic khởi chạy ESP-CLANGD của bạn (đã hoạt động)
    init = function()
      -- Thay đường dẫn này bằng đường dẫn tuyệt đối nếu cần
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

      -- [SỬA QUAN TRỌNG 1]: Chỉ tìm file đặc trưng của ESP (sdkconfig, platformio)
      -- Bỏ .git và compile_commands.json đi để tránh nhận nhầm Linux Kernel là ESP
      local function get_esp_root_dir()
        local current_buf = vim.api.nvim_buf_get_name(0)
        if current_buf == "" then
          return nil
        end

        -- Chỉ tìm sdkconfig hoặc platformio.ini
        local root_file = vim.fs.find({ "sdkconfig", "platformio.ini" }, {
          upward = true,
          path = vim.fs.dirname(current_buf),
        })[1]

        if root_file then
          return vim.fs.dirname(root_file)
        end
        return nil
      end

      -- Autocommand giữ nguyên
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          local root = get_esp_root_dir()
          -- Nếu tìm thấy sdkconfig -> Bật ESP-Clangd
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
    end,

    -- 2. Logic phân luồng thông minh (Thay vì chặn tất cả)
    opts = {
      setup = {
        clangd = function(_, opts)
          -- Lấy tên file hiện tại
          local fname = vim.api.nvim_buf_get_name(0)
          local util = require("lspconfig.util")

          -- Kiểm tra xem thư mục này có phải ESP32 không?
          local is_esp_project = util.root_pattern("sdkconfig", "platformio.ini")(fname)

          if is_esp_project then
            -- Nếu là ESP32 -> return true để CHẶN clangd thường (nhường sân cho code ở trên chạy)
            return true
          end

          -- Nếu KHÔNG phải ESP32 (ví dụ: Linux Kernel) -> return false
          -- Để LazyVim tự động bật clangd chuẩn lên
          return false
        end,
      },
    },
  },
}

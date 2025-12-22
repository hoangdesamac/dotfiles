-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- =================================================================
-- [START] CẤU HÌNH TỰ ĐỘNG CHO ESP-IDF (ESP-CLANG)
-- =================================================================
--mkdir -p ~/.local/bin
--ln -sf \
--~/.espressif/tools/esp-clang/esp-20.1.1_20250829/esp-clang/bin/clangd \
--~/.local/bin/esp-clangd
--echo $PATH
--export PATH="$HOME/.local/bin:$PATH"
-- 1. Đường dẫn tới esp-clang chính chủ (Đã lấy từ máy bạn)
local esp_clangd_cmd = {
  "esp-clangd",
  "--background-index",
  "--query-driver=**",
  "--header-insertion=iwyu",
  "--clang-tidy",
  "--completion-style=detailed",
  "--function-arg-placeholders",
  "--fallback-style=llvm",
}

-- 2. Hàm tìm thư mục gốc dự án (chứa compile_commands.json)
local function get_esp_root_dir()
  local root = vim.fs.find({'compile_commands.json', 'platformio.ini', '.git'}, {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  })[1]
  
  if root then return vim.fs.dirname(root) end
  return nil -- Trả về nil nếu không tìm thấy, để tránh chạy sai
end

-- 3. Tạo Autocommand: Tự động chạy khi mở file C/C++
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function()
    local root = get_esp_root_dir()

    -- Chỉ chạy nếu tìm thấy file cấu hình dự án
    if root then
      vim.lsp.start({
        name = "esp-clangd", -- Đặt tên khác để dễ phân biệt
        cmd = esp_clangd_cmd,
        root_dir = root,
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        -- Tắt xung đột với semantic tokens của Mason nếu có
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil 
        end,
      })
    end
  end,
})
-- =================================================================
-- [END] CẤU HÌNH ESP-IDF
-- =================================================================

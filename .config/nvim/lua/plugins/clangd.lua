return {
  "neovim/nvim-lspconfig",
  -- Sử dụng 'config' thay vì 'opts' để đảm bảo cấu hình này chạy đè lên mọi thiết lập mặc định
  config = function()
    local lspconfig = require("lspconfig")
    
    -- 1. Setup capabilities (Hỗ trợ utf-16 để tránh warning khó chịu)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = { "utf-16" }

    -- 2. Hàm tạo lệnh chạy (QUAN TRỌNG: Dùng đường dẫn tuyệt đối)
    local get_cmd = function()
      local cmd = {
        -- ĐÂY LÀ CHÌA KHÓA: Trỏ thẳng vào file trong máy bạn
        "/home/hoangdesamac/.local/share/nvim/mason/bin/clangd", 
        
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--fallback-style=llvm",
        "--query-driver=**", -- Bắt buộc cho PlatformIO để đọc thư viện Arduino
      }

      -- Logic tự động tìm file compile_commands.json trong thư mục .pio/build
      local cwd = vim.fn.getcwd()
      if vim.fn.isdirectory(cwd .. "/.pio/build") == 1 then
         local builds = vim.fn.glob(cwd .. "/.pio/build/*", true, true)
         for _, build in ipairs(builds) do
           if vim.fn.filereadable(build .. "/compile_commands.json") == 1 then
             table.insert(cmd, "--compile-commands-dir=" .. build)
             break 
           end
         end
      end
      return cmd
    end

    -- 3. Kích hoạt Clangd
    lspconfig.clangd.setup({
      capabilities = capabilities,
      cmd = get_cmd(), -- Gọi hàm để lấy lệnh kèm đường dẫn đầy đủ
      root_dir = lspconfig.util.root_pattern("platformio.ini", "compile_commands.json", ".git"),
      init_options = {
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
      },
    })
  end,
}

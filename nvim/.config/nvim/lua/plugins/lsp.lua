return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "SmiteshP/nvim-navic",
        opts = { lsp = { auto_attach = true }, highlight = true },
      },
    },
    opts = {
      servers = {
        tvm_ffi_navigator = { enabled = false, autostart = false },
        pyright = {},
        ruff = {},
      },
      setup = {
        clangd = function(_, opts)
          -- HÀM QUÉT THÔNG MINH ĐÃ ĐƯỢC FIX ĐƯỜNG DẪN THEO EIM V6
          local function get_latest_esp_clangd()
            local home = vim.env.HOME
            local pattern = home .. "/.espressif/tools/esp-clang/esp-*/esp-clang/bin/clangd"
            local matches = vim.fn.glob(pattern, true, true)

            if #matches > 0 then
              table.sort(matches)
              local newest_path = matches[#matches]
              if vim.fn.executable(newest_path) == 1 then
                return newest_path
              end
            end
            return "clangd"
          end

          local final_path = get_latest_esp_clangd()

          local util = require("lspconfig.util")
          local root =
            util.root_pattern("sdkconfig", "platformio.ini", "CMakeLists.txt", ".git")(vim.api.nvim_buf_get_name(0))

          if root then
            -- ĐỊNH NGHĨA DRIVER CHẠY CHO CẢ CHIP XTENSA VÀ RISC-V TÁCH BIỆT BẰNG DẤU PHẨY
            local home_dir = vim.env.HOME
            local xtensa_driver = home_dir .. "/.espressif/tools/xtensa-esp-elf/*/xtensa-esp-elf/bin/*gcc*"
            local riscv_driver = home_dir .. "/.espressif/tools/riscv32-esp-elf/*/riscv32-esp-elf/bin/*gcc*"
            local query_driver_arg = "--query-driver=" .. xtensa_driver .. "," .. riscv_driver

            require("lspconfig").clangd.setup({
              cmd = {
                final_path,
                "--background-index",
                query_driver_arg, -- Áp dụng driver chuẩn vừa cấu hình
                "--compile-commands-dir=" .. root .. "/build",
                "--header-insertion=iwyu",
              },
              root_dir = root,
              on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                  require("nvim-navic").attach(client, bufnr)
                end
              end,
            })
            return true
          else
            vim.notify("❌ Không tìm thấy root (sdkconfig). Clangd chưa kích hoạt!", vim.log.levels.WARN)
          end

          return false
        end,
      },
    },
  },
}

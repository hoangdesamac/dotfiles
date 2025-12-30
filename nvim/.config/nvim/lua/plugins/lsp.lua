return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Cần cái này để lấy capabilities chuẩn
      {
        "SmiteshP/nvim-navic",
        opts = {
          lsp = { auto_attach = true },
          highlight = true,
          separator = "  ",
          depth_limit = 0,
          icons = {
            File = " ",
            Module = " ",
            Namespace = " ",
            Package = " ",
            Class = " ",
            Method = " ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = " ",
            Interface = " ",
            Function = "󰊕 ",
            Variable = " ",
            Constant = " ",
            String = " ",
            Number = " ",
            Boolean = " ",
            Array = " ",
            Object = " ",
            Key = " ",
            Null = " ",
            EnumMember = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " ",
          },
        },
      },
    },

    init = function()
      local esp_clang_path = "esp-clangd"
      -- Các cờ khởi động server
      local esp_clangd_cmd = {
        esp_clang_path,
        "--background-index",
        "--query-driver=**",
        "--header-insertion=iwyu",
        "--clang-tidy",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--all-scopes-completion", -- [QUAN TRỌNG] Quét cả phạm vi global/static
        "--header-insertion-decorators=0",
      }

      -- Hàm tìm thư mục gốc của dự án ESP-IDF
      local function get_esp_root_dir()
        local current_buf = vim.api.nvim_buf_get_name(0)
        if current_buf == "" then
          return nil
        end
        local root_file = vim.fs.find({ "sdkconfig", "platformio.ini" }, {
          upward = true,
          path = vim.fs.dirname(current_buf),
        })[1]
        if root_file then
          return vim.fs.dirname(root_file)
        end
        return nil
      end

      -- Tự động chạy khi mở file C/C++
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          local root = get_esp_root_dir()
          if root and (vim.fn.executable(esp_clang_path) == 1 or esp_clang_path == "esp-clangd") then
            -- 1. Tạo capabilities chuẩn từ CMP
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if status_ok then
              capabilities = cmp_nvim_lsp.default_capabilities()
            end

            -- [FIX LỖI CHI TIẾT] Ép buộc hỗ trợ Full 26 loại Symbol
            capabilities.textDocument.documentSymbol = {
              hierarchicalDocumentSymbolSupport = true, -- Cho phép hiện cây thư mục (Struct > Field)
              dynamicRegistration = false,
              symbolKind = {
                valueSet = {
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                  8,
                  9,
                  10,
                  11,
                  12,
                  13,
                  14,
                  15,
                  16,
                  17,
                  18,
                  19,
                  20,
                  21,
                  22,
                  23,
                  24,
                  25,
                  26,
                },
              },
            }

            vim.lsp.start({
              name = "esp-clangd",
              cmd = esp_clangd_cmd,
              root_dir = root,
              capabilities = capabilities,
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
              },
              on_attach = function(client, bufnr)
                -- Tắt highlight mặc định nếu thấy rối
                client.server_capabilities.semanticTokensProvider = nil

                -- [NAVIC] Gắn Navic vào (Không cần kiểm tra điều kiện if nữa cho chắc ăn)
                local navic = require("nvim-navic")
                navic.attach(client, bufnr)
              end,
            })
          end
        end,
      })
    end,

    -- Logic chặn clangd thường để tránh xung đột với esp-clangd
    opts = {
      setup = {
        clangd = function(_, opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local util = require("lspconfig.util")
          local is_esp_project = util.root_pattern("sdkconfig", "platformio.ini")(fname)
          if is_esp_project then
            return true -- Return true để chặn clangd mặc định start
          end
          return false
        end,
      },
    },
  },
}

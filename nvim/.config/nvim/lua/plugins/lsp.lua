return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp", -- [FIX] Dùng blink thay vì cmp-nvim-lsp
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
      local esp_clangd_cmd = {
        esp_clang_path,
        "--background-index",
        "--query-driver=**",
        "--header-insertion=iwyu",
        "--clang-tidy",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--all-scopes-completion",
        "--header-insertion-decorators=0",
        "--compile-commands-dir=build", -- <--- THÊM DÒNG NÀY (Chỉ định rõ nơi chứa file json)
      }

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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          local root = get_esp_root_dir()
          if root and (vim.fn.executable(esp_clang_path) == 1 or esp_clang_path == "esp-clangd") then
            -- [FIX QUAN TRỌNG] Lấy capabilities từ Blink thay vì cmp-nvim-lsp
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
              capabilities = blink.get_lsp_capabilities(capabilities)
            end

            -- Vẫn giữ đoạn ép buộc này để hiện chi tiết cây thư mục
            capabilities.textDocument.documentSymbol = {
              hierarchicalDocumentSymbolSupport = true,
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
                client.server_capabilities.semanticTokensProvider = nil
                local navic = require("nvim-navic")
                navic.attach(client, bufnr)
              end,
            })
          end
        end,
      })
    end,

    opts = {
      setup = {
        clangd = function(_, opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local util = require("lspconfig.util")
          local is_esp_project = util.root_pattern("sdkconfig", "platformio.ini")(fname)
          if is_esp_project then
            return true
          end
          return false
        end,
      },
    },
  },
}

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
      -- TỰ ĐỘNG TÌM ĐƯỜNG DẪN:
      -- Quét trong thư mục tools/esp-clang để tìm file 'clangd' sâu nhất
      local find_clangd_cmd = "find $HOME/.espressif/tools/esp-clang -name 'clangd' -executable -type f | head -n 1"
      local detected_path = vim.fn.system(find_clangd_cmd):gsub("%s+", "")

      -- Kiểm tra nếu tìm thấy thì dùng, không thì mặc định là "clangd"
      local esp_clang_path = (detected_path ~= "" and vim.v.shell_error == 0) and detected_path or "clangd"

      -- Hàm tìm root của dự án (Giữ nguyên)
      local function get_esp_root_dir()
        local current_buf = vim.api.nvim_buf_get_name(0)
        if current_buf == "" then
          return nil
        end
        local root_file = vim.fs.find({ "sdkconfig", "platformio.ini" }, {
          upward = true,
          path = vim.fs.dirname(current_buf),
        })[1]
        return root_file and vim.fs.dirname(root_file) or nil
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          local root = get_esp_root_dir()
          if root and (vim.fn.executable(esp_clang_path) == 1) then
            local esp_clangd_cmd = {
              esp_clang_path,
              "--background-index",
              -- Giữ lại query-driver để tìm stdio.h
              "--query-driver=/home/hoangdesamac/.espressif/tools/*/bin/*gcc*",
              "--header-insertion=iwyu",
              "--clang-tidy",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
              "--all-scopes-completion",
              "--header-insertion-decorators=0",
              "--compile-commands-dir=" .. (root or ".") .. "/build",
            }

            -- ... (Phần còn lại của vim.lsp.start giữ nguyên)

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
              capabilities = blink.get_lsp_capabilities(capabilities)
            end

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
            return true -- Vô hiệu hóa clangd mặc định nếu là project ESP
          end
          return false
        end,
      },
    },
  },
}

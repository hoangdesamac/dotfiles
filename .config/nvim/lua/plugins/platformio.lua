return {
  -- Chúng ta sẽ ghi đè cấu hình của nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- Thêm cờ --query-driver để clangd hiểu compiler của PlatformIO
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--query-driver=**", -- <--- ĐÂY LÀ DÒNG QUAN TRỌNG NHẤT
          },
          -- Đảm bảo clangd tìm thấy root của dự án PlatformIO
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja",
              "compile_commands.json",
              "platformio.ini", -- Ưu tiên tìm file này
              ".git"
            )(fname) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
          end,
        },
      },
    },
  },
}

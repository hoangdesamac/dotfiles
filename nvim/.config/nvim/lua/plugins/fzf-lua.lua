return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      winopts = {
        height = 0.85, 
        width = 0.90, -- Tăng chiều rộng lên chút cho dễ nhìn
        preview = {
          layout = "horizontal", -- <--- SỬA DÒNG NÀY (từ vertical thành horizontal)
          scrollbar = "float",
          
          -- Tùy chỉnh thêm (nếu muốn):
          -- vertical = "down:45%",   -- (Nếu dùng layout vertical thì dòng này chỉnh chiều cao)
          horizontal = "right:50%",   -- (Quan trọng) Chia đôi 50/50, preview nằm bên phải
        },
      },
      
      -- ... (giữ nguyên các phần files, grep, keymaps bên dưới) ...
      
      -- Tối ưu hóa bộ lọc cho dự án Nhúng (PlatformIO)
      files = {
  fd_opts = "--type f --hidden --follow --exclude .git --exclude .pio --exclude node_modules",
},

      
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob '!.git/*' --glob '!.pio/*' --glob '!node_modules/*'",
      },
    })

    -- ... (giữ nguyên phần keymap) ...
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Fzf Files" })
    vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Fzf Grep" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Fzf Buffers" })
    
    vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Fzf Diagnostics (File)" })
    vim.keymap.set("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Fzf Diagnostics (Project)" })
    
    vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "Fzf References" })
    vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Fzf Symbols" })
  end,
}

return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(hl)
      -- nền chính
      hl.Normal = { bg = "none" }
      hl.NormalNC = { bg = "none" }

      -- CursorLine
      hl.CursorLine = { bg = "none" }
      -- popup / float
      hl.NormalFloat = { bg = "none" }
      hl.FloatBorder = { bg = "none" }

      -- statusline / winbar
      hl.StatusLine = { bg = "none" }
      hl.StatusLineNC = { bg = "none" }

      -- dòng được LSP tham chiếu (CÁI BỊ TÔ NỀN KHÓ CHỊU)
      hl.LspReferenceRead = { bg = "none" }
      hl.LspReferenceText = { bg = "none" }
      hl.LspReferenceWrite = { bg = "none" }
    end,
  },
}

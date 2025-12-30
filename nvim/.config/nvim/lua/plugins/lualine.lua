return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    -- Setup Navic ở đây
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

  opts = function()
    local navic = require("nvim-navic")
    local custom_theme = require("lualine.themes.auto")

    -- 1. HÀM CHỈ LÀM TRONG SUỐT PHẦN GIỮA
    local function make_middle_transparent(mode)
      if custom_theme[mode] then
        if custom_theme[mode].c then
          custom_theme[mode].c.bg = "NONE"
        end
        if custom_theme[mode].x then
          custom_theme[mode].x.bg = "NONE"
        end
      end
    end

    local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
    for _, mode in pairs(modes) do
      make_middle_transparent(mode)
    end

    -- 2. [ĐÃ NÂNG CẤP] Hàm lấy tên LSP chuẩn hơn
    local function get_lsp_name()
      local msg = "No Active LSP"
      -- Lấy danh sách client đang gắn vào buffer hiện tại
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then
        return msg
      end

      local client_names = {}
      for _, client in pairs(clients) do
        -- Lọc bỏ các client phụ (như null-ls hay copilot) nếu muốn, hoặc để hết
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(client_names, client.name)
        end
      end

      if #client_names == 0 then
        return msg
      end

      -- Trả về định dạng: [esp-clangd]
      return "" .. table.concat(client_names, ", ") .. ""
    end

    return {
      options = {
        theme = custom_theme,
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
        globalstatus = true,
      },
      sections = {
        -- === KHỐI TRÁI ===
        lualine_a = { { "mode", icon = "", gui = "bold" } },
        lualine_b = {
          { "branch", icon = "" },
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        },

        -- === KHỐI GIỮA (Navic & File) ===
        lualine_c = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            colored = true,
          },
          {
            "filename",
            path = 1,
            color = { fg = "#0db9d7", gui = "bold" },
            symbols = { modified = "●", readonly = "", unnamed = "[No Name]" },
          },
          {
            -- Hiển thị Navic (Breadcrumbs)
            function()
              return navic.get_location()
            end,
            cond = function()
              return navic.is_available()
            end,
            color = { fg = "#9d7cd8", gui = "italic" },
          },
        },

        -- === KHỐI GIỮA PHẢI (LSP Name) ===
        lualine_x = {
          { "searchcount", color = { fg = "#ff9e64", gui = "bold" } },
          {
            get_lsp_name, -- Gọi hàm hiển thị tên LSP
            icon = " ",
            color = { fg = "#73daca", gui = "bold" },
          },
        },

        -- === KHỐI PHẢI ===
        lualine_y = {
          { "fileformat", symbols = { unix = "", dos = "", mac = "" } },
          { "encoding", padding = { right = 1 } },
        },
        lualine_z = {
          { "progress", icon = "" },
          { "location", icon = "" },
        },
      },
    }
  end,
}

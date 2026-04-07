return {
  "mfussenegger/nvim-dap",
  -- Ép nvim-dap phải trả về một table có hàm setup trống để tránh lỗi nil value
  opts = function()
    return {}
  end,
  config = function(_, opts)
    local dap = require("dap")
    -- Bạn có thể thêm cấu hình adapter ở đây nếu cần
  end,
}

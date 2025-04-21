return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  },
  lazy = false,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    require("dap-python").setup("python")
    require("dapui").setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
      dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
    end
      dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
    end

    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<Leader>dB', dap.set_breakpoint, {})
    vim.keymap.set('n', '<Leader>dc', dap.continue, {})
    vim.keymap.set('n', '<Leader>ds', dap.step_into, {})
    vim.keymap.set('n', '<Leader>dn', dap.step_over, {}) 

    -- `DapBreakpoint` for breakpoints (default: `B`)
    -- `DapBreakpointCondition` for conditional breakpoints (default: `C`)
    -- `DapLogPoint` for log points (default: `L`)
    -- `DapStopped` to indicate where the debugee is stopped (default: `→`)
    -- `DapBreakpointRejected` to indicate breakpoints rejected by the debug
    --  adapter (default: `R`)
    
    --You can customize the signs by setting them with the |sign_define()| function.
    vim.fn.sign_define('DapBreakpoint', {text='❄️', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
  end,
}


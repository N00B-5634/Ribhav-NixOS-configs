-- Bootstrap lazy.nvim (downloads it automatically if it's missing)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Setup LazyVim if you are using the framework (uncomment if needed):
    -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- This imports all your plugin specs from the `lua/plugins/` directory
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. 
    -- Change to true if you want all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version = false for now, since a lot the plugin 
    -- ecosystem uses the master branch by default.
    version = false, 
  },
  checker = {
    enabled = true, -- Automatically check for plugin updates
    notify = false, -- Turn off notifications when updates are found
  },
  performance = {
    rtp = {
      -- disable some rtp plugins you don't use to speed up startup times
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

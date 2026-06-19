-- ==============================
-- INIT.LUA – ENHANCED + KDE ASTRONAUT DARK (LAZY.NVIM VERSION)
-- ==============================

-- 1. Load Lazy.nvim (This must exist in ~/.config/nvim/lua/config/lazy.lua)
vim.g.mapleader = "."
vim.g.maplocalleader = "."
require("config.lazy")

local fn = vim.fn
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

-- --- SETTINGS: Core ---
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.cursorline = true
opt.showcmd = true
opt.showmode = true
opt.laststatus = 2
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 5
opt.sidescrolloff = 5
cmd("syntax enable")

-- Configure wl-clipboard for Wayland
if fn.executable("wl-copy") == 1 then
  g.clipboard = {
    name = "wl-clipboard",
    copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
    paste = { ["+"] = "wl-paste --no-newline", ["*"] = "wl-paste --no-newline" },
    cache_enabled = 1,
  }
end

-- --- COLORS: KDE AstronautDark-inspired ---
if not g.colors_name then
  cmd("highlight clear")
  cmd("syntax reset")
  opt.background = "dark"

  cmd("hi Normal guifg=#E6E6E6 guibg=#000000")
  cmd("hi NormalNC guifg=#646464 guibg=#191919")
  cmd("hi CursorLine guibg=#191919")
  cmd("hi LineNr guifg=#5555FF")
  cmd("hi CursorLineNr guifg=#9317FF")

  cmd("hi Visual guibg=#505050 guifg=#550000")
  cmd("hi StatusLine guifg=#E6E6E6 guibg=#000000")
  cmd("hi StatusLineNC guifg=#646464 guibg=#191919")

  cmd("hi Identifier guifg=#00AAFF")
  cmd("hi Function guifg=#9317FF")
  cmd("hi Keyword guifg=#AA5500")

  cmd("hi Pmenu guibg=#AA55FF guifg=#E6E6E6")
  cmd("hi PmenuSel guibg=#5555FF guifg=#000000")
end

-- --- KEYBINDINGS ---
-- NERDTree (Ensure this is in your lua/config/lazy.lua plugin list)
vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>N", ":NERDTreeFind<CR>", { noremap = true, silent = true })

-- Save & Quit
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { noremap = true, silent = true })

-- Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Quick buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true })

-- Escape shortcut
vim.keymap.set("i", "jk", "<ESC>", { noremap = true })

-- --- AUTO-COMMANDS ---
cmd([[
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    augroup YankHighlight
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="Visual", timeout=200}
    augroup END
]])

-- --- TREESITTER FIX (Updated for 2026) ---
-- Use 'config' instead of 'configs' for the new nvim-treesitter rewrite
local ok, ts_config = pcall(require, "nvim-treesitter.config")
if ok then
  ts_config.setup({
    ensure_installed = { "c", "cpp", "lua", "python", "javascript", "html", "css" },
    highlight = { enable = true },
  })
else
  -- Fallback for legacy branch if you haven't updated the plugin yet
  local legacy_ok, legacy_configs = pcall(require, "nvim-treesitter.configs")
  if legacy_ok then
    legacy_configs.setup({
      ensure_installed = { "c", "cpp", "lua", "python", "javascript", "html", "css" },
      highlight = { enable = true },
    })
  end
end
require("lazy").setup({
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        filetype = {
          -- Default C configuration: compiles with gcc and runs the output
          c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
          cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        },
      })
    end,
  },
})
vim.keymap.set("n", "<F5>", function()
  vim.cmd("write")
  -- Opens a 15-line split terminal to compile and run
  vim.cmd("15split | term gcc % -o %:r && ./%:r")
  vim.cmd("startinsert")

  -- Automatically close the window 10 seconds after the program finishes
  local current_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = current_buf,
    callback = function()
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(current_buf) then
          vim.api.nvim_buf_delete(current_buf, { force = true })
        end
      end, 20000)
    end,
  })
end, { desc = "Compile, Run, and Auto-close in 10s" })
vim.keymap.set(
  { "n", "i", "v", "t" },
  "<leader>r",
  "<Cmd>w|split|term python3 %<CR>",
  { desc = "Run Python file from any mode" }
)
-- ==============================
-- END INIT.LUA
-- ==============================

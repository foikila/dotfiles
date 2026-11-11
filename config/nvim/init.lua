-- Loaded after config/vim/vimrc; plugins and language servers come from home/neovim.nix.

vim.g.mapleader = " "

-- Same palette as the Waybar style.
vim.cmd.colorscheme("catppuccin-mocha")

-- Treesitter highlighting for every filetype that has a parser installed.
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Language servers: configs from nvim-lspconfig, binaries from extraPackages.
vim.lsp.enable({ "nixd", "ts_ls", "eslint", "bashls", "gopls", "terraformls" })
vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Built-in completion popup while typing; Ctrl-y accepts, Ctrl-e closes.
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
  end,
})

-- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Search text" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Open buffers" })
vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "Diagnostics" })

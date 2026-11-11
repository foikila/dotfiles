return {
  -- Mason downloads generic Linux binaries, which don't run on NixOS.
  -- All tools come from home/neovim.nix instead.
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },

  -- No LazyVim extra for Bash.
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { bashls = {} } },
  },

  -- The Terraform extra calls `terraform`; use OpenTofu's `tofu` instead.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "tofu_fmt" },
        tf = { "tofu_fmt" },
        ["terraform-vars"] = { "tofu_fmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        terraform = { "tofu" },
        tf = { "tofu" },
      },
    },
  },

  -- Same palette as the Waybar style.
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}

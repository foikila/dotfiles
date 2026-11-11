{ pkgs, ... }:

# LazyVim: lazy.nvim downloads and updates the plugins itself on first start
# (needs network). Nix provides Neovim, build tools and language servers;
# Mason is disabled in config/nvim because its downloads don't run on NixOS.
{
  home.packages = with pkgs; [
    neovim

    # lazy.nvim and treesitter parser builds
    gcc
    tree-sitter

    # Pickers
    ripgrep
    fd

    # Lua (LazyVim's own config)
    lua-language-server
    stylua

    # Nix
    nil
    nixfmt
    statix

    # TypeScript/JavaScript
    vtsls
    vscode-langservers-extracted # eslint

    # Bash
    bash-language-server
    shellcheck
    shfmt

    # Go
    gopls
    gotools # goimports
    gofumpt
    golangci-lint

    opentofu
    terraform-ls
    tflint
  ];

  # Only these are linked, so ~/.config/nvim stays writable for lazy-lock.json.
  xdg.configFile."nvim/init.lua".source = ../config/nvim/init.lua;
  xdg.configFile."nvim/lua".source = ../config/nvim/lua;
}

{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.go
        p.hcl
        p.javascript
        p.json
        p.lua
        p.markdown
        p.nix
        p.terraform
        p.tsx
        p.typescript
        p.yaml
      ]))
      nvim-lspconfig
      telescope-nvim
      catppuccin-nvim
    ];

    # Only on Neovim's PATH, not the shell's.
    extraPackages = with pkgs; [
      nixd
      typescript-language-server
      vscode-langservers-extracted # eslint
      bash-language-server
      shellcheck # used by bashls
      gopls
      terraform-ls
      ripgrep # telescope live_grep
      fd # telescope find_files
    ];

    # Same base settings as Vim, then the Neovim-only setup.
    extraLuaConfig = ''
      vim.cmd.source("${../config/vim/vimrc}")
    '' + builtins.readFile ../config/nvim/init.lua;
  };
}

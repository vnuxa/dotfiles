{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: {
  programs.nixneovim = {
    #TODO: make this in to a seperate folder/module instead!
    enable = true;
    globals.mapleader = " ";
    globals.maplocalleader = " ";

    plugins = import ./nvim_configs/plugins_main.nix;
    options = import ./nvim_configs/options_main.nix;
    mappings = import ./nvim_configs/keymaps.nix;
    # augroups = import ./nvim_configs/augroups.nix;
    # for osme reason when importing ti says it doenst exist, so for now its like this
    augroups = {
        FormatAutogroup = {
            autocmds = [
            {
                event = "BufWritePost";
                pattern = "*";
                command = "FormatWrite";
            }
            ];
        };
    };
    extraPlugins = with pkgs.vimExtraPlugins; [
      veil-nvim
      which-key-nvim
      workspaces-nvim
      NeoTerm-lua
      stcursorword
      url-open
      nvim-toggler
      code-runner-nvim
      smart-pairs
      nui-nvim
      neo-tree-nvim
      palette-nvim
      nvim-navic
      barbecue-nvim
      ferris-nvim
      rustaceanvim
      # bg-nvim # uncomment for neovim background to sync with terminal
      telescope-file-browser-nvim
      formatter-nvim
      rainbow-delimiters-nvim
      wilder-nvim
    ];

    extraLuaPreConfig = ''
      do -- add vscode lua snippets (support a lot of languages)
        require('luasnip.loaders.from_vscode').lazy_load()
      end
    '';
    extraLuaPostConfig = import ./nvim_configs/extra_config.nix {config = config;};
  };
}

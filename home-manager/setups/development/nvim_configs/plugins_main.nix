{
  colorizer.enable = true;
  colorizer.userDefaultOptions.names = false;
  lspconfig = import ./plugin_configurations/lsp_config.nix;
  treesitter.enable = true;
  treesitter.indent = true;
  plenary.enable = true;
  telescope = import ./plugin_configurations/telescope.nix;

  # visual stuff
  lualine.enable = true;
  which-key.enable = true;
  # editor related stuff
  indent-blankline.enable = true;
  barbar.enable = true;
  comment.enable = true; # makes it so that gc can comment (visual) lines and regions
  lspkind.enable = true;
  
  todo-comments.enable = true;
  todo-comments.extraConfig = {
    keywords = {
      FIX = {
        icon = " ";  # icon used for the sign, and in search results
        color = "error"; # can be a hex color, or a named color (see below)
        alt = [ "FIXME" "BUG" "FIXIT" "ISSUE" "!" "IMPORTANT" ]; # a set of other keywords that all map to this FIX keywords
        # signs = false, # configure signs for some keywords individually
      };
      TODO = { icon = " "; color = "info"; };
      HACK = { icon = " "; color = "warning"; };
      WARN = { icon = " "; color = "warning"; alt = [ "WARNING" "XXX" ]; };
      PERF = { icon = " "; alt = [ "QUESTION" "WHAT" "ASK" "ANSWER" "EXPLANATION" "INFO" ]; };
      NOTE = { icon = " "; color = "hint"; alt = ["OPTIONAL"]; };
      TEST = { icon = "⏲ "; color = "test"; alt = [ "TESTING" "PASSED" "FAILED" ]; };
    };
    gui_style = {
      fg = "NONE"; # The gui style to use for the fg highlight group.
      bg = "BOLD"; # The gui style to use for the bg highlight group.
    };

  };
  # veil-nvim.enable = true; # TODO: customize this further
  
  # autocompletion
  luasnip.enable = true;
  luasnip.lazyLoad = true;

  nvim-cmp = import ./plugin_configurations/autocompletion.nix;
}

{
  enable = true;
  # snippets
  snippet.luasnip.enable = true;
  
  # completion sources
  sources = {
    # luasnip.enable = true;
    nvim_lsp.enable = true;
    # buffer.enable = true;
  };
  # customize the menu for completion
  completion.completeopt = "menu,menuone,noinsert";

  # keymaps for autocompletion
  mappingPresets = ["insert"];
  mapping = {
    "<C-p>" = { # select next item
      modes = ["i" "s"];
      action = ''
        function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end
      '';
    };  
    "<S-Enter>" = { # select previous item
      modes = ["i" "s"];
      action = ''
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item({behavior = 'insert'})
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end
      '';
    };
    "<C-d>" = "cmp.mapping.scroll_docs(-4)";
    "<C-f>" = "cmp.mapping.scroll_docs(4)";
    "<C-Enter>" = "cmp.mapping.confirm{ select = true }";
    "<C-e>" = "cmp.mapping.abort()";
    "<C-Space>" = "cmp.mapping.complete{}";
  };
  #TODO: commandline version
}

{
  # Toggle neo-tree
  normal."<leader>e" = {
    action = "'<cmd>Neotree toggle<CR>'";
    desc = "Open neotree";
    silent = true;
  };
  # Saving the file
  normal."<C-s>" = {
    action = "'<cmd>w!<CR>'";
    desc = "Save file";
    silent = true;
  };
  # Searching within the current buffer
  #IMPORTANT: this needs fixing (as in the package for it is not there in neovim.nix)
  normal."<C-f>" = {
    action = "'<cmd>Telescope current_buffer_fuzzy_find<cr>'";
    desc = "Search current buffer";
  };
  
  # For commenting lines
  normal."<leader>/" = {
    action = ''
      function()
        require("Comment.api").toggle.linewise.current()
      end
    '';
    desc = "Comment line";
  };
  visual."<leader>/" = {
    action = '' '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR> ' '';
    desc = "Comment lines";
  };

  # Move lines
  visual."J" = {
    action = "':m \\'>+1<CR>gv=gv'";
    desc = "Move line down";
  };
  visual."K" = {
    action = "':m \\'>-2<CR>gv=gv'";
    desc = "Move line down";
  };

  # Search terms
  # Keep search terms in the middle (search terms can be accesed by pressing / ) (for eaxmple /vim and once you press enter and press n it will go to the next)
  # Also search temrs have magic characers (.* if you want until the end and then after that it removes characters from the end)
  normal."n" = {
    action = "'nzzzv'";
    desc = "Search next character";
  };
  normal."N" = {
    action = "'nzzzv'";
    desc = "Search previous character";
  };

  # Make it so that when you paste things over, it doesnt make you loose your selection
  visualOnly."<leader>p" = {
    action = "'\"_DP'";
    desc = "Paste over";
  };

  # Delete things seperately from the regular system clipboard
  normal."<leader>d" = {
    action = "'\"_d'";
    desc = "Void delete";
  };
  visual."<leader>d" = {
    action = "'\"_d'";
    desc = "Void delete";
  };

  # Delete capital Q
  normal."Q" = "'<nop>'";

  # Replace current word that you are on
  normal."<leader>s" = {
    action = "':%s/\\\\<<C-r><C-w>\\\\>/<C-r><C-w>/gi<Left><Left><Left>'";
    desc = "Find and replace";
  };

  # Sets the currnet buffer directory as root for neotree and stuff
  normal."<leader>." = {
    action = "':cd %:h<CR>'";
    desc = "Set buffer dir as root";
  };

  # Reformat lines
  #NOTE: to paste stuff with sort of an indent you can just type ]P, it will follow your current indentation instead
  #NOTE: OR INSTEAD OF DOING THAT JUST PRESS = and it will foramt current selection
  #if you want to reformat the entire file, put this gg=G
  normal."<leader>rff" = {
    action = "':m gg=G<CR>'";
    desc = "Reformat file";
  };

  # Plugin keymaps

  # Open dashboard
  normal."<leader>ab" = {
    action = "':Veil<CR>'";
    desc = "Open dashboard";
    silent = true;
  };

  # Code runner
  normal."<leader>r" = {
    action = "':RunCode<CR>'";
    desc = "Run code";
  };
  normal."<leader>rf" = {
    action = "':RunFile<CR>'";
    desc = "Run file";
  };
  normal."<leader>rp" = {
    action = "':RunProject<CR>'";
    desc = "Run project";
  };
  normal."<leader>crp" = {
    action = "':CRProjects<CR>'";
    desc = "Code runner projects";
  };

  # Telescope configurations
  normal."<leader>tro" = {
    action = "require('telescope.builtin').oldfiles";
    desc = "Find recently opened files";
  };
  normal."<leader>tb" = {
    action = "require('telescope.builtin').buffers";
    desc = "Find existing buffers";
  };

  # Tabs and buffer related stuff
  # Move to previous/next
  normal."<A-,>" = "'<Cmd>BufferPrevious<CR>'";
  normal."<A-.>" = "'<Cmd>BufferNext<CR>'";
  # Reorder previous/next
  normal."<A-<>" = "'<Cmd>BufferMovePrevious<CR>'";
  normal."<A->>" = "'<Cmd>BufferMoveNext<CR>'";
  # Pin/unpin buffer
  normal."<A-p>" = "'<Cmd>BufferPin<CR>'";
  # Close buffer
  normal."<A-c>" = "'<Cmd>BufferClose<CR>'";

  # if you want you can import buffer sorting??

}
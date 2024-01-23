''
{
  {
    icon = "",
    text = "Find Files",
    shortcut = "f",
    callback = function()
      require("telescope.builtin").find_files()
    end,
  },


  {
    icon = "",
    text = "Nix home-manager configurations",
    shortcut = "n",
    callback = function()
      -- require("telescope.builtin").buffers()
      vim.cmd("cd ~/.config/home-manager/")
      require("telescope").extensions.file_browser.file_browser({
        path = "~/.config/home-manager/", 
      })
    end,
  },

  {
    icon = "",
    text = "Hyprland configuration",
    shortcut = "h",
    callback = function()
      -- require("telescope.builtin").buffers()
      require("telescope").extensions.file_browser.file_browser({
        path = "~/.config/hypr/", 
      })
      vim.cmd("cd ~/.config/hypr/")
    end,

  },
  
  {
    icon = "",
    text = "Config",
    shortcut = "c",
    callback = function() 
      vim.cmd("cd ~/.config/nvim/")
      require("telescope").extensions.file_browser.file_browser({
        path = vim.fn.stdpath("config"), 
      })
    end,
  },

  {
    icon = "",
    text = "Workspaces",
    shortcut = "s",
    callback = function()
      vim.cmd("Neotree")
      vim.cmd("Telescope workspaces")
      -- require("telescope").extensions.workspaces()
    end,
  }
  -- might need to add my own
}
''
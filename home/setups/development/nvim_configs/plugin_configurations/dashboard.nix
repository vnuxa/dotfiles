''
  {
    {
      icon = "",
      text = "New Workspace",
      shortcut = "p",
      callback = function()
          -- if theres a new workspace, maybe make it so that theres a delete workspace???
          -- in other words, it deletes folders from ~/Documents/Programming/
          local templates = {
              rust = function(workspace_name)
                  os.execute("cd ~/Documents/Programming/".. workspace_name .." && cargo init")
              end,
              lua = function(workspace_name)
                  os.execute("mkdir ~/Documents/Programming/"..workspace_name .."/src")
                  os.execute([[ echo > ~/Documents/Programming/]].. workspace_name [[/src/main.lua "print('hello world')" ]])
              end,
          }
          local function if_template_applied(workspace_name)
              for template, instructions in pairs(templates) do
                  if string.sub(workspace_name, 1, string.len(template)) == template and string.sub(workspace_name, string.len(template) + 1, string.len(template) + 1) == "/" then
                      local applied_name = string.sub(workspace_name, string.len(template) + 2, string.len(workspace_name))
                      return instructions, applied_name
                  end
              end
              return nil, workspace_name
          end

          local Input = require("nui.input")
          local event = require("nui.utils.autocmd").event

          local input = Input({
              position = "50%",
              size = {
                  width = 20,
              },
              border = {
                  style = "single",
                  text = {
                      top = "[ Workspace name ]",
                      top_align = "center",
                  },
              },
              win_options = {
                  winhighlight = "Normal:Normal,FloatBorder:Normal",
              },
          },
          {
              prompt = "> ",
              default_value = "",
              on_submit = function(value)
                  local instructions, workspace_name = if_template_applied(value)
                  os.execute("mkdir ~/Documents/Programming/".. workspace_name)
                  vim.cmd("cd ~/Documents/Programming/".. workspace_name)
                  vim.cmd("WorkspacesAdd ".. workspace_name)
                  vim.cmd("WorkspacesOpen "..workspace_name)

                  if instructions then
                      instructions(workspace_name)
                      require("telescope.builtin").find_files()
                  else
                      vim.cmd("Neotree")
                  end
              end,
          })

          -- mount/open the component
          input:mount()

          -- unmount component when cursor leaves buffer
          input:on(event.BufLeave, function()
              input:unmount()
          end)

      end,
    },


    {
      icon = "",
      text = "Nix home-manager configurations",
      shortcut = "n",
      callback = function()
        -- require("telescope.builtin").buffers()
        vim.cmd("cd ~/.config/dotfiles/home/")
        require("telescope.builtin").find_files()
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
        -- vim.cmd("Neotree")
        vim.cmd("Telescope workspaces")
        -- require("telescope.builtin").find_files()
        -- require("telescope").extensions.workspaces()
      end,
    }
  }
''

# used for mianly plugins and maybe a couple of other misc things that dont exist in nixneovim
{config, ...}: let
  # theme = import ./plugin_configurations/current-theme.nix;
  theme = import (./. + ("/plugin_configurations/themes/" + config.nix-neovim.current-theme + ".nix"));
  # theme = import (./. +  "/plugin_configurations/current-theme.nix");
in
  #TODO: add nushell support
  # example below
  # do -- nushell support
  #   -- set the filetype to nu for all .nu files
  #   vim.filetype.add({
  #       extension = {
  #           nu = 'nu'
  #       }
  #   })
  # end
  # do
  #   -- add nu parser to treesitter
  #   local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  #   parser_config.nu = {
  #     filetype = "nu",
  #   }
  # end
  #TODO: fix nix indenting on line 57
  ''
    --/// Useful features
      do -- add neo-tree stuff
        require("neo-tree").setup({
            enable_git_status = true,
            default_component_configs = {
                git_status = {
                    symbols = {
                      -- Change type
                      added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                      modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                      deleted   = "✖",-- this can only be used in the git_status source
                      renamed   = "󰁕",-- this can only be used in the git_status source
                      -- Status type
                      untracked = "",
                      ignored   = "",
                      unstaged  = "󰄱",
                      staged    = "",
                      conflict  = "",
                    }
                }
            }
        })
      end
      do -- formatter
      -- Utilities for creating configurations

      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      require("formatter").setup {
          -- Enable or disable logging
              logging = true,
                      -- Set the log level
                          log_level = vim.log.levels.WARN,
                      -- All formatter configurations are opt-in
                          filetype = {
                              -- Formatter configurations for filetype "lua" go here
                                  -- and will be executed in order
                                  lua = {
                                      -- "formatter.filetypes.lua" defines default configurations for the
                                          -- "lua" filetype
                                          require("formatter.filetypes.lua").stylua,
                                  },
                              nix = {
                                  require("formatter.filetypes.nix").alejandra,
                              },

                              -- Use the special "*" filetype for defining formatter configurations on
                                  -- any filetype
                                  ["*"] = {
                                      -- "formatter.filetypes.any" defines default configurations for any
                                          -- filetype
                                          require("formatter.filetypes.any").remove_trailing_whitespace
                                  }
                          }
      }
    end
      do -- add wilder support (command line completion)
        local wilder = require('wilder')
        wilder.setup({
          modes = {':', '/', '?'},
          next_key = '<Tab>',
          previous_key = '<S-Tab>',
          accept_key = '<Down>',
          reject_key = '<Up>',
        })
        wilder.set_option('history', {
          30
        })

        wilder.set_option('pipeline', {
          wilder.branch(
            wilder.python_file_finder_pipeline({
              -- to use ripgrep : {'rg', '--files'}
              -- to use fd      : {'fd', '-tf'}
              file_command = {'find', '.', '-type', 'f', '-printf', '%P\n'},
              -- to use fd      : {'fd', '-td'}
              dir_command = {'find', '.', '-type', 'd', '-printf', '%P\n'},
              -- use {'cpsm_filter'} for performance, requires cpsm vim plugin
              -- found at https://github.com/nixprime/cpsm
              filters = {'fuzzy_filter', 'difflib_sorter'},
            }),
            wilder.cmdline_pipeline(),
            wilder.python_search_pipeline()
          ),
        })
        wilder.set_option('renderer', wilder.popupmenu_renderer({
          -- highlighter applies highlighting to the candidates
          highlighter = wilder.basic_highlighter(),
        }))
      end
    do -- add code runner
      -- runs code for stuff
      --? if im going to program in more languages, add more language support if it doenst exist
      require('code_runner').setup({
        filetype = {
          java = {
            "cd $dir &&",
            "javac $fileName &&",
            "java $fileNameWithoutExt"
          },
          python = "python3 -u",
          typescript = "deno run",
          rust = {
            "cd $dir &&",
            "rustc $fileName &&",
            "$dir/$fileNameWithoutExt"
          },
        },
      })
    end
    do -- add neo-term
      require('neo-term').setup()
    end
    do -- add ferris (aka rust support)
      require("ferris").setup()
    end
    do -- add bread crumbs at the top
      require("barbecue").setup()
    end
    do -- fix indenting with # comments
      --vim.opt.cindent = true
      --vim.opt.cinkeys = true
    end
    --/// General QOL features

    do -- add workspaces
      require('workspaces').setup({
          hooks = {
              open = { "Telescope find_files" } -- run the find_files telescope picker every time i open a workspace and keep workspace path
          }
      })
    end

    do -- add smart delimiter autopairing
      require('pairs'):setup()
    end

    do -- add cursor word highlighting
      require('stcursorword').setup()
    end

    do -- setup url opening
      require('url-open').setup()
    end

    do -- setup boolean toggling
      require('nvim-toggler').setup()
    end

    --/// fixes for other configs
    do -- fix cmdline for autocompletion
      --INFO: Setting up cmp-cmdline for cmdline completion
      local cmp = require 'cmp'

      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
          }, {
          {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })
    end
    do --? configuring indent rainbow
        local highlight = {
          "RainbowGreen",
          "RainbowPink",
          "RainbowBlue",
          "RainbowYellow",
        }

        local hooks = require "ibl.hooks"
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#426843" })
          vim.api.nvim_set_hl(0, "RainbowPink", { fg = "#674168" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#245151" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#696932" })
        end)

        require("ibl").setup { indent = { highlight = highlight } }
        vim.g.rainbow_delimiters = { highlight = highlight }
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end

    do -- configuring the dashboard
      --? dashboard setup
      -- TODO customize  it further
      local builtin = require("veil.builtin")

      local default = {
        sections = {
          builtin.sections.animated(builtin.headers.frames_nvim, {
            hl = { fg = "#5de4c7" },
          }),

          builtin.sections.buttons(${import ./plugin_configurations/dashboard.nix}),
          builtin.sections.oldfiles(),
        },
        mappings = {},
        startup = true,
        listed = false
      }

      require('veil').setup(default)

      vim.keymap.set('n',"<leader>ab",":Veil<CR>", { desc = "Open dashboard", silent = true })

    end

    --/// Configuring the theme
    do
      local colors = {
        test_red = "${theme.test-red}",
        test_green = "${theme.test-green}",
        test_blue = "${theme.test-blue}",
        accent = "${theme.accent}", -- for cursor and statusline
        background = "${theme.background}",
        popup_menu_background = "${theme.popup-menu-background}",
        text_color = "${theme.text-color}",

        statements = "${theme.statements}",
        strings = "${theme.strings}",
        operators = "${theme.operators}",
        delimiters = "${theme.delimiters}",
        booleans = "${theme.booleans}",
        constants = "${theme.constants}",

        comments = "${theme.comments}",
        identifiers = "${theme.identifiers}", -- like print and stuff
        directory = "${theme.directory}",
        functions = "${theme.functions}",
        numbers = "${theme.numbers}",
        keywords = "${theme.keywords}",
        variables = "${theme.variables}",

        line_numbers = "${theme.line-numbers}",
        line_background = "${theme.line-background}",
        self_word = "${theme.self-word}",

        annotations = "${theme.annotations}",
        attributes = "${theme.attributes}",

        errors = "${theme.errors}",
        info = "${theme.info}",
        todo = "${theme.todo}",
        help = "${theme.help}",

        window_border = "${theme.window-border}",

        color0 = "${theme.color0}";
        color8 = "${theme.color8}";
        color1 = "${theme.color1}";
        color9 = "${theme.color9}";
        color2 = "${theme.color2}";
        color10 = "${theme.color10}";
        color3 = "${theme.color3}";
        color11 = "${theme.color11}";
        color4 = "${theme.color4}";
        color12 = "${theme.color12}";
        color5 = "${theme.color5}";
        color13 = "${theme.color13}";
        color6 = "${theme.color6}";
        color14 = "${theme.color14}";
        color7 = "${theme.color7}";
        color15 = "${theme.color15}";
      }
      --import the highlight groups with their respective palettes
      ${import ./plugin_configurations/highlight-groups.nix}

      require("palette").setup({
        custom_highlight_group = "nixneovim-theme",
        custom_highlight_groups = {
          ["nixneovim-theme"] = new_palette
        }

      })

      vim.cmd([[colorscheme palette]])

    end

  ''

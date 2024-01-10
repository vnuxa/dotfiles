# used for mianly plugins and maybe a couple of other misc things that dont exist in nixneovim
{  config,  ... }:
let 
# theme = import ./plugin_configurations/current-theme.nix;
theme = import (./. + ( "/plugin_configurations/themes/" + config.nix-neovim.current-theme + ".nix"));
# theme = import (./. +  "/plugin_configurations/current-theme.nix");
in 
''
  --/// Useful features
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
  do -- add bread crumbs at the top
    require("barbecue").setup()
  end
  --/// General QOL features

  do -- add workspaces
    require('workspaces').setup()
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
      "RainbowYellow",
      "RainbowGreen",
      "RainbowPink",
      "RainbowBlue",
    }

    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#696932" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#426843" })
      vim.api.nvim_set_hl(0, "RainbowPink", { fg = "#674168" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#245151" })
    end)

    require("ibl").setup { indent = { highlight = highlight } }
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
      
      statements = "$${theme.statements}",
      strings = "${theme.strings}",
      operators = "${theme.operators}", 
      delimiter = "${theme.delimiter}",
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
    }
    --import the highlight groups with their respective palettes
    ${import ./plugin_configurations/highlight-groups.nix }

    require("palette").setup({
      custom_highlight_group = "nixneovim-theme",
      custom_highlight_groups = {
        ["nixneovim-theme"] = new_palette
      }

    })

    vim.cmd([[colorscheme palette]])

  end

''

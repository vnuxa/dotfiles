''
  ---? Structure
  --- {
      --- Highlight group (STRING)
          --- Foreground color (HEX)
          --- Background color (HEX)
          --- Text style (or styles) (italic, underline, bold) (TABLE WITH SELECTED STYLE STRINGS INSIDE) (ex.: {"italic", "bold"} )
          ---* all have nil defaults
          --- }
          local new_palette = {
              --? Defaults (like default neovim highlighting stuff)
                  -- Default window, etc. bg = None is transparent..
                  { "Whitespace", colors.accent },
                  { "Normal", colors.text_color ,colors.background },
                  { "NormalFloat", colors.keywords },
                  { "FloatBorder", colors.text_color, colors.background },
                  { "NotifyBackground", nil, colors.background },
                  { "NonText", colors.text_color },

                  -- End of buffer: ~'s
                  { "EndOfBuffer", colors.background }, -- you can make it the same as background color to hide it

              -- Special characters
              { "Special", colors.accent }, -- you can see on buffer line AND fuzzy find
              { "SpecialChar", colors.test_green }, --! dont know

              -- Preprocessor & Include
              { "PreProc", colors.keywords }, --! dont know
              { "Include", colors.strings },--you cna see this on nixos imports

              -- Statements and Keywords
              { "Statement", colors.statements },
              { "Conditional", colors.statements },
              { "Repeat", colors.statements },
              { "Exception", colors.statements },
              { "Directory", colors.directory }, -- file explorer mostly
              { "Keyword", colors.keywords }, --visible in whichkey things

              -- Operators and Delimiters
              { "Operator", colors.operator },
              { "Delimiter", colors.delimiters },

              -- Comments and Documentation
              { "Comment", colors.comments, nil, {"italic"} },
              { "DocComment", colors.comments, nil, {"italic"}},

              -- Identifiers
              { "Identifier", colors.identifiers },
              { "Variable", colors.test_green }, --TODO

              { "Function", colors.functions },

                  -- Strings
                  { "String", colors.strings },


                  -- Variables --TODO
                  { "Type", colors.delimiters, nil, "NONE" },
                  { "Label", colors.statements }, -- javascript default keyword

              -- Constants and Literals
              { "Character", colors.strings },
              { "Number", colors.numbers },
              { "Boolean", colors.booleans },
              { "Float", colors.statements },
              { "Constant", colors.constants },

              -- Todo's etc.
              { "Todo", colors.accent, nil, {"italic"} },
              { "Debug", colors.accent, nil, {"italic"} },

              -- Status line, VertSplit, Tab pages, Titles, etc.
              { "StatusLine", colors.popup_menu_background },
              { "StatusLineNC", colors.popup_menu_background },
              { "VertSplit", colors.background }, -- could change it to something brighter so that you knwo wherei t splits
              { "TabLine", colors.directory },
                  { "TabLineSel", colors.accent },
                  { "TabLineFill", colors.accent },
                  { "Title", colors.line_numbers }, --! dont know
              { "SignColumn", colors.background }, -- For the bar at the side, where comment signs can be

              -- Visual Mode
              { "Visual", colors.functions, colors.line_background },
              { "VisualNOS", colors.test_green, colors.popup_menu_background }, --! dont know

              -- Line Numbers
              { "LineNr", colors.line_numbers },
              { "CursorLineNr", colors.text_color },

              -- -- Folded text, and the column where it's shown --! not done becuase i dont know how folds work
                  -- { "Folded", m.color4, m.bg },
              -- { "FoldColumn", m.color4, m.bg },

              -- Popup menu
              { "Pmenu", colors.statements, colors.popup_menu_background },
              { "PmenuSel", colors.statements, colors.line_background },
              --{ "PmenuSbar", a.accent0 },
              { "PmenuThumb", nil, colors.text_color },


              -- -- Spell checking --! not done becuase i couldnt care less
                  -- { "SpellBad", colors.statement },
              -- { "SpellCap", colors },
              -- { "SpellRare", m.color5 },
              -- { "SpellLocal", m.color6 },


              -- More UI elements --! dont know where they are
              { "Cursor", colors.test_red },
              { "CursorColumn", colors.test_green },
              { "CursorLine", nil, colors.line_background },
              { "CursorLineFold", colors.test_green },
              { "CursorLineSign", colors.test_blue },
              { "ToolbarLine", colors.test_red },
              { "ToolbarButton", colors.test_green },
              -- { "WindowBorder",  colors.test_red},


              -- UI Messages / prompts
                  -- quit, etc.
                  { "MoreMsg", colors.numbers },
              -- input method (prompt)
              { "CursorIM", colors.test_red },
              { "Question", colors.numbers },
              { "SpecialKey", colors.test_green },

              -- Search & Matches
              { "MatchParen", colors.numbers },
              { "Search", colors.directory },
              { "IncSearch", colors.directory, colors.line_background },

              -- ? nvim-treesitter stuff
              { "@annotation", colors.annotations }, -- javascirpt i think
              { "@attribute", colors.attributes }, -- css and js maybe
              { "@boolean", colors.booleans },
                  { "@character", colors.strings },
                  { "@character.special", colors.accent }, -- dont know
              { "@comment", colors.comments, nil, {"italic"}}, -- might need to set italic
              { "@conditional", colors.statements }, -- dont know

              { "@constant", colors.constants }, -- dont know
              { "@constant.builtin", colors.accent }, -- dont know

              { "@constructor", colors.accent }, -- dont know
              { "@define", colors.self_word }, -- dont know
              { "@defaultLibrary", colors.self_word }, -- variable default library (like self and stuff)
              { "@error", colors.errors } ,
                  { "@exception", colors.line_numbers }, -- dont know
              { "@field", colors.variables }, -- dictionary keys and refrencing them -- you can also try accent
              { "@float", colors.numbers },

                  { "@function", colors.functions },
                  { "@function.builtin", colors.accent }, -- dont know
              { "@function.call", colors.functions },

                  { "@include", colors.annotations }, -- i think c++ includes
              { "@keyword", colors.keywords }, -- dont know

              { "@keyword.function", colors.functions }, -- or use function color
              { "@keyword.operator", colors.identifiers },
                  { "@keyword.return", colors.functions },

                  { "@label", colors.statements },
                  { "@method", colors.functions },
                  { "@method.call", colors.functions },

                  { "@namespace", colors.self_word },

                  { "@number", colors.numbers },
                  { "@operator", colors.operators },
                  { "@parameter", colors.accent }, -- OR you can use identifier
              { "@preproc", colors.identifiers },
                  { "@property", colors.identifiers },

                  { "@punctuation.bracket", colors.delimiters_fix },
                  { "@punctuation.delimiter", colors.text_color },
                  { "@punctuation.special", colors.text_color },

                  { "@repeat", colors.statements },

                  { "@string", colors.strings },
                  { "@string.escape", colors.identifiers },
                  { "@string.regex", colors.identifiers },
                  { "@string.special", colors.strings },

                  { "@symbol", colors.identifiers },

                  { "@tag", colors.text_color },
                  { "@tag.attribute", colors.constants },
                  { "@tag.delimiter", colors.delimeters },
                  -- a lot of missing stuff, dont know if i need or not
                  { "@todo", colors.accent, nil, {"bold"} },

                  { "@type", colors.annotations },
                  { "@type.builtin", colors.annotations },
                  { "@type.definitions", colors.annotations }, -- dont know
              { "@type.qualifier", colors.annotations },

                  { "@variable",  colors.text_color }, -- or change it to variables if you want
              { "@variable.builtin", colors.variables },

                  --? missing lsp stuff (diagnostics)
                      -- you can add these
                      -- LspReferenceRead = { bg = p.bg3 },
                  -- LspReferenceWrite = { bg = p.bg3 },
                  -- LspReferenceText = { bg = p.bg3 },
                  -- LspInfoBorder = { fg = p.bg4 },

                  -- lsp sematic tokens
                  { "LspNamespace", colors.self_word },
                  { "LspType", colors.annotations },
                  { "LspClass", colors.annotations },
                  { "LspEnum", colors.constants },
                  { "LspInterface", colors.constants },
                  { "LspTypeParameter", colors.annotations },
                  { "LspParameter", colors.accent },

                  -- todo comments
                      --Foreground
                      { "TodoFGNOTE", colors.help },
                      { "TodoFgFIX", colors.errors },
                      { "TodoFgPERF", colors.info },
                      --Background
                      { "TodoBGNOTE", colors.background, colors.help },
                      { "TodoBgFIX", colors.background, colors.errors },
                      { "TodoBgPERF", colors.background, colors.info },


                  -- Git & Version Control
                  { "gitcommitComment", colors.color6 },
                  { "gitcommitUntracked", colors.color7},
                  { "gitcommitDiscarded", colors.color9 },
                  { "gitcommitSelected", colors.statements },
                  { "gitcommitUnmerged", colors.self_word },
                  { "gitcommitOnBranch", colors.color2 },
                  { "gitcommitBranch", colors.help },
                  { "gitcommitDiscardedType", colors.color9 },
                  { "gitcommitSelectedType", colors.color11 },
                  { "gitcommitUntrackedFile", colors.color7},
                  { "gitcommitDiscardedFile", colors.color9 },
                  { "gitcommitUnmergedFile", colors.color5},
                  { "gitcommitSelectedFile",  colors.color4 },


                  -- neo tree
                      { "NeoTreeModified", colors.numbers },
                      -- { "NeoTreeFileName", colors.test_red },

                      -- neo tree git colors

                      { "NeoTreeGitAdded", colors.color2 },
                      { "NeoTreeGitConflict", colors.color1},
                      { "NeoTreeGitDeleted", colors.color9 },
                      { "NeoTreeGitIgnored", colors.color15 },
                      { "NeoTreeGitModified", colors.color5 },
                      { "NeoTreeGitUnstaged", colors.color4 },
                      { "NeoTreeGitUntracked", colors.color6 },
                      { "NeoTreeGitStaged", colors.color10},


                  -- rust setup
                      { "@lsp.type.variable.rust", colors.text_color },
                      { "@lsp.type.parameter.rust", colors.text_color, nil, {"italic"} },
                      { "@lsp.type.property.rust", colors.variables },

                      { "@lsp.type.struct.rust", colors.identifiers },
                      { "@lsp.type.interface.rust", colors.identifiers },

                      { "@lsp.typemod.struct.declaration.rust", colors.accent },
                      { "@lsp.typemod.interface.declaration.rust", colors.accent },
                      { "@lsp.typemod.method.declaration.rust", colors.accent, nil, {"italic"} },
                      { "@lsp.typemod.function.declaration.rust", colors.accent, nil, {"italic"} },

                      { "@lsp.type.selfKeyword.rust", colors.self_word },
                      { "@lsp.type.macro.rust", colors.identifiers },
                      { "@lsp.type.builtinType.rust", colors.numbers, nil, {"italic"} },
                      { "@lsp.type.namespace.rust", colors.strings, nil, {"italic"} },
                      { "@lsp.type.enum.rust", colors.annotations },
                      { "@type.qualifier.rust", colors.accent },

                  --nix setup
                      { "@lsp.type.boolean.nix", colors.booleans },
                      { "@lsp.type.path.nix", colors.strings },
                      { "@lsp.type.variable.nix", colors.variables },
                      { "@lsp.type.property.nix", colors.text_color, nil, {"italic"} },

                      { "@lsp.mod.withAttribute.nix", colors.variables, nil, {"italic"} },

                      { "@lsp.typemod.parameter.definition.nix", colors.accent },
                      { "@lsp.typemod.property.definition.nix", colors.text_color },
          }
''

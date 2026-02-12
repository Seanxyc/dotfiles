return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
    },
  },

  -- animations
  {
    "nvim-mini/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- filename
  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  -- Disable snacks dashboard to use dashboard-nvim instead
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
  },

  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = function()
      -- Set dashboard colors to 墨绿色
      local main_color = "#2aa198"  -- 亮墨绿色
      local light_color = "#5fc4b8" -- 更亮的版本
      local dark_color = "#1a5c6b"  -- 稍暗的版本

      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = main_color })
      vim.api.nvim_set_hl(0, "DashboardIcon", { fg = light_color })
      vim.api.nvim_set_hl(0, "DashboardDesc", { fg = light_color })
      vim.api.nvim_set_hl(0, "DashboardKey", { fg = main_color, bold = true })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = dark_color, italic = true })

      local logo = [[
	    ███╗   ███╗ █████╗ ██╗  ██╗███████╗   
	    ████╗ ████║██╔══██╗██║ ██╔╝██╔════╝   
	    ██╔████╔██║███████║█████╔╝ █████╗     
	    ██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝     
	    ██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗   
	    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   
	      ██████╗ ██████╗  ██████╗ ██╗        
	     ██╔════╝██╔═══██╗██╔═══██╗██║        
	     ██║     ██║   ██║██║   ██║██║        
	     ██║     ██║   ██║██║   ██║██║        
	     ╚██████╗╚██████╔╝╚██████╔╝███████╗   
	      ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝   
	███████╗████████╗██╗   ██╗███████╗███████╗
	██╔════╝╚══██╔══╝██║   ██║██╔════╝██╔════╝
	███████╗   ██║   ██║   ██║█████╗  █████╗  
	╚════██║   ██║   ██║   ██║██╔══╝  ██╔══╝  
	███████║   ██║   ╚██████╔╝██║     ██║     
	╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝     
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = 'lua require("telescope.builtin").find_files()',                                    desc = " Find File",       icon = " ", key = "f" },
            { action = "ene | startinsert",                                                                desc = " New File",        icon = " ", key = "n" },
            { action = 'lua require("telescope.builtin").oldfiles()',                                      desc = " Recent Files",    icon = " ", key = "r" },
            { action = 'lua require("telescope.builtin").live_grep()',                                     desc = " Find Text",       icon = " ", key = "g" },
            { action = 'lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })', desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',                                                desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                                                       desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                                                             desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end,                                   desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
}

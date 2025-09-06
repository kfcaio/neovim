local packer = require("packer")

vim.cmd([[packadd packer.nvim]])

packer.startup(function(use)
  use({
    "mfussenegger/nvim-lint",
  })
  use({
    "rshkarin/mason-nvim-lint",
    after = { "mason.nvim", "nvim-lint" },
  })
  use({
    "ibhagwan/fzf-lua",
    requires = { "nvim-tree/nvim-web-devicons" },
  })
  use("wbthomason/packer.nvim")
  use({
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  })
  use("windwp/nvim-autopairs")
  use("Mofiqul/dracula.nvim")
  use("tpope/vim-commentary")
  use("airblade/vim-gitgutter")
  use("APZelos/blamer.nvim")
  use {
    "nvim-lualine/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use("tpope/vim-fugitive")
  use({
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
    end,
  })
  use({
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  })
  use({
    "williamboman/mason-lspconfig.nvim",
    after = { "mason.nvim" },
    config = function()
      local status, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not status then
        return
      end
      -- usar apenas ensure_installed, não chama automatic_enable
      mason_lspconfig.setup({
        ensure_installed = { "pyright" }
      })
    end,
  })
  use({
    "neovim/nvim-lspconfig",
    after = { "mason-lspconfig.nvim" },
  })
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use({
  "nvim-tree/nvim-tree.lua",
   requires = {
    "kyazdani42/nvim-web-devicons",
   },
  })
  use {
    "rmagatti/goto-preview",
    config = function()
    require('goto-preview').setup {}
    end
  }
  use {
    'azorng/goose.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        config = function()
          require('render-markdown').setup({
            anti_conceal = { enabled = false },
          })
        end,
      }
    },
    config = function()
      require('goose').setup({})
    end,
  }
end)

local set = vim.opt
vim.g.blamer_enabled = true
vim.g.blamer_delay = 2000
vim.g.blamer_show_in_insert_modes = 0

set.foldlevel = 99
set.foldenable = false
set.foldmethod = "indent"
set.background = "dark"
set.clipboard = "unnamedplus"
set.completeopt = "noinsert,menuone,noselect"
set.cursorline = true
set.expandtab = true
set.hidden = true
set.inccommand = "split"
set.mouse = "a"
set.number = true
set.relativenumber = true
set.shiftwidth = 2
set.smarttab = true
set.splitbelow = true
set.splitright = true
set.swapfile = false
set.tabstop = 2
set.termguicolors = true
set.title = true
set.ttimeoutlen = 0
set.updatetime = 250
set.wildmenu = true
set.wrap = true

vim.cmd([[
  filetype plugin indent on
  syntax on
  filetype on
  colorscheme dracula
]])

require('lualine').setup {
  options = {
    theme = 'codedark'
  },
  sections = {
    lualine_a = { 'buffers' },
    lualine_c = {},
    lualine_x = {},
  }
}


require('goto-preview').setup {
  width = 120; -- Width of the floating window
  height = 15; -- Height of the floating window
  border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
  default_mappings = false; -- Bind default mappings
  debug = false; -- Print debug information
  opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
  post_close_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
  focus_on_open = true; -- Focus the floating window when opening it.
  dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
  stack_floating_preview_windows = true, -- Whether to nest floating windows
  preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
}

vim.g.mapleader = "`"

vim.diagnostic.config({
  float = {
    source = "always",
    format = function(diagnostic)
      return string.format(
        "%s (%s) [%s]",
        diagnostic.message,
        diagnostic.code or "",
        diagnostic.source
      )
    end,
  },
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
})

require'nvim-tree'.setup({
  view = {
    adaptive_size = true,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        item = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = false,
      show = {
        file = false,
        folder = true,
        folder_arrow = false,
        git = true
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "", -- 
          staged = "",
          unmerged = "",
          renamed = "➜",
          untracked = "",
          deleted = "",
          ignored = "◌",
        },
     },
    },
  }
})

-- vim.cmd([[ autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

vim.keymap.set('n', '<leader>f', '<cmd>:NvimTreeToggle<cr>')

-- ~/.config/nvim/init.lua  -----------------------------------------------
-- Reimplementa :Ag aceitando qualquer combinação de FLAGS + PADRÃO,
-- espelhando a sintaxe da linha de comando “ag [flags] <pattern> [path]”.
-- Usa fzf#vim#grep() porque é o *wrapper* mais flexível.

-- Pequeno utilitário para converter a lista de args em string segura
local function shell_escape(str)
  -- A função fzf#shellescape faz exatamente isso no lado Vim-script.
  return vim.fn["fzf#shellescape"](str)
end

local function build_ag_cmd(opts)
  -- opts.args: string com tudo que o usuário digitou após :Ag
  -- Ex.: "--hidden --ignore vendor foo"
  -- Não tentamos reorganizar nada, só prefixamos nossas opções padrão.
  local default = "--nogroup --column --color --line-number --smart-case"
  return ("ag %s %s"):format(default, opts.args)
end

local function ag_with_flags(opts)
  -- 1. Monta a linha de comando
  local cmd = build_ag_cmd(opts)

  -- 2. Abre fzf com pré-visualização (usa preview.sh do plugin)
  local spec = vim.fn["fzf#vim#with_preview"]()

  -- 3. Chama o wrapper de grep; o terceiro argumento indica fullscreen (!)
  vim.fn["fzf#vim#grep"](cmd, spec, opts.bang and 1 or 0)
end

-- Cria (ou sobrescreve) o comando :Ag
-- vim.api.nvim_create_user_command(
--   "Ag",
--   ag_with_flags,
--   {
--     bang = true,         -- permite :Ag! para fullscreen
--     nargs = "*",         -- aceita 0 ou mais argumentos
--     complete = "file",   -- completa arquivos/caminhos
--   }
-- )
-- -----------------------------------------------------------------------




vim.keymap.set("n", "<leader>d", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})
vim.keymap.set("n", "<leader>D", function()
  require("goto-preview").goto_preview_definition()
  vim.defer_fn(function()
    vim.cmd("wincmd T") -- move janela atual (preview) para nova aba
  end, 100)
end, { noremap = true, silent = true })

vim.g.python3_host_prog="/Users/jusbrasil/.pyenv/shims/python3"

local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	-- Theme, colors and gui
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

local servers = {
	pyright = {},

	eslint = {
		codeAction = {
			disableRuleComment = {
				enable = false,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = false,
		nodePath = "",
		onIgnoredFiles = "off",
		packageManager = "npm",
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "location",
		},
	},
  ts_ls = {},
	bashls = {},
	cssls = {},
	html = {},
	jsonls = {},
	lemminx = {},
	gopls = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}

-- MASON.NVIM
require("mason").setup()

-- Force all LSP servers to agree on position encoding (UTF-8) to avoid
-- the "buffers attached to multiple clients with different position encodings" warning.
-- We patch the capabilities once and also patch pyright explicitly because it
-- still advertises UTF-16 by default.
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- MASON-LSPCONFIG.NVIM
local capabilities = lsp_capabilities

vim.opt.updatetime = 100

vim.api.nvim_create_autocmd({"CursorHold"}, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end, 500)
  end,
})

local capabilities = lsp_capabilities
local cmp = require 'cmp'

cmp.setup({
  mapping = {
    -- <C-r> aceita a sugestão selecionada
    ['<C-r>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),  -- força a abertura da seleção (opcional)
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>']   = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
  },
  -- Sugestões aparecem automaticamente
  completion = {
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    -- Se quiser sugestões na command-line do vim:
    { name = "cmdline" },
    -- Outras fontes opcionais, se usar:
    { name = "copilot" },
    { name = "supermaven" },
  },
  -- Caso queira menu mesmo sem seleção
  experimental = {
    ghost_text = false,
  },
  preselect = cmp.PreselectMode.None,  -- não seleciona automaticamente
})

if vim.fn.exists(':Troubles') == 0 then
  vim.api.nvim_create_user_command('Troubles', function()
    vim.diagnostic.setloclist({ open = false })
    vim.cmd('lopen')        -- abre a location-list logo em seguida
  end, { desc = 'Abre a location-list com os diagnostics do buffer' })
end

local opts = {}
vim.api.nvim_set_keymap("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)

-- show the effects of a search / replace in a live preview window
vim.o.inccommand = "split"

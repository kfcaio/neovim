local packer = require("packer")

vim.cmd([[packadd packer.nvim]])

packer.startup(function()
  use("wbthomason/packer.nvim")
  use("windwp/nvim-autopairs")
  use("Mofiqul/dracula.nvim")
  use("dense-analysis/ale")
  use("tpope/vim-commentary")
  use("airblade/vim-gitgutter")
  use("APZelos/blamer.nvim")
  use {
    "nvim-lualine/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use("tpope/vim-fugitive")
  use({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	})
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use({
  "kyazdani42/nvim-tree.lua",
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
  use({
    "junegunn/fzf.vim",
    requires = { "junegunn/fzf", run = ":call fzf#install()" }
 })
  use {
  'Exafunction/codeium.vim',
  config = function ()
    vim.keymap.set('i', '<leader>n', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<leader>p', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<leader>x', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end
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
  virtual_text = false,
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
vim.api.nvim_create_user_command(
  "Ag",
  ag_with_flags,
  {
    bang = true,         -- permite :Ag! para fullscreen
    nargs = "*",         -- aceita 0 ou mais argumentos
    complete = "file",   -- completa arquivos/caminhos
  }
)
-- -----------------------------------------------------------------------




vim.keymap.set("n", "<leader>d", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})
vim.keymap.set("n", "<leader>D", function()
  require("goto-preview").goto_preview_definition()
  vim.defer_fn(function()
    vim.cmd("wincmd T") -- move janela atual (preview) para nova aba
  end, 100)
end, { noremap = true, silent = true })

vim.g.ale_linters = {
   python = {'flake8'}
}

vim.g.ale_set_balloons = 0
vim.g.ale_virtualtext_cursor = 0
vim.g.ale_python_flake8_options = '--max-line-length=79 --extend-ignore=E203'

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

-- MASON-LSPCONFIG.NVIM
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

vim.opt.updatetime = 100

vim.api.nvim_create_autocmd({"CursorHold"}, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end, 500)
  end,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local cmp = require 'cmp'
cmp.setup {
    capabilities = capabilities,
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<C-t>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = "supermaven" },
        { name = 'nvim_lsp' },
    },
}

-- Cola com indentação corrigida
vim.keymap.set("n", "p", "p=`]", { noremap = true, silent = true })

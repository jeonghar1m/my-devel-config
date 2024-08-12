if vim.g.vscode then
  return
end

lvim.plugins = {
  {
    "neanias/everforest-nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("everforest").setup({
        -- Your config here
        options = {
          theme = "everforest", -- Can also be "auto" to detect automatically.
        }
      })
      vim.o.background='dark'
    end,
  },
  --[[
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "soft",
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
  ]]--
  {
    "HiPhish/nvim-ts-rainbow2",
    config = function()
      require('nvim-treesitter.configs').setup {
        rainbow = {
          enable = true,
          -- Which query to use for finding delimiters
          query = 'rainbow-parens',
          -- Highlight the entire buffer all at once
          strategy = require('ts-rainbow').strategy.global,
        }
      }
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    'ggandor/lightspeed.nvim',
    event = "BufRead",
    config = function()
      require('lightspeed').setup({
        ignore_case = true
      })
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', ',t', ',z', ',b' },
        hide_cursor = true,            -- Hide cursor while scrolling
        stop_eof = true,               -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false,   -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,     -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true,   -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = "quadratic", -- Default easing function
        pre_hook = nil,                -- Function to run before the scrolling animation starts
        post_hook = nil,               -- Function to run after the scrolling animation ends
      })
      local t    = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '250', [['sine']] } }
      t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '250', [['sine']] } }
      t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '350', [['circular']] } }
      t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '350', [['circular']] } }
      t['<C-y>'] = { 'scroll', { '-0.10', 'false', '70', nil } }
      t['<C-e>'] = { 'scroll', { '0.10', 'false', '70', nil } }
      t[',t']    = { 'zt', { '120' } }
      t[',z']    = { 'zz', { '120' } }
      t[',b']    = { 'zb', { '120' } }

      require('neoscroll.config').set_mappings(t)
    end
  },
  {
    'gen740/SmoothCursor.nvim',
    config = function()
      require('smoothcursor').setup({
        autostart = true,
        cursor = "", -- cursor shape (need nerd font)
        texthl = "SmoothCursor", -- highlight group, default is { bg = nil, fg = "#FFD400" }
        linehl = nil, -- highlight sub-cursor line like 'cursorline', "CursorLine" recommended
        type = "default", -- define cursor movement calculate function, "default" or "exp" (exponential).
        fancy = {
          enable = true, -- enable fancy mode
          head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
          body = {
            { cursor = "●", texthl = "SmoothCursorRed" },
            { cursor = "●", texthl = "SmoothCursorOrange" },
            { cursor = "⦿", texthl = "SmoothCursorYellow" },
            { cursor = "⦿", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" }
        },
        flyin_effect = "top",                                   -- "bottom" or "top"
        speed = 25,                                             -- max is 100 to stick to your current position
        intervals = 35,                                         -- tick interval
        priority = 10,                                          -- set marker priority
        timeout = 3000,                                         -- timout for animation
        threshold = 3,                                          -- animate if threshold lines jump
        disable_float_win = true,                               -- disable on float window
        enabled_filetypes = nil,                                -- example: { "lua", "vim" }
        disabled_filetypes = { "TelescopePrompt", "NvimTree" }, -- this option will be skipped if enabled_filetypes is set. example: { "TelescopePrompt", "NvimTree" }
      })
    end
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 1
      vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
      vim.g.gitblame_date_format = '%Y-%m-%d %H:%M:%S'
      local git_blame = require('gitblame')
      require('lualine').setup({
        sections = {
          lualine_c = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
          }
        }
      })
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup({
        virtual_style = 'window',
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.2',
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
        },
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
    },
    config = function(_, opts) 
      require "lsp_signature".setup(opts) 
      local golang_setup = {
        on_attach = function(_, bufnr)
          require "lsp_signature".on_attach(opts, bufnr)  -- Note: add in lsp client on-attach
        end,
      }
      require'lspconfig'.gopls.setup(golang_setup)
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
      vim.cmd("noremap <silent> <F12> :SymbolsOutline<CR>")
    end
  },
  {
    "dnlhc/glance.nvim",
    config = function()
      require('glance').setup({
        theme = {
          mode = 'brighten'
        },
        border = {
          enable = true,
          top_char = '―',
          bottom_char = '―',
        },
        hooks = {
          before_open = function(results, open, jump, method)
            local result_size = #results
            local i = 1
            while i <= result_size do -- warning: do not cache the table length
              local v = results[i]
              if string.find(v.uri, "/mock/") ~= nil then
                results[i] = results[result_size]
                results[result_size] = nil
                result_size = result_size - 1
              else
                i = i + 1
              end
            end

            if result_size == 0 then
              return
            end

            if result_size == 1 then
              jump(results[0])
            else
              open(results)
            end
          end,
        }
      })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        markdown = { 'vale', },
        jshint = { 'jshint', },
        jsonlint = { 'jsonlint', },
        luacheck = { 'luacheck', },
      }
    end,
  },
  {
    "preservim/nerdtree",
    config = function()
      vim.cmd("map <F9> :NERDTreeToggle<CR>")
      vim.cmd("nnoremap <leader>e :NERDTreeToggle<CR>")
      vim.cmd("let NERDTreeWinPos='left'")
      vim.cmd("let g:nerdtreedirarrows=0")
      vim.cmd("let nerdtreequitonopen=1")
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
    },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    event = 'VeryLazy',
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = 'right'
      vim.g.db_ui_use_nvim_notify = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = '~/Google Drive/내 드라이브/App/App-Config/neovim/db_ui_queries'
    end,
  }
}

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.modifiable = true
-- -- fold
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"                     -- "expr" "manual"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
vim.opt.foldlevel = 99                          -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldcolumn = '1'                        -- '0' is not bad
vim.opt.foldlevelstart = 99
vim.cmd([[
augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END
]])
-- -- fold DONE

lvim.colorscheme = "everforest"
lvim.builtin.cmp.completion.keyword_length = 2
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.autotag.enable = true
lvim.builtin.telescope.defaults.layout_config.width = 0.95
lvim.builtin.telescope.defaults.layout_config.preview_cutoff = 75
lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
end
lvim.builtin.bufferline.options = {
  indicator = {
    style = 'underline'
  },
  separator_style = "slant",
  hover = {
    enabled = true,
    delay = 200,
    reveal = { 'close' }
  },
}

lvim.keys.normal_mode["L"] =
":BufferLineCycleNext<CR>" -- Switch to Next File Buffer
lvim.keys.normal_mode["H"] =
":BufferLineCyclePrev<CR>" -- Switch to Previous File Buffer
lvim.keys.normal_mode["P"] = "<CMD>BufferLineGroupToggle pinned<CR><CMD>bufdo BufferLineTogglePin<CR>"
lvim.keys.normal_mode["X"] =
"<CMD>BufferKill<CR>"                                                       -- Close Current File Buffer
lvim.keys.normal_mode["<Leader>bp"] =
"<CMD>BufferLineGroupClose ungrouped<CR><CMD>bufdo BufferLineTogglePin<CR>" -- Close all non-pinned buffers
lvim.keys.normal_mode["<F10>"] = "<CMD>bufdo BufferLineTogglePin<CR>"
lvim.keys.normal_mode["<F11>"] = "<CMD>ToggleBlame virtual<CR>"
lvim.keys.normal_mode["<Leader>df"] = "<CMD>DiffviewFileHistory %<CR>"
lvim.keys.normal_mode["<Leader>D"] = "<CMD>DBUIToggle<CR>"
lvim.keys.normal_mode["<Leader>lR"] = "<CMD>LspRestart<CR>"
lvim.keys.normal_mode['<M-j>'] = false
lvim.keys.normal_mode['<M-k>'] = false
lvim.keys.normal_mode["<Char-27>h"] = "<c-w>h"
lvim.keys.normal_mode["<Char-27>j"] = "<c-w>j"
lvim.keys.normal_mode["<Char-27>k"] = "<c-w>k"
lvim.keys.normal_mode["<Char-27>l"] = "<c-w>l"
lvim.keys.normal_mode["<Char-27>b"] = "<CMD>Telescope buffers<CR>"
lvim.keys.normal_mode["<Char-27>f"] = "<CMD>Telescope find_files hidden=true no_ignore=true<CR>"
lvim.keys.normal_mode["<Char-27>r"] = "<CMD>Telescope oldfiles<CR>"
lvim.keys.normal_mode["<Char-27>S"] = "<CMD>Telescope live_grep<CR>"
lvim.keys.normal_mode["<Char-27>s"] = "<CMD>Telescope grep_string<CR>"
lvim.keys.visual_mode["<Char-27>s"] = "<CMD>Telescope grep_string<CR>"
lvim.keys.normal_mode["<C-i>"] = "<CMD>Glance implementations<CR>"
lvim.keys.normal_mode["<C-[>"] = "<CMD>Glance references<CR>"
lvim.keys.normal_mode["[["] = "[{"
lvim.keys.normal_mode["]]"] = "]}"
lvim.keys.normal_mode["j"] = "gj"
lvim.keys.normal_mode["k"] = "gk"

vim.cmd([[
let g:hexViewer = 0
func! Hv()
  if (g:hexViewer == 0)
    let g:hexViewer = 1
    exe "%!xxd"
  else
    let g:hexViewer = 0
    exe "%!xxd -r"
  endif
endfunc

function! CloseOnShutdown()
  if eval('@%')==''
      set nomodified
  elseif eval('@%')=~'sql$'
      set nomodified
  endif
endfunction

set wrap
set clipboard+=unnamedplus
nmap ,h :call Hv()<cr>

command! Q DiffviewClose
command! QA :bufdo bd

autocmd BufWritePre *.go lua go_org_imports()
autocmd BufEnter,FocusGained * checktime
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
autocmd FileType dbui nmap <buffer> v <Plug>(DBUI_SelectLineVsplit)
autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni
autocmd ColorScheme * lua require'lightspeed'.init_highlight(true)
au BufNewFile,BufRead /private/**/gopass** setlocal noswapfile nobackup noundofile
autocmd FocusLost * call CloseOnShutdown()
autocmd BufLeave * call CloseOnShutdown()

let g:NERDTreeQuitOnOpen = 1
function s:buffer_name_generator(opts)
  if empty(a:opts.table)
    return a:opts.schema.'query.sql'
  endif
  return a:opts.schema.a:opts.table.'-'.a:opts.label.'.sql'
endfunction

let g:Db_ui_buffer_name_generator = function('s:buffer_name_generator')
let g:db_ui_table_helpers = {
\   'mysql': {
\     'List': 'SELECT * FROM {optional_schema}{table} ORDER BY id desc LIMIT 200',
\     'Count': 'select count(*) from {optional_schema}{table}'
\   }
\ }
let g:completion_chain_complete_list = {
\   'sql': [
\    {'complete_items': ['vim-dadbod-completion']},
\   ],
\ }
let g:completion_matching_strategy_list = ['exact', 'substring']
let g:completion_matching_ignore_case = 1
]])

vim.api.nvim_exec([[
let $GIT_EDITOR = "nvr --servername /tmp/nvim-server-$(tmux display-message -p '#I.#P').pipe -cc split --remote +'set bufhidden=wipe'"
]], false)

-- Remember last cursor position
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
            not (ft:match('commit') and ft:match('rebase'))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

function go_org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"

        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
  vim.lsp.buf.format({ async = false })
end

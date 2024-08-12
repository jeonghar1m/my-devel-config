
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      { 'lvimuser/lsp-inlayhints.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
    },
    config = function()
      local ih = require('lsp-inlayhints')
      ih.setup()
      local lsp = require('lsp-zero').preset({})

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
      end)

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = { 'gopls' },
        handlers = {
          lsp.default_setup,
        },
      })

      require('lspconfig').lua_ls.setup({
        on_attach = function(client, bufnr)
          ih.on_attach(client, bufnr)
        end,
        settings = {
          Lua = {
            hint = {
              enable = true,
            },
          },
          gopls = {
            hint = {
              enable = true,
            }
          }
        },
      })
      lsp.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })
      lsp.setup()

      -- You need to setup `cmp` after lsp-zero
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()

      cmp.setup({
        formatting = {
          -- changing the order of fields so the icon is the first
          fields = { 'menu', 'abbr', 'kind' },

          -- here is where the change happens
          format = function(entry, item)
            local menu_icon = {
              nvim_lsp = 'λ',
              luasnip = '⋗',
              buffer = 'Ω',
              path = 'P',
              nvim_lua = 'Π',
            }
            item.menu = menu_icon[entry.source.name]
            return item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          -- `Enter` key to confirm completion
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          -- Ctrl+Space to trigger completion menu
          ['<C-CR>'] = cmp.mapping.complete(),

          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),

          -- Navigate between snippet placeholder
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }
      })
    end,
  },

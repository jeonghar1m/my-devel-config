  {
    'hrsh7th/nvim-cmp',
    dependencies = { "onsails/lspkind.nvim" },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            unpack = unpack or table.unpack
            local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
            local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
            local indent = string.match(line_text, '^%s*')
            local replace = vim.split(args.body, '\n', true)
            local surround = string.match(line_text, '%S.*') or ''
            local surround_end = surround:sub(col)

            replace[1] = surround:sub(0, col - 1) .. replace[1]
            replace[#replace] = replace[#replace] .. (#surround_end > 1 and ' ' or '') .. surround_end
            if indent ~= '' then
              for i, line in ipairs(replace) do
                replace[i] = indent .. line
              end
            end

            vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<Tab>"] = function(fallback)
            if not cmp.select_next_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,
          ["<S-Tab>"] = function(fallback)
            if not cmp.select_prev_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,
          ['<C-I>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Esc>"] = cmp.mapping.close(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
        },
        sources = {
          { name = "nvim_lsp" },                     -- For nvim-lsp
          { name = "ultisnips" },                    -- For ultisnips user.
          { name = "path" },                         -- for path completion
          { name = "buffer",   keyword_length = 2 }, -- for buffer word completion
          { name = "emoji",    insert = true },      -- emoji completion
        },
        completion = {
          keyword_length = 1,
          completeopt = "menu,noselect",
          autocomplete = false,
        },
        view = {
          entries = "custom",
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
            menu = {
              nvim_lsp = "[LSP]",
              ultisnips = "[US]",
              --nvim_lua = "[Lua]",
              path = "[Path]",
              buffer = "[Buffer]",
              emoji = "[Emoji]",
              omni = "[Omni]",
            },
          },
        },
      })

      cmp.setup.filetype("tex", {
        sources = {
          { name = "omni" },
          { name = "ultisnips" },                    -- For ultisnips user.
          { name = "buffer",   keyword_length = 2 }, -- for buffer word completion
          { name = "path" },                         -- for path completion
        },
      })
    end,
  },

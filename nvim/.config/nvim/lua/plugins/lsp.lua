-- ~/.config/nvim/lua/plugins/lsp.lua
-- Neovim 0.10/0.11+ style LSP using core API (vim.lsp.config + vim.lsp.start)
-- JS/TS, Python, C/C++, Java. No require('lspconfig') calls.

return {
  -- 1) Installer
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Optional helper to auto-install the tools we want
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "typescript-language-server",
          "pyright",
          "clangd",
          "jdtls",
          "html-lsp",
          "css-lsp",
          "json-lsp",
          "json-lsp",
          "emmet-language-server",
          "marksman",
        },
        run_on_start = true,
      })
    end,
  },

  -- 2) Core LSP wiring with Neovim APIs
  {
    -- Use a tiny plugin stub so Lazy loads this config block
    -- (you could also fold this into any existing plugin spec)
    "neovim/nvim-lspconfig", -- only for timing; we won't call require('lspconfig')
    config = function()
      --------------------------------------------------------------------------
      -- Shared capabilities & on_attach
      --------------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- If you use nvim-cmp, uncomment:
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Keymaps when any LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
        end,
      })

      -- Simple root finder using marker files
      local function root_dir(markers)
        local bufpath = vim.api.nvim_buf_get_name(0)
        local start = bufpath ~= "" and vim.fs.dirname(bufpath) or vim.loop.cwd()
        local found = vim.fs.find(markers, { upward = true, path = start })[1]
        return found and vim.fs.dirname(found) or start
      end

      --------------------------------------------------------------------------
      -- 3) Define server configs with vim.lsp.config
      --------------------------------------------------------------------------
      -- HTML
      vim.lsp.config["html"] = {
        name = "html",
        cmd = { "vscode-html-language-server", "--stdio" },
        root_dir = function() return root_dir({ "package.json", ".git", ".editorconfig" }) end,
        filetypes = { "html" },
        single_file_support = true,
        capabilities = capabilities,
      }

      -- CSS
      vim.lsp.config["cssls"] = {
        name = "cssls",
        cmd = { "vscode-css-language-server", "--stdio" },
        root_dir = function() return root_dir({ "package.json", ".git", ".editorconfig" }) end,
        filetypes = { "css", "scss", "less" },
        single_file_support = true,
        capabilities = capabilities,
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      }

      -- Emmet (nice for HTML/JSX/TSX/CSS)
      vim.lsp.config["emmet_ls"] = {
        name = "emmet_ls",
        cmd = { "emmet-language-server", "--stdio" },
        root_dir = function() return root_dir({ "package.json", ".git" }) end,
        filetypes = {
          "html", "css", "scss", "less",
          "javascriptreact", "typescriptreact",
          "vue", "svelte",
        },
        single_file_support = true,
        capabilities = capabilities,
        init_options = { jsx = { options = {} } },
      }

      -- Markdown
      vim.lsp.config["marksman"] = {
        name = "marksman",
        cmd = { "marksman", "server" },
        root_dir = function() return root_dir({ ".marksman.toml", ".git" }) end,
        filetypes = { "markdown" },
        single_file_support = true,
        capabilities = capabilities,
      }

      -- Lua (lua-language-server)
      vim.lsp.config["lua_ls"] = {
        name = "lua_ls",
        cmd = { "lua-language-server" },
        root_dir = function()
          return root_dir({ ".git", ".luarc.json", ".luarc.jsonc", ".stylua.toml", "lua" })
        end,
        filetypes = { "lua" },
        single_file_support = true,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              },
            },
            format = {
              enable = true,
            },
          },
        },
        capabilities = capabilities,
      }


      -- JS/TS (typescript-language-server)
      vim.lsp.config["tsserver"] = {
        name = "tsserver",
        cmd = { "typescript-language-server", "--stdio" },
        root_dir = function() return root_dir({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }) end,
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        single_file_support = true,
        capabilities = capabilities,
      }

      -- Python (pyright)
      vim.lsp.config["pyright"] = {
        name = "pyright",
        cmd = { "pyright-langserver", "--stdio" },
        root_dir = function() return root_dir({ "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" }) end,
        filetypes = { "python" },
        capabilities = capabilities,
      }

      -- C/C++ (clangd)
      vim.lsp.config["clangd"] = {
        name = "clangd",
        cmd = { "clangd" },
        root_dir = function() return root_dir({ "compile_commands.json", "compile_flags.txt", ".git" }) end,
        filetypes = { "c", "cpp", "objc", "objcpp" },
        capabilities = capabilities,
      }

      -- Java (jdtls) - minimal, per-project workspace suggested
      vim.lsp.config["jdtls"] = {
        name = "jdtls",
        cmd = { "jdtls" },
        root_dir = function() return root_dir({ "pom.xml", "gradle.properties", "mvnw", "gradlew", ".git" }) end,
        filetypes = { "java" },
        capabilities = capabilities,
      }

      --------------------------------------------------------------------------
      -- 4) Autostart per filetype (no lspconfig.setup calls)
      --------------------------------------------------------------------------
      local function ensure_started(server_name, opts)
        -- If a client for this root is already running, do nothing.
        local root = opts.root_dir and opts.root_dir() or vim.loop.cwd()
        -- for _, client in pairs(vim.lsp.get_active_clients({ name = server_name })) do
        --   if client.config.root_dir == root then
        --     return
        --   end
        -- end
        local function norm(p) return p and vim.fs.normalize(p) or p end
        for _, client in pairs(vim.lsp.get_clients({ name = server_name })) do
          if norm(client.config.root_dir) == norm(root) then
            return
          end
        end
        vim.lsp.start(opts)
      end

      -- HTML
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html" },
        callback = function()
          ensure_started("html", vim.lsp.config["html"])
        end,
      })

      -- CSS / SCSS / LESS
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "css", "scss", "less" },
        callback = function()
          ensure_started("cssls", vim.lsp.config["cssls"])
        end,
      })

      -- Emmet (attach on common front-end types)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "html", "css", "scss", "less",
          "javascriptreact", "typescriptreact",
          "vue", "svelte",
        },
        callback = function()
          ensure_started("emmet_ls", vim.lsp.config["emmet_ls"])
        end,
      })

      -- Markdown
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function()
          ensure_started("marksman", vim.lsp.config["marksman"])
        end,
      })


      -- Lua
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua" },
        callback = function()
          ensure_started("lua_ls", vim.lsp.config["lua_ls"])
        end,
      })


      -- JS/TS
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        callback = function()
          ensure_started("tsserver", vim.lsp.config["tsserver"])
        end,
      })

      -- Python
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python" },
        callback = function()
          ensure_started("pyright", vim.lsp.config["pyright"])
        end,
      })

      -- C/C++
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          ensure_started("clangd", vim.lsp.config["clangd"])
        end,
      })

      -- Java
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = function()
          -- For jdtls, many users prefer a per-workspace launcher. This is the basic start.
          ensure_started("jdtls", vim.lsp.config["jdtls"])
        end,
      })
    end,
  },
}

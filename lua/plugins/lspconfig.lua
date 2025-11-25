return { -- Main LSP Configuration
        "neovim/nvim-lspconfig",
        dependencies = {
                -- Automatically install LSPs and related tools to stdpath for Neovim
                -- Mason must be loaded before its dependents so we need to set it up here.
                -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
                { "mason-org/mason.nvim", opts = {} },
                "mason-org/mason-lspconfig.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",

                -- Useful status updates for LSP.
                { "j-hui/fidget.nvim", opts = {} },

                -- Allows extra capabilities provided by blink.cmp
        },
        config = function()
                -- local capabilities = require("blink.lsp").default_capabilities()

                local util = require("lspconfig.util")

                local root_files = {
                        ".luarc.json",
                        ".luarc.jsonc",
                        ".luacheckrc",
                        ".stylua.toml",
                        ".git",
                        "stylua.toml",
                        "selene.toml",
                        "selene.yml",
                }

                local servers = {
                        lua_ls = {
                                root_dir = function(fname)
                                        local bufname = vim.api.nvim_buf_get_name(0)
                                        local is_luapad = bufname:match("Luapad") or bufname:match("luapad.nvim")

                                        if is_luapad then
                                                -- Use buffer's directory as root to avoid scanning project
                                                return nil
                                        end

                                        return util.find_git_ancestor(fname) or util.path.dirname(fname)
                                end,
                                on_attach = function(client, bufnr)
                                        local bufname = vim.api.nvim_buf_get_name(bufnr)
                                        if bufname:match("Luapad") or bufname:match("luapad.nvim") then
                                                vim.schedule(function()
                                                        client.stop()
                                                        vim.notify(
                                                                "Detached lua_ls from Luapad buffer",
                                                                vim.log.levels.INFO
                                                        )
                                                end)
                                                return
                                        end
                                        -- Normal attach logic here (if needed)
                                end,
                                single_file_support = true,
                                cmd = { "lua-language-server" },

                                settings = {
                                        lua = {
                                                runtime = {
                                                        version = "LuaJit",
                                                },
                                                diagnostics = {
                                                        globals = { "vim" },
                                                },
                                        },
                                },
                        },
                        -- Add more servers here if needed
                        -- tsserver = {},
                        -- jsonls = {},
                }

                -- for server, config in pairs(servers) do
                -- 	vim.lsp.config(server, config)
                -- 	vim.lsp.enable(server)
                -- end
                require("mason-lspconfig").setup({
                        ensure_installed = { "lua_ls" },
                })
                require("mason-tool-installer").setup({
                        ensure_installed = {
                                "stylua", -- this installs the CLI formatter
                        },
                })
        end,
}

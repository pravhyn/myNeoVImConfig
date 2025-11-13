return {
        {
                "obsidian-nvim/obsidian.nvim",
                version = "*",
                ---@module 'obsidian'
                ---@type obsidian.config
                opts = {
                        ui = {
                                enable = true,
                        },
                        workspaces = {
                                {
                                        name = "development",
                                        path = "~/Projects/obsidianVaults/Wisdom",
                                },
                        },
                },
        },
        -- {
        --
        --         "MeanderingProgrammer/render-markdown.nvim",
        --         dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
        --         -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
        --         -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        --         ---@module 'render-markdown'
        --         ---@type render.md.UserConfig
        --         opts = {},
        -- },
}

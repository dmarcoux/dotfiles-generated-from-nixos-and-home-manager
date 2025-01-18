-- Nixvim's internal module table
-- Can be used to share code throughout init.lua
local _M = {}

-- Set up globals {{{
do
    local nixvim_globals = { rooter_patterns = { ".git" }, wstrip_auto = 1 }

    for k, v in pairs(nixvim_globals) do
        vim.g[k] = v
    end
end
-- }}}

-- Set up options {{{
do
    local nixvim_options = { clipboard = "unnamedplus", completeopt = { "menu", "menuone", "noselect" } }

    for k, v in pairs(nixvim_options) do
        vim.opt[k] = v
    end
end
-- }}}

local cmp = require("cmp")
cmp.setup({
    mapping = {
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-l>"] = cmp.mapping.confirm({ select = false }),
        ["<C-y>"] = cmp.config.disable,
    },
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "buffer" },
    },
})

require("which-key").setup({ preset = "modern" })

vim.opt.runtimepath:prepend(vim.fs.joinpath(vim.fn.stdpath("data"), "site"))
require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
})

require("mini.base16").setup({
    palette = {
        base00 = "#ffffff",
        base01 = "#ededed",
        base02 = "#dbdbdb",
        base03 = "#848484",
        base04 = "#636363",
        base05 = "#555555",
        base06 = "#555555",
        base07 = "#555555",
        base08 = "#af4947",
        base09 = "#a0570d",
        base0A = "#876500",
        base0B = "#557301",
        base0C = "#087767",
        base0D = "#186daa",
        base0E = "#7b4ecb",
        base0F = "#a93e93",
    },
})

require("lualine").setup({
    inactive_winbar = { lualine_c = { { "filename", file_status = true, path = 1 } } },
    options = { globalstatus = true },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", file_status = true, path = 1 }, "diff" },
        lualine_x = {
            "diagnostics",
            {
                function()
                    local msg = ""
                    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                color = { fg = "#ffffff" },
                icon = " ",
            },
            "encoding",
            "fileformat",
            "filetype",
        },
    },
    winbar = { lualine_c = { { "filename", file_status = true, path = 1 } } },
})

-- LSP {{{
do
    local __lspServers = {
        { name = "pyright" },
        { name = "gopls" },
        {
            extraOptions = { cmd = { "elixir-ls" }, settings = { elixirLS = { dialyzerEnabled = false } } },
            name = "elixirls",
        },
    }
    -- Adding lspOnAttach function to nixvim module lua table so other plugins can hook into it.
    _M.lspOnAttach = function(client, bufnr) end
    local __lspCapabilities = function()
        capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        return capabilities
    end

    local __setup = {
        on_attach = _M.lspOnAttach,
        capabilities = __lspCapabilities(),
    }

    for i, server in ipairs(__lspServers) do
        if type(server) == "string" then
            require("lspconfig")[server].setup(__setup)
        else
            local options = server.extraOptions

            if options == nil then
                options = __setup
            else
                options = vim.tbl_extend("keep", options, __setup)
            end

            require("lspconfig")[server.name].setup(options)
        end
    end
end
-- }}}

require("luasnip").config.setup({})

-- Set up keybinds {{{
do
    local __nixvim_binds = {
        { action = ":Files<CR>", key = "<C-p>", mode = { "n", "v" } },
        { action = ":Buffers<CR>", key = "<C-n>", mode = { "n", "v" } },
    }
    for i, map in ipairs(__nixvim_binds) do
        vim.keymap.set(map.mode, map.key, map.action, map.options)
    end
end
-- }}}

--- TODO: See what https://github.com/nvim-lua/kickstart.nvim does, maybe I can incorporate a few things...

-------------------- Mappings
---- Mappings with vim.keymap.set are non-recursive by default
-- Mouse can be used in all modes
vim.opt.mouse = "a"

-- Set leader key to define extra key combinations with this. For example, to save the current file, define: map <leader>w
-- It's recommended to set the leader key before plugins are loaded, otherwise the default (thus wrong) leader key will be used
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Allow Backspace, Space, left arrow, right arrow, h and l keys to move to the previous/next line when the cursor is on the first/last character in the line
vim.opt.whichwrap = "b,s,<,>,h,l"

---------- Insert Mode
-- Non-recursive mapping for Shift+Tab to unindent
vim.keymap.set("i", "<S-Tab>", "<C-D>")

---------- Normal Mode
-- Non-recursive mappings for Ctrl + J and Ctrl + K to move the current line(s) up / down
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")

---------- Visual and Select Modes
-- Non-recursive mappings for Ctrl + J and Ctrl + K to move selected line(s) up / down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

---------- Normal, Visual and Operator Pending Modes
-- Non-recursive mappings for n to always search forward and N to always search backward (for / and ?)
--https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set({ "n", "v", "o" }, "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set({ "n", "v", "o" }, "N", "'nN'[v:searchforward]", { expr = true })

-- Non-recursive mappings to move around long wrapped lines
vim.keymap.set({ "n", "v", "o" }, "j", "gj")
vim.keymap.set({ "n", "v", "o" }, "k", "gk")

-- Non-recursive mapping for leader + Enter to disable text highlighting
vim.keymap.set({ "n", "v", "o" }, "<leader><CR>", ":noh<CR>", { silent = true })

-------------------- Command Mode
-- Non-recursive abbreviations for common typos when saving/quiting
vim.cmd.cnoreabbrev("W!", "w!")
vim.cmd.cnoreabbrev("W", "w")
vim.cmd.cnoreabbrev("Q!", "q!")
vim.cmd.cnoreabbrev("Q", "q")
vim.cmd.cnoreabbrev("Wq", "wq")
vim.cmd.cnoreabbrev("wQ", "wq")
vim.cmd.cnoreabbrev("WQ", "wq")

-------------------- UI Settings
-- Enable true colors
vim.opt.termguicolors = true

-- Set the title of the terminal to the file's complete path (up to maximum 70 characters)
vim.opt.title = true
vim.opt.titlestring = "neovim: %F" -- TODO: This isn't really useful to have the file's complete path, since it's quite long most of the time. The file name isn't visible then...
vim.opt.titlelen = 70

-- Format the status line
vim.opt.statusline = "FILE: %F%m%r%h %w  CWD: %r%{getcwd()}%h  Line: %l  Column: %c"

-- Highlight the column and line where the cursor is currently
vim.opt.cursorcolumn = true
vim.opt.cursorline = true

-- Always display the sign column (signs appear when lines are added/modified/deleted, some plugins like also LSP use signs)
-- Without this setting, it's pretty annoying to always have the text shift to the right whenever the first sign appears
vim.opt.signcolumn = "yes"

-- Show the line number where the cursor is located
vim.opt.number = true

-- Height (in number of lines) of the command bar at the bottom
vim.opt.cmdheight = 2

-- Show matching brackets when text indicator is over them
vim.opt.showmatch = true

-- How many tenths of a second to blink when matching brackets
vim.opt.matchtime = 2

-- Minimal number of screen lines to keep above and below the cursor when moving vertically (if possible...)
vim.opt.scrolloff = 10

-- Display tabs as │· (longer pipe) and trailing spaces as ·
vim.opt.list = true
vim.opt.listchars = "tab:│·,trail:·"

-- Disable word wrapping
vim.opt.wrap = false

-- Visually line break on lines of 500 characters (without actually inserting line break)
vim.opt.linebreak = true
vim.opt.textwidth = 500

-------------------- Search Settings
-- Use case-insensitive search by default
vim.opt.ignorecase = true
-- Use case-sensitive search if any of the search characters are uppercase
vim.opt.smartcase = true

---------------------- History, Backup & System
-- Use Unix as the standard file format
vim.opt.fileformats = "unix,dos,mac"

-- Do not create backup files, my files are tracked in Git anyway
vim.opt.backup = false
vim.opt.writebackup = false

-- Disable swap file
vim.opt.swapfile = false

-------------------- Wildmenu
-- Ignore case
vim.opt.wildignorecase = true

-- Ignore these files
vim.opt.wildignore = "*~,.git*,.hg*,.svn*"

-- List all matches without completing
vim.opt.wildmode = "longest,list,full"

-- Display the fzf window at the bottom of the screen with 40% of the available height
vim.g.fzf_layout = { down = "40%" }

-- Set up autogroups {{
do
    local __nixvim_autogroups = { nixvim_binds_LspAttach = { clear = true } }

    for group_name, options in pairs(__nixvim_autogroups) do
        vim.api.nvim_create_augroup(group_name, options)
    end
end
-- }}
-- Set up autocommands {{
do
    local __nixvim_autocommands = {
        {
            callback = function()
                do
                    local __nixvim_binds = {
                        {
                            action = vim.diagnostic.goto_next,
                            key = "<leader>ej",
                            mode = "n",
                            options = { desc = "Next Diagnostic", silent = false },
                        },
                        {
                            action = vim.diagnostic.goto_prev,
                            key = "<leader>ek",
                            mode = "n",
                            options = { desc = "Previous Diagnostic", silent = false },
                        },
                        {
                            action = vim.diagnostic.open_float,
                            key = "<leader>el",
                            mode = "n",
                            options = { desc = "Show Diagnostic", silent = false },
                        },
                        {
                            action = vim.lsp.buf.definition,
                            key = "<leader>d",
                            mode = "n",
                            options = { desc = "Jump to the definition of the symbol under the cursor", silent = false },
                        },
                        {
                            action = vim.lsp.buf.implementation,
                            key = "<leader>i",
                            mode = "n",
                            options = {
                                desc = "List all implementations for the symbol under the cursor",
                                silent = false,
                            },
                        },
                        {
                            action = vim.lsp.buf.hover,
                            key = "<leader>k",
                            mode = "n",
                            options = { desc = "Display information about the symbol under the cursor", silent = false },
                        },
                        {
                            action = vim.lsp.buf.references,
                            key = "<leader>r",
                            mode = "n",
                            options = { desc = "List all references to the symbol under the cursor", silent = false },
                        },
                        {
                            action = vim.lsp.buf.type_definition,
                            key = "<leader>t",
                            mode = "n",
                            options = {
                                desc = "Jump to the type definition of the symbol under the cursor",
                                silent = false,
                            },
                        },
                    }
                    for i, map in ipairs(__nixvim_binds) do
                        vim.keymap.set(map.mode, map.key, map.action, map.options)
                    end
                end
            end,
            desc = "Load keymaps for LspAttach",
            event = "LspAttach",
            group = "nixvim_binds_LspAttach",
        },
        {
            callback = function()
                -- Force Markdown type
                vim.opt.filetype = "markdown"
                -- Wrap lines at 80 characters
                vim.opt_local.textwidth = 80
            end,
            desc = "Set options in Markdown files",
            event = { "BufNewFile", "BufReadPost" },
            pattern = { "*.md", "gitcommit" },
        },
        {
            callback = function()
                vim.cmd("wincmd J") -- See `:help :wincmd` and `:help ^WJ`
            end,
            desc = "When the quickfix window opens, move it the very bottom",
            event = "FileType",
            pattern = "qf",
        },
        {
            callback = function()
                -- See `:help vim.highlight.on_yank()`
                vim.highlight.on_yank({ timeout = 1000 }) -- highlight for 1 second
            end,
            desc = "Highlight when yanking (copying) text",
            event = "TextYankPost",
        },
        {
            callback = function()
                vim.cmd("call tagbar#autoopen(0)") -- See `:help :tagbar-autoopen`
            end,
            desc = "Open tagbar automatically for supported filetypes whenever opening a file",
            event = "FileType",
            nested = true,
            pattern = "*",
        },
    }

    for _, autocmd in ipairs(__nixvim_autocommands) do
        vim.api.nvim_create_autocmd(autocmd.event, {
            group = autocmd.group,
            pattern = autocmd.pattern,
            buffer = autocmd.buffer,
            desc = autocmd.desc,
            callback = autocmd.callback,
            command = autocmd.command,
            once = autocmd.once,
            nested = autocmd.nested,
        })
    end
end
-- }}

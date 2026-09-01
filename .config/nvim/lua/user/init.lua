-- General quick test: `:lua dap_test()`
function dap_test()
    print("It works!")
end

--[[ Plugins
-- Uses the nvim 0.12+ vim.pack feature.
--
-- I've tried using vim-plug since it's already loaded in my base vimrc,
-- but calling it a second time causes it to remove plugins added the first time.
--]]
if vim.pack then
    vim.pack.add{
        'https://github.com/neovim/nvim-lspconfig',
    }
end

--[[ LSP (Language Server Protocol)
-- Guarded for easy use with older versions of neovim.
-- Enable specific servers here.
-- Configure in $XDG_CONFIG_HOME/nvim/after/lsp/language_server_name.lua
-- so my settings supersede those set by nvim-lspconfig.
--]]
if vim.lsp then
    vim.lsp.enable {
        -- Server   -- Language     Install command
        ----------- --------------- ---------------
        'ruff',     -- Python       pip install ruff
    }

    --[[
    Default keymaps (from
    <https://vonheikemen.github.io/learn-nvim/feature/lsp-setup.html>):

    Vim built-ins enhanced for LSP:
        <C-]>       Go to definition
        gq          Format selected text
        K           Help for symbol undedr cursor
        <C-X><C-O>  Trigger code completion (Insert mode)

    Neovim additional mappings:
        grn         Rename all references of the symbol under the cursor
        gra         List code actions available in the line under the cursor
        grr         Lists all the references of the symbol under the cursor
        gri         Lists all the implementations for the symbol under the cursor
        grt         Jump to the definition of the type symbol under the cursor
        gO          Lists all symbols in the current buffer
        <C-S>       In insert mode, display function signature under the cursor
        [d          Jump to previous diagnostic in the current buffer
        ]d          Jump to next diagnostic in the current buffer
        <C-W>d      Show error/warning message in the line under the cursor
    --]]
    -- I use <C-S> for other things, so remap this function
    vim.keymap.set({'i','s'}, '<C-F>', function()
        vim.lsp.buf.signature_help()
    end, { desc = 'LSP signature help' })

end -- vim.lsp

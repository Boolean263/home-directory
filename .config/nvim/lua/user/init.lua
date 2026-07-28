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

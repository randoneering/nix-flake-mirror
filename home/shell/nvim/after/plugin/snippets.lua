local ok_luasnip, luasnip = pcall(require, "luasnip")
if ok_luasnip then
  require("snippets").setup()
end

local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
  pcall(telescope.load_extension, "luasnip")

  vim.keymap.set("n", "<leader>fs", function()
    telescope.extensions.luasnip.luasnip()
  end, { desc = "Browse snippets" })

  vim.api.nvim_create_user_command("TelescopeLuaSnip", function()
    telescope.extensions.luasnip.luasnip()
  end, { desc = "Browse LuaSnip snippets" })
end

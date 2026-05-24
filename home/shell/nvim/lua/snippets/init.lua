local ls = require("luasnip")

local M = {}

function M.setup()
  local snippet_sets = {
    ansible = require("snippets.ansible"),
    go = require("snippets.go"),
    hcl = require("snippets.hcl"),
    nix = require("snippets.nix"),
    python = require("snippets.python"),
    ruby = require("snippets.ruby"),
    sql = require("snippets.sql"),
    yaml = require("snippets.yaml"),
  }

  ls.filetype_extend("yaml", { "ansible" })

  for filetype, snippets in pairs(snippet_sets) do
    ls.add_snippets(filetype, snippets)
  end
end

return M

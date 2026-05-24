local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "doc", name = "document", dscr = "YAML document skeleton" },
    fmt(
      [[---
{}: {}
{}]],
      { i(1, "key"), i(2, "value"), i(0) }
    )
  ),
  s(
    { trig = "list", name = "list item", dscr = "YAML list skeleton" },
    fmt(
      [[{}:
  - {}
  - {}]],
      { i(1, "items"), i(2, "first"), i(0, "second") }
    )
  ),
  s(
    { trig = "job", name = "CI job", dscr = "YAML CI job skeleton" },
    fmt(
      [[{}:
  runs-on: {}
  steps:
    - uses: actions/checkout@v4
    - name: {}
      run: {}]],
      { i(1, "job_name"), i(2, "ubuntu-latest"), i(3, "Run command"), i(0, "make test") }
    )
  ),
}

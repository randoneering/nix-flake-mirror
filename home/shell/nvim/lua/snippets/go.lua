local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "iferr", name = "if err", dscr = "Go error check" },
    fmt(
      [[if err != nil {{
  {}
}}]],
      { i(0, "return err") }
    )
  ),
  s(
    { trig = "func", name = "function", dscr = "Go function" },
    fmt(
      [[func {}({}) {} {{
  {}
}}]],
      { i(1, "name"), i(2, "args"), i(3, "error"), i(0) }
    )
  ),
  s(
    { trig = "gotest", name = "table test", dscr = "Go table-driven test" },
    fmt(
      [[func Test{}(t *testing.T) {{
  tests := []struct {{
    name {}
  }}{{
    {{ name: "{}" }},
  }}

  for _, tt := range tests {{
    t.Run(tt.name, func(t *testing.T) {{
      {}
    }})
  }}
}}]],
      { i(1, "Name"), i(2, "string"), i(3, "case"), i(0) }
    )
  ),
}

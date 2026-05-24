local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "resource", name = "resource block", dscr = "Terraform resource block" },
    fmt(
      [[resource "{}" "{}" {{
  {}
}}]],
      { i(1, "provider_resource"), i(2, "name"), i(0) }
    )
  ),
  s(
    { trig = "variable", name = "variable block", dscr = "Terraform variable block" },
    fmt(
      [[variable "{}" {{
  type = {}
  description = "{}"
  default = {}
}}]],
      { i(1, "name"), i(2, "string"), i(3, "Description"), i(0, "null") }
    )
  ),
  s(
    { trig = "module", name = "module block", dscr = "Terraform module block" },
    fmt(
      [[module "{}" {{
  source = "{}"
  {}
}}]],
      { i(1, "name"), i(2, "./module"), i(0) }
    )
  ),
}

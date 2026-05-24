local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "class", name = "class", dscr = "Ruby class" },
    fmt(
      [[class {}
  def initialize({})
    {}
  end
end]],
      { i(1, "ClassName"), i(2, "args"), i(0) }
    )
  ),
  s(
    { trig = "module", name = "module", dscr = "Ruby module" },
    fmt(
      [[module {}
  {}
end]],
      { i(1, "ModuleName"), i(0) }
    )
  ),
  s(
    { trig = "rspec", name = "rspec example", dscr = "RSpec describe block" },
    fmt(
      [[RSpec.describe {} do
  it "{}" do
    {}
  end
end]],
      { i(1, "ClassName"), i(2, "does something"), i(0) }
    )
  ),
}

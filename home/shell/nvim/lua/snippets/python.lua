local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "main", name = "main guard", dscr = "Python main guard" },
    fmt(
      [[if __name__ == "__main__":
    {}]],
      { i(0, "main()") }
    )
  ),
  s(
    { trig = "dataclass", name = "dataclass", dscr = "Python dataclass" },
    fmt(
      [[@dataclass
class {}:
    {}: {}
    {}]],
      { i(1, "ClassName"), i(2, "field_name"), i(3, "str"), i(0) }
    )
  ),
  s(
    { trig = "pytest", name = "pytest test", dscr = "pytest test function" },
    fmt(
      [[def test_{}():
    {}

    assert {}]],
      { i(1, "behavior"), i(2, "result = function()"), i(0, "result") }
    )
  ),
}

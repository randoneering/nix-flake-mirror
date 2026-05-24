local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "cte", name = "CTE query", dscr = "WITH query skeleton" },
    fmt(
      [[with {} as (
  select
    {}
  from {}
)
select
  {}
from {};]],
      { i(1, "source_data"), i(2, "*"), i(3, "table_name"), i(4, "*"), i(0, "source_data") }
    )
  ),
  s(
    { trig = "join", name = "join query", dscr = "SELECT with JOIN" },
    fmt(
      [[select
  {}
from {} {}
join {} {} on {}
where {};]],
      { i(1, "a.id"), i(2, "table_a"), i(3, "a"), i(4, "table_b"), i(5, "b"), i(6, "a.id = b.a_id"), i(0, "true") }
    )
  ),
  s(
    { trig = "insret", name = "insert returning", dscr = "INSERT ... RETURNING" },
    fmt(
      [[insert into {} (
  {}
) values (
  {}
)
returning {};]],
      { i(1, "table_name"), i(2, "column_name"), i(3, "value"), i(0, "*") }
    )
  ),
}

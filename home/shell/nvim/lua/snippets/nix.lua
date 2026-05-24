local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "mkif", name = "mkIf block", dscr = "lib.mkIf conditional block" },
    fmt(
      [[lib.mkIf {} {{
  {}
}}]],
      { i(1, "condition"), i(0) }
    )
  ),
  s(
    { trig = "flakeinput", name = "flake input", dscr = "flake.nix input declaration" },
    fmt(
      [[{} = {{
  url = "github:{}";
  inputs.nixpkgs.follows = "nixpkgs";
}};]],
      { i(1, "input-name"), i(0, "owner/repo") }
    )
  ),
  s(
    { trig = "module", name = "module skeleton", dscr = "basic Nix module" },
    fmt(
      [[{{ config, lib, pkgs, ... }}:
{{
  {}
}}]],
      { i(0) }
    )
  ),
}

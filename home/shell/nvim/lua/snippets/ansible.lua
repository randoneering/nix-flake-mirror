local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

return {
  s(
    { trig = "play", name = "playbook", dscr = "Ansible playbook skeleton" },
    fmt(
      [[- name: {}
  hosts: {}
  become: {}
  tasks:
    - name: {}
      ansible.builtin.{}:
        {}]],
      { i(1, "Configure hosts"), i(2, "all"), i(3, "true"), i(4, "Example task"), i(5, "debug"), i(0, 'msg: "hello"') }
    )
  ),
  s(
    { trig = "task", name = "task", dscr = "Ansible task" },
    fmt(
      [[- name: {}
  ansible.builtin.{}:
    {}]],
      { i(1, "Task name"), i(2, "command"), i(0, "cmd: whoami") }
    )
  ),
  s(
    { trig = "handler", name = "handler", dscr = "Ansible handler" },
    fmt(
      [[handlers:
  - name: {}
    ansible.builtin.service:
      name: {}
      state: restarted]],
      { i(1, "restart service"), i(0, "nginx") }
    )
  ),
}

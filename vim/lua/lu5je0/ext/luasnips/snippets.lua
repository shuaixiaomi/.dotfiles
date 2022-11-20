---@diagnostic disable: unused-local

local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local extras = require "luasnip.extras"
local fmt = extras.fmt
local m = extras.m
local l = extras.l
local postfix = require "luasnip.extras.postfix".postfix

ls.add_snippets("markdown", {
  postfix({ trig = "%dtable", match_pattern = "%dtable$" }, {
    f(function(_, parent)
      return "hhhhh"
    end, {})
  })
})

--
-- ls.add_snippets("all", {
--   postfix({ trig = ".argg", match_pattern = "[%w%.%_%-%(%)]+$" }, {
--     i(1, ""),
--     t("("),
--     f(function(_, parent)
--       return parent.snippet.env.POSTFIX_MATCH
--     end, {}),
--     t(")"),
--   })
-- })
--
ls.add_snippets("lua", {
  postfix({ trig = ".local", match_pattern = "^ +(.+)$" }, {
    t("local "), i(1, ""), t(" = "),
    f(function(_, parent)
      return parent.snippet.env.POSTFIX_MATCH
    end, {}),
  })
})
--
--
-- -- for i = 1, 10, 1 do
-- --
-- -- end
-- ls.add_snippets("all", {
--   postfix({ trig = ".fori", match_pattern = " %d+$" }, {
--     f(function(_, parent)
--       return ("for i = 1, %d, 1 do"):format(parent.snippet.env.POSTFIX_MATCH)
--     end, {}), t(""),
--     t("  "), i(""), t(""),
--     t("end"),
--   })
-- })

-- ls.add_snippets("python", {
--   postfix({ trig = ".varr", match_pattern = "^ +(.+)$" }, {
--     i(1, ""), t(" = "),
--     f(function(_, parent)
--       return parent.snippet.env.POSTFIX_MATCH
--     end, {}),
--   })
-- })

-- ls.add_snippets("all", {
--   s("ternary", {
--     -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
--     i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
--   })
-- })


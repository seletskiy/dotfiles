local luasnip = require("luasnip")
local λ = require("lambda")

-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md

-- local r = ls.restore_node
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local m = require("luasnip.extras").m
-- local lambda = require("luasnip.extras").l

local clean = luasnip.cleanup
local for_filetype = luasnip.add_snippets
local extend = luasnip.filetype_extend
local add = luasnip.snippet
local txt = luasnip.text_node
local ins = luasnip.insert_node
local fun = luasnip.function_node
local isn = luasnip.indent_snippet_node
-- local rep = require("luasnip.extras").rep
-- local lambda = require("luasnip.extras").lambda

local fmt = {
	curly = require("luasnip.extras.fmt").fmt,
	angle = require("luasnip.extras.fmt").fmta,
	square = function(tpl, args, ...)
		return require("luasnip.extras.fmt").fmt(tpl, args, { delimiters = "[]", ... })
	end,
}
local fn = {
	-- treesitter bindings
	ts = {},
}

function fn.is_line_start(line_to_cursor, matched_trigger)
	return line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^$")
end

function fn.line_after_cursor()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	return string.sub(vim.api.nvim_get_current_line(), col + 1, -1)
end

function fn.line_before_cursor(line_to_cursor)
	return line_to_cursor
end

function fn.ts.node_type()
	vim.print("X")
	return vim.treesitter.get_node():type()
end

--  = λ(vim.treesitter.get_node):call():at("type"):call()

luasnip.setup({ enable_autosnippets = true })

clean()

for_filetype("all", {
	add({ trig = "\\lambda" }, { txt("λ") }, { show_condition = λ.f }),

	add(
		{ trig = "{" },
		fmt.angle(
			[[
	        {
	            <>
	        }
            ]],
			{ ins(1) }
		),
		{
			show_condition = λ.f,
			condition = λ(fn.line_after_cursor):match("}"):neg(),
		}
	),

	add(
		{ trig = "{" },
		fmt.angle(
			[[
	        {
	            <>

            ]],
			{ ins(1) }
		),
		{
			show_condition = λ.f,
			condition = λ(fn.line_after_cursor):match("}"),
		}
	),
})

for_filetype("typescript", {
	add({ trig = "a", priority = 2000 }, { txt("async ") }, { condition = fn.is_line_start }),
	add(
		{ trig = "f", priority = 2000 },
		fmt.square(
			[[
			function []([]) {
				[]
			}
            ]],
			{ ins(1), ins(2), ins(3) }
		),
		{ condition = λ(fn.line_before_cursor):match("^[a-z ]+$") }
	),

	add({ trig = "e", priority = 2000 }, { txt("export ") }, { condition = fn.is_line_start }),

	add({ trig = "export i", priority = 2000 }, { txt("export interface ") }, { condition = fn.is_line_start }),

	add({ trig = "i", priority = 2000 }, { txt("interface ") }, { condition = fn.is_line_start }),

	add(
		{ trig = "i", priority = 1000 },
		fmt.angle(
			[[
	        if (<cond>) {
	            <>
	        }
            ]],
			{ cond = ins(1), ins(2) }
		)
	),

	add({ trig = ".", wordTrig = false }, fmt.angle(".<>(<>)", { ins(1), ins(2) }), { show_condition = λ.f }),

	add({ trig = "u" }, txt("undefined")),

	add({ trig = "r" }, txt("return ")),
	add({ trig = "return f" }, txt("return false;")),
	add({ trig = "return t" }, txt("return true;")),
	add({ trig = "return u" }, txt("return undefined;")),
	add({ trig = "return n" }, txt("return null;")),

	add({ trig = "f" }, fmt.square("[]([]) => []", { ins(1), ins(2), ins(3) })),

	add({ trig = "a" }, { txt("async ") }, {
		show_condition = λ.f,
		condition = λ(fn.line_after_cursor):match("[(]"),
	}),

	add({ trig = ") => " }, fmt.square(") => {[]}", { ins(1) })),

	add(
		{ trig = "p" },
		fmt.curly("console.log('{}', {})", {
			fun(function()
				return "XXXXX " .. vim.fn.expand("%:t") .. ":" .. vim.api.nvim_buf_get_mark(0, ".")[1]
			end),
			ins(1),
		})
	),

	add({ trig = "/t" }, fmt.curly("// TODO (@seletskiy): ", {})),
	add({ trig = "fi" }, fmt.square("(() => {[]})()", { ins(1) })),
	add({ trig = "js" }, fmt.square("JSON.stringify([])", { ins(1) })),
})

for_filetype("typescript", {
	add({ trig = "$" }, fmt.angle("${<>}", { ins(1) }), {
		show_condition = λ.f,
		condition = λ(function()
			return vim.treesitter.get_node():type()
		end):call():eq("template_string"),
	}),
}, { type = "autosnippets", key = "typescript_auto" })

for_filetype("tsx", {
	add(
		{ trig = "pe" },
		fmt.curly("require('react').useEffect(() => console.log('{}', {}), [{}])", {
			fun(function()
				return "XXXXX " .. vim.fn.expand("%:t") .. ":" .. vim.api.nvim_buf_get_mark(0, ".")[1]
			end),
			ins(1),
			fun(λ._1, 1),
		})
	),

	-- add(
	-- 	{ trig = "us" },
	-- 	fmt.angle("const [<>, set<>] = useState(<>)", {
	-- 		ins(1),
	-- 		snip.node.lambda(snip.node.lambda:gsub("^(.)", λ():upper().chain), 1),
	-- 		ins(2),
	-- 	})
	-- ),

	add({ trig = "ue" }, fmt.angle("useEffect(<>)", { ins(1) })),

	add({ trig = "<" }, fmt.square("<>[]</>", { ins(1) })),
})

extend("typescriptreact", { "typescript", "tsx" })

for_filetype("zig", {
	add(
		{ trig = "p" },
		fmt.angle('std.debug.print("<> {any}\\n", .{<>});', {
			fun(function()
				return "XXXXX " .. vim.fn.expand("%:t") .. ":" .. vim.api.nvim_buf_get_mark(0, ".")[1]
			end),
			ins(1),
		})
	),

	add(
		{ trig = "s" },
		fmt.angle(
			[[
            struct {
                <>
            }
        ]],
			{ ins(1) }
		)
	),

	add(
		{ trig = "w" },
		fmt.angle(
			[[
            switch {
                <>
            }
        ]],
			{ ins(1) }
		)
	),

	add(
		{ trig = "(%s+)", regTrig = true },
		fmt.square("[][] => {[]},", { fun(λ(λ._2):call():at("captures"):at(1)), ins(1), ins(2) }),
		{
			show_condition = λ.f,
			condition = λ(fn.ts.node_type):call():eq("switch_expression"),
		}
	),

	add({ trig = "(", wordTrig = false }, txt("(this: @This()"), {
		condition = λ(fn.ts.node_type):call():eq("parameters"),
	}),

	add({ trig = "^@", regTrig = true }, fmt.angle('const <> = @import("<>");', { ins(1), ins(2) }), {
		condition = λ(fn.ts.node_type):call():eq("source_file"),
	}),

	add({ trig = "^f", regTrig = true }, fmt.angle("fn <>() <> {<>}", { ins(1), ins(2), ins(3) }), {
		condition = λ(fn.ts.node_type):call():eq("source_file"),
	}),
})

for_filetype("", {
	add({ trig = "#" }, fmt.angle("#!/bin/bash", {})),
})

local luasnip = require("luasnip")

-- local add_snippets = ls.add_snippets
-- local snippet = ls.snippet
-- local insert = ls.insert_node
-- local text = ls.text_node

-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local format_c = require("luasnip.extras.fmt").fmt
-- local format_a = require("luasnip.extras.fmt").fmta
-- local m = require("luasnip.extras").m
-- local lambda = require("luasnip.extras").l

local snip = {
	clean = luasnip.cleanup,
	for_filetype = luasnip.add_snippets,
	extend = luasnip.filetype_extend,
	add = luasnip.snippet,
	node = {
		text = luasnip.text_node,
		insert = luasnip.insert_node,
		func = luasnip.function_node,
	},

	format = {
		curly = require("luasnip.extras.fmt").fmt,
		angle = require("luasnip.extras.fmt").fmta,
	},
}

local lib = {
	text = {},
}

function lib.text.is_line_start(line_to_cursor, matched_trigger)
	return line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^$")
end

function lib.return_false()
	return false
end

luasnip.cleanup()

snip.for_filetype("all", {
	snip.add(
		{ trig = "{" },
		snip.format.curly(
			[[
	        {{
	            {}
	        }}
            ]],
			{ snip.node.insert(1) }
		),
		{
			show_condition = lib.return_false,
		}
	),
})

snip.for_filetype("typescript", {
	snip.add({ trig = "i", priority = 2000 }, {
		snip.node.text("interface "),
	}, {
		condition = lib.text.is_line_start,
	}),

	snip.add(
		{ trig = "i", priority = 1000 },
		snip.format.angle(
			[[
	        if (<cond>) {
	            <>
	        }
            ]],
			{ cond = snip.node.insert(1), snip.node.insert(2) }
		)
	),

	snip.add("r", snip.format.curly("return ", {})),

	snip.add("f", snip.format.angle("(<>) =>> <>", { snip.node.insert(1), snip.node.insert(2) })),

	snip.add(
		"p",
		snip.format.curly("console.log('{}', {})", {
			snip.node.func(function()
				return "XXXXX " .. vim.fn.expand("%:t") .. ":" .. vim.api.nvim_buf_get_mark(0, ".")[1]
			end),
			snip.node.insert(1),
		})
	),

	snip.add(
		"pe",
		snip.format.curly("require('react').useEffect(() => console.log('{}', {}), [{}])", {
			snip.node.func(function()
				return "XXXXX " .. vim.fn.expand("%:t") .. ":" .. vim.api.nvim_buf_get_mark(0, ".")[1]
			end),
			snip.node.insert(1),
			snip.node.func(function(args)
				return args[1]
			end, 1),
		})
	),

	snip.add("/t", snip.format.curly("// TODO (@seletskiy): ", {})),
})

snip.extend("typescriptreact", { "typescript" })

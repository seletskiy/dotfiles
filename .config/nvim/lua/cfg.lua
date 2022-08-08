return {
	hi = {
		set = function(group, spec)
			vim.cmd(
				("hi " .. group)
					.. (" gui=" .. (spec.style or "none"))
					.. (" guifg=" .. (spec.fg or "none"))
					.. (" guibg=" .. (spec.bg or "none"))
			)
		end,

		link = function(source, target)
			vim.cmd("hi clear " .. source)
			vim.cmd("hi link " .. source .. " " .. target)
		end,
	},
}

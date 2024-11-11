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
	tbl = {
		merge = function(t1, t2)
			for k, v in pairs(t2) do
				t1[k] = v
			end

			return t1
		end,
	},
}

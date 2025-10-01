-- Function definitions
local get_visual = function(args, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

-- Taken from https://ejmastnak.com/tutorials/vim-latex/luasnip/
local tex_utils = {}
tex_utils.in_mathzone = function() -- math context detection
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex_utils.in_text = function()
	return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function() -- comment detection
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end
tex_utils.in_env = function(name) -- generic environment detection
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- Concrete environments
tex_utils.in_equation = function() -- equation environment detection
	return tex_utils.in_env("equation")
end
tex_utils.in_itemize = function() -- itemize environment detection
	return tex_utils.in_env("itemize")
end
tex_utils.in_tikz = function() -- TikZ picture environment detection
	return tex_utils.in_env("tikzpicture")
end

local first_capture = f(function(_, snip)
	return snip.captures[1]
end)

return {
	s(
		{ trig = "bg", dscr = "Begin an environment", snippetType = "autosnippet" },
		fmta(
			[[
\begin{<>}
	<>
\end{<>}
			]],
			{ i(1), i(2), rep(1) }
		)
	),
	s({ trig = " in", wordTrig = false, snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t(" \\in "),
	}),
	s({ trig = "\\in t", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\int"),
	}),
	s({ trig = "\\in f", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\inf"),
	}),
	s({ trig = "\\in y", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\infty"),
	}),
	s({ trig = "nin", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\not\\in "),
	}),
	s({ trig = " ?^^", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, {
		t("^{"),
		i(1),
		t("}"),
	}),
	s({
		trig = "(%w),%.",
		regTrig = true,
		wordTrig = false,
		snippetType = "autosnippet",
		condition = tex_utils.in_mathzone,
	}, {
		t("vec{"),
		first_capture,
		t("}"),
		i(0),
	}),
	s({
		trig = "(%w)%.,",
		regTrig = true,
		wordTrig = false,
		snippetType = "autosnippet",
		condition = tex_utils.in_mathzone,
	}, {
		t("vec{"),
		first_capture,
		t("}"),
		i(0),
	}), -- TODO: Merge these two somehow
	s(
		{ trig = "fv", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\frac{<>}{<>}<>", {
			d(1, get_visual),
			i(2),
			i(0),
		})
	),
	s(
		{ trig = "ff", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\frac{<>}{<>}<>", {
			i(1),
			i(2),
			i(0),
		})
	),
	s(
		{ trig = "dd", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\dv{<>}{<>}<>", {
			i(1),
			i(2),
			i(0),
		})
	),
	s(
		{ trig = "dD", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\dv*{<>}{<>}<>", {
			i(1),
			i(2),
			i(0),
		})
	),
	s(
		{ trig = "Dd", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\dv[<>]{<>}{<>}<>", {
			i(1),
			i(2),
			i(3),
			i(0),
		})
	),
	s(
		{ trig = "DD", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\dv*[<>]{<>}{<>}<>", {
			i(1),
			i(2),
			i(3),
			i(0),
		})
	),
	s(
		{ trig = "ll", wordTrig = false, condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		t({ "\\\\", "" })
	),
	s(
		{ trig = "vv", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\vec{<>}<>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "ss", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\left\\{ <> \\right\\} <>", {
			i(1),
			i(0),
		})
	),
	s({ trig = " ?__", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, {
		t("_{"),
		i(1),
		t("}"),
	}),
	s({ trig = ";a", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\alpha "),
	}),
	s({ trig = ";b", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\beta "),
	}),
	s({ trig = ";g", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\gamma "),
	}),
	s({ trig = ";o", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\omega "),
	}),
	s({ trig = ";p", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\pi "),
	}),
	s({ trig = ";e", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\epsilon "),
	}),
	s({ trig = "seq", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\subseteq "),
	}),
	s({ trig = "nseq", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\nsubseteq "),
	}),
	s({ trig = "sneq", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\subsetneqq "),
	}),
	s({ trig = "ex", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\exists "),
	}),
	s({ trig = "fr", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\forall "),
	}),
	s({ trig = "br", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\mathbb{R} "),
	}),
	s({ trig = "bc", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\mathbb{C} "),
	}),
	s({ trig = "bn", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\mathbb{N} "),
	}),
	s({ trig = "bz", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\mathbb{Z} "),
	}),
	s({ trig = "bq", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\mathbb{Q} "),
	}),
	s({ trig = "es", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\emptyset "),
	}),
	s({ trig = "sm", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\setminus "),
	}),
	s({ trig = "eq", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\coloneqq "),
	}),
	s({ trig = "iff", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\iff "),
	}),
	s({ trig = "im", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\implies "),
	}),
	s({ trig = "cup", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\cup "),
	}),
	s({ trig = "cap", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\cap "),
	}),
	s({ trig = "and", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\land "),
	}),
	s({ trig = "or", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\lor "),
	}),
	s({ trig = "not", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\neg "),
	}),
	s({ trig = "sin", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\sin "),
	}),
	s({ trig = "cos", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\cos "),
	}),
	s({ trig = "sup", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\sup "),
	}),
	s({ trig = "ge", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\geq "),
	}),
	s({ trig = "le", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\leq "),
	}),
	s({ trig = "nq", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\neq "),
	}),
	s({ trig = "tm", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\times "),
	}),
	s({ trig = "ld", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\ldots "),
	}),
	s({ trig = "to", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\to "),
	}),
	s({ trig = "mt", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\mapsto "),
	}),
	s({
		trig = " sq",
		wordTrig = false,
		snippetType = "autosnippet",
		condition = tex_utils.in_mathzone,
	}, {
		t(" \\quad "),
	}),
	s({ trig = "sd", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\; "),
	}),
	s({ trig = "ds", snippetType = "autosnippet", condition = tex_utils.in_mathzone }, {
		t("\\ds "), -- \displaystyle
	}),
	s(
		{ trig = "cc", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\mathcal{<>}<>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "ss", condition = tex_utils.in_text, snippetType = "autosnippet" },
		fmta("\\section{<>}\n<>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "sS", condition = tex_utils.in_text, snippetType = "autosnippet" },
		fmta("\\subsection{<>}\n<>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "SS", condition = tex_utils.in_text, snippetType = "autosnippet" },
		fmta("\\subsubsection{<>}\n<>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "mk", condition = tex_utils.in_text, snippetType = "autosnippet" },
		fmta("$<>$ <>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "dm", condition = tex_utils.in_text, snippetType = "autosnippet" },
		fmta("\\[\n<>\n\\]", {
			i(1),
		})
	),
	s(
		{ trig = "gt", condition = tex_utils.in_text, snippetType = "autosnippet" },
		fmta("\\begin{gather*}\n<>\n\\end{gather*}", {
			i(1),
		})
	),
	s(
		{ trig = "pp", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\left(<> \\right) <>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "PP", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("(<>) <>", {
			i(1),
			i(0),
		})
	),
	s(
		{ trig = "VV", condition = tex_utils.in_mathzone, snippetType = "autosnippet" },
		fmta("\\begin{pmatrix}\n<>\\\\\n<>\\\\\n<>\n\\end{pmatrix}<>", {
			i(1),
			i(2),
			i(3),
			i(0),
		})
	),
	s({ trig = "è", condition = tex_utils.in_mathzone, snippetType = "autosnippet" }, t("\\cdot ")),
}

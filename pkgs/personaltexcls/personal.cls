\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{personal}[2025/09/24 My personal LaTeX class]

% Pass additional options to article
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt]{article}

% Math packages
\RequirePackage{amsmath, amssymb, amsfonts, mathtools, dsfont}

% Formatting/Styling packages
\RequirePackage{parskip, hyperref, xcolor, csquotes}
\RequirePackage[a4paper,margin=2.5cm]{geometry}
\RequirePackage[mocha,textcolor=true,pagecolor=true]{catppuccinpalette}

% Latex settings
\MakeOuterQuote{"}

% Latex commands
\newcommand{\ds}{\displaystyle}

% Math commands
\newcommand{\diff}{\ensuremath{\operatorname{d}\!}} % d space
\newcommand{\diffns}{\ensuremath{\operatorname{d}}} % d no space

\ExplSyntaxOn
\NewDocumentCommand{\dv}{ s O{1} m m }{%
	\mathcolor{CtpPink}{\dfrac{%
		\int_compare:nTF {#2 = 1} {\diffns} {\diffns^{#2}}%
		\IfBooleanF{#1}{\! #4}%
	}{%
		\int_compare:nTF {#2 = 1} {\diffns} {\diffns^{#2}} \! #3
	}%
	\IfBooleanT{#1}{#4}}%
}
\ExplSyntaxOff

% Colored math

\everymath{\color{CtpPeach}}

\let\oldmathbb\mathbb
\renewcommand{\mathbb}[1]{\mathcolor{CtpSky}{\oldmathbb{#1}}}
\let\oldmathcal\mathcal
\renewcommand{\mathcal}[1]{\mathcolor{CtpYellow}{\oldmathcal{#1}}}

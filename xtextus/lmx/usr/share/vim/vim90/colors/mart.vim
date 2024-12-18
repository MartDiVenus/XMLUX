" Vim colours
"
" Maintainer: Mario Fantini "MartDiVenus" ing.mariofantini@gmail.com 
"             https://github.com/MartDiVenus/ 
" Name: mart.vim
" Version: 1.0.0 
" Date: 2021/10/15


set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="mart"

hi Normal			guifg=white     guibg=grey20		ctermbg=black	ctermfg=white

"" Highlight syntax groups
hi NonText					guifg=magenta					ctermfg=lightMagenta
hi label					guifg=yellow					ctermfg=yellow
hi operator	gui=bold			guifg=orange		                	ctermfg=lightRed	
hi ErrorMs			guibg=white	guifg=red					ctermfg=lightRed
hi WarningMsg	gui=bold	guibg=darkGreen	guifg=orange					ctermfg=cyan	
hi ModeMsg	gui=NONE			guifg=yellow					ctermfg=yellow
hi MoreMsg	gui=NONE			guifg=yellow					ctermfg=yellow
hi Cursor			guibg=white	guifg=black		ctermbg=white		ctermfg=black
hi Search			guibg=peru	guifg=wheat		ctermbg=darkYellow	ctermfg=black	
hi IncSearch			guibg=yellow	guifg=black		ctermbg=darkYellow	ctermfg=black	
hi LineNr					guifg=cyan
hi title	gui=bold			guifg=white	cterm=bold			ctermfg=cyan
hi StatusLineNC	gui=NONE	guibg=blue	guifg=black		ctermbg=blue		ctermfg=black		
hi StatusLine	gui=bold	guibg=blue	guifg=cyan		ctermbg=blue		ctermfg=cyan
hi VertSplit	gui=none	guibg=blue	guifg=blue		ctermbg=blue		ctermfg=blue
hi Visual	term=reverse	guibg=darkCyan	guifg=black		ctermbg=darkCyan	ctermfg=black 		 		
hi DiffChange			guibg=darkGreen	guifg=black		ctermbg=darkGreen	ctermfg=black
hi DiffText			guibg=olivedrab	guifg=black		ctermbg=darkGreen	ctermfg=black
hi DiffAdd			guibg=slateblue	guifg=black		ctermbg=blue		ctermfg=black
hi DiffDelete			guibg=coral	guifg=black		ctermbg=lightRed	ctermfg=black
hi Folded			guibg=SeaGreen	guifg=black		ctermbg=yellow		ctermfg=black
hi FoldColumn			guibg=gray50	guifg=tan		ctermbg=gray		ctermfg=black
hi TabLineSel			guibg=white	guifg=red
hi Question		  			guifg=green					ctermfg=green

"" syntax highlight groups
hi Comment	gui=bold			guifg=SkyBlue		                	ctermfg=lightCyan			 
hi Constant					guifg=cyan					ctermfg=brown
hi Directory					guifg=lightBlue					ctermfg=lightBlue	
hi Function					guifg=gold					ctermfg=darkYellow
hi Delimiter					guifg=blue					ctermfg=blue
hi Identifier					guifg=gray					ctermfg=7
hi netrwDateSep					guifg=darkGreen					ctermfg=darkGreen
hi netrwComment					guifg=darkCyan					ctermfg=darkCyan
hi netrwGray					guifg=gray					ctermfg=gray
hi netrwPlain					guifg=white					ctermfg=white
hi Number					guifg=salmon					ctermfg=lightmagenta

hi Statement	gui=none			guifg=green		                	ctermfg=green	
hi Preproc					guifg=lightMagenta				ctermfg=lightMagenta
hi Type						guifg=darkKhaki		ctermbg=darkGreen	ctermfg=lightRed	
hi Special					guifg=navajowhite				ctermfg=darkYellow	
hi Underlined	gui=underline			guifg=cyan	cterm=underline			ctermfg=cyan			
hi Todo				guibg=black	guifg=coral		ctermbg=darkYellow	ctermfg=black
hi Error	gui=underline	guibg=white	guifg=red					ctermfg=red
hi Ignore					guifg=grey40

"" *.xml *.lmx
hi CharCommand					guifg=green					ctermfg=green
hi PatternCommand		guibg=lightGray	guifg=darkGreen		ctermbg=gray		ctermfg=green
hi Group					guifg=coral					ctermfg=lightRed
hi Option					guifg=lightMagenta				ctermfg=lightMagenta


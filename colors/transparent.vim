set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="transparent"

hi Normal			ctermfg=Gray	ctermbg=NONE				guifg=Gray	guibg=#00002A

hi Cursor										guifg=Black	guibg=Green
if version >= 700
    hi CursorColumn cterm=reverse										guibg=Gray40
    hi CursorLine	cterm=underline										guibg=Gray40
endif
hi Directory			ctermfg=White						guifg=White
hi DiffAdd			ctermfg=White	ctermbg=DarkCyan			guifg=White	guibg=DarkCyan
hi DiffChange			ctermfg=Black	ctermbg=Gray				guifg=Black	guibg=DarkGray
hi DiffDelete			ctermfg=White	ctermbg=DarkRed				guifg=White	guibg=DarkRed
hi DiffText	cterm=bold	ctermfg=White	ctermbg=Gray		gui=bold	guifg=White	guibg=DarkGray
hi ErrorMsg			ctermfg=White	ctermbg=DarkRed				guifg=White	guibg=DarkRed
hi VertSplit	cterm=reverse						gui=reverse
hi Folded	cterm=bold	ctermfg=Cyan	ctermbg=NONE		gui=bold	guifg=Cyan	guibg=DarkCyan
hi FoldColumn			ctermfg=Green	ctermbg=NONE				guifg=Green	guibg=#00002A
hi IncSearch			ctermfg=White	ctermbg=Black				guifg=White	guibg=Black
hi LineNr			ctermfg=Yellow						guifg=DarkCyan
if version >= 700
    hi MatchParen	cterm=bold,underline		ctermbg=NONE		gui=bold,underline		guibg=NONE
endif
hi ModeMsg	cterm=bold	ctermfg=White				gui=bold	guifg=White
hi MoreMsg	cterm=bold	ctermfg=White				gui=bold	guifg=White
hi NonText			ctermfg=NONE						guifg=NONE
if version >= 700
    hi Pmenu			ctermfg=Black	ctermbg=Cyan				guifg=Black	guibg=Cyan
    hi PmenuSel			ctermfg=Black	ctermbg=Grey				guifg=Black	guibg=Grey
    hi PmenuSbar			ctermfg=Black	ctermbg=Grey				guifg=Black	guibg=Grey
    hi PmenuThumb	cterm=reverse						gui=reverse
endif
hi Question			ctermfg=Green						guifg=Green
hi Search	cterm=reverse	ctermfg=fg	ctermbg=NONE		gui=reverse	guifg=fg	guibg=bg
hi SpecialKey			ctermfg=LightRed					guifg=Red
if version >= 700
    hi SpellBad					ctermbg=Red		gui=undercurl					guisp=Red
    hi SpellCap					ctermbg=Blue		gui=undercurl					guisp=Blue
    hi SpellRare					ctermbg=Magenta		gui=undercurl					guisp=Magenta
    hi SpellLocal					ctermbg=Cyan		gui=undercurl					guisp=Cyan
endif
hi StatusLine	cterm=bold,reverse ctermfg=White ctermbg=Black		gui=bold,reverse guifg=White	guibg=Black
hi StatusLineNC	cterm=reverse	ctermfg=Gray	ctermbg=Black		gui=reverse	guifg=DarkGray	guibg=Black
if version >= 700
    hi TabLine	cterm=underline	ctermfg=Gray				gui=underline	guifg=Black	guibg=DarkGray
    hi TabLineSel	cterm=bold,underline ctermfg=White			gui=bold	guifg=White
    hi TabLineFill cterm=underline ctermfg=Gray				gui=underline	guifg=Black	guibg=DarkGray
endif
hi Title			ctermfg=LightGreen			gui=bold	guifg=Green
hi Visual	cterm=inverse	ctermfg=White	ctermbg=DarkGray	gui=inverse	guifg=DarkGray	guibg=Black
hi VisualNOS	cterm=bold,underline					gui=bold,underline
hi WarningMsg			ctermfg=White	ctermbg=DarkRed				guifg=White	guibg=DarkRed
hi WildMenu	cterm=bold	ctermfg=Black	ctermbg=Yellow		gui=bold	guifg=Black	guibg=Yellow

hi Comment			ctermfg=DarkCyan					guifg=DarkCyan
hi Constant			ctermfg=LightGreen					guifg=LightGreen
hi String			ctermfg=Yellow						guifg=Yellow
hi Character			ctermfg=Yellow						guifg=Yellow
hi Identifier			ctermfg=LightCyan					guifg=LightCyan
hi Function			ctermfg=White						guifg=White
hi Statement			ctermfg=Yellow						guifg=Yellow
hi Label			ctermfg=White						guifg=White
hi Operator			ctermfg=Green						guifg=Green
hi Exception			ctermfg=Black	ctermbg=DarkRed				guifg=Black	guibg=DarkRed
hi PreProc			ctermfg=DarkGreen					guifg=#00aa00
hi Type				ctermfg=Green						guifg=Green
hi Typedef			ctermfg=Red						guifg=Red
hi Special			ctermfg=Red						guifg=Red
hi Tag				ctermfg=LightGreen					guifg=LightGreen
hi Delimiter			ctermfg=Green						guifg=Green
hi Debug			ctermfg=White	ctermbg=Black				guifg=White	guibg=Black
hi Underlined	cterm=underline						gui=underline
hi Ignore			ctermfg=DarkBlue					guifg=DarkBlue
hi Error			ctermfg=White	ctermbg=DarkRed				guifg=White	guibg=DarkRed
hi Todo				ctermfg=Black	ctermbg=Gray				guifg=Black	guibg=Gray

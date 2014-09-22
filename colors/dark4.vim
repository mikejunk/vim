" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" vmi color file
set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let colors_name="dark4"

if version >= 700
    hi CursorLine   term=NONE   cterm=NONE  ctermbg=236     ctermfg=NONE    gui=NONE    guibg=#2d2d2d   guifg=NONE
    hi CursorColumn term=NONE   cterm=NONE  ctermbg=236     ctermfg=NONE    gui=NONE    guibg=#2d2d2d   guifg=NONE
    hi MatchParen   term=bold   cterm=bold  ctermbg=237     ctermfg=157     gui=bold    guibg=#2f2f2f   guifg=#d0ffc0
    hi Pmenu        term=NONE   cterm=NONE  ctermbg=238     ctermfg=255     gui=NONE    guibg=#444444   guifg=#ffffff
    hi PmenuSel     term=italic cterm=NONE  ctermbg=148     ctermfg=0       gui=NONE    guibg=#b1d631   guifg=#000000
endif

hi Cursor       term=NONE           cterm=NONE          ctermbg=Red         ctermfg=NONE        gui=NONE        guibg=#8b3a3a       guifg=#e3e3e3
hi Normal       term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=LightGrey   gui=NONE        guibg=#03080F       guifg=#958a73
hi NonText      term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=Black       gui=NONE        guibg=#03080F       guifg=#000030
hi DiffDelete   term=NONE           cterm=NONE          ctermbg=DarkRed     ctermfg=White       gui=NONE        guibg=DarkRed       guifg=White
hi DiffAdd      term=NONE           cterm=NONE          ctermbg=DarkGreen   ctermfg=White       gui=NONE        guibg=DarkGreen     guifg=White
hi DiffText     term=NONE           cterm=NONE          ctermbg=LightCyan   ctermfg=Yellow      gui=NONE        guibg=Lightblue     guifg=Yellow
hi DiffChange   term=NONE           cterm=NONE          ctermbg=LightBlue   ctermfg=White       gui=NONE        guibg=Grey          guifg=White
hi Constant     term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=Red         gui=NONE        guibg=NONE          guifg=#872e30
hi StatusLine   term=standout       cterm=italic        ctermbg=DarkGrey    ctermfg=Red         gui=italic      guibg=#2a2a2a       guifg=#eeeeee
hi StatusLineNC term=NONE           cterm=NONE          ctermbg=Darkgrey    ctermfg=black       gui=NONE        guibg=#515151       guifg=Black
hi VertSplit    term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=NONE        gui=NONE        guibg=NONE          guifg=Grey
hi Visual       term=underline      cterm=underline     ctermbg=DarkRed     ctermfg=Red         gui=NONE        guibg=#6b6b6b       guifg=#431818
hi Search       term=NONE           cterm=NONE          ctermbg=Yellow      ctermfg=LightGrey   gui=NONE        guibg=#bf9966       guifg=#03080F
hi Label        term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=NONE        gui=NONE        guibg=NONE          guifg=#ffc0c0
hi LineNr       term=bold           cterm=NONE          ctermbg=NONE        ctermfg=Red         gui=NONE        guibg=NONE          guifg=#A39274
hi MoreMsg      term=bold,italic    cterm=bold,italic   ctermbg=NONE        ctermfg=Brown       gui=bold        guibg=NONE          guifg=SeaGreen
hi question     term=standout       cterm=standout      ctermbg=NONE        ctermfg=Brown       gui=bold        guibg=NONE          guifg=SeaGreen
hi Comment      term=italic         cterm=italic        ctermbg=NONE        ctermfg=Yellow      gui=italic      guibg=NONE          guifg=#5c683f
hi PreProc      term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=darkcyan    gui=NONE        guibg=NONE          guifg=#387e7e
hi Statement    term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=Gray        gui=NONE        guibg=NONE          guifg=#ab952b
hi Type         term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=darkmagenta gui=NONE        guibg=NONE          guifg=#ba5bdb
hi Identifier   term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=Yellow      gui=NONE        guibg=NONE          guifg=#737d95
hi Special      term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=Green       gui=NONE        guibg=NONE          guifg=#5b5646
hi Todo         term=bold,italic    cterm=bold,italic   ctermbg=NONE        ctermfg=darkmagenta gui=bold,italic guibg=NONE          guifg=LightBlue
hi Number       term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=darkcyan    gui=NONE        guibg=NONE          guifg=lightblue
hi lispAtomMark term=underline      cterm=underline     ctermbg=NONE        ctermfg=lightcyan   gui=NONE        guifg=darkcyan      guibg=NONE
hi lispNumber   term=bold           cterm=NONE          ctermbg=NONE        ctermfg=DarkGreen   gui=NONE        guifg=lightblue     guibg=NONE
hi Folded       term=italic         cterm=italic        ctermbg=darkgray    ctermfg=NONE        gui=italic      guibg=#001a33       guifg=#a69c89
hi FoldColumn   term=NONE           cterm=NONE          ctermbg=NONE        ctermfg=Yellow      gui=NONE        guibg=#6699CC       guifg=#0000EE


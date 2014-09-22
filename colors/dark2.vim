" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" vmi color file
set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let colors_name="dark2"

hi LineNr       term=bold           cterm=bold              ctermfg=Green       ctermbg=Black
hi Normal       term=NONE           cterm=NONE              ctermfg=Brown       ctermbg=Black
hi NonText      term=NONE           cterm=NONE              ctermfg=black       ctermbg=Black
hi Statement    term=bold           cterm=bold              ctermfg=DarkCyan    ctermbg=Black
hi Comment      term=bold           cterm=bold              ctermfg=DarkGreen   ctermbg=Black
hi Constant     term=NONE           cterm=NONE              ctermfg=DarkCyan    ctermbg=Black
hi Identifier   term=NONE           cterm=NONE              ctermfg=White       ctermbg=Black
hi Type         term=NONE           cterm=NONE              ctermfg=DarkCyan    ctermbg=Black
hi String       term=NONE           cterm=NONE              ctermfg=Cyan        ctermbg=black
hi Boolean      term=NONE           cterm=NONE              ctermfg=DarkCyan    ctermbg=Black
hi Number       term=NONE           cterm=NONE              ctermfg=DarkCyan    ctermbg=Black
hi Folded       term=underline      cterm=underline         ctermfg=DarkCyan    ctermbg=Black
hi Special      term=NONE           cterm=NONE              ctermfg=darkgreen   ctermbg=Black
hi PreProc      term=bold           cterm=bold              ctermfg=LightGrey   ctermbg=Black
hi Scrollbar    term=NONE           cterm=NONE              ctermfg=DarkCyan    ctermbg=Black
hi Cursor       term=NONE           cterm=NONE              ctermfg=Black       ctermbg=Yellow
hi ErrorMsg     term=bold           cterm=bold              ctermfg=Red         ctermbg=Black
hi WarningMsg   term=NONE           cterm=NONE              ctermfg=Yellow      ctermbg=Black
hi VertSplit    term=NONE           cterm=NONE              ctermfg=black       ctermbg=Black
hi Directory    term=NONE           cterm=NONE              ctermfg=Green       ctermbg=DarkBlue
hi Visual       term=underline      cterm=underline         ctermfg=White       ctermbg=DarkGray
hi Title        term=NONE           cterm=NONE              ctermfg=White       ctermbg=DarkBlue
hi StatusLine   term=bold,underline cterm=bold,underline    ctermfg=White       ctermbg=Black
hi StatusLineNC term=bold,underline cterm=bold,underline    ctermfg=Gray        ctermbg=Black
hi cursorline   term=NONE           cterm=NONE              ctermbg=DarkGreen   ctermfg=Black

hi LineNr       gui=bold            guifg=Green     guibg=Black
hi Normal       gui=NONE            guifg=Brown     guibg=Black
hi NonText      gui=NONE            guifg=black     guibg=Black
hi Statement    gui=bold            guifg=DarkCyan  guibg=Black
hi Comment      gui=bold            guifg=darkgreen guibg=Black
hi Constant     gui=NONE            guifg=DarkCyan  guibg=Black
hi Identifier   gui=NONE            guifg=White     guibg=Black
hi Type         gui=NONE            guifg=DarkCyan  guibg=Black
hi String       gui=NONE            guifg=Cyan      guibg=Black
hi Boolean      gui=NONE            guifg=DarkCyan  guibg=Black
hi Number       gui=NONE            guifg=DarkCyan  guibg=Black
hi Folded       gui=underline       guifg=DarkCyan  guibg=Black
hi Special      gui=NONE            guifg=darkgreen guibg=Black
hi PreProc      gui=bold            guifg=LightGrey guibg=Black
hi Scrollbar    gui=NONE            guifg=DarkCyan  guibg=Black
hi Cursor       gui=NONE            guifg=Black     guibg=Yellow
hi ErrorMsg     gui=bold            guifg=Red       guibg=Black
hi WarningMsg   gui=NONE            guifg=Yellow    guibg=Black
hi VertSplit    gui=NONE            guifg=black     guibg=Black
hi Directory    gui=NONE            guifg=Green     guibg=DarkBlue
hi Visual       gui=underline       guifg=White     guibg=DarkGray
hi Title        gui=NONE            guifg=White     guibg=DarkBlue
hi StatusLine   gui=bold,underline  guifg=White     guibg=Black
hi StatusLineNC gui=bold,underline  guifg=Gray      guibg=Black
hi cursorline   gui=NONE            guifg=Black     guibg=DarkGreen


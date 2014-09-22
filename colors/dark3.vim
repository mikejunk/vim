" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" vmi color file
set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let colors_name = "dark3"

hi Cursor           gui=NONE        guifg=fg        guibg=#da70d6
hi CursorIM         gui=NONE        guifg=NONE      guibg=#ff83fa
hi Directory        gui=NONE        guifg=#e0ffff   guibg=bg
hi DiffAdd          gui=NONE        guifg=fg        guibg=#528b8b
hi DiffChange       gui=NONE        guifg=fg        guibg=#8b636c
hi DiffDelete       gui=bold        guifg=fg        guibg=#000000
hi DiffText         gui=bold        guifg=fg        guibg=#6959cd
hi ErrorMsg         gui=bold        guifg=#ffffff   guibg=#ff0000
hi VertSplit        gui=bold        guifg=#bdb76b   guibg=#000000
hi Folded           gui=NONE        guifg=#000000   guibg=#bdb76b
hi FoldColumn       gui=NONE        guifg=#000000   guibg=#bdb76b
hi SignColumn       gui=bold        guifg=#bdb76b   guibg=#20b2aa
hi IncSearch        gui=bold        guifg=#000000   guibg=#ffffff
hi LineNr           gui=bold        guifg=#bdb76b   guibg=#528b8b
hi ModeMsg          gui=bold        guifg=fg        guibg=bg  
hi MoreMsg          gui=bold        guifg=#20b2aa   guibg=bg 
hi NonText          gui=bold        guifg=#ffffff   guibg=bg 
hi Normal           gui=NONE        guifg=#f5deb3   guibg=#2f4f4f
hi Question         gui=bold        guifg=#ff6347   guibg=bg
hi Search           gui=bold        guifg=#000000   guibg=#ffd700
hi SpecialKey       gui=NONE        guifg=#00ffff   guibg=bg
hi StatusLine       gui=bold        guifg=#f0e68c   guibg=#000000
hi StatusLineNC     gui=NONE        guifg=#404040   guibg=#bdb76b
hi Title            gui=bold        guifg=#ff6347   guibg=bg
hi Visual           gui=NONE        guifg=#000000   guibg=fg
hi VisualNOS        gui=bold        guifg=#000000   guibg=fg
hi WarningMsg       gui=NONE        guifg=#ffffff   guibg=#ff6347
hi WildMenu         gui=bold        guifg=#000000   guibg=#ffff00

hi Comment          gui=NONE        guifg=#da70d6   guibg=bg
hi Constant         gui=NONE        guifg=#cdcd00   guibg=bg
hi String           gui=NONE        guifg=#7fffd4   guibg=bg
hi Character        gui=NONE        guifg=#7fffd4   guibg=bg
hi Number           gui=NONE        guifg=#ff6347   guibg=bg
hi Boolean          gui=NONE        guifg=#cdcd00   guibg=bg
hi Float            gui=NONE        guifg=#ff6347   guibg=bg
hi Identifier       gui=NONE        guifg=#afeeee   guibg=bg
hi Function         gui=NONE        guifg=#ffffff   guibg=bg
hi Statement        gui=bold        guifg=#4682b4   guibg=bg
hi Conditional      gui=bold        guifg=#4682b4   guibg=bg
hi Repeat           gui=bold        guifg=#4682b4   guibg=bg
hi Label            gui=bold        guifg=#4682b4   guibg=bg
hi Operator         gui=bold        guifg=#4682b4   guibg=bg
hi Keyword          gui=bold        guifg=#4682b4   guibg=bg
hi Exception        gui=bold        guifg=#4682b4   guibg=bg
hi PreProc          gui=NONE        guifg=#cdcd00   guibg=bg
hi Include          gui=NONE        guifg=#ffff00   guibg=bg
hi Define           gui=NONE        guifg=#cdcd00   guibg=bg
hi Macro            gui=NONE        guifg=#cdcd00   guibg=bg
hi PreCondit        gui=NONE        guifg=#cdcd00   guibg=bg
hi Type             gui=bold        guifg=#98fb98   guibg=bg
hi StorageClass     gui=NONE        guifg=#00ff00   guibg=bg
hi Structure        gui=NONE        guifg=#20b2aa   guibg=bg
hi Typedef          gui=NONE        guifg=#00ff7f   guibg=bg
hi Special          gui=NONE        guifg=#ff6347   guibg=bg
hi SpecialChar      gui=underline   guifg=#7fffd4   guibg=bg
hi Tag              gui=NONE        guifg=#ff6347   guibg=bg
hi Delimiter        gui=bold        guifg=#b0c4de   guibg=bg
hi SpecialComment   gui=bold        guifg=#da70d6   guibg=bg
hi Debug            gui=bold        guifg=#ff0000   guibg=bg
hi Underlined       gui=underline   guifg=fg        guibg=bg
hi Ignore           gui=NONE        guifg=bg        guibg=bg
hi Error            gui=bold        guifg=#ffffff   guibg=#ff0000
hi Todo             gui=bold        guifg=#000000   guibg=#ff83fa


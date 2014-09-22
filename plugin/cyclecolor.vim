
function! s:CycleColor(dir)
    " initialize the string of colorscheme filenames
    let l:schemes = "aaa-\n".globpath(&rtp, "colors/*.vim")."zzz-\n"
    " get the first colorscheme name in the string
    let l:first = substitute(l:schemes, 'aaa-\n[^\n]*[/\\]colors[/\\]'.'\([^\.]*\)'.'\.vim\n.*zzz-\n', '\1', '')
    " get the last colorscheme name in the string
    let l:last = substitute(l:schemes, '.*\n[^\n]*[/\\]colors[/\\]'.'\([^\.]*\)'.'\.vim\nzzz-\n', '\1', '')
    " sync the current color scheme with vim's colorscheme
    let l:curr = ""
    if exists("g:colors_name")
        let l:curr = g:colors_name
    else
        if a:dir == 1
            let l:curr = l:last
        else
            let l:curr = l:first
        endif
    endif
    " process forward or reverse to get the new colorscheme
    if a:dir == 1
        let l:next = substitute(l:schemes, '.*\n[^\n]*[/\\]colors[/\\]'.l:curr.'\.vim\n[^\n]*[/\\]colors[/\\]\([^\.]*\)\.vim\n.*', '\1', '')
        if l:next == l:schemes
            let l:next = l:first
        endif
        let l:curr = l:next
    else
        let l:prev = substitute(l:schemes, '.*\n[^\n]*[/\\]colors[/\\]\([^\.]*\)\.vim\n[^\n]*[/\\]colors[/\\]'.l:curr.'\.vim\n.*', '\1', '')
        if l:prev == l:schemes
            let l:prev = l:last
        endif
        let l:curr = l:prev
    endif
    " change to the new colorscheme
    exec 'colorscheme '.l:curr
    redraw
    " verify the vim colorscheme variable is set correctly
    if l:curr != g:colors_name
        let g:colors_name=l:curr
        echomsg 'WARNING: colorscheme '.l:curr.' does not set g:colors_name: !!!RESETTING g:colors='.l:curr.'!!!'
    else
        echo l:curr
    endif
endfunction

command! CycleColorNext :call s:CycleColor(1)
command! CycleColorPrev :call s:CycleColor(0)

nnoremap <f4> :CycleColorNext<cr>
nnoremap <f3> :CycleColorPrev<cr>


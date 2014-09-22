set nocompatible
set ruler
set showcmd
set showmatch
set expandtab
set visualbell
set notimeout
set backup
set autochdir
set hlsearch
set ignorecase
set smartcase
set nowrap
set nowrapscan
set tabstop=4
set shiftwidth=4
set textwidth=0
set updatecount=100
set updatetime=3000
set backspace=indent,eol,start
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,conceal:*,nbsp:+

filetype plugin indent on

if has('mouse')
    set mouse=a
endif

" use cygstart to launch the windows program for the given file type
nmap gx :LaunchAssociated<cr>
command! -nargs=0 LaunchAssociated :call LaunchAssociated(expand("%:p"))
function! LaunchAssociated(file)
    if substitute(a:file,'^\s*\(.\{-}\)\s*$','\1','') != ''
        call system('cygstart ' . a:file)
    endif
endfunction

" create a scratch buffer
command! Scratch call Scratch()
function! Scratch()
    let scratch_bufnum = bufnr("scratch")
    if scratch_bufnum == -1
        execute "new scratch"
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal noswapfile
        setlocal buflisted
    else
        let scratch_winnum = bufwinnr(scratch_bufnum)
        if scratch_winnum == -1
            execute "split +buffer" . scratch_bufnum
        else
            if winnr() != scratch_winnum
                execute scratch_winnum . "wincmd w"
            endif
        endif
    endif
endfunction

" destroy all buffers that are not open in any tabs or windows
command! -bang Wipeout :call Wipeout(<bang>0)
function! Wipeout(bang)
    " figure out which buffers are visible in any tab
    let visible = {}
    for t in range(1, tabpagenr('$'))
        for b in tabpagebuflist(t)
            let visible[b] = 1
        endfor
    endfor
    " close any buffer that are loaded and not visible
    let l:tally = 0
    let l:cmd = 'bw'
    if a:bang
        let l:cmd .= '!'
    endif
    for b in range(1, bufnr('$'))
        if buflisted(b) && !has_key(visible, b)
            let l:tally += 1
            exe l:cmd . ' ' . b
        endif
    endfor
    echon "Deleted " . l:tally . " buffers"
endfun

" open help file(s) without leaving current window
command! -nargs=? -bang -complete=help Help call Help('<bang>', <f-args>)
function! Help(bang, ...)
    let l:start_bt = &l:buftype
    if a:0 > 0
        exec 'help' . a:bang . ' ' . a:1
        if l:start_bt != 'help'
            " return to prev window if we were not in help window
            wincmd p
        endif
    else
        " open or switch to help window and close it
        help
        wincmd c
    endif
endfunction

if has("autocmd")
    augroup vimrcEx
        au!
        autocmd GUIEnter * simalt ~x
        autocmd FileType text setlocal textwidth=78
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif
    augroup END
else
    set autoindent
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pathogen plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
execute pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" conque term plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ConqueTerm_FastMode=1
let g:ConqueTerm_Color=0
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_Syntax = 'conque_term'
let g:ConqueTerm_TERM = 'vt100'
let g:ConqueTerm_ColorMode = 'conceal'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" solarized plugin
" (:silent !source ~/.mintty-dark-config)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:syntax enable
:set background=dark
:colorscheme solarized


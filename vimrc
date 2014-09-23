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
set viminfo='100,n$HOME/.vim/viminfo
set sessionoptions=blank,curdir,folds,help,tabpages,winpos

filetype plugin indent on

if has('mouse')
    set mouse=a
endif

" use cygstart to launch the windows program for the given str/buf
nmap gx :LaunchAssocCursor<cr>
nmap gX :LaunchAssocBuffer<cr>
" launch the associated program for object under the cursor
command! -nargs=0 LaunchAssocCursor :call LaunchAssoc(expand("<cfile>"))
" launch the associated program for object that is the buffer contents 
command! -nargs=0 LaunchAssocBuffer :call LaunchAssoc(expand("%:p"))
function! LaunchAssociated(x)
    let l:y = substitute(a:x,'^\s*\(.\{-}\)\s*$','\1','')
    if l:y != ''
        call system('cygstart '.l:y)
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
    let l:start_bt = &buftype
    if a:0 > 0
        let l:xs = ""
        if a:bang
            let l:xs = l:xs . "help! "
        else
            let l:xs = l:xs . "help "
        endif
        let l:xs = l:xs . join(a:000)
        execute l:xs
        if l:start_bt != 'help'
            wincmd p
            wincmd c
        endif
    else
        help
    endif
endfunction

nnoremap <f12>   :ShowSpaces 1<CR>
nnoremap <s-f12> m`:TrimSpaces<CR>``
vnoremap <s-f12> :TrimSpaces<CR>
command! -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
function! ShowSpaces(...)
    let @/='\v(\s+$)|( +\ze\t)'
    let oldhlsearch=&hlsearch
    if !a:0
        let &hlsearch=!&hlsearch
    else
        let &hlsearch=a:1
    end
    return oldhlsearch
endfunction
function! TrimSpaces() range
    let oldhlsearch=ShowSpaces(1)
    execute a:firstline.",".a:lastline."substitute ///gec"
    let &hlsearch=oldhlsearch
endfunction


if has("autocmd")
    augroup vimrcEx
        au!
        autocmd GUIEnter * simalt ~x
        autocmd GUIFailed * simalt ~x
        autocmd FileType startify setlocal buftype=
        autocmd FileType text setlocal textwidth=78
        autocmd User Startified call AirlineRefresh
        autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
    augroup END
else
    set autoindent
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDTreeHijackNetrw = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pathogen plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
execute pathogen#infect()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tagbar plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_autoclose=1
nnoremap <silent> <f9> :TagbarToggle<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taglist plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Tlist_GainFocus_On_ToggleOpen=1
let g:Tlist_Auto_Highlight_Tag=1
let g:Tlist_Auto_Open=0
let g:Tlist_Auto_Update=0
let g:Tlist_Display_Tag_Scope=1
let g:Tlist_Enable_Fold_Column=1
let g:Tlist_Exit_OnlyWindow=1
let g:Tlist_Inc_Winwidth=1
let g:Tlist_Process_File_Always=0
let g:Tlist_Show_Menu=1
let g:Tlist_Show_One_File=1
nnoremap <silent> <f8> :TlistToggle<cr>
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
" airline plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_inactive_collapse=0
let g:airline_theme='kalisi'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" solarized plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:syntax enable
:set background=dark
:colorscheme solarized
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" startify plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_list_order = ['bookmarks', 'sessions', 'dir', 'files']
let g:startify_files_number=10
let g:startify_session_autoload=0
let g:startify_change_to_dir=1
let g:startify_skiplist = [
            \ 'COMMIT_EDITMSG',
            \ $VIMRUNTIME .'/doc',
            \ 'bundle/.*/doc',
            \ '\.DS_Store'
            \ ]
let g:startify_custom_header = [
            \ '                                 ________  __ __        ',
            \ '            __                  /\_____  \/\ \\ \       ',
            \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
            \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
            \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
            \ '                                                        ',
            \ '                                                        ',
            \ '                     header                             ',
            \ '                                                        ',]
let g:startify_custom_footer = [
            \ '                                                        ',
            \ '                     footer                             ',
            \ '                                 ________  __ __        ',
            \ '            __                  /\_____  \/\ \\ \       ',
            \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
            \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
            \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
            \ '                                                        ',]


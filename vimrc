set nocompatible
set ruler
set showcmd
set showmode
set showmatch
set visualbell
set notimeout
set backup
set ignorecase
set nowrapscan
set expandtab
set tabstop=4
set shiftwidth=4
set textwidth=0
set laststatus=2
set shortmess=I
set backspace=indent,eol,start
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,conceal:*,nbsp:+
set sessionoptions=blank,curdir,folds,help,tabpages,winpos

execute pathogen#infect()
syntax on
filetype plugin indent on
set background=dark
colorscheme torte
syntax enable

runtime! ftplugin/man.vim

" use cygstart to launch the windows program for the given str/buf
nmap gx :LaunchAssocCursor<cr>
nmap gX :LaunchAssocBuffer<cr>
" launch the associated program for object under the cursor
command! -nargs=0 LaunchAssocCursor :call LaunchAssoc(expand("<cfile>"))
" launch the associated program for object that is the buffer contents 
command! -nargs=0 LaunchAssocBuffer :call LaunchAssoc(expand("%:p"))
function! LaunchAssoc(x)
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

"nnoremap <f12>   :ShowSpaces 1<CR>
"nnoremap <s-f12> m`:TrimSpaces<CR>``
"vnoremap <s-f12> :TrimSpaces<CR>
"command! -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
"command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
"function! ShowSpaces(...)
"    let @/='\v(\s+$)|( +\ze\t)'
"    let oldhlsearch=&hlsearch
"    if !a:0
"        let &hlsearch=!&hlsearch
"    else
"        let &hlsearch=a:1
"    end
"    return oldhlsearch
"endfunction
"function! TrimSpaces() range
"    let oldhlsearch=ShowSpaces(1)
"    execute a:firstline.",".a:lastline."substitute ///gec"
"    let &hlsearch=oldhlsearch
"endfunction

function! Readpdf()
    if (!executable("pdftotext"))
        echo "Error: pdftotext not installed or not in path"
        return
    endif
    let tmp = tempname()
    call system("pdftotext '" . escape (expand("<afile>"), "'") . "' " . tmp)
    setlocal nobin
	execute "silent '[-1r " . tmp
    call delete(tmp)
    set nowrite
endfun

function! Readps()
    if (!executable("pstotext"))
        echo "Error: pstotext not installed or not in path"
        return
    endif
    let tmp = tempname()
    call system("pstotext -output " . tmp . "'" . escape (expand("<afile>"), "'") . "'")
    setlocal nobin
	execute "silent '[-1r " . tmp
    call delete(tmp)
    set nowrite
endfun

if has("autocmd")
    augroup vimrcEx
        au!
        autocmd GUIEnter * simalt ~x
        autocmd FileType startify setlocal buftype=
        autocmd User Startified call AirlineRefresh
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
else
    set autoindent
endif

let g:showmarks_enable=0

let g:NERDTreeCaseSensitiveSort=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeShowFiles=1
let g:NERDTreeShowHidden=1
let g:NERDTreeChDirMode=2 

"set tags=./tags;
let g:easytags_dynamic_files=1

let g:tagbar_autoclose=1
nnoremap <silent> <f9> :TagbarToggle<cr>

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

let g:ConqueTerm_PyVersion=3
let g:ConqueTerm_FastMode=1
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CloseOnEnd = 0
let g:ConqueTerm_StartMessages = 1
let g:ConqueTerm_Syntax = 'conque_term'

let g:airline_theme='hybrid'

set nocompatible
set ruler
set showcmd
set showmode
set showmatch
set visualbell
set wildmenu
set notimeout
set nottimeout
set backup
set hlsearch
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

execute pathogen#infect()
syntax on
filetype plugin indent on

runtime! ftplugin/man.vim

" change background color when in insert mode and then back when you hit escape
"noremap i :highlight Normal guibg=lightyellow<cr>i
"noremap o :highlight Normal guibg=lightyellow<cr>o
"noremap s :highlight Normal guibg=lightyellow<cr>s
"noremap a :highlight Normal guibg=lightyellow<cr>a
"noremap I :highlight Normal guibg=lightyellow<cr>I
"noremap O :highlight Normal guibg=lightyellow<cr>O
"noremap S :highlight Normal guibg=lightyellow<cr>S
"noremap A :highlight Normal guibg=lightyellow<cr>A
"inoremap <Esc> <Esc>:highlight Normal guibg=Sys_Window<cr> 

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

" Remove trailing whitespace and sequential whitespace between words.
function! WhiteWash()
    let l:save_cursor = getpos(".")
    %s/\s\+$//e
    if true
        %s/\(\S\)\s\{2,\}/\1/eg
    else
        %s/\>\s\{2,\}//eg
    endif
    call setpos('.', l:save_cursor)
endfunction
command! -range=% WhiteWash :silent call WhiteWash()

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

let g:ulti_color_Add_Fav='<leader><leader><leader>a'
let g:ulti_color_Remove_Fav='<leader><leader><leader>A'
let g:ulti_color_Next_Global='<leader><leader><leader>n'
let g:ulti_color_Prev_Global='<leader><leader><leader>N'
let g:ulti_color_Next_Fav='<leader><leader><leader>f'
let g:ulti_color_Prev_Fav='<leader><leader><leader>F'
let g:ulti_color_Next_Global_Fav='<leader><leader><leader>g'
let g:ulti_color_Prev_Global_Fav='<leader><leader><leader>G'
let g:ulti_color_See_Fav='<leader><leader><leader>q'
let g:ulti_color_Font_Next_Fav='<leader><leader><leader>e'
let g:ulti_color_Font_Prev_Fav='<leader><leader><leader>E'
let g:ulti_color_Font_Next_Global_Fav='<leader><leader><leader>r'
let g:ulti_color_Font_Prev_Global_Fav='<leader><leader><leader>R'
let g:ulti_color_Font_Add_Fav='<leader><leader><leader>t'
let g:ulti_color_Font_Remove_Fav='<leader><leader><leader>T'
let g:ulti_color_write_Fav='<leader><leader><leader>s'
let g:ulti_color_Load_Fav='<leader><leader><leader>S'
let g:ulti_color_default_keys=0
let g:ulti_color_gui_menu=0

let g:showmarks_enable=0

let g:NERDTreeAutoCenter=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeShowFiles=1
let g:NERDTreeShowHidden=1
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeChDirMode=2 

set tags=./tags;
let g:easytags_dynamic_files = 1
let g:easytags_python_enabled=1
let g:easytags_always_enabled = 1
let g:easytags_by_filetype="~/.vim/tags"
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

let g:ConqueTerm_PyVersion=2
let g:ConqueTerm_FastMode=1
let g:ConqueTerm_Color=1
let g:ConqueTerm_ReadUnfocused=1
let g:ConqueTerm_InsertOnEnter=1
let g:ConqueTerm_StartMessages=1
let g:ConqueTerm_CloseOnEnd=0
let g:ConqueTerm_Syntax='conque_term'
let g:ConqueTerm_EscKey='<Esc>'
let g:ConqueTerm_ToggleKey='<F3>'
let g:ConqueTerm_ExecFileKey='<F4>'
let g:ConqueTerm_SendFileKey='<F5>'
let g:ConqueTerm_SendVisKey='<F6>'
let g:ConqueTerm_TERM = 'vt100'
"let g:ConqueTerm_TERM='xterm'
let g:ConqueTerm_PyExe='/usr/bin/python.exe'
let g:ConqueTerm_ColorMode='conceal'

"remap snipmate's trigger key from tab to ^j
imap <c-j> <plug>snipMateNextOrTrigger
smap <c-j> <plug>snipMateNextOrTrigger

"let g:pymode_python='python3'

let g:pyref_python='/usr/share/doc/python3/html'
let g:pyref_django=''

let g:pymode_folding=0

let g:ctrlp_show_hidden=1
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=20
let g:ctrlp_user_command='find %s -type f'
let g:ctrlp_open_new_file='r'


" Use this to customize the mappings inside CtrlP's prompt to your liking.
" You only need to keep the lines that you've changed the values (inside [])
let g:ctrlp_prompt_mappings = {
            \ 'PrtBS()':              ['<bs>', '<c-]>'],
            \ 'PrtDelete()':          ['<del>'],
            \ 'PrtDeleteWord()':      ['<c-w>'],
            \ 'PrtClear()':           ['<c-u>'],
            \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
            \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
            \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
            \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
            \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
            \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
            \ 'PrtHistory(-1)':       ['<c-n>'],
            \ 'PrtHistory(1)':        ['<c-p>'],
            \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
            \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
            \ 'AcceptSelection("t")': ['<c-t>'],
            \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
            \ 'ToggleFocus()':        ['<s-tab>'],
            \ 'ToggleRegex()':        ['<c-r>'],
            \ 'ToggleByFname()':      ['<c-d>'],
            \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
            \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
            \ 'PrtExpandDir()':       ['<tab>'],
            \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
            \ 'PrtInsert()':          ['<c-\>'],
            \ 'PrtCurStart()':        ['<c-a>'],
            \ 'PrtCurEnd()':          ['<c-e>'],
            \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
            \ 'PrtCurRight()':        ['<c-l>', '<right>'],
            \ 'PrtClearCache()':      ['<F5>'],
            \ 'PrtDeleteEnt()':       ['<F7>'],
            \ 'CreateNewFile()':      ['<c-y>'],
            \ 'MarkToOpen()':         ['<c-z>'],
            \ 'OpenMulti()':          ['<c-o>'],
            \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
            \ }

let g:xterm16_colormap='soft'
let g:xterm16_brightness='high'
:syntax enable
:colorscheme transparent



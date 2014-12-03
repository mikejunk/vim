set nocompatible
set ruler
set showcmd
set showmode
set showmatch
set visualbell
set wildmenu
set notimeout
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


"===========================================================================
" MUTT
"===========================================================================


" muttaliasescomplete
let g:aliases = []
let g:aliases_files = ['~/Mail/.mutt_aliases','~/.mutt/aliases','~/.mutt/lists']
function! MuttaliasescompleteInit()
    for l:file in g:aliases_files
        call MuttaliasescompleteLoadFile(l:file)
    endfor
endfunction
function! MuttaliasescompleteLoadFile(filename)
    let a:nameMatch = glob(a:filename)
    if filereadable(a:nameMatch)
        for line in readfile(a:nameMatch)
            if match(line, 'alias') == 0
                let fields = split(line)
                call remove(fields, 0, 1)
                call add(g:aliases, join(fields, " "))
            endif
        endfor
    endif
endfunction
function! MuttaliasescompleteComplete(findstart, base)
    " cache aliases
    if g:aliases == []
        call MuttaliasescompleteInit()
    endif
    " find beginning of the current address
    if a:findstart
        let line = getline('.')
        let start = col('.') -1
        while line[start -2] != ',' && line[start -2] != ':' && start > 0
            let start -= 1
        endwhile
        return start
    endif
    " TODO check if an address is required in this line (To:, Cc:, ...)
    " complete an empty start, return all aliases
    if a:base == ''
        return g:aliases
    endif
    let matches = []
    let needle = '\c' . a:base
    for item in g:aliases
        if match(item, needle) != -1
            call add(matches, item)
        endif
    endfor
    return matches
endfunction




" my mutt canned response function(s)
" To install this, add it to ~/.vim/scripts/ or somewhere and add something like the following:
"   au BufRead /tmp/mutt-* source ~/.vim/scripts/mutt-canned.vim
"   au BufRead ./example.file source ./mutt-canned.vim
" 0) echo lol, canned response > ~/.canned/lol
" 1.a) insert canned response at current position:
"      hammer CTRL-X (twice or more) to hop through them
" 1.b) insert canned response, replacing selected text:
"      highlight something with V and then hammer CTRL-X to replace it
" 1.c) build new canned response:
"      highlight something with V and hammer CTRL-V (twice) to build a new canned response
function! Read_Canned() 
    let canned = split(glob("~/.canned/*"), "\n")
    if len(canned)
        for file in canned
            let ftok = split(file, "/")
            let bnam = substitute(ftok[-1], '\s', '_', 'g')
            exec  "menu Canned." . bnam . " :r " . file . ""
        endfor
    endif
endfunction
function! Save_Canned() range
    let lines = getline(a:firstline, a:lastline)
    echo "slurped" len(lines) "lines"
    let response = input("Response Name: ")
    call writefile(lines, expand("~/.canned/" . response))
    call Read_Canned()
endfunction
set cpo-=<
set wcm=<C-X>
call Read_Canned()
map <C-X><C-X> o<esc>:emenu Canned.<C-X>
vmap <C-X><C-X> dk:emenu Canned.<C-X>
vmap <C-V><C-V> :call Save_Canned()




" Checking attachments in edited emails for use in Mutt: warns user when exiting
autocmd BufUnload mutt-* call CheckAttachments()
function! CheckAttachments()
    let l:english = 'attach\(ing\|ed\|ment\)\?'
    let l:french = 'attach\(e\|er\|ée\?s\?\|ement\|ant\)'
    let l:ic = &ignorecase
    if (l:ic == 0)
        set ignorecase
    endif
    if (search('^\([^>|].*\)\?\<\(re-\?\)\?\(' . l:english . '\|' . l:french . '\)\>', "w") != 0)
        let l:temp = inputdialog("Do you want to attach a file? [Hit return] ")
    endif
    if (l:ic == 0)
        set noignorecase
    endif
    echo
endfunction




" my mutt aliases complete function(s)
" To install this, add it to ~/.vim/scripts/ or somewhere
" and add something like the following:
"   au BufRead /tmp/mutt-* source ~/.vim/scripts/mutt-aliases.vim
"   au BufRead ./example.file source ./mutt-aliases.vim
" Invoke the completion in insert mode with either i_CTRL-X_CTRL-U, or with
" macro: imap macro: @@ inserted by this .vim script.
" The aliases file is assumed to be ~/.aliases, or whatever your ~/.muttrc file
" says.  " You can override by setting: let g:mutt_aliases_file="~/.blarg"
let g:mutt_aliases_file="~/Mail/mutt_aliases"
fun! Read_Aliases()
    let lines = readfile(s:aliases_file)
    for line in lines
        if line =~? "^[ ]*alias "
            let tokens  = split(line)
            let alias   = tokens[1]
            let address = join(tokens[2:])

            let s:address_dictionary[alias] = address
        endif
    endfor
endfun
fun! Complete_Emails(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\S'
            let start -= 1
        endwhile
        echo "start: " start
        return start
    else
        let res = []
        for alias in keys(s:address_dictionary)
            let address = s:address_dictionary[alias]
            if alias =~? '^' . a:base    ||    address =~? '\<' . a:base
                call add(res, {'word': address, 'menu': "[" . alias . "]"})
            endif
        endfor
        return res
    endif
endfun
let s:aliases_file = "~/.aliases"
let s:address_dictionary = {}
let s:muttrc_file = expand("~/.muttrc")
if filereadable(s:muttrc_file)
    let lines = readfile(s:muttrc_file)
    for l in lines
        if l =~ '\s*set\s\+alias_file\s*='
            let ll = split(l, "=")
            silent! let le = eval(ll[1])
            let s:aliases_file = le
            break
        endif
    endfor
endif
if exists("g:mutt_aliases_file")
    let s:aliases_file = g:mutt_aliases_file
endif
let s:aliases_file = expand(s:aliases_file)
if filereadable(s:aliases_file)
    call Read_Aliases()
    set completefunc=Complete_Emails
    imap @@ <C-X><C-U>
endif




fun! CompleteEmails(findstart, base)
    if a:findstart
        let line = getline('.')
        "locate the start of the word
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[^:,]'
            let start -= 1
        endwhile
        return start
    else
        " find the addresses ustig the external tool
        " the tools must give properly formated email addresses
        let res = []
        for m in split(system('mutt-evo-query -r  ' . shellescape(a:base)), '\n')
            call add(res, m)
        endfor
        return res
    endif
endfun
fun! UserComplete(findstart, base)
    " Fetch current line
    let line = getline(line('.'))
    " Is it a special line?
    if line =~ '^\(To\|Cc\|Bcc\|From\|Reply-To\):'
        return CompleteEmails(a:findstart, a:base)
    endif
endfun
set completefunc=UserComplete







"===========================================================================
" File: 	Mail_Sig_set.vim
" Last Update:	03rd jul 2002
" Purpose:	Defines a command that deletes signatures at the end of e-mail
"               (/usenet post) replies.
" Bonus:	Defines an operator-pending mapping that will match our own
" 		signature or the end of the file. Very handy when we want to
" 		delete every line of a reply but our signature.
" 		Usage: d-- to delete till the signature/end of the file
" 		       c-- to change till the signature/end of the file
" 		       y-- to yank   till the signature/end of the file
" 		       etc.
" Installation:	Drop this file into your $HOME/vimfiles/ftplugin/mail/ 
" 		directory and invokes the EraseSignature command (either from
" 		another file, or this one -- require a little modification).
"===========================================================================
onoremap -- /\n^-- \=$\\|\%$/+0<cr>
" explaination of the pattern :
" 1- either match a new line (\n) followed by the double dashed alone on a line
" 2- or match the last line (\%: line ; $:last) the {offset} of '+0' permit to
" match the end of the new line or the very end of the file.
"---------------------------------------------------------------------------
command! -nargs=0 EraseSignature :call <sid>Erase_Sig()
" Function:	s:Erase_Sig()
" Purpose:	Delete signatures at the end of e-mail replies.
" Features:	* Does not beep when no signature is found
" 		* Also deletes the empty lines (even those beginning by '>')
" 		  preceding the signature.
"		* Do not delete the automatic signature inserted by the MUA
"		* Delete multiple signatures inserted by mailing lists
"---------------------------------------------------------------------------
function! s:Erase_Sig()
    normal G
    " position of our signature if automatically inserted by our MUA
    let s = search('^-- $', 'b')
    let s = (s!=0) ? s : line('$')+1
    " position of a signature from the replied email
    let i = s:SearchSignatureOnce( s-1, s )
    " call confirm('i='.i."  -- s=".s, '&Ok')
    " If found, then
    if i != 0
        " Try to see if an automatic signature from a mailing list has been
        " inserted
        let j = s:SearchSignatureOnce(i-1, s)
        if j != 0 | let i = j | endif
        " Finally, delete these lines plus the signature
        exe 'normal '.i.'Gd'.(s-1).'G'
    endif
endfunction
function! s:SearchSignatureOnce(l, pos_self_sig)
    " Search for the signature pattern : "^> -- $"
    exe a:l
    let i = search('^> *-- \=$', 'b')
    " If found, then
    if i != 0
        " 0- check that nothing before
        let j = search('^[^>]', 'W') 
        " call confirm('j='.j."  -- i=".i, '&Ok')
        if (j != 0) && (j<a:pos_self_sig) | return 0 | endif 
        " First, search for the last non empty (non sig) line
        while i >= 1
            let i = i - 1
            " rem : i can't value 1
            if getline(i) !~ '^\(>\s*\)*$'
                break
            endif
        endwhile
        " Second, delete these lines plus the signature
        let i = i + 1
    endif
    return i
endfunction




" Email Completion 1.02 for Vim >= 6.0
" Note: This script depends on the following basic unix tools: grep, sort, 
" uniq, wc and xargs. Feel free to hack it up for other OSs
" First create a ~/.addresses file. In this file put a list of addresses 
" separated by new lines. Duplicates will be automatically ignored.
" Load the script:
" :source /path/to/email.vim
" If you'd like the script to automatically load when editing a mutt email, 
" add the following line to your ~/vimrc:
" au BufRead /tmp/mutt* source ~/email.vim
" Then on a new line type:
" To: start_of_emai<tab>
" where "start_of_emai" is the begining of an email address listed in 
" ~/.addresses
" Map <tab>
inoremap <tab> <c-r>=TabComplete()<cr>
" Where to look for addresses
let s:addresses = '~/Mail/email.addressbook'
" Function to snag the current string under the cursor
function! SnagString( line )
    " Set column number
    let column =	col('.')-1
    " Split up line		line	start	end
    let begining = strpart(	a:line,	0, 	column)
    " Setup string		source		regex
    let string = matchstr(	begining,	'\S*$')
    return string
endfunction
" Function to match a string to an email address
function! MatchAddress(string)
    " Behold, the power unix!
    let size = system('cat '.s:addresses.' | grep -i ^'.escape(a:string,'\\').' | sort | uniq | wc -l | xargs')
    if size == 1 
        " We have an exact match!
        let address = system('cat '.s:addresses.' | grep -i ^'.escape(a:string,'\\').' | sort | uniq')
        return address
    endif
endfunction
" Function <tab> is mapped to
function! TabComplete()
    " Fetch current line
    let line = getline(line('.'))
    " Is it a special line?
    if line =~ '^\(To\|Cc\|Bcc\|From\|Reply-To\):'
        " Fetch current string under cursor
        let string = SnagString( line )
        let string_length = strlen(string)
        if string_length > 0
            " Try and match that string to an address
            let address = MatchAddress( string )
            let address_length = strlen( address )
            if address_length > 0 && string_length != address_length
                " Hot dang, we've done and got ourselves a match!
                let paste = strpart( address, string_length, address_length )
                " Convert to lower, remove trailing \n, return
                return substitute(tolower(paste),"\n","","g")
            else
                " No address matched
                return ''
            endif
        else
            " No string found, nothing to compare
            return ''
        endif
    else
        " Not an address line, return a tab
        return "\t"
    endif
endfunction




" ===========================================================================
" Vim script file
" File          : Mail_mutt_alias_set.vim
" Last update   : 01st jul 2002
" Purpose       : extract an alias from the aliases file : ~/.mutt/aliases_file
" Dependencies	: a.vim		<http://vim.sf.net/scripts>
" 		  words_tools.vim
" 		  VIM version 6.0+
"------------------------------------------------------------
" Use           : In normal mode  -> ,Ca the_alias
"                 In command mode -> :Ca the_alias
" Alternative way: In insert mode, enter <tab> after the pattern of an
" alias. If only one alias matches the current pattern, the pattern will be
" replaced by the corresponding alias. If severall patterns match, a choice
" will be given in a split window.
" Rem: 
" (*) <tab> has is classical effect on non-address lines (i.e.: not To:,
"     Cc:, Bcc: and Reply-To: lines).
" (*) Many functions stolen to the file <grep.vim> authored by Ron Aaron
"     and extended by Zdenek Sekera.
" (*) VIM version needed : works fine with VIM 6.1 under Windows-NT
" Todo:
" (*) Tag regarding a pattern : <C-t>
" (*) Test with VIM 6 under Solaris
" ===========================================================================
if exists("g:loaded_Mail_mutt_alias_set_vim") | finish | endif
let g:loaded_Mail_mutt_alias_set_vim = 1
let s:fields = '^\(To\|Cc\|Bcc\|Reply-To\):'
" ===========================================================================
" Old stuff
" command! -nargs=1 Ca :call AppendAlias(<q-args>)
" noremap ,Ca :Ca 
" ===========================================================================
" New stuff based on <tab> and a possible menu.
runtime macros/a.vim
function! s:Error(msg)
    if has("gui")
        call confirm(a:msg,'&Ok', 1, 'Error')
    else
        echohl ErrorMsg
        echo a:msg
        echohl None
    endif
endfunction
" Rem: <cword> is not really adapted, hence GetCurrentWord().
inoremap <buffer> <silent> <tab> <c-r>=<sid>MapTab(GetCurrentWord())<cr>
" Extract the address from a Mutt-alias line
function! s:Addr(the_line)
    let msk = 'alias\s\+\S\+\s\+' 
    return substitute( a:the_line, msk, '', '')
endfunction 
"----------------------------------------
" Add aliases in place of the current (previous) word.
function! s:PutAddrLines(addrs)
    let l = line('.')
    exe l.'s/\s*\S\+$//'
    exe l . "put = a:addrs"
    silent! call s:ReformatLine(l)
endfunction
function! s:ReformatLine(l)
    exe a:l.'normal $'
    let l0 = search(s:fields, 'bW')
    normal V
    /\(^\S\+:\)\|\(^\s*$\)/-1
    normal J
    s/,$//
    s/\t/ /g
    s/\s*, /,\r\t/g
    exe l0
    while (getline(l0) !~ '[^,]$') && (l0 <line('$'))
        if strlen(getline(l0)) + strlen(getline(l0+1)) <= &tw
            normal J
        endif
        normal j
        let l0 = l0 + 1
    endwhile
endfunction
" Main function
function! s:GrepAlias(the_alias)
    let buffername = $HOME . '/tmp/search-results-aliases'
    call FindOrCreateBuffer(buffername,1)	" from a.vim
    normal 1GdG
    0 put = '#Aliases corresponding to the current pattern : <'.a:the_alias . '>'
    1 put = '-none-of-these-'
    1 put = s:Help()
    " only the alias
    ""exe '$r!grep -i "alias *' . a:the_alias . ".*[\t ]\" " .expand('$HOME').  '/.mutt/aliases_file | sort'
    " Any substring except the address
    silent exe '$r!grep -i "alias *.*' . a:the_alias . "[^\t]*\t\" " .expand('$HOME').  '/.mutt/aliases_file | sort'
    silent g/^$/ d
    let result = line('$')
    " No result
    if result == s:Help_NbL()
        silent bd!
        call s:Error("\r" . 'No alias matching <'.a:the_alias.">")
        return "\<esc>a"
        " Only one result
    elseif result == s:Help_NbL() + 1
        let addr = getline(line('$'))
        silent bd!
        call s:PutAddrLines("\t".s:Addr(addr))
        return "\<esc>A"
    endif
    " Default return : several results
    silent 1,$s/alias //
    call s:Syntax(a:the_alias)
    call s:Reformat()
    exe (s:Help_NbL() + 1)
    return "\<esc>"
endfunction
" Local mappings
func! s:GrepEditFileLine(lineNum)
    if a:lineNum > 3
        let line = getline(a:lineNum)
        if (line != "-none-of-these-")
            " If there are tagged choices
            if b:NbTags != 0
                %v/^\*/d
                %s/^.\S\+\s\+//
                exe '1,'.b:NbTags.'s/$/,'
                %s/^/\t/
                normal vipy
                let addrs = @"
            else
                " Else : return the current line only
                let addrs = "\t".s:Addr('alias '.line).','
            endif
            bd!
            call s:PutAddrLines(addrs)
        else
            bd!
            echo "\r"
        endif
    endif
endfunc
" Reformat the displayed aliases
function! s:Reformat()
    set expandtab
    set tabstop=12
    retab
    %s/^\([^#][^<]*\S\)\s*\(<.*>\)/ \1\t\2/
    set tabstop=39
endfunction
" Tag / untag the current choice
function! s:ToggleTag(lineNum)
    if a:lineNum > s:Help_NbL()
        " If tagged
        if (getline(a:lineNum)[0] == '*')
            let b:NbTags = b:NbTags - 1
            silent exe a:lineNum.'s/^\*/ /'
        else
            let b:NbTags = b:NbTags + 1
            silent exe a:lineNum.'s/^ /*/'
        endif
        call s:NextChoice(1)
    endif
endfunction
" Go to the Next (/previous) possible choice.
function! s:NextChoice(isForward)
    if a:isForward == 1
        /^\( \|\*\)\S\+/
    else
        ?^\( \|\*\)\S\+?
    endif
endfunction
" Mappings for the menu buffer
" Maps for the (splitted) choice window
" Rem: The first '<silent>' disable the display of ':silent call ...'
"      The second ':silent' disable the displays coming from The execution
"      of the functions.
func! s:GrepEnterBuf()
    let b:NbTags = 0
    " map <enter> to edit a file, also dbl-click
    nnoremap <silent> <buffer> <esc>         :silent call <sid>GrepEditFileLine(<sid>Help_NbL())<cr>
    nnoremap <silent> <buffer> <cr>          :silent call <sid>GrepEditFileLine(line("."))<cr>
    nnoremap <silent> <buffer> <2-LeftMouse> :silent call <sid>GrepEditFileLine(line("."))<cr>
    " nnoremap <silent> <buffer> Q	  :call <sid>Reformat()<cr>
    nnoremap <silent> <buffer> <Left>	  :set tabstop-=1<cr>
    nnoremap <silent> <buffer> <Right>	  :set tabstop+=1<cr>
    nnoremap <silent> <buffer> t	  :silent call <sid>ToggleTag(line("."))<cr>
    nnoremap <silent> <buffer> <tab>	  :silent call <sid>NextChoice(1)<cr>
    nnoremap <silent> <buffer> <S-tab>	  :silent call <sid>NextChoice(0)<cr>
    nnoremap <silent> <buffer> h	  :silent call <sid>ToggleHelp()<cr>
endfunc
aug MuttAliases_GrepBuf
    au!
    au BufEnter search-results-* call <sid>GrepEnterBuf()
aug END
"----------------------------------------
" Looks if the header-field of the current line is either To:, Cc: or Bcc:
function! s:MapTab(the_alias)
    if (strlen(a:the_alias) == 0)  || (a:the_alias !~ '^\S*$')
        " echo "-" . a:the_alias . "-\n"
        return "\t"
    endif
    let l = line('.')
    while l != 0
        let ll = getline(l)			" Current line
        if ll =~ '^\S\+:'			" ¿ Is an field ?
            if ll =~ s:fields			"   ¿ Is an address field ?
                return s:GrepAlias(a:the_alias)	"     Then grep the alias
                " let r = s:GrepAlias(a:the_alias)"     Then grep the alias
                " if "\<esc>a" != r | return r
                " else              | return r."\t"
                " endif
            else   | return "\t"		"     Otherwise, return <tab>
            endif
        else   | let l = l - 1		"   Otherwise, test previous line
        endif
    endwhile
endfunction
" Syntax for the (splitted) choice window.
function! s:Syntax(...)
    if has("syntax")
        syn clear
        if a:0 > 0
            " exe 'syntax region GrepFind start=+\(^\|<\)+ end=/' . a:1 . '>\=/'
            exe 'syntax match GrepFind /' . a:1 . '/ contained'
        endif
        syntax region GrepLine  start='.' end='$' contains=GrepAlias
        syntax match GrepAlias /^./ contained nextgroup=GrepName contains=GrepFind
        syntax match GrepName /[^<]\+/ contained nextgroup=GrepAddress contains=GrepFind
        syntax region GrepAddress start='<' end='>' contained 
        syntax region GrepExplain start='#' end='$' contains=GrepStart,GrepFind
        syntax match GrepStart /#/ contained
        syntax match Statement /-none-of-these-/
        highlight link GrepExplain Comment
        highlight link GrepFind Search
        highlight link GrepStart Ignore
        highlight link GrepLine Normal
        highlight link GrepAlias SpecialChar
        highlight link GrepAddress Identifier
    endif
endfunction
" Help
function! s:Add2help(msg, help_var)
    if (!exists(a:help_var))
        exe 'let ' . a:help_var . '   = a:msg'
        exe 'let ' . a:help_var . 'NB = 0'
    else
        exe 'let ' . a:help_var . ' = ' . a:help_var . '."\n" . a:msg'
    endif
    exe 'let ' . a:help_var . 'NB = ' . a:help_var . 'NB + 1 '
endfunction
if !exists(":MUAAHM")
    command! -nargs=1 MUAAHM call <sid>Add2help(<args>,"s:muaa_help")
    MUAAHM  "#| <cr>, <double-click> : Insert the current alias"
    MUAAHM  "#| <esc>                : Abort"
    MUAAHM  "#| <t>                  : (un)tag the current alias"
    MUAAHM  "#| <up>, <down>, <tab>  : Move between entries"
    MUAAHM  "#| <right>, <left>      : Change the tab stop alignment"
    MUAAHM  "#|"
    MUAAHM  "#| h                    : Don't display this help"
    MUAAHM  "#+-----------------------------------------------------------------------------"
    MUAAHM  "#"
    command! -nargs=1 MUAAHM call <sid>Add2help(<args>,"s:muaa_short_help")
    MUAAHM  "#| h                    : Display the help"
    MUAAHM  "#+-----------------------------------------------------------------------------"
    MUAAHM  "#"
endif
function! s:Help()
    if s:display_long_help	| return s:muaa_help
    else				| return s:muaa_short_help
    endif
endfunction
function! s:Help_NbL()
    " return 1 + nb lignes of BuildHelp
    if s:display_long_help	| return 2 + s:muaa_helpNB
    else				| return 2 + s:muaa_short_helpNB
    endif
endfunction
let s:display_long_help = 0
function! s:ToggleHelp()
    let s:display_long_help = 1 - s:display_long_help
    silent call s:RedisplayHelp()
endfunction
function! s:RedisplayHelp()
    2,$g/^#/d
    1 put = s:Help()
endfunction


"==============================================================================
" WHITEWASH
"==============================================================================


" WhiteWash.vim
" Remove trailing whitespace and sequential whitespace between words.
function! s:WhiteWash()
	let l:save_cursor = getpos(".")
	call s:WhiteWashTrailing()
	if exists("g:WhiteWash_Aggressive") && (g:WhiteWash_Aggressive)
		call s:WhiteWashAggressive()
	else
		call s:WhiteWashLazy()
	endif
	call setpos('.', l:save_cursor)
endfunction
function! s:WhiteWashTrailing()
	%s/\s\+$//e
endfunction
function! s:WhiteWashLazy()
	%s/\>\s\{2,\}/ /eg
endfunction
function! s:WhiteWashAggressive()
	%s/\(\S\)\s\{2,\}/\1 /eg
endfunction
command! -range=% WhiteWash :silent call <SID>WhiteWash()
command! -range=% WhiteWashAggressive :silent call <SID>WhiteWashAggressive()
command! -range=% WhiteWashLazy :silent call <SID>WhiteWashLazy()
command! -range=% WhiteWashTrailing :silent call <SID>WhiteWashTrailing()


"==============================================================================
" END
"==============================================================================


let g:mail_mutt_alias_file="/home/Michael/Mail/.mutt_aliases"

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
"let g:ConqueTerm_TERM = 'vt100'
let g:ConqueTerm_TERM='xterm-256color'
let g:ConqueTerm_PyExe='/usr/bin/python.exe'
let g:ConqueTerm_ColorMode='conceal'

let g:airline_theme='powerlineish'

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


let g:xterm16_colormap='soft' "'soft', 'softlight', 'standard', 'allblue'
let g:xterm16_brightness='high' "'low', 'med', 'high', 'default', custom
set background=dark
colorscheme xterm16


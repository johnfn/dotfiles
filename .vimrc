"function! InstaOpenNote()
"  "Go straight to the file.
"  if @% == "NERD_tree_1"
"    return "<CR><CR>"
"  end
"  return "<CR>"
"endfunction

"function! LoadNT()
"  if argv()[0] == "notes"
"
"    "Search through notes with \f (also works generally...)
"    :map \f :copen<CR><C-W>k:vimgrep  *<left><left>
"    :map <CR> :call InstaOpenNote()
"    NERDTree ~/notes
"  end
"endfunction

set nocompatible
filetype plugin indent on 
syntax on

"autocmd VimEnter * call LoadNT()

autocmd BufRead,BufNewFile *.clj nmap xyz <Plug>ClojureEvalToplevel

autocmd VimEnter *.js TlistToggle

"Make taglist play nice with JS.
let g:tlist_javascript_settings = 'javascript;r:var;s:string;a:array;o:object;u:function'

"filetype off
"call pathogen#runtime_append_all_bundles()

:map <F4> :w<CR>:!python %<CR>
"clojure
:map <F5> :w<CR>:!clj %<CR>

"Run jslint and open it in new buffer
:map <F6> :w<CR>:bdelete OUT_TEMP<CR>:!rm OUT_TEMP<CR>:!./jslint > OUT_TEMP<CR>:split OUT_TEMP<CR>
"Run jslint (first time) - can't figure out how to make bdelete silent...
"TODO?
":map <F7> :w<CR>:!rm OUT_TEMP<CR>:!rhino jslint.js % > OUT_TEMP<CR>:split OUT_TEMP<CR>

"c++
:map <F7> :w!<CR>:!g++ % && ./a.out<CR>

:map <tab> gt
:map <s-tab> gT
:map :tn :TlistAddFiles

"Settings

:set mouse=a
:set number
:set tabstop=2
:set shiftwidth=2
:set autoindent
:set incsearch
:set smarttab
:set expandtab
:set softtabstop=2



:let g:vimclojure#ParenRainbow = 1
:let g:vimclojure#HighlightBuiltins = 1
:let g:vimclojure#WantNailgun = 1
:let g:vimclojure#NailgunClient = "/home/grant/.vim/vimclojure-nailgun-client/ng"
:let vimclojure#SplitPos = "bottom"

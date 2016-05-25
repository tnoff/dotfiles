scriptencoding utf-8
set nocompatible

set tabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start

set colorcolumn=150

execute pathogen#infect()
let g:syntastic_check_on_open=0
let g:syntastic_auto_loc_list=1
let g:syntastic_python_checkers=['pylint']
let g:syntastic_enable_highlighting = 1

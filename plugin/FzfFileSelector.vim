scriptencoding utf-8
if exists('g:load_VimJKMotion')
 finish
endif
let g:load_VimJKMotion = 1

let s:save_cpo = &cpo
set cpo&vim

:lua require('VimJKMotion').show_target()
nnoremap <silent> <Plug>vim-jk-motion :lua require('VimJKMotion').motion()<cr>
vnoremap <silent> <Plug>vim-jk-motion :lua require('VimJKMotion').motion_visual()<cr>
nnoremap <silent> ; <Plug>vim-jk-motion
vnoremap <silent> ; <Plug>vim-jk-motion

let &cpo = s:save_cpo
unlet s:save_cpo

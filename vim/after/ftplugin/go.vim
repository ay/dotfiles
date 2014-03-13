setlocal shiftwidth=4
setlocal softtabstop=0
setlocal noexpandtab
setlocal nolist

" Since we don't see trailing whitespace because of nolist, highlight any
" extra whitespace in red instead.
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

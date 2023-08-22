command! -nargs=1 ClipboardBrowse call clipboardManager#ClipboardBrowse(<args>)
command! ShowClipboard call clipboardManager#ShowClipboard()
command! ClearClipboard call clipboardManager#ClearClipboard()

" Define the default key mappings
nnoremap <S-Left> :ClipboardBrowse -1<cr>
nnoremap <S-Right> :ClipboardBrowse 1<cr>
nnoremap <c-b>3 :ClipboardBrowse 3<cr>
nnoremap <c-b>5 :ClipboardBrowse 5<cr>
nnoremap <c-b>9 :ClipboardBrowse 9<cr>

augroup SaveText
	au!
	autocmd TextYankPost * call clipboardManager#SaveClipboard()
augroup END

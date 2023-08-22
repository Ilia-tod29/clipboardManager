command! -nargs=1 ClipboardBrowse call clipboardManager#BrowseClipboard(<args>)
command! ClipboardShow call clipboardManager#ShowClipboard()
command! ClipboardClear call clipboardManager#ClearClipboard()

" Define the default key mappings
nnoremap <S-Left> :ClipboardBrowse -1<cr>
nnoremap <S-Right> :ClipboardBrowse 1<cr>
nnoremap <c-b>3 :ClipboardBrowse 3<cr>
nnoremap <c-b>5 :ClipboardBrowse 5<cr>
nnoremap <c-b>9 :ClipboardBrowse 9<cr>

augroup SaveText
	au!
	autocmd TextYankPost * call clipboardManager#SaveClipboard()
	autocmd CursorMoved * call clipboardManager#SaveClipboard()
augroup END


augroup SaveClipboardToReg
	au!
	autocmd VimLeavePre * call clipboardManager#SaveClipboardOnQuit()
augroup END


augroup RestoreClipboard
	au!
	autocmd VimEnter * call clipboardManager#LoadClipboardOnStart()
augroup END

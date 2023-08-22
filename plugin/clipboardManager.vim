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


let s:clipboardHistory = []
let s:clipboardPosition = -1

function! clipboardManager#SaveClipboard()
	" Check if the clipboard exists in the current window
	if exists('+clipboard') && (&clipboard == 'unnamed,unnamedplus' || &clipboard == 'unnamed')
		let clip = getreg('+')

		if !empty(clip) && (empty(s:clipboardHistory) || clip != s:clipboardHistory[0])
			if len(s:clipboardHistory) == 40
				call remove(s:clipboardHistory, 39)
			endif

			let s:clipboardHistory = [clip] + s:clipboardHistory
		endif
	endif
endfunction

function! clipboardManager#BrowseClipboard(step)
	if empty(s:clipboardHistory)
		echo "Clipboard is empty."
		return
	endif

	let newPosition = s:clipboardPosition + a:step

	if newPosition < 0
		let newPosition = len(s:clipboardHistory) + (newPosition % len(s:clipboardHistory))
	endif
	if newPosition >= len(s:clipboardHistory)
		let newPosition = newPosition % len(s:clipboardHistory)
	endif

	let s:clipboardPosition = newPosition
	let selectedClip = s:clipboardHistory[s:clipboardPosition]
	call setreg('+', selectedClip)
	echomsg 'Pasting clipboard element: ' .. (s:clipboardPosition + 1) .. '/' .. len(s:clipboardHistory) .. " -> " .. strpart(s:clipboardHistory[s:clipboardPosition], 0, 150)
endfunction

function! clipboardManager#ShowClipboard()
	echomsg "Items: " .. len(s:clipboardHistory)
	echomsg "Clipboard history: "

	let counter = 1
	for element in s:clipboardHistory
		let toPrint = strpart(element, 0, 150)
		echomsg counter .. ": " ..toPrint

		let counter += 1
	endfor
endfunction

function! clipboardManager#ClearClipboard()
	let s:clipboardHistory = []
	echomsg "Clipboard cleared!"
endfunction

function! clipboardManager#SaveClipboardOnQuit()
	" Save the current clipboard to register 'z'
	call setreg('z', string(s:clipboardHistory))
endfunction

function! clipboardManager#LoadClipboardOnStart()
	" Read the 'z' register to restore the clipboard
	let restoredHistoryString = getreg('z')
	let restoredHistory = eval(restoredHistoryString)

	" Check if the restored clipboard is actually array
	if type(restoredHistory) == 3
		let s:clipboardHistory = restoredHistory
		let currentYank = getreg('+')

		if empty(s:clipboardHistory) || s:clipboardHistory[0] != currentYank
			call clipboardManager#SaveClipboard()
		endif
	else
		echo "Clipboard history lost."
		let s:clipboardHistory = []
	endif
endfunction

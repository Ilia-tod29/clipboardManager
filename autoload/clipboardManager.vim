let s:clipboard_history = []
let s:clipboard_position = -1

function! clipboardManager#SaveClipboard()
	if exists('+clipboard') && &clipboard == 'unnamed,unnamedplus'
		let clip = getreg('+')
		if !empty(clip)
			if len(s:clipboard_history) == 40
				call remove(s:clipboard_history, 39)
			endif	
			let s:clipboard_history = [clip] + s:clipboard_history 
		endif
	endif
endfunction

function! clipboardManager#ClipboardBrowse(step)
	if empty(s:clipboard_history)
		echo "Clipboard is empty."
		return
	endif
	let new_pos = s:clipboard_position + a:step
	if new_pos < 0
		let new_pos = 0
	elseif new_pos >= len(s:clipboard_history)
		echomsg "No more elements. Starting from the beggining."
		let new_pos = new_pos % len(s:clipboard_history)
	endif
	let s:clipboard_position = new_pos
	let selected_clip = s:clipboard_history[s:clipboard_position]
	call setreg('+', selected_clip)
	echomsg 'Pasting clipboard element: ' .. (s:clipboard_position + 1) .. '/' .. len(s:clipboard_history) .. " -> " .. strpart(s:clipboard_history[s:clipboard_position], 0, 150)
endfunction

function! clipboardManager#ShowClipboard()
	echomsg "Items: " .. len(s:clipboard_history)
	echomsg "Clipboard history: "

	let counter = 1
	for element in s:clipboard_history
		let toPrint = strpart(element, 0, 150)
		echomsg counter .. ": " ..toPrint
		let counter += 1
	endfor
endfunction

function! clipboardManager#ClearClipboard()
	let s:clipboard_history = []
	echomsg "Clipboard cleared!"
endfunction

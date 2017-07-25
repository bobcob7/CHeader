"============================================================================
"File:        CHeader.vim
"Description: Vim plugin for quickly showing corresponding header files
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Eric Suedmier.
"
"============================================================================

func! s:findExtensionPoint(filename)
	let l:flen = len(a:filename)
	let l:i = l:flen-1
	while l:i>=0
		if a:filename[l:i]=='.'
			return l:i
		endif
		let l:i-=1
	endwhile
endfunc

func! s:removeExtension(filename)
	let l:point = s:findExtensionPoint(a:filename)
	return strpart(a:filename,0,l:point)
endfunc

func! OpenCFile()
	if exists('t:CFile')
		" close down CFile explorer window
		let cwinnr = bufwinnr(t:CFile)
		if cwinnr != -1
			let curwin = winnr()
			exe cwinnr."wincmd w"
			close
			exe curwin."wincmd w"
		endif
		unlet t:CFile
	else
		let l:filename = s:removeExtension(@%)
		echo l:filename
		if matchstr(@%, '.c',2) != ''
			if filereadable(l:filename.'.h')
				exe 'vsplit '.l:filename.'.h'
				let t:CFile = bufnr("%")
			elseif filereadable(l:filename.'.hpp')
				exe 'vsplit '.l:filename.'.hpp'
				let t:CFile = bufnr("%")
			else
				echo 'Could not find header file'
			endif
		elseif matchstr(@%, '.h', 2) != ''
			if filereadable(l:filename.'.c')
				exe 'vsplit '.l:filename.'.c'
				let t:CFile = bufnr("%")
			elseif filereadable(l:filename.'.cpp')
				exe 'vsplit '.l:filename.'.cpp'
				let t:CFile = bufnr("%")
			else
				echo 'Could not find source file'
			endif
		elseif matchstr(@%, '.cpp',4) != ''
			if filereadable(l:filename.'.hpp')
				exe 'vsplit '.l:filename.'.hpp'
				let t:CFile = bufnr("%")
			elseif filereadable(l:filename.'.h')
				exe 'vsplit '.l:filename.'.h'
				let t:CFile = bufnr("%")
			else
				echo 'Could not find header file'
			endif
		elseif matchstr(@%, '.hpp', 2) != ''
			if filereadable(l:filename.'.cpp')
				exe 'vsplit '.l:filename.'.cpp'
				let t:CFile = bufnr("%")
			elseif filereadable(l:filename.'.c')
				exe 'vsplit '.l:filename.'.c'
				let t:CFile = bufnr("%")
			else
				echo 'Could not find source file'
			endif
		else
			echo 'Nothing to do'
		endif
	endif
endfunc
map <silent> <C-H> :call OpenCFile()<CR>

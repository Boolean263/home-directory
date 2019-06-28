" The functions in this file are used to test if the user is editing
" a script with a shebang line, and if they are, makes it executable
" when they save it.

" See if the file is already executable, returns true if not
function! MyFileTestExecutable (fname)
  execute "silent! !test -x" a:fname
  return ! v:shell_error
endfunction

" Test the passed-in line to see if it's a valid shebang line
function! MySetExecutableIfScript(line1, current_file)
  if a:line1 =~ '^#![ \t]*\(/usr\(/local\)*\)*/bin/' && ! MyFileTestExecutable(a:current_file)
    let chmod_command = "silent! !chmod a+x " . a:current_file
    execute chmod_command
    " reopen the file to suppress vim's "mode changed" warning
    silent! edit!
    silent! syn on
  endif
endfunction

" The autocmd that makes the magic happen
augroup xbit
    autocmd!
    autocmd BufWritePost * call MySetExecutableIfScript(getline(1), expand("%:p"))
augroup END

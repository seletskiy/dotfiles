delfunction ale#fix#ApplyFixes

function! ale#fix#ApplyFixes(buffer, output) abort
    let l:data = g:ale_fix_buffer_data[a:buffer]
    let l:data.output = a:output
    let l:data.changes_made = l:data.lines_before !=# l:data.output " no-custom-checks
    let l:data.done = 1

    call ale#command#RemoveManagedFiles(a:buffer)

    if !bufexists(a:buffer)
        " Remove the buffer data when it doesn't exist.
        call remove(g:ale_fix_buffer_data, a:buffer)
    endif

    if l:data.changes_made && bufexists(a:buffer)
        let l:lines = getbufline(a:buffer, 1, '$')

        if l:data.lines_before != l:lines
            call remove(g:ale_fix_buffer_data, a:buffer)
            " NO ERROR, I'M JUST WORKING
            " execute 'echoerr ''The file was changed before fixing finished'''
            return
        endif
    endif

    " We can only change the lines of a buffer which is currently open,
    " so try and apply the fixes to the current buffer.
    call ale#fix#ApplyQueuedFixes(a:buffer)
endfunction


function! wildgitignore#load()
    let cwd = getcwd()
    let gitignore_path = cwd . '/.gitignore'

    call s:BuildWildignore(gitignore_path)
endfunction

function! s:BuildWildignore(gitignore_path)
    let ignore = '.git,'

    for gline in readfile(a:gitignore_path)
        let line = substitute(gline, '\s|\n|\r', '', "g")

        " 1. Ignore comments (starting with #)
        " 2. Ignore empty lines
        " 3. Ignore negated patterns, no such support in wildignore
        " 4. Ignore lines with comma, that corrupts wildignore
        if line =~ '^#' || line == '' || line =~ '^!' || line =~ ","
            continue
        endif

        if line =~ '/$'
            let line = trim(line, '/')
        endif

        let ignore .= line . ','
    endfor

    let ignore = substitute(ignore, ',$', '', 'g')
    exec "set wildignore+=" . ignore
endfunction

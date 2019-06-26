let s:original_wildignore = &wildignore

function! wildgitignore#load()
    let cwd = getcwd()
    let gitignore_path = cwd . '/.gitignore'

    call s:WildignoreFromGitignore(gitignore_path)
endfunction

function! s:WildignoreFromGitignore(gitignore_path)
    if !filereadable(a:gitignore_path)
        return
    endif

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
    exec "set wildignore=" . s:original_wildignore . ',' . ignore
endfunction

augroup wildgitignorefromgitignore_fugitive
    autocmd!
    autocmd User Fugitive if exists('b:git_dir') | call <SID>WildignoreFromGitignore(fnamemodify(b:git_dir, ':h') . '/.gitignore') | endif
augroup END

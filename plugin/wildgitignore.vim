if exists("g:wildgitignore")
    finish
endif

let g:wildgitignore = 1

call wildgitignore#load()

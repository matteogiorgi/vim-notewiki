setlocal wrap
setlocal conceallevel=2


" nmap <buffer> <leader>ni <Plug>(NoteWiki)
" nmap <buffer> <leader>nb <Plug>(NoteBrowse)<cr>
" nmap <buffer> <leader>np <Plug>(NotePandoc)<cr>

command! <buffer> NoteWiki   <Plug>(NoteWiki)
command! <buffer> NoteBrowse <Plug>(NoteBrowse)<cr>
command! <buffer> NotePandoc <Plug>(NotePandoc)<cr>

nmap <buffer> <tab> <Plug>(NextLink)
nmap <buffer> <S-tab> <Plug>(PrevLink)
nmap <buffer> <backspace> <Plug>(Back)
nmap <buffer> <return> <Plug>(OpenLink)
nmap <buffer> \ <Plug>(EndPar)

nnoremap <buffer> - :HeaderIncrease<cr>
nnoremap <buffer> _ :HeaderDecrease<cr>

noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj

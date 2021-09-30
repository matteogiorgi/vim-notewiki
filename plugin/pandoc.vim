" notewiki-plugin location
let $plugged = 'plugged'


" NotePandoc{{{
function! s:NotePandoc(format) abort
    let l:prefix = expand('%:p:h')
    let l:currfile = expand('%:p')

    let $prefix = fnamemodify(l:prefix, ':p')
    let $prefixtail = fnamemodify(l:prefix, ':t')
    let $currfile = fnamemodify(l:currfile, ':p')

	if &filetype ==? 'markdown' || &filetype ==? 'markdown.pandoc' || &filetype ==? 'pandoc'
	    if a:format ==? 'pdf'
            let l:pdf = l:prefix . '/pdf'
            let $pdf = fnamemodify(l:pdf, ':p')
            if !isdirectory($pdf)
                if has('nvim')
                    !cp -R $HOME/.config/nvim/$plugged/vim-notewiki/utils/pdf $prefix
                else
                    !cp -R $HOME/.vim/$plugged/vim-notewiki/utils/pdf $prefix
                endif
            endif
            !pandoc $currfile -s --to=pdf -o $pdf/%:t:r.pdf
                        \ --pdf-engine=lualatex
                        \ --lua-filter=$pdf/assets/tcolorbox.lua
                        \ --highlight-style=$pdf/assets/dracula.theme
                        \ --metadata-file=$pdf/assets/pdf.yaml
        elseif a:format ==? 'html'
            let l:html = l:prefix . '/html'
            let $html = fnamemodify(l:html, ':p')
            if !isdirectory($html)
                if has('nvim')
                    !cp -R $HOME/.config/nvim/$plugged/vim-notewiki/utils/html $prefix
                else
                    !cp -R $HOME/.vim/$plugged/vim-notewiki/utils/html $prefix
                endif
            endif
            !pandoc $currfile -s --to=html5 -o $html/%:t:r.html
                        \ --mathjax
                        \ --highlight-style=$html/assets/dracula.theme
                        \ -c assets/style.css
                        \ --lua-filter=$html/assets/link2html.lua
                        \ -B $html/assets/prebody.html
                        \ -A $html/assets/footer.html
                        \ -H $html/assets/header.html
                        \ -T $prefixtail
        endif
    else
        echomsg 'This is not the file you are looking for.'
    endif
endfunction
"}}}


" Commands{{{
nnoremap <silent> <Plug>(PdfDocument) :call <SID>NotePandoc('pdf')
nnoremap <silent> <Plug>(HtmlPage) :call <SID>NotePandoc('html')
"}}}

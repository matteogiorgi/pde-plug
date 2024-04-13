" plug.vim: simple viml-script that sets basic configuration
" for installed plugins (Vim 9.0+ required just for copilot).
" ---
" COMMENTARY https://github.com/tpope/vim-commentary
" SURROUND   https://github.com/tpope/vim-surround
" REPEAT     https://github.com/tpope/vim-repeat
" LEXIMA     https://github.com/cohama/lexima.vim
" CONTEXT    https://github.com/wellle/context.vim
" SIGNIFY    https://github.com/mhinz/vim-signify
" ALE        https://github.com/dense-analysis/ale
" CTRLP      https://github.com/ctrlpvim/ctrlp.vim
" COPILOT    https://github.com/github/copilot.vim




" INIT {{{
if exists("g:plugme")
    finish
endif
let g:plugme = 1
" ---
function! s:MakeNote()
    let l:path_file   = expand('%:p')
    let l:path_parent = expand('%:p:h')
    let l:path_notes  = l:path_parent . '/notes'
    let $FILE   = fnamemodify(l:path_file, ':p')
    let $PARENT = fnamemodify(l:path_parent, ':p')
    let $PREFIX = fnamemodify(l:path_parent, ':t')
    let $NOTES  = fnamemodify(l:path_notes, ':p')
    if empty(glob(l:path_parent . '/*.md'))
        echo 'no markdown found inside ' . l:path_parent
        return
    endif
    if !isdirectory($NOTES)
        execute 'silent !cp -R $HOME/.vim/plugin/notes $PARENT'
    endif
    execute 'silent !$NOTES/assets/makenote %:t:r'
    redraw!
    redrawstatus!
    redrawtabline
    echo 'notes archived in ' . l:path_notes
endfunction
" ---
command! MakeNote call <SID>MakeNote()
"}}}




" SIGNIFY {{{
if &rtp =~ 'signify'
    nnoremap <silent><C-n> <plug>(signify-next-hunk)
    nnoremap <silent><C-p> <plug>(signify-prev-hunk)
    nnoremap <leader>g :SignifyDiff<CR>
    nnoremap <leader>v :SignifyHunkDiff<CR>
    nnoremap <leader>b :SignifyHunkUndo<CR>
endif
" }}}




" ALE {{{
if &rtp =~ 'ale'
    function! s:ToggleLL()
        let g:quickfix = 'cclose'
        let g:loclist = !exists("g:loclist") || g:loclist ==# 'lclose' ? 'lopen' : 'lclose'
        silent! execute g:quickfix
        silent! execute g:loclist
    endfunction
    " ---
    let g:ale_completion_enabled = 1
    set omnifunc=ale#completion#OmniFunc
    set completeopt=menu,menuone,popup,noselect,noinsert
    " ---
    augroup ale_ominfunc
        autocmd FileType python,c,bash setlocal omnifunc=ale#completion#OmniFunc
    augroup END
    " ---
    let g:ale_linters = {'python': ['pylsp'], 'c': ['gcc'], 'bash': ['shellcheck']}
    let g:ale_fixers = {'python': ['black'], '*': ['remove_trailing_lines', 'trim_whitespace']}
    let g:ale_echo_msg_format = '[%linter% %severity%] %s'
    let g:ale_virtualtext_cursor = 0
    let g:ale_fix_on_save = 1
    let g:ale_lsp_suggestions = 1
    " ---
    inoremap <silent><C-c> :AleComplete<CR>
    nnoremap <silent><C-l> :ALENextWrap<CR>
    nnoremap <silent><C-h> :ALEPreviousWrap<CR>
    nnoremap <localleader>a :call <SID>ToggleLL()<CR>
    nnoremap <leader>s :ALEFindReferences<CR>
    nnoremap <leader>d :ALEGoToDefinition<CR>
endif
" }}}




" CTRLP {{{
if &rtp =~ 'ctrlp'
    function! s:Ctags()
        if !executable('ctags')
            echo "ctags not installed"
            return
        endif
        execute 'silent !ctags -R --exclude=.git'
        redraw!|redrawstatus!|redrawtabline
        echo "ctags executed"
    endfunction
    " ---
    let g:ctrlp_map = ''
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_show_hidden = 1
    let g:ctrlp_custom_ignore = {
        \      'dir': '\v[\/]\.(git|hg|svn|mypy_cache)$',
        \      'file': '\v\.(exe|so|dll)$'
        \ }
    " ---
    augroup netrw_prettyfier
        autocmd FileType netrw nmap <buffer> <leader>f :CtrlP<space>%:p:h<CR>
    augroup end
    " ---
    command! Ctags call s:Ctags()
    nnoremap <leader>a :CtrlPQuickfix<CR>
    nnoremap <leader>u :CtrlPUndo<CR>
    nnoremap <leader>i :CtrlPChange<CR>
    nnoremap <leader>f :CtrlP<space>%:p:h<CR>
    nnoremap <leader>h :CtrlPMRUFiles<CR>
    nnoremap <leader>j :CtrlPBuffer<CR>
    nnoremap <leader>k :CtrlPTag<CR>
    nnoremap <leader>l :CtrlPLine<CR>
endif
" }}}




" COPILOT {{{
if &rtp =~ 'copilot'
    function! s:SuggestWord()
        let suggestion = copilot#Accept("")
        let textsuggested = copilot#TextQueuedForInsertion()
        return textsuggested ==# '' ? '' : split(textsuggested, '[ .()\[\]{}]\zs')[0]
    endfunction
    " ---
    function! s:CopilotPanel()
        let l:panel_status = len(filter(range(1, bufnr('$')),
            \ 'bufexists(v:val) && bufname(v:val) =~# "^copilot:///"')) > 0
        let g:copilot_panel = l:panel_status ? 'close' : 'Copilot panel'
        silent! execute g:copilot_panel
    endfunction
    " ---
    let g:copilot_enabled = v:true
    nnoremap <localleader>c :call <SID>CopilotPanel()<CR>
    " ---
    inoremap <silent><C-s> <Plug>(copilot-suggest)
    inoremap <silent><C-d> <Plug>(copilot-dismiss)
    inoremap <silent><C-h> <C-w>
    inoremap <silent><C-j> <Plug>(copilot-next)
    inoremap <silent><C-k> <Plug>(copilot-previous)
    inoremap <script><expr> <C-l> <SID>SuggestWord()
endif
" }}}

" vim: fdm=marker:sw=2:sts=2:et

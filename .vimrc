call plug#begin('~/.vim/plugged')

Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Townk/vim-autoclose'
Plug 'w0rp/ale'

" color scheme
Plug 'sjl/badwolf'
Plug 'tomasr/molokai'
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'w0ng/vim-hybrid'
Plug 'jpo/vim-railscasts-theme'

call plug#end()

filetype plugin indent on
syntax enable

set t_Co=256
" syntax on "コードの色分け
" autocmd ColorScheme * highlight Normal ctermbg=none
" autocmd ColorScheme * highlight LineNr ctermbg=none
" set background=dark
colorscheme badwolf

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
set ambiwidth=double " □や○文字が崩れる問題を解決

set expandtab "タブをスペースに変換
set tabstop=2 "インデントをスペース2つ分に設定
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "自動インデント
set smartindent "自動インデント
set shiftwidth=2 "自動インデントでずれる幅

set backspace=start,eol,indent
set number "行番号を表示する
set list "空白文字を表示する
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set notitle "タイトルの非表示
set showmatch "括弧入力時の対応する括弧を表示

" Load settings for each location.
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

source ~/.vim/snippet.vim

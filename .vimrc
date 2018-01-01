if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein')

  call dein#add('~/.vim/dein')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#add('ConradIrwin/vim-bracketed-paste')
  call dein#add('scrooloose/nerdtree')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Townk/vim-autoclose')
  call dein#add('w0rp/ale')

  " color scheme
  call dein#add('sjl/badwolf')
  call dein#add('tomasr/molokai')
  call dein#add('joshdick/onedark.vim')
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('w0ng/vim-hybrid')
  call dein#add('jpo/vim-railscasts-theme')

  call dein#end()
  call dein#save_state()
endif

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

source ~/.vim/complete.vim
source ~/.vim/snippet.vim

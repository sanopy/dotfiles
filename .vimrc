" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'Townk/vim-autoclose'

" color scheme
NeoBundle 'sjl/badwolf'
NeoBundle 'tomasr/molokai'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'jpo/vim-railscasts-theme'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

set t_Co=256
syntax on "コードの色分け
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
set background=dark
colorscheme badwolf

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
set ambiwidth=double " □や○文字が崩れる問題を解決

set expandtab "タブをスペースに変換
set tabstop=2 "インデントをスペース2つ分に設定
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set cindent "自動インデント
set shiftwidth=2 "自動インデントでずれる幅

set backspace=start,eol,indent
set number "行番号を表示する
set list "空白文字を表示する
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set notitle "タイトルの非表示
set showmatch "括弧入力時の対応する括弧を表示

;;; init.el --- My configurations for Emacs

;;; Commentary:

;;;; How to set up my configurations for Emacs?
;; $ cd ~/.emacs.d
;; $ cask install

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; ツールバー非表示
;(tool-bar-mode -1)

;; メニューバー非表示
;(menu-bar-mode -1)

;; フレームタイトル
(setq frame-title-format
      (concat "%b - emacs@" system-name))

;; スタートアップメッセージを表示しない
(setq inhibit-startup-message t)

;; 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)

;; ガベージコレクションの発動頻度設定
(setq gc-cons-threshold (* 512 1024 1024))

(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 800000)
            (garbage-collect)))

;; 行番号表示
(require 'linum)
(global-linum-mode 1)

;; カーソル行をハイライトする
;(global-hl-line-mode t)

;; モードラインに行番号表示
(line-number-mode t)
;; モードラインに列番号表示
(column-number-mode t)
;; モードラインに時計を表示
(display-time)

;; 括弧の範囲内を強調表示
(show-paren-mode t)
;; (setq show-paren-delay 0)
;; (setq show-paren-style 'expression)

;; 行末のスペースを強調表示
(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))

;; 保存前 行末空白削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 最終行に必ず一行挿入する
(setq require-final-newline t)

;; 言語環境設定
(set-language-environment "Japanese")
;; デフォルト文字コード
(prefer-coding-system 'utf-8)
;; フォント設定
(add-to-list 'default-frame-alist '(font . "Ricty" ))
(set-face-attribute 'default t :font "Ricty" )

;; tab ではなく space を使う
(setq-default indent-tabs-mode nil)
;; tab 幅を 2 に設定
(setq-default tab-width 2)
;; アセンブリ言語モードのとき タブ幅8
(add-hook 'asm-mode-hook
          '(lambda ()
             (setq tab-width 8)
             (setq tab-stop-list (number-sequence 8 160 8))))
;; tab キーを押したときの移動量
(setq tab-stop-list (number-sequence 2 120 2)) ;; 2 4 6 8 ... 118 120

;; 選択状態の文字列を上書き
(delete-selection-mode t)

;; バックアップを残さない
(setq make-backup-files nil)

;;; ショートカット
(global-set-key "\C-z" 'undo)
(global-set-key "\C-h" 'backward-delete-char)
;; Enter時 autoindent
(define-key global-map (kbd "RET") 'newline-and-indent)
;; Ctrl-EnterをSublime Textなどと同じ挙動に
(define-key global-map (kbd "<C-return>")
  (lambda ()
    (interactive)
    (move-end-of-line 1)
    (newline-and-indent)))

;; recentfを有効にする
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 1024)

;; 括弧の自動補完
(electric-pair-mode 1)

;;; cask
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;;; use-package
(eval-when-compile
  (require 'use-package))

;;; all-the-icons
(use-package all-the-icons
  :defer t)

;;; AUCTeX
(use-package auctex-latexmk
  :defer t
  :config
  (auctex-latexmk-setup)
  (add-hook 'TeX-mode-hook
            '(lambda ()
               (setq TeX-command-default "LatexMk")
               (setq TeX-view-program-selection '((output-pdf "Okular")))
               (setq TeX-source-correlate-method 'synctex)
               (setq TeX-source-correlate-start-server t)
               (setq TeX-source-correlate-mode t)
               (server-start)))
  ;; RefTeX
  (with-eval-after-load 'tex-jp
    (add-hook 'LaTeX-mode-hook 'turn-on-reftex))
  (setq reftex-plug-into-AUCTeX t))

;;; company
(use-package company
  :defer t
  :diminish company-mode
  :init
  (global-company-mode)
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t))

;;; company-auctex
(use-package company-auctex
  :defer t
  :commands (TeX-mode LaTeX-mode)
  :config
  (company-auctex-init))

;;; dashboard
(use-package dashboard
  :defer t
  :disabled t
  :init
  (dashboard-setup-startup-hook))

;;; ddskk
(use-package skk-study
  :commands (skk-mode skk-auto-fill-mode skk-tutorial)
  :bind (("C-x C-j" . skk-mode)
         ("C-x j" . skk-auto-fill-mode)
         ("C-x t" . skk-tutorial))
  :config
  (setq skk-tut-file "/usr/share/skk/SKK.tut")
  (setq default-input-method "japanese-skk")
  ;; (setq default-input-method "japanese-skk-auto-fill")
  )

;;; expand-region
(use-package expand-region
  :bind (("C-@" . er/expand-region)
         ("C-M-@" . er/contract-region)))

;;; flycheck
(use-package flycheck
  :defer t
  :diminish flycheck-mode
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (add-hook 'c++-mode-hook (lambda()
                             (setq flycheck-gcc-language-standard "c++11")
                             (setq flycheck-clang-language-standard "c++11")))
  :config
  (custom-set-variables
   '(flycheck-disabled-checkers '(javascript-jshint javascript-jscs))))

;;; flycheck-rust
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;;; git-gutter-fringe
(use-package git-gutter-fringe
  :diminish git-gutter-mode
  :config
  (global-git-gutter-mode t))

;;; golden-ratio
(use-package golden-ratio
  :diminish golden-ratio-mode
  :config
  (golden-ratio-mode 1))

;;; helm
(use-package helm
  :defer t
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x C-f" . helm-find-files)
         ("C-x C-r" . helm-recentf))
  :config
  (use-package helm-config
    :config
    (helm-mode 1))
  (define-key global-map [remap list-buffers] 'helm-mini)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action))
(use-package helm-themes
  :commands helm-themes)

;;; highlight-symbol
(use-package highlight-symbol
  :defer t
  :diminish highlight-symbol-mode
  :init
  (add-hook 'prog-mode-hook 'highlight-symbol-mode)
  (add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)
  :config
  (setq highlight-symbol-idle-delay 1.0) ; 1秒後自動ハイライト
  )

;;; js2-mode
(use-package js2-mode
  :defer t
  :mode (("\\.js\\'" . js2-mode))
  :config
  (setq js2-basic-offset 2)
  (setq js2-include-browser-externs nil)
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil)
  (setq js2-highlight-external-variables nil)
  (setq js2-include-jslint-globals nil))

;;; markdown-mode
(use-package markdown-mode
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'"       . markdown-mode)))
(use-package gfm-mode
  :mode (("README\\.md\\'" . gfm-mode)))

;;; multiple-cursors
(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . mc/edit-lines)
  ("C->"         . mc/mark-next-like-this)
  ("C-<"         . mc/mark-previous-like-this)
  ("C-c C-<"     . mc/mark-all-like-this))

;;; neotree
(use-package neotree
  :defer t
  :bind ([f8] . neotree-toggle)
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;;; org-mode
(use-package ox-latex
  :defer t
  :config
  (setq org-latex-pdf-process '("latexmk %f"))
  (setq org-latex-default-class "bxjsarticle")
  (add-to-list 'org-latex-classes
               '("bxjsarticle"
                 "\\documentclass[autodetect-engine,dvi=dvipdfmx,11pt,a4paper,ja=standard]{bxjsarticle}
                 [NO-DEFAULT-PACKAGES]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-packages-alist '("" "amsmath") t)
  (add-to-list 'org-latex-packages-alist '("" "color") t)
  (add-to-list 'org-latex-packages-alist '("" "graphicx") t)
  (add-to-list 'org-latex-packages-alist '("" "newtxtext,newtxmath") t)
  (add-to-list 'org-latex-packages-alist '("" "here") t)
  (add-to-list 'org-latex-packages-alist '("hidelinks" "hyperref") t)
  (add-to-list 'org-latex-packages-alist '("" "listings") t)
  (add-to-list 'org-latex-packages-alist '("" "minted") t)
  (setq org-latex-listings 'minted)
  (setq org-latex-minted-options '(("breaklines" "true")
                                   ("breakanywhere" "true")
                                   ("linenos"))))

;;; php-mode
(use-package php-mode
  :defer t
  :mode ("\\.php\\'" . php-mode)
  :config
  (setq tab-width 2)
  (setq c-basic-offset 2))
(use-package php-ext
  :commands (php-mode))

;;; popwin
(use-package popwin
  :disabled t
  :config
  (popwin-mode 1))

;;; powerline
(use-package powerline
  :defer t)

;;; rainbow-delimiters
(use-package rainbow-delimiters
  :defer t
  :disabled t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  :config
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(rainbow-delimiters-depth-1-face ((t (:foreground "dark orange"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "deep pink"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "chartreuse"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "deep sky blue"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "yellow"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "orchid"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "spring green"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "sienna1"))))))

;;; rust-mode
(use-package rust-mode
  :mode (("\\.rs\\'" . rust-mode))
  :config
  (setq rust-format-on-save t))

;;; SLIME
(use-package slime
  :commands (slime)
  :init
  (setq inferior-lisp-program "clisp")
  :config
  (slime-setup '(slime-repl slime-fancy slime-banner)))

;;; smooth-scroll
(use-package smooth-scrolling
  :defer t
  :init
  (smooth-scrolling-mode 1))

;;; undo-tree
(use-package undo-tree
  :diminish undo-tree-mode
  :defer t
  :init
  (global-undo-tree-mode))

;;; web-mode
(use-package web-mode
  :defer t
  :mode (("\\.phtml\\'"    . web-mode)
         ("\\.[agj]sp\\'"  . web-mode)
         ("\\.as[cp]x\\'"  . web-mode)
         ("\\.erb\\'"      . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'"   . web-mode)
         ("\\.html?\\'"    . web-mode)
         ("\\.css\\'"      . web-mode))
  :config
  ;; HTML element offset indentation
  (setq web-mode-markup-indent-offset 2)
  ;; CSS offset indentation
  (setq web-mode-css-indent-offset 2)
  ;; Script/code offset indentation (for JavaScript, Java, PHP, Ruby, VBScript, Python, etc.)
  (setq web-mode-code-indent-offset 2)
  ;; Auto-pairing
  (setq web-mode-enable-auto-pairing t)
  ;; CSS colorization
  (setq web-mode-enable-css-colorization t))

;;; theme setting
(use-package darkokai-theme
  :ensure t
  :config (load-theme 'darkokai t))
;; (load-theme 'atom-dark t)
;; (load-theme 'gruvbox-dark-hard t)
;; (load-theme 'leuven t)
;; (load-theme 'material t)
;; (load-theme 'material-light t)
;; (load-theme 'monokai t)
;; (load-theme 'seti t)
;; (load-theme 'zenburn t)

;;; moe-theme
(use-package moe-theme
  :disabled
  :config
  ;; Show highlighted buffer-id as decoration. (Default: nil)
  (setq moe-theme-highlight-buffer-id t)
  ;; Choose a color for mode-line.(Default: blue)
  ;; (Available colors: blue, orange, green ,magenta, yellow, purple, red, cyan, w/b.)
  (moe-theme-set-color 'purple)
  (powerline-moe-theme)
  ;; Finally, apply moe-theme now.
  ;; Choose what you like, (moe-light) or (moe-dark)
  (moe-dark))


;; 透明度指定
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.95 0.80)))

; (provide 'init)

;;; init.el ends here

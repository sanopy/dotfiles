;;; package --- Summary
;;; Code:
;;; Commentary:

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

;;; all-the-icons
(require 'all-the-icons)

;;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)
(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)

;;; dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)

;;; ddskk
(require 'skk-study)
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xt" 'skk-tutorial)
(setq skk-tut-file "/usr/share/skk/SKK.tut")
(setq default-input-method "japanese-skk")
;; (setq default-input-method "japanese-skk-auto-fill")

;;; expand-region
(require 'expand-region)
(global-set-key (kbd "C-@") 'er/expand-region)
(global-set-key (kbd "C-M-@") 'er/contract-region)

;;; flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'c++-mode-hook (lambda()
                           (setq flycheck-gcc-language-standard "c++11")
                           (setq flycheck-clang-language-standard "c++11")))
(eval-after-load 'flycheck
  '(custom-set-variables
    '(flycheck-disabled-checkers '(javascript-jshint javascript-jscs))))

;;; flycheck-rust
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;;; helm
(require 'helm-config)
(require 'helm-themes)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
(define-key global-map [remap list-buffers] 'helm-mini)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

;;; highlight-symbol
(require 'highlight-symbol)
(setq highlight-symbol-idle-delay 1.0) ; 1秒後自動ハイライト
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)

;;; js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-basic-offset 2)
(setq js2-include-browser-externs nil)
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)
(setq js2-highlight-external-variables nil)
(setq js2-include-jslint-globals nil)

;;; markdown-mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;; neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;;; php-mode
(eval-after-load 'php-mode
  '(require 'php-ext))
(add-hook 'php-mode-hook
          (lambda ()
            (auto-complete-mode t)
            (require 'ac-php)
            (setq ac-sources  '(ac-source-php ) )
            (yas-global-mode 1)
            (ac-php-core-eldoc-setup ) ;; enable eldoc
            (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
            (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back)    ;go back
            (setq tab-width 2)
            (setq c-basic-offset 2)))

;;; popwin
(require 'popwin)
(popwin-mode 1)

;;; powerline
(require 'powerline)

;;; rainbow-delimiters
; (require 'rainbow-delimiters)
; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
; (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ; '(rainbow-delimiters-depth-1-face ((t (:foreground "dark orange"))))
 ; '(rainbow-delimiters-depth-2-face ((t (:foreground "deep pink"))))
 ; '(rainbow-delimiters-depth-3-face ((t (:foreground "chartreuse"))))
 ; '(rainbow-delimiters-depth-4-face ((t (:foreground "deep sky blue"))))
 ; '(rainbow-delimiters-depth-5-face ((t (:foreground "yellow"))))
 ; '(rainbow-delimiters-depth-6-face ((t (:foreground "orchid"))))
 ; '(rainbow-delimiters-depth-7-face ((t (:foreground "spring green"))))
 ; '(rainbow-delimiters-depth-8-face ((t (:foreground "sienna1")))))

;;; rust-mode
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;;; SLIME
(setq inferior-lisp-program "clisp")
(require 'slime)
(slime-setup '(slime-repl slime-fancy slime-banner))

;;; smooth-scroll
(require 'smooth-scroll)
(smooth-scroll-mode t)

;;; twittering-mode
(require 'twittering-mode)
(setq twittering-use-master-password t)
(setq twittering-icon-mode t)
(setq twittering-use-icon-storage t)
(setq twittering-display-remaining t)

;;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
; (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
;; HTML element offset indentation
(setq web-mode-markup-indent-offset 2)
;; CSS offset indentation
(setq web-mode-css-indent-offset 2)
;; Script/code offset indentation (for JavaScript, Java, PHP, Ruby, VBScript, Python, etc.)
(setq web-mode-code-indent-offset 2)
;; Auto-pairing
(setq web-mode-enable-auto-pairing t)
;; CSS colorization
(setq web-mode-enable-css-colorization t)


;; マイナーモードをモードラインに表示しない
(setq my/hidden-minor-modes
      '(auto-complete-mode
        flycheck-mode
        helm-mode
        highlight-symbol-mode
        smartparens-mode
        smooth-scroll-mode
        undo-tree-mode))
(--each my/hidden-minor-modes
  (setq minor-mode-alist
        (cons (list it "") (assq-delete-all it minor-mode-alist))))

;;; theme setting
;; (load-theme 'atom-dark t)
(load-theme 'gruvbox-dark-hard t)
;; (load-theme 'leuven t)
;; (load-theme 'material t)
;; (load-theme 'material-light t)
;; (load-theme 'monokai t)
;; (load-theme 'seti t)
;; (load-theme 'zenburn t)

;;; moe-theme
; (require 'moe-theme)
;; Show highlighted buffer-id as decoration. (Default: nil)
; (setq moe-theme-highlight-buffer-id t)
;; Choose a color for mode-line.(Default: blue)
;; (Available colors: blue, orange, green ,magenta, yellow, purple, red, cyan, w/b.)
; (moe-theme-set-color 'purple)
; (powerline-moe-theme)
;; Finally, apply moe-theme now.
;; Choose what you like, (moe-light) or (moe-dark)
; (moe-dark)


;; 透明度指定
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.95 0.80)))

(provide 'init)
;;; init.el ends here

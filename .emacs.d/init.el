;;; init.el --- My configurations for Emacs

;;; Commentary:
;; How to setup my configurations for Emacs?
;; $ cd ~/.emacs.d
;; $ emacs --batch -f batch-byte-compile init.el

;;; Code:

;; (require 'cl) を見逃す
(setq byte-compile-warnings '(cl-functions))

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)
(leaf use-package :ensure t)
(leaf transient-dwim
  :ensure t
  :bind ("M-=" . transient-dwim-dispatch))

;; You can also configure builtin package via leaf!
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :custom (;; スタートアップメッセージを表示しない
           (inhibit-startup-message . t)
           ;; フレームタイトル
           (frame-title-format . `,(concat "%b - emacs@" (system-name)))
           ;; 折返し表示をしない
           (truncate-lines . t)
           ;; メニューバー表示
           (menu-bar-mode . t)
           ;; ツールバー表示
           (tool-bar-mode . t)
           ;; スクロールバー表示
           (scroll-bar-mode . t)
           ;; モードラインに行番号表示
           (line-number-mode . t)
           ;; モードラインに列番号表示
           (column-number-mode . t)
           ;; tab ではなく space を使う
           (indent-tabs-mode . nil)
           ;; tab 幅を 2 に設定
           (tab-width . 2)
           ;; tab キーを押したときの移動量
           ;(tab-stop-list . `,(number-sequence 2 120 2)) ;; 2 4 6 8 ... 118 120
           ;; 選択状態の文字列を上書き
           (delete-selection-mode . t)
           ;; 括弧の自動補完
           (electric-pair-mode . t)
           ;; 対応する括弧を強調表示
           (show-paren-mode . t))
  :config
  ;; 言語環境設定
  (set-language-environment "Japanese")
  ;; デフォルト文字コード
  (prefer-coding-system 'utf-8)
  ;; フォント設定
  ;(add-to-list 'default-frame-alist '(font . "Ricty"))
  ;(set-face-attribute 'default t :font "Ricty")
  ;; 透明度指定 アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
  (add-to-list 'default-frame-alist '(alpha . (0.95 0.80))))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom (auto-revert-interval . 0.1)
  :global-minor-mode global-auto-revert-mode)

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :added "2021-05-10"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :added "2021-05-10"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

(leaf *white-space
  :config
  ;; 行末のスペースを強調表示
  (when (boundp 'show-trailing-whitespace)
    (setq-default show-trailing-whitespace t))
  ;; 保存前 行末空白削除
  (add-hook 'before-save-hook 'delete-trailing-whitespace))

(leaf all-the-icons
  :doc "A library for inserting Developer icons"
  :req "emacs-24.3"
  :tag "lisp" "convenient" "emacs>=24.3"
  :added "2021-05-10"
  :url "https://github.com/domtronn/all-the-icons.el"
  :emacs>= 24.3
  :ensure t)

(leaf auctex
  :doc "Integrated environment for *TeX*"
  :req "emacs-24.3"
  :tag "preview-latex" "doctex" "context" "texinfo" "latex" "tex" "emacs>=24.3"
  :added "2021-05-10"
  :url "https://www.gnu.org/software/auctex/"
  :emacs>= 24.3
  :ensure t
  :config
  (leaf auctex-latexmk
    :doc "Add LatexMk support to AUCTeX"
    :req "auctex-11.87"
    :tag "tex"
    :added "2021-05-10"
    :url "https://github.com/tom-tan/auctex-latexmk/"
    :ensure t
    :custom (reftex-plug-into-AUCTeX . t)
    :config
    (auctex-latexmk-setup)
    (add-hook 'TeX-mode-hook
              '(lambda nil
                 (setq TeX-command-default "LatexMk")
                 (setq TeX-view-program-selection '((output-pdf "Okular")))
                 (setq TeX-source-correlate-method 'synctex)
                 (setq TeX-source-correlate-start-server t)
                 (setq TeX-source-correlate-mode t)
                 (server-start)))
    (with-eval-after-load 'tex-jp
      (add-hook 'LaTeX-mode-hook 'turn-on-reftex))))

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-25.1"
  :tag "matching" "convenience" "abbrev" "emacs>=25.1"
  :added "2021-05-10"
  :url "http://company-mode.github.io/"
  :emacs>= 25.1
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-selection-wrap-around . t)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode
  :config
  (leaf company-auctex
    :doc "Company-mode auto-completion for AUCTeX"
    :req "yasnippet-0.8.0" "company-0.8.0" "auctex-11.87"
    :added "2021-05-10"
    :url "https://github.com/alexeyr/company-auctex/"
    :ensure t
    :after yasnippet company auctex
    :commands (TeX-mode LaTeX-mode)
    :config (company-auctex-init))
  (leaf company-c-headers
    :doc "Company mode backend for C/C++ header files"
    :req "emacs-24.1" "company-0.8"
    :tag "company" "development" "emacs>=24.1"
    :added "2021-05-10"
    :emacs>= 24.1
    :ensure t
    :after company
    :defvar company-backends
    :config
    (add-to-list 'company-backends 'company-c-headers)))

(leaf dashboard
  :doc "A startup screen extracted from Spacemacs"
  :req "emacs-25.3" "page-break-lines-0.11"
  :tag "dashboard" "tools" "screen" "startup" "emacs>=25.3"
  :added "2021-05-10"
  :url "https://github.com/emacs-dashboard/emacs-dashboard"
  :emacs>= 25.3
  :ensure t
  ;:after page-break-lines
  :init (dashboard-setup-startup-hook)
  :custom (;; Use icons
           (dashboard-set-heading-icons . t)
           (dashboard-set-file-icons . t)))

(leaf ddskk
  :doc "Simple Kana to Kanji conversion program."
  :req "ccc-1.43" "cdb-20141201.754"
  :added "2021-05-10"
  :ensure t
  :commands (skk-mode skk-auto-fill-mode)
  :bind (("C-x C-j" . skk-mode)
         ("C-x j" . skk-auto-fill-mode))
  :custom ((skk-byte-compile-init-file . t)
           (skk-preload . t)
           (skk-isearch-mode-enable . 'always)
           (default-input-method . "japanese-skk")))

(leaf diff-hl
  :doc "Highlight uncommitted changes using VC"
  :req "cl-lib-0.2" "emacs-25.1"
  :tag "diff" "vc" "emacs>=25.1"
  :added "2021-05-10"
  :url "https://github.com/dgutov/diff-hl"
  :emacs>= 25.1
  :ensure t
  :global-minor-mode global-diff-hl-mode)

(leaf eldoc
  :doc "Show function arglist or variable docstring in echo area"
  :tag "builtin"
  :added "2021-05-10"
  :blackout t)

(leaf expand-region
  :doc "Increase selected region by semantic units."
  :tag "region" "marking"
  :added "2021-05-10"
  :ensure t
  :bind (("C-@" . er/expand-region)
         ("C-M-@" . er/contract-region)))

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "tools" "languages" "convenience" "emacs>=24.3"
  :added "2021-05-10"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :blackout flycheck-mode
  :global-minor-mode global-flycheck-mode
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :custom (flycheck-emacs-lisp-initialize-packages . t)
  :defvar (flycheck-gcc-language-standard flycheck-clang-language-standard)
  :init
  (add-hook 'c++-mode-hook (lambda()
                             (setq flycheck-gcc-language-standard "c++11")
                             (setq flycheck-clang-language-standard "c++11")))
  :config
  (leaf flycheck-elsa
    :doc "Flycheck for Elsa."
    :req "emacs-25" "seq-2.0"
    :tag "convenience" "emacs>=25"
    :added "2021-05-10"
    :url "https://github.com/emacs-elsa/flycheck-elsa"
    :emacs>= 25
    :ensure t
    :config (flycheck-elsa-setup))

  (leaf flycheck-package
    :doc "A Flycheck checker for elisp package authors"
    :req "emacs-24.1" "flycheck-0.22" "package-lint-0.2"
    :tag "lisp" "emacs>=24.1"
    :added "2021-05-10"
    :url "https://github.com/purcell/flycheck-package"
    :emacs>= 24.1
    :ensure t
    :after flycheck package-lint
    :config (flycheck-package-setup)))

(leaf git-gutter-fringe
  :disabled t
  :doc "Fringe version of git-gutter.el"
  :req "git-gutter-0.88" "fringe-helper-0.1.1" "cl-lib-0.5" "emacs-24"
  :tag "emacs>=24"
  :added "2021-05-10"
  :url "https://github.com/emacsorphanage/git-gutter-fringe"
  :emacs>= 24
  :ensure t
  ;:after git-gutter fringe-helper
  :blackout global-git-gutter-mode
  :global-minor-mode global-git-gutter-mode)

(leaf go-mode
  :doc "Major mode for the Go programming language"
  :tag "go" "languages"
  :added "2021-05-10"
  :url "https://github.com/dominikh/go-mode.el"
  :ensure t)

(leaf golden-ratio
  :doc "Automatic resizing of Emacs windows to the golden ratio"
  :tag "resizing" "window"
  :added "2021-05-10"
  :ensure t
  :blackout golden-ratio-mode
  :global-minor-mode golden-ratio-mode)

(leaf helm
  :disabled t
  :doc "Helm is an Emacs incremental and narrowing framework"
  :req "emacs-25.1" "async-1.9.4" "popup-0.5.3" "helm-core-3.7.1"
  :tag "emacs>=25.1"
  :added "2021-05-10"
  :url "https://github.com/emacs-helm/helm"
  :emacs>= 25.1
  :ensure t
  ;:after helm-core
  :require helm-config
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x C-f" . helm-find-files)
         ("C-x C-r" . helm-recentf)
         ("C-x b" . helm-buffers-list)
         (:helm-find-files-map
          ("TAB" . helm-execute-persistent-action))
         (:helm-read-file-map
          ("TAB" . helm-execute-persistent-action)))
  :config
  (helm-mode t)
  (define-key global-map [remap list-buffers] 'helm-mini)
  (leaf helm-themes
    :doc "Color theme selection with helm interface"
    :req "helm-core-2.0" "emacs-24.4"
    :tag "emacs>=24.4"
    :added "2021-05-10"
    :url "https://github.com/syohex/emacs-helm-themes"
    :emacs>= 24.4
    :ensure t
    :after helm-core
    :commands helm-themes))

(leaf highlight-symbol
  :doc "automatic and manual symbol highlighting"
  :tag "matching" "faces"
  :added "2021-05-10"
  :url "http://nschum.de/src/emacs/highlight-symbol/"
  :ensure t
  :blackout highlight-symbol-mode
  :custom (highlight-symbol-idle-delay . 1.0)
  :config
  (add-hook 'prog-mode-hook 'highlight-symbol-mode)
  (add-hook 'prog-mode-hook 'highlight-symbol-nav-mode))

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :added "2021-05-10"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :custom (;; `ivy-switch-buffer' (C-x b) のリストに recent files と bookmark を含める．
           (ivy-use-virtual-buffers . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.4"
    :tag "matching" "emacs>=24.5"
    :added "2021-05-10"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :after ivy
    :bind ("C-s" . swiper))
  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "ivy-0.13.4" "swiper-0.13.4"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :added "2021-05-10"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    ;:after ivy swiper
    :bind (("M-x" . counsel-M-x)
           ("C-x C-f" . counsel-find-file)
           ("C-x C-r" . counsel-recentf)))
  (leaf prescient
    :doc "Better sorting and filtering"
    :req "emacs-25.1"
    :tag "extensions" "emacs>=25.1"
    :added "2021-05-10"
    :url "https://github.com/raxod502/prescient.el"
    :emacs>= 25.1
    :ensure t
    :global-minor-mode prescient-persist-mode)
  (leaf ivy-prescient
    :doc "prescient.el + Ivy"
    :req "emacs-25.1" "prescient-5.1" "ivy-0.11.0"
    :tag "extensions" "emacs>=25.1"
    :added "2021-05-10"
    :url "https://github.com/raxod502/prescient.el"
    :emacs>= 25.1
    :ensure t
    :after prescient ivy
    :custom (ivy-prescient-retain-classic-highlighting . t)
    :global-minor-mode t))

(leaf js2-mode
  :doc "Improved JavaScript editing mode"
  :req "emacs-24.1" "cl-lib-0.5"
  :tag "javascript" "languages" "emacs>=24.1"
  :added "2021-05-10"
  :url "https://github.com/mooz/js2-mode/"
  :emacs>= 24.1
  :ensure t
  :mode (("\\.js\\'" . js2-mode))
  :custom (js2-indent-level . 2))

(leaf linum
  :doc "display line numbers in the left margin"
  :tag "builtin"
  :added "2021-05-10"
  :global-minor-mode global-linum-mode)

(leaf markdown-mode
  :doc "Major mode for Markdown-formatted text"
  :req "emacs-25.1"
  :tag "itex" "github flavored markdown" "markdown" "emacs>=25.1"
  :added "2021-05-10"
  :url "https://jblevins.org/projects/markdown-mode/"
  :emacs>= 25.1
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :custom (markdown-command . "multimarkdown"))

(leaf multiple-cursors
  :doc "Multiple cursors for Emacs."
  :req "cl-lib-0.5"
  :tag "cursors" "editing"
  :added "2021-05-10"
  :url "https://github.com/magnars/multiple-cursors.el"
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))

(leaf neotree
  :doc "A tree plugin like NerdTree for Vim"
  :req "cl-lib-0.5"
  :added "2021-05-10"
  :url "https://github.com/jaypei/emacs-neotree"
  :ensure t
  :bind ([f8] . neotree-toggle)
  :custom
  (neo-show-hidden-files . t)
  (neo-theme . 'icons))

(leaf org
  :doc "Export Framework for Org Mode"
  :tag "builtin"
  :added "2021-05-10"
  :custom (org-support-shift-select . t)
  :config
  (leaf org-ref
    :doc "citations, cross-references and bibliographies in org-mode"
    :req "dash-2.11.0" "htmlize-1.51" "helm-1.5.5" "helm-bibtex-2.0.0" "ivy-0.8.0" "hydra-0.13.2" "key-chord-0" "s-1.10.0" "f-0.18.0" "pdf-tools-0.7" "bibtex-completion-0"
    :tag "label" "ref" "cite" "org-mode"
    :added "2021-05-10"
    :url "https://github.com/jkitchin/org-ref"
    :ensure t
    :after helm helm-bibtex ivy hydra key-chord pdf-tools bibtex-completion)
  (leaf ox-latex
    :doc "LaTeX Back-End for Org Export Engine"
    :tag "builtin" "wp" "calendar" "hypermedia" "outlines"
    :added "2021-05-10"
    :require t
    :defvar (org-latex-pdf-process org-latex-default-class org-latex-classes org-latex-packages-alist org-latex-listings org-latex-minted-options)
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
    (add-to-list 'org-latex-classes
                 '("twocolumn"
                   "\\documentclass[autodetect-engine,dvi=dvipdfmx,10pt,a4paper,ja=standard,twocolumn]{bxjsarticle}
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
                                     ("linenos")))))
org-latex-classes
(leaf php-mode
  :doc "Major mode for editing PHP code"
  :req "emacs-25.2"
  :tag "php" "languages" "emacs>=25.2"
  :added "2021-05-10"
  :url "https://github.com/emacs-php/php-mode"
  :emacs>= 25.2
  :ensure t
  :mode ("\\.php\\'" . php-mode))

(leaf popwin
  :doc "Popup Window Manager"
  :req "emacs-24.3"
  :tag "convenience" "emacs>=24.3"
  :added "2021-05-10"
  :url "https://github.com/emacsorphanage/popwin"
  :emacs>= 24.3
  :ensure t
  :global-minor-mode popwin-mode)

(leaf powerline
  :disabled t
  :doc "Rewrite of Powerline"
  :req "cl-lib-0.2"
  :tag "mode-line"
  :added "2021-05-10"
  :url "http://github.com/milkypostman/powerline/"
  :ensure t
  :config
  (powerline-default-theme))

(leaf rainbow-delimiters
  :doc "Highlight brackets according to their depth"
  :tag "tools" "lisp" "convenience" "faces"
  :added "2021-05-10"
  :url "https://github.com/Fanael/rainbow-delimiters"
  :ensure t
  :hook prog-mode-hook)

(leaf recentf
  :doc "setup a menu of recently opened files"
  :tag "builtin"
  :added "2021-05-10"
  :custom (recentf-max-menu-items . 1024)
  :global-minor-mode recentf-mode)

(leaf rust-mode
  :doc "A major-mode for editing Rust source code"
  :req "emacs-25.1"
  :tag "languages" "emacs>=25.1"
  :added "2021-05-10"
  :url "https://github.com/rust-lang/rust-mode"
  :emacs>= 25.1
  :ensure t
  :mode ("\\.rs\\'" . rust-mode)
  :custom (rust-format-on-save . t))

(leaf slime
  :doc "Superior Lisp Interaction Mode for Emacs"
  :req "cl-lib-0.5" "macrostep-0.9"
  :tag "slime" "lisp" "languages"
  :added "2021-05-10"
  :url "https://github.com/slime/slime"
  :ensure t
  :after macrostep
  :commands slime
  :custom (inferior-lisp-program . "clisp")
  :config (slime-setup '(slime-repl slime-fancy slime-banner)))

(leaf smooth-scrolling
  :doc "Make emacs scroll smoothly"
  :tag "convenience"
  :added "2021-05-10"
  :url "http://github.com/aspiers/smooth-scrolling/"
  :ensure t
  :global-minor-mode smooth-scrolling-mode)

(leaf undo-tree
  :blackout undo-tree-mode
  :ensure t
  :bind
  ("C-z" . undo-tree-undo)
  ("C-S-z" . undo-tree-undo)
  :global-minor-mode global-undo-tree-mode)

(leaf web-mode
  :doc "major mode for editing web templates"
  :req "emacs-23.1"
  :tag "languages" "emacs>=23.1"
  :added "2021-05-10"
  :url "https://web-mode.org"
  :emacs>= 23.1
  :ensure t
  :mode (("\\.phtml\\'"    . web-mode)
         ("\\.[agj]sp\\'"  . web-mode)
         ("\\.as[cp]x\\'"  . web-mode)
         ("\\.erb\\'"      . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'"   . web-mode)
         ("\\.html?\\'"    . web-mode)
         ("\\.css\\'"      . web-mode))
  :custom
  ;; HTML element offset indentation
  (web-mode-markup-indent-offset . 2)
  ;; CSS offset indentation
  (web-mode-css-indent-offset . 2)
  ;; Script/code offset indentation (for JavaScript, Java, PHP, Ruby, VBScript, Python, etc.)
  (web-mode-code-indent-offset . 2)
  ;; Auto-pairing
  (web-mode-enable-auto-pairing . t)
  ;; CSS colorization
  (web-mode-enable-css-colorization . t))

(leaf doom-themes
  :ensure t
  :custom
  (doom-themes-enable-italic . t)
  (doom-themes-enable-bold . t)
  :config
  ;; Theme settings
  (load-theme 'doom-molokai t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
                                        ;(doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (leaf doom-modeline
    :ensure t
    :hook (after-init-hook . doom-modeline-mode)))

(leaf moe-theme
  :disabled t
  :doc "A colorful eye-candy theme. Moe, moe, kyun!"
  :tag "themes"
  :added "2021-05-10"
  :url "https://github.com/kuanyui/moe-theme.el"
  :ensure t
  :custom (;; Show highlighted buffer-id as decoration. (Default: nil)
           (moe-theme-highlight-buffer-id . t))
  :config
  ;; Choose a color for mode-line.(Default: blue)
  ;; (Available colors: blue, orange, green ,magenta, yellow, purple, red, cyan, w/b.)
  (moe-theme-set-color 'purple)
  (powerline-moe-theme)
  ;; Finally, apply moe-theme now.
  ;; Choose what you like, (moe-light) or (moe-dark)
  (moe-dark))

(leaf suscolors-theme
  :disabled t
  :ensure t
  :config (load-theme 'suscolors t))

;; atom-dark
;; gruvbox-dark-hard
;; leuven
;; material
;; material-light
;; monokai
;; seti
;; zenburn

(provide 'init)

;;; init.el ends here

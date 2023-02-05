;; emacs housekeeping
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq create-lockfiles nil)
(setq delete-old-versions -1)           ; delete excess backup versions silently
(setq version-control t)                ; use version control
(setq vc-make-backup-files t)           ; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))) ; which directory to put backups file
(setq vc-follow-symlinks t)                                    ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))) ;transform backups file name
(setq inhibit-startup-screen t) ; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore)       ; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8)    ; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)    ; sentence SHOULD end with only a point.
(setq default-fill-column 80)           ; toggle wrapping text at the 80th character
(find-file "~/Dropbox/darrellbanks.com/org/tasks/inbox.org")        ; Open to inbox file


;; package management
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))



;; path management
(use-package exec-path-from-shell
  :ensure t)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(defun goto-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

;; tree sitter
(use-package treesit
  :commands (treesit-install-language-grammar nf/treesit-install-all-languages)
  :init
  (setq treesit-language-source-alist
   '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
     (c . ("https://github.com/tree-sitter/tree-sitter-c"))
     (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
     (css . ("https://github.com/tree-sitter/tree-sitter-css"))
     (go . ("https://github.com/tree-sitter/tree-sitter-go"))
     (html . ("https://github.com/tree-sitter/tree-sitter-html"))
     (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
     (json . ("https://github.com/tree-sitter/tree-sitter-json"))
     (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
     (make . ("https://github.com/alemuller/tree-sitter-make"))
     (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" "master" "ocaml/src"))
     (python . ("https://github.com/tree-sitter/tree-sitter-python"))
     (php . ("https://github.com/tree-sitter/tree-sitter-php"))
     (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
     (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
     (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
     (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
     (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
     (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
  :config
  (defun nf/treesit-install-all-languages ()
    "Install all languages specified by `treesit-language-source-alist'."
    (interactive)
    (let ((languages (mapcar 'car treesit-language-source-alist)))
      (dolist (lang languages)
	      (treesit-install-language-grammar lang)
	      (message "`%s' parser was installed." lang)
	      (sit-for 0.75)))))

(require 'treesit)

;; org mode
(use-package org
  :config
  (setq org-return-follows-link t)
  (setq org-confirm-babel-evaluate nil)
  (setq org-agenda-files '("~/Dropbox/darrellbanks.com/org/projects"))
  (setq org-outline-path-complete-in-steps nil)         
  (setq org-refile-use-outline-path nil)      
  (setq org-todo-keyword-faces '(("NOTE" . "#ffb951")))
  (setq org-todo-keywords '((sequence "TODO(t)" "PROGRESS(p)" "|" "DONE(d)" "NOTE(n)")))
  (setq org-refile-targets '((nil :maxlevel . 1)
                             (org-agenda-files :maxlevel . 1)))
  (setq org-capture-templates
        '(("t" "Todo" entry (file "~/Dropbox/darrellbanks.com/org/tasks/inbox.org")
           "* TODO %?")
          ("n" "Note" entry (file "~/Dropbox/darrellbanks.com/org/tasks/inbox.org")
           "* NOTE %?")))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (js . t)
     (python . t)))

;; Why do I need this? Without a restart,
;; org doesn't recognize my org-todo-keywords.
(org-mode-restart))


(define-skeleton babel-skeleton
  "Header info for a emacs-org file."
  "#+TITLE:" str " \n"
  "#+AUTHOR: Darrell Banks\n"
  "#+email: howdy@changeset.io\n"
  "#+INFOJS_OPT: \n"
  "#+BABEL: :session *js* :session *python* :cache yes :results output graphics :exports both :tangle yes \n"
  "-----"
 )

;; org-roam
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-directory "~/Dropbox/darrellbanks.com/org/notes")
  (setq org-link-file-path-type 'absolute)
  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
    :after org-roam
    :ensure t
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; Hugo
(use-package ox-hugo
  :ensure t)
(setq time-stamp-active t
      time-stamp-start "#\\+lastmod:[ \t]*"
      time-stamp-end "$"
      time-stamp-format "%04Y-%02m-%02d")
(add-hook 'before-save-hook 'time-stamp nil)

;; Visual settings
;; - org mode
(use-package org-superstar
    :ensure t
    :config
    (setq org-superstar-special-todo-items t)
    (add-hook 'org-mode-hook (org-superstar-mode 1)))

;; - font
(set-face-attribute 'default nil :font "MonoLisa" :height 180)
;; - icons
(use-package all-the-icons :ensure t)
;; - company
(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

;; - modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; - indents
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-space)

;; - theme
(use-package exotica-theme 
  :ensure t
  :config
  (load-theme 'exotica t))

;; use-package
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

;; projectile
(use-package projectile :ensure t
   :config
    (projectile-global-mode))

;; Languages
;; - Typescript
(add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-ts-mode))
(add-hook 'typescript-ts-mode-hook 'eglot-ensure)

;; - brackets
(electric-pair-mode 1)

;; - web
(use-package web-mode :ensure t
    :mode (("\\.svelte$" .  web-mode)
         ("\\.html$" .  web-mode)))

;; - prettier
(use-package prettier-js :ensure t
  :init
  (add-hook 'typescript-ts-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode))

;; treemacs
(use-package treemacs :ensure t)
(use-package treemacs-evil :ensure t)
(use-package treemacs-projectile :ensure t)

;; ivy
(use-package ivy
  :ensure t
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config
  (ivy-mode))
(use-package ivy-rich
  :ensure t
  :after ivy
  :custom
  (ivy-virtual-abbreviate 'full
                          ivy-rich-switch-buffer-align-virtual-buffer t
                          ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))
(use-package all-the-icons-ivy
  :ensure t
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))
(use-package counsel
  :after ivy
  :ensure t
  :config
  (counsel-mode))
(use-package counsel-projectile :ensure t)

;; movement
(use-package avy :ensure t)
(use-package wgrep :ensure t)
(use-package swiper :ensure t)
(use-package imenu-list :ensure t
  :init
  (setq imenu-list-auto-resize t)
  (setq imenu-list-focus-after-activation t))

;; Evil Mode
(use-package evil
  :ensure t
  :config
  (evil-set-undo-system 'undo-redo)
  (evil-mode))
(use-package evil-mc :ensure t
  :config
  (global-evil-mc-mode 1))

;; Magit
(use-package magit
  :ensure t)

;; Key Bindings
(use-package which-key :ensure t
  :init (which-key-mode))
(use-package general :ensure t
  :config
  (general-evil-setup t)

  ;; org keys
  (general-define-key
   :states '(normal visual)
   :keymaps 'org-mode-map
   "t"   'org-todo
   "."   'org-time-stamp
   "-"   'org-ctrl-c-minus
   "+"   'org-ctrl-c-ctrl-c
   "*"   'org-ctrl-c-star
   "^"   'org-sort
   "{"   'org-edit-src-code
   "|"   'org-table-create-or-convert-from-region
   "RET" 'org-open-at-point
   "TAB" 'org-cycle)

  (general-define-key
   :states '(normal)
   :prefix ","
   :keymaps 'org-mode-map
   "<backtab>" 'org-promote-subtree
   ","   "C-c C-c"
   "/"   'org-sparse-tree
   "b"   '(:ignore t :which-key "Babel")
   "bi"  'org-insert-structure-template
   "bx"  'org-babel-execute-src-block
   "bh"  'org-babel-insert-header-arg
   "bn"  'org-babel-next-src-block
   "bp"  'org-babel-previous-src-block
   "bs"  'babel-skeleton
   "c"   '(:ignore t :which-key "Clocks")
   "ci"  'org-clock-in
   "co"  'org-clock-out
   "cs"  'org-schedule
   "cd"  'org-deadline
   "t"   'org-set-tags-command
   "o"   'org-occur
   "r"   'org-refile
   "A"   'org-archive-subtree
   "il"  'org-insert-link
   "RET" 'org-meta-return
   "TAB" 'org-demote-subtree)

  ;; xref keys
  (general-define-key
   :states '(normal visual)
   :keymaps 'xref--xref-buffer-mode-map
   "," 'xref-goto-xref)


  ;; general keys
  (general-define-key
   :states '(normal visual insert emacs treemacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

   ;; M-x
   "SPC" '(counsel-M-x :which-key "M-x")

   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "ao" '(:ignore t :which-key "Org")
   "aoa" '(org-agenda :which-key "Agenda")
   "aoc" '(org-capture :which-key "Capture")
   "ao>" '(org-goto-calendar :which-key "Go To Calendar")
   "at"  '(:ignore t :which-key "Treemacs")
   "atd" '(treemacs-select-directory :which-key "Select Directory")
   "aor" '(:ignore t :which-key "Org Roam")
   "aori" '(org-roam-node-insert :which-key "Insert Node")
   "aorf" '(org-roam-node-find :which-key "Find Node")
   "aoru" '(org-roam-ui-open :which-key "Open UI")
   "aos" '(org-edit-src-exit :which-key "Exit Src Edit")

   ;; Eglot
   "T" '(eglot-find-typeDefinition :which-key "Find Type Definition")
   "I" '(eglot-find-implementation :which-key "Find Implementation")
   "D"  '(eglot-find-declaration :which-key "Find Declaration")
   
   ;; Buffers
   "b" '(:ignore t :which-key "Buffers")
   "bl" '(list-buffers :which-key "List Buffers")
   "bb" '(ivy-switch-buffer :which-key "Switch Buffer (ivy)")
   "bd" '(kill-this-buffer :which-key "Kill Buffer")
   "bp" '(previous-buffer :which-key "Previous Buffer")
   "bn" '(next-buffer :which-key "Next Buffer")
   "bs" '(scratch-buffer :which-key "Scratch Buffer")

   ;; Toggles
   "t" '(:ignore t :which-key "Toggles")
   "tl" '(display-line-numbers-mode :which-key "Line Numbers")
   "ti" '(imenu-list-smart-toggle :which-key "IMenu List")

   ;; Avy
   "j" '(:ignore t :which-key "Jump To")
   "jl" '(avy-goto-line :which-key "Jump To Line (avy)")
   "jw" '(avy-goto-word-1 :which-key "Jump To Worg (avy)")

   ;; Counsel
   "/" '(counsel-ag :which-key "Search in project")
   "p" '(:ignore t :which-key "Projectile")
   "pp" '(counsel-projectile-switch-project :which-key "Switch Project (projectile)")
   "pf" '(counsel-projectile-find-file :which-key "Find Files In Project (projectile)")

   ;; Files
   "f" '(:ignore t :which-key "Files")
   "fed" '(goto-init-file :which-key "Go to init file")
   "ft" '(treemacs :which-key "Treemacs Filetree")

   ;; Windows
   "w" '(:ignore t :which-key "Windows")
   "wd" '(delete-window :which-key "Delete Window")
   "w/" '(split-window-right :which-key "Split Window Right")
   "w-" '(split-window-below :which-key "Split Window Below")
   "wh" '(windmove-left :which-key "Move to Window on Left")
   "wl" '(windmove-right :which-key "Move to Window on Right")
   "wj" '(windmove-down :which-key "Move to Window Below")
   "wk"  '(windmove-up :which-key "Move to Window Above")

   ;; Magit
   "g" '(:ignore t :which-key "Magit")
   "gd" '(magit-diff :which-key "Diff")
   
   ;; Emacs
   "q" '(:ignore t :which-key "Quit")
   "qr" '(restart-emacs :which-key "Restart Emacs")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("1d89fcf0105dd8778e007239c481643cc5a695f2a029c9f30bd62c9d5df6418d" default))
 '(package-selected-packages
   '(org-roam-ui all-the-icons-ivy web-mode doom-modeline all-the-icons evil avy))
 '(safe-local-variable-values '((org-hugo-base-dir . "./org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

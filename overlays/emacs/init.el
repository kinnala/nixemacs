(require 'package)
(package-initialize 'noactivate)
(eval-when-compile
  (require 'use-package))

(use-package org
  :commands org-babel-do-load-languages
  :config
  (unbind-key "C-," org-mode-map)
  :init
  (add-hook 'org-mode-hook (lambda () (org-babel-do-load-languages
                                       'org-babel-load-languages '((python . t)
                                                                   (shell . t)))))
  (add-hook 'org-agenda-finalize-hook
            (lambda ()
              (save-excursion
                (color-org-header "inbox:" "#DDDDFF" "black")
                (color-org-header "work:" "#FFDDDD" "red")
                (color-org-header "research:" "#DDFFDD" "DarkGreen"))))
  (defun color-org-header (tag backcolor forecolor)
    ""
    (interactive)
    (goto-char (point-min))
    (while (re-search-forward tag nil t)
      (add-text-properties (match-beginning 0) (+ (match-beginning 0) 10)
                           `(face (:background, backcolor, :foreground, forecolor)))))
  (setq org-default-notes-file "~/Dropbox/Notes/gtd/inbox.org"
        org-agenda-files '("~/Dropbox/Notes/gtd/inbox.org"
                           "~/Dropbox/Notes/gtd/tickler.org"
                           "~/Dropbox/Notes/gtd/research.org"
                           "~/Dropbox/Notes/gtd/work.org")
        org-refile-targets '(("~/Dropbox/Notes/gtd/inbox.org" . (:maxlevel . 1))
                             ("~/Dropbox/Notes/gtd/tickler.org" . (:maxlevel . 1))
                             ("~/Dropbox/Notes/gtd/research.org" . (:maxlevel . 1))
                             ("~/Dropbox/Notes/gtd/work.org" . (:maxlevel . 1)))
        org-log-done 'time
        org-tags-column 0
        org-export-babel-evaluate nil
        org-adapt-indentation nil
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-duration-format '(("d" . nil) ("h" . t) (special . 2))
        org-format-latex-options '(:foreground default
                                   :background default
                                   :scale 1.5
                                   :html-foreground "Black"
                                   :html-background "Transparent"
                                   :html-scale 1.0
                                   :matchers
                                   ("begin" "$1" "$" "$$" "\\(" "\\["))
        org-src-preserve-indentation t
        org-confirm-babel-evaluate nil
        python-shell-completion-native-disabled-interpreters '("python")
        org-babel-default-header-args:sh '((:prologue . "exec 2>&1")
                                           (:epilogue . ":"))
        org-capture-templates '(("t" "Todo" entry
                                 (file "~/Dropbox/Notes/gtd/inbox.org")
                                 "* TODO %?\n  SCHEDULED: %t\n%i\n%a")
                                ("k" "Entry" entry
                                 (file "~/Dropbox/Notes/gtd/inbox.org")
                                 "* %?\n%t")))
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda)))

(use-package hydra)

(use-package ivy
  :commands
  ivy-mode
  :init
  (ivy-mode 1)
  (setq ivy-height 12
        ivy-fixed-height-minibuffer t
       	ivy-use-virtual-buffers t)
  :bind (("C-x b" . ivy-switch-buffer)
         ("C-c r" . ivy-resume)
	 ("C-x C-b" . ibuffer)))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c g" . counsel-rg)
         ("C-c f" . counsel-file-jump)
         ("C-c G" . counsel-git)
         ("C-x b" . counsel-switch-buffer)
         ("C-c h" . counsel-minibuffer-history)
         ("M-y" . counsel-yank-pop))
  :init (setq counsel-find-file-ignore-regexp "\\archive\\'"))

(use-package swiper
  :bind ("C-c s" . swiper))

(use-package transient)

(use-package magit
  :init
  (setq magit-repository-directories '(("~/src" . 1)))
  :bind (("C-x g" . magit-status)
         ("C-c M-g" . magit-file-dispatch)
         ("C-c l" . magit-list-repositories)))

(use-package which-key
  :commands which-key-mode
  :init (which-key-mode))

(use-package exec-path-from-shell
  :commands exec-path-from-shell-initialize
  :init (exec-path-from-shell-initialize))

(use-package expand-region
  :bind ("C-." . er/expand-region)
  :init
  (require 'expand-region)
  (require 'cl)
  (defun mark-around* (search-forward-char)
    (let* ((expand-region-fast-keys-enabled nil)
           (char (or search-forward-char
                     (char-to-string
                      (read-char "Mark inner, starting with:"))))
           (q-char (regexp-quote char))
           (starting-point (point)))
      (when search-forward-char
        (search-forward char (point-at-eol)))
      (flet ((message (&rest args) nil))
        (er--expand-region-1)
        (er--expand-region-1)
        (while (and (not (= (point) (point-min)))
                    (not (looking-at q-char)))
          (er--expand-region-1))
        (er/expand-region -1))))
  (defun mark-around ()
    (interactive)
    (mark-around* nil))
  (define-key global-map (kbd "M-i") 'mark-around))

(use-package multiple-cursors
  :init
  (define-key global-map (kbd "C-'") 'mc-hide-unmatched-lines-mode)
  (define-key global-map (kbd "C-,") 'mc/mark-next-like-this)
  (define-key global-map (kbd "C-;") 'mc/mark-all-dwim))

(use-package term)

(use-package dired-x)

(use-package dired
  :after (term dired-x)
  :init
  (setq dired-dwim-target t)
  (setq dired-omit-files "^\\...+$")
  (defun run-gnome-terminal-here ()
    (interactive)
    (shell-command "gnome-terminal"))
  :bind (("C-x C-j" . dired-jump))
  :bind (:map dired-mode-map
              ("'" . run-gnome-terminal-here)
              ("j" . swiper)
              ("s" . swiper)))

(use-package json-mode)

(use-package leuven-theme
  :after diredfl
  :init
  (load-theme 'leuven t)
  (global-hl-line-mode)
  (set-face-attribute 'font-lock-type-face nil :box 1)
  (set-face-attribute 'font-lock-function-name-face nil :box 1)
  (set-face-attribute 'font-lock-constant-face nil :box 1)
  (set-face-attribute
   'term nil :foreground "#000000" :background "#DDFFFF")
  (set-face-attribute
   'diredfl-compressed-file-suffix nil :foreground "#000000")
  (set-face-attribute
   'diredfl-dir-name nil :foreground "#000000" :background "#FFDDDD" :box nil)
  (set-face-attribute
   'diredfl-dir-heading nil :foreground "#000000" :background "#FFDDDD")
  (set-face-attribute
   'diredfl-write-priv nil :foreground "#000000" :background "#FFDDDD")
  (set-face-attribute
   'diredfl-read-priv nil :foreground "#000000" :background "#DDFFDD")
  (set-face-attribute
   'diredfl-exec-priv nil :foreground "#000000" :background "#DDDDDFF")
  (set-face-attribute 'mode-line nil :font "Iosevka-10")
  (set-face-attribute 'mode-line-inactive nil :font "Iosevka-10")
  (set-face-attribute 'default nil :font "Iosevka-15")
  (setq initial-frame-alist '(
                              (mouse-color           . "midnightblue")
                              (foreground-color      . "grey20")
                              (background-color      . "FloralWhite")
                              (internal-border-width . 2)
                              (line-spacing          . 1)
                              (top . 20) (left . 650) (width . 100) (height . 24)))
  (setq default-frame-alist '(
                              (border-color          . "#4e3832")
                              (foreground-color      . "grey10")
                              (background-color      . "FloralWhite")
                              (cursor-color          . "purple")
                              (cursor-type           . box)
                              (top . 30) (left . 150) (width . 100) (height . 24))))

(use-package highlight-indentation
  :init
  (defun set-hl-indent-color ()
    (set-face-background 'highlight-indentation-face "#ededdc"))
  (add-hook 'prog-mode-hook 'highlight-indentation-mode)
  (add-hook 'prog-mode-hook 'set-hl-indent-color))

(use-package yaml-mode)

(use-package wgrep)

(use-package csv-mode
  :mode "\\.csv$"
  :init
  (setq csv-separators '(";")))

(use-package phi-search
  :after multiple-cursors
  :init (require 'phi-replace)
  :bind ("C-:" . phi-replace)
  :bind (:map mc/keymap
              ("C-s" . phi-search)
              ("C-r" . phi-search-backward)))

(use-package docker
  :bind ("C-c d" . docker))

(use-package restclient)

(use-package ob-restclient
  :after (org restclient)
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages '((restclient . t))))

(use-package htmlize)

(use-package diredfl
  :commands diredfl-global-mode
  :init (diredfl-global-mode))

(use-package python-pytest
  :bind ("C-c t" . python-pytest-popup))

(use-package dired-k
  :after (dired)
  :bind (:map dired-mode-map
              ("g" . dired-k)))

(use-package anaconda-mode
  :init
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package nix-mode)

;; move lines, from https://github.com/kinnala/move-lines

(defun move-lines--internal (n)
  "Moves the current line or, if region is actives, the lines surrounding
region, of N lines. Down if N is positive, up if is negative"
  (let* (text-start
         text-end
         (region-start (point))
         (region-end region-start)
         swap-point-mark
         delete-latest-newline)

    ;; STEP 1: identifying the text to cut.
    (when (region-active-p)
      (if (> (point) (mark))
          (setq region-start (mark))
        (exchange-point-and-mark)
        (setq swap-point-mark t
              region-end (point))))

    ;; text-end and region-end
    (end-of-line)
    ;; If point !< point-max, this buffers doesn't have the trailing newline.
    (if (< (point) (point-max))
        (forward-char 1)
      (setq delete-latest-newline t)
      (insert-char ?\n))
    (setq text-end (point)
          region-end (- region-end text-end))

    ;; text-start and region-start
    (goto-char region-start)
    (beginning-of-line)
    (setq text-start (point)
          region-start (- region-start text-end))

    ;; STEP 2: cut and paste.
    (let ((text (delete-and-extract-region text-start text-end)))
      (forward-line n)
      ;; If the current-column != 0, I have moved the region at the bottom of a
      ;; buffer doesn't have the trailing newline.
      (when (not (= (current-column) 0))
        (insert-char ?\n)
        (setq delete-latest-newline t))
      (insert text))

    ;; STEP 3: Restoring.
    (forward-char region-end)

    (when delete-latest-newline
      (save-excursion
        (goto-char (point-max))
        (delete-char -1)))

    (when (region-active-p)
      (setq deactivate-mark nil)
      (set-mark (+ (point) (- region-start region-end)))
      (if swap-point-mark
          (exchange-point-and-mark)))))

(defun move-lines-up (n)
  "Moves the current line or, if region is actives, the lines surrounding
region, up by N lines, or 1 line if N is nil."
  (interactive "p")
  (if (eq n nil)
      (setq n 1))
  (move-lines--internal (- n)))

(defun move-lines-down (n)
  "Moves the current line or, if region is actives, the lines surrounding
region, down by N lines, or 1 line if N is nil."
  (interactive "p")
  (if (eq n nil)
      (setq n 1))
  (move-lines--internal n))

(defun tom/shift-left (start end &optional count)
  "Shift region left and activate hydra."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end) current-prefix-arg)
     (list (line-beginning-position) (line-end-position) current-prefix-arg)))
  (python-indent-shift-left start end count)
  (tom/hydra-move-lines/body))

(defun tom/shift-right (start end &optional count)
  "Shift region right and activate hydra."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end) current-prefix-arg)
     (list (line-beginning-position) (line-end-position) current-prefix-arg)))
  (python-indent-shift-right start end count)
  (tom/hydra-move-lines/body))

(defun tom/move-lines-p ()
  "Move lines up once and activate hydra."
  (interactive)
  (move-lines-up 1)
  (tom/hydra-move-lines/body))

(defun tom/move-lines-n ()
  "Move lines down once and activate hydra."
  (interactive)
  (move-lines-down 1)
  (tom/hydra-move-lines/body))

(defhydra tom/hydra-move-lines ()
  "Move one or multiple lines"
  ("n" move-lines-down "down")
  ("p" move-lines-up "up")
  ("<" python-indent-shift-left "left")
  (">" python-indent-shift-right "right"))

(define-key global-map (kbd "C-c n") 'tom/move-lines-n)
(define-key global-map (kbd "C-c p") 'tom/move-lines-p)
(define-key global-map (kbd "C-c <") 'tom/shift-left)
(define-key global-map (kbd "C-c >") 'tom/shift-right)

;; useful functions

(defun tom/unfill-paragraph (&optional region)
  "Take REGION and turn it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'tom/unfill-paragraph)

;; other global configurations

;; show current function in modeline
(which-function-mode)

;; scroll screen
(define-key global-map "\M-n" 'scroll-up-line)
(define-key global-map "\M-p" 'scroll-down-line)

;; change yes/no to y/n
(defalias 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'yes-or-no-p)

;; enable winner-mode, previous window config with C-left
(winner-mode 1)

;; windmove
(windmove-default-keybindings)

;; disable tool and menu bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

;; change gc behavior
(setq gc-cons-threshold 50000000)

;; warn when opening large file
(setq large-file-warning-threshold 100000000)

;; disable startup screen
(setq inhibit-startup-screen t)

;; useful frame title format
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; automatic revert
(global-auto-revert-mode t)

;; highlight parenthesis, easier jumping with C-M-n/p
(show-paren-mode 1)
(setq show-paren-delay 0)

;; control indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-offset 4)

;; modify scroll settings
(setq scroll-preserve-screen-position t)

;; set default fill width (e.g. M-q)
(setq-default fill-column 80)

;; window dividers
(fringe-mode 0)
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode 1)

;; display time in modeline
(display-time-mode 1)

;; put all backups to same directory to not clutter directories
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; display line numbers
(global-display-line-numbers-mode)

;; browse in chrome
(setq browse-url-browser-function 'browse-url-chromium)

;; don't fontify latex
(setq font-latex-fontify-script nil)

;; set default encodings to utf-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)

;; make Customize to not modify this file
(setq custom-file (make-temp-file "emacs-custom"))

;; enable all disabled commands
(setq disabled-command-function nil)

;; ediff setup
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; unbind keys
(unbind-key "C-z" global-map)

;; change emacs frame by number
(defun tom/select-frame (n)
  "Select frame identified by the number N."
  (interactive)
  (let ((frame (nth n (reverse (frame-list)))))
    (if frame
        (select-frame-set-input-focus frame)
      (select-frame-set-input-focus (make-frame))
      (toggle-frame-fullscreen))))

(define-key global-map
  (kbd "M-1")
  (lambda () (interactive)
    (tom/select-frame 0)))
(define-key global-map
  (kbd "M-2")
  (lambda () (interactive)
    (tom/select-frame 1)))
(define-key global-map
  (kbd "M-3")
  (lambda () (interactive)
    (tom/select-frame 2)))
(define-key global-map
  (kbd "M-4")
  (lambda () (interactive)
    (tom/select-frame 3)))

;; load private configurations
(load "~/Dropbox/Config/emacs/private.el" t)

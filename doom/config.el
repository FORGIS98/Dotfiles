;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

(setq user-full-name "Jorge Sol"
      user-mail-address "jorgesolgonzalez@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-pro)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/mi-gemelo-digital/")
(setq org-agenda-files
      (directory-files-recursively "~/mi-gemelo-digital/" "\\.org$"))

(defun my/org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(defun my/org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))

(setq org-agenda-custom-commands
      '(("d" "Daily agenda and all TODOs"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High Priority! DO-NOW:")))
          (agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-start-day "0d")
                   (org-agenda-overriding-header "Agenda:")))
          (alltodo ""
                   ((org-agenda-skip-function (lambda ()
                            (or (my/org-skip-subtree-if-habit)
                                (my/org-skip-subtree-if-priority ?A)
                                (org-agenda-skip-if nil '(scheduled deadline)))))
                    (org-agenda-overriding-header "TODO-LIST:"))))
         ((org-agenda-compact-blocks nil)
          (org-agenda-block-separator #x2500)))))

(defun my/pop-to-org-agenda (&optional split)
  "Visit the org agenda, in the current window or a SPLIT."
  (interactive "P")
  (org-agenda nil "d")
  (when (not split)
    (delete-other-windows)))

(define-key evil-normal-state-map (kbd "S-SPC") 'my/pop-to-org-agenda)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Muestra el cursos cuando te mueves (una chorrada)
(beacon-mode 1)

(use-package! denote
  :defer nil
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :config
  (setq denote-directory (expand-file-name "~/mi-gemelo-digital/denote"))
  (denote-rename-buffer-mode 1)

  (map! :leader
        :prefix ("d" . "denote")
        :desc "search or create file"        "n" #'denote-open-or-create
        :desc "rename file"                  "r" #'denote-rename-file
        :desc "link note"                    "l" #'denote-link
        :desc "backlinks"                    "b" #'denote-backlinks
        :desc "dired notes"                  "d" #'denote-dired
        :desc "grep notes"                   "g" #'denote-grep
        :desc "create under directory"       "y" #'denote-subdirectory)
  (setq denote-known-keywords '()))

;; esto es por que vterm da error si tengo en mi .zshrc ^j
(add-hook 'vterm-mode-hook
          (lambda ()
            (define-key vterm-mode-map (kbd "C-j") #'vterm-send-down)))

(use-package! calfw-org)

(setq calendar-holidays nil)

(defun my/open-calendar-week-view ()
  "Abrir el calendario de calfw-org directamente en vista semanal."
  (interactive)
  (calfw-open-calendar-buffer)
  (calfw-change-view-week))

(map! :leader
      (:prefix-map ("o" . "open")
                   (:prefix-map ("c" . "calendar")
                    :desc "today"                      "t" #'org-timeblock)))

(after! org
  (setq org-start-on-weekday 1)
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file "todo.org")
           "* TODO %?\n"
           :prepend t)
          ("j" "Diario"
           entry (file+datetree "journal.org")
           "* %?"))))

(map! :leader
      :desc "Capture something."           "x" #'org-capture
      :desc "Pop up a persistent scratch buffer." "X" #'doom/open-scratch-buffer)

(setq create-lockfiles nil)
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "autosave/") t)))

(after! calendar
  (setq calendar-week-start-day 1))

(after! org-timeblock
  :config
  (setq org-timeblock-span 1)
  (setq org-timeblock-scale-options '(6 . 24)))

(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d!)" "CANC(c!)")))

;; log into LOGBOOK drawer
(setq org-log-into-drawer t)

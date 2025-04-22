;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
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
;; (setq doom-font (font-spec :family "Mononoki Nerd Font Mono" :size 15 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

(setq doom-font (font-spec :family "JetBrains MonoNL" :size 13)
      doom-variable-pitch-font (font-spec :family "JetBrains MonoNL" :size 13)
      doom-big-font (font-spec :family "JetBrains MonoNL" :size 20))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

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
(setq org-directory "~/org/")


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

;; enseña el cursor mejor cuando te mueves
(beacon-mode 1)

;; org-journal config
(setq org-journal-dir "/home/jorge/doomed-brain/journal"
      org-journal-date-prefix "#+title: "
      org-journal-time-prefix ""
      org-journal-file-format "%y-%m-%d.org")

(setq org-roam-directory "/home/jorge/doomed-brain/roam")
(org-roam-db-autosync-mode)

;; config del ssh agent para git
(use-package! exec-path-from-shell
  :init
  (setq exec-path-from-shell-variables '("SSH_AUTH_SHOCK" "SSH_AGENT_PID"))
  :config
  (exec-path-from-shell-initialize))

(after! org-roam
  (setq org-roam-db-update-on-save t))

(use-package! denote
  :defer nil
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :config
  (setq denote-directory (expand-file-name "/home/jorge/mi-gemelo-digital"))
  (denote-rename-buffer-mode 1)

  ;; Doom leader key bindings
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

(use-package denote-journal
  :ensure t
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  (setq denote-journal-directory
        (expand-file-name "mi-diario" denote-directory))
  (setq denote-journal-keyword "diario")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format nil))

;;; new-config.el -*- lexical-binding: t; -*-

;; Datos personales
(setq user-full-name "Jorge Sol"
      user-mail-address "jorgesolgonzalez@gmail.com")

;; Config global
(setq doom-theme 'doom-monokai-pro)
(setq display-line-numbers-type 'relative)
(setq frame-title-format "Emacs")
(setq calendar-holidays nil)
(beacon-mode 1)

;; Backups
(setq create-lockfiles nil)
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "autosave/") t)))

;; Para usar vterm como uso kitty
(add-hook 'vterm-mode-hook
          (lambda ()
            (define-key vterm-mode-map (kbd "C-j") #'vterm-send-down)))

;; Cargo resto de configs
(defun my/load-config-recursively (base-dir)
  "Carga recursivamente todos los archivos .el dentro de base-dir"
  (when (file-exists-p base-dir)
    (let ((files (directory-files-recursively base-dir "\\.el$")))
      (dolist (file files)
        (load file)))))

;; Cargo la config del curro si estoy en el curro, si no, no
(cond
 ((string-equal (system-name) "ES99P4brP0pSx2I")
  (my/load-config-recursively (expand-file-name "config-work" doom-user-dir)))
 (t
  (my/load-config-recursively (expand-file-name "config-personal" doom-user-dir))))

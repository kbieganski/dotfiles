;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;(require 'arc-theme)
;;(load-file "kb-theme.el")
;; User info
(setq user-full-name "Krzysztof Biegański"
      user-mail-address "krzysztof@biegan.ski")

;; Fonts
(setq doom-font (font-spec :family "Iosevka" :size 13))
(setq doom-big-font (font-spec :family "Iosevka" :size 20))
(setq doom-variable-pitch-font (font-spec :family "Jost*" :size 12))

;; Theme
(setq doom-theme 'doom-kb)

;; Normal line numbers
(setq display-line-numbers-type t)

(setq scroll-margin 5)

(evil-define-key* '(normal visual) 'global (kbd "J") (lambda () (interactive) (scroll-up 2)))
(evil-define-key* '(normal visual) 'global (kbd "K") (lambda () (interactive) (scroll-down 2)))
;(general-define-key
; :states '(normal visual)
; "J" (lambda () (interactive) (scroll-up 2))
; "K" (lambda () (interactive) (scroll-down 2)))

;; A bit of frame transparency
(defconst frame-transparency 90)
(set-frame-parameter (selected-frame) 'alpha frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,frame-transparency))
;; (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 90)))

;; Enable word wrap everywhere
(+global-word-wrap-mode +1)

;(add-hook 'kill-emacs-hook #'doom/quicksave-session)
;;(add-hook 'window-setup-hook #'doom/quickload-session)

(setq deft-directory "~/notes"
      deft-extensions '("md")
      deft-recursive t)

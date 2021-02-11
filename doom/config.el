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
(evil-define-key* '(normal visual) 'global (kbd "H") (lambda () (interactive) (evil-jump-backward)))
(evil-define-key* '(normal visual) 'global (kbd "L") (lambda () (interactive) (evil-jump-forward)))
(map! :leader "m t" 'smerge-mode :desc "Merge mode toggle")
(map! :leader "m n" 'smerge-next :desc "Next conflict")
(map! :leader "m N" 'smerge-prev :desc "Prev conflict")
(map! :leader "m j" 'smerge-keep-lower :desc "Keep lower")
(map! :leader "m k" 'smerge-keep-upper :desc "Keep upper")

(setq-default evil-kill-on-visual-paste nil)

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

(add-hook 'kill-emacs-hook #'doom/quicksave-session)
(run-at-time 60 t #'doom/save-session)

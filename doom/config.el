;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; User info
(setq user-full-name "Krzysztof Biegański"
      user-mail-address "krzysztof@biegan.ski")

;; Fonts
(setq doom-font (font-spec :family "Iosevka" :size 14))
(setq doom-big-font (font-spec :family "Iosevka" :size 20))
(setq doom-variable-pitch-font (font-spec :family "Jost*" :size 12))

;; Theme
(setq doom-theme 'doom-dracula)

;; Normal line numbers
(setq display-line-numbers-type t)

;; Fix for modeline being too tall
(setq doom-modeline-icon nil)

;; A bit of frame transparency
(defconst frame-transparency 90)
(set-frame-parameter (selected-frame) 'alpha frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,frame-transparency))

;; Enable word wrap everywhere
(+global-word-wrap-mode +1)

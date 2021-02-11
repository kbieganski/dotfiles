
(setq doom-localleader-key "SPC l")

(doom! :completion
       company
       (ivy +icons)

       :ui
       deft
       doom
       doom-dashboard
       doom-quit
       hl-todo
       modeline
       ophints
       (popup +defaults)
       tabs
       treemacs
       unicode
       vc-gutter
       vi-tilde-fringe
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       format
       multiple-cursors
       snippets
       word-wrap

       :emacs
       (dired +ranger +icons)
       electric
       undo
       vc

       :checkers
       spell
       grammar

       :tools
       (eval +overlay)
       lsp
       magit
       rgb

       :lang
       (cc +lsp)
       data
       emacs-lisp
       (go +lsp)
       json
       javascript
       markdown
       (org +pretty +dragndrop)
       (python +lsp)
       rst
       (rust +lsp)
       sh
       web
       yaml

       :config
       (default +bindings +smartparens))

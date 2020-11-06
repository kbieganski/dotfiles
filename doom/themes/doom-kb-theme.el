;;; doom-kb-theme.el --- Opera-Light theme -*- no-byte-compile: t; -*-

(require 'doom-themes)

(defgroup doom-kb-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(defcustom doom-kb-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-kb-theme
  :type 'boolean)

(defcustom doom-kb-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-kb-theme
  :type 'boolean)

(defcustom doom-kb-comment-bg doom-kb-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-kb-theme
  :type 'boolean)

(defcustom doom-kb-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-kb-theme
  :type '(choice integer boolean))

(defcustom doom-kb-region-highlight t
  "Determines the selection highlight style. Can be 'frost, 'snowstorm or t
(default)."
  :group 'doom-kb-theme
  :type 'symbol)

(def-doom-theme doom-kb
  "A light Opera theme."

  ;; name        default   256       16
  ((bg         '("#e7e8eb" nil       nil ))
   (bg-alt     '("#e0e0e0" nil       nil ))
   (base0      '("#fafafa" "#dfdfdf" nil ))
   (base1      '("#f5f5f5" "#979797" nil ))
   (base2      '("#eeeeee" "#6b6b6b" nil ))
   (base3      '("#e0e0e0" "#525252" nil ))
   (base4      '("#bdbdbd" "#3f3f3f" nil ))
   (base5      '("#9e9e9e" "#262626" nil ))
   (base6      '("#858585" "#2e2e2e" nil ))
   (base7      '("#616161" "#1e1e1e" nil ))
   (base8      '("#424242" "black"   nil ))
   (fg         '("#4e5157" "#2a2a2a" nil ))
   (fg-alt     '("#4e5157" "#2a2a2a" nil ))

   (grey       base4)
   (red        '("#8c5a5a" "#ff6655" nil ))
   (orange     '("#8c6d5a" "#dd8844" nil ))
   (green      '("#5a8c5f" "#99bb66" nil ))
   (teal       '("#5a8c89" "#44b9b1" nil ))
   (yellow     '("#8c845a" "#ECBE7B" nil ))
   (blue       '("#5294e2" "#51afef" nil ))
   (dark-blue  '("#5a6b8c" "#2257A0" nil ))
   (magenta    '("#8c5a7e" "#c678dd" nil ))
   (violet     '("#745a8c" "#a9a1e1" nil ))
   (cyan       '("#398eac" "#46D9FF" nil ))
   (dark-cyan  '("#5a8c86" "#5699AF" nil ))

   ;; face categories -- required for all themes
   (highlight      blue)
   (vertical-bar   (doom-darken base1 0.2))
   (selection      dark-blue)
   (builtin        teal)
   (comments       (if doom-kb-brighter-comments dark-cyan (doom-lighten base6 0.2)))
   (doc-comments   (doom-lighten (if doom-kb-brighter-comments dark-cyan base6) 0.25))
   (constants      magenta)
   (functions      teal)
   (keywords       blue)
   (methods        teal)
   (operators      blue)
   (type           yellow)
   (strings        green)
   (variables      magenta)
   (numbers        violet)
   (region         base4)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-modeline-bright doom-kb-brighter-modeline)
   (-modeline-pad
    (when doom-kb-padded-modeline
      (if (integerp doom-kb-padded-modeline) doom-kb-padded-modeline 4)))

   (modeline-fg     nil)
   (modeline-fg-alt base5)

   (modeline-bg
    (if -modeline-bright
        (doom-darken blue 0.475)
      `(,(doom-darken (car bg-alt) 0.15) ,@(cdr base0))))
   (modeline-bg-l
    (if -modeline-bright
        (doom-darken blue 0.45)
      `(,(doom-darken (car bg-alt) 0.1) ,@(cdr base0))))
   (modeline-bg-inactive   (doom-darken bg-alt 0.1))
   (modeline-bg-inactive-l `(,(car bg-alt) ,@(cdr base1))))

  ;; --- extra faces ------------------------
  (
   ((lazy-highlight &override) :foreground base1 :weight 'bold)
   ((line-number &override) :foreground fg-alt)
   ((line-number-current-line &override) :foreground fg)

   (font-lock-comment-face
    :foreground comments
    :background (if doom-kb-comment-bg (doom-lighten bg 0.05)))
   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)

   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))

   ;; ivy-posframe
   (ivy-posframe :background bg-alt)
   (ivy-posframe-border :background base1)

   ;; ivy
   (ivy-current-match :background base3)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if -modeline-bright base8 highlight))

   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))))

;;; doom-kb-theme.el ends here

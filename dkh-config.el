
(starter-kit-load "misc-recommended")

(message "emacs-init started ...")
(setq debug-on-error t)

;; added by dkh
(add-to-list 'load-path (concat user-emacs-directory "el-get/el-get"))

(setq load-path
      (append (list nil
                    )
              load-path))


(add-to-list 'load-path (expand-file-name "~/git/foss/org-mode/contrib/lisp"))

(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(setq
 el-get-sources
 '(
   (:name eproject :type git :url "https://github.com/jrockway/eproject.git" :features "eproject-extras")
   ))


;; now set our own packages
(setq
 my:el-get-packages
 '(
   auto-install
   autosmiley
   bbdb
   browse-kill-ring+
calfw
   color-theme
   dictem
   el-get ; el-get is self-hosting
   emacs-w3m
   emoticons
   erc-highlight-nicknames
   erc-track-score
   face-list
   fliptext
   grep+
nognus
   key-chord
   keychain-environment
   paste2
   protbuf
   savehist-20+
   second-sel
   tail
   thing-cmds ;; for thing-region
   thingatpt-ext ;; for 'string
   ))


(when (el-get-executable-find "svn")
  (loop for p in '(psvn                 ; M-x svn-status
                   )
        do (add-to-list 'el-get-sources p)))


(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

(defun rwd-require-package (name)
(or (package-installed-p name) (package-install name)))

(setq dkh-required-packages
      (list
        'auctex
        'auto-indent-mode
        'bitlbee
        'bm
        'bookmark+
        'browse-kill-ring
        'buffer-move
        'color-theme-solarized
        'etags-select
        'expand-region
        'fill-column-indicator
        'js2-mode
        'lorem-ipsum
        'magit
        'nav
        'oauth2
        'org2blog
        'org-mime
        'pastebin
        'perspective
        'php-mode
        'rainbow-delimiters
        'rainbow-mode
        'rotate-text
        'sauron
        'session
        'smex
        'switch-window
        'synonyms
        'undo-tree
        'window-number
        'winpoint
        'xml-rpc
        'yaml-mode
))

(package-refresh-contents)
(dolist (package dkh-required-packages) (when (not (package-installed-p package)) (package-install package)))

(setq custom-file "~/git/.emacs.d/custom.el")

(setq default-directory "~/git/")

(setq savehist-file "~/.emacs.d/history")

(setq ispell-personal-dictionary "~/git/.emacs.d/.aspell.LANG.pws")

(setq message-log-max 1000)

(setq initial-scratch-message "ಠ_ಠ")
;; empty out the comments on the scratch buffer, (i hate that text)

;; Enable all disabled commands (eval-expression, narrow-to-..., etc.)
(setq disabled-command-function nil)

(setq pop-up-windows nil)

(add-to-list 'same-window-buffer-names "*Help*")
(add-to-list 'same-window-buffer-names "*Apropos*")
(add-to-list 'same-window-buffer-names "*Summary*")
 (add-to-list 'same-window-buffer-names "*Backtrace*")



;; Define buffers that should appear in the same window.
(add-to-list 'same-window-buffer-names "*Buffer List*")
(add-to-list 'same-window-buffer-names "*Colors*")
(add-to-list 'same-window-buffer-names "*Command History*")
(add-to-list 'same-window-buffer-names "*Diff*")
(add-to-list 'same-window-buffer-names "*Proced*")
(add-to-list 'same-window-buffer-names "*vc-dir*")
(add-to-list 'same-window-buffer-names "*SQL*")
(add-to-list 'same-window-buffer-names "scratch.org")


(setq same-window-regexps '(
                          "\*grep\*"
))

(add-to-list 'same-window-regexps "\\*compilation\\*\\(\\|<[0-9]+>\\)")
(add-to-list 'same-window-regexps "\\*Help\\*\\(\\|<[0-9]+>\\)")

(add-to-list 'same-window-regexps "\\*Shell Command Output\\*\\(\\|<[0-9]+>\\)")

(add-to-list 'same-window-regexps "\\*dictem.*")

(icomplete-mode 1)

(setq sentence-end-double-space nil)

(global-set-key (kbd "RET") 'newline-and-indent)

(scroll-bar-mode -1)                   ;; turn off the scrollbar
;;(scroll-bar-mode 1)                       ;; otherwise, show a scrollbar...
;;(set-scroll-bar-mode 'right))             ;; ... on the right

(setq session-save-file "~/.emacs.d/.session")

(setq mswindows-p (string-match "windows" (symbol-name system-type)))
(setq macosx-p (string-match "darwin" (symbol-name system-type)))
(setq linux-p (string-match "gnu/linux" (symbol-name system-type)))

;; We know we have consolas on OS X, so use it
;; We also need to do this as near the beginning as possible, since it crashes
;; otherwise?
(when (and macosx-p
  (when (member "Consolas" (font-family-list))
    (set-face-font 'default "consolas-11"))))
(when mswindows-p
  (set-face-font 'default "consolas-8"))
(when linux-p
  (when (member "Inconsolata" (font-family-list))
;;    (set-face-font 'default "inconsolata-11")
;;    (set-face-font 'default "DejaVu Sans Mono-9")
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-12"))
))

(when macosx-p
  ;;Change meta to alt
  (setq mac-command-modifier 'meta)
  ;;avoid hiding with M-h
  (setq mac-pass-command-to-system nil))

(defun merge-x-resources ()
  (let ((file (file-name-nondirectory (buffer-file-name))))
    (when (or (string= file ".Xdefaults")
              (string= file ".Xresources"))
      (start-process "xrdb" nil "xrdb" "-merge" (buffer-file-name))
      (message (format "Merged %s into X resource database" file)))))

(add-hook 'after-save-hook 'merge-x-resources)

;; avoid Emacs hanging for a while changing default font
(modify-frame-parameters nil '((wait-for-wm . nil)))

(defun cycle-font (num)
  "Change font in current frame.
Each time this is called, font cycles thru a predefined set of fonts.
If NUM is 1, cycle forward.
If NUM is -1, cycle backward.
Warning: tested on Windows Vista only."
  (interactive "p")
  ;; this function sets a property “state”. It is a integer. Possible values are any index to the fontList.
  (let (fontList fontToUse currentState nextState )
    (setq fontList (list
                    "Courier New-10" "DejaVu Sans Mono-9"
;;"Lucida Console-10"
                    "DejaVu Sans-10"
;; "Lucida Sans Unicode-10"
;; "Arial Unicode MS-10" 
;;                    "inconsolata-11"
"DejaVu Sans Mono-9" "DejaVu Sans Mono-10" "DejaVu Sans Mono-12"
))
    ;; fixed-width "Courier New" "Unifont"  "FixedsysTTF" "Miriam Fixed" "Lucida Console" "Lucida Sans Typewriter"
    ;; variable-width "Code2000"
    (setq currentState (if (get 'cycle-font 'state) (get 'cycle-font 'state) 0))
    (setq nextState (% (+ currentState (length fontList) num) (length fontList)))

    (setq fontToUse (nth nextState fontList))
    (set-frame-parameter nil 'font fontToUse)
    (redraw-frame (selected-frame))
    (message "Current font is: %s" fontToUse )

    (put 'cycle-font 'state nextState)
    )
  )

(defun cycle-font-forward ()
  "Switch to the next font, in the current frame.
See `cycle-font'."
  (interactive)
  (cycle-font 1)
  )

(defun cycle-font-backward ()
  "Switch to the previous font, in the current frame.
See `cycle-font'."
  (interactive)
  (cycle-font -1)
  )

;; enable recent files mode.
(recentf-mode t)

(setq recentf-save-file "~/.emacs.d/recentf")

(setq enable-recursive-minibuffers t)

(require 'keychain-environment)

(setq delete-old-versions t)

(require 'flyspell)

(setq flyspell-use-meta-tab nil)

(add-hook 'c-mode-common-hook 'flyspell-prog-mode)
(add-hook 'tcl-mode-hook 'flyspell-prog-mode)

(defun set-frame-size-according-to-resolution ()
    (interactive)
    (if window-system
    (progn
      (if (> (x-display-pixel-width) 1500) ;; 1500 is the delimiter marging in px to consider the screen big
             (set-frame-width (selected-frame) 237) ;; on the big screen make the fram 237 columns big
             (set-frame-width (selected-frame) 177)) ;; on the small screen we use 177 columns
      (setq my-height (/ (- (x-display-pixel-height) 150) ;; cut 150 px of the screen height and use the rest as height for the frame
                               (frame-char-height)))
      (set-frame-height (selected-frame) my-height)
      (set-frame-position (selected-frame) 3 90) ;; position the frame 3 pixels left and 90 px down
  )))

  ;; (set-frame-size-according-to-resolution)
  (global-set-key (kbd "C-x 9") 'set-frame-size-according-to-resolution)

(setq frame-title-format
  '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))

(require 'switch-window)

(setq default-indicate-empty-lines t)

(setq windmove-wrap-around t)

(require 'window-number)
(window-number-mode)
(window-number-meta-mode)

;;; switch

;; Experiment with more convenient keys than `C-x o' and `M-- C-x o'.
(define-key global-map [(hyper ?\x8a7)] 'other-window)
(define-key global-map [(hyper ?\x8bd)] (lambda () (interactive) (other-window -1)))
(define-key global-map [(hyper ?\247)] 'other-window)
(define-key global-map [(hyper ?\275)] (lambda () (interactive) (other-window -1)))
(define-key global-map [(hyper ?`)] 'other-window)
(define-key global-map [(hyper ?~)] (lambda () (interactive) (other-window -1)))
(define-key global-map [(hyper ?<)] 'other-window)
(define-key global-map [(hyper ?>)] (lambda () (interactive) (other-window -1)))
(define-key global-map [(hyper ?,)] 'other-window)
(define-key global-map [(hyper ?.)] (lambda () (interactive) (other-window -1)))
(define-key global-map [(hyper print)] 'other-window)

(defun my-swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2))
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

(defun my-toggle-window-split ()
  "Vertical split shows more of each line, horizontal split shows
more lines. This code toggles between them. It only works for
frames with exactly two windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;; I want to be able to conmute between a split and a single window (sort of "C-x 1" for the one on focus)
(defun toggle-windows-split()
"Switch back and forth between one window and whatever split of windows we might have in the frame. The idea is to maximize the current buffer, while being able to go back to the previous split of windows in the frame simply by calling this command again."
(interactive)
(if (not(window-minibuffer-p (selected-window)))
(progn
(if (< 1 (count-windows))
(progn
(window-configuration-to-register ?u)
(delete-other-windows))
(jump-to-register ?u))))
;;(my-iswitchb-close)
)

(defun split-window-switch-buffer () (interactive)
  "Split current window and display the two last buffers used."
  (split-window)
  (switch-to-buffer (other-buffer (current-buffer)))
  )

(defun hsplit-window-switch-buffer () (interactive)
  "Split current window horizontally and display the two last buffers used."
  (split-window-horizontally)
  (switch-to-buffer (other-buffer (current-buffer)))
  )

(setq swapping-buffer nil)
(setq swapping-window nil)

(defun swap-buffers-in-windows ()
  "Swap buffers between two windows"
  (interactive)
  (if (and swapping-window
           swapping-buffer)
      (let ((this-buffer (current-buffer))
            (this-window (selected-window)))
        (if (and (window-live-p swapping-window)
                 (buffer-live-p swapping-buffer))
            (progn (switch-to-buffer swapping-buffer)
                   (select-window swapping-window)
                   (switch-to-buffer this-buffer)
                   (select-window this-window)
                   (message "Swapped buffers."))
          (message "Old buffer/window killed.  Aborting."))
        (setq swapping-buffer nil)
        (setq swapping-window nil))
    (progn
      (setq swapping-buffer (current-buffer))
      (setq swapping-window (selected-window))
      (message "Buffer and window marked for swapping."))))

(defun rotate-windows ()
 "Rotate your windows" (interactive) (cond ((not (> (count-windows) 1)) (message "You can't rotate a single window!"))
(t
 (setq i 1)
 (setq numWindows (count-windows))
 (while  (< i numWindows)
   (let* (
          (w1 (elt (window-list) i))
          (w2 (elt (window-list) (+ (% i numWindows) 1)))

          (b1 (window-buffer w1))
          (b2 (window-buffer w2))

          (s1 (window-start w1))
          (s2 (window-start w2))
          )
     (set-window-buffer w1  b2)
     (set-window-buffer w2 b1)
     (set-window-start w1 s2)
     (set-window-start w2 s1)
     (setq i (1+ i)))))))

(require 'buffer-move)

(defun select-next-window ()
  "Switch to the next window" 
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window" 
  (interactive)
  (select-window (previous-window)))

(defun buffer-same-mode (change-buffer-fun)
  (let ((current-mode major-mode)
        (next-mode nil))
    (while (not (eq next-mode current-mode))
      (funcall change-buffer-fun)
      (setq next-mode major-mode))))

(defun previous-buffer-same-mode ()
  (interactive)
  (buffer-same-mode #'previous-buffer))

(defun next-buffer-same-mode ()
  (interactive)
  (buffer-same-mode #'next-buffer))

(global-set-key [H-tab] 'previous-buffer-same-mode)
(global-set-key [C-H-tab] 'next-buffer-same-mode)

; a feature to preserve split pane configuration. Use 【Ctrl+c ←】 and 【Ctrl+c →】
(when (fboundp 'winner-mode) (winner-mode 1))

;;----------------------------------------------------------------------------
;; When splitting window, show (other-buffer) in the new window
;;----------------------------------------------------------------------------
(defun split-window-func-with-other-buffer (split-function)
  (lexical-let ((s-f split-function))
    (lambda ()
      (interactive)
      (funcall s-f)
      (set-window-buffer (next-window) (other-buffer)))))

(global-set-key "\C-x2" (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key "\C-x3" (split-window-func-with-other-buffer 'split-window-horizontally))

;;----------------------------------------------------------------------------
;; Rearrange split windows
;;----------------------------------------------------------------------------
(defun split-window-horizontally-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-horizontally))))

(defun split-window-vertically-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-vertically))))

(global-set-key "\C-x|" 'split-window-horizontally-instead)
(global-set-key "\C-x_" 'split-window-vertically-instead)

;; have pasting work right in emacs 24
(setq x-select-enable-primary t)

(delete-selection-mode t)

(setq x-select-enable-clipboard t)

(setq completion-ignore-case t)

(setq completion-ignored-extensions
      (append (list
                    ".bak"
                  ".old"
                  ".tar"
                  ".new"
                  ".tar.gz"
                  ".jeff"
                    )
              completion-ignored-extensions))

(defconst pcmpl-git-commands
  '("add" "bisect" "branch" "checkout" "clone"
    "commit" "diff" "fetch" "grep"
    "init" "log" "merge" "mv" "pull" "push" "rebase"
    "reset" "rm" "show" "status" "tag" )
  "List of `git' commands")
 
(defvar pcmpl-git-ref-list-cmd "git for-each-ref refs/ --format='%(refname)'"
  "The `git' command to run to get a list of refs")
 
(defun pcmpl-git-get-refs (type)
  "Return a list of `git' refs filtered by TYPE"
  (with-temp-buffer
    (insert (shell-command-to-string pcmpl-git-ref-list-cmd))
    (goto-char (point-min))
    (let ((ref-list))
      (while (re-search-forward (concat "^refs/" type "/\\(.+\\)$") nil t)
        (add-to-list 'ref-list (match-string 1)))
      ref-list)))
 
(defun pcomplete/git ()
  "Completion for `git'"
  ;; Completion for the command argument.
  (pcomplete-here* pcmpl-git-commands)  
  ;; complete files/dirs forever if the command is `add' or `rm'
  (cond
   ((pcomplete-match (regexp-opt '("add" "rm")) 1)
    (while (pcomplete-here (pcomplete-entries))))
   ;; provide branch completion for the command `checkout'.
   ((pcomplete-match "checkout" 1)
    (pcomplete-here* (pcmpl-git-get-refs "heads")))))

(size-indication-mode)

(if (require 'sml-modeline nil 'noerror)    
  (progn (sml-modeline-mode 1) mode line))

(when (require 'diminish nil 'noerror)
  (eval-after-load "company"
      '(diminish 'company-mode "Cmp"))
  (eval-after-load "abbrev"
    '(diminish 'abbrev-mode "Ab"))
  (eval-after-load "yasnippet"
    '(diminish 'yas/minor-mode "Y")))

;; And the major-modes, for example for Emacs Lisp mode:

(add-hook 'emacs-lisp-mode-hook 
  (lambda()
    (setq mode-name "el")))

(add-hook 'find-file-hooks 'goto-address-prog-mode)

(require 'color-theme)
(require 'color-theme-solarized)
(load-theme 'solarized-dark t)
;;(setq solarized-termcolors "256")

(require 'rainbow-mode)
(rainbow-mode t)
(setq rainbow-x-colors t)
(require 'rainbow-delimiters)

(when (require 'rainbow-delimiters nil 'noerror)
  (progn
    (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode))
    (add-hook 'js2-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'c-mode-common-hook 'rainbow-delimiters-mode)
    (add-hook 'php-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode))

(setq list-colors-sort 'hsv )

(require 'winpoint)
(window-point-remember-mode 1)

(require 'saveplace)                          ;; get the package

(when (require 'goto-last-change nil 'noerror)
  (global-set-key (kbd "C-x C-/") 'goto-last-change))

(add-to-list 'load-path "~/.emacs.d/src/expand-region.el")
(require 'expand-region)
(global-set-key (kbd "H-SPC") 'er/expand-region)

(defun er/add-text-mode-expansions ()
  (make-variable-buffer-local 'er/try-expand-list)
  (setq er/try-expand-list (append
                            er/try-expand-list
                            '(mark-paragraph
                              mark-page))))

(add-hook 'text-mode-hook 'er/add-text-mode-expansions)

(defun get-selection-or-unit  (unit)
  "Return the string and boundary of text selection or UNIT under cursor.

If `region-active-p' is true, then the region is the unit. Else,
it depends on the UNIT. See `unit-at-cursor' for detail about
UNIT.

Returns a vector [text a b], where text is the string and a and b
are its boundary."
  (interactive)

  (let (mytext p1 p2)
    (if (region-active-p)
        (progn
          (setq p1 (region-beginning))
          (setq p2 (region-end))
          (setq mytext (buffer-substring p1 p2) )
          (vector (buffer-substring-no-properties p1 p2) p1 p2 )
          )
      (unit-at-cursor unit)
 ) ) )

(defun unit-at-cursor  (unit)
  "Return the string and boundary of UNIT under cursor.

Returns a vector [text a b], where text is the string and a and b are its boundary.

UNIT can be:
• 'word — sequence of 0 to 9, A to Z, a to z, and hyphen.
• 'glyphs — sequence of visible glyphs. Useful for file name, url, …, that doesn't have spaces in it.
• 'line — delimited by “\\n”.
• 'block — delimited by “\\n\\n” or beginning/end of buffer.
• 'buffer — whole buffer. (respects `narrow-to-region')
• a vector [beginRegex endRegex] — The elements are regex strings used to determine the beginning/end of boundary chars. They are passed to `skip-chars-backward' and `skip-chars-forward'. For example, if you want paren as delimiter, use [\"^(\" \"^)\"]

Example usage:
    (setq bds (unit-at-cursor 'line))
    (setq myText (elt bds 0) p1 (elt bds 1) p2 (elt bds 2)  )

This function is similar to `thing-at-point' and `bounds-of-thing-at-point'.
The main differences are:
• this function returns the text and the 2 boundaries as a vector in one shot.
• 'line always returns the line without end of line character, avoiding inconsistency when the line is at end of buffer.
• 'word does not depend on syntax table.
• 'block does not depend on syntax table."
  (let (p1 p2)
    (save-excursion
        (cond
         ( (eq unit 'word)
           (let ((wordcharset "-A-Za-zÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ"))
             (skip-chars-backward wordcharset)
             (setq p1 (point))
             (skip-chars-forward wordcharset)
             (setq p2 (point)))
           )

         ( (eq unit 'glyphs)
           (progn
             (skip-chars-backward "[:graph:]")
             (setq p1 (point))
             (skip-chars-forward "[:graph:]")
             (setq p2 (point)))
           )

         ( (eq unit 'buffer)
           (progn
             (setq p1 (point-min))
             (setq p2 (point-max))
             )
           )

         ((eq unit 'line)
          (progn
            (setq p1 (line-beginning-position))
            (setq p2 (line-end-position))))
         ((eq unit 'block)
          (progn
            (if (re-search-backward "\n\n" nil t)
                (progn (forward-char 2)
                       (setq p1 (point) ) )
              (setq p1 (line-beginning-position) )
              )

            (if (re-search-forward "\n\n" nil t)
                (progn (backward-char)
                       (setq p2 (point) ))
              (setq p2 (line-end-position) ) ) ))

         ((vectorp unit)
          (let (p0)
             (setq p0 (point))
             (skip-chars-backward (elt unit 0))
             (setq p1 (point))
             (goto-char p0)
             (skip-chars-forward (elt unit 1))
             (setq p2 (point))))
         ) )

    (vector (buffer-substring-no-properties p1 p2) p1 p2 )
    ) )

(defun region-or-thing (thing)
  "Return a vector containing the region and its bounds if there is one
or the thing at the point and its bounds if there is no region"
  (if (use-region-p)
      (vector (buffer-substring-no-properties (region-beginning) (region-end))
              (region-beginning) (region-end))
    (let* ((bounds (bounds-of-thing-at-point thing))
           (beg (car bounds))
           (end (cdr bounds)))
      (vector (buffer-substring-no-properties beg end) beg end))))

(defun google-search ()
  "Do a Google search of the region or symbol at the point"
  (interactive)
  (let ((phrase (elt (region-or-thing 'symbol) 0)))
    (browse-url (concat "http://www.google.com/search?q="
                        (replace-regexp-in-string " " "+" phrase)))))

(defun sacha/search-word-backward ()
  "Find the previous occurrence of the current word."
  (interactive)
  (let ((cur (point)))
    (skip-syntax-backward "w_")
    (goto-char
     (if (re-search-backward (concat "\\_<" (current-word) "\\_>") nil t)
         (match-beginning 0)
       cur))))

(defun sacha/search-word-forward ()
  "Find the next occurrence of the current word."
  (interactive)
  (let ((cur (point)))
    (skip-syntax-forward "w_")
    (goto-char
     (if (re-search-forward (concat "\\_<" (current-word) "\\_>") nil t)
         (match-beginning 0)
       cur))))

(global-set-key (kbd "C-H-r") 'sacha/search-word-backward)
(global-set-key (kbd "C-H-s") 'sacha/search-word-forward)
(defadvice search-for-keyword (around sacha activate)
  "Match in a case-insensitive way."
  (let ((case-fold-search t))
    ad-do-it))

(defun ash-forward-string (&optional arg)
  "Move forward to ARGth string."
  (setq arg (or arg 1))
  (if (not (bobp))
      (save-match-data
        (when (or (and (looking-at-p "\\s-*\"")
                       (not (looking-back "\\\\")))
                  (re-search-backward "[^\\\\]\"" nil nil))
          (looking-at "\\s-*\"")
          (goto-char (match-end 0))
          (forward-char -1))))
  (while (and (> arg 0)
              (not (eobp))
              (looking-at-p "\\s-*\""))
    (forward-sexp 1)
    (setq arg (1- arg)))
  (while (and (< arg 0)
              (not (bobp))
              (looking-at-p "\""))
    (forward-sexp -1)
    (setq arg (1+ arg)))
  (ignore))

(put 'string 'forward-op 'ash-forward-string)

(defun ash-kill-string (&optional arg) 
  "Kill ARG strings under point."
  (interactive "*p")
  (setq arg (or (and (not (zerop arg)) arg) 1))
  (if (> arg 0)
      (kill-region
       (progn (forward-thing 'string 0) (point))
       (progn (forward-thing 'string arg) (point)))
    (kill-region
     (progn (forward-thing 'string 1) (point))
     (progn (forward-thing 'string arg) (point)))))

(defun translate ()
  "Translate the word at point using WordReference."
  (interactive)
  (browse-url (concat "http://www.wordreference.com/fren/" 
              (thing-at-point 'word)))
)

(defun answers-define ()
  "Look up the word under cursor in a browser."
  (interactive)
  (browse-url
   (concat "http://www.answers.com/main/ntquery?s="
           (thing-at-point 'word))))

(defun my-replace-region ()
  (interactive)
  (unless (use-region-p)
    (error "no region"))
  (let ((what (buffer-substring-no-properties
               (region-beginning) (region-end)))
        (replacement (read-string "replace with: ")))
    (save-excursion
      (goto-char (point-min))
      (while (search-forward what nil t)
        (replace-match replacement)))))

(defun kill-save-rectangle (start end &optional fill)       
  "Save the rectangle as if killed, but don't kill it.  See 
`kill-rectangle' for more information."                     
  (interactive "r\nP")                                      
  (kill-rectangle start end fill)                           
  (goto-char start)                                         
  (yank-rectangle))

(global-set-key (kbd "C-x r M-k") 'kill-save-rectangle)

(defun confirm-exit-emacs ()
        "ask for confirmation before exiting emacs"
        (interactive)
        (if (yes-or-no-p "Are you sure you want to exit? ")
                (save-buffers-kill-emacs)))

(global-unset-key "\C-x\C-c")
(global-set-key "\C-x\C-c" 'confirm-exit-emacs)

(global-auto-revert-mode 1)

(setq abbrev-file-name "~/git/.emacs.d/.abbrev_defs")
(read-abbrev-file abbrev-file-name t)
(setq dabbrev-case-replace nil)  ; Preserve case when expanding
(setq abbrev-mode t)
(setq-default abbrev-mode t)

(require 'savehist-20+)
(savehist-mode 1)

;; provided by snogglethorpe
(defcustom mode-line-bell-string "ding" ;"â™ª"
  "Message displayed in mode-line by `mode-line-bell' function."
  :group 'user)
(defcustom mode-line-bell-delay 1.0
  "Number of seconds `mode-line-bell' displays its message."
  :group 'user)

;; internal variables
(defvar mode-line-bell-cached-string nil)
(defvar mode-line-bell-propertized-string nil)

(defun mode-line-bell ()
  "Briefly display a highlighted message in the mode-line.

  The string displayed is the value of `mode-line-bell-string',
  with a red background; the background highlighting extends to the
  right margin.  The string is displayed for `mode-line-bell-delay'
  seconds.

  This function is intended to be used as a value of `ring-bell-function'."

  (unless (equal mode-line-bell-string mode-line-bell-cached-string)
    (setq mode-line-bell-propertized-string
          (propertize
           (concat
            (propertize
             "x"
             'display
             `(space :align-to (- right ,(string-width mode-line-bell-string))))
            mode-line-bell-string)
           'face '(:background "red")))
    (setq mode-line-bell-cached-string mode-line-bell-string))
  (message mode-line-bell-propertized-string)
  (sit-for mode-line-bell-delay)
  (message ""))

(setq ring-bell-function 'mode-line-bell)

(add-hook 'emacs-lisp-mode-hook (lambda () (add-hook 'after-save-hook 'emacs-lisp-byte-compile t t)) )

(add-hook 'after-save-hook
  'executable-make-buffer-file-executable-if-script-p)

(blink-cursor-mode 1)

(defvar blink-cursor-colors (list  "#92c48f" "#6785c5" "#be369c" "#d9ca65")
  "On each blink the cursor will cycle to the next color in this list.")

(setq blink-cursor-count 0)

(defun blink-cursor-timer-function ()
  "Cyberpunk variant of timer `blink-cursor-timer'. OVERWRITES original version in `frame.el'.

This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
  (when (not (internal-show-cursor-p))
    (when (>= blink-cursor-count (length blink-cursor-colors))
      (setq blink-cursor-count 0))
    (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
    (setq blink-cursor-count (+ 1 blink-cursor-count))
    )
  (internal-show-cursor nil (not (internal-show-cursor-p)))
  )

(cua-selection-mode t)

(global-set-key "\M-[" 'cua-set-rectangle-mark)

(require 'fill-column-indicator)

(setq fci-rule-width 1)
(setq fci-rule-color "darkblue")

(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

(require 'key-chord)
(key-chord-mode 1)

(key-chord-define-global "''"     "`'\C-b")
(key-chord-define-global ",,"     'indent-for-comment)
(key-chord-define-global "qq"     "the ")
(key-chord-define-global "QQ"     "The ")
(key-chord-define-global ",."     'append-next-kill)
(key-chord-define-global "4r"     "$")
(key-chord-define-global "jk" 'goto-line)
(key-chord-define-global "df"     'bookmark-jump)
(key-chord-define-global "sd"     'er/expand-region)
(key-chord-define-global "kl"     'dabbrev-expand)
(key-chord-define-global "AS" 'my-swap-windows)
(key-chord-define-global "SD" 'my-toggle-window-split)
(key-chord-define-global "DF" 'toggle-windows-split)
(key-chord-define-global "FG" 'split-window-switch-buffer)
(key-chord-define-global "GH" 'hsplit-window-switch-buffer)
(key-chord-define-global "JK" 'rotate-windows)
(key-chord-define-global "KL" 'swap-buffers-in-windows)
(key-chord-define-global "L:" 'transpose-windows)

(setq linum-mode-inhibit-modes-list '(eshell-mode                                                 
                                      shell-mode                                                  
                                      erc-mode                                                    
                                      jabber-roster-mode                                          
                                      jabber-chat-mode                                            
                                      gnus-group-mode                                             
                                      gnus-summary-mode                                           
                                      gnus-article-mode))                                         
                                                                                                  
(defadvice linum-on (around linum-on-inhibit-for-modes)                                           
  "Stop the load of linum-mode for some major modes."                                             
    (unless (member major-mode linum-mode-inhibit-modes-list)                                     
      ad-do-it))                                                                                  
                                                                                                  
(ad-activate 'linum-on)

(require 'rotate-text)
(autoload 'rotate-text "rotate-text" nil t)
(autoload 'rotate-text-backward "rotate-text" nil t)

(if (require 'artbollocks-mode nil t)
    (progn
      (setq weasel-words-regex
            (concat "\\b" (regexp-opt
                           '("one of the"
                             "should"
                             "just"
                             "sort of"
                             "a lot"
                             "probably"
                             "maybe"
                             "perhaps"
                             "I think"
                             "really"
                             "pretty"
                             "maybe"
                             "nice"
                             "action"
                             "utilize"
                             "leverage") t) "\\b"))
      ;; Fix a bug in the regular expression to catch repeated words
      (setq lexical-illusions-regex "\\b\\(\\w+\\)\\W+\\(\\1\\)\\b")
      ;; Don't show the art critic words, or at least until I figure
      ;; out my own jargon
      (setq artbollocks nil)
      (add-hook 'org-capture-mode-hook 'artbollocks-mode)

      ))

(if (require 'miniedit nil t)
    (miniedit-install))

(require 'auto-indent-mode)

(require 'browse-kill-ring)

;;(when (require 'browse-kill-ring nil 'noerror)
;;  (browse-kill-ring-default-keybindings))

(global-set-key (kbd "C-M-y") '(lambda ()
   (interactive)
   (popup-menu 'yank-menu)))

(require 'second-sel)
(require 'browse-kill-ring+)

(require 'undo-tree)
(global-undo-tree-mode 1)

(defalias 'redo 'undo-tree-redo)

(global-set-key (kbd "C-z") 'undo) ; 【Ctrl+z】
(global-set-key (kbd "C-S-z") 'redo) ; 【Ctrl+Shift+z】

(add-hook 'before-revert-hook  (lambda () (kill-ring-save (point-min) (point-max))))

(setq ibuffer-saved-filter-groups
      (quote
       (("default"
         ("ssh"
          (or
           (name . "\\*tramp") 
           (name . "^\\*debug tramp")
           ))

         ("emacs"
          (or
           (mode . occur-mode)
           (mode . bookmark-bmenu-mode)
           (mode . help-mode)
           (name . "^\\*scratch\\*$")
           (name . "^\\*Messages\\*$")

           (name . "^\\*Compile-Log\\*$")
           (name . "^\\*Backtrace\\*$")
           (name . "^\\*info\\*$")
           (name . "^\\*Occur\\*$")
           (name . "^\\*grep\\*$")
           (name . "^\\*Process List\\*$")
           (name . "^\\*gud\\*$")
           (name . "^\\*compilation\\*$")
           (name . "^\\*Kill Ring\\*$")
           ))
         ("agenda" (or (name . "^\\*Calendar\\*$")
                       (name . "^\\*Org Agenda")
                       (name . "^\\*scratch\\* (org)$")
                       (filename . "git\\/dkh\-org")
                       (mode . muse-mode)
                       ))
         ("blog" (or 
                       (filename . "git\\/blog")
                       (filename . "git\\/netlsd")
                       ))

         ("cu agenda" (or (filename . "git\\/cu")))
         ("latex" (or (mode . latex-mode)
                      (mode . LaTeX-mode)
                      (mode . bibtex-mode)
                      (mode . reftex-mode)))
         ("irc"
          (or
           (name . "^\\*Sauron\\*$")
           (mode . garak-mode)
           (name . "^\\*Garak\\*$")
           (mode . erc-mode)
           (mode . twittering-mode)
  (name . "^\\*scratch\\* (irc)$")
         ))
         ("jabber"
          (or
          (name . "^\\*-jabber.*")
           (name . "\\*fsm-debug\\*")
          (name . "^\\*scratch\\* (jabber)$")
        ))
         ("test"
          (or
           (name . "test")
           (filename . "user\\@localhost:/home/www/htdocs")
           ))
         ("devel"
          (or
           (name . "^\\*eshell\\-devel\\-drupal\\*$")
           (name . "devel")
           (filename . "localhost:/home/www")
           (filename . "localhost:/home/user")
           ))

         ("stage"
          (or
           (name . "stage")
           (name . "staging")
           (filename . "host-staging.domain.com")
           (name . "\\*ansi\\-term\\-stage\\*")
           ))
         ("prod"
          (or
           (name . "prod")
           (filename . "host-prod.domain.com")
           ))
         ("IGP Project Trunk"
          (filename . "igp_reporting_trunk"))
         ("competitions" (or
                          (filename . "competitions")
                          (filename . "apache2\/competitions")
                          ))
         ("templates"
          (filename . "templates_trunk"))
         ("gnus" (or
                  (mode . message-mode)
                  (mode . bbdb-mode)
                  (mode . mail-mode)
                  (mode . gnus-group-mode)
                  (mode . gnus-summary-mode)
                  (mode . gnus-article-mode)
                  (name . "^\\.bbdb$")
                  (name . "^\\.newsrc-dribble")
                  (name . "^\\*gnus trace\\*$")
                  (name . "^\\*scratch\\* (gnus)$")
                  ))
         ("tool config" (or (mode . emacs-lisp-mode)
                            (filename . "\\.emacs\\.d")
                            (filename . "git\\/vinylisland")
                            (name . "^\\.conkerorrc$")
                            (filename . "org-mode-doc")
                            ))

         ("w3m" (or
                 (mode . w3m-mode)
               ;;  (name . "\\(w3m\\)$")
                  (name . "w3m")
                 ))
         ("documentation" (or (mode . Info-mode)
                              (mode . apropos-mode)
                              (mode . woman-mode)
                              (mode . help-mode)
                              (mode . Man-mode)))
         ("Magit" (name . "\*magit"))
         ))))

(setq ibuffer-never-show-predicates
      (list
       ;; Gnus development version
       "^\\*Completions\\*$"
       "^\\*nnimap"
       "^\\*gnus trace"
       "^\\*imap log"
       ;; Elim
       "^\\*elim"
       ;; others
       "^\\*Completions\\*$"
       "^\\*BBDB\\*$"
       "^\\.bbdb$"
       "^\\.newsrc-dribble$"
       ;;       "^\\*magit-"        ;; magit stuff
       "^\\*fsm-debug"     ;; jabber
       "\\.org_archive$"   ;; orgmode archive files
       "^\\*jekyll-aa\\*$" ;; local jekyll server
       "\\.diary$"
       "^mumamo-fetch-major-mode-setup-php-mode$"
       ))

                                        ; default groups for ibuffer
;; http://www.shellarchive.co.uk/content/emacs_tips.html#sec17


;; ibuffer, I like my buffers to be grouped
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups
             "default")))

(setq ibuffer-never-show-predicates
      (list "\\*Completions\\*"
            "\\*vc\\*"))

;; Switching to ibuffer puts the cursor on the most recent buffer
(defadvice ibuffer (around ibuffer-point-to-most-recent) ()
  "Open ibuffer with cursor pointed to most recent buffer name"
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

(setq ibuffer-show-empty-filter-groups nil)

(defadvice ibuffer-generate-filter-groups (after reverse-ibuffer-groups ()
                                                 activate)
  (setq ad-return-value (nreverse ad-return-value)))

(setq ibuffer-restore-window-config-on-quit t)

;; Enable ibuffer-filter-by-filename to filter on directory names too.
(eval-after-load "ibuf-ext"
  '(define-ibuffer-filter filename
     "Toggle current view to buffers with file or directory name matching QUALIFIER."
     (:description "filename"
      :reader (read-from-minibuffer "Filter by file/directory name (regexp): "))
     (ibuffer-awhen (or (buffer-local-value 'buffer-file-name buf)
                        (buffer-local-value 'dired-directory buf))
       (string-match qualifier it))))

(define-prefix-command 'perspective-map)
(global-set-key (kbd "C-8") 'perspective-map)

;; ido makes competing buffers and finding files easier
;; http://www.emacswiki.org/cgi-bin/wiki/InteractivelyDoThings

(setq 
  ido-save-directory-list-file "~/.emacs.d/cache/ido.last"
)

(set `ido-ignore-files '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./"
"\\`\\./" "\\.el?$"))

(setq ido-ignore-buffers 
  '("\\` " "^\*Mess" "^\*Back" ".*Completions" "^\*Ido" "^\*trace"
     "^\*compilation" "^\*GTAGS" "^session\.*" "^\*" "^\\*Completions\\*$"))

(setq  ido-work-directory-list '("~/git" "~/.emacs.d" "~/docs" ))



(setq  ido-case-fold  t                 ; be case-insensitive
  ido-enable-last-directory-history t ; remember last used dirs
  ido-max-work-directory-list 30   ; should be enough
  ido-max-work-file-list      50   ; remember many
)

(setq ido-use-filename-at-point 'guess)

(setq ido-use-url-at-point nil)         ; don't use url at point (annoying)

(setq ido-enable-flex-matching t)   ; don't try to be too smart

(setq ido-max-prospects 8)              ; don't spam my minibuffer

(setq  ido-confirm-unique-completion t) ; wait for RET, even with unique completion

;; when using ido, the confirmation is rather annoying...
(setq confirm-nonexistent-file-or-buffer nil)

                                          ; 50 files ought to be enough.
  (setq recentf-max-saved-items 50)
  
  (defun ido-recentf-open ()
    "Use `ido-completing-read' to \\[find-file] a recent file"
    (interactive)
    (if (find-file (ido-completing-read "Find recent file: " recentf-list))
        (message "Opening file...")
      (message "Aborting")))
  
                                          ; IDO switch between irc channels.

;; get rid of `find-file-read-only' and replace it with something
  ;; more useful.
  (global-set-key (kbd "C-x C-r") 'ido-recentf-open)

(setq ido-create-new-buffer 'always)

(setq ido-file-extensions-order '(".org" ".php" ".txt" ".py" ".xml" ".el" ".ini" ".cfg" ".cnf"))

(defun rgr/ido-erc-buffer()
(interactive)
(switch-to-buffer
 (ido-completing-read "Channel:" 
                      (save-excursion
                        (delq
                         nil
                         (mapcar (lambda (buf)
                                   (when (buffer-live-p buf)
                                     (with-current-buffer buf
                                       (and (eq major-mode 'erc-mode)
                                            (buffer-name buf)))))
                                 (buffer-list)))))))

(defun ido-find-file-in-tag-files ()
  (interactive)
  (save-excursion
    (let ((enable-recursive-minibuffers t))
      (visit-tags-table-buffer))
    (find-file
     (expand-file-name
      (ido-completing-read
       "Project file: " (tags-table-files) nil t)))))

(lambda (x) (and (string-match-p "^\\.." x) x))

(lambda (a b)
      (let ((a-tramp-file-p (string-match-p ":\\'" a))
            (b-tramp-file-p (string-match-p ":\\'" b)))
        (cond
         ((and a-tramp-file-p b-tramp-file-p)
          (string< a b))
         (a-tramp-file-p nil)
         (b-tramp-file-p t)
         (t (time-less-p
             (sixth (file-attributes (concat ido-current-directory b)))
             (sixth (file-attributes (concat ido-current-directory a))))))))

(setq ido-enable-tramp-completion nil)

(setq ido-use-virtual-buffers 't)

(add-to-list 'ido-work-directory-list-ignore-regexps tramp-file-name-regexp)

(setq ido-default-buffer-method 'selected-window)

(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
    (add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)

(defun ido-sort-mtime ()
      (setq ido-temp-list
            (sort ido-temp-list 
                  (lambda (a b)
                    (let ((ta (nth 5 (file-attributes (concat ido-current-directory a))))
                          (tb (nth 5 (file-attributes (concat ido-current-directory b)))))
                      (if (= (nth 0 ta) (nth 0 tb))
                          (> (nth 1 ta) (nth 1 tb))
                        (> (nth 0 ta) (nth 0 tb)))))))
      (ido-to-end  ;; move . files to end (again)
       (delq nil (mapcar
                  (lambda (x) (if (string-equal (substring x 0 1) ".") x))
                  ido-temp-list))))

(defun find-file-as-root ()
  "Find a file as root."
  (interactive)
  (let* ((parsed (when (tramp-tramp-file-p default-directory)
                   (coerce (tramp-dissect-file-name default-directory)
                           'list)))
         (default-directory
           (if parsed
               (apply 'tramp-make-tramp-file-name
                      (append '("sudo" "root") (cddr parsed)))
             (tramp-make-tramp-file-name "sudo" "root" "localhost"
                                         default-directory))))
    (call-interactively 'find-file)))

(defun toggle-alternate-file-as-root (&optional filename)
  "Toggle between the current file as the default user and as root."
  (interactive)
  (let* ((filename (or filename (buffer-file-name)))
         (parsed (when (tramp-tramp-file-p filename)
                   (coerce (tramp-dissect-file-name filename)
                           'list))))
    (unless filename
      (error "No file in this buffer."))

    (find-alternate-file
     (if (equal '("sudo" "root") (butlast parsed 2))
         ;; As non-root
         (if (or
              (string= "localhost" (nth 2 parsed))
              (string= (system-name) (nth 2 parsed)))
             (car (last parsed))
           (apply 'tramp-make-tramp-file-name
                  (append (list tramp-default-method nil) (cddr parsed))))

       ;; As root
       (if parsed
           (apply 'tramp-make-tramp-file-name
                  (append '("sudo" "root") (cddr parsed)))
         (tramp-make-tramp-file-name "sudo" nil nil filename))))))

(defun th-find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file))))

(defadvice find-file (around th-find-file activate)
  "Open FILENAME using tramp's sudo method if it's read-only."
  (if (and (not (file-writable-p (ad-get-arg 0)))
       (not (file-remote-p (ad-get-arg 0)))
       (y-or-n-p (concat "File "
                 (ad-get-arg 0)
                 " is read-only.  Open it as root? ")))
      (th-find-file-sudo (ad-get-arg 0))
    ad-do-it))

(require 'filecache)

(defun file-cache-ido-find-file (file)
  "Using ido, interactively open file from file cache'.
First select a file, matched using ido-switch-buffer against the contents
in `file-cache-alist'. If the file exist in more than one
directory, select directory. Lastly the file is opened."
  (interactive (list (file-cache-ido-read "File: "
                                          (mapcar
                                           (lambda (x)
                                             (car x))
                                           file-cache-alist))))
  (let* ((record (assoc file file-cache-alist)))
    (find-file
     (expand-file-name
      file
      (if (= (length record) 2)
          (car (cdr record))
        (file-cache-ido-read
         (format "Find %s in dir: " file) (cdr record)))))))

(defun file-cache-ido-read (prompt choices)
  (let ((ido-make-buffer-list-hook
         (lambda ()
           (setq ido-temp-list choices))))
    (ido-read-buffer prompt)))
(add-to-list 'file-cache-filter-regexps "docs/html")
(add-to-list 'file-cache-filter-regexps "\\.svn-base$")
(add-to-list 'file-cache-filter-regexps "\\.dump$")

(setq imenu-auto-rescan 't)

(setq smex-save-file "~/.emacs.d/.smex-items")

(dolist (r `( (?b (file . "~/git/vinylisland/dkh-bindings.org"))
             (?v (file . "~/git/vinylisland/dkh-config.org"))))
             (set-register (car r) (cadr r)))

(setq bookmark-default-file "~/git/.emacs.d/.emacs.bmk")

(setq bmkp-last-as-first-bookmark-file "~/git/.emacs.d/.emacs.bmk")

(require 'bookmark+)
;; (call-interactively 'bookmark-bmenu-list)

(setq bmkp-bmenu-state-file "~/git/.emacs.d/.emacs-bmk-bmenu-state.el")

(defalias 'tc 'dkh/toggle-chrome)
(defalias 'll 'load-library)  ;; dynamic, instead of require
(defalias 'es 'eshell)
(defalias 'r 'list-registers)
(defalias 'ev 'eval-buffer)
(defalias 'td 'toggle-debug-on-error)
(defalias 'sc 'sql-connect)

(defalias 'j 'jabber)

(defalias 'iw 'ispell-word)
;; (defalias 'fm 'flyspell-mode)

(defalias 'egi 'el-get-install)
(defalias 'pi 'package-install)
(defalias 'ai 'auto-install-from-emacswiki)
(defalias 'bc  'bbdb-create)
(defalias 'bb  'bbdb)

(defalias 'qrr 'query-replace-regexp)

(defalias 'rn 'wdired-change-to-wdired-mode) ; rename file in dired
(defalias 'g 'grep)
(defalias 'gf 'grep-find)
(defalias 'fd 'find-dired)
(defalias 'ntr 'narrow-to-region)
(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'dnml 'delete-non-matching-lines)
(defalias 'sl 'sort-lines)
(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'lcd 'list-colors-display)
(defalias 'rb 'revert-buffer)
(defalias 'rs 'replace-string)
(defalias 'rr 'reverse-region)
(defalias 'lf 'load-file)
(defalias 'man 'woman)

(defalias 'sh 'shell)
(defalias 'ps 'powershell)
(defalias 'fb 'flyspell-buffer)
(defalias 'sbc 'set-background-color)

(defalias 'rof 'recentf-open-files)

; elisp
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ed 'eval-defun)
(defalias 'ele 'eval-last-sexp)
(defalias 'eis 'elisp-index-search)

; modes
(defalias 'hm 'html-mode)
(defalias 'tm 'text-mode)
(defalias 'elm 'emacs-lisp-mode)
(defalias 'vbm 'visual-basic-mode)
(defalias 'vlm 'visual-line-mode)
(defalias 'wsm 'whitespace-mode)
(defalias 'gwsm 'global-whitespace-mode)
(defalias 'om 'org-mode)
(defalias 'ssm 'shell-script-mode)
(defalias 'cc 'calc)
(defalias 'dsm 'desktop-save-mode)

(defalias 'acm 'auto-complete-mode)

(setq org-user-agenda-files (quote (
"~/git/cu"
"~/git/cu/igp"
"~/git/cu/centers"
"~/git/dkh-org"
"~/git/dkh-org/wordpress"
"~/git/netlsd"
)))

(setq diary-file "~/git/.emacs.d/.diary")

(require 'org-habit) ;; added by dkh

(require 'org-latex)
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))

(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-export-latex-classes
             `("book"
               "\\documentclass{book}"
               ("\\part{%s}" . "\\part*{%s}")
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
             )

(add-to-list 'org-export-latex-classes
      '("org-article"
         "\\documentclass{org-article}
         [NO-DEFAULT-PACKAGES]
         [PACKAGES]
         [EXTRA]"
         ("\\section{%s}" . "\\section*{%s}")
         ("\\subsection{%s}" . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
         ("\\paragraph{%s}" . "\\paragraph*{%s}")
         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-export-latex-classes
          '("koma-article"
             "\\documentclass{scrartcl}
             [NO-DEFAULT-PACKAGES]
             [EXTRA]"
             ("\\section{%s}" . "\\section*{%s}")
             ("\\subsection{%s}" . "\\subsection*{%s}")
             ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
             ("\\paragraph{%s}" . "\\paragraph*{%s}")
             ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-export-latex-listings 'minted)
(setq org-export-latex-custom-lang-environments
      '(
       (emacs-lisp "common-lispcode")
        ))
(setq org-export-latex-minted-options
      '(("frame" "lines")
        ("fontsize" "\\scriptsize")
        ("linenos" "")))
(setq org-latex-to-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-export-latex-listings 'listings)
(setq org-export-latex-custom-lang-environments
      '((emacs-lisp "common-lispcode")))
(setq org-export-latex-listings-options
      '(("frame" "lines")
        ("basicstyle" "\\footnotesize")
        ("numbers" "left")
        ("numberstyle" "\\tiny")))
(setq org-latex-to-pdf-process
      '("pdflatex -interaction nonstopmode -output-directory %o %f"
      "pdflatex -interaction nonstopmode -output-directory %o %f"
      "pdflatex -interaction nonstopmode -output-directory %o %f"))
(org-add-link-type
 "latex" nil
 (lambda (path desc format)
   (cond
    ((eq format 'html)
     (format "<span class=\"%s\">%s</span>" path desc))
    ((eq format 'latex)
     (format "\\%s{%s}" path desc)))))

(define-key org-mode-map (kbd "C-c k") 'org-cut-subtree)

(setq org-export-with-section-numbers nil)
(setq org-html-include-timestamps nil)

(defun sacha/org-export-subtree-as-html-fragment ()
  (interactive)
  (org-export-region-as-html
   (org-back-to-heading)
   (org-end-of-subtree)
   t))

(setq org-link-abbrev-alist
  '(("google" . "http://www.google.com/search?q=")
    ("gmap" . "http://maps.google.com/maps?q=%s")
    ("blog" . "http://sachachua.com/blog/p/")))

(org-babel-do-load-languages
    'org-babel-load-languages '((python . t) (R . t) (perl . t)))

(which-function-mode t)
(setq which-func-modes t)
(which-func-mode 1)

(setq Man-switches "-a")

(defadvice Man-build-page-list (after reverse-page-list activate)
  (setq Man-page-list (nreverse Man-page-list)))

(setq use-dialog-box nil)

(setq use-file-dialog nil)

(require 'mm-url)
(defun google-define-word-or-phrase (query)
  (interactive "sInsert word or phrase to search: ")
  (let* ((url (concat "http://www.google.com.pe/search?hl=en&q=define%3A"
              (replace-regexp-in-string " " "+" query)))
     (definition
       (save-excursion
         (with-temp-buffer
           (mm-url-insert url)
           (goto-char (point-min))
           (if (search-forward "No definitions found of " nil t)
           "No definitions found"
         (buffer-substring (search-forward "<li>") (- (search-forward "<") 1)))))))
    (message "%s: %s" query definition)))

(eldoc-mode t)

(setq tramp-default-method "ssh")

(setq tramp-default-user "username")

(setq tramp-debug-buffer t)
(setq tramp-verbose 10)

(setq password-cache nil)

(setq tramp-backup-directory-alist backup-directory-alist)

;;       (starter-kit-load "eshell")

;;This makes Eshell’s ‘ls’ file names RET-able. Yay!
  (eval-after-load "em-ls"
    '(progn
       (defun ted-eshell-ls-find-file-at-point (point)
         "RET on Eshell's `ls' output to open files."
         (interactive "d")
         (find-file (buffer-substring-no-properties
                     (previous-single-property-change point 'help-echo)
                     (next-single-property-change point 'help-echo))))

       (defun pat-eshell-ls-find-file-at-mouse-click (event)
         "Middle click on Eshell's `ls' output to open files.
   From Patrick Anderson via the wiki."
         (interactive "e")
         (ted-eshell-ls-find-file-at-point (posn-point (event-end event))))

       (let ((map (make-sparse-keymap)))
         (define-key map (kbd "RET")      'ted-eshell-ls-find-file-at-point)
         (define-key map (kbd "<return>") 'ted-eshell-ls-find-file-at-point)
         (define-key map (kbd "<mouse-2>") 'pat-eshell-ls-find-file-at-mouse-click)
         (defvar ted-eshell-ls-keymap map))

       (defadvice eshell-ls-decorated-name (after ted-electrify-ls activate)
         "Eshell's `ls' now lets you click or RET on file names to open them."
         (add-text-properties 0 (length ad-return-value)
                              (list 'help-echo "RET, mouse-2: visit this file"
                                    'mouse-face 'highlight
                                    'keymap ted-eshell-ls-keymap)
                              ad-return-value)
         ad-return-value)))

  (defun ted-eshell-ls-find-file ()
          (interactive)
    (let ((fname (buffer-substring-no-properties
              (previous-single-property-change (point) 'help-echo)
              (next-single-property-change (point) 'help-echo))))
            ;; Remove any leading whitespace, including newline that might
            ;; be fetched by buffer-substring-no-properties
      (setq fname (replace-regexp-in-string "^[ \t\n]*" "" fname))
            ;; Same for trailing whitespace and newline
      (setq fname (replace-regexp-in-string "[ \t\n]*$" "" fname))
      (cond
       ((equal "" fname)
        (message "No file name found at point"))
       (fname
        (find-file fname)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Here is a cool function by MilanZamazal? that brings lots of Debian commands together. Note how options are defined and documented using eshell-eval-using-options.

    (defun eshell/deb (&rest args)
      (eshell-eval-using-options
       "deb" args
       '((?f "find" t find "list available packages matching a pattern")
         (?i "installed" t installed "list installed debs matching a pattern")
         (?l "list-files" t list-files "list files of a package")
         (?s "show" t show "show an available package")
         (?v "version" t version "show the version of an installed package")
         (?w "where" t where "find the package containing the given file")
         (nil "help" nil nil "show this usage information")
         :show-usage)
       (eshell-do-eval
        (eshell-parse-command
         (cond
          (find
           (format "apt-cache search %s" find))
          (installed
           (format "dlocate -l %s | grep '^.i'" installed))
          (list-files
           (format "dlocate -L %s | sort" list-files))
          (show
           (format "apt-cache show %s" show))
          (version
           (format "dlocate -s %s | egrep '^(Package|Status|Version):'" version))
          (where
           (format "dlocate %s" where))))
        t)))

;; aliases

(defalias 'open 'find-file)
(defalias 'openo 'find-file-other-window)

(defun eshell/emacs (file)
          (find-file file))


(setq eshell-aliases-file "~/git/.emacs.d/eshell/alias")

  (require 'em-smart)
  (setq eshell-where-to-jump 'begin)
  (setq eshell-review-quick-commands nil)
  (setq eshell-smart-space-goes-to-end t)

(defvar explicit-su-file-name "/bin/su")
(defvar explicit-su-args '("-"))

(defun su (&optional buffer)
  (interactive
   (list
    (and current-prefix-arg
     (prog1
         (read-buffer "SU buffer: "
              (generate-new-buffer-name "*su*"))
       (if (file-remote-p default-directory)
       ;; It must be possible to declare a local default-directory.
       (setq default-directory
             (expand-file-name
          (read-file-name
           "Default directory: " default-directory default-directory
           t nil 'file-directory-p))))))))
  (setq buffer (get-buffer-create (or buffer "*su*")))
  ;; Pop to buffer, so that the buffer's window will be correctly set
  ;; when we call comint (so that comint sets the COLUMNS env var properly).
  (pop-to-buffer buffer)
  (unless (comint-check-proc buffer)
    (let* ((prog explicit-su-file-name)
       (name (file-name-nondirectory prog))
       (startfile (concat "~/.emacs_" name))
       (xargs-name (intern-soft (concat "explicit-" name "-args"))))
  (apply 'make-comint-in-buffer "su" buffer prog
         (if (file-exists-p startfile) startfile)
         (if (and xargs-name (boundp xargs-name))
         (symbol-value xargs-name)
       '("-i")))
  (shell-mode)))
  buffer)

(defun visit-ansi-term ()
  (interactive)
  "Creates an ansi-term and switches to it. If a buffer with name already exists, we simply switch to it."
  (let ((buffer-of-name (get-buffer (concat "*ansi-term-" (persp-name persp-curr))))
;;        (default-directory "/home/www")
        (term-cmd "/bin/bash")
)
    (cond ((bufferp buffer-of-name) ;If the buffer exists, switch to it (assume it is a shell)
           (switch-to-buffer buffer-of-name))
          ( t 
            (progn
              (ansi-term term-cmd)
              ;(process-send-string (get-buffer-process new-buff-name) (concat "cd " localdir "\n"))
              (rename-buffer  (concat "*ansi-term-" (persp-name persp-curr))))))))

(global-set-key (kbd "C-x <f2>") 'visit-ansi-term)

(defun open-localhost ()
  (interactive)
  (ansi-term "bash" "localhost"))


(defun open-localhost ()
  (interactive)
  (ansi-term "bash" "localhost"))

;; Use this for remote so I can specify command line arguments
(defun remote-term (new-buffer-name cmd &rest switches)
  (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
  (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
  (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  (term-set-escape-char ?\C-x)
  (switch-to-buffer term-ansi-buffer-name))

(defun open-prod ()
  (interactive)
  (remote-term (concat "ansi-term-" (persp-name persp-curr) ) "ssh" "user@prod.domain.com"))

(defun open-stage ()
  (interactive)
  (remote-term (concat "ansi-term-" (persp-name persp-curr) ) "ssh" "user@host-staging.domain.com"))

(defun open-test ()
  (interactive)
  (remote-term (concat "ansi-term-" (persp-name persp-curr) ) "ssh" "user@localhost"))


(defun open-devel ()
  (interactive)
  (remote-term (concat "ansi-term-" (persp-name persp-curr) ) "ssh" "user@localhost"))

(global-set-key (kbd "C-x <f6>") 'open-devel)
(global-set-key (kbd "C-x <f7>") 'open-test)
(global-set-key (kbd "C-x <f8>") 'open-stage)
(global-set-key (kbd "C-x <f9>") 'open-prod)

(defun shell-command-on-region-to-string (start end command)                    
  (with-output-to-string                                                        
    (shell-command-on-region start end command standard-output)))               
                                                                                
(defun shell-command-on-region-with-output-to-end-of-buffer (start end command) 
  (interactive                                                                  
   (let ((command (read-shell-command "Shell command on region: ")))            
     (if (use-region-p)                                                         
         (list (region-beginning) (region-end) command)                         
       (list (point-min) (point-max) command))))                                
  (save-excursion                                                               
    (goto-char (point-max))                                                     
    (insert (shell-command-on-region-to-string start end command))))

(defun shell-here ()
  "Open a shell in `default-directory'."
  (interactive)
  (let ((dir (expand-file-name default-directory))
        (buf (or (get-buffer "*shell*") (shell))))
    (goto-char (point-max))
    (if (not (string= (buffer-name) "*shell*"))
        (switch-to-buffer-other-window buf))
    (message list-buffers-directory)
    (if (not (string= (expand-file-name list-buffers-directory) dir))
        (progn (comint-send-string (get-buffer-process buf)
                                   (concat "cd \"" dir "\"\r"))
               (setq list-buffers-directory dir)))))

(setq ansi-color-names-vector
      ["black" "tomato" "PaleGreen2" "gold1"
       "DeepSkyBlue1" "MediumOrchid1" "cyan" "white"])

(setq ansi-color-map (ansi-color-make-color-map))

(add-hook 'shell-mode-hook 
     '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)

(defvar my-local-shells
  '("*shell0*" "*shell1*" "*shell2*" "*shell3*" "*music*"))
(defvar my-remote-shells
  '("*dhaley*" "*pup*" "*pup-staging*" "*heaven2*" "*heaven3*"))
(defvar my-shells (append my-local-shells my-remote-shells))

(custom-set-variables
 '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
 ;; '(comint-completion-autolist t)     ; show completion list when ambiguous
 '(comint-input-ignoredups t)           ; no duplicates in command history
 '(comint-buffer-maximum-size 20000)    ; max length of the buffer in lines
 '(comint-prompt-read-only nil)         ; if this is t, it breaks shell-command
 '(comint-get-old-input (lambda () "")) ; what to run when i press enter on a
                                        ; line above the current prompt
 '(protect-buffer-bury-p nil)
)

;; truncate buffers continuously
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

(defun make-my-shell-output-read-only (text)
  "Add to comint-output-filter-functions to make stdout read only in my shells."
  (if (member (buffer-name) my-shells)
      (let ((inhibit-read-only t)
            (output-end (process-mark (get-buffer-process (current-buffer)))))
        (put-text-property comint-last-output-start output-end 'read-only t))))
(add-hook 'comint-output-filter-functions 'make-my-shell-output-read-only)

(defun my-dirtrack-mode ()
  "Add to shell-mode-hook to use dirtrack mode in my shell buffers."
  (when (member (buffer-name) my-shells)
    (shell-dirtrack-mode 0)
    (set-variable 'dirtrack-list '("^.*[^ ]+:\\(.*\\)>" 1 nil))
    (dirtrack-mode 1)))
(add-hook 'shell-mode-hook 'my-dirtrack-mode)

; interpret and use ansi color codes in shell output windows
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun set-scroll-conservatively ()
  "Add to shell-mode-hook to prevent jump-scrolling on newlines in shell buffers."
  (set (make-local-variable 'scroll-conservatively) 10))
(add-hook 'shell-mode-hook 'set-scroll-conservatively)

;; i think this is wrong, and it buries the shell when you run emacsclient from
;; it. temporarily removing.
;; (defun unset-display-buffer-reuse-frames ()
;;   "Add to shell-mode-hook to prevent switching away from the shell buffer
;; when emacsclient opens a new buffer."
;;   (set (make-local-variable 'display-buffer-reuse-frames) t))
;; (add-hook 'shell-mode-hook 'unset-display-buffer-reuse-frames)

(require 'protbuf)
(add-hook 'shell-mode-hook 'protect-process-buffer-from-kill-mode)


(defun make-comint-directory-tracking-work-remotely ()
  "Add this to comint-mode-hook to make directory tracking work
while sshed into a remote host, e.g. for remote shell buffers
started in tramp. (This is a bug fix backported from Emacs 24:
http://comments.gmane.org/gmane.emacs.bugs/39082"
  (set (make-local-variable 'comint-file-name-prefix)
       (or (file-remote-p default-directory) "")))
(add-hook 'comint-mode-hook 'make-comint-directory-tracking-work-remotely)

(defun enter-again-if-enter ()
  "Make the return key select the current item in minibuf and shell history isearch.
An alternate approach would be after-advice on isearch-other-meta-char."
  (when (and (not isearch-mode-end-hook-quit)
             (equal (this-command-keys-vector) [13])) ; == return
    (cond ((active-minibuffer-window) (minibuffer-complete-and-exit))
          ((member (buffer-name) my-shells) (comint-send-input)))))
(add-hook 'isearch-mode-end-hook 'enter-again-if-enter)

(defadvice comint-previous-matching-input
    (around suppress-history-item-messages activate)
  "Suppress the annoying 'History item : NNN' messages from shell history isearch.
If this isn't enough, try the same thing with
comint-replace-by-expanded-history-before-point."
  (let ((old-message (symbol-function 'message)))
    (unwind-protect
      (progn (fset 'message 'ignore) ad-do-it)
    (fset 'message old-message))))

(defadvice comint-send-input (around go-to-end-of-multiline activate)
  "When I press enter, jump to the end of the *buffer*, instead of the end of
the line, to capture multiline input. (This only has effect if
`comint-eol-on-send' is non-nil."
  (flet ((end-of-line () (end-of-buffer)))
    ad-do-it))

;; not sure why, but comint needs to be reloaded from the source (*not*
;; compiled) elisp to make the above advise stick.
(load "comint.el.gz")

;; for other code, e.g. emacsclient in TRAMP ssh shells and automatically
;; closing completions buffers, see the links above.

;; enable the use of the command `dired-find-alternate-file'
;; without confirmation
(put 'dired-find-alternate-file 'disabled nil)

(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map "b" 'my-browser-find-file)))

(defun my-dired-browser-find-file ()
  "Dired function to view a file in a web browser"
  (interactive)
  (browse-url (browse-url-file-url (dired-get-filename))))

(add-hook 'dired-load-hook (function (lambda () (load "dired-x"))))

;; (setq dired-omit-file "^\\.?#\\|^\\.$\\|^\\.\\.$")

(setq dired-omit-files 
      (rx (or (seq bol (? ".") "#")         ;; emacs autosave files 
              (seq "~" eol)                 ;; backup-files 
              (seq bol "svn" eol)           ;; svn dirs 
;;              (seq ".git" eol)
              (seq bol "." (not (any "."))) ;; dot-files                                                                                                                                                                    
;;              (seq ".pyc" eol)
              )))
(setq dired-omit-extensions 
      (append dired-latex-unclean-extensions 
              dired-bibtex-unclean-extensions 
              dired-texinfo-unclean-extensions))
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(defun 2zip ()
  "Zip the current file/dir in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip commandline tool."
  (interactive)
  (require 'dired)
  (let ( (fileName (elt (dired-get-marked-files) 0))  )
    (shell-command (format "zip -r '%s.zip' '%s'" (file-relative-name fileName) (file-relative-name fileName)))
    ))

(autoload 'dired-jump "dired-x" "Jump to dired corresponding current buffer.") 
(autoload 'dired-jump-other-window "dired-x" "jump to dired in other window.")


(setq toggle-diredp-find-file-reuse-directory t)

(add-hook 'message-sent-hook 'gnus-score-followup-article)
(add-hook 'message-sent-hook 'gnus-score-followup-thread)

(setq gnus-kill-files-directory "~/git/gnus/.gnuskillfiled") ;;

(defun my-gnus ()
  "Start a new Gnus, or locate the existing buffer *Group*."
  (interactive)
  (if (buffer-live-p    (get-buffer "*Group*"))
      (switch-to-buffer (get-buffer "*Group*"))
    (gnus)))

(require 'gnus)
(setq message-directory "~/git/gnus/Mail")
(setq nnml-directory "~/git/gnus/Mail")
(setq gnus-article-save-directory "~/git/gnus/News")
(setq gnus-cache-directory "~/git/gnus/News/cache")

(setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\”]\”[#’()]")

;;(setq gnus-select-method
;;      (nntp "Gwene"
;;            (nntp-address "news.gwene.org"))
;;      (nntp "Gmane"
;;            (nntp-address "news.gmane.org"))
;;      (nntp "Gnus"
;;            (nntp-address "news.gnus.org"))
;;      (nnml "freeshell"
;;            (nnmaildir "" (directory "~/Mail"))
;;            (nnml-get-new-mail t)))


(setq auth-sources (quote ((:source "~/.emacs.d/.authinfo.gpg"
                                    :host t :protocol t))))

(copy-face 'default 'my-gnus-face)
(copy-face 'my-gnus-face 'my-subject-face)

(copy-face 'my-gnus-face 'my-group-face)
(set-face-attribute 'my-group-face nil :inherit 'my-gnus-face)

(copy-face 'my-group-face 'my-group-face-unread)
(set-face-attribute 'my-group-face-unread nil :inherit 'my-group-face)

(copy-face 'my-group-face 'my-group-server-face)
(copy-face 'my-group-server-face 'my-group-server-face-unread)
(set-face-attribute 'my-group-server-face-unread nil :inherit 'my-group-server-face)

(copy-face 'my-group-face 'my-unread-count-face)
(copy-face 'my-unread-count-face 'my-unread-count-face-unread)
(set-face-attribute 'my-unread-count-face-unread nil :inherit 'my-unread-count-face)

(copy-face 'my-group-face 'my-inbox-icon-face)
(copy-face 'my-inbox-icon-face 'my-inbox-icon-face-unread)
(set-face-attribute 'my-inbox-icon-face-unread nil :inherit 'my-inbox-icon-face)

(copy-face 'my-gnus-face 'my-topic-empty-face)
(copy-face 'my-gnus-face 'my-topic-face)


(setq nntp-marks-is-evil t)


(require 'gnus)
;; (require 'gnushush)

;;           (require 'miniedit)

(defun store-gnus-outgoing-message-group ()
  (cond ((and gnus-newsgroup-name
              (not (message-news-p))
              (stringp gnus-newsgroup-name))
         gnus-newsgroup-name)
        (t ted-default-gcc-group)))

(setq gnus-outgoing-message-group nil
      gnus-level-subscribed 5)

(setq gnus-topic-line-format "%i[ %u&topic-line; ] %v\n")

(defun dkh/unread-face (f)
  (intern (if (> (string-to-number gnus-tmp-number-of-unread) 0) (concat f "-unread") f)))

;; this corresponds to a topic line format of "%n %A"
(defun gnus-user-format-function-topic-line (dummy)
  (let ((topic-face (if (zerop total-number-of-articles)
                        'my-topic-empty-face
                      'my-topic-face)))
    (propertize
     (format "%s %d" name total-number-of-articles)
     'face topic-face)))

(defun gnus-user-format-function-s (header)
  (propertize (mail-header-subject header) 'face 'my-subject-face 'gnus-face t))

;; dkh commented out all this stuff
(defun gnus-user-format-function-g (headers) ;; gnus-group-line-format use %ug to call this func! e.g  "%M%S%p%P%(%-40,40ug%)%-5uy %ud\n"
  split full group protocol-server:group into three parts.
  (message "format function g for group %s" gnus-tmp-group)
  (string-match "\\(^.*\\)\\+\\(.*\\):\\(.*\\)" gnus-tmp-group)
  map the first two letters of the server name to a more friendly and cuddly display name
  (let*  ((match-ok (match-string 2 gnus-tmp-group))
          (server-key (if (null match-ok) nil (upcase(substring match-ok 0 2)))))
    (if (zerop (length server-key))
        gnus-tmp-group
      ;; construct new group format line with a small envelope taking the place of any INBOX
      (concat
       (propertize
        (format "%-8s" (cdr (assoc server-key dkh/server-name-maps)))
        'face (dkh/unread-face "my-group-server-face") 'face (dkh/unread-face (concat "my-group-server-face-" server-key)) 'gnus-face t)
       " - "
       (if (or (string-match "mail.misc" (match-string 3 gnus-tmp-group) )(string-match "INBOX" (match-string 3 gnus-tmp-group) ))
           (propertize "\x2709" 'face (dkh/unread-face "my-inbox-icon-face") 'gnus-face t)
         (propertize (match-string 3 gnus-tmp-group) 'face (dkh/unread-face "my-group-face") 'gnus-face t) )))))


(defun gnus-user-format-function-j (headers)
  ;; prefix each post depending on whether to, cc or Bcc to
  (let ((to (gnus-extra-header 'To headers)))
    (if (string-match dkh-mails to)
        (if (string-match "," to) "~" "»")
      (if (or (string-match dkh-mails
                            (gnus-extra-header 'Cc headers))
              (string-match dkh-mails
                            (gnus-extra-header 'BCc headers)))
          "~"
        " "))))

(defun gnus-user-format-function-y (headers)
  "return string representation for unread articles"
  (concat
   (propertize  (if (= (string-to-number  gnus-tmp-number-of-unread) 0) "" "\x2709") 'face (dkh/unread-face "my-inbox-icon-face") 'gnus-face t)
   (propertize  (if (= (string-to-number  gnus-tmp-number-of-unread) 0) ""
                  (concat "   (" gnus-tmp-number-of-unread ")")) 'face (dkh/unread-face "my-unread-count-face") 'gnus-face t)))



(setq  gnus-user-date-format-alist
       ;; Format the date so we can see today/tomorrow quickly.
       ;; See http://emacs.wordpress.com/category/gnus/ for the original.
       '(
         ((gnus-seconds-today) . "Today, %H:%M")
         ((+ 86400 (gnus-seconds-today)) . "Yesterday, %H:%M")
         (604800 . "%A %H:%M") ;;that's one week
         ((gnus-seconds-month) . "%A %d")
         ((gnus-seconds-year) . "%B %d")
         (t . "%B %d '%y"))) ;;this one is used when no other does match


(defun gnus-group-read-group-no-prompt ()
  "Read news in this newsgroup and don't prompt.
                                Use the value of `gnus-large-newsgroup'."
  (interactive)
  (gnus-group-read-group gnus-large-newsgroup))

(defun gnus-article-sort-by-chars (h1 h2)
  "Sort articles by size."
  (< (mail-header-chars h1)
     (mail-header-chars h2)))

;;             (add-to-list 'message-syntax-checks '(existing-newsgroups . disabled))





;; group topics
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)


;;F6 killfiles a poster, F7 ignores a thread
;;   (define-key gnus-summary-mode-map (kbd "<f6>") "LA")
;;   (define-key gnus-summary-mode-map (kbd "<f7>") 'gnus-summary-kill-thread)
(define-key gnus-summary-mode-map (kbd "<deletechar>") (lambda ()(interactive)(gnus-summary-delete-article)(next-line)))

;; some comfort keys to scroll article in other window when in summary window
(define-key gnus-summary-mode-map [(meta up)] (lambda() (interactive) (scroll-other-window -1)))
(define-key gnus-summary-mode-map [(meta down)] (lambda() (interactive) (scroll-other-window 1)))
;; thread navigation
(define-key gnus-summary-mode-map [(control down)] 'gnus-summary-next-thread)
(define-key gnus-summary-mode-map [(control up)] 'gnus-summary-prev-thread)


(define-key gnus-summary-mode-map (kbd ">") 'gnus-summary-show-thread)
(define-key gnus-summary-mode-map (kbd "<") 'gnus-summary-hide-thread)


;; some trickery to show the newsread people are using and colour code depending on type
;; in this case highlight users of any outlook type dross :-;
(setq  gnus-header-face-alist nil)
(add-to-list
 'gnus-header-face-alist
 (list (concat
        "^"
        (regexp-opt '("User-Agent" "X-Mailer" "Newsreader" "X-Newsreader") t)
        ":.*") ;; other
       nil font-lock-comment-face))

(add-to-list
 'gnus-header-face-alist
 (list (concat
        "^"
        (regexp-opt '("User-Agent" "X-Mailer" "Newsreader" "X-Newsreader") t)
        ":.*Outlook.*")
       nil 'gnus-emphasis-highlight-words))

;; And show any real men who use Gnus!
(add-to-list
 'gnus-header-face-alist
 (list (concat
        "^"
        (regexp-opt '("User-Agent" "X-Mailer" "Newsreader" "X-Newsreader") t)
        ":.*Gnus.*")
       nil 'gnus-server-opened))

;; Format RSS feed titles nicely
(add-hook 'gnus-summary-mode-hook
          (lambda ()
            (if (string-match "^nnrss:.*" gnus-newsgroup-name)
                (progn
                  (make-local-variable 'gnus-show-threads)
                  (make-local-variable 'gnus-article-sort-functions)
                  (make-local-variable 'gnus-use-adaptive-scoring)
                  (make-local-variable 'gnus-use-scoring)
                  (make-local-variable 'gnus-score-find-score-files-function)
                  (setq gnus-show-threads nil)
                  (setq gnus-article-sort-functions 'gnus-article-sort-by-date)
                  (setq gnus-use-adaptive-scoring nil)
                  (setq gnus-use-scoring t)
                  ;;                  (setq gnus-score-find-score-files-function 'gnus-score-find-single)
                  ))))


(add-hook 'gnus-select-group-hook 'gnus-group-set-timestamp)

(defun gnus-user-format-function-d (headers)
  (let ((time (gnus-group-timestamp gnus-tmp-group)))
    (if time
        (format-time-string "%b %d  %H:%M" time)
      ""
      )
    )
  )

(define-key mode-specific-map [?m] (lambda()(interactive) (gnus-agent-toggle-plugged t)(gnus 1)))

;; which email addresses to detect for special highlighting
(defvar dkh-mails
  "me@google.com")



(starter-kit-load "gnus" "pretty-summary")

(setq gnus-suppress-duplicates t
      gnus-save-duplicate-list t
      gnus-duplicate-list-length 100000)

(remove-hook 'gnus-article-prepare-hook 'bbdb-mua-display-sender)




(gnus-add-configuration
 '(article
   (horizontal 1.0
               (group 0.25)
               (vertical 1.0
                         (summary 0.16 point)
                         (article 1.0)
                         ("*BBDB*" 6))
               )))

(add-hook 'gnus-summary-exit-hook
          (lambda ()
            (when (every (lambda (buffer) (member buffer (gnus-buffers)))
                         (mapcar 'window-buffer (window-list)))
              (delete-other-windows)))
          t nil)

;; Set the window title
                                        ;(modify-frame-parameters nil '((title . "Gnus")))

;; indexing in mail groups supported by dovecot on the server side.
(require 'nnir)

(define-key gnus-group-mode-map (kbd "<H-f1>") 'gnus-group-make-nnir-group)
;; (define-key gnus-group-mode-map (kbd "<C-f3>") 'gnus-group-make-nnir-group)
;;  (define-key gnus-summary-mode-map (kbd "G G") 'command gnus-group-make-nnir-group)

                                        ; (setq nnir-search-engine 'imap)

(defcustom dkh/authinfo-file (expand-file-name(concat user-emacs-directory ".authinfo.gpg"))
  "regexp for searching blogger"
  :group 'dkh/gnus
  :type 'string)

(global-set-key (kbd "C-c x") '(lambda()(interactive)(save-buffers-kill-emacs)))
;; Mark gcc'ed (archive) as read:
(setq gnus-gcc-mark-as-read t)

;; put everything in ~/.emacs.d
(setq
 gnus-init-file "~/git/.emacs.d/dkh-gnus.el"
 message-signatrue-directory "~/git/.emacs.d/sig/"
 )

(setq gnus-startup-file "~/git/gnus/.newsrc")
       (setq gnus-directory "~/git/gnus/News")
     (setq gnus-dribble-directory "~/git/gnus/")
       (setq gnus-home-directory "~/git/gnus")
     (setq nntp-marks-directory "~/git/gnus/News/")
     (setq nndraft-directory "~/git/gnus/News/drafts/")
     (setq nndraft-current-directory "~/git/gnus/News/drafts/")
   (setq mail-default-directory "~/git/gnus/Mail")
   (setq gnus-default-directory "~/git/gnus")
   (setq nnmail-message-id-cache-file "~/git/gnus/nnmail_cache")

     (setq gnus-posting-styles
           '(
             ;;
             ;; Default (also used when no group is selected)
             ;; - innovation address
             ;; - record copy into INBOX
             ;;
             (".*"
              (eval(setq gnushush-user-agent-header (quote real)))
              ;;                             (eval (setq mml2015-signers '("b39a104a")))
              )
           ))

           (setq gnus-permanently-visible-groups nil)

(setq gnus-summary-save-parts-last-directory "~/Downloads")


;; (require 'info)
  (if (featurep 'xemacs)
      (add-to-list 'Info-directory-list "~/.emacs.d/el-get/nognus/texi/")
    (add-to-list 'Info-default-directory-list "~/.emacs.d/el-get/nognus/texi/"))

(defcustom gnus-summary-save-parts-exclude-article nil                                                                                                                                                                     
          "If non-nil don't save article along with attachments."                                                                                                                                                                  
          :group 'gnus-article-mime                                                                                                                                                                                                
          :type 'boolean)                                                                                                                                                                                                          
                                                                                                                                                                                                                                   
        (defun gnus-summary-save-parts-1 (type dir handle reverse)                                                                                                                                                                 
          (if (stringp (car handle))                                                                                                                                                                                               
(mapcar (lambda (h) (gnus-summary-save-parts-1 type dir h reverse))                                                                                                                                                  
    (cdr handle))                                                                                                                                                                                                    
            (when (if reverse                                                                                                                                                                                                      
                  (not (string-match type (mm-handle-media-type handle)))                                                                                                                                                          
                (string-match type (mm-handle-media-type handle)))                                                                                                                                                                 
              (let* ((name (or                                                                                                                                                                                                     
                            (mm-handle-filename handle)                                                                                                                                                                            
                            (unless gnus-summary-save-parts-exclude-article                                                                                                                                                        
                              (format "%s.%d.%d" gnus-newsgroup-name                                                                                                                                                               
                                      (cdr gnus-article-current)                                                                                                                                                                   
                                      gnus-summary-save-parts-counter))))                                                                                                                                                          
                     (file (when name                                                                                                                                                                                              
                             (expand-file-name                                                                                                                                                                                     
                              (gnus-map-function                                                                                                                                                                                   
                               mm-file-name-rewrite-functions                                                                                                                                                                      
                               (file-name-nondirectory                                                                                                                                                                             
                                name))                                                                                                                                                                                             
                              dir))))                                                                                                                                                                                              
                (when file                                                                                                                                                                                                         
                  (incf gnus-summary-save-parts-counter)                                                                                                                                                                           
                  (unless (file-exists-p file)                                                                                                                                                                                     
                    (mm-save-part-to-file handle file)))))))

(setq message-cite-prefix-regexp
"\\([ ]*[-_.#[:word:]]+>+\\|[ ]*[]>|}]\\)+")

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-default-smtp-server "smtp.host.com")

(setq smtpmail-smtp-service 587)

(erc-notify-mode 1)
(load-library "erc-highlight-nicknames")
(add-to-list 'erc-modules 'highlight-nicknames)
(add-to-list 'erc-modules 'match)

(erc-update-modules)

(require 'erc-autoaway)
(setq erc-auto-discard-away t)
(setq erc-autoaway-idle-seconds 600)
(setq erc-autoaway-use-emacs-idle t)
(setq erc-autoaway-message "cappuccino time")

(erc-button-mode nil) ;slow
(erc-fill-mode t)

(require 'erc-log)
  ;; logging
  (setq erc-log-channels-directory "~/.emacs.d/.erc/logs/")

  (if (not (file-exists-p erc-log-channels-directory))
      (mkdir erc-log-channels-directory t))

;; logging:
(setq erc-log-insert-log-on-open nil)
(setq erc-log-channels t)

(setq erc-hide-timestamps nil)
(erc-netsplit-mode t)

(require 'erc-notify)
      (setq erc-notify-list  '(
                       "ultimateboy"
                       "techgeekgirl"
"technomancy" ;; mentioned conkeror in #emacs
))

;; (require 'erc-ring)
(erc-ring-mode t)

(require 'erc-spelling)
;; enable spell checking
(erc-spelling-mode 1)

(erc-timestamp-mode t)
(setq erc-timestamp-format "[%R-%m/%d]")

;; check channels
(erc-track-mode t)
(setq erc-track-use-faces t)

(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                    "324" "329" "332" "333" "353" "477"))

(setq erc-track-exclude-server-buffer t)

(defadvice erc-track-find-face (around erc-track-find-face-promote-query activate)
  (if (erc-query-buffer-p)
      (setq ad-return-value (intern "erc-current-nick-face"))
    ad-do-it))

(defadvice erc-track-modified-channels (around erc-track-modified-channels-promote-query activate)
  (if (erc-query-buffer-p) (setq erc-track-priority-faces-only 'nil))
  ad-do-it
  (if (erc-query-buffer-p) (setq erc-track-priority-faces-only 'all)))

;;;; truncate long irc buffers
(erc-truncate-mode +1)

; auto truncatebuffers
(defvar erc-insert-post-hook)
(add-hook 'erc-insert-post-hook
    'erc-truncate-buffer)

;; share my real name
(setq erc-user-full-name "Mi nombre")

(defun erc-cmd-UPTIME (&rest ignore)
  "Display the uptime of the system, as well as some load-related
stuff, to the current ERC buffer."
  (let ((uname-output
         (replace-regexp-in-string
          ", load average: " "] {Load average} ["
          ;; Collapse spaces, remove
          (replace-regexp-in-string
           " +" " "
           ;; Remove beginning and trailing whitespace
           (replace-regexp-in-string
            "^ +\\|[ \n]+$" ""
            (shell-command-to-string "uptime"))))))
    (erc-send-message
     (concat "{Uptime} [" uname-output "]"))))

(global-set-key (kbd "C-H-i") (lambda () (interactive)
(erc :server "asimov.freenode.net"  :nick "my_nick" :password "my_pass" :port 6667)
))

(setq erc-autojoin-channels-alist
  '((".*\\.freenode.net" "#drupal-colorado" "#emacs" 
  "#solidstatedepot" "#fsf-members" "#erc" "#conkeror" "#org-mode")
;;     (".*\\.gimp.org" "#unix" "#gtk+")
;;     (".*\\.gnome.org" "#sparklehorse" "#gtk+")
))

(setq erc-interpret-mirc-color t)

;; The following are commented out by default, but users of other
;; non-Emacs IRC clients might find them useful.
;; Kill buffers for channels after /part
;; (setq erc-kill-buffer-on-part t)
;; Kill buffers for private queries after quitting the server
;; (setq erc-kill-queries-on-quit t)
;; Kill buffers for server messages after quitting the server
;; (setq erc-kill-server-buffer-on-quit t)

(setq erc-query-display 'buffer)

(defun erc-cmd-SHOWOFF (&rest ignore)
  "Show off implementation"
  (let* ((chnl (erc-buffer-list))
         (srvl (erc-buffer-list 'erc-server-buffer-p))
         (memb (apply '+ (mapcar (lambda (chn)
                                   (with-current-buffer chn
                                     (1- (length (erc-get-channel-user-list)))))
                                 chnl)))
         (show (format "is connected to %i networks and talks in %i chans to %i ppl overall :>"
                       (length srvl)
                       (- (length chnl) (length srvl))
                       memb)))
    (erc-send-action (erc-default-target) show)))

(defalias 'erc-cmd-SO 'erc-cmd-SHOWOFF)

(defun erc-cmd-DETAILED-SHOWOFF (&rest ignore)
  "Show off implementation enriched with even more with details"
  (let* ((chnl (erc-buffer-list))
         (srvl (erc-buffer-list 'erc-server-buffer-p)))
    (mapcar (lambda (srv)
              (let* ((netn (with-current-buffer srv erc-session-server))
                     (netp (with-current-buffer srv erc-session-port))
                     (chns (remove-if-not
                            (lambda (chn)
                              (and (string= netn (with-current-buffer chn erc-session-server))
                                   (eq netp (with-current-buffer chn erc-session-port))))
                            chnl))
                     (chnn (1- (length chns)))
                     (chnm (remove nil
                                   (mapcar (lambda (chn)
                                             (with-current-buffer chn
                                               (erc-get-channel-user-list)))
                                           chns)))
                     (chnmn (apply '+ (mapcar '1- (mapcar 'length chnm))))
                     (show (format "is connected to %s (%s), talking to %i users in %i chans"
                                   netn
                                   (buffer-name srv)
                                   chnmn
                                   chnn)))
                (erc-send-action (erc-default-target) show)
                (sit-for 1)))
            srvl)))

(defalias 'erc-cmd-DSO 'erc-cmd-DETAILED-SHOWOFF)

(setq erc-server-coding-system '(utf-8 . utf-8))

(defun filter-server-buffers ()
  (delq nil
        (mapcar
         (lambda (x) (and (erc-server-buffer-p x) x))
         (buffer-list))))

(setq erc-keywords '("\scu\s" "\stor\s" "university"
   "academic" "organic groups" "relation module" "contextual filter" "gmane" "gwene"
   "dired" "bitcoin" ) )

(erc-match-enable)
(erc-match-mode 1)

(setq erc-track-faces-priority-list
'(erc-current-nick-face erc-keyword-face erc-pal-face
erc-nick-msg-face erc-direct-msg-face))

(setq erc-current-nick-highlight-type 'nick)

(setq erc-track-priority-faces-only 'all)

(defun my-erc-md-all-but-emacs ()
  "Minimal distraction for all channels except #emacs"
  (interactive)
  (setq erc-track-priority-faces-only
        (remove "#emacs" (my-erc-joined-channels))))

(defun my-erc-joined-channels ()
  "Return all the channels you're in as a list.  This does not include queries."
  (save-excursion
    ;; need to get out of ERC mode so we can have *all* channels returned
    (set-buffer "*scratch*")
    (mapcar #'(lambda (chanbuf)
                (with-current-buffer chanbuf (erc-default-target)))
            (erc-channel-list erc-process))))

(defun erc-cmd-UNTRACK (&optional target)
  "Add TARGET to the list of target to be tracked."
  (if target
      (erc-with-server-buffer
 (let ((untracked (car (erc-member-ignore-case target erc-track-exclude))))
   (if untracked
       (erc-display-line
        (erc-make-notice (format "%s is not currently tracked!" target))
        'active)
     (add-to-list 'erc-track-exclude target)
     (erc-display-line
      (erc-make-notice (format "Now not tracking %s" target))
      'active))))

    (if (null erc-track-exclude)
 (erc-display-line (erc-make-notice "Untracked targets list is empty") 'active)

      (erc-display-line (erc-make-notice "Untracked targets list:") 'active)
      (mapc #'(lambda (item)
     (erc-display-line (erc-make-notice item) 'active))
     (erc-with-server-buffer erc-track-exclude))))
  t)


(defun erc-cmd-TRACK (target)
  "Remove TARGET of the list of targets which they should not be tracked.
If no TARGET argument is specified, list the contents of `erc-track-exclude'."
  (when target
    (erc-with-server-buffer
      (let ((tracked (not (car (erc-member-ignore-case target erc-track-exclude)))))
 (if tracked
     (erc-display-line
      (erc-make-notice (format "%s is currently tracked!" target))
      'active)
   (setq erc-track-exclude (remove target erc-track-exclude))
   (erc-display-line
    (erc-make-notice (format "Now tracking %s" target))
    'active)))))
  t)

(defvar erc-channels-to-visit nil
  "Channels that have not yet been visited by erc-next-channel-buffer")
(defun erc-next-channel-buffer ()
  "Switch to the next unvisited channel. See erc-channels-to-visit"
  (interactive)
  (when (null erc-channels-to-visit)
    (setq erc-channels-to-visit
      (remove (current-buffer) (erc-channel-list nil))))
  (let ((target (pop erc-channels-to-visit)))
    (if target
    (switch-to-buffer target))))

;; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))

(setq erc-max-buffer-size 20000)
(defvar erc-insert-post-hook)
(add-hook 'erc-insert-post-hook 'erc-truncate-buffer)
(setq erc-truncate-buffer-on-save t)

(defadvice erc-display-prompt (after conversation-erc-display-prompt activate)
  "Insert last recipient after prompt."
  (let ((previous
         (save-excursion
           (if (and (search-backward-regexp (concat "^[^<]*<" erc-nick ">") nil t)
                    (search-forward-regexp (concat "^[^<]*<" erc-nick ">"
                                                   " *\\([^:]*: ?\\)") nil t))
               (match-string 1)))))
    ;; when we got something, and it was in the last 3 mins, put it in
    (when (and
           previous
           (> 180 (float-time
                   (time-since (get-text-property 0 'timestamp previous)))))
      (set-text-properties 0 (length previous) nil previous)
      (insert previous))))

(defun start-irc ()
   "Connect to IRC."
   (interactive)
   (erc-tls :server "irc.oftc.net" :port 6697
        :nick "ootput" :full-name "ootput")
   (setq erc-autojoin-channels-alist '(("freenode.net" "#emacs" "#screen" "#ion")  ("oftc.net" "#debian")))
)

(setq erc-track-showcount t)

(require 'url)

(defun download-file (&optional url download-dir download-name)
  (interactive)
  (let ((url (or url
                 (read-string "Enter download URL: "))))
    (let ((download-buffer (url-retrieve-synchronously url)))
      (save-excursion
        (set-buffer download-buffer)
        ;; we may have to trim the http response
        (goto-char (point-min))
        (re-search-forward "^$" nil 'move)
        (forward-char)
        (delete-region (point-min) (point))
        (write-file (concat (or download-dir
                                "~/downloads/")
                            (or download-name
                                (car (last (split-string url "/" t))))))))))

(setq calendar-latitude 40)
  (setq calendar-longitude -105)
  (setq calendar-location-name "Boulder, CO")

(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'font-lock-function-name-face))

(require 'calendar)                                                                                                                                             
(defun display-a-month (day month year)                                                                                                                         
  (insert (format "%s\n" (calendar-date-string (list  month day year))))                                                                                        
  (if (< day 30)                                                                                                                                                
    (display-a-month (+ day 1) month year)))

(require 'calfw)

(require 'calfw-org)

(setq
 eudc-ldap-bbdb-conversion-alist (quote ((name . displayName) (net . mail) (address eudc-bbdbify-address Postaladdress "Office") (phone (eudc-bbdbify-phone telephoneNumber "Office")) (notes . title)))
 eudc-protocol (quote ldap)
 eudc-query-form-attributes (quote (name firstname email phone
 cuedupersonuuid Postaladdress)))

(setq eudc-server "directory.colorado.edu"
 ldap-host-parameters-alist
 '(("directory.colorado.edu" base "dc=colorado,dc=edu")))



(setq eudc-default-return-attributes nil
 eudc-strict-return-matches nil
 ldap-ldapsearch-args (quote ("-tt" "-LLL" "-x")))

(setq eudc-options-file "~/git/.emacs.d/.eudc-options")

(require 'ldap)
(require 'eudc)
(require 'imap)


(eudc-protocol-set 'eudc-inline-query-format
                   '((firstname)
                     (lastname)
                     (firstname lastname)
                     (net))
                    'bbdb)

(eudc-protocol-set 'eudc-inline-expansion-format
                   '("%s %s <%s>" firstname lastname net)
                   'bbdb)

(eudc-protocol-set 'eudc-inline-query-format
                   '(
                     (cn)
                     (cn cn)
                     (cn cn cn)
                     (Displayname)
                     (mail))
                   'ldap)


                   
(eudc-protocol-set 'eudc-inline-expansion-format
                   '("%s <%s>"  displayName mail)
                   'ldap)

(defun enz-eudc-expand-inline()
  (interactive)
  (move-end-of-line 1)
  (insert "*")
  (unless (condition-case nil
              (eudc-expand-inline)
            (error nil))
    (backward-delete-char-untabify 1))
  )

;; Adds some hooks

(eval-after-load "message"
  '(define-key message-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
(eval-after-load "sendmail"
  '(define-key mail-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
(eval-after-load "post"
  '(define-key post-mode-map (kbd "TAB") 'enz-eudc-expand-inline))

; Protocol local. A mapping between EUDC attribute names and corresponding
;; protocol specific names.  The following names are defined by EUDC and may be
;; included in that list: `name' , `firstname', `email', `phone'
(set eudc-protocol-attributes-translation-alist
     '(
       (fistname . Displayname)
       (name . cn)
       (email . mail)
       (phone . telephoneNumber)
       (title . title)
       )
     )

;; (provide 'dkh-directory)

(add-to-list 'load-path (expand-file-name "~/git/src/emacs-bash-completion"))

(require 'bash-completion)
(bash-completion-setup)

(defun save-macro (name)                  
  "save a macro. Take a name as argument
   and save the last defined macro under 
   this name at the end of your .emacs"
   (interactive "SName of the macro :")  ; ask for the name of the macro    
   (kmacro-name-last-macro name)         ; use this name for the macro    
   (find-file (user-init-file))                   ; open ~/.emacs or other user init file 
   (goto-char (point-max))               ; go to the end of the .emacs
   (newline)                             ; insert a newline
   (insert-kbd-macro name)               ; copy the macro 
   (newline)                             ; insert a newline
   (switch-to-buffer nil))               ; return to the initial buffer

(defun init-macro-counter-default () "Set the initial counter to 1 and
  reset every time it's called.  To set to a different value call
  `kmacro-set-counter' interactively i.e M-x kmacro-set-counter."
  (interactive) (kmacro-set-counter 1))

(global-set-key (kbd "H-<f5>") 'init-macro-counter-default)
(global-set-key (kbd "M-<f5>") 'kmacro-insert-counter)

(setq bbdb-file "~/git/.emacs.d/.bbdb")           ;; keep ~/ clean; set before loading

(require 'bbdb-loaddefs "~/.emacs.d/el-get/bbdb/lisp/bbdb-loaddefs.el")

(require 'bbdb)

(bbdb-initialize 'gnus 'message)
(setq bbdb-accept-name-mismatch                 t
      bbdb-completion-display-record            nil
      bbdb-message-all-addresses                t
      bbdb-mua-update-interactive-p             '(create . query))

(defun my-alter-summary-map ()
; ....
  (local-set-key ":" 'bbdb-mua-display-records))

(add-hook 'gnus-summary-mode-hook 'my-alter-summary-map)

(defun message-read-from-minibuffer (prompt &optional initial-contents)
  "Read from the minibuffer while providing abbrev expansion."
  (bbdb-completing-read-mails prompt initial-contents))

(bbdb-mua-auto-update-init 'gnus 'message)

;; don't display a continuously-updating BBDB window while in GNUS
(setq bbdb-pop-up-layout  nil)

;;; turn on the electric mode (t) for popup behavior
;; be disposable with SPC
(setq bbdb-electric nil)

(setq
         bbdb-mail-avoid-redundancy  t ;; always use full name
    bbdb-accept-name-mismatch 2)       ;; show name-mismatches 2 secs

(setq    bbdb-completion-list t                 ;; complete on anything
    ;; allow cycling of email addresses while completing them
    bbdb-complete-mail-allow-cycling t  ;; cycle through matches
                                             ;; this only works partially (bbdb3)
)

(setq bbdb-use-alternate-names t)

(setq
       bbdb/gnus-header-prefer-real-names t
       bbdb-check-postcode t
       ;;; if non-nil, pop a database record of every mail sender when
       ;; message is viewed. If a record for a mail message does not exist,
       ;; use : to create a new one. display vbls control the popup format
       bbdb/gnus-split-nomatch-function 'nnmail-split-fancy ; change from nnimap-split-fancy - dky
       bbdb/gnus-split-myaddr-regexp 'gnus-ignored-from-addresses
       bbdb-phone-style nil
       bbdb-mail-user-agent 'gnus)  ;; (bbdb3)

(setq
       bbdb-canonicalize-mail-function
       '(lambda (net)
         (let ((buf (get-buffer gnus-article-buffer)))
           (if buf
               (save-excursion
                 (goto-char (point-min))
                 (if (and (string-match "@public.gmane.org" net)
                          (re-search-forward (format "[^:,]*<%s>" net) (point-max) t))
                     (let ((ad (mail-extract-address-components (match-string 0)))
                           realnet)
                       (message "Found `%S' in headers! Doing realname search!" ad)
                       (and (car ad)
                            (setq realnet (bbdb-search-simple (car ad) nil))
                            (setq realnet (car (bbdb-record-net realnet)))
                            (setq net realnet))))
                 net))
           net))
)

;;        (add-hook 'message-setup-hook 'bbdb-get-mail-aliases) ;; bbdb 3
(add-hook 'message-setup-hook 'bbdb-mail-aliases) ; BBDB 3.x

(require 'bbdb-message)


(defun dkh/bbdb-name ()
  "function to bbdb-search name word at point"
  (interactive)
   (let (myresult)
    (setq myresult (thing-at-point 'word))
    (bbdb-search-name myresult)
    ))

;; no default area code to use when prompting for a new phone number
(setq bbdb-default-area-code nil)

;; default country to use if none is specified
(setq bbdb-default-country "USA")

;; desired number of lines in a GNUS pop-up BBDB window
;;    (setq bbdb-pop-up-window-size  1)
    (setq bbdb-pop-up-window-size  0.5)

;; default display layout
(setq bbdb-layout 'multi-line)

;; automatically add some text to the notes field of the BBDB record
    (add-hook 'bbdb-notice-mail-hook 'bbdb-auto-notes)


(set `bbdb-auto-notes-rules
   `(
;;("From" ("@colorado" . "University of Colorado"))
("CC" ("tmr" . "OIT Managed Services"))
("To" ("-vm@" . "VM mailing list"))
    ("Subject" ("sprocket" . "mail about sprockets")
               ("you bonehead" . "called me a bonehead"))
))


;; will cause the text "VM mailing list" to be added to the notes field
;; of the records corresponding to anyone you get mail from via one of the VM
;; mailing lists.


    ;; capture auto-notes
    (setq bbdb-auto-notes-alist
          ;; organization
          `(("Organization" (".*" Organization 0))

            ;; mailer
            ("User-Agent" (".*" mailer 0 t))  ;; t = overwrite
            ("X-Mailer" (".*" mailer 0 t))
            ("X-Newsreader" (".*" mailer 0 t))

            ;; X-Face bitmaps of the people
            ("x-face" ,(list (concat "[ \t\n]*\\([^ \t\n]*\\)"
                                     "\\([ \t\n]+\\([^ \t\n]+\\)\\)?"
                                     "\\([ \t\n]+\\([^ \t\n]+\\)\\)?"
                                     "\\([ \t\n]+\\([^ \t\n]+\\)\\)?")
                             'face
                             "\\1\\3\\5\\7"))))

(defun dkh/toggle-bbdb-mua-update-interactive-p ()
  "function to toggle bbdb-mua-update-interactive-p"
  (interactive)
(lambda ()
                (when (y-or-n-p "BBDB update interactive? ")
    (cdr bbdb-mua-update-interactive-p)
    (car bbdb-mua-update-interactive-p)
)))

(setq rs-bbdb-ignored-from-list '(
                               "@public.gmane.org"
                                "post <at> gwene.org"
                                "post@gwene.org"
                                "bozo@dev.null.invalid"
                                "no.?reply"
                                "DAEMON"
                                "daemon"
                                "facebookmail"
                                "twitter"
                                "do-not-reply"
                                "lists.math.uh.edu"
                                "emacs-orgmode-confirm"
                         "-confirm"
"gnulist"
"privacy-noreply"
"-request@kgnu.org"
"confirm-nomail"
"noreply"
"webappsec-return"
"vinylisl"
"MAILER-DAEMON"
"noreply"
"mailman-owner"
))


(setq bbdb-ignore-message-alist
      `(("From" . , (regexp-opt rs-bbdb-ignored-from-list))))

(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
  Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))
(global-set-key (kbd "C-,") 'push-mark-no-activate)

(defun dkh/toggle-chrome ()
  "Show/hide toolbar and menubar."
  (interactive)
  (menu-bar-mode)
  (when (window-system)
    (tool-bar-mode)))

;; this seems to enable MS-Word documents
 (defun mm-inline-msword (handle)
   (let (text)
     (with-temp-buffer
       (mm-insert-part handle)
       (call-process-region (point-min) (point-max) "antiword" t t nil "-")
       (setq text (buffer-string)))
     (mm-insert-inline handle text)))

;; stolen from old starter-kit
(defun switch-or-start (function buffer)
  "If the buffer is current, bury it, otherwise invoke the function."
  (if (equal (buffer-name (current-buffer)) buffer)
      (bury-buffer)
    (if (get-buffer buffer)
        (switch-to-buffer buffer)
      (funcall function))))

(defun find-alternative-file-with-sudo ()
    "Open current buffer as root!"
    (interactive)
    (when buffer-file-name
      (find-alternate-file
       (concat "/sudo:root@localhost:"
               buffer-file-name))))

(global-set-key (kbd "C-x C-t") 'find-alternative-file-with-sudo)

(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

 ;; C-8 will increase opacity (== decrease transparency)
 ;; C-9 will decrease opacity (== increase transparency
 ;; C-0 will returns the state to normal
(global-set-key (kbd "H-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "H-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "H-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

(defun forward-open-bracket ()
  "Move cursor to the next occurrence of left bracket or quotation mark."
  (interactive)
  (forward-char 1)
  (search-forward-regexp "(\\|{\\|\\[\\|<\\|〔\\|【\\|〖\\|〈\\|「\\|『\\|“\\|‘\\|‹\\|«")
  (backward-char 1)
  )

(defun backward-open-bracket ()
  "Move cursor to the previous occurrence of left bracket or quotation mark.."
  (interactive)
  (search-backward-regexp "(\\|{\\|\\[\\|<\\|〔\\|【\\|〖\\|〈\\|「\\|『\\|“\\|‘\\|‹\\|«")
  )

(defun forward-close-bracket ()
  "Move cursor to the next occurrence of right bracket or quotation mark."
  (interactive)
  (search-forward-regexp ")\\|\\]\\|}\\|>\\|〕\\|】\\|〗\\|〉\\|」\\|』\\|”\\| ’\\| ›\\| »")
 )

(defun backward-close-bracket ()
  "Move cursor to the next occurrence of right bracket or quotation mark."
  (interactive)
  (backward-char 1)
  (search-backward-regexp ")\\|\\]\\|}\\|>\\|〕\\|】\\|〗\\|〉\\|」\\|』\\|”\\| ’\\| ›\\| »")
  (forward-char 1)
  )

(defun get-point (symbol &optional arg)
 "get the point"
 (funcall symbol arg)
 (point)
)

(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "copy thing between beg & end into kill ring"
   (save-excursion
     (let ((beg (get-point begin-of-thing 1))
        (end (get-point end-of-thing arg)))
       (copy-region-as-kill beg end)))
)

(defun paste-to-mark(&optional arg)
  "Paste things to mark, or to the prompt in shell-mode"
  (let ((pasteMe 
    (lambda()
      (if (string= "shell-mode" major-mode)
        (progn (comint-next-prompt 25535) (yank))
      (progn (goto-char (mark)) (yank) )))))
   (if arg
       (if (= arg 1)
       nil
         (funcall pasteMe))
     (funcall pasteMe))
   ))

(defun copy-word (&optional arg)
 "Copy words at point into kill-ring"
  (interactive "P")
  (copy-thing 'backward-word 'forward-word arg)
  ;;(paste-to-mark arg)
)

;; (transient-mark-mode 1)

(defun select-current-line ()
  "Select the current line"
  (interactive)
  (end-of-line) ; move to end of line
  (set-mark (line-beginning-position)))

(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
       (set-frame-parameter nil 'fullscreen
                            (if (equal 'fullboth current-value)
                                (if (boundp 'old-fullscreen) old-fullscreen nil)
                                (progn (setq old-fullscreen current-value)
                                       'fullboth)))))

(defun insert-date ()
"Insert date at point."
(interactive)
(insert (format-time-string "%d.%m.%Y %H:%M")))

(defun dos-to-unix ()
  "Cut all visible ^M from the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

(defun unix-to-dos ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (replace-match "\r\n"))))

(defun rename-file-and-buffer ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (message "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)))))))

(defun remove-dupes (list)
  (let (tmp-list head)
    (while list
      (setq head (pop list))
      (unless (equal head (car list))
        (push head tmp-list)))
    (reverse tmp-list)))

(defun assoc-replace (seq values)
  "Replace an element within an association list where the cars match."
  (mapcar (lambda (elem)
            (let* ((key (car elem))
                   (val (assoc key values)))
              (if val (cadr val) elem))) seq))

(defun duplicate-current-line ()
  (interactive)
  (beginning-of-line nil)
  (let ((b (point)))
    (end-of-line nil)
    (copy-region-as-kill b (point)))
  (beginning-of-line 2)
  (open-line 1)
  (yank)
  (back-to-indentation))

(defun duplicate-current-line (&optional n)
“duplicate current line, make more than 1 copy given a numeric argument”
(interactive “p”)
(save-excursion
(let ((nb (or n 1))
(current-line (thing-at-point ‘line)))
;; when on last line, insert a newline first
(when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
(insert “\n”))

;; now insert as many time as requested
(while (> n 0)
(insert current-line)
(setq n (- n 1))))))

(global-set-key (kbd "C-S-d") 'duplicate-current-line)

(defun set-longlines-mode ()
  (interactive)
  (text-mode)
  (longlines-mode 1))

(defun regex-replace (regex string)
  (goto-char (point-min))
  (while (re-search-forward regex nil t)
    (replace-match string)))

(defun string-repeat (str n)
  (let ((retval ""))
    (dotimes (i n)
      (setq retval (concat retval str)))
    retval))

;;;###autoload

(defun grab-url-at-point-my ()
  (interactive)
  (kill-new (thing-at-point 'url)))

;;;###autoload

(defun grab-email-my ()
  "Grab the next email in the buffer
  First posted by François Fleuret <francois.fleuret@inria.fr>..
improved by many.."
  (interactive)
  (re-search-forward "[^ \t\n]+@[^ \t\n]+")
  (copy-region-as-kill (match-beginning 0) (match-end 0))
  )

(defun duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
With argument N, make N copies.
With negative N, comment out original line and use the absolute value."
  (interactive "*p")
  (let ((use-region (use-region-p)))
    (save-excursion
      (let ((text (if use-region        ;Get region if active, otherwise line
                      (buffer-substring (region-beginning) (region-end))
                    (prog1 (thing-at-point 'line)
                      (end-of-line)
                      (if (< 0 (forward-line 1)) ;Go to beginning of next line, or make a new one
                          (newline))))))
        (dotimes (i (abs (or n 1)))     ;Insert N times, or once if not specified
          (insert text))))
    (if use-region nil                  ;Only if we're working with a line (not a region)
      (let ((pos (- (point) (line-beginning-position)))) ;Save column
        (if (> 0 n)                             ;Comment out original with negative arg
            (comment-region (line-beginning-position) (line-end-position)))
        (forward-line 1)
        (forward-char pos)))))

(defun increment (n) (interactive "p")
 ;; Increment the number after point.  With an argument, add that much.
 (let (val)
   (delete-region
    (point)
    (progn
      (setq val (read (current-buffer)))
      (if (not (numberp val)) (error "Not in front of a number"))
      (point)))
   (insert (int-to-string (+ val n)))))
(global-set-key "\C-c+" 'increment)

;; Macro way
;; from insert-kbd-macro
(fset 'ucase_between_quotes
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([18 34 67108896 19 34 19 24 21] 0 "%d")) arg)))

;;;  Create a thing type for double-quote delimited "string"
(put 'string 'bounds-of-thing-at-point
     (lambda () (thing-at-point-bounds-of-delimited-thing-at-point "\"")))

(defun dkh/select_q_string_region ()
  "Select the region of string at point"
  (interactive)
  (thing-region "string"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Get IP Address
;; http://emacs-fu.blogspot.com/2009/05/getting-your-ip-address.html
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-ip-address (&optional dev)
  "get the IP-address for device DEV (default: eth0)"
  (interactive)
  (let ((dev (if dev dev "eth0")))
    (format-network-address (car (network-interface-info dev)) t)))

;; http://snipplr.com/view.php?codeview&id=34032

(defun get-ip-addresses ()
  "Returns the current system IPv4 addresses as a list of
strings"
  (let* ((start 0)
; (match-positions ())
(ip-re "[1-9][0-9]?[0-9]?\.[1-9][0-9]?[0-9]?\.[1-9][0-9]?[0-9]?\.[1-9][0-9]?[0-9]?")
;; The rest of these variables try to make this platform agnostic.
;; Add more on to the cond statements if you need
(ipconfig (cond ((eq system-type 'windows-nt)
"ipconfig")
((eq system-type 'gnu/linux)
"/sbin/ifconfig")
((eq system-type 'darwin)
"/sbin/ifconfig")
(t (error "Don't know how to get-ip-address for %s"
system-type))))
(line-re (cond ((eq system-type 'windows-nt)
"IPv4 Address.*")
((eq system-type 'gnu/linux)
(concat "inet addr:" ip-re))
((eq system-type 'darwin)
(concat "inet " ip-re))
(t (error "Don't know how regex out ip line for %s"
system-type))))
;; I lied, not all of the rest of the variables are to make it
;; platform agnostic. This is where we grab the output
(output (shell-command-to-string ipconfig)))

    ;; The inner loop is a bit funky since I can't seem to get it to behave
    ;; exactly like Common Lisp
    (loop for pos in
(loop named inner
with match-positions = ()
do (let ((ret (string-match line-re output start)))
(if ret
(setq start (1+ ret))
(return-from inner match-positions))
(setq match-positions
(append match-positions (list ret)))))
collect (progn
(string-match ip-re output pos)
(match-string 0 output)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Reload current file with position saved
;; http://www.thekidder.net/2008/10/21/emacs-reload-file/
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun reload-file ()
  (interactive)
  (let ((curr-scroll (window-vscroll)))
    (find-file (buffer-name))
    (set-window-vscroll nil curr-scroll)
    (message "Reloaded file")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Edit files as root
;; http://nflath.com/2009/08/tramp/
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun sudo-edit (&optional arg)
  (interactive "p")
  (if arg
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun sudo-edit-current-file ()
  (interactive)
  (let ((pos (point)))
    (find-alternate-file
     (concat "/sudo:root@localhost:" (buffer-file-name (current-buffer))))
    (goto-char pos)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Rename a file and the buffer it's in at the same time
;; Via yeggeconf http://sites.google.com/site/steveyegge2/my-dot-emacs-file
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun rename-file-and-buffer ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (message "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file name new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Abort minibuffer when mousing
;; http://trey-jackson.blogspot.com/2010/04/emacs-tip-36-abort-minibuffer-when.html
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (>= (recursion-depth) 1)
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Random crap
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; http://www.emacswiki.org/emacs/ElispCookbook
(defun qdot/filter (condp lst)
    (delq nil
          (mapcar (lambda (x) (and (funcall condp x) x)) lst)))

;; http://stackoverflow.com/questions/2238418/emacs-lisp-how-to-get-buffer-major-mode
(defun qdot/buffer-mode (buffer-or-string)
  "Returns the major mode associated with a buffer."
  (save-excursion
     (set-buffer buffer-or-string)
     major-mode))

(defun qdot/open-in-browser()
  (interactive)
  (let ((filename (buffer-file-name)))
    (browse-url (concat "file://" filename))))

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun shell-current-directory ()
  "Opens a shell in the current directory"
  (interactive)
  (shell (concat "shell-" default-directory "-shell" )))

;; http://blog.tuxicity.se/elisp/emacs/2010/11/16/delete-file-and-buffer-in-emacs.html
(defun delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

;; http://www.reddit.com/r/emacs/comments/jfrqm/what_does_your_tab_key_do/
(defun smart-tab ()
  "If mark is active, indents region. Else if point is at the end of a symbol,
expands it. Else indents the current line. Acts as normal in minibuffer."
  (interactive)
  (cond (mark-active (indent-region (region-beginning) (region-end)))
        ((and (looking-at "\\_>") (not (looking-at "end")))
         (hippie-expand nil))
        (t (indent-for-tab-command))))

(defun dkh-shell-with-name (name)
  (interactive "sName: ")
  "Creates a shell with name given by the first argument, and switches to it. If a buffer with name already exists, we simply switch to it."
  (let ((buffer-of-name (get-buffer (concat "*eshell-" (persp-name persp-curr) "-" name "*")))
       (localdir name))
    (cond ((bufferp buffer-of-name) ;If the buffer exists, switch to it (assume it is a shell)
           (switch-to-buffer buffer-of-name))
          ( t 
            (progn
              (eshell)
              ;(process-send-string (get-buffer-process new-buff-name) (concat "cd " localdir "\n"))
              (rename-buffer  (concat "*eshell-" (persp-name persp-curr) "-" name "*")))))))


(defun dkh-eshell-macs ()
  (interactive)
  "Creates a tool config shell and switches to it. If a buffer with name already exists, we simply switch to it."
  (let ((buffer-of-name (get-buffer (concat "*eshell-" (persp-name persp-curr) "-tool-config*")))
        (default-directory "~/git/vinylisland"))
    (cond ((bufferp buffer-of-name) ;If the buffer exists, switch to it (assume it is a shell)
           (switch-to-buffer buffer-of-name))
          ( t 
            (progn
              (eshell t)
              ;(process-send-string (get-buffer-process new-buff-name) (concat "cd " localdir "\n"))
              (rename-buffer  (concat "*eshell-" (persp-name persp-curr) "-tool-config*")))))))

(message (concat "0 " (buffer-name) "... Done"))

(defun cat-command ()
  "A command for cats."
  (interactive)
  (require 'animate)
  (let ((mouse "
           ___00
        ~~/____'>
          \"  \"")
        (h-pos (floor (/ (window-height) 2)))
        (contents (buffer-string))
        (mouse-buffer (generate-new-buffer "*mouse*")))
    (save-excursion
      (switch-to-buffer mouse-buffer)
      (insert contents)
      (setq truncate-lines t)
      (animate-string mouse h-pos 0)
      (dotimes (_ (window-width))
        (sit-for 0.01)
        (dotimes (n 3)
          (goto-line (+ h-pos n 2))
          (move-to-column 0)
          (insert " "))))
    (kill-buffer mouse-buffer)))

(defun toggle-line-spacing ()
  "Toggle line spacing between no extra space to extra half line height."
  (interactive)
  (if (eq line-spacing nil)
      (setq-default line-spacing 0.5) ; add 0.5 height between lines
    (setq-default line-spacing nil)   ; no extra heigh between lines
    )
  (redraw-display))

(defun my-insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.

Prefixed with \\[universal-argument], expand the file name to
its fully canocalized path.  See `expand-file-name'.

Prefixed with \\[negative-argument], use relative path to file
name from current directory, `default-directory'.  See
`file-relative-name'.

The default with no prefix is to insert the file name exactly as
it appears in the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (file-relative-name filename)))
        ((not (null args))
         (insert (expand-file-name filename)))
        (t
         (insert filename))))

(global-set-key (kbd "C-H-f") 'my-insert-file-name)

(autoload 'ffap-guesser "ffap")
(autoload 'ffap-read-file-or-url "ffap")

(defun my-replace-file-at-point (currfile newfile)
  "Replace CURRFILE at point with NEWFILE.

When interactive, CURRFILE will need to be confirmed by user
and will need to exist on the file system to be recognized,
unless it is a URL.

NEWFILE does not need to exist.  However, Emacs's minibuffer
completion can help if it needs to be.

Based on `ffap'."
  (interactive
   (let ((currfile (ffap-read-file-or-url "Replace filename: "
                                          (ffap-guesser))))
     (list currfile
           (ffap-read-file-or-url (format "Replace `%s' with: "
                                          currfile) currfile))))
  (save-match-data
    (if (or (looking-at (regexp-quote currfile))
            (let ((filelen (length currfile))
                  (opoint (point))
                  (limit (+ (point) (length currfile))))
              (save-excursion
                (goto-char (1- filelen))
                (and (search-forward currfile limit
                                     'noerror)
                     (< (match-beginning 0) opoint))
                     (>= (match-end 0) opoint))))
        (replace-match newfile)
      (error "No file at point to replace"))))

(global-set-key (kbd "C-H-v") 'my-replace-file-at-point)

(message "0 dkh-insert-filename... Done")

(defun get-relative-line-content (num)
  "Return the string content of line `num' relative to the current line"
  (save-excursion
    (forward-line num)
    (buffer-substring-no-properties
     (line-beginning-position) (line-end-position))))

(defun insert-line-same ()
  "Insert the content up to the first difference of the previous two lines."
  (interactive)
  (let* ((line1 (get-relative-line-content -2))
    (line2 (get-relative-line-content -1))
      (beg (current-column))
      (end (compare-strings line1 beg nil line2 beg nil)))
    (insert-string
     (substring line1 beg
            (if (integerp end)
                (+ beg (- (abs end) 1))
              (length line1))))))

(autoload 'Lorem-ipsum-insert-paragraphs "lorem-ipsum" "" t)
(autoload 'Lorem-ipsum-insert-sentences "lorem-ipsum" "" t)
(autoload 'Lorem-ipsum-insert-list "lorem-ipsum" "" t)

(require 'pastebin)

(setq dictem-server "localhost")
(require 'dictem)

;;  http://www.myrkr.in-berlin.de/dictionary/

; SEARCH = MATCH + DEFINE
; Ask for word, database and search strategy
; and show definitions found

; SHOW DB
; Show a list of databases provided by DICT server
(global-set-key "\C-c\M-b" 'dictem-run-show-databases)

(define-key dictem-mode-map [tab] 'dictem-next-link)
(define-key dictem-mode-map [(backtab)] 'dictem-previous-link)
(define-key dictem-mode-map [return] 'dictem-run-search)

(dictem-initialize)

(defun my-dictem-run-search ()
  "Look up definitions for word at point."
  (interactive)
  (dictem-run 'dictem-base-search "*" (thing-at-point 'word) ".")
  (other-window 1))

;;;###autoload

(defun rgr/synonyms()
 (interactive)
 (let* ((default (thing-at-point 'symbol))
        (term (read-string (format "Synonyms for (%s): "
                                   default) default)))
   (dictem-run
    'dictem-base-search
    "moby-thes" term "exact")))

(define-key mode-specific-map [?S] 'rgr/synonyms)

(dictem-initialize)

;; junk

;; moby-thes is not a valid database, use -D for a list
;; No matches found for "junk"

    ;; For creating hyperlinks on database names and found matches.
    ;; Click on them with `mouse-2'
(add-hook 'dictem-postprocess-match-hook
         'dictem-postprocess-match)

    ;; For highlighting the separator between the definitions found.
    ;; This also creates hyperlink on database names.
(add-hook 'dictem-postprocess-definition-hook
         'dictem-postprocess-definition-separator)

    ;; For creating hyperlinks in dictem buffer that contains definitions.
(add-hook 'dictem-postprocess-definition-hook
         'dictem-postprocess-definition-hyperlinks)

    ;; For creating hyperlinks in dictem buffer that contains information
    ;; about a database.
(add-hook 'dictem-postprocess-show-info-hook
         'dictem-postprocess-definition-hyperlinks)

(add-hook 'dictem-postprocess-definition-hook
         'dictem-postprocess-each-definition)



(define-key flyspell-mode-map (kbd "C-+") 'flyspell-check-previous-highlighted-word)
(define-key flyspell-mode-map (kbd "C-#") 'flyspell-auto-correct-previous-word)
(define-key flyspell-mode-map (kbd "S-<f2>") 'ispell-word)
(define-key flyspell-mode-map (kbd "C-<f2>") 'flyspell-auto-correct-previous-word)

(setq synonyms-file "~/.emacs.d/thesaurus/mthesaur.txt")
(setq synonyms-cache-file "~/.emacs.d/thesaurus/syn.cache")
(setq synonyms-match-more-flag nil)

(require 'synonyms)
(define-key mode-specific-map [?S] 'synonyms)

(define-key mode-specific-map [?s] 'dictem-run-search)


(define-key dictem-mode-map [tab] 'dictem-next-link)
(define-key dictem-mode-map [(backtab)] 'dictem-previous-link)

; For creating hyperlinks on database names
                                      ; and found matches.
                                      ; Click on them with mouse-2
(add-hook 'dictem-postprocess-match-hook
        'dictem-postprocess-match)

        ; For highlighting the separator between the definitions found.
        ; This also creates hyperlink on database names.
(add-hook 'dictem-postprocess-definition-hook 
        'dictem-postprocess-definition-separator)

        ; For creating hyperlinks in dictem buffer
                                      ; that contains definitions.
(add-hook 'dictem-postprocess-definition-hook 
        'dictem-postprocess-definition-hyperlinks)

        ; For creating hyperlinks in dictem buffer
        ; that contains information about a database.
(add-hook 'dictem-postprocess-show-info-hook
        'dictem-postprocess-definition-hyperlinks)

(require 'identica-mode)

(require 'oauth2)

(autoload 'identica-mode "identica-mode" nil t)
(setq identica-auth-mode "oauth2")

(global-set-key "\C-cip" 'identica-update-status-interactive)

(global-set-key "\C-cid" 'identica-direct-message-interactive)

;; secrets.el.gpg
(setq identica-username "username")

;; (setq load-path (cons "/usr/share/emacs/site-lisp/w3m/" load-path))
(require 'w3m)


;;             (defun playwav (url)
;;               (interactive)
;;               (message "url is %s" url)
;;               (w3m-view-this-url url)
;;               )

(setq mm-text-html-renderer 'w3m)


;;(define-key gnus-article-mode-map (kbd "M-w") 'org-w3m-copy-for-org-mode)

(define-key gnus-article-mode-map (kbd "C-c C-x M-w") 'org-w3m-copy-for-org-mode)

(setq apropos-url-alist
      '(("^gw?:? +\\(.*\\)" . ;; Google Web 
         "http://www.google.com/search?q=\\1")

        ("^g!:? +\\(.*\\)" . ;; Google Lucky
         "http://www.google.com/search?btnI=I%27m+Feeling+Lucky&q=\\1")
        
        ("^gl:? +\\(.*\\)" .  ;; Google Linux 
         "http://www.google.com/linux?q=\\1")
        
        ("^gi:? +\\(.*\\)" . ;; Google Images
         "http://images.google.com/images?sa=N&tab=wi&q=\\1")

        ("^gg:? +\\(.*\\)" . ;; Google Groups
         "http://groups.google.com/groups?q=\\1")

        ("^gd:? +\\(.*\\)" . ;; Google Directory
         "http://www.google.com/search?&sa=N&cat=gwd/Top&tab=gd&q=\\1")

        ("^gn:? +\\(.*\\)" . ;; Google News
         "http://news.google.com/news?sa=N&tab=dn&q=\\1")

        ("^gt:? +\\(\\w+\\)|? *\\(\\w+\\) +\\(\\w+://.*\\)" . ;; Google Translate URL
         "http://translate.google.com/translate?langpair=\\1|\\2&u=\\3")
        
        ("^gt:? +\\(\\w+\\)|? *\\(\\w+\\) +\\(.*\\)" . ;; Google Translate Text
         "http://translate.google.com/translate_t?langpair=\\1|\\2&text=\\3")

        ("^/\\.$" . ;; Slashdot 
         "http://www.slashdot.org")

        ("^/\\.:? +\\(.*\\)" . ;; Slashdot search
         "http://www.osdn.com/osdnsearch.pl?site=Slashdot&query=\\1")        
        
        ("^fm$" . ;; Freshmeat
         "http://www.freshmeat.net")

        ("^ewiki:? +\\(.*\\)" . ;; Emacs Wiki Search
         "http://www.emacswiki.org/cgi-bin/wiki?search=\\1")
 
        ("^ewiki$" . ;; Emacs Wiki 
         "http://www.emacswiki.org")

        ("^arda$" . ;; The Encyclopedia of Arda 
         "http://www.glyphweb.com/arda/")
         
         ))

(add-to-list 'apropos-url-alist '("^googledict:? +\\(\\w+\\)|? *\\(\\w+\\) +\\(.*\\)" . "http://www.google.com/dictionary?aq=f&langpair=\\1|\\2&q=\\3&hl=\\1"))
(add-to-list 'apropos-url-alist '("^ewiki2:? +\\(.*\\)" .  "http://www.google.com/cse?cx=004774160799092323420%3A6-ff2s0o6yi&q=\\1&sa=Search"))

(add-to-list 'apropos-url-alist '("^dpi:? +\\(.*\\)" . "http://api.drupal.org/api/search/7/\\1")) ;; Drupal API default to 7, api number if specified

(defun browse-apropos-url (text &optional new-window)
  (interactive (browse-url-interactive-arg "Location: "))
  (let ((text (replace-regexp-in-string 
               "^ *\\| *$" "" 
               (replace-regexp-in-string "[ \t\n]+" " " text))))
    (let ((url (assoc-default 
                text apropos-url-alist 
                '(lambda (a b) (let () (setq __braplast a) (string-match a b)))
                text)))
      (browse-url (replace-regexp-in-string __braplast url text) new-window))))

(defun browse-apropos-url-on-region (min max text &optional new-window)
  (interactive "r \nsAppend region to location: \nP")
  (browse-apropos-url (concat text " " (buffer-substring min max)) new-window))

;;(require 'browse-apropos-url)
;; (provide 'browse-url)



(defun rgr/browse-url (arg &optional url)
  "Browse the URL passed. Use a prefix arg for external default browser else use default browser which is probably W3m"
  (interactive "P")
  (setq url (or url (w3m-url-valid (w3m-anchor))
  (browse-url-url-at-point) 
(thing-at-point 'word)
))
  (if arg
      (when url (browse-url-default-browser url))
    (if  url (browse-url url) (call-interactively 'browse-url))
    ))


(defun rgr/google(term)
  "Call google search for the specified term. Do not call if string is zero length."
  (let ((url (if (zerop (length term)) "http://www.google.com " (concat "gw: " term))))
    (browse-apropos-url url)))

(defun rgr/google-search-prompt()
  (interactive)
  (rgr/google (read-string "Google the web for the following phrase :
  "
(thing-at-point 'word)
)))

(add-to-list 'apropos-url-alist '("^googledict:? +\\(\\w+\\)|? *\\(\\w+\\) +\\(.*\\)" . "http://www.google.com/dictionary?aq=f&langpair=\\1|\\2&q=\\3&hl=\\1"))
(add-to-list 'apropos-url-alist '("^ewiki2:? +\\(.*\\)" .  "http://www.google.com/cse?cx=004774160799092323420%3A6-ff2s0o6yi&q=\\1&sa=Search"))


(defun rgr/call-google-translate (langpair prompt)
  (interactive)
  (let* ((thing (thing-at-point 'word) )
    )
    (setq thing (read-string (format prompt thing) nil nil thing))
    (browse-apropos-url  (concat (if (string-match " " thing) (quote "gt")(quote "googledict")) " " langpair " " thing))))

(defun rgr/browse-apropos-url (prefix prompt)
  (interactive)
  (let* ((thing (thing-at-point 'word))
    )
    (setq thing (read-string (format prompt thing) nil nil thing))
    (browse-apropos-url  (concat prefix " " thing))))

;; Search Google at point:
(defun my-search-google (w)
  "Launch google on the Word at Point"
  (interactive
   (list (let* ((word (thing-at-point 'symbol))
                (input (read-string (format "Google%s: " 
                                (if (not word) "" (format " (default %s)" word))))))
           (if (string= input "") (if (not word) 
                       (error "No keyword to search given") word) input) ;sinon input
           )))
  (browse-url (format "http:/www.google.com/search?q=%s" w))
  )

;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.


(defun pm/region-or-word (prompt)
  "Read a string from the minibuffer, prompting with PROMPT.
If `transient-mark-mode' is non-nil and the mark is active,
it defaults to the current region, else to the word at or before
point. This function returns a list (string) for use in `interactive'."
  (list (read-string prompt (or (and transient-mark-mode mark-active
                                     (buffer-substring-no-properties
                                      (region-beginning) (region-end)))
                            (current-word))))) 
(defun pm/google (string)
  "Ask a WWW browser to google string.
Prompts for a string, defaulting to the active region or the current word at
or before point."
  (interactive (pm/region-or-word "Google: "))
  (browse-url (concat "http://google.com/search?num=100&q=" string)))


(setq w3m-use-cookies t)

(setq w3m-coding-system 'utf-8
      w3m-file-coding-system 'utf-8
      w3m-file-name-coding-system 'utf-8
      w3m-input-coding-system 'utf-8
      w3m-output-coding-system 'utf-8
      w3m-terminal-coding-system 'utf-8)

(require 'org-w3m)

(setq browse-url-new-window-flag t)

(setq browse-url-browser-function 'w3m-browse-url-other-workgroup)

(defun w3m-browse-url-other-workgroup (url &optional newwin)
  (let ((w3m-pop-up-windows t))
   (dkh-persp/w3m)
    (w3m-browse-url url newwin)))

(setq browse-url-generic-program "conkeror")

(defun rgr/browse (url)
  "If prefix is specified use the system default browser else use the configured emacs one"
  (if current-prefix-arg
;;      (when url (browse-url-default-browser url))
      (when url (browse-url-generic url))
    (if  url (browse-url url) (call-interactively 'browse-url))
    ))

(defun rgr/browse-url (&optional url)
  "browse the url passed in"
  (interactive)
  (setq url (or url (w3m-url-valid (w3m-anchor)) (browse-url-url-at-point) (region-or-word-at-point)))
  (setq url (read-string (format "Url \"%s\" :" url) url nil url))
  (rgr/browse url))

(global-set-key "\C-xm" 'browse-url-at-point)
(global-set-key (kbd "<f4>") 'rgr/browse-url)

(require 'webjump)

(global-set-key [H-f2] 'webjump)
(setq webjump-sites
(append '(
("Java API" .
[simple-query "www.google.com" "http://www.google.com/search?hl=en&as_sitesearch=http://java.sun.com/javase/6/docs/api/&q=" ""])
("Stack Overflow" . "www.stackoverlow.com")
("Pop's Site"   . "www.joebob-and-son.com/")

)
      webjump-sample-sites))

(setq
           w3m-session-file "~/.emacs.d/.w3m-session"
)

 (defun w3m-add-keys ()
   (define-key w3m-mode-map "S" 'w3m-session-save)
   (define-key w3m-mode-map "L" 'w3m-session-load))
 (add-hook 'w3m-mode-hook 'w3m-add-keys)

(defun my-w3m-rename-buffer (url)
  "Renames the current buffer to be the current URL"
  (rename-buffer url t))
(add-hook 'w3m-display-hook 'my-w3m-rename-buffer)

(setq w3m-default-directory "~/.emacs.d/.w3m")

(message "0 dkh-w3m... Done")

(defun sacha/toggle-w3m ()
  (interactive)
  (let ((list (buffer-list))
        found
        (from-w3m (equal major-mode 'w3m-mode)))
    (while list
      (when (with-current-buffer (car list)
              (if from-w3m
                  (not (equal major-mode 'w3m-mode))
                (equal major-mode 'w3m-mode)))
        (setq found (car list))
        (pop-to-buffer (car list))
        (setq list nil))
      (setq list (cdr list)))
    (unless (or from-w3m found)
      (call-interactively 'w3m))))

;; http://www.mit.edu/afs/sipb/contrib/emacs/packages/w3m_el-1.2.8/w3m-filter.el
(defun sacha/w3m-filter-google (url &rest ignore)
  "Add <LINK> tag to search results of www.google.com."
  (goto-char (point-max))
  (let ((next (when (re-search-backward
                     "<a href=\\([^>]+\\)><img src=/\\(intl/[^/]+/\\)?nav_next.gif"
                     nil t)
                (match-string 1)))
        (prev (when (re-search-backward
                     "<a href=\\([^>]+\\)><img src=/\\(intl/[^/]+/\\)?nav_previous.gif"
                     nil t)
                (match-string 1))))
    (goto-char (point-min))
    (when (search-forward "<head>" nil t)
      (when prev (insert "\n<link rel=\"prev\" href=\"" prev "\">"))
      (when next (insert "\n<link rel=\"next\" href=\"" next "\">")))
    t))

(defun sacha/w3m-filter-clientcopia (url &rest ignore)
  "Add <LINK> tag to search results of www.clientcopia.com."
  (goto-char (point-max))
  (let* ((next (when (re-search-backward
                     "\\(quotes.php.id=[0-9]+\\).*NEXT"
                     nil t)
                (match-string 1)))
         (prev (when (re-search-backward
                     "<a href=\\(quotes.php.id=[0-9]+\\).*BACK"
                     nil t)
                (match-string 1))))
    (goto-char (point-min))
    (when (search-forward "<head>" nil t)
      (when prev (insert "\n<link rel=\"prev\" href=\"" prev "\">"))
      (when next (insert "\n<link rel=\"next\" href=\"" next "\">")))
    t))

;; Guessed
(defun w3m-filter-find-relationships (url next previous)
  "Add <LINK> tags if they don't yet exist."
  (let ((case-fold-search t))
    (goto-char (point-max))
    (when (re-search-backward next nil t)
      (when (re-search-backward "href=\"?\\([^\" \t\n]+\\)" nil t)
        (setq w3m-next-url (match-string 1))))
    (when (re-search-backward previous nil t)
      (when (re-search-backward "href=\"?\\([^\" \t\n]+\\)" nil t)
        (setq w3m-previous-url (match-string 1))))))

(defun w3m-download-with-wget ()
  (interactive)
  (let ((url (or (w3m-anchor) (w3m-image))))
    (if url
        (let ((proc (start-process "wget" (format "*wget %s*" url)
                                   "wget" "-x" "--passive-ftp" "-nv"
                                   "-P" "/home/sacha/notebook/mirrors" url)))
          (with-current-buffer (process-buffer proc)
            (erase-buffer))
          (set-process-sentinel proc (lambda (proc str)
                                       (message "wget download done"))))
      (message "Nothing to get"))))

(defun sacha/w3m-setup-keymap ()
  "Use my heavily customized map."
  (interactive)
  ;; Undefine this key and use the advice instead so that my ido doesn't get
  ;; overridden
  (define-key w3m-mode-map (kbd "C-x b") nil)
  (define-key w3m-mode-map "C" 'w3m-print-this-url)
  (define-key w3m-mode-map "a" 'sacha/delicious-url)
  (define-key w3m-mode-map "A" 'w3m-bookmark-add-current-url)
  (define-key w3m-mode-map "w" 'w3m-download-with-wget)
  (define-key w3m-mode-map "d" 'w3m-download-with-wget)
  (define-key w3m-mode-map "D" 'w3m-download-this-url)
  ;; Do not override my ever so handy ERC binding
  (define-key w3m-mode-map (kbd "C-c C-SPC") nil)
  (define-key w3m-mode-map "m" 'sacha/w3m-mirror-current-page)
  (define-key w3m-mode-map "M" 'sacha/w3m-mirror-link)
  ;; I use search much more often than the context history list, although
  ;; context is still cool. 
  (define-key w3m-mode-map "!" 'sacha/w3m-mirror-current-page)
  (define-key w3m-mode-map "s" 'w3m-search)
  (define-key w3m-mode-map "h" 'w3m-history)
  (define-key w3m-mode-map "t" 'w3m-scroll-down-or-previous-url)
  (define-key w3m-mode-map "n" 'w3m-scroll-up-or-next-url)
  ;; I don't often w3m to edit pages, so I'm borrowing o and e (right
  ;; below , / . for tab navigation) for page navigation instead.
  (define-key w3m-mode-map "o" 'w3m-view-previous-page)
  (define-key w3m-mode-map "e" 'w3m-view-next-page)
  ;; i is a more useful mnemonic for toggling images
  (define-key w3m-mode-map "i" 'w3m-toggle-inline-image)
  (define-key w3m-mode-map "I" 'w3m-toggle-inline-images)
  ;; and X for closing the buffer
  (define-key w3m-mode-map "X" 'w3m-delete-buffer)
  (define-key w3m-mode-map "x" 'w3m-delete-buffer)
  (define-key w3m-mode-map "z" 'w3m-delete-buffer)
  ;; and b for bookmarks
  (define-key w3m-mode-map "b" 'w3m-bookmark-view)
  ;; I don't use the Qwerty keymap, so hjkl is useless for me
  ;; I'll use HTNS, though
  (define-key w3m-mode-map "H" 'backward-char)
  (define-key w3m-mode-map "T" 'previous-line)
  (define-key w3m-mode-map "N" 'next-line)
  (define-key w3m-mode-map "S" 'forward-char)
  ;; Browse in new sessions by default
  (define-key w3m-mode-map (kbd "RET") 'w3m-view-this-url-new-session)
  (define-key w3m-mode-map [(shift return)] 'w3m-view-this-url)
  (define-key w3m-mode-map "g" 'w3m-goto-url)
  (define-key w3m-mode-map "G" 'w3m-goto-url-new-session)
  ;; f for forward? I want to be able to follow links without removing
  ;; most of my fingers from home row. My fingers are too short to hit
  ;; Enter.
  (define-key w3m-mode-map "f" 'w3m-view-this-url-new-session)
  (define-key w3m-mode-map "F" 'w3m-view-this-url)
  ;; Use cursor keys to scroll
  (define-key w3m-mode-map [(left)] 'backward-char)
  (define-key w3m-mode-map [(right)] 'forward-char)
  (define-key w3m-mode-map [(shift left)] 'w3m-shift-right)
  (define-key w3m-mode-map [(shift right)] 'w3m-shift-left)
  ;; Which means I can now use , and . to switch pages
  (define-key w3m-mode-map "." 'w3m-next-buffer)
  (define-key w3m-mode-map "," 'w3m-previous-buffer)
  ;; IBM stuff
  (define-key w3m-mode-map "i" nil)
  (define-key w3m-mode-map "ib" 'sacha/ibm-blog)
  (define-key w3m-mode-map "id" 'sacha/dogear-url)
  (define-key w3m-mode-map "f" 'sacha/w3m-open-in-firefox)

  )

(setq w3m-keep-arrived-urls 5000)
(add-hook 'w3m-mode-hook 'sacha/w3m-setup-keymap)
;;(sacha/w3m-setup-keymap)

(defun sacha/w3m-open-in-firefox ()
  (interactive)
  (browse-url-firefox w3m-current-url))

(eval-after-load 'w3m
  '(progn
     (define-key w3m-mode-map "q" 'w3m-previous-buffer)
     (define-key w3m-mode-map "w" 'w3m-next-buffer)
     (define-key w3m-mode-map "x" 'w3m-close-window)))

(defun i-wanna-be-social ()
  "Connect to IM networks using bitlbee."
  (interactive)
  (erc :server "localhost" :port 6667 :nick "my_nick")
)

(setq dkh-bitlebee-password "password")

(defun bitlbee-identify ()
  (when (and (string= "localhost" erc-session-server)
          (string= "&bitlbee" (buffer-name)))
    (erc-message "PRIVMSG" (format "%s identify user secretpassword"
                             (erc-default-target)
                             dkh-bitlebee-password))))

(add-hook 'erc-join-hook 'bitlbee-identify)

(defun erc-cmd-ICQWHOIS (uin)
  "Queries icq-user with UIN `uin', and returns the result."
  (let* ((result (myerc-query-icq-user uin))
         (fname (cdr (assoc 'fname result)))
         (lname (cdr (assoc 'lname result)))
         (nick (cdr (assoc 'nick result))))
    (erc-display-message nil 'notice (current-buffer) (format "%s (%s %s)" nick fname lname))))

(require 'magit)

(setq magit-repo-dirs (quote
(
        "/home/user/git/project"
        "/home/user/git/project2"
        "/su:user@localhost:/home/www/project1"
)))

(defun jcs-comment-box (b e)
  "Draw a box comment around the region but arrange for the region
to extend to at least the fill column. Place the point after the
comment box."
  (interactive "r")
  (let ((e (copy-marker e t)))
    (goto-char b)
    (end-of-line)
    (insert-char ?  (- fill-column (current-column)))
    (comment-box b e 1)
    (goto-char e)
    (set-marker e nil)))

(setq compilation-scroll-output 1)

;;; Shut up compile saves
(setq compilation-ask-about-save nil)
;;; Don't save *anything*
(setq compilation-save-buffers-predicate '(lambda () nil))

(add-hook 'css-mode-hook 'rainbow-mode)

(subword-mode 1) ; 1 for on, 0 for off
(global-subword-mode 1) ; 1 for on, 0 for off

(require 'whitespace)
(global-set-key (kbd "C-c w") 'whitespace-mode)
(global-set-key (kbd "C-c W") 'whitespace-toggle-options)
(setq whitespace-line-column 80
      whitespace-style '(tabs trailing lines-tail))
(set-face-attribute 'whitespace-line nil
                    :background "red1"
                    :foreground "yellow"
                    :weight 'bold)

;; face for Tabs
(set-face-attribute 'whitespace-tab nil
                    :background "red1"
                    :foreground "yellow"
                    :weight 'bold)

(require 'js-mode-expansions)
(require 'html-mode-expansions)
(require 'css-mode-expansions)

(setq php-manual-path "~/docs/php/php-chunked-xhtml/")

(setq php-completion-file "~/git/.emacs.d/php-completion-file")

(require 'drupal-mode)

(setq auto-mode-alist
      (append
       '(
("\\.php$" . php-mode)
("\.\(module\|test\|install\|theme\)$" . drupal-mode)
("/drupal.*\.\(php\|inc\)$" . drupal-mode)
("\.info" . conf-mode)
         ) auto-mode-alist))

(require 'etags-select)

;; list of file names of tags tables to search
(setq tags-table-list
      '(
"~/.emacs.d/TAGS"
        ))

(defun ido-find-tag ()
  "Find a tag using ido"
  (interactive)
  (tags-completion-table)
  (let (tag-names)
    (mapc (lambda (x)
        (unless (integerp x)
          (push (prin1-to-string x t) tag-names)))
      tags-completion-table)
    (find-tag (ido-completing-read "Tag: " tag-names))))
 
(defun ido-find-file-in-tag-files ()
  (interactive)
  (save-excursion
    (let ((enable-recursive-minibuffers t))
      (visit-tags-table-buffer))
    (find-file
     (expand-file-name
      (ido-completing-read
       "Project file: " (tags-table-files) nil t)))))
 
(global-set-key [remap find-tag] 'ido-find-tag)
(global-set-key (kbd "H-.") 'ido-find-file-in-tag-files)

(defun pm/find-tags-file ()
  "Recursively searches each parent directory for a file named `TAGS'
   and returns the path to that file or nil if a tags file is not found.
   Returns nil if the buffer is not visiting a file.
   (from jds-find-tags-file in the emacs-wiki)"
  (labels ((find-tags-file-r
            (path)
            (let* ((parent (if path (file-name-directory path)
                             default-directory))
                   (possible-tags-file (concat parent "TAGS")))
              (cond
               ((file-exists-p possible-tags-file)
                (shell-command (concat "make -C" parent " TAGS"))
                (throw 'found-it possible-tags-file))
               ((string= "/TAGS" possible-tags-file)
                (error "no tags file found"))
               (t
                (find-tags-file-r (directory-file-name parent)))))))
    (catch 'found-it 
      (find-tags-file-r (buffer-file-name)))))

(defadvice find-tag (before pm/before-find-tag activate)
  (setq tags-file-name (pm/find-tags-file)))

(require 'generic-x)

(define-generic-mode 'htaccess-mode
  '(?#)
  '(;; core
    "AcceptPathInfo" "AccessFileName" "AddDefaultCharset" "AddOutputFilterByType"
    "AllowEncodedSlashes" "AllowOverride" "AuthName" "AuthType"
    "CGIMapExtension" "ContentDigest" "DefaultType" "DocumentRoot"
    "EnableMMAP" "EnableSendfile" "ErrorDocument" "ErrorLog"
    "FileETag" "ForceType" "HostnameLookups" "IdentityCheck"
    "Include" "KeepAlive" "KeepAliveTimeout" "LimitInternalRecursion"
    "LimitRequestBody" "LimitRequestFields" "LimitRequestFieldSize" "LimitRequestLine"
    "LimitXMLRequestBody" "LogLevel" "MaxKeepAliveRequests" "NameVirtualHost"
    "Options" "Require" "RLimitCPU" "RLimitMEM"
    "RLimitNPROC" "Satisfy" "ScriptInterpreterSource" "ServerAdmin"
    "ServerAlias" "ServerName" "ServerPath" "ServerRoot"
    "ServerSignature" "ServerTokens" "SetHandler" "SetInputFilter"
    "SetOutputFilter" "TimeOut" "UseCanonicalName"
    ;; .htaccess tutorial
    "AddHandler" "AuthUserFile" "AuthGroupFile"
    ;; mod_rewrite
    "RewriteBase" "RewriteCond" "RewriteEngine" "RewriteLock" "RewriteLog"
    "RewriteLogLevel" "RewriteMap" "RewriteOptions" "RewriteRule"
    ;; mod_alias
    "Alias" "AliasMatch" "Redirect" "RedirectMatch" "RedirectPermanent"
    "RedirectTemp" "ScriptAlias" "ScriptAliasMatch")
  '(("%{\\([A-Z_]+\\)}" 1 font-lock-variable-name-face)
    ("\\b[0-9][0-9][0-9]\\b" . font-lock-constant-face)
    ("\\[.*\\]" . font-lock-type-face))
  '(".htaccess\\'")
  nil
  "Generic mode for Apache .htaccess files.")

(add-to-list 'auto-mode-alist '("\\.htaccess\\'" . htaccess-mode))

(defun my-html-mode-setup ()                                    
(auto-fill-mode -1))                                          
(add-hook 'html-mode-hook 'my-html-mode-setup)

(defun prettify-key-sequence (&optional omit-brackets)
    "Markup a key sequence for pretty display in HTML.
  If OMIT-BRACKETS is non-null then don't include the key sequence brackets."
    (interactive "P")
    (let* ((seq (thing-at-point 'symbol))
           (key-seq (elt seq 0))
           (beg (elt seq 1))
           (end (elt seq 2))
           (key-seq-map (list (key "Ctrl") (key "Meta") (key "Shift")
                              (key "Tab") (key "Alt") (key "Esc")
                              (key "Enter") (key "Return") (key "Backspace")
                              (key "Delete") (key "F10") (key "F11")
                              (key "F12") (key "F2") (key "F3")
                              (key "F4") (key "F5") (key "F6") (key "F7")
                              (key "F8") (key "F9")
                              ;; Disambiguate F1
                              '("\\`F1" . "@<span class=\"key\">F1@</span>")
                              '("\\([^>]\\)F1" .
                                "\\1@<span class=\"key\">F1@</span>")
                              ;; Symbol on key
                              '("Opt" . "@<span class=\"key\">⌥ Opt@</span>")
                              '("Cmd" . "@<span class=\"key\">⌘ Cmd@</span>")
                              ;; Combining rules
                              '("\+\\(.\\) \\(.\\)\\'" .
                                "+@<span class=\"key\">\\1@</span> @<span class=\"key\">\\2@</span>")
                              '("\+\\(.\\) \\(.\\) " .
                                "+@<span class=\"key\">\\1@</span> @<span class=\"key\">\\2@</span> ")
                              '("\+\\(.\\) " .
                                "+@<span class=\"key\">\\1@</span> ")
                              '("\+\\(.\\)\\'" .
                                "+@<span class=\"key\">\\1@</span>"))))
      (mapc (lambda (m) (setq key-seq (replace-regexp-in-string
                                       (car m) (cdr m) key-seq t)))
            key-seq-map)
      ;; Single key
      (if (= (length key-seq) 1)
          (setq key-seq (concat "@<span class=\"key\">" key-seq "@</span>")))
      (delete-region beg end)
      (if omit-brackets
          (insert key-seq)
        (insert (concat "【" key-seq "】")))))
  
(defalias 'pks 'prettify-key-sequence)

(defun open-in-desktop ()
  "Open the current file in desktop.
Works in Microsoft Windows, Mac OS X, Linux."
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" default-directory t t)))
   ((string-equal system-type "darwin") (shell-command "open ."))
   ((string-equal system-type "gnu/linux") (shell-command "xdg-open ."))
   ) )

(global-set-key (kbd "<f7>") 'open-in-desktop)

(starter-kit-load "js")

;;; psvn
(setq svn-status-prefix-key '[(hyper s)])
(require 'psvn)
(define-key svn-log-edit-mode-map [f6] 'svn-log-edit-svn-diff)

(defun xsteve-svn-log-edit-setup ()
  (setq ispell-local-dictionary "english")
  (auto-fill-mode 1))

(add-hook 'svn-log-edit-mode-hook 'xsteve-svn-log-edit-setup)

(yas/load-directory "~/git/.emacs.d/snippets2")

(yas/load-directory "~/git/.emacs.d/snippets")

(yas/define-snippets 'text-mode
             '(("email" "me@google.com" "(user's email)" nil nil nil nil nil)
               ("phone" "777-777-7777" "(phone numer)" nil nil nil nil nil)
               ("thanks" "Thanks. Let me know if you have any questions or concerns" "(salutation)" nil nil nil nil nil)
               ("time" "`(current-time-string)`" "(current time)" nil nil nil nil nil))
             'nil)

(setq yas/indent-line nil)

;; Integrate Emacs with Stack Exchange http://stackoverflow.com/a/10386560/789593                                                       
(add-to-list 'auto-mode-alist '("\\(stack\\(exchange\\|overflow\\)\\|superuser\\|askubuntu\\)\\.com\\.[a-z0-9]+\\.txt" . markdown-mode))

;; face to be put on capitals of an identifier looked through glasses
(setq glasses-face 'bold)

;; string to be displayed as a visual separator in unreadable identifiers
(setq glasses-separator "")

;; I hate tabs!
;; let tabs indent 4 spaces
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq indent-line-function 'insert-tab)

(setq whitespace-action '(auto-cleanup)) (whitespace-mode) ;; automatically clean up bad whitespace

(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab)) ;; only show bad whitespace

(setq whitespace-style '(face trailing lines-tail) whitespace-line-column 80) 

;; handy too: ;; highlight long lines tails

(setq semantic-load-turn-useful-things-on t)

;; set unicode data file location. (used by what-cursor-position and describe-char)
(let ((x "~/git/.emacs.d/UnicodeData.txt"))
  (when (file-exists-p x)
    (setq describe-char-unicodedata-file x)))

(defun my-print-chars (&optional start end)
  (interactive "nstart: \nnend: ")
  (switch-to-buffer (get-buffer-create "*UNICODE*"))
  (erase-buffer)
  (let ( (i start) )
    (while (<= i end)
      (insert (format "%s: U+%04x, %s\n" (char-to-string i) i (get-char-code-property i 'name)))
      (setq i (1+ i))
      )))

(org-babel-load-file "~/git/.emacs.d/private.org")

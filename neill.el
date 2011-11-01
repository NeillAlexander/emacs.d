(server-start)

;; set up the color theme to use
;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-goodies-el/color-theme.el")
(require 'color-theme)
(color-theme-blackboard)

;; set font size to 10pt
;;(set-face-attribute 'default nil :height 90)

;; start maximized
(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)
(toggle-fullscreen)


;; auto complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-delay 0.5) ;; eclipse uses 500ms

;; configure auto complete to work in slime (who needs eclipse)
(add-to-list 'load-path "~/.emacs.d/ac-slime")
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

;; can switch to repl with C-cs r
(global-set-key "\C-cs" 'slime-selector)

;; use C-TAB and C-Shift-TAB to switch to next / previous window
(global-set-key [C-tab] 'other-window)
(global-set-key [C-S-tab] 
    (lambda ()
      (interactive)
      (other-window -1)))

;; set up paredit to enable automatically in slime repl
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))

;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))

(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

;; real auto-save - forces auto save mode
(require 'real-auto-save)
(add-hook 'text-mode-hook 'turn-on-real-auto-save)
(add-hook 'muse-mode-hook 'turn-on-real-auto-save)
(add-hook 'slime-mode-hook 'turn-on-real-auto-save) ;; for auto-save in Clojure
(add-hook 'emacs-list-mode-hook 'turn-on-real-auto-save) ;; for auto-save in elisp
(setq real-auto-save-interval 60) ;; in seconds

;; make sure slime doesn't barf when reading rtm etc
(setq slime-net-coding-system 'utf-8-unix)

(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)

(global-set-key "\C-z" nil)

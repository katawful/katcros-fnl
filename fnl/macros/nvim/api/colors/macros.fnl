;;; Macros for color management

;; Private macros
;; Macro -- shorthand for vim.cmd
(fn cmd [string]
  `(vim.cmd ,string))
;; Macro -- shorthand for tostring
(fn sym-tostring [x]
  `,(tostring x))

;; Macro -- set colorscheme
;; @scheme -- a string of the colorscheme desired
(fn col- [scheme]
  "Macro -- set colorscheme"
  (let [scheme (.. "colorscheme " scheme)]
   (cmd scheme)))

{
 :col- col-}


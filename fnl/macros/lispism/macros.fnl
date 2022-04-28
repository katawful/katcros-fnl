; convert to string)
(fn sym-tostring [x]
  `,(tostring x))

; plugin initialization
; for packer.nvim
(fn plugInit [...]
  `(do
     ((. (require :packer) :startup) (fn []
                                      (do
                                        ,...)))))

; i find "Plug" to be more semantically ideal
(fn Plug [plugin]
    `(use ,plugin))

; require configs
; lua options really, i find the table lookup syntax to be garbage
(fn opt- [tableOrigin lookupValue ...]
  (let [tableOrigin tableOrigin
        lookupValue lookupValue
        output [...]]
       `(do
          ((. (require ,tableOrigin) ,lookupValue)
           ,...))))

{
 :Plug Plug
 :plugInit plugInit
 :opt- opt-}


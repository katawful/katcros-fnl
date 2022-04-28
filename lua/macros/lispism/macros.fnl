;;; Macros to convert Lua constructs to something more Lisp-y


;; Macro -- table lookup
;; @origin -- table to search
;; @lookup -- lookup value
;; @... -- list to do on the lookupped value
(fn opt- [origin lookup ...]
  "Macro -- Lookup a value in a table, and do"
  (let [output [...]]
       `(do
          ((. (require ,origin) ,lookup)
           ,...))))

{
 :opt- opt-}


(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(import-macros option :katcros-fnl.macros.nvim.api.options.macros)

(describe "Set option macro:"
          (fn []
            (it "set-opt with no flag"
                (fn []
                  (assert.are.same "(tset vim.opt \"option\" \"Value\")"
                                   (macrodebug (option.set-opt option :Value)
                                               true))))
            (it "set-opt with flag"
                (fn []
                  (assert.are.same "(: (. vim.opt \"option\") \"append\" \"Value\")"
                                   (macrodebug (option.set-opt option :Value
                                                               :append)
                                               true))))))

(describe "Set local option macro:"
          (fn []
            (it "set-local-opt with no flag"
                (fn []
                  (assert.are.same "(tset vim.opt_local \"spell\" \"Value\")"
                                   (macrodebug (option.set-local-opt spell
                                                                     :Value)
                                               true))))
            (it "set-local-opt with flag"
                (fn []
                  (assert.are.same "(: (. vim.opt_local \"spell\") \"append\" \"Value\")"
                                   (macrodebug (option.set-local-opt spell
                                                                     :Value
                                                                     :append)
                                               true))))))

(describe "Set global option macro:"
          (fn []
            (it "set-global-opt with no flag"
                (fn []
                  (assert.are.same "(tset vim.opt_global \"mouse\" \"Value\")"
                                   (macrodebug (option.set-global-opt mouse
                                                                      :Value)
                                               true))))
            (it "set-global-opt with flag"
                (fn []
                  (assert.are.same "(: (. vim.opt_global \"mouse\") \"append\" \"Value\")"
                                   (macrodebug (option.set-global-opt mouse
                                                                      :Value
                                                                      :append)
                                               true))))))

(describe "Set multiple options macro:"
          (fn []
            (it "set-opts with no flags"
                (fn []
                  (assert.are.same "(do (tset vim.opt \"spell\" true) (do (tset vim.opt \"mouse\" \"nvi\")))"
                                   (macrodebug (option.set-opts {spell true
                                                                 mouse :nvi})
                                               true))))
            (it "set-opts with flags"
                (fn []
                  (assert.are.same "(do (: (. vim.opt \"spell\") \"append\" true) (do (: (. vim.opt \"mouse\") \"append\" \"nvi\")))"
                                   (macrodebug (option.set-opts {spell true
                                                                 mouse :nvi}
                                                                :append)
                                               true))))))

(describe "Set multiple local options macro:"
          (fn []
            (it "set-local-opts with no flags"
                (fn []
                  (assert.are.same "(do (tset vim.opt_local \"wrap\" true) (do (tset vim.opt_local \"spell\" true)))"
                                   (macrodebug (option.set-local-opts {spell true
                                                                       wrap true})
                                               true))))
            (it "set-local-opts with flags"
                (fn []
                  (assert.are.same "(do (: (. vim.opt_local \"wrap\") \"append\" true) (do (: (. vim.opt_local \"spell\") \"append\" true)))"
                                   (macrodebug (option.set-local-opts {spell true
                                                                       wrap true}
                                                                      :append)
                                               true))))))

(describe "Set multiple global options macro:"
          (fn []
            (it "set-global-opts with no flags"
                (fn []
                  (assert.are.same "(do (tset vim.opt_global \"mouse\" \"nvi\") (do (tset vim.opt_global \"background\" \"dark\")))"
                                   (macrodebug (option.set-global-opts {mouse :nvi
                                                                        background :dark})
                                               true))))
            (it "set-global-opts with flags"
                (fn []
                  (assert.are.same "(do (: (. vim.opt_global \"mouse\") \"append\" \"nvi\") (do (: (. vim.opt_global \"background\") \"append\" \"dark\")))"
                                   (macrodebug (option.set-global-opts {mouse :nvi
                                                                        background :dark}
                                                                       :append)
                                               true))))))

(describe "Automatically set option macro:"
          (fn []
            (it "set-opt-auto with global option and no flag"
                (fn []
                  (assert.are.same "(tset vim.opt_global \"mouse\" \"nvi\")"
                                   (macrodebug (option.set-opt-auto mouse :nvi)
                                               true))))
            (it "set-opt-auto with local option and no flag"
                (fn []
                  (assert.are.same "(tset vim.opt_local \"spell\" true)"
                                   (macrodebug (option.set-opt-auto spell true)
                                               true))))
            (it "set-opt-auto with global option and flag"
                (fn []
                  (assert.are.same "(: (. vim.opt_global \"mouse\") \"append\" \"nvi\")"
                                   (macrodebug (option.set-opt-auto mouse :nvi
                                                                    :append)
                                               true))))
            (it "set-opt-auto with local option and flag"
                (fn []
                  (assert.are.same "(: (. vim.opt_local \"spell\") \"append\" true)"
                                   (macrodebug (option.set-opt-auto spell true
                                                                    :append)
                                               true))))))

(describe "Automatically set multiple options macro:"
          (fn []
            (it "set-opts-auto with no flag"
                (fn []
                  (assert.are.same "(do (tset vim.opt_local \"spell\" true) (do (tset vim.opt_global \"mouse\" \"nvi\")))"
                                   (macrodebug (option.set-opts-auto {mouse :nvi
                                                                      spell true})
                                               true))))
            (it "set-opts-auto with flag"
                (fn []
                  (assert.are.same "(do (: (. vim.opt_local \"spell\") \"append\" true) (do (: (. vim.opt_global \"mouse\") \"append\" \"nvi\")))"
                                   (macrodebug (option.set-opts-auto {mouse :nvi
                                                                      spell true}
                                                                     :append)
                                               true))))))
(describe "Set vim variable macro:"
  (fn []

    (it "set-var with no scope indexing"
      (fn [] (assert.are.same
              "(tset (. vim \"g\") \"variable\" \"Value\")"
              (macrodebug (option.set-var :g variable "Value") true))))

    (it "set-var with scope indexing"
      (fn [] (assert.are.same
              "(tset (. (. vim \"b\") 1) \"variable\" \"Value\")"
              (macrodebug (option.set-var (. :b 1) variable "Value") true))))))

(describe "Set multiple vim variables macro:"
  (fn []

    (it "set-vars with no scope indexing"
      (fn [] (assert.are.same
              "(do (tset (. vim \"g\") \"variable_2\" true) (tset (. vim \"g\") \"variable_1\" \"Value\"))"
              (macrodebug (option.set-vars :g {:variable_1 "Value"
                                               :variable_2 true}) true))))

    (it "set-vars with scope indexing"
      (fn [] (assert.are.same
              "(do (tset (. (. vim \"b\") 1) \"variable_2\" true) (tset (. (. vim \"b\") 1) \"variable_1\" \"Value\"))"
              (macrodebug (option.set-vars (. :b 1) {:variable_1 "Value"
                                                     :variable_2 true}) true))))))

(describe "Get option or variable macro:"

  (fn []

    (it "get-opt"
      (fn [] (assert.are.same
              "(: (. vim.opt \"option\") \"get\")"
              (macrodebug (option.get-opt option) true))))
    
    (it "get-var with no scope indexing"
      (fn [] (assert.are.same
              "(. (. vim \"g\") \"variable\")"
              (macrodebug (option.get-var :g variable) true))))
    
    (it "get-var with scope indexing"
      (fn [] (assert.are.same
              "(. (. (. vim \"b\") 1) \"variable\")"
              (macrodebug (option.get-var (. :b 1) variable) true))))))

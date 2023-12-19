(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(import-macros command :katcros-fnl.macros.nvim.api.utils.macros)

(describe "Do Ex command macro:"
          (fn []
            (it "do-ex with no args"
                (fn []
                  (assert.are.same "(vim.cmd {:args {} :cmd \"function\" :output true})"
                                   (macrodebug (command.do-ex function) true))))
            (it "do-ex with switch arg"
                (fn []
                  (assert.are.same "(vim.cmd {:args [\"arg\"] :cmd \"function\" :output true})"
                                   (macrodebug (command.do-ex function :arg)
                                               true))))
            (it "do-ex with table arg"
                (fn []
                  (assert.are.same "(vim.cmd {:args [\"key=value\"] :cmd \"function\" :output true})"
                                   (macrodebug (command.do-ex function
                                                              {:key value})
                                               true))))
            (it "do-ex with table and switch arg"
                (fn []
                  (assert.are.same "(vim.cmd {:args [\"arg\" \"key=value\"] :cmd \"function\" :output true})"
                                   (macrodebug (command.do-ex function :arg
                                                              {:key value})
                                               true))))))

(describe "Do VimL 8 command macro:"
          (fn []
            (it "do-viml with no args"
                (fn []
                  (assert.are.same "((. vim.fn \"function\"))"
                                   (macrodebug (command.do-viml function) true))))
            (it "do-viml boolean returning function"
                (fn []
                  (assert.are.same "(do (let [result_2_auto ((. vim.fn \"empty\"))] (if (= result_2_auto 0) false true)))"
                                   (macrodebug (command.do-viml empty) true))))
            (it "do-viml with arg"
                (fn []
                  (assert.are.same "((. vim.fn \"expand\") \"%\" vim.v.true)"
                                   (macrodebug (command.do-viml expand "%"
                                                                vim.v.true)
                                               true))))
            (it "do-viml boolean returning function with arg"
                (fn []
                  (assert.are.same "(do (let [result_2_auto ((. vim.fn \"has\") \"arg\")] (if (= result_2_auto 0) false true)))"
                                   (macrodebug (command.do-viml has :arg) true))))))

(describe "Create user-command macro:"
          (fn []
            (it "cre-command with name and callback"
                (fn []
                  (assert.are.same "(vim.api.nvim_create_user_command \"UserCommand\" (fn [] callback) {})"
                                   (macrodebug (command.cre-command :UserCommand
                                                                    (fn []
                                                                      callback))
                                               true))))
            (it "cre-command with name, callback, and description"
                (fn []
                  (assert.are.same "(vim.api.nvim_create_user_command \"UserCommand\" (fn [] callback) {:desc \"Description\"})"
                                   (macrodebug (command.cre-command :UserCommand
                                                                    (fn []
                                                                      callback)
                                                                    :Description)
                                               true))))
            (it "cre-command with name, callback, description, and opts table"
                (fn []
                  (assert.are.same "(vim.api.nvim_create_user_command \"UserCommand\" (fn [] callback) {:bang true :desc \"Description\"})"
                                   (macrodebug (command.cre-command :UserCommand
                                                                    (fn []
                                                                      callback)
                                                                    :Description
                                                                    {:bang true})
                                               true))))
            (it "cre-command with name, callback, and opts table"
                (fn []
                  (assert.are.same "(vim.api.nvim_create_user_command \"UserCommand\" (fn [] callback) {:bang true})"
                                   (macrodebug (command.cre-command :UserCommand
                                                                    (fn []
                                                                      callback)
                                                                    {:bang true})
                                               true))))
            (it "cre-command with name, callback, and opts table with buffer option"
                (fn []
                  (assert.are.same "(vim.api.nvim_buf_create_user_command 0 \"UserCommand\" (fn [] callback) {:bang true})"
                                   (macrodebug (command.cre-command :UserCommand
                                                                    (fn []
                                                                      callback)
                                                                    {:bang true
                                                                     :buffer 0})
                                               true))))
            (it "cre-command with name, callback, description, and opts table with buffer option"
                (fn []
                  (assert.are.same "(vim.api.nvim_buf_create_user_command 0 \"UserCommand\" (fn [] callback) {:bang true :desc \"Description\"})"
                                   (macrodebug (command.cre-command :UserCommand
                                                                    (fn []
                                                                      callback)
                                                                    :Description
                                                                    {:bang true
                                                                     :buffer 0})
                                               true))))))

(describe "Define user-command macro:"
          (fn []
            (it :def-command
                (fn []
                  (assert.are.same "(do (vim.api.nvim_create_user_command \"UserCommand\" (fn [] callback) {}) \"UserCommand\")"
                                   (macrodebug (command.def-command :UserCommand
                                                 (fn [] callback))
                                               true))))))

(describe "Delete user-command macro:"
          (fn []
            (it "del-command with just name"
                (fn []
                  (assert.are.same "(vim.api.nvim_del_user_command \"UserCommand\")"
                                   (macrodebug (command.del-command :UserCommand)
                                               true))))
            (it "del-command with name and boolean buffer option"
                (fn []
                  (assert.are.same "(vim.api.nvim_buf_del_user_command \"UserCommand\" 0)"
                                   (macrodebug (command.del-command :UserCommand
                                                                    true)
                                               true))))
            (it "del-command with name and int buffer option"
                (fn []
                  (assert.are.same "(vim.api.nvim_buf_del_user_command \"UserCommand\" 1)"
                                   (macrodebug (command.del-command :UserCommand
                                                                    1)
                                               true))))))

(describe "Do user-command macro:"
          (fn []
            (it "do-command with no args"
                (fn []
                  (assert.are.same "(do (vim.cmd {:args {} :cmd \"function\" :output true}))"
                                   (macrodebug (command.do-command function)
                                               true))))
            (it "do-command with switch arg"
                (fn []
                  (assert.are.same "(do (vim.cmd {:args [\"arg\"] :cmd \"function\" :output true}))"
                                   (macrodebug (command.do-command function
                                                                   :arg)
                                               true))))
            (it "do-command with table arg"
                (fn []
                  (assert.are.same "(do (vim.cmd {:args [\"key=value\"] :cmd \"function\" :output true}))"
                                   (macrodebug (command.do-command function
                                                                   {:key value})
                                               true))))
            (it "do-command with table and switch arg"
                (fn []
                  (assert.are.same "(do (vim.cmd {:args [\"arg\" \"key=value\"] :cmd \"function\" :output true}))"
                                   (macrodebug (command.do-command function
                                                                   :arg
                                                                   {:key value})
                                               true))))))

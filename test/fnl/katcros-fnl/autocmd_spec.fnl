(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(import-macros auto :katcros-fnl.macros.nvim.api.autocommands.macros)

(describe "Clear autocommand macro:"
          (fn []
            (it "cle-auc! is empty"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {})"
                                   (macrodebug (auto.cle-auc! {}) true))))
            (it "cle-auc! with one option"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:buffer 0})"
                                   (macrodebug (auto.cle-auc! {:buffer 0}) true))))
            (it "cle-auc! with multiple options"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:buffer 0 :event \"Test\"})"
                                   (macrodebug (auto.cle-auc! {:buffer 0
                                                               :event :Test})
                                               true))))
            (it "cle-auc<-event! with one option"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:event \"Event1\"})"
                                   (macrodebug (auto.cle-auc<-event! :Event1)
                                               true))))
            (it "cle-auc<-event! with multiple options"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:event [\"Event1\" \"Event2\"]})"
                                   (macrodebug (auto.cle-auc<-event! [:Event1
                                                                      :Event2])
                                               true))))
            (it "cle-auc<-pattern! with one option"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:pattern \"Pattern\"})"
                                   (macrodebug (auto.cle-auc<-pattern! :Pattern)
                                               true))))
            (it "cle-auc<-pattern! with multiple options"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:pattern [\"Pattern1\" \"Pattern2\"]})"
                                   (macrodebug (auto.cle-auc<-pattern! [:Pattern1
                                                                        :Pattern2])
                                               true))))
            (it :cle-auc<-buffer!
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:buffer 0})"
                                   (macrodebug (auto.cle-auc<-buffer! 0) true))))
            (it "cle-auc<-group! with string group"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:group \"Group\"})"
                                   (macrodebug (auto.cle-auc<-group! :Group)
                                               true))))
            (it "cle-auc<-group! with int group"
                (fn []
                  (assert.are.same "(vim.api.nvim_clear_autocmds {:group 0})"
                                   (macrodebug (auto.cle-auc<-group! 0) true))))))

(describe "Delete autocommand group macro:"
          (fn []
            (it "del-aug! with int augroup"
                (fn []
                  (assert.are.same "(vim.api.nvim_del_augroup_by_id 0)"
                                   (macrodebug (auto.del-aug! 0) true))))
            (it "del-aug! with string augroup"
                (fn []
                  (assert.are.same "(vim.api.nvim_del_augroup_by_name \"Augroup\")"
                                   (macrodebug (auto.del-aug! :Augroup) true))))))

(describe "Get autocommand macro:"
          (fn []
            (it "get-auc with table"
                (fn []
                  (assert.are.same "(vim.api.nvim_get_autocmds {:group \"Group\"})"
                                   (macrodebug (auto.get-auc {:group :Group})
                                               true))))
            (it "get-auc<-event with one option"
                (fn []
                  (assert.are.same "(vim.api.nvim_get_autocmds {:event \"Event\"})"
                                   (macrodebug (auto.get-auc<-event :Event)
                                               true))))
            (it "get-auc<-event with multiple option"
                (fn []
                  (assert.are.same "(vim.api.nvim_get_autocmds {:event [\"Event1\" \"Event2\"]})"
                                   (macrodebug (auto.get-auc<-event [:Event1
                                                                     :Event2])
                                               true))))
            (it "get-auc<-pattern with one option"
                (fn []
                  (assert.are.same "(vim.api.nvim_get_autocmds {:pattern \"Pattern\"})"
                                   (macrodebug (auto.get-auc<-pattern :Pattern)
                                               true))))
            (it "get-auc<-pattern with multiple option"
                (fn []
                  (assert.are.same "(vim.api.nvim_get_autocmds {:pattern [\"Pattern1\" \"Pattern2\"]})"
                                   (macrodebug (auto.get-auc<-pattern [:Pattern1
                                                                       :Pattern2])
                                               true))))
            (it "get-auc<-group with string augroup"
                (fn []
                  (assert.are.same "(vim.api.nvim_get_autocmds {:group \"Group\"})"
                                   (macrodebug (auto.get-auc<-group :Group)
                                               true))))
            (it "get-auc<-group with int augroup"
                (fn []
                  (assert.are.same "(vim.api.nvim_get_autocmds {:group 0})"
                                   (macrodebug (auto.get-auc<-group 0) true))))))

(describe "Do autocommand macro:"
          (fn []
            (it "do-auc with string event and no opts table"
                (fn []
                  (assert.are.same "(vim.api.nvim_exec_autocmds \"Event\" {})"
                                   (macrodebug (auto.do-auc :Event) true))))
            (it "do-auc with string event and opts table"
                (fn []
                  (assert.are.same "(vim.api.nvim_exec_autocmds \"Event\" {:group \"Group\"})"
                                   (macrodebug (auto.do-auc :Event
                                                            {:group :Group})
                                               true))))
            (it "do-auc with table event and no opts table"
                (fn []
                  (assert.are.same "(vim.api.nvim_exec_autocmds [\"Event1\" \"Event2\"] {})"
                                   (macrodebug (auto.do-auc [:Event1 :Event2])
                                               true))))
            (it "do-auc with table event and opts table"
                (fn []
                  (assert.are.same "(vim.api.nvim_exec_autocmds [\"Event1\" \"Event2\"] {:group \"Group\"})"
                                   (macrodebug (auto.do-auc [:Event1 :Event2]
                                                            {:group :Group})
                                               true))))))

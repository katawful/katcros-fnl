-- [nfnl] Compiled from test/fnl/katcros-fnl/macros/nvim/api/autocommands/macros-spec.fnl by https://github.com/Olical/nfnl, do not edit.
local core = require("nfnl.core")
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local function _2_()
  local function _3_()
    return assert.are.same(core["pr-str"](vim.api.nvim_clear_autocmds({})), core["pr-str"](vim.api.nvim_clear_autocmds({})))
  end
  return it("empty cle-auc!", _3_)
end
return describe("clear autocommands", _2_)

-- [nfnl] Compiled from test/fnl/katcros-fnl/autocmd_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local function _2_()
  local function _3_()
    local function _4_()
      return "(vim.api.nvim_clear_autocmds {})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {})", _4_())
  end
  it("cle-auc! is empty", _3_)
  local function _5_()
    local function _6_()
      return "(vim.api.nvim_clear_autocmds {:buffer 0})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:buffer 0})", _6_())
  end
  it("cle-auc! with one option", _5_)
  local function _7_()
    local function _8_()
      return "(vim.api.nvim_clear_autocmds {:buffer 0 :event \"Test\"})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:buffer 0 :event \"Test\"})", _8_())
  end
  it("cle-auc! with multiple options", _7_)
  local function _9_()
    local function _10_()
      return "(vim.api.nvim_clear_autocmds {:event \"Event1\"})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:event \"Event1\"})", _10_())
  end
  it("cle-auc<-event! with one option", _9_)
  local function _11_()
    local function _12_()
      return "(vim.api.nvim_clear_autocmds {:event [\"Event1\" \"Event2\"]})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:event [\"Event1\" \"Event2\"]})", _12_())
  end
  it("cle-auc<-event! with multiple options", _11_)
  local function _13_()
    local function _14_()
      return "(vim.api.nvim_clear_autocmds {:pattern \"Pattern\"})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:pattern \"Pattern\"})", _14_())
  end
  it("cle-auc<-pattern! with one option", _13_)
  local function _15_()
    local function _16_()
      return "(vim.api.nvim_clear_autocmds {:pattern [\"Pattern1\" \"Pattern2\"]})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:pattern [\"Pattern1\" \"Pattern2\"]})", _16_())
  end
  it("cle-auc<-pattern! with multiple options", _15_)
  local function _17_()
    local function _18_()
      return "(vim.api.nvim_clear_autocmds {:buffer 0})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:buffer 0})", _18_())
  end
  it("cle-auc<-buffer!", _17_)
  local function _19_()
    local function _20_()
      return "(vim.api.nvim_clear_autocmds {:group \"Group\"})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:group \"Group\"})", _20_())
  end
  it("cle-auc<-group! with string group", _19_)
  local function _21_()
    local function _22_()
      return "(vim.api.nvim_clear_autocmds {:group 0})"
    end
    return assert.are.same("(vim.api.nvim_clear_autocmds {:group 0})", _22_())
  end
  return it("cle-auc<-group! with int group", _21_)
end
describe("Clear autocommand macro:", _2_)
local function _23_()
  local function _24_()
    local function _25_()
      return "(vim.api.nvim_del_augroup_by_id 0)"
    end
    return assert.are.same("(vim.api.nvim_del_augroup_by_id 0)", _25_())
  end
  it("del-aug! with int augroup", _24_)
  local function _26_()
    local function _27_()
      return "(vim.api.nvim_del_augroup_by_name \"Augroup\")"
    end
    return assert.are.same("(vim.api.nvim_del_augroup_by_name \"Augroup\")", _27_())
  end
  return it("del-aug! with string augroup", _26_)
end
describe("Delete autocommand group macro:", _23_)
local function _28_()
  local function _29_()
    local function _30_()
      return "(vim.api.nvim_get_autocmds {:group \"Group\"})"
    end
    return assert.are.same("(vim.api.nvim_get_autocmds {:group \"Group\"})", _30_())
  end
  it("get-auc with table", _29_)
  local function _31_()
    local function _32_()
      return "(vim.api.nvim_get_autocmds {:event \"Event\"})"
    end
    return assert.are.same("(vim.api.nvim_get_autocmds {:event \"Event\"})", _32_())
  end
  it("get-auc<-event with one option", _31_)
  local function _33_()
    local function _34_()
      return "(vim.api.nvim_get_autocmds {:event [\"Event1\" \"Event2\"]})"
    end
    return assert.are.same("(vim.api.nvim_get_autocmds {:event [\"Event1\" \"Event2\"]})", _34_())
  end
  it("get-auc<-event with multiple option", _33_)
  local function _35_()
    local function _36_()
      return "(vim.api.nvim_get_autocmds {:pattern \"Pattern\"})"
    end
    return assert.are.same("(vim.api.nvim_get_autocmds {:pattern \"Pattern\"})", _36_())
  end
  it("get-auc<-pattern with one option", _35_)
  local function _37_()
    local function _38_()
      return "(vim.api.nvim_get_autocmds {:pattern [\"Pattern1\" \"Pattern2\"]})"
    end
    return assert.are.same("(vim.api.nvim_get_autocmds {:pattern [\"Pattern1\" \"Pattern2\"]})", _38_())
  end
  it("get-auc<-pattern with multiple option", _37_)
  local function _39_()
    local function _40_()
      return "(vim.api.nvim_get_autocmds {:group \"Group\"})"
    end
    return assert.are.same("(vim.api.nvim_get_autocmds {:group \"Group\"})", _40_())
  end
  it("get-auc<-group with string augroup", _39_)
  local function _41_()
    local function _42_()
      return "(vim.api.nvim_get_autocmds {:group 0})"
    end
    return assert.are.same("(vim.api.nvim_get_autocmds {:group 0})", _42_())
  end
  return it("get-auc<-group with int augroup", _41_)
end
describe("Get autocommand macro:", _28_)
local function _43_()
  local function _44_()
    local function _45_()
      return "(vim.api.nvim_exec_autocmds \"Event\" {})"
    end
    return assert.are.same("(vim.api.nvim_exec_autocmds \"Event\" {})", _45_())
  end
  it("do-auc with string event and no opts table", _44_)
  local function _46_()
    local function _47_()
      return "(vim.api.nvim_exec_autocmds \"Event\" {:group \"Group\"})"
    end
    return assert.are.same("(vim.api.nvim_exec_autocmds \"Event\" {:group \"Group\"})", _47_())
  end
  it("do-auc with string event and opts table", _46_)
  local function _48_()
    local function _49_()
      return "(vim.api.nvim_exec_autocmds [\"Event1\" \"Event2\"] {})"
    end
    return assert.are.same("(vim.api.nvim_exec_autocmds [\"Event1\" \"Event2\"] {})", _49_())
  end
  it("do-auc with table event and no opts table", _48_)
  local function _50_()
    local function _51_()
      return "(vim.api.nvim_exec_autocmds [\"Event1\" \"Event2\"] {:group \"Group\"})"
    end
    return assert.are.same("(vim.api.nvim_exec_autocmds [\"Event1\" \"Event2\"] {:group \"Group\"})", _51_())
  end
  return it("do-auc with table event and opts table", _50_)
end
return describe("Do autocommand macro:", _43_)

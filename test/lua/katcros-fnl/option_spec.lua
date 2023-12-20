-- [nfnl] Compiled from test/fnl/katcros-fnl/option_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local function _2_()
  local function _3_()
    local function _4_()
      return "(tset vim.opt \"option\" \"Value\")"
    end
    return assert.are.same("(tset vim.opt \"option\" \"Value\")", _4_())
  end
  it("set-opt with no flag", _3_)
  local function _5_()
    local function _6_()
      return "(: (. vim.opt \"option\") \"append\" \"Value\")"
    end
    return assert.are.same("(: (. vim.opt \"option\") \"append\" \"Value\")", _6_())
  end
  return it("set-opt with flag", _5_)
end
describe("Set option macro:", _2_)
local function _7_()
  local function _8_()
    local function _9_()
      return "(tset vim.opt_local \"spell\" \"Value\")"
    end
    return assert.are.same("(tset vim.opt_local \"spell\" \"Value\")", _9_())
  end
  it("set-local-opt with no flag", _8_)
  local function _10_()
    local function _11_()
      return "(: (. vim.opt_local \"spell\") \"append\" \"Value\")"
    end
    return assert.are.same("(: (. vim.opt_local \"spell\") \"append\" \"Value\")", _11_())
  end
  return it("set-local-opt with flag", _10_)
end
describe("Set local option macro:", _7_)
local function _12_()
  local function _13_()
    local function _14_()
      return "(tset vim.opt_global \"mouse\" \"Value\")"
    end
    return assert.are.same("(tset vim.opt_global \"mouse\" \"Value\")", _14_())
  end
  it("set-global-opt with no flag", _13_)
  local function _15_()
    local function _16_()
      return "(: (. vim.opt_global \"mouse\") \"append\" \"Value\")"
    end
    return assert.are.same("(: (. vim.opt_global \"mouse\") \"append\" \"Value\")", _16_())
  end
  return it("set-global-opt with flag", _15_)
end
describe("Set global option macro:", _12_)
local function _17_()
  local function _18_()
    local function _19_()
      return "(do (tset vim.opt \"spell\" true) (do (tset vim.opt \"mouse\" \"nvi\")))"
    end
    return assert.are.same("(do (tset vim.opt \"spell\" true) (do (tset vim.opt \"mouse\" \"nvi\")))", _19_())
  end
  it("set-opts with no flags", _18_)
  local function _20_()
    local function _21_()
      return "(do (: (. vim.opt \"spell\") \"append\" true) (do (: (. vim.opt \"mouse\") \"append\" \"nvi\")))"
    end
    return assert.are.same("(do (: (. vim.opt \"spell\") \"append\" true) (do (: (. vim.opt \"mouse\") \"append\" \"nvi\")))", _21_())
  end
  return it("set-opts with flags", _20_)
end
describe("Set multiple options macro:", _17_)
local function _22_()
  local function _23_()
    local function _24_()
      return "(do (tset vim.opt_local \"wrap\" true) (do (tset vim.opt_local \"spell\" true)))"
    end
    return assert.are.same("(do (tset vim.opt_local \"wrap\" true) (do (tset vim.opt_local \"spell\" true)))", _24_())
  end
  it("set-local-opts with no flags", _23_)
  local function _25_()
    local function _26_()
      return "(do (: (. vim.opt_local \"wrap\") \"append\" true) (do (: (. vim.opt_local \"spell\") \"append\" true)))"
    end
    return assert.are.same("(do (: (. vim.opt_local \"wrap\") \"append\" true) (do (: (. vim.opt_local \"spell\") \"append\" true)))", _26_())
  end
  return it("set-local-opts with flags", _25_)
end
describe("Set multiple local options macro:", _22_)
local function _27_()
  local function _28_()
    local function _29_()
      return "(do (tset vim.opt_global \"mouse\" \"nvi\") (do (tset vim.opt_global \"background\" \"dark\")))"
    end
    return assert.are.same("(do (tset vim.opt_global \"mouse\" \"nvi\") (do (tset vim.opt_global \"background\" \"dark\")))", _29_())
  end
  it("set-global-opts with no flags", _28_)
  local function _30_()
    local function _31_()
      return "(do (: (. vim.opt_global \"mouse\") \"append\" \"nvi\") (do (: (. vim.opt_global \"background\") \"append\" \"dark\")))"
    end
    return assert.are.same("(do (: (. vim.opt_global \"mouse\") \"append\" \"nvi\") (do (: (. vim.opt_global \"background\") \"append\" \"dark\")))", _31_())
  end
  return it("set-global-opts with flags", _30_)
end
describe("Set multiple global options macro:", _27_)
local function _32_()
  local function _33_()
    local function _34_()
      return "(tset vim.opt_global \"mouse\" \"nvi\")"
    end
    return assert.are.same("(tset vim.opt_global \"mouse\" \"nvi\")", _34_())
  end
  it("set-opt-auto with global option and no flag", _33_)
  local function _35_()
    local function _36_()
      return "(tset vim.opt_local \"spell\" true)"
    end
    return assert.are.same("(tset vim.opt_local \"spell\" true)", _36_())
  end
  it("set-opt-auto with local option and no flag", _35_)
  local function _37_()
    local function _38_()
      return "(: (. vim.opt_global \"mouse\") \"append\" \"nvi\")"
    end
    return assert.are.same("(: (. vim.opt_global \"mouse\") \"append\" \"nvi\")", _38_())
  end
  it("set-opt-auto with global option and flag", _37_)
  local function _39_()
    local function _40_()
      return "(: (. vim.opt_local \"spell\") \"append\" true)"
    end
    return assert.are.same("(: (. vim.opt_local \"spell\") \"append\" true)", _40_())
  end
  return it("set-opt-auto with local option and flag", _39_)
end
describe("Automatically set option macro:", _32_)
local function _41_()
  local function _42_()
    local function _43_()
      return "(do (tset vim.opt_local \"spell\" true) (do (tset vim.opt_global \"mouse\" \"nvi\")))"
    end
    return assert.are.same("(do (tset vim.opt_local \"spell\" true) (do (tset vim.opt_global \"mouse\" \"nvi\")))", _43_())
  end
  it("set-opts-auto with no flag", _42_)
  local function _44_()
    local function _45_()
      return "(do (: (. vim.opt_local \"spell\") \"append\" true) (do (: (. vim.opt_global \"mouse\") \"append\" \"nvi\")))"
    end
    return assert.are.same("(do (: (. vim.opt_local \"spell\") \"append\" true) (do (: (. vim.opt_global \"mouse\") \"append\" \"nvi\")))", _45_())
  end
  return it("set-opts-auto with flag", _44_)
end
describe("Automatically set multiple options macro:", _41_)
local function _46_()
  local function _47_()
    local function _48_()
      return "(tset (. vim \"g\") \"variable\" \"Value\")"
    end
    return assert.are.same("(tset (. vim \"g\") \"variable\" \"Value\")", _48_())
  end
  it("set-var with no scope indexing", _47_)
  local function _49_()
    local function _50_()
      return "(tset (. (. vim \"b\") 1) \"variable\" \"Value\")"
    end
    return assert.are.same("(tset (. (. vim \"b\") 1) \"variable\" \"Value\")", _50_())
  end
  return it("set-var with scope indexing", _49_)
end
describe("Set vim variable macro:", _46_)
local function _51_()
  local function _52_()
    local function _53_()
      return "(do (tset (. vim \"g\") \"variable_2\" true) (tset (. vim \"g\") \"variable_1\" \"Value\"))"
    end
    return assert.are.same("(do (tset (. vim \"g\") \"variable_2\" true) (tset (. vim \"g\") \"variable_1\" \"Value\"))", _53_())
  end
  it("set-vars with no scope indexing", _52_)
  local function _54_()
    local function _55_()
      return "(do (tset (. (. vim \"b\") 1) \"variable_2\" true) (tset (. (. vim \"b\") 1) \"variable_1\" \"Value\"))"
    end
    return assert.are.same("(do (tset (. (. vim \"b\") 1) \"variable_2\" true) (tset (. (. vim \"b\") 1) \"variable_1\" \"Value\"))", _55_())
  end
  return it("set-vars with scope indexing", _54_)
end
describe("Set multiple vim variables macro:", _51_)
local function _56_()
  local function _57_()
    local function _58_()
      return "(: (. vim.opt \"option\") \"get\")"
    end
    return assert.are.same("(: (. vim.opt \"option\") \"get\")", _58_())
  end
  it("get-opt", _57_)
  local function _59_()
    local function _60_()
      return "(. (. vim \"g\") \"variable\")"
    end
    return assert.are.same("(. (. vim \"g\") \"variable\")", _60_())
  end
  it("get-var with no scope indexing", _59_)
  local function _61_()
    local function _62_()
      return "(. (. (. vim \"b\") 1) \"variable\")"
    end
    return assert.are.same("(. (. (. vim \"b\") 1) \"variable\")", _62_())
  end
  return it("get-var with scope indexing", _61_)
end
return describe("Get option or variable macro:", _56_)

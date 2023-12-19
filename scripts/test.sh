#!/usr/bin/env bash

XDG_CONFIG_HOME=$(pwd)/.test-config
export XDG_CONFIG_HOME

nvim --headless -c 'edit .nfnl.fnl' -c trust -c qa
nvim --headless -c 'PlenaryBustedDirectory test/lua'

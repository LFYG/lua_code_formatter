#!/bin/bash

in_file=$1
out_file=$2

lua_call="
do
  require('lcf.workshop.base')
  local run = request('lcf.lua_reformat')
  run('$in_file', '$out_file')
end
"

echo $lua_call | lua

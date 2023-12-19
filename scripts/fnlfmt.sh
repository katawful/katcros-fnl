#!/bin/bash

for i in $(find 'fnl/katcros-fnl/' -name "*.fnl"); do
  fnlfmt --fix "$i"
done;
for i in $(find 'test/fnl/katcros-fnl/' -name "*.fnl"); do
  fnlfmt --fix "$i"
done;
echo "Done formatting with fnlfmt"

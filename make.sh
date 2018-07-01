#!/bin/sh

set -e 

./clean.sh

yosys -q -p "synth_ice40 -blif main.blif" main.sv
arachne-pnr -d 8k -P tq144:4k -p main.pcf main.blif -o main.asc
icetime -c 100 main.asc
icepack main.asc main.bin
stty -F /dev/ttyACM0 raw
cat main.bin > /dev/ttyACM0


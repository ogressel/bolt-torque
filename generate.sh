#!/bin/bash
#
# ---=== TorquePro dashboard generator for Bolt EV / Opel Ampera-e
#

id0=0
x0=3
y0=72

# --- battery cell voltage indicators

for id in $(seq 0 95); do

    num=$(printf "%02d" $((id+1)))
    pid=$((id+2244993))

    # --- screen coordinates

    xcoord=$(( x0 + 210*$(( (id-id0)%5 )) ))
    ycoord=$(( y0 + 210*$(( (id-id0)/5 )) ))

    # --- jump to new screen

    if [[ $((id%32)) == 31 ]]; then
        x0=$((x0+5*216))
        id0=$((id0+32))
    fi

    # --- write .dash file

    cat template-cell-voltage.dash |\
        sed "s/{ID}/$id/g" |\
        sed "s/{NUM}/$num/g" |\
        sed "s/{PID}/$pid/g" |\
        sed "s/{XCOORD}/$xcoord/g" |\
        sed "s/{YCOORD}/$ycoord/g"

done

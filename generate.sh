#!/bin/bash
#
# ---=== TorquePro dashboard generator for Bolt EV / Opel Ampera-e
#

nid=0

xdisp=1080
ydisp=1920

# --- various temperature sensors

x0=$((12-xdisp))
y0=72

cid=0

for id in $(seq 0 5); do

    cid=$((cid+1))

    num=$(printf "%01d" $((id+1)))
    pid=$((id+2244823))

    # --- screen coordinates

    xcoord=$(( x0 + 216*$(( id%2 )) ))
    ycoord=$(( y0 + 216*$(( id/2 )) ))

    # --- write .dash file

    cat template-sect-temperature.dash |\
        sed "s/{ID}/$((id+nid))/g" |\
        sed "s/{NUM}/$num/g" |\
        sed "s/{PID}/$pid/g" |\
        sed "s/{XCOORD}/$xcoord/g" |\
        sed "s/{YCOORD}/$ycoord/g"

done

nid=$((nid+cid))

# --- battery cell voltage indicators

x0=3
y0=72

id0=0

cid=0

for id in $(seq 0 95); do

    cid=$((cid+1))

    num=$(printf "%02d" $((id+1)))
    pid=$((id+2244993))

    # --- screen coordinates

    xcoord=$(( x0 + 210*$(( (id-id0)%5 )) ))
    ycoord=$(( y0 + 210*$(( (id-id0)/5 )) ))

    # --- jump to new screen

    if [[ $((id%32)) == 31 ]]; then
        x0=$((x0+xdisp))
        id0=$((id0+32))
    fi

    # --- write .dash file

    cat template-cell-voltage.dash |\
        sed "s/{ID}/$((id+nid))/g" |\
        sed "s/{NUM}/$num/g" |\
        sed "s/{PID}/$pid/g" |\
        sed "s/{XCOORD}/$xcoord/g" |\
        sed "s/{YCOORD}/$ycoord/g"

done

nid=$((nid+cid))

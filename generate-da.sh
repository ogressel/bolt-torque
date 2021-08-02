#!/bin/bash
#
# ---=== TorquePro dashboard generator for Bolt EV / Ampera-e ===---
#

# --- screen dimensions

xdisp=1080
ydisp=1920

# ---  for generating unique IDs

nid=0

# ---=== AC+DC VOLTAGE/CURRENT/POWER INDICATORS ===---

x0=$(( -2*xdisp + xdisp/2 ))
y0=96

pids=( 2245483 2245484 15540910 2245480 2245481 15672635 )

lbls=( "DC Volts" "DC Amps" "DC Power"
       "AC Volts" "AC Amps" "AC Power" )

upids=( "\!Charger HV Voltage" "\!Charger HV Current" "\!Charger HV Power"
        "*Charger AC Voltage"  "*Charger AC Current"  "*Charger AC Power" )

maxvs=( 500.0 200.0 60.0
        500.0 40.0 8.0 )

units=( "V", "A", "kW" )

cid=0

for id in $(seq 0 5); do

    cid=$((cid+1))

    # --- lookup labels

    pid=${pids[$id]}
    lbl=${lbls[$id]}
    upid=${upids[$id]}
    maxv=${maxvs[$id]}
    unit=${units[$id%3]}

    # --- screen coordinates

    xcoord=$(( x0 + 448*$(( id/3-1)) ))
    ycoord=$(( y0 + 448*$(( id%3  )) ))

    # --- write .dash file

    cat template-power.dash |\
        sed "s/{ID}/$((id+nid))/g" |\
        sed "s/{LBL}/$lbl/g" |\
        sed "s/{USRPID}/$upid/g" |\
        sed "s/{PID}/$pid/g" |\
        sed "s/{MAXV}/$maxv/g" |\
        sed "s/{UNIT}/$unit/g" |\
        sed "s/{XCOORD}/$xcoord/g" |\
        sed "s/{YCOORD}/$ycoord/g"

done

nid=$((nid+cid))

# ---=== VARIOUS TEMPERATURE SENSORS ===---

x0=$((24-xdisp))
y0=96

pids=( 326     2261022 2261023
       2244823 2244824 2244825
       2244826 2244827 2244828
       2245455 2245028 )

lbls=( "Air Temp 0" "Air Temp 1" "Air Temp 2"
       "Batt Sec 1" "Batt Sec 2" "Batt Sec 3"
       "Batt Sec 4" "Batt Sec 5" "Batt Sec 6"
       "Batt Temp"  "Coolant Temp" )

upids=( "\\\\!Air Temp 0" "*Air Temp 1" "*Air Temp 2"
        "*BECM Battery Section 1 Temp" "*BECM Battery Section 2 Temp"
        "*BECM Battery Section 3 Temp" "*BECM Battery Section 4 Temp"
        "*BECM Battery Section 5 Temp" "*BECM Battery Section 6 Temp"
        "\\\\!Batt Temp" "*BECM Battery Coolant Temp ?" )

cid=0

for id in $(seq 0 10); do

    cid=$((cid+1))

    # --- lookup labels

    pid=${pids[$id]}
    lbl=${lbls[$id]}
    upid=${upids[$id]}

    # --- screen coordinates

    xcoord=$(( x0 + 224*$(( id%3 )) ))
    ycoord=$(( y0 + 224*$(( id/3 )) ))

    # --- write .dash file

    cat template-temperature.dash |\
        sed "s/{ID}/$((id+nid))/g" |\
        sed "s/{LBL}/$lbl/g" |\
        sed "s/{USRPID}/$upid/g" |\
        sed "s/{PID}/$pid/g" |\
        sed "s/{XCOORD}/$xcoord/g" |\
        sed "s/{YCOORD}/$ycoord/g"

done

nid=$((nid+cid))

# ---=== BATTERY HEATER AND COOLANT PUMP ===---

templ=( "heater" "pump" )

cid=0

for id in $(seq 0 1); do

    cid=$((cid+1))

    # --- screen coordinates

    xcoord=$(( x0 + 504 ))
    ycoord=$(( y0 + 672 + 448*id ))

    # --- write .dash file

    cat template-${templ[$id]}.dash |\
        sed "s/{ID}/$((id+nid))/g" |\
        sed "s/{XCOORD}/$xcoord/g" |\
        sed "s/{YCOORD}/$ycoord/g"

done

nid=$((nid+cid))

# ---=== BATTERY CELL VOLTAGE INDICATORS ===---

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

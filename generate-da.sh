#!/bin/bash
#
# ---=== TorquePro dashboard generator for Bolt EV / Ampera-e ===---
#

# --- print usage info

if [[ "$#" -ne 1 ]]; then
    echo "usage: $0 {--original|--updated}"
    exit -1
fi

# --- parse command-line parameters

while [[ -n "$1" ]]; do
    case "$1" in

        "--original")
            spec="original"
            shift
            ;;

        "--updated")
            spec="updated"
            shift
            ;;

        *)
            echo "$0: unknown paramter \`$1' --> exiting."
            exit -1
    esac
    shift
done

# --- screen dimensions

xdisp=1080  # enable for
ydisp=2400  # 20:9 screen ratio

# xdisp=1080  # enable for
# ydisp=1920  # 16:9 screen ratio

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

if [[ $spec == "updated" ]]; then  # account for name changes
    upids[0]=${upids[0]/!/*}
    upids=("${upids[@]/Charger/Charger -}")
fi

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

upids=( $(cut -d ',' -f1 "pidlist-temperature-$spec.csv" | sed 's/ /_/g') )
lbls=( $(cut -d ',' -f2 "pidlist-temperature-$spec.csv" | sed 's/ /_/g') )
pids=( $(cut -d ',' -f3 "pidlist-temperature-$spec.csv") )

npids=${#pids[@]}

cid=0

for ((id=0; id<npids; id++)); do

    cid=$((cid+1))

    # --- lookup labels

    pid=${pids[$id]};         pid=$((16#${pid}))  # hex --> dec
    lbl=${lbls[$id]//_/ }
    upid=${upids[$id]//_/ };  upid=${upid//!/\\\\!}  # escape '!'

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

x1=$(( 504 ))
y1=$(( ycoord-y0 ))

for id in $(seq 0 1); do

    cid=$((cid+1))

    # --- screen coordinates

    xcoord=$(( x0 + x1 ))
    ycoord=$(( y0 + y1 + 448*id ))

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

v_per_page=$(( ((ydisp/210-1)*5) /16 *16))

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

    if [[ $((id%$v_per_page)) == $((v_per_page-1)) ]]; then
        x0=$((x0+xdisp))
        id0=$((id0+$v_per_page))
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

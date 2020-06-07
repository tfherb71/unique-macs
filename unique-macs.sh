#!/bin/bash

declare -a allmacs=$(cat `find /sys/devices/pci0000\:00 -name address -print`)

start=$(printf ${allmacs[0]} | sed s/"\(.\{16\}\).*"/"\10"/ | cut -d ":" -f6)
startd=`printf %3d 0x${start}`

n=0
mcount=0
export mmacs=(255 255)
findman-macs() {
    for i in `seq  $startd 255` ; do
        ih=`printf %2x ${i}`
        for ad in ${allmacs[@]} ; do
            lb=`echo ${ad} | cut -d ":" -f6`
            if [ $lb = $ih ] ; then
                mcount=$[$mcount+1]
            else
                continue
            fi
        done
        if [[ $mcount == 0 ]] ; then
           mmacs[n]=$ih
           n=$[$n+1]
           if [[ $n == 2 ]] ; then
                return
           fi
        fi
        mcount=0
    done
}
findman-macs
echo "mmacs are ${mmacs[@]}"

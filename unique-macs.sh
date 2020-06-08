#!/bin/bash

# Copyright (c) Entry Point llc and/or its affiliates.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The script finds all assigned macs on board.
# It then selects first two unassigned macs that follow numerically
# highest existing assigned mac and prints last octet of two new macs.
# It tries to keep the two new macs in the same block of 16 macs as the
# existing interfaces. 
#
# Works best on Aaeon x86_64 board.
# Execute script on target system.
# This script assumes that Linux is running on target system.
#
# Limitation: This script may not work if all macs are in sequence and
# the last octet of the highest mac is 'ff'.

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
echo "Last octet of two new macs are ${mmacs[@]}"

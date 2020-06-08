# Unique-macs

## Unique-macs finds all assigned macs on a target system.

It then selects first two unassigned mac addresses  that follow the
highest existing assigned mac numerically in  prints last octet.
It tries to keep the two new mac addresses in the same block of the  of 16
mac addresses containing the
existing interfaces. It prints the last octet in hex of the new mac addresses.

Tested only on an Aaeon x86_64 board as it is somewhat specific to that
Hardware.

## Instructions

Execute script on target system.
```
./unique-macs
```
## Sample output
```
[root@host ~]# ./unique-macs.sh 
Last octet of two new macs are 56 57
```

## Limitations

- This script assumes that Linux is running on target system.
- This script may not work if all macs are in sequence and
the last octet of the highest mac is 'ff'.

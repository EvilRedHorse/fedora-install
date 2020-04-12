#! /usr/bin/env bash

# overclock Cerebus 1050 Ti 

set GPU_FORCE_64BIT_PTR=0
set GPU_MAX_HEAP_SIZE=100
set GPU_USE_SYNC_OBJECTS=1
set GPU_MAX_ALLOC_PERCENT=100
set GPU_SINGLE_ALLOC_PERCENT=100

nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[3]=512

nvidia-settings -a [gpu:0]/GPUGraphicsClockOffset[3]=32

# start ethminer
# ethminer-0.19.0-alpha.0-cuda-9-linux-x86_64
PROGRAM="/home/$USER/bin/ethminer -U --response-timeout 60 --failover-timeout 60 --work-timeout 180 -P stratum1+tcp://0x80ba682f1b66b59db106e2817dead5c79b18f71a@us1.ethermine.org:14444 -P stratum1+tcp://0x80ba682f1b66b59db106e2817dead5c79b18f71a@us1.ethermine.org:4444"
while true
do
    $PROGRAM
    sleep 10
done


#!/bin/bash

# Launch Windows 11 VM in fullscreen with working mouse/input

VM_NAME="win11"
QCOW2_PATH="/home/daniel/.vms/win11/win11.qcow2"
NVRAM_PATH="/home/daniel/.vms/win11/win11_VARS.fd"
OVMF_CODE="/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd"
ISO_PATH="/home/daniel/Downloads/Win11_24H2_English_x64.iso" # optional
SANDISK_VID="0x0781"
SANDISK_PID="0x5581"


exec qemu-system-x86_64 \
  -name "$VM_NAME" \
  -enable-kvm \
  -machine q35,accel=kvm,kernel-irqchip=split \
  -cpu host,kvm=on,topoext \
  -smp 6,sockets=1,cores=6,threads=1 \
  -m 8192 \
  -device intel-iommu,intremap=on,caching-mode=on \
  -rtc base=utc \
  -global kvm-pit.lost_tick_policy=delay \
  -boot order=c \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
  -drive if=pflash,format=raw,file="$NVRAM_PATH" \
  -drive file="$QCOW2_PATH",format=qcow2,if=none,id=hd \
  -device ide-hd,drive=hd,bus=ide.0 \
  -device ich9-intel-hda -device hda-duplex \
  -netdev user,id=net0 -device e1000e,netdev=net0 \
  -usb -device usb-tablet \
  -device qemu-xhci \
  -device nec-usb-xhci,id=xhci \
  -device usb-host,bus=xhci.0,vendorid=0x0781,productid=0x5581 \
  -device qxl-vga,vgamem_mb=64 \
  -display gtk,gl=on,show-menubar=off \
  -cdrom "$ISO_PATH"

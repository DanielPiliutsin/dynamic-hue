VM_DISK="/home/daniel/.vms/Kali/kali-linux-2025.1c-qemu-amd64.qcow2"

qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -m 4096 \
  -drive file="$VM_DISK",if=virtio \
  -display gtk,gl=on,show-menubar=off \
  -device virtio-net,netdev=n0 \
  -netdev user,id=n0 \
  -device virtio-tablet \
  -device virtio-keyboard \
  -device ich9-intel-hda \
  -device hda-output \
  -rtc base=utc \
  -boot c 
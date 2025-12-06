{
  writeShellScriptBin,
  ...
}:

writeShellScriptBin "vms" ''
  set -e

  VIRSH_CMD='virsh --connect qemu:///system'
  VM_NAME='debian13-x86_64-base'

  VM_STATE=$($VIRSH_CMD domstate "$VM_NAME")
  if [ "$VM_STATE" = "shut off" ]; then
  	echo "VM '$VM_NAME' is already shut down."
  	exit 0
  fi

  # Attempt graceful shutdown
  echo "Shutting down VM '$VM_NAME'..."
  $VIRSH_CMD shutdown "$VM_NAME"

  # Wait until the VM is fully off
  while [ "$($VIRSH_CMD domstate "$VM_NAME")" != "shut off" ]; do
  	echo "Waiting for VM to shut down..."
  	sleep 1
  done

  echo "VM '$VM_NAME' is now shut down."
''

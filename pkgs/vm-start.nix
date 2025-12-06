{
  writeShellScriptBin,
  ...
}:

writeShellScriptBin "vm" ''
  set -e

  VIRSH_CMD='virsh --connect qemu:///system'
  VM_NAME='debian13-x86_64-base'

  # SSH details
  SSH_USER="tobor"
  SSH_HOST="ctf-vm"

  VM_STATE=$($VIRSH_CMD domstate "$VM_NAME")

  if [ "$VM_STATE" != "running" ]; then
      echo "VM is not running. Starting..."
      $VIRSH_CMD start "$VM_NAME"

      echo "Waiting for VM ip..."
      while true; do
          SSH_HOST=$($VIRSH_CMD domifaddr --domain "$VM_NAME" | awk '/ipv4/ {print $4}' | cut -d/ -f1)
          if [ -n "$SSH_HOST" ]; then
              echo "VM IP found: $SSH_HOST"
              break
          fi
          sleep 1
      done

      echo "Waiting for VM network to boot..."
      # Wait for host to respond to ping
      until ping -c1 -W1 "$SSH_HOST" &>/dev/null; do
          echo "Waiting for host $SSH_HOST..."
          sleep 2
      done

      echo "Network is up. Waiting for SSH..."
      until nc -z "$SSH_HOST" 22; do
          echo "Waiting for SSH port..."
          sleep 2
      done

      sleep 1

      echo "VM is up!"
  else
      echo "VM is already running."
      SSH_HOST=$($VIRSH_CMD domifaddr --domain "$VM_NAME" | awk '/ipv4/ {print $4}' | cut -d/ -f1)
  fi

  echo "Connecting via ssh to tobor@$SSH_HOST"
  ssh "$SSH_USER@$SSH_HOST"
''

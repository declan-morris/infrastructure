export BW_SESSION=$(bw unlock --raw)

bw sync

# proxmox
export PM_API_URL="https://192.168.86.240:8006/api2/json"
export PM_USER="root@pam"
export PM_PASS=$(bw get password proxmox-asimov-root-pass --session $BW_SESSION)

# terraform state user
export AWS_ACCESS_KEY_ID=$(bw get password aws-terraform-keyid --session $BW_SESSION)
export AWS_SECRET_ACCESS_KEY=$(bw get password aws-terraform-accesskey --session $BW_SESSION)

#kill the bw session?
bw lock --quiet
export BW_SESSION=""
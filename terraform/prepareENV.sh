export BW_SESSION=$(bw unlock --raw)

bw sync

# proxmox
export PM_API_URL="https://192.168.86.240:8006/api2/json"
export PM_USER="root@pam"
export PM_PASS=$(bw get password proxmox-asimov-root-pass --session $BW_SESSION)

# aws terraform state user
export AWS_ACCESS_KEY_ID=$(bw get password aws-terraform-keyid --session $BW_SESSION)
export AWS_SECRET_ACCESS_KEY=$(bw get password aws-terraform-accesskey --session $BW_SESSION)

# azure service principal - username of terraform
export ARM_CLIENT_ID=$(bw get password azure-terraform-clientid --session $BW_SESSION)
export ARM_CLIENT_SECRET=$(bw get password azure-terraform-clientSecret --session $BW_SESSION)
export ARM_SUBSCRIPTION_ID=$(bw get password azure-terraform-subscriptionid --session $BW_SESSION)
export ARM_TENANT_ID=$(bw get password azure-terraform-tenantid --session $BW_SESSION)

# cloudflare
export CLOUDFLARE_API_TOKEN=$(bw get password cloudflare-terraform-apitoken --session $BW_SESSION)
export TF_VAR_CLOUDFLARE_ACCOUNT_ID=$(bw get password cloudflare-terraform-account-id --session $BW_SESSION)
export TF_VAR_CLOUDFLARE_EMAIL_DMARC_ALERT=$(bw get password cloudflare-terraform-email-dmarc-alert --session $BW_SESSION)

#kill the bw session?
bw lock --quiet
export BW_SESSION=""
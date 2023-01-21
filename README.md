# infrastructure

Repo for infrastructure

# Getting started

**Run `git-init.sh` to save you from yourself!**


Bitwarden is used to store secrets and vault decryption keys. Install bitwarden cli by running the following commands

Download zip
`wget https://vault.bitwarden.com/download/\?app\=cli\&platform\=linux -O bw.zip`

Unzip
`unzip bw.zip`

Install bitwarden
`sudo install bw /usr/local/bin`

Login
`bw login`

## Ansible

### Install ansible and current requirements
Install pip3
`sudo apt-get -y install python3-pip`

Install Ansible
`sudo python -m pip install ansible`

Install requirements
`ansible-galaxy install -r requirements.yml`


## Terraform

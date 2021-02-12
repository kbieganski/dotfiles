#!/usr/bin/env bash
set -euo pipefail

ansible-galaxy install -r ansible/requirements.yml
ansible-playbook -K ansible/local.yml

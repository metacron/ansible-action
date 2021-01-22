# Ansible Action

This repository is just an container image builder using [this Dockerfile](Dockerfile). The image is created from a CentOS 8 pure base image (`centos:8`) and published as [metacron/ansible-action](https://github.com/orgs/metacron/packages/container/package/ansible-action) GitHub Package by automated workflows (GitHub Actions). You can use it as a secure way to run Ansible in Docker and as a step for GitHub Actions workflow:

```yml
name: Ansible (Operations Automation)

on:
  push:
    branches:
      - main
    paths:
      - playbooks/**

jobs:

  apply:
    name: Some complex automation job
    runs-on: ubuntu-20.04

    steps:

      # Optional, load envwarden secrets
      - name: Load secrets with envwarden (Bitwarden as sensitive-data vault)
        uses: docker://ghcr.io/metacron/envwarden:unstable
        id: vars
        timeout-minutes: 30
        env:
          BW_CLIENTID: ${{ secrets.BW_CLIENTID }}
          BW_CLIENTSECRET: ${{ secrets.BW_CLIENTSECRET }}
          BW_PASSWORD: ${{ secrets.BW_PASSWORD }}

          BW_ORGANIZATIONID: ${{ secrets.BW_ORGANIZATIONID }}
          BW_COLLECTIONID: ${{ secrets.BW_PRODUCTION_COLLECTIONID }}
      
      # Checkout the repository
      - name: Checkout
        uses: actions/checkout@v2

      - name: Run ansible-playbook
        uses: docker://ghcr.io/metacron/ansible-action:unstable
        timeout-minutes: 30
        env:
          AWS_ACCESS_KEY_ID: ${{ steps.vars.outputs.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ steps.vars.outputs.AWS_SECRET_ACCESS_KEY }}

          GOOGLE_APPLICATION_CREDENTIALS: ${{ github.workspace }}/gcp_credentials.json
          
          SOURCE_REF: ${{ github.ref }}
        with:
          args: annsible-playbook -i github_runner -u root playbooks/my_playbook.yml

```

Assuming you have the `hosts.yml` file with something like:

```yml
all:
  hosts:
    github_runner:
      ansible_connection: local
```

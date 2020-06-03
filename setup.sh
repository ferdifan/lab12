#!/bin/env bash
export LABDIR="${HOME}/my_az_lab/"
export REMOTEHOST="http://localhost:8080/lab12/"
export REMOTEHOST=" -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/cyberbootcamp/lab12/master/terraform/"

mkdir -p ${LABDIR}/{.config,bin,RedTeam}

[[ -e ${LABDIR}/site.yml ]] && rm ${LABDIR}/site.yml

curl -o ${LABDIR}/site.yml https://raw.githubusercontent.com/cyberbootcamp/lab12/master/site.yml?_=$(date +%s)

which ansible || sudo apt-get install -y ansible

(cd ${LABDIR} && /usr/bin/ansible-playbook --connection=local --inventory 127.0.0.1 -K ./site.yml)


#!/bin/env bash
mkdir $PWD/roles_ext
ansible-galaxy install -r requirements.yml -p ./roles_ext
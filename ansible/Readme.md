# Ansible setup for devtools server

    # install ansible roles
    $ ansible-galaxy install -r requirements.yml -p ./roles/
    
    # run install playbook
    $ cd /path/to/cpswt-devtools/ansible/
    $ ansible-playbook install-devtools-playbook.yml -i inventory


1. Follow instructions on how to setup the Archiva instance on the server (see ../Readme.md)

2. To develop `c2wt-java` you need to do the following extra steps:
  
  * `cp settings.xml ~/.m2/`
  * add your archiva server's url to your hosts file: `129.59.107.43 cpswtng_archiva`

---

## Extend ansible setup

1. Write/find custom ansible role to install a new software
2. Add it to the requirements.yml (see ansible-galaxy docs)
3. Add extra task to playbook (install-devtools-playbook.yml)
4. Run the steps above (ansible setup for devtools server)
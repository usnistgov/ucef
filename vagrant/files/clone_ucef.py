# -*- coding: utf-8 -*-
# clone_ucef.py <output directory>
# a simple python script to clone the UCEF repositories
# written in python to better handle JSON configurations

import json
import os
import subprocess
import sys

with open("clone_ucef.json") as json_data:
    config = json.load(json_data)
    
    for repo in config['repositories']:
        repo_path = os.path.join(sys.argv[1], repo['directory'])
        if not os.path.exists(repo_path):
            os.makedirs(repo_path)
        subprocess.run(["git", "clone", "--branch", repo['branch'], repo['url'], repo_path])

echo "Pre.sh script"

python27_func(){
#    sudo add-apt-repository ppa:fkrull/deadsnakes -y
#    sudo apt-get update -y
    sudo apt-get install python2.7 -y
    sudo apt-get install python-pip -y
    sudo apt-get install python-lxml -y
}
git_func(){
    sudo apt-get install git -y
    # git config --global core.autocrlf true
    git config core.eol lf
    sudo apt-get install gitk -y
}

gitpython_func(){

	sudo pip install gitpython
}

python27_func
git_func
gitpython_func
# echo $PWD  ==> /home/vagrant

echo "Cloning the Repositories"
python /vagrant/shell_build_scripts/git_dev_fetch.py
# move files from build subfolder to here for execution
cd /home/vagrant/cpswt/cpswt-devtools/
sudo mv build/* .
sudo rm -rf build
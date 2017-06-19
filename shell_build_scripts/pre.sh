echo "Pre.sh script"

python27_func(){
    sudo add-apt-repository ppa:fkrull/deadsnakes -y
    sudo apt-get update -y
    sudo apt-get install python2.7 -y
    sudo apt-get install python-pip -y
}
git_func(){
    sudo apt-get install git -y
#	git config --global core.autocrlf true
	git config core.eol lf
    sudo apt-get gitk -y
}

gitpython_func(){

	sudo pip install gitpython
}

python27_func
git_func
gitpython_func
# echo $PWD  ==> /home/vagrant

echo "Cloning the Developer Repositories"
python /vagrant/shell_build_scripts/git_dev_fetch.py


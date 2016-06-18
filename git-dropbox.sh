#!/bin/bash 
dir=$(pwd)

if [ $# -lt 1 ]
then
    echo "git-dropbox Help Information"
    echo -e "FORMAT:"
    echo -e "\t$ git-dropbox [INSTRUCTION] "
    echo "INSTRUCTION:"
    echo -e "\tcreate [NAME]\n\t\t-- Create a corresponding repo in ~/Dropbox/git/ directory, NAME is optional"
    echo -e "\tpush \n\t\t-- Push to your dropbox repo (current branch)"
    echo -e "\tpull \n\t\t-- Pull from your dropbox repo (current branch)"
    echo -e "\tlist \n\t\t-- List your repositories in ~/Dropbox/git/"
    echo -e "\n"
fi

if
    git branch 2>&1 | grep "fatal:"
then # git fatal error
    echo "git error!"

else # .git is found and fine

branchName=$(git branch | grep \* | awk '{print $2}')
if [ "$1" = "create" ] 
then
    folderName=${dir##*/}
    if [ $# -gt 1 ] 
    then
        folderName=$2
    fi
    echo "folder name is ${folderName}"
    (cd ~/Dropbox; mkdir git; cd git; git init --bare ${folderName}.git)
    echo "Git Repo ~/Dropbox/git/${folderName}.git created!"
    git remote remove dropbox
    git remote add dropbox ~/Dropbox/git/${folderName}.git
    echo "Git remote added!"
    git push dropbox ${branchName}
    echo "Branch '${branchName}' pushed!"
fi

if [ "$1" = "push" ]
then
    git push dropbox ${branchName}
fi

if [ "$1" = "pull" ]
then
    git pull dropbox ${branchName}
fi

if [ "$1" = "list" ]
then
    ls ~/Dropbox/git
fi

fi

#!/bin/bash 

dir=$(pwd)

if test -f ~/.dropbox/info.json 
then
    echo "Dropbox found!"
else
    echo "Error: Dropbox not found!"
    exit 0
fi

read line < ~/.dropbox/info.json 
DropboxPath=${line#*\"path\":[ ]*\"}
DropboxPath=${DropboxPath%%\"*}
DropboxPath=${DropboxPath%/}/
echo "Dropbox directory found: $DropboxPath"

exit 0

printHelp()
{
    echo "git-dropbox Help Information"
    echo -e "FORMAT:"
    echo -e "\t$ git-dropbox [INSTRUCTION]\n"
    echo "INSTRUCTION:"
    echo -e "\tcreate [NAME]\n\t\t-- Create a corresponding repo in git/ directory under your Dropbox directory,\n\t\t    NAME is optional"
    echo -e "\tpush \n\t\t-- Push to your dropbox repo (current branch)"
    echo -e "\tpull \n\t\t-- Pull from your dropbox repo (current branch)"
    echo -e "\tlist \n\t\t-- List your repositories in git/ directory under your Dropbox directory"
    echo ""
}

if
    git branch 2>&1 | grep "fatal:"
then # git fatal error
    echo "git error!"

else # .git is found and fine

branchName=$(git branch | grep \* | awk '{print $2}')
case "$1" in 
    "create")
        folderName=${dir##*/}
        if [ $# -gt 1 ] 
        then
            folderName=$2
        fi
        echo "folder name is ${folderName}"
        (cd $DropboxPath; mkdir git; cd git; git init --bare ${folderName}.git)
        echo "Git Repo ${DropboxPath}git/${folderName}.git created!"
        git remote remove dropbox
        git remote add dropbox ${DropboxPath}git/${folderName}.git
        echo "Git remote added!"
        git push dropbox ${branchName}
        echo "Branch '${branchName}' pushed!"
        ;;

    "push")
        git push dropbox ${branchName}
        ;;

    "pull")
        git pull dropbox ${branchName}
        ;;

    "list")
        ls ${DropboxPath}git
        ;;

    *)
        printHelp 
        ;;
esac

fi

#!/bin/bash 

dir=$(pwd)

if ! test -f ~/.dropbox/info.json 
then
    echo "Error: Dropbox not found!"
    exit 0
fi

read line < ~/.dropbox/info.json 
DropboxPath=${line#*\"path\":[ ]*\"}
DropboxPath=${DropboxPath%%\"*}
DropboxPath=${DropboxPath%/}/
echo -e "Dropbox directory found: $DropboxPath\n"

printHelp()
{
cat << EOF
Below is git-dropbox Help Information.

FORMAT:
    $ git-dropbox [INSTRUCTION]

INSTRUCTION:
    create [NAME]
        -- Create a corresponding repo in git/ directory under 
           your Dropbox directory (${DropboxPath}), i.e.
               '${DropboxPath}git/'.
           NAME is optional.
    push 
        -- Push to your dropbox repo (current branch).
    pull 
        -- Pull from your dropbox repo (current branch).
    list 
        -- List your repositories in '${DropboxPath}git/'.

EOF
}

getBranchName()
{
if
    git branch 2>&1 | grep "fatal:"
then # git fatal error
    echo "git error!"
    exit
else # .git is found and fine
    branchName=$(git branch | grep \* | awk '{print $2}')
fi
}

case "$1" in 
    "create")
        folderName=${dir##*/}
        if [ $# -gt 1 ] 
        then
            folderName=$2
        fi
        getBranchName
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
        getBranchName
        git push dropbox ${branchName}
        ;;

    "pull")
        getBranchName
        git pull dropbox ${branchName}
        ;;

    "list")
        ls ${DropboxPath}git
        ;;

    *)
        printHelp 
        ;;
esac


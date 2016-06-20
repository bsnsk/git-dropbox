# git-dropbox

A bash script to backup your git repositories in your Dropbox folder. 

**Not necessary** to have your Dropbox folder at `~/Dropbox/`; the folder can be detected as ${DropboxPath}.

## Install
This will install `git-dropbox` into your directory `/usr/local/bin/`.

```bash
./install.sh 
```

Make sure you have `git` installed.

## Usage

Run `git-dropbox` to get the help information.

```bash
$ git-dropbox
Dropbox directory found: ${DropboxPath}/

Below is git-dropbox Help Information.

FORMAT:
	$ git-dropbox [INSTRUCTION]

INSTRUCTION:
	create [NAME]
		-- Create a corresponding repo in ${DropboxPath}/git/ directory, 
           NAME is optional
	push 
		-- Push to your dropbox repo (current branch)
	pull 
		-- Pull from your dropbox repo (current branch)
	list 
		-- List your repositories in ${DropboxPath}/git/
```

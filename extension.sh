#!/bin/bash

if [ $# -ne 1 ]
then
	echo "helper script to create template vsts plugin"
        echo "usage : " $0 " <your extension name>"
        exit 1
fi

case "$1" in
        --help)
            echo "help"
            ;;
         
        *)
            echo run
            exit 1
 
esac


#mkdir $1
#cd $1

# intialize a local nodeJS prohect
#npm init -y

#install VSTS extensions
#npm install vss-web-extension-sdk --save

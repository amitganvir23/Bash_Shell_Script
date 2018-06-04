#!/bin/bash
##MS(Micro Service)
d_path=$(pwd)
list=no-ui-list.txt

## Execute to clone or pull the latest data for repo before push any changes.
./clone-all.sh

### Specify list of repo or revert your MS from the list
for a in $(cat $list|awk '{print $1}'|grep -v motobohan);
do
 cd ${d_path}
 repo=$(grep $a $list |awk '{print $2}')
 cd ${d_path}/$a
 if [ -d $repo ];then
   cd $repo
   echo "============================================================================== [ $repo ]"
   pwd
   #git pull origin master
   git branch
   git status
   git add .
   git commit -am "Updating Dockerfile and startup.sh, also removing scriptsfolder"
   git push origin master
 else
   echo "This Repository dose not exsist-----------: [$repo]"
 fi

done


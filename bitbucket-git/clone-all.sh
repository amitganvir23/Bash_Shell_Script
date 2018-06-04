#!/bin/bash

## The current dir path
d_path=$(pwd)

###---- Repo should be in below format "MS_Name  RepoName"
##[root@server ~]# cat repo-list.txt
##logui alp-log-ui
##acms alp-test-kernel

## MS (Micro Service)
## Pulling this repo for get MS list
repo_list_dir=alp-jenkins-seed-jobs-devops
rm -rvf $repo_list_dir
git clone ssh://git@github.com/alpin/alp-jenkins-seed-jobs-devops.git
find $repo_list_dir -name repo-list.txt -type f -exec cp -fv {} . \;

## Making UI MS list
cat repo-list.txt|grep '\-ui' > ui-list.txt

## Making Non-UI MS list
cat repo-list.txt|grep -v '\-ui' > no-ui-list.txt
list=no-ui-list.txt

###creating Micro service dir
for a in $(cat $list|awk '{print $1}');
do
###$1=tot to make a directory for MS name
#rm -rvf $a
 if [ -d $a ];then
   echo Directory Exsist: $a
 else
   mkdir -v $a
 fi
done

## Clone all the repo from the list Else It will Pull the changes if repo exsist.
for i in $(cat $list|awk '{print $1}');
do

 cd $d_path
 repo=$(grep -w $i $list |awk '{print $2}')
 echo "======================================================================================================== [ $i = $repo ]"
 cd $i
 pwd
 git clone ssh://git@github.com/alp/${repo}.git
 if [ "$?" != "0" ];then
   cd ${repo}
   git branch
   git pull origin master
 fi

done

#!/bin/bash

#First part(clone the git repositories and save them to assignments directory)
tar -xf archive.tar.gz
if [ ! -d "assignments" ];then 
	mkdir assignments
fi
tar tzf archive.tar.gz | while IFS= read -r f ; do
	if [[ "${f##*.}" == "txt" ]];then
		while IFS= read -r repo; do
			if [[ ${repo:0:1} != "#" && "${repo##*.}" == "git" && "${repo:0:5}" == "https" ]];then
				cd assignments
				git clone "$repo" --quiet
				if [[ "$?" != "0" ]]; then
        			echo "$repo : Cloning FAILED"
        		else
        			echo "$repo : Cloning OK"
        		fi
        		cd - > /dev/null
        		break
			fi
		done < "$f"
	fi
done

#second part(count number of folders, text and other files for each repository)
cd assignments
count_total_files=0
count_folders=0
count_text=0
count_other_files=0
for dir in */
do
	cd "$dir" 

	count_total_files=$(ls -a | wc -l)
	((count_total_files = count_total_files - 2))

	count_folders=$(find -maxdepth 1 -type d | wc -l) #number of folders in current repo
	((count_folders = count_folders - 1))

	count_text=$(find -maxdepth 1 -type f | wc -l) #number of text in current repo
	((count_other_files=count_total_files-count_folders-count_text))

	echo "$dir:"
	echo "Number of directories: $count_folders"
	echo "Number of txt files: $count_text"
	echo "Number of other files: $count_other_files"

	cd - > /dev/null

done
